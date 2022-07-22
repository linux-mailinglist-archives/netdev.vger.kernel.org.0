Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4D057DB31
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 09:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiGVHWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 03:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbiGVHWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 03:22:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C42220C1
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF70EB827A1
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 07:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0B9C341C6;
        Fri, 22 Jul 2022 07:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658474562;
        bh=CnYkj1Ii7nMMi7fZxhtZxbEj7WgtArU1b5/mp8OWqGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a70lAY6XQLqHg2aG7Fkzt8v1FTX9zLHzNgjDlriEXee+rQLAA31RXZTZ/sTvHNFTn
         SSj2GGuMrIEcR9XAS6mYLc4pAWlBSGAA3b3UBKHdxVUmNO6u+nuZ+YAIoUG9TnRRjH
         FcsBn6qh4AF5srqSqsatxxl8CIuu9hjxqsFrJTc/1mwQuYvGh/5uXJwk0+CtFCuY9b
         +YxCj26M6Hb3o5vvYfz1OgvcwaOIjIjoEDtz7cSXSmDcttEJXJ2MktyUSgsbr3cQVq
         a92rRLQSUFBMIYopacnJyC55aX8kguYDojSkwnQiYrMqWzi1XzoXPGrQOei8rk1yUU
         gi5bPFSrQTDGw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH v4 net-next 5/5] net: ethernet: mtk_eth_soc: add support for page_pool_get_stats
Date:   Fri, 22 Jul 2022 09:19:40 +0200
Message-Id: <a92b8f4b901bb7b8b1e3abdc2dd3d09de7d2c96c.1658474059.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1658474059.git.lorenzo@kernel.org>
References: <cover.1658474059.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 37 +++++++++++++++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

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
index cfbdcf68f9b9..c370d6589596 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3528,11 +3528,18 @@ static void mtk_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 	int i;
 
 	switch (stringset) {
-	case ETH_SS_STATS:
+	case ETH_SS_STATS: {
+		struct mtk_mac *mac = netdev_priv(dev);
+
 		for (i = 0; i < ARRAY_SIZE(mtk_ethtool_stats); i++) {
 			memcpy(data, mtk_ethtool_stats[i].str, ETH_GSTRING_LEN);
 			data += ETH_GSTRING_LEN;
 		}
+		if (mtk_page_pool_enabled(mac->hw))
+			page_pool_ethtool_stats_get_strings(data);
+		break;
+	}
+	default:
 		break;
 	}
 }
@@ -3540,13 +3547,35 @@ static void mtk_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 static int mtk_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
-	case ETH_SS_STATS:
-		return ARRAY_SIZE(mtk_ethtool_stats);
+	case ETH_SS_STATS: {
+		int count = ARRAY_SIZE(mtk_ethtool_stats);
+		struct mtk_mac *mac = netdev_priv(dev);
+
+		if (mtk_page_pool_enabled(mac->hw))
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
@@ -3574,6 +3603,8 @@ static void mtk_get_ethtool_stats(struct net_device *dev,
 
 		for (i = 0; i < ARRAY_SIZE(mtk_ethtool_stats); i++)
 			*data_dst++ = *(data_src + mtk_ethtool_stats[i].offset);
+		if (mtk_page_pool_enabled(mac->hw))
+			mtk_ethtool_pp_stats(mac->hw, data_dst);
 	} while (u64_stats_fetch_retry_irq(&hwstats->syncp, start));
 }
 
-- 
2.36.1

