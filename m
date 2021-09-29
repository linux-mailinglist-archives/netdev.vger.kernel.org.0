Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF2841C930
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344429AbhI2QCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:20 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24130 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343997AbhI2P7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:43 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbC57d2z1DHJQ;
        Wed, 29 Sep 2021 23:56:39 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:57 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 014/167] net: convert the prototype of br_features_recompute
Date:   Wed, 29 Sep 2021 23:51:01 +0800
Message-ID: <20210929155334.12454-15-shenjian15@huawei.com>
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
br_features_recompute for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/bridge/br_device.c  |  2 +-
 net/bridge/br_if.c      | 17 +++++++----------
 net/bridge/br_private.h |  3 +--
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 622559aff2dd..fc508b9cbaa9 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -292,7 +292,7 @@ static void br_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct net_bridge *br = netdev_priv(dev);
 
-	*features = br_features_recompute(br, *features);
+	br_features_recompute(br, features);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4a02f8bb278a..b2afbea2133e 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -532,25 +532,22 @@ static void br_set_gso_limits(struct net_bridge *br)
 /*
  * Recomputes features using slave's features
  */
-netdev_features_t br_features_recompute(struct net_bridge *br,
-	netdev_features_t features)
+void br_features_recompute(struct net_bridge *br, netdev_features_t *features)
 {
 	struct net_bridge_port *p;
 	netdev_features_t mask;
 
 	if (list_empty(&br->port_list))
-		return features;
+		return;
 
-	mask = features;
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	mask = *features;
+	*features &= ~NETIF_F_ONE_FOR_ALL;
 
 	list_for_each_entry(p, &br->port_list, list) {
-		features = netdev_increment_features(features,
-						     p->dev->features, mask);
+		*features = netdev_increment_features(*features,
+						      p->dev->features, mask);
 	}
-	features = netdev_add_tso_features(features, mask);
-
-	return features;
+	*features = netdev_add_tso_features(*features, mask);
 }
 
 /* called with RTNL */
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b4cef3a97f12..1f5cff791827 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -824,8 +824,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	      struct netlink_ext_ack *extack);
 int br_del_if(struct net_bridge *br, struct net_device *dev);
 void br_mtu_auto_adjust(struct net_bridge *br);
-netdev_features_t br_features_recompute(struct net_bridge *br,
-					netdev_features_t features);
+void br_features_recompute(struct net_bridge *br, netdev_features_t *features);
 void br_port_flags_change(struct net_bridge_port *port, unsigned long mask);
 void br_manage_promisc(struct net_bridge *br);
 int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
-- 
2.33.0

