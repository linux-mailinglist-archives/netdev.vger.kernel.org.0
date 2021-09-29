Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8790041C8DA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344212AbhI2P7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:59:43 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13833 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244682AbhI2P7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:38 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWJ6WpDz8yrD;
        Wed, 29 Sep 2021 23:53:16 +0800 (CST)
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
Subject: [RFCv2 net-next 002/167] net: convert the prototype of netdev_get_wanted_features
Date:   Wed, 29 Sep 2021 23:50:49 +0800
Message-ID: <20210929155334.12454-3-shenjian15@huawei.com>
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
netdev_get_wanted_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdevice.h | 6 +++---
 net/core/dev.c            | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5d5129d4791f..a5598d617789 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5031,10 +5031,10 @@ static inline void netdev_intersect_features(netdev_features_t *ret,
 	*ret = f1 & f2;
 }
 
-static inline netdev_features_t netdev_get_wanted_features(
-	struct net_device *dev)
+static inline void netdev_get_wanted_features(struct net_device *dev,
+					      netdev_features_t *wanted)
 {
-	return (dev->features & ~dev->hw_features) | dev->wanted_features;
+	*wanted = (dev->features & ~dev->hw_features) | dev->wanted_features;
 }
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask);
diff --git a/net/core/dev.c b/net/core/dev.c
index 6ee56cd01d53..e2b4ae74c999 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9939,7 +9939,7 @@ int __netdev_update_features(struct net_device *dev)
 
 	ASSERT_RTNL();
 
-	features = netdev_get_wanted_features(dev);
+	netdev_get_wanted_features(dev, &features);
 
 	if (dev->netdev_ops->ndo_fix_features)
 		features = dev->netdev_ops->ndo_fix_features(dev, features);
-- 
2.33.0

