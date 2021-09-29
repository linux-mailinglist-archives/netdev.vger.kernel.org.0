Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E50D41C912
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345915AbhI2QBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:17 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13840 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345465AbhI2P7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:48 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWV2wB6z8ymr;
        Wed, 29 Sep 2021 23:53:26 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:04 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 062/167] xen-netback: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:49 +0800
Message-ID: <20210929155334.12454-63-shenjian15@huawei.com>
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
 drivers/net/xen-netback/interface.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index f964f0a402a6..8acfc1f1e716 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -380,15 +380,15 @@ static void xenvif_fix_features(struct net_device *dev,
 	struct xenvif *vif = netdev_priv(dev);
 
 	if (!vif->can_sg)
-		*features &= ~NETIF_F_SG;
+		netdev_feature_clear_bit(NETIF_F_SG_BIT, features);
 	if (~(vif->gso_mask) & GSO_BIT(TCPV4))
-		*features &= ~NETIF_F_TSO;
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 	if (~(vif->gso_mask) & GSO_BIT(TCPV6))
-		*features &= ~NETIF_F_TSO6;
+		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, features);
 	if (!vif->ip_csum)
-		*features &= ~NETIF_F_IP_CSUM;
+		netdev_feature_clear_bit(NETIF_F_IP_CSUM_BIT, features);
 	if (!vif->ipv6_csum)
-		*features &= ~NETIF_F_IPV6_CSUM;
+		netdev_feature_clear_bit(NETIF_F_IPV6_CSUM_BIT, features);
 }
 
 static const struct xenvif_stat {
@@ -532,10 +532,13 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	INIT_LIST_HEAD(&vif->fe_mcast_addr);
 
 	dev->netdev_ops	= &xenvif_netdev_ops;
-	dev->hw_features = NETIF_F_SG |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_FRAGLIST;
-	dev->features = dev->hw_features | NETIF_F_RXCSUM;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_FRAGLIST,
+				&dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
 	dev->tx_queue_len = XENVIF_QUEUE_LENGTH;
-- 
2.33.0

