Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB96FD0C5
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 23:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfKNWNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 17:13:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52552 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726613AbfKNWNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 17:13:06 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAELtmcT011481
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 14:13:03 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8u0tfhsr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 14:13:03 -0800
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 14 Nov 2019 14:13:01 -0800
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id CF59B62B602A; Thu, 14 Nov 2019 14:13:00 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <ilias.apalodimas@linaro.org>, <brouer@redhat.com>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [net-next PATCH v3 1/1] page_pool: do not release pool until inflight == 0.
Date:   Thu, 14 Nov 2019 14:13:00 -0800
Message-ID: <20191114221300.1002982-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114221300.1002982-1-jonathan.lemon@gmail.com>
References: <20191114221300.1002982-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=2 malwarescore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1034 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911140178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The page pool keeps track of the number of pages in flight, and
it isn't safe to remove the pool until all pages are returned.

Disallow removing the pool until all pages are back, so the pool
is always available for page producers.

Make the page pool responsible for its own delayed destruction
instead of relying on XDP, so the page pool can be used without
the xdp memory model.

When all pages are returned, free the pool and notify xdp if the
pool is registered with the xdp memory system.  Have the callback
perform a table walk since some drivers (cpsw) may share the pool
among multiple xdp_rxq_info.

Note that the increment of pages_state_release_cnt may result in
inflight == 0, resulting in the pool being released.

Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic warning")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
 include/net/page_pool.h                       |  54 +++-----
 include/net/xdp_priv.h                        |   4 -
 include/trace/events/xdp.h                    |  19 +--
 net/core/page_pool.c                          | 124 ++++++++++-------
 net/core/xdp.c                                | 125 +++++++-----------
 6 files changed, 143 insertions(+), 187 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 199c4f938bb2..cd0d8a4bbeb3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1502,10 +1502,8 @@ static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
 					  rx_q->dma_erx, rx_q->dma_rx_phy);
 
 		kfree(rx_q->buf_pool);
-		if (rx_q->page_pool) {
-			page_pool_request_shutdown(rx_q->page_pool);
+		if (rx_q->page_pool)
 			page_pool_destroy(rx_q->page_pool);
-		}
 	}
 }
 
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2cbcdbdec254..1121faa99c12 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -70,7 +70,12 @@ struct page_pool_params {
 struct page_pool {
 	struct page_pool_params p;
 
-        u32 pages_state_hold_cnt;
+	struct delayed_work release_dw;
+	void (*disconnect)(void *);
+	unsigned long defer_start;
+	unsigned long defer_warn;
+
+	u32 pages_state_hold_cnt;
 
 	/*
 	 * Data structure for allocation side
@@ -129,26 +134,20 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
-void __page_pool_free(struct page_pool *pool);
-static inline void page_pool_free(struct page_pool *pool)
-{
-	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
-	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
-	 */
 #ifdef CONFIG_PAGE_POOL
-	__page_pool_free(pool);
-#endif
-}
-
-/* Drivers use this instead of page_pool_free */
+void page_pool_destroy(struct page_pool *pool);
+void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *));
+#else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
-	if (!pool)
-		return;
-
-	page_pool_free(pool);
 }
 
+static inline void page_pool_use_xdp_mem(struct page_pool *pool,
+					 void (*disconnect)(void *))
+{
+}
+#endif
+
 /* Never call this directly, use helpers below */
 void __page_pool_put_page(struct page_pool *pool,
 			  struct page *page, bool allow_direct);
