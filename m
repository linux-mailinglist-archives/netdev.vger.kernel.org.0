Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C1741C971
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346023AbhI2QFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:21 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24138 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345650AbhI2QAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:06 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbW2rCSz1DHMt;
        Wed, 29 Sep 2021 23:56:55 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:14 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 125/167] net: 3com: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:52 +0800
Message-ID: <20210929155334.12454-126-shenjian15@huawei.com>
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
 drivers/net/ethernet/3com/3c59x.c   |  9 ++++++---
 drivers/net/ethernet/3com/typhoon.c | 10 ++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 7b0ae9efc004..d5bdd8a97a61 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1446,7 +1446,8 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 		if (card_idx < MAX_UNITS &&
 		    ((hw_checksums[card_idx] == -1 && (vp->drv_flags & HAS_HWCKSM)) ||
 				hw_checksums[card_idx] == 1)) {
-			dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
+			netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG,
+						&dev->features);
 		}
 	} else
 		dev->netdev_ops =  &vortex_netdev_ops;
@@ -1454,8 +1455,10 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 	if (print_info) {
 		pr_info("%s: scatter/gather %sabled. h/w checksums %sabled\n",
 				print_name,
-				(dev->features & NETIF_F_SG) ? "en":"dis",
-				(dev->features & NETIF_F_IP_CSUM) ? "en":"dis");
+				netdev_feature_test_bit(NETIF_F_SG_BIT,
+							dev->features) ? "en" : "dis",
+				netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT,
+							dev->features) ? "en" : "dis");
 	}
 
 	dev->ethtool_ops = &vortex_ethtool_ops;
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 05e15b6e5e2c..5ec10b9217f1 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2458,10 +2458,12 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * on the current 3XP firmware -- it does not respect the offload
 	 * settings -- so we only allow the user to toggle the TX processing.
 	 */
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_HW_VLAN_CTAG_TX;
-	dev->features = dev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_RXCSUM;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
+				NETIF_F_HW_VLAN_CTAG_TX, &dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_RXCSUM,
+				&dev->features);
 
 	err = register_netdev(dev);
 	if (err < 0) {
-- 
2.33.0

