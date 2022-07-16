Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD651576C5F
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 09:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiGPHfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 03:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiGPHfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 03:35:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613FF4A805
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 00:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF149609FE
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 07:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC532C3411C;
        Sat, 16 Jul 2022 07:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657956907;
        bh=7OpGJ3ShzgdHVf9A3CxHwSqBqO4HxHrg3gyyVyOKpI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHhW0PTElwSL1r5uYA5oCMyJK8jotmyM2w3jkc2xZ/4XC/NLBetZUwDtiLq0ZVkW8
         azPPJYso8DXQ9UCAQhicrYjA7Fqf+f/wXYazjyB0wcYNX742z3Hmfmw5LgiCHnAUD0
         vAoKn72/YeBCvocoJxoQUoZxaVjeEo1Vlnc6qosAuS9a4xeCZgukZBDLkU5pzhMYxP
         DBFesFyxF7HPWPWSq1PNILUrdR4ZL5Kn/Cr5LV2TJZQ3+xzEqEQ5ps2S0povr1FnRG
         WR1C2Kwb/ovW3jfstgiIIoQdNWnG6vD4/lt3oTqJqmCNgyWoe9eIi3HpGQV50ip5tJ
         woAdsrmNbHUjA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH v3 net-next 5/5] net: ethernet: mtk_eth_soc: add support for page_pool_get_stats
Date:   Sat, 16 Jul 2022 09:34:31 +0200
Message-Id: <8592ada26b28995d038ef67f15c145b6cebf4165.1657956652.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657956652.git.lorenzo@kernel.org>
References: <cover.1657956652.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce support for the page_pool stats API into mtk_eth_soc driver.
Report page_pool stats through ethtool.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/Kconfig       |  1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 40 +++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index d2422c7b31b0..97374fb3ee79 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -18,6 +18,7 @@ config NET_MEDIATEK_SOC
 	select PHYLINK
 	select DIMLIB
 	select PAGE_POOL
+	select PAGE_POOL_STATS
 	help
 	  This driver supports the gigabit ethernet MACs in the
 	  MediaTek SoC family.
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index abb8bc281015..eba95a86086d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3517,11 +3517,19 @@ static void mtk_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 	int i;
 
 	switch (stringset) {
-	case ETH_SS_STATS:
+	case ETH_SS_STATS: {
+		struct mtk_mac *mac = netdev_priv(dev);
+		struct mtk_eth *eth = mac->hw;
+
 		for (i = 0; i < ARRAY_SIZE(mtk_ethtool_stats); i++) {
 			memcpy(data, mtk_ethtool_stats[i].str, ETH_GSTRING_LEN);
 			data += ETH_GSTRING_LEN;
 		}
+		if (!eth->hwlro)
+			page_pool_ethtool_stats_get_strings(data);
+		break;
+	}
+	default:
 		break;
 	}
 }
@@ -3529,18 +3537,42 @@ static void mtk_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 static int mtk_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
-	case ETH_SS_STATS:
-		return ARRAY_SIZE(mtk_ethtool_stats);
+	case ETH_SS_STATS: {
+		int count = ARRAY_SIZE(mtk_ethtool_stats);
+		struct mtk_mac *mac = netdev_priv(dev);
+		struct mtk_eth *eth = mac->hw;
+
+		if (!eth->hwlro)
+			count += page_pool_ethtool_stats_get_count();
+		return count;
+	}
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
+static void mtk_ethtool_pp_stats(struct mtk_eth *eth, u64 *data)
+{
+	struct page_pool_stats stats = {};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(eth->rx_ring); i++) {
+		struct mtk_rx_ring *ring = &eth->rx_ring[i];
+
+		if (!ring->page_pool)
+			continue;
+
+		page_pool_get_stats(ring->page_pool, &stats);
+	}
+	page_pool_ethtool_stats_get(data, &stats);
+}
+
 static void mtk_get_ethtool_stats(struct net_device *dev,
 				  struct ethtool_stats *stats, u64 *data)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_hw_stats *hwstats = mac->hw_stats;
+	struct mtk_eth *eth = mac->hw;
 	u64 *data_src, *data_dst;
 	unsigned int start;
 	int i;
@@ -3563,6 +3595,8 @@ static void mtk_get_ethtool_stats(struct net_device *dev,
 
 		for (i = 0; i < ARRAY_SIZE(mtk_ethtool_stats); i++)
 			*data_dst++ = *(data_src + mtk_ethtool_stats[i].offset);
+		if (!eth->hwlro)
+			mtk_ethtool_pp_stats(eth, data_dst);
 	} while (u64_stats_fetch_retry_irq(&hwstats->syncp, start));
 }
 
-- 
2.36.1

