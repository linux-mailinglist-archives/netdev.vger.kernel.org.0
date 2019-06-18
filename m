Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE16D4A1A2
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbfFRNF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:05:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbfFRNF4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:05:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A5963092667;
        Tue, 18 Jun 2019 13:05:56 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D53E85F58C;
        Tue, 18 Jun 2019 13:05:53 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 0AD89306665E6;
        Tue, 18 Jun 2019 15:05:53 +0200 (CEST)
Subject: [PATCH net-next v2 09/12] xdp: force mem allocator removal and
 periodic warning
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Tue, 18 Jun 2019 15:05:53 +0200
Message-ID: <156086315298.27760.5679537697366392825.stgit@firesoul>
In-Reply-To: <156086304827.27760.11339786046465638081.stgit@firesoul>
References: <156086304827.27760.11339786046465638081.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 18 Jun 2019 13:05:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bugs exists or are introduced later e.g. by drivers misusing the API,
then we want to warn about the issue, such that developer notice. This patch
will generate a bit of noise in form of periodic pr_warn every 30 seconds.

It is not nice to have this stall warning running forever. Thus, this patch
will (after 120 attempts) force disconnect the mem id (from the rhashtable)
and free the page_pool object. This will cause fallback to the put_page() as
before, which only potentially leak DMA-mappings, if objects are really
stuck for this long. In that unlikely case, a WARN_ONCE should show us the
call stack.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c |   18 +++++++++++++++++-
 net/core/xdp.c       |   37 +++++++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 8679e24fd665..42c3b0a5a259 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -330,11 +330,27 @@ static void __page_pool_empty_ring(struct page_pool *pool)
 	}
 }
 
+static void __warn_in_flight(struct page_pool *pool)
+{
+	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
+	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
+	s32 distance;
+
+	distance = _distance(hold_cnt, release_cnt);
+
+	/* Drivers should fix this, but only problematic when DMA is used */
+	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
+	     distance, hold_cnt, release_cnt);
+}
+
 void __page_pool_free(struct page_pool *pool)
 {
 	WARN(pool->alloc.count, "API usage violation");
 	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
-	WARN(!__page_pool_safe_to_destroy(pool), "still in-flight pages");
+
+	/* Can happen due to forced shutdown */
+	if (!__page_pool_safe_to_destroy(pool))
+		__warn_in_flight(pool);
 
 	ptr_ring_cleanup(&pool->ring, NULL);
 	kfree(pool);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 2b7bad227030..53bce4fa776a 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -39,6 +39,9 @@ struct xdp_mem_allocator {
 	struct rhash_head node;
 	struct rcu_head rcu;
 	struct delayed_work defer_wq;
+	unsigned long defer_start;
+	unsigned long defer_warn;
+	int disconnect_cnt;
 };
 
 static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
@@ -95,7 +98,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
 	kfree(xa);
 }
 
-bool __mem_id_disconnect(int id)
+bool __mem_id_disconnect(int id, bool force)
 {
 	struct xdp_mem_allocator *xa;
 	bool safe_to_remove = true;
@@ -108,29 +111,47 @@ bool __mem_id_disconnect(int id)
 		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
 		return true;
 	}
+	xa->disconnect_cnt++;
 
 	/* Detects in-flight packet-pages for page_pool */
 	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
 		safe_to_remove = page_pool_request_shutdown(xa->page_pool);
 
-	if (safe_to_remove &&
+	/* TODO: Tracepoint will be added here in next-patch */
+
+	if ((safe_to_remove || force) &&
 	    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
 		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
 
 	mutex_unlock(&mem_id_lock);
-	return safe_to_remove;
+	return (safe_to_remove|force);
 }
 
 #define DEFER_TIME (msecs_to_jiffies(1000))
+#define DEFER_WARN_INTERVAL (30 * HZ)
+#define DEFER_MAX_RETRIES 120
 
 static void mem_id_disconnect_defer_retry(struct work_struct *wq)
 {
 	struct delayed_work *dwq = to_delayed_work(wq);
 	struct xdp_mem_allocator *xa = container_of(dwq, typeof(*xa), defer_wq);
+	bool force = false;
+
+	if (xa->disconnect_cnt > DEFER_MAX_RETRIES)
+		force = true;
 
-	if (__mem_id_disconnect(xa->mem.id))
+	if (__mem_id_disconnect(xa->mem.id, force))
 		return;
 
+	/* Periodic warning */
+	if (time_after_eq(jiffies, xa->defer_warn)) {
+		int sec = (s32)((u32)jiffies - (u32)xa->defer_start) / HZ;
+
+		pr_warn("%s() stalled mem.id=%u shutdown %d attempts %d sec\n",
+			__func__, xa->mem.id, xa->disconnect_cnt, sec);
+		xa->defer_warn = jiffies + DEFER_WARN_INTERVAL;
+	}
+
 	/* Still not ready to be disconnected, retry later */
 	schedule_delayed_work(&xa->defer_wq, DEFER_TIME);
 }
@@ -153,7 +174,7 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 	if (id == 0)
 		return;
 
-	if (__mem_id_disconnect(id))
+	if (__mem_id_disconnect(id, false))
 		return;
 
 	/* Could not disconnect, defer new disconnect attempt to later */
@@ -164,6 +185,8 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 		mutex_unlock(&mem_id_lock);
 		return;
 	}
+	xa->defer_start = jiffies;
+	xa->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
 
 	INIT_DELAYED_WORK(&xa->defer_wq, mem_id_disconnect_defer_retry);
 	mutex_unlock(&mem_id_lock);
@@ -388,10 +411,12 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 		page = virt_to_head_page(data);
-		if (xa) {
+		if (likely(xa)) {
 			napi_direct &= !xdp_return_frame_no_direct();
 			page_pool_put_page(xa->page_pool, page, napi_direct);
 		} else {
+			/* Hopefully stack show who to blame for late return */
+			WARN_ONCE(1, "page_pool gone mem.id=%d", mem->id);
 			put_page(page);
 		}
 		rcu_read_unlock();

