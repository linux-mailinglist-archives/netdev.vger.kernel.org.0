Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087DC52081A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiEIXF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbiEIXF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:05:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BD7201B7;
        Mon,  9 May 2022 16:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB7F2B817CC;
        Mon,  9 May 2022 23:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04756C385C3;
        Mon,  9 May 2022 23:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652137319;
        bh=zUbTEVVseYBgx5Ro9Lro0bTRJULUeBVRav353AcrrgM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Opu38XGBpSmjylWzYpuaTyO/7O6xDWE8KmQYoAxguyBW0Kfrm/B+HdK/dVC+4tQsA
         ICyzr6l+3I5SOTWzDWXvCj2vqj20xGe0xYKsKhnOzatUHCFL33dP+OXaZ0Rnq+ZN3T
         4VFSjnkCH6fW1KnS8pObJ5d7uJ0Na/AjHxg02C26YwjpMAtQ+pe8XrdjPokxA7Xwjr
         bSrLyG9oiJ6cLZJTqk+kdOLgfbgDRaoyXShYIav87fl4MzoziZfje6uRQKzsHgT2g4
         KldGcmx9peJzwVMz97jb7bkoUyABf3bzOEHhyxdFSGcRxJXzRzidOB/65JyF0ppxa5
         x+884/JMwCwKQ==
Date:   Mon, 9 May 2022 16:01:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zixuan Fu <r33s3n6@gmail.com>
Cc:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: Re: [PATCH] drivers: net: vmxnet3: fix possible NULL pointer
 dereference in vmxnet3_rq_cleanup()
Message-ID: <20220509160157.3a3778fa@kernel.org>
In-Reply-To: <20220506133748.2799853-1-r33s3n6@gmail.com>
References: <20220506133748.2799853-1-r33s3n6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 May 2022 21:37:48 +0800 Zixuan Fu wrote:
> In vmxnet3_rq_create(), when dma_alloc_coherent() fails, 
> vmxnet3_rq_destroy() is called. It sets rq->rx_ring[i].base to NULL. Then
> vmxnet3_rq_create() returns an error to its callers mxnet3_rq_create_all()

                                                      vmxnet3_rq_create_all()

> -> vmxnet3_change_mtu(). Then vmxnet3_change_mtu() calls   
> vmxnet3_force_close() -> dev_close() in error handling code. And the driver
> calls vmxnet3_close() -> vmxnet3_quiesce_dev() -> vmxnet3_rq_cleanup_all()
> -> vmxnet3_rq_cleanup(). In vmxnet3_rq_cleanup(),   
> rq->rx_ring[ring_idx].base is accessed, but this variable is NULL, causing
> a NULL pointer dereference.
> 
> To fix this possible bug, an if statement is added to check whether 
> rq->rx_ring[ring_idx].base is NULL in vmxnet3_rq_cleanup().
> 
> The error log in our fault-injection testing is shown as follows:
> 
> [   65.220135] BUG: kernel NULL pointer dereference, address: 0000000000000008
> ...
> [   65.222633] RIP: 0010:vmxnet3_rq_cleanup_all+0x396/0x4e0 [vmxnet3]
> ...
> [   65.227977] Call Trace:
> ...
> [   65.228262]  vmxnet3_quiesce_dev+0x80f/0x8a0 [vmxnet3]
> [   65.228580]  vmxnet3_close+0x2c4/0x3f0 [vmxnet3]
> [   65.228866]  __dev_close_many+0x288/0x350
> [   65.229607]  dev_close_many+0xa4/0x480
> [   65.231124]  dev_close+0x138/0x230
> [   65.231933]  vmxnet3_force_close+0x1f0/0x240 [vmxnet3]
> [   65.232248]  vmxnet3_change_mtu+0x75d/0x920 [vmxnet3]
> ...
> 
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c | 42 ++++++++++++++++---------------
>  1 file changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index d9d90baac72a..247fbdfe834a 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -1667,28 +1667,30 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
>  	struct Vmxnet3_RxDesc *rxd;

If destroy_all got called presumably we can just check ring 0 is NULL
and exit early rather than skipping ring by ring?

Either way, please rewrite the change so you don't have to re-indent
the entire block.

>  	for (ring_idx = 0; ring_idx < 2; ring_idx++) {
> -		for (i = 0; i < rq->rx_ring[ring_idx].size; i++) {
> -#ifdef __BIG_ENDIAN_BITFIELD
> -			struct Vmxnet3_RxDesc rxDesc;
> -#endif
> -			vmxnet3_getRxDesc(rxd,
> -				&rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
> -
> -			if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> -					rq->buf_info[ring_idx][i].skb) {
> -				dma_unmap_single(&adapter->pdev->dev, rxd->addr,
> -						 rxd->len, DMA_FROM_DEVICE);
> -				dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
> -				rq->buf_info[ring_idx][i].skb = NULL;
> -			} else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
> -					rq->buf_info[ring_idx][i].page) {
> -				dma_unmap_page(&adapter->pdev->dev, rxd->addr,
> -					       rxd->len, DMA_FROM_DEVICE);
> -				put_page(rq->buf_info[ring_idx][i].page);
> -				rq->buf_info[ring_idx][i].page = NULL;
> +		if (rq->rx_ring[ring_idx].base) {
> +			for (i = 0; i < rq->rx_ring[ring_idx].size; i++) {
> +	#ifdef __BIG_ENDIAN_BITFIELD
> +				struct Vmxnet3_RxDesc rxDesc;
> +	#endif
> +				vmxnet3_getRxDesc(rxd,
> +					&rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
> +
> +				if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> +						rq->buf_info[ring_idx][i].skb) {
> +					dma_unmap_single(&adapter->pdev->dev, rxd->addr,
> +							 rxd->len, DMA_FROM_DEVICE);
> +					dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
> +					rq->buf_info[ring_idx][i].skb = NULL;
> +				} else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
> +						rq->buf_info[ring_idx][i].page) {
> +					dma_unmap_page(&adapter->pdev->dev, rxd->addr,
> +						       rxd->len, DMA_FROM_DEVICE);
> +					put_page(rq->buf_info[ring_idx][i].page);
> +					rq->buf_info[ring_idx][i].page = NULL;
> +				}
>  			}
>  		}
> -
> +

What's this change?

>  		rq->rx_ring[ring_idx].gen = VMXNET3_INIT_GEN;
>  		rq->rx_ring[ring_idx].next2fill =
>  					rq->rx_ring[ring_idx].next2comp = 0;

