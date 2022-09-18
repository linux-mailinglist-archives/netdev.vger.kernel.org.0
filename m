Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58C85BBCF0
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiIRJuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiIRJty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4629B11C31
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjb854w5zMmxs;
        Sun, 18 Sep 2022 17:45:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:47 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 07/55] net: ethernet: mtk_eth_soc: replace const features initialization with NETDEV_FEATURE_SET
Date:   Sun, 18 Sep 2022 09:42:48 +0000
Message-ID: <20220918094336.28958-8-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mediatek driver use netdev features in global structure
initialization. Changed the netdev_features_t memeber to
netdev_features_t *, and make it refer to a global constant
netdev_features_t variable.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 43 ++++++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 12 +-----
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c19c67a480ae..1e1d08248664 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -161,6 +161,10 @@ static const char * const mtk_clks_source_name[] = {
 	"sgmii_ck", "eth2pll", "wocpu0", "wocpu1", "netsys0", "netsys1"
 };
 
+static netdev_features_t mtk_hw_features __ro_after_init;
+static netdev_features_t mtk_mt7628_hw_features __ro_after_init;
+static netdev_features_t mtk_empty_features __ro_after_init;
+
 void mtk_w32(struct mtk_eth *eth, u32 val, unsigned reg)
 {
 	__raw_writel(val, eth->base + reg);
@@ -3366,6 +3370,24 @@ static int mtk_hw_deinit(struct mtk_eth *eth)
 	return 0;
 }
 
+static void __init mtk_features_init(void)
+{
+	netdev_features_set_set(mtk_hw_features,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_HW_TC_BIT);
+	netdev_features_set_set(mtk_mt7628_hw_features,
+				NETIF_F_SG_BIT,
+				NETIF_F_RXCSUM_BIT);
+	netdev_features_zero(mtk_empty_features);
+}
+
 static int __init mtk_init(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
@@ -3380,6 +3402,8 @@ static int __init mtk_init(struct net_device *dev)
 			dev->dev_addr);
 	}
 
+	mtk_features_init();
+
 	return 0;
 }
 
@@ -3872,13 +3896,13 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	eth->netdev[id]->netdev_ops = &mtk_netdev_ops;
 	eth->netdev[id]->base_addr = (unsigned long)eth->base;
 
-	eth->netdev[id]->hw_features = eth->soc->hw_features;
+	eth->netdev[id]->hw_features = *eth->soc->hw_features;
 	if (eth->hwlro)
 		eth->netdev[id]->hw_features |= NETIF_F_LRO;
 
-	eth->netdev[id]->vlan_features = eth->soc->hw_features &
+	eth->netdev[id]->vlan_features = *eth->soc->hw_features &
 		~(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
-	eth->netdev[id]->features |= eth->soc->hw_features;
+	eth->netdev[id]->features |= *eth->soc->hw_features;
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
 	eth->netdev[id]->irq = eth->irq[0];
@@ -4174,7 +4198,7 @@ static int mtk_remove(struct platform_device *pdev)
 static const struct mtk_soc_data mt2701_data = {
 	.reg_map = &mtk_reg_map,
 	.caps = MT7623_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 	.txrx = {
@@ -4190,7 +4214,7 @@ static const struct mtk_soc_data mt2701_data = {
 static const struct mtk_soc_data mt7621_data = {
 	.reg_map = &mtk_reg_map,
 	.caps = MT7621_CAPS,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
@@ -4208,7 +4232,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.reg_map = &mtk_reg_map,
 	.ana_rgc3 = 0x2028,
 	.caps = MT7622_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7622_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
@@ -4225,7 +4249,7 @@ static const struct mtk_soc_data mt7622_data = {
 static const struct mtk_soc_data mt7623_data = {
 	.reg_map = &mtk_reg_map,
 	.caps = MT7623_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 	.offload_version = 2,
@@ -4243,7 +4267,7 @@ static const struct mtk_soc_data mt7629_data = {
 	.reg_map = &mtk_reg_map,
 	.ana_rgc3 = 0x128,
 	.caps = MT7629_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7629_CLKS_BITMAP,
 	.required_pctl = false,
 	.txrx = {
@@ -4260,6 +4284,7 @@ static const struct mtk_soc_data mt7986_data = {
 	.reg_map = &mt7986_reg_map,
 	.ana_rgc3 = 0x128,
 	.caps = MT7986_CAPS,
+	.hw_features = &mtk_empty_features,
 	.required_clks = MT7986_CLKS_BITMAP,
 	.required_pctl = false,
 	.txrx = {
@@ -4275,7 +4300,7 @@ static const struct mtk_soc_data mt7986_data = {
 static const struct mtk_soc_data rt5350_data = {
 	.reg_map = &mt7628_reg_map,
 	.caps = MT7628_CAPS,
-	.hw_features = MTK_HW_FEATURES_MT7628,
+	.hw_features = &mtk_mt7628_hw_features,
 	.required_clks = MT7628_CLKS_BITMAP,
 	.required_pctl = false,
 	.txrx = {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index ecf85e9ed824..10389a7debc0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -11,6 +11,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of_net.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/refcount.h>
@@ -40,15 +41,6 @@
 				 NETIF_MSG_IFUP | \
 				 NETIF_MSG_RX_ERR | \
 				 NETIF_MSG_TX_ERR)
-#define MTK_HW_FEATURES		(NETIF_F_IP_CSUM | \
-				 NETIF_F_RXCSUM | \
-				 NETIF_F_HW_VLAN_CTAG_TX | \
-				 NETIF_F_HW_VLAN_CTAG_RX | \
-				 NETIF_F_SG | NETIF_F_TSO | \
-				 NETIF_F_TSO6 | \
-				 NETIF_F_IPV6_CSUM |\
-				 NETIF_F_HW_TC)
-#define MTK_HW_FEATURES_MT7628	(NETIF_F_SG | NETIF_F_RXCSUM)
 #define NEXT_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
 
 #define MTK_PP_HEADROOM		XDP_PACKET_HEADROOM
@@ -982,7 +974,7 @@ struct mtk_soc_data {
 	u32		required_clks;
 	bool		required_pctl;
 	u8		offload_version;
-	netdev_features_t hw_features;
+	const netdev_features_t *hw_features;
 	struct {
 		u32	txd_size;
 		u32	rxd_size;
-- 
2.33.0

