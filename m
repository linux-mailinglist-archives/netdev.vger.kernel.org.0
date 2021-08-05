Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32FC3E137D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240776AbhHELHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:07:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12455 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbhHELGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:06:42 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GgQgX1QDFzclCr;
        Thu,  5 Aug 2021 19:02:48 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 5 Aug 2021 19:06:22 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 5 Aug 2021 19:06:22 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
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
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 1/4] page_pool: keep pp info as long as page pool owns the page
Date:   Thu, 5 Aug 2021 19:05:23 +0800
Message-ID: <1628161526-29076-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628161526-29076-1-git-send-email-linyunsheng@huawei.com>
References: <1628161526-29076-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, page->pp is cleared and set everytime the page
is recycled, which is unnecessary.

So only set the page->pp when the page is added to the page
pool and only clear it when the page is released from the
page pool.

This is also a preparation to support allocating frag page
in page pool.

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/net/ethernet/marvell/mvneta.c           |  6 +-----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  2 +-
 drivers/net/ethernet/ti/cpsw.c                  |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c              |  2 +-
 include/linux/skbuff.h                          |  4 +---
 include/net/page_pool.h                         |  7 -------
 net/core/page_pool.c                            | 21 +++++++++++++++++----
 7 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 361bc4f..89bf31fd 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2327,7 +2327,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	skb_mark_for_recycle(skb, virt_to_page(xdp->data), pool);
+	skb_mark_for_recycle(skb);
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
@@ -2339,10 +2339,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				skb_frag_page(frag), skb_frag_off(frag),
 				skb_frag_size(frag), PAGE_SIZE);
-		/* We don't need to reset pp_recycle here. It's already set, so
-		 * just mark fragments for recycling.
-		 */
-		page_pool_store_mem_info(skb_frag_page(frag), pool);
 	}
 
 	return skb;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 3229baf..320eddb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3995,7 +3995,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		}
 
 		if (pp)
-			skb_mark_for_recycle(skb, page, pp);
+			skb_mark_for_recycle(skb);
 		else
 			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index cbbd0f6..9d59143 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -431,7 +431,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	skb->protocol = eth_type_trans(skb, ndev);
 
 	/* mark skb for recycling */
-	skb_mark_for_recycle(skb, page, pool);
+	skb_mark_for_recycle(skb);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 57d279f..a4234a3 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -374,7 +374,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	skb->protocol = eth_type_trans(skb, ndev);
 
 	/* mark skb for recycling */
-	skb_mark_for_recycle(skb, page, pool);
+	skb_mark_for_recycle(skb);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b2db9cd..7795979 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4711,11 +4711,9 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_PAGE_POOL
-static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
-					struct page_pool *pp)
+static inline void skb_mark_for_recycle(struct sk_buff *skb)
 {
 	skb->pp_recycle = 1;
-	page_pool_store_mem_info(page, pp);
 }
 #endif
 
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 3dd62dd..8d7744d 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -253,11 +253,4 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
 		spin_unlock_bh(&pool->ring.producer_lock);
 }
 
-/* Store mem_info on struct page and use it while recycling skb frags */
-static inline
-void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
-{
-	page->pp = pp;
-}
-
 #endif /* _NET_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 33b7dd7..bee33f6 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -206,6 +206,19 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 	return true;
 }
 
+static void page_pool_set_pp_info(struct page_pool *pool,
+				  struct page *page)
+{
+	page->pp = pool;
+	page->pp_magic |= PP_SIGNATURE;
+}
+
+static void page_pool_clear_pp_info(struct page *page)
+{
+	page->pp_magic = 0;
+	page->pp = NULL;
+}
+
 static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 						 gfp_t gfp)
 {
@@ -222,7 +235,7 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 		return NULL;
 	}
 
-	page->pp_magic |= PP_SIGNATURE;
+	page_pool_set_pp_info(pool, page);
 
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
@@ -266,7 +279,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 			put_page(page);
 			continue;
 		}
-		page->pp_magic |= PP_SIGNATURE;
+
+		page_pool_set_pp_info(pool, page);
 		pool->alloc.cache[pool->alloc.count++] = page;
 		/* Track how many pages are held 'in-flight' */
 		pool->pages_state_hold_cnt++;
@@ -345,7 +359,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 			     DMA_ATTR_SKIP_CPU_SYNC);
 	page_pool_set_dma_addr(page, 0);
 skip_dma_unmap:
-	page->pp_magic = 0;
+	page_pool_clear_pp_info(page);
 
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
@@ -644,7 +658,6 @@ bool page_pool_return_skb_page(struct page *page)
 	 * The page will be returned to the pool here regardless of the
 	 * 'flipped' fragment being in use or not.
 	 */
-	page->pp = NULL;
 	page_pool_put_full_page(pp, page, false);
 
 	return true;
-- 
2.7.4

