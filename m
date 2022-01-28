Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6402549F234
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 05:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345950AbiA1EBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 23:01:01 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17822 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbiA1EBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 23:01:00 -0500
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JlNy12wB6z9sbB;
        Fri, 28 Jan 2022 11:59:37 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 28 Jan 2022 12:00:37 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Fri, 28 Jan
 2022 12:00:37 +0800
Subject: Re: [PATCH net-next v2 4/4] net: hns3: support skb's frag page
 recycling based on page pool
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     <linuxarm@openeuler.org>, <ilias.apalodimas@linaro.org>,
        <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <moyufeng@huawei.com>, <alexanderduyck@fb.com>,
        <brouer@redhat.com>, <kuba@kernel.org>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
 <1628217982-53533-5-git-send-email-linyunsheng@huawei.com>
 <YfFbDivUPbpWjh/m@myrica>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3315a093-582c-f464-d894-cb07522e5547@huawei.com>
Date:   Fri, 28 Jan 2022 12:00:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YfFbDivUPbpWjh/m@myrica>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/1/26 22:30, Jean-Philippe Brucker wrote:
> Hi,
> 
> On Fri, Aug 06, 2021 at 10:46:22AM +0800, Yunsheng Lin wrote:
>> This patch adds skb's frag page recycling support based on
>> the frag page support in page pool.
>>
>> The performance improves above 10~20% for single thread iperf
>> TCP flow with IOMMU disabled when iperf server and irq/NAPI
>> have a different CPU.
>>
>> The performance improves about 135%(14Gbit to 33Gbit) for single
>> thread iperf TCP flow when IOMMU is in strict mode and iperf
>> server shares the same cpu with irq/NAPI.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> This commit is giving me some trouble, but I haven't managed to pinpoint
> the exact problem.

Hi,
Thanks for reporting the problem.

We also hit a similiar problem during internal CI testing, but was not
able to trigger it manually, so was not able to find the root case yet.

Is your test case more likely to trigger the problem?

> 
> Symptoms are:
> * A page gets unmapped twice from page_pool_release_page(). The second
>   time, dma-iommu.c warns about the empty PTE [1]
> * The rx ring still accesses the page after the first unmap, causing SMMU
>   translation faults [2]
> * That leads to APEI errors and reset of the device, at which time
>   page_pool_inflight() complains about "Negative(-x) inflight packet-pages".
> 
> After some debugging, it looks like the page gets released three times
> instead of two:
> 
> (1) first in page_pool_drain_frag():
> 
>         page_pool_alloc_frag+0x1fc/0x248
>         hns3_alloc_and_map_buffer+0x30/0x170
>         hns3_nic_alloc_rx_buffers+0x9c/0x170
>         hns3_clean_rx_ring+0x854/0x950
>         hns3_nic_common_poll+0xa0/0x218
>         __napi_poll+0x38/0x1b0
>         net_rx_action+0xe8/0x248
>         __do_softirq+0x120/0x284
> 
> (2) Then later by page_pool_return_skb_page(), which (I guess) unmaps the
>     page:
> 
>         page_pool_put_page+0x214/0x308
>         page_pool_return_skb_page+0x48/0x60
>         skb_release_data+0x168/0x188
>         skb_release_all+0x28/0x38
>         kfree_skb+0x30/0x90
>         packet_rcv+0x4c/0x410
>         __netif_receive_skb_list_core+0x1f4/0x218
>         netif_receive_skb_list_internal+0x18c/0x2a8
> 
> (3) And finally, soon after, by clean_rx_ring() which causes pp_frag_count
>     underflow (seen after removing the optimization in
>     page_pool_atomic_sub_frag_count_return):
> 
>         page_pool_put_page+0x2a0/0x308
>           page_pool_put_full_page
>           hns3_alloc_skb
>           hns3_handle_rx_bd
>         hns3_clean_rx_ring+0x744/0x950
>         hns3_nic_common_poll+0xa0/0x218
>         __napi_poll+0x38/0x1b0
>         net_rx_action+0xe8/0x248
> 
> So I'm guessing (2) happens too early while the RX ring is still using the
> page, but I don't know more. I'd be happy to add more debug and to test

If the reference counting or pp_frag_count of the page is manipulated correctly,
I think step 2&3 does not have any dependency between each other.

