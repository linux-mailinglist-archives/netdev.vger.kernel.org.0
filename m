Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3FF41C900
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345775AbhI2QAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:40 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24129 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344007AbhI2P7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:44 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbC4FnJz1DHJ5;
        Wed, 29 Sep 2021 23:56:39 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 013/167] net: convert the prototype of netdev_sync_upper_features
Date:   Wed, 29 Sep 2021 23:51:00 +0800
Message-ID: <20210929155334.12454-14-shenjian15@huawei.com>
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
netdev_sync_upper_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/core/dev.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a03a01e5339e..58c46131126b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9782,8 +9782,9 @@ static void net_set_todo(struct net_device *dev)
 	dev_net(dev)->dev_unreg_count++;
 }
 
-static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
-	struct net_device *upper, netdev_features_t features)
+static void netdev_sync_upper_features(struct net_device *lower,
+				       struct net_device *upper,
+				       netdev_features_t *features)
 {
 	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
 	netdev_features_t feature;
@@ -9791,15 +9792,13 @@ static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		feature = __NETIF_F_BIT(feature_bit);
-		if (!(upper->wanted_features & feature)
-		    && (features & feature)) {
+		if (!(upper->wanted_features & feature) &&
+		    (*features & feature)) {
 			netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
 				   &feature, upper->name);
-			features &= ~feature;
+			*features &= ~feature;
 		}
 	}
-
-	return features;
 }
 
 static void netdev_sync_lower_features(struct net_device *upper,
@@ -9938,7 +9937,7 @@ int __netdev_update_features(struct net_device *dev)
 
 	/* some features can't be enabled if they're off on an upper device */
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
-		features = netdev_sync_upper_features(dev, upper, features);
+		netdev_sync_upper_features(dev, upper, &features);
 
 	if (dev->features == features)
 		goto sync_lower;
-- 
2.33.0

