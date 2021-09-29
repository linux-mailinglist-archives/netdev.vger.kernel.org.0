Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9E141C935
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345823AbhI2QCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13844 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345503AbhI2P7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWY3Yf4z8yCQ;
        Wed, 29 Sep 2021 23:53:29 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:08 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:07 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 084/167] net: broadcom: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:11 +0800
Message-ID: <20210929155334.12454-85-shenjian15@huawei.com>
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
 drivers/net/ethernet/broadcom/b44.c           |   2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  24 +--
 drivers/net/ethernet/broadcom/bgmac.c         |   8 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  49 +++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  62 ++++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  84 ++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 152 +++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  11 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   3 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  12 +-
 drivers/net/ethernet/broadcom/tg3.c           |  56 ++++---
 12 files changed, 279 insertions(+), 188 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 38b465452902..d9e9742dec91 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2353,7 +2353,7 @@ static int b44_init_one(struct ssb_device *sdev,
 	SET_NETDEV_DEV(dev, sdev->dev);
 
 	/* No interesting netdevice features in this card... */
-	dev->features |= 0;
+	netdev_feature_set_bits(0, &dev->features);
 
 	bp = netdev_priv(dev);
 	bp->sdev = sdev;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 7fa1b695400d..0d686804fa6e 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -122,7 +122,7 @@ static void bcm_sysport_set_rx_csum(struct net_device *dev,
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	u32 reg;
 
-	priv->rx_chk_en = !!(wanted & NETIF_F_RXCSUM);
+	priv->rx_chk_en = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, wanted);
 	reg = rxchk_readl(priv, RXCHK_CONTROL);
 	/* Clear L2 header checks, which would prevent BPDUs
 	 * from being received.
@@ -162,8 +162,10 @@ static void bcm_sysport_set_tx_csum(struct net_device *dev,
 	/* Hardware transmit checksum requires us to enable the Transmit status
 	 * block prepended to the packet contents
 	 */
-	priv->tsb_en = !!(wanted & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				    NETIF_F_HW_VLAN_CTAG_TX));
+	priv->tsb_en = netdev_feature_test_bits(NETIF_F_IP_CSUM |
+						NETIF_F_IPV6_CSUM |
+						NETIF_F_HW_VLAN_CTAG_TX,
+						wanted);
 	reg = tdma_readl(priv, TDMA_CONTROL);
 	if (priv->tsb_en)
 		reg |= tdma_control_bit(priv, TSB_EN);
@@ -180,7 +182,7 @@ static void bcm_sysport_set_tx_csum(struct net_device *dev,
 	tdma_writel(priv, reg, TDMA_CONTROL);
 
 	/* Default TPID is ETH_P_8021AD, change to ETH_P_8021Q */
-	if (wanted & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, wanted))
 		tdma_writel(priv, ETH_P_8021Q, TDMA_TPID);
 }
 
@@ -1543,7 +1545,8 @@ static int bcm_sysport_init_tx_ring(struct bcm_sysport_priv *priv,
 	/* Adjust the packet size calculations if SYSTEMPORT is responsible
 	 * for HW insertion of VLAN tags
 	 */
-	if (priv->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				    priv->netdev->features))
 		reg = VLAN_HLEN << RING_PKT_SIZE_ADJ_SHIFT;
 	tdma_writel(priv, reg, TDMA_DESC_RING_PCP_DEI_VID(index));
 
@@ -2567,11 +2570,12 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	dev->netdev_ops = &bcm_sysport_netdev_ops;
 	netif_napi_add(dev, &priv->napi, bcm_sysport_poll, 64);
 
-	dev->features |= NETIF_F_RXCSUM | NETIF_F_HIGHDMA |
-			 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			 NETIF_F_HW_VLAN_CTAG_TX;
-	dev->hw_features |= dev->features;
-	dev->vlan_features |= dev->features;
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_HIGHDMA |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_HW_VLAN_CTAG_TX, &dev->features);
+	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(&dev->vlan_features, dev->vlan_features,
+			  dev->features);
 	dev->max_mtu = UMAC_MAX_MTU_SIZE;
 
 	/* Request the WOL interrupt and advertise suspend if available */
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index fe4d99abd548..c99800b8d812 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1535,9 +1535,11 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 		goto err_dma_free;
 	}
 
-	net_dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	net_dev->hw_features = net_dev->features;
-	net_dev->vlan_features = net_dev->features;
+	netdev_feature_zero(&net_dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM, &net_dev->features);
+	netdev_feature_copy(&net_dev->hw_features, net_dev->features);
+	netdev_feature_copy(&net_dev->vlan_features, net_dev->features);
 
 	/* Omit FCS from max MTU size */
 	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 8c83973adca5..29f7b0b03d64 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -3258,7 +3258,8 @@ bnx2_rx_int(struct bnx2 *bp, struct bnx2_napi *bnapi, int budget)
 		}
 
 		skb_checksum_none_assert(skb);
