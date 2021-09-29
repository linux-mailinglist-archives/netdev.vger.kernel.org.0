Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F8B41C91D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344511AbhI2QBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:40 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24137 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245103AbhI2P7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbG2X9Tz1DHLw;
        Wed, 29 Sep 2021 23:56:42 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 035/167] macvlan: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:22 +0800
Message-ID: <20210929155334.12454-36-shenjian15@huawei.com>
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
 drivers/net/macvlan.c | 49 +++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 3c408653e864..9ac38e22ccfc 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -620,7 +620,8 @@ static int macvlan_open(struct net_device *dev)
 	/* Attempt to populate accel_priv which is used to offload the L2
 	 * forwarding requests for unicast packets.
 	 */
-	if (lowerdev->features & NETIF_F_HW_L2FW_DOFFLOAD)
+	if (netdev_feature_test_bit(NETIF_F_HW_L2FW_DOFFLOAD_BIT,
+				    lowerdev->features))
 		vlan->accel_priv =
 		      lowerdev->netdev_ops->ndo_dfwd_add_station(lowerdev, dev);
 
@@ -893,12 +894,15 @@ static int macvlan_init(struct net_device *dev)
 
 	dev->state		= (dev->state & ~MACVLAN_STATE_MASK) |
 				  (lowerdev->state & MACVLAN_STATE_MASK);
-	dev->features 		= lowerdev->features & MACVLAN_FEATURES;
-	dev->features		|= ALWAYS_ON_FEATURES;
-	dev->hw_features	|= NETIF_F_LRO;
-	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
-	dev->vlan_features	|= ALWAYS_ON_OFFLOADS;
-	dev->hw_enc_features    |= dev->features;
+	netdev_feature_copy(&dev->features, lowerdev->features);
+	netdev_feature_and_bits(MACVLAN_FEATURES, &dev->features);
+	netdev_feature_set_bits(ALWAYS_ON_FEATURES, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LRO_BIT, &dev->hw_features);
+	netdev_feature_copy(&dev->vlan_features, lowerdev->vlan_features);
+	netdev_feature_and_bits(MACVLAN_FEATURES, &dev->vlan_features);
+	netdev_feature_set_bits(ALWAYS_ON_OFFLOADS, &dev->vlan_features);
+	netdev_feature_or(&dev->hw_enc_features, dev->hw_enc_features,
+			  dev->features);
 	dev->gso_max_size	= lowerdev->gso_max_size;
 	dev->gso_max_segs	= lowerdev->gso_max_segs;
 	dev->hard_header_len	= lowerdev->hard_header_len;
@@ -1071,17 +1075,25 @@ static void macvlan_fix_features(struct net_device *dev,
 				 netdev_features_t *features)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
-	netdev_features_t lowerdev_features = vlan->lowerdev->features;
-	netdev_features_t mask;
-
-	*features |= NETIF_F_ALL_FOR_ALL;
-	*features &= (vlan->set_features | ~MACVLAN_FEATURES);
-	mask = *features;
-
-	lowerdev_features &= (*features | ~NETIF_F_LRO);
+	netdev_features_t lowerdev_features;
+	netdev_features_t mask, tmp;
+
+	netdev_feature_copy(&lowerdev_features, vlan->lowerdev->features);
+	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
+	netdev_feature_fill(&tmp);
+	netdev_feature_clear_bits(MACVLAN_FEATURES, &tmp);
+	netdev_feature_or(&tmp, tmp, vlan->set_features);
+	netdev_feature_and(features, *features, tmp);
+	netdev_feature_copy(&mask, *features);
+
+	netdev_feature_fill(&tmp);
+	netdev_feature_clear_bit(NETIF_F_LRO_BIT, &tmp);
+	netdev_feature_or(&tmp, tmp, *features);
+	netdev_feature_and(&lowerdev_features, lowerdev_features, tmp);
 	netdev_increment_features(features, lowerdev_features, *features, mask);
-	*features |= ALWAYS_ON_FEATURES;
-	*features &= (ALWAYS_ON_FEATURES | MACVLAN_FEATURES);
+	netdev_feature_set_bits(ALWAYS_ON_FEATURES, features);
+	netdev_feature_and_bits(ALWAYS_ON_FEATURES | MACVLAN_FEATURES,
+				features);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -1458,7 +1470,8 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	vlan->lowerdev = lowerdev;
 	vlan->dev      = dev;
 	vlan->port     = port;
-	vlan->set_features = MACVLAN_FEATURES;
+	netdev_feature_zero(&vlan->set_features);
+	netdev_feature_set_bits(MACVLAN_FEATURES, &vlan->set_features);
 
 	vlan->mode     = MACVLAN_MODE_VEPA;
 	if (data && data[IFLA_MACVLAN_MODE])
-- 
2.33.0

