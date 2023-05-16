Return-Path: <netdev+bounces-2818-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E677042B3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 03:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98CCA1C20C9E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 01:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9AC1FA8;
	Tue, 16 May 2023 01:14:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6091A199
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:14:09 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32A810EA;
	Mon, 15 May 2023 18:14:06 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QKyrL6wxqzsRhT;
	Tue, 16 May 2023 09:12:02 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 16 May
 2023 09:14:01 +0800
Subject: Re: [PATCH net-next] octeontx2-pf: Add support for page pool
To: Ratheesh Kannoth <rkannoth@marvell.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <sgoutham@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
References: <20230515055607.651799-1-rkannoth@marvell.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c50a0969-4b17-f2c2-6ad6-b085b8ac4043@huawei.com>
Date: Tue, 16 May 2023 09:14:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230515055607.651799-1-rkannoth@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/15 13:56, Ratheesh Kannoth wrote:
> Page pool for each rx queue enhance rx side performance
> by reclaiming buffers back to each queue specific pool. DMA
> mapping is done only for first allocation of buffers.
> As subsequent buffers allocation avoid DMA mapping,
> it results in performance improvement.

Any performance data to share here?

....
> @@ -1170,15 +1199,24 @@ void otx2_free_aura_ptr(struct otx2_nic *pfvf, int type)
>  	/* Free SQB and RQB pointers from the aura pool */
>  	for (pool_id = pool_start; pool_id < pool_end; pool_id++) {
>  		iova = otx2_aura_allocptr(pfvf, pool_id);
> +		pool = &pfvf->qset.pool[pool_id];
>  		while (iova) {
>  			if (type == AURA_NIX_RQ)
>  				iova -= OTX2_HEAD_ROOM;
>  
>  			pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
> -			dma_unmap_page_attrs(pfvf->dev, iova, size,
> -					     DMA_FROM_DEVICE,
> -					     DMA_ATTR_SKIP_CPU_SYNC);
> -			put_page(virt_to_page(phys_to_virt(pa)));
> +			page = virt_to_page(phys_to_virt(pa));

virt_to_page() seems ok for order-0 page allocated from page
pool as it does now, but it may break for order-1+ page as
page_pool_put_page() expects head page of compound page or base
page. Maybe add a comment for that or use virt_to_head_page()
explicitly.

> +
> +			if (pool->page_pool) {
> +				page_pool_put_page(pool->page_pool, page, size, true);

page_pool_put_full_page() seems more appropriate here, as the
PP_FLAG_DMA_SYNC_DEV flag is not set, even if it is set, it seems
the whole page need to be synced instead of a frag.


> +			} else {
> +				dma_unmap_page_attrs(pfvf->dev, iova, size,
> +						     DMA_FROM_DEVICE,
> +						     DMA_ATTR_SKIP_CPU_SYNC);
> +
> +				put_page(page);
> +			}
> +
>  			iova = otx2_aura_allocptr(pfvf, pool_id);
>  		}
>  	}
> @@ -1196,6 +1234,8 @@ void otx2_aura_pool_free(struct otx2_nic *pfvf)
>  		pool = &pfvf->qset.pool[pool_id];
>  		qmem_free(pfvf->dev, pool->stack);
>  		qmem_free(pfvf->dev, pool->fc_addr);
> +		page_pool_destroy(pool->page_pool);
> +		pool->page_pool = NULL;
>  	}
>  	devm_kfree(pfvf->dev, pfvf->qset.pool);
>  	pfvf->qset.pool = NULL;
> @@ -1279,8 +1319,10 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
>  }
>  
>  static int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
> -			  int stack_pages, int numptrs, int buf_size)
> +			  int stack_pages, int numptrs, int buf_size,
> +			  int type)
>  {
> +	struct page_pool_params pp_params = { 0 };
>  	struct npa_aq_enq_req *aq;
>  	struct otx2_pool *pool;
>  	int err;
> @@ -1324,6 +1366,22 @@ static int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
>  	aq->ctype = NPA_AQ_CTYPE_POOL;
>  	aq->op = NPA_AQ_INSTOP_INIT;
>  
> +	if (type != AURA_NIX_RQ) {
> +		pool->page_pool = NULL;
> +		return 0;
> +	}
> +
> +	pp_params.flags = PP_FLAG_PAGE_FRAG | PP_FLAG_DMA_MAP;
> +	pp_params.pool_size = numptrs;
> +	pp_params.nid = NUMA_NO_NODE;
> +	pp_params.dev = pfvf->dev;
> +	pp_params.dma_dir = DMA_FROM_DEVICE;
> +	pool->page_pool = page_pool_create(&pp_params);
> +	if (!pool->page_pool) {
> +		netdev_err(pfvf->netdev, "Creation of page pool failed\n");
> +		return -EFAULT;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1358,7 +1416,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
>  
>  		/* Initialize pool context */
>  		err = otx2_pool_init(pfvf, pool_id, stack_pages,
> -				     num_sqbs, hw->sqb_size);
> +				     num_sqbs, hw->sqb_size, AURA_NIX_SQ);
>  		if (err)
>  			goto fail;
>  	}
> @@ -1421,7 +1479,7 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
>  	}
>  	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
>  		err = otx2_pool_init(pfvf, pool_id, stack_pages,
> -				     num_ptrs, pfvf->rbsize);
> +				     num_ptrs, pfvf->rbsize, AURA_NIX_RQ);
>  		if (err)
>  			goto fail;
>  	}

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index 7045fedfd73a..df5f45aa6980 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -217,9 +217,10 @@ static bool otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
>  		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
>  				va - page_address(page) + off,
>  				len - off, pfvf->rbsize);
> -
> +#ifndef CONFIG_PAGE_POOL

