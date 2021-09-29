Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC95F41C954
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346522AbhI2QE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:29 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27914 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345621AbhI2QAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:04 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLX40kspzbmvw;
        Wed, 29 Sep 2021 23:53:56 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [RFCv2 net-next 117/167] net: sxgbe: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:44 +0800
Message-ID: <20210929155334.12454-118-shenjian15@huawei.com>
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
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 6781aa636d58..b70ce380fa61 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1775,10 +1775,12 @@ static int sxgbe_set_features(struct net_device *dev,
 			      netdev_features_t features)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_RXCSUM) {
-		if (features & NETIF_F_RXCSUM) {
+	netdev_feature_xor(&changed, dev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 			priv->hw->mac->enable_rx_csum(priv->ioaddr);
 			priv->rxcsum_insertion = true;
 		} else {
@@ -2102,10 +2104,13 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 
 	ndev->netdev_ops = &sxgbe_netdev_ops;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_RXCSUM | NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_GRO;
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
+	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM |
+				NETIF_F_RXCSUM | NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_GRO, &ndev->hw_features);
+	netdev_feature_or(&ndev->features, ndev->features, ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
 	ndev->watchdog_timeo = msecs_to_jiffies(TX_TIMEO);
 
 	/* assign filtering support */
-- 
2.33.0

