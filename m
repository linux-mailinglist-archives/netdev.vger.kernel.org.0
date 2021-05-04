Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFF2372B71
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 15:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhEDN42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 09:56:28 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:51499 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhEDN41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 09:56:27 -0400
X-Originating-IP: 90.65.108.55
Received: from localhost (lfbn-lyo-1-1676-55.w90-65.abo.wanadoo.fr [90.65.108.55])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 9FD541BF20B;
        Tue,  4 May 2021 13:55:27 +0000 (UTC)
Date:   Tue, 4 May 2021 15:55:27 +0200
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
Message-ID: <YJFST3Q13Kp/Eqa1@piout.net>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
 <YJE+prMCIMiQm26Z@lunn.ch>
 <20210504125942.nx5b6j2cy34qyyhm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504125942.nx5b6j2cy34qyyhm@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/05/2021 12:59:43+0000, Vladimir Oltean wrote:
> > > +static void vsc7512_phylink_validate(struct ocelot *ocelot, int port,
> > > +				     unsigned long *supported,
> > > +				     struct phylink_link_state *state)
> > > +{
> > > +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> > > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = {
> > > +		0,
> > > +	};
> > 
> > This function seems out of place. Why would SPI access change what the
> > ports are capable of doing? Please split this up into more
> > patches. Keep the focus of this patch as being adding SPI support.
> 
> What is going on is that this is just the way in which the drivers are
> structured. Colin is not really "adding SPI support" to any of the
> existing DSA switches that are supported (VSC9953, VSC9959) as much as
> "adding support for a new switch which happens to be controlled over
> SPI" (VSC7512).

Note that this should not only be about vsc7512 as the whole ocelot
family (vsc7511, vsc7512, vsc7513 and vsc7514) can be connected over
spi. Also, they can all be used in a DSA configuration, over PCIe, just
like Felix.

> The layering is as follows:
> - drivers/net/dsa/ocelot/felix_vsc7512_spi.c: deals with the most
>   hardware specific SoC support. The regmap is defined here, so are the
>   port capabilities.
> - drivers/net/dsa/ocelot/felix.c: common integration with DSA
> - drivers/net/ethernet/mscc/ocelot*.c: the SoC-independent hardware
>   support.
> 
> I'm not actually sure that splitting the port PHY mode support in a
> separate patch is possible while keeping functional intermediate
> results. But I do agree about the rest, splitting the device tree
> changes, etc.

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
