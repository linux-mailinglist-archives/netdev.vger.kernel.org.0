Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80D541C976
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245118AbhI2QFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:33 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23247 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345471AbhI2QAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:07 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLc1231Jz8tX6;
        Wed, 29 Sep 2021 23:57:21 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:13 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:13 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 118/167] net: xgmac: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:45 +0800
Message-ID: <20210929155334.12454-119-shenjian15@huawei.com>
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
 drivers/net/ethernet/calxeda/xgmac.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index b6a066404f4b..10792529ef56 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -974,7 +974,7 @@ static int xgmac_hw_init(struct net_device *dev)
 
 	ctrl |= XGMAC_CONTROL_DDIC | XGMAC_CONTROL_JE | XGMAC_CONTROL_ACS |
 		XGMAC_CONTROL_CAR;
-	if (dev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features))
 		ctrl |= XGMAC_CONTROL_IPC;
 	writel(ctrl, ioaddr + XGMAC_CONTROL);
 
@@ -1491,13 +1491,15 @@ static int xgmac_set_features(struct net_device *dev, netdev_features_t features
 	u32 ctrl;
 	struct xgmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = priv->base;
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
-	if (!(changed & NETIF_F_RXCSUM))
+	netdev_feature_xor(&changed, dev->features, features);
+
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	ctrl = readl(ioaddr + XGMAC_CONTROL);
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		ctrl |= XGMAC_CONTROL_IPC;
 	else
 		ctrl &= ~XGMAC_CONTROL_IPC;
@@ -1773,11 +1775,13 @@ static int xgmac_probe(struct platform_device *pdev)
 	if (device_can_wakeup(priv->device))
 		priv->wolopts = WAKE_MAGIC;	/* Magic Frame as default */
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA;
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA,
+				&ndev->hw_features);
+
 	if (readl(priv->base + XGMAC_DMA_HW_FEATURE) & DMA_HW_FEAT_TXCOESEL)
-		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				     NETIF_F_RXCSUM;
-	ndev->features |= ndev->hw_features;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+					NETIF_F_RXCSUM, &ndev->hw_features);
+	netdev_feature_or(&ndev->features, &ndev->features, &ndev->hw_features);
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 46 - 9000 */
-- 
2.33.0

