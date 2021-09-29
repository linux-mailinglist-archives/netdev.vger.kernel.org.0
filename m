Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC3A41C973
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345898AbhI2QFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:25 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23245 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345638AbhI2QAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:06 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLc073YBz8tY4;
        Wed, 29 Sep 2021 23:57:20 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:13 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:13 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 116/167] net: stmmac: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:43 +0800
Message-ID: <20210929155334.12454-117-shenjian15@huawei.com>
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

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 56 ++++++++++++-------
 .../stmicro/stmmac/stmmac_selftests.c         |  6 +-
 3 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index b21745368983..3d0028f78577 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -712,7 +712,8 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	}
 
 	/* VLAN filtering */
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    dev->features))
 		value |= GMAC_PACKET_FILTER_VTFE;
 
 	writel(value, ioaddr + GMAC_PACKET_FILTER);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index aa977cac3c10..b3e9c9d52096 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3101,7 +3101,7 @@ static void stmmac_mac_config_rss(struct stmmac_priv *priv)
 		return;
 	}
 
-	if (priv->dev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, priv->dev->features))
 		priv->rss.enable = true;
 	else
 		priv->rss.enable = false;
@@ -4415,9 +4415,11 @@ static void stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
 	vlan_proto = veth->h_vlan_proto;
 
 	if ((vlan_proto == htons(ETH_P_8021Q) &&
-	     dev->features & NETIF_F_HW_VLAN_CTAG_RX) ||
+	     netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				     dev->features)) ||
 	    (vlan_proto == htons(ETH_P_8021AD) &&
-	     dev->features & NETIF_F_HW_VLAN_STAG_RX)) {
+	     netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_RX_BIT,
+				     dev->features))) {
 		/* pop the vlan tag */
 		vlanid = ntohs(veth->h_vlan_TCI);
 		memmove(skb->data + VLAN_HLEN, veth, ETH_ALEN * 2);
@@ -5467,10 +5469,10 @@ static void stmmac_fix_features(struct net_device *dev,
 	struct stmmac_priv *priv = netdev_priv(dev);
 
 	if (priv->plat->rx_coe == STMMAC_RX_COE_NONE)
-		*features &= ~NETIF_F_RXCSUM;
+		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, features);
 
 	if (!priv->plat->tx_coe)
-		*features &= ~NETIF_F_CSUM_MASK;
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, features);
 
 	/* Some GMAC devices have a bugged Jumbo frame support that
 	 * needs to have the Tx COE disabled for oversized frames
@@ -5478,11 +5480,11 @@ static void stmmac_fix_features(struct net_device *dev,
 	 * the TX csum insertion in the TDES and not use SF.
 	 */
 	if (priv->plat->bugged_jumbo && (dev->mtu > ETH_DATA_LEN))
-		*features &= ~NETIF_F_CSUM_MASK;
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, features);
 
 	/* Disable tso if asked by ethtool */
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
-		if (*features & NETIF_F_TSO)
+		if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *features))
 			priv->tso = true;
 		else
 			priv->tso = false;
@@ -5497,7 +5499,7 @@ static int stmmac_set_features(struct net_device *netdev,
 	u32 chan;
 
 	/* Keep the COE Type in case of csum is supporting */
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		priv->hw->rx_csum = priv->plat->rx_coe;
 	else
 		priv->hw->rx_csum = 0;
@@ -6867,24 +6869,28 @@ int stmmac_dvr_probe(struct device *device,
 
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			    NETIF_F_RXCSUM;
+	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM,
+				&ndev->hw_features);
 
 	ret = stmmac_tc_init(priv, priv);
 	if (!ret) {
-		ndev->hw_features |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &ndev->hw_features);
 	}
 
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
-		ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					&ndev->hw_features);
 		if (priv->plat->has_gmac4)
-			ndev->hw_features |= NETIF_F_GSO_UDP_L4;
+			netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT,
+					       &ndev->hw_features);
 		priv->tso = true;
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
 
 	if (priv->dma_cap.sphen) {
-		ndev->hw_features |= NETIF_F_GRO;
+		netdev_feature_set_bit(NETIF_F_GRO_BIT, &ndev->hw_features);
 		priv->sph_cap = true;
 		priv->sph = priv->sph_cap;
 		dev_info(priv->device, "SPH feature enabled\n");
@@ -6922,19 +6928,27 @@ int stmmac_dvr_probe(struct device *device,
 		}
 	}
 
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
+	netdev_feature_or(&ndev->features, ndev->features,
+			  ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
 	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_STAG_RX,
+				&ndev->features);
 	if (priv->dma_cap.vlhash) {
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-		ndev->features |= NETIF_F_HW_VLAN_STAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &ndev->features);
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+				       &ndev->features);
 	}
 	if (priv->dma_cap.vlins) {
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       &ndev->features);
 		if (priv->dma_cap.dvlan)
-			ndev->features |= NETIF_F_HW_VLAN_STAG_TX;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
+					       &ndev->features);
 	}
 #endif
 	priv->msg_enable = netif_msg_init(debug, default_msg_level);
@@ -6946,7 +6960,7 @@ int stmmac_dvr_probe(struct device *device,
 		priv->rss.table[i] = ethtool_rxfh_indir_default(i, rxq);
 
 	if (priv->dma_cap.rssen && priv->plat->rss_en)
-		ndev->features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->features);
 
 	/* MTU range: 46 - hw-specific max */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 0462dcc93e53..606405243f09 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -974,7 +974,8 @@ static int stmmac_test_vlanfilt_perfect(struct stmmac_priv *priv)
 {
 	int ret, prev_cap = priv->dma_cap.vlhash;
 
-	if (!(priv->dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				     priv->dev->features))
 		return -EOPNOTSUPP;
 
 	priv->dma_cap.vlhash = 0;
@@ -1068,7 +1069,8 @@ static int stmmac_test_dvlanfilt_perfect(struct stmmac_priv *priv)
 {
 	int ret, prev_cap = priv->dma_cap.vlhash;
 
-	if (!(priv->dev->features & NETIF_F_HW_VLAN_STAG_FILTER))
+	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+				     priv->dev->features))
 		return -EOPNOTSUPP;
 
 	priv->dma_cap.vlhash = 0;
-- 
2.33.0