-		if ((bp->dev->features & NETIF_F_RXCSUM) &&
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    bp->dev->features) &&
 			(status & (L2_FHDR_STATUS_TCP_SEGMENT |
 			L2_FHDR_STATUS_UDP_DATAGRAM))) {
 
@@ -3266,7 +3267,8 @@ bnx2_rx_int(struct bnx2 *bp, struct bnx2_napi *bnapi, int budget)
 					      L2_FHDR_ERRORS_UDP_XSUM)) == 0))
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 		}
-		if ((bp->dev->features & NETIF_F_RXHASH) &&
+		if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+					    bp->dev->features) &&
 		    ((status & L2_FHDR_STATUS_USE_RXHASH) ==
 		     L2_FHDR_STATUS_USE_RXHASH))
 			skb_set_hash(skb, rx_hdr->l2_fhdr_hash,
@@ -3586,7 +3588,8 @@ bnx2_set_rx_mode(struct net_device *dev)
 	rx_mode = bp->rx_mode & ~(BNX2_EMAC_RX_MODE_PROMISCUOUS |
 				  BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG);
 	sort_mode = 1 | BNX2_RPM_SORT_USER0_BC_EN;
-	if (!(dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				     dev->features) &&
 	     (bp->flags & BNX2_FLAG_CAN_KEEP_VLAN))
 		rx_mode |= BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG;
 	if (dev->flags & IFF_PROMISC) {
@@ -7747,18 +7750,23 @@ static int
 bnx2_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct bnx2 *bp = netdev_priv(dev);
+	netdev_features_t tmp;
 
 	/* TSO with VLAN tag won't work with current firmware */
-	if (features & NETIF_F_HW_VLAN_CTAG_TX)
-		dev->vlan_features |= (dev->hw_features & NETIF_F_ALL_TSO);
-	else
-		dev->vlan_features &= ~NETIF_F_ALL_TSO;
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
+		netdev_feature_copy(&tmp, dev->hw_features);
+		netdev_feature_and_bits(NETIF_F_ALL_TSO, &tmp);
+		netdev_feature_or(&dev->vlan_features, dev->vlan_features,
+				  tmp);
+	} else {
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, &dev->vlan_features);
+	}
 
-	if ((!!(features & NETIF_F_HW_VLAN_CTAG_RX) !=
+	if ((netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) !=
 	    !!(bp->rx_mode & BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG)) &&
 	    netif_running(dev)) {
 		bnx2_netif_stop(bp, false);
-		dev->features = features;
+		netdev_feature_copy(&dev->features, features);
 		bnx2_set_rx_mode(dev);
 		bnx2_fw_sync(bp, BNX2_DRV_MSG_CODE_KEEP_VLAN_UPDATE, 0, 1);
 		bnx2_netif_start(bp, false);
@@ -8208,7 +8216,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 
 	/* Configure DMA attributes. */
 	if (dma_set_mask(&pdev->dev, dma_mask) == 0) {
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 		rc = dma_set_coherent_mask(&pdev->dev, persist_dma_mask);
 		if (rc) {
 			dev_err(&pdev->dev,
@@ -8576,22 +8584,27 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	memcpy(dev->dev_addr, bp->mac_addr, ETH_ALEN);
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-		NETIF_F_TSO | NETIF_F_TSO_ECN |
-		NETIF_F_RXHASH | NETIF_F_RXCSUM;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
+				NETIF_F_TSO | NETIF_F_TSO_ECN |
+				NETIF_F_RXHASH | NETIF_F_RXCSUM,
+				&dev->hw_features);
 
 	if (BNX2_CHIP(bp) == BNX2_CHIP_5709)
-		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+		netdev_feature_set_bits(NETIF_F_IPV6_CSUM | NETIF_F_TSO6,
+					&dev->hw_features);
 
-	dev->vlan_features = dev->hw_features;
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-	dev->features |= dev->hw_features;
+	netdev_feature_copy(&dev->vlan_features, dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &dev->hw_features);
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->min_mtu = MIN_ETHERNET_PACKET_SIZE;
 	dev->max_mtu = MAX_ETHERNET_JUMBO_PACKET_SIZE;
 
 	if (!(bp->flags & BNX2_FLAG_CAN_KEEP_VLAN))
-		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					 &dev->hw_features);
 
 	if ((rc = register_netdev(dev))) {
 		dev_err(&pdev->dev, "Cannot register net device\n");
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index d74510306068..b238312fd0c7 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -412,7 +412,7 @@ static u32 bnx2x_get_rxhash(const struct bnx2x *bp,
 			    enum pkt_hash_types *rxhash_type)
 {
 	/* Get Toeplitz hash from CQE */
-	if ((bp->dev->features & NETIF_F_RXHASH) &&
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, bp->dev->features) &&
 	    (cqe->status_flags & ETH_FAST_PATH_RX_CQE_RSS_HASH_FLG)) {
 		enum eth_rss_hash_type htype;
 
@@ -1073,7 +1073,8 @@ static int bnx2x_rx_int(struct bnx2x_fastpath *fp, int budget)
 
 		skb_checksum_none_assert(skb);
 
-		if (bp->dev->features & NETIF_F_RXCSUM)
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    bp->dev->features))
 			bnx2x_csum_validate(skb, cqe, fp,
 					    bnx2x_fp_qstats(bp, fp));
 
@@ -2491,9 +2492,10 @@ static void bnx2x_bz_fp(struct bnx2x *bp, int index)
 	/* set the tpa flag for each queue. The tpa flag determines the queue
 	 * minimal size so it must be set prior to queue memory allocation
 	 */
-	if (bp->dev->features & NETIF_F_LRO)
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, bp->dev->features))
 		fp->mode = TPA_MODE_LRO;
-	else if (bp->dev->features & NETIF_F_GRO_HW)
+	else if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT,
+					 bp->dev->features))
 		fp->mode = TPA_MODE_GRO;
 	else
 		fp->mode = TPA_MODE_DISABLED;
