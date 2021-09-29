Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036E341C96E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345945AbhI2QFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:10 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24145 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345636AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbS58jqz1DHFg;
        Wed, 29 Sep 2021 23:56:52 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [RFCv2 net-next 107/167] net: marvell: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:34 +0800
Message-ID: <20210929155334.12454-108-shenjian15@huawei.com>
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
 drivers/net/ethernet/marvell/mv643xx_eth.c    | 14 ++--
 drivers/net/ethernet/marvell/mvneta.c         | 16 ++--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 71 +++++++++++------
 .../marvell/octeontx2/nic/otx2_common.c       |  3 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |  4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 79 +++++++++++--------
 .../marvell/octeontx2/nic/otx2_txrx.c         |  8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  | 35 ++++----
 .../ethernet/marvell/prestera/prestera_main.c |  3 +-
 drivers/net/ethernet/marvell/skge.c           | 11 +--
 drivers/net/ethernet/marvell/sky2.c           | 68 +++++++++-------
 11 files changed, 190 insertions(+), 122 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 28d5ad296646..b14aab7f7aff 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1681,7 +1681,9 @@ static int
 mv643xx_eth_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
-	bool rx_csum = features & NETIF_F_RXCSUM;
+	bool rx_csum;
+
+	rx_csum = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features);
 
 	wrlp(mp, PORT_CONFIG, rx_csum ? 0x02000000 : 0x00000000);
 
@@ -3186,11 +3188,13 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	dev->watchdog_timeo = 2 * HZ;
 	dev->base_addr = 0;
 
-	dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
-	dev->vlan_features = dev->features;
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO,
+				&dev->features);
+	netdev_feature_copy(&dev->vlan_features, dev->features);
 
-	dev->features |= NETIF_F_RXCSUM;
-	dev->hw_features = dev->features;
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+	netdev_feature_copy(&dev->hw_features, dev->features);
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->gso_max_segs = MV643XX_MAX_TSO_SEGS;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index a4093977cd2b..58e803942a93 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1807,7 +1807,7 @@ static void mvneta_rx_error(struct mvneta_port *pp,
 /* Handle RX checksum offload based on the descriptor's status */
 static int mvneta_rx_csum(struct mvneta_port *pp, u32 status)
 {
-	if ((pp->dev->features & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, pp->dev->features) &&
 	    (status & MVNETA_RXD_L3_IP4) &&
 	    (status & MVNETA_RXD_L4_CSUM_OK))
 		return CHECKSUM_UNNECESSARY;
@@ -3776,7 +3776,8 @@ static void mvneta_fix_features(struct net_device *dev,
 	struct mvneta_port *pp = netdev_priv(dev);
 
 	if (pp->tx_csum_limit && dev->mtu > pp->tx_csum_limit) {
-		*features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
+		netdev_feature_clear_bits(NETIF_F_IP_CSUM | NETIF_F_TSO,
+					  features);
 		netdev_info(dev,
 			    "Disable IP checksum for MTU greater than %dB\n",
 			    pp->tx_csum_limit);
@@ -5339,10 +5340,13 @@ static int mvneta_probe(struct platform_device *pdev)
 		}
 	}
 
-	dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_TSO | NETIF_F_RXCSUM;
-	dev->hw_features |= dev->features;
-	dev->vlan_features |= dev->features;
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM |
+				NETIF_F_TSO | NETIF_F_RXCSUM, &dev->features);
+	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(&dev->vlan_features, dev->vlan_features,
+			  dev->features);
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	dev->gso_max_segs = MVNETA_MAX_TSO_SEGS;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d5c92e43f89e..a222a6923dcb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1265,7 +1265,10 @@ static int mvpp2_swf_bm_pool_init(struct mvpp2_port *port)
 static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 			      enum mvpp2_bm_pool_log_num new_long_pool)
 {
-	const netdev_features_t csums = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_features_t csums;
+
+	netdev_feature_zero(&csums);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM, &csums);
 
 	/* Update L4 checksum when jumbo enable/disable on port.
 	 * Only port 0 supports hardware checksum offload due to
@@ -1274,11 +1277,15 @@ static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 	 * has 7 bits, so the maximum L3 offset is 128.
 	 */
 	if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
