Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63DD8DA1C3
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405002AbfJPWvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:51:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62976 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393485AbfJPWu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:50:56 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GMop45024805
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:56 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnpry5ghg-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:55 -0700
Received: from 2401:db00:2120:81dc:face:0:23:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 16 Oct 2019 15:50:30 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id D98234A2BD62; Wed, 16 Oct 2019 15:50:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH 08/10 net-next] page_pool: Add statistics
Date:   Wed, 16 Oct 2019 15:50:26 -0700
Message-ID: <20191016225028.2100206-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 suspectscore=2 clxscore=1034 priorityscore=1501
 spamscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add statistics to the page pool, providing visibility into its operation.

Callers can provide a location where the stats are stored, otherwise
the page pool will allocate a statistic area.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/net/page_pool.h | 21 +++++++++++++---
 net/core/page_pool.c    | 55 +++++++++++++++++++++++++++++++++++------
 2 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index fc340db42f9a..4f383522b141 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -34,8 +34,11 @@
 #include <linux/ptr_ring.h>
 #include <linux/dma-direction.h>
 
-#define PP_FLAG_DMA_MAP 1 /* Should page_pool do the DMA map/unmap */
-#define PP_FLAG_ALL	PP_FLAG_DMA_MAP
+#define PP_FLAG_DMA_MAP		BIT(0) /* page_pool does the DMA map/unmap */
+#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP)
+
+/* internal flags, not expoed to user */
+#define PP_FLAG_INTERNAL_STATS	BIT(8)
 
 /*
  * Fast allocation side cache array/stack
@@ -57,6 +60,17 @@
 #define PP_ALLOC_POOL_DEFAULT	1024
 #define PP_ALLOC_POOL_LIMIT	32768
 
+struct page_pool_stats {
+	u64 cache_hit;
+	u64 cache_full;
+	u64 cache_empty;
+	u64 ring_produce;
+	u64 ring_consume;
+	u64 ring_return;
+	u64 flush;
+	u64 node_change;
+};
+
 struct page_pool_params {
 	unsigned int	flags;
 	unsigned int	order;
@@ -65,6 +79,7 @@ struct page_pool_params {
 	int		nid;  /* Numa node id to allocate from pages from */
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
 	struct device	*dev; /* device, for DMA pre-mapping purposes */
+	struct page_pool_stats *stats; /* pool stats stored externally */
 };
 
 struct page_pool {
@@ -230,8 +245,8 @@ static inline bool page_pool_put(struct page_pool *pool)
 static inline void page_pool_update_nid(struct page_pool *pool, int new_nid)
 {
 	if (unlikely(pool->p.nid != new_nid)) {
-		/* TODO: Add statistics/trace */
 		pool->p.nid = new_nid;
+		pool->p.stats->node_change++;
 	}
 }
 #endif /* _NET_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index f8fedecddb6f..ea6202813584 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -20,9 +20,10 @@
 
 static int page_pool_init(struct page_pool *pool)
 {
+	int size;
 
 	/* Validate only known flags were used */
-	if (pool->p.flags & ~(PP_FLAG_ALL))
+	if (pool->p.flags & ~PP_FLAG_ALL)
 		return -EINVAL;
 
 	if (!pool->p.pool_size)
@@ -40,8 +41,16 @@ static int page_pool_init(struct page_pool *pool)
 	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
 		return -EINVAL;
 
+	if (!pool->p.stats) {
+		size  = sizeof(struct page_pool_stats);
+		pool->p.stats = kzalloc_node(size, GFP_KERNEL, pool->p.nid);
+		if (!pool->p.stats)
+			return -ENOMEM;
+		pool->p.flags |= PP_FLAG_INTERNAL_STATS;
+	}
+
 	if (ptr_ring_init(&pool->ring, pool->p.pool_size, GFP_KERNEL) < 0)
-		return -ENOMEM;
+		goto fail;
 
 	atomic_set(&pool->pages_state_release_cnt, 0);
 
@@ -52,6 +61,12 @@ static int page_pool_init(struct page_pool *pool)
 		get_device(pool->p.dev);
 
 	return 0;
+
+fail:
+	if (pool->p.flags & PP_FLAG_INTERNAL_STATS)
+		kfree(pool->p.stats);
+
+	return -ENOMEM;
 }
 
 struct page_pool *page_pool_create(const struct page_pool_params *params)
@@ -98,9 +113,11 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	if (likely(in_serving_softirq())) {
 		if (likely(pool->alloc_count)) {
 			/* Fast-path */
+			pool->p.stats->cache_hit++;
 			page = pool->alloc_cache[--pool->alloc_count];
 			return page;
 		}
+		pool->p.stats->cache_empty++;
 		refill = true;
 	}
 
@@ -113,10 +130,13 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 	 */
 	spin_lock(&r->consumer_lock);
 	page = __ptr_ring_consume(r);
-	if (refill)
+	if (refill) {
 		pool->alloc_count = __ptr_ring_consume_batched(r,
 							pool->alloc_cache,
 							PP_ALLOC_CACHE_REFILL);
+		pool->p.stats->ring_consume += pool->alloc_count;
+	}
+	pool->p.stats->ring_consume += !!page;
 	spin_unlock(&r->consumer_lock);
 	return page;
 }
