Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429E241C965
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346217AbhI2QDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:43 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13839 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345587AbhI2QAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:02 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWd1N5rz8yrX;
        Wed, 29 Sep 2021 23:53:33 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:11 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 106/167] net: mediatek: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:33 +0800
Message-ID: <20210929155334.12454-107-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Changes the type of "hw_features" of struct mtk_soc_data to "u64",
for it is initialized in the variable definition stage, avoid
compile issue when change the type of "netdev_features_t" to
"unsigned long *".

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 62 +++++++++++++--------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 +-
 2 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6a6ef1c29657..bc944937645c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1348,7 +1348,8 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			skb_set_hash(skb, hash, PKT_HASH_TYPE_L4);
 		}
 
-		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX &&
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    netdev->features) &&
 		    (trxd.rxd2 & RX_DMA_VTAG))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 					       RX_DMA_VID(trxd.rxd3));
@@ -2024,14 +2025,14 @@ static int mtk_hwlro_get_fdir_all(struct net_device *dev,
 static void mtk_fix_features(struct net_device *dev,
 			     netdev_features_t *features)
 {
-	if (!(*features & NETIF_F_LRO)) {
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, *features)) {
 		struct mtk_mac *mac = netdev_priv(dev);
 		int ip_cnt = mtk_hwlro_get_ip_cnt(mac);
 
 		if (ip_cnt) {
 			netdev_info(dev, "RX flow is programmed, LRO should keep on\n");
 
-			*features |= NETIF_F_LRO;
+			netdev_feature_set_bit(NETIF_F_LRO_BIT, features);
 		}
 	}
 }
@@ -2040,10 +2041,11 @@ static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 {
 	int err = 0;
 
-	if (!((dev->features ^ features) & NETIF_F_LRO))
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features) ==
+	    netdev_feature_test_bit(NETIF_F_LRO_BIT, features))
 		return 0;
 
-	if (!(features & NETIF_F_LRO))
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, features))
 		mtk_hwlro_netdev_disable(dev);
 
 	return err;
@@ -2859,13 +2861,15 @@ static int mtk_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
-		if (dev->hw_features & NETIF_F_LRO) {
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT,
+					    dev->hw_features)) {
 			cmd->data = MTK_MAX_RX_RING_NUM;
 			ret = 0;
 		}
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
-		if (dev->hw_features & NETIF_F_LRO) {
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT,
+					    dev->hw_features)) {
 			struct mtk_mac *mac = netdev_priv(dev);
 
 			cmd->rule_cnt = mac->hwlro_ip_cnt;
@@ -2873,11 +2877,13 @@ static int mtk_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 		}
 		break;
 	case ETHTOOL_GRXCLSRULE:
-		if (dev->hw_features & NETIF_F_LRO)
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT,
+					    dev->hw_features))
 			ret = mtk_hwlro_get_fdir_entry(dev, cmd);
 		break;
 	case ETHTOOL_GRXCLSRLALL:
-		if (dev->hw_features & NETIF_F_LRO)
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT,
+					    dev->hw_features))
 			ret = mtk_hwlro_get_fdir_all(dev, cmd,
 						     rule_locs);
 		break;
@@ -2894,11 +2900,13 @@ static int mtk_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 
 	switch (cmd->cmd) {
 	case ETHTOOL_SRXCLSRLINS:
-		if (dev->hw_features & NETIF_F_LRO)
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT,
+					    dev->hw_features))
 			ret = mtk_hwlro_add_ipaddr(dev, cmd);
 		break;
 	case ETHTOOL_SRXCLSRLDEL:
-		if (dev->hw_features & NETIF_F_LRO)
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT,
+					    dev->hw_features))
 			ret = mtk_hwlro_del_ipaddr(dev, cmd);
 		break;
 	default:
@@ -3023,13 +3031,21 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	eth->netdev[id]->netdev_ops = &mtk_netdev_ops;
 	eth->netdev[id]->base_addr = (unsigned long)eth->base;
 
-	eth->netdev[id]->hw_features = eth->soc->hw_features;
+	netdev_feature_zero(&eth->netdev[id]->hw_features);
+	netdev_feature_set_bits(eth->soc->hw_features[0],
+				&eth->netdev[id]->hw_features);
 	if (eth->hwlro)
-		eth->netdev[id]->hw_features |= NETIF_F_LRO;
-
-	eth->netdev[id]->vlan_features = eth->soc->hw_features &
-		~(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
-	eth->netdev[id]->features |= eth->soc->hw_features;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT,
+				       &eth->netdev[id]->hw_features);
+
+	netdev_feature_zero(&eth->netdev[id]->vlan_features);
+	netdev_feature_set_bits(eth->soc->hw_features[0],
+				&eth->netdev[id]->vlan_features);
+	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				  NETIF_F_HW_VLAN_CTAG_RX,
+				  &eth->netdev[id]->vlan_features);
+	netdev_feature_set_bits(eth->soc->hw_features[0],
+				&eth->netdev[id]->features);
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
 	eth->netdev[id]->irq = eth->irq[0];
@@ -3279,14 +3295,14 @@ static int mtk_remove(struct platform_device *pdev)
 
 static const struct mtk_soc_data mt2701_data = {
 	.caps = MT7623_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = { MTK_HW_FEATURES },
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 };
 
 static const struct mtk_soc_data mt7621_data = {
 	.caps = MT7621_CAPS,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = { MTK_HW_FEATURES },
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
@@ -3295,7 +3311,7 @@ static const struct mtk_soc_data mt7621_data = {
 static const struct mtk_soc_data mt7622_data = {
 	.ana_rgc3 = 0x2028,
 	.caps = MT7622_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = { MTK_HW_FEATURES },
 	.required_clks = MT7622_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
@@ -3303,7 +3319,7 @@ static const struct mtk_soc_data mt7622_data = {
 
 static const struct mtk_soc_data mt7623_data = {
 	.caps = MT7623_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = { MTK_HW_FEATURES },
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 	.offload_version = 2,
@@ -3312,14 +3328,14 @@ static const struct mtk_soc_data mt7623_data = {
 static const struct mtk_soc_data mt7629_data = {
 	.ana_rgc3 = 0x128,
 	.caps = MT7629_CAPS | MTK_HWLRO,
-	.hw_features = MTK_HW_FEATURES,
+	.hw_features = { MTK_HW_FEATURES },
 	.required_clks = MT7629_CLKS_BITMAP,
 	.required_pctl = false,
 };
 
 static const struct mtk_soc_data rt5350_data = {
 	.caps = MT7628_CAPS,
-	.hw_features = MTK_HW_FEATURES_MT7628,
+	.hw_features = { MTK_HW_FEATURES_MT7628 },
 	.required_clks = MT7628_CLKS_BITMAP,
 	.required_pctl = false,
 };
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 5ef70dd8b49c..271d595a1665 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -844,7 +844,7 @@ struct mtk_soc_data {
 	u32		required_clks;
 	bool		required_pctl;
 	u8		offload_version;
-	netdev_features_t hw_features;
+	u64		hw_features[NETDEV_FEATURE_DWORDS];
 };
 
 /* currently no SoC has more than 2 macs */
-- 
2.33.0