@@ -4891,7 +4893,7 @@ int bnx2x_change_mtu(struct net_device *dev, int new_mtu)
 	dev->mtu = new_mtu;
 
 	if (!bnx2x_mtu_allows_gro(new_mtu))
-		dev->features &= ~NETIF_F_GRO_HW;
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, &dev->features);
 
 	if (IS_PF(bp) && SHMEM2_HAS(bp, curr_cfg))
 		SHMEM2_WR(bp, curr_cfg, CURR_CFG_MET_OS);
@@ -4904,42 +4906,54 @@ void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features)
 	struct bnx2x *bp = netdev_priv(dev);
 
 	if (pci_num_vf(bp->pdev)) {
-		netdev_features_t changed = dev->features ^ *features;
+		netdev_features_t changed;
+
+		netdev_feature_xor(&changed, dev->features, *features);
 
 		/* Revert the requested changes in features if they
 		 * would require internal reload of PF in bnx2x_set_features().
 		 */
-		if (!(*features & NETIF_F_RXCSUM) && !bp->disable_tpa) {
-			*features &= ~NETIF_F_RXCSUM;
-			*features |= dev->features & NETIF_F_RXCSUM;
+		if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features) &&
+		    !bp->disable_tpa) {
+			if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						    dev->features))
+				netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+						       features);
 		}
 
-		if (changed & NETIF_F_LOOPBACK) {
-			*features &= ~NETIF_F_LOOPBACK;
-			*features |= dev->features & NETIF_F_LOOPBACK;
+		if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed)) {
+			netdev_feature_clear_bit(NETIF_F_LOOPBACK_BIT,
+						 features);
+			if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT,
+						    dev->features))
+				netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT,
+						       features);
 		}
 	}
 
 	/* TPA requires Rx CSUM offloading */
-	if (!(*features & NETIF_F_RXCSUM))
-		*features &= ~NETIF_F_LRO;
-
-	if (!(*features & NETIF_F_GRO) || !bnx2x_mtu_allows_gro(dev->mtu))
-		*features &= ~NETIF_F_GRO_HW;
-	if (*features & NETIF_F_GRO_HW)
-		*features &= ~NETIF_F_LRO;
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
+
+	if (!netdev_feature_test_bit(NETIF_F_GRO_BIT, *features) ||
+	    !bnx2x_mtu_allows_gro(dev->mtu))
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
+	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 }
 
 int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct bnx2x *bp = netdev_priv(dev);
-	netdev_features_t changes = features ^ dev->features;
+	netdev_features_t changes;
 	bool bnx2x_reload = false;
 	int rc;
 
+	netdev_feature_xor(&changes, dev->features, features);
+
 	/* VFs or non SRIOV PFs should be able to change loopback feature */
 	if (!pci_num_vf(bp->pdev)) {
-		if (features & NETIF_F_LOOPBACK) {
+		if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, features)) {
 			if (bp->link_params.loopback_mode != LOOPBACK_BMAC) {
 				bp->link_params.loopback_mode = LOOPBACK_BMAC;
 				bnx2x_reload = true;
@@ -4953,14 +4967,14 @@ int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 	}
 
 	/* Don't care about GRO changes */
-	changes &= ~NETIF_F_GRO;
+	netdev_feature_clear_bit(NETIF_F_GRO_BIT, &changes);
 
-	if (changes)
+	if (!netdev_feature_empty(changes))
 		bnx2x_reload = true;
 
 	if (bnx2x_reload) {
 		if (bp->recovery_state == BNX2X_RECOVERY_DONE) {
-			dev->features = features;
+			netdev_feature_copy(&dev->features, features);
 			rc = bnx2x_reload_if_running(dev);
 			return rc ? rc : 1;
 		}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 1f817dfa5b64..67fbe0ebf3b6 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -3393,9 +3393,9 @@ static void bnx2x_drv_info_ether_stat(struct bnx2x *bp)
 				ether_stat->mac_local + MAC_PAD, MAC_PAD,
 				ETH_ALEN);
 	ether_stat->mtu_size = bp->dev->mtu;
-	if (bp->dev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, bp->dev->features))
 		ether_stat->feature_flags |= FEATURE_ETH_CHKSUM_OFFLOAD_MASK;
-	if (bp->dev->features & NETIF_F_TSO)
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, bp->dev->features))
 		ether_stat->feature_flags |= FEATURE_ETH_LSO_MASK;
 	ether_stat->feature_flags |= bp->common.boot_mode;
 
