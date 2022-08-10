Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0500658E542
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiHJDN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiHJDNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9CA81B29
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:47 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zfr1TJpzXdSw;
        Wed, 10 Aug 2022 11:09:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:44 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 07/36] net: ethernet: mtk_eth_soc: replace const features initialization with NETDEV_FEATURE_SET
Date:   Wed, 10 Aug 2022 11:05:55 +0800
Message-ID: <20220810030624.34711-8-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220810030624.34711-1-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mediatek driver use netdev_features in global structure
initialization. Changed the its netdev_features_t memeber
to netdev_features_t *, and make it prefer to a netdev_features_t
global variables.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 46 +++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 12 +-----
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d9426b01f462..92c1de636128 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -161,6 +161,23 @@ static const char * const mtk_clks_source_name[] = {
 	"sgmii_ck", "eth2pll", "wocpu0", "wocpu1", "netsys0", "netsys1"
 };
 
+static DECLARE_NETDEV_FEATURE_SET(mtk_hw_feature_set,
+				  NETIF_F_IP_CSUM_BIT,
+				  NETIF_F_RXCSUM_BIT,
+				  NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				  NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_TSO_BIT,
+				  NETIF_F_TSO6_BIT,
+				  NETIF_F_IPV6_CSUM_BIT,
+				  NETIF_F_HW_TC_BIT);
+static DECLARE_NETDEV_FEATURE_SET(mtk_mt7628_hw_feature_set,
+				  NETIF_F_SG_BIT,
+				  NETIF_F_RXCSUM_BIT);
+static netdev_features_t mtk_hw_features __ro_after_init;
+static netdev_features_t mtk_mt7628_hw_features __ro_after_init;
+static netdev_features_t mtk_empty_features __ro_after_init;
+
 void mtk_w32(struct mtk_eth *eth, u32 val, unsigned reg)
 {
 	__raw_writel(val, eth->base + reg);
@@ -3362,6 +3379,14 @@ static int mtk_hw_deinit(struct mtk_eth *eth)
 	return 0;
 }
 
+static void __init mtk_features_init(void)
+{
+	netdev_features_set_array(&mtk_hw_feature_set, &mtk_hw_features);
+	netdev_features_set_array(&mtk_mt7628_hw_feature_set,
+				  &mtk_mt7628_hw_features);
+	netdev_features_zero(&mtk_empty_features);
+}
+
 static int __init mtk_init(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
@@ -3376,6 +3401,8 @@ static int __init mtk_init(struct net_device *dev)
 			dev->dev_addr);
 	}
 
+	mtk_features_init();
+
 	return 0;
 }
 
@@ -3868,13 +3895,13 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
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
@@ -4170,7 +4197,7 @@ static int mtk_remove(struct platform_device *pdev)
 static const struct mtk_soc_data mt2701_data = {
 	.reg_map = &mtk_reg_map,
 	.caps = MT7623_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 	.txrx = {
@@ -4186,7 +4213,7 @@ static const struct mtk_soc_data mt2701_data = {
 static const struct mtk_soc_data mt7621_data = {
 	.reg_map = &mtk_reg_map,
 	.caps = MT7621_CAPS,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
@@ -4204,7 +4231,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.reg_map = &mtk_reg_map,
 	.ana_rgc3 = 0x2028,
 	.caps = MT7622_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7622_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
@@ -4221,7 +4248,7 @@ static const struct mtk_soc_data mt7622_data = {
 static const struct mtk_soc_data mt7623_data = {
 	.reg_map = &mtk_reg_map,
 	.caps = MT7623_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 	.offload_version = 2,
@@ -4239,7 +4266,7 @@ static const struct mtk_soc_data mt7629_data = {
 	.reg_map = &mtk_reg_map,
 	.ana_rgc3 = 0x128,
 	.caps = MT7629_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = &mtk_hw_features,
 	.required_clks = MT7629_CLKS_BITMAP,
 	.required_pctl = false,
 	.txrx = {
@@ -4256,6 +4283,7 @@ static const struct mtk_soc_data mt7986_data = {
 	.reg_map = &mt7986_reg_map,
 	.ana_rgc3 = 0x128,
 	.caps = MT7986_CAPS,
+	.hw_features = &mtk_empty_features,
 	.required_clks = MT7986_CLKS_BITMAP,
 	.required_pctl = false,
 	.txrx = {
@@ -4271,7 +4299,7 @@ static const struct mtk_soc_data mt7986_data = {
 static const struct mtk_soc_data rt5350_data = {
 	.reg_map = &mt7628_reg_map,
 	.caps = MT7628_CAPS,
-	.hw_features = MTK_HW_FEATURES_MT7628,
+	.hw_features = &mtk_mt7628_hw_features,
 	.required_clks = MT7628_CLKS_BITMAP,
 	.required_pctl = false,
 	.txrx = {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 7405c97cda66..9620240885aa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -11,6 +11,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
@@ -977,7 +969,7 @@ struct mtk_soc_data {
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

