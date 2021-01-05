Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204CB2EAD2A
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbhAEOLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:11:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50172 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbhAEOLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:11:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwn2L-00GAxa-O1; Tue, 05 Jan 2021 15:10:13 +0100
Date:   Tue, 5 Jan 2021 15:10:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is not
 set
Message-ID: <X/RzRd0zXHzAqLDl@lunn.ch>
References: <20210104122415.1263541-1-geert+renesas@glider.be>
 <20210104145331.tlwjwbzey5i4vgvp@skbuf>
 <CAMuHMdUVsSuAur1wWkjs7FW5N-36XV9iXA6wmvst59eKoUFDHQ@mail.gmail.com>
 <20210104170112.hn6t3kojhifyuaf6@skbuf>
 <X/NNS3FUeSNxbqwo@lunn.ch>
 <X/NQ2fYdBygm3CYc@lunn.ch>
 <20210104184341.szvnl24wnfnxg4k7@skbuf>
 <alpine.DEB.2.22.394.2101051038550.302140@ramsan.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2101051038550.302140@ramsan.of.borg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I added a statically-linked ethtool binary to my initramfs, and can
> confirm that retrieving the PHY statistics does not access the PHY
> registers when the device is suspended:
> 
>     # ethtool --phy-statistics eth0
>     no stats available
>     # ifconfig eth0 up
>     # ethtool --phy-statistics eth0
>     PHY statistics:
> 	 phy_receive_errors: 0
> 	 phy_idle_errors: 0
>     #
> 
> In the past, we've gone to great lengths to avoid accessing the PHY
> registers when the device is suspended, usually in the statistics
> handling (see e.g. [1][2]).

I would argue that is the wrong approach. The PHY device is a
device. It has its own lifetime. You would not suspend a PCI bus
controller without first suspending all PCI devices on the bus etc.

> +static int sh_mdiobb_read(struct mii_bus *bus, int phy, int reg)
> +{
> +	struct bb_info *bb = container_of(bus->priv, struct bb_info, ctrl);

mii_bus->parent should give you dev, so there is no need to add it to
bb_info.

> +	/* Wrap accessors with Runtime PM-aware ops */
> +	bitbang->read = mdp->mii_bus->read;
> +	bitbang->write = mdp->mii_bus->write;
> +	mdp->mii_bus->read = sh_mdiobb_read;
> +	mdp->mii_bus->write = sh_mdiobb_write;

I did wonder about just exporting the two functions so you can
directly call them.

Otherwise, this looks good.

	   Andrew
