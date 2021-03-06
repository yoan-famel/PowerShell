$computerList = "C:\Storage\lists\ping-list.txt"

ForEach ($computer in (Get-Content $computerList)) {
	
	$testConnection = Test-Connection -Count 2 $computer -ErrorAction 'silentlycontinue'
	
	If ($testConnection -ne $null) {
		
		Invoke-Command -ComputerName (Get-Content $computerList) -Scriptblock {
			$IPv4 = $env:HostIP = (
				Get-NetIPConfiguration |
				Where-Object {
					$_.IPv4DefaultGateway -ne $null -and
					$_.NetAdapter.Status -ne "Disconnected"
				}
			).IPv4Address.IPAddress
		}
		
		Write-Host "$computer ONLINE - $IPv4"

	} Else {
		
		Write-Host "$computer OFFLINE"	
	} 
}
