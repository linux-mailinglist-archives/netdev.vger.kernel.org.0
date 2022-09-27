Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928215EC338
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiI0Mrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiI0Mro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4BB15EF9E
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664282862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RKYdTgxfiI7eUQWmaftKyjIz9jtORAAmbtWWAfEZHco=;
        b=UAXJ8JHZZjf02chU6pWG2gef7Fagh97Rhwm5tc0Tfi2wtI4oDcDO3W7LrgxraIRRmttaRU
        IQRPcvkTmyNdDJ5VzrLxwJH5HbdmYa1/JyN/KJc6NNvsB7O647mWuyC3kX3XT+BLMrTxQQ
        vaLcPi2Sve6gkrKyvfEwYMA08aF2aCI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-294-6PGFKnI_PYOHMa2fuzH5wg-1; Tue, 27 Sep 2022 08:47:41 -0400
X-MC-Unique: 6PGFKnI_PYOHMa2fuzH5wg-1
Received: by mail-wr1-f70.google.com with SMTP id d18-20020adfa352000000b0022cbe33d2a5so556638wrb.11
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=RKYdTgxfiI7eUQWmaftKyjIz9jtORAAmbtWWAfEZHco=;
        b=GnIPfsGO1X9Y97NE68Aa9tzf4j+9nKHfrt9fo9kIux268JBIEs9cEJ6P7G34ZIiCNj
         xWwGiPDKWWTm3VLpmfM9lcf/Qo66RgCvWyjBX5uwARDmUzBWNMCg+w8yYMGj4zehxuTq
         u13ztpr7uDYuJ6XeYSLwmlehVDMiJ+sT/KZz2m5ktghyhkR+tYLUaQ4VTvADfBo/IrdX
         mLvYUoeTfRfoxidSX9c3ztqDqPWLD6jZQUfvyZcrhm3dA2+nrIgb5wEX5Q+mvYFQKcMI
         aIA1KftzfGnBZ0BK1YNaH9IIeMRetWqS7JNDYZSD1hQbAn3Lpupjj9nwDDIXBU+nK2GP
         kTag==
X-Gm-Message-State: ACrzQf14VAX6vOSutUzzmPZt2mxI2MJx2ZR8Yfx2q9JAIcB4gO8VLFDP
        n42S7KhX2L0rT9RmwSEekVVKFeUs8zaI03nXMQ6wX6NqD6Ys99IQMaZVzTvAPXzzs/CZVZyuKpq
        1kvVFBkjLFYsUzvV3
X-Received: by 2002:a05:600c:1c8e:b0:3b4:9247:7ecc with SMTP id k14-20020a05600c1c8e00b003b492477eccmr2605543wms.40.1664282859869;
        Tue, 27 Sep 2022 05:47:39 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Myca2MVKkV2KIt1XKsStTkT5Gg0d+r20JLISzms+daySu0V3MrOItm8S8N740Ssa8OX/cUA==
X-Received: by 2002:a05:600c:1c8e:b0:3b4:9247:7ecc with SMTP id k14-20020a05600c1c8e00b003b492477eccmr2605503wms.40.1664282859434;
        Tue, 27 Sep 2022 05:47:39 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id z2-20020a05600c0a0200b003b51a4c61aasm9330179wmp.40.2022.09.27.05.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 05:47:39 -0700 (PDT)
Message-ID: <83c9e18e27084a3458f1e4c928eb6fe603e37e0e.camel@redhat.com>
Subject: Re: [PATCH net-next v2 03/12] net: dpaa2-eth: add support for
 multiple buffer pools per DPNI
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Date:   Tue, 27 Sep 2022 14:47:37 +0200
In-Reply-To: <20220923154556.721511-4-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
         <20220923154556.721511-4-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-23 at 18:45 +0300, Ioana Ciornei wrote:
