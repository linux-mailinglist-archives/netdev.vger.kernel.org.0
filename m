Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F862F0889
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbhAJRF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:05:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59956 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbhAJRF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 12:05:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kye8v-00HLBh-Uf; Sun, 10 Jan 2021 18:04:41 +0100
Date:   Sun, 10 Jan 2021 18:04:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org
Subject: Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM memory map
Message-ID: <X/szqUG3nr/FrZXS@lunn.ch>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-4-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610292623-15564-4-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mvpp2_get_sram(struct platform_device *pdev,
> +			  struct mvpp2 *priv)
> +{
> +	struct device_node *dn = pdev->dev.of_node;
> +	struct resource *res;
> +
> +	if (has_acpi_companion(&pdev->dev)) {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +		if (!res) {
> +			dev_warn(&pdev->dev, "ACPI is too old, TX FC disabled\n");
> +			return 0;
> +		}
> +		priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(priv->cm3_base))
> +			return PTR_ERR(priv->cm3_base);
> +	} else {
> +		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
> +		if (!priv->sram_pool) {
> +			dev_warn(&pdev->dev, "DT is too old, TX FC disabled\n");
> +			return 0;
> +		}
> +		priv->cm3_base = (void __iomem *)gen_pool_alloc(priv->sram_pool,
> +								MSS_SRAM_SIZE);
> +		if (!priv->cm3_base)
> +			return -ENOMEM;

Should there be -EPROBE_DEFER handling in here somewhere? The SRAM is
a device, so it might not of been probed yet?

  Andrew
