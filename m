Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0262DCA72
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 02:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389109AbgLQBOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 20:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbgLQBOR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 20:14:17 -0500
Date:   Wed, 16 Dec 2020 17:13:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608167616;
        bh=G7SMuWC6pQQRgmjNh6PIaZ1HUFCNGNnFmEOc7xRb9Uk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=swlBta63ruJo1D7b7yTMmnHVaTEq3pyvUjOPxGcovwCwSryZUREhb86C6w+f4NcTL
         LsPG3d7e6zM5ZxtfyVnOt/Ibgkt73/tpwhwPMnTyeYdtfZEeIybUeWCicbXACQGHWg
         mmBnGul0gIFn/X8WwdDikbY2S+ugvsxppD+P61nA34Xz0qUiWfgbzOWRF7re2xRyJs
         kpyDOy8JuBmDsIGHiJU7+XuIPtmDj8yLqFijp98RJNUV+vWps2b+LargSCCxxRO6oE
         5vtFml82XCJEtDDrIeQA5UemHDYTQ5vQBLMswrx9lWzvw+uqbDTi2hLxZt4UO97/TO
         TasCT7fKDGwHg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Holger Assmann <h.assmann@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/2] net: stmmac: retain PTP-clock at hwtstamp_set
Message-ID: <20201216171334.1e36fbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216113239.2980816-1-h.assmann@pengutronix.de>
References: <20201216113239.2980816-1-h.assmann@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 12:32:38 +0100 Holger Assmann wrote:
> As it is, valid SIOCSHWTSTAMP ioctl calls - i.e. enable/disable time
> stamping or changing filter settings - lead to synchronization of the
> NIC's hardware clock with CLOCK_REALTIME. This might be necessary
> during system initialization, but at runtime, when the PTP clock has
> already been synchronized to a grand master, a reset of the timestamp
> settings might result in a clock jump.
> 
> This further differs from how drivers like IGB and FEC behave: Those
> initialize the PTP system time less frequently - on interface up and
> at probe time, respectively.
> 
> We consequently introduce the new function stmmac_init_hwtstamp(), which
> gets called during ndo_open(). It contains the code snippet moved
> from stmmac_hwtstamp_set() that manages the time synchronization. Besides,
> the sub second increment configuration is also moved here since the
> related values are hardware dependent and do not change during runtime.
> 
> Furthermore, the hardware clock must be kept running even when no time
> stamping mode is selected in order to retain the once synced time basis.
> That way, time stamping can be enabled again at any time only with the
> need for compensation of the clock's natural drifting.
> 
> As a side effect, this patch fixes a potential race between SIOCSHWTSTAMP
> and ptp_clock_info::enable regarding priv->systime_flags. Subsequently,
> since this variable becomes deprecated by this commit, it should be
> removed completely in a follow-up patch.
> 
> Fixes: 92ba6888510c ("stmmac: add the support for PTP hw clock driver")
> Fixes: cc4c9001ce31 ("net: stmmac: Switch stmmac_hwtimestamp to generic
> HW Interface Helpers")
> 

Thanks for the patch, minor nits below.

If you post a v2 please don't wrap fixes tags and no space between
those and the other tags.

Also please put the tree in the subject, like [PATCH net 1/2].

Please remember to CC Richard, the PTP maintainer.

> Reported-by: Michael Olbrich <m.olbrich@pengutronix.de>
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Signed-off-by: Holger Assmann <h.assmann@pengutronix.de>
> ---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 121 ++++++++++++------
>  1 file changed, 80 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 5b1c12ff98c0..55f5e6cd1cad 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -46,6 +46,13 @@
>  #include "dwxgmac2.h"
>  #include "hwif.h"
>  
> +

Spurious new line

> +/* As long the interface is active, we keep the timestamping HW enabled with
> + * fine resolution and binary rollover. This avoid non-monotonic behavior
> + * when changing timestamp settings at runtime
> + * */

The */ should be on a line of its own.

> +#define STMMAC_HWTS_ACTIVE (PTP_TCR_TSENA | PTP_TCR_TSCFUPDT | PTP_TCR_TSCTRLSSR)
> +
>  #define	STMMAC_ALIGN(x)		ALIGN(ALIGN(x, SMP_CACHE_BYTES), 16)
>  #define	TSO_MAX_BUFF_SIZE	(SZ_16K - 1)

> @@ -791,6 +772,63 @@ static void stmmac_release_ptp(struct stmmac_priv *priv)
>  	stmmac_ptp_unregister(priv);
>  }
>  
> +/**
> + * stmmac_init_hwtstamp - init Timestamping Hardware
> + * @priv: driver private structure
> + * Description: Initialize hardware for Timestamping use
> + * This is valid as long as the interface is open and not suspended.
> + * Will be rerun after resume from suspension.
> + */
> +static int stmmac_init_hwtstamp(struct stmmac_priv *priv)
> +{
> +	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
> +	struct timespec64 now;
> +	u32 sec_inc = 0;
> +	u64 temp = 0;
> +	u32 value;
> +	int ret;
> +
> +	ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
> +	if (ret < 0) {
> +		netdev_warn(priv->dev, "failed to enable PTP reference clock: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))

!a && !b reads better IMHO

> +		return -EOPNOTSUPP;
> +
> +	value = STMMAC_HWTS_ACTIVE;
> +	stmmac_config_hw_tstamping(priv, priv->ptpaddr, value);
> +
> +	/* program Sub Second Increment reg */
> +	stmmac_config_sub_second_increment(priv,
> +			priv->ptpaddr, priv->plat->clk_ptp_rate,
> +			xmac, &sec_inc);

Now that this code is not indented as much any more please align the
continuation lines under the opening bracket.

> +	temp = div_u64(1000000000ULL, sec_inc);
> +
> +	/* Store sub second increment and flags for later use */
> +	priv->sub_second_inc = sec_inc;
> +	priv->systime_flags = value;
> +
> +	/* calculate default added value:
> +	 * formula is :
> +	 * addend = (2^32)/freq_div_ratio;
> +	 * where, freq_div_ratio = 1e9ns/sec_inc
> +	 */
> +	temp = (u64)(temp << 32);
> +	priv->default_addend = div_u64(temp, priv->plat->clk_ptp_rate);
> +	stmmac_config_addend(priv, priv->ptpaddr, priv->default_addend);
> +
> +	/* initialize system time */
> +	ktime_get_real_ts64(&now);
> +
> +	/* lower 32 bits of tv_sec are safe until y2106 */
> +	stmmac_init_systime(priv, priv->ptpaddr,
> +			(u32)now.tv_sec, now.tv_nsec);

ditto

> +
> +	return 0;
> +}
> +
>  /**
>   *  stmmac_mac_flow_ctrl - Configure flow control in all queues
>   *  @priv: driver private structure
> @@ -2713,15 +2751,17 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
>  	stmmac_mmc_setup(priv);
>  
>  	if (init_ptp) {
> -		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
> -		if (ret < 0)
> -			netdev_warn(priv->dev, "failed to enable PTP reference clock: %d\n", ret);
> -
> -		ret = stmmac_init_ptp(priv);
> -		if (ret == -EOPNOTSUPP)
> -			netdev_warn(priv->dev, "PTP not supported by HW\n");
> -		else if (ret)
> -			netdev_warn(priv->dev, "PTP init failed\n");
> +		ret = stmmac_init_hwtstamp(priv);
> +		if (ret) {
> +			netdev_warn(priv->dev, "HW Timestamping init failed: %pe\n",
> +					ERR_PTR(ret));

why convert to ERR_PTR and use %pe and not just %d?

also continuation misaligned

> +		} else {
> +			ret = stmmac_init_ptp(priv);
> +			if (ret == -EOPNOTSUPP)
> +				netdev_warn(priv->dev, "PTP not supported by HW\n");
> +			else if (ret)
> +				netdev_warn(priv->dev, "PTP init failed\n");
> +		}
>  	}
>  
>  	priv->eee_tw_timer = STMMAC_DEFAULT_TWT_LS;
> @@ -5290,8 +5330,7 @@ int stmmac_resume(struct device *dev)
>  		/* enable the clk previously disabled */
>  		clk_prepare_enable(priv->plat->stmmac_clk);
>  		clk_prepare_enable(priv->plat->pclk);
> -		if (priv->plat->clk_ptp_ref)
> -			clk_prepare_enable(priv->plat->clk_ptp_ref);
> +		stmmac_init_hwtstamp(priv);

This was optional, now you always init?

>  		/* reset the phy so that it's ready */
>  		if (priv->mii)
>  			stmmac_mdio_reset(priv->mii);
> 
> base-commit: 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9

