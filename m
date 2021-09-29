Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AB641C98C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346127AbhI2QG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23326 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345719AbhI2QAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:24 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX9035WzRd6L;
        Wed, 29 Sep 2021 23:54:01 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:18 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 150/167] RDMA: ipoib: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:17 +0800
Message-ID: <20210929155334.12454-151-shenjian15@huawei.com>
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
 drivers/infiniband/hw/hfi1/vnic_main.c     |  7 ++++---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c  | 16 ++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |  2 +-
 5 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index 3650fababf25..c02cf9467c62 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -588,9 +588,10 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
 	rn->free_rdma_netdev = hfi1_vnic_free_rn;
 	rn->set_id = hfi1_vnic_set_vesw_id;
 
-	netdev->features = NETIF_F_HIGHDMA | NETIF_F_SG;
-	netdev->hw_features = netdev->features;
-	netdev->vlan_features = netdev->features;
+	netdev_feature_zero(&netdev->features);
+	netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_SG, &netdev->features);
+	netdev_feature_copy(&netdev->hw_features, netdev->features)
+	netdev_feature_copy(&netdev->vlan_features, netdev->features)
 	netdev->watchdog_timeo = msecs_to_jiffies(HFI_TX_TIMEOUT_MS);
 	netdev->netdev_ops = &hfi1_netdev_ops;
 	mutex_init(&vinfo->lock);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 684c2ddb16f5..6b22253813ac 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1070,7 +1070,7 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
 	};
 	struct ib_qp *tx_qp;
 
-	if (dev->features & NETIF_F_SG)
+	if (netdev_feature_test_bit(NETIF_F_SG_BIT, dev->features))
 		attr.cap.max_send_sge = min_t(u32, priv->ca->attrs.max_send_sge,
 					      MAX_SKB_FRAGS + 1);
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index ceabfb0b0a83..a9fc7e58c689 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -260,7 +260,7 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		dev->stats.multicast++;
 
 	skb->dev = dev;
-	if ((dev->features & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features) &&
 			likely(wc->wc_flags & IB_WC_IP_CSUM_OK))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 488d50a82a87..5fd0b7a1bcb9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -220,7 +220,8 @@ static void ipoib_fix_features(struct net_device *dev,
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
-		*features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
+		netdev_feature_clear_bits(NETIF_F_IP_CSUM | NETIF_F_TSO,
+					  features);
 }
 
 static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
@@ -1849,12 +1850,15 @@ static void ipoib_set_dev_features(struct ipoib_dev_priv *priv)
 	priv->hca_caps = priv->ca->attrs.device_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
-		priv->dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
+					&priv->dev->hw_features);
 
 		if (priv->hca_caps & IB_DEVICE_UD_TSO)
-			priv->dev->hw_features |= NETIF_F_TSO;
+			netdev_feature_set_bit(NETIF_F_TSO_BIT,
+					       &priv->dev->hw_features);
 
-		priv->dev->features |= priv->dev->hw_features;
+		netdev_feature_or(&priv->dev->features, priv->dev->features,
+				  priv->dev->hw_features);
 	}
 }
 
@@ -2117,8 +2121,8 @@ void ipoib_setup_common(struct net_device *dev)
 	dev->addr_len		 = INFINIBAND_ALEN;
 	dev->type		 = ARPHRD_INFINIBAND;
 	dev->tx_queue_len	 = ipoib_sendq_size * 2;
-	dev->features		 = (NETIF_F_VLAN_CHALLENGED	|
-				    NETIF_F_HIGHDMA);
+	netdev_feature_set_bits(NETIF_F_VLAN_CHALLENGED	|
+				NETIF_F_HIGHDMA, &dev->features);
 	netif_keep_dst(dev);
 
 	memcpy(dev->broadcast, ipv4_bcast_addr, INFINIBAND_ALEN);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 5a150a080ac2..d0437c302ef4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -234,7 +234,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	priv->rx_wr.sg_list = priv->rx_sge;
 
 	if (init_attr.cap.max_send_sge > 1)
-		dev->features |= NETIF_F_SG;
+		netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->features);
 
 	priv->max_send_sge = init_attr.cap.max_send_sge;
 
-- 
2.33.0

