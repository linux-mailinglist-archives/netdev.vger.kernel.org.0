Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2BADA1BF
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395226AbfJPWvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:51:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55174 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2394598AbfJPWvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:51:00 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9GMormh004297
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:58 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vp3uk2nn5-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:57 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 16 Oct 2019 15:50:29 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id E21384A2BD66; Wed, 16 Oct 2019 15:50:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH 10/10 net-next] page_pool: Cleanup and rename page_pool functions.
Date:   Wed, 16 Oct 2019 15:50:28 -0700
Message-ID: <20191016225028.2100206-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=2 malwarescore=0
 adultscore=0 clxscore=1034 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions starting with __ usually indicate those which are called
while holding a lock, or are exported, but should not be called
directly.  Internal static functions don't meet either of these
criteria, so make it more readable.

Move stub functions to end of file in their own section for readability
and ease of maintenance.  Add missing page_pool_get() stub function.

Checked by compiling kernel without PAGE_POOL defined.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/net/page_pool.h | 141 ++++++++++++++++++++--------------------
 net/core/page_pool.c    |  76 ++++++++++------------
 2 files changed, 102 insertions(+), 115 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 4f383522b141..3d1590be5638 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -124,6 +124,8 @@ struct page_pool {
 	void *alloc_cache[];
 };
 
+#ifdef CONFIG_PAGE_POOL
+
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
 
 static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
@@ -133,8 +135,8 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 	return page_pool_alloc_pages(pool, gfp);
 }
 
-/* get the stored dma direction. A driver might decide to treat this locally and
- * avoid the extra cache line from page_pool to determine the direction
+/* get the stored dma direction. A driver might decide to treat this locally
+ * and avoid the extra cache line from page_pool to determine the direction.
  */
 static
 inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
@@ -143,16 +145,36 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 }
 
 struct page_pool *page_pool_create(const struct page_pool_params *params);
+void page_pool_free(struct page_pool *pool);
+void page_pool_put_page(struct page_pool *pool,
+			struct page *page, bool allow_direct);
 
-void __page_pool_free(struct page_pool *pool);
-static inline void page_pool_free(struct page_pool *pool)
+/* Very limited use-cases allow recycle direct */
+static inline void page_pool_recycle_direct(struct page_pool *pool,
+					    struct page *page)
 {
-	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
-	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
-	 */
-#ifdef CONFIG_PAGE_POOL
-	__page_pool_free(pool);
-#endif
+	page_pool_put_page(pool, page, true);
+}
+
+/* API user MUST have disconnected alloc-side (not allowed to call
+ * page_pool_alloc_pages()) before calling this.  The free-side can
+ * still run concurrently, to handle in-flight packet-pages.
+ *
+ * A request to shutdown can fail (with false) if there are still
+ * in-flight packet-pages.
+ */
+bool page_pool_request_shutdown(struct page_pool *pool);
+
+/* Disconnects a page (from a page_pool).  API users can have a need
+ * to disconnect a page (from a page_pool), to allow it to be used as
+ * a regular page (that will eventually be returned to the normal
+ * page-allocator via put_page).
+ */
+void page_pool_release_page(struct page_pool *pool, struct page *page);
+
+static inline bool is_page_pool_compiled_in(void)
+{
+	return true;
 }
 
 /* Drivers use this instead of page_pool_free */
@@ -164,73 +186,11 @@ static inline void page_pool_destroy(struct page_pool *pool)
 	page_pool_free(pool);
 }
 
-/* Never call this directly, use helpers below */
-void __page_pool_put_page(struct page_pool *pool,
-			  struct page *page, bool allow_direct);
-
-static inline void page_pool_put_page(struct page_pool *pool,
-				      struct page *page, bool allow_direct)
-{
-	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
-	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
-	 */
-#ifdef CONFIG_PAGE_POOL
-	__page_pool_put_page(pool, page, allow_direct);
-#endif
-}
-/* Very limited use-cases allow recycle direct */
-static inline void page_pool_recycle_direct(struct page_pool *pool,
-					    struct page *page)
-{
-	__page_pool_put_page(pool, page, true);
-}
-
-/* API user MUST have disconnected alloc-side (not allowed to call
- * page_pool_alloc_pages()) before calling this.  The free-side can
- * still run concurrently, to handle in-flight packet-pages.
- *
- * A request to shutdown can fail (with false) if there are still
- * in-flight packet-pages.
- */
-bool __page_pool_request_shutdown(struct page_pool *pool);
-static inline bool page_pool_request_shutdown(struct page_pool *pool)
-{
-	bool safe_to_remove = false;
-
-#ifdef CONFIG_PAGE_POOL
-	safe_to_remove = __page_pool_request_shutdown(pool);
-#endif
-	return safe_to_remove;
-}
-
-/* Disconnects a page (from a page_pool).  API users can have a need
- * to disconnect a page (from a page_pool), to allow it to be used as
- * a regular page (that will eventually be returned to the normal
- * page-allocator via put_page).
- */
-void page_pool_unmap_page(struct page_pool *pool, struct page *page);
-static inline void page_pool_release_page(struct page_pool *pool,
-					  struct page *page)
-{
-#ifdef CONFIG_PAGE_POOL
-	page_pool_unmap_page(pool, page);
-#endif
-}
-
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
 	return page->dma_addr;
 }
 