-		port->dev->features &= ~csums;
-		port->dev->hw_features &= ~csums;
+		netdev_feature_andnot(&port->dev->features,
+				      port->dev->features, csums);
+		netdev_feature_andnot(&port->dev->hw_features,
+				      port->dev->hw_features, csums);
 	} else {
-		port->dev->features |= csums;
-		port->dev->hw_features |= csums;
+		netdev_feature_or(&port->dev->features, port->dev->features,
+				  csums);
+		netdev_feature_or(&port->dev->hw_features,
+				  port->dev->hw_features, csums);
 	}
 }
 
@@ -1340,18 +1347,25 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 
 		/* Update L4 checksum when jumbo enable/disable on port */
 		if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
-			dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-			dev->hw_features &= ~(NETIF_F_IP_CSUM |
-					      NETIF_F_IPV6_CSUM);
+			netdev_feature_clear_bits(NETIF_F_IP_CSUM |
+						  NETIF_F_IPV6_CSUM,
+						  &dev->features);
+			netdev_feature_clear_bits(NETIF_F_IP_CSUM |
+						  NETIF_F_IPV6_CSUM,
+						  &dev->hw_features);
 		} else {
-			dev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-			dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+			netdev_feature_set_bits(NETIF_F_IP_CSUM |
+						NETIF_F_IPV6_CSUM,
+						&dev->features);
+			netdev_feature_set_bits(NETIF_F_IP_CSUM |
+						NETIF_F_IPV6_CSUM,
+						&dev->hw_features);
 		}
 	}
 
 out_set:
 	dev->mtu = mtu;
-	dev->wanted_features = dev->features;
+	netdev_feature_copy(&dev->wanted_features, dev->features);
 
 	netdev_update_features(dev);
 	return 0;
