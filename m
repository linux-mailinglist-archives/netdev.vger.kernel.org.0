Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B632279F1
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgGUHza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:55:30 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57698 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728348AbgGUHz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 03:55:28 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A1797201557;
        Tue, 21 Jul 2020 09:55:24 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9525F20081B;
        Tue, 21 Jul 2020 09:55:24 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 67F5B202A9;
        Tue, 21 Jul 2020 09:55:24 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 6/6] enetc: Add adaptive interrupt coalescing
Date:   Tue, 21 Jul 2020 10:55:22 +0300
Message-Id: <1595318122-18490-7-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the generic dynamic interrupt moderation (dim)
framework to implement adaptive interrupt coalescing
on Rx.  With the per-packet interrupt scheme, a high
interrupt rate has been noted for moderate traffic flows
leading to high CPU utilization.  The 'dim' scheme
implemented by the current patch addresses this issue
improving CPU utilization while using minimal coalescing
time thresholds in order to preserve a good latency.
On the Tx side use an optimal time threshold value by
default.  This value has been optimized for Tx TCP
streams at a rate of around 85kpps on a 1G link,
at which rate half of the Tx ring size (128) gets filled
in 1500 usecs.  Scaling this down to 2.5G links yields
the current value of 600 usecs, which is conservative
and gives good enough results for 1G links too (see
next).

Below are some measurement results for before and after
this patch (and related dependencies) basically, for a
2 ARM Cortex-A72 @1.3Ghz CPUs system (32 KB L1 data cache),
using 60secs log netperf TCP stream tests @ 1Gbit link
(maximum throughput):

1) 1 Rx TCP flow, both Rx and Tx processed by the same NAPI
thread on the same CPU:
	CPU utilization		int rate (ints/sec)
Before:	50%-60% (over 50%)		92k
After:  13%-22%				3.5k-12k
Comment:  Major CPU utilization improvement for a single flow
	  Rx TCP flow (i.e. netperf -t TCP_MAERTS) on a single
	  CPU. Usually settles under 16% for longer tests.

2) 4 Rx TCP flows + 4 Tx TCP flows (+ pings to check the latency):
	Total CPU utilization	Total int rate (ints/sec)
Before:	~80% (spikes to 90%)		~100k
After:   60% (more steady)		  ~4k
Comment:  Important improvement for this load test, while the
	  ping test outcome does not show any notable
	  difference compared to before.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: Replaced Tx DIM with static optimal value.