@@ -12332,8 +12332,10 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 	/* Set TPA flags */
 	if (bp->disable_tpa) {
-		bp->dev->hw_features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
-		bp->dev->features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
+					  &bp->dev->hw_features);
+		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
+					  &bp->dev->features);
 	}
 
 	if (CHIP_IS_E1(bp))
@@ -12853,7 +12855,7 @@ static void bnx2x_features_check(struct sk_buff *skb, struct net_device *dev,
 	if (unlikely(skb_is_gso(skb) &&
 		     (skb_shinfo(skb)->gso_size > 9000) &&
 		     !skb_gso_validate_mac_len(skb, 9700)))
-		*features &= ~NETIF_F_GSO_MASK;
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 
 	vlan_features_check(skb, features);
 	vxlan_features_check(skb, features);
@@ -13190,52 +13192,62 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6 |
-		NETIF_F_RXCSUM | NETIF_F_LRO | NETIF_F_GRO | NETIF_F_GRO_HW |
-		NETIF_F_RXHASH | NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM | NETIF_F_TSO |
+				NETIF_F_TSO_ECN | NETIF_F_TSO6 |
+				NETIF_F_RXCSUM | NETIF_F_LRO | NETIF_F_GRO |
+				NETIF_F_GRO_HW | NETIF_F_RXHASH |
+				NETIF_F_HW_VLAN_CTAG_TX, &dev->hw_features);
 	if (!chip_is_e1x) {
-		dev->hw_features |= NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM |
-				    NETIF_F_GSO_IPXIP4 |
-				    NETIF_F_GSO_UDP_TUNNEL |
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_PARTIAL;
-
-		dev->hw_enc_features =
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6 |
-			NETIF_F_GSO_IPXIP4 |
-			NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM |
-			NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
-			NETIF_F_GSO_PARTIAL;
-
-		dev->gso_partial_features = NETIF_F_GSO_GRE_CSUM |
-					    NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_feature_set_bits(NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM |
+				NETIF_F_GSO_IPXIP4 | NETIF_F_GSO_UDP_TUNNEL |
+				NETIF_F_GSO_UDP_TUNNEL_CSUM |
+				NETIF_F_GSO_PARTIAL, &dev->hw_features);
+
+		netdev_feature_zero(&dev->hw_enc_features);
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_SG | NETIF_F_TSO |
+				NETIF_F_TSO_ECN | NETIF_F_TSO6 |
+				NETIF_F_GSO_IPXIP4 | NETIF_F_GSO_GRE |
+				NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
+				NETIF_F_GSO_UDP_TUNNEL_CSUM |
+				NETIF_F_GSO_PARTIAL, &dev->hw_enc_features);
+
+		netdev_feature_zero(&dev->gso_partial_features);
+		netdev_feature_set_bits(NETIF_F_GSO_GRE_CSUM |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					&dev->gso_partial_features);
 
 		if (IS_PF(bp))
 			dev->udp_tunnel_nic_info = &bnx2x_udp_tunnels;
 	}
 
-	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_HIGHDMA;
+	netdev_feature_zero(&dev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM | NETIF_F_TSO |
+				NETIF_F_TSO_ECN | NETIF_F_TSO6 |
+				NETIF_F_HIGHDMA, &dev->vlan_features);
 
 	if (IS_PF(bp)) {
 		if (chip_is_e1x)
 			bp->accept_any_vlan = true;
 		else
-			dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					       &dev->hw_features);
 	}
 	/* For VF we'll know whether to enable VLAN filtering after
 	 * getting a response to CHANNEL_TLV_ACQUIRE from PF.
 	 */
 
-	dev->features |= dev->hw_features | NETIF_F_HW_VLAN_CTAG_RX;
-	dev->features |= NETIF_F_HIGHDMA;
-	if (dev->features & NETIF_F_LRO)
-		dev->features &= ~NETIF_F_GRO_HW;
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features))
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, &dev->features);
 
 	/* Add Loopback capability to the device */
-	dev->hw_features |= NETIF_F_LOOPBACK;
+	netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, &dev->features);
 
 #ifdef BCM_DCBNL
 	dev->dcbnl_ops = &bnx2x_dcbnl_ops;
