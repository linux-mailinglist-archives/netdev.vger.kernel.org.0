Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39B221D663
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgGMM4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:56:20 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48800 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbgGMM4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 08:56:15 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 01B2E2014FE;
        Mon, 13 Jul 2020 14:56:12 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DDFBB2014F1;
        Mon, 13 Jul 2020 14:56:11 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B7C43204BE;
        Mon, 13 Jul 2020 14:56:11 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 6/6] enetc: Add adaptive interrupt coalescing
Date:   Mon, 13 Jul 2020 15:56:10 +0300
Message-Id: <1594644970-13531-7-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
References: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the generic dynamic interrupt moderation (dim)
framework to implement adaptive interrupt coalescing
in ENETC.  With the per-packet interrupt scheme, a high
interrupt rate has been noted for moderate traffic flows
leading to high CPU utilization.  The 'dim' scheme
implemented by the current patch addresses this issue
improving CPU utilization while using minimal coalescing
time thresholds in order to preserve a good latency.

Below are some measurement results for before and after
this patch (and related dependencies) basically, for a
2 ARM Cortex-A72 @1.3Ghz CPUs system (32 KB L1 data cache),
using netperf @ 1Gbit link (maximum throughput):

1) 1 Rx TCP flow, both Rx and Tx processed by the same NAPI
thread on the same CPU:
	CPU utilization		int rate (ints/sec)
Before:	50%-60% (over 50%)		92k
After:  just under 50%			35k
Comment:  Small CPU utilization improvement for a single flow
	  Rx TCP flow (i.e. netperf -t TCP_MAERTS) on a single
	  CPU.

2) 1 Rx TCP flow, Rx processing on CPU0, Tx on CPU1:
	Total CPU utilization	Total int rate (ints/sec)
Before:	60%-70%			85k CPU0 + 42k CPU1
After:  15%			3.5k CPU0 + 3.5k CPU1
Comment:  Huge improvement in total CPU utilization
	  correlated w/a a huge decrease in interrupt rate.

3) 4 Rx TCP flows + 4 Tx TCP flows (+ pings to check the latency):
	Total CPU utilization	Total int rate (ints/sec)
Before:	~80% (spikes to 90%)		~100k
After:   60% (more steady)		 ~10k
Comment:  Important improvement for this load test, while the
	  ping test outcome was not impacted.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig  |   2 +
 drivers/net/ethernet/freescale/enetc/enetc.c  | 100 ++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  14 ++-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  28 +++--
 4 files changed, 129 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 2b43848e1363..37b804f8bd76 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -4,6 +4,7 @@ config FSL_ENETC
 	depends on PCI && PCI_MSI
 	select FSL_ENETC_MDIO
 	select PHYLIB
+	select DIMLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
 	  physical function (PF) devices, managing ENETC Ports at a privileged
@@ -15,6 +16,7 @@ config FSL_ENETC_VF
 	tristate "ENETC VF driver"
 	depends on PCI && PCI_MSI
 	select PHYLIB
+	select DIMLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
 	  virtual function (VF) devices enabled by the ENETC PF driver.
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e66405d1b791..0c623eaf431c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -277,10 +277,68 @@ static irqreturn_t enetc_msix(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget);
+static int enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget);
 static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 			       struct napi_struct *napi, int work_limit);
 
+static void enetc_rx_dim_work(struct work_struct *w)
+{
+	struct dim *dim = container_of(w, struct dim, work);
+	struct dim_cq_moder moder =
+		net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
+	struct enetc_int_vector	*v =
+		container_of(dim, struct enetc_int_vector, rx_dim);
+
+	v->rx_ictt = enetc_usecs_to_cycles(moder.usec);
+	dim->state = DIM_START_MEASURE;
+}
+
+static void enetc_tx_dim_work(struct work_struct *w)
+{
+	struct dim *dim = container_of(w, struct dim, work);
+	struct dim_cq_moder moder =
+		net_dim_get_tx_moderation(dim->mode, dim->profile_ix);
+	struct enetc_int_vector	*v =
+		container_of(dim, struct enetc_int_vector, tx_dim);
+
+	v->tx_ictt = enetc_usecs_to_cycles(moder.usec);
+	dim->state = DIM_START_MEASURE;
+}
+
+static void enetc_rx_net_dim(struct enetc_int_vector *v)
+{
+	struct dim_sample dim_sample;
+
+	dim_update_sample(v->comp_cnt,
+			  v->rx_ring.stats.packets,
+			  v->rx_ring.stats.bytes,
+			  &dim_sample);
+	net_dim(&v->rx_dim, dim_sample);
+}
+
+static void enetc_tx_net_dim(struct enetc_int_vector *v)
+{
+	unsigned int packets = 0, bytes = 0;
+	struct dim_sample dim_sample;
+	int i;
+
+	for (i = 0; i < v->count_tx_rings; i++) {
+		packets += v->tx_ring[i].stats.packets;
+		bytes += v->tx_ring[i].stats.bytes;
+	}
+	dim_update_sample(v->comp_cnt, packets, bytes, &dim_sample);
+	net_dim(&v->tx_dim, dim_sample);
+}
+
+static void enetc_net_dim(struct enetc_int_vector *v)
+{
+	v->comp_cnt++;
+	if (v->rx_dim_en && v->rx_napi_work)
+		enetc_rx_net_dim(v);
+	if (v->tx_dim_en && v->tx_napi_work)
+		enetc_tx_net_dim(v);
+}
+
 static int enetc_poll(struct napi_struct *napi, int budget)
 {
 	struct enetc_int_vector
@@ -289,19 +347,31 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	int work_done;
 	int i;
 
-	for (i = 0; i < v->count_tx_rings; i++)
-		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
+	for (i = 0; i < v->count_tx_rings; i++) {
+		work_done = enetc_clean_tx_ring(&v->tx_ring[i], budget);
+		if (work_done == ENETC_DEFAULT_TX_WORK)
 			complete = false;
+		if (work_done)
+			v->tx_napi_work = true;
+	}
 
 	work_done = enetc_clean_rx_ring(&v->rx_ring, napi, budget);
 	if (work_done == budget)
 		complete = false;
+	if (work_done)
+		v->rx_napi_work = true;
 
 	if (!complete)
 		return budget;
 
 	napi_complete_done(napi, work_done);
 
+	if (likely(v->rx_dim_en || v->tx_dim_en))
+		enetc_net_dim(v);
+
+	v->rx_napi_work = false;
+	v->tx_napi_work = false;
+
 	/* enable interrupts */
 	enetc_wr_reg(v->rbier, ENETC_RBIER_RXTIE);
 
@@ -343,7 +413,7 @@ static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
 	}
 }
 