@@ -170,24 +169,6 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	__page_pool_put_page(pool, page, true);
 }
 
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
 /* Disconnects a page (from a page_pool).  API users can have a need
  * to disconnect a page (from a page_pool), to allow it to be used as
  * a regular page (that will eventually be returned to the normal
@@ -216,11 +197,6 @@ static inline bool is_page_pool_compiled_in(void)
 #endif
 }
 
-static inline void page_pool_get(struct page_pool *pool)
-{
-	refcount_inc(&pool->user_cnt);
-}
-
 static inline bool page_pool_put(struct page_pool *pool)
 {
 	return refcount_dec_and_test(&pool->user_cnt);
diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
index 6a8cba6ea79a..a9d5b7603b89 100644
--- a/include/net/xdp_priv.h
+++ b/include/net/xdp_priv.h
@@ -12,12 +12,8 @@ struct xdp_mem_allocator {
 		struct page_pool *page_pool;
 		struct zero_copy_allocator *zc_alloc;
 	};
-	int disconnect_cnt;
-	unsigned long defer_start;
 	struct rhash_head node;
 	struct rcu_head rcu;
-	struct delayed_work defer_wq;
-	unsigned long defer_warn;
 };
 
 #endif /* __LINUX_NET_XDP_PRIV_H__ */
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index c7e3c9c5bad3..a7378bcd9928 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -317,19 +317,15 @@ __MEM_TYPE_MAP(__MEM_TYPE_TP_FN)
 
 TRACE_EVENT(mem_disconnect,
 
-	TP_PROTO(const struct xdp_mem_allocator *xa,
-		 bool safe_to_remove, bool force),
+	TP_PROTO(const struct xdp_mem_allocator *xa),
 
-	TP_ARGS(xa, safe_to_remove, force),
+	TP_ARGS(xa),
 
 	TP_STRUCT__entry(
 		__field(const struct xdp_mem_allocator *,	xa)
 		__field(u32,		mem_id)
 		__field(u32,		mem_type)
 		__field(const void *,	allocator)
-		__field(bool,		safe_to_remove)
-		__field(bool,		force)
-		__field(int,		disconnect_cnt)
 	),
 
 	TP_fast_assign(
@@ -337,19 +333,12 @@ TRACE_EVENT(mem_disconnect,
 		__entry->mem_id		= xa->mem.id;
 		__entry->mem_type	= xa->mem.type;
 		__entry->allocator	= xa->allocator;
-		__entry->safe_to_remove	= safe_to_remove;
-		__entry->force		= force;
-		__entry->disconnect_cnt	= xa->disconnect_cnt;
 	),
 
-	TP_printk("mem_id=%d mem_type=%s allocator=%p"
-		  " safe_to_remove=%s force=%s disconnect_cnt=%d",
+	TP_printk("mem_id=%d mem_type=%s allocator=%p",
 		  __entry->mem_id,
 		  __print_symbolic(__entry->mem_type, __MEM_TYPE_SYM_TAB),
-		  __entry->allocator,
-		  __entry->safe_to_remove ? "true" : "false",
-		  __entry->force ? "true" : "false",
-		  __entry->disconnect_cnt
+		  __entry->allocator
 	)
 );
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 5bc65587f1c4..dfc2501c35d9 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -18,6 +18,9 @@
 
 #include <trace/events/page_pool.h>
 
+#define DEFER_TIME (msecs_to_jiffies(1000))
+#define DEFER_WARN_INTERVAL (60 * HZ)
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
@@ -193,22 +196,14 @@ static s32 page_pool_inflight(struct page_pool *pool)
 {
 	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
 	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
-	s32 distance;
+	s32 inflight;
 
-	distance = _distance(hold_cnt, release_cnt);
+	inflight = _distance(hold_cnt, release_cnt);
 
-	trace_page_pool_inflight(pool, distance, hold_cnt, release_cnt);
-	return distance;
-}
-
-static bool __page_pool_safe_to_destroy(struct page_pool *pool)
-{
-	s32 inflight = page_pool_inflight(pool);
-
-	/* The distance should not be able to become negative */
+	trace_page_pool_inflight(pool, inflight, hold_cnt, release_cnt);
 	WARN(inflight < 0, "Negative(%d) inflight packet-pages", inflight);
 
-	return (inflight == 0);
+	return inflight;
 }
 
 /* Cleanup page_pool state from page */
@@ -216,6 +211,7 @@ static void __page_pool_clean_page(struct page_pool *pool,
 				   struct page *page)
 {
 	dma_addr_t dma;
+	int count;
 
 	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
 		goto skip_dma_unmap;
@@ -227,9 +223,11 @@ static void __page_pool_clean_page(struct page_pool *pool,
 			     DMA_ATTR_SKIP_CPU_SYNC);
 	page->dma_addr = 0;
 skip_dma_unmap:
-	atomic_inc(&pool->pages_state_release_cnt);
-	trace_page_pool_state_release(pool, page,
-			      atomic_read(&pool->pages_state_release_cnt));
+	/* This may be the last page returned, releasing the pool, so
+	 * it is not safe to reference pool afterwards.
+	 */
+	count = atomic_inc_return(&pool->pages_state_release_cnt);
+	trace_page_pool_state_release(pool, page, count);
 }
 
 /* unmap the page and clean our state */
@@ -338,31 +336,10 @@ static void __page_pool_empty_ring(struct page_pool *pool)
 	}
 }
 