@@ -13938,8 +13950,10 @@ static int bnx2x_init_one(struct pci_dev *pdev,
 #ifdef CONFIG_BNX2X_SRIOV
 		/* VF with OLD Hypervisor or old PF do not support filtering */
 		if (bp->acquire_resp.pfdev_info.pf_cap & PFVF_CAP_VLAN_FILTER) {
-			dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-			dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					       &dev->hw_features);
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					       &dev->features);
 		}
 #endif
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7d9166876e95..24d6f883c243 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1704,7 +1704,8 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb_set_hash(skb, tpa_info->rss_hash, tpa_info->hash_type);
 
 	if ((tpa_info->flags2 & RX_CMP_FLAGS2_META_FORMAT_VLAN) &&
-	    (skb->dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)) {
+	    (netdev_feature_test_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
+				      skb->dev->features))) {
 		__be16 vlan_proto = htons(tpa_info->metadata >>
 					  RX_CMP_FLAGS2_METADATA_TPID_SFT);
 		u16 vtag = tpa_info->metadata & RX_CMP_FLAGS2_METADATA_TCI_MASK;
@@ -1940,7 +1941,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 	if ((rxcmp1->rx_cmp_flags2 &
 	     cpu_to_le32(RX_CMP_FLAGS2_META_FORMAT_VLAN)) &&
-	    (skb->dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)) {
+	     netdev_feature_test_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
+				      skb->dev->features)) {
 		u32 meta_data = le32_to_cpu(rxcmp1->rx_cmp_meta_data);
 		u16 vtag = meta_data & RX_CMP_FLAGS2_METADATA_TCI_MASK;
 		__be16 vlan_proto = htons(meta_data >>
@@ -1956,13 +1958,15 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 	skb_checksum_none_assert(skb);
 	if (RX_CMP_L4_CS_OK(rxcmp1)) {
-		if (dev->features & NETIF_F_RXCSUM) {
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    dev->features)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			skb->csum_level = RX_CMP_ENCAP(rxcmp1);
 		}
 	} else {
 		if (rxcmp1->rx_cmp_cfa_code_errors_v2 & RX_CMP_L4_CS_ERR_BITS) {
-			if (dev->features & NETIF_F_RXCSUM)
+			if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						    dev->features))
 				bnapi->cp_ring.sw_stats.rx.rx_l4_csum_errors++;
 		}
 	}
@@ -3756,9 +3760,10 @@ void bnxt_set_tpa_flags(struct bnxt *bp)
 	bp->flags &= ~BNXT_FLAG_TPA;
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
 		return;
-	if (bp->dev->features & NETIF_F_LRO)
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, bp->dev->features))
 		bp->flags |= BNXT_FLAG_LRO;
-	else if (bp->dev->features & NETIF_F_GRO_HW)
+	else if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT,
+					 bp->dev->features))
 		bp->flags |= BNXT_FLAG_GRO;
 }
 
@@ -6344,8 +6349,10 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 
 			bp->flags &= ~BNXT_FLAG_AGG_RINGS;
 			bp->flags |= BNXT_FLAG_NO_AGG_RINGS;
-			bp->dev->hw_features &= ~NETIF_F_LRO;
-			bp->dev->features &= ~NETIF_F_LRO;
+			netdev_feature_clear_bit(NETIF_F_LRO_BIT,
+						 &bp->dev->hw_features);
+			netdev_feature_clear_bit(NETIF_F_LRO_BIT,
+						 &bp->dev->features);
 			bnxt_set_ring_params(bp);
 		}
 	}
@@ -10189,7 +10196,8 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	if ((bp->flags & BNXT_FLAG_RFS) &&
 	    !(bp->flags & BNXT_FLAG_USING_MSIX)) {
 		/* disable RFS if falling back to INTA */
-		bp->dev->hw_features &= ~NETIF_F_NTUPLE;
+		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT,
+					 &bp->dev->hw_features);
 		bp->flags &= ~BNXT_FLAG_RFS;
 	}
 
@@ -10897,34 +10905,42 @@ static bool bnxt_rfs_capable(struct bnxt *bp)
 static void bnxt_fix_features(struct net_device *dev,
 			      netdev_features_t *features)
 {
+	netdev_features_t vlan_features, tmp;
 	struct bnxt *bp = netdev_priv(dev);
-	netdev_features_t vlan_features;
 
-	if ((*features & NETIF_F_NTUPLE) && !bnxt_rfs_capable(bp))
-		*features &= ~NETIF_F_NTUPLE;
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, *features) &&
+	    !bnxt_rfs_capable(bp))
+		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT, features);
 
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
-		*features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
+					  features);
 
-	if (!(*features & NETIF_F_GRO))
-		*features &= ~NETIF_F_GRO_HW;
+	if (!netdev_feature_test_bit(NETIF_F_GRO_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
 
-	if (*features & NETIF_F_GRO_HW)
-		*features &= ~NETIF_F_LRO;
+	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
 	 */
-	vlan_features = *features & BNXT_HW_FEATURE_VLAN_ALL_RX;
-	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
-		if (dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)
-			*features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
-		else if (vlan_features)
-			*features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
+	netdev_feature_zero(&tmp);
+	netdev_feature_set_bits(BNXT_HW_FEATURE_VLAN_ALL_RX, &tmp);
+	netdev_feature_and(&vlan_features, *features, tmp);
+	if (!netdev_feature_equal(vlan_features, tmp)) {
+		if (netdev_feature_test_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
+					     dev->features))
+			netdev_feature_clear_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
+						  features);
+		else if (!netdev_feature_empty(vlan_features))
+			netdev_feature_set_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
+						features);
 	}
 #ifdef CONFIG_BNXT_SRIOV
 	if (BNXT_VF(bp) && bp->vf.vlan)
-		*features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
+		netdev_feature_clear_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
+					  features);
 #endif
 }
 
@@ -10938,18 +10954,18 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	bool update_tpa = false;
 
 	flags &= ~BNXT_FLAG_ALL_CONFIG_FEATS;
-	if (features & NETIF_F_GRO_HW)
+	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, features))
 		flags |= BNXT_FLAG_GRO;
