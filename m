Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38191A6C24
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 20:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733060AbgDMSmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 14:42:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34690 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgDMSma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 14:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8e8HuFV0TGA3SZAvtjW3okIjD6ZadtQhQFCOyp+9cMM=; b=tDZBmoIpTl7imtNp7ZyIoz4CfS
        Wl/q3Vm0T+vfA94P9I+K9gpJ2G2DapV2etrMetKrRA+PuoKoSYhlgLqOPlX9jrFWGGWx/ANlZ2IVQ
        s/BSgP+sB5/TAukc20TyEfexZHf9fbiy3zx4kQZ7DCxvRI5AVMrYGM1kDXay8Q4CU74I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jO42G-002Uln-2m; Mon, 13 Apr 2020 20:42:20 +0200
Date:   Mon, 13 Apr 2020 20:42:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH 1/3] net: phy: mdio: add IPQ40xx MDIO driver
Message-ID: <20200413184219.GH557892@lunn.ch>
References: <20200413170107.246509-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413170107.246509-1-robert.marko@sartura.hr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
>  obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
>  obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
>  obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
> +obj-$(CONFIG_MDIO_IPQ40XX)	+= mdio-ipq40xx.o
>  obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
>  obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o

Hi Robert

That looks odd. What happened to the

obj-$(CONFIG_MDIO_IPQ8064)      += mdio-ipq8064.o

>  obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
> diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
> new file mode 100644
> index 000000000000..8068f1e6a077
> --- /dev/null
> +++ b/drivers/net/phy/mdio-ipq40xx.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
> +
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +
> +#define MDIO_CTRL_0_REG		0x40
> +#define MDIO_CTRL_1_REG		0x44
> +#define MDIO_CTRL_2_REG		0x48
> +#define MDIO_CTRL_3_REG		0x4c
> +#define MDIO_CTRL_4_REG		0x50

Can we have better names than as. It seems like 3 is read data, 2 is
write data, etc.

> +#define MDIO_CTRL_4_ACCESS_BUSY		BIT(16)
> +#define MDIO_CTRL_4_ACCESS_START		BIT(8)
> +#define MDIO_CTRL_4_ACCESS_CODE_READ		0
> +#define MDIO_CTRL_4_ACCESS_CODE_WRITE	1
> +#define CTRL_0_REG_DEFAULT_VALUE	0x150FF

No magic numbers please. Try to explain what each of these bits
do. I'm guessing they are clock speed, preamble enable, maybe C22/C45?

> +
> +#define IPQ40XX_MDIO_RETRY	1000
> +#define IPQ40XX_MDIO_DELAY	10
> +
> +struct ipq40xx_mdio_data {
> +	struct mii_bus	*mii_bus;
> +	void __iomem	*membase;
> +	struct device	*dev;
> +};
> +
> +static int ipq40xx_mdio_wait_busy(struct ipq40xx_mdio_data *am)
> +{
> +	int i;
> +
> +	for (i = 0; i < IPQ40XX_MDIO_RETRY; i++) {
> +		unsigned int busy;
> +
> +		busy = readl(am->membase + MDIO_CTRL_4_REG) &
> +			MDIO_CTRL_4_ACCESS_BUSY;
> +		if (!busy)
> +			return 0;
> +
> +		/* BUSY might take to be cleard by 15~20 times of loop */
> +		udelay(IPQ40XX_MDIO_DELAY);
> +	}
> +
> +	dev_err(am->dev, "%s: MDIO operation timed out\n", am->mii_bus->name);

dev_err() should give you enough to identify the device. No need to
print am->mii_bus->name as well.

> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int ipq40xx_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> +{
> +	struct ipq40xx_mdio_data *am = bus->priv;
> +	int value = 0;
> +	unsigned int cmd = 0;
> +
> +	lockdep_assert_held(&bus->mdio_lock);

Do you think the core is broken?

Please check if the request is for a C45 read, and return -EOPNOTSUPP
if so.


> +
> +	if (ipq40xx_mdio_wait_busy(am))
> +		return -ETIMEDOUT;
> +
> +	/* issue the phy address and reg */
> +	writel((mii_id << 8) | regnum, am->membase + MDIO_CTRL_1_REG);
> +
> +	cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_READ;
> +
> +	/* issue read command */
> +	writel(cmd, am->membase + MDIO_CTRL_4_REG);
> +
> +	/* Wait read complete */
> +	if (ipq40xx_mdio_wait_busy(am))
> +		return -ETIMEDOUT;
> +
> +	/* Read data */
> +	value = readl(am->membase + MDIO_CTRL_3_REG);
> +
> +	return value;
> +}
> +
> +static int ipq40xx_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> +							 u16 value)
> +{
> +	struct ipq40xx_mdio_data *am = bus->priv;
> +	unsigned int cmd = 0;
> +
> +	lockdep_assert_held(&bus->mdio_lock);
> +
> +	if (ipq40xx_mdio_wait_busy(am))
> +		return -ETIMEDOUT;
> +
> +	/* issue the phy address and reg */
> +	writel((mii_id << 8) | regnum, am->membase + MDIO_CTRL_1_REG);
> +
> +	/* issue write data */
> +	writel(value, am->membase + MDIO_CTRL_2_REG);
> +
> +	cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_WRITE;
> +	/* issue write command */
> +	writel(cmd, am->membase + MDIO_CTRL_4_REG);
> +
> +	/* Wait write complete */
> +	if (ipq40xx_mdio_wait_busy(am))
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +static int ipq40xx_mdio_probe(struct platform_device *pdev)
> +{
> +	struct ipq40xx_mdio_data *am;

Why the name am? Generally priv is used. I could also understand bus,
or even data, but am?

   Andrew
