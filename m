Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC38F41C93A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345573AbhI2QCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:47 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23243 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244682AbhI2P7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:54 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbm1yTMz8tTW;
        Wed, 29 Sep 2021 23:57:08 +0800 (CST)
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
Subject: [RFCv2 net-next 027/167] bridge: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:14 +0800
Message-ID: <20210929155334.12454-28-shenjian15@huawei.com>
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
 net/bridge/br_device.c | 16 +++++++++++-----
 net/bridge/br_if.c     |  4 ++--
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index fc508b9cbaa9..c9894b9944ab 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -490,11 +490,17 @@ void br_dev_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &br_type);
 	dev->priv_flags = IFF_EBRIDGE | IFF_NO_QUEUE;
 
-	dev->features = COMMON_FEATURES | NETIF_F_LLTX | NETIF_F_NETNS_LOCAL |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
-	dev->hw_features = COMMON_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-			   NETIF_F_HW_VLAN_STAG_TX;
-	dev->vlan_features = COMMON_FEATURES;
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bits(COMMON_FEATURES | NETIF_F_LLTX |
+				NETIF_F_NETNS_LOCAL |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX,
+				&dev->features);
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(COMMON_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX, &dev->hw_features);
+	netdev_feature_zero(&dev->vlan_features);
+	netdev_feature_set_bits(COMMON_FEATURES, &dev->vlan_features);
 
 	br->dev = dev;
 	spin_lock_init(&br->lock);
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 914ca4b2d07c..c0a71fd6f772 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -540,8 +540,8 @@ void br_features_recompute(struct net_bridge *br, netdev_features_t *features)
 	if (list_empty(&br->port_list))
 		return;
 
-	mask = *features;
-	*features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_feature_copy(&mask, *features);
+	netdev_feature_clear_bits(NETIF_F_ONE_FOR_ALL, features);
 
 	list_for_each_entry(p, &br->port_list, list) {
 		netdev_increment_features(features, *features, p->dev->features,
-- 
2.33.0

