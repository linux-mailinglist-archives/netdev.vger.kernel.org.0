Return-Path: <netdev+bounces-4712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D1370DFBB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28F4728128B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444091F947;
	Tue, 23 May 2023 14:53:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2C61F19D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:53:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FB6CD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684853584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gENW+j3SfpOMmo8IUY3lvawdOv8AtpaP6smSmxRWsyg=;
	b=H2q41wT5pta5ggFfs4HfWaedW9dPe0YsMLj2GPdD1QsWtgLvWpkyPyRBs4en4c9I0XbOIJ
	BLPOamZP+QaUzfLx5m8F3+IoIhFAvvqFen603tjEe8if/TxQqAWUgGgn0IEjOz2GuWg6+u
	UJOyWvMzzRwiiGTJxf9CDtjD0S4Bygc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-Ity1FgVMOoCVJ3LCzI8CUg-1; Tue, 23 May 2023 10:53:00 -0400
X-MC-Unique: Ity1FgVMOoCVJ3LCzI8CUg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0EDA1C0A58B;
	Tue, 23 May 2023 14:52:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.23])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 511F5492B0A;
	Tue, 23 May 2023 14:52:59 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
	by firesoul.localdomain (Postfix) with ESMTP id 5DC4D307372E8;
	Tue, 23 May 2023 16:52:58 +0200 (CEST)
Subject: [PATCH RFC net-next/mm V4 2/2] page_pool: Remove workqueue in new
 shutdown scheme
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>, netdev@vger.kernel.org,
 Eric Dumazet <eric.dumazet@gmail.com>, linux-mm@kvack.org,
 Mel Gorman <mgorman@techsingularity.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, lorenzo@kernel.org,
 =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
 linyunsheng@huawei.com, bpf@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 willy@infradead.org
Date: Tue, 23 May 2023 16:52:58 +0200
Message-ID: <168485357834.2849279.8073426325295894331.stgit@firesoul>
In-Reply-To: <168485351546.2849279.13771638045665633339.stgit@firesoul>
References: <168485351546.2849279.13771638045665633339.stgit@firesoul>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This removes the workqueue scheme that periodically tests when
inflight reach zero such that page_pool memory can be freed.

This change adds code to fast-path free checking for a shutdown flags
bit after returning PP pages.

Performance is very important for PP, as the fast path is used for
XDP_DROP use-cases where NIC drivers recycle PP pages directly into PP
alloc cache.

This patch (since V3) shows zero impact on this fast path. Micro
benchmarked with [1] on Intel CPU E5-1650 @3.60GHz. The slight code
reorg of likely() are deliberate.

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/page_pool.h |   10 ++-
 net/core/page_pool.c    |  138 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 104 insertions(+), 44 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index c8ec2f34722b..19396e05f12d 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -50,6 +50,9 @@
 				 PP_FLAG_DMA_SYNC_DEV |\
 				 PP_FLAG_PAGE_FRAG)
 
+/* Internal flag: PP in shutdown phase, waiting for inflight pages */
+#define PP_FLAG_SHUTDOWN	BIT(8)
+
 /*
  * Fast allocation side cache array/stack
  *
@@ -151,11 +154,6 @@ static inline u64 *page_pool_ethtool_stats_get(u64 *data, void *stats)
 struct page_pool {
 	struct page_pool_params p;
 
-	struct delayed_work release_dw;
-	void (*disconnect)(void *);
-	unsigned long defer_start;
-	unsigned long defer_warn;
-
 	u32 pages_state_hold_cnt;
 	unsigned int frag_offset;
 	struct page *frag_page;
@@ -165,6 +163,7 @@ struct page_pool {
 	/* these stats are incremented while in softirq context */
 	struct page_pool_alloc_stats alloc_stats;
 #endif
+	void (*disconnect)(void *);
 	u32 xdp_mem_id;
 
 	/*
@@ -208,6 +207,7 @@ struct page_pool {
 	refcount_t user_cnt;
 
 	u64 destroy_cnt;
+	struct rcu_head rcu;
 };
 
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e212e9d7edcb..213349148a48 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -23,9 +23,6 @@
 
 #include <trace/events/page_pool.h>
 
-#define DEFER_TIME (msecs_to_jiffies(1000))
-#define DEFER_WARN_INTERVAL (60 * HZ)
-
 #define BIAS_MAX	LONG_MAX
 
 #ifdef CONFIG_PAGE_POOL_STATS
@@ -380,6 +377,10 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	struct page *page;
 	int i, nr_pages;
 
+	/* API usage BUG: PP in shutdown phase, cannot alloc new pages */
+	if (WARN_ON(pool->p.flags & PP_FLAG_SHUTDOWN))
+		return NULL;
+
 	/* Don't support bulk alloc for high-order pages */
 	if (unlikely(pp_order))
 		return __page_pool_alloc_page_order(pool, gfp);
