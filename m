Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455CC41C911
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345578AbhI2QBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:15 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23245 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345478AbhI2P7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbp19JHz8tVW;
        Wed, 29 Sep 2021 23:57:10 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 042/167] vmxnet3: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:29 +0800
Message-ID: <20210929155334.12454-43-shenjian15@huawei.com>
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
 drivers/net/vmxnet3/vmxnet3_drv.c     | 75 +++++++++++++++++----------
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 73 ++++++++++++++++----------
 2 files changed, 94 insertions(+), 54 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 142f70670f5c..06acbad37a6d 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1223,7 +1223,9 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		struct sk_buff *skb,
 		union Vmxnet3_GenericDesc *gdesc)
 {
-	if (!gdesc->rcd.cnc && adapter->netdev->features & NETIF_F_RXCSUM) {
+	if (!gdesc->rcd.cnc &&
+	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    adapter->netdev->features)) {
 		if (gdesc->rcd.v4 &&
 		    (le32_to_cpu(gdesc->dword[3]) &
 		     VMXNET3_RCD_CSUM_OK) == VMXNET3_RCD_CSUM_OK) {
@@ -1478,7 +1480,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 
 #ifdef VMXNET3_RSS
 			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
-			    (adapter->netdev->features & NETIF_F_RXHASH)) {
+			    netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+						    adapter->netdev->features)) {
 				enum pkt_hash_types hash_type;
 
 				switch (rcd->rssType) {
@@ -1581,7 +1584,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);
 			if (!rcd->tcp ||
-			    !(adapter->netdev->features & NETIF_F_LRO))
+			    !netdev_feature_test_bit(NETIF_F_LRO_BIT,
+						     adapter->netdev->features))
 				goto not_lro;
 
 			if (segCnt != 0 && mss != 0) {
@@ -1612,7 +1616,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			if (unlikely(rcd->ts))
 				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), rcd->tci);
 
-			if (adapter->netdev->features & NETIF_F_LRO)
+			if (netdev_feature_test_bit(NETIF_F_LRO_BIT,
+						    adapter->netdev->features))
 				netif_receive_skb(skb);
 			else
 				napi_gro_receive(&rq->napi, skb);
@@ -2501,18 +2506,22 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 	devRead->misc.ddLen = cpu_to_le32(sizeof(struct vmxnet3_adapter));
 
 	/* set up feature flags */
-	if (adapter->netdev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    adapter->netdev->features))
 		devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
 
-	if (adapter->netdev->features & NETIF_F_LRO) {
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT,
+				    adapter->netdev->features)) {
 		devRead->misc.uptFeatures |= UPT1_F_LRO;
 		devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
 	}
-	if (adapter->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    adapter->netdev->features))
 		devRead->misc.uptFeatures |= UPT1_F_RXVLAN;
 
-	if (adapter->netdev->features & (NETIF_F_GSO_UDP_TUNNEL |
-					 NETIF_F_GSO_UDP_TUNNEL_CSUM))
+	if (netdev_feature_test_bits(NETIF_F_GSO_UDP_TUNNEL |
+				     NETIF_F_GSO_UDP_TUNNEL_CSUM,
+				     adapter->netdev->features))
 		devRead->misc.uptFeatures |= UPT1_F_RXINNEROFLD;
 
 	devRead->misc.mtu = cpu_to_le32(adapter->netdev->mtu);
@@ -3163,28 +3172,39 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter, bool dma64)
 {
 	struct net_device *netdev = adapter->netdev;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
-		NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_LRO;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
+				NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO |
+				NETIF_F_TSO6 | NETIF_F_LRO,
+				&netdev->hw_features);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					&netdev->hw_features);
 
-		netdev->hw_enc_features = NETIF_F_SG | NETIF_F_RXCSUM |
-			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_feature_zero(&netdev->hw_enc_features);
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
+					NETIF_F_HW_CSUM |
+					NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_CTAG_RX |
+					NETIF_F_TSO | NETIF_F_TSO6 |
+					NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					&netdev->hw_enc_features);
 	}
 
 	if (dma64)
-		netdev->hw_features |= NETIF_F_HIGHDMA;
-	netdev->vlan_features = netdev->hw_features &
-				~(NETIF_F_HW_VLAN_CTAG_TX |
-				  NETIF_F_HW_VLAN_CTAG_RX);
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+				       &netdev->hw_features);
+	netdev_feature_copy(&netdev->vlan_features, netdev->hw_features);
+	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				  NETIF_F_HW_VLAN_CTAG_RX,
+				  &netdev->vlan_features);
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			       &netdev->features);
 }
 
 
