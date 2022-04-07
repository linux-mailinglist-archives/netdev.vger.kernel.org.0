Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C184F8555
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbiDGQ5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiDGQ5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:57:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F046A02C
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD8D8B82795
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 16:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FB1C385A4;
        Thu,  7 Apr 2022 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649350532;
        bh=FldePOliMRb/opUYvoCZB/YpwvbGb3uMor2K2o4V9U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSBWx4r8jyvaEQO/5G9C77/2iAr5+9g1lDoF2faZGQCMqDsN4+VHLGZ9eR7geIF0K
         zmo0yWgyE73cKJOlSbEQQlT7dYBgtNqPHfiXPVq66pqS9l9V2bP5oT5k9q/Llc53Nc
         YNo6b6KDOX6/9IT63oLQ7szajE9i/Qo1ngKFQ5SwuHO2Jy0uf27SUUx8cpi/d9hS4y
         eo4Pw1vz66CUBel94vK4TtyK3tefQAdYlIVYqHhMsUQtQGRs2JRoihC1fiG2YQO2jL
         7YcoD4T7N/ftACUHRHF6aZISpYtj+uxZsyr81YW4RZqhw/Ywnshl6zQ+tt+zZVbPV6
         IQWkObnLC6jTw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [RFC net-next 1/2] net: page_pool: introduce ethtool stats
Date:   Thu,  7 Apr 2022 18:55:04 +0200
Message-Id: <ab9f8ae8a29f2c3acdb33fe7ade0691ff4a9494a.1649350165.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649350165.git.lorenzo@kernel.org>
References: <cover.1649350165.git.lorenzo@kernel.org>
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

Introduce APIs to report page_pool stats through ethtool and reduce
duplicated code in each driver.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/page_pool.h | 24 +++++++++++
 net/core/page_pool.c    | 96 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ea5fb70e5101..17fb15b49f1a 100644
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
+void page_pool_ethtool_stats_get_strings(u8 *data);
+void page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *stats);
+
 /*
  * Drivers that wish to harvest page pool stats and report them to users
  * (perhaps via ethtool, debugfs, or another mechanism) can allocate a
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 4af55d28ffa3..7f24fc2fe58d 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -18,6 +18,7 @@
 #include <linux/page-flags.h>
 #include <linux/mm.h> /* for __put_page() */
 #include <linux/poison.h>
+#include <linux/ethtool.h>
 
 #include <trace/events/page_pool.h>
 
@@ -66,6 +67,101 @@ bool page_pool_get_stats(struct page_pool *pool,
 	return true;
 }
 EXPORT_SYMBOL(page_pool_get_stats);
+
+void page_pool_ethtool_stats_get_strings(u8 *data)
+{
+	static const struct {
+		u8 type;
+		char name[ETH_GSTRING_LEN];
+	} stats[PP_ETHTOOL_STATS_MAX] = {
+		{
+			.type = PP_ETHTOOL_ALLOC_FAST,
+			.name = "rx_pp_alloc_fast"
+		}, {
+			.type = PP_ETHTOOL_ALLOC_SLOW,
+			.name = "rx_pp_alloc_slow"
+		}, {
+			.type = PP_ETHTOOL_ALLOC_SLOW_HIGH_ORDER,
+			.name = "rx_pp_alloc_slow_ho"
+		}, {
+			.type = PP_ETHTOOL_ALLOC_EMPTY,
+			.name = "rx_pp_alloc_empty"
+		}, {
+			.type = PP_ETHTOOL_ALLOC_REFILL,
+			.name = "rx_pp_alloc_refill"
+		}, {
+			.type = PP_ETHTOOL_ALLOC_WAIVE,
+			.name = "rx_pp_alloc_waive"
+		}, {
+			.type = PP_ETHTOOL_RECYCLE_CACHED,
+			.name = "rx_pp_recycle_cached"
+		}, {
+			.type = PP_ETHTOOL_RECYCLE_CACHE_FULL,
+			.name = "rx_pp_recycle_cache_full"
+		}, {
+			.type = PP_ETHTOOL_RECYCLE_RING,
+			.name = "rx_pp_recycle_ring"
+		}, {
+			.type = PP_ETHTOOL_RECYCLE_RING_FULL,
+			.name = "rx_pp_recycle_ring_full"
+		}, {
+			.type = PP_ETHTOOL_RECYCLE_RELEASED_REF,
+			.name = "rx_pp_recycle_released_ref"
+		},
+	};
+	int i;
+
+	for (i = 0; i < PP_ETHTOOL_STATS_MAX; i++) {
+		memcpy(data, stats[i].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+}
+EXPORT_SYMBOL(page_pool_ethtool_stats_get_strings);
+
+void page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *stats)
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
+}
+EXPORT_SYMBOL(page_pool_ethtool_stats_get);
 #else
 #define alloc_stat_inc(pool, __stat)
 #define recycle_stat_inc(pool, __stat)
-- 
2.35.1