-static void __warn_in_flight(struct page_pool *pool)
+static void page_pool_free(struct page_pool *pool)
 {
-	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
-	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
-	s32 distance;
-
-	distance = _distance(hold_cnt, release_cnt);
-
-	/* Drivers should fix this, but only problematic when DMA is used */
-	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
-	     distance, hold_cnt, release_cnt);
-}
-
-void __page_pool_free(struct page_pool *pool)
-{
-	/* Only last user actually free/release resources */
-	if (!page_pool_put(pool))
-		return;
-
-	WARN(pool->alloc.count, "API usage violation");
-	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
-
-	/* Can happen due to forced shutdown */
-	if (!__page_pool_safe_to_destroy(pool))
-		__warn_in_flight(pool);
+	if (pool->disconnect)
+		pool->disconnect(pool);
 
 	ptr_ring_cleanup(&pool->ring, NULL);
 
@@ -371,12 +348,8 @@ void __page_pool_free(struct page_pool *pool)
 
 	kfree(pool);
 }
-EXPORT_SYMBOL(__page_pool_free);
 
-/* Request to shutdown: release pages cached by page_pool, and check
- * for in-flight pages
- */
-bool __page_pool_request_shutdown(struct page_pool *pool)
+static void page_pool_scrub(struct page_pool *pool)
 {
 	struct page *page;
 
@@ -393,7 +366,64 @@ bool __page_pool_request_shutdown(struct page_pool *pool)
 	 * be in-flight.
 	 */
 	__page_pool_empty_ring(pool);
-
-	return __page_pool_safe_to_destroy(pool);
 }
-EXPORT_SYMBOL(__page_pool_request_shutdown);
+
+static int page_pool_release(struct page_pool *pool)
+{
+	int inflight;
+
+	page_pool_scrub(pool);
+	inflight = page_pool_inflight(pool);
+	if (!inflight)
+		page_pool_free(pool);
+
+	return inflight;
+}
+
+static void page_pool_release_retry(struct work_struct *wq)
+{
+	struct delayed_work *dwq = to_delayed_work(wq);
+	struct page_pool *pool = container_of(dwq, typeof(*pool), release_dw);
+	int inflight;
+
+	inflight = page_pool_release(pool);
+	if (!inflight)
+		return;
+
+	/* Periodic warning */
+	if (time_after_eq(jiffies, pool->defer_warn)) {
+		int sec = (s32)((u32)jiffies - (u32)pool->defer_start) / HZ;
+
+		pr_warn("%s() stalled pool shutdown %d inflight %d sec\n",
+			__func__, inflight, sec);
+		pool->defer_warn = jiffies + DEFER_WARN_INTERVAL;
+	}
+
+	/* Still not ready to be disconnected, retry later */
+	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
+}
+
+void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *))
+{
+	refcount_inc(&pool->user_cnt);
+	pool->disconnect = disconnect;
+}
+
+void page_pool_destroy(struct page_pool *pool)
+{
+	if (!pool)
+		return;
+
+	if (!page_pool_put(pool))
+		return;
+
+	if (!page_pool_release(pool))
+		return;
+
+	pool->defer_start = jiffies;
+	pool->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
+
+	INIT_DELAYED_WORK(&pool->release_dw, page_pool_release_retry);
+	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
+}
+EXPORT_SYMBOL(page_pool_destroy);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 20781ad5f9c3..8e405abaf05a 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -70,10 +70,6 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
 
 	xa = container_of(rcu, struct xdp_mem_allocator, rcu);
 
-	/* Allocator have indicated safe to remove before this is called */
-	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
-		page_pool_free(xa->page_pool);
-
 	/* Allow this ID to be reused */
 	ida_simple_remove(&mem_id_pool, xa->mem.id);
 
@@ -85,10 +81,41 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
 	kfree(xa);
 }
 
