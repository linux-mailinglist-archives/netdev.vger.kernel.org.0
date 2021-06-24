Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5815B3B3141
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhFXO2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:28:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231978AbhFXO2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 10:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=daRFBCA9iRpEHBee51ZqEeUZ2hHxuMUcehyqzo51cKE=; b=Y+DaKI+AJ2acjklMtCkCgeKtFx
        y/BDgTdvQOihy8YSuq/2Go1I29pHdu1CMXmzld0D3NcaN9vTNN1HKBy4ITf3ZaWSiVKzo9V9gWxeJ
        12ZhsEIo1S31bew7wKL7shzLdXIIqGxclsA8k6Sm9SHFoQIRgmBCUmXaW7HLQ5Lxie5U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwQIf-00AzBN-7M; Thu, 24 Jun 2021 16:25:49 +0200
Date:   Thu, 24 Jun 2021 16:25:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: stmmac: Fix an error code in dwmac-ingenic.c
Message-ID: <YNSV7caeVBNnxr1S@lunn.ch>
References: <1623811148-11064-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623811148-11064-1-git-send-email-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 10:39:08AM +0800, Yang Li wrote:
> When IS_ERR(mac->regmap) returns true, the value of ret is 0.
> So, we set ret to -ENODEV to indicate this error.
> 
> Clean up smatch warning:
> drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c:266
> ingenic_mac_probe() warn: missing error code 'ret'
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
> index 60984c1..f3950e0 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
> @@ -263,6 +263,7 @@ static int ingenic_mac_probe(struct platform_device *pdev)
>  	mac->regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node, "mode-reg");
>  	if (IS_ERR(mac->regmap)) {
>  		dev_err(&pdev->dev, "%s: Failed to get syscon regmap\n", __func__);
> +		ret = -ENODEV;

mac->regmap is a ERR_PTR(), containing an error code. Please use that
error code, not ENODEV.

      Andrew
