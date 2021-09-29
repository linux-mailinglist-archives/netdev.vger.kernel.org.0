Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8505941C97D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345598AbhI2QFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27916 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345667AbhI2QAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLX61jsGzbmw2;
        Wed, 29 Sep 2021 23:53:58 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:15 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 131/167] net: toshiba: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:58 +0800
Message-ID: <20210929155334.12454-132-shenjian15@huawei.com>
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
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 14 +++++++++-----
 drivers/net/ethernet/toshiba/spider_net.c    | 12 ++++++++----
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 55e652624bd7..f502108bd88c 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -936,7 +936,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr *descr,
 	skb->protocol = eth_type_trans(skb, netdev);
 
 	/* checksum offload */
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->features)) {
 		if ((data_status & GELIC_DESCR_DATA_STATUS_CHK_MASK) &&
 		    (!(data_error & GELIC_DESCR_DATA_ERROR_CHK_MASK)))
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -1461,11 +1461,14 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 	int status;
 	u64 v1, v2;
 
-	netdev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
+				&netdev->hw_features);
 
-	netdev->features = NETIF_F_IP_CSUM;
+	netdev_feature_zero(&netdev->features);
+	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &netdev->features);
 	if (GELIC_CARD_RX_CSUM_DEFAULT)
-		netdev->features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
 
 	status = lv1_net_control(bus_id(card), dev_id(card),
 				 GELIC_LV1_GET_MAC_ADDRESS,
@@ -1485,7 +1488,8 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 		 * As vlan is internally used,
 		 * we can not receive vlan packets
 		 */
-		netdev->features |= NETIF_F_VLAN_CHALLENGED;
+		netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT,
+				       &netdev->features);
 	}
 
 	/* MTU range: 64 - 1518 */
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 66d4e024d11e..2c8bfb02e9fb 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -966,7 +966,7 @@ spider_net_pass_skb_up(struct spider_net_descr *descr,
 
 	/* checksum offload */
 	skb_checksum_none_assert(skb);
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->features)) {
 		if ( ( (data_status & SPIDER_NET_DATA_STATUS_CKSUM_MASK) ==
 		       SPIDER_NET_DATA_STATUS_CKSUM_MASK) &&
 		     !(data_error & SPIDER_NET_DATA_ERR_CKSUM_MASK))
@@ -2274,10 +2274,14 @@ spider_net_setup_netdev(struct spider_net_card *card)
 
 	spider_net_setup_netdev_ops(netdev);
 
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM,
+				&netdev->hw_features);
 	if (SPIDER_NET_RX_CSUM_DEFAULT)
-		netdev->features |= NETIF_F_RXCSUM;
-	netdev->features |= NETIF_F_IP_CSUM | NETIF_F_LLTX;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_LLTX,
+				&netdev->features);
+
 	/* some time: NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 	 *		NETIF_F_HW_VLAN_CTAG_FILTER
 	 */
-- 
2.33.0