-static bool __mem_id_disconnect(int id, bool force)
+static void mem_xa_remove(struct xdp_mem_allocator *xa)
+{
+	trace_mem_disconnect(xa);
+
+	mutex_lock(&mem_id_lock);
+
+	if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
+		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
+
+	mutex_unlock(&mem_id_lock);
+}
+
+static void mem_allocator_disconnect(void *allocator)
+{
+	struct xdp_mem_allocator *xa;
+	struct rhashtable_iter iter;
+
+	rhashtable_walk_enter(mem_id_ht, &iter);
+	do {
+		rhashtable_walk_start(&iter);
+
+		while ((xa = rhashtable_walk_next(&iter)) && !IS_ERR(xa)) {
+			if (xa->allocator == allocator)
+				mem_xa_remove(xa);
+		}
+
+		rhashtable_walk_stop(&iter);
+
+	} while (xa == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
+}
+
+static void mem_id_disconnect(int id)
 {
 	struct xdp_mem_allocator *xa;
-	bool safe_to_remove = true;
 
 	mutex_lock(&mem_id_lock);
 
@@ -96,51 +123,15 @@ static bool __mem_id_disconnect(int id, bool force)
 	if (!xa) {
 		mutex_unlock(&mem_id_lock);
 		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
-		return true;
+		return;
 	}
-	xa->disconnect_cnt++;
 
-	/* Detects in-flight packet-pages for page_pool */
-	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
-		safe_to_remove = page_pool_request_shutdown(xa->page_pool);
+	trace_mem_disconnect(xa);
 
-	trace_mem_disconnect(xa, safe_to_remove, force);
-
-	if ((safe_to_remove || force) &&
-	    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
+	if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
 		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
 
 	mutex_unlock(&mem_id_lock);
-	return (safe_to_remove|force);
-}
-
-#define DEFER_TIME (msecs_to_jiffies(1000))
-#define DEFER_WARN_INTERVAL (30 * HZ)
-#define DEFER_MAX_RETRIES 120
-
-static void mem_id_disconnect_defer_retry(struct work_struct *wq)
-{
-	struct delayed_work *dwq = to_delayed_work(wq);
-	struct xdp_mem_allocator *xa = container_of(dwq, typeof(*xa), defer_wq);
-	bool force = false;
-
-	if (xa->disconnect_cnt > DEFER_MAX_RETRIES)
-		force = true;
-
-	if (__mem_id_disconnect(xa->mem.id, force))
-		return;
-
-	/* Periodic warning */
-	if (time_after_eq(jiffies, xa->defer_warn)) {
-		int sec = (s32)((u32)jiffies - (u32)xa->defer_start) / HZ;
-
-		pr_warn("%s() stalled mem.id=%u shutdown %d attempts %d sec\n",
-			__func__, xa->mem.id, xa->disconnect_cnt, sec);
-		xa->defer_warn = jiffies + DEFER_WARN_INTERVAL;
-	}
-
-	/* Still not ready to be disconnected, retry later */
-	schedule_delayed_work(&xa->defer_wq, DEFER_TIME);
 }
 
 void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
@@ -153,38 +144,21 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 		return;
 	}
 
-	if (xdp_rxq->mem.type != MEM_TYPE_PAGE_POOL &&
-	    xdp_rxq->mem.type != MEM_TYPE_ZERO_COPY) {
-		return;
-	}
-
 	if (id == 0)
 		return;
 
-	if (__mem_id_disconnect(id, false))
-		return;
+	if (xdp_rxq->mem.type == MEM_TYPE_ZERO_COPY)
+		return mem_id_disconnect(id);
 
-	/* Could not disconnect, defer new disconnect attempt to later */
-	mutex_lock(&mem_id_lock);
-
-	xa = rhashtable_lookup_fast(mem_id_ht, &id, mem_id_rht_params);
-	if (!xa) {
-		mutex_unlock(&mem_id_lock);
-		return;
+	if (xdp_rxq->mem.type == MEM_TYPE_PAGE_POOL) {
+		rcu_read_lock();
+		xa = rhashtable_lookup(mem_id_ht, &id, mem_id_rht_params);
+		page_pool_destroy(xa->page_pool);
+		rcu_read_unlock();
 	}
-	xa->defer_start = jiffies;
-	xa->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
-
-	INIT_DELAYED_WORK(&xa->defer_wq, mem_id_disconnect_defer_retry);
-	mutex_unlock(&mem_id_lock);
-	schedule_delayed_work(&xa->defer_wq, DEFER_TIME);
 }
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg_mem_model);
 
-/* This unregister operation will also cleanup and destroy the
- * allocator. The page_pool_free() operation is first called when it's
- * safe to remove, possibly deferred to a workqueue.
- */
 void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
 {
 	/* Simplify driver cleanup code paths, allow unreg "unused" */
@@ -371,7 +345,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	}
 
 	if (type == MEM_TYPE_PAGE_POOL)
-		page_pool_get(xdp_alloc->page_pool);
+		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect);
 
 	mutex_unlock(&mem_id_lock);
 
@@ -402,15 +376,8 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 		page = virt_to_head_page(data);
-		if (likely(xa)) {
-			napi_direct &= !xdp_return_frame_no_direct();
-			page_pool_put_page(xa->page_pool, page, napi_direct);
-		} else {
-			/* Hopefully stack show who to blame for late return */
-			WARN_ONCE(1, "page_pool gone mem.id=%d", mem->id);
-			trace_mem_return_failed(mem, page);
-			put_page(page);
-		}
+		napi_direct &= !xdp_return_frame_no_direct();
+		page_pool_put_page(xa->page_pool, page, napi_direct);
 		rcu_read_unlock();
 		break;
 	case MEM_TYPE_PAGE_SHARED:
-- 
2.17.1

