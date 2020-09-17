Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D583B26D435
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 09:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgIQHGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 03:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgIQHGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 03:06:24 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6941206E6;
        Thu, 17 Sep 2020 07:06:17 +0000 (UTC)
Date:   Thu, 17 Sep 2020 10:06:14 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Vijaya Balan Sadhishkhanna 
        <sadhishkhanna.vijaya.balan@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>
Subject: Re: [PATCH net-next] net: stmmac: introduce rtnl_lock|unlock() on
 configuring real_num_rx|tx_queues
Message-ID: <20200917070614.GP486552@unreal>
References: <20200917050215.8725-1-vee.khee.wong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917050215.8725-1-vee.khee.wong@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 01:02:15PM +0800, Wong Vee Khee wrote:
> From: "Tan, Tee Min" <tee.min.tan@intel.com>
>
> For driver open(), rtnl_lock is acquired by network stack but not in the
> resume(). Therefore, we introduce lock_acquired boolean to control when
> to use rtnl_lock|unlock() within stmmac_hw_setup().

Doesn't really make sense, if function needs to have lock acquired, the
caller is supposed to take it and function should have proper lockdep
annotation inside and not this conditional lock/unlock.

Thanks

>
> Fixes: 686cff3d7022 ("net: stmmac: Fix incorrect location to set real_num_rx|tx_queues")
>

Extra line.

> Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index df2c74bbfcff..22e6a3defa78 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2607,7 +2607,8 @@ static void stmmac_safety_feat_configuration(struct stmmac_priv *priv)
>   *  0 on success and an appropriate (-)ve integer as defined in errno.h
>   *  file on failure.
>   */
> -static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
> +static int stmmac_hw_setup(struct net_device *dev, bool init_ptp,
> +			   bool lock_acquired)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
>  	u32 rx_cnt = priv->plat->rx_queues_to_use;
> @@ -2715,9 +2716,15 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
>  	}
>
>  	/* Configure real RX and TX queues */
> +	if (!lock_acquired)
> +		rtnl_lock();
> +
>  	netif_set_real_num_rx_queues(dev, priv->plat->rx_queues_to_use);
>  	netif_set_real_num_tx_queues(dev, priv->plat->tx_queues_to_use);
>
> +	if (!lock_acquired)
> +		rtnl_unlock();
> +
>  	/* Start the ball rolling... */
>  	stmmac_start_all_dma(priv);
>
> @@ -2804,7 +2811,7 @@ static int stmmac_open(struct net_device *dev)
>  		goto init_error;
>  	}
>
> -	ret = stmmac_hw_setup(dev, true);
> +	ret = stmmac_hw_setup(dev, true, true);
>  	if (ret < 0) {
>  		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
>  		goto init_error;
> @@ -5238,7 +5245,7 @@ int stmmac_resume(struct device *dev)
>
>  	stmmac_clear_descriptors(priv);
>
> -	stmmac_hw_setup(ndev, false);
> +	stmmac_hw_setup(ndev, false, false);
>  	stmmac_init_coalesce(priv);
>  	stmmac_set_rx_mode(ndev);
>
> --
> 2.17.0
>
