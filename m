Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D408D41C95F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345637AbhI2QEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24184 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345634AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbx2Y8sz8tWG;
        Wed, 29 Sep 2021 23:57:17 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
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
Subject: [RFCv2 net-next 092/167] net: freescale: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:19 +0800
Message-ID: <20210929155334.12454-93-shenjian15@huawei.com>
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
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 23 ++++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 44 ++++++++++++-------
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  5 ++-
 drivers/net/ethernet/freescale/enetc/enetc.c  | 34 +++++++++-----
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 38 ++++++++++------
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  2 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   | 16 ++++---
 drivers/net/ethernet/freescale/fec_main.c     | 29 +++++++-----
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      | 39 +++++++++-------
 .../net/ethernet/freescale/gianfar_ethtool.c  | 11 +++--
 11 files changed, 151 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 685d2d8a3b36..2087fd4adea8 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -249,22 +249,25 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
 
-	net_dev->hw_features |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_LLTX | NETIF_F_RXHASH);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_LLTX | NETIF_F_RXHASH,
+				&net_dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA,
+				&net_dev->hw_features);
 
-	net_dev->hw_features |= NETIF_F_SG | NETIF_F_HIGHDMA;
 	/* The kernels enables GSO automatically, if we declare NETIF_F_SG.
 	 * For conformity, we'll still declare GSO explicitly.
 	 */
-	net_dev->features |= NETIF_F_GSO;
-	net_dev->features |= NETIF_F_RXCSUM;
+	netdev_feature_set_bit(NETIF_F_GSO_BIT, &net_dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &net_dev->features);
 
 	net_dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	/* we do not want shared skbs on TX */
 	net_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 
-	net_dev->features |= net_dev->hw_features;
-	net_dev->vlan_features = net_dev->features;
+	netdev_feature_or(&net_dev->features, net_dev->features,
+			  net_dev->hw_features);
+	netdev_feature_copy(&net_dev->vlan_features, net_dev->features);
 
 	if (is_valid_ether_addr(mac_addr)) {
 		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
@@ -1729,7 +1732,8 @@ static u8 rx_csum_offload(const struct dpaa_priv *priv, const struct qm_fd *fd)
 	 * We know there were no parser errors (and implicitly no
 	 * L4 csum error), otherwise we wouldn't be here.
 	 */
-	if ((priv->net_dev->features & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    priv->net_dev->features) &&
 	    (be32_to_cpu(fd->status) & FM_FD_STAT_L4CV))
 		return CHECKSUM_UNNECESSARY;
 
@@ -2728,7 +2732,8 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	}
 
 	/* Extract the hash stored in the headroom before running XDP */
-	if (net_dev->features & NETIF_F_RXHASH && priv->keygen_in_use &&
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, net_dev->features) &&
+	    priv->keygen_in_use &&
 	    !fman_port_get_hash_result_offset(priv->mac_dev->port[RX],
 					      &hash_offset)) {
 		hash = be32_to_cpu(*(u32 *)(vaddr + hash_offset));
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 03c168b1712f..d9ce2925e0b9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -51,7 +51,8 @@ static void dpaa2_eth_validate_rx_csum(struct dpaa2_eth_priv *priv,
 	skb_checksum_none_assert(skb);
 
 	/* HW checksum validation is disabled, nothing to do here */
-	if (!(priv->net_dev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     priv->net_dev->features))
 		return;
 
 	/* Read checksum validation bits */
@@ -2141,26 +2142,30 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 				  netdev_features_t features)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	netdev_features_t changed = features ^ net_dev->features;
+	netdev_features_t changed;
 	bool enable;
 	int err;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
+	netdev_feature_xor(&changed, features, net_dev->features);
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
+		enable = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						 features);
 		err = dpaa2_eth_set_rx_vlan_filtering(priv, enable);
 		if (err)
 			return err;
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
-		enable = !!(features & NETIF_F_RXCSUM);
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
+		enable = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features);
 		err = dpaa2_eth_set_rx_csum(priv, enable);
 		if (err)
 			return err;
 	}
 
