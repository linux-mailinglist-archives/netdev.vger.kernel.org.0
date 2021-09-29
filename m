Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207B141C92C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345730AbhI2QCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:06 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23244 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344354AbhI2P7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbn2yNwz8tVP;
        Wed, 29 Sep 2021 23:57:09 +0800 (CST)
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
Subject: [RFCv2 net-next 036/167] macsec: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:23 +0800
Message-ID: <20210929155334.12454-37-shenjian15@huawei.com>
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
 drivers/net/macsec.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 601b833a40bd..5526d54c0a14 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -347,7 +347,8 @@ static bool macsec_check_offload(enum macsec_offload offload,
 		return macsec->real_dev->phydev &&
 		       macsec->real_dev->phydev->macsec_ops;
 	else if (offload == MACSEC_OFFLOAD_MAC)
-		return macsec->real_dev->features & NETIF_F_HW_MACSEC &&
+		return netdev_feature_test_bit(NETIF_F_HW_MACSEC_BIT,
+					       macsec->real_dev->features) &&
 		       macsec->real_dev->macsec_ops;
 
 	return false;
@@ -3419,13 +3420,6 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 #define SW_MACSEC_FEATURES \
 	(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST)
 
-/* If h/w offloading is enabled, use real device features save for
- *   VLAN_FEATURES - they require additional ops
- *   HW_MACSEC - no reason to report it
- */
-#define REAL_DEV_FEATURES(dev) \
-	((dev)->features & ~(NETIF_F_VLAN_FEATURES | NETIF_F_HW_MACSEC))
-
 static int macsec_dev_init(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
@@ -3443,10 +3437,19 @@ static int macsec_dev_init(struct net_device *dev)
 	}
 
 	if (macsec_is_offloaded(macsec)) {
-		dev->features = REAL_DEV_FEATURES(real_dev);
+		/* If h/w offloading is enabled, use real device features save for
+		 *   VLAN_FEATURES - they require additional ops
+		 *   HW_MACSEC - no reason to report it
+		 */
+		netdev_feature_copy(&dev->features, real_dev->features);
+		netdev_feature_clear_bits(NETIF_F_VLAN_FEATURES |
+					  NETIF_F_HW_MACSEC,
+					  &dev->features);
 	} else {
-		dev->features = real_dev->features & SW_MACSEC_FEATURES;
-		dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
+		netdev_feature_copy(&dev->features, real_dev->features);
+		netdev_feature_and_bits(SW_MACSEC_FEATURES, &dev->features);
+		netdev_feature_set_bits(NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE,
+					&dev->features);
 	}
 
 	dev->needed_headroom = real_dev->needed_headroom +
@@ -3475,15 +3478,21 @@ static void macsec_fix_features(struct net_device *dev,
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
+	netdev_features_t tmp;
 
 	if (macsec_is_offloaded(macsec)) {
-		*features = REAL_DEV_FEATURES(real_dev);
+		netdev_feature_copy(features, real_dev->features);
+		netdev_feature_clear_bits(NETIF_F_VLAN_FEATURES |
+					  NETIF_F_HW_MACSEC, features);
 		return;
 	}
 
-	*features &= (real_dev->features & SW_MACSEC_FEATURES) |
-		    NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES;
-	*features |= NETIF_F_LLTX;
+	netdev_feature_copy(&tmp, real_dev->features);
+	netdev_feature_and_bits(SW_MACSEC_FEATURES, &tmp);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES,
+				&tmp);
+	netdev_feature_and(features, *features, tmp);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, features);
 }
 
 static int macsec_dev_open(struct net_device *dev)
-- 
2.33.0

