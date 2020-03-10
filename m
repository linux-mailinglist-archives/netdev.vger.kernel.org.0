Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D10F17FDB6
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 14:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgCJMvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 08:51:37 -0400
Received: from inva021.nxp.com ([92.121.34.21]:45474 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbgCJMv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:29 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A59932005C8;
        Tue, 10 Mar 2020 13:51:26 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 98A622005AE;
        Tue, 10 Mar 2020 13:51:26 +0100 (CET)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4A9892036B;
        Tue, 10 Mar 2020 13:51:26 +0100 (CET)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 4/4] enetc: Add dynamic allocation of extended Rx BD rings
Date:   Tue, 10 Mar 2020 14:51:24 +0200
Message-Id: <1583844684-28202-5-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
References: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware timestamping support (PTP) on Rx requires extended
buffer descriptors, double the size of normal Rx descriptors.
On the current controller revision only the timestamping offload
requires extended Rx descriptors.
Since Rx timestamping can be turned on/off at runtime, make Rx ring
allocation configurable at runtime too. As a result, the static
config option FSL_ENETC_HW_TIMESTAMPING can be dropped and the
extended descriptors can be used only when Rx timestamping gets
activated.
The extension has the same size as the base descriptor, making
the descriptor iterators easy to update for the extended case.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig  | 10 -----
 drivers/net/ethernet/freescale/enetc/enetc.c  | 39 +++++++++++++------
 drivers/net/ethernet/freescale/enetc/enetc.h  | 18 ++++++++-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  2 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  9 ++---
 5 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index f86283411f4d..2b43848e1363 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -42,16 +42,6 @@ config FSL_ENETC_PTP_CLOCK
 
 	  If compiled as module (M), the module name is fsl-enetc-ptp.
 
-config FSL_ENETC_HW_TIMESTAMPING
-	bool "ENETC hardware timestamping support"
-	depends on FSL_ENETC || FSL_ENETC_VF
-	help
-	  Enable hardware timestamping support on the Ethernet packets
-	  using the SO_TIMESTAMPING API. Because the RX BD ring dynamic
-	  allocation has not been supported and it is too expensive to use
-	  extended RX BDs if timestamping is not used, this option enables
-	  extended RX BDs in order to support hardware timestamping.
-
 config FSL_ENETC_QOS
 	bool "ENETC hardware Time-sensitive Network support"
 	depends on (FSL_ENETC || FSL_ENETC_VF) && (NET_SCH_TAPRIO || NET_SCH_CBS)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index f1bbaef428c0..ccf2611f4a20 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -487,7 +487,7 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
 	return j;
 }
 
-#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
+#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 static void enetc_get_rx_tstamp(struct net_device *ndev,
 				union enetc_rx_bd *rxbd,
 				struct sk_buff *skb)
@@ -501,7 +501,8 @@ static void enetc_get_rx_tstamp(struct net_device *ndev,
 	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_TSTMP) {
 		lo = enetc_rd(hw, ENETC_SICTR0);
 		hi = enetc_rd(hw, ENETC_SICTR1);
-		tstamp_lo = le32_to_cpu(rxbd->r.tstamp);
+		rxbd = enetc_rxbd_ext(rxbd);
+		tstamp_lo = le32_to_cpu(rxbd->ext.tstamp);
 		if (lo <= tstamp_lo)
 			hi -= 1;
 
@@ -515,7 +516,7 @@ static void enetc_get_rx_tstamp(struct net_device *ndev,
 static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 			       union enetc_rx_bd *rxbd, struct sk_buff *skb)
 {
-#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
+#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
 #endif
 	/* TODO: hashing */
@@ -532,7 +533,7 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_VLAN)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       le16_to_cpu(rxbd->r.vlan_opt));
-#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
+#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	if (priv->active_offloads & ENETC_F_RX_TSTAMP)
 		enetc_get_rx_tstamp(rx_ring->ndev, rxbd, skb);
 #endif
@@ -838,15 +839,19 @@ static void enetc_free_tx_resources(struct enetc_ndev_priv *priv)
 		enetc_free_txbdr(priv->tx_ring[i]);
 }
 
