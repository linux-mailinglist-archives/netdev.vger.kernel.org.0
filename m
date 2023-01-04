Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9175265D55C
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjADORz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjADOR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:17:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF646BCA0
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 06:17:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FB9FB8166B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 14:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D5EC433D2;
        Wed,  4 Jan 2023 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672841846;
        bh=70yVVqBiABhbGaYgz+MXDYJqrHHcVKlfShZRj/7ZA8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HEYmMatNBFlqAkKxcujIwMf7hvSxK05sbig6D5oAeEZ2cL5JJy6c3u+wfJdp118uJ
         I4D5JlbLdCIShM5SDYADJakbN0+fzU/L3exZHXxZXyrSIMjpGyq1/mjo6O2KwZmfk4
         3LS8GtlqxPMweFtTB7i7z5sqpLVDMs86o+lRv+OxVw+eFd1wD5HTtcQNKpnggquRFG
         TMdpwK0Hzq4VMkWFu1Yr7uKExf4H6JCyd63EpYc+DGnIAS9gtCP4iR4vH/GSE9SWcb
         EqiTbjZDtixxmau1eNyeOynJbhfPovxSf/wLqd3VPmJsyInk/7FJU+mSY9qfoN5aUI
         RoY4kMlK7R4Gw==
Date:   Wed, 4 Jan 2023 16:17:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org
Subject: Re: [PATCH v2 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
Message-ID: <Y7WKcdWap3SrLAp3@unreal>
References: <cover.1672840858.git.lorenzo@kernel.org>
 <3145529a2588bba0ded16fc3c1c93ae799024442.1672840859.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3145529a2588bba0ded16fc3c1c93ae799024442.1672840859.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 03:03:14PM +0100, Lorenzo Bianconi wrote:
> Introduce reset and reset_complete wlan callback to schedule WLAN driver
> reset when ethernet/wed driver is resetting.
> 
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  6 ++++
>  drivers/net/ethernet/mediatek/mtk_wed.c     | 40 +++++++++++++++++++++
>  drivers/net/ethernet/mediatek/mtk_wed.h     |  8 +++++
>  include/linux/soc/mediatek/mtk_wed.h        |  2 ++
>  4 files changed, 56 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index bafae4f0312e..2d74e26f45c9 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -3913,6 +3913,10 @@ static void mtk_pending_work(struct work_struct *work)
>  		mtk_w32(eth, val, MTK_MAC_MCR(i));
>  	}
>  
> +	rtnl_unlock();
> +	mtk_wed_fe_reset();
> +	rtnl_lock();

Is it safe to call rtnl_unlock(), perform some work and lock again?

> +
>  	/* stop all devices to make sure that dma is properly shut down */
>  	for (i = 0; i < MTK_MAC_COUNT; i++) {
>  		if (!eth->netdev[i] || !netif_running(eth->netdev[i]))
> @@ -3949,6 +3953,8 @@ static void mtk_pending_work(struct work_struct *work)
>  
>  	clear_bit(MTK_RESETTING, &eth->state);
>  
> +	mtk_wed_fe_reset_complete();
> +
>  	rtnl_unlock();
>  }
>  
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
> index a6271449617f..4854993f2941 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> @@ -206,6 +206,46 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
>  	iounmap(reg);
>  }
>  
> +void mtk_wed_fe_reset(void)
> +{
> +	int i;
> +
> +	mutex_lock(&hw_lock);
> +
> +	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
> +		struct mtk_wed_hw *hw = hw_list[i];
> +		struct mtk_wed_device *dev = hw->wed_dev;
> +
> +		if (!dev || !dev->wlan.reset)
> +			continue;
> +
> +		/* reset callback blocks until WLAN reset is completed */
> +		if (dev->wlan.reset(dev))
> +			dev_err(dev->dev, "wlan reset failed\n");
> +	}
> +
> +	mutex_unlock(&hw_lock);
> +}
> +
> +void mtk_wed_fe_reset_complete(void)
> +{
> +	int i;
> +
> +	mutex_lock(&hw_lock);
> +
> +	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
> +		struct mtk_wed_hw *hw = hw_list[i];
> +		struct mtk_wed_device *dev = hw->wed_dev;
> +
> +		if (!dev || !dev->wlan.reset_complete)
> +			continue;
> +
> +		dev->wlan.reset_complete(dev);
> +	}
> +
> +	mutex_unlock(&hw_lock);
> +}
> +
>  static struct mtk_wed_hw *
>  mtk_wed_assign(struct mtk_wed_device *dev)
>  {
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.h b/drivers/net/ethernet/mediatek/mtk_wed.h
> index e012b8a82133..6108a7e69a80 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed.h
> +++ b/drivers/net/ethernet/mediatek/mtk_wed.h
> @@ -128,6 +128,8 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
>  void mtk_wed_exit(void);
>  int mtk_wed_flow_add(int index);
>  void mtk_wed_flow_remove(int index);
> +void mtk_wed_fe_reset(void);
> +void mtk_wed_fe_reset_complete(void);
>  #else
>  static inline void
>  mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
> @@ -146,6 +148,12 @@ static inline int mtk_wed_flow_add(int index)
>  static inline void mtk_wed_flow_remove(int index)
>  {
>  }
> +static inline void mtk_wed_fe_reset(void)
> +{
> +}
> +static inline void mtk_wed_fe_reset_complete(void)
> +{
> +}
>  
>  #endif
>  
> diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
> index db637a13888d..ddff54fc9717 100644
> --- a/include/linux/soc/mediatek/mtk_wed.h
> +++ b/include/linux/soc/mediatek/mtk_wed.h
> @@ -150,6 +150,8 @@ struct mtk_wed_device {
>  		void (*release_rx_buf)(struct mtk_wed_device *wed);
>  		void (*update_wo_rx_stats)(struct mtk_wed_device *wed,
>  					   struct mtk_wed_wo_rx_stats *stats);
> +		int (*reset)(struct mtk_wed_device *wed);
> +		int (*reset_complete)(struct mtk_wed_device *wed);

I don't see any driver implementation of these callbacks in this series.
Did I miss it?

Thanks

>  	} wlan;
>  #endif
>  };
> -- 
> 2.39.0
> 