@@ -4898,7 +4912,8 @@ static int mvpp2_prs_mac_da_accept_list(struct mvpp2_port *port,
 
 static void mvpp2_set_rx_promisc(struct mvpp2_port *port, bool enable)
 {
-	if (!enable && (port->dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+	if (!enable && netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					       port->dev->features))
 		mvpp2_prs_vid_enable_filtering(port);
 	else
 		mvpp2_prs_vid_disable_filtering(port);
@@ -5273,11 +5288,14 @@ static int mvpp2_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 static int mvpp2_set_features(struct net_device *dev,
 			      netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	struct mvpp2_port *port = netdev_priv(dev);
+	netdev_features_t changed;
+
+	netdev_feature_xor(&changed, dev->features, features);
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    features)) {
 			mvpp2_prs_vid_enable_filtering(port);
 		} else {
 			/* Invalidate all registered VID filters for this
@@ -5289,8 +5307,8 @@ static int mvpp2_set_features(struct net_device *dev,
 		}
 	}
 
-	if (changed & NETIF_F_RXHASH) {
-		if (features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features))
 			mvpp22_port_rss_enable(port);
 		else
 			mvpp22_port_rss_disable(port);
@@ -6915,21 +6933,24 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		}
 	}
 
-	features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		   NETIF_F_TSO;
-	dev->features = features | NETIF_F_RXCSUM;
-	dev->hw_features |= features | NETIF_F_RXCSUM | NETIF_F_GRO |
-			    NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_feature_zero(&features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM | NETIF_F_TSO, &features);
+	netdev_feature_copy(&dev->features, features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+	netdev_feature_or(&dev->hw_features, dev->hw_features, features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_GRO |
+				NETIF_F_HW_VLAN_CTAG_FILTER, &dev->hw_features);
 
 	if (mvpp22_rss_is_supported(port)) {
-		dev->hw_features |= NETIF_F_RXHASH;
-		dev->features |= NETIF_F_NTUPLE;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &dev->features);
 	}
 
 	if (!port->priv->percpu_pools)
 		mvpp2_set_hw_csum(port, port->pool_long->id);
 
-	dev->vlan_features |= features;
+	netdev_feature_or(&dev->vlan_features, dev->vlan_features, features);
 	dev->gso_max_segs = MVPP2_MAX_TSO_SEGS;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 4c3dbade8cfb..78f47a797728 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -493,7 +493,8 @@ void otx2_setup_segmentation(struct otx2_nic *pfvf)
 	mutex_unlock(&pfvf->mbox.lock);
 	netdev_info(pfvf->netdev,
 		    "Failed to get LSO index for UDP GSO offload, disabling\n");
-	pfvf->netdev->hw_features &= ~NETIF_F_GSO_UDP_L4;
+	netdev_feature_clear_bit(NETIF_F_GSO_UDP_L4_BIT,
+				 &pfvf->netdev->hw_features);
 }
 
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index b0f57bda7e27..50e809f7a624 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -650,7 +650,7 @@ static int otx2_set_rss_hash_opts(struct otx2_nic *pfvf,
 static int otx2_get_rxnfc(struct net_device *dev,
 			  struct ethtool_rxnfc *nfc, u32 *rules)
 {
-	bool ntuple = !!(dev->features & NETIF_F_NTUPLE);
+	bool ntuple = netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, dev->features);
 	struct otx2_nic *pfvf = netdev_priv(dev);
 	int ret = -EOPNOTSUPP;
 
@@ -683,7 +683,7 @@ static int otx2_get_rxnfc(struct net_device *dev,
 
 static int otx2_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *nfc)
 {
-	bool ntuple = !!(dev->features & NETIF_F_NTUPLE);
+	bool ntuple = netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, dev->features);
 	struct otx2_nic *pfvf = netdev_priv(dev);
 	int ret = -EOPNOTSUPP;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index cf4513ec02e6..c3d187a57d35 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1816,10 +1816,10 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 static void otx2_fix_features(struct net_device *dev,
 			      netdev_features_t *features)
 {
-	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
-		*features |= NETIF_F_HW_VLAN_STAG_RX;
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
 	else
-		*features &= ~NETIF_F_HW_VLAN_STAG_RX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
 }
 
 static void otx2_set_rx_mode(struct net_device *netdev)
@@ -1839,23 +1839,29 @@ static void otx2_rx_mode_wrk_handler(struct work_struct *work)
 static int otx2_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
-	bool ntuple = !!(features & NETIF_F_NTUPLE);
+	bool ntuple = netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features);
+	bool tc = netdev_feature_test_bit(NETIF_F_HW_TC_BIT, features);
 	struct otx2_nic *pf = netdev_priv(netdev);
-	bool tc = !!(features & NETIF_F_HW_TC);
+	netdev_features_t changed;
 
-	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
+	netdev_feature_xor(&changed, features, netdev->features);
+
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed) &&
+	    netif_running(netdev))
 		return otx2_cgx_config_loopback(pf,
-						features & NETIF_F_LOOPBACK);
+						netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT,
+									features));
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) && netif_running(netdev))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
+	    netif_running(netdev))
 		return otx2_enable_rxvlan(pf,
-					  features & NETIF_F_HW_VLAN_CTAG_RX);
+					  netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+								  features));
 
-	if ((changed & NETIF_F_NTUPLE) && !ntuple)
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, changed) && !ntuple)
 		otx2_destroy_ntuple_flows(pf);
 
-	if ((changed & NETIF_F_NTUPLE) && ntuple) {
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, changed) && ntuple) {
 		if (!pf->flow_cfg->max_flows) {
 			netdev_err(netdev,
 				   "Can't enable NTUPLE, MCAM entries not allocated\n");
@@ -1863,7 +1869,7 @@ static int otx2_set_features(struct net_device *netdev,
 		}
 	}
 
-	if ((changed & NETIF_F_HW_TC) && tc) {
+	if (netdev_feature_test_bit(NETIF_F_HW_TC_BIT, changed) && tc) {
 		if (!pf->flow_cfg->max_flows) {
 			netdev_err(netdev,
 				   "Can't enable TC, MCAM entries not allocated\n");
@@ -1871,21 +1877,23 @@ static int otx2_set_features(struct net_device *netdev,
 		}
 	}
 
-	if ((changed & NETIF_F_HW_TC) && !tc &&
+	if (netdev_feature_test_bit(NETIF_F_HW_TC_BIT, changed) && !tc &&
 	    pf->flow_cfg && pf->flow_cfg->nr_flows) {
 		netdev_err(netdev, "Can't disable TC hardware offload while flows are active\n");
 		return -EBUSY;
 	}
 
-	if ((changed & NETIF_F_NTUPLE) && ntuple &&
-	    (netdev->features & NETIF_F_HW_TC) && !(changed & NETIF_F_HW_TC)) {
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, changed) && ntuple &&
+	    netdev_feature_test_bit(NETIF_F_HW_TC_BIT, netdev->features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_TC_BIT, changed)) {
 		netdev_err(netdev,
 			   "Can't enable NTUPLE when TC is active, disable TC and retry\n");
 		return -EINVAL;
 	}
 
-	if ((changed & NETIF_F_HW_TC) && tc &&
-	    (netdev->features & NETIF_F_NTUPLE) && !(changed & NETIF_F_NTUPLE)) {
+	if (netdev_feature_test_bit(NETIF_F_HW_TC_BIT, changed) && tc &&
+	    netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, netdev->features) &&
+	    !netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, changed)) {
 		netdev_err(netdev,
 			   "Can't enable TC when NTUPLE is active, disable NTUPLE and retry\n");
 		return -EINVAL;
@@ -2584,36 +2592,43 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	pf->iommu_domain = iommu_get_domain_for_dev(dev);
 
-	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			       NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
-			       NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-			       NETIF_F_GSO_UDP_L4);
-	netdev->features |= netdev->hw_features;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
+				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_GSO_UDP_L4, &netdev->hw_features);
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
 
 	err = otx2_mcam_flow_init(pf);
 	if (err)
 		goto err_ptp_destroy;
 
 	if (pf->flags & OTX2_FLAG_NTUPLE_SUPPORT)
-		netdev->hw_features |= NETIF_F_NTUPLE;
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
 
 	if (pf->flags & OTX2_FLAG_UCAST_FLTR_SUPPORT)
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* Support TSO on tag interface */
-	netdev->vlan_features |= netdev->features;
-	netdev->hw_features  |= NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_STAG_TX;
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX,
+				&netdev->hw_features);
 	if (pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX |
-				       NETIF_F_HW_VLAN_STAG_RX;
-	netdev->features |= netdev->hw_features;
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
+					NETIF_F_HW_VLAN_STAG_RX,
+					&netdev->hw_features);
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
 
 	/* HW supports tc offload but mutually exclusive with n-tuple filters */
 	if (pf->flags & OTX2_FLAG_TC_FLOWER_SUPPORT)
-		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
 
-	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
+	netdev_feature_set_bits(NETIF_F_LOOPBACK | NETIF_F_RXALL,
+				&netdev->hw_features);
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 3f3ec8ffc4dd..991ba63a447a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -193,7 +193,8 @@ static void otx2_set_rxhash(struct otx2_nic *pfvf,
 	struct otx2_rss_info *rss;
 	u32 hash = 0;
 
-	if (!(pfvf->netdev->features & NETIF_F_RXHASH))
+	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				     pfvf->netdev->features))
 		return;
 
 	rss = &pfvf->hw.rss_info;
@@ -283,7 +284,7 @@ static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
 	}
 
 	/* If RXALL is enabled pass on packets to stack. */
