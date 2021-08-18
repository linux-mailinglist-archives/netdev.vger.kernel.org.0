Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDB03EF8A8
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbhHRDe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:34:26 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8033 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbhHRDeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:34:22 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GqD4y2dPszYqJb;
        Wed, 18 Aug 2021 11:33:22 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:27 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:27 +0800
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
        <chenhao288@hisilicon.com>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <memxor@gmail.com>, <linux@rempel-privat.de>, <atenart@kernel.org>,
        <weiwan@google.com>, <ap420073@gmail.com>, <arnd@arndb.de>,
        <mathew.j.martineau@linux.intel.com>, <aahringo@redhat.com>,
        <ceggers@arri.de>, <yangbo.lu@nxp.com>, <fw@strlen.de>,
        <xiangxia.m.yue@gmail.com>, <linmiaohe@huawei.com>
Subject: [PATCH RFC 1/7] page_pool: refactor the page pool to support multi alloc context
Date:   Wed, 18 Aug 2021 11:32:17 +0800
Message-ID: <1629257542-36145-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the page pool assumes the caller MUST guarantee safe
non-concurrent access, e.g. softirq for rx.

This patch refactors the page pool to support multi allocation
contexts, in order to support the tx recycling support in the
page pool(tx means 'socket to netdev' here).

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/page_pool.h | 10 ++++++
 net/core/page_pool.c    | 86 +++++++++++++++++++++++++++----------------------
 2 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index a408240..8d4ae4b 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -135,6 +135,9 @@ struct page_pool {
 };
 
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
+struct page *__page_pool_alloc_pages(struct page_pool *pool,
+				     struct pp_alloc_cache *alloc,
+				     gfp_t gfp);
 
 static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 {
@@ -155,6 +158,13 @@ static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
 	return page_pool_alloc_frag(pool, offset, size, gfp);
 }
 
+struct page *page_pool_drain_frag(struct page_pool *pool, struct page *page,
+				  long drain_count);
+void page_pool_free_frag(struct page_pool *pool, struct page *page,
+			 long drain_count);
+void page_pool_empty_alloc_cache_once(struct page_pool *pool,
+				      struct pp_alloc_cache *alloc);
+
 /* get the stored dma direction. A driver might decide to treat this locally and
  * avoid the extra cache line from page_pool to determine the direction
  */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e140905..7194dcc 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -110,7 +110,8 @@ EXPORT_SYMBOL(page_pool_create);
 static void page_pool_return_page(struct page_pool *pool, struct page *page);
 
 noinline