Most driver does 'select PAGE_POOL' in config when adding page
pool support, is there any reason it does not do it here?

>  		otx2_dma_unmap_page(pfvf, iova - OTX2_HEAD_ROOM,
>  				    pfvf->rbsize, DMA_FROM_DEVICE);
> +#endif
>  		return true;
>  	}
>  
> @@ -382,6 +383,8 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
>  	if (pfvf->netdev->features & NETIF_F_RXCSUM)
>  		skb->ip_summed = CHECKSUM_UNNECESSARY;
>  
> +	skb_mark_for_recycle(skb);
> +
>  	napi_gro_frags(napi);
>  }
>  
> @@ -1180,11 +1183,14 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
>  }
>  EXPORT_SYMBOL(otx2_sq_append_skb);
>  
> -void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
> +void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq, int qidx)
>  {
>  	struct nix_cqe_rx_s *cqe;
>  	int processed_cqe = 0;
> +	struct otx2_pool *pool;
> +	struct page *page;
>  	u64 iova, pa;
> +	u16 pool_id;
>  
>  	if (pfvf->xdp_prog)
>  		xdp_rxq_info_unreg(&cq->xdp_rxq);
> @@ -1192,6 +1198,9 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
>  	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
>  		return;
>  
> +	pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_RQ, qidx);
> +	pool = &pfvf->qset.pool[pool_id];
> +
>  	while (cq->pend_cqe) {
>  		cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq);
>  		processed_cqe++;
> @@ -1205,8 +1214,14 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
>  		}
>  		iova = cqe->sg.seg_addr - OTX2_HEAD_ROOM;
>  		pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
> -		otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize, DMA_FROM_DEVICE);
> -		put_page(virt_to_page(phys_to_virt(pa)));
> +		page = virt_to_page(phys_to_virt(pa));
> +
> +		if (pool->page_pool) {
> +			page_pool_put_page(pool->page_pool, page, pfvf->rbsize, true);
> +		} else {
> +			otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize, DMA_FROM_DEVICE);
> +			put_page(page);
> +		}

Maybe add a helper for the above as there is a similiar code block
in the otx2_free_aura_ptr()


> 

