Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B23532AB6
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbiEXMxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbiEXMxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:53:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72528DDC7;
        Tue, 24 May 2022 05:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aEQGnJB4yRDEKYIAvYkQ3Er0fCkxSuDTVlCpQ3Ht8F4=; b=SFczDPIoraBwGxxn4oJuMlM7yD
        hCSZdnYeNNzerCAG9VqheNwTlmGqXEgPrkFarZfW+4OFVSrFIBgaDjL3LVcPWQ99Q/uRknPaw1MOK
        WxHo3oYyTP2lTR3Bt2UK/Ccx33rwRk/UqXnjM5J4MDtGgUfbPqcbYA2TCm4XijLmfmy8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ntU1o-0046NS-HK; Tue, 24 May 2022 14:52:48 +0200
Date:   Tue, 24 May 2022 14:52:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Qiang Yang <line_walker2016@163.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Weiqiang Su <David.suwq@outlook.com>
Subject: Re: [PATCH] net: stmicro: implement basic Wake-On-LAN support
Message-ID: <YozVIEhUYpWk6atX@lunn.ch>
References: <20220524123903.13210-1-line_walker2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524123903.13210-1-line_walker2016@163.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> @@ -267,7 +267,14 @@ static void dwmac1000_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
>  static void dwmac1000_pmt(struct mac_device_info *hw, unsigned long mode)
>  {
>  	void __iomem *ioaddr = hw->pcsr;
> -	unsigned int pmt = 0;
> +	unsigned int pmt = 0, i = 0;
> +
> +	writel(pointer_reset, ioaddr + GMAC_PMT);
> +	mdelay(100);

That is quite a long delay. Is there a bit which can be polled to let
you know it is ready?

> +
> +	for (i = 0; i < WAKEUP_REG_LENGTH; i++)
> +		writel(*(stmmac_wakeup_filter_config + i),
> +		       ioaddr + GMAC_WAKEUP_FILTER);
>  
>  	if (mode & WAKE_MAGIC) {
>  		pr_debug("GMAC: WOL Magic frame\n");
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 0a4d093adfc9..7866f3ec5ef6 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4513,6 +4513,7 @@ int stmmac_suspend(struct device *dev)
>  
>  	/* Enable Power down mode by programming the PMT regs */
>  	if (device_may_wakeup(priv->device)) {
> +		priv->wolopts |= WAKE_MAGIC;
>  		stmmac_pmt(priv, priv->hw, priv->wolopts);
>  		priv->irq_wake = 1;
>  	} else {
> @@ -4598,6 +4599,7 @@ int stmmac_resume(struct device *dev)
>  			stmmac_mdio_reset(priv->mii);
>  	}
>  
> +	device_set_wakeup_enable(dev, 0);
>  	netif_device_attach(ndev);
>  
>  	mutex_lock(&priv->lock);
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> index cc1e887e47b5..ec69521f061c 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> @@ -322,6 +322,7 @@ static int __maybe_unused stmmac_pci_suspend(struct device *dev)
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	int ret;
>  
> +	device_set_wakeup_enable(dev, 1);
>  	ret = stmmac_suspend(dev);
>  	if (ret)
>  		return ret;

This looks too minimum. I would expect there to be code in set_wol and
get_wol, to indicate WAKE_MAGIC is available, and to turn it
on/off. You also need to deal with when the PHY also implements
WAKE_MAGIC. Ideally, the PHY should implement it, since it can do it
with less power. But when the PHY does not have support, then the MAC
should implement it.

Maybe some of this code already exists, i've not looked.

       Andrew