-	if (pfvf->netdev->features & NETIF_F_RXALL)
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, pfvf->netdev->features))
 		return false;
 
 	/* Free buffer back to pool */
@@ -330,7 +331,8 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	otx2_set_rxhash(pfvf, cqe, skb);
 
 	skb_record_rx_queue(skb, cq->cq_idx);
-	if (pfvf->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    pfvf->netdev->features))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	napi_gro_frags(napi);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index f1fddae11eed..9b500cc46e9f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -473,11 +473,12 @@ static void otx2vf_reset_task(struct work_struct *work)
 static int otx2vf_set_features(struct net_device *netdev,
 			       netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
-	bool ntuple_enabled = !!(features & NETIF_F_NTUPLE);
+	bool ntuple_enabled = netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features);
 	struct otx2_nic *vf = netdev_priv(netdev);
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_NTUPLE) {
+	netdev_feature_xor(&changed, features, netdev->features);
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, changed)) {
 		if (!ntuple_enabled) {
 			otx2_mcam_flow_del(vf);
 			return 0;
@@ -649,19 +650,23 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Assign default mac address */
 	otx2_get_mac_from_af(netdev);
 
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
-			      NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-			      NETIF_F_GSO_UDP_L4;
-	netdev->features = netdev->hw_features;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
+				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_GSO_UDP_L4, &netdev->hw_features);
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
 	/* Support TSO on tag interface */
-	netdev->vlan_features |= netdev->features;
-	netdev->hw_features  |= NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_STAG_TX;
-	netdev->features |= netdev->hw_features;
-
-	netdev->hw_features |= NETIF_F_NTUPLE;
-	netdev->hw_features |= NETIF_F_RXALL;
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX,
+				&netdev->hw_features);
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+
+	netdev_feature_set_bits(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXALL_BIT, &netdev->hw_features);
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 78a7a00bce22..41cfbecebd80 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -316,7 +316,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_dl_port_register;
 
