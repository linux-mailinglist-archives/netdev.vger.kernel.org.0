Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D7E41C970
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345997AbhI2QFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:19 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13849 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345548AbhI2QAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:06 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWf2z30z8yth;
        Wed, 29 Sep 2021 23:53:34 +0800 (CST)
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
Subject: [RFCv2 net-next 114/167] net: neterion: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:41 +0800
Message-ID: <20210929155334.12454-115-shenjian15@huawei.com>
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
 drivers/net/ethernet/neterion/s2io.c          | 32 ++++++++------
 .../net/ethernet/neterion/vxge/vxge-main.c    | 43 ++++++++++++-------
 2 files changed, 47 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 09c0e839cca5..0e3f500ab5bb 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -6567,14 +6567,17 @@ static void s2io_ethtool_get_strings(struct net_device *dev,
 static int s2io_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct s2io_nic *sp = netdev_priv(dev);
-	netdev_features_t changed = (features ^ dev->features) & NETIF_F_LRO;
+	netdev_features_t changed;
 
-	if (changed && netif_running(dev)) {
+	netdev_feature_xor(&changed, features, dev->features);
+
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, changed) &&
+	    netif_running(dev)) {
 		int rc;
 
 		s2io_stop_all_tx_queue(sp);
 		s2io_card_down(sp);
-		dev->features = features;
+		netdev_feature_copy(&dev->features, features);
 		rc = s2io_card_up(sp);
 		if (rc)
 			s2io_reset(sp);
@@ -7120,7 +7123,8 @@ static int s2io_card_up(struct s2io_nic *sp)
 		struct ring_info *ring = &mac_control->rings[i];
 
 		ring->mtu = dev->mtu;
-		ring->lro = !!(dev->features & NETIF_F_LRO);
+		ring->lro = netdev_feature_test_bit(NETIF_F_LRO_BIT,
+						    dev->features);
 		ret = fill_rx_buffers(sp, ring, 1);
 		if (ret) {
 			DBG_PRINT(ERR_DBG, "%s: Out of memory in Open\n",
@@ -7154,7 +7158,7 @@ static int s2io_card_up(struct s2io_nic *sp)
 	/* Setting its receive mode */
 	s2io_set_multicast(dev, true);
 
-	if (dev->features & NETIF_F_LRO) {
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features)) {
 		/* Initialize max aggregatable pkts per session based on MTU */
 		sp->lro_max_aggr_per_sess = ((1<<16) - 1) / dev->mtu;
 		/* Check if we can use (if specified) user provided value */
@@ -7366,7 +7370,7 @@ static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp)
 	if ((rxdp->Control_1 & TCP_OR_UDP_FRAME) &&
 	    ((!ring_data->lro) ||
 	     (!(rxdp->Control_1 & RXD_FRAME_IP_FRAG))) &&
-	    (dev->features & NETIF_F_RXCSUM)) {
+	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features)) {
 		l3_csum = RXD_GET_L3_CKSUM(rxdp->Control_1);
 		l4_csum = RXD_GET_L4_CKSUM(rxdp->Control_1);
 		if ((l3_csum == L3_CKSUM_OK) && (l4_csum == L4_CKSUM_OK)) {
@@ -7861,13 +7865,17 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 	/*  Driver entry points */
 	dev->netdev_ops = &s2io_netdev_ops;
 	dev->ethtool_ops = &netdev_ethtool_ops;
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_RXCSUM | NETIF_F_LRO;
-	dev->features |= dev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_RXCSUM | NETIF_F_LRO,
+				&dev->hw_features);
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX,
+				&dev->features);
 	if (sp->high_dma_flag == true)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 	dev->watchdog_timeo = WATCH_DOG_TIMEOUT;
 	INIT_WORK(&sp->rst_timer_task, s2io_restart_nic);
 	INIT_WORK(&sp->set_link_task, s2io_set_link);
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 5f720e97a558..12d0508dbd7b 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -490,7 +490,8 @@ vxge_rx_1b_compl(struct __vxge_hw_ring *ringh, void *dtr,
 
 		if ((ext_info.proto & VXGE_HW_FRAME_PROTO_TCP_OR_UDP) &&
 		    !(ext_info.proto & VXGE_HW_FRAME_PROTO_IP_FRAG) &&
-		    (dev->features & NETIF_F_RXCSUM) && /* Offload Rx side CSUM */
+		    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    dev->features) && /* Offload Rx side CSUM */
 		    ext_info.l3_cksum == VXGE_HW_L3_CKSUM_OK &&
 		    ext_info.l4_cksum == VXGE_HW_L4_CKSUM_OK)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2642,27 +2643,33 @@ static void vxge_poll_vp_lockup(struct timer_list *t)
 static void vxge_fix_features(struct net_device *dev,
 			      netdev_features_t *features)
 {
-	netdev_features_t changed = dev->features ^ *features;
+	netdev_features_t changed;
+
+	netdev_feature_xor(&changed, dev->features, *features);
 
 	/* Enabling RTH requires some of the logic in vxge_device_register and a
 	 * vpath reset.  Due to these restrictions, only allow modification
 	 * while the interface is down.
 	 */
-	if ((changed & NETIF_F_RXHASH) && netif_running(dev))
-		*features ^= NETIF_F_RXHASH;
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, changed) &&
+	    netif_running(dev))
+		netdev_feature_change_bit(NETIF_F_RXHASH_BIT, features);
 }
 
 static int vxge_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct vxgedev *vdev = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
+
+	netdev_feature_xor(&changed, dev->features, features);
 
-	if (!(changed & NETIF_F_RXHASH))
+	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT, changed))
 		return 0;
 
 	/* !netif_running() ensured by vxge_fix_features() */
 
-	vdev->devh->config.rth_en = !!(features & NETIF_F_RXHASH);
+	vdev->devh->config.rth_en = netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+							    features);
 	vxge_reset_all_vpaths(vdev);
 
 	return 0;
@@ -3391,16 +3398,20 @@ static int vxge_device_register(struct __vxge_hw_device *hldev,
 
 	SET_NETDEV_DEV(ndev, &vdev->pdev->dev);
 
-	ndev->hw_features = NETIF_F_RXCSUM | NETIF_F_SG |
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO6 |
-		NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_SG |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_HW_VLAN_CTAG_TX,
+				&ndev->hw_features);
 	if (vdev->config.rth_steering != NO_STEERING)
-		ndev->hw_features |= NETIF_F_RXHASH;
-
-	ndev->features |= ndev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->hw_features);
 
+	netdev_feature_or(&ndev->features, ndev->features,
+			  ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER,
+				&ndev->features);
 
 	ndev->netdev_ops = &vxge_netdev_ops;
 
@@ -3424,7 +3435,7 @@ static int vxge_device_register(struct __vxge_hw_device *hldev,
 		"%s : checksumming enabled", __func__);
 
 	if (high_dma) {
-		ndev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
 		vxge_debug_init(vxge_hw_device_trace_level_get(hldev),
 			"%s : using High DMA", __func__);
 	}
-- 
2.33.0

