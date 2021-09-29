Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E081641C94C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346327AbhI2QDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23329 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345594AbhI2QAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:03 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX148jjzRd5Y;
        Wed, 29 Sep 2021 23:53:53 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 101/167] net: ionic: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:28 +0800
Message-ID: <20210929155334.12454-102-shenjian15@huawei.com>
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
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 123 +++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |   9 +-
 2 files changed, 79 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 381966e8f557..0d1604e85ed4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1489,37 +1489,37 @@ static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
 {
 	u64 wanted = 0;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
 		wanted |= IONIC_ETH_HW_VLAN_TX_TAG;
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		wanted |= IONIC_ETH_HW_VLAN_RX_STRIP;
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 		wanted |= IONIC_ETH_HW_VLAN_RX_FILTER;
-	if (features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features))
 		wanted |= IONIC_ETH_HW_RX_HASH;
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		wanted |= IONIC_ETH_HW_RX_CSUM;
-	if (features & NETIF_F_SG)
+	if (netdev_feature_test_bit(NETIF_F_SG_BIT, features))
 		wanted |= IONIC_ETH_HW_TX_SG;
-	if (features & NETIF_F_HW_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, features))
 		wanted |= IONIC_ETH_HW_TX_CSUM;
-	if (features & NETIF_F_TSO)
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO;
-	if (features & NETIF_F_TSO6)
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_IPV6;
-	if (features & NETIF_F_TSO_ECN)
+	if (netdev_feature_test_bit(NETIF_F_TSO_ECN_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_ECN;
-	if (features & NETIF_F_GSO_GRE)
+	if (netdev_feature_test_bit(NETIF_F_GSO_GRE_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_GRE;
-	if (features & NETIF_F_GSO_GRE_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_GSO_GRE_CSUM_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_GRE_CSUM;
-	if (features & NETIF_F_GSO_IPXIP4)
+	if (netdev_feature_test_bit(NETIF_F_GSO_IPXIP4_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_IPXIP4;
-	if (features & NETIF_F_GSO_IPXIP6)
+	if (netdev_feature_test_bit(NETIF_F_GSO_IPXIP6_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_IPXIP6;
-	if (features & NETIF_F_GSO_UDP_TUNNEL)
+	if (netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_UDP;
-	if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features))
 		wanted |= IONIC_ETH_HW_TSO_UDP_CSUM;
 
 	return cpu_to_le64(wanted);
@@ -1559,7 +1559,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 	if ((old_hw_features ^ lif->hw_features) & IONIC_ETH_HW_RX_HASH)
 		ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);
 
-	if ((vlan_flags & features) &&
+	if (netdev_feature_test_bits(vlan_flags, features) &&
 	    !(vlan_flags & le64_to_cpu(ctx.comp.lif_setattr.features)))
 		dev_info_once(lif->ionic->dev, "NIC is not supporting vlan offload, likely in SmartNIC mode\n");
 
@@ -1608,63 +1608,85 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	int err;
 
 	/* set up what we expect to support by default */
-	features = NETIF_F_HW_VLAN_CTAG_TX |
-		   NETIF_F_HW_VLAN_CTAG_RX |
-		   NETIF_F_HW_VLAN_CTAG_FILTER |
-		   NETIF_F_SG |
-		   NETIF_F_HW_CSUM |
-		   NETIF_F_RXCSUM |
-		   NETIF_F_TSO |
-		   NETIF_F_TSO6 |
-		   NETIF_F_TSO_ECN;
+	netdev_feature_zero(&features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_SG |
+				NETIF_F_HW_CSUM |
+				NETIF_F_RXCSUM |
+				NETIF_F_TSO |
+				NETIF_F_TSO6 |
+				NETIF_F_TSO_ECN,
+				&features);
 
 	if (lif->nxqs > 1)
-		features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &features);
 
 	err = ionic_set_nic_features(lif, features);
 	if (err)
 		return err;
 
 	/* tell the netdev what we actually can support */
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
 
 	if (lif->hw_features & IONIC_ETH_HW_VLAN_TX_TAG)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       &netdev->hw_features);
 	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_STRIP)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       &netdev->hw_features);
 	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_FILTER)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &netdev->hw_features);
 	if (lif->hw_features & IONIC_ETH_HW_RX_HASH)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
+				       &netdev->hw_features);
 	if (lif->hw_features & IONIC_ETH_HW_TX_SG)
-		netdev->hw_features |= NETIF_F_SG;
+		netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
 
 	if (lif->hw_features & IONIC_ETH_HW_TX_CSUM)
-		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_RX_CSUM)
-		netdev->hw_enc_features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO)
-		netdev->hw_enc_features |= NETIF_F_TSO;
+		netdev_feature_set_bit(NETIF_F_TSO_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_IPV6)
-		netdev->hw_enc_features |= NETIF_F_TSO6;
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_ECN)
-		netdev->hw_enc_features |= NETIF_F_TSO_ECN;
+		netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE)
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
+		netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE_CSUM)
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE_CSUM;
+		netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP4)
-		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4;
+		netdev_feature_set_bit(NETIF_F_GSO_IPXIP4_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP6)
-		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP6;
+		netdev_feature_set_bit(NETIF_F_GSO_IPXIP6_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP)
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
+				       &netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP_CSUM)
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-
-	netdev->hw_features |= netdev->hw_enc_features;
-	netdev->features |= netdev->hw_features;
-	netdev->vlan_features |= netdev->features & ~NETIF_F_VLAN_FEATURES;
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				       &netdev->hw_enc_features);
+
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  netdev->hw_enc_features);
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+	netdev_feature_copy(&features, netdev->features);
+	netdev_feature_clear_bits(NETIF_F_VLAN_FEATURES, &features);
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT |
 			      IFF_LIVE_ADDR_CHANGE;
@@ -2124,7 +2146,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 		}
 	}
 
-	if (lif->netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, lif->netdev->features))
 		ionic_lif_rss_init(lif);
 
 	ionic_lif_rx_mode(lif);
@@ -3092,7 +3114,8 @@ void ionic_lif_deinit(struct ionic_lif *lif)
 		cancel_work_sync(&lif->deferred.work);
 		cancel_work_sync(&lif->tx_timeout_work);
 		ionic_rx_filters_deinit(lif);
-		if (lif->netdev->features & NETIF_F_RXHASH)
+		if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+					    lif->netdev->features))
 			ionic_lif_rss_deinit(lif);
 	}
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 37c39581b659..8c0cf924a194 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -252,7 +252,8 @@ static void ionic_rx_clean(struct ionic_queue *q,
 
 	skb_record_rx_queue(skb, q->index);
 
-	if (likely(netdev->features & NETIF_F_RXHASH)) {
+	if (likely(netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+					   netdev->features))) {
 		switch (comp->pkt_type_color & IONIC_RXQ_COMP_PKT_TYPE_MASK) {
 		case IONIC_PKT_TYPE_IPV4:
 		case IONIC_PKT_TYPE_IPV6:
@@ -269,7 +270,8 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		}
 	}
 
-	if (likely(netdev->features & NETIF_F_RXCSUM) &&
+	if (likely(netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					   netdev->features)) &&
 	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_CALC)) {
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = (__force __wsum)le16_to_cpu(comp->csum);
@@ -283,7 +285,8 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		     (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_IP_BAD)))
 		stats->csum_error++;
 
-	if (likely(netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (likely(netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					   netdev->features)) &&
 	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_VLAN)) {
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       le16_to_cpu(comp->vlan_tci));
-- 
2.33.0