-	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
+	netdev_feature_set_bits(NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC,
+				&dev->features);
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
 
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 051dd3fb5b03..069a0141ebab 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3109,7 +3109,7 @@ static struct sk_buff *skge_rx_get(struct net_device *dev,
 
 	skb_put(skb, len);
 
-	if (dev->features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features)) {
 		skb->csum = le16_to_cpu(csum);
 		skb->ip_summed = CHECKSUM_COMPLETE;
 	}
@@ -3825,7 +3825,7 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 	dev->max_mtu = ETH_JUMBO_MTU;
 
 	if (highmem)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 
 	skge = netdev_priv(dev);
 	netif_napi_add(dev, &skge->napi, skge_poll, NAPI_WEIGHT);
@@ -3856,9 +3856,10 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 	if (is_genesis(hw))
 		timer_setup(&skge->link_timer, xm_link_timer, 0);
 	else {
-		dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-		                   NETIF_F_RXCSUM;
-		dev->features |= dev->hw_features;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
+					NETIF_F_RXCSUM, &dev->hw_features);
+		netdev_feature_or(&dev->features, dev->features,
+				  dev->hw_features);
 	}
 
 	/* read the mac address */
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 8b1af582c250..eee84e6b97f6 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1274,8 +1274,9 @@ static void rx_set_checksum(struct sky2_port *sky2)
 
 	sky2_write32(sky2->hw,
 		     Q_ADDR(rxqaddr[sky2->port], Q_CSR),
-		     (sky2->netdev->features & NETIF_F_RXCSUM)
-		     ? BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
+		     netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					     sky2->netdev->features) ?
+		     BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
 }
 
 /* Enable/disable receive hash calculation (RSS) */
@@ -1292,7 +1293,7 @@ static void rx_set_rss(struct net_device *dev, netdev_features_t features)
 	}
 
 	/* Program RSS initial values */
-	if (features & NETIF_F_RXHASH) {
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features)) {
 		u32 rss_key[10];
 
 		netdev_rss_key_fill(rss_key, sizeof(rss_key));
@@ -1407,24 +1408,26 @@ static void sky2_vlan_mode(struct net_device *dev, netdev_features_t features)
 	struct sky2_hw *hw = sky2->hw;
 	u16 port = sky2->port;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T),
 			     RX_VLAN_STRIP_ON);
 	else
 		sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T),
 			     RX_VLAN_STRIP_OFF);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_TX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
 		sky2_write32(hw, SK_REG(port, TX_GMF_CTRL_T),
 			     TX_VLAN_TAG_ON);
 
-		dev->vlan_features |= SKY2_VLAN_OFFLOADS;
+		netdev_feature_set_bits(SKY2_VLAN_OFFLOADS,
+					&dev->vlan_features);
 	} else {
 		sky2_write32(hw, SK_REG(port, TX_GMF_CTRL_T),
 			     TX_VLAN_TAG_OFF);
 
 		/* Can't do transmit offload of vlan without hw vlan */
-		dev->vlan_features &= ~SKY2_VLAN_OFFLOADS;
+		netdev_feature_clear_bits(SKY2_VLAN_OFFLOADS,
+					  &dev->vlan_features);
 	}
 }
 
@@ -2678,7 +2681,8 @@ static void sky2_rx_checksum(struct sky2_port *sky2, u32 status)
 		 * It will be reenabled on next ndo_set_features, but if it's
 		 * really broken, will get disabled again
 		 */
