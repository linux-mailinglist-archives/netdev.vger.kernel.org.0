Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03E43E3228
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244755AbhHFXqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244616AbhHFXqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 19:46:37 -0400
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD75AC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 16:46:12 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:6d98:f916:e67:fd3] (unknown [IPv6:2600:8801:8800:12e8:6d98:f916:e67:fd3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id C4FFE2082F;
        Fri,  6 Aug 2021 16:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1628293570;
        bh=5LsLorwFn7UD6TsLjJExUOYd4oHKkpw0LOJfnUgzBFs=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=Bmu3CMs1AOwYoTSCr2gMYZBgiKds9hLy8sw7+9u5/qOdJ3Nybx1h4EoxuWqAgv+sw
         tv8F5dFHe4oea70wjAEe8Dv4U5WdwFAdwKt/h+HwMGIBH2SzyFsteazbCTDpbW1qur
         an05hjr3JoD0XKalQsIdI027X+2BLF1oE67ActEw=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
From:   Dario Alcocer <dalcocer@helixd.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <YPsJnLCKVzEUV5cb@lunn.ch>
 <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com> <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com> <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com> <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
 <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
 <de5758c6-4379-1b70-19ff-d6dd2b3ea269@helixd.com>
Message-ID: <4902bb0e-87ad-3fa4-f7af-bbe7b43ad68f@helixd.com>
Date:   Fri, 6 Aug 2021 16:46:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <de5758c6-4379-1b70-19ff-d6dd2b3ea269@helixd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

Using 5.13.8 resolves the LOWERLAYERDOWN issue I observed when bringing 
up a slave interface on 5.4.114. The interface comes up after a 
15-second delay, with the Marvell PHY driver reporting a downshift event:

root@dali:~# ip addr add 192.0.2.1/24 dev lan1
root@dali:~# ip link set lan1 up
[  264.992698] socfpga-dwmac ff700000.ethernet eth0: Register 
MEM_TYPE_PAGE_POOL RxQ-0
[  264.997303] socfpga-dwmac ff700000.ethernet eth0: No Safety Features 
support found
[  264.998167] socfpga-dwmac ff700000.ethernet eth0: IEEE 1588-2008 
Advanced Timestamp supported
[  264.999357] socfpga-dwmac ff700000.ethernet eth0: registered PTP clock
[  265.000804] socfpga-dwmac ff700000.ethernet eth0: configuring for 
fixed/gmii link mode
[  265.002542] socfpga-dwmac ff700000.ethernet eth0: Link is Up - 
1Gbps/Full - flow control rx/tx
[  265.007121] mv88e6085 stmmac-0:1a lan1: configuring for phy/gmii link 
mode
[  265.015320] 8021q: adding VLAN 0 to HW filter on device lan1
[  265.016921] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
root@dali:~# [  280.856989] Marvell 88E1540 mv88e6xxx-0:00: Downshift 
occurred from negotiated speed 1Gbps to actual speed 100Mbps, check cabling!
[  280.858797] mv88e6085 stmmac-0:1a lan1: Link is Up - 100Mbps/Full - 
flow control rx/tx
[  280.859713] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready

Unfortunately, the single-port DSA configuration showcase example (from 
Documentation/networking/dsa/configuration.rst) still does not pass ICMP 
via the lan1 port:

root@dali:~# ping 192.0.2.2
PING 192.0.2.2 (192.0.2.2): 56 data bytes
^C
--- 192.0.2.2 ping statistics ---
12 packets transmitted, 0 packets received, 100% packet loss
root@dali:~#

Running tcpdump indicates ARP packets are sent to eth0, but the lan1 
link peer does not reply:

root@dali:~# tcpdump -i eth0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
12:15:11.248264 MEDSA 1.1:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ea:38:64:39:ee:b2 (oui Unknown), length 548
12:15:13.805980 MEDSA 0.0:0: ARP, Request who-has 192.0.2.2 tell 
192.0.2.1, length 28
12:15:14.849210 MEDSA 0.0:0: ARP, Request who-has 192.0.2.2 tell 
192.0.2.1, length 28
12:15:15.889193 MEDSA 0.0:0: ARP, Request who-has 192.0.2.2 tell 
192.0.2.1, length 28
12:15:16.238290 MEDSA 1.1:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ea:38:64:39:ee:b2 (oui Unknown), length 548
12:15:17.806438 MEDSA 0.0:0: ARP, Request who-has 192.0.2.2 tell 
192.0.2.1, length 28
12:15:18.849208 MEDSA 0.0:0: ARP, Request who-has 192.0.2.2 tell 
192.0.2.1, length 28
12:15:19.889200 MEDSA 0.0:0: ARP, Request who-has 192.0.2.2 tell 
192.0.2.1, length 28
12:15:21.238306 MEDSA 1.1:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ea:38:64:39:ee:b2 (oui Unknown), length 548
12:15:21.806994 MEDSA 0.0:0: ARP, Request who-has 192.0.2.2 tell 
192.0.2.1, length 28
12:15:22.849200 MEDSA 0.0:0: ARP, Request who-has 192.0.2.2 tell 
192.0.2.1, length 28
12:15:23.889195 MEDSA 0.0:0: ARP, Request who-has 192.0.2.2 tell 
192.0.2.1, length 28
12:15:26.238330 MEDSA 1.1:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ea:38:64:39:ee:b2 (oui Unknown), length 548
12:15:31.238361 MEDSA 1.1:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ea:38:64:39:ee:b2 (oui Unknown), length 548
12:15:31.259217 IP6 fe80::801d:a3ff:fea2:b66b > ip6-allrouters: ICMP6, 
router solicitation, length 16
12:15:36.238375 MEDSA 1.1:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ea:38:64:39:ee:b2 (oui Unknown), length 548
12:15:50.405148 MEDSA 1.0:0: IP6 fe80::b8de:29ff:fed8:d469 > 
ip6-allrouters: ICMP6, router solicitation, length 16
12:15:52.234783 MEDSA 1.0:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ba:de:29:d8:d4:69 (oui Unknown), length 548
12:15:57.235155 MEDSA 1.0:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ba:de:29:d8:d4:69 (oui Unknown), length 548
12:16:01.969215 MEDSA 0.0:0: IP6 fe80::801d:a3ff:fea2:b66b > 
ip6-allrouters: ICMP6, router solicitation, length 16
12:16:02.234543 MEDSA 1.0:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ba:de:29:d8:d4:69 (oui Unknown), length 548
12:16:07.234883 MEDSA 1.0:0: IP 0.0.0.0.bootpc > 255.255.255.255.bootps: 
BOOTP/DHCP, Request from ba:de:29:d8:d4:69 (oui Unknown), length 548
^C
22 packets captured[  977.987343] device eth0 left promiscuous mode
2
22 packets received by filter
0 packets dropped by kernel
root@dali:~#

Running tcpdump on the link peer shows no Ethernet frames are being 
received.

Port registers for both switches:

root@dali:~# mv88e6xxx_dump --list
mdio_bus/stmmac-0:1a
mdio_bus/stmmac-0:1e
root@dali:~# mv88e6xxx_dump --ports --device mdio_bus/stmmac-0:1a
                            0    1    2    3    4    5    6
00 Port status            9d0f 100f 100f 100f 1e0f 0009 0d04
01 Physical control       0003 0003 0003 0003 003e 0003 0003
02 Jamming control        0000 0000 0000 ff00 0000 ff00 ff00
03 Switch ID              1761 1761 1761 1761 1761 1761 1761
04 Port control           043f 043f 043f 007c 053f 007c 007c
05 Port control 1         0000 0000 0000 0000 8000 0000 0000
06 Port base VLAN map     0010 0010 0010 0077 006f 005f 003f
07 Def VLAN ID & Prio     0000 0000 0000 0001 0000 0001 0001
08 Port control 2         0080 0080 0080 2080 0080 2080 2080
09 Egress rate control    0001 0001 0001 0001 0001 0001 0001
0a Egress rate control 2  0000 0000 0000 8000 0000 8000 8000
0b Port association vec   0000 0000 0000 0008 0010 0020 0040
0c Port ATU control       0000 0000 0000 0000 0000 0000 0000
0d Override               0000 0000 0000 0000 0000 0000 0000
0e Policy control         0000 0000 0000 0000 0000 0000 0000
0f Port ether type        9100 9100 9100 9100 9100 9100 9100
10 In discard low         0000 0000 0000 0000 0000 0000 0000
11 In discard high        0000 0000 0000 0000 0000 0000 0000
12 In filtered            0000 0000 0000 0000 0000 0000 0000
13 RX frame count         0105 0000 0000 0000 0000 0000 0000
14 Reserved               0000 0000 0000 0000 0000 0000 0000
15 Reserved               0000 0000 0000 0000 0000 0000 0000
16 LED control            0033 0033 0033 0033 0033 0033 0000
17 Reserved               0000 0000 0000 0000 0000 0000 0000
18 Tag remap low          3210 3210 3210 3210 3210 3210 3210
19 Tag remap high         7654 7654 7654 7654 7654 7654 7654
1a Reserved               0000 0000 0000 0000 0000 0000 0000
1b Queue counters         8000 8000 8000 8000 8000 8000 8000
1c Reserved               0000 0000 0000 0000 0000 0000 0000
1d Reserved               0000 0000 0000 0000 0000 0000 0000
1e Reserved               0000 0000 0000 0000 0000 0000 0000
1f Reserved               0000 0000 0000 0000 0000 0000 0000
root@dali:~# mv88e6xxx_dump --ports --device mdio_bus/stmmac-0:1e
                            0    1    2    3    4    5    6
00 Port status            1d0f 1d0f 100f 100f 1e0f 0009 0e03
01 Physical control       0003 0003 0003 0003 003e 0003 003e
02 Jamming control        0000 0000 ff00 ff00 0000 ff00 0000
03 Switch ID              1761 1761 1761 1761 1761 1761 1761
04 Port control           043f 043f 007c 007c 053f 007c 373f
05 Port control 1         0000 0000 0000 0000 8000 0000 0000
06 Port base VLAN map     0050 0050 007b 0077 006f 005f 003f
07 Def VLAN ID & Prio     0000 0000 0001 0001 0000 0001 0000
08 Port control 2         0080 0080 2080 2080 0080 2080 0080
09 Egress rate control    0001 0001 0001 0001 0001 0001 0001
0a Egress rate control 2  0000 0000 8000 8000 0000 8000 0000
0b Port association vec   0000 0000 0004 0008 0010 0020 0040
0c Port ATU control       0000 0000 0000 0000 0000 0000 0000
0d Override               0000 0000 0000 0000 0000 0000 0000
0e Policy control         0000 0000 0000 0000 0000 0000 0000
0f Port ether type        9100 9100 9100 9100 9100 9100 dada
10 In discard low         0000 0000 0000 0000 0000 0000 0000
11 In discard high        0000 0000 0000 0000 0000 0000 0000
12 In filtered            0000 0000 0000 0000 0000 0000 0000
13 RX frame count         010a 00d5 0000 0000 0000 0000 0073
14 Reserved               0000 0000 0000 0000 0000 0000 0000
15 Reserved               0000 0000 0000 0000 0000 0000 0000
16 LED control            0033 0033 0033 0033 0033 0033 0000
17 Reserved               0000 0000 0000 0000 0000 0000 0000
18 Tag remap low          3210 3210 3210 3210 3210 3210 3210
19 Tag remap high         7654 7654 7654 7654 7654 7654 7654
1a Reserved               0000 0000 0000 0000 0000 0000 0000
1b Queue counters         8000 8000 8000 8000 8000 8000 8000
1c Reserved               0000 0000 0000 0000 0000 0000 0000
1d Reserved               0000 0000 0000 0000 0000 0000 0000
1e Reserved               0000 0000 0000 0000 0000 0000 0000
1f Reserved               0000 0000 0000 0000 0000 0000 0000

Detailed info from switch 0, port 0, corresponding to lan1 port:

root@dali:~# mv88e6xxx_dump --port 0 --device mdio_bus/stmmac-0:1a
00 Port status                            0x9d0f
       Pause Enabled                        1
       My Pause                             0
       802.3 PHY Detected                   1
       Link Status                          Up
       Duplex                               Full
       Speed                                100 or 200 Mbps
       EEE Enabled                          0
       Transmitter Paused                   0
       Flow Control                         0
       Config Mode                          0xf
01 Physical control                       0x0003
       RGMII Receive Timing Control         Default
       RGMII Transmit Timing Control        Default
       200 BASE Mode                        100
       Flow Control's Forced value          0
       Force Flow Control                   0
       Link's Forced value                  Down
       Force Link                           0
       Duplex's Forced value                Half
       Force Duplex                         0
       Force Speed                          Not forced
02 Jamming control                        0x0000
03 Switch ID                              0x1761
04 Port control                           0x043f
       Source Address Filtering controls    Disabled
       Egress Mode                          Unmodified
       Ingress & Egress Header Mode         0
       IGMP and MLD Snooping                1
       Frame Mode                           Normal
       VLAN Tunnel                          0
       TagIfBoth                            0
       Initial Priority assignment          Tag & IP Priority
       Egress Flooding mode                 Allow unknown DA
       Port State                           Forwarding
05 Port control 1                         0x0000
       Message Port                         0
       Trunk Port                           0
       Trunk ID                             0
       FID[11:4]                            0x000
06 Port base VLAN map                     0x0010
       FID[3:0]                             0x000
       VLANTable                            4
07 Def VLAN ID & Prio                     0x0000
       Default Priority                     0x0
       Force to use Default VID             0
       Default VLAN Identifier              0
08 Port control 2                         0x0080
       Force good FCS in the frame          0
       Jumbo Mode                           1522
       802.1QMode                           Disabled
       Discard Tagged Frames                0
       Discard Untagged Frames              0
       Map using DA hits                    1
       ARP Mirror enable                    0
       Egress Monitor Source Port           0
       Ingress Monitor Source Port          0
       Use Default Queue Priority           0
       Default Queue Priority               0x0
09 Egress rate control                    0x0001
0a Egress rate control 2                  0x0000
0b Port association vec                   0x0000
0c Port ATU control                       0x0000
0d Override                               0x0000
0e Policy control                         0x0000
0f Port ether type                        0x9100
10 In discard low                         0x0000
11 In discard high                        0x0000
12 In filtered                            0x0000
13 RX frame count                         0x010d
14 Reserved                               0x0000
15 Reserved                               0x0000
16 LED control                            0x0033
17 Reserved                               0x0000
18 Tag remap low                          0x3210
19 Tag remap high                         0x7654
1a Reserved                               0x0000
1b Queue counters                         0x8000
1c Reserved                               0x0000
1d Reserved                               0x0000
1e Reserved                               0x0000
1f Reserved                               0x0000

Detailed info for switch 0, port 4 and switch 1, port 4, which are the 
DSA ports for both switches, using a SERDES link:

root@dali:~# mv88e6xxx_dump --port 4 --device mdio_bus/stmmac-0:1a
00 Port status                            0x1e0f
       Pause Enabled                        0
       My Pause                             0
       802.3 PHY Detected                   1
       Link Status                          Up
       Duplex                               Full
       Speed                                1000 Mbps
       EEE Enabled                          0
       Transmitter Paused                   0
       Flow Control                         0
       Config Mode                          0xf
01 Physical control                       0x003e
       RGMII Receive Timing Control         Default
       RGMII Transmit Timing Control        Default
       200 BASE Mode                        100
       Flow Control's Forced value          0
       Force Flow Control                   0
       Link's Forced value                  Up
       Force Link                           1
       Duplex's Forced value                Full
       Force Duplex                         1
       Force Speed                          1000 Mbps
02 Jamming control                        0x0000
03 Switch ID                              0x1761
04 Port control                           0x053f
       Source Address Filtering controls    Disabled
       Egress Mode                          Unmodified
       Ingress & Egress Header Mode         0
       IGMP and MLD Snooping                1
       Frame Mode                           DSA
       VLAN Tunnel                          0
       TagIfBoth                            0
       Initial Priority assignment          Tag & IP Priority
       Egress Flooding mode                 Allow unknown DA
       Port State                           Forwarding
05 Port control 1                         0x8000
       Message Port                         1
       Trunk Port                           0
       Trunk ID                             0
       FID[11:4]                            0x000
06 Port base VLAN map                     0x006f
       FID[3:0]                             0x000
       VLANTable                            0 1 2 3 5 6
07 Def VLAN ID & Prio                     0x0000
       Default Priority                     0x0
       Force to use Default VID             0
       Default VLAN Identifier              0
08 Port control 2                         0x0080
       Force good FCS in the frame          0
       Jumbo Mode                           1522
       802.1QMode                           Disabled
       Discard Tagged Frames                0
       Discard Untagged Frames              0
       Map using DA hits                    1
       ARP Mirror enable                    0
       Egress Monitor Source Port           0
       Ingress Monitor Source Port          0
       Use Default Queue Priority           0
       Default Queue Priority               0x0
09 Egress rate control                    0x0001
0a Egress rate control 2                  0x0000
0b Port association vec                   0x0010
0c Port ATU control                       0x0000
0d Override                               0x0000
0e Policy control                         0x0000
0f Port ether type                        0x9100
10 In discard low                         0x0000
11 In discard high                        0x0000
12 In filtered                            0x0000
13 RX frame count                         0x0000
14 Reserved                               0x0000
15 Reserved                               0x0000
16 LED control                            0x0033
17 Reserved                               0x0000
18 Tag remap low                          0x3210
19 Tag remap high                         0x7654
1a Reserved                               0x0000
1b Queue counters                         0x8000
1c Reserved                               0x0000
1d Reserved                               0x0000
1e Reserved                               0x0000
1f Reserved                               0x0000
root@dali:~# mv88e6xxx_dump --port 4 --device mdio_bus/stmmac-0:1e
00 Port status                            0x1e0f
       Pause Enabled                        0
       My Pause                             0
       802.3 PHY Detected                   1
       Link Status                          Up
       Duplex                               Full
       Speed                                1000 Mbps
       EEE Enabled                          0
       Transmitter Paused                   0
       Flow Control                         0
       Config Mode                          0xf
01 Physical control                       0x003e
       RGMII Receive Timing Control         Default
       RGMII Transmit Timing Control        Default
       200 BASE Mode                        100
       Flow Control's Forced value          0
       Force Flow Control                   0
       Link's Forced value                  Up
       Force Link                           1
       Duplex's Forced value                Full
       Force Duplex                         1
       Force Speed                          1000 Mbps
02 Jamming control                        0x0000
03 Switch ID                              0x1761
04 Port control                           0x053f
       Source Address Filtering controls    Disabled
       Egress Mode                          Unmodified
       Ingress & Egress Header Mode         0
       IGMP and MLD Snooping                1
       Frame Mode                           DSA
       VLAN Tunnel                          0
       TagIfBoth                            0
       Initial Priority assignment          Tag & IP Priority
       Egress Flooding mode                 Allow unknown DA
       Port State                           Forwarding
05 Port control 1                         0x8000
       Message Port                         1
       Trunk Port                           0
       Trunk ID                             0
       FID[11:4]                            0x000
06 Port base VLAN map                     0x006f
       FID[3:0]                             0x000
       VLANTable                            0 1 2 3 5 6
07 Def VLAN ID & Prio                     0x0000
       Default Priority                     0x0
       Force to use Default VID             0
       Default VLAN Identifier              0
08 Port control 2                         0x0080
       Force good FCS in the frame          0
       Jumbo Mode                           1522
       802.1QMode                           Disabled
       Discard Tagged Frames                0
       Discard Untagged Frames              0
       Map using DA hits                    1
       ARP Mirror enable                    0
       Egress Monitor Source Port           0
       Ingress Monitor Source Port          0
       Use Default Queue Priority           0
       Default Queue Priority               0x0
09 Egress rate control                    0x0001
0a Egress rate control 2                  0x0000
0b Port association vec                   0x0010
0c Port ATU control                       0x0000
0d Override                               0x0000
0e Policy control                         0x0000
0f Port ether type                        0x9100
10 In discard low                         0x0000
11 In discard high                        0x0000
12 In filtered                            0x0000
13 RX frame count                         0x0000
14 Reserved                               0x0000
15 Reserved                               0x0000
16 LED control                            0x0033
17 Reserved                               0x0000
18 Tag remap low                          0x3210
19 Tag remap high                         0x7654
1a Reserved                               0x0000
1b Queue counters                         0x8000
1c Reserved                               0x0000
1d Reserved                               0x0000
1e Reserved                               0x0000
1f Reserved                               0x0000

Detailed info for the CPU port connected to eth0:

root@dali:~# mv88e6xxx_dump --port 6 --device mdio_bus/stmmac-0:1e
00 Port status                            0x0e03
       Pause Enabled                        0
       My Pause                             0
       802.3 PHY Detected                   0
       Link Status                          Up
       Duplex                               Full
       Speed                                1000 Mbps
       EEE Enabled                          0
       Transmitter Paused                   0
       Flow Control                         0
       Config Mode                          0x3
01 Physical control                       0x003e
       RGMII Receive Timing Control         Default
       RGMII Transmit Timing Control        Default
       200 BASE Mode                        100
       Flow Control's Forced value          0
       Force Flow Control                   0
       Link's Forced value                  Up
       Force Link                           1
       Duplex's Forced value                Full
       Force Duplex                         1
       Force Speed                          1000 Mbps
02 Jamming control                        0x0000
03 Switch ID                              0x1761
04 Port control                           0x373f
       Source Address Filtering controls    Disabled
       Egress Mode                          Reserved
       Ingress & Egress Header Mode         0
       IGMP and MLD Snooping                1
       Frame Mode                           Ether Type DSA
       VLAN Tunnel                          0
       TagIfBoth                            0
       Initial Priority assignment          Tag & IP Priority
       Egress Flooding mode                 Allow unknown DA
       Port State                           Forwarding
05 Port control 1                         0x0000
       Message Port                         0
       Trunk Port                           0
       Trunk ID                             0
       FID[11:4]                            0x000
06 Port base VLAN map                     0x003f
       FID[3:0]                             0x000
       VLANTable                            0 1 2 3 4 5
07 Def VLAN ID & Prio                     0x0000
       Default Priority                     0x0
       Force to use Default VID             0
       Default VLAN Identifier              0
08 Port control 2                         0x0080
       Force good FCS in the frame          0
       Jumbo Mode                           1522
       802.1QMode                           Disabled
       Discard Tagged Frames                0
       Discard Untagged Frames              0
       Map using DA hits                    1
       ARP Mirror enable                    0
       Egress Monitor Source Port           0
       Ingress Monitor Source Port          0
       Use Default Queue Priority           0
       Default Queue Priority               0x0
09 Egress rate control                    0x0001
0a Egress rate control 2                  0x0000
0b Port association vec                   0x0040
0c Port ATU control                       0x0000
0d Override                               0x0000
0e Policy control                         0x0000
0f Port ether type                        0xdada
10 In discard low                         0x0000
11 In discard high                        0x0000
12 In filtered                            0x0000
13 RX frame count                         0x0073
14 Reserved                               0x0000
15 Reserved                               0x0000
16 LED control                            0x0000
17 Reserved                               0x0000
18 Tag remap low                          0x3210
19 Tag remap high                         0x7654
1a Reserved                               0x0000
1b Queue counters                         0x8000
1c Reserved                               0x0000
1d Reserved                               0x0000
1e Reserved                               0x0000
1f Reserved                               0x0000

Finally, here's the DSA info printed during boot:

Jan  1 00:00:08 (none) user.info kernel: [    1.787590] libphy: 
mv88e6xxx SMI: probed
Jan  1 00:00:08 (none) user.info kernel: [    4.246782] mv88e6085 
stmmac-0:1a lan1 (uninitialized): PHY [mv88e6xxx-0:00] driver [Marvell 
88E1540] (irq=80)
Jan  1 00:00:08 (none) user.info kernel: [    4.373236] mv88e6085 
stmmac-0:1a lan2 (uninitialized): PHY [mv88e6xxx-0:01] driver [Marvell 
88E1540] (irq=81)
Jan  1 00:00:08 (none) user.info kernel: [    4.488280] mv88e6085 
stmmac-0:1a lan3 (uninitialized): PHY [mv88e6xxx-0:02] driver [Marvell 
88E1540] (irq=82)
Jan  1 00:00:08 (none) user.info kernel: [    4.510657] mv88e6085 
stmmac-0:1a: configuring for fixed/1000base-x link mode
Jan  1 00:00:08 (none) user.info kernel: [    4.544236] mv88e6085 
stmmac-0:1a: Link is Up - 1Gbps/Full - flow control off
Jan  1 00:00:08 (none) user.info kernel: [    4.653347] mv88e6085 
stmmac-0:1e lan4 (uninitialized): PHY [mv88e6xxx-2:00] driver [Marvell 
88E1540] (irq=105)
Jan  1 00:00:08 (none) user.info kernel: [    4.774293] mv88e6085 
stmmac-0:1e dmz (uninitialized): PHY [mv88e6xxx-2:01] driver [Marvell 
88E1540] (irq=106)
Jan  1 00:00:08 (none) user.info kernel: [    4.797851] mv88e6085 
stmmac-0:1e: configuring for fixed/1000base-x link mode
Jan  1 00:00:08 (none) user.info kernel: [    4.823888] mv88e6085 
stmmac-0:1e: Link is Up - 1Gbps/Full - flow control off
Jan  1 00:00:08 (none) user.info kernel: [    4.832086] DSA: tree 0 setup

Any ideas on how to get ICMP working, using the DSA single-port 
configuration example, are welcome.

Thanks!
