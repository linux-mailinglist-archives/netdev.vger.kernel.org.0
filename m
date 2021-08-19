Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921E33F1C21
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240684AbhHSPDc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Aug 2021 11:03:32 -0400
Received: from mail.rutenbeck.de ([80.149.79.228]:20421 "EHLO
        mail.rutenbeck.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240652AbhHSPDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:03:31 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2021 11:03:31 EDT
From:   "Gade, Jonas" <jonas.gade@rutenbeck.de>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: mv88e6352 no traffic over phy to phy cpu port
Thread-Topic: mv88e6352 no traffic over phy to phy cpu port
Thread-Index: AdeU8Bx2jRKhaLtdQ9WtaT+nagdh0Q==
Date:   Thu, 19 Aug 2021 14:47:52 +0000
Message-ID: <5874a25e685547e695004d8c3c20d820@rutenbeck.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.50.150]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,
we have a 8devices Carambola2 (running OpenWrt 21, Kernel 5.4) connected to mv88e6352 switch on a custom board. On the Carambola2 MDC is connected to GPIO 19 and MDIO is connected to GPIO 21 (Bit banging). The Port 1 of the mv88e6352 is connected to fast ethernet port 2 on the internal AR9331 switch. Unfortunately there is no traffic between the carambola2 and the mv88e6352. The SMI is working and the driver is probing. The AR9331 internal switch is configured to all ports being untagged. When the system is running without probing the mv88e6352 driver, i can reach the carambola2 module over the mv88e6352. So hardware should be okay. Is there anything else I should check or am I trying something stupid?

DTS:
ports {
	#address-cells = <1>;
	#size-cells = <0>;

	port@0 {
		reg = <0>;
		label = "lan0";
	};

	port@1 {
		reg = <1>;
		label = "cpu";
		ethernet = <&eth1>;
	};

	port@2 {
		reg = <2>;
		label = "lan2";
	};

	port@3 {
		reg = <3>;
		label = "lan3";
	};

	port@4 {
		reg = <4>;
		label = "lan4";
	};
};

BOOTLOG:
[    0.408255] libphy: GPIO Bitbanged MDIO: probed
[    0.413506] libphy: Fixed MDIO Bus: probed
[    0.420599] mv88e6085 gpio-0:00: switch 0x3520 detected: Marvell 88E6352, revision 1
[    0.627134] libphy: mv88e6xxx SMI: probed
[    0.883384] random: fast init done
[    0.953589] libphy: ag71xx_mdio: probed
[    0.956179] ag71xx 19000000.eth: Could not connect to PHY device. Deferring probe.
[    1.595893] libphy: ag71xx_mdio: probed
[    1.599262] libphy: ar8xxx-mdio: probed
[    1.605418] switch0: Atheros AR724X/AR933X built-in rev. 2 switch registered on mdio.1
[    1.645589] ag71xx 1a000000.eth: connected to PHY at fixed-0:00 [uid=00000000, driver=Generic PHY]
[    1.654151] eth0: Atheros AG71xx at 0xba000000, irq 5, mode: gmii

[    1.689368] mv88e6085 gpio-0:00: switch 0x3520 detected: Marvell 88E6352, revision 1
[    1.877661] libphy: mv88e6xxx SMI: probed
[    2.205024] ag71xx 19000000.eth: connected to PHY at mdio.1:1f:04 [uid=004dd041, driver=Generic PHY]
[    2.214126] eth1: Atheros AG71xx at 0xb9000000, irq 4, mode: mii
[    2.219290] mv88e6085 gpio-0:00: switch 0x3520 detected: Marvell 88E6352, revision 1
[    2.400623] libphy: mv88e6xxx SMI: probed
[    2.679660] mv88e6085 gpio-0:00 lan0 (uninitialized): PHY [mv88e6xxx-2:00] driver [Marvell 88E1540]
[    2.698447] mv88e6085 gpio-0:00 lan2 (uninitialized): PHY [mv88e6xxx-2:02] driver [Marvell 88E1540]
[    2.711375] mv88e6085 gpio-0:00 lan3 (uninitialized): PHY [mv88e6xxx-2:03] driver [Marvell 88E1540]
[    2.729265] mv88e6085 gpio-0:00 lan4 (uninitialized): PHY [mv88e6xxx-2:04] driver [Marvell 88E1540]
[    2.741964] DSA: tree 0 setup

