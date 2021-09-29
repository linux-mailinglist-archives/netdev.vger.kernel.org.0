Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2910941C904
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345807AbhI2QAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12982 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344326AbhI2P7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbF1lW4zWXJx;
        Wed, 29 Sep 2021 23:56:41 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 028/167] ipvlan: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:15 +0800
Message-ID: <20210929155334.12454-29-shenjian15@huawei.com>
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
 drivers/net/ipvlan/ipvlan_main.c | 28 ++++++++++++++++++----------
 drivers/net/ipvlan/ipvtap.c      |  5 +++--
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 6a0b7bd2d3ae..84ad786ae18d 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -135,11 +135,14 @@ static int ipvlan_init(struct net_device *dev)
 
 	dev->state = (dev->state & ~IPVLAN_STATE_MASK) |
 		     (phy_dev->state & IPVLAN_STATE_MASK);
-	dev->features = phy_dev->features & IPVLAN_FEATURES;
-	dev->features |= IPVLAN_ALWAYS_ON;
-	dev->vlan_features = phy_dev->vlan_features & IPVLAN_FEATURES;
-	dev->vlan_features |= IPVLAN_ALWAYS_ON_OFLOADS;
-	dev->hw_enc_features |= dev->features;
+	netdev_feature_copy(&dev->features, phy_dev->features);
+	netdev_feature_and_bits(IPVLAN_FEATURES, &dev->features);
+	netdev_feature_set_bits(IPVLAN_ALWAYS_ON, &dev->features);
+	netdev_feature_copy(&dev->vlan_features, phy_dev->vlan_features);
+	netdev_feature_and_bits(IPVLAN_FEATURES, &dev->vlan_features);
+	netdev_feature_set_bits(IPVLAN_ALWAYS_ON_OFLOADS, &dev->vlan_features);
+	netdev_feature_or(&dev->hw_enc_features, dev->hw_enc_features,
+			  dev->features);
 	dev->gso_max_size = phy_dev->gso_max_size;
 	dev->gso_max_segs = phy_dev->gso_max_segs;
 	dev->hard_header_len = phy_dev->hard_header_len;
@@ -239,13 +242,17 @@ static void ipvlan_fix_features(struct net_device *dev,
 				netdev_features_t *features)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
+	netdev_features_t tmp;
 
-	*features |= NETIF_F_ALL_FOR_ALL;
-	*features &= (ipvlan->sfeatures | ~IPVLAN_FEATURES);
+	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
+	netdev_feature_fill(&tmp);
+	netdev_feature_clear_bits(IPVLAN_FEATURES, &tmp);
+	netdev_feature_or(&tmp, tmp, ipvlan->sfeatures);
+	netdev_feature_and(features, *features, tmp);
 	netdev_increment_features(features, ipvlan->phy_dev->features,
 				  *features, *features);
-	*features |= IPVLAN_ALWAYS_ON;
-	*features &= (IPVLAN_FEATURES | IPVLAN_ALWAYS_ON);
+	netdev_feature_set_bits(IPVLAN_ALWAYS_ON, features);
+	netdev_feature_and_bits(IPVLAN_FEATURES | IPVLAN_ALWAYS_ON, features);
 }
 
 static void ipvlan_change_rx_flags(struct net_device *dev, int change)
@@ -567,7 +574,8 @@ int ipvlan_link_new(struct net *src_net, struct net_device *dev,
 
 	ipvlan->phy_dev = phy_dev;
 	ipvlan->dev = dev;
-	ipvlan->sfeatures = IPVLAN_FEATURES;
+	netdev_feature_zero(&ipvlan->sfeatures);
+	netdev_feature_set_bits(IPVLAN_FEATURES, &ipvlan->sfeatures);
 	if (!tb[IFLA_MTU])
 		ipvlan_adjust_mtu(ipvlan, phy_dev);
 	INIT_LIST_HEAD(&ipvlan->addrs);
diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index 1cedb634f4f7..fd11ce806cc7 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -70,7 +70,7 @@ static void ipvtap_update_features(struct tap_dev *tap,
 	struct ipvtap_dev *vlantap = container_of(tap, struct ipvtap_dev, tap);
 	struct ipvl_dev *vlan = &vlantap->vlan;
 
-	vlan->sfeatures = features;
+	netdev_feature_copy(&vlan->sfeatures, features);
 	netdev_update_features(vlan->dev);
 }
 
@@ -86,7 +86,8 @@ static int ipvtap_newlink(struct net *src_net, struct net_device *dev,
 	/* Since macvlan supports all offloads by default, make
 	 * tap support all offloads also.
 	 */
-	vlantap->tap.tap_features = TUN_OFFLOADS;
+	netdev_feature_zero(&vlantap->tap.tap_features);
+	netdev_feature_set_bits(TUN_OFFLOADS, &vlantap->tap.tap_features);
 	vlantap->tap.count_tx_dropped = ipvtap_count_tx_dropped;
 	vlantap->tap.update_features =	ipvtap_update_features;
 	vlantap->tap.count_rx_dropped = ipvtap_count_rx_dropped;
-- 
2.33.0

