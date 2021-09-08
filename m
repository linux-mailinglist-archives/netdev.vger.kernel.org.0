Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4712A403625
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 10:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348238AbhIHIe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 04:34:27 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9405 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348283AbhIHIcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 04:32:51 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H4FcT2Pvyz8yMC;
        Wed,  8 Sep 2021 16:27:21 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 8 Sep 2021 16:31:40 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 8 Sep 2021
 16:31:40 +0800
Subject: Re: [PATCH net-next v2 4/4] net: hns3: support skb's frag page
 recycling based on page pool
To:     Yunsheng Lin <linyunsheng@huawei.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
 <1628217982-53533-5-git-send-email-linyunsheng@huawei.com>
CC:     <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
        <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>, <moyufeng@huawei.com>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <2b75d66b-a3bf-2490-2f46-fef5731ed7ad@huawei.com>
Date:   Wed, 8 Sep 2021 16:31:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1628217982-53533-5-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub

    After adding page pool to hns3 receiving package process,
we want to add some debug info. Such as below:

1. count of page pool allocate and free page, which is defined
for pages_state_hold_cnt and pages_state_release_cnt in page
pool framework.

2. pool size、order、nid、dev、max_len, which is setted for
each rx ring in hns3 driver.

In this regard, we consider two ways to show these info：

1. Add it to queue statistics and query it by ethtool -S.

2. Add a file node "page_pool_info" for debugfs, then cat this
file node, print as below:

queue_id  allocate_cnt  free_cnt  pool_size  order  nid  dev  max_len
000		   xxx       xxx        xxx    xxx  xxx  xxx      xxx
001
002
.
.
	
Which one is more acceptable, or would you have some other suggestion?

Thanks


