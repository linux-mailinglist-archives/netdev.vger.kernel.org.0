Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746E43E36F1
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 21:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhHGTUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 15:20:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhHGTUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 15:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=s83klAhmciDbx+1XFJaV0CS4/5F56HShYxU1P/qX0Ks=; b=MI6b8vpa5nR2Qpkra8VZbocKik
        2zJ8B8KZHiESk78lkoiH+MfUSpqkhgsrVbV50xIgE10A9OrcFdJhRqHJzjBaRhqmlo8n/cCJ/Y+N3
        c+BxwtjMBUBea0kKA7Dx0/MjQLerTYktrgCBW+GX8edOMxoKLrT/1d6neUkMbyIg0sEw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCRrC-00GW1L-DC; Sat, 07 Aug 2021 21:19:42 +0200
Date:   Sat, 7 Aug 2021 21:19:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: Add driver for LiteX's LiteETH network interface
Message-ID: <YQ7czmvIm6FTZAol@lunn.ch>
References: <20210806054904.534315-1-joel@jms.id.au>
 <20210806054904.534315-3-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806054904.534315-3-joel@jms.id.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void liteeth_reset_hw(struct liteeth *priv)
> +{
> +	/* Reset, twice */
> +	writeb(0, priv->base + LITEETH_PHY_CRG_RESET);
> +	udelay(10);
> +	writeb(1, priv->base + LITEETH_PHY_CRG_RESET);
> +	udelay(10);
> +	writeb(0, priv->base + LITEETH_PHY_CRG_RESET);
> +	udelay(10);

What is this actually resetting?

> +static int liteeth_probe(struct platform_device *pdev)
> +{
> +	struct net_device *netdev;
> +	void __iomem *buf_base;
> +	struct resource *res;
> +	struct liteeth *priv;
> +	int irq, err;
> +
> +	netdev = alloc_etherdev(sizeof(*priv));
> +	if (!netdev)
> +		return -ENOMEM;
> +
> +	priv = netdev_priv(netdev);
> +	priv->netdev = netdev;
> +	priv->dev = &pdev->dev;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "Failed to get IRQ\n");
> +		goto err;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base)) {
> +		err = PTR_ERR(priv->base);
> +		goto err;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	priv->mdio_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->mdio_base)) {
> +		err = PTR_ERR(priv->mdio_base);
> +		goto err;
> +	}

So you don't have any PHY handling, or any MDIO bus master code. So i
would drop this, until the MDIO architecture question is answered. I
also wonder how much use the MAC driver is without any PHY code?
Unless you have a good reason, i don't think we should merge this
until it makes the needed calls into phylib. It is not much code to
add.

	Andrew
