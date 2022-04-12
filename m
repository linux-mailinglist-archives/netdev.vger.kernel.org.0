Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85ECD4FE5EC
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbiDLQet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355583AbiDLQes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:34:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCE95E166
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12B0861835
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 16:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A4CC385A5;
        Tue, 12 Apr 2022 16:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649781148;
        bh=4K3oNTpyrook6JGNGT7fjLqedtAtZUOZyt4n+mpS/Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oO7QHP8e7Fv105GF/hhFdQ99Iipwc5pC9AA50/NfpNN02Tbn8L5mJXf5RHPl+8MLW
         DeGb8dGRN1TwctY3NnBhYOmJp8QFEwCRp4A/KQ9757q05Mwug0+tZcus0CF8FAfDG0
         kigb1KkJWI575nw0rFgMjEF578rL49RGdrDXJ1wt2AF4qj2QPiMFiWboqCSPXMimZ0
         cBoktbX6ujIPn0VN5D8UrRfzlbkV0Ap3/VquSlEzPkIZq6giQ0i2mKf+ypaJ4hs5eG
         /FkGm5V97DhiDQeG6Ckq/CApmgDxKw1qH3gir9gVnU86c0pP1ei7z8Ib54zUyZgRfh
         WcD/K3SU4v7iQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [PATCH v5 net-next 1/2] net: page_pool: introduce ethtool stats
Date:   Tue, 12 Apr 2022 18:31:58 +0200
Message-Id: <a452ed5f5699447973c237cad1bd6c74bc9e7031.1649780789.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649780789.git.lorenzo@kernel.org>
References: <cover.1649780789.git.lorenzo@kernel.org>
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
 include/net/page_pool.h | 21 ++++++++++++++
 net/core/page_pool.c    | 63 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ea5fb70e5101..813c93499f20 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -117,6 +117,10 @@ struct page_pool_stats {
 	struct page_pool_recycle_stats recycle_stats;
 };
 
+int page_pool_ethtool_stats_get_count(void);
+u8 *page_pool_ethtool_stats_get_strings(u8 *data);
+u64 *page_pool_ethtool_stats_get(u64 *data, void *stats);
+
 /*
  * Drivers that wish to harvest page pool stats and report them to users
  * (perhaps via ethtool, debugfs, or another mechanism) can allocate a
@@ -124,6 +128,23 @@ struct page_pool_stats {
  */
 bool page_pool_get_stats(struct page_pool *pool,
 			 struct page_pool_stats *stats);
+#else
+
+static inline int page_pool_ethtool_stats_get_count(void)
+{
+	return 0;
+}
+
+static inline u8 *page_pool_ethtool_stats_get_strings(u8 *data)
+{
+	return data;
+}
+
+static inline u64 *page_pool_ethtool_stats_get(u64 *data, void *stats)
+{
+	return data;
+}
+
 #endif
 
 struct page_pool {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 4af55d28ffa3..bdbadfaee867 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -18,6 +18,7 @@
 #include <linux/page-flags.h>
 #include <linux/mm.h> /* for __put_page() */
 #include <linux/poison.h>
+#include <linux/ethtool.h>
 
 #include <trace/events/page_pool.h>
 
@@ -42,6 +43,20 @@
 		this_cpu_add(s->__stat, val);						\
 	} while (0)
 
+static const char pp_stats[][ETH_GSTRING_LEN] = {
+	"rx_pp_alloc_fast",
+	"rx_pp_alloc_slow",
+	"rx_pp_alloc_slow_ho",
+	"rx_pp_alloc_empty",
+	"rx_pp_alloc_refill",
+	"rx_pp_alloc_waive",
+	"rx_pp_recycle_cached",
+	"rx_pp_recycle_cache_full",
+	"rx_pp_recycle_ring",
+	"rx_pp_recycle_ring_full",
+	"rx_pp_recycle_released_ref",
+};
+
 bool page_pool_get_stats(struct page_pool *pool,
 			 struct page_pool_stats *stats)
 {
@@ -50,7 +65,13 @@ bool page_pool_get_stats(struct page_pool *pool,
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
@@ -66,6 +87,46 @@ bool page_pool_get_stats(struct page_pool *pool,
 	return true;
 }
 EXPORT_SYMBOL(page_pool_get_stats);
+
+u8 *page_pool_ethtool_stats_get_strings(u8 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(pp_stats); i++) {
+		memcpy(data, pp_stats[i], ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	return data;
+}
+EXPORT_SYMBOL(page_pool_ethtool_stats_get_strings);
+
+int page_pool_ethtool_stats_get_count(void)
+{
+	return ARRAY_SIZE(pp_stats);
+}
+EXPORT_SYMBOL(page_pool_ethtool_stats_get_count);
+
+u64 *page_pool_ethtool_stats_get(u64 *data, void *stats)
+{
+	struct page_pool_stats *pool_stats = stats;
+
+	*data++ = pool_stats->alloc_stats.fast;
+	*data++ = pool_stats->alloc_stats.slow;
+	*data++ = pool_stats->alloc_stats.slow_high_order;
+	*data++ = pool_stats->alloc_stats.empty;
+	*data++ = pool_stats->alloc_stats.refill;
+	*data++ = pool_stats->alloc_stats.waive;
+	*data++ = pool_stats->recycle_stats.cached;
+	*data++ = pool_stats->recycle_stats.cache_full;
+	*data++ = pool_stats->recycle_stats.ring;
+	*data++ = pool_stats->recycle_stats.ring_full;
+	*data++ = pool_stats->recycle_stats.released_refcnt;
+
+	return data;
+}
+EXPORT_SYMBOL(page_pool_ethtool_stats_get);
+
 #else
 #define alloc_stat_inc(pool, __stat)
 #define recycle_stat_inc(pool, __stat)
-- 
2.35.1