@@ -266,15 +286,23 @@ static void __page_pool_return_page(struct page_pool *pool, struct page *page)
 static bool __page_pool_recycle_into_ring(struct page_pool *pool,
 				   struct page *page)
 {
+	struct ptr_ring *r = &pool->ring;
 	int ret;
 
-	/* BH protection not needed if current is serving softirq */
 	if (in_serving_softirq())
-		ret = ptr_ring_produce(&pool->ring, page);
+		spin_lock(&r->producer_lock);
 	else
-		ret = ptr_ring_produce_bh(&pool->ring, page);
+		spin_lock_bh(&r->producer_lock);
 
-	return (ret == 0) ? true : false;
+	ret = __ptr_ring_produce(r, page);
+	pool->p.stats->ring_produce++;
+
+	if (in_serving_softirq())
+		spin_unlock(&r->producer_lock);
+	else
+		spin_unlock_bh(&r->producer_lock);
+
+	return ret == 0;
 }
 
 /* Only allow direct recycling in special circumstances, into the
@@ -285,8 +313,10 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
 static bool __page_pool_recycle_into_cache(struct page *page,
 					   struct page_pool *pool)
 {
-	if (unlikely(pool->alloc_count == pool->p.cache_size))
+	if (unlikely(pool->alloc_count == pool->p.cache_size)) {
+		pool->p.stats->cache_full++;
 		return false;
+	}
 
 	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
 	pool->alloc_cache[pool->alloc_count++] = page;
@@ -343,6 +373,7 @@ EXPORT_SYMBOL(__page_pool_put_page);
 static void __page_pool_empty_ring(struct page_pool *pool)
 {
 	struct page *page;
+	int count = 0;
 
 	/* Empty recycle ring */
 	while ((page = ptr_ring_consume_bh(&pool->ring))) {
@@ -351,8 +382,11 @@ static void __page_pool_empty_ring(struct page_pool *pool)
 			pr_crit("%s() page_pool refcnt %d violation\n",
 				__func__, page_ref_count(page));
 
+		count++;
 		__page_pool_return_page(pool, page);
 	}
+
+	pool->p.stats->ring_return += count;
 }
 
 static void __warn_in_flight(struct page_pool *pool)
@@ -381,6 +415,9 @@ void __page_pool_free(struct page_pool *pool)
 	if (!__page_pool_safe_to_destroy(pool))
 		__warn_in_flight(pool);
 
+	if (pool->p.flags & PP_FLAG_INTERNAL_STATS)
+		kfree(pool->p.stats);
+
 	ptr_ring_cleanup(&pool->ring, NULL);
 
 	if (pool->p.flags & PP_FLAG_DMA_MAP)
@@ -394,6 +431,8 @@ static void page_pool_flush(struct page_pool *pool)
 {
 	struct page *page;
 
+	pool->p.stats->flush++;
+
 	/* Empty alloc cache, assume caller made sure this is
 	 * no-longer in use, and page_pool_alloc_pages() cannot be
 	 * called concurrently.
-- 
2.17.1

