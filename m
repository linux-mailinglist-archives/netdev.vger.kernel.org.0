Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8700A3DA412
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhG2N1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:27:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237528AbhG2N1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 09:27:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ve/KL1lU44TvwHzfefIp6JxgDdI8qbOUpEiu1gJ+fiU=; b=Z7OaNwnYWxUZ3TTXmSx0cznR3c
        Tr03VFm1LyFn5euqXGtQ0L5TuicEeg/xYF/h0QERCRdUo0H1TUsG8SY+YtaSAEWtN4vJfljqHoJfD
        w0v2zUo9xqF0mFQC94/UYFqBeyjhaHIp45kkw+xflO/G8x5I2VgAH/HoN5kewLZkNDD0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m963q-00FJdk-4G; Thu, 29 Jul 2021 15:26:54 +0200
Date:   Thu, 29 Jul 2021 15:26:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        p.zabel@pengutronix.de, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        robert.marko@sartura.hr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH 1/3] net: mdio-ipq4019: Add mdio reset function
Message-ID: <YQKsnqWCfoTpTuxI@lunn.ch>
References: <20210729125358.5227-1-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729125358.5227-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luo

For a patchset, netdev wants to see a patch 0/X which describes the
big picture. What is the patchset as a whole doing.

> +static int ipq_mdio_reset(struct mii_bus *bus)
> +{
> +	struct ipq4019_mdio_data *priv = bus->priv;
> +	struct device *dev = bus->parent;
> +	struct gpio_desc *reset_gpio;
> +	u32 val;
> +	int i, ret;
> +
> +	/* To indicate CMN_PLL that ethernet_ldo has been ready if needed */
> +	if (!IS_ERR(priv->eth_ldo_rdy)) {
> +		val = readl(priv->eth_ldo_rdy);
> +		val |= BIT(0);
> +		writel(val, priv->eth_ldo_rdy);
> +		fsleep(QCA_PHY_SET_DELAY_US);
> +	}
> +
> +	/* Reset GEPHY if need */
> +	if (!IS_ERR(priv->reset_ctrl)) {
> +		reset_control_assert(priv->reset_ctrl);
> +		fsleep(QCA_PHY_SET_DELAY_US);
> +		reset_control_deassert(priv->reset_ctrl);
> +		fsleep(QCA_PHY_SET_DELAY_US);
> +	}

What exactly is being reset here? Which is GEPHY?

The MDIO bus master driver should not be touching any Ethernet
PHYs. All it provides is a bus, nothing more.

> +
> +	/* Configure MDIO clock frequency */
> +	if (!IS_ERR(priv->mdio_clk)) {
> +		ret = clk_set_rate(priv->mdio_clk, QCA_MDIO_CLK_RATE);
> +		if (ret)
> +			return ret;
> +
> +		ret = clk_prepare_enable(priv->mdio_clk);
> +		if (ret)
> +			return ret;
> +	}

> +
> +	/* Reset PHYs by gpio pins */
> +	for (i = 0; i < gpiod_count(dev, "phy-reset"); i++) {
> +		reset_gpio = gpiod_get_index_optional(dev, "phy-reset", i, GPIOD_OUT_HIGH);
> +		if (IS_ERR(reset_gpio))
> +			continue;
> +		gpiod_set_value_cansleep(reset_gpio, 0);
> +		fsleep(QCA_PHY_SET_DELAY_US);
> +		gpiod_set_value_cansleep(reset_gpio, 1);
> +		fsleep(QCA_PHY_SET_DELAY_US);
> +		gpiod_put(reset_gpio);
> +	}

No, there is common code in phylib to do that.

>  static int ipq4019_mdio_probe(struct platform_device *pdev)
>  {
>  	struct ipq4019_mdio_data *priv;
>  	struct mii_bus *bus;
> +	struct resource *res;
>  	int ret;
>  
>  	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
> @@ -182,14 +244,23 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	priv = bus->priv;
> +	priv->eth_ldo_rdy = IOMEM_ERR_PTR(-EINVAL);
>  
>  	priv->membase = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(priv->membase))
>  		return PTR_ERR(priv->membase);
>  
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (res)
> +		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);
> +
> +	priv->reset_ctrl = devm_reset_control_get_exclusive(&pdev->dev, "gephy_mdc_rst");
> +	priv->mdio_clk = devm_clk_get(&pdev->dev, "gcc_mdio_ahb_clk");

You probably want to use devm_clk_get_optional().

    Andrew
