Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0464351B5A8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 04:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbiEECPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 22:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiEECPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 22:15:39 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83FC47399
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 19:12:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VCEWZQR_1651716717;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VCEWZQR_1651716717)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 05 May 2022 10:11:57 +0800
Message-ID: <1651716696.4057877-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 2/2] net: move snowflake callers to netif_napi_add_tx_weight()
Date:   Thu, 5 May 2022 10:11:36 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, claudiu.manoil@nxp.com,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, davem@davemloft.net
References: <20220504163725.550782-1-kuba@kernel.org>
 <20220504163725.550782-2-kuba@kernel.org>
In-Reply-To: <20220504163725.550782-2-kuba@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 May 2022 09:37:25 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> Make the drivers with custom tx napi weight call netif_napi_add_tx_weight().
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: claudiu.manoil@nxp.com
> CC: bryan.whitehead@microchip.com
> CC: UNGLinuxDriver@microchip.com
> CC: mst@redhat.com
> CC: jasowang@redhat.com
> CC: virtualization@lists.linux-foundation.org
> ---
>  drivers/net/ethernet/freescale/gianfar.c      | 4 ++--
>  drivers/net/ethernet/microchip/lan743x_main.c | 6 +++---
>  drivers/net/virtio_net.c                      | 5 +++--
>  3 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> index f0b652a65043..3dc9369a33f7 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -3233,8 +3233,8 @@ static int gfar_probe(struct platform_device *ofdev)
>  	for (i = 0; i < priv->num_grps; i++) {
>  		netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
>  			       gfar_poll_rx_sq, NAPI_POLL_WEIGHT);
> -		netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
> -				  gfar_poll_tx_sq, 2);
> +		netif_napi_add_tx_weight(dev, &priv->gfargrp[i].napi_tx,
> +					 gfar_poll_tx_sq, 2);
>  	}
>
>  	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 9ac0c2b96a15..efbddf24ba31 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -2044,9 +2044,9 @@ static int lan743x_tx_open(struct lan743x_tx *tx)
>  	tx->vector_flags = lan743x_intr_get_vector_flags(adapter,
>  							 INT_BIT_DMA_TX_
>  							 (tx->channel_number));
> -	netif_tx_napi_add(adapter->netdev,
> -			  &tx->napi, lan743x_tx_napi_poll,
> -			  tx->ring_size - 1);
> +	netif_napi_add_tx_weight(adapter->netdev,
> +				 &tx->napi, lan743x_tx_napi_poll,
> +				 tx->ring_size - 1);
>  	napi_enable(&tx->napi);
>
>  	data = 0;
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index cbba9d2e8f32..ebb98b796352 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3315,8 +3315,9 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>  		vi->rq[i].pages = NULL;
>  		netif_napi_add(vi->dev, &vi->rq[i].napi, virtnet_poll,
>  			       napi_weight);
> -		netif_tx_napi_add(vi->dev, &vi->sq[i].napi, virtnet_poll_tx,
> -				  napi_tx ? napi_weight : 0);
> +		netif_napi_add_tx_weight(vi->dev, &vi->sq[i].napi,
> +					 virtnet_poll_tx,
> +					 napi_tx ? napi_weight : 0);

for virtio-net:

Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


>
>  		sg_init_table(vi->rq[i].sg, ARRAY_SIZE(vi->rq[i].sg));
>  		ewma_pkt_len_init(&vi->rq[i].mrg_avg_pkt_len);
> --
> 2.34.1
>