> From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
> 
> This patch allows the configuration of multiple buffer pools associated
> with a single DPNI object, each distinct DPBP object not necessarily
> shared among all queues.
> The user can interogate both the number of buffer pools and the buffer
> count in each buffer pool by using the .get_ethtool_stats() callback.
> 
> Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - Export dpaa2_eth_allocate_dpbp/dpaa2_eth_free_dpbp in this patch to
>    avoid a build warning. The functions will be used in next patches.
> 
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 188 ++++++++++++------
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  26 ++-
>  .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  15 +-
>  3 files changed, 162 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 75d51572693d..aa93ed339b63 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>  /* Copyright 2014-2016 Freescale Semiconductor Inc.
> - * Copyright 2016-2020 NXP
> + * Copyright 2016-2022 NXP
>   */
>  #include <linux/init.h>
>  #include <linux/module.h>
> @@ -304,7 +304,7 @@ static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
>  	if (ch->recycled_bufs_cnt < DPAA2_ETH_BUFS_PER_CMD)
>  		return;
>  
> -	while ((err = dpaa2_io_service_release(ch->dpio, priv->bpid,
> +	while ((err = dpaa2_io_service_release(ch->dpio, ch->bp->bpid,
>  					       ch->recycled_bufs,
>  					       ch->recycled_bufs_cnt)) == -EBUSY) {
>  		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
> @@ -1631,7 +1631,7 @@ static int dpaa2_eth_set_tx_csum(struct dpaa2_eth_priv *priv, bool enable)
>   * to the specified buffer pool
>   */
>  static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
> -			      struct dpaa2_eth_channel *ch, u16 bpid)
> +			      struct dpaa2_eth_channel *ch)
>  {
>  	struct device *dev = priv->net_dev->dev.parent;
>  	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
> @@ -1663,12 +1663,12 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
>  		trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
>  					 DPAA2_ETH_RX_BUF_RAW_SIZE,
>  					 addr, priv->rx_buf_size,
> -					 bpid);
> +					 ch->bp->bpid);
>  	}
>  
>  release_bufs:
>  	/* In case the portal is busy, retry until successful */
> -	while ((err = dpaa2_io_service_release(ch->dpio, bpid,
> +	while ((err = dpaa2_io_service_release(ch->dpio, ch->bp->bpid,
>  					       buf_array, i)) == -EBUSY) {
>  		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
>  			break;
> @@ -1697,39 +1697,59 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
>  	return 0;
>  }
>  
> -static int dpaa2_eth_seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
> +static int dpaa2_eth_seed_pool(struct dpaa2_eth_priv *priv,
> +			       struct dpaa2_eth_channel *ch)
>  {
> -	int i, j;
> +	int i;
>  	int new_count;
>  
> -	for (j = 0; j < priv->num_channels; j++) {
> -		for (i = 0; i < DPAA2_ETH_NUM_BUFS;
> -		     i += DPAA2_ETH_BUFS_PER_CMD) {
> -			new_count = dpaa2_eth_add_bufs(priv, priv->channel[j], bpid);
> -			priv->channel[j]->buf_count += new_count;
> +	for (i = 0; i < DPAA2_ETH_NUM_BUFS; i += DPAA2_ETH_BUFS_PER_CMD) {
> +		new_count = dpaa2_eth_add_bufs(priv, ch);
> +		ch->buf_count += new_count;
>  
> -			if (new_count < DPAA2_ETH_BUFS_PER_CMD) {
> -				return -ENOMEM;
> -			}
> -		}
> +		if (new_count < DPAA2_ETH_BUFS_PER_CMD)
> +			return -ENOMEM;
>  	}
>  
>  	return 0;
>  }
>  
> +static void dpaa2_eth_seed_pools(struct dpaa2_eth_priv *priv)
> +{
> +	struct net_device *net_dev = priv->net_dev;
> +	struct dpaa2_eth_channel *channel;
> +	int i, err = 0;
> +
> +	for (i = 0; i < priv->num_channels; i++) {
> +		channel = priv->channel[i];
> +
> +		err = dpaa2_eth_seed_pool(priv, channel);
> +
> +		/* Not much to do; the buffer pool, though not filled up,
> +		 * may still contain some buffers which would enable us
> +		 * to limp on.
> +		 */
> +		if (err)
> +			netdev_err(net_dev, "Buffer seeding failed for DPBP %d (bpid=%d)\n",
> +				   channel->bp->dev->obj_desc.id,
> +				   channel->bp->bpid);
> +	}
> +}
> +
>  /*
> - * Drain the specified number of buffers from the DPNI's private buffer pool.
> + * Drain the specified number of buffers from one of the DPNI's private buffer
> + * pools.
>   * @count must not exceeed DPAA2_ETH_BUFS_PER_CMD
>   */
> -static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int count)
> +static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int bpid,
> +				 int count)
>  {
>  	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
>  	int retries = 0;
>  	int ret;
>  
>  	do {
> -		ret = dpaa2_io_service_acquire(NULL, priv->bpid,
> -					       buf_array, count);
> +		ret = dpaa2_io_service_acquire(NULL, bpid, buf_array, count);
>  		if (ret < 0) {
>  			if (ret == -EBUSY &&
>  			    retries++ < DPAA2_ETH_SWP_BUSY_RETRIES)
> @@ -1742,23 +1762,35 @@ static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int count)
>  	} while (ret);
>  }
>  
> -static void dpaa2_eth_drain_pool(struct dpaa2_eth_priv *priv)
> +static void dpaa2_eth_drain_pool(struct dpaa2_eth_priv *priv, int bpid)
>  {
>  	int i;
>  
> -	dpaa2_eth_drain_bufs(priv, DPAA2_ETH_BUFS_PER_CMD);
> -	dpaa2_eth_drain_bufs(priv, 1);
> +	/* Drain the buffer pool */
> +	dpaa2_eth_drain_bufs(priv, bpid, DPAA2_ETH_BUFS_PER_CMD);
> +	dpaa2_eth_drain_bufs(priv, bpid, 1);
>  
> +	/* Setup to zero the buffer count of all channels which were
> +	 * using this buffer pool.
> +	 */
>  	for (i = 0; i < priv->num_channels; i++)
> -		priv->channel[i]->buf_count = 0;
> +		if (priv->channel[i]->bp->bpid == bpid)
> +			priv->channel[i]->buf_count = 0;
> +}
> +
> +static void dpaa2_eth_drain_pools(struct dpaa2_eth_priv *priv)
> +{
> +	int i;
> +
> +	for (i = 0; i < priv->num_bps; i++)
> +		dpaa2_eth_drain_pool(priv, priv->bp[i]->bpid);
>  }
>  
>  /* Function is called from softirq context only, so we don't need to guard
>   * the access to percpu count
>   */
>  static int dpaa2_eth_refill_pool(struct dpaa2_eth_priv *priv,
> -				 struct dpaa2_eth_channel *ch,
> -				 u16 bpid)
> +				 struct dpaa2_eth_channel *ch)
>  {
>  	int new_count;
>  
> @@ -1766,7 +1798,7 @@ static int dpaa2_eth_refill_pool(struct dpaa2_eth_priv *priv,
>  		return 0;
>  
>  	do {
> -		new_count = dpaa2_eth_add_bufs(priv, ch, bpid);
> +		new_count = dpaa2_eth_add_bufs(priv, ch);
>  		if (unlikely(!new_count)) {
>  			/* Out of memory; abort for now, we'll try later on */
>  			break;
> @@ -1848,7 +1880,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
>  			break;
>  
>  		/* Refill pool if appropriate */
> -		dpaa2_eth_refill_pool(priv, ch, priv->bpid);
> +		dpaa2_eth_refill_pool(priv, ch);
>  
>  		store_cleaned = dpaa2_eth_consume_frames(ch, &fq);
>  		if (store_cleaned <= 0)
> @@ -2047,15 +2079,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
>  	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
>  	int err;
>  
> -	err = dpaa2_eth_seed_pool(priv, priv->bpid);
> -	if (err) {
> -		/* Not much to do; the buffer pool, though not filled up,
> -		 * may still contain some buffers which would enable us
> -		 * to limp on.
> -		 */
> -		netdev_err(net_dev, "Buffer seeding failed for DPBP %d (bpid=%d)\n",
> -			   priv->dpbp_dev->obj_desc.id, priv->bpid);
> -	}
> +	dpaa2_eth_seed_pools(priv);
>  
>  	if (!dpaa2_eth_is_type_phy(priv)) {
>  		/* We'll only start the txqs when the link is actually ready;
> @@ -2088,7 +2112,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
>  
>  enable_err:
>  	dpaa2_eth_disable_ch_napi(priv);
> -	dpaa2_eth_drain_pool(priv);
> +	dpaa2_eth_drain_pools(priv);
>  	return err;
>  }
>  
> @@ -2193,7 +2217,7 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
>  	dpaa2_eth_disable_ch_napi(priv);
>  
>  	/* Empty the buffer pool */
> -	dpaa2_eth_drain_pool(priv);
> +	dpaa2_eth_drain_pools(priv);
>  
>  	/* Empty the Scatter-Gather Buffer cache */
>  	dpaa2_eth_sgt_cache_drain(priv);
> @@ -3204,13 +3228,14 @@ static void dpaa2_eth_setup_fqs(struct dpaa2_eth_priv *priv)
>  	dpaa2_eth_set_fq_affinity(priv);
>  }
>  
> -/* Allocate and configure one buffer pool for each interface */
> -static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
> +/* Allocate and configure a buffer pool */
> +struct dpaa2_eth_bp *dpaa2_eth_allocate_dpbp(struct dpaa2_eth_priv *priv)
>  {
> -	int err;
> -	struct fsl_mc_device *dpbp_dev;
>  	struct device *dev = priv->net_dev->dev.parent;
> +	struct fsl_mc_device *dpbp_dev;
>  	struct dpbp_attr dpbp_attrs;
> +	struct dpaa2_eth_bp *bp;
> +	int err;
>  
>  	err = fsl_mc_object_allocate(to_fsl_mc_device(dev), FSL_MC_POOL_DPBP,
>  				     &dpbp_dev);
> @@ -3219,12 +3244,16 @@ static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
>  			err = -EPROBE_DEFER;
>  		else
>  			dev_err(dev, "DPBP device allocation failed\n");
> -		return err;
> +		return ERR_PTR(err);
>  	}
>  
> -	priv->dpbp_dev = dpbp_dev;
> +	bp = kzalloc(sizeof(*bp), GFP_KERNEL);
> +	if (!bp) {
> +		err = -ENOMEM;
> +		goto err_alloc;
> +	}

It looks like 'bp' is leaked on later error paths.

Cheers,

Paolo

