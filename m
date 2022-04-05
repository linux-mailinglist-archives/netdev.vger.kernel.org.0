Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C564F5422
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345806AbiDFE05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347776AbiDEVJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 17:09:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43DB67D07
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 13:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 702E4619A6
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 20:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB670C385A0;
        Tue,  5 Apr 2022 20:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649190749;
        bh=ZvOmuWZ03jB6qirN4926W0KR3vfLtA+vmunBO4W26bk=;
        h=From:To:Cc:Subject:Date:From;
        b=UWFwaGdPenaSdmtQlMClW4R8aE4IQzK34qMV1XiY2JSTQAU3KBl6Pslw7nWxlQFP6
         y+YRBgtUE6jPoaJOOlT6yzHFahW+19c0erL9CMRCHTVjrMWJs7P/cBmIUiMEq4QGNF
         6sxs+T79M4OEHdt6mG2lPBAS7JftpFSQhQXeUXPX6aMfBMGIpIFVSG1xtiPiLSg3J5
         KcvPa8lK2fFikz4urG2mHKGX+RVc1L8eu//Ly89X6rZAeuVngVHYgsGoJ/NiV9CvMj
         qtL6GdJw4JRCaR4kYuo3k19n2H7lkHxUTdvdE2WDSpCRICqy0JJ1Vh/Hmj9xNjJFui
         Wvb1kah13h8lQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com,
        ilias.apalodimas@linaro.org, jdamato@fastly.com
Subject: [PATCH net-next] net: mvneta: add support for page_pool_get_stats
Date:   Tue,  5 Apr 2022 22:32:12 +0200
Message-Id: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
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

Introduce support for the page_pool_get_stats API to mvneta driver.
If CONFIG_PAGE_POOL_STATS is enabled, ethtool will report page pool
stats.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 105 ++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 934f6dd90992..b986a6bded9a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -382,6 +382,19 @@ enum {
 	ETHTOOL_XDP_TX_ERR,
 	ETHTOOL_XDP_XMIT,
 	ETHTOOL_XDP_XMIT_ERR,
+#ifdef CONFIG_PAGE_POOL_STATS
+	ETHTOOL_PP_ALLOC_FAST,
+	ETHTOOL_PP_ALLOC_SLOW,
+	ETHTOOL_PP_ALLOC_SLOW_HIGH_ORDER,
+	ETHTOOL_PP_ALLOC_EMPTY,
+	ETHTOOL_PP_ALLOC_REFILL,
+	ETHTOOL_PP_ALLOC_WAIVE,
+	ETHTOOL_PP_RECYCLE_CACHED,
+	ETHTOOL_PP_RECYCLE_CACHE_FULL,
+	ETHTOOL_PP_RECYCLE_RING,
+	ETHTOOL_PP_RECYCLE_RING_FULL,
+	ETHTOOL_PP_RECYCLE_RELEASED_REF,
+#endif /* CONFIG_PAGE_POOL_STATS */
 	ETHTOOL_MAX_STATS,
 };
 
@@ -443,6 +456,19 @@ static const struct mvneta_statistic mvneta_statistics[] = {
 	{ ETHTOOL_XDP_TX_ERR, T_SW, "rx_xdp_tx_errors", },
 	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },
 	{ ETHTOOL_XDP_XMIT_ERR, T_SW, "tx_xdp_xmit_errors", },
+#ifdef CONFIG_PAGE_POOL_STATS
+	{ ETHTOOL_PP_ALLOC_FAST, T_SW, "rx_pp_alloc_fast", },
+	{ ETHTOOL_PP_ALLOC_SLOW, T_SW, "rx_pp_alloc_slow", },
+	{ ETHTOOL_PP_ALLOC_SLOW_HIGH_ORDER, T_SW, "rx_pp_alloc_slow_ho", },
+	{ ETHTOOL_PP_ALLOC_EMPTY, T_SW, "rx_pp_alloc_empty", },
+	{ ETHTOOL_PP_ALLOC_REFILL, T_SW, "rx_pp_alloc_refill", },
+	{ ETHTOOL_PP_ALLOC_WAIVE, T_SW, "rx_pp_alloc_waive", },
+	{ ETHTOOL_PP_RECYCLE_CACHED, T_SW, "rx_pp_recycle_cached", },
+	{ ETHTOOL_PP_RECYCLE_CACHE_FULL, T_SW, "rx_pp_recycle_cache_full", },
+	{ ETHTOOL_PP_RECYCLE_RING, T_SW, "rx_pp_recycle_ring", },
+	{ ETHTOOL_PP_RECYCLE_RING_FULL, T_SW, "rx_pp_recycle_ring_full", },
+	{ ETHTOOL_PP_RECYCLE_RELEASED_REF, T_SW, "rx_pp_recycle_released_ref", },
+#endif /* CONFIG_PAGE_POOL_STATS */
 };
 
 struct mvneta_stats {
@@ -4783,16 +4809,56 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 	}
 }
 
