Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF51123AB0
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfLQXRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:17:48 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49259 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbfLQXRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:17:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576624666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6vRPlHz1BtYlsRl4iL0a42PQZIs+OZkdPOBgCK2qhEw=;
        b=P42pRDpfxnMKVL9xlVH9lSfFDNe3txlR2FUhl10qWjt1bYaSREysQzvImujcZTvAXykjDv
        RKmzZNgNcwmk2xsucwgNb7foITsJBEzAcM88nI9mf9Crmf71ps82t2m0lTMCmNVgbHodir
        6vUpZ2u0qwfvPLhmYaijOAr6k99nLVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-J8TN0XzFMPelNY6EPhZ_hw-1; Tue, 17 Dec 2019 18:17:43 -0500
X-MC-Unique: J8TN0XzFMPelNY6EPhZ_hw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 621418017DF;
        Tue, 17 Dec 2019 23:17:41 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-28.brq.redhat.com [10.40.200.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 606DD7C856;
        Tue, 17 Dec 2019 23:17:38 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1107830736C73;
        Wed, 18 Dec 2019 00:17:37 +0100 (CET)
Subject: [net-next v3 PATCH] page_pool: handle page recycle for NUMA_NO_NODE
 condition
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, lirongqing@baidu.com,
        linyunsheng@huawei.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, mhocko@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 18 Dec 2019 00:17:36 +0100
Message-ID: <157662465670.141017.5588210646574716982.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check in pool_page_reusable (page_to_nid(page) == pool->p.nid) is
not valid if page_pool was configured with pool->p.nid = NUMA_NO_NODE.

The goal of the NUMA changes in commit d5394610b1ba ("page_pool: Don't
recycle non-reusable pages"), were to have RX-pages that belongs to the
same NUMA node as the CPU processing RX-packet during softirq/NAPI. As
illustrated by the performance measurements.

This patch moves the NAPI checks out of fast-path, and at the same time
solves the NUMA_NO_NODE issue.

First realize that alloc_pages_node() with pool->p.nid = NUMA_NO_NODE
will lookup current CPU nid (Numa ID) via numa_mem_id(), which is used
as the the preferred nid.  It is only in rare situations, where
e.g. NUMA zone runs dry, that page gets doesn't get allocated from
preferred nid.  The page_pool API allows drivers to control the nid
themselves via controlling pool->p.nid.

This patch moves the NAPI check to when alloc cache is refilled, via
dequeuing/consuming pages from the ptr_ring. Thus, we can allow placing
pages from remote NUMA into the ptr_ring, as the dequeue/consume step
will check the NUMA node. All current drivers using page_pool will
alloc/refill RX-ring from same CPU running softirq/NAPI process.

Drivers that control the nid explicitly, also use page_pool_update_nid
when changing nid runtime.  To speed up transision to new nid the alloc
cache is now flushed on nid changes.  This force pages to come from
ptr_ring, which does the appropate nid check.

For the NUMA_NO_NODE case, when a NIC IRQ is moved to another NUMA
node, then ptr_ring will be emptied in 65 (PP_ALLOC_CACHE_REFILL+1)
chunks per allocation and allocation fall-through to the real
page-allocator with the new nid derived from numa_mem_id(). We accept
that transitioning the alloc cache doesn't happen immediately.

Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
Reported-by: Li RongQing <lirongqing@baidu.com>
Reported-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c |   64 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 15 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a6aefe989043..37316ea66937 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -96,19 +96,22 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
 }
 EXPORT_SYMBOL(page_pool_create);
 
+static void __page_pool_return_page(struct page_pool *pool, struct page *page);
+
 /* fast path */
 static struct page *__page_pool_get_cached(struct page_pool *pool)
 {
 	struct ptr_ring *r = &pool->ring;
+	struct page *first_page, *page;
 	bool refill = false;
-	struct page *page;
+	int i, curr_nid;
 
 	/* Test for safe-context, caller should provide this guarantee */
 	if (likely(in_serving_softirq())) {
 		if (likely(pool->alloc.count)) {
 			/* Fast-path */
-			page = pool->alloc.cache[--pool->alloc.count];
-			return page;
+			first_page = pool->alloc.cache[--pool->alloc.count];
+			return first_page;
 		}
 		refill = true;
 	}
@@ -117,17 +120,42 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	if (__ptr_ring_empty(r))
 		return NULL;
 
-	/* Slow-path: Get page from locked ring queue,
-	 * refill alloc array if requested.
+	/* Softirq guarantee CPU and thus NUMA node is stable. This,
+	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
 	 */
+	curr_nid = numa_mem_id();
+
+	/* Slower-path: Get pages from locked ring queue */
 	spin_lock(&r->consumer_lock);
-	page = __ptr_ring_consume(r);
-	if (refill)
-		pool->alloc.count = __ptr_ring_consume_batched(r,
-							pool->alloc.cache,
-							PP_ALLOC_CACHE_REFILL);
+	first_page = __ptr_ring_consume(r);
+
+	/* Fallback to page-allocator if NUMA node doesn't match */
+	if (first_page && unlikely(!(page_to_nid(first_page) == curr_nid))) {
+		__page_pool_return_page(pool, first_page);
+		first_page = NULL;
+	}
+
+	if (unlikely(!refill))
+		goto out;
+
+	/* Refill alloc array, but only if NUMA node match */
+	for (i = 0; i < PP_ALLOC_CACHE_REFILL; i++) {
+		page = __ptr_ring_consume(r);
+		if (unlikely(!page))
+			break;
+
+		if (likely(page_to_nid(page) == curr_nid)) {
+			pool->alloc.cache[pool->alloc.count++] = page;
+		} else {
+			/* Release page to page-allocator, assume
+			 * refcnt == 1 invariant of cached pages
+			 */
+			__page_pool_return_page(pool, page);
+		}
+	}
+out:
 	spin_unlock(&r->consumer_lock);
-	return page;
+	return first_page;
 }
 
 static void page_pool_dma_sync_for_device(struct page_pool *pool,
@@ -311,13 +339,10 @@ static bool __page_pool_recycle_direct(struct page *page,
 
 /* page is NOT reusable when:
  * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
- * 2) belongs to a different NUMA node than pool->p.nid.
- *
- * To update pool->p.nid users must call page_pool_update_nid.
  */
 static bool pool_page_reusable(struct page_pool *pool, struct page *page)
 {
-	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
+	return !page_is_pfmemalloc(page);
 }
 
 void __page_pool_put_page(struct page_pool *pool, struct page *page,
@@ -484,7 +509,16 @@ EXPORT_SYMBOL(page_pool_destroy);
 /* Caller must provide appropriate safe context, e.g. NAPI. */
 void page_pool_update_nid(struct page_pool *pool, int new_nid)
 {
+	struct page *page;
+
+	WARN_ON(!in_serving_softirq());
 	trace_page_pool_update_nid(pool, new_nid);
 	pool->p.nid = new_nid;
+
+	/* Flush pool alloc cache, as refill will check NUMA node */
+	while (pool->alloc.count) {
+		page = pool->alloc.cache[--pool->alloc.count];
+		__page_pool_return_page(pool, page);
+	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);


