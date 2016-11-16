@echo off

rem NO SPACES ALLOWED IN SETTINGS!!!!

rem Set role (client, server, both)
set role=
rem Set path to shared folder below (if server):
set srvpath=
rem Set share name (if server):
set sname=
rem Set permissions to grant (if server - READ, CHANGE, or FULL)
set perm=
rem Set path to connect to (if client):
set clipath=
rem Set the drive letter to use (if client):
set mapto=
rem Set the username used to connect (created in server mode, used in client mode - set to the word null to skip)
set usr=
rem Set the password used to connect for client (or leave blank if using current account):
set pw=
rem Set whether or not to set Windows Firewall rules (for either - true/false):
set fwset=


rem ************* BEGIN SCRIPT ******************
if %role%==client goto cli
if %role%==server goto srv
if %role%==both goto srv
goto exit
:exit
cls
exit
:cli
net use %mapto% /delete
net use %mapto% %clipath% %pw% /user:%usr% /savecred
if %fwset%==true goto setfirewall
goto exit
:srv
net share %sname% /delete
if %usr%==null goto doshare
net user /delete %usr%
net user /add %usr%
net user %usr% %pw%
:doshare
net share %sname%=%srvpath% /GRANT:%usr%,%perm%
if %role%==both goto cli
if %fwset%=true goto setfirewall
goto exit
:setfirewall
netsh firewall add portopening TCP 139 "File sharing 1"
netsh firewall add portopening TCP 445 "File sharing 2"
netsh firewall add portopening UDP 137 "File sharing 3"
netsh firewall add portopening UDP 138 "File sharing 4"
goto exit