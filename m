Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B5F41C8DF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344318AbhI2P7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:59:44 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23319 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhI2P7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:38 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWj6RKBzR9dj;
        Wed, 29 Sep 2021 23:53:37 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 001/167] net: convert the prototype of netdev_intersect_features
Date:   Wed, 29 Sep 2021 23:50:48 +0800
Message-ID: <20210929155334.12454-2-shenjian15@huawei.com>
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

For the origin type for netdev_features_t would be changed to
be unsigned long * from u64, so changes the prototype of
netdev_intersect_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 2 +-
 include/linux/netdevice.h                         | 7 ++++---
 net/8021q/vlan_dev.c                              | 8 ++++----
 net/core/dev.c                                    | 8 ++++----
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 369f6ae700c7..f04b79f04a9d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -246,7 +246,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	if (lower_features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
 		lower_features |= NETIF_F_HW_CSUM;
 
-	features = netdev_intersect_features(features, lower_features);
+	netdev_intersect_features(&features, features, lower_features);
 	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_HW_TC);
 	features |= NETIF_F_LLTX;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d79163208dfd..5d5129d4791f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5017,8 +5017,9 @@ const char *netdev_drivername(const struct net_device *dev);
 
 void linkwatch_run_queue(void);
 
-static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
-							  netdev_features_t f2)
+static inline void netdev_intersect_features(netdev_features_t *ret,
+					     netdev_features_t f1,
+					     netdev_features_t f2)
 {
 	if ((f1 ^ f2) & NETIF_F_HW_CSUM) {
 		if (f1 & NETIF_F_HW_CSUM)
@@ -5027,7 +5028,7 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 			f2 |= (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
 	}
 
-	return f1 & f2;
+	*ret = f1 & f2;
 }
 
 static inline netdev_features_t netdev_get_wanted_features(
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 0c21d1fec852..2987201ec93d 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -640,16 +640,16 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	netdev_features_t old_features = features;
 	netdev_features_t lower_features;
 
-	lower_features = netdev_intersect_features((real_dev->vlan_features |
-						    NETIF_F_RXCSUM),
-						   real_dev->features);
+	netdev_intersect_features(&lower_features,
+				  (real_dev->vlan_features | NETIF_F_RXCSUM),
+				  real_dev->features);
 
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
 	if (lower_features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))
 		lower_features |= NETIF_F_HW_CSUM;
-	features = netdev_intersect_features(features, lower_features);
+	netdev_intersect_features(&features, features, lower_features);
 	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
 	features |= NETIF_F_LLTX;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index fa989ab63f29..6ee56cd01d53 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3548,10 +3548,10 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		features &= dev->hw_enc_features;
 
 	if (skb_vlan_tagged(skb))
-		features = netdev_intersect_features(features,
-						     dev->vlan_features |
-						     NETIF_F_HW_VLAN_CTAG_TX |
-						     NETIF_F_HW_VLAN_STAG_TX);
+		netdev_intersect_features(&features, features,
+					  dev->vlan_features |
+					  NETIF_F_HW_VLAN_CTAG_TX |
+					  NETIF_F_HW_VLAN_STAG_TX);
 
 	if (dev->netdev_ops->ndo_features_check)
 		features &= dev->netdev_ops->ndo_features_check(skb, dev,
-- 
2.33.0