-	else if (features & NETIF_F_LRO)
+	else if (netdev_feature_test_bit(NETIF_F_LRO_BIT, features))
 		flags |= BNXT_FLAG_LRO;
 
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
 		flags &= ~BNXT_FLAG_TPA;
 
-	if (features & BNXT_HW_FEATURE_VLAN_ALL_RX)
+	if (netdev_feature_test_bits(BNXT_HW_FEATURE_VLAN_ALL_RX, features))
 		flags |= BNXT_FLAG_STRIP_VLAN;
 
-	if (features & NETIF_F_NTUPLE)
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features))
 		flags |= BNXT_FLAG_RFS;
 
 	changes = flags ^ bp->flags;
@@ -11112,7 +11128,8 @@ static void bnxt_features_check(struct sk_buff *skb, struct net_device *dev,
 			return;
 		break;
 	}
-	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
 }
 
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
@@ -11956,14 +11973,15 @@ static void bnxt_set_dflt_rfs(struct bnxt *bp)
 {
 	struct net_device *dev = bp->dev;
 
-	dev->hw_features &= ~NETIF_F_NTUPLE;
-	dev->features &= ~NETIF_F_NTUPLE;
+	netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT, &dev->hw_features);
+	netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT, &dev->features);
 	bp->flags &= ~BNXT_FLAG_RFS;
 	if (bnxt_rfs_supported(bp)) {
-		dev->hw_features |= NETIF_F_NTUPLE;
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &dev->hw_features);
 		if (bnxt_rfs_capable(bp)) {
 			bp->flags |= BNXT_FLAG_RFS;
-			dev->features |= NETIF_F_NTUPLE;
+			netdev_feature_set_bit(NETIF_F_NTUPLE_BIT,
+					       &dev->features);
 		}
 	}
 }
@@ -12948,8 +12966,10 @@ static int bnxt_get_dflt_rings(struct bnxt *bp, int *max_rx, int *max_tx,
 			return rc;
 		}
 		bp->flags |= BNXT_FLAG_NO_AGG_RINGS;
-		bp->dev->hw_features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
-		bp->dev->features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
+					  &bp->dev->hw_features);
+		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
+					  &bp->dev->features);
 		bnxt_set_ring_params(bp);
 	}
 
@@ -13064,7 +13084,7 @@ static int bnxt_init_dflt_ring_mode(struct bnxt *bp)
 	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 	if (bnxt_rfs_supported(bp) && bnxt_rfs_capable(bp)) {
 		bp->flags |= BNXT_FLAG_RFS;
-		bp->dev->features |= NETIF_F_NTUPLE;
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &bp->dev->features);
 	}
 init_dflt_ring_err:
 	bnxt_ulp_irq_restart(bp, rc);
@@ -13260,37 +13280,46 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto init_err_pci_clean;
 	}
 
-	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
-			   NETIF_F_TSO | NETIF_F_TSO6 |
-			   NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			   NETIF_F_GSO_IPXIP4 |
-			   NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM |
-			   NETIF_F_GSO_PARTIAL | NETIF_F_RXHASH |
-			   NETIF_F_RXCSUM | NETIF_F_GRO;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
+				NETIF_F_GSO_IPXIP4 |
+				NETIF_F_GSO_UDP_TUNNEL_CSUM |
+				NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_PARTIAL |
+				NETIF_F_RXHASH | NETIF_F_RXCSUM | NETIF_F_GRO,
+				&dev->hw_features);
 
 	if (BNXT_SUPPORTS_TPA(bp))
-		dev->hw_features |= NETIF_F_LRO;
-
-	dev->hw_enc_features =
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_TSO6 |
-			NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM |
-			NETIF_F_GSO_IPXIP4 | NETIF_F_GSO_PARTIAL;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, &dev->hw_features);
+
+	netdev_feature_zero(&dev->hw_enc_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
+				NETIF_F_GSO_UDP_TUNNEL_CSUM |
+				NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_IPXIP4 |
+				NETIF_F_GSO_PARTIAL, &dev->hw_enc_features);
 	dev->udp_tunnel_nic_info = &bnxt_udp_tunnels;
 
-	dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_GRE_CSUM;
-	dev->vlan_features = dev->hw_features | NETIF_F_HIGHDMA;
+	netdev_feature_zero(&dev->gso_partial_features);
+	netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL_CSUM |
+				NETIF_F_GSO_GRE_CSUM,
+				&dev->gso_partial_features);
+	netdev_feature_copy(&dev->vlan_features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->vlan_features);
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_RX_STRIP)
-		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
+		netdev_feature_set_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
+					&dev->hw_features);
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_TX_INSERT)
-		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_TX;
+		netdev_feature_set_bits(BNXT_HW_FEATURE_VLAN_ALL_TX,
+					&dev->hw_features);
 	if (BNXT_SUPPORTS_TPA(bp))
-		dev->hw_features |= NETIF_F_GRO_HW;
-	dev->features |= dev->hw_features | NETIF_F_HIGHDMA;
-	if (dev->features & NETIF_F_GRO_HW)
-		dev->features &= ~NETIF_F_LRO;
+		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, &dev->hw_features);
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, dev->features))
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &dev->features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 #ifdef CONFIG_BNXT_SRIOV
@@ -13339,7 +13368,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bnxt_fw_init_one_p3(bp);
 
