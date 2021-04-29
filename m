Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C453F36E706
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbhD2I2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 04:28:12 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3346 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbhD2I2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 04:28:11 -0400
Received: from dggeml711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FW7mr14SHz19JR5;
        Thu, 29 Apr 2021 16:23:24 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml711-chm.china.huawei.com (10.3.17.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 29 Apr 2021 16:27:22 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 29 Apr
 2021 16:27:21 +0800
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
To:     Matteo Croce <mcroce@linux.microsoft.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
CC:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <bpf@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
Date:   Thu, 29 Apr 2021 16:27:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210409223801.104657-1-mcroce@linux.microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/10 6:37, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> This is a respin of [1]
> 
> This  patchset shows the plans for allowing page_pool to handle and
> maintain DMA map/unmap of the pages it serves to the driver.  For this
> to work a return hook in the network core is introduced.
> 
> The overall purpose is to simplify drivers, by providing a page
> allocation API that does recycling, such that each driver doesn't have
> to reinvent its own recycling scheme.  Using page_pool in a driver
> does not require implementing XDP support, but it makes it trivially
> easy to do so.  Instead of allocating buffers specifically for SKBs
> we now allocate a generic buffer and either wrap it on an SKB
> (via build_skb) or create an XDP frame.
> The recycling code leverages the XDP recycle APIs.
> 
> The Marvell mvpp2 and mvneta drivers are used in this patchset to
> demonstrate how to use the API, and tested on a MacchiatoBIN
> and EspressoBIN boards respectively.
> 

Hi, Matteo
     I added the skb frag page recycling in hns3 based on this patchset,
and it has above 10%~20% performance improvement for one thread iperf
TCP flow(IOMMU is off, there may be more performance improvement if
considering the DMA map/unmap avoiding for IOMMU), thanks for the job.

    The skb frag page recycling support in hns3 driver is not so simple
as the mvpp2 and mvneta driver, because:

1. the hns3 driver do not have XDP support yet, so "struct xdp_rxq_info"
   is added to assist relation binding between the "struct page" and
   "struct page_pool".

2. the hns3 driver has already a page reusing based on page spliting and
   page reference count, but it may not work if the upper stack can not
   handle skb and release the corresponding page fast enough.

3. the hns3 driver support page reference count updating batching, see:
   aeda9bf87a45 ("net: hns3: batch the page reference count updates")

So it would be better if：

1. skb frag page recycling do not need "struct xdp_rxq_info" or
   "struct xdp_mem_info" to bond the relation between "struct page" and
   "struct page_pool", which seems uncessary at this point if bonding
   a "struct page_pool" pointer directly in "struct page" does not cause
   space increasing.

2. it would be good to do the page reference count updating batching
   in page pool instead of specific driver.


page_pool_atomic_sub_if_positive() is added to decide who can call
page_pool_put_full_page(), because the driver and stack may hold
reference to the same page, only if last one which hold complete
reference to a page can call page_pool_put_full_page() to decide if
recycling is possible, if not, the page is released, so I am wondering
if a similar page_pool_atomic_sub_if_positive() can added to specific
user space address unmapping path to allow skb recycling for RX zerocopy
too?

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index c21dd11..8b01a7d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2566,7 +2566,10 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
        unsigned int order = hns3_page_order(ring);
        struct page *p;

-       p = dev_alloc_pages(order);
+       if (ring->page_pool)
+               p = page_pool_dev_alloc_pages(ring->page_pool);
+       else
+               p = dev_alloc_pages(order);
        if (!p)
                return -ENOMEM;

@@ -2582,13 +2585,32 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
        return 0;
 }

+static void hns3_page_frag_cache_drain(struct hns3_enet_ring *ring,
+                                      struct hns3_desc_cb *cb)
+{
+       if (ring->page_pool) {
+               struct page *p = cb->priv;
+
+               if (page_pool_atomic_sub_if_positive(p, cb->pagecnt_bias))
+                       return;
+
+               if (cb->pagecnt_bias > 1)
+                       page_ref_sub(p, cb->pagecnt_bias - 1);
+
+               page_pool_put_full_page(ring->page_pool, p, false);
+               return;
+       }
+
+       __page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
+}
+
 static void hns3_free_buffer(struct hns3_enet_ring *ring,
                             struct hns3_desc_cb *cb, int budget)
 {
        if (cb->type == DESC_TYPE_SKB)
                napi_consume_skb(cb->priv, budget);
        else if (!HNAE3_IS_TX_RING(ring) && cb->pagecnt_bias)
-               __page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
+               hns3_page_frag_cache_drain(ring, cb);
        memset(cb, 0, sizeof(*cb));
 }

@@ -2892,13 +2914,15 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
        skb_add_rx_frag(skb, i, desc_cb->priv, desc_cb->page_offset + pull_len,
                        size - pull_len, truesize);

