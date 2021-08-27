Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6D23F9A8D
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 16:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbhH0OD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 10:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231675AbhH0OD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 10:03:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D25C760F25;
        Fri, 27 Aug 2021 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630072959;
        bh=9KVL338uZU2WstNlPctg6BYMhKgoDAyusOTsEn/ouuM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CASqYK4WvoeOw7f6syajt3xV0idVa1b4L0oQ4JtnOFWpZqjTSaZmZcx+zbzhe+qB9
         ixjl3hCW1sWlfD6NbuUgZXHNiy6pnMM/SG//ANdPM1FAI+ij2zCUbsgoMcdhVqLGjL
         k5BWgJNi7B988nnPscyVug5z4gppxLKvKNgA/PMtj8F+BWll7nu2WuILM6yTfHP9P0
         H7ZO5kRrUvstQTPNbDlxFc7SYtUcGz6/YiiRGuPXrjotg//y94Bne/NtZ058zAhBna
         xBOhU/xYrd5sGhFEG695Fez4ULsInXSzQejMBC/CQJwOWPQjQ8B3HvCqZm2cv7Dplq
         QBpUkFpsQ63ww==
Date:   Fri, 27 Aug 2021 07:02:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhaoxiao <zhaoxiao@uniontech.com>
Cc:     davem@davemloft.net, mcoquelin.stm32@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stmmac: dwmac-loongson: change the pr_info() to
 dev_err() in loongson_dwmac_probe()
Message-ID: <20210827070238.7586fb11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210827085550.13519-1-zhaoxiao@uniontech.com>
References: <20210827085550.13519-1-zhaoxiao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 16:55:50 +0800 zhaoxiao wrote:
> - Change the pr_info/dev_info to dev_err.
> - Add the dev_err to improve readability.
> 
> Signed-off-by: zhaoxiao <zhaoxiao@uniontech.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-loongson.c  | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> index 4c9a37dd0d3f..495c94e7929f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> @@ -54,20 +54,21 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
>  	bool mdio = false;
>  
>  	np = dev_of_node(&pdev->dev);
> -
>  	if (!np) {
> -		pr_info("dwmac_loongson_pci: No OF node\n");
> +		dev_err(&pdev->dev, "dwmac_loongson_pci: No OF node\n");
>  		return -ENODEV;
>  	}
>  
>  	if (!of_device_is_compatible(np, "loongson, pci-gmac")) {
> -		pr_info("dwmac_loongson_pci: Incompatible OF node\n");
> +		dev_err(&pdev->dev, "dwmac_loongson_pci: Incompatible OF node\n");
>  		return -ENODEV;
>  	}
>  
>  	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
> -	if (!plat)
> +	if (!plat) {
> +		dev_err(&pdev->dev, "memory allocation failed\n");

Please don't add error messages after allocation failures. OOM will
produce a lot of kernel messages and a stack trace already.

>  		return -ENOMEM;
> +	}
>  
>  	if (plat->mdio_node) {
>  		dev_err(&pdev->dev, "Found MDIO subnode\n");
> @@ -109,8 +110,10 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
>  		plat->bus_id = pci_dev_id(pdev);
>  
>  	phy_mode = device_get_phy_mode(&pdev->dev);
> -	if (phy_mode < 0)
> +	if (phy_mode < 0) {
>  		dev_err(&pdev->dev, "phy_mode not found\n");
> +		return phy_mode;

You're adding a return here, it should be a separate patch with its own
justification.

> +	}
>  
>  	plat->phy_interface = phy_mode;
>  	plat->interface = PHY_INTERFACE_MODE_GMII;
> @@ -130,7 +133,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
>  
>  	res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
>  	if (res.wol_irq < 0) {
> -		dev_info(&pdev->dev, "IRQ eth_wake_irq not found, using macirq\n");
> +		dev_err(&pdev->dev, "IRQ eth_wake_irq not found, using macirq\n");

Why upgrade to an error, isn't wol_irq optional?

>  		res.wol_irq = res.irq;
>  	}
>  

