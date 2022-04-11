Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABD24FBFF7
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347678AbiDKPOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347688AbiDKPOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:14:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F254231907
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:12:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D796614D2
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 15:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2649C385A4;
        Mon, 11 Apr 2022 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649689922;
        bh=PtIz8isQaMyaa/FWfJ9rGCK8/8JZD5fQC/nWy/2Z3o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auuEeyZzXx0XG//lwUO5o2co5jqzHW9UbA89DmQVEhMuqPw4vZs7j8BAmxlRvTewg
         wN9FsckAVmJHw8UBihh5aBkoT50bPOQJMNSOMnGC3cHM5tOvAOgqGN+S0qkpquYWye
         0Q4hIGNVakdbPtWrzntArmYElwL3DaSbCCnEB7Axq85Ch3YxuuFfdd+cBI6CpjpWz5
         e8MWRWzzixA4iiN0/Dw7ka6IUx5bK4o02uJt1bb9PaRE6I8M4rVdIil5Cp+5nI4UIr
         ewZP0w92IGfhcank2K+ds2EgQ2d6IGP9e9H9GWHcP+6gdltqmUVZxwkNZzfNAeDL80
         /e8rDAVFdNYmQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [PATCH v4 net-next 1/2] net: page_pool: introduce ethtool stats
Date:   Mon, 11 Apr 2022 17:11:41 +0200
Message-Id: <e01df27fd1ac1e6e94893c46806d91587db39cc8.1649689580.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649689580.git.lorenzo@kernel.org>
References: <cover.1649689580.git.lorenzo@kernel.org>
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
index 4af55d28ffa3..90130f5a519e 100644
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
+	struct page_pool_stats *pp_stats = stats;
+
+	*data++ = pp_stats->alloc_stats.fast;
+	*data++ = pp_stats->alloc_stats.slow;
+	*data++ = pp_stats->alloc_stats.slow_high_order;
+	*data++ = pp_stats->alloc_stats.empty;
+	*data++ = pp_stats->alloc_stats.refill;
+	*data++ = pp_stats->alloc_stats.waive;
+	*data++ = pp_stats->recycle_stats.cached;
+	*data++ = pp_stats->recycle_stats.cache_full;
+	*data++ = pp_stats->recycle_stats.ring;
+	*data++ = pp_stats->recycle_stats.ring_full;
+	*data++ = pp_stats->recycle_stats.released_refcnt;
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