-static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
+static int enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 {
 	struct net_device *ndev = tx_ring->ndev;
 	int tx_frm_cnt = 0, tx_byte_cnt = 0;
@@ -419,7 +489,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 		netif_wake_subqueue(ndev, tx_ring->index);
 	}
 
-	return tx_frm_cnt != ENETC_DEFAULT_TX_WORK;
+	return tx_frm_cnt;
 }
 
 static bool enetc_new_page(struct enetc_bdr *rx_ring,
@@ -1077,6 +1147,7 @@ void enetc_init_si_rings_params(struct enetc_ndev_priv *priv)
 	priv->num_rx_rings = min_t(int, cpus, si->num_rx_rings);
 	priv->num_tx_rings = si->num_tx_rings;
 	priv->bdr_int_num = cpus;
+	priv->ic_mode = ENETC_IC_ADAPTIVE;
 
 	/* SI specific */
 	si->cbd_ring.bd_count = ENETC_CBDR_DEFAULT_SIZE;
@@ -1320,7 +1391,8 @@ static void enetc_setup_interrupts(struct enetc_ndev_priv *priv)
 
 	/* enable Tx & Rx event indication */
 	for (i = 0; i < priv->num_rx_rings; i++) {
-		if (priv->ic_mode & ENETC_IC_RX_MANUAL) {
+		if (priv->ic_mode &
+		    (ENETC_IC_RX_MANUAL | ENETC_IC_RX_ADAPTIVE)) {
 			icpt = ENETC_RBICR0_SET_ICPT(ENETC_RXIC_PKTTHR);
 			/* init to non-0 minimum, will be adjusted later */
 			ictt = 0x1;
@@ -1335,7 +1407,8 @@ static void enetc_setup_interrupts(struct enetc_ndev_priv *priv)
 	}
 
 	for (i = 0; i < priv->num_tx_rings; i++) {
-		if (priv->ic_mode & ENETC_IC_TX_MANUAL) {
+		if (priv->ic_mode &
+		    (ENETC_IC_TX_MANUAL | ENETC_IC_TX_ADAPTIVE)) {
 			icpt = ENETC_TBICR0_SET_ICPT(ENETC_TXIC_PKTTHR);
 			/* init to non-0 minimum, will be adjusted later */
 			ictt = 0x1;
@@ -1793,6 +1866,15 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 
 		priv->int_vector[i] = v;
 
+		/* init defaults for adaptive IC */
+		if (priv->ic_mode == ENETC_IC_ADAPTIVE) {
+			v->tx_ictt = 0x1;
+			v->rx_ictt = 0x1;
+			v->tx_dim_en = true;
+			v->rx_dim_en = true;
+		}
+		INIT_WORK(&v->rx_dim.work, enetc_rx_dim_work);
+		INIT_WORK(&v->tx_dim.work, enetc_tx_dim_work);
 		netif_napi_add(priv->ndev, &v->napi, enetc_poll,
 			       NAPI_POLL_WEIGHT);
 		v->count_tx_rings = v_tx_rings;
@@ -1828,6 +1910,8 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 fail:
 	while (i--) {
 		netif_napi_del(&priv->int_vector[i]->napi);
+		cancel_work_sync(&priv->int_vector[i]->rx_dim.work);
+		cancel_work_sync(&priv->int_vector[i]->tx_dim.work);
 		kfree(priv->int_vector[i]);
 	}
 
@@ -1844,6 +1928,8 @@ void enetc_free_msix(struct enetc_ndev_priv *priv)
 		struct enetc_int_vector *v = priv->int_vector[i];
 
 		netif_napi_del(&v->napi);
+		cancel_work_sync(&v->rx_dim.work);
+		cancel_work_sync(&v->tx_dim.work);
 	}
 
 	for (i = 0; i < priv->num_rx_rings; i++)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index af5a276ce02d..b9d1215c7155 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -10,6 +10,7 @@
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
 #include <linux/phy.h>
+#include <linux/dim.h>
 
 #include "enetc_hw.h"
 
@@ -196,12 +197,17 @@ struct enetc_int_vector {
 	u32 tx_ictt;
 	unsigned long tx_rings_map;
 	int count_tx_rings;
-	struct napi_struct napi;
+	u16 comp_cnt;
+	bool rx_dim_en, tx_dim_en;
+	bool rx_napi_work, tx_napi_work;
+	struct napi_struct napi ____cacheline_aligned_in_smp;
+	struct dim rx_dim ____cacheline_aligned_in_smp;
+	struct dim tx_dim;
 	char name[ENETC_INT_NAME_MAX];
 
 	struct enetc_bdr rx_ring;
 	struct enetc_bdr tx_ring[];
-};
+} ____cacheline_aligned_in_smp;
 
 struct enetc_cls_rule {
 	struct ethtool_rx_flow_spec fs;
@@ -232,8 +238,12 @@ enum enetc_ic_mode {
 	/* activated when int coalescing time is set to a non-0 value */
 	ENETC_IC_RX_MANUAL = BIT(0),
 	ENETC_IC_TX_MANUAL = BIT(1),
+	/* use dynamic interrupt moderation */
+	ENETC_IC_RX_ADAPTIVE = BIT(2),
+	ENETC_IC_TX_ADAPTIVE = BIT(3),
 };
 
+#define ENETC_IC_ADAPTIVE	(ENETC_IC_RX_ADAPTIVE | ENETC_IC_TX_ADAPTIVE)
 #define ENETC_RXIC_PKTTHR	min_t(u32, 256, ENETC_RX_RING_DEFAULT_SIZE / 2)
 #define ENETC_TXIC_PKTTHR	min_t(u32, 128, ENETC_TX_RING_DEFAULT_SIZE / 2)
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 8e0867fa1af6..344a1105444f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -576,6 +576,9 @@ static int enetc_get_coalesce(struct net_device *ndev,
 	ic->tx_max_coalesced_frames = ENETC_TXIC_PKTTHR;
 	ic->rx_max_coalesced_frames = ENETC_RXIC_PKTTHR;
 
+	ic->use_adaptive_rx_coalesce = priv->ic_mode & ENETC_IC_RX_ADAPTIVE;
+	ic->use_adaptive_tx_coalesce = priv->ic_mode & ENETC_IC_TX_ADAPTIVE;
+
 	return 0;
 }
 
@@ -598,10 +601,19 @@ static int enetc_set_coalesce(struct net_device *ndev,
 			   ENETC_TXIC_PKTTHR);
 
 	ic_mode = ENETC_IC_NONE;
-	if (tx_ictt)
-		ic_mode |= ENETC_IC_TX_MANUAL;
-	if (rx_ictt)
-		ic_mode |= ENETC_IC_RX_MANUAL;
+	if (ic->use_adaptive_rx_coalesce) {
+		ic_mode |= ENETC_IC_RX_ADAPTIVE;
+		rx_ictt = 0x1;
+	} else {
+		ic_mode |= rx_ictt ? ENETC_IC_RX_MANUAL : 0;
+	}
+
+	if (ic->use_adaptive_tx_coalesce) {
+		ic_mode |= ENETC_IC_TX_ADAPTIVE;
+		tx_ictt = 0x1;
+	} else {
+		ic_mode |= tx_ictt ? ENETC_IC_TX_MANUAL : 0;
+	}
 
 	/* commit the settings */
 	for (i = 0; i < priv->bdr_int_num; i++) {
@@ -609,6 +621,8 @@ static int enetc_set_coalesce(struct net_device *ndev,
 
 		v->tx_ictt = tx_ictt;
 		v->rx_ictt = rx_ictt;
+		v->tx_dim_en = !!(ic_mode & ENETC_IC_TX_ADAPTIVE);
+		v->rx_dim_en = !!(ic_mode & ENETC_IC_RX_ADAPTIVE);
 	}
 
 	if (netif_running(ndev) && ic_mode != priv->ic_mode) {
@@ -682,7 +696,8 @@ static int enetc_set_wol(struct net_device *dev,
 
 static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-				     ETHTOOL_COALESCE_MAX_FRAMES,
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_regs_len = enetc_get_reglen,
 	.get_regs = enetc_get_regs,
 	.get_sset_count = enetc_get_sset_count,
@@ -707,7 +722,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-				     ETHTOOL_COALESCE_MAX_FRAMES,
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_regs_len = enetc_get_reglen,
 	.get_regs = enetc_get_regs,
 	.get_sset_count = enetc_get_sset_count,
-- 
2.17.1