[   34.759169] eth0: link up (1000Mbps/Full duplex)
[   34.765145] mv88e6085 gpio-0:00 lan0: configuring for phy/gmii link mode
[   34.779912] 8021q: adding VLAN 0 to HW filter on device lan0
[   34.784995] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   34.799094] br-lan: port 1(lan0) entered blocking state
[   34.802948] br-lan: port 1(lan0) entered disabled state
[   34.825702] device lan0 entered promiscuous mode
[   34.828934] device eth0 entered promiscuous mode
[   35.002030] mv88e6085 gpio-0:00 lan2: configuring for phy/gmii link mode
[   35.019923] 8021q: adding VLAN 0 to HW filter on device lan2
[   35.030538] br-lan: port 2(lan2) entered blocking state
[   35.034401] br-lan: port 2(lan2) entered disabled state
[   35.057375] device lan2 entered promiscuous mode
[   35.067776] mv88e6085 gpio-0:00: p1: already a member of VLAN 1
[   35.108017] mv88e6085 gpio-0:00 lan3: configuring for phy/gmii link mode
[   35.122364] 8021q: adding VLAN 0 to HW filter on device lan3
[   35.132707] br-lan: port 3(lan3) entered blocking state
[   35.136573] br-lan: port 3(lan3) entered disabled state
[   35.160565] device lan3 entered promiscuous mode
[   35.170915] mv88e6085 gpio-0:00: p1: already a member of VLAN 1
[   35.215998] mv88e6085 gpio-0:00 lan4: configuring for phy/gmii link mode
[   35.230356] 8021q: adding VLAN 0 to HW filter on device lan4
[   35.240334] br-lan: port 4(lan4) entered blocking state
[   35.244187] br-lan: port 4(lan4) entered disabled state
[   35.268667] device lan4 entered promiscuous mode
[   35.279016] mv88e6085 gpio-0:00: p1: already a member of VLAN 1
[   36.869911] mv88e6085 gpio-0:00 lan3: Link is Up - 100Mbps/Full - flow control rx/tx
[   36.895570] br-lan: port 3(lan3) entered blocking state
[   36.899352] br-lan: port 3(lan3) entered forwarding state
[   36.944191] IPv6: ADDRCONF(NETDEV_CHANGE): br-lan: link becomes ready
[   38.462172] mv88e6085 gpio-0:00 lan4: Link is Up - 1Gbps/Full - flow control rx/tx
[   38.468377] br-lan: port 4(lan4) entered blocking state
[   38.473548] br-lan: port 4(lan4) entered forwarding state

SWCONFIG AR9331:
root@OpenWrt:/# swconfig dev switch0 show
Global attributes:
	enable_vlan: 1
	ar8xxx_mib_poll_interval: 500
	ar8xxx_mib_type: 0
	enable_mirror_rx: 0
	enable_mirror_tx: 0
	mirror_monitor_port: 0
	mirror_source_port: 0
	arl_table: address resolution table
Port 0: MAC c4:93:00:20:bd:a2

Port 0:
	mib: MIB counters
RxGoodByte  : 7362 (7.1 KiB)
TxByte      : 0

	pvid: 1
	link: port:0 link:up speed:1000baseT full-duplex txflow rxflow
Port 1:
	mib: No MIB data
	pvid: 1
	link: port:1 link:down
Port 2:
	mib: MIB counters
RxGoodByte  : 0
TxByte      : 7362 (7.1 KiB)

	pvid: 1
	link: port:2 link:up speed:100baseT full-duplex auto
Port 3:
	mib: No MIB data
	pvid: 1
	link: port:3 link:down
Port 4:
	mib: No MIB data
	pvid: 1
	link: port:4 link:down
VLAN 1:
	vid: 1
	ports: 0 1 2 3 4

IP LINK SHOW:
root@OpenWrt:/# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc fq_codel state UP qlen 1000
    link/ether c4:93:00:20:bd:a3 brd ff:ff:ff:ff:ff:ff
