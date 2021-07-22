Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316AE3D3004
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 01:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhGVWXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 18:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbhGVWXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 18:23:03 -0400
X-Greylist: delayed 510 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Jul 2021 16:03:37 PDT
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F54C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 16:03:37 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:502c:d016:36c4:32a0] (unknown [IPv6:2600:8801:8800:12e8:502c:d016:36c4:32a0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id 90F9C206FC
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 15:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1626994505;
        bh=zta+LQRTU5ZA1bg8wFA26ej3VPwEAJgZatcWkMJLxO4=;
        h=To:From:Subject:Date:From;
        b=KiYjoF/2W1WmfMOjOajXOmTkauIl+fRPaJTPUAU9+g/Zijjf2NlyI/zJ2sxN/6pm0
         b9jI97ffLLwfmDThqyWNgWTvHRBQTiILnDV/klCo3466KZmkpyej9aZCJGh6SfrIH/
         vH7Dw58ngEqrFRQ6w6nb7n0yMoVOTNabx5WAFZEw=
To:     netdev@vger.kernel.org
From:   Dario Alcocer <dalcocer@helixd.com>
Subject: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
Date:   Thu, 22 Jul 2021 15:55:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After configuring a DSA tree for two Marvell 88E6176 chips, attempts to
ping a host connected to the first user port fail. Running "ip link" shows
the user port state as LOWERLAYERDOWN, and no packets make it out the port.

It's not clear why the state is LOWERLAYERDOWN. The port has a connected
network device, and the port LED is on.

I'd welcome any ideas on how to figure out why the port is not working.

The Marvell chips are configured for multi-chip mode, and are connected
to a single MDIO bus:

* chip at PHY address 0x1E is connected to eth0 of the host processor,
   an Altera Cyclone V
* chip at PHY address 0x1A is connected over SERDES to the other chip,
   using port 4

Here's a console capture showing the port set-up and the failed ping:

root@dali:~# uname -a
Linux dali 5.4.114-altera #1 SMP Thu Jul 22 20:07:57 UTC 2021 armv7l armv7l armv7l GNU/Linux
root@dali:~# ip link

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
     link/can
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/sit 0.0.0.0 brd 0.0.0.0
5: lan1@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
6: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
7: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
8: lan4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
9: dmz@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
root@dali:~# ip addr add 192.0.2.1/24 dev lan1
root@dali:~# ip link set lan1 up
[  902.623835] mv88e6085 stmmac-0:1a lan1: configuring for phy/gmii link mode
[  902.633092] 8021q: adding VLAN 0 to HW filter on device lan1
root@dali:~# ping -c 4 192.0.2.2
PING 192.0.2.2 (192.0.2.2): 56 data bytes

--- 192.0.2.2 ping statistics ---
4 packets transmitted, 0 packets received, 100% packet loss
root@dali:~# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
     link/can
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/sit 0.0.0.0 brd 0.0.0.0
5: lan1@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
6: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
7: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
8: lan4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
9: dmz@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
root@dali:~# ip route
default via 192.168.0.1 dev eth0
192.0.2.0/24 dev lan1 proto kernel scope link src 192.0.2.1 linkdown
192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.3
224.0.0.0/4 dev eth0 scope link src 192.168.0.3
root@dali:~#

The DSA switch tree is configured using this device tree fragment:

gmac0 {
     status = "okay";
     phy-mode = "gmii";
     txc-skew-ps = <0xbb8>;
     rxc-skew-ps = <0xbb8>;
     txen-skew-ps = <0>;
     rxdv-skew-ps = <0>;
     rxd0-skew-ps = <0>;
     rxd1-skew-ps = <0>;
     rxd2-skew-ps = <0>;
     rxd3-skew-ps = <0>;
     txd0-skew-ps = <0>;
     txd1-skew-ps = <0>;
     txd2-skew-ps = <0>;
     txd3-skew-ps = <0>;
     max-frame-size = <3800>;

     fixed-link {
     speed = <0x3e8>;
         full-duplex;
         pause;
     };

     mdio {
         compatible = "snps,dwmac-mdio";
         #address-cells = <0x1>;
         #size-cells = <0x0>;

         switch0: switch0@1a {
             compatible = "marvell,mv88e6085";
             reg = <0x1a>;
             dsa,member = <0 0>;
             ports {
                 #address-cells = <1>;
                 #size-cells = <0>;
                 port@0 {
                     reg = <0>;
                     label = "lan1";
                 };
                 port@1 {
                     reg = <1>;
                     label = "lan2";
                 };
                 port@2 {
                     reg = <2>;
                     label = "lan3";
                 };
                 switch0port4: port@4 {
                     reg = <4>;
                     phy-mode = "rgmii-id";
                     link = <&switch1port4>;
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
                     };
                 };
                 port@6 {
                     reg = <6>;
                     ethernet = <&gmac0>;
                     label = "cpu";
                 };
             };
         };
         switch1: switch1@1e {
             compatible = "marvell,mv88e6085";
             reg = <0x1e>;
             dsa,member = <0 1>;
             ports {
                 #address-cells = <1>;
                 #size-cells = <0>;
                 port@0 {
                     reg = <0>;
                     label = "lan4";
                 };
                 port@1 {
                     reg = <1>;
                     label = "dmz";
                 };
                 switch1port4: port@4 {
                     reg = <4>;
                     link = <&switch0port4>;
                     phy-mode = "rgmii-id";
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
                     };
                 };
             };
         };
     };
};

