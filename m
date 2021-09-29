Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C994C41C922
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344886AbhI2QBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:47 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23323 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345415AbhI2P7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:47 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWs3WmXzRWx4;
        Wed, 29 Sep 2021 23:53:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 046/167] netdevsim: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:33 +0800
Message-ID: <20210929155334.12454-47-shenjian15@huawei.com>
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
 drivers/net/netdevsim/ipsec.c  |  4 ++--
 drivers/net/netdevsim/netdev.c | 15 ++++++++-------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index b80ed2ffd45e..3b77c376e34f 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -280,8 +280,8 @@ void nsim_ipsec_init(struct netdevsim *ns)
 				 NETIF_F_HW_ESP_TX_CSUM | \
 				 NETIF_F_GSO_ESP)
 
-	ns->netdev->features |= NSIM_ESP_FEATURES;
-	ns->netdev->hw_enc_features |= NSIM_ESP_FEATURES;
+	netdev_feature_set_bits(NSIM_ESP_FEATURES, &ns->netdev->features);
+	netdev_feature_set_bits(NSIM_ESP_FEATURES, &ns->netdev->hw_enc_features);
 
 	ns->ipsec.pfile = debugfs_create_file("ipsec", 0400,
 					      ns->nsim_dev_port->ddir, ns,
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 50572e0f1f52..895b5487bbee 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -232,7 +232,8 @@ nsim_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
-	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC))
+	if (netdev_feature_test_bit(NETIF_F_HW_TC_BIT, dev->features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_TC_BIT, features))
 		return nsim_bpf_disable_tc(ns);
 
 	return 0;
@@ -288,12 +289,12 @@ static void nsim_setup(struct net_device *dev)
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE |
 			   IFF_NO_QUEUE;
-	dev->features |= NETIF_F_HIGHDMA |
-			 NETIF_F_SG |
-			 NETIF_F_FRAGLIST |
-			 NETIF_F_HW_CSUM |
-			 NETIF_F_TSO;
-	dev->hw_features |= NETIF_F_HW_TC;
+	netdev_feature_set_bits(NETIF_F_HIGHDMA |
+				NETIF_F_SG |
+				NETIF_F_FRAGLIST |
+				NETIF_F_HW_CSUM |
+				NETIF_F_TSO, &dev->features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &dev->hw_features);
 	dev->max_mtu = ETH_MAX_MTU;
 }
 
-- 
2.33.0