+#ifdef CONFIG_PAGE_POOL_STATS
+static void mvneta_ethtool_update_pp_stats(struct mvneta_port *pp,
+					   struct page_pool_stats *stats)
+{
+	int i;
+
+	memset(stats, 0, sizeof(*stats));
+	for (i = 0; i < rxq_number; i++) {
+		struct page_pool *page_pool = pp->rxqs[i].page_pool;
+		struct page_pool_stats pp_stats = {};
+
+		if (!page_pool_get_stats(page_pool, &pp_stats))
+			continue;
+
+		stats->alloc_stats.fast += pp_stats.alloc_stats.fast;
+		stats->alloc_stats.slow += pp_stats.alloc_stats.slow;
+		stats->alloc_stats.slow_high_order +=
+			pp_stats.alloc_stats.slow_high_order;
+		stats->alloc_stats.empty += pp_stats.alloc_stats.empty;
+		stats->alloc_stats.refill += pp_stats.alloc_stats.refill;
+		stats->alloc_stats.waive += pp_stats.alloc_stats.waive;
+		stats->recycle_stats.cached += pp_stats.recycle_stats.cached;
+		stats->recycle_stats.cache_full +=
+			pp_stats.recycle_stats.cache_full;
+		stats->recycle_stats.ring += pp_stats.recycle_stats.ring;
+		stats->recycle_stats.ring_full +=
+			pp_stats.recycle_stats.ring_full;
+		stats->recycle_stats.released_refcnt +=
+			pp_stats.recycle_stats.released_refcnt;
+	}
+}
+#endif /* CONFIG_PAGE_POOL_STATS */
+
 static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 {
 	struct mvneta_ethtool_stats stats = {};
 	const struct mvneta_statistic *s;
+#ifdef CONFIG_PAGE_POOL_STATS
+	struct page_pool_stats pp_stats;
+#endif /* CONFIG_PAGE_POOL_STATS */
 	void __iomem *base = pp->base;
 	u32 high, low;
 	u64 val;
 	int i;
 
 	mvneta_ethtool_update_pcpu_stats(pp, &stats);
+#ifdef CONFIG_PAGE_POOL_STATS
+	mvneta_ethtool_update_pp_stats(pp, &pp_stats);
+#endif /* CONFIG_PAGE_POOL_STATS */
+
 	for (i = 0, s = mvneta_statistics;
 	     s < mvneta_statistics + ARRAY_SIZE(mvneta_statistics);
 	     s++, i++) {
@@ -4841,6 +4907,45 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 			case ETHTOOL_XDP_XMIT_ERR:
 				pp->ethtool_stats[i] = stats.ps.xdp_xmit_err;
 				break;
+#ifdef CONFIG_PAGE_POOL_STATS
+			case ETHTOOL_PP_ALLOC_FAST:
+				pp->ethtool_stats[i] = pp_stats.alloc_stats.fast;
+				break;
+			case ETHTOOL_PP_ALLOC_SLOW:
+				pp->ethtool_stats[i] = pp_stats.alloc_stats.slow;
+				break;
+			case ETHTOOL_PP_ALLOC_SLOW_HIGH_ORDER:
+				pp->ethtool_stats[i] =
+					pp_stats.alloc_stats.slow_high_order;
+				break;
+			case ETHTOOL_PP_ALLOC_EMPTY:
+				pp->ethtool_stats[i] = pp_stats.alloc_stats.empty;
+				break;
+			case ETHTOOL_PP_ALLOC_REFILL:
+				pp->ethtool_stats[i] = pp_stats.alloc_stats.refill;
+				break;
+			case ETHTOOL_PP_ALLOC_WAIVE:
+				pp->ethtool_stats[i] = pp_stats.alloc_stats.waive;
+				break;
+			case ETHTOOL_PP_RECYCLE_CACHED:
+				pp->ethtool_stats[i] = pp_stats.recycle_stats.cached;
+				break;
+			case ETHTOOL_PP_RECYCLE_CACHE_FULL:
+				pp->ethtool_stats[i] =
+					pp_stats.recycle_stats.cache_full;
+				break;
+			case ETHTOOL_PP_RECYCLE_RING:
+				pp->ethtool_stats[i] = pp_stats.recycle_stats.ring;
+				break;
+			case ETHTOOL_PP_RECYCLE_RING_FULL:
+				pp->ethtool_stats[i] =
+					pp_stats.recycle_stats.ring_full;
+				break;
+			case ETHTOOL_PP_RECYCLE_RELEASED_REF:
+				pp->ethtool_stats[i] =
+					pp_stats.recycle_stats.released_refcnt;
+				break;
+#endif /* CONFIG_PAGE_POOL_STATS */
 			}
 			break;
 		}
-- 
2.35.1

