Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C808941C979
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344635AbhI2QFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:41 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24187 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345665AbhI2QAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:08 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLc23VyZz8tYD;
        Wed, 29 Sep 2021 23:57:22 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [RFCv2 net-next 126/167] net: aeroflex: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:53 +0800
Message-ID: <20210929155334.12454-127-shenjian15@huawei.com>
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
 drivers/net/ethernet/aeroflex/greth.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index c560ad06f0be..2c0fc8103386 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -914,7 +914,9 @@ static int greth_rx_gbit(struct net_device *dev, int limit)
 
 				skb_put(skb, pkt_len);
 
-				if (dev->features & NETIF_F_RXCSUM && hw_checksummed(status))
+				if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+							    dev->features) &&
+				    hw_checksummed(status))
 					skb->ip_summed = CHECKSUM_UNNECESSARY;
 				else
 					skb_checksum_none_assert(skb);
@@ -1483,9 +1485,11 @@ static int greth_of_probe(struct platform_device *ofdev)
 	GRETH_REGSAVE(regs->status, 0xFF);
 
 	if (greth->gbit_mac) {
-		dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-			NETIF_F_RXCSUM;
-		dev->features = dev->hw_features | NETIF_F_HIGHDMA;
+		netdev_feature_zero(&dev->hw_features);
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+					NETIF_F_RXCSUM, &dev->hw_features);
+		netdev_feature_copy(&dev->features, dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 		greth_netdev_ops.ndo_start_xmit = greth_start_xmit_gbit;
 	}
 
-- 
2.33.0

