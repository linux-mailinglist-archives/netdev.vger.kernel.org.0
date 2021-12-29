Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF64948165E
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhL2Teu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 14:34:50 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:49523 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhL2Teu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 14:34:50 -0500
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 182BC20002;
        Wed, 29 Dec 2021 19:34:44 +0000 (UTC)
Date:   Wed, 29 Dec 2021 20:34:44 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        clement.leger@bootlin.com
Subject: Re: [RFC v5 net-next 02/13] mfd: ocelot: offer an interface for MFD
 children to get regmaps
Message-ID: <Ycy4VPy+XVgYmfeg@piout.net>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-3-colin.foster@in-advantage.com>
 <Ycx9j3bflcTGsb7b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ycx9j3bflcTGsb7b@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Lee,

On 29/12/2021 15:23:59+0000, Lee Jones wrote:
> On Sat, 18 Dec 2021, Colin Foster wrote:
> 
> > Child devices need to get a regmap from a resource struct, specifically
> > from the MFD parent. The MFD parent has the interface to the hardware
> > layer, which could be I2C, SPI, PCIe, etc.
> > 
> > This is somewhat a hack... ideally child devices would interface with the
> > struct device* directly, by way of a function like
> > devm_get_regmap_from_resource which would be akin to
> > devm_get_and_ioremap_resource. A less ideal option would be to interface
> > directly with MFD to get a regmap from the parent.
> > 
> > This solution is even less ideal than both of the two suggestions, so is
> > intentionally left in a separate commit after the initial MFD addition.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/ocelot-core.c |  9 +++++++++
> >  include/soc/mscc/ocelot.h | 12 ++++++++++++
> >  2 files changed, 21 insertions(+)
> > 
> > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > index a65619a8190b..09132ea52760 100644
> > --- a/drivers/mfd/ocelot-core.c
> > +++ b/drivers/mfd/ocelot-core.c
> > @@ -94,6 +94,15 @@ static struct regmap *ocelot_mfd_regmap_init(struct ocelot_mfd_core *core,
> >  	return regmap;
> >  }
> >  
> > +struct regmap *ocelot_mfd_get_regmap_from_resource(struct device *dev,
> > +						   const struct resource *res)
> > +{
> > +	struct ocelot_mfd_core *core = dev_get_drvdata(dev);
> > +
> > +	return ocelot_mfd_regmap_init(core, res);
> > +}
> > +EXPORT_SYMBOL(ocelot_mfd_get_regmap_from_resource);
> 
> This is almost certainly not the right way to do whatever it is you're
> trying to do!
> 
> Please don't try to upstream "somewhat a hack"s into the Mainline
> kernel.
> 

Please elaborate on the correct way to do that. What we have here is a
SoC (vsc7514) that has MMIO devices. This SoC has a MIPS CPU and
everything is fine when using it. However, the CPU can be disabled and
the SoC connected to another CPU using SPI or PCIe. What Colin is doing
here is using this SoC over SPI. Don't tell me this is not an MFD
because this is exactly what this is, a single chip with a collection of
devices that are also available separately.

The various drivers for the VSC7514 have been written using regmap
exactly for this use case. The missing piece is probing the devices over
SPI instead of MMIO.

Notice that all of that gets worse when using PCIe on architectures that
don't have device tree support and Clément will submit multiple series
trying to fix that.

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