@@ -450,9 +451,8 @@ EXPORT_SYMBOL(page_pool_alloc_pages);
  */
 #define _distance(a, b)	(s32)((a) - (b))
 
-static s32 page_pool_inflight(struct page_pool *pool)
+static s32 __page_pool_inflight(struct page_pool *pool, u32 release_cnt)
 {
-	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
 	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
 	s32 inflight;
 
@@ -464,6 +464,14 @@ static s32 page_pool_inflight(struct page_pool *pool)
 	return inflight;
 }
 
+static s32 page_pool_inflight(struct page_pool *pool)
+{
+	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
+	return __page_pool_inflight(pool, release_cnt);
+}
+
+static int page_pool_free_attempt(struct page_pool *pool, u32 release_cnt);
+
 /* Disconnects a page (from a page_pool).  API users can have a need
  * to disconnect a page (from a page_pool), to allow it to be used as
  * a regular page (that will eventually be returned to the normal
@@ -472,7 +480,7 @@ static s32 page_pool_inflight(struct page_pool *pool)
 void page_pool_release_page(struct page_pool *pool, struct page *page)
 {
 	dma_addr_t dma;
-	int count;
+	u32 release_cnt;
 
 	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
 		/* Always account for inflight pages, even if we didn't
@@ -490,11 +498,12 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 skip_dma_unmap:
 	page_pool_clear_pp_info(page);
 
-	/* This may be the last page returned, releasing the pool, so
-	 * it is not safe to reference pool afterwards.
-	 */
-	count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
-	trace_page_pool_state_release(pool, page, count);
+	release_cnt = atomic_inc_return(&pool->pages_state_release_cnt);
+	trace_page_pool_state_release(pool, page, release_cnt);
+
+	/* In shutdown phase, last page will free pool instance */
+	if (READ_ONCE(pool->p.flags) & PP_FLAG_SHUTDOWN)
+		page_pool_free_attempt(pool, release_cnt);
 }
 EXPORT_SYMBOL(page_pool_release_page);
 
@@ -535,7 +544,7 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 static bool page_pool_recycle_in_cache(struct page *page,
 				       struct page_pool *pool)
 {
-	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE)) {
+	if (pool->alloc.count == PP_ALLOC_CACHE_SIZE) {
 		recycle_stat_inc(pool, cache_full);
 		return false;
 	}
@@ -546,6 +555,8 @@ static bool page_pool_recycle_in_cache(struct page *page,
 	return true;
 }
 
+static void page_pool_empty_ring(struct page_pool *pool);
+
 /* If the page refcnt == 1, this will try to recycle the page.
  * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
  * the configured size min(dma_sync_size, pool->max_len).
@@ -572,7 +583,8 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 			page_pool_dma_sync_for_device(pool, page,
 						      dma_sync_size);
 
-		if (allow_direct && in_softirq() &&
+		/* During PP shutdown, no direct recycle must occur */
+		if (likely(allow_direct && in_softirq()) &&
 		    page_pool_recycle_in_cache(page, pool))
 			return NULL;
 
@@ -609,6 +621,8 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
 		recycle_stat_inc(pool, ring_full);
 		page_pool_return_page(pool, page);
 	}
+	if (page && pool->p.flags & PP_FLAG_SHUTDOWN)
+		page_pool_empty_ring(pool);
 }
 EXPORT_SYMBOL(page_pool_put_defragged_page);
 
@@ -646,6 +660,9 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 	recycle_stat_add(pool, ring, i);
 	page_pool_ring_unlock(pool);
 
+	if (pool->p.flags & PP_FLAG_SHUTDOWN)
+		page_pool_empty_ring(pool);
+
 	/* Hopefully all pages was return into ptr_ring */
 	if (likely(i == bulk_len))
 		return;
@@ -737,12 +754,18 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
 }
 EXPORT_SYMBOL(page_pool_alloc_frag);
 