-static inline bool is_page_pool_compiled_in(void)
-{
-#ifdef CONFIG_PAGE_POOL
-	return true;
-#else
-	return false;
-#endif
-}
-
 static inline void page_pool_get(struct page_pool *pool)
 {
 	refcount_inc(&pool->user_cnt);
@@ -249,4 +209,41 @@ static inline void page_pool_update_nid(struct page_pool *pool, int new_nid)
 		pool->p.stats->node_change++;
 	}
 }
+
+#else
+
+/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
+ * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
+ */
+
+static inline void page_pool_free(struct page_pool *pool)
+{
+}
+
+static inline void page_pool_put_page(struct page_pool *pool,
+				      struct page *page, bool allow_direct)
+{
+}
+
+static inline bool page_pool_request_shutdown(struct page_pool *pool)
+{
+	return false;
+}
+
+static inline void page_pool_release_page(struct page_pool *pool,
+					  struct page *page)
+{
+}
+
+static inline bool is_page_pool_compiled_in(void)
+{
+	return false;
+}
+
+static inline void page_pool_get(struct page_pool *pool)
+{
+}
+
+#endif /* CONFIG_PAGE_POOL */
+
 #endif /* _NET_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ea6202813584..5ef062db61bc 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -103,7 +103,7 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
 EXPORT_SYMBOL(page_pool_create);
 
 /* fast path */
-static struct page *__page_pool_get_cached(struct page_pool *pool)
+static struct page *page_pool_get_cached(struct page_pool *pool)
 {
 	struct ptr_ring *r = &pool->ring;
 	bool refill = false;
@@ -143,8 +143,8 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 
 /* slow path */
 noinline
-static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
-						 gfp_t _gfp)
+static struct page *page_pool_alloc_pages_slow(struct page_pool *pool,
+					       gfp_t _gfp)
 {
 	struct page *page;
 	gfp_t gfp = _gfp;
@@ -203,12 +203,12 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
 	struct page *page;
 
 	/* Fast-path: Get a page from cache */
-	page = __page_pool_get_cached(pool);
+	page = page_pool_get_cached(pool);
 	if (page)
 		return page;
 
 	/* Slow-path: cache empty, do real allocation */
-	page = __page_pool_alloc_pages_slow(pool, gfp);
+	page = page_pool_alloc_pages_slow(pool, gfp);
 	return page;
 }
 EXPORT_SYMBOL(page_pool_alloc_pages);
@@ -230,7 +230,7 @@ static s32 page_pool_inflight(struct page_pool *pool)
 	return distance;
 }
 
-static bool __page_pool_safe_to_destroy(struct page_pool *pool)
+static bool page_pool_safe_to_destroy(struct page_pool *pool)
 {
 	s32 inflight = page_pool_inflight(pool);
 
@@ -241,8 +241,7 @@ static bool __page_pool_safe_to_destroy(struct page_pool *pool)
 }
 
 /* Cleanup page_pool state from page */
