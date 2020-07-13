Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F217621D664
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgGMM4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:56:21 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56528 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729683AbgGMM4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 08:56:15 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7E3721A0EC1;
        Mon, 13 Jul 2020 14:56:11 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6D3951A0EBE;
        Mon, 13 Jul 2020 14:56:11 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 458BA204BE;
        Mon, 13 Jul 2020 14:56:11 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 4/6] enetc: Add interrupt coalescing support
Date:   Mon, 13 Jul 2020 15:56:08 +0300
Message-Id: <1594644970-13531-5-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
References: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable programming of the interrupt coalescing registers
and allow manual configuration of the coalescing time
thresholds via ethtool.  Packet thresholds have been fixed
to predetermined values as there's no point in making them
run-time configurable, also anticipating the dynamic interrupt
moderation (dim) algorithm which uses fixed packet thresholds
as well.  If the interface is up when the operation mode of
traffic interrupt events is changed by the user (i.e. switching
from default per-packet interrupts to coalesced interrupts),
the traffic needs to be paused in the process.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 41 ++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  | 19 +++++
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 76 ++++++++++++++++++-
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 19 ++++-
 4 files changed, 144 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index be594c7af538..e66405d1b791 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -265,9 +265,12 @@ static irqreturn_t enetc_msix(int irq, void *data)
 
 	/* disable interrupts */
 	enetc_wr_reg(v->rbier, 0);
+	enetc_wr_reg(v->ricr1, v->rx_ictt);
 
-	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
+	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS) {
 		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i), 0);
+		enetc_wr_reg(v->ticr1_base + ENETC_BDR_OFF(i), v->tx_ictt);
+	}
 
 	napi_schedule_irqoff(&v->napi);
 
@@ -1268,6 +1271,8 @@ static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 
 		v->tbier_base = hw->reg + ENETC_BDR(TX, 0, ENETC_TBIER);
 		v->rbier = hw->reg + ENETC_BDR(RX, i, ENETC_RBIER);
+		v->ticr1_base = hw->reg + ENETC_BDR(TX, 0, ENETC_TBICR1);
+		v->ricr1 = hw->reg + ENETC_BDR(RX, i, ENETC_RBICR1);
 
 		enetc_wr(hw, ENETC_SIMSIRRV(i), entry);
 
@@ -1309,17 +1314,39 @@ static void enetc_free_irqs(struct enetc_ndev_priv *priv)
 
 static void enetc_setup_interrupts(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
+	u32 icpt, ictt;
 	int i;
 
 	/* enable Tx & Rx event indication */
 	for (i = 0; i < priv->num_rx_rings; i++) {
-		enetc_rxbdr_wr(&priv->si->hw, i,
-			       ENETC_RBIER, ENETC_RBIER_RXTIE);
+		if (priv->ic_mode & ENETC_IC_RX_MANUAL) {
+			icpt = ENETC_RBICR0_SET_ICPT(ENETC_RXIC_PKTTHR);
+			/* init to non-0 minimum, will be adjusted later */
+			ictt = 0x1;
+		} else {
+			icpt = 0x1; /* enable Rx ints by setting pkt thr to 1 */
+			ictt = 0;
+		}
+
+		enetc_rxbdr_wr(hw, i, ENETC_RBICR1, ictt);
+		enetc_rxbdr_wr(hw, i, ENETC_RBICR0, ENETC_RBICR0_ICEN | icpt);
+		enetc_rxbdr_wr(hw, i, ENETC_RBIER, ENETC_RBIER_RXTIE);
 	}
 
 	for (i = 0; i < priv->num_tx_rings; i++) {
-		enetc_txbdr_wr(&priv->si->hw, i,
-			       ENETC_TBIER, ENETC_TBIER_TXTIE);
+		if (priv->ic_mode & ENETC_IC_TX_MANUAL) {
+			icpt = ENETC_TBICR0_SET_ICPT(ENETC_TXIC_PKTTHR);
+			/* init to non-0 minimum, will be adjusted later */
+			ictt = 0x1;
+		} else {
+			icpt = 0x1; /* enable Tx ints by setting pkt thr to 1 */
+			ictt = 0;
+		}
+
+		enetc_txbdr_wr(hw, i, ENETC_TBICR1, ictt);
+		enetc_txbdr_wr(hw, i, ENETC_TBICR0, ENETC_TBICR0_ICEN | icpt);
+		enetc_txbdr_wr(hw, i, ENETC_TBIER, ENETC_TBIER_TXTIE);
 	}
 }
 
@@ -1370,7 +1397,7 @@ static int enetc_phy_connect(struct net_device *ndev)
 	return 0;
 }
 