On 2021/8/6 10:46, Yunsheng Lin wrote:
> This patch adds skb's frag page recycling support based on
> the frag page support in page pool.
> 
> The performance improves above 10~20% for single thread iperf
> TCP flow with IOMMU disabled when iperf server and irq/NAPI
> have a different CPU.
> 
> The performance improves about 135%(14Gbit to 33Gbit) for single
> thread iperf TCP flow when IOMMU is in strict mode and iperf
> server shares the same cpu with irq/NAPI.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/Kconfig          |  1 +
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 79 +++++++++++++++++++++++--
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  3 +
>  3 files changed, 78 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
> index 094e4a3..2ba0e7b 100644
> --- a/drivers/net/ethernet/hisilicon/Kconfig
> +++ b/drivers/net/ethernet/hisilicon/Kconfig
> @@ -91,6 +91,7 @@ config HNS3
>  	tristate "Hisilicon Network Subsystem Support HNS3 (Framework)"
>  	depends on PCI
>  	select NET_DEVLINK
> +	select PAGE_POOL
>  	help
>  	  This selects the framework support for Hisilicon Network Subsystem 3.
>  	  This layer facilitates clients like ENET, RoCE and user-space ethernet
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index cb8d5da..fcbeb1f 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -3205,6 +3205,21 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
>  	unsigned int order = hns3_page_order(ring);
>  	struct page *p;
>  
> +	if (ring->page_pool) {
> +		p = page_pool_dev_alloc_frag(ring->page_pool,
> +					     &cb->page_offset,
> +					     hns3_buf_size(ring));
> +		if (unlikely(!p))
> +			return -ENOMEM;
> +
> +		cb->priv = p;
> +		cb->buf = page_address(p);
> +		cb->dma = page_pool_get_dma_addr(p);
> +		cb->type = DESC_TYPE_PP_FRAG;
> +		cb->reuse_flag = 0;
> +		return 0;
> +	}
> +
>  	p = dev_alloc_pages(order);
>  	if (!p)
>  		return -ENOMEM;
> @@ -3227,8 +3242,13 @@ static void hns3_free_buffer(struct hns3_enet_ring *ring,
>  	if (cb->type & (DESC_TYPE_SKB | DESC_TYPE_BOUNCE_HEAD |
>  			DESC_TYPE_BOUNCE_ALL | DESC_TYPE_SGL_SKB))
>  		napi_consume_skb(cb->priv, budget);
> -	else if (!HNAE3_IS_TX_RING(ring) && cb->pagecnt_bias)
> -		__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
> +	else if (!HNAE3_IS_TX_RING(ring)) {
> +		if (cb->type & DESC_TYPE_PAGE && cb->pagecnt_bias)
> +			__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
> +		else if (cb->type & DESC_TYPE_PP_FRAG)
> +			page_pool_put_full_page(ring->page_pool, cb->priv,
> +						false);
> +	}
>  	memset(cb, 0, sizeof(*cb));
>  }
>  
> @@ -3315,7 +3335,7 @@ static int hns3_alloc_and_map_buffer(struct hns3_enet_ring *ring,
>  	int ret;
>  
>  	ret = hns3_alloc_buffer(ring, cb);
> -	if (ret)
> +	if (ret || ring->page_pool)
>  		goto out;
>  
>  	ret = hns3_map_buffer(ring, cb);
> @@ -3337,7 +3357,8 @@ static int hns3_alloc_and_attach_buffer(struct hns3_enet_ring *ring, int i)
>  	if (ret)
>  		return ret;
>  
> -	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
> +	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
> +					 ring->desc_cb[i].page_offset);
>  
>  	return 0;
>  }
> @@ -3367,7 +3388,8 @@ static void hns3_replace_buffer(struct hns3_enet_ring *ring, int i,
>  {
>  	hns3_unmap_buffer(ring, &ring->desc_cb[i]);
>  	ring->desc_cb[i] = *res_cb;
> -	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
> +	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
> +					 ring->desc_cb[i].page_offset);
>  	ring->desc[i].rx.bd_base_info = 0;
>  }
>  
> @@ -3539,6 +3561,12 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
>  	u32 frag_size = size - pull_len;
>  	bool reused;
>  
> +	if (ring->page_pool) {
> +		skb_add_rx_frag(skb, i, desc_cb->priv, frag_offset,
> +				frag_size, truesize);
> +		return;
> +	}
> +
>  	/* Avoid re-using remote or pfmem page */
>  	if (unlikely(!dev_page_is_reusable(desc_cb->priv)))
>  		goto out;
> @@ -3856,6 +3884,9 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
>  		/* We can reuse buffer as-is, just make sure it is reusable */
>  		if (dev_page_is_reusable(desc_cb->priv))
>  			desc_cb->reuse_flag = 1;
> +		else if (desc_cb->type & DESC_TYPE_PP_FRAG)
> +			page_pool_put_full_page(ring->page_pool, desc_cb->priv,
> +						false);
>  		else /* This page cannot be reused so discard it */
>  			__page_frag_cache_drain(desc_cb->priv,
>  						desc_cb->pagecnt_bias);
> @@ -3863,6 +3894,10 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
>  		hns3_rx_ring_move_fw(ring);
>  		return 0;
>  	}
> +
> +	if (ring->page_pool)
> +		skb_mark_for_recycle(skb);
> +
>  	u64_stats_update_begin(&ring->syncp);
>  	ring->stats.seg_pkt_cnt++;
>  	u64_stats_update_end(&ring->syncp);
> @@ -3901,6 +3936,10 @@ static int hns3_add_frag(struct hns3_enet_ring *ring)
>  					    "alloc rx fraglist skb fail\n");
>  				return -ENXIO;
>  			}
> +
> +			if (ring->page_pool)
> +				skb_mark_for_recycle(new_skb);
> +
>  			ring->frag_num = 0;
>  
>  			if (ring->tail_skb) {
> @@ -4705,6 +4744,29 @@ static void hns3_put_ring_config(struct hns3_nic_priv *priv)
>  	priv->ring = NULL;
>  }
>  
> +static void hns3_alloc_page_pool(struct hns3_enet_ring *ring)
> +{
> +	struct page_pool_params pp_params = {
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_PAGE_FRAG |
> +				PP_FLAG_DMA_SYNC_DEV,
> +		.order = hns3_page_order(ring),
> +		.pool_size = ring->desc_num * hns3_buf_size(ring) /
> +				(PAGE_SIZE << hns3_page_order(ring)),
> +		.nid = dev_to_node(ring_to_dev(ring)),
> +		.dev = ring_to_dev(ring),
> +		.dma_dir = DMA_FROM_DEVICE,
> +		.offset = 0,
> +		.max_len = PAGE_SIZE << hns3_page_order(ring),
> +	};
> +
> +	ring->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(ring->page_pool)) {
> +		dev_warn(ring_to_dev(ring), "page pool creation failed: %ld\n",
> +			 PTR_ERR(ring->page_pool));
> +		ring->page_pool = NULL;
> +	}
> +}
> +
>  static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
>  {
>  	int ret;
> @@ -4724,6 +4786,8 @@ static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
>  		goto out_with_desc_cb;
>  
>  	if (!HNAE3_IS_TX_RING(ring)) {
> +		hns3_alloc_page_pool(ring);
> +
>  		ret = hns3_alloc_ring_buffers(ring);
>  		if (ret)
>  			goto out_with_desc;
> @@ -4764,6 +4828,11 @@ void hns3_fini_ring(struct hns3_enet_ring *ring)
>  		devm_kfree(ring_to_dev(ring), tx_spare);
>  		ring->tx_spare = NULL;
>  	}
> +
> +	if (!HNAE3_IS_TX_RING(ring) && ring->page_pool) {
> +		page_pool_destroy(ring->page_pool);
> +		ring->page_pool = NULL;
> +	}
>  }
>  
>  static int hns3_buf_size2type(u32 buf_size)
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> index 15af3d9..27809d6 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> @@ -6,6 +6,7 @@
>  
>  #include <linux/dim.h>
>  #include <linux/if_vlan.h>
> +#include <net/page_pool.h>
>  
>  #include "hnae3.h"
>  
> @@ -307,6 +308,7 @@ enum hns3_desc_type {
>  	DESC_TYPE_BOUNCE_ALL		= 1 << 3,
>  	DESC_TYPE_BOUNCE_HEAD		= 1 << 4,
>  	DESC_TYPE_SGL_SKB		= 1 << 5,
> +	DESC_TYPE_PP_FRAG		= 1 << 6,
>  };
>  
>  struct hns3_desc_cb {
> @@ -451,6 +453,7 @@ struct hns3_enet_ring {
>  	struct hnae3_queue *tqp;
>  	int queue_index;
>  	struct device *dev; /* will be used for DMA mapping of descriptors */
> +	struct page_pool *page_pool;
>  
>  	/* statistic */
>  	struct ring_stats stats;
> 