-static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
+static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
+						 struct pp_alloc_cache *alloc)
 {
 	struct ptr_ring *r = &pool->ring;
 	struct page *page;
@@ -140,7 +141,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 			break;
 
 		if (likely(page_to_nid(page) == pref_nid)) {
-			pool->alloc.cache[pool->alloc.count++] = page;
+			alloc->cache[alloc->count++] = page;
 		} else {
 			/* NUMA mismatch;
 			 * (1) release 1 page to page-allocator and
@@ -151,27 +152,28 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 			page = NULL;
 			break;
 		}
-	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
+	} while (alloc->count < PP_ALLOC_CACHE_REFILL);
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
-		page = pool->alloc.cache[--pool->alloc.count];
+	if (likely(alloc->count > 0))
+		page = alloc->cache[--alloc->count];
 
 	spin_unlock(&r->consumer_lock);
 	return page;
 }
 
 /* fast path */
-static struct page *__page_pool_get_cached(struct page_pool *pool)
+static struct page *__page_pool_get_cached(struct page_pool *pool,
+					   struct pp_alloc_cache *alloc)
 {
 	struct page *page;
 
 	/* Caller MUST guarantee safe non-concurrent access, e.g. softirq */
-	if (likely(pool->alloc.count)) {
+	if (likely(alloc->count)) {
 		/* Fast-path */
-		page = pool->alloc.cache[--pool->alloc.count];
+		page = alloc->cache[--alloc->count];
 	} else {
-		page = page_pool_refill_alloc_cache(pool);
+		page = page_pool_refill_alloc_cache(pool, alloc);
 	}
 
 	return page;
@@ -252,6 +254,7 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 /* slow path */
 noinline
 static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
+						 struct pp_alloc_cache *alloc,
 						 gfp_t gfp)
 {
 	const int bulk = PP_ALLOC_CACHE_REFILL;
@@ -265,13 +268,13 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 		return __page_pool_alloc_page_order(pool, gfp);
 
 	/* Unnecessary as alloc cache is empty, but guarantees zero count */
-	if (unlikely(pool->alloc.count > 0))
-		return pool->alloc.cache[--pool->alloc.count];
+	if (unlikely(alloc->count > 0))
+		return alloc->cache[--alloc->count];
 
 	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
-	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
+	memset(alloc->cache, 0, sizeof(void *) * bulk);
 
-	nr_pages = alloc_pages_bulk_array(gfp, bulk, pool->alloc.cache);
+	nr_pages = alloc_pages_bulk_array(gfp, bulk, alloc->cache);
 	if (unlikely(!nr_pages))
 		return NULL;
 
@@ -279,7 +282,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	 * page element have not been (possibly) DMA mapped.
 	 */
 	for (i = 0; i < nr_pages; i++) {
-		page = pool->alloc.cache[i];
+		page = alloc->cache[i];
 		if ((pp_flags & PP_FLAG_DMA_MAP) &&
 		    unlikely(!page_pool_dma_map(pool, page))) {
 			put_page(page);
@@ -287,7 +290,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 		}
 
 		page_pool_set_pp_info(pool, page);
-		pool->alloc.cache[pool->alloc.count++] = page;
+		alloc->cache[alloc->count++] = page;
 		/* Track how many pages are held 'in-flight' */
 		pool->pages_state_hold_cnt++;
 		trace_page_pool_state_hold(pool, page,
@@ -295,8 +298,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	}
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
-		page = pool->alloc.cache[--pool->alloc.count];
+	if (likely(alloc->count > 0))
+		page = alloc->cache[--alloc->count];
 	else
 		page = NULL;
 
@@ -307,19 +310,27 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 /* For using page_pool replace: alloc_pages() API calls, but provide
  * synchronization guarantee for allocation side.
  */
-struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
+struct page *__page_pool_alloc_pages(struct page_pool *pool,
+				     struct pp_alloc_cache *alloc,
+				     gfp_t gfp)
 {
 	struct page *page;
 
 	/* Fast-path: Get a page from cache */
-	page = __page_pool_get_cached(pool);
+	page = __page_pool_get_cached(pool, alloc);
 	if (page)
 		return page;
 
 	/* Slow-path: cache empty, do real allocation */
-	page = __page_pool_alloc_pages_slow(pool, gfp);
+	page = __page_pool_alloc_pages_slow(pool, alloc, gfp);
 	return page;
 }
+EXPORT_SYMBOL(__page_pool_alloc_pages);
+
+struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
+{
+	return __page_pool_alloc_pages(pool, &pool->alloc, gfp);
+}
 EXPORT_SYMBOL(page_pool_alloc_pages);
 
 /* Calculate distance between two u32 values, valid if distance is below 2^(31)
@@ -522,11 +533,9 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 }
 EXPORT_SYMBOL(page_pool_put_page_bulk);
 
-static struct page *page_pool_drain_frag(struct page_pool *pool,
-					 struct page *page)
+struct page *page_pool_drain_frag(struct page_pool *pool, struct page *page,
+				  long drain_count)
 {
-	long drain_count = BIAS_MAX - pool->frag_users;
-
 	/* Some user is still using the page frag */
 	if (likely(page_pool_atomic_sub_frag_count_return(page,
 							  drain_count)))
@@ -543,13 +552,9 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
 	return NULL;
 }
 
-static void page_pool_free_frag(struct page_pool *pool)
+void page_pool_free_frag(struct page_pool *pool, struct page *page,
+			 long drain_count)
 {
-	long drain_count = BIAS_MAX - pool->frag_users;
-	struct page *page = pool->frag_page;
-
-	pool->frag_page = NULL;
-
 	if (!page ||
 	    page_pool_atomic_sub_frag_count_return(page, drain_count))
 		return;
@@ -572,7 +577,8 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
 	*offset = pool->frag_offset;
 
 	if (page && *offset + size > max_size) {
-		page = page_pool_drain_frag(pool, page);
+		page = page_pool_drain_frag(pool, page,
+					    BIAS_MAX - pool->frag_users);
 		if (page)
 			goto frag_reset;
 	}
@@ -628,26 +634,26 @@ static void page_pool_free(struct page_pool *pool)
 	kfree(pool);
 }
 
-static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
+void page_pool_empty_alloc_cache_once(struct page_pool *pool,
+				      struct pp_alloc_cache *alloc)
 {
 	struct page *page;
 
-	if (pool->destroy_cnt)
-		return;
-
 	/* Empty alloc cache, assume caller made sure this is
 	 * no-longer in use, and page_pool_alloc_pages() cannot be
 	 * call concurrently.
 	 */
-	while (pool->alloc.count) {
-		page = pool->alloc.cache[--pool->alloc.count];
+	while (alloc->count) {
+		page = alloc->cache[--alloc->count];
 		page_pool_return_page(pool, page);
 	}
 }
 
 static void page_pool_scrub(struct page_pool *pool)
 {
-	page_pool_empty_alloc_cache_once(pool);
+	if (!pool->destroy_cnt)
+		page_pool_empty_alloc_cache_once(pool, &pool->alloc);
+
 	pool->destroy_cnt++;
 
 	/* No more consumers should exist, but producers could still
@@ -705,7 +711,9 @@ void page_pool_destroy(struct page_pool *pool)
 	if (!page_pool_put(pool))
 		return;
 
-	page_pool_free_frag(pool);
+	page_pool_free_frag(pool, pool->frag_page,
+			    BIAS_MAX - pool->frag_users);
+	pool->frag_page = NULL;
 
 	if (!page_pool_release(pool))
 		return;
-- 
2.7.4

