Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DA13D94F9
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhG1SHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:07:42 -0400
Received: from tulum.helixd.com ([162.252.81.98]:48909 "EHLO tulum.helixd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhG1SHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 14:07:41 -0400
Received: from [IPv6:2600:8801:8800:12e8:2884:1d04:ad3c:7242] (unknown [IPv6:2600:8801:8800:12e8:2884:1d04:ad3c:7242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id C7DED1FD43;
        Wed, 28 Jul 2021 11:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627495659;
        bh=Pv81ObY5wvD9qYpMtiXGr02Rb/e7/n9Xrwrdn4tphzk=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=hqNgSN471aXwC8Tu4Hmta0+QywAxV5tpj47gRURuerPBv26+GUthsXNwUA8Skm6w7
         A0mH2jd3Xq4LOYMSvp2zYumZt/YVpR6q2XuTSzFGu3IcR+gaQoXy0wcCeeaPiek1HU
         VIfoQTjmmf41mH9whDrQQZhiEs4hS3F15uh+DGGI=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
From:   Dario Alcocer <dalcocer@helixd.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
 <YPrHJe+zJGJ7oezW@lunn.ch> <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
 <YPsJnLCKVzEUV5cb@lunn.ch> <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com> <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
Message-ID: <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com>
Date:   Wed, 28 Jul 2021 11:07:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears the port link-state issue is caused by the mv88e6xxx switch 
driver. The function mv88e6xxx_mac_config identifies the PHY as internal 
and skips the call to mv88e6xxx_port_setup_mac.

It does not make sense to me why internal PHY configuration should be 
skipped.

During boot, the 5.4.114 kernel successfully probes both switch chips, 
and the SERDES link appears to be brought up successfully:

[    2.782024] libphy: Fixed MDIO Bus: probed
[    2.800458] socfpga-dwmac ff700000.ethernet: IRQ eth_wake_irq not found
[    2.807070] socfpga-dwmac ff700000.ethernet: IRQ eth_lpi not found
[    2.813367] socfpga-dwmac ff700000.ethernet: PTP uses main clock
[    2.819537] socfpga-dwmac ff700000.ethernet: Version ID not available
[    2.825978] socfpga-dwmac ff700000.ethernet:         DWMAC1000
[    2.831186] socfpga-dwmac ff700000.ethernet: DMA HW capability 
register supported
[    2.838647] socfpga-dwmac ff700000.ethernet: RX Checksum Offload 
Engine supported
[    2.846108] socfpga-dwmac ff700000.ethernet: COE Type 2
[    2.851312] socfpga-dwmac ff700000.ethernet: TX Checksum insertion 
supported
[    2.858338] socfpga-dwmac ff700000.ethernet: Enhanced/Alternate 
descriptors
[    2.865279] socfpga-dwmac ff700000.ethernet: Extended descriptors not 
supported
[    2.872557] socfpga-dwmac ff700000.ethernet: Ring mode enabled
[    2.878382] socfpga-dwmac ff700000.ethernet: device MAC address 
fa:8b:6f:1f:4b:83
[    2.886010] libphy: stmmac: probed
[    2.890027] mv88e6085 stmmac-0:1a: switch 0x1760 detected: Marvell 
88E6176, revision 1
[    3.085696] libphy: mv88e6xxx SMI: probed
[    3.090416] mv88e6085 stmmac-0:1e: switch 0x1760 detected: Marvell 
88E6176, revision 1
[    3.281274] libphy: mv88e6xxx SMI: probed
[    3.626689] mv88e6085 stmmac-0:1e: switch 0x1760 detected: Marvell 
88E6176, revision 1
[    3.824809] libphy: mv88e6xxx SMI: probed
[    4.983937] mv88e6085 stmmac-0:1a lan1 (uninitialized): PHY 
[mv88e6xxx-0:00] driver [Marvell 88E1540]
[    4.999891] mv88e6085 stmmac-0:1a lan2 (uninitialized): PHY 
[mv88e6xxx-0:01] driver [Marvell 88E1540]
[    5.016620] mv88e6085 stmmac-0:1a lan3 (uninitialized): PHY 
[mv88e6xxx-0:02] driver [Marvell 88E1540]
[    5.032460] mv88e6085 stmmac-0:1a: configuring for fixed/1000base-x 
link mode
[    5.039594] mv88e6xxx_mac_config: switch=0, port=4, mode=0x1
[    5.045245] mv88e6xxx_mac_config: mode==MLO_AN_FIXED, force link up, 
speed=1000, duplex=1
[    5.053875] mv88e6xxx_mac_config: switch=0, port=4, mode=0x1
[    5.059522] mv88e6xxx_mac_config: mode==MLO_AN_FIXED, force link up, 
speed=1000, duplex=1
[    5.084915] mv88e6085 stmmac-0:1a: Link is Up - 1Gbps/Full - flow 
control off
[    6.253481] mv88e6085 stmmac-0:1e lan4 (uninitialized): PHY 
[mv88e6xxx-2:00] driver [Marvell 88E1540]
[    6.273714] mv88e6085 stmmac-0:1e dmz (uninitialized): PHY 
[mv88e6xxx-2:01] driver [Marvell 88E1540]
[    6.290369] mv88e6085 stmmac-0:1e: configuring for fixed/1000base-x 
link mode
[    6.297503] mv88e6xxx_mac_config: switch=1, port=4, mode=0x1
[    6.303152] mv88e6xxx_mac_config: mode==MLO_AN_FIXED, force link up, 
speed=1000, duplex=1
[    6.311774] mv88e6xxx_mac_config: switch=1, port=4, mode=0x1
[    6.317435] mv88e6xxx_mac_config: mode==MLO_AN_FIXED, force link up, 
speed=1000, duplex=1
[    6.340344] mv88e6085 stmmac-0:1e: Link is Up - 1Gbps/Full - flow 
control off
[    6.348972] debugfs: Directory 'switch0' with parent 'dsa' already 
present!
[    6.355938] DSA: failed to create debugfs interface for switch 0 (-14)
[    6.362692] DSA: tree 0 setup

After booting, I logged in and set up dynamic tracing for the relevant 
kernel routines:

dali login: root
Password:
root@dali:~# echo 'file drivers/net/phy/marvell.c +p' > 
/sys/kernel/debug/dynamic_debug/control
root@dali:~# echo 'file drivers/net/phy/phy_device.c +p' > 
/sys/kernel/debug/dynamic_debug/control
root@dali:~# echo 'file drivers/net/phy/phylink.c +p' > 
/sys/kernel/debug/dynamic_debug/control
root@dali:~# echo 'file drivers/net/phy/phy.c +p' > 
/sys/kernel/debug/dynamic_debug/control
root@dali:~# echo 'file net/dsa/port.c +p' > 
/sys/kernel/debug/dynamic_debug/control
root@dali:~# echo 'file net/dsa/slave.c +p' > 
/sys/kernel/debug/dynamic_debug/control
root@dali:~# echo 'file drivers/net/dsa/mv88e6xxx/chip.c +p' > 
/sys/kernel/debug/dynamic_debug/control
root@dali:~# echo 'func mv88e6xxx_read -p' > 
/sys/kernel/debug/dynamic_debug/control
root@dali:~# echo 'func mv88e6xxx_write -p' > 
/sys/kernel/debug/dynamic_debug/control

I then attempted to bring up the lan1 port and duplicated the 
LOWERLAYERDOWN issue. I inserted begin/end markers in the system log to 
locate the PHY traces:

root@dali:~# logger -t adhoc begin: bring up lan1 port
root@dali:~# ip addr add 192.0.2.1/24 dev lan1
root@dali:~# ip link set lan1 up
[   64.087971] mv88e6085 stmmac-0:1a lan1: configuring for phy/gmii link 
mode
[   64.094929] mv88e6xxx_mac_config: switch=0, port=0, mode=0x0
[   64.100563] mv88e6xxx_mac_config: skip MAC config for internal PHY
[   64.109285] 8021q: adding VLAN 0 to HW filter on device lan1
root@dali:~# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode 
DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group 
default qlen 10
     link/can
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP 
mode DEFAULT group default qlen 1000
     link/ether fa:8b:6f:1f:4b:83 brd ff:ff:ff:ff:ff:ff
4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group 
default qlen 1000
     link/sit 0.0.0.0 brd 0.0.0.0
5: lan1@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue 
state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
     link/ether fa:8b:6f:1f:4b:83 brd ff:ff:ff:ff:ff:ff
6: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode 
DEFAULT group default qlen 1000
     link/ether fa:8b:6f:1f:4b:83 brd ff:ff:ff:ff:ff:ff
7: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode 
DEFAULT group default qlen 1000
     link/ether fa:8b:6f:1f:4b:83 brd ff:ff:ff:ff:ff:ff
8: lan4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode 
DEFAULT group default qlen 1000
     link/ether fa:8b:6f:1f:4b:83 brd ff:ff:ff:ff:ff:ff
9: dmz@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode 
DEFAULT group default qlen 1000
     link/ether fa:8b:6f:1f:4b:83 brd ff:ff:ff:ff:ff:ff
root@dali:~# logger -t adhoc end: bring up lan1 port

The extracted PHY traces from the system log are below:

root@dali:~# sed -ne '/adhoc: begin:/,/adhoc: end:/p' /var/log/messages
Nov  1 12:00:54 (none) user.notice adhoc: begin: bring up lan1 port
Nov  1 12:00:54 (none) user.info kernel: [   64.087971] mv88e6085 
stmmac-0:1a lan1: configuring for phy/gmii link mode
Nov  1 12:00:54 (none) user.debug kernel: [   64.094872] mv88e6085 
stmmac-0:1a lan1: phylink_resolve_flow: link config MLO_PAUSE_AN: set
Nov  1 12:00:54 (none) user.debug kernel: [   64.094882] mv88e6085 
stmmac-0:1a lan1: phylink_resolve_flow: setting pause=10
Nov  1 12:00:54 (none) user.debug kernel: [   64.094898] mv88e6085 
stmmac-0:1a lan1: phylink_mac_config: mode=phy/gmii/Unknown/Unknown 
adv=00,00000000,000022ef pause=10 link=0 an=1
Nov  1 12:00:54 (none) user.debug kernel: [   64.094912] 
dsa_port_phylink_mac_config: config type=0, mode=0, interface="gmii", 
speed=-1, duplex=255, pause=16, link=0 an_enabled=1 an_complete=0
Nov  1 12:00:54 (none) user.debug kernel: [   64.094918] 
dsa_port_phylink_mac_config: switch=0, port=0 "lan1"
Nov  1 12:00:54 (none) user.debug kernel: [   64.094923] 
dsa_port_phylink_mac_config: calling switch op phylink_mac_config
Nov  1 12:00:54 (none) user.info kernel: [   64.094929] 
mv88e6xxx_mac_config: switch=0, port=0, mode=0x0
Nov  1 12:00:54 (none) user.info kernel: [   64.100563] 
mv88e6xxx_mac_config: skip MAC config for internal PHY
Nov  1 12:00:54 (none) user.debug kernel: [   64.106754] 
phylink_run_resolve: phylink_disable_state==false, dispatch 
system_power_efficient_wq
Nov  1 12:00:54 (none) user.debug kernel: [   64.106803] mv88e6085 
stmmac-0:1a lan1: phylink_resolve: link_an_mode=phy
Nov  1 12:00:54 (none) user.debug kernel: [   64.106814] mv88e6085 
stmmac-0:1a lan1: phylink_resolve_flow: link config MLO_PAUSE_AN: set
Nov  1 12:00:54 (none) user.debug kernel: [   64.106823] mv88e6085 
stmmac-0:1a lan1: phylink_resolve_flow: setting pause=00
Nov  1 12:00:54 (none) user.debug kernel: [   64.106832] mv88e6085 
stmmac-0:1a lan1: phylink_resolve: have netdev, link_changed=0
Nov  1 12:00:54 (none) daemon.info avahi-daemon[529]: Joining mDNS 
multicast group on interface lan1.IPv4 with address 192.0.2.1.
Nov  1 12:00:54 (none) user.debug kernel: [   64.108923] libphy: 
genphy_resume: phy_clear_bits returns 0x0
Nov  1 12:00:54 (none) user.info kernel: [   64.109285] 8021q: adding 
VLAN 0 to HW filter on device lan1
Nov  1 12:00:54 (none) daemon.info avahi-daemon[529]: New relevant 
interface lan1.IPv4 for mDNS.
Nov  1 12:00:54 (none) daemon.info avahi-daemon[529]: Registering new 
address record for 192.0.2.1 on lan1.IPv4.
Nov  1 12:00:54 (none) user.debug kernel: [   64.119685] 
marvell_read_page: id=0x1410eb1(21040817), state=UP, flags=0x0, link=0, 
suspended=0, suspended_by_mdio_bus=0, autoneg=1, autoneg_complete=0
Nov  1 12:00:54 (none) user.debug kernel: [   64.121499] 
marvell_read_page: __phy_read(phydev, 22) returns 0x0
Nov  1 12:00:54 (none) user.debug kernel: [   64.121511] 
marvell_write_page: id=0x1410eb1(21040817), state=UP, flags=0x0, link=0, 
suspended=0, suspended_by_mdio_bus=0, autoneg=1, autoneg_complete=0
Nov  1 12:00:54 (none) user.debug kernel: [   64.126302] 
marvell_write_page: __phy_write(phydev, 22, 2) returns 0x0
Nov  1 12:00:54 (none) user.debug kernel: [   64.129909] 
marvell_write_page: id=0x1410eb1(21040817), state=UP, flags=0x0, link=0, 
suspended=0, suspended_by_mdio_bus=0, autoneg=1, autoneg_complete=0
Nov  1 12:00:54 (none) user.debug kernel: [   64.131711] 
marvell_write_page: __phy_write(phydev, 22, 0) returns 0x0
Nov  1 12:00:54 (none) user.debug kernel: [   64.158548] 
m88e1510_config_aneg: set copper page
Nov  1 12:00:54 (none) user.debug kernel: [   64.160371] 
marvell_read_status: read status from copper page
Nov  1 12:00:54 (none) user.debug kernel: [   64.171227] 
phylink_run_resolve: phylink_disable_state==false, dispatch 
system_power_efficient_wq
Nov  1 12:00:54 (none) user.debug kernel: [   64.171247] mv88e6085 
stmmac-0:1a lan1: phy link down gmii/1Gbps/Half
Nov  1 12:00:54 (none) user.debug kernel: [   64.171258] Marvell 88E1540 
mv88e6xxx-0:00: PHY state change UP -> NOLINK
Nov  1 12:00:54 (none) user.debug kernel: [   64.171271] mv88e6085 
stmmac-0:1a lan1: phylink_resolve: link_an_mode=phy
Nov  1 12:00:54 (none) user.debug kernel: [   64.171281] mv88e6085 
stmmac-0:1a lan1: phylink_resolve_flow: link config MLO_PAUSE_AN: set
Nov  1 12:00:54 (none) user.debug kernel: [   64.171290] mv88e6085 
stmmac-0:1a lan1: phylink_resolve_flow: setting pause=00
Nov  1 12:00:54 (none) user.debug kernel: [   64.171298] mv88e6085 
stmmac-0:1a lan1: phylink_resolve: have netdev, link_changed=0
Nov  1 12:00:55 (none) user.notice adhoc: end: bring up lan1 port
root@dali:~#