+       skb_mark_for_recycle(skb, desc_cb->priv, &ring->rxq_info.mem);
+
        /* Avoid re-using remote and pfmemalloc pages, or the stack is still
         * using the page when page_offset rollback to zero, flag default
         * unreuse
         */
        if (!dev_page_is_reusable(desc_cb->priv) ||
            (!desc_cb->page_offset && !hns3_can_reuse_page(desc_cb))) {
-               __page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
+               hns3_page_frag_cache_drain(ring, desc_cb);
                return;
        }

@@ -2911,7 +2935,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
                desc_cb->reuse_flag = 1;
                desc_cb->page_offset = 0;
        } else if (desc_cb->pagecnt_bias) {
-               __page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
+               hns3_page_frag_cache_drain(ring, desc_cb);
                return;
        }

@@ -3156,8 +3180,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
                if (dev_page_is_reusable(desc_cb->priv))
                        desc_cb->reuse_flag = 1;
                else /* This page cannot be reused so discard it */
-                       __page_frag_cache_drain(desc_cb->priv,
-                                               desc_cb->pagecnt_bias);
+                       hns3_page_frag_cache_drain(ring, desc_cb);

                hns3_rx_ring_move_fw(ring);
                return 0;
@@ -4028,6 +4051,33 @@ static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
                goto out_with_desc_cb;

        if (!HNAE3_IS_TX_RING(ring)) {
+               struct page_pool_params pp_params = {
+               /* internal DMA mapping in page_pool */
+               .flags = 0,
+               .order = 0,
+               .pool_size = 1024,
+               .nid = dev_to_node(ring_to_dev(ring)),
+               .dev = ring_to_dev(ring),
+               .dma_dir = DMA_FROM_DEVICE,
+               .offset = 0,
+               .max_len = 0,
+               };
+
+               ring->page_pool = page_pool_create(&pp_params);
+               if (IS_ERR(ring->page_pool)) {
+                       dev_err(ring_to_dev(ring), "page pool creation failed\n");
+                       ring->page_pool = NULL;
+               }
+
+               ret = xdp_rxq_info_reg(&ring->rxq_info, ring_to_netdev(ring), ring->queue_index, 0);
+               if (ret)
+                       dev_err(ring_to_dev(ring), "xdp_rxq_info_reg failed\n");
+
+               ret = xdp_rxq_info_reg_mem_model(&ring->rxq_info, MEM_TYPE_PAGE_POOL,
+                                                ring->page_pool);
+               if (ret)
+                       dev_err(ring_to_dev(ring), "xdp_rxq_info_reg_mem_model failed\n");
+
                ret = hns3_alloc_ring_buffers(ring);
                if (ret)
                        goto out_with_desc;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index daa04ae..fd53fcc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -6,6 +6,9 @@

 #include <linux/if_vlan.h>

+#include <net/page_pool.h>
+#include <net/xdp.h>
+
 #include "hnae3.h"

 enum hns3_nic_state {
@@ -408,6 +411,8 @@ struct hns3_enet_ring {
        struct hnae3_queue *tqp;
        int queue_index;
        struct device *dev; /* will be used for DMA mapping of descriptors */
+       struct page_pool *page_pool;
        struct hnae3_queue *tqp;
        int queue_index;
        struct device *dev; /* will be used for DMA mapping of descriptors */
+       struct page_pool *page_pool;
+       struct xdp_rxq_info rxq_info;

        /* statistic */
        struct ring_stats stats;
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 75fffc1..70c310e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -195,6 +195,8 @@ static inline void page_pool_put_full_page(struct page_pool *pool,
 #endif
 }

+bool page_pool_atomic_sub_if_positive(struct page *page, int i);
+
 /* Same as above but the caller must guarantee safe context. e.g NAPI */
 static inline void page_pool_recycle_direct(struct page_pool *pool,
                                            struct page *page)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 43bfd2e..8bc8b7e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -596,6 +596,26 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 }
 EXPORT_SYMBOL(page_pool_update_nid);

+bool page_pool_atomic_sub_if_positive(struct page *page, int i)
+{
+       atomic_t *v = &page->_refcount;
+       int dec, c;
+
+       do {
+               c = atomic_read(v);
+
+               dec = c - i;
+               if (unlikely(dec == 0))
+                       return false;
+               else if (unlikely(dec < 0)) {
+                       pr_err("c: %d, dec: %d, i: %d\n", c, dec, i);
+                       return false;
+               }
+       } while (!atomic_try_cmpxchg(v, &c, dec));
+
+       return true;
+}
+
 bool page_pool_return_skb_page(void *data)
 {
        struct xdp_mem_info mem_info;
@@ -606,6 +626,9 @@ bool page_pool_return_skb_page(void *data)
        if (unlikely(page->signature != PP_SIGNATURE))
                return false;

+       if (page_pool_atomic_sub_if_positive(page, 1))
+               return true;
+
        info.raw = page_private(page);
        mem_info = info.mem_info;