3: lan0@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue master br-lan state LOWERLAYERDOWN qlen 1000
    link/ether c4:93:00:20:bd:a3 brd ff:ff:ff:ff:ff:ff
4: lan2@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue master br-lan state LOWERLAYERDOWN qlen 1000
    link/ether c4:93:00:20:bd:a3 brd ff:ff:ff:ff:ff:ff
5: lan3@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-lan state UP qlen 1000
    link/ether c4:93:00:20:bd:a3 brd ff:ff:ff:ff:ff:ff
6: lan4@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-lan state UP qlen 1000
    link/ether c4:93:00:20:bd:a3 brd ff:ff:ff:ff:ff:ff
7: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether c4:93:00:20:bd:a2 brd ff:ff:ff:ff:ff:ff
8: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether c4:93:00:20:bd:a4 brd ff:ff:ff:ff:ff:ff
9: br-lan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP qlen 1000
    link/ether c4:93:00:20:bd:a3 brd ff:ff:ff:ff:ff:ff

ETHTOOL:
root@OpenWrt:/# ethtool -S eth0
NIC statistics:
     Tx/Rx 64 Byte: 24
     Tx/Rx 65-127 Byte: 8
     Tx/Rx 128-255 Byte: 11
     Tx/Rx 256-511 Byte: 1
     Tx/Rx 512-1023 Byte: 0
     Tx/Rx 1024-1518 Byte: 0
     Tx/Rx 1519-1522 Byte VLAN: 0
     Rx Byte: 0
     Rx Packet: 0
     Rx FCS Error: 0
     Rx Multicast Packet: 0
     Rx Broadcast Packet: 0
     Rx Control Frame Packet: 0
     Rx Pause Frame Packet: 0
     Rx Unknown OPCode Packet: 0
     Rx Alignment Error: 0
     Rx Frame Length Error: 0
     Rx Code Error: 0
     Rx Carrier Sense Error: 0
     Rx Undersize Packet: 0
     Rx Oversize Packet: 0
     Rx Fragments: 0
     Rx Jabber: 0
     Rx Dropped Packet: 0
     Tx Byte: 4552
     Tx Packet: 44
     Tx Multicast Packet: 19
     Tx Broadcast Packet: 25
     Tx Pause Control Frame: 0
     Tx Deferral Packet: 0
     Tx Excessive Deferral Packet: 0
     Tx Single Collision Packet: 0
     Tx Multiple Collision: 0
     Tx Late Collision Packet: 0
     Tx Excessive Collision Packet: 0
     Tx Total Collision: 0
     Tx Pause Frames Honored: 1803
     Tx Drop Frame: 0
     Tx Jabber Frame: 0
     Tx FCS Error: 0
     Tx Control Frame: 0
     Tx Oversize Frame: 0
     Tx Undersize Frame: 0
     Tx Fragment: 0
     p01_in_good_octets: 0
     p01_in_bad_octets: 0
     p01_in_unicast: 0
     p01_in_broadcasts: 0
     p01_in_multicasts: 0
     p01_in_pause: 0
     p01_in_undersize: 0
     p01_in_fragments: 0
     p01_in_oversize: 0
     p01_in_jabber: 0
     p01_in_rx_error: 0
     p01_in_fcs_error: 0
     p01_out_octets: 67733
     p01_out_unicast: 0
     p01_out_broadcasts: 61
     p01_out_multicasts: 213
     p01_out_pause: 0
     p01_excessive: 0
     p01_collisions: 0
     p01_deferred: 0
     p01_single: 0
     p01_multiple: 0
     p01_out_fcs_error: 0
     p01_late: 0
     p01_hist_64bytes: 0
     p01_hist_65_127bytes: 154
     p01_hist_128_255bytes: 56
     p01_hist_256_511bytes: 8
     p01_hist_512_1023bytes: 56
     p01_hist_1024_max_bytes: 0
     p01_sw_in_discards: 0
     p01_sw_in_filtered: 0
     p01_sw_out_filtered: 0
     p01_atu_member_violation: 0
     p01_atu_miss_violation: 0
     p01_atu_full_violation: 0
     p01_vtu_member_violation: 0
     p01_vtu_miss_violation: 0

Jonas