+noinline
 static void page_pool_empty_ring(struct page_pool *pool)
 {
-	struct page *page;
+	struct page *page, *next;
+
+	next = ptr_ring_consume_bh(&pool->ring);
 
 	/* Empty recycle ring */
-	while ((page = ptr_ring_consume_bh(&pool->ring))) {
+	while (next) {
+		page = next;
+		next = ptr_ring_consume_bh(&pool->ring);
+
 		/* Verify the refcnt invariant of cached pages */
 		if (!(page_ref_count(page) == 1))
 			pr_crit("%s() page_pool refcnt %d violation\n",
@@ -768,6 +791,14 @@ static void page_pool_free(struct page_pool *pool)
 	kfree(pool);
 }
 
+static void page_pool_free_rcu(struct rcu_head *rcu)
+{
+	struct page_pool *pool;
+
+	pool = container_of(rcu, struct page_pool, rcu);
+	page_pool_free(pool);
+}
+
 static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 {
 	struct page *page;
@@ -796,39 +827,30 @@ static void page_pool_scrub(struct page_pool *pool)
 	page_pool_empty_ring(pool);
 }
 
-static int page_pool_release(struct page_pool *pool)
+noinline
+static int page_pool_free_attempt(struct page_pool *pool, u32 release_cnt)
 {
 	int inflight;
 
-	page_pool_scrub(pool);
-	inflight = page_pool_inflight(pool);
+	rcu_read_lock();
+	inflight = __page_pool_inflight(pool, release_cnt);
+	rcu_read_unlock();
 	if (!inflight)
-		page_pool_free(pool);
+		call_rcu(&pool->rcu, page_pool_free_rcu);
 
 	return inflight;
 }
 
-static void page_pool_release_retry(struct work_struct *wq)
+static int page_pool_release(struct page_pool *pool)
 {
-	struct delayed_work *dwq = to_delayed_work(wq);
-	struct page_pool *pool = container_of(dwq, typeof(*pool), release_dw);
 	int inflight;
 
-	inflight = page_pool_release(pool);
+	page_pool_scrub(pool);
+	inflight = page_pool_inflight(pool);
 	if (!inflight)
-		return;
-
-	/* Periodic warning */
-	if (time_after_eq(jiffies, pool->defer_warn)) {
-		int sec = (s32)((u32)jiffies - (u32)pool->defer_start) / HZ;
-
-		pr_warn("%s() stalled pool shutdown %d inflight %d sec\n",
-			__func__, inflight, sec);
-		pool->defer_warn = jiffies + DEFER_WARN_INTERVAL;
-	}
+		page_pool_free(pool);
 
-	/* Still not ready to be disconnected, retry later */
-	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
+	return inflight;
 }
 
 void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
@@ -856,6 +878,10 @@ EXPORT_SYMBOL(page_pool_unlink_napi);
 
 void page_pool_destroy(struct page_pool *pool)
 {
+	unsigned int flags;
+	u32 release_cnt;
+	u32 hold_cnt;
+
 	if (!pool)
 		return;
 
@@ -868,11 +894,45 @@ void page_pool_destroy(struct page_pool *pool)
 	if (!page_pool_release(pool))
 		return;
 
-	pool->defer_start = jiffies;
-	pool->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
+	/* PP have pages inflight, thus cannot immediately release memory.
+	 * Enter into shutdown phase, depending on remaining in-flight PP
+	 * pages to trigger shutdown process (on concurrent CPUs) and last
+	 * page will free pool instance.
+	 *
+	 * There exist two race conditions here, we need to take into
+	 * account in the following code.
+	 *
+	 * 1. Before setting PP_FLAG_SHUTDOWN another CPU released the last
+	 *    pages into the ptr_ring.  Thus, it missed triggering shutdown
+	 *    process, which can then be stalled forever.
+	 *
+	 * 2. After setting PP_FLAG_SHUTDOWN another CPU released the last
+	 *    page, which triggered shutdown process and freed pool
+	 *    instance. Thus, its not safe to dereference *pool afterwards.
+	 *
+	 * Handling races by holding a fake in-flight count, via artificially
+	 * bumping pages_state_hold_cnt, which assures pool isn't freed under
+	 * us.  Use RCU Grace-Periods to guarantee concurrent CPUs will
+	 * transition safely into the shutdown phase.
+	 *
+	 * After safely transition into this state the races are resolved.  For
+	 * race(1) its safe to recheck and empty ptr_ring (it will not free
+	 * pool). Race(2) cannot happen, and we can release fake in-flight count
+	 * as last step.
+	 */
+	hold_cnt = READ_ONCE(pool->pages_state_hold_cnt) + 1;
+	WRITE_ONCE(pool->pages_state_hold_cnt, hold_cnt);
+	synchronize_rcu();
+
+	flags = READ_ONCE(pool->p.flags) | PP_FLAG_SHUTDOWN;
+	WRITE_ONCE(pool->p.flags, flags);
+	synchronize_rcu();
+
+	/* Concurrent CPUs could have returned last pages into ptr_ring */
+	page_pool_empty_ring(pool);
 
-	INIT_DELAYED_WORK(&pool->release_dw, page_pool_release_retry);
-	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
+	release_cnt = atomic_inc_return(&pool->pages_state_release_cnt);
+	page_pool_free_attempt(pool, release_cnt);
 }
 EXPORT_SYMBOL(page_pool_destroy);
 