-	if (dev->hw_features & BNXT_HW_FEATURE_VLAN_ALL_RX)
+	if (netdev_feature_test_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
+				     dev->hw_features))
 		bp->flags |= BNXT_FLAG_STRIP_VLAN;
 
 	rc = bnxt_init_int_mode(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index e6a4a768b10b..ff88f5ccb782 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -2052,8 +2052,8 @@ int bnxt_init_tc(struct bnxt *bp)
 		goto destroy_decap_table;
 
 	tc_info->enabled = true;
-	bp->dev->hw_features |= NETIF_F_HW_TC;
-	bp->dev->features |= NETIF_F_HW_TC;
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &bp->dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &bp->dev->features);
 	bp->tc_info = tc_info;
 
 	/* init indirect block notifications */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 9401936b74fa..d77beadf5921 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -468,11 +468,12 @@ static void bnxt_vf_rep_netdev_init(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 	/* Just inherit all the featues of the parent PF as the VF-R
 	 * uses the RX/TX rings of the parent PF
 	 */
-	dev->hw_features = pf_dev->hw_features;
-	dev->gso_partial_features = pf_dev->gso_partial_features;
-	dev->vlan_features = pf_dev->vlan_features;
-	dev->hw_enc_features = pf_dev->hw_enc_features;
-	dev->features |= pf_dev->features;
+	netdev_feature_copy(&dev->hw_features, pf_dev->hw_features);
+	netdev_feature_copy(&dev->gso_partial_features,
+			    pf_dev->gso_partial_features);
+	netdev_feature_copy(&dev->vlan_features, pf_dev->vlan_features);
+	netdev_feature_copy(&dev->hw_enc_features, pf_dev->hw_enc_features);
+	netdev_feature_or(&dev->features, dev->features, pf_dev->features);
 	bnxt_vf_rep_eth_addr_gen(bp->pf.mac_addr, vf_rep->vf_idx,
 				 dev->perm_addr);
 	ether_addr_copy(dev->dev_addr, dev->perm_addr);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c8083df5e0ab..a86f3c3db767 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -297,7 +297,8 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 		bnxt_get_max_rings(bp, &rx, &tx, true);
 		if (rx > 1) {
 			bp->flags &= ~BNXT_FLAG_NO_AGG_RINGS;
-			bp->dev->hw_features |= NETIF_F_LRO;
+			netdev_feature_set_bit(NETIF_F_LRO_BIT,
+					       &bp->dev->hw_features);
 		}
 	}
 	bp->tx_nr_rings_xdp = tx_xdp;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 6a8234bc9428..1b12d0ae8f1f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2285,7 +2285,8 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 
 		status = (struct status_64 *)skb->data;
 		dma_length_status = status->length_status;
-		if (dev->features & NETIF_F_RXCSUM) {
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    dev->features)) {
 			rx_csum = (__force __be16)(status->rx_csum & 0xffff);
 			skb->csum = (__force __wsum)ntohs(rx_csum);
 			skb->ip_summed = CHECKSUM_COMPLETE;
@@ -4005,10 +4006,11 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	priv->msg_enable = netif_msg_init(-1, GENET_MSG_DEFAULT);
 
 	/* Set default features */
-	dev->features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-			 NETIF_F_RXCSUM;
-	dev->hw_features |= dev->features;
-	dev->vlan_features |= dev->features;
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
+				NETIF_F_RXCSUM, &dev->features);
+	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(&dev->vlan_features, dev->vlan_features,
+			  dev->features);
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index df0d6a35f093..0406951a3a3e 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6918,7 +6918,8 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
 			tg3_hwclock_to_timestamp(tp, tstamp,
 						 skb_hwtstamps(skb));
 
-		if ((tp->dev->features & NETIF_F_RXCSUM) &&
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    tp->dev->features) &&
 		    (desc->type_flags & RXD_FLAG_TCPUDP_CSUM) &&
 		    (((desc->ip_tcp_csum & RXD_TCPCSUM_MASK)
 		      >> RXD_TCPCSUM_SHIFT) == 0xffff))
@@ -7860,6 +7861,7 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 {
 	u32 frag_cnt_est = skb_shinfo(skb)->gso_segs * 3;
 	struct sk_buff *segs, *seg, *next;
+	netdev_features_t tmp;
 
 	/* Estimate the number of fragments in the worst case */
 	if (unlikely(tg3_tx_avail(tnapi) <= frag_cnt_est)) {
@@ -7877,8 +7879,9 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 		netif_tx_wake_queue(txq);
 	}
 
-	segs = skb_gso_segment(skb, tp->dev->features &
-				    ~(NETIF_F_TSO | NETIF_F_TSO6));
+	netdev_feature_copy(&tmp, tp->dev->features);
+	netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6, &tmp);
+	segs = skb_gso_segment(skb, tmp);
 	if (IS_ERR(segs) || !segs)
 		goto tg3_tso_bug_end;
 