@@ -3629,8 +3649,9 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	if (adapter->num_rx_queues > 1 &&
 	    adapter->intr.type == VMXNET3_IT_MSIX) {
 		adapter->rss = true;
-		netdev->hw_features |= NETIF_F_RXHASH;
-		netdev->features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->features);
 		dev_dbg(&pdev->dev, "RSS is enabled.\n");
 	} else {
 		adapter->rss = false;
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 6a5827c21c63..05e422b48774 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -250,8 +250,8 @@ void vmxnet3_fix_features(struct net_device *netdev,
 			  netdev_features_t *features)
 {
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!(*features & NETIF_F_RXCSUM))
-		*features &= ~NETIF_F_LRO;
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 }
 
 void vmxnet3_features_check(struct sk_buff *skb, struct net_device *netdev,
@@ -274,7 +274,9 @@ void vmxnet3_features_check(struct sk_buff *skb, struct net_device *netdev,
 			l4_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			netdev_feature_clear_bits(NETIF_F_CSUM_MASK |
+						  NETIF_F_GSO_MASK,
+						  features);
 			return;
 		}
 
@@ -286,12 +288,16 @@ void vmxnet3_features_check(struct sk_buff *skb, struct net_device *netdev,
 			if (port != GENEVE_UDP_PORT &&
 			    port != IANA_VXLAN_UDP_PORT &&
 			    port != VXLAN_UDP_PORT) {
-				*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+				netdev_feature_clear_bits(NETIF_F_CSUM_MASK |
+							  NETIF_F_GSO_MASK,
+							  features);
 				return;
 			}
 			break;
 		default:
-			*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			netdev_feature_clear_bits(NETIF_F_CSUM_MASK |
+						  NETIF_F_GSO_MASK,
+						  features);
 			return;
 		}
 	}
@@ -302,11 +308,14 @@ static void vmxnet3_enable_encap_offloads(struct net_device *netdev)
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_enc_features |= NETIF_F_SG | NETIF_F_RXCSUM |
-			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
+					NETIF_F_HW_CSUM |
+					NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_CTAG_RX |
+					NETIF_F_TSO | NETIF_F_TSO6 |
+					NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					&netdev->hw_enc_features);
 	}
 }
 
@@ -315,26 +324,33 @@ static void vmxnet3_disable_encap_offloads(struct net_device *netdev)
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_enc_features &= ~(NETIF_F_SG | NETIF_F_RXCSUM |
-			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM);
+		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_RXCSUM |
+					  NETIF_F_HW_CSUM |
+					  NETIF_F_HW_VLAN_CTAG_TX |
+					  NETIF_F_HW_VLAN_CTAG_RX |
+					  NETIF_F_TSO | NETIF_F_TSO6 |
+					  NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
+					  NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					  &netdev->hw_enc_features);
 	}
 }
 
 int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+	u64 tun_offload_mask = NETIF_F_GSO_UDP_TUNNEL |
+				NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	netdev_features_t changed;
 	unsigned long flags;
-	netdev_features_t changed = features ^ netdev->features;
-	netdev_features_t tun_offload_mask = NETIF_F_GSO_UDP_TUNNEL |
-					     NETIF_F_GSO_UDP_TUNNEL_CSUM;
-	u8 udp_tun_enabled = (netdev->features & tun_offload_mask) != 0;
-
-	if (changed & (NETIF_F_RXCSUM | NETIF_F_LRO |
-		       NETIF_F_HW_VLAN_CTAG_RX | tun_offload_mask)) {
-		if (features & NETIF_F_RXCSUM)
+	u8 udp_tun_enabled;
+
+	netdev_feature_xor(&changed, netdev->features, features);
+	udp_tun_enabled = netdev_feature_test_bits(tun_offload_mask,
+						   netdev->features);
+	if (netdev_feature_test_bits(NETIF_F_RXCSUM | NETIF_F_LRO |
+				     NETIF_F_HW_VLAN_CTAG_RX |
+				     tun_offload_mask, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXCSUM;
 		else
@@ -342,25 +358,28 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 			~UPT1_F_RXCSUM;
 
 		/* update hardware LRO capability accordingly */
-		if (features & NETIF_F_LRO)
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, features))
 			adapter->shared->devRead.misc.uptFeatures |=
 							UPT1_F_LRO;
 		else
 			adapter->shared->devRead.misc.uptFeatures &=
 							~UPT1_F_LRO;
 
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    features))
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXVLAN;
 		else
 			adapter->shared->devRead.misc.uptFeatures &=
 			~UPT1_F_RXVLAN;
 
-		if ((features & tun_offload_mask) != 0 && !udp_tun_enabled) {
+		if (netdev_feature_test_bits(tun_offload_mask, features) &&
+		    !udp_tun_enabled) {
 			vmxnet3_enable_encap_offloads(netdev);
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXINNEROFLD;
-		} else if ((features & tun_offload_mask) == 0 &&
+		} else if (!netdev_feature_test_bits(tun_offload_mask,
+						     features) &&
 			   udp_tun_enabled) {
 			vmxnet3_disable_encap_offloads(netdev);
 			adapter->shared->devRead.misc.uptFeatures &=
-- 
2.33.0

