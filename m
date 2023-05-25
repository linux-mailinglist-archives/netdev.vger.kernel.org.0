Return-Path: <netdev+bounces-5329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4233710CF2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D62B2814F3
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BAD10788;
	Thu, 25 May 2023 13:00:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED60101F1
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 13:00:42 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C310CF;
	Thu, 25 May 2023 06:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685019624; x=1716555624;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GwVgZzmK6hAs/7H6eK8PN89Rgl6guxNN7+o+ff6EBp4=;
  b=I2woCwOoG1oS/bU5ILyaCDRHEWEjGux+bDzb3YH7/FVVI9iztPDQlgQ5
   QbApfgJw8aqOcGgqBeC5wneojO00qE5tnbCV6F9bhiycgWPuBpQUKq8Ai
   Gckw4goaFkRzukYdz3gAL0k71ywdL5QqcQ/i/w/Re5HtF1ep0nuvEJR0x
   VjewL8KzbRj6rpi0VirDqVLKZzpKcev8hyzl5PoCzD2VKfHNO9qF6RTxp
   dD7wreZLuUfsbgF6h8MtuVIWI8/zphnAwdw55T0dp0uU8oNOH2iC4GJz+
   WoouSx7HxLUOBwsj+G8Oh0Hp7Px6BB1a+8qNToyedCWll0OPQqax9P/hd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351384479"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="351384479"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 05:59:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="817075217"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="817075217"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga002.fm.intel.com with ESMTP; 25 May 2023 05:59:12 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Christoph Hellwig <hch@lst.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 11/12] libie: add per-queue Page Pool stats
Date: Thu, 25 May 2023 14:57:45 +0200
Message-Id: <20230525125746.553874-12-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525125746.553874-1-aleksander.lobakin@intel.com>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Expand the libie generic per-queue stats with the generic Page Pool
stats provided by the API itself, when CONFIG_PAGE_POOL is enabled.
When it's not, there'll be no such fields in the stats structure, so
no space wasted.
They are also a bit special in terms of how they are obtained. One
&page_pool accumulates statistics until it's destroyed obviously,
which happens on ifdown. So, in order to not lose any statistics,
get the stats and store in the queue container before destroying
a pool. This container survives ifups/downs, so it basically stores
the statistics accumulated since the very first pool was allocated
on this queue. When it's needed to export the stats, first get the
numbers from this container and then add the "live" numbers -- the
ones that the current active pool returns. The result values will
always represent the actual device-lifetime* stats.
There's a cast from &page_pool_stats to `u64 *` in a couple functions,
but they are guarded with stats asserts to make sure it's safe to do.
FWIW it saves a lot of object code.

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 drivers/net/ethernet/intel/libie/internal.h | 23 +++++++
 drivers/net/ethernet/intel/libie/rx.c       | 20 ++++++
 drivers/net/ethernet/intel/libie/stats.c    | 73 ++++++++++++++++++++-
 include/linux/net/intel/libie/rx.h          |  4 ++
 include/linux/net/intel/libie/stats.h       | 39 ++++++++++-
 5 files changed, 156 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/libie/internal.h

diff --git a/drivers/net/ethernet/intel/libie/internal.h b/drivers/net/ethernet/intel/libie/internal.h
new file mode 100644
index 000000000000..083398dc37c6
--- /dev/null
+++ b/drivers/net/ethernet/intel/libie/internal.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* libie internal declarations not to be used in drivers.
+ *
+ * Copyright(c) 2023 Intel Corporation.
+ */
+
+#ifndef __LIBIE_INTERNAL_H
+#define __LIBIE_INTERNAL_H
+
+struct libie_rq_stats;
+struct page_pool;
+
+#ifdef CONFIG_PAGE_POOL_STATS
+void libie_rq_stats_sync_pp(struct libie_rq_stats *stats,
+			    struct page_pool *pool);
+#else
+static inline void libie_rq_stats_sync_pp(struct libie_rq_stats *stats,
+					  struct page_pool *pool)
+{
+}
+#endif
+
+#endif /* __LIBIE_INTERNAL_H */
diff --git a/drivers/net/ethernet/intel/libie/rx.c b/drivers/net/ethernet/intel/libie/rx.c
index d68eab76593c..128f134aca6d 100644
--- a/drivers/net/ethernet/intel/libie/rx.c
+++ b/drivers/net/ethernet/intel/libie/rx.c
@@ -3,6 +3,8 @@
 
 #include <linux/net/intel/libie/rx.h>
 
+#include "internal.h"
+
 /* O(1) converting i40e/ice/iavf's 8/10-bit hardware packet type to a parsed
  * bitfield struct.
  */
@@ -133,6 +135,24 @@ struct page_pool *libie_rx_page_pool_create(struct napi_struct *napi,
 }
 EXPORT_SYMBOL_NS_GPL(libie_rx_page_pool_create, LIBIE);
 