@@ -8280,7 +8283,7 @@ static void tg3_set_loopback(struct net_device *dev, netdev_features_t features)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	if (features & NETIF_F_LOOPBACK) {
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, features)) {
 		if (tp->mac_mode & MAC_MODE_PORT_INT_LPBACK)
 			return;
 
@@ -8308,14 +8311,16 @@ static void tg3_fix_features(struct net_device *dev,
 	struct tg3 *tp = netdev_priv(dev);
 
 	if (dev->mtu > ETH_DATA_LEN && tg3_flag(tp, 5780_CLASS))
-		*features &= ~NETIF_F_ALL_TSO;
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, features);
 }
 
 static int tg3_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
-	if ((changed & NETIF_F_LOOPBACK) && netif_running(dev))
+	netdev_feature_xor(&changed, dev->features, features);
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed) &&
+	    netif_running(dev))
 		tg3_set_loopback(dev, features);
 
 	return 0;
@@ -11648,7 +11653,7 @@ static int tg3_start(struct tg3 *tp, bool reset_phy, bool test_irq,
 	 * Reset loopback feature if it was turned on while the device was down
 	 * make sure that it's installed properly now.
 	 */
-	if (dev->features & NETIF_F_LOOPBACK)
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, dev->features))
 		tg3_set_loopback(dev, dev->features);
 
 	return 0;
@@ -17558,7 +17563,9 @@ static int tg3_init_one(struct pci_dev *pdev,
 	u32 sndmbx, rcvmbx, intmbx;
 	char str[40];
 	u64 dma_mask, persist_dma_mask;
-	netdev_features_t features = 0;
+	netdev_features_t features;
+
+	netdev_feature_zero(&features);
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -17701,7 +17708,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 	if (dma_mask > DMA_BIT_MASK(32)) {
 		err = dma_set_mask(&pdev->dev, dma_mask);
 		if (!err) {
-			features |= NETIF_F_HIGHDMA;
+			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &features);
 			err = dma_set_coherent_mask(&pdev->dev,
 						    persist_dma_mask);
 			if (err < 0) {
@@ -17726,10 +17733,12 @@ static int tg3_init_one(struct pci_dev *pdev,
 	 * to hardware bugs.
 	 */
 	if (tg3_chip_rev_id(tp) != CHIPREV_ID_5700_B0) {
-		features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+					NETIF_F_RXCSUM, &features);
 
 		if (tg3_flag(tp, 5755_PLUS))
-			features |= NETIF_F_IPV6_CSUM;
+			netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+					       &features);
 	}
 
 	/* TSO is on by default on chips that support hardware TSO.
@@ -17739,23 +17748,24 @@ static int tg3_init_one(struct pci_dev *pdev,
 	if ((tg3_flag(tp, HW_TSO_1) ||
 	     tg3_flag(tp, HW_TSO_2) ||
 	     tg3_flag(tp, HW_TSO_3)) &&
-	    (features & NETIF_F_IP_CSUM))
-		features |= NETIF_F_TSO;
+	    netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, features))
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, &features);
 	if (tg3_flag(tp, HW_TSO_2) || tg3_flag(tp, HW_TSO_3)) {
-		if (features & NETIF_F_IPV6_CSUM)
-			features |= NETIF_F_TSO6;
+		if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, features))
+			netdev_feature_set_bit(NETIF_F_TSO6_BIT, &features);
 		if (tg3_flag(tp, HW_TSO_3) ||
 		    tg3_asic_rev(tp) == ASIC_REV_5761 ||
 		    (tg3_asic_rev(tp) == ASIC_REV_5784 &&
 		     tg3_chip_rev(tp) != CHIPREV_5784_AX) ||
 		    tg3_asic_rev(tp) == ASIC_REV_5785 ||
 		    tg3_asic_rev(tp) == ASIC_REV_57780)
-			features |= NETIF_F_TSO_ECN;
+			netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &features);
 	}
 
-	dev->features |= features | NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX;
-	dev->vlan_features |= features;
+	netdev_feature_or(&dev->features, dev->features, features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+			NETIF_F_HW_VLAN_CTAG_RX, &dev->features);
+	netdev_feature_or(&dev->vlan_features, dev->vlan_features, features);
 
 	/*
 	 * Add loopback capability only for a subset of devices that support
@@ -17765,9 +17775,9 @@ static int tg3_init_one(struct pci_dev *pdev,
 	if (tg3_asic_rev(tp) != ASIC_REV_5780 &&
 	    !tg3_flag(tp, CPMU_PRESENT))
 		/* Add the loopback capability */
-		features |= NETIF_F_LOOPBACK;
+		netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, &features);
 
-	dev->hw_features |= features;
+	netdev_feature_or(&dev->hw_features, dev->hw_features, features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 60 - 9000 or 1500, depending on hardware */
@@ -17902,7 +17912,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 	}
 
 	netdev_info(dev, "RXcsums[%d] LinkChgREG[%d] MIirq[%d] ASF[%d] TSOcap[%d]\n",
-		    (dev->features & NETIF_F_RXCSUM) != 0,
+		    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features),
 		    tg3_flag(tp, USE_LINKCHG_REG) != 0,
 		    (tp->phy_flags & TG3_PHYFLG_USE_MI_INTERRUPT) != 0,
 		    tg3_flag(tp, ENABLE_ASF) != 0,
-- 
2.33.0

