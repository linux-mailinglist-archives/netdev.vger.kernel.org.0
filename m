Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F50341C991
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345368AbhI2QGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:38 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24190 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345798AbhI2QAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:45 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLc53yh8z8tYN;
        Wed, 29 Sep 2021 23:57:25 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:17 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 146/167] net: via: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:13 +0800
Message-ID: <20210929155334.12454-147-shenjian15@huawei.com>
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
 drivers/net/ethernet/via/via-rhine.c    | 10 ++++++----
 drivers/net/ethernet/via/via-velocity.c | 14 +++++++++-----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 3b73a9c55a5a..77b6cc9b2d63 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -966,12 +966,14 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 	netif_napi_add(dev, &rp->napi, rhine_napipoll, 64);
 
 	if (rp->quirks & rqRhineI)
-		dev->features |= NETIF_F_SG|NETIF_F_HW_CSUM;
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
+					&dev->features);
 
 	if (rp->quirks & rqMgmt)
-		dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-				 NETIF_F_HW_VLAN_CTAG_RX |
-				 NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_CTAG_RX |
+					NETIF_F_HW_VLAN_CTAG_FILTER,
+					&dev->features);
 
 	/* dev->name not defined before register_netdev()! */
 	rc = register_netdev(dev);
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 4b9c30f735b5..583752b0d1cf 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2847,11 +2847,15 @@ static int velocity_probe(struct device *dev, int irq,
 	netif_napi_add(netdev, &vptr->napi, velocity_poll,
 							VELOCITY_NAPI_WEIGHT);
 
-	netdev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-			   NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_IP_CSUM;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
+				NETIF_F_HW_VLAN_CTAG_TX,
+				&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_IP_CSUM,
+				&netdev->features);
 
 	/* MTU range: 64 - 9000 */
 	netdev->min_mtu = VELOCITY_MIN_MTU;
-- 
2.33.0

