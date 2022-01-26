Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B113B49C291
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiAZESC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:18:02 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49682 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiAZESB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 23:18:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CBE00CE1BBF;
        Wed, 26 Jan 2022 04:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B32C340E3;
        Wed, 26 Jan 2022 04:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643170678;
        bh=MaAuNjsFO8On+BGpUOJ4aK1T9MBVNUh+44P2Z4qFPYQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cwQgwPJRdJ0WHqCqAeWadgK+l1IyR8R05fdGOpE3f90v/9Ocq2lw1LDrenpG8/++/
         0bly1h4lIoY1v8CpsT7bVS4nLTaX4DPGQ6lnpLJKg3G0n0gqM9af7BGFVW94y75Y8n
         ZuJ7zuNkG5DK7zmOMxT2VCLsxahb9u6jfrgzLybhiWvhxkFjgx2weWPdnrD6i+6Anj
         d3Zzl0xzlwM0kjCF7uKvK+K6++Rn0uiiivlAX6fVtCZ7nhrdJRU0EsRolboOcSag92
         NJ8fq7P66AT8IjK0TVB21pjKjmAsa1QskuKMIpB+4MwlFPbwaYYSMRiW+g1pezaYWm
         vV9d8AgmG3u4Q==
Date:   Tue, 25 Jan 2022 20:17:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] net: stmmac: skip only stmmac_ptp_register
 when resume from suspend
Message-ID: <20220125201756.1606e1c4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125032324.4055-3-mohammad.athari.ismail@intel.com>
References: <20220125032324.4055-1-mohammad.athari.ismail@intel.com>
        <20220125032324.4055-3-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 11:23:24 +0800 Mohammad Athari Bin Ismail wrote:
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index d7e261768f73..b8e5e19e6f7b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -880,11 +880,12 @@ EXPORT_SYMBOL_GPL(stmmac_init_tstamp_counter);
>  /**
>   * stmmac_init_ptp - init PTP
>   * @priv: driver private structure
> + * @ptp_register: register PTP if set
>   * Description: this is to verify if the HW supports the PTPv1 or PTPv2.
>   * This is done by looking at the HW cap. register.
>   * This function also registers the ptp driver.
>   */
> -static int stmmac_init_ptp(struct stmmac_priv *priv)
> +static int stmmac_init_ptp(struct stmmac_priv *priv, bool ptp_register)
>  {
>  	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
>  	int ret;
> @@ -914,7 +915,8 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
>  	priv->hwts_tx_en = 0;
>  	priv->hwts_rx_en = 0;
>  
> -	stmmac_ptp_register(priv);
> +	if (ptp_register)
> +		stmmac_ptp_register(priv);

stmmac_init_ptp() only has one caller, and the registration step is last.
Wouldn't it be better to move the stmmac_ptp_register() call out to
stmmac_hw_setup()? That way we don't need to pass extra arguments to init.

>  	return 0;
>  }
> @@ -3241,7 +3243,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
>  /**
>   * stmmac_hw_setup - setup mac in a usable state.
>   *  @dev : pointer to the device structure.
> - *  @init_ptp: initialize PTP if set
> + *  @ptp_register: register PTP if set
>   *  Description:
>   *  this is the main function to setup the HW in a usable state because the
>   *  dma engine is reset, the core registers are configured (e.g. AXI,
> @@ -3251,7 +3253,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
>   *  0 on success and an appropriate (-)ve integer as defined in errno.h
>   *  file on failure.
>   */
> -static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
> +static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
>  	u32 rx_cnt = priv->plat->rx_queues_to_use;
> @@ -3308,13 +3310,11 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
>  
>  	stmmac_mmc_setup(priv);
>  
> -	if (init_ptp) {
> -		ret = stmmac_init_ptp(priv);
> -		if (ret == -EOPNOTSUPP)
> -			netdev_warn(priv->dev, "PTP not supported by HW\n");
> -		else if (ret)
> -			netdev_warn(priv->dev, "PTP init failed\n");
> -	}
> +	ret = stmmac_init_ptp(priv, ptp_register);
> +	if (ret == -EOPNOTSUPP)
> +		netdev_warn(priv->dev, "PTP not supported by HW\n");
> +	else if (ret)
> +		netdev_warn(priv->dev, "PTP init failed\n");
