Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC0141C966
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346264AbhI2QDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23330 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345598AbhI2QAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:02 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX15y8xzR5GN;
        Wed, 29 Sep 2021 23:53:53 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:11 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 103/167] net: micrel: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:30 +0800
Message-ID: <20210929155334.12454-104-shenjian15@huawei.com>
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
 drivers/net/ethernet/micrel/ksz884x.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index a0ee155f9f51..a7bbe1c2fb01 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6504,7 +6504,7 @@ static int netdev_set_features(struct net_device *dev,
 	mutex_lock(&hw_priv->lock);
 
 	/* see note in hw_setup() */
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		hw->rx_cfg |= DMA_RX_CSUM_TCP | DMA_RX_CSUM_IP;
 	else
 		hw->rx_cfg &= ~(DMA_RX_CSUM_TCP | DMA_RX_CSUM_IP);
@@ -6702,15 +6702,17 @@ static int __init netdev_init(struct net_device *dev)
 	/* 500 ms timeout */
 	dev->watchdog_timeo = HZ / 2;
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_RXCSUM;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_RXCSUM,
+				&dev->hw_features);
 
 	/*
 	 * Hardware does not really support IPv6 checksum generation, but
 	 * driver actually runs faster with this on.
 	 */
-	dev->hw_features |= NETIF_F_IPV6_CSUM;
+	netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, &dev->hw_features);
 
-	dev->features |= dev->hw_features;
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
 
 	sema_init(&priv->proc_sem, 1);
 
-- 
2.33.0