v3: simplified the code by dropping the 'OPTIMAL' flag

 drivers/net/ethernet/freescale/enetc/Kconfig  |  2 +
 drivers/net/ethernet/freescale/enetc/enetc.c  | 48 ++++++++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc.h  | 11 ++++-
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 19 ++++++--
 4 files changed, 73 insertions(+), 7 deletions(-)

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
index f4593c044043..f50353cbb4db 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -279,6 +279,34 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget);
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
+static void enetc_rx_net_dim(struct enetc_int_vector *v)
+{
+	struct dim_sample dim_sample;
+
+	v->comp_cnt++;
+
+	if (!v->rx_napi_work)
+		return;
+
+	dim_update_sample(v->comp_cnt,
+			  v->rx_ring.stats.packets,
+			  v->rx_ring.stats.bytes,
+			  &dim_sample);
+	net_dim(&v->rx_dim, dim_sample);
+}
+
 static int enetc_poll(struct napi_struct *napi, int budget)
 {
 	struct enetc_int_vector
@@ -294,12 +322,19 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	work_done = enetc_clean_rx_ring(&v->rx_ring, napi, budget);
 	if (work_done == budget)
 		complete = false;
+	if (work_done)
+		v->rx_napi_work = true;
 
 	if (!complete)
 		return budget;
 
 	napi_complete_done(napi, work_done);
 
+	if (likely(v->rx_dim_en))
+		enetc_rx_net_dim(v);
+
+	v->rx_napi_work = false;
+
 	/* enable interrupts */
 	enetc_wr_reg(v->rbier, ENETC_RBIER_RXTIE);
 
@@ -1075,6 +1110,8 @@ void enetc_init_si_rings_params(struct enetc_ndev_priv *priv)
 	priv->num_rx_rings = min_t(int, cpus, si->num_rx_rings);
 	priv->num_tx_rings = si->num_tx_rings;
 	priv->bdr_int_num = cpus;
+	priv->ic_mode = ENETC_IC_RX_ADAPTIVE | ENETC_IC_TX_MANUAL;
+	priv->tx_ictt = ENETC_TXIC_TIMETHR;
 
 	/* SI specific */
 	si->cbd_ring.bd_count = ENETC_CBDR_DEFAULT_SIZE;
@@ -1316,7 +1353,8 @@ static void enetc_setup_interrupts(struct enetc_ndev_priv *priv)
 	int i;
 
 	/* enable Tx & Rx event indication */
-	if (priv->ic_mode & ENETC_IC_RX_MANUAL) {
+	if (priv->ic_mode &
+	    (ENETC_IC_RX_MANUAL | ENETC_IC_RX_ADAPTIVE)) {
 		icpt = ENETC_RBICR0_SET_ICPT(ENETC_RXIC_PKTTHR);
 		/* init to non-0 minimum, will be adjusted later */
 		ictt = 0x1;
@@ -1786,6 +1824,12 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 
 		priv->int_vector[i] = v;
 
+		/* init defaults for adaptive IC */
+		if (priv->ic_mode & ENETC_IC_RX_ADAPTIVE) {
+			v->rx_ictt = 0x1;
+			v->rx_dim_en = true;
+		}
+		INIT_WORK(&v->rx_dim.work, enetc_rx_dim_work);
 		netif_napi_add(priv->ndev, &v->napi, enetc_poll,
 			       NAPI_POLL_WEIGHT);
 		v->count_tx_rings = v_tx_rings;
@@ -1821,6 +1865,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 fail:
 	while (i--) {
 		netif_napi_del(&priv->int_vector[i]->napi);
+		cancel_work_sync(&priv->int_vector[i]->rx_dim.work);
 		kfree(priv->int_vector[i]);
 	}
 
@@ -1837,6 +1882,7 @@ void enetc_free_msix(struct enetc_ndev_priv *priv)
 		struct enetc_int_vector *v = priv->int_vector[i];
 
 		netif_napi_del(&v->napi);
+		cancel_work_sync(&v->rx_dim.work);
 	}
 
 	for (i = 0; i < priv->num_rx_rings; i++)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 4e3af7f07892..d309803cfeb6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -10,6 +10,7 @@
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
 #include <linux/phy.h>
+#include <linux/dim.h>
 
 #include "enetc_hw.h"
 
@@ -194,12 +195,15 @@ struct enetc_int_vector {
 	unsigned long tx_rings_map;
 	int count_tx_rings;
 	u32 rx_ictt;
-	struct napi_struct napi;
+	u16 comp_cnt;
+	bool rx_dim_en, rx_napi_work;
+	struct napi_struct napi ____cacheline_aligned_in_smp;
+	struct dim rx_dim ____cacheline_aligned_in_smp;
 	char name[ENETC_INT_NAME_MAX];
 
 	struct enetc_bdr rx_ring;
 	struct enetc_bdr tx_ring[];
-};
+} ____cacheline_aligned_in_smp;
 
 struct enetc_cls_rule {
 	struct ethtool_rx_flow_spec fs;
@@ -230,10 +234,13 @@ enum enetc_ic_mode {
 	/* activated when int coalescing time is set to a non-0 value */
 	ENETC_IC_RX_MANUAL = BIT(0),
 	ENETC_IC_TX_MANUAL = BIT(1),
+	/* use dynamic interrupt moderation */
+	ENETC_IC_RX_ADAPTIVE = BIT(2),
 };
 
 #define ENETC_RXIC_PKTTHR	min_t(u32, 256, ENETC_RX_RING_DEFAULT_SIZE / 2)
 #define ENETC_TXIC_PKTTHR	min_t(u32, 128, ENETC_TX_RING_DEFAULT_SIZE / 2)
+#define ENETC_TXIC_TIMETHR	enetc_usecs_to_cycles(600)
 
 struct enetc_ndev_priv {
 	struct net_device *ndev;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 521f3b4cd250..1dab83fbca77 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -575,6 +575,8 @@ static int enetc_get_coalesce(struct net_device *ndev,
 	ic->tx_max_coalesced_frames = ENETC_TXIC_PKTTHR;
 	ic->rx_max_coalesced_frames = ENETC_RXIC_PKTTHR;
 
+	ic->use_adaptive_rx_coalesce = priv->ic_mode & ENETC_IC_RX_ADAPTIVE;
+
 	return 0;
 }
 
@@ -596,11 +598,17 @@ static int enetc_set_coalesce(struct net_device *ndev,
 		return -EOPNOTSUPP;
 
 	ic_mode = ENETC_IC_NONE;
+	if (ic->use_adaptive_rx_coalesce) {
+		ic_mode |= ENETC_IC_RX_ADAPTIVE;
+		rx_ictt = 0x1;
+	} else {
+		ic_mode |= rx_ictt ? ENETC_IC_RX_MANUAL : 0;
+	}
+
 	ic_mode |= tx_ictt ? ENETC_IC_TX_MANUAL : 0;
-	ic_mode |= rx_ictt ? ENETC_IC_RX_MANUAL : 0;
 
 	/* commit the settings */
-	changed = (ic_mode != priv->ic_mode);
+	changed = (ic_mode != priv->ic_mode) || (priv->tx_ictt != tx_ictt);
 
 	priv->ic_mode = ic_mode;
 	priv->tx_ictt = tx_ictt;
@@ -609,6 +617,7 @@ static int enetc_set_coalesce(struct net_device *ndev,
 		struct enetc_int_vector *v = priv->int_vector[i];
 
 		v->rx_ictt = rx_ictt;
+		v->rx_dim_en = !!(ic_mode & ENETC_IC_RX_ADAPTIVE);
 	}
 
 	if (netif_running(ndev) && changed) {
@@ -679,7 +688,8 @@ static int enetc_set_wol(struct net_device *dev,
 
 static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-				     ETHTOOL_COALESCE_MAX_FRAMES,
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_regs_len = enetc_get_reglen,
 	.get_regs = enetc_get_regs,
 	.get_sset_count = enetc_get_sset_count,
@@ -704,7 +714,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-				     ETHTOOL_COALESCE_MAX_FRAMES,
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_regs_len = enetc_get_reglen,
 	.get_regs = enetc_get_regs,
 	.get_sset_count = enetc_get_sset_count,
-- 
2.17.1