> fixes if you have any suggestions.

My initial thinking is to track if the reference counting or pp_frag_count of
the page is manipulated correctly.

Perhaps using the newly added reference counting tracking infrastructure?
Will look into how to use the reference counting tracking infrastructure
for the above problem.

> 
> Thanks,
> Jean
> 
> 
> [1] ------------[ cut here ]------------
>      WARNING: CPU: 71 PID: 0 at drivers/iommu/dma-iommu.c:848 iommu_dma_unmap_page+0xbc/0xd8
>      Modules linked in: fuse overlay ipmi_si hisi_hpre hisi_zip ecdh_generic hisi_trng_v2 ecc ipmi_d>
>      CPU: 71 PID: 0 Comm: swapper/71 Not tainted 5.16.0-g3813c61fbaad #22
>      Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 2280-V2 CS V5.B133.01 03/25/2021
>      pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>      pc : iommu_dma_unmap_page+0xbc/0xd8
>      lr : iommu_dma_unmap_page+0x38/0xd8
>      sp : ffff800010abb8d0
>      x29: ffff800010abb8d0 x28: ffff20200ee80000 x27: 0000000000000042
>      x26: ffff20201a7ed800 x25: ffff20200be7a5c0 x24: 0000000000000002
>      x23: 0000000000000020 x22: 0000000000001000 x21: 0000000000000000
>      x20: 0000000000000002 x19: ffff002086b730c8 x18: 0000000000000001
>      x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>      x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000008
>      x11: 000000000000ffff x10: 0000000000000001 x9 : 0000000000000004
>      x8 : 0000000000000000 x7 : 0000000000000000 x6 : ffff202006274800
>      x5 : 0000000000000009 x4 : 0000000000000001 x3 : 000000000000001e
>      x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
>      Call trace:
>       iommu_dma_unmap_page+0xbc/0xd8
>       dma_unmap_page_attrs+0x30/0x1d0
>       page_pool_release_page+0x40/0x88
>       page_pool_return_page+0x18/0x80
>       page_pool_put_page+0x248/0x288
>       hns3_clean_rx_ring+0x744/0x950
>       hns3_nic_common_poll+0xa0/0x218
>       __napi_poll+0x38/0x1b0
>       net_rx_action+0xe8/0x248
>       __do_softirq+0x120/0x284
>       irq_exit_rcu+0xe0/0x100
>       el1_interrupt+0x3c/0x88
>       el1h_64_irq_handler+0x18/0x28
>       el1h_64_irq+0x78/0x7c
>       arch_cpu_idle+0x18/0x28
>       default_idle_call+0x20/0x68
>       do_idle+0x214/0x260
>       cpu_startup_entry+0x28/0x70
>       secondary_start_kernel+0x160/0x170
>       __secondary_switched+0x90/0x94
>      ---[ end trace 432d1737b4b96ed9 ]---
> 
>     (please ignore the kernel version, I can reproduce this with v5.14 and
>     v5.17-rc1, and bisected to this commit.)
> 
> [2] arm-smmu-v3 arm-smmu-v3.6.auto: event 0x10 received:
>     arm-smmu-v3 arm-smmu-v3.6.auto: 	0x0000bd0000000010
>     arm-smmu-v3 arm-smmu-v3.6.auto: 	0x000012000000007c
>     arm-smmu-v3 arm-smmu-v3.6.auto: 	0x00000000ff905800
>     arm-smmu-v3 arm-smmu-v3.6.auto: 	0x00000000ff905000
> 
> 
>> ---
>>  drivers/net/ethernet/hisilicon/Kconfig          |  1 +
>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 79 +++++++++++++++++++++++--
>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  3 +
>>  3 files changed, 78 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
>> index 094e4a3..2ba0e7b 100644
>> --- a/drivers/net/ethernet/hisilicon/Kconfig
>> +++ b/drivers/net/ethernet/hisilicon/Kconfig
>> @@ -91,6 +91,7 @@ config HNS3
>>  	tristate "Hisilicon Network Subsystem Support HNS3 (Framework)"
>>  	depends on PCI
>>  	select NET_DEVLINK
>> +	select PAGE_POOL
>>  	help
>>  	  This selects the framework support for Hisilicon Network Subsystem 3.
>>  	  This layer facilitates clients like ENET, RoCE and user-space ethernet
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> index cb8d5da..fcbeb1f 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> @@ -3205,6 +3205,21 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
>>  	unsigned int order = hns3_page_order(ring);
>>  	struct page *p;
>>  
>> +	if (ring->page_pool) {
>> +		p = page_pool_dev_alloc_frag(ring->page_pool,
>> +					     &cb->page_offset,
>> +					     hns3_buf_size(ring));
>> +		if (unlikely(!p))
>> +			return -ENOMEM;
>> +
>> +		cb->priv = p;
>> +		cb->buf = page_address(p);
>> +		cb->dma = page_pool_get_dma_addr(p);
>> +		cb->type = DESC_TYPE_PP_FRAG;
>> +		cb->reuse_flag = 0;
>> +		return 0;
>> +	}
>> +
>>  	p = dev_alloc_pages(order);
>>  	if (!p)
>>  		return -ENOMEM;
>> @@ -3227,8 +3242,13 @@ static void hns3_free_buffer(struct hns3_enet_ring *ring,
>>  	if (cb->type & (DESC_TYPE_SKB | DESC_TYPE_BOUNCE_HEAD |
>>  			DESC_TYPE_BOUNCE_ALL | DESC_TYPE_SGL_SKB))
>>  		napi_consume_skb(cb->priv, budget);
>> -	else if (!HNAE3_IS_TX_RING(ring) && cb->pagecnt_bias)
>> -		__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
>> +	else if (!HNAE3_IS_TX_RING(ring)) {
>> +		if (cb->type & DESC_TYPE_PAGE && cb->pagecnt_bias)
>> +			__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
>> +		else if (cb->type & DESC_TYPE_PP_FRAG)
>> +			page_pool_put_full_page(ring->page_pool, cb->priv,
>> +						false);
>> +	}
>>  	memset(cb, 0, sizeof(*cb));
>>  }
>>  
>> @@ -3315,7 +3335,7 @@ static int hns3_alloc_and_map_buffer(struct hns3_enet_ring *ring,
>>  	int ret;
>>  
>>  	ret = hns3_alloc_buffer(ring, cb);
>> -	if (ret)
>> +	if (ret || ring->page_pool)
>>  		goto out;
>>  
>>  	ret = hns3_map_buffer(ring, cb);
>> @@ -3337,7 +3357,8 @@ static int hns3_alloc_and_attach_buffer(struct hns3_enet_ring *ring, int i)
>>  	if (ret)
>>  		return ret;
>>  
>> -	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
>> +	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
>> +					 ring->desc_cb[i].page_offset);
>>  
>>  	return 0;
>>  }
>> @@ -3367,7 +3388,8 @@ static void hns3_replace_buffer(struct hns3_enet_ring *ring, int i,
>>  {
>>  	hns3_unmap_buffer(ring, &ring->desc_cb[i]);
>>  	ring->desc_cb[i] = *res_cb;
>> -	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
>> +	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
>> +					 ring->desc_cb[i].page_offset);
>>  	ring->desc[i].rx.bd_base_info = 0;
>>  }
>>  
>> @@ -3539,6 +3561,12 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
>>  	u32 frag_size = size - pull_len;
>>  	bool reused;
>>  
>> +	if (ring->page_pool) {
>> +		skb_add_rx_frag(skb, i, desc_cb->priv, frag_offset,
>> +				frag_size, truesize);
>> +		return;
>> +	}
>> +
>>  	/* Avoid re-using remote or pfmem page */
>>  	if (unlikely(!dev_page_is_reusable(desc_cb->priv)))
>>  		goto out;
>> @@ -3856,6 +3884,9 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
>>  		/* We can reuse buffer as-is, just make sure it is reusable */
>>  		if (dev_page_is_reusable(desc_cb->priv))
>>  			desc_cb->reuse_flag = 1;
>> +		else if (desc_cb->type & DESC_TYPE_PP_FRAG)
>> +			page_pool_put_full_page(ring->page_pool, desc_cb->priv,
>> +						false);
>>  		else /* This page cannot be reused so discard it */
>>  			__page_frag_cache_drain(desc_cb->priv,
>>  						desc_cb->pagecnt_bias);
>> @@ -3863,6 +3894,10 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
>>  		hns3_rx_ring_move_fw(ring);
>>  		return 0;
>>  	}
>> +
>> +	if (ring->page_pool)
>> +		skb_mark_for_recycle(skb);
>> +
>>  	u64_stats_update_begin(&ring->syncp);
>>  	ring->stats.seg_pkt_cnt++;
>>  	u64_stats_update_end(&ring->syncp);
>> @@ -3901,6 +3936,10 @@ static int hns3_add_frag(struct hns3_enet_ring *ring)
>>  					    "alloc rx fraglist skb fail\n");
>>  				return -ENXIO;
>>  			}
>> +
>> +			if (ring->page_pool)
>> +				skb_mark_for_recycle(new_skb);
>> +
>>  			ring->frag_num = 0;
>>  
>>  			if (ring->tail_skb) {
>> @@ -4705,6 +4744,29 @@ static void hns3_put_ring_config(struct hns3_nic_priv *priv)
>>  	priv->ring = NULL;
>>  }
>>  
>> +static void hns3_alloc_page_pool(struct hns3_enet_ring *ring)
>> +{
>> +	struct page_pool_params pp_params = {
>> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_PAGE_FRAG |
>> +				PP_FLAG_DMA_SYNC_DEV,
>> +		.order = hns3_page_order(ring),
>> +		.pool_size = ring->desc_num * hns3_buf_size(ring) /
>> +				(PAGE_SIZE << hns3_page_order(ring)),
>> +		.nid = dev_to_node(ring_to_dev(ring)),
>> +		.dev = ring_to_dev(ring),
>> +		.dma_dir = DMA_FROM_DEVICE,
>> +		.offset = 0,
>> +		.max_len = PAGE_SIZE << hns3_page_order(ring),
>> +	};
>> +
>> +	ring->page_pool = page_pool_create(&pp_params);
>> +	if (IS_ERR(ring->page_pool)) {
>> +		dev_warn(ring_to_dev(ring), "page pool creation failed: %ld\n",
>> +			 PTR_ERR(ring->page_pool));
>> +		ring->page_pool = NULL;
>> +	}
>> +}
>> +
>>  static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
>>  {
>>  	int ret;
>> @@ -4724,6 +4786,8 @@ static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
>>  		goto out_with_desc_cb;
>>  
>>  	if (!HNAE3_IS_TX_RING(ring)) {
>> +		hns3_alloc_page_pool(ring);
>> +
>>  		ret = hns3_alloc_ring_buffers(ring);
>>  		if (ret)
>>  			goto out_with_desc;
>> @@ -4764,6 +4828,11 @@ void hns3_fini_ring(struct hns3_enet_ring *ring)
>>  		devm_kfree(ring_to_dev(ring), tx_spare);
>>  		ring->tx_spare = NULL;
>>  	}
>> +
>> +	if (!HNAE3_IS_TX_RING(ring) && ring->page_pool) {
>> +		page_pool_destroy(ring->page_pool);
>> +		ring->page_pool = NULL;
>> +	}
>>  }
>>  
>>  static int hns3_buf_size2type(u32 buf_size)
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
>> index 15af3d9..27809d6 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
>> @@ -6,6 +6,7 @@
>>  
>>  #include <linux/dim.h>
>>  #include <linux/if_vlan.h>
>> +#include <net/page_pool.h>
>>  
>>  #include "hnae3.h"
>>  
>> @@ -307,6 +308,7 @@ enum hns3_desc_type {
>>  	DESC_TYPE_BOUNCE_ALL		= 1 << 3,
>>  	DESC_TYPE_BOUNCE_HEAD		= 1 << 4,
>>  	DESC_TYPE_SGL_SKB		= 1 << 5,
>> +	DESC_TYPE_PP_FRAG		= 1 << 6,
>>  };
>>  
>>  struct hns3_desc_cb {
>> @@ -451,6 +453,7 @@ struct hns3_enet_ring {
>>  	struct hnae3_queue *tqp;
>>  	int queue_index;
>>  	struct device *dev; /* will be used for DMA mapping of descriptors */
>> +	struct page_pool *page_pool;
>>  
>>  	/* statistic */
>>  	struct ring_stats stats;
>> -- 
>> 2.7.4
>>
> .
> 
