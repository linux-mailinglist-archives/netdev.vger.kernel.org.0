Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FC91AE3B7
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgDQRVO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Apr 2020 13:21:14 -0400
Received: from mailoutvs59.siol.net ([185.57.226.250]:40114 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728863AbgDQRVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 13:21:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id 99F9D524C3A;
        Fri, 17 Apr 2020 19:15:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at psrvmta09.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta09.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id b6KrGSb_97M0; Fri, 17 Apr 2020 19:15:13 +0200 (CEST)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id AF4AA524C39;
        Fri, 17 Apr 2020 19:15:13 +0200 (CEST)
Received: from jernej-laptop.localnet (cpe-194-152-20-232.static.triera.net [194.152.20.232])
        (Authenticated sender: jernej.skrabec@siol.net)
        by mail.siol.net (Postfix) with ESMTPA id DD577524C3B;
        Fri, 17 Apr 2020 19:15:12 +0200 (CEST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@siol.net>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] net: phy: Add support for AC200 EPHY
Date:   Fri, 17 Apr 2020 19:15:12 +0200
Message-ID: <4409454.rnE6jSC6OK@jernej-laptop>
In-Reply-To: <1d03b2a8-fed5-5de8-6326-81b7436637da@gmail.com>
References: <20200416185758.1388148-1-jernej.skrabec@siol.net> <3035405.oiGErgHkdL@jernej-laptop> <1d03b2a8-fed5-5de8-6326-81b7436637da@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne petek, 17. april 2020 ob 18:29:04 CEST je Heiner Kallweit napisal(a):
> On 17.04.2020 18:03, Jernej Škrabec wrote:
> > Dne četrtek, 16. april 2020 ob 22:18:52 CEST je Heiner Kallweit 
napisal(a):
> >> On 16.04.2020 20:57, Jernej Skrabec wrote:
> >>> AC200 MFD IC supports Fast Ethernet PHY. Add a driver for it.
> >>> 
> >>> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> >>> ---
> >>> 
> >>>  drivers/net/phy/Kconfig  |   7 ++
> >>>  drivers/net/phy/Makefile |   1 +
> >>>  drivers/net/phy/ac200.c  | 206 +++++++++++++++++++++++++++++++++++++++
> >>>  3 files changed, 214 insertions(+)
> >>>  create mode 100644 drivers/net/phy/ac200.c
> >>> 
> >>> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> >>> index 3fa33d27eeba..16af69f69eaf 100644
> >>> --- a/drivers/net/phy/Kconfig
> >>> +++ b/drivers/net/phy/Kconfig
> >>> @@ -288,6 +288,13 @@ config ADIN_PHY
> >>> 
> >>>  	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
> >>>  	  
> >>>  	    Ethernet PHY
> >>> 
> >>> +config AC200_PHY
> >>> +	tristate "AC200 EPHY"
> >>> +	depends on NVMEM
> >>> +	depends on OF
> >>> +	help
> >>> +	  Fast ethernet PHY as found in X-Powers AC200 multi-function
> > 
> > device.
> > 
> >>> +
> >>> 
> >>>  config AMD_PHY
> >>>  
> >>>  	tristate "AMD PHYs"
> >>>  	---help---
> >>> 
> >>> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> >>> index 2f5c7093a65b..b0c5b91900fa 100644
> >>> --- a/drivers/net/phy/Makefile
> >>> +++ b/drivers/net/phy/Makefile
> >>> @@ -53,6 +53,7 @@ obj-$(CONFIG_SFP)		+= sfp.o
> >>> 
> >>>  sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
> >>>  obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
> >>> 
> >>> +obj-$(CONFIG_AC200_PHY)		+= ac200.o
> >>> 
> >>>  obj-$(CONFIG_ADIN_PHY)		+= adin.o
> >>>  obj-$(CONFIG_AMD_PHY)		+= amd.o
> >>>  aquantia-objs			+= aquantia_main.o
> >>> 
> >>> diff --git a/drivers/net/phy/ac200.c b/drivers/net/phy/ac200.c
> >>> new file mode 100644
> >>> index 000000000000..3d7856ff8f91
> >>> --- /dev/null
> >>> +++ b/drivers/net/phy/ac200.c
> >>> @@ -0,0 +1,206 @@
> >>> +// SPDX-License-Identifier: GPL-2.0+
> >>> +/**
> >>> + * Driver for AC200 Ethernet PHY
> >>> + *
> >>> + * Copyright (c) 2020 Jernej Skrabec <jernej.skrabec@siol.net>
> >>> + */
> >>> +
> >>> +#include <linux/kernel.h>
> >>> +#include <linux/module.h>
> >>> +#include <linux/mfd/ac200.h>
> >>> +#include <linux/nvmem-consumer.h>
> >>> +#include <linux/of.h>
> >>> +#include <linux/phy.h>
> >>> +#include <linux/platform_device.h>
> >>> +
> >>> +#define AC200_EPHY_ID			0x00441400
> >>> +#define AC200_EPHY_ID_MASK		0x0ffffff0
> >>> +
> >> 
> >> You could use PHY_ID_MATCH_MODEL() here.
> > 
> > Ok.
> > 
> >>> +/* macros for system ephy control 0 register */
> >>> +#define AC200_EPHY_RESET_INVALID	BIT(0)
> >>> +#define AC200_EPHY_SYSCLK_GATING	BIT(1)
> >>> +
> >>> +/* macros for system ephy control 1 register */
> >>> +#define AC200_EPHY_E_EPHY_MII_IO_EN	BIT(0)
> >>> +#define AC200_EPHY_E_LNK_LED_IO_EN	BIT(1)
> >>> +#define AC200_EPHY_E_SPD_LED_IO_EN	BIT(2)
> >>> +#define AC200_EPHY_E_DPX_LED_IO_EN	BIT(3)
> >>> +
> >>> +/* macros for ephy control register */
> >>> +#define AC200_EPHY_SHUTDOWN		BIT(0)
> >>> +#define AC200_EPHY_LED_POL		BIT(1)
> >>> +#define AC200_EPHY_CLK_SEL		BIT(2)
> >>> +#define AC200_EPHY_ADDR(x)		(((x) & 0x1F) << 4)
> >>> +#define AC200_EPHY_XMII_SEL		BIT(11)
> >>> +#define AC200_EPHY_CALIB(x)		(((x) & 0xF) << 12)
> >>> +
> >>> +struct ac200_ephy_dev {
> >>> +	struct phy_driver	*ephy;
> >> 
> >> Why embedding a pointer and not a struct phy_driver directly?
> >> Then you could omit the separate allocation.
> > 
> > Right.
> > 
> >> ephy is not the best naming. It may be read as a phy_device.
> >> Better use phydrv.
> > 
> > Ok.
> > 
> >>> +	struct regmap		*regmap;
> >>> +};
> >>> +
> >>> +static char *ac200_phy_name = "AC200 EPHY";
> >>> +
> >> 
> >> Why not using the name directly in the assignment?
> > 
> > phy_driver->name is pointer. Wouldn't that mean that string is allocated
> > on
> > stack and next time pointer is used, it will return garbage?
> 
> No, it's not on the stack. No problem here.
> 
> >> And better naming: "AC200 Fast Ethernet"
> > 
> > Ok.
> > 
> >>> +static int ac200_ephy_config_init(struct phy_device *phydev)
> >>> +{
> >>> +	const struct ac200_ephy_dev *priv = phydev->drv->driver_data;
> >>> +	unsigned int value;
> >>> +	int ret;
> >>> +
> >>> +	phy_write(phydev, 0x1f, 0x0100);	/* Switch to Page 1 */
> >>> +	phy_write(phydev, 0x12, 0x4824);	/* Disable APS */
> >>> +
> >>> +	phy_write(phydev, 0x1f, 0x0200);	/* Switch to Page 2 */
> >>> +	phy_write(phydev, 0x18, 0x0000);	/* PHYAFE TRX optimization */
> >>> +
> >>> +	phy_write(phydev, 0x1f, 0x0600);	/* Switch to Page 6 */
> >>> +	phy_write(phydev, 0x14, 0x708f);	/* PHYAFE TX optimization */
> >>> +	phy_write(phydev, 0x13, 0xF000);	/* PHYAFE RX optimization */
> >>> +	phy_write(phydev, 0x15, 0x1530);
> >>> +
> >>> +	phy_write(phydev, 0x1f, 0x0800);	/* Switch to Page 6 */
> >>> +	phy_write(phydev, 0x18, 0x00bc);	/* PHYAFE TRX optimization */
> >>> +
> >>> +	phy_write(phydev, 0x1f, 0x0100);	/* switch to page 1 */
> >>> +	phy_clear_bits(phydev, 0x17, BIT(3));	/* disable intelligent
> > 
> > IEEE */
> > 
> >>> +
> >>> +	/* next two blocks disable 802.3az IEEE */
> >>> +	phy_write(phydev, 0x1f, 0x0200);	/* switch to page 2 */
> >>> +	phy_write(phydev, 0x18, 0x0000);
> >>> +
> >>> +	phy_write(phydev, 0x1f, 0x0000);	/* switch to page 0 */
> >>> +	phy_clear_bits_mmd(phydev, 0x7, 0x3c, BIT(1));
> >> 
> >> Better use the following:
> >> phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0000);
> >> It makes clear that you disable advertising EEE completely.
> > 
> > Ok.
> > 
> >>> +
> >>> +	if (phydev->interface == PHY_INTERFACE_MODE_RMII)
> >>> +		value = AC200_EPHY_XMII_SEL;
> >>> +	else
> >>> +		value = 0;
> >>> +
> >>> +	ret = regmap_update_bits(priv->regmap, AC200_EPHY_CTL,
> >>> +				 AC200_EPHY_XMII_SEL, value);
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >> 
> >> I had a brief look at the spec, and it's not fully clear
> >> to me what this register setting does. Does it affect the
> >> MAC side and/or the PHY side?
> > 
> > It's my understanding that it selects interface mode on PHY. Besides
> > datasheet mentioned in cover letter, BSP drivers (one for MFD and one for
> > PHY) are the only other source of information. BSP PHY driver is located
> > here:
> > https://github.com/Allwinner-Homlet/H6-BSP4.9-linux/blob/master/drivers/ne
> > t/ phy/sunxi-ephy.c
> > 
> >> If it affects the PHY side, then I'd expect that the chip
> >> has to talk to the PHY via the MDIO bus. Means there should
> >> be a PHY register for setting MII vs. RMII.
> >> In this case the setup could be very much simplified.
> >> Then the PHY driver wouldn't have to be embedded in the
> >> platform driver.
> > 
> > Actually, PHY has to be configured first through I2C and then through
> > MDIO. I2C is used to enable it (power it up), configure LED polarity, set
> > PHY address, write calibration value stored elsewhere.
> > 
> > Based on all available documentation I have (code and datasheet), this I2C
> > register is the only way to select MII or RMII mode.
> 
> Then how and where is the PHY interface mode configured on the MAC side?
> If there is no such setting, then I'd assume that this register bit
> configures both sides. This leads to the question whether the interface
> mode really needs to be set in the PHY driver's config_init().
> If we could avoid this, then you could make the PHY driver static.

Check patch 4. There is emac node added with property phy-mode = "rmii"; 
AC200 and H6 are internally connected through RMII interface.

Note that MAC has multiplexed interface and can either uses this copackaged 
PHY or external PHY. External PHY usually uses RGMII interface.

In 99% cases, this PHY driver will be used for copackaged AC200 with H6 SoC, 
which means it will be used in RMII mode. Even if someone uses standalone 
AC200 IC with mainline Linux, will probably still use RMII. But there is still 
very small chance that someone will use it in MII mode.

Anyway, if that special setting for H6 proves important, we will still need a 
way to convey that information from platform driver to PHY. Easiest way to do 
that is through driver_data.

> 
> You could set the PHY interface mode as soon as the PHY interface mode
> is read from DT. So why not set the interface mode at the place where
> you configure the other values like PHY address?

PHY interface mode is actually set on MAC side in DT. This PHY has acutally 
programmable PHY address through I2C. Currently I hardcoded it to 1.

As I explained in cover letter, I don't really know how to properly present 
this device in DT. Based on current DT documentation, PHY node would have to 
be child node of mdio bus node and MFD node at the same time which is not 
possible.

> 
> >>> +	/* FIXME: This is H6 specific */
> >>> +	phy_set_bits(phydev, 0x13, BIT(12));
> >>> +
> >> 
> >> This seems to indicate that the same PHY is used in a slightly
> >> different version with other Hx models. Do they use different
> >> PHY ID's?
> > 
> > Situation is a bit complicated. Same PHY, at least with same PHY ID, is
> > used in different ways.
> > 1. as part of standalone AC200 MFD IC
> > 2. as part of AC200 wafer copackaged with H6 SoC wafer in same package.
> > This in theory shouldn't be any different than standalone IC, but it
> > apparently is, based on the BSP driver code.
> > 3. integrated directly in SoCs like H3, H5 and V3s. There is no I2C access
> > to configuration register. Instead, it's memory mapped and slightly
> > different.
> > 
> > In all cases PHY ID is same, just glue logic is different.
> > 
> > I asked Allwinner if above setting is really necessary for H6 and what it
> > does, but I didn't get any useful answer back.
> > 
> > So maybe another compatible is needed for H6.
> > 
> > Best regards,
> > Jernej
> > 
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int ac200_ephy_probe(struct platform_device *pdev)
> >>> +{
> >>> +	struct ac200_dev *ac200 = dev_get_drvdata(pdev->dev.parent);
> >>> +	struct device *dev = &pdev->dev;
> >>> +	struct ac200_ephy_dev *priv;
> >>> +	struct nvmem_cell *calcell;
> >>> +	struct phy_driver *ephy;
> >>> +	u16 *caldata, calib;
> >>> +	size_t callen;
> >>> +	int ret;
> >>> +
> >>> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> >>> +	if (!priv)
> >>> +		return -ENOMEM;
> >>> +
> >>> +	ephy = devm_kzalloc(dev, sizeof(*ephy), GFP_KERNEL);
> >>> +	if (!ephy)
> >>> +		return -ENOMEM;
> >>> +
> >>> +	calcell = devm_nvmem_cell_get(dev, "calibration");
> >>> +	if (IS_ERR(calcell)) {
> >>> +		dev_err(dev, "Unable to find calibration data!\n");
> >>> +		return PTR_ERR(calcell);
> >>> +	}
> >>> +
> >>> +	caldata = nvmem_cell_read(calcell, &callen);
> >>> +	if (IS_ERR(caldata)) {
> >>> +		dev_err(dev, "Unable to read calibration data!\n");
> >>> +		return PTR_ERR(caldata);
> >>> +	}
> >>> +
> >>> +	if (callen != 2) {
> >>> +		dev_err(dev, "Calibration data has wrong length: 2 !=
> > 
> > %zu\n",
> > 
> >>> +			callen);
> >>> +		kfree(caldata);
> >>> +		return -EINVAL;
> >>> +	}
> >>> +
> >>> +	calib = *caldata + 3;
> >>> +	kfree(caldata);
> >>> +
> >>> +	ephy->phy_id = AC200_EPHY_ID;
> >>> +	ephy->phy_id_mask = AC200_EPHY_ID_MASK;
> >>> +	ephy->name = ac200_phy_name;
> >>> +	ephy->driver_data = priv;
> >>> +	ephy->soft_reset = genphy_soft_reset;
> >>> +	ephy->config_init = ac200_ephy_config_init;
> >>> +	ephy->suspend = genphy_suspend;
> >>> +	ephy->resume = genphy_resume;
> >>> +
> >>> +	priv->ephy = ephy;
> >>> +	priv->regmap = ac200->regmap;
> >>> +	platform_set_drvdata(pdev, priv);
> >>> +
> >>> +	ret = regmap_write(ac200->regmap, AC200_SYS_EPHY_CTL0,
> >>> +			   AC200_EPHY_RESET_INVALID |
> >>> +			   AC200_EPHY_SYSCLK_GATING);
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >>> +	ret = regmap_write(ac200->regmap, AC200_SYS_EPHY_CTL1,
> >>> +			   AC200_EPHY_E_EPHY_MII_IO_EN |
> >>> +			   AC200_EPHY_E_LNK_LED_IO_EN |
> >>> +			   AC200_EPHY_E_SPD_LED_IO_EN |
> >>> +			   AC200_EPHY_E_DPX_LED_IO_EN);
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >>> +	ret = regmap_write(ac200->regmap, AC200_EPHY_CTL,
> >>> +			   AC200_EPHY_LED_POL |
> >>> +			   AC200_EPHY_CLK_SEL |
> >>> +			   AC200_EPHY_ADDR(1) |
> >>> +			   AC200_EPHY_CALIB(calib));
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >>> +	ret = phy_driver_register(priv->ephy, THIS_MODULE);
> >>> +	if (ret) {
> >>> +		dev_err(dev, "Unable to register phy\n");
> >>> +		return ret;
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int ac200_ephy_remove(struct platform_device *pdev)
> >>> +{
> >>> +	struct ac200_ephy_dev *priv = platform_get_drvdata(pdev);
> >>> +
> >>> +	phy_driver_unregister(priv->ephy);
> >>> +
> >>> +	regmap_write(priv->regmap, AC200_EPHY_CTL, AC200_EPHY_SHUTDOWN);
> >>> +	regmap_write(priv->regmap, AC200_SYS_EPHY_CTL1, 0);
> >>> +	regmap_write(priv->regmap, AC200_SYS_EPHY_CTL0, 0);
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static const struct of_device_id ac200_ephy_match[] = {
> >>> +	{ .compatible = "x-powers,ac200-ephy" },
> >>> +	{ /* sentinel */ }
> >>> +};
> >>> +MODULE_DEVICE_TABLE(of, ac200_ephy_match);
> >>> +
> >>> +static struct platform_driver ac200_ephy_driver = {
> >>> +	.probe		= ac200_ephy_probe,
> >>> +	.remove		= ac200_ephy_remove,
> >>> +	.driver		= {
> >>> +		.name		= "ac200-ephy",
> >>> +		.of_match_table	= ac200_ephy_match,
> >>> +	},
> >>> +};
> >>> +module_platform_driver(ac200_ephy_driver);
> >>> +
> >>> +MODULE_AUTHOR("Jernej Skrabec <jernej.skrabec@siol.net>");
> >>> +MODULE_DESCRIPTION("AC200 Ethernet PHY driver");
> >>> +MODULE_LICENSE("GPL");




