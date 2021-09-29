Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F7141C96F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345969AbhI2QFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:17 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23248 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345623AbhI2QAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:06 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbx193Vz8tW1;
        Wed, 29 Sep 2021 23:57:17 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 091/167] net: davicom: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:18 +0800
Message-ID: <20210929155334.12454-92-shenjian15@huawei.com>
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
 drivers/net/ethernet/davicom/dm9000.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index e842de6f6635..cf349566d9e0 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -586,14 +586,17 @@ static int dm9000_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct board_info *dm = to_dm9000_board(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 	unsigned long flags;
 
-	if (!(changed & NETIF_F_RXCSUM))
+	netdev_feature_xor(&changed, dev->features, features);
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	spin_lock_irqsave(&dm->lock, flags);
-	iow(dm, DM9000_RCSR, (features & NETIF_F_RXCSUM) ? RCSR_CSUM : 0);
+	iow(dm, DM9000_RCSR,
+	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) ?
+	    RCSR_CSUM : 0);
 	spin_unlock_irqrestore(&dm->lock, flags);
 
 	return 0;
@@ -911,9 +914,10 @@ dm9000_init_dm9000(struct net_device *dev)
 	db->io_mode = ior(db, DM9000_ISR) >> 6;	/* ISR bit7:6 keeps I/O mode */
 
 	/* Checksum mode */
-	if (dev->hw_features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->hw_features))
 		iow(db, DM9000_RCSR,
-			(dev->features & NETIF_F_RXCSUM) ? RCSR_CSUM : 0);
+		    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    dev->features) ? RCSR_CSUM : 0);
 
 	iow(db, DM9000_GPCR, GPCR_GEP_CNTL);	/* Let GPIO0 output */
 	iow(db, DM9000_GPR, 0);
@@ -1169,7 +1173,8 @@ dm9000_rx(struct net_device *dev)
 
 			/* Pass to upper layer */
 			skb->protocol = eth_type_trans(skb, dev);
-			if (dev->features & NETIF_F_RXCSUM) {
+			if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						    dev->features)) {
 				if ((((rxbyte & 0x1c) << 3) & rxbyte) == 0)
 					skb->ip_summed = CHECKSUM_UNNECESSARY;
 				else
@@ -1643,8 +1648,11 @@ dm9000_probe(struct platform_device *pdev)
 
 	/* dm9000a/b are capable of hardware checksum offload */
 	if (db->type == TYPE_DM9000A || db->type == TYPE_DM9000B) {
-		ndev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
-		ndev->features |= ndev->hw_features;
+		netdev_feature_zero(&ndev->hw_features);
+		netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM,
+					&ndev->hw_features);
+		netdev_feature_or(&ndev->features, ndev->features,
+				  ndev->hw_features);
 	}
 
 	/* from this point we assume that we have found a DM9000 */
-- 
2.33.0

