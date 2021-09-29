Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852C341C91F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345982AbhI2QBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:42 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23248 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345483AbhI2P7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:48 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbs4nfsz8tVc;
        Wed, 29 Sep 2021 23:57:13 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 070/167] net: ifb: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:57 +0800
Message-ID: <20210929155334.12454-71-shenjian15@huawei.com>
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
 drivers/net/ifb.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index e9258a9f3702..c7cf224f8bed 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -213,11 +213,13 @@ static void ifb_setup(struct net_device *dev)
 	ether_setup(dev);
 	dev->tx_queue_len = TX_Q_LIMIT;
 
-	dev->features |= IFB_FEATURES;
-	dev->hw_features |= dev->features;
-	dev->hw_enc_features |= dev->features;
-	dev->vlan_features |= IFB_FEATURES & ~(NETIF_F_HW_VLAN_CTAG_TX |
-					       NETIF_F_HW_VLAN_STAG_TX);
+	netdev_feature_set_bits(IFB_FEATURES, &dev->features);
+	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(&dev->hw_enc_features, dev->hw_enc_features,
+			  dev->features);
+	netdev_feature_set_bits(IFB_FEATURES & ~(NETIF_F_HW_VLAN_CTAG_TX |
+						 NETIF_F_HW_VLAN_STAG_TX),
+				&dev->vlan_features);
 
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
-- 
2.33.0

