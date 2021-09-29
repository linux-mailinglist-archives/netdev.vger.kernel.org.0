Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F1741C93F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345918AbhI2QC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12992 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344278AbhI2P76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:58 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbT2mSVzWYZx;
        Wed, 29 Sep 2021 23:56:53 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 113/167] net: renesas: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:40 +0800
Message-ID: <20210929155334.12454-114-shenjian15@huawei.com>
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
 drivers/net/ethernet/renesas/ravb.h      |  4 ++--
 drivers/net/ethernet/renesas/ravb_main.c | 24 +++++++++++++-------
 drivers/net/ethernet/renesas/sh_eth.c    | 28 ++++++++++++++++--------
 3 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 47c5377e4f42..61668a2a5296 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -990,8 +990,8 @@ struct ravb_hw_info {
 	void (*emac_init)(struct net_device *ndev);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
-	netdev_features_t net_hw_features;
-	netdev_features_t net_features;
+	u64 net_hw_features;
+	u64 net_features;
 	int stats_len;
 	size_t max_rx_len;
 	unsigned aligned_tx: 1;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f85f2d97b18..6f3574494a8e 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -433,7 +433,8 @@ static void ravb_rcar_emac_init(struct net_device *ndev)
 
 	/* EMAC Mode: PAUSE prohibition; Duplex; RX Checksum; TX; RX */
 	ravb_write(ndev, ECMR_ZPF | ECMR_DM |
-		   (ndev->features & NETIF_F_RXCSUM ? ECMR_RCSC : 0) |
+		   (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    ndev->features) ? ECMR_RCSC : 0) |
 		   ECMR_TE | ECMR_RE, ECMR);
 
 	ravb_set_rate(ndev);
@@ -649,7 +650,8 @@ static bool ravb_rcar_rx(struct net_device *ndev, int *quota, int q)
 
 			skb_put(skb, pkt_len);
 			skb->protocol = eth_type_trans(skb, ndev);
-			if (ndev->features & NETIF_F_RXCSUM)
+			if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						    ndev->features))
 				ravb_rx_csum(skb);
 			napi_gro_receive(&priv->napi[q], skb);
 			stats->rx_packets++;
@@ -1921,12 +1923,16 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 static int ravb_set_features_rx_csum(struct net_device *ndev,
 				     netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_RXCSUM)
-		ravb_set_rx_csum(ndev, features & NETIF_F_RXCSUM);
+	netdev_feature_xor(&changed, ndev->features, features);
 
-	ndev->features = features;
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed))
+		ravb_set_rx_csum(ndev,
+				 netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+							 features));
+
+	netdev_feature_copy(&ndev->features, features);
 
 	return 0;
 }
@@ -2166,8 +2172,10 @@ static int ravb_probe(struct platform_device *pdev)
 
 	info = of_device_get_match_data(&pdev->dev);
 
-	ndev->features = info->net_features;
-	ndev->hw_features = info->net_hw_features;
+	netdev_feature_zero(&ndev->features);
+	netdev_feature_set_bits(info->net_features, &ndev->features);
+	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_set_bits(info->net_hw_features, &ndev->hw_features);
 
 	reset_control_deassert(rstc);
 	pm_runtime_enable(&pdev->dev);
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 1374faa229a2..a3cfc6283a86 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1504,7 +1504,8 @@ static int sh_eth_dev_init(struct net_device *ndev)
 
 	/* EMAC Mode: PAUSE prohibition; Duplex; RX Checksum; TX; RX */
 	sh_eth_write(ndev, ECMR_ZPF | (mdp->duplex ? ECMR_DM : 0) |
-		     (ndev->features & NETIF_F_RXCSUM ? ECMR_RCSC : 0) |
+		     (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      ndev->features) ? ECMR_RCSC : 0) |
 		     ECMR_TE | ECMR_RE, ECMR);
 
 	if (mdp->cd->set_rate)
@@ -1654,7 +1655,8 @@ static int sh_eth_rx(struct net_device *ndev, u32 intr_status, int *quota)
 					 DMA_FROM_DEVICE);
 			skb_put(skb, pkt_len);
 			skb->protocol = eth_type_trans(skb, ndev);
-			if (ndev->features & NETIF_F_RXCSUM)
+			if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						    ndev->features))
 				sh_eth_rx_csum(skb);
 			netif_receive_skb(skb);
 			ndev->stats.rx_packets++;
@@ -2931,13 +2933,18 @@ static void sh_eth_set_rx_csum(struct net_device *ndev, bool enable)
 static int sh_eth_set_features(struct net_device *ndev,
 			       netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
 	struct sh_eth_private *mdp = netdev_priv(ndev);
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_RXCSUM && mdp->cd->rx_csum)
-		sh_eth_set_rx_csum(ndev, features & NETIF_F_RXCSUM);
+	netdev_feature_xor(&changed, ndev->features, features);
 
-	ndev->features = features;
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed) &&
+	    mdp->cd->rx_csum)
+		sh_eth_set_rx_csum(ndev,
+				   netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+							   features));
+
+	netdev_feature_copy(&ndev->features, features);
 
 	return 0;
 }
@@ -3291,8 +3298,10 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	ndev->min_mtu = ETH_MIN_MTU;
 
 	if (mdp->cd->rx_csum) {
-		ndev->features = NETIF_F_RXCSUM;
-		ndev->hw_features = NETIF_F_RXCSUM;
+		netdev_feature_zero(&ndev->features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &ndev->features);
+		netdev_feature_zero(&ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &ndev->hw_features);
 	}
 
 	/* set function */
@@ -3344,7 +3353,8 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 			goto out_release;
 		}
 		mdp->port = port;
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &ndev->features);
 
 		/* Need to init only the first port of the two sharing a TSU */
 		if (port == 0) {
-- 
2.33.0

