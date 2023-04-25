Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678426EE674
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 19:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbjDYRQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 13:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbjDYRQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 13:16:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CC712CB2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 10:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682442944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=670hg1AZvr7qtlDRF5iLq0fUp54srb+aqDOh/giGrsI=;
        b=TouZh2XZcgVvIKRMveQki5mKayejxweLeitm53c2uI8TNe4xTMN6b3alXAo7N6YyS5uqhJ
        lvLYkVU6NIUDp5emYfGR3ICdFb/AViP/dI4A09cGF3U3HNy9zLQrFu2hkrZY973UqxcJMx
        SH5Z8xMqKE/u1u++k4w5ewdF+u/zolE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-A1AxtTPcPWO5xQ1mDE96BA-1; Tue, 25 Apr 2023 13:15:42 -0400
X-MC-Unique: A1AxtTPcPWO5xQ1mDE96BA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D24351C0515E;
        Tue, 25 Apr 2023 17:15:39 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E6312166B3A;
        Tue, 25 Apr 2023 17:15:39 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id C9D96307372E8;
        Tue, 25 Apr 2023 19:15:38 +0200 (CEST)
Subject: [PATCH RFC net-next/mm V1 1/3] page_pool: Remove workqueue in new
 shutdown scheme
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, lorenzo@kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linyunsheng@huawei.com, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Date:   Tue, 25 Apr 2023 19:15:38 +0200
Message-ID: <168244293875.1741095.10502498932946558516.stgit@firesoul>
In-Reply-To: <168244288038.1741095.1092368365531131826.stgit@firesoul>
References: <168244288038.1741095.1092368365531131826.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the workqueue scheme that periodically tests when
inflight reach zero such that page_pool memory can be freed.

This change adds code to fast-path free checking for a shutdown flags
bit after returning PP pages.

Performance is very important for PP, as the fast path is used for
XDP_DROP use-cases where NIC drivers recycle PP pages directly into PP
alloc cache.

The goal were that this code change should have zero impact on this
fast-path. The slight code reorg of likely() are deliberate. Micro
benchmarking done via kernel module[1] on x86_64, shows this code
change only cost a single instruction extra (approx 0.3 nanosec on CPU
E5-1650 @3.60GHz).

It is possible to make this code zero impact via static_key, but that
change is split out into the next patch, as we are unsure if it is
worth the complexity.

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/page_pool.h |    9 +++----
 net/core/page_pool.c    |   59 +++++++++++++++++++----------------------------
 2 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index c8ec2f34722b..a71c0f2695b0 100644
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
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e212e9d7edcb..ce7e8dda6403 100644
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
@@ -489,10 +490,6 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 	page_pool_set_dma_addr(page, 0);
 skip_dma_unmap:
 	page_pool_clear_pp_info(page);
-
-	/* This may be the last page returned, releasing the pool, so
-	 * it is not safe to reference pool afterwards.
-	 */
 	count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
 	trace_page_pool_state_release(pool, page, count);
 }
@@ -535,7 +532,7 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 static bool page_pool_recycle_in_cache(struct page *page,
 				       struct page_pool *pool)
 {
-	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE)) {
+	if (pool->alloc.count == PP_ALLOC_CACHE_SIZE) {
 		recycle_stat_inc(pool, cache_full);
 		return false;
 	}
@@ -546,6 +543,8 @@ static bool page_pool_recycle_in_cache(struct page *page,
 	return true;
 }
 
+static void page_pool_shutdown_attempt(struct page_pool *pool);
+
 /* If the page refcnt == 1, this will try to recycle the page.
  * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
  * the configured size min(dma_sync_size, pool->max_len).
@@ -572,7 +571,8 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 			page_pool_dma_sync_for_device(pool, page,
 						      dma_sync_size);
 
-		if (allow_direct && in_softirq() &&
+		/* During PP shutdown, no direct recycle must occur */
+		if (likely(allow_direct && in_softirq()) &&
 		    page_pool_recycle_in_cache(page, pool))
 			return NULL;
 
@@ -609,6 +609,8 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
 		recycle_stat_inc(pool, ring_full);
 		page_pool_return_page(pool, page);
 	}
+	if (pool->p.flags & PP_FLAG_SHUTDOWN)
+		page_pool_shutdown_attempt(pool);
 }
 EXPORT_SYMBOL(page_pool_put_defragged_page);
 
@@ -648,13 +650,17 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 
 	/* Hopefully all pages was return into ptr_ring */
 	if (likely(i == bulk_len))
-		return;
+		goto out;
 
 	/* ptr_ring cache full, free remaining pages outside producer lock
 	 * since put_page() with refcnt == 1 can be an expensive operation
 	 */
 	for (; i < bulk_len; i++)
 		page_pool_return_page(pool, data[i]);
+
+out:
+	if (pool->p.flags & PP_FLAG_SHUTDOWN)
+		page_pool_shutdown_attempt(pool);
 }
 EXPORT_SYMBOL(page_pool_put_page_bulk);
 
@@ -808,27 +814,10 @@ static int page_pool_release(struct page_pool *pool)
 	return inflight;
 }
 
-static void page_pool_release_retry(struct work_struct *wq)
+noinline
+static void page_pool_shutdown_attempt(struct page_pool *pool)
 {
-	struct delayed_work *dwq = to_delayed_work(wq);
-	struct page_pool *pool = container_of(dwq, typeof(*pool), release_dw);
-	int inflight;
-
-	inflight = page_pool_release(pool);
-	if (!inflight)
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
-
-	/* Still not ready to be disconnected, retry later */
-	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
+	page_pool_release(pool);
 }
 
 void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
@@ -868,11 +857,11 @@ void page_pool_destroy(struct page_pool *pool)
 	if (!page_pool_release(pool))
 		return;
 
-	pool->defer_start = jiffies;
-	pool->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
-
-	INIT_DELAYED_WORK(&pool->release_dw, page_pool_release_retry);
-	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
+	/* PP have pages inflight, thus cannot immediately release memory.
+	 * Enter into shutdown phase, and retry release to handle races.
+	 */
+	pool->p.flags |= PP_FLAG_SHUTDOWN;
+	page_pool_shutdown_attempt(pool);
 }
 EXPORT_SYMBOL(page_pool_destroy);
 


