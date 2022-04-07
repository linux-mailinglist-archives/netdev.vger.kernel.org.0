Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D404F8556
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242813AbiDGQ5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345252AbiDGQ5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:57:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D425FA20F
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F513B82795
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 16:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A494EC385A5;
        Thu,  7 Apr 2022 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649350535;
        bh=K9ltJCNwpm/a6Cxg4cn09//zPGGUtCHIt8Duu/Kwh+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duPtLMAZUkI8O3hbtOuTeyKwvu+ihuXa3PNL5xZ30fNQ2yY5ku/tjUZ0dT+CIEguS
         zWFlQ8/rGi8OyWhk2x1GuzJsqjEgtuROTONhQh8oHK5St6WRHkzsj2SGF0R43rbFvU
         cMQypCDzsshl9+G0fkcfInoa5dst729ro70mfAiWQwoF2kDzCwoElLRJICEpqrJrGB
         QacsK+jH2gybpEvjfyN3eI93x20SD7sg2UdWN97LhFSF2axrLv5R/nX33pFOvD3CBS
         LlqJj5c03cS0Gz3dO7avQv1KlV/avRv8+9N3A/I1hfkT2vlvJ3Tv5RUzRwrff0BVvM
         +SWz6BZX7zihQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [RFC net-next 2/2] net: mvneta: add support for page_pool_get_stats
Date:   Thu,  7 Apr 2022 18:55:05 +0200
Message-Id: <cd1bb62e5efe9d151fe96a5224add25122f5044a.1649350165.git.lorenzo@kernel.org>
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

Introduce support for the page_pool_get_stats API to mvneta driver.
Report page_pool stats through ethtool.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/Kconfig  |  1 +
 drivers/net/ethernet/marvell/mvneta.c | 59 ++++++++++++++++++++++++---
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index fe0989c0fc25..1240cb2dc07f 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -62,6 +62,7 @@ config MVNETA
 	select MVMDIO
 	select PHYLINK
 	select PAGE_POOL
+	select PAGE_POOL_STATS
 	help
 	  This driver supports the network interface units in the
 	  Marvell ARMADA XP, ARMADA 370, ARMADA 38x and
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 934f6dd90992..9864ea09e887 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -540,7 +540,7 @@ struct mvneta_port {
 	bool eee_active;
 	bool tx_lpi_enabled;
 
-	u64 ethtool_stats[ARRAY_SIZE(mvneta_statistics)];
+	u64 *ethtool_stats;
 
 	u32 indir[MVNETA_RSS_LU_TABLE_SIZE];
 
@@ -4732,9 +4732,13 @@ static void mvneta_ethtool_get_strings(struct net_device *netdev, u32 sset,
 	if (sset == ETH_SS_STATS) {
 		int i;
 
-		for (i = 0; i < ARRAY_SIZE(mvneta_statistics); i++)
-			memcpy(data + i * ETH_GSTRING_LEN,
-			       mvneta_statistics[i].name, ETH_GSTRING_LEN);
+		for (i = 0; i < ARRAY_SIZE(mvneta_statistics); i++) {
+			memcpy(data, mvneta_statistics[i].name,
+			       ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		}
+
+		page_pool_ethtool_stats_get_strings(data);
 	}
 }
 
@@ -4847,6 +4851,38 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 	}
 }
 
+static void mvneta_ethtool_pp_stats(struct mvneta_port *pp, u64 *data)
+{
+	struct page_pool_stats stats = {};
+	int i;
+
+	for (i = 0; i < rxq_number; i++) {
+		struct page_pool *page_pool = pp->rxqs[i].page_pool;
+		struct page_pool_stats pp_stats = {};
+
+		if (!page_pool_get_stats(page_pool, &pp_stats))
+			continue;
+
+		stats.alloc_stats.fast += pp_stats.alloc_stats.fast;
+		stats.alloc_stats.slow += pp_stats.alloc_stats.slow;
+		stats.alloc_stats.slow_high_order +=
+			pp_stats.alloc_stats.slow_high_order;
+		stats.alloc_stats.empty += pp_stats.alloc_stats.empty;
+		stats.alloc_stats.refill += pp_stats.alloc_stats.refill;
+		stats.alloc_stats.waive += pp_stats.alloc_stats.waive;
+		stats.recycle_stats.cached += pp_stats.recycle_stats.cached;
+		stats.recycle_stats.cache_full +=
+			pp_stats.recycle_stats.cache_full;
+		stats.recycle_stats.ring += pp_stats.recycle_stats.ring;
+		stats.recycle_stats.ring_full +=
+			pp_stats.recycle_stats.ring_full;
+		stats.recycle_stats.released_refcnt +=
+			pp_stats.recycle_stats.released_refcnt;
+	}
+
+	page_pool_ethtool_stats_get(data, &stats);
+}
+
 static void mvneta_ethtool_get_stats(struct net_device *dev,
 				     struct ethtool_stats *stats, u64 *data)
 {
@@ -4857,12 +4893,16 @@ static void mvneta_ethtool_get_stats(struct net_device *dev,
 
 	for (i = 0; i < ARRAY_SIZE(mvneta_statistics); i++)
 		*data++ = pp->ethtool_stats[i];
+
+	mvneta_ethtool_pp_stats(pp, data);
 }
 
 static int mvneta_ethtool_get_sset_count(struct net_device *dev, int sset)
 {
 	if (sset == ETH_SS_STATS)
-		return ARRAY_SIZE(mvneta_statistics);
+		return ARRAY_SIZE(mvneta_statistics) +
+		       page_pool_ethtool_stats_get_count();
+
 	return -EOPNOTSUPP;
 }
 
@@ -5372,6 +5412,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	phy_interface_t phy_mode;
 	const char *mac_from;
 	int tx_csum_limit;
+	int stats_len;
 	int err;
 	int cpu;
 
@@ -5392,6 +5433,14 @@ static int mvneta_probe(struct platform_device *pdev)
 	pp->rxq_def = rxq_def;
 	pp->indir[0] = rxq_def;
 
+	stats_len = ARRAY_SIZE(mvneta_statistics) +
+		    page_pool_ethtool_stats_get_count();
+	pp->ethtool_stats = devm_kzalloc(&pdev->dev,
+					 sizeof(*pp->ethtool_stats) * stats_len,
+					 GFP_KERNEL);
+	if (!pp->ethtool_stats)
+		return -ENOMEM;
+
 	err = of_get_phy_mode(dn, &phy_mode);
 	if (err) {
 		dev_err(&pdev->dev, "incorrect phy-mode\n");
-- 
2.35.1

