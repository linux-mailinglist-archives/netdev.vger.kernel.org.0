Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAE63036C8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 07:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbhAZGpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 01:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388076AbhAZGn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 01:43:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C95B822B3F;
        Tue, 26 Jan 2021 06:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611643367;
        bh=bYiLoT3jWDdN2YAySXxdPXkMujwT9IfHnqKAdrHmEVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qY36ekrKI0/nHDx0hnxfvQiTgHH8mlKp0aLjhUc1ZSfIKXe9S+HVlLXym9EWalUKQ
         mfM7HhPI9VPpoi7nVwVVltlV1Twycv2hyeIujujgty8YiwfkBB9BnQewfZX9CqhuZM
         5rMhu10gGKbSiW1yCfQz/4HmcvClXpMbuyUK/Fiw4kn6F/WAvJDGARgNSQs/DQ3myn
         jz8x5oW0Z16ZD9o8JOPziCkgFy3qnPPf414lBQQ1lD5bshawHxNOgk/NWPpspkRKkE
         bkinF8HPZSDtO4d6nOyTaq3zKbGcM2Kyc21b1uIlTSLihNUqeBpNsj2QVqVhK51rLM
         hR+DWzByAfGEg==
Date:   Tue, 26 Jan 2021 08:13:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, Petr Vandrovec <petr@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next] Remove buf_info from device accessible
 structures
Message-ID: <20210126061344.GA1053290@unreal>
References: <20210125223456.25043-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125223456.25043-1-doshir@vmware.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 02:34:56PM -0800, Ronak Doshi wrote:
> vmxnet3: Remove buf_info from device accessible structures

This line should be part of the "Subject: ..." and not as separated line.

Thanks

