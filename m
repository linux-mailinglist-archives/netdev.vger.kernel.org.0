Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA0B3C3392
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhGJHqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:46:53 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:11250 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhGJHqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:46:48 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GMMMm4FpJz1CGx2;
        Sat, 10 Jul 2021 15:38:28 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 10 Jul 2021 15:44:01 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 10 Jul 2021 15:44:00 +0800
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
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: [PATCH rfc v2 3/5] page_pool: add page recycling support based on elevated refcnt
Date:   Sat, 10 Jul 2021 15:43:20 +0800
Message-ID: <1625903002-31619-4-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com>
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently page pool only support page recycling only when
refcnt of page is one, which means it can not support the
split page recycling implemented in the most driver.

The expectation of page recycling based on elevated refcnt
is that we only do the recycling or freeing of page when the
last user has dropped the refcnt that has given to it.

The above expectation is based on that the last user will
always call page_pool_put_full_page() in order to do the
recycling or do the resource cleanup(dma unmaping..etc) and
freeing.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/page_pool.h |   5 ++-
 net/core/page_pool.c    | 106 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 84 insertions(+), 27 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 5746f17..f0e708d 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -45,7 +45,10 @@
 					* Please note DMA-sync-for-CPU is still
 					* device driver responsibility
 					*/
-#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
+#define PP_FLAG_PAGECNT_BIAS	BIT(2)	/* For elevated refcnt feature */
+#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP |\
+				 PP_FLAG_DMA_SYNC_DEV |\
+				 PP_FLAG_PAGECNT_BIAS)
 
 /*
  * Fast allocation side cache array/stack
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 78838c6..a87cbe1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -24,6 +24,8 @@
 #define DEFER_TIME (msecs_to_jiffies(1000))
 #define DEFER_WARN_INTERVAL (60 * HZ)
 
+#define BIAS_MAX	(PAGE_SIZE - 1)
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
@@ -209,14 +211,24 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 static void page_pool_set_pp_info(struct page_pool *pool,
 				  struct page *page)
 {
+	if (pool->p.flags & PP_FLAG_PAGECNT_BIAS) {
+		page_ref_add(page, BIAS_MAX);
+		page_pool_set_pagecnt_bias(page, BIAS_MAX);
+	}
+
 	page->pp = pool;
 	page->pp_magic |= PP_SIGNATURE;
 }
 
-static void page_pool_clear_pp_info(struct page *page)
+static int page_pool_clear_pp_info(struct page *page)
 {
+	int bias = page_pool_get_pagecnt_bias(page);
+
 	page->pp_magic = 0;
 	page->pp = NULL;
+	page_pool_set_pagecnt_bias(page, 0);
+
+	return bias;
 }
 
 static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
@@ -298,6 +310,23 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	return page;
 }
 
+static void page_pool_sub_bias(struct page_pool *pool,
+			       struct page *page, int nr)
+{
+	int bias;
+
+	if (!(pool->p.flags & PP_FLAG_PAGECNT_BIAS))
+		return;
+
+	bias = page_pool_get_pagecnt_bias(page);
+	if (unlikely(bias <= nr)) {
+		page_ref_add(page, BIAS_MAX - bias);
+		bias = BIAS_MAX;
+	}
+
+	page_pool_set_pagecnt_bias(page, bias - nr);
+}
+
 /* For using page_pool replace: alloc_pages() API calls, but provide
  * synchronization guarantee for allocation side.
  */
@@ -307,11 +336,16 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
 
 	/* Fast-path: Get a page from cache */
 	page = __page_pool_get_cached(pool);
-	if (page)
+	if (page) {
+		page_pool_sub_bias(pool, page, 1);
 		return page;
+	}
 
 	/* Slow-path: cache empty, do real allocation */
 	page = __page_pool_alloc_pages_slow(pool, gfp);
+	if (likely(page))
+		page_pool_sub_bias(pool, page, 1);
+
 	return page;
 }
 EXPORT_SYMBOL(page_pool_alloc_pages);
@@ -340,10 +374,11 @@ static s32 page_pool_inflight(struct page_pool *pool)
  * a regular page (that will eventually be returned to the normal
  * page-allocator via put_page).
  */
