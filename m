Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2E49CA5C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiAZNHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:07:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234750AbiAZNHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 08:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iyaK/5RcSx3Af2ZoGVfePYGS3+zGe9ADowEH6CDKC3o=; b=PtQUEVisYfRC/bB+eQ5/IqQD5m
        q8UaOIW/t252E2Zjzd1rycHp+i1O9T4mFeXEuIlh+ADJZQCag3842NewxtNSaJvDp9nNbRFAWJ3Q9
        IssGzJFxD5MKl4Im6I0DhzsweqNw/9OsCGnun/JQNl8OOGjIUX/1vHlscALZD1kBjX7A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCi1S-002o9W-LJ; Wed, 26 Jan 2022 14:07:38 +0100
Date:   Wed, 26 Jan 2022 14:07:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net/fsl: xgmac_mdio: Support setting the
 MDC frequency
Message-ID: <YfFHmkFXtlVus9IW@lunn.ch>
References: <20220126101432.822818-1-tobias@waldekranz.com>
 <20220126101432.822818-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126101432.822818-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias

>  struct mdio_fsl_priv {
>  	struct	tgec_mdio_controller __iomem *mdio_base;
> +	struct clk *enet_clk;

It looks like there is a whitespace issue here?

> +	u32	mdc_freq;
>  	bool	is_little_endian;
>  	bool	has_a009885;
>  	bool	has_a011043;
> @@ -255,6 +258,34 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
>  	return ret;
>  }
>  
> +static void xgmac_mdio_set_mdc_freq(struct mii_bus *bus)
> +{
> +	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> +	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
> +	struct device *dev = bus->parent;
> +	u32 mdio_stat, div;
> +
> +	if (device_property_read_u32(dev, "clock-frequency", &priv->mdc_freq))
> +		return;
> +
> +	priv->enet_clk = devm_clk_get(dev, NULL);
> +	if (IS_ERR(priv->enet_clk)) {
> +		dev_err(dev, "Input clock unknown, not changing MDC frequency");

Is the clock optional or mandatory?

If mandatory, then i would prefer -ENODEV and fail the probe.

> +		return;
> +	}
> +
> +	div = ((clk_get_rate(priv->enet_clk) / priv->mdc_freq) - 1) / 2;
> +	if (div < 5 || div > 0x1ff) {
> +		dev_err(dev, "Requested MDC frequecy is out of range, ignoring");

and here return -EINVAL.

I always think it is best to make it obvious something is broken. One
additional line on the console can be missed for a while. All the
Ethernet devices missing because the PHYs are missing, because the
MDIO bus is missing is going to get noticed very quickly.

     Andrew
