Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF1F3AE1BD
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 04:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhFUC57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 22:57:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229901AbhFUC56 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Jun 2021 22:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QK752DbSwacLa/sK38ulodAOLnHwWz+NFCNnwogFzak=; b=lU3TC1nXnpuNByWkI3qu6w4CKW
        +5XJpObhUS28zRmnViSpHJB89wAq0OgGt+WLPO0ynKPiLdMIbVnO2nLig/wnPK8IF7/4hnSdGP0jW
        zocMghFEmeqgZBAyEve9gOuIPZk8upBQEZUXoAndV+3fOstVMykWzHu3yCatXrLe4CtA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvA5g-00ARYz-Jy; Mon, 21 Jun 2021 04:55:12 +0200
Date:   Mon, 21 Jun 2021 04:55:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Qing Zhang <zhangqing@loongson.cn>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rob Herring <robh+dt@kernel.org>,
        Huacai Chen <chenhc@lemote.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 1/4] stmmac: pci: Add dwmac support for Loongson
Message-ID: <YM//kGGAp3vz8OYb@lunn.ch>
References: <20210618025337.5705-1-zhangqing@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618025337.5705-1-zhangqing@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct plat_stmmacenet_data *plat;
> +	struct stmmac_resources res;
> +	int ret, i, mdio;
> +	struct device_node *np;
> +
> +	np = dev_of_node(&pdev->dev);
> +
> +	if (!np) {
> +		pr_info("dwmac_loongson_pci: No OF node\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!of_device_is_compatible(np, "loongson, pci-gmac")) {
> +		pr_info("dwmac_loongson_pci: Incompatible OF node\n");
> +		return -ENODEV;
> +	}
> +
> +	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
> +	if (!plat)
> +		return -ENOMEM;
> +
> +	if (plat->mdio_node) {
> +		dev_err(&pdev->dev, "Found MDIO subnode\n");

It is an error is an MDIO node is found?

> +		mdio = true;
> +	}
> +

...

> +
> +	plat->phy_interface = device_get_phy_mode(&pdev->dev);
> +	if (plat->phy_interface < 0)
> +		dev_err(&pdev->dev, "phy_mode not found\n");
> +
> +	plat->interface = PHY_INTERFACE_MODE_GMII;

Seems odd you call device_get_phy_mode() but then have this hard coded
PHY_INTERFACE_MODE_GMII?

	Andrew