-	if (changed & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
-		enable = !!(features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM));
+	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				     changed)) {
+		enable = netdev_feature_test_bits(NETIF_F_IP_CSUM |
+						  NETIF_F_IPV6_CSUM, features);
 		err = dpaa2_eth_set_tx_csum(priv, enable);
 		if (err)
 			return err;
@@ -4103,14 +4108,17 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 	net_dev->priv_flags &= ~not_supported;
 
 	/* Features */
-	net_dev->features = NETIF_F_RXCSUM |
-			    NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			    NETIF_F_SG | NETIF_F_HIGHDMA |
-			    NETIF_F_LLTX | NETIF_F_HW_TC;
-	net_dev->hw_features = net_dev->features;
+	netdev_feature_zero(&net_dev->features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_SG | NETIF_F_HIGHDMA |
+				NETIF_F_LLTX | NETIF_F_HW_TC,
+				&net_dev->features);
+	netdev_feature_copy(&net_dev->hw_features, net_dev->features);
 
 	if (priv->dpni_attrs.vlan_filter_entries)
-		net_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &net_dev->hw_features);
 
 	return 0;
 }
@@ -4393,12 +4401,16 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		goto err_netdev_init;
 
 	/* Configure checksum offload based on current interface flags */
-	err = dpaa2_eth_set_rx_csum(priv, !!(net_dev->features & NETIF_F_RXCSUM));
+	err = dpaa2_eth_set_rx_csum(priv,
+				    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+							    net_dev->features));
 	if (err)
 		goto err_csum;
 
 	err = dpaa2_eth_set_tx_csum(priv,
-				    !!(net_dev->features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)));
+				    netdev_feature_test_bits(NETIF_F_IP_CSUM |
+							     NETIF_F_IPV6_CSUM,
+							     net_dev->features));
 	if (err)
 		goto err_csum;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 175f15c46842..8c2d9b6cf5dc 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3275,9 +3275,10 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	/* The DPAA2 switch's ingress path depends on the VLAN table,
 	 * thus we are not able to disable VLAN filtering.
 	 */
-	port_netdev->features = NETIF_F_HW_VLAN_CTAG_FILTER |
+	netdev_feature_zero(&port_netdev->features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				NETIF_F_HW_VLAN_STAG_FILTER |
-				NETIF_F_HW_TC;
+				NETIF_F_HW_TC, &port_netdev->features);
 
 	err = dpaa2_switch_port_init(port_priv, port_idx);
 	if (err)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3cbfa8b4e265..0d92c45aa5df 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -720,7 +720,8 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
 
 	/* TODO: hashing */
-	if (rx_ring->ndev->features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    rx_ring->ndev->features)) {
 		u16 inet_csum = le16_to_cpu(rxbd->r.inet_csum);
 
 		skb->csum = csum_unfold((__force __sum16)~htons(inet_csum));
@@ -1769,7 +1770,8 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	enetc_txbdr_wr(hw, idx, ENETC_TBICR0, ENETC_TBICR0_ICEN | 0x1);
 
 	tbmr = ENETC_TBMR_EN;
-	if (tx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				    tx_ring->ndev->features))
 		tbmr |= ENETC_TBMR_VIH;
 
 	/* enable ring */
@@ -1810,7 +1812,8 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	if (rx_ring->ext_en)
 		rbmr |= ENETC_RBMR_BDS;
 
-	if (rx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    rx_ring->ndev->features))
 		rbmr |= ENETC_RBMR_VTE;
 
 	rx_ring->rcir = hw->reg + ENETC_BDR(RX, idx, ENETC_RBCIR);
@@ -2351,22 +2354,29 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed;
 	int err = 0;
 
-	if (changed & NETIF_F_RXHASH)
-		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
+	netdev_feature_xor(&changed, ndev->features, features);
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, changed))
+		enetc_set_rss(ndev, netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+							    features));
+
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		enetc_enable_rxvlan(ndev,
-				    !!(features & NETIF_F_HW_VLAN_CTAG_RX));
+				    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+							    features));
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, changed))
 		enetc_enable_txvlan(ndev,
-				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
+				    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+							    features));
 
-	if (changed & NETIF_F_HW_TC)
-		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
+	if (netdev_feature_test_bit(NETIF_F_HW_TC_BIT, changed))
+		err = enetc_set_psfp(ndev,
+				     netdev_feature_test_bit(NETIF_F_HW_TC_BIT,
+							     features));
 
 	return err;
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index f0ff95096846..7dad33460673 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -704,20 +704,26 @@ static int enetc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 static int enetc_pf_set_features(struct net_device *ndev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	netdev_feature_xor(&changed, ndev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    changed)) {
 		struct enetc_pf *pf = enetc_si_priv(priv->si);
 
-		if (!!(features & NETIF_F_HW_VLAN_CTAG_FILTER))
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    features))
 			enetc_disable_si_vlan_promisc(pf, 0);
 		else
 			enetc_enable_si_vlan_promisc(pf, 0);
 	}
 
