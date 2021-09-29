Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F60B41C95A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345169AbhI2QEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:37 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13840 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345627AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWg2DhJz8ywR;
        Wed, 29 Sep 2021 23:53:35 +0800 (CST)
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
Subject: [RFCv2 net-next 120/167] net: ti: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:47 +0800
Message-ID: <20210929155334.12454-121-shenjian15@huawei.com>
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
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 23 ++++++++++++++---------
 drivers/net/ethernet/ti/cpsw.c           |  6 ++++--
 drivers/net/ethernet/ti/cpsw_new.c       |  7 ++++---
 drivers/net/ethernet/ti/netcp_core.c     |  9 +++++----
 4 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 0de5f4a4fe08..da28db9fa6ed 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -748,7 +748,8 @@ static void am65_cpsw_nuss_rx_csum(struct sk_buff *skb, u32 csum_info)
 	 */
 	skb_checksum_none_assert(skb);
 
-	if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      skb->dev->features)))
 		return;
 
 	if ((csum_info & (AM65_CPSW_RX_PSD_IPV6_VALID |
@@ -1974,19 +1975,23 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	port->ndev->min_mtu = AM65_CPSW_MIN_PACKET_SIZE;
 	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
-	port->ndev->hw_features = NETIF_F_SG |
-				  NETIF_F_RXCSUM |
-				  NETIF_F_HW_CSUM |
-				  NETIF_F_HW_TC;
-	port->ndev->features = port->ndev->hw_features |
-			       NETIF_F_HW_VLAN_CTAG_FILTER;
-	port->ndev->vlan_features |=  NETIF_F_SG;
+	netdev_feature_zero(&port->ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_RXCSUM |
+				NETIF_F_HW_CSUM |
+				NETIF_F_HW_TC,
+				&port->ndev->hw_features);
+	netdev_feature_copy(&port->ndev->features, port->ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			       &port->ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &port->ndev->vlan_features);
 	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
 
 	/* Disable TX checksum offload by default due to HW bug */
 	if (common->pdata.quirks & AM65_CPSW_QUIRK_I2027_NO_TX_CSUM)
-		port->ndev->features &= ~NETIF_F_HW_CSUM;
+		netdev_feature_clear_bit(NETIF_F_HW_CSUM_BIT,
+					 &port->ndev->features);
 
 	ndev_priv->stats = netdev_alloc_pcpu_stats(struct am65_cpsw_ndev_stats);
 	if (!ndev_priv->stats)
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 66f7ddd9b1f9..025fef70665d 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1464,7 +1464,8 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 
 	priv_sl2->emac_port = 1;
 	cpsw->slaves[1].ndev = ndev;
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_CTAG_RX, &ndev->features);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
@@ -1643,7 +1644,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	cpsw->slaves[0].ndev = ndev;
 
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_CTAG_RX, &ndev->features);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 1530532748a8..25fa7eb9ad1e 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1406,9 +1406,10 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 
 		cpsw->slaves[i].ndev = ndev;
 
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL;
-
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+					NETIF_F_HW_VLAN_CTAG_RX |
+					NETIF_F_NETNS_LOCAL,
+					&ndev->features);
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index eda2961c0fe2..a0129d484f45 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1976,10 +1976,11 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 		return -ENOMEM;
 	}
 
-	ndev->features |= NETIF_F_SG;
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-	ndev->hw_features = ndev->features;
-	ndev->vlan_features |=  NETIF_F_SG;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			       &ndev->features);
+	netdev_feature_copy(&ndev->hw_features, ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->vlan_features);
 
 	/* MTU range: 68 - 9486 */
 	ndev->min_mtu = ETH_MIN_MTU;
-- 
2.33.0

