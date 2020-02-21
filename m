Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E16167F50
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 14:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgBUNxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 08:53:44 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49246 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgBUNxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 08:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9eeBha9lPzAUV3NjBfsVhaOkGKArfI3EhMei1YyTe9A=; b=GvFv+6I9mh2IpGMQ3I1ucTbN8
        jhVvZPRcwWcMwxeN+EHWcVUV/jvwJgyMr/nsEFGFCDv2dZR5NA++oCZT3aBYl1MDMF0Ov3vOZHrQ8
        cEeTXXmalcF6gmioN9dl+IeJRU0KHVLSyDTBqS12O9zGpBQlLcdCYOLpjXE53e0g7H+0ORLwOU6ol
        IdCVYS3vf7eih0vxVorORZ1HTFvVz/c70vlfcw5yVpPMuHkyS1sgw46NPIqiRsPFKOeQsVUqqELs5
        EEJMnj8NuIF6Nws2d6axD522Wu9FEgmGkM31ZFZuVGs2a/afwcQwi0wE42nuQlQqPUHyiCl1KXQk+
        XiQb93HxA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54994)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j58kE-0001Za-6P; Fri, 21 Feb 2020 13:53:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j58kA-0003YG-1R; Fri, 21 Feb 2020 13:53:26 +0000
Date:   Fri, 21 Feb 2020 13:53:26 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] net: mdio: add ipq8064 mdio driver
Message-ID: <20200221135325.GI25745@shell.armlinux.org.uk>
References: <20200221132834.20719-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221132834.20719-1-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 02:28:31PM +0100, Ansuel Smith wrote:
> Currently ipq806x soc use generi bitbang driver to
> comunicate with the gmac ethernet interface.
> Add a dedicated driver created by chunkeey to fix this.
> 
> Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/phy/Kconfig        |   8 ++
>  drivers/net/phy/Makefile       |   1 +
>  drivers/net/phy/mdio-ipq8064.c | 166 +++++++++++++++++++++++++++++++++
>  3 files changed, 175 insertions(+)
>  create mode 100644 drivers/net/phy/mdio-ipq8064.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 9dabe03a668c..ec2a5493a7e8 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -157,6 +157,14 @@ config MDIO_I2C
>  
>  	  This is library mode.
>  
> +config MDIO_IPQ8064
> +	tristate "Qualcomm IPQ8064 MDIO interface support"
> +	depends on HAS_IOMEM && OF_MDIO
> +	depends on MFD_SYSCON
> +	help
> +	  This driver supports the MDIO interface found in the network
> +	  interface units of the IPQ8064 SoC
> +
>  config MDIO_MOXART
>  	tristate "MOXA ART MDIO interface support"
>  	depends on ARCH_MOXART || COMPILE_TEST
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index fe5badf13b65..8f02bd2089f3 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
>  obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
>  obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
>  obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
> +obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
>  obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
>  obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
>  obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
> diff --git a/drivers/net/phy/mdio-ipq8064.c b/drivers/net/phy/mdio-ipq8064.c
> new file mode 100644
> index 000000000000..fd856b798194
> --- /dev/null
> +++ b/drivers/net/phy/mdio-ipq8064.c
> @@ -0,0 +1,166 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//
> +// Qualcomm IPQ8064 MDIO interface driver
> +//
> +// Copyright (C) 2019 Christian Lamparter <chunkeey@gmail.com>
> +
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/syscon.h>
> +
> +/* MII address register definitions */
> +#define MII_ADDR_REG_ADDR                       0x10
> +#define MII_BUSY                                BIT(0)
> +#define MII_WRITE                               BIT(1)
> +#define MII_CLKRANGE_60_100M                    (0 << 2)
> +#define MII_CLKRANGE_100_150M                   (1 << 2)
> +#define MII_CLKRANGE_20_35M                     (2 << 2)
> +#define MII_CLKRANGE_35_60M                     (3 << 2)
> +#define MII_CLKRANGE_150_250M                   (4 << 2)
> +#define MII_CLKRANGE_250_300M                   (5 << 2)
> +#define MII_CLKRANGE_MASK			GENMASK(4, 2)
> +#define MII_REG_SHIFT				6
> +#define MII_REG_MASK				GENMASK(10, 6)
> +#define MII_ADDR_SHIFT				11
> +#define MII_ADDR_MASK				GENMASK(15, 11)
> +
> +#define MII_DATA_REG_ADDR                       0x14
> +
> +#define MII_MDIO_DELAY                          (1000)
> +#define MII_MDIO_RETRY                          (10)

