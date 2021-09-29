Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FF541C964
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345926AbhI2QFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27924 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345641AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLX45Dvxzbmvx;
        Wed, 29 Sep 2021 23:53:56 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:13 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 121/167] net: benet: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:48 +0800
Message-ID: <20210929155334.12454-122-shenjian15@huawei.com>
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
 drivers/net/ethernet/emulex/benet/be_main.c | 51 +++++++++++++--------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 27e8a1d95a9a..b8faf899dfb3 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2406,14 +2406,16 @@ static void be_rx_compl_process(struct be_rx_obj *rxo, struct napi_struct *napi,
 
 	skb_fill_rx_data(rxo, skb, rxcp);
 
-	if (likely((netdev->features & NETIF_F_RXCSUM) && csum_passed(rxcp)))
+	if (likely(netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					   netdev->features) &&
+		   csum_passed(rxcp)))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	else
 		skb_checksum_none_assert(skb);
 
 	skb->protocol = eth_type_trans(skb, netdev);
 	skb_record_rx_queue(skb, rxo - &adapter->rx_obj[0]);
-	if (netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features))
 		skb_set_hash(skb, rxcp->rss_hash, PKT_HASH_TYPE_L3);
 
 	skb->csum_level = rxcp->tunneled;
@@ -2471,7 +2473,8 @@ static void be_rx_compl_process_gro(struct be_rx_obj *rxo,
 	skb->data_len = rxcp->pkt_size;
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	skb_record_rx_queue(skb, rxo - &adapter->rx_obj[0]);
-	if (adapter->netdev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    adapter->netdev->features))
 		skb_set_hash(skb, rxcp->rss_hash, PKT_HASH_TYPE_L3);
 
 	skb->csum_level = rxcp->tunneled;
@@ -3999,9 +4002,10 @@ static int be_vxlan_set_port(struct net_device *netdev, unsigned int table,
 	}
 	adapter->vxlan_port = ti->port;
 
-	netdev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				   NETIF_F_TSO | NETIF_F_TSO6 |
-				   NETIF_F_GSO_UDP_TUNNEL;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_GSO_UDP_TUNNEL,
+				&netdev->hw_enc_features);
 
 	dev_info(dev, "Enabled VxLAN offloads for UDP port %d\n",
 		 be16_to_cpu(ti->port));
@@ -4023,7 +4027,7 @@ static int be_vxlan_unset_port(struct net_device *netdev, unsigned int table,
 	adapter->flags &= ~BE_FLAGS_VXLAN_OFFLOADS;
 	adapter->vxlan_port = 0;
 
-	netdev->hw_enc_features = 0;
+	netdev_feature_zero(&netdev->hw_enc_features);
 	return 0;
 }
 
@@ -5075,7 +5079,7 @@ static void be_features_check(struct sk_buff *skb, struct net_device *dev,
 		 * to Lancer and BE3 HW. Disable TSO6 feature.
 		 */
 		if (!skyhawk_chip(adapter) && is_ipv6_ext_hdr(skb))
-			*features &= ~NETIF_F_TSO6;
+			netdev_feature_clear_bit(NETIF_F_TSO6_BIT, features);
 
 		/* Lancer cannot handle the packet with MSS less than 256.
 		 * Also it can't handle a TSO packet with a single segment
@@ -5084,7 +5088,7 @@ static void be_features_check(struct sk_buff *skb, struct net_device *dev,
 		if (lancer_chip(adapter) &&
 		    (skb_shinfo(skb)->gso_size < 256 ||
 		     skb_shinfo(skb)->gso_segs == 1))
-			*features &= ~NETIF_F_GSO_MASK;
+			netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 	}
 
 	/* The code below restricts offload features for some tunneled and
@@ -5120,7 +5124,8 @@ static void be_features_check(struct sk_buff *skb, struct net_device *dev,
 		sizeof(struct udphdr) + sizeof(struct vxlanhdr) ||
 	    !adapter->vxlan_port ||
 	    udp_hdr(skb)->dest != adapter->vxlan_port) {
-		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+					  features);
 		return;
 	}
 }
@@ -5186,18 +5191,24 @@ static void be_netdev_init(struct net_device *netdev)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 
-	netdev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
-		NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_GSO_UDP_TUNNEL |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_RXCSUM |
+				NETIF_F_HW_VLAN_CTAG_TX,
+				&netdev->hw_features);
 	if ((be_if_cap_flags(adapter) & BE_IF_FLAGS_RSS))
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->hw_features);
 
-	netdev->features |= netdev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER,
+				&netdev->features);
 
-	netdev->vlan_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				&netdev->vlan_features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
@@ -5841,7 +5852,7 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 
 	status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (!status) {
-		netdev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
 	} else {
 		status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (status) {
-- 
2.33.0