-	if (changed & NETIF_F_LOOPBACK)
-		enetc_set_loopback(ndev, !!(features & NETIF_F_LOOPBACK));
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed))
+		enetc_set_loopback(ndev,
+				   netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT,
+							   features));
 
 	return enetc_set_features(ndev, features);
 }
@@ -758,15 +764,19 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->watchdog_timeo = 5 * HZ;
 	ndev->max_mtu = ENETC_MAX_MTU;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
-			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK;
-	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
-			 NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_LOOPBACK, &ndev->hw_features);
+	netdev_feature_zero(&ndev->features);
+	netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &ndev->features);
 
 	if (si->num_rss)
-		ndev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->hw_features);
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
@@ -775,8 +785,8 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
-		ndev->features |= NETIF_F_HW_TC;
-		ndev->hw_features |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &ndev->features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &ndev->hw_features);
 	}
 
 	/* pick up primary MAC address from SI */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 4577226d3c6a..c7a6f6231186 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -308,7 +308,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 
 	/* Do not support TXSTART and TX CSUM offload simutaniously */
-	if (ndev->features & NETIF_F_CSUM_MASK)
+	if (netdev_feature_test_bits(NETIF_F_CSUM_MASK, ndev->features))
 		return -EBUSY;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 0704f6bf12fd..615562e39783 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -120,15 +120,17 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->watchdog_timeo = 5 * HZ;
 	ndev->max_mtu = ENETC_MAX_MTU;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
-			    NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_HW_VLAN_CTAG_RX;
-	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
-			 NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &ndev->hw_features);
+	netdev_feature_zero(&ndev->features);
+	netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &ndev->features);
 
 	if (si->num_rss)
-		ndev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->hw_features);
 
 	/* pick up primary MAC address from SI */
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ec87b370bba1..e782bf61463d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1553,7 +1553,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 
 		/* If this is a VLAN packet remove the VLAN Tag */
 		vlan_packet_rcvd = false;
-		if ((ndev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    ndev->features) &&
 		    fep->bufdesc_ex &&
 		    (ebdp->cbd_esc & cpu_to_fec32(BD_ENET_RX_VLAN))) {
 			/* Push and remove the vlan tag */
@@ -3372,13 +3373,14 @@ static inline void fec_enet_set_netdev_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
-	netdev->features = features;
+	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_copy(&netdev->features, features);
 
 	/* Receive checksum has been changed */
-	if (changed & NETIF_F_RXCSUM) {
-		if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 			fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 		else
 			fep->csum_flags &= ~FLAG_RX_CSUM_ENABLED;
@@ -3389,9 +3391,12 @@ static int fec_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
-	if (netif_running(netdev) && changed & NETIF_F_RXCSUM) {
+	netdev_feature_xor(&changed, features, netdev->features);
+
+	if (netif_running(netdev) &&
+	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
 		napi_disable(&fep->napi);
 		netif_tx_lock_bh(netdev);
 		fec_stop(netdev);
@@ -3558,14 +3563,16 @@ static int fec_enet_init(struct net_device *ndev)
 
 	if (fep->quirks & FEC_QUIRK_HAS_VLAN)
 		/* enable hw VLAN support */
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       &ndev->features);
 
 	if (fep->quirks & FEC_QUIRK_HAS_CSUM) {
 		ndev->gso_max_segs = FEC_MAX_TSO_SEGS;
 
 		/* enable hw accelerator */
-		ndev->features |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM
-				| NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_TSO);
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+					NETIF_F_RXCSUM | NETIF_F_SG |
+					NETIF_F_TSO, &ndev->features);
 		fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 	}
 
@@ -3574,7 +3581,7 @@ static int fec_enet_init(struct net_device *ndev)
 		fep->rx_align = 0x3f;
 	}
 
-	ndev->hw_features = ndev->features;
+	netdev_feature_copy(&ndev->hw_features, ndev->features);
 
 	fec_restart(ndev);
 
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 2db6e38a772e..07965565d056 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1026,7 +1026,7 @@ static int fs_enet_probe(struct platform_device *ofdev)
 
 	netif_carrier_off(ndev);
 
-	ndev->features |= NETIF_F_SG;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->features);
 
 	ret = register_netdev(ndev);
 	if (ret)
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index af6ad94bf24a..852b5d5d4f47 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -160,7 +160,8 @@ static void gfar_rx_offload_en(struct gfar_private *priv)
 	/* set this when rx hw offload (TOE) functions are being used */
 	priv->uses_rxfcb = 0;
 