-static void enetc_start(struct net_device *ndev)
+void enetc_start(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	int i;
@@ -1440,7 +1467,7 @@ int enetc_open(struct net_device *ndev)
 	return err;
 }
 
-static void enetc_stop(struct net_device *ndev)
+void enetc_stop(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	int i;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 0dd8ee179753..cec7e05ec523 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -190,6 +190,10 @@ static inline bool enetc_si_is_pf(struct enetc_si *si)
 struct enetc_int_vector {
 	void __iomem *rbier;
 	void __iomem *tbier_base;
+	void __iomem *ricr1;
+	void __iomem *ticr1_base;
+	u32 rx_ictt;
+	u32 tx_ictt;
 	unsigned long tx_rings_map;
 	int count_tx_rings;
 	struct napi_struct napi;
@@ -221,6 +225,18 @@ enum enetc_active_offloads {
 	ENETC_F_QCI		= BIT(3),
 };
 
+/* interrupt coalescing modes */
+enum enetc_ic_mode {
+	/* one interrupt per frame */
+	ENETC_IC_NONE = 0,
+	/* activated when int coalescing time is set to a non-0 value */
+	ENETC_IC_RX_MANUAL = BIT(0),
+	ENETC_IC_TX_MANUAL = BIT(1),
+};
+
+#define ENETC_RXIC_PKTTHR	min_t(u32, 256, ENETC_RX_RING_DEFAULT_SIZE / 2)
+#define ENETC_TXIC_PKTTHR	min_t(u32, 128, ENETC_TX_RING_DEFAULT_SIZE / 2)
+
 struct enetc_ndev_priv {
 	struct net_device *ndev;
 	struct device *dev; /* dma-mapping device */
@@ -245,6 +261,7 @@ struct enetc_ndev_priv {
 
 	struct device_node *phy_node;
 	phy_interface_t if_mode;
+	int ic_mode;
 };
 
 /* Messaging */
@@ -274,6 +291,8 @@ void enetc_free_si_resources(struct enetc_ndev_priv *priv);
 
 int enetc_open(struct net_device *ndev);
 int enetc_close(struct net_device *ndev);
+void enetc_start(struct net_device *ndev);
+void enetc_stop(struct net_device *ndev);
 netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev);
 struct net_device_stats *enetc_get_stats(struct net_device *ndev);
 int enetc_set_features(struct net_device *ndev,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 8aeaa3de0012..8e0867fa1af6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -14,12 +14,14 @@ static const u32 enetc_si_regs[] = {
 
 static const u32 enetc_txbdr_regs[] = {
 	ENETC_TBMR, ENETC_TBSR, ENETC_TBBAR0, ENETC_TBBAR1,
-	ENETC_TBPIR, ENETC_TBCIR, ENETC_TBLENR, ENETC_TBIER
+	ENETC_TBPIR, ENETC_TBCIR, ENETC_TBLENR, ENETC_TBIER, ENETC_TBICR0,
+	ENETC_TBICR1
 };
 
 static const u32 enetc_rxbdr_regs[] = {
 	ENETC_RBMR, ENETC_RBSR, ENETC_RBBSR, ENETC_RBCIR, ENETC_RBBAR0,
-	ENETC_RBBAR1, ENETC_RBPIR, ENETC_RBLENR, ENETC_RBICR0, ENETC_RBIER
+	ENETC_RBBAR1, ENETC_RBPIR, ENETC_RBLENR, ENETC_RBIER, ENETC_RBICR0,
+	ENETC_RBICR1
 };
 
 static const u32 enetc_port_regs[] = {
@@ -561,6 +563,68 @@ static void enetc_get_ringparam(struct net_device *ndev,
 	}
 }
 
+static int enetc_get_coalesce(struct net_device *ndev,
+			      struct ethtool_coalesce *ic)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_int_vector *v = priv->int_vector[0];
+
+	memset(ic, 0, sizeof(*ic));
+	ic->tx_coalesce_usecs = enetc_cycles_to_usecs(v->tx_ictt);
+	ic->rx_coalesce_usecs = enetc_cycles_to_usecs(v->rx_ictt);
+
+	ic->tx_max_coalesced_frames = ENETC_TXIC_PKTTHR;
+	ic->rx_max_coalesced_frames = ENETC_RXIC_PKTTHR;
+
+	return 0;
+}
+
+static int enetc_set_coalesce(struct net_device *ndev,
+			      struct ethtool_coalesce *ic)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	u32 rx_ictt, tx_ictt;
+	int i, ic_mode;
+
+	tx_ictt = enetc_usecs_to_cycles(ic->tx_coalesce_usecs);
+	rx_ictt = enetc_usecs_to_cycles(ic->rx_coalesce_usecs);
+
+	if (!ic->rx_max_coalesced_frames)
+		netif_warn(priv, hw, ndev, "rx-frames fixed to %d\n",
+			   ENETC_RXIC_PKTTHR);
+
+	if (!ic->tx_max_coalesced_frames)
+		netif_warn(priv, hw, ndev, "tx-frames fixed to %d\n",
+			   ENETC_TXIC_PKTTHR);
+
+	ic_mode = ENETC_IC_NONE;
+	if (tx_ictt)
+		ic_mode |= ENETC_IC_TX_MANUAL;
+	if (rx_ictt)
+		ic_mode |= ENETC_IC_RX_MANUAL;
+
+	/* commit the settings */
+	for (i = 0; i < priv->bdr_int_num; i++) {
+		struct enetc_int_vector *v = priv->int_vector[i];
+
+		v->tx_ictt = tx_ictt;
+		v->rx_ictt = rx_ictt;
+	}
+
+	if (netif_running(ndev) && ic_mode != priv->ic_mode) {
+		priv->ic_mode = ic_mode;
+		/* reconfigure the operation mode of h/w interrupts,
+		 * traffic needs to be paused in the process
+		 */
+		enetc_stop(ndev);
+		enetc_start(ndev);
+	} else {
+		priv->ic_mode = ic_mode;
+	}
+
+	return 0;
+}
+
 static int enetc_get_ts_info(struct net_device *ndev,
 			     struct ethtool_ts_info *info)
 {
@@ -617,6 +681,8 @@ static int enetc_set_wol(struct net_device *dev,
 }
 
 static const struct ethtool_ops enetc_pf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_regs_len = enetc_get_reglen,
 	.get_regs = enetc_get_regs,
 	.get_sset_count = enetc_get_sset_count,
@@ -629,6 +695,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.get_rxfh = enetc_get_rxfh,
 	.set_rxfh = enetc_set_rxfh,
 	.get_ringparam = enetc_get_ringparam,
+	.get_coalesce = enetc_get_coalesce,
+	.set_coalesce = enetc_set_coalesce,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 	.get_link = ethtool_op_get_link,
@@ -638,6 +706,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_regs_len = enetc_get_reglen,
 	.get_regs = enetc_get_regs,
 	.get_sset_count = enetc_get_sset_count,
@@ -649,6 +719,8 @@ static const struct ethtool_ops enetc_vf_ethtool_ops = {
 	.get_rxfh = enetc_get_rxfh,
 	.set_rxfh = enetc_set_rxfh,
 	.get_ringparam = enetc_get_ringparam,
+	.get_coalesce = enetc_get_coalesce,
+	.set_coalesce = enetc_set_coalesce,
 	.get_link = ethtool_op_get_link,
 	.get_ts_info = enetc_get_ts_info,
 };
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 05bb4c525897..95f3c4d8f602 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -122,7 +122,10 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_RBIER_RXTIE	BIT(0)
 #define ENETC_RBIDR	0xa4
 #define ENETC_RBICR0	0xa8
-#define ENETC_RBICR0_ICEN	BIT(31)
+#define ENETC_RBICR0_ICEN		BIT(31)
+#define ENETC_RBICR0_ICPT_MASK		0x1ff
+#define ENETC_RBICR0_SET_ICPT(n)	((n) & ENETC_RBICR0_ICPT_MASK)
+#define ENETC_RBICR1	0xac
 
 /* TX BDR reg offsets */
 #define ENETC_TBMR	0
@@ -142,7 +145,10 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_TBIER_TXTIE	BIT(0)
 #define ENETC_TBIDR	0xa4
 #define ENETC_TBICR0	0xa8
-#define ENETC_TBICR0_ICEN	BIT(31)
+#define ENETC_TBICR0_ICEN		BIT(31)
+#define ENETC_TBICR0_ICPT_MASK		0xf
+#define ENETC_TBICR0_SET_ICPT(n) ((ilog2(n) + 1) & ENETC_TBICR0_ICPT_MASK)
+#define ENETC_TBICR1	0xac
 
 #define ENETC_RTBLENR_LEN(n)	((n) & ~0x7)
 
@@ -784,6 +790,15 @@ struct enetc_cbd {
 };
 
 #define ENETC_CLK  400000000ULL
+static inline u32 enetc_cycles_to_usecs(u32 cycles)
+{
+	return (u32)div_u64(cycles * 1000000ULL, ENETC_CLK);
+}
+
+static inline u32 enetc_usecs_to_cycles(u32 usecs)
+{
+	return (u32)div_u64(usecs * ENETC_CLK, 1000000ULL);
+}
 
 /* port time gating control register */
 #define ENETC_QBV_PTGCR_OFFSET		0x11a00
-- 
2.17.1

