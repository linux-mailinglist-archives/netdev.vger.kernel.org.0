Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26B041C941
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345922AbhI2QDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12994 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345555AbhI2P77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:59 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbX5yG7zWWWk;
        Wed, 29 Sep 2021 23:56:56 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:16 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 136/167] net: microchip: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:03 +0800
Message-ID: <20210929155334.12454-137-shenjian15@huawei.com>
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
 drivers/net/ethernet/microchip/lan743x_main.c       | 7 +++++--
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 9e8561cdc32a..00f06f690078 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2807,8 +2807,11 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 
 	adapter->netdev->netdev_ops = &lan743x_netdev_ops;
 	adapter->netdev->ethtool_ops = &lan743x_ethtool_ops;
-	adapter->netdev->features = NETIF_F_SG | NETIF_F_TSO | NETIF_F_HW_CSUM;
-	adapter->netdev->hw_features = adapter->netdev->features;
+	netdev_feature_zero(&adapter->netdev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO | NETIF_F_HW_CSUM,
+				&adapter->netdev->features);
+	netdev_feature_copy(&adapter->netdev->hw_features,
+			    adapter->netdev->features);
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 7436f62fa152..082f28476e16 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -238,7 +238,7 @@ static bool sparx5_fdma_rx_get_frame(struct sparx5 *sparx5, struct sparx5_rx *rx
 	}
 	skb->dev = port->ndev;
 	skb_pull(skb, IFH_LEN * sizeof(u32));
-	if (likely(!(skb->dev->features & NETIF_F_RXFCS)))
+	if (likely(!netdev_feature_test_bit(NETIF_F_RXFCS_BIT, skb->dev->features)))
 		skb_trim(skb, skb->len - ETH_FCS_LEN);
 	skb->protocol = eth_type_trans(skb, skb->dev);
 	/* Everything we see on an interface that is in the HW bridge
-- 
2.33.0