-		sky2->netdev->features &= ~NETIF_F_RXCSUM;
+		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT,
+					 &sky2->netdev->features);
 		sky2_write32(sky2->hw, Q_ADDR(rxqaddr[sky2->port], Q_CSR),
 			     BMU_DIS_RX_CHKSUM);
 	}
@@ -2744,7 +2748,8 @@ static int sky2_status_intr(struct sky2_hw *hw, int to_do, u16 idx)
 
 			/* This chip reports checksum status differently */
 			if (hw->flags & SKY2_HW_NEW_LE) {
-				if ((dev->features & NETIF_F_RXCSUM) &&
+				if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+							    dev->features) &&
 				    (le->css & (CSS_ISIPV4 | CSS_ISIPV6)) &&
 				    (le->css & CSS_TCPUDPCSOK))
 					skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2768,7 +2773,8 @@ static int sky2_status_intr(struct sky2_hw *hw, int to_do, u16 idx)
 			sky2_rx_tag(sky2, length);
 			fallthrough;
 		case OP_RXCHKS:
-			if (likely(dev->features & NETIF_F_RXCSUM))
+			if (likely(netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+							   dev->features)))
 				sky2_rx_checksum(sky2, status);
 			break;
 
@@ -4369,35 +4375,40 @@ static void sky2_fix_features(struct net_device *dev,
 	 */
 	if (dev->mtu > ETH_DATA_LEN && hw->chip_id == CHIP_ID_YUKON_EC_U) {
 		netdev_info(dev, "checksum offload not possible with jumbo frames\n");
-		*features &= ~(NETIF_F_TSO | NETIF_F_SG | NETIF_F_CSUM_MASK);
+		netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_SG |
+					  NETIF_F_CSUM_MASK, features);
 	}
 
 	/* Some hardware requires receive checksum for RSS to work. */
-	if ((*features & NETIF_F_RXHASH) &&
-	    !(*features & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, *features) &&
+	    !netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features) &&
 	    (sky2->hw->flags & SKY2_HW_RSS_CHKSUM)) {
 		netdev_info(dev, "receive hashing forces receive checksum\n");
-		*features |= NETIF_F_RXCSUM;
+		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, features);
 	}
 }
 
 static int sky2_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
-	if ((changed & NETIF_F_RXCSUM) &&
+	netdev_feature_xor(&changed, dev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed) &&
 	    !(sky2->hw->flags & SKY2_HW_NEW_LE)) {
 		sky2_write32(sky2->hw,
 			     Q_ADDR(rxqaddr[sky2->port], Q_CSR),
-			     (features & NETIF_F_RXCSUM)
+			     netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						     features)
 			     ? BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
 	}
 
-	if (changed & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, changed))
 		rx_set_rss(dev, features);
 
-	if (changed & (NETIF_F_HW_VLAN_CTAG_TX|NETIF_F_HW_VLAN_CTAG_RX))
+	if (netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				     NETIF_F_HW_VLAN_CTAG_RX, changed))
 		sky2_vlan_mode(dev, features);
 
 	return 0;
@@ -4670,7 +4681,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	/* Auto speed and flow control */
 	sky2->flags = SKY2_FLAG_AUTO_SPEED | SKY2_FLAG_AUTO_PAUSE;
 	if (hw->chip_id != CHIP_ID_YUKON_XL)
-		dev->hw_features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
 
 	sky2->flow_mode = FC_BOTH;
 
@@ -4689,22 +4700,25 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 
 	sky2->port = port;
 
-	dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO,
+				&dev->hw_features);
 
 	if (highmem)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 
 	/* Enable receive hashing unless hardware is known broken */
 	if (!(hw->flags & SKY2_HW_RSS_BROKEN))
-		dev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &dev->hw_features);
 
 	if (!(hw->flags & SKY2_HW_VLAN_BROKEN)) {
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX;
-		dev->vlan_features |= SKY2_VLAN_OFFLOADS;
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_CTAG_RX,
+					&dev->hw_features);
+		netdev_feature_set_bits(SKY2_VLAN_OFFLOADS,
+					&dev->vlan_features);
 	}
 
-	dev->features |= dev->hw_features;
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
 
 	/* MTU range: 60 - 1500 or 9000 */
 	dev->min_mtu = ETH_ZLEN;
-- 
2.33.0

