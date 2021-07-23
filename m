Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C133D3B55
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhGWNB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:01:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42380 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233486AbhGWNBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 09:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=d1J1wXVbu1iHeQSIz/1gnHdwbskSH+eTURSMe53/20c=; b=z1
        aclrXq7xZWht4GYTQ3RfZeU76O4VgTpsrIy/crQCb8TmoXoOz0PU7uJeE1CH2HMqZzxAg6Arl/ezD
        OrXPRpsalSwBxQpSPacoflAKUXQ+fm43ncFD/B+kxpUegshFs6+QkMCOZWg2ach/BvTl3fMsUW2Ua
        HP0miRPLAMqxnDY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6vR7-00EV0Q-9h; Fri, 23 Jul 2021 15:41:57 +0200
Date:   Fri, 23 Jul 2021 15:41:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YPrHJe+zJGJ7oezW@lunn.ch>
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 03:55:04PM -0700, Dario Alcocer wrote:
> After configuring a DSA tree for two Marvell 88E6176 chips, attempts to
> ping a host connected to the first user port fail. Running "ip link" shows
> the user port state as LOWERLAYERDOWN, and no packets make it out the port.
> 
> It's not clear why the state is LOWERLAYERDOWN. The port has a connected
> network device, and the port LED is on.
> 
> I'd welcome any ideas on how to figure out why the port is not working.
> 
> The Marvell chips are configured for multi-chip mode, and are connected
> to a single MDIO bus:
> 
> * chip at PHY address 0x1E is connected to eth0 of the host processor,
>   an Altera Cyclone V
> * chip at PHY address 0x1A is connected over SERDES to the other chip,
>   using port 4
> 
> Here's a console capture showing the port set-up and the failed ping:
> 
> root@dali:~# uname -a
> Linux dali 5.4.114-altera #1 SMP Thu Jul 22 20:07:57 UTC 2021 armv7l armv7l armv7l GNU/Linux
> root@dali:~# ip link
> 
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
>     link/can
> 3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/sit 0.0.0.0 brd 0.0.0.0
> 5: lan1@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 6: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 7: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 8: lan4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 9: dmz@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> root@dali:~# ip addr add 192.0.2.1/24 dev lan1
> root@dali:~# ip link set lan1 up
> [  902.623835] mv88e6085 stmmac-0:1a lan1: configuring for phy/gmii link mode
> [  902.633092] 8021q: adding VLAN 0 to HW filter on device lan1
> root@dali:~# ping -c 4 192.0.2.2
> PING 192.0.2.2 (192.0.2.2): 56 data bytes
> 
> --- 192.0.2.2 ping statistics ---
> 4 packets transmitted, 0 packets received, 100% packet loss
> root@dali:~# ip link
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
>     link/can
> 3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/sit 0.0.0.0 brd 0.0.0.0
> 5: lan1@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff

NO-CARRIER suggests a PHY problem. You should see it report link up if
it really is up.

When then switch probes the PHYs should also probe. What PHY driver is
being used? You want the Marvell PHY driver, not genphy.

> 6: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 7: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 8: lan4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 9: dmz@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> root@dali:~# ip route
> default via 192.168.0.1 dev eth0

That is not correct. eth0 just acts as a pipe towards the switch. It
does not have an IP address, and there should not be any routes using
it. It needs to be configured up, but that is all.

> 192.0.2.0/24 dev lan1 proto kernel scope link src 192.0.2.1 linkdown
> 192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.3
> 224.0.0.0/4 dev eth0 scope link src 192.168.0.3
> root@dali:~#
> 
> The DSA switch tree is configured using this device tree fragment:
> 
> gmac0 {
>     status = "okay";
>     phy-mode = "gmii";

gmii? That is a bit unusual. You normally see rgmii.

>     txc-skew-ps = <0xbb8>;
>     rxc-skew-ps = <0xbb8>;
>     txen-skew-ps = <0>;
>     rxdv-skew-ps = <0>;
>     rxd0-skew-ps = <0>;
>     rxd1-skew-ps = <0>;
>     rxd2-skew-ps = <0>;
>     rxd3-skew-ps = <0>;
>     txd0-skew-ps = <0>;
>     txd1-skew-ps = <0>;
>     txd2-skew-ps = <0>;
>     txd3-skew-ps = <0>;
>     max-frame-size = <3800>;
> 
>     fixed-link {
>     speed = <0x3e8>;

decimal would be much more readable. Or is this not the source .dts
file, but you have decompiled the DTB back to DTS?

>         full-duplex;
>         pause;
>     };
> 
>     mdio {
>         compatible = "snps,dwmac-mdio";
>         #address-cells = <0x1>;
>         #size-cells = <0x0>;
> 
>         switch0: switch0@1a {
>             compatible = "marvell,mv88e6085";
>             reg = <0x1a>;
>             dsa,member = <0 0>;
>             ports {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>                 port@0 {
>                     reg = <0>;
>                     label = "lan1";
>                 };
>                 port@1 {
>                     reg = <1>;
>                     label = "lan2";
>                 };
>                 port@2 {
>                     reg = <2>;
>                     label = "lan3";
>                 };
>                 switch0port4: port@4 {
>                     reg = <4>;
>                     phy-mode = "rgmii-id";
>                     link = <&switch1port4>;
>                     fixed-link {
>                         speed = <1000>;
>                         full-duplex;
>                     };
>                 };
>                 port@6 {
>                     reg = <6>;
>                     ethernet = <&gmac0>;
>                     label = "cpu";
>                 };
>             };
>         };
>         switch1: switch1@1e {
>             compatible = "marvell,mv88e6085";
>             reg = <0x1e>;
>             dsa,member = <0 1>;
>             ports {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>                 port@0 {
>                     reg = <0>;
>                     label = "lan4";
>                 };
>                 port@1 {
>                     reg = <1>;
>                     label = "dmz";
>                 };
>                 switch1port4: port@4 {
>                     reg = <4>;
>                     link = <&switch0port4>;
>                     phy-mode = "rgmii-id";

You probably don't want both ends of the link in rgmii-id mode. That
will give you twice the delay.

    Andrew
