Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860E839EA85
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 02:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFHAD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 20:03:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230282AbhFHAD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 20:03:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=N3a+03kBTMfQSx5Hd/bgZB3TBPMGzTKqpBlMp1B0wk8=; b=nakdTipNHB98wcXQ2sRFnxmLlF
        WoyocyN0jrUpK+Zcdvcu2GYF34gelZzc6rMgPNpe6zxlAVZE7cwYGNe+aAHNR9ozGYlAVFVT6HYBS
        x1EBu7rwkrI8Yx2xyCDXKAF7Y0MixQIOsjKlaDfC4SRgb88JciIQq9gImH4SrflyzGC0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lqPBa-008GfJ-3G; Tue, 08 Jun 2021 02:01:38 +0200
Date:   Tue, 8 Jun 2021 02:01:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: Re: [PATCH 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <YL6zYgGdqxqL9c0j@lunn.ch>
References: <1623086867-119039-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623086867-119039-3-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623086867-119039-3-git-send-email-zhouyanjie@wanyeetech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  config DWMAC_ROCKCHIP
>  	tristate "Rockchip dwmac support"
> -	default ARCH_ROCKCHIP
> +	default MACH_ROCKCHIP
>  	depends on OF && (ARCH_ROCKCHIP || COMPILE_TEST)
>  	select MFD_SYSCON
>  	help
> @@ -164,7 +176,7 @@ config DWMAC_STI
>  
>  config DWMAC_STM32
>  	tristate "STM32 DWMAC support"
> -	default ARCH_STM32
> +	default MACH_STM32

It would be good to explain in the commit message why you are changing
these two. It is not obvious.

> +static int jz4775_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
> +{
> +	struct ingenic_mac *mac = plat_dat->bsp_priv;
> +	int val;
> +
> +	switch (plat_dat->interface) {
> +	case PHY_INTERFACE_MODE_MII:
> +		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_MII);
> +		pr_debug("MAC PHY Control Register: PHY_INTERFACE_MODE_MII\n");
> +		break;
> +
> +	case PHY_INTERFACE_MODE_GMII:
> +		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_GMII);
> +		pr_debug("MAC PHY Control Register: PHY_INTERFACE_MODE_GMII\n");
> +		break;
> +
> +	case PHY_INTERFACE_MODE_RMII:
> +		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
> +		pr_debug("MAC PHY Control Register: PHY_INTERFACE_MODE_RMII\n");
> +		break;
> +
> +	case PHY_INTERFACE_MODE_RGMII:

What about the other three RGMII modes?

> +	case PHY_INTERFACE_MODE_RGMII:
> +		val = FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_DELAY) |
> +			  FIELD_PREP(MACPHYC_TX_DELAY_MASK, MACPHYC_TX_DELAY_63_UNIT) |
> +			  FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN) |
> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII);

What exactly does MACPHYC_TX_DELAY_63_UNIT mean here? Ideally, the MAC
should not be adding any RGMII delays. It should however pass mode
through to the PHY, so it can add the delays, if the mode indicates it
should, e.g. PHY_INTERFACE_MODE_RGMII_ID. This is also why you should
be handling all 4 RGMII modes here, not just one.

	 Andrew