-void page_pool_release_page(struct page_pool *pool, struct page *page)
+static int __page_pool_release_page(struct page_pool *pool,
+				    struct page *page)
 {
+	int bias, count;
 	dma_addr_t dma;
-	int count;
 
 	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
 		/* Always account for inflight pages, even if we didn't
@@ -359,22 +394,30 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 			     DMA_ATTR_SKIP_CPU_SYNC);
 	page_pool_set_dma_addr(page, 0);
 skip_dma_unmap:
-	page_pool_clear_pp_info(page);
+	bias = page_pool_clear_pp_info(page);
 
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
 	 */
 	count = atomic_inc_return(&pool->pages_state_release_cnt);
 	trace_page_pool_state_release(pool, page, count);
+
+	return bias;
+}
+
+void page_pool_release_page(struct page_pool *pool, struct page *page)
+{
+	int bias = __page_pool_release_page(pool, page);
+
+	WARN_ONCE(bias, "%s is called from driver with elevated refcnt\n",
+		  __func__);
 }
 EXPORT_SYMBOL(page_pool_release_page);
 
 /* Return a page to the page allocator, cleaning up our state */
 static void page_pool_return_page(struct page_pool *pool, struct page *page)
 {
-	page_pool_release_page(pool, page);
-
-	put_page(page);
+	__page_frag_cache_drain(page, __page_pool_release_page(pool, page) + 1);
 	/* An optimization would be to call __free_pages(page, pool->p.order)
 	 * knowing page is not part of page-cache (thus avoiding a
 	 * __page_cache_release() call).
@@ -409,6 +452,15 @@ static bool page_pool_recycle_in_cache(struct page *page,
 	return true;
 }
 
+static bool page_pool_bias_page_recyclable(struct page *page, int bias)
+{
+	int ref = page_ref_dec_return(page);
+
+	WARN_ON(ref <= bias);
+
+	return ref == bias + 1;
+}
+
 /* If the page refcnt == 1, this will try to recycle the page.
  * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
  * the configured size min(dma_sync_size, pool->max_len).
@@ -419,6 +471,20 @@ static __always_inline struct page *
 __page_pool_put_page(struct page_pool *pool, struct page *page,
 		     unsigned int dma_sync_size, bool allow_direct)
 {
+	int bias = page_pool_get_pagecnt_bias(page);
+
+	/* Handle the elevated refcnt case first */
+	if (bias) {
+		/* It is not the last user yet */
+		if (!page_pool_bias_page_recyclable(page, bias))
+			return NULL;
+
+		if (likely(!page_is_pfmemalloc(page)))
+			goto recyclable;
+		else
+			goto unrecyclable;
+	}
+
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
 	 * regular page allocator APIs.
@@ -430,7 +496,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 	 */
 	if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
 		/* Read barrier done in page_ref_count / READ_ONCE */
-
+recyclable:
 		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
 			page_pool_dma_sync_for_device(pool, page,
 						      dma_sync_size);
@@ -442,22 +508,9 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 		/* Page found as candidate for recycling */
 		return page;
 	}
-	/* Fallback/non-XDP mode: API user have elevated refcnt.
-	 *
-	 * Many drivers split up the page into fragments, and some
-	 * want to keep doing this to save memory and do refcnt based
-	 * recycling. Support this use case too, to ease drivers
-	 * switching between XDP/non-XDP.
-	 *
-	 * In-case page_pool maintains the DMA mapping, API user must
-	 * call page_pool_put_page once.  In this elevated refcnt
-	 * case, the DMA is unmapped/released, as driver is likely
-	 * doing refcnt based recycle tricks, meaning another process
-	 * will be invoking put_page.
-	 */
-	/* Do not replace this with page_pool_return_page() */
-	page_pool_release_page(pool, page);
-	put_page(page);
+
+unrecyclable:
+	page_pool_return_page(pool, page);
 
 	return NULL;
 }
@@ -518,7 +571,8 @@ static void page_pool_empty_ring(struct page_pool *pool)
 	/* Empty recycle ring */
 	while ((page = ptr_ring_consume_bh(&pool->ring))) {
 		/* Verify the refcnt invariant of cached pages */
-		if (!(page_ref_count(page) == 1))
+		if (!(page_ref_count(page) ==
+		      (page_pool_get_pagecnt_bias(page) + 1)))
 			pr_crit("%s() page_pool refcnt %d violation\n",
 				__func__, page_ref_count(page));
 
-- 
2.7.4