-static void __page_pool_clean_page(struct page_pool *pool,
-				   struct page *page)
+void page_pool_release_page(struct page_pool *pool, struct page *page)
 {
 	dma_addr_t dma;
 
@@ -260,31 +259,22 @@ static void __page_pool_clean_page(struct page_pool *pool,
 	trace_page_pool_state_release(pool, page,
 			      atomic_read(&pool->pages_state_release_cnt));
 }
-
-/* unmap the page and clean our state */
-void page_pool_unmap_page(struct page_pool *pool, struct page *page)
-{
-	/* When page is unmapped, this implies page will not be
-	 * returned to page_pool.
-	 */
-	__page_pool_clean_page(pool, page);
-}
-EXPORT_SYMBOL(page_pool_unmap_page);
+EXPORT_SYMBOL(page_pool_release_page);
 
 /* Return a page to the page allocator, cleaning up our state */
-static void __page_pool_return_page(struct page_pool *pool, struct page *page)
+static void page_pool_return_page(struct page_pool *pool, struct page *page)
 {
-	__page_pool_clean_page(pool, page);
+	page_pool_release_page(pool, page);
 
 	put_page(page);
 	/* An optimization would be to call __free_pages(page, pool->p.order)
 	 * knowing page is not part of page-cache (thus avoiding a
-	 * __page_cache_release() call).
+	 * page_cache_release() call).
 	 */
 }
 
-static bool __page_pool_recycle_into_ring(struct page_pool *pool,
-				   struct page *page)
+static bool page_pool_recycle_into_ring(struct page_pool *pool,
+					struct page *page)
 {
 	struct ptr_ring *r = &pool->ring;
 	int ret;
@@ -310,8 +300,8 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
  *
  * Caller must provide appropriate safe context.
  */
-static bool __page_pool_recycle_into_cache(struct page *page,
-					   struct page_pool *pool)
+static bool page_pool_recycle_into_cache(struct page *page,
+					 struct page_pool *pool)
 {
 	if (unlikely(pool->alloc_count == pool->p.cache_size)) {
 		pool->p.stats->cache_full++;
@@ -334,8 +324,8 @@ static bool page_pool_keep_page(struct page_pool *pool, struct page *page)
 	       !page_is_pfmemalloc(page);
 }
 
-void __page_pool_put_page(struct page_pool *pool,
-			  struct page *page, bool allow_direct)
+void page_pool_put_page(struct page_pool *pool,
+			struct page *page, bool allow_direct)
 {
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
@@ -345,10 +335,10 @@ void __page_pool_put_page(struct page_pool *pool,
 		/* Read barrier done in page_ref_count / READ_ONCE */
 
 		if (allow_direct && in_serving_softirq())
-			if (__page_pool_recycle_into_cache(page, pool))
+			if (page_pool_recycle_into_cache(page, pool))
 				return;
 
-		if (__page_pool_recycle_into_ring(pool, page))
+		if (page_pool_recycle_into_ring(pool, page))
 			return;
 
 		/* Cache full, fallback to return pages */
@@ -366,11 +356,11 @@ void __page_pool_put_page(struct page_pool *pool,
 	 * doing refcnt based recycle tricks, meaning another process
 	 * will be invoking put_page.
 	 */
-	__page_pool_return_page(pool, page);
+	page_pool_return_page(pool, page);
 }
-EXPORT_SYMBOL(__page_pool_put_page);
+EXPORT_SYMBOL(page_pool_put_page);
 
-static void __page_pool_empty_ring(struct page_pool *pool)
+static void page_pool_empty_ring(struct page_pool *pool)
 {
 	struct page *page;
 	int count = 0;
@@ -383,13 +373,13 @@ static void __page_pool_empty_ring(struct page_pool *pool)
 				__func__, page_ref_count(page));
 
 		count++;
-		__page_pool_return_page(pool, page);
+		page_pool_return_page(pool, page);
 	}
 
 	pool->p.stats->ring_return += count;
 }
 
-static void __warn_in_flight(struct page_pool *pool)
+static void warn_in_flight(struct page_pool *pool)
 {
 	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
 	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
@@ -402,7 +392,7 @@ static void __warn_in_flight(struct page_pool *pool)
 	     distance, hold_cnt, release_cnt);
 }
 
-void __page_pool_free(struct page_pool *pool)
+void page_pool_free(struct page_pool *pool)
 {
 	/* Only last user actually free/release resources */
 	if (!page_pool_put(pool))
@@ -412,8 +402,8 @@ void __page_pool_free(struct page_pool *pool)
 	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
 
 	/* Can happen due to forced shutdown */
-	if (!__page_pool_safe_to_destroy(pool))
-		__warn_in_flight(pool);
+	if (!page_pool_safe_to_destroy(pool))
+		warn_in_flight(pool);
 
 	if (pool->p.flags & PP_FLAG_INTERNAL_STATS)
 		kfree(pool->p.stats);
@@ -425,7 +415,7 @@ void __page_pool_free(struct page_pool *pool)
 
 	kfree(pool);
 }
-EXPORT_SYMBOL(__page_pool_free);
+EXPORT_SYMBOL(page_pool_free);
 
 static void page_pool_flush(struct page_pool *pool)
 {
@@ -439,22 +429,22 @@ static void page_pool_flush(struct page_pool *pool)
 	 */
 	while (pool->alloc_count) {
 		page = pool->alloc_cache[--pool->alloc_count];
-		__page_pool_return_page(pool, page);
+		page_pool_return_page(pool, page);
 	}
 
 	/* No more consumers should exist, but producers could still
 	 * be in-flight.
 	 */
-	__page_pool_empty_ring(pool);
+	page_pool_empty_ring(pool);
 }
 
 /* Request to shutdown: release pages cached by page_pool, and check
  * for in-flight pages
  */
-bool __page_pool_request_shutdown(struct page_pool *pool)
+bool page_pool_request_shutdown(struct page_pool *pool)
 {
 	page_pool_flush(pool);
 
-	return __page_pool_safe_to_destroy(pool);
+	return page_pool_safe_to_destroy(pool);
 }
-EXPORT_SYMBOL(__page_pool_request_shutdown);
+EXPORT_SYMBOL(page_pool_request_shutdown);
-- 
2.17.1

