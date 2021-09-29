Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1755541C925
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346004AbhI2QBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27910 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345449AbhI2P7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:47 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWv5hlTzbmql;
        Wed, 29 Sep 2021 23:53:47 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:04 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 063/167] xen-netfront: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:50 +0800
Message-ID: <20210929155334.12454-64-shenjian15@huawei.com>
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
 drivers/net/xen-netfront.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 79752f16277a..00c30e6dbe7c 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -231,7 +231,7 @@ static const struct attribute_group xennet_dev_group;
 
 static bool xennet_can_sg(struct net_device *dev)
 {
-	return dev->features & NETIF_F_SG;
+	return netdev_feature_test_bit(NETIF_F_SG_BIT, dev->features);
 }
 
 
@@ -1391,28 +1391,29 @@ static void xennet_fix_features(struct net_device *dev,
 {
 	struct netfront_info *np = netdev_priv(dev);
 
-	if (*features & NETIF_F_SG &&
+	if (netdev_feature_test_bit(NETIF_F_SG_BIT, *features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-sg", 0))
-		*features &= ~NETIF_F_SG;
+		netdev_feature_clear_bit(NETIF_F_SG_BIT, features);
 
-	if (*features & NETIF_F_IPV6_CSUM &&
+	if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, *features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend,
 				  "feature-ipv6-csum-offload", 0))
-		*features &= ~NETIF_F_IPV6_CSUM;
+		netdev_feature_clear_bit(NETIF_F_IPV6_CSUM_BIT, features);
 
-	if (*features & NETIF_F_TSO &&
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv4", 0))
-		*features &= ~NETIF_F_TSO;
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 
-	if (*features & NETIF_F_TSO6 &&
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, *features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv6", 0))
-		*features &= ~NETIF_F_TSO6;
+		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, features);
 }
 
 static int xennet_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
-	if (!(features & NETIF_F_SG) && dev->mtu > ETH_DATA_LEN) {
+	if (!netdev_feature_test_bit(NETIF_F_SG_BIT, features) &&
+	    dev->mtu > ETH_DATA_LEN) {
 		netdev_info(dev, "Reducing MTU because no SG offload");
 		dev->mtu = ETH_DATA_LEN;
 	}
@@ -1604,19 +1605,22 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 
 	netdev->netdev_ops	= &xennet_netdev_ops;
 
-	netdev->features        = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-				  NETIF_F_GSO_ROBUST;
-	netdev->hw_features	= NETIF_F_SG |
-				  NETIF_F_IPV6_CSUM |
-				  NETIF_F_TSO | NETIF_F_TSO6;
-
+	netdev_feature_zero(&netdev->features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+				NETIF_F_GSO_ROBUST, &netdev->features);
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_IPV6_CSUM |
+				NETIF_F_TSO | NETIF_F_TSO6,
+				&netdev->hw_features);
 	/*
          * Assume that all hw features are available for now. This set
          * will be adjusted by the call to netdev_update_features() in
          * xennet_connect() which is the earliest point where we can
          * negotiate with the backend regarding supported features.
          */
-	netdev->features |= netdev->hw_features;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
 
 	netdev->ethtool_ops = &xennet_ethtool_ops;
 	netdev->min_mtu = ETH_MIN_MTU;
-- 
2.33.0

