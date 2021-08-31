Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9B63FCFC4
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241078AbhHaXDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:03:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50882 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235659AbhHaXDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 19:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=enbFY4AVKjJRnyljEbP4rqvuKLOuy7w4dhctW4G9+Pc=; b=TbneM/9NQEoaUp0zOG3XRre1XH
        UxI+alXoL6qsrMUqaE1U188kI4iGhU3jWtF6ZXvd2iQHmVinWsmOlSihU/RwtfWSfk4qcj3kvuFga
        KWTDDdRqWoVtzhmhvFNDVvnJxTR3TyIcBZvo1R7L3UoGGwrlmTQsWysnG2IGqF7pUsE4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLCld-004m4d-Tn; Wed, 01 Sep 2021 01:02:09 +0200
Date:   Wed, 1 Sep 2021 01:02:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YS608fdIhH4+qJsn@lunn.ch>
References: <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If the switches are broken without the phy-handle or ethernet change,
> I'm not sure if the "BROKEN_PARENT" patch would help.

> > Which is not enough to fix these Ethernet switches.
> 
> Ok, if you can give more specifics on this, I'll look into it.

The switches probe, but get the wrong PHY driver, genphy, not the
Marvell PHY driver. And genphy is not sufficient for this hardware.

I'd need:
> 1) The DTS file that you see the issue on.

I did the bisect on arch/arm/boot/dts/vf610-zii-dev-rev-c.dts but i
also tested arch/arm/boot/dts/vf610-zii-dev-rev-b.dts.

Rev B is interesting because switch0 and switch1 got genphy, while
switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
interrupt properties, so don't loop back to their parent device.

Here is Rev B. I trimmed out other devices probing in parallel:

[    1.029100] fec 400d1000.ethernet: Invalid MAC address: 00:00:00:00:00:00
[    1.034735] fec 400d1000.ethernet: Using random MAC address: 42:f2:14:33:78:f5
[    1.042272] libphy: fec_enet_mii_bus: probed
[    1.455932] libphy: mdio_mux: probed
[    1.459432] mv88e6085 0.1:00: switch 0x3520 detected: Marvell 88E6352, revision 1
[    1.494076] libphy: mdio: probed
[    1.518958] libphy: mdio_mux: probed
[    1.522553] mv88e6085 0.2:00: switch 0x3520 detected: Marvell 88E6352, revision 1
[    1.537295] libphy: mdio: probed
[    1.556571] libphy: mdio_mux: probed
[    1.559719] mv88e6085 0.4:00: switch 0x1a70 detected: Marvell 88E6185, revision 2
[    1.574614] libphy: mdio: probed
[    1.733104] mv88e6085 0.1:00 lan0 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:00] driver [Generic PHY] (irq=POLL)
[    1.750737] mv88e6085 0.1:00 lan1 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
[    1.768273] mv88e6085 0.1:00 lan2 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
[    1.806561] mv88e6085 0.2:00 lan3 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:00] driver [Generic PHY] (irq=POLL)
[    1.824033] mv88e6085 0.2:00 lan4 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
[    1.841496] mv88e6085 0.2:00 lan5 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
[    1.943535] mv88e6085 0.4:00 lan6 (uninitialized): PHY [!mdio-mux!mdio@4!switch@0!mdio:00] driver [Marvell 88E1545] (irq=POLL)
[    2.003529] mv88e6085 0.4:00 lan7 (uninitialized): PHY [!mdio-mux!mdio@4!switch@0!mdio:01] driver [Marvell 88E1545] (irq=POLL)
[    2.063535] mv88e6085 0.4:00 lan8 (uninitialized): PHY [!mdio-mux!mdio@4!switch@0!mdio:02] driver [Marvell 88E1545] (irq=POLL)
[    2.084768] DSA: tree 0 setup
[    2.087791] libphy: mdio_mux: probed
[    2.265477] Micrel KSZ8041 400d0000.ethernet-1:00: attached PHY driver (mii_bus:phy_addr=400d0000.ethernet-1:00, irq=POLL)

root@zii-devel-b:~# cat /sys/kernel/debug/devices_deferred
root@zii-devel-b:~# 

For Rev C we see:

[    1.244417] fec 400d1000.ethernet: Invalid MAC address: 00:00:00:00:00:00
[    1.250081] fec 400d1000.ethernet: Using random MAC address: c6:42:89:ed:5f:dd
[    1.257507] libphy: fec_enet_mii_bus: probed
[    1.570725] libphy: mdio_mux: probed
[    1.574208] mv88e6085 0.1:00: switch 0xa10 detected: Marvell 88E6390X, revision 1
[    1.590272] libphy: mdio: probed
[    1.627721] libphy: mdio_mux: probed
[    1.631222] mv88e6085 0.2:00: switch 0xa10 detected: Marvell 88E6390X, revision 1
[    1.659643] libphy: mdio: probed
[    1.811665] mv88e6085 0.1:00 lan1 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
[    1.829230] mv88e6085 0.1:00 lan2 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
[    1.845884] mv88e6085 0.1:00 lan3 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:03] driver [Generic PHY] (irq=POLL)
[    1.863237] mv88e6085 0.1:00 lan4 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:04] driver [Generic PHY] (irq=POLL)
[    1.884078] mv88e6085 0.2:00 lan5 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
[    1.901630] mv88e6085 0.2:00 lan6 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
[    1.918287] mv88e6085 0.2:00 lan7 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:03] driver [Generic PHY] (irq=POLL)
[    1.933721] mv88e6085 0.2:00 lan8 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:04] driver [Generic PHY] (irq=POLL)
[    1.948722] DSA: tree 0 setup
[    1.951599] libphy: mdio_mux: probed

[   21.565550] Micrel KSZ8041 400d0000.ethernet-1:00: attached PHY driver (mii_bus:phy_addr=400d0000.ethernet-1:00, irq=48)

I have Rev B using NFS root, so the interfaces are configured up by
the kernel during boot. Rev C has a local root filesystem, so user
space brings the interfaces up, and it is only when the FEC is opened
does it attach to the Micrel PHY. That explains the difference between
2.265 and 21.565 seconds for the last line.

Again, nothing deferred.

       Andrew