+/**
+ * libie_rx_page_pool_destroy - destroy a &page_pool created by libie
+ * @pool: pool to destroy
+ * @stats: RQ stats from the ring (or %NULL to skip updating PP stats)
+ *
+ * As the stats usually has the same lifetime as the device, but PP is usually
+ * created/destroyed on ifup/ifdown, in order to not lose the stats accumulated
+ * during the last ifup, the PP stats need to be added to the driver stats
+ * container. Then the PP gets destroyed.
+ */
+void libie_rx_page_pool_destroy(struct page_pool *pool,
+				struct libie_rq_stats *stats)
+{
+	libie_rq_stats_sync_pp(stats, pool);
+	page_pool_destroy(pool);
+}
+EXPORT_SYMBOL_NS_GPL(libie_rx_page_pool_destroy, LIBIE);
+
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Intel(R) Ethernet common library");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/intel/libie/stats.c b/drivers/net/ethernet/intel/libie/stats.c
index 61456842a362..71c7ce14edca 100644
--- a/drivers/net/ethernet/intel/libie/stats.c
+++ b/drivers/net/ethernet/intel/libie/stats.c
@@ -3,6 +3,9 @@
 
 #include <linux/ethtool.h>
 #include <linux/net/intel/libie/stats.h>
+#include <net/page_pool.h>
+
+#include "internal.h"
 
 /* Rx per-queue stats */
 
