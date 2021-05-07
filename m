Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A000A375E1C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhEGA4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233933AbhEGA4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 20:56:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0ECC60E0B;
        Fri,  7 May 2021 00:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620348924;
        bh=UHb+b8Utq3FEk+G1NJBR8QnH4sblAOkzaEo9Ly3sZ98=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dqx7G95qVK47QhE/LaWgm/iV/bmFTrTeAKAZ09h1imOu3LLMO2/fTiNbYmt4MccDQ
         /+su66musEHXpTbzaajb0XkcOTbCfykW0FOZ8SNxnpBmM6nR6ghYTNdiyCKAAtICob
         odfhXFY7yx9t/4xtefPpWo7pA2yp3i1QXSX1PaRhku84GAV9BUvh1n3KOTKa8gZC5+
         hUURVTyAJDXoIqhrxqGBdaptPorC9gps90YkKGFjZE5tSedF1pleqh5aA2cmS72Drt
         ROEXSHxSG80hQvdas1y6UfslHy8iOAi665e4QQ6zFBq3cxthrbIplOqb97Bl+xhDBn
         7avvrYOQiJSZA==
Date:   Thu, 6 May 2021 17:55:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Jisheng.Zhang@synaptics.com,
        netdev@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH V4 net] net: stmmac: Fix MAC WoL not working if PHY does
 not support WoL
Message-ID: <20210506175522.49a2ad5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210506050658.9624-1-qiangqing.zhang@nxp.com>
References: <20210506050658.9624-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 May 2021 13:06:58 +0800 Joakim Zhang wrote:
> Both get and set WoL will check device_can_wakeup(), if MAC supports PMT,
> it will set device wakeup capability. After commit 1d8e5b0f3f2c ("net:
> stmmac: Support WOL with phy"), device wakeup capability will be overwrite
> in stmmac_init_phy() according to phy's Wol feature. If phy doesn't support
> WoL, then MAC will lose wakeup capability.

Let's take a step back. Can we get a minimal fix for losing the config
in stmmac_init_phy(), and then extend the support for WoL for devices
which do support wake up themselves?

> This patch combines WoL capabilities both MAC and PHY from stmmac_get_wol(),
> set wakeup capability and give WoL priority to the PHY in stmmac_set_wol()
> when enable WoL. What PHYs do implement is WAKE_MAGIC, WAKE_UCAST, WAKE_MAGICSECURE
> and WAKE_BCAST.
> 
> Fixes: commit 1d8e5b0f3f2c ("net: stmmac: Support WOL with phy")

Please remove "commit" from the fixes tag.

> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index c5642985ef95..6d09908dec1f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -629,35 +629,49 @@ static void stmmac_get_strings(struct net_device *dev, u32 stringset, u8 *data)
>  /* Currently only support WOL through Magic packet. */
>  static void stmmac_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>  {
> +	struct ethtool_wolinfo wol_phy = { .cmd = ETHTOOL_GWOL };
>  	struct stmmac_priv *priv = netdev_priv(dev);
>  
> -	if (!priv->plat->pmt)
> -		return phylink_ethtool_get_wol(priv->phylink, wol);
> -
>  	mutex_lock(&priv->lock);
> -	if (device_can_wakeup(priv->device)) {

Why remove the device_can_wakeup() check?

> +	if (priv->plat->pmt) {
>  		wol->supported = WAKE_MAGIC | WAKE_UCAST;
>  		if (priv->hw_cap_support && !priv->dma_cap.pmt_magic_frame)
>  			wol->supported &= ~WAKE_MAGIC;
> -		wol->wolopts = priv->wolopts;
>  	}
> +
> +	phylink_ethtool_get_wol(priv->phylink, &wol_phy);
> +
> +	/* Combine WoL capabilities both PHY and MAC */
> +	wol->supported |= wol_phy.supported;
> +	wol->wolopts = priv->wolopts;
> +
>  	mutex_unlock(&priv->lock);
>  }
>  
>  static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>  {
> +	u32 support = WAKE_MAGIC | WAKE_UCAST | WAKE_MAGICSECURE | WAKE_BCAST;

Why this list?

> +	struct ethtool_wolinfo wol_phy = { .cmd = ETHTOOL_GWOL };
>  	struct stmmac_priv *priv = netdev_priv(dev);
> -	u32 support = WAKE_MAGIC | WAKE_UCAST;

This list was the list of what the MAC supported, right?

> +	int ret;
>  
> -	if (!device_can_wakeup(priv->device))

Why remove this check?

> +	if (wol->wolopts & ~support)
>  		return -EOPNOTSUPP;
>  
> -	if (!priv->plat->pmt) {
> -		int ret = phylink_ethtool_set_wol(priv->phylink, wol);
> -
> -		if (!ret)
> -			device_set_wakeup_enable(priv->device, !!wol->wolopts);
> -		return ret;
> +	/* First check if can WoL from PHY */
> +	phylink_ethtool_get_wol(priv->phylink, &wol_phy);
> +	if (wol->wolopts & wol_phy.supported) {

So if _any_ requests match PHY capabilities we'd use PHY?
I think the check should be:

	if ((wol->woltops & wol_phy.supported) == wol->woltops)

That said I'm not 100% sure what the semantics for WoL are.

> +		wol->wolopts &= wol_phy.supported;
> +		ret = phylink_ethtool_set_wol(priv->phylink, wol);
> +
> +		if (!ret) {
> +			pr_info("stmmac: phy wakeup enable\n");
> +			device_set_wakeup_capable(priv->device, 1);
> +			device_set_wakeup_enable(priv->device, 1);
> +			goto wolopts_update;
> +		} else {
> +			return ret;
> +		}
>  	}
>  
>  	/* By default almost all GMAC devices support the WoL via
> @@ -666,18 +680,21 @@ static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>  	if ((priv->hw_cap_support) && (!priv->dma_cap.pmt_magic_frame))
>  		wol->wolopts &= ~WAKE_MAGIC;
>  
> -	if (wol->wolopts & ~support)
> -		return -EINVAL;

Now you seem to not validate against MAC capabilities anywhere.

> -	if (wol->wolopts) {
> -		pr_info("stmmac: wakeup enable\n");
> +	if (priv->plat->pmt && wol->wolopts) {
> +		pr_info("stmmac: mac wakeup enable\n");
> +		device_set_wakeup_capable(priv->device, 1);
>  		device_set_wakeup_enable(priv->device, 1);
>  		enable_irq_wake(priv->wol_irq);
> -	} else {
> +		goto wolopts_update;
> +	}
> +
> +	if (!wol->wolopts) {
> +		device_set_wakeup_capable(priv->device, 0);
>  		device_set_wakeup_enable(priv->device, 0);
>  		disable_irq_wake(priv->wol_irq);
>  	}
>  
> +wolopts_update:
>  	mutex_lock(&priv->lock);
>  	priv->wolopts = wol->wolopts;
>  	mutex_unlock(&priv->lock);