-static int enetc_alloc_rxbdr(struct enetc_bdr *rxr)
+static int enetc_alloc_rxbdr(struct enetc_bdr *rxr, bool extended)
 {
+	size_t size = sizeof(union enetc_rx_bd);
 	int err;
 
 	rxr->rx_swbd = vzalloc(rxr->bd_count * sizeof(struct enetc_rx_swbd));
 	if (!rxr->rx_swbd)
 		return -ENOMEM;
 
-	err = enetc_dma_alloc_bdr(rxr, sizeof(union enetc_rx_bd));
+	if (extended)
+		size *= 2;
+
+	err = enetc_dma_alloc_bdr(rxr, size);
 	if (err) {
 		vfree(rxr->rx_swbd);
 		return err;
@@ -855,6 +860,7 @@ static int enetc_alloc_rxbdr(struct enetc_bdr *rxr)
 	rxr->next_to_clean = 0;
 	rxr->next_to_use = 0;
 	rxr->next_to_alloc = 0;
+	rxr->ext_en = extended;
 
 	return 0;
 }
@@ -874,10 +880,11 @@ static void enetc_free_rxbdr(struct enetc_bdr *rxr)
 
 static int enetc_alloc_rx_resources(struct enetc_ndev_priv *priv)
 {
+	bool extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
 	int i, err;
 
 	for (i = 0; i < priv->num_rx_rings; i++) {
-		err = enetc_alloc_rxbdr(priv->rx_ring[i]);
+		err = enetc_alloc_rxbdr(priv->rx_ring[i], extended);
 
 		if (err)
 			goto fail;
@@ -1167,9 +1174,10 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	enetc_rxbdr_wr(hw, idx, ENETC_RBICIR0, ENETC_RBICIR0_ICEN | 0x1);
 
 	rbmr = ENETC_RBMR_EN;
-#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
-	rbmr |= ENETC_RBMR_BDS;
-#endif
+
+	if (rx_ring->ext_en)
+		rbmr |= ENETC_RBMR_BDS;
+
 	if (rx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
 		rbmr |= ENETC_RBMR_VTE;
 
@@ -1570,11 +1578,12 @@ int enetc_set_features(struct net_device *ndev,
 	return 0;
 }
 
-#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
+#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct hwtstamp_config config;
+	int ao;
 
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
@@ -1590,6 +1599,7 @@ static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
 		return -ERANGE;
 	}
 
+	ao = priv->active_offloads;
 	switch (config.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
 		priv->active_offloads &= ~ENETC_F_RX_TSTAMP;
@@ -1599,6 +1609,11 @@ static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
 	}
 
+	if (netif_running(ndev) && ao != priv->active_offloads) {
+		enetc_close(ndev);
+		enetc_open(ndev);
+	}
+
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
 	       -EFAULT : 0;
 }
@@ -1625,7 +1640,7 @@ static int enetc_hwtstamp_get(struct net_device *ndev, struct ifreq *ifr)
 
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 {
-#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
+#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	if (cmd == SIOCSHWTSTAMP)
 		return enetc_hwtstamp_set(ndev, rq);
 	if (cmd == SIOCGHWTSTAMP)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 1cd4cddd5c58..56c43f35b633 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -73,6 +73,7 @@ struct enetc_bdr {
 
 	dma_addr_t bd_dma_base;
 	u8 tsd_enable; /* Time specific departure */
+	bool ext_en; /* enable h/w descriptor extensions */
 } ____cacheline_aligned_in_smp;
 
 static inline void enetc_bdr_idx_inc(struct enetc_bdr *bdr, int *i)
@@ -107,7 +108,13 @@ struct enetc_cbdr {
 
 static inline union enetc_rx_bd *enetc_rxbd(struct enetc_bdr *rx_ring, int i)
 {
-	return &(((union enetc_rx_bd *)rx_ring->bd_base)[i]);
+	int hw_idx = i;
+
+#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
+	if (rx_ring->ext_en)
+		hw_idx = 2 * i;
+#endif
+	return &(((union enetc_rx_bd *)rx_ring->bd_base)[hw_idx]);
 }
 
 static inline union enetc_rx_bd *enetc_rxbd_next(struct enetc_bdr *rx_ring,
@@ -115,12 +122,21 @@ static inline union enetc_rx_bd *enetc_rxbd_next(struct enetc_bdr *rx_ring,
 						 int i)
 {
 	rxbd++;
+#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
+	if (rx_ring->ext_en)
+		rxbd++;
+#endif
 	if (unlikely(++i == rx_ring->bd_count))
 		rxbd = rx_ring->bd_base;
 
 	return rxbd;
 }
 
+static inline union enetc_rx_bd *enetc_rxbd_ext(union enetc_rx_bd *rxbd)
+{
+	return ++rxbd;
+}
+
 struct enetc_msg_swbd {
 	void *vaddr;
 	dma_addr_t dma;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 888d45fef529..34bd1f3fb415 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -574,7 +574,7 @@ static int enetc_get_ts_info(struct net_device *ndev,
 		info->phc_index = -1;
 	}
 
-#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
+#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index da134e211c1a..2a6523136947 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -418,9 +418,6 @@ union enetc_rx_bd {
 	struct {
 		__le64 addr;
 		u8 reserved[8];
-#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
-		u8 reserved1[16];
-#endif
 	} w;
 	struct {
 		__le16 inet_csum;
@@ -435,11 +432,11 @@ union enetc_rx_bd {
 			};
 			__le32 lstatus;
 		};
-#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
+	} r;
+	struct {
 		__le32 tstamp;
 		u8 reserved[12];
-#endif
-	} r;
+	} ext;
 };
 
 #define ENETC_RXBD_LSTATUS_R	BIT(30)
-- 
2.17.1

