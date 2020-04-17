Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B941AE056
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 17:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgDQPBt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Apr 2020 11:01:49 -0400
Received: from mailoutvs25.siol.net ([185.57.226.216]:45090 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726707AbgDQPBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 11:01:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id 3B421522A05;
        Fri, 17 Apr 2020 17:01:45 +0200 (CEST)
X-Virus-Scanned: amavisd-new at psrvmta09.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta09.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 35vgEkZzt6rN; Fri, 17 Apr 2020 17:01:44 +0200 (CEST)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id AAA5C5248A7;
        Fri, 17 Apr 2020 17:01:44 +0200 (CEST)
Received: from jernej-laptop.localnet (cpe-194-152-20-232.static.triera.net [194.152.20.232])
        (Authenticated sender: jernej.skrabec@siol.net)
        by mail.siol.net (Postfix) with ESMTPA id 5BE3F522A05;
        Fri, 17 Apr 2020 17:01:43 +0200 (CEST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@siol.net>
To:     robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] net: phy: Add support for AC200 EPHY
Date:   Fri, 17 Apr 2020 17:01:42 +0200
Message-ID: <2274555.jE0xQCEvom@jernej-laptop>
In-Reply-To: <5062b508-2c68-dc94-add2-038178667c9f@gmail.com>
References: <20200416185758.1388148-1-jernej.skrabec@siol.net> <20200416185758.1388148-3-jernej.skrabec@siol.net> <5062b508-2c68-dc94-add2-038178667c9f@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne četrtek, 16. april 2020 ob 21:18:29 CEST je Florian Fainelli napisal(a):
> On 4/16/2020 11:57 AM, Jernej Skrabec wrote:
> > AC200 MFD IC supports Fast Ethernet PHY. Add a driver for it.
> > 
> > Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> > ---
> > 
> >   drivers/net/phy/Kconfig  |   7 ++
> >   drivers/net/phy/Makefile |   1 +
> >   drivers/net/phy/ac200.c  | 206 +++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 214 insertions(+)
> >   create mode 100644 drivers/net/phy/ac200.c
> > 
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 3fa33d27eeba..16af69f69eaf 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -288,6 +288,13 @@ config ADIN_PHY
> > 
> >   	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
> >   	  
> >   	    Ethernet PHY
> > 
> > +config AC200_PHY
> > +	tristate "AC200 EPHY"
> > +	depends on NVMEM
> > +	depends on OF
> > +	help
> > +	  Fast ethernet PHY as found in X-Powers AC200 multi-function 
device.
> > +
> > 
> >   config AMD_PHY
> >   
> >   	tristate "AMD PHYs"
> >   	---help---
> > 
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index 2f5c7093a65b..b0c5b91900fa 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -53,6 +53,7 @@ obj-$(CONFIG_SFP)		+= sfp.o
> > 
> >   sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
> >   obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
> > 
> > +obj-$(CONFIG_AC200_PHY)		+= ac200.o
> > 
> >   obj-$(CONFIG_ADIN_PHY)		+= adin.o
> >   obj-$(CONFIG_AMD_PHY)		+= amd.o
> >   aquantia-objs			+= aquantia_main.o
> > 
> > diff --git a/drivers/net/phy/ac200.c b/drivers/net/phy/ac200.c
> > new file mode 100644
> > index 000000000000..3d7856ff8f91
> > --- /dev/null
> > +++ b/drivers/net/phy/ac200.c
> > @@ -0,0 +1,206 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/**
> > + * Driver for AC200 Ethernet PHY
> > + *
> > + * Copyright (c) 2020 Jernej Skrabec <jernej.skrabec@siol.net>
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/mfd/ac200.h>
> > +#include <linux/nvmem-consumer.h>
> > +#include <linux/of.h>
> > +#include <linux/phy.h>
> > +#include <linux/platform_device.h>
> > +
> > +#define AC200_EPHY_ID			0x00441400
> > +#define AC200_EPHY_ID_MASK		0x0ffffff0
> > +
> > +/* macros for system ephy control 0 register */
> > +#define AC200_EPHY_RESET_INVALID	BIT(0)
> > +#define AC200_EPHY_SYSCLK_GATING	BIT(1)
> > +
> > +/* macros for system ephy control 1 register */
> > +#define AC200_EPHY_E_EPHY_MII_IO_EN	BIT(0)
> > +#define AC200_EPHY_E_LNK_LED_IO_EN	BIT(1)
> > +#define AC200_EPHY_E_SPD_LED_IO_EN	BIT(2)
> > +#define AC200_EPHY_E_DPX_LED_IO_EN	BIT(3)
> > +
> > +/* macros for ephy control register */
> > +#define AC200_EPHY_SHUTDOWN		BIT(0)
> > +#define AC200_EPHY_LED_POL		BIT(1)
> > +#define AC200_EPHY_CLK_SEL		BIT(2)
> > +#define AC200_EPHY_ADDR(x)		(((x) & 0x1F) << 4)
> > +#define AC200_EPHY_XMII_SEL		BIT(11)
> > +#define AC200_EPHY_CALIB(x)		(((x) & 0xF) << 12)
> > +
> > +struct ac200_ephy_dev {
> > +	struct phy_driver	*ephy;
> > +	struct regmap		*regmap;
> > +};
> > +
> > +static char *ac200_phy_name = "AC200 EPHY";
> > +
> > +static int ac200_ephy_config_init(struct phy_device *phydev)
> > +{
> > +	const struct ac200_ephy_dev *priv = phydev->drv->driver_data;
> > +	unsigned int value;
> > +	int ret;
> > +
> > +	phy_write(phydev, 0x1f, 0x0100);	/* Switch to Page 1 */
> 
> You could define a macro for accessing the page and you may consider
> implementing .read_page and .write_page and use the
> phy_read_paged()/phy_write_paged() helper functions.

Yeah, I saw that, but they bring some overhead - there is no need to switch 
page back after write, because next write changes it anyway. But it will 
probably be more readable and it's done only once so overhead is acceptable.

> 
> > +	phy_write(phydev, 0x12, 0x4824);	/* Disable APS */
> > +
> > +	phy_write(phydev, 0x1f, 0x0200);	/* Switch to Page 2 */
> > +	phy_write(phydev, 0x18, 0x0000);	/* PHYAFE TRX optimization */
> > +
> > +	phy_write(phydev, 0x1f, 0x0600);	/* Switch to Page 6 */
> > +	phy_write(phydev, 0x14, 0x708f);	/* PHYAFE TX optimization */
> > +	phy_write(phydev, 0x13, 0xF000);	/* PHYAFE RX optimization */
> > +	phy_write(phydev, 0x15, 0x1530);
> > +
> > +	phy_write(phydev, 0x1f, 0x0800);	/* Switch to Page 6 */
> 
> Seems like the comment does not match the code, that should be Page 8, no?

Right, I copy that from BSP driver. If they made this copy and paste error, I 
wonder if all other comments are ok. I have no documentation about there 
registers.

> 
> > +	phy_write(phydev, 0x18, 0x00bc);	/* PHYAFE TRX optimization */
> > +
> > +	phy_write(phydev, 0x1f, 0x0100);	/* switch to page 1 */
> > +	phy_clear_bits(phydev, 0x17, BIT(3));	/* disable intelligent 
IEEE */
> 
> Intelligent EEE maybe?

Not sure. As I said before, I just copied comments from BSP driver:
https://github.com/Allwinner-Homlet/H6-BSP4.9-linux/blob/master/drivers/net/
phy/sunxi-ephy.c

This is my first take at ethernet phy drivers, so I don't really know if all 
comments above make sense.

Best regards,
Jernej




