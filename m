Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6913E46A372
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243887AbhLFRsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:48:32 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53604 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbhLFRsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:48:31 -0500
Received: from [IPv6:2a00:23c6:c31a:b300:d843:805f:270e:3984] (unknown [IPv6:2a00:23c6:c31a:b300:d843:805f:270e:3984])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id F31821F42B71;
        Mon,  6 Dec 2021 17:45:00 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1638812701; bh=UelLsJvro2CHP1GVYlt5j4D7wNFgmp4QcfIgZcKT6mc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Up/gO65/nRqxQHaPDHiTRqYe42s0MTRlCirAe9YAKEL0joRyZ/wTbPbz2g7bqPs+R
         O826PC2hv/Cuf9Q1Vg6jV/JAANDzgSWAFGHAuxc7VGg1K1qsBfJZNl2wDus20ME3v9
         XdOCHTQSZabwQyenv8ksldOaq2rV7uAyQeb92l39v36E88D3IaTOOmMUG/bYmVXaIP
         fcL3mboJoGQey1TgCVk7pB7aZlTbQ0XFuzPCty0lL9S5/8uJ7BFlvgQhZ58kKzHNSI
         3++8KfwBnZtDaa7GKJDCu7B00YDP4k5AEwbqYxLCa1aKdEfhJph3yH7axOEzsvGo4W
         0UNqAoSd7ZknQ==
Message-ID: <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
Subject: Re: mv88e6240 configuration broken for B850v3
From:   Martyn Welch <martyn.welch@collabora.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        kernel@collabora.com, Russell King <rmk+kernel@armlinux.org.uk>
Date:   Mon, 06 Dec 2021 17:44:59 +0000
In-Reply-To: <YapE3I0K4s1Vzs3w@lunn.ch>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
         <YapE3I0K4s1Vzs3w@lunn.ch>
Organization: Collabora Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-12-03 at 17:25 +0100, Andrew Lunn wrote:
> > Hi Andrew,
> 
> Adding Russell to Cc:
> 
> > I'm currently in the process of updating the GE B850v3 [1] to run a
> > newer kernel than the one it's currently running. 
> 
> Which kernel exactly. We like bug reports against net-next, or at
> least the last -rc.
> 

I tested using v5.15-rc3 and that was also affected.

> > 
> > This device (and others in the same family) use a mv88e6240 switch to
> > provide a number of their ethernet ports. The CPU link on the switch
> > is
> > connected via a PHY, as the network port on the SoM used is exposed
> > via
> > a PHY.
> > 
> > The ports of the B850v3 stopped working when I upgraded, bisecting
> > resulted in me finding that this commit was the root cause:
> > 
> > 3be98b2d5fbc (refs/bisect/bad) net: dsa: Down cpu/dsa ports phylink
> > will control
> > 
> > I think this is causing the PHY on the mv88e6240 side of the CPU link
> > to be forced down in our use case.
> > 
> > I assume an extra check is needed here to stop that in cases like
> > ours,
> > though I'm not sure what at this point. Any ideas?
> 
> From the commit message.
> 
>     DSA and CPU ports can be configured in two ways. By default, the
>     driver should configure such ports to there maximum bandwidth. For
>     most use cases, this is sufficient. When this default is
> insufficient,
>     a phylink instance can be bound to such ports, and phylink will
>     configure the port,
> 
> You have a phy-handle in your node:
> 
>         port@4 {
>                 reg = <4>;
>                 label = "cpu";
>                 ethernet = <&switch_nic>;
>                 phy-handle = <&switchphy4>;
>         };
> 
> so i would expect there to be a phylink instance. The commit message
> continues to say:
> 
>                                           and phylink will
>     configure the port, e.g. based on fixed-link properties.
> 
> So i think you are asking the wrong question. It is not an extra check
> is needed here, we need to understand why phylink is not configuring
> the MAC. Or is that configuration wrong.
> 
> I suggest you add #define DEBUG 1 to the very top of
> drivers/net/phy/phylink.c so we can see what phylink is doing.
> 

The pertinent parts of the logs (from v5.16-rc3, with the above debug
added) appear to be:

# dmesg | grep -e mv88e6085 -e DSA -e libphy
[    2.119282] libphy: Fixed MDIO Bus: probed
[    2.124547] libphy: GPIO Bitbanged MDIO: probed
[    2.129795] mv88e6085 gpio-0:00: switch 0x2400 detected: Marvell
88E6240, revision 1
[    2.150568] libphy: mdio: probed
[    2.224233] libphy: fec_enet_mii_bus: probed
[    3.064455] mv88e6085 gpio-0:00: switch 0x2400 detected: Marvell
88E6240, revision 1
[    3.083930] libphy: mdio: probed
[    3.844882] mv88e6085 gpio-0:00 eneport1 (uninitialized): PHY
[!mdio-gpio!switch@0!mdio:00] driver [Marvell 88E1540] (irq=362)
[    3.856335] mv88e6085 gpio-0:00 eneport1 (uninitialized): phy:
setting supported 0000000,00000000,000022ef advertising
0000000,00000000,000022ef
[    3.962649] mv88e6085 gpio-0:00 eneport2 (uninitialized): PHY
[!mdio-gpio!switch@0!mdio:01] driver [Marvell 88E1540] (irq=363)
[    3.974091] mv88e6085 gpio-0:00 eneport2 (uninitialized): phy:
setting supported 0000000,00000000,000022ef advertising
0000000,00000000,000022ef
[    4.080405] mv88e6085 gpio-0:00 enix (uninitialized): PHY
[!mdio-gpio!switch@0!mdio:02] driver [Marvell 88E1540] (irq=364)
[    4.091510] mv88e6085 gpio-0:00 enix (uninitialized): phy: setting
supported 0000000,00000000,000022ef advertising
0000000,00000000,000022ef
[    4.202683] mv88e6085 gpio-0:00 enid (uninitialized): PHY
[!mdio-gpio!switch@0!mdio:03] driver [Marvell 88E1540] (irq=365)
[    4.213774] mv88e6085 gpio-0:00 enid (uninitialized): phy: setting
supported 0000000,00000000,000022ef advertising
0000000,00000000,000022ef
[    4.298209] mv88e6085 gpio-0:00: PHY [!mdio-gpio!switch@0!mdio:04]
driver [Marvell 88E1540] (irq=366)
[    4.307475] mv88e6085 gpio-0:00: phy: setting supported
0000000,00000000,000022ef advertising 0000000,00000000,000022ef
[    4.314285] mv88e6085 gpio-0:00: configuring for phy/ link mode
[    4.320251] mv88e6085 gpio-0:00: major config 
[    4.320262] mv88e6085 gpio-0:00: phylink_mac_config:
mode=phy//Unknown/Unknown adv=0000000,00000000,00000000 pause=00 link=0
an=0
[    4.324265] DSA: tree 0 setup
[    4.399423] mv88e6085 gpio-0:00: phy link down /Unknown/Unknown/off
[   15.600977] mv88e6085 gpio-0:00 enix: configuring for phy/ link mode
[   15.607417] mv88e6085 gpio-0:00 enix: major config 
[   15.607443] mv88e6085 gpio-0:00 enix: phylink_mac_config:
mode=phy//Unknown/Unknown adv=0000000,00000000,00000000 pause=00 link=0
an=0
[   15.678811] mv88e6085 gpio-0:00 enix: phy link down
/Unknown/Unknown/off
[   15.961559] mv88e6085 gpio-0:00 enid: configuring for phy/ link mode
[   15.967945] mv88e6085 gpio-0:00 enid: major config 
[   15.967958] mv88e6085 gpio-0:00 enid: phylink_mac_config:
mode=phy//Unknown/Unknown adv=0000000,00000000,00000000 pause=00 link=0
an=0
[   15.986370] mv88e6085 gpio-0:00 enix: configuring for phy/ link mode
[   15.992829] mv88e6085 gpio-0:00 enix: major config 
[   15.992843] mv88e6085 gpio-0:00 enix: phylink_mac_config:
mode=phy//Unknown/Unknown adv=0000000,00000000,00000000 pause=00 link=0
an=0
[   16.019628] mv88e6085 gpio-0:00 eneport2: configuring for phy/ link
mode
[   16.026370] mv88e6085 gpio-0:00 eneport2: major config 
[   16.026382] mv88e6085 gpio-0:00 eneport2: phylink_mac_config:
mode=phy//Unknown/Unknown adv=0000000,00000000,00000000 pause=00 link=0
an=0
[   16.057585] mv88e6085 gpio-0:00 eneport1: configuring for phy/ link
mode
[   16.064367] mv88e6085 gpio-0:00 eneport1: major config 
[   16.064381] mv88e6085 gpio-0:00 eneport1: phylink_mac_config:
mode=phy//Unknown/Unknown adv=0000000,00000000,00000000 pause=00 link=0
an=0
[   16.132700] mv88e6085 gpio-0:00 enid: phy link up /10Mbps/Full/off
[   16.134210] mv88e6085 gpio-0:00 enid: phylink_mac_config:
mode=phy//10Mbps/Full adv=0000000,00000000,00000000 pause=00 link=1
an=0
[   16.141177] mv88e6085 gpio-0:00 enid: Link is Up - 10Mbps/Full -
flow control off
[   16.195201] mv88e6085 gpio-0:00 enix: phy link down
/Unknown/Unknown/off
[   16.215131] mv88e6085 gpio-0:00 eneport2: phy link down
/Unknown/Unknown/off
[   16.254004] mv88e6085 gpio-0:00 eneport1: phy link up
/10Mbps/Full/off
[   16.254027] mv88e6085 gpio-0:00 eneport1: phylink_mac_config:
mode=phy//10Mbps/Full adv=0000000,00000000,00000000 pause=00 link=1
an=0
[   16.254056] mv88e6085 gpio-0:00 eneport1: Link is Up - 10Mbps/Full -
flow control off
[   18.706700] mv88e6085 gpio-0:00: phy link up /1Gbps/Full/rx/tx
[   18.708976] mv88e6085 gpio-0:00: phylink_mac_config:
mode=phy//1Gbps/Full adv=0000000,00000000,00000000 pause=03 link=1 an=0
[   18.709002] mv88e6085 gpio-0:00: Link is Up - 1Gbps/Full - flow
control rx/tx

Despite the last few lines suggesting to me the phy link is up, I'm
unable to access the network I'd expect to be able to access.

>         Andrew
> 