>
> buf_info structures in RX & TX queues are private driver data that
> do not need to be visible to the device.  Although there is physical
> address and length in the queue descriptor that points to these
> structures, their layout is not standardized, and device never looks
> at them.
>
> So lets allocate these structures in non-DMA-able memory, and fill
> physical address as all-ones and length as zero in the queue
> descriptor.
>
> That should alleviate worries brought by Martin Radev in
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210104/022829.html
> that malicious vmxnet3 device could subvert SVM/TDX guarantees.
>
> Signed-off-by: Petr Vandrovec <petr@vmware.com>
> Signed-off-by: Ronak Doshi <doshir@vmware.com>
> ---
> Changes in v2:
>  - Use kcalloc_node()
>  - Remove log for memory allocation failure
> Changes in v3:
>  - Do not pass __GFP_ZERO to kcalloc
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c | 37 ++++++++++++-------------------------
>  drivers/net/vmxnet3/vmxnet3_int.h |  2 --
>  2 files changed, 12 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index 336504b7531d..419e81b21d9b 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -452,9 +452,7 @@ vmxnet3_tq_destroy(struct vmxnet3_tx_queue *tq,
>  		tq->comp_ring.base = NULL;
>  	}
>  	if (tq->buf_info) {
> -		dma_free_coherent(&adapter->pdev->dev,
> -				  tq->tx_ring.size * sizeof(tq->buf_info[0]),
> -				  tq->buf_info, tq->buf_info_pa);
> +		kfree(tq->buf_info);
>  		tq->buf_info = NULL;
>  	}
>  }
> @@ -505,8 +503,6 @@ static int
>  vmxnet3_tq_create(struct vmxnet3_tx_queue *tq,
>  		  struct vmxnet3_adapter *adapter)
>  {
> -	size_t sz;
> -
>  	BUG_ON(tq->tx_ring.base || tq->data_ring.base ||
>  	       tq->comp_ring.base || tq->buf_info);
>
> @@ -534,9 +530,9 @@ vmxnet3_tq_create(struct vmxnet3_tx_queue *tq,
>  		goto err;
>  	}
>
> -	sz = tq->tx_ring.size * sizeof(tq->buf_info[0]);
> -	tq->buf_info = dma_alloc_coherent(&adapter->pdev->dev, sz,
> -					  &tq->buf_info_pa, GFP_KERNEL);
> +	tq->buf_info = kcalloc_node(tq->tx_ring.size, sizeof(tq->buf_info[0]),
> +				    GFP_KERNEL,
> +				    dev_to_node(&adapter->pdev->dev));
>  	if (!tq->buf_info)
>  		goto err;
>
> @@ -1738,10 +1734,7 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
>  	}
>
>  	if (rq->buf_info[0]) {
> -		size_t sz = sizeof(struct vmxnet3_rx_buf_info) *
> -			(rq->rx_ring[0].size + rq->rx_ring[1].size);
> -		dma_free_coherent(&adapter->pdev->dev, sz, rq->buf_info[0],
> -				  rq->buf_info_pa);
> +		kfree(rq->buf_info[0]);
>  		rq->buf_info[0] = rq->buf_info[1] = NULL;
>  	}
>  }
> @@ -1883,10 +1876,9 @@ vmxnet3_rq_create(struct vmxnet3_rx_queue *rq, struct vmxnet3_adapter *adapter)
>  		goto err;
>  	}
>
> -	sz = sizeof(struct vmxnet3_rx_buf_info) * (rq->rx_ring[0].size +
> -						   rq->rx_ring[1].size);
> -	bi = dma_alloc_coherent(&adapter->pdev->dev, sz, &rq->buf_info_pa,
> -				GFP_KERNEL);
> +	bi = kcalloc_node(rq->rx_ring[0].size + rq->rx_ring[1].size,
> +			  sizeof(rq->buf_info[0][0]), GFP_KERNEL,
> +			  dev_to_node(&adapter->pdev->dev));
>  	if (!bi)
>  		goto err;
>
> @@ -2522,14 +2514,12 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
>  		tqc->txRingBasePA   = cpu_to_le64(tq->tx_ring.basePA);
>  		tqc->dataRingBasePA = cpu_to_le64(tq->data_ring.basePA);
>  		tqc->compRingBasePA = cpu_to_le64(tq->comp_ring.basePA);
> -		tqc->ddPA           = cpu_to_le64(tq->buf_info_pa);
> +		tqc->ddPA           = cpu_to_le64(~0ULL);
>  		tqc->txRingSize     = cpu_to_le32(tq->tx_ring.size);
>  		tqc->dataRingSize   = cpu_to_le32(tq->data_ring.size);
>  		tqc->txDataRingDescSize = cpu_to_le32(tq->txdata_desc_size);
>  		tqc->compRingSize   = cpu_to_le32(tq->comp_ring.size);
> -		tqc->ddLen          = cpu_to_le32(
> -					sizeof(struct vmxnet3_tx_buf_info) *
> -					tqc->txRingSize);
> +		tqc->ddLen          = cpu_to_le32(0);
>  		tqc->intrIdx        = tq->comp_ring.intr_idx;
>  	}
>
> @@ -2541,14 +2531,11 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
>  		rqc->rxRingBasePA[0] = cpu_to_le64(rq->rx_ring[0].basePA);
>  		rqc->rxRingBasePA[1] = cpu_to_le64(rq->rx_ring[1].basePA);
>  		rqc->compRingBasePA  = cpu_to_le64(rq->comp_ring.basePA);
> -		rqc->ddPA            = cpu_to_le64(rq->buf_info_pa);
> +		rqc->ddPA            = cpu_to_le64(~0ULL);
>  		rqc->rxRingSize[0]   = cpu_to_le32(rq->rx_ring[0].size);
>  		rqc->rxRingSize[1]   = cpu_to_le32(rq->rx_ring[1].size);
>  		rqc->compRingSize    = cpu_to_le32(rq->comp_ring.size);
> -		rqc->ddLen           = cpu_to_le32(
> -					sizeof(struct vmxnet3_rx_buf_info) *
> -					(rqc->rxRingSize[0] +
> -					 rqc->rxRingSize[1]));
> +		rqc->ddLen           = cpu_to_le32(0);
>  		rqc->intrIdx         = rq->comp_ring.intr_idx;
>  		if (VMXNET3_VERSION_GE_3(adapter)) {
>  			rqc->rxDataRingBasePA =
> diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
> index d958b92c9429..e910596b79cf 100644
> --- a/drivers/net/vmxnet3/vmxnet3_int.h
> +++ b/drivers/net/vmxnet3/vmxnet3_int.h
> @@ -240,7 +240,6 @@ struct vmxnet3_tx_queue {
>  	spinlock_t                      tx_lock;
>  	struct vmxnet3_cmd_ring         tx_ring;
>  	struct vmxnet3_tx_buf_info      *buf_info;
> -	dma_addr_t                       buf_info_pa;
>  	struct vmxnet3_tx_data_ring     data_ring;
>  	struct vmxnet3_comp_ring        comp_ring;
>  	struct Vmxnet3_TxQueueCtrl      *shared;
> @@ -298,7 +297,6 @@ struct vmxnet3_rx_queue {
>  	u32 qid2;           /* rqID in RCD for buffer from 2nd ring */
>  	u32 dataRingQid;    /* rqID in RCD for buffer from data ring */
>  	struct vmxnet3_rx_buf_info     *buf_info[2];
> -	dma_addr_t                      buf_info_pa;
>  	struct Vmxnet3_RxQueueCtrl            *shared;
>  	struct vmxnet3_rq_driver_stats  stats;
>  } __attribute__((__aligned__(SMP_CACHE_BYTES)));
> --
> 2.11.0
>
