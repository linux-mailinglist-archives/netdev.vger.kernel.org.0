Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9A3E3B13
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhHHP1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:27:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhHHP1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 11:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nJhYiy8fBhKop5tc79Q9zyLajcYLA2qBPGNFwOEzCNY=; b=Ngjeoyhre0MFM1qZboSdv+EE7o
        0ZhtYCibC5IVePWaqVk3TMcE5OFrlmhJtcKCzxGJNqZTMY1u6Wu08rghgjRyvMgpW8a7ozBLlUjTa
        Aj9KBbLAinCFi0FEjrU02efaM56DjLtDS+t5zFzvQOkMO1hwbutTp5Dmy7EOcF2y4YYk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCkhd-00GalW-2Y; Sun, 08 Aug 2021 17:27:05 +0200
Date:   Sun, 8 Aug 2021 17:27:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v1 1/2] net: mdio: Add the reset function for IPQ MDIO
 driver
Message-ID: <YQ/3ycEU9zkn8idJ@lunn.ch>
References: <20210808072111.8365-1-luoj@codeaurora.org>
 <20210808072111.8365-2-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808072111.8365-2-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ipq_mdio_reset(struct mii_bus *bus)
> +{
> +	struct ipq4019_mdio_data *priv = bus->priv;
> +	u32 val;
> +	int ret;
> +
> +	/* To indicate CMN_PLL that ethernet_ldo has been ready if platform resource 1
> +	 * is specified in the device tree.
> +	 * */
> +	if (!IS_ERR(priv->eth_ldo_rdy)) {
> +		val = readl(priv->eth_ldo_rdy);
> +		val |= BIT(0);
> +		writel(val, priv->eth_ldo_rdy);
> +		fsleep(IPQ_PHY_SET_DELAY_US);
> +	}
> +
> +	/* Configure MDIO clock source frequency if clock is specified in the device tree */
> +	if (!IS_ERR_OR_NULL(priv->mdio_clk)) {
> +		ret = clk_set_rate(priv->mdio_clk, IPQ_MDIO_CLK_RATE);
> +		if (ret)
> +			return ret;
> +
> +		ret = clk_prepare_enable(priv->mdio_clk);
> +		if (ret)
> +			return ret;
> +	}

These !IS_ERR() are pretty ugly. So

> @@ -182,14 +221,22 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	priv = bus->priv;
> +	priv->eth_ldo_rdy = IOMEM_ERR_PTR(-EINVAL);
>  
>  	priv->membase = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(priv->membase))
>  		return PTR_ERR(priv->membase);
>  
> +	priv->mdio_clk = devm_clk_get_optional(&pdev->dev, "gcc_mdio_ahb_clk");

If this returns an error, it is a real error. You should not ignore
it. Fail the probe returning the error. That then means when the reset
function is called priv->mdio_clk contains either a clock, or NULL,
which the clk API is happy to take. No need for an if.


> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (res)
> +		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);

platform_get_resource() returns a pointer or NULL. There is no error
code. So

> +	if (!IS_ERR(priv->eth_ldo_rdy)) {

is actually wrong, should simply become

> +	if (priv->eth_ldo_rdy) {

  Andrew
