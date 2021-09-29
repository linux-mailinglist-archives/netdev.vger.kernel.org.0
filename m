Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8056841C950
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346419AbhI2QEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:09 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27910 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345613AbhI2QAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:03 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLX35lJyzbmvj;
        Wed, 29 Sep 2021 23:53:55 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:13 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 115/167] net: cortina: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:42 +0800
Message-ID: <20210929155334.12454-116-shenjian15@huawei.com>
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
 drivers/net/ethernet/cortina/gemini.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 44397d1f44e4..bc3575dc2a87 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1980,17 +1980,19 @@ static void gmac_fix_features(struct net_device *netdev,
 			      netdev_features_t *features)
 {
 	if (netdev->mtu + ETH_HLEN + VLAN_HLEN > MTU_SIZE_BIT_MASK)
-		*features &= ~GMAC_OFFLOAD_FEATURES;
+		netdev_feature_clear_bits(GMAC_OFFLOAD_FEATURES, features);
 }
 
 static int gmac_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
-	int enable = features & NETIF_F_RXCSUM;
 	unsigned long flags;
+	int enable;
 	u32 reg;
 
+	enable = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features);
+
 	spin_lock_irqsave(&port->config_lock, flags);
 
 	reg = readl(port->gmac_base + GMAC_CONFIG0);
@@ -2452,8 +2454,10 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	spin_lock_init(&port->config_lock);
 	gmac_clear_hw_stats(netdev);
 
-	netdev->hw_features = GMAC_OFFLOAD_FEATURES;
-	netdev->features |= GMAC_OFFLOAD_FEATURES | NETIF_F_GRO;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(GMAC_OFFLOAD_FEATURES, &netdev->hw_features);
+	netdev_feature_set_bits(GMAC_OFFLOAD_FEATURES | NETIF_F_GRO,
+				&netdev->features);
 	/* We can handle jumbo frames up to 10236 bytes so, let's accept
 	 * payloads of 10236 bytes minus VLAN and ethernet header
 	 */
-- 
2.33.0