@@ -14,6 +17,70 @@ static const char * const libie_rq_stats_str[] = {
 
 #define LIBIE_RQ_STATS_NUM	ARRAY_SIZE(libie_rq_stats_str)
 
+#ifdef CONFIG_PAGE_POOL_STATS
+/**
+ * libie_rq_stats_get_pp - get the current stats from a &page_pool
+ * @sarr: local array to add stats to
+ * @pool: pool to get the stats from
+ *
+ * Adds the current "live" stats from an online PP to the stats read from
+ * the RQ container, so that the actual totals will be returned.
+ */
+static void libie_rq_stats_get_pp(u64 *sarr, struct page_pool *pool)
+{
+	struct page_pool_stats *pps;
+	/* Used only to calculate pos below */
+	struct libie_rq_stats tmp;
+	u32 pos;
+
+	/* Validate the libie PP stats array can be casted <-> PP struct */
+	static_assert(sizeof(tmp.pp) == sizeof(*pps));
+
+	if (!pool)
+		return;
+
+	/* Position of the first Page Pool stats field */
+	pos = (u64_stats_t *)&tmp.pp - tmp.raw;
+	pps = (typeof(pps))&sarr[pos];
+
+	page_pool_get_stats(pool, pps);
+}
+
+/**
+ * libie_rq_stats_sync_pp - add the current PP stats to the RQ stats container
+ * @stats: stats structure to update
+ * @pool: pool to read the stats
+ *
+ * Called by libie_rx_page_pool_destroy() to save the stats before destroying
+ * the pool.
+ */
+void libie_rq_stats_sync_pp(struct libie_rq_stats *stats,
+			    struct page_pool *pool)
+{
+	u64_stats_t *qarr = (u64_stats_t *)&stats->pp;
+	struct page_pool_stats pps = { };
+	u64 *sarr = (u64 *)&pps;
+
+	if (!stats)
+		return;
+
+	page_pool_get_stats(pool, &pps);
+
+	u64_stats_update_begin(&stats->syncp);
+
+	for (u32 i = 0; i < sizeof(pps) / sizeof(*sarr); i++)
+		u64_stats_add(&qarr[i], sarr[i]);
+
+	u64_stats_update_end(&stats->syncp);
+}
+#else
+static void libie_rq_stats_get_pp(u64 *sarr, struct page_pool *pool)
+{
+}
+
+/* static inline void libie_rq_stats_sync_pp() is declared in "internal.h" */
+#endif
+
 /**
  * libie_rq_stats_get_sset_count - get the number of Ethtool RQ stats provided
  *
@@ -41,8 +108,10 @@ EXPORT_SYMBOL_NS_GPL(libie_rq_stats_get_strings, LIBIE);
  * libie_rq_stats_get_data - get the RQ stats in Ethtool format
  * @data: reference to the cursor pointing to the output array
  * @stats: RQ stats container from the queue
+ * @pool: &page_pool from the queue (%NULL to ignore PP "live" stats)
  */
-void libie_rq_stats_get_data(u64 **data, const struct libie_rq_stats *stats)
+void libie_rq_stats_get_data(u64 **data, const struct libie_rq_stats *stats,
+			     struct page_pool *pool)
 {
 	u64 sarr[LIBIE_RQ_STATS_NUM];
 	u32 start;
@@ -54,6 +123,8 @@ void libie_rq_stats_get_data(u64 **data, const struct libie_rq_stats *stats)
 			sarr[i] = u64_stats_read(&stats->raw[i]);
 	} while (u64_stats_fetch_retry(&stats->syncp, start));
 
+	libie_rq_stats_get_pp(sarr, pool);
+
 	for (u32 i = 0; i < LIBIE_RQ_STATS_NUM; i++)
 		(*data)[i] += sarr[i];
 
diff --git a/include/linux/net/intel/libie/rx.h b/include/linux/net/intel/libie/rx.h
index b86cadd281f1..d401feb17928 100644
--- a/include/linux/net/intel/libie/rx.h
+++ b/include/linux/net/intel/libie/rx.h
@@ -160,7 +160,11 @@ static inline void libie_skb_set_hash(struct sk_buff *skb, u32 hash,
 /* Maximum frame size minus LL overhead */
 #define LIBIE_MAX_MTU		(LIBIE_MAX_RX_FRM_LEN - LIBIE_RX_LL_LEN)
 
+struct libie_rq_stats;
+
 struct page_pool *libie_rx_page_pool_create(struct napi_struct *napi,
 					    u32 size);
+void libie_rx_page_pool_destroy(struct page_pool *pool,
+				struct libie_rq_stats *stats);
 
 #endif /* __LIBIE_RX_H */
diff --git a/include/linux/net/intel/libie/stats.h b/include/linux/net/intel/libie/stats.h
index dbbc98bbd3a7..23ca0079a905 100644
--- a/include/linux/net/intel/libie/stats.h
+++ b/include/linux/net/intel/libie/stats.h
@@ -49,6 +49,17 @@
  * fragments: number of processed descriptors carrying only a fragment
  * alloc_page_fail: number of Rx page allocation fails
  * build_skb_fail: number of build_skb() fails
+ * pp_alloc_fast: pages taken from the cache or ring
+ * pp_alloc_slow: actual page allocations
+ * pp_alloc_slow_ho: non-order-0 page allocations
+ * pp_alloc_empty: number of times the pool was empty
+ * pp_alloc_refill: number of cache refills
+ * pp_alloc_waive: NUMA node mismatches during recycling
+ * pp_recycle_cached: direct recyclings into the cache
+ * pp_recycle_cache_full: number of times the cache was full
+ * pp_recycle_ring: recyclings into the ring
+ * pp_recycle_ring_full: number of times the ring was full
+ * pp_recycle_released_ref: pages released due to elevated refcnt
  */
 
 #define DECLARE_LIBIE_RQ_NAPI_STATS(act)		\
@@ -60,9 +71,29 @@
 	act(alloc_page_fail)				\
 	act(build_skb_fail)
 
+#ifdef CONFIG_PAGE_POOL_STATS
+#define DECLARE_LIBIE_RQ_PP_STATS(act)			\
+	act(pp_alloc_fast)				\
+	act(pp_alloc_slow)				\
+	act(pp_alloc_slow_ho)				\
+	act(pp_alloc_empty)				\
+	act(pp_alloc_refill)				\
+	act(pp_alloc_waive)				\
+	act(pp_recycle_cached)				\
+	act(pp_recycle_cache_full)			\
+	act(pp_recycle_ring)				\
+	act(pp_recycle_ring_full)			\
+	act(pp_recycle_released_ref)
+#else
+#define DECLARE_LIBIE_RQ_PP_STATS(act)
+#endif
+
 #define DECLARE_LIBIE_RQ_STATS(act)			\
 	DECLARE_LIBIE_RQ_NAPI_STATS(act)		\
-	DECLARE_LIBIE_RQ_FAIL_STATS(act)
+	DECLARE_LIBIE_RQ_FAIL_STATS(act)		\
+	DECLARE_LIBIE_RQ_PP_STATS(act)
+
+struct page_pool;
 
 struct libie_rq_stats {
 	struct u64_stats_sync	syncp;
@@ -72,6 +103,9 @@ struct libie_rq_stats {
 #define act(s)	u64_stats_t	s;
 			DECLARE_LIBIE_RQ_NAPI_STATS(act);
 			DECLARE_LIBIE_RQ_FAIL_STATS(act);
+			struct_group(pp,
+				DECLARE_LIBIE_RQ_PP_STATS(act);
+			);
 #undef act
 		};
 		DECLARE_FLEX_ARRAY(u64_stats_t, raw);
@@ -110,7 +144,8 @@ libie_rq_napi_stats_add(struct libie_rq_stats *qs,
 
 u32 libie_rq_stats_get_sset_count(void);
 void libie_rq_stats_get_strings(u8 **data, u32 qid);
-void libie_rq_stats_get_data(u64 **data, const struct libie_rq_stats *stats);
+void libie_rq_stats_get_data(u64 **data, const struct libie_rq_stats *stats,
+			     struct page_pool *pool);
 
 /* Tx per-queue stats:
  * packets: packets sent from this queue
-- 
2.40.1


