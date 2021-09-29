Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C0641C988
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345720AbhI2QGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13841 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345691AbhI2QAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:19 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWn2CN8z8ywM;
        Wed, 29 Sep 2021 23:53:41 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:19 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 159/167] net: ieee802154: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:26 +0800
Message-ID: <20210929155334.12454-160-shenjian15@huawei.com>
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
 net/ieee802154/6lowpan/core.c |  2 +-
 net/ieee802154/core.c         | 14 +++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ieee802154/6lowpan/core.c b/net/ieee802154/6lowpan/core.c
index 3297e7fa9945..23a0b7e4474f 100644
--- a/net/ieee802154/6lowpan/core.c
+++ b/net/ieee802154/6lowpan/core.c
@@ -115,7 +115,7 @@ static void lowpan_setup(struct net_device *ldev)
 	ldev->netdev_ops	= &lowpan_netdev_ops;
 	ldev->header_ops	= &lowpan_header_ops;
 	ldev->needs_free_netdev	= true;
-	ldev->features		|= NETIF_F_NETNS_LOCAL;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &ldev->features);
 }
 
 static int lowpan_validate(struct nlattr *tb[], struct nlattr *data[],
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index de259b5170ab..04d613a8e7c2 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -204,11 +204,13 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	list_for_each_entry(wpan_dev, &rdev->wpan_dev_list, list) {
 		if (!wpan_dev->netdev)
 			continue;
-		wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+		netdev_feature_clear_bit(NETIF_F_NETNS_LOCAL_BIT,
+					 &wpan_dev->netdev->features);
 		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
 		if (err)
 			break;
-		wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+				       &wpan_dev->netdev->features);
 	}
 
 	if (err) {
@@ -220,11 +222,13 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 						     list) {
 			if (!wpan_dev->netdev)
 				continue;
-			wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+			netdev_feature_clear_bit(NETIF_F_NETNS_LOCAL_BIT,
+						 &wpan_dev->netdev->features);
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
 			WARN_ON(err);
-			wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
+			netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+					       &wpan_dev->netdev->features);
 		}
 
 		return err;
@@ -269,7 +273,7 @@ static int cfg802154_netdev_notifier_call(struct notifier_block *nb,
 	switch (state) {
 		/* TODO NETDEV_DEVTYPE */
 	case NETDEV_REGISTER:
-		dev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
 		wpan_dev->identifier = ++rdev->wpan_dev_id;
 		list_add_rcu(&wpan_dev->list, &rdev->wpan_dev_list);
 		rdev->devlist_generation++;
-- 
2.33.0