You've missed my comments on these.

> +
> +struct ipq8064_mdio {
> +	struct regmap *base; /* NSS_GMAC0_BASE */
> +};
> +
> +static int
> +ipq8064_mdio_wait_busy(struct ipq8064_mdio *priv)
> +{
> +	u32 busy;
> +
> +	return regmap_read_poll_timeout(priv->base, MII_ADDR_REG_ADDR, busy,
> +				   !(busy & MII_BUSY), MII_MDIO_DELAY,
> +				   MII_MDIO_RETRY * USEC_PER_MSEC);
> +}
> +
> +static int
> +ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
> +{
> +	struct ipq8064_mdio *priv = bus->priv;
> +	u32 miiaddr = MII_BUSY | MII_CLKRANGE_250_300M;
> +	u32 ret_val;
> +	int err;
> +
> +	/* Reject clause 45 */
> +	if (reg_offset & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
> +		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> +
> +	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> +	usleep_range(10, 20);
> +
> +	err = ipq8064_mdio_wait_busy(priv);
> +	if (err)
> +		return err;
> +
> +	regmap_read(priv->base, MII_DATA_REG_ADDR, &ret_val);
> +	return (int)ret_val;
> +}
> +
> +static int
> +ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
> +{
> +	struct ipq8064_mdio *priv = bus->priv;
> +	u32 miiaddr = MII_WRITE | MII_BUSY | MII_CLKRANGE_250_300M;
> +
> +	/* Reject clause 45 */
> +	if (reg_offset & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	regmap_write(priv->base, MII_DATA_REG_ADDR, data);
> +
> +	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
> +		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> +
> +	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> +	usleep_range(10, 20);
> +
> +	return ipq8064_mdio_wait_busy(priv);
> +}
> +
> +static int
> +ipq8064_mdio_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct ipq8064_mdio *priv;
> +	struct mii_bus *bus;
> +	int ret;
> +
> +	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	bus->name = "ipq8064_mdio_bus";
> +	bus->read = ipq8064_mdio_read;
> +	bus->write = ipq8064_mdio_write;
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
> +	bus->parent = &pdev->dev;
> +
> +	priv = bus->priv;
> +	priv->base = syscon_node_to_regmap(np);
> +	if (IS_ERR(priv->base) && priv->base != ERR_PTR(-EPROBE_DEFER))
> +		priv->base = syscon_regmap_lookup_by_phandle(np, "master");
> +
> +	if (priv->base == ERR_PTR(-EPROBE_DEFER)) {
> +		return -EPROBE_DEFER;
> +	} else if (IS_ERR(priv->base)) {
> +		dev_err(&pdev->dev, "error getting syscon regmap, error=%ld\n",
> +			PTR_ERR(priv->base));

Why not %pe as I suggested, which is documented in printk-formats to
optionally give a symbolic error string.

> +		return PTR_ERR(priv->base);
> +	}

And have you even tested the above - you haven't said whether you have
or not...

> +
> +	ret = of_mdiobus_register(bus, np);
> +	if (ret)
> +		return ret;
> +
> +	platform_set_drvdata(pdev, bus);
> +	return 0;
> +}
> +
> +static int
> +ipq8064_mdio_remove(struct platform_device *pdev)
> +{
> +	struct mii_bus *bus = platform_get_drvdata(pdev);
> +
> +	mdiobus_unregister(bus);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ipq8064_mdio_dt_ids[] = {
> +	{ .compatible = "qcom,ipq8064-mdio" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ipq8064_mdio_dt_ids);
> +
> +static struct platform_driver ipq8064_mdio_driver = {
> +	.probe = ipq8064_mdio_probe,
> +	.remove = ipq8064_mdio_remove,
> +	.driver = {
> +		.name = "ipq8064-mdio",
> +		.of_match_table = ipq8064_mdio_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(ipq8064_mdio_driver);
> +
> +MODULE_DESCRIPTION("Qualcomm IPQ8064 MDIO interface driver");
> +MODULE_AUTHOR("Christian Lamparter <chunkeey@gmail.com>");
> +MODULE_LICENSE("GPL");
> -- 
> 2.25.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
