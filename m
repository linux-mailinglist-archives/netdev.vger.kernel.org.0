Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9586126479
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfLSOUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:20:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60843 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726695AbfLSOUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 09:20:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576765243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o8w3RWEy911G0WmjBLZTINd5bgSpZvCXDWcEwYe3mVE=;
        b=fuKR1pjdEfXnTw2EjeDT613Q86YdOv5ESxBRZbALLhiPK69R1HNUX8c0f/eLAUc8Rz4n5a
        VwQq1CtOokLsiyCOy/oZ2QLlnrwLDAsnN+KEWP0/ThkEAsK+1Mw0RB3zqCDNmbFr6Xm1yI
        Dy50nsHvl8z4uv+SWDH70N0HVUllSaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-tXOr6pyjMQCFlVOxZbmoWw-1; Thu, 19 Dec 2019 09:20:40 -0500
X-MC-Unique: tXOr6pyjMQCFlVOxZbmoWw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 612ED1005502;
        Thu, 19 Dec 2019 14:20:38 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-28.brq.redhat.com [10.40.200.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C13017D934;
        Thu, 19 Dec 2019 14:20:33 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1E96A30736C73;
        Thu, 19 Dec 2019 15:20:32 +0100 (CET)
Subject: [net-next v5 PATCH] page_pool: handle page recycle for NUMA_NO_NODE
 condition
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, lirongqing@baidu.com,
        linyunsheng@huawei.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, mhocko@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 19 Dec 2019 15:20:32 +0100
Message-ID: <157676523108.200893.4571988797174399927.stgit@firesoul>
In-Reply-To: <20191218084437.6db92d32@carbon>
References: <20191218084437.6db92d32@carbon>
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
node, we accept that transitioning the alloc cache doesn't happen
immediately. The preferred nid change runtime via consulting
numa_mem_id() based on the CPU processing RX-packets.

Notice, to avoid stressing the page buddy allocator and avoid doing too
much work under softirq with preempt disabled, the NUMA check at
ptr_ring dequeue will break the refill cycle, when detecting a NUMA
mismatch. This will cause a slower transition, but its done on purpose.

Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
Reported-by: Li RongQing <lirongqing@baidu.com>
Reported-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c |   80 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 19 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a6aefe989043..748f0d36f4be 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -96,10 +96,60 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
 }
 EXPORT_SYMBOL(page_pool_create);
 
+static void __page_pool_return_page(struct page_pool *pool, struct page *page);
+
+noinline
+static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
+						 bool refill)
+{
+	struct ptr_ring *r = &pool->ring;
+	struct page *page;
+	int pref_nid; /* preferred NUMA node */
+
+	/* Quicker fallback, avoid locks when ring is empty */
+	if (__ptr_ring_empty(r))
+		return NULL;
+
+	/* Softirq guarantee CPU and thus NUMA node is stable. This,
+	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
+	 */
+	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;
+
+	/* Slower-path: Get pages from locked ring queue */
+	spin_lock(&r->consumer_lock);
+
+	/* Refill alloc array, but only if NUMA match */
+	do {
+		page = __ptr_ring_consume(r);
+		if (unlikely(!page))
+			break;
+
+		if (likely(page_to_nid(page) == pref_nid)) {
+			pool->alloc.cache[pool->alloc.count++] = page;
+		} else {
+			/* NUMA mismatch;
+			 * (1) release 1 page to page-allocator and
+			 * (2) break out to fallthough to alloc_pages_node.
+			 * This limit stress on page buddy alloactor.
+			 */
+			__page_pool_return_page(pool, page);
+			page = NULL;
+			break;
+		}
+	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL &&
+		 refill);
+
+	/* Return last page */
+	if (likely(pool->alloc.count > 0))
+		page = pool->alloc.cache[--pool->alloc.count];
+
+	spin_unlock(&r->consumer_lock);
+	return page;
+}
+
 /* fast path */
 static struct page *__page_pool_get_cached(struct page_pool *pool)
 {
-	struct ptr_ring *r = &pool->ring;
 	bool refill = false;
 	struct page *page;
 
@@ -113,20 +163,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 		refill = true;
 	}
 
-	/* Quicker fallback, avoid locks when ring is empty */
-	if (__ptr_ring_empty(r))
-		return NULL;
-
-	/* Slow-path: Get page from locked ring queue,
-	 * refill alloc array if requested.
-	 */
-	spin_lock(&r->consumer_lock);
-	page = __ptr_ring_consume(r);
-	if (refill)
-		pool->alloc.count = __ptr_ring_consume_batched(r,
-							pool->alloc.cache,
-							PP_ALLOC_CACHE_REFILL);
-	spin_unlock(&r->consumer_lock);
+	page = page_pool_refill_alloc_cache(pool, refill);
 	return page;
 }
 
@@ -311,13 +348,10 @@ static bool __page_pool_recycle_direct(struct page *page,
 
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
@@ -484,7 +518,15 @@ EXPORT_SYMBOL(page_pool_destroy);
 /* Caller must provide appropriate safe context, e.g. NAPI. */
 void page_pool_update_nid(struct page_pool *pool, int new_nid)
 {
+	struct page *page;
+
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


