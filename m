Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D930372CBD
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 17:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhEDPJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 11:09:51 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:40801 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhEDPJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 11:09:50 -0400
Received: from localhost (lfbn-lyo-1-1676-55.w90-65.abo.wanadoo.fr [90.65.108.55])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 07D82240003;
        Tue,  4 May 2021 15:08:52 +0000 (UTC)
Date:   Tue, 4 May 2021 17:08:52 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Colin Foster <colin.foster@in-advantage.com>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "supporter:OCELOT ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OCELOT ETHERNET SWITCH DRIVER" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Message-ID: <YJFjhH+HmVc/tLDI@piout.net>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
 <YJE+prMCIMiQm26Z@lunn.ch>
 <20210504125942.nx5b6j2cy34qyyhm@skbuf>
 <YJFST3Q13Kp/Eqa1@piout.net>
 <20210504143633.gju4sgjntihndpy6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504143633.gju4sgjntihndpy6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/05/2021 14:36:34+0000, Vladimir Oltean wrote:
> On Tue, May 04, 2021 at 03:55:27PM +0200, Alexandre Belloni wrote:
> > On 04/05/2021 12:59:43+0000, Vladimir Oltean wrote:
> > > > > +static void vsc7512_phylink_validate(struct ocelot *ocelot, int port,
> > > > > +				     unsigned long *supported,
> > > > > +				     struct phylink_link_state *state)
> > > > > +{
> > > > > +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> > > > > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = {
> > > > > +		0,
> > > > > +	};
> > > > 
> > > > This function seems out of place. Why would SPI access change what the
> > > > ports are capable of doing? Please split this up into more
> > > > patches. Keep the focus of this patch as being adding SPI support.
> > > 
> > > What is going on is that this is just the way in which the drivers are
> > > structured. Colin is not really "adding SPI support" to any of the
> > > existing DSA switches that are supported (VSC9953, VSC9959) as much as
> > > "adding support for a new switch which happens to be controlled over
> > > SPI" (VSC7512).
> > 
> > Note that this should not only be about vsc7512 as the whole ocelot
> > family (vsc7511, vsc7512, vsc7513 and vsc7514) can be connected over
> > spi. Also, they can all be used in a DSA configuration, over PCIe, just
> > like Felix.
> 
> I see. From the Linux device driver model's perspective, a SPI driver
> for VSC7512 is still different than an MMIO driver for the same hardware
> is, and that is working a bit against us. I don't know much about regmap
> for SPI, specifically how are the protocol buffers constructed, and if
> it's easy or not to have a driver-specified hook in which the memory
> address for the SPI reads and writes is divided by 4. If I understand
> correctly, that's about the only major difference between a VSC7512
> driver for SPI vs MMIO, and would allow reusing the same regmaps as e.g.
> the ones in drivers/net/ethernet/ocelot_vsc7514.c. Avoiding duplication
> for the rest could be handled with a lot of EXPORT_SYMBOL, although
> right now, I am not sure that is quite mandated yet. I know that the
> hardware is capable of a lot more flexibility than what the Linux
> drivers currently make of, but let's not think of overly complex ways of
> managing that entire complexity space unless somebody actually needs it.
> 

I've been thinking about defining the .reg_read and .reg_write functions
of the regmap_config to properly abstract accesses and leave the current
ocelot core as it is.

> As to phylink, I had some old patches converting ocelot to phylink in
> the blind, but given the fact that I don't have any vsc7514 board and I
> was relying on Horatiu to test them, those patches didn't land anywhere
> and would be quite obsolete now.
> I don't know how similar VSC7512 (Colin's chip) and VSC7514 (the chip
> supported by the switchdev ocelot) are in terms of hardware interfaces.
> If the answer is "not very", then this is a bit of a moot point, but if
> they are, then ocelot might first have to be converted to phylink, and
> then its symbols exported such that DSA can use them too.
> 

VSC7512 and VSC7514 are exactly the same chip. VSC7514 has the MIPS
CPU enabled.

> What Colin appears to be doing differently to all other Ocelot/Felix
> drivers is that he has a single devm_regmap_init_spi() in felix_spi_probe.
> Whereas everyone else uses a separate devm_regmap_init_mmio() per each
> memory region, tucked away in ocelot_regmap_init(). I still haven't
> completely understood why that is, but this is the reason why he needs
> the "offset" passed to all I/O accessors: since he uses a single regmap,
> the offset is what accesses one memory region or another in his case.
> 

Yes, this is the main pain point. You only have one chip select so from
the regmap point of view, there is only one region. I'm wondering
whether we could actually register multiple regmap for a single SPI
device (and then do the offsetting in .reg_read/.reg_write) which would
help.


-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
