param (
	[system.string]$ShortcutName     = "EAL-ATS Client",
	[system.string]$ShortcutUrl      = "C:\Program Files (x86)\WinToe.Cln\Ats.exe",
	[system.string]$IconURL          = "https://intune.twence.nl/icons/eal.ico",
	[system.string]$Desktop          = "C:\Users\Public\Desktop",
    [system.string]$IntuneProgramDir = "C:\ProgramData\Intune",
	[System.String]$TempIcon         = "$IntuneProgramDir\eal.ico",
	[bool]$ShortcutOnDesktop         = $True,
	[bool]$ShortcutInStartMenu       = $True
)

#Test if icon is currently present, if so delete it so we can update it
$IconPresent = Get-ChildItem -Path $Desktop | Where-Object {$_.Name -eq "$ShortcutName.lnk"}
If ($null -ne $IconPresent)
{
	Remove-Item $IconPresent.VersionInfo.FileName -Force -Confirm:$False
}

$WScriptShell = New-Object -ComObject WScript.Shell

If ((Test-Path -Path $IntuneProgramDir) -eq $False)
{
    New-Item -ItemType Directory $IntuneProgramDir -Force -Confirm:$False
}

#Start download of the icon in blob storage 
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($IconURL, $TempIcon)



if ($ShortcutOnDesktop)
{
	$Shortcut = $WScriptShell.CreateShortcut("$Desktop\$ShortcutName.lnk")
	$Shortcut.TargetPath = $ShortcutUrl
    $Shortcut.IconLocation = $TempIcon
	$Shortcut.Save()
}

if ($ShortCutInStartMenu)
{
	#$Shortcut = $WScriptShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk")
	$Shortcut = $WScriptShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk")
	$Shortcut.TargetPath = $ShortcutUrl
    $Shortcut.IconLocation = $TempIcon
	$Shortcut.Save()
}
