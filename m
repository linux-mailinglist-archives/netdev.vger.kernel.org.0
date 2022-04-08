Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49B94F90B2
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiDHI00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiDHI0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:26:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F490196093
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69DF2617B3
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 08:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCEEC385A3;
        Fri,  8 Apr 2022 08:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649406258;
        bh=0jhbgnK7FcTOktRUo0xOM6/7vpGZeIB/hIzoQGjdjA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdSlJbvv1yFWnTdxwpcMH2QObsDssZknYElX+wJSE1cqkIKlsbsCb+CNlpH2p2D5k
         ouNGd6O+vij4QRqogtxZmGJ7toB/szL0YGldQQBD1lPnm9efD5ypOsJ6hmxxjok0mf
         JcpXr5aidcf0MSMewFIjqGZsAu6Ak3hmvTv6g/nPAJst2ug7IBTFuoRoDEDqYb8B1X
         AQmNlFPof+4fLoKWsQuYSp20dLYwM61ab0EqbEBpec8B//h59AhRj6Axp1aFIl2MoJ
         BierZtgfQF6FmE57QJc4l+1JrZcoIXZNPLnE0a+ZcEHHde+NHkpb59u7KvYt3uIxBK
         v0jKI6i5rMCIw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [PATCH v2 net-next 1/2] net: page_pool: introduce ethtool stats
Date:   Fri,  8 Apr 2022 10:23:59 +0200
Message-Id: <63efff0da4235bfa2e326848545eb90c211e5db1.1649405981.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649405981.git.lorenzo@kernel.org>
References: <cover.1649405981.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool APIs to report stats through ethtool and reduce
duplicated code in each driver.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/page_pool.h | 24 ++++++++++++
 net/core/page_pool.c    | 81 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ea5fb70e5101..ada528df1843 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -117,6 +117,30 @@ struct page_pool_stats {
 	struct page_pool_recycle_stats recycle_stats;
 };
 
+/* List of page_pool stats exported through ethtool. */
+enum {
+	PP_ETHTOOL_ALLOC_FAST,
+	PP_ETHTOOL_ALLOC_SLOW,
+	PP_ETHTOOL_ALLOC_SLOW_HIGH_ORDER,
+	PP_ETHTOOL_ALLOC_EMPTY,
+	PP_ETHTOOL_ALLOC_REFILL,
+	PP_ETHTOOL_ALLOC_WAIVE,
+	PP_ETHTOOL_RECYCLE_CACHED,
+	PP_ETHTOOL_RECYCLE_CACHE_FULL,
+	PP_ETHTOOL_RECYCLE_RING,
+	PP_ETHTOOL_RECYCLE_RING_FULL,
+	PP_ETHTOOL_RECYCLE_RELEASED_REF,
+	PP_ETHTOOL_STATS_MAX,
+};
+
+static inline int page_pool_ethtool_stats_get_count(void)
+{
+	return PP_ETHTOOL_STATS_MAX;
+}
+
+u8 *page_pool_ethtool_stats_get_strings(u8 *data);
+u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *stats);
+
 /*
  * Drivers that wish to harvest page pool stats and report them to users
  * (perhaps via ethtool, debugfs, or another mechanism) can allocate a
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 4af55d28ffa3..bffc3037d7f6 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -18,6 +18,7 @@
 #include <linux/page-flags.h>
 #include <linux/mm.h> /* for __put_page() */
 #include <linux/poison.h>
+#include <linux/ethtool.h>
 
 #include <trace/events/page_pool.h>
 
@@ -50,7 +51,13 @@ bool page_pool_get_stats(struct page_pool *pool,
 	if (!stats)
 		return false;
 
-	memcpy(&stats->alloc_stats, &pool->alloc_stats, sizeof(pool->alloc_stats));
+	/* The caller is responsible to initialize stats. */
+	stats->alloc_stats.fast += pool->alloc_stats.fast;
+	stats->alloc_stats.slow += pool->alloc_stats.slow;
+	stats->alloc_stats.slow_high_order += pool->alloc_stats.slow_high_order;
+	stats->alloc_stats.empty += pool->alloc_stats.empty;
+	stats->alloc_stats.refill += pool->alloc_stats.refill;
+	stats->alloc_stats.waive += pool->alloc_stats.waive;
 
 	for_each_possible_cpu(cpu) {
 		const struct page_pool_recycle_stats *pcpu =
@@ -66,6 +73,78 @@ bool page_pool_get_stats(struct page_pool *pool,
 	return true;
 }
 EXPORT_SYMBOL(page_pool_get_stats);
+
+u8 *page_pool_ethtool_stats_get_strings(u8 *data)
+{
+	static const char stats[PP_ETHTOOL_STATS_MAX][ETH_GSTRING_LEN] = {
+		"rx_pp_alloc_fast",
+		"rx_pp_alloc_slow",
+		"rx_pp_alloc_slow_ho",
+		"rx_pp_alloc_empty",
+		"rx_pp_alloc_refill",
+		"rx_pp_alloc_waive",
+		"rx_pp_recycle_cached",
+		"rx_pp_recycle_cache_full",
+		"rx_pp_recycle_ring",
+		"rx_pp_recycle_ring_full",
+		"rx_pp_recycle_released_ref",
+	};
+	int i;
+
+	for (i = 0; i < PP_ETHTOOL_STATS_MAX; i++) {
+		memcpy(data, stats[i], ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	return data;
+}
+EXPORT_SYMBOL(page_pool_ethtool_stats_get_strings);
+
+u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *stats)
+{
+	int i;
+
+	for (i = 0; i < PP_ETHTOOL_STATS_MAX; i++) {
+		switch (i) {
+		case PP_ETHTOOL_ALLOC_FAST:
+			*data++ = stats->alloc_stats.fast;
+			break;
+		case PP_ETHTOOL_ALLOC_SLOW:
+			*data++ = stats->alloc_stats.slow;
+			break;
+		case PP_ETHTOOL_ALLOC_SLOW_HIGH_ORDER:
+			*data++ = stats->alloc_stats.slow_high_order;
+			break;
+		case PP_ETHTOOL_ALLOC_EMPTY:
+			*data++ = stats->alloc_stats.empty;
+			break;
+		case PP_ETHTOOL_ALLOC_REFILL:
+			*data++ = stats->alloc_stats.refill;
+			break;
+		case PP_ETHTOOL_ALLOC_WAIVE:
+			*data++ = stats->alloc_stats.waive;
+			break;
+		case PP_ETHTOOL_RECYCLE_CACHED:
+			*data++ = stats->recycle_stats.cached;
+			break;
+		case PP_ETHTOOL_RECYCLE_CACHE_FULL:
+			*data++ = stats->recycle_stats.cache_full;
+			break;
+		case PP_ETHTOOL_RECYCLE_RING:
+			*data++ = stats->recycle_stats.ring;
+			break;
+		case PP_ETHTOOL_RECYCLE_RING_FULL:
+			*data++ = stats->recycle_stats.ring_full;
+			break;
+		case PP_ETHTOOL_RECYCLE_RELEASED_REF:
+			*data++ = stats->recycle_stats.released_refcnt;
+			break;
+		}
+	}
+
+	return data;
+}
+EXPORT_SYMBOL(page_pool_ethtool_stats_get);
 #else
 #define alloc_stat_inc(pool, __stat)
 #define recycle_stat_inc(pool, __stat)
-- 
2.35.1

