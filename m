Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE5941C903
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345803AbhI2QAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27912 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344370AbhI2P7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWs5WgPzbmgn;
        Wed, 29 Sep 2021 23:53:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 047/167] virtio_net: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:34 +0800
Message-ID: <20210929155334.12454-48-shenjian15@huawei.com>
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
 drivers/net/virtio_net.c | 50 +++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2ed49884565f..5307bc4f3c99 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2648,11 +2648,12 @@ static int virtnet_set_features(struct net_device *dev,
 	u64 offloads;
 	int err;
 
-	if ((dev->features ^ features) & NETIF_F_GRO_HW) {
+	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, dev->features) !=
+	    netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, features)) {
 		if (vi->xdp_enabled)
 			return -EBUSY;
 
-		if (features & NETIF_F_GRO_HW)
+		if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, features))
 			offloads = vi->guest_offloads_capable;
 		else
 			offloads = vi->guest_offloads_capable &
@@ -2907,7 +2908,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 	if (vi->has_cvq) {
 		vi->cvq = vqs[total_vqs - 1];
 		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
-			vi->dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					       &vi->dev->features);
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -3118,7 +3120,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
 			   IFF_TX_SKB_NO_LINEAR;
 	dev->netdev_ops = &virtnet_netdev;
-	dev->features = NETIF_F_HIGHDMA;
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 
 	dev->ethtool_ops = &virtnet_ethtool_ops;
 	SET_NETDEV_DEV(dev, &vdev->dev);
@@ -3126,37 +3129,48 @@ static int virtnet_probe(struct virtio_device *vdev)
 	/* Do we support "hardware" checksums? */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CSUM)) {
 		/* This opens up the world of extra features. */
-		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+		netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG,
+					&dev->hw_features);
 		if (csum)
-			dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+			netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG,
+						&dev->features);
 
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
-			dev->hw_features |= NETIF_F_TSO
-				| NETIF_F_TSO_ECN | NETIF_F_TSO6;
+			netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO_ECN |
+						NETIF_F_TSO6,
+						&dev->hw_features);
 		}
 		/* Individual feature bits: what can host handle? */
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO4))
-			dev->hw_features |= NETIF_F_TSO;
+			netdev_feature_set_bit(NETIF_F_TSO_BIT,
+					       &dev->hw_features);
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO6))
-			dev->hw_features |= NETIF_F_TSO6;
+			netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+					       &dev->hw_features);
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
-			dev->hw_features |= NETIF_F_TSO_ECN;
+			netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT,
+					       &dev->hw_features);
 
-		dev->features |= NETIF_F_GSO_ROBUST;
+		netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, &dev->features);
 
-		if (gso)
-			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
+		if (gso) {
+			netdev_features_t tmp;
+
+			netdev_feature_copy(&tmp, dev->hw_features);
+			netdev_feature_and_bits(NETIF_F_ALL_TSO, &tmp);
+			netdev_feature_or(&dev->features, dev->features, tmp);
+		}
 		/* (!csum && gso) case will be fixed by register_netdev() */
 	}
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
-		dev->features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
-		dev->features |= NETIF_F_GRO_HW;
+		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, &dev->features);
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
-		dev->hw_features |= NETIF_F_GRO_HW;
+		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, &dev->hw_features);
 
-	dev->vlan_features = dev->features;
+	netdev_feature_copy(&dev->vlan_features, dev->features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = MIN_MTU;
-- 
2.33.0

