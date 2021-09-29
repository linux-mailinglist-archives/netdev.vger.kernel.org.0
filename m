Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C7F41C92D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345735AbhI2QCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12979 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344189AbhI2P7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:43 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbC4S0kzW86N;
        Wed, 29 Sep 2021 23:56:39 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:57 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 015/167] net: convert the prototype of netdev_add_tso_features
Date:   Wed, 29 Sep 2021 23:51:02 +0800
Message-ID: <20210929155334.12454-16-shenjian15@huawei.com>
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
netdev_add_tso_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/bonding/bond_main.c | 2 +-
 drivers/net/team/team.c         | 2 +-
 include/linux/netdevice.h       | 6 +++---
 net/bridge/br_if.c              | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 469509260a51..878c92746ada 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1386,7 +1386,7 @@ static void bond_fix_features(struct net_device *dev,
 						      slave->dev->features,
 						      mask);
 	}
-	*features = netdev_add_tso_features(*features, mask);
+	netdev_add_tso_features(features, mask);
 }
 
 #define BOND_VLAN_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 340be925d4eb..706572b7a313 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2014,7 +2014,7 @@ static void team_fix_features(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
-	*features = netdev_add_tso_features(*features, mask);
+	netdev_add_tso_features(features, mask);
 }
 
 static int team_change_carrier(struct net_device *dev, bool new_carrier)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 43eb57fa9434..e826435ab847 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5043,10 +5043,10 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
  * Performing the GSO segmentation before last device
  * is a performance improvement.
  */
-static inline netdev_features_t netdev_add_tso_features(netdev_features_t features,
-							netdev_features_t mask)
+static inline void netdev_add_tso_features(netdev_features_t *features,
+					   netdev_features_t mask)
 {
-	return netdev_increment_features(features, NETIF_F_ALL_TSO, mask);
+	*features = netdev_increment_features(*features, NETIF_F_ALL_TSO, mask);
 }
 
 int __netdev_update_features(struct net_device *dev);
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index b2afbea2133e..749971ab1088 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -547,7 +547,7 @@ void br_features_recompute(struct net_bridge *br, netdev_features_t *features)
 		*features = netdev_increment_features(*features,
 						      p->dev->features, mask);
 	}
-	*features = netdev_add_tso_features(*features, mask);
+	netdev_add_tso_features(features, mask);
 }
 
 /* called with RTNL */
-- 
2.33.0

