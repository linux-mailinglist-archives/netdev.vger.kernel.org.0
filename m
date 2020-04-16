Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA021AB9E8
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 09:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439280AbgDPH2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 03:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439264AbgDPH2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 03:28:05 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF201206D5;
        Thu, 16 Apr 2020 07:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587022084;
        bh=w+nPkuKj2fNBoyAqj0+LVj5YRJnCBFYLxnu4z9r5o3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p/+FaYsXXVpQvawW/bB5pBeFg94y8wvi68MZpusiUD9zf/VTvB/hqDWPT24gpNdlC
         XDOTiQSFGQKDR4FJnfTeqH9jU6xA5AfbuZM10qjcO4GVgrJFZrTPoxnBiaVw8VyHKK
         AUbK3qm9zutGjGBq1rIFNYoERjXWo70jPkwEChWo=
Date:   Thu, 16 Apr 2020 10:28:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v3 1/3] net: phy: mdio: add IPQ40xx MDIO driver
Message-ID: <20200416072801.GG1309273@unreal>
References: <20200415150244.2737206-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415150244.2737206-1-robert.marko@sartura.hr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 05:02:43PM +0200, Robert Marko wrote:
> This patch adds the driver for the MDIO interface
> inside of Qualcomm IPQ40xx series SoC-s.
>
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Cc: Luka Perkov <luka.perkov@sartura.hr>
> ---
> Changes from v2 to v3:
> * Rename registers
> * Remove unnecessary variable initialisations
> * Switch to readl_poll_timeout() instead of custom solution
> * Drop unused header
>
> Changes from v1 to v2:
> * Remove magic default value
> * Remove lockdep_assert_held
> * Add C45 check
> * Simplify the driver
> * Drop device and mii_bus structs from private struct
> * Use devm_mdiobus_alloc_size()
>
>  drivers/net/phy/Kconfig        |   7 ++
>  drivers/net/phy/Makefile       |   1 +
>  drivers/net/phy/mdio-ipq40xx.c | 160 +++++++++++++++++++++++++++++++++
>  3 files changed, 168 insertions(+)
>  create mode 100644 drivers/net/phy/mdio-ipq40xx.c
>
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 3fa33d27eeba..23bb5db033e3 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -157,6 +157,13 @@ config MDIO_I2C
>
>  	  This is library mode.
>
> +config MDIO_IPQ40XX
> +	tristate "Qualcomm IPQ40xx MDIO interface"
> +	depends on HAS_IOMEM && OF_MDIO
> +	help
> +	  This driver supports the MDIO interface found in Qualcomm
> +	  IPQ40xx series Soc-s.
> +
>  config MDIO_IPQ8064
>  	tristate "Qualcomm IPQ8064 MDIO interface support"
>  	depends on HAS_IOMEM && OF_MDIO
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index 2f5c7093a65b..36aafc6128c4 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -37,6 +37,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
>  obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
>  obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
>  obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
> +obj-$(CONFIG_MDIO_IPQ40XX)	+= mdio-ipq40xx.o
>  obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
>  obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
>  obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
> diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
> new file mode 100644
> index 000000000000..acf1230341bd
> --- /dev/null
> +++ b/drivers/net/phy/mdio-ipq40xx.c
> @@ -0,0 +1,160 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
> +/* Copyright (c) 2020 Sartura Ltd. */
> +
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/of_address.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +
> +#define MDIO_ADDR_REG				0x44
> +#define MDIO_DATA_WRITE_REG			0x48
> +#define MDIO_DATA_READ_REG			0x4c
> +#define MDIO_CMD_REG				0x50
> +#define MDIO_CMD_ACCESS_BUSY		BIT(16)
> +#define MDIO_CMD_ACCESS_START		BIT(8)
> +#define MDIO_CMD_ACCESS_CODE_READ	0
> +#define MDIO_CMD_ACCESS_CODE_WRITE	1
> +
> +#define IPQ40XX_MDIO_TIMEOUT	10000
> +#define IPQ40XX_MDIO_SLEEP		10
> +
> +struct ipq40xx_mdio_data {
> +	void __iomem	*membase;
> +};
> +
> +static int ipq40xx_mdio_wait_busy(struct mii_bus *bus)
> +{
> +	struct ipq40xx_mdio_data *priv = bus->priv;
> +	unsigned int busy;
> +
> +	return readl_poll_timeout(priv->membase + MDIO_CMD_REG, busy,
> +				  (busy & MDIO_CMD_ACCESS_BUSY) == 0,
> +				  IPQ40XX_MDIO_SLEEP, IPQ40XX_MDIO_TIMEOUT);
> +}
> +
> +static int ipq40xx_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> +{
> +	struct ipq40xx_mdio_data *priv = bus->priv;
> +	unsigned int cmd;
> +
> +	/* Reject clause 45 */
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	if (ipq40xx_mdio_wait_busy(bus))
> +		return -ETIMEDOUT;
> +
> +	/* issue the phy address and reg */
> +	writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
> +
> +	cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_READ;
> +
> +	/* issue read command */
> +	writel(cmd, priv->membase + MDIO_CMD_REG);
> +
> +	/* Wait read complete */
> +	if (ipq40xx_mdio_wait_busy(bus))
> +		return -ETIMEDOUT;
> +
> +	/* Read and return data */
> +	return readl(priv->membase + MDIO_DATA_READ_REG);
> +}
> +
> +static int ipq40xx_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> +							 u16 value)
> +{
> +	struct ipq40xx_mdio_data *priv = bus->priv;
> +	unsigned int cmd;
> +
> +	/* Reject clause 45 */
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	if (ipq40xx_mdio_wait_busy(bus))
> +		return -ETIMEDOUT;
> +
> +	/* issue the phy address and reg */
> +	writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
> +
> +	/* issue write data */
> +	writel(value, priv->membase + MDIO_DATA_WRITE_REG);
> +
> +	cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_WRITE;
> +	/* issue write command */
> +	writel(cmd, priv->membase + MDIO_CMD_REG);
> +
> +	/* Wait write complete */
> +	if (ipq40xx_mdio_wait_busy(bus))
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +static int ipq40xx_mdio_probe(struct platform_device *pdev)
> +{
> +	struct ipq40xx_mdio_data *priv;
> +	struct mii_bus *bus;
> +	int ret;
> +
> +	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	priv = bus->priv;
> +
> +	priv->membase = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(priv->membase))
> +		return PTR_ERR(priv->membase);
> +
> +	bus->name = "ipq40xx_mdio";
> +	bus->read = ipq40xx_mdio_read;
> +	bus->write = ipq40xx_mdio_write;
> +	bus->parent = &pdev->dev;
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s%d", pdev->name, pdev->id);
> +
> +	ret = of_mdiobus_register(bus, pdev->dev.of_node);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot register MDIO bus!\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, bus);
> +
> +	return 0;
> +}
> +
> +static int ipq40xx_mdio_remove(struct platform_device *pdev)
> +{
> +	struct mii_bus *bus = platform_get_drvdata(pdev);
> +
> +	mdiobus_unregister(bus);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ipq40xx_mdio_dt_ids[] = {
> +	{ .compatible = "qcom,ipq40xx-mdio" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ipq40xx_mdio_dt_ids);
> +
> +static struct platform_driver ipq40xx_mdio_driver = {
> +	.probe = ipq40xx_mdio_probe,
> +	.remove = ipq40xx_mdio_remove,
> +	.driver = {
> +		.name = "ipq40xx-mdio",
> +		.of_match_table = ipq40xx_mdio_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(ipq40xx_mdio_driver);
> +
> +MODULE_DESCRIPTION("IPQ40XX MDIO interface driver");
> +MODULE_AUTHOR("Qualcomm Atheros");

Strictly saying, but author can't be company.

> +MODULE_LICENSE("Dual BSD/GPL");
> --
> 2.26.0
>