-	if (priv->ndev->features & (NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_RX))
+	if (netdev_feature_test_bits(NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_RX,
+				     priv->ndev->features))
 		priv->uses_rxfcb = 1;
 
 	if (priv->hwts_rx_en || priv->rx_filer_enable)
@@ -182,7 +183,7 @@ static void gfar_mac_rx_config(struct gfar_private *priv)
 	if (priv->ndev->flags & IFF_PROMISC)
 		rctrl |= RCTRL_PROM;
 
-	if (priv->ndev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, priv->ndev->features))
 		rctrl |= RCTRL_CHECKSUMMING;
 
 	if (priv->extended_hash)
@@ -197,7 +198,8 @@ static void gfar_mac_rx_config(struct gfar_private *priv)
 	if (priv->hwts_rx_en)
 		rctrl |= RCTRL_PRSDEP_INIT | RCTRL_TS_ENABLE;
 
-	if (priv->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    priv->ndev->features))
 		rctrl |= RCTRL_VLEX | RCTRL_PRSDEP_INIT;
 
 	/* Clear the LFC bit */
@@ -216,7 +218,8 @@ static void gfar_mac_tx_config(struct gfar_private *priv)
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
 	u32 tctrl = 0;
 
-	if (priv->ndev->features & NETIF_F_IP_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT,
+				    priv->ndev->features))
 		tctrl |= TCTRL_INIT_CSUM;
 
 	if (priv->prio_sched_en)
@@ -227,7 +230,8 @@ static void gfar_mac_tx_config(struct gfar_private *priv)
 		gfar_write(&regs->tr47wt, DEFAULT_WRRS_WEIGHT);
 	}
 
-	if (priv->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				    priv->ndev->features))
 		tctrl |= TCTRL_VLINS;
 
 	gfar_write(&regs->tctrl, tctrl);
@@ -2484,14 +2488,15 @@ static void gfar_process_frame(struct net_device *ndev, struct sk_buff *skb)
 	/* Trim off the FCS */
 	pskb_trim(skb, skb->len - ETH_FCS_LEN);
 
-	if (ndev->features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, ndev->features))
 		gfar_rx_checksum(skb, fcb);
 
 	/* There's need to check for NETIF_F_HW_VLAN_CTAG_RX here.
 	 * Even if vlan rx accel is disabled, on some chips
 	 * RXFCB_VLN is pseudo randomly set.
 	 */
-	if (ndev->features & NETIF_F_HW_VLAN_CTAG_RX &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    ndev->features) &&
 	    be16_to_cpu(fcb->flags) & RXFCB_VLN)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       be16_to_cpu(fcb->vlctl));
@@ -3242,16 +3247,20 @@ static int gfar_probe(struct platform_device *ofdev)
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
-		dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-				   NETIF_F_RXCSUM;
-		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG |
-				 NETIF_F_RXCSUM | NETIF_F_HIGHDMA;
+		netdev_feature_zero(&dev->hw_features);
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
+					NETIF_F_RXCSUM, &dev->hw_features);
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
+					NETIF_F_RXCSUM | NETIF_F_HIGHDMA,
+					&dev->features);
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX;
-		dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_CTAG_RX,
+					&dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       &dev->features);
 	}
 
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
@@ -3264,7 +3273,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
 		priv->padding = 8 + DEFAULT_PADDING;
 
-	if (dev->features & NETIF_F_IP_CSUM ||
+	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, dev->features) ||
 	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
 		dev->needed_headroom = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 7b32ed29bf4c..38e77a01ddd1 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -503,18 +503,21 @@ static int gfar_spauseparam(struct net_device *dev,
 
 int gfar_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	struct gfar_private *priv = netdev_priv(dev);
+	netdev_features_t changed;
 	int err = 0;
 
-	if (!(changed & (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_RXCSUM)))
+	netdev_feature_xor(&changed, dev->features, features);
+
+	if (!netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				      NETIF_F_HW_VLAN_CTAG_RX |
+				      NETIF_F_RXCSUM, changed))
 		return 0;
 
 	while (test_and_set_bit_lock(GFAR_RESETTING, &priv->state))
 		cpu_relax();
 
-	dev->features = features;
+	netdev_feature_copy(&dev->features, features);
 
 	if (dev->flags & IFF_UP) {
 		/* Now we take down the rings to rebuild them */
-- 
2.33.0

