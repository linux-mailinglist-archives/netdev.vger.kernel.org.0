Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185125BBD21
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiIRJva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiIRJuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC74312620
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:58 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbx6H79zlVwL;
        Sun, 18 Sep 2022 17:45:49 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:52 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 37/55] net: adjust the prototype of netdev_add_tso_features()
Date:   Sun, 18 Sep 2022 09:43:18 +0000
Message-ID: <20220918094336.28958-38-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function netdev_add_tos_features() using netdev_features_t
as parameters, and returns netdev_features_t directly. For the
prototype of netdev_features_t will be extended to be larger
than 8 bytes, so change the prototype of the function, change
the prototype of input features to ‘netdev_features_t *',
and return the features pointer as output parameters.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/bonding/bond_main.c | 2 +-
 drivers/net/team/team.c         | 2 +-
 include/linux/netdevice.h       | 7 +++----
 net/bridge/br_if.c              | 2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5c76a55392aa..a50f8935658a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1420,7 +1420,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 		netdev_increment_features(&features, &features,
 					  &slave->dev->features, &mask);
 	}
-	features = netdev_add_tso_features(features, mask);
+	netdev_add_tso_features(&features, &mask);
 
 	return features;
 }
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8d3a97d2d1dc..508424471c28 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2018,7 +2018,7 @@ static netdev_features_t team_fix_features(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
-	features = netdev_add_tso_features(features, mask);
+	netdev_add_tso_features(&features, &mask);
 
 	return features;
 }
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3f451906d62c..ec9e7cf7efbc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4899,11 +4899,10 @@ void netdev_increment_features(netdev_features_t *ret,
  * Performing the GSO segmentation before last device
  * is a performance improvement.
  */
-static inline netdev_features_t netdev_add_tso_features(netdev_features_t features,
-							netdev_features_t mask)
+static inline void netdev_add_tso_features(netdev_features_t *features,
+					   const netdev_features_t *mask)
 {
-	netdev_increment_features(&features, &features, &NETIF_F_ALL_TSO, &mask);
-	return features;
+	netdev_increment_features(features, features, &NETIF_F_ALL_TSO, mask);
 }
 
 int __netdev_update_features(struct net_device *dev);
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index fa348a984aa9..2a9b564ff234 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -548,7 +548,7 @@ netdev_features_t br_features_recompute(struct net_bridge *br,
 		netdev_increment_features(&features, &features,
 					  &p->dev->features, &mask);
 	}
-	features = netdev_add_tso_features(features, mask);
+	netdev_add_tso_features(&features, &mask);
 
 	return features;
 }
-- 
2.33.0

