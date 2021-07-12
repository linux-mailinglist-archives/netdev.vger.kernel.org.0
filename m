Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7593C5A07
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358975AbhGLJXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 05:23:22 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:11260 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350313AbhGLJXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 05:23:18 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GNdQ033M2z1CJ4n;
        Mon, 12 Jul 2021 17:14:48 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 17:20:23 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 17:20:22 +0800
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
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH rfc v3 3/4] page_pool: add page recycling support based on elevated refcnt
Date:   Mon, 12 Jul 2021 17:19:40 +0800
Message-ID: <1626081581-54524-5-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626081581-54524-1-git-send-email-linyunsheng@huawei.com>
References: <1626081581-54524-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently page pool only support page recycling only when
there is only one user of the page, and the split page
reusing implemented in the most driver can not use the
page pool as bing-pong way of reusing requires the elevated
refcnt support.

Those reusing or recycling has below limitations:
1. page from page pool can only be used be one user in order
   for the page recycling to happen.
2. Bing-pong way of reusing in most driver does not support
   multi desc using different part of the same page in order
   to save memory.

So add elevated refcnt support in page pool to in order to
overcome the above limitation.

This is a preparation to support allocating page frag in page
pool.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/page_pool.h |  22 ++++++++-
 net/core/page_pool.c    | 121 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 129 insertions(+), 14 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 84cd972..d9a736f 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -45,7 +45,10 @@
 					* Please note DMA-sync-for-CPU is still
 					* device driver responsibility
 					*/
-#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
+#define PP_FLAG_PAGE_FRAG	BIT(2)	/* for page frag feature */
+#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP |\
+				 PP_FLAG_DMA_SYNC_DEV |\
+				 PP_FLAG_PAGE_FRAG)
 
 /*
  * Fast allocation side cache array/stack
@@ -88,6 +91,9 @@ struct page_pool {
 	unsigned long defer_warn;
 
 	u32 pages_state_hold_cnt;
+	unsigned int frag_offset;
+	int frag_bias;
+	struct page *frag_page;
 
 	/*
 	 * Data structure for allocation side
@@ -137,6 +143,20 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 	return page_pool_alloc_pages(pool, gfp);
 }
 
+struct page *page_pool_alloc_frag(struct page_pool *pool,
+				  unsigned int *offset,
+				  unsigned int size,
+				  gfp_t gfp);
+
+static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
+						    unsigned int *offset,
+						    unsigned int size)
+{
+	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
+
+	return page_pool_alloc_frag(pool, offset, size, gfp);
+}
+
 /* get the stored dma direction. A driver might decide to treat this locally and
  * avoid the extra cache line from page_pool to determine the direction
  */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1abefc6..9f518dc 100644
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
@@ -304,6 +306,33 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	return page;
 }
 
+/* nr could be negative */
+static int page_pool_atomic_add_bias(struct page *page, int nr)
+{
+	unsigned long *bias_ptr = page_pool_pagecnt_bias_ptr(page);
+	unsigned long old_bias = READ_ONCE(*bias_ptr);
+	unsigned long new_bias;
+
+	do {
+		int bias = (int)(old_bias & ~PAGE_MASK);
+
+		/* Warn when page_pool_dev_alloc_pages() is called
+		 * with PP_FLAG_PAGE_FRAG flag in driver.
+		 */
+		WARN_ON(!bias);
+
+		/* already the last user */
+		if (!(bias + nr))
+			return 0;
+
+		new_bias = old_bias + nr;
+	} while (!try_cmpxchg(bias_ptr, &old_bias, new_bias));
+
+	WARN_ON((new_bias & PAGE_MASK) != (old_bias & PAGE_MASK));
+
+	return new_bias & ~PAGE_MASK;
+}
+
 /* For using page_pool replace: alloc_pages() API calls, but provide
  * synchronization guarantee for allocation side.
  */
@@ -425,6 +454,11 @@ static __always_inline struct page *
 __page_pool_put_page(struct page_pool *pool, struct page *page,
 		     unsigned int dma_sync_size, bool allow_direct)
 {
+	/* It is not the last user for the page frag case */
+	if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
+	    page_pool_atomic_add_bias(page, -1))
+		return NULL;
+
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
 	 * regular page allocator APIs.
@@ -448,19 +482,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
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
+
 	/* Do not replace this with page_pool_return_page() */
 	page_pool_release_page(pool, page);
 	put_page(page);
@@ -517,6 +539,77 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 }
 EXPORT_SYMBOL(page_pool_put_page_bulk);
 
+/* When BIAS_RESERVE to avoid frag page being recycled back to
+ * page pool while the frag page is still in pool->frag_page
+ * waiting for more user. As minimum align size for DMA seems to
+ * be 32, so we support max size of 2047 * 32 for 4K page size.
+ */
+#define BIAS_RESERVE		((int)(BIAS_MAX / 2 + 1))
+#define BIAS_NEGATIVE_RESERVE	(0 - BIAS_RESERVE)
+
+static struct page *page_pool_drain_frag(struct page_pool *pool,
+					 struct page *page)
+{
+	/* page pool is not the last user */
+	if (page_pool_atomic_add_bias(page, pool->frag_bias +
+				      BIAS_NEGATIVE_RESERVE))
+		return NULL;
+	else
+		return page;
+}
+
+static void page_pool_free_frag(struct page_pool *pool)
+{
+	struct page *page = pool->frag_page;
+
+	if (!page ||
+	    page_pool_atomic_add_bias(page, pool->frag_bias +
+				      BIAS_NEGATIVE_RESERVE))
+		return;
+
+	page_pool_return_page(pool, page);
+	pool->frag_page = NULL;
+}
+
+struct page *page_pool_alloc_frag(struct page_pool *pool,
+				  unsigned int *offset,
+				  unsigned int size,
+				  gfp_t gfp)
+{
+	unsigned int max_size = PAGE_SIZE << pool->p.order;
+	unsigned int frag_offset = pool->frag_offset;
+	struct page *frag_page = pool->frag_page;
+
+	if (WARN_ON(!(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
+		    size > max_size))
+		return NULL;
+
+	size = ALIGN(size, dma_get_cache_alignment());
+
+	if (frag_page && frag_offset + size > max_size)
+		frag_page = page_pool_drain_frag(pool, frag_page);
+
+	if (!frag_page) {
+		frag_page = page_pool_alloc_pages(pool, gfp);
+		if (unlikely(!frag_page)) {
+			pool->frag_page = NULL;
+			return NULL;
+		}
+
+		pool->frag_page = frag_page;
+		pool->frag_bias = 0;
+		frag_offset = 0;
+		page_pool_set_pagecnt_bias(frag_page, BIAS_RESERVE);
+	}
+
+	pool->frag_bias++;
+	*offset = frag_offset;
+	pool->frag_offset = frag_offset + size;
+
+	return frag_page;
+}
+EXPORT_SYMBOL(page_pool_alloc_frag);
+
 static void page_pool_empty_ring(struct page_pool *pool)
 {
 	struct page *page;
@@ -622,6 +715,8 @@ void page_pool_destroy(struct page_pool *pool)
 	if (!page_pool_put(pool))
 		return;
 
+	page_pool_free_frag(pool);
+
 	if (!page_pool_release(pool))
 		return;
 
-- 
2.7.4

