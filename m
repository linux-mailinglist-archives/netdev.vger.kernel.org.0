Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8767B28C3A9
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbgJLVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731635AbgJLVAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 17:00:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ABF720790;
        Mon, 12 Oct 2020 21:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602536417;
        bh=o6aZLtcP0Ru/D0IbfSOrni7YBea1LE5S2GYGPX37jlA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PfXi3D+xFp0/gDRVGf92V50G0aS+RMkpBk7nPR2CRu6kJE9Xsa4qo6d6Mfx0kVrE7
         wJNo0UIgU2t8HHPH/8lJepgp8VfojQBAa8bJzr9TEoKAX+B5jToDulIhcmzq9mes7o
         JmFEpMHxUcT4USS9IJLgzOmS/m+FiZ9ozcQ4/CVk=
Date:   Mon, 12 Oct 2020 14:00:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: Re: [PATCH v1 net-next] net: stmmac: Enable EEE HW LPI timer with
 auto SW/HW switching
Message-ID: <20201012140015.2fa2be66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008161123.9317-1-weifeng.voon@intel.com>
References: <20201008161123.9317-1-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Oct 2020 00:11:23 +0800 Voon Weifeng wrote:
> From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> 
> This patch enables the HW LPI Timer which controls the automatic entry
> and exit of the LPI state.
> The EEE LPI timer value is configured through ethtool. The driver will
> auto select the LPI HW timer if the value in the HW timer supported range.
> Else, the driver will fallback to SW timer.
> 
> Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

minor nits, but the patch makes sense to me
please repost soon so it makes it into 5.10

> diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
> index df7de50497a0..f59c4a1c1674 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/common.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/common.h
> @@ -402,6 +402,9 @@ struct dma_features {
>  /* Default LPI timers */
>  #define STMMAC_DEFAULT_LIT_LS	0x3E8
>  #define STMMAC_DEFAULT_TWT_LS	0x1E
> +#define STMMAC_ET_MAX		0xFFFFF
> +#define LPI_ET_ENABLE		1
> +#define LPI_ET_DISABLE		0

Don't think you need defines for true / false values like that.
Just use literals.

>  
>  #define STMMAC_CHAIN_MODE	0x1
>  #define STMMAC_RING_MODE	0x2

> @@ -268,6 +269,7 @@ int stmmac_dvr_probe(struct device *device,
>  		     struct stmmac_resources *res);
>  void stmmac_disable_eee_mode(struct stmmac_priv *priv);
>  bool stmmac_eee_init(struct stmmac_priv *priv);
> +void stmmac_lpi_entry_timer_enable(struct stmmac_priv *priv, bool en);

This doesn't have to be declared in the header...

>  int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
>  int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
>  
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 220626a8d499..908df3cb12cd 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -327,6 +327,11 @@ static void stmmac_enable_eee_mode(struct stmmac_priv *priv)
>   */
>  void stmmac_disable_eee_mode(struct stmmac_priv *priv)
>  {
> +	if (!priv->eee_sw_timer_en) {
> +		stmmac_lpi_entry_timer_enable(priv, LPI_ET_DISABLE);
> +		return;
> +	}
> +
>  	stmmac_reset_eee_mode(priv, priv->hw);
>  	del_timer_sync(&priv->eee_ctrl_timer);
>  	priv->tx_path_in_lpi_mode = false;
> @@ -347,6 +352,16 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
>  	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
>  }
>  
> +void stmmac_lpi_entry_timer_enable(struct stmmac_priv *priv, bool en)
> +{

Just move this function up in the file so it's defined before
stmmac_disable_eee_mode(). We prefer to limit forward declarations 
in the kernel.

Also the name of the function would probably be better as
..._timer_config() or such. I find it strange to call a function called
enable() to disable something.

> +	int tx_lpi_timer;
> +
> +	/* Clear/set the SW EEE timer flag based on LPI ET enablement */
> +	priv->eee_sw_timer_en = en ? 0 : 1;
> +	tx_lpi_timer  = en ? priv->tx_lpi_timer : 0;
> +	stmmac_set_eee_lpi_timer(priv, priv->hw, tx_lpi_timer);
> +}
