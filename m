Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6242441C982
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345725AbhI2QGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27926 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345685AbhI2QAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:16 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLX64xqlzbmw5;
        Wed, 29 Sep 2021 23:53:58 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:15 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 134/167] net: ena: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:01 +0800
Message-ID: <20210929155334.12454-135-shenjian15@huawei.com>
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
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 44 +++++++++++---------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0e43000614ab..3bbf12bc25d8 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1534,7 +1534,8 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
 				   struct sk_buff *skb)
 {
 	/* Rx csum disabled */
-	if (unlikely(!(rx_ring->netdev->features & NETIF_F_RXCSUM))) {
+	if (unlikely(!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      rx_ring->netdev->features))) {
 		skb->ip_summed = CHECKSUM_NONE;
 		return;
 	}
@@ -1592,7 +1593,8 @@ static void ena_set_rx_hash(struct ena_ring *rx_ring,
 {
 	enum pkt_hash_types hash_type;
 
-	if (likely(rx_ring->netdev->features & NETIF_F_RXHASH)) {
+	if (likely(netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+					   rx_ring->netdev->features))) {
 		if (likely((ena_rx_ctx->l4_proto == ENA_ETH_IO_L4_PROTO_TCP) ||
 			   (ena_rx_ctx->l4_proto == ENA_ETH_IO_L4_PROTO_UDP)))
 
@@ -4024,42 +4026,46 @@ static u32 ena_calc_max_io_queue_num(struct pci_dev *pdev,
 static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 				 struct net_device *netdev)
 {
-	netdev_features_t dev_features = 0;
+	netdev_features_t dev_features;
+
+	netdev_feature_zero(&dev_features);
 
 	/* Set offload features */
 	if (feat->offload.tx &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_TX_L4_IPV4_CSUM_PART_MASK)
-		dev_features |= NETIF_F_IP_CSUM;
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &dev_features);
 
 	if (feat->offload.tx &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_TX_L4_IPV6_CSUM_PART_MASK)
-		dev_features |= NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, &dev_features);
 
 	if (feat->offload.tx & ENA_ADMIN_FEATURE_OFFLOAD_DESC_TSO_IPV4_MASK)
-		dev_features |= NETIF_F_TSO;
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, &dev_features);
 
 	if (feat->offload.tx & ENA_ADMIN_FEATURE_OFFLOAD_DESC_TSO_IPV6_MASK)
-		dev_features |= NETIF_F_TSO6;
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT, &dev_features);
 
 	if (feat->offload.tx & ENA_ADMIN_FEATURE_OFFLOAD_DESC_TSO_ECN_MASK)
-		dev_features |= NETIF_F_TSO_ECN;
+		netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &dev_features);
 
 	if (feat->offload.rx_supported &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_RX_L4_IPV4_CSUM_MASK)
-		dev_features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev_features);
 
 	if (feat->offload.rx_supported &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_RX_L4_IPV6_CSUM_MASK)
-		dev_features |= NETIF_F_RXCSUM;
-
-	netdev->features =
-		dev_features |
-		NETIF_F_SG |
-		NETIF_F_RXHASH |
-		NETIF_F_HIGHDMA;
-
-	netdev->hw_features |= netdev->features;
-	netdev->vlan_features |= netdev->features;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev_features);
+
+	netdev_feature_copy(&netdev->features, dev_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_RXHASH |
+				NETIF_F_HIGHDMA,
+				&netdev->features);
+
+	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			  netdev->features);
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
 }
 
 static void ena_set_conf_feat_params(struct ena_adapter *adapter,
-- 
2.33.0

