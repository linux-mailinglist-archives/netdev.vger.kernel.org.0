Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8DB5A3397
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 03:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbiH0Bot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 21:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiH0Bor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 21:44:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF1B133
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 18:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A192ACE2FD5
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 01:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B098FC433D6;
        Sat, 27 Aug 2022 01:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661564681;
        bh=i496oI/Uh3zzL0jlwAqYSPF9rH+b1jIkJiIZa4nYpOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X/F+6W9bfcdHaGy3m2U0gGwtJYNUcng1hVNa3qqQzZHHbD22H6/EbW0bMCv9hg4aV
         klmLhRxqepegv+A6Uru+CNjz4WYSU+4gQMJ1NAl4PSfJmnUeQANMl5UTk9sgTfZD6g
         qJpFl0XnGqDAZkws/IC7oxpQ5XsPQq+sFeEAVcASV6orT9M51KD5wV5sswLTYp1NZO
         u8Pu+/sLgXtFOHhNVturERDaTQQ+xvWaTyp0lA43zOaZpFqMDFGm2/haurP4uKZ7IK
         KR30QYhuB3VdyKWl+o6whvKlas6h2RqQCacGIap2jNIFfcAdIJCgvY1+Ba1NB9k1+y
         V8XjDOEgQRTGA==
Date:   Fri, 26 Aug 2022 18:44:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thinh Tran <thinhtr@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, aelior@marvell.com, davem@davemloft.net,
        manishc@marvell.com, skalluru@marvell.com
Subject: Re: [PATCH] bnx2x: Fix error recovering in switch configuration
Message-ID: <20220826184440.37e7cb85@kernel.org>
In-Reply-To: <20220825200029.4143670-1-thinhtr@linux.vnet.ibm.com>
References: <20220825200029.4143670-1-thinhtr@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 20:00:29 +0000 Thinh Tran wrote:
> As the BCM57810 and other I/O adapters are connected
> through a PCIe switch, the bnx2x driver causes unexpected
> system hang/crash while handling PCIe switch errors, if 
> its error handler is called after other drivers' handlers.
> 
> In this case, after numbers of bnx2x_tx_timout(), the
> bnx2x_nic_unload() is  called, frees up resources and
> calls bnx2x_napi_disable(). Then when EEH calls its
> error handler, the bnx2x_io_error_detected() and
> bnx2x_io_slot_reset() also calling bnx2x_napi_disable()
> and freeing the resources.
> 
> This patch will:
> - reduce the numbers of bnx2x_panic_dump() while in
>   bnx2x_tx_timeout(), avoid filling up dmesg buffer.
> - use checking new napi_enable flags to prevent calling 
>   disable again which causing system hangs.
> - cheking if fp->page_pool already freed avoid system
>   crash.

> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 712b5595bc39..bb8d91f44642 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -1860,37 +1860,49 @@ static int bnx2x_setup_irqs(struct bnx2x *bp)
>  static void bnx2x_napi_enable_cnic(struct bnx2x *bp)
>  {
>  	int i;
> +	if (bp->cnic_napi_enable)

empty line between variables and code, pls

> +		return;
>  
>  	for_each_rx_queue_cnic(bp, i) {
>  		napi_enable(&bnx2x_fp(bp, i, napi));
>  	}
> +	bp->cnic_napi_enable = true;

The concept of not calling napi_enable() / disable()
feels a little wrong. It's the state of the driver,
not the NAPI that's the problem so perhaps you could
a appropriately named bool for that (IDK, maybe 
nic_stopped) and prevent coming into the NAPI handling
functions completely?

Is all other code in the driver on the path in question 
really idempotent?

>  }
>  
>  static void bnx2x_napi_enable(struct bnx2x *bp)
>  {
>  	int i;
> +	if (bp->napi_enable)
> +		return;
>  
>  	for_each_eth_queue(bp, i) {
>  		napi_enable(&bnx2x_fp(bp, i, napi));
>  	}
> +	bp->napi_enable = true;
>  }
>  
>  static void bnx2x_napi_disable_cnic(struct bnx2x *bp)
>  {
>  	int i;
> +	if (!bp->cnic_napi_enable)
> +		return;
>  
>  	for_each_rx_queue_cnic(bp, i) {
>  		napi_disable(&bnx2x_fp(bp, i, napi));
>  	}
> +	bp->cnic_napi_enable = false;
>  }
>  
>  static void bnx2x_napi_disable(struct bnx2x *bp)
>  {
>  	int i;
> +	if (!bp->napi_enable)
> +		return;
>  
>  	for_each_eth_queue(bp, i) {
>  		napi_disable(&bnx2x_fp(bp, i, napi));
>  	}
> +	bp->napi_enable = false;
>  }
>  
>  void bnx2x_netif_start(struct bnx2x *bp)
> @@ -2554,6 +2566,7 @@ int bnx2x_load_cnic(struct bnx2x *bp)
>  	}
>  
>  	/* Add all CNIC NAPI objects */
> +	bp->cnic_napi_enable = false;
>  	bnx2x_add_all_napi_cnic(bp);
>  	DP(NETIF_MSG_IFUP, "cnic napi added\n");
>  	bnx2x_napi_enable_cnic(bp);
> @@ -2701,7 +2714,9 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
>  	 */
>  	bnx2x_setup_tc(bp->dev, bp->max_cos);
>  
> +	bp->tx_timeout_cnt = 0;
>  	/* Add all NAPI objects */
> +	bp->napi_enable = false;
>  	bnx2x_add_all_napi(bp);
>  	DP(NETIF_MSG_IFUP, "napi added\n");
>  	bnx2x_napi_enable(bp);
> @@ -4982,7 +4997,14 @@ void bnx2x_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  	 */
>  	if (!bp->panic)
>  #ifndef BNX2X_STOP_ON_ERROR
> -		bnx2x_panic_dump(bp, false);
> +	{
> +		if (++bp->tx_timeout_cnt > 3) {
> +			bnx2x_panic_dump(bp, false);
> +			bp->tx_timeout_cnt = 0;
> +		} else {
> +			netdev_err(bp->dev, "TX timeout %d times\n", bp->tx_timeout_cnt);
> +		}
> +	}

Please put this code in a helper function so that the oddly looking
brackets are not needed.

>  #else
>  		bnx2x_panic();
>  #endif
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
> index d8b1824c334d..7e1d38a2c7ec 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
> @@ -1018,6 +1018,9 @@ static inline void bnx2x_free_rx_sge_range(struct bnx2x *bp,
>  	if (fp->mode == TPA_MODE_DISABLED)
>  		return;
>  
> +	if (!fp->page_pool.page)
> +		return;

See, another thing that's not idempotent. Better to bail higher up,
in the callee.

>  	for (i = 0; i < last; i++)
>  		bnx2x_free_rx_sge(bp, fp, i);
>  

