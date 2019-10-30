Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E320E9549
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfJ3D3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:29:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:2946 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfJ3D3P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 23:29:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 20:29:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="205673650"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2019 20:29:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 5/9] ice: Add support for AF_XDP
Date:   Tue, 29 Oct 2019 20:29:06 -0700
Message-Id: <20191030032910.24261-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
References: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>

Add zero copy AF_XDP support.  This patch adds zero copy support for
Tx and Rx; code for zero copy is added to ice_xsk.h and ice_xsk.c.

For Tx, implement ndo_xsk_wakeup. As with other drivers, reuse
existing XDP Tx queues for this task, since XDP_REDIRECT guarantees
mutual exclusion between different NAPI contexts based on CPU ID. In
turn, a netdev can XDP_REDIRECT to another netdev with a different
NAPI context, since the operation is bound to a specific core and each
core has its own hardware ring.

For Rx, allocate frames as MEM_TYPE_ZERO_COPY on queues that AF_XDP is
enabled.

Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
Co-developed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile      |    1 +
 drivers/net/ethernet/intel/ice/ice.h         |   26 +
 drivers/net/ethernet/intel/ice/ice_base.c    |   53 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |    7 +
 drivers/net/ethernet/intel/ice/ice_lib.c     |   57 +-
 drivers/net/ethernet/intel/ice/ice_lib.h     |    4 +
 drivers/net/ethernet/intel/ice/ice_main.c    |   13 +
 drivers/net/ethernet/intel/ice/ice_txrx.c    |   46 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h    |   20 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c     | 1181 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_xsk.h     |   72 ++
 11 files changed, 1453 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_xsk.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_xsk.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 9a7d6c02bcc6..df5a9699276a 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -21,3 +21,4 @@ ice-y := ice_main.o	\
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_lib.o
+ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 19edc66e3497..a0eff20ba91f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -35,6 +35,7 @@
 #include <linux/bpf.h>
 #include <linux/avf/virtchnl.h>
 #include <net/ipv6.h>
+#include <net/xdp_sock.h>
 #include "ice_devids.h"
 #include "ice_type.h"
 #include "ice_txrx.h"
@@ -44,6 +45,7 @@
 #include "ice_sched.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
+#include "ice_xsk.h"
 
 extern const char ice_drv_ver[];
 #define ICE_BAR0		0
@@ -287,6 +289,9 @@ struct ice_vsi {
 	struct ice_ring **xdp_rings;	/* XDP ring array */
 	u16 num_xdp_txq;		/* Used XDP queues */
 	u8 xdp_mapping_mode;		/* ICE_MAP_MODE_[CONTIG|SCATTER] */
+	struct xdp_umem **xsk_umems;
+	u16 num_xsk_umems_used;
+	u16 num_xsk_umems;
 } ____cacheline_internodealigned_in_smp;
 
 /* struct that defines an interrupt vector */
@@ -440,6 +445,27 @@ static inline void ice_set_ring_xdp(struct ice_ring *ring)
 	ring->flags |= ICE_TX_FLAGS_RING_XDP;
 }
 
+/**
+ * ice_xsk_umem - get XDP UMEM bound to a ring
+ * @ring - ring to use
+ *
+ * Returns a pointer to xdp_umem structure if there is an UMEM present,
+ * NULL otherwise.
+ */
+static inline struct xdp_umem *ice_xsk_umem(struct ice_ring *ring)
+{
+	struct xdp_umem **umems = ring->vsi->xsk_umems;
+	int qid = ring->q_index;
+
+	if (ice_ring_is_xdp(ring))
+		qid -= ring->vsi->num_xdp_txq;
+
+	if (!umems || !umems[qid] || !ice_is_xdp_ena_vsi(ring->vsi))
+		return NULL;
+
+	return umems[qid];
+}
+
 /**
  * ice_get_main_vsi - Get the PF VSI
  * @pf: PF instance
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 8721934fb4ea..2904de054c10 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -276,14 +276,17 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
  */
 int ice_setup_rx_ctx(struct ice_ring *ring)
 {
+	int chain_len = ICE_MAX_CHAINED_RX_BUFS;
 	struct ice_vsi *vsi = ring->vsi;
-	struct ice_hw *hw = &vsi->back->hw;
 	u32 rxdid = ICE_RXDID_FLEX_NIC;
 	struct ice_rlan_ctx rlan_ctx;
+	struct ice_hw *hw;
 	u32 regval;
 	u16 pf_q;
 	int err;
 
+	hw = &vsi->back->hw;
+
 	/* what is Rx queue number in global space of 2K Rx queues */
 	pf_q = vsi->rxq_map[ring->q_index];
 
@@ -297,10 +300,38 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 			xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 					 ring->q_index);
 
-		err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
-						 MEM_TYPE_PAGE_SHARED, NULL);
-		if (err)
-			return err;
+		ring->xsk_umem = ice_xsk_umem(ring);
+		if (ring->xsk_umem) {
+			xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
+
+			ring->rx_buf_len = ring->xsk_umem->chunk_size_nohr -
+					   XDP_PACKET_HEADROOM;
+			/* For AF_XDP ZC, we disallow packets to span on
+			 * multiple buffers, thus letting us skip that
+			 * handling in the fast-path.
+			 */
+			chain_len = 1;
+			ring->zca.free = ice_zca_free;
+			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+							 MEM_TYPE_ZERO_COPY,
+							 &ring->zca);
+			if (err)
+				return err;
+
+			dev_info(&vsi->back->pdev->dev, "Registered XDP mem model MEM_TYPE_ZERO_COPY on Rx ring %d\n",
+				 ring->q_index);
+		} else {
+			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
+				xdp_rxq_info_reg(&ring->xdp_rxq,
+						 ring->netdev,
+						 ring->q_index);
+
+			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+							 MEM_TYPE_PAGE_SHARED,
+							 NULL);
+			if (err)
+				return err;
+		}
 	}
 	/* Receive Queue Base Address.
 	 * Indicates the starting address of the descriptor queue defined in
@@ -340,7 +371,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	 * than 5 x DBUF
 	 */
 	rlan_ctx.rxmax = min_t(u16, vsi->max_frame,
-			       ICE_MAX_CHAINED_RX_BUFS * vsi->rx_buf_len);
+			       chain_len * ring->rx_buf_len);
 
 	/* Rx queue threshold in units of 64 */
 	rlan_ctx.lrxqthresh = 1;
@@ -378,7 +409,15 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* init queue specific tail register */
 	ring->tail = hw->hw_addr + QRX_TAIL(pf_q);
 	writel(0, ring->tail);
-	ice_alloc_rx_bufs(ring, ICE_DESC_UNUSED(ring));
+
+	err = ring->xsk_umem ?
+	      ice_alloc_rx_bufs_slow_zc(ring, ICE_DESC_UNUSED(ring)) :
+	      ice_alloc_rx_bufs(ring, ICE_DESC_UNUSED(ring));
+	if (err)
+		dev_info(&vsi->back->pdev->dev,
+			 "Failed allocate some buffers on %sRx ring %d (pf_q %d)\n",
+			 ring->xsk_umem ? "UMEM enabled " : "",
+			 ring->q_index, pf_q);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 6cee99b5865b..42b032620f66 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2612,6 +2612,13 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 		return 0;
 	}
 
+	/* If there is a AF_XDP UMEM attached to any of Rx rings,
+	 * disallow changing the number of descriptors -- regardless
+	 * if the netdev is running or not.
+	 */
+	if (ice_xsk_any_rx_ring_ena(vsi))
+		return -EBUSY;
+
 	while (test_and_set_bit(__ICE_CFG_BUSY, pf->state)) {
 		timeout--;
 		if (!timeout)
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 93831376f721..5fa92801b5a3 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1283,7 +1283,17 @@ int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi)
  */
 int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
 {
-	return ice_vsi_cfg_txqs(vsi, vsi->xdp_rings);
+	int ret;
+	int i;
+
+	ret = ice_vsi_cfg_txqs(vsi, vsi->xdp_rings);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < vsi->num_xdp_txq; i++)
+		vsi->xdp_rings[i]->xsk_umem = ice_xsk_umem(vsi->xdp_rings[i]);
+
+	return ret;
 }
 
 /**
@@ -2515,6 +2525,51 @@ char *ice_nvm_version_str(struct ice_hw *hw)
 	return buf;
 }
 
+/**
+ * ice_update_ring_stats - Update ring statistics
+ * @ring: ring to update
+ * @cont: used to increment per-vector counters
+ * @pkts: number of processed packets
+ * @bytes: number of processed bytes
+ *
+ * This function assumes that caller has acquired a u64_stats_sync lock.
+ */
+static void
+ice_update_ring_stats(struct ice_ring *ring, struct ice_ring_container *cont,
+		      u64 pkts, u64 bytes)
+{
+	ring->stats.bytes += bytes;
+	ring->stats.pkts += pkts;
+	cont->total_bytes += bytes;
+	cont->total_pkts += pkts;
+}
+
+/**
+ * ice_update_tx_ring_stats - Update Tx ring specific counters
+ * @tx_ring: ring to update
+ * @pkts: number of processed packets
+ * @bytes: number of processed bytes
+ */
+void ice_update_tx_ring_stats(struct ice_ring *tx_ring, u64 pkts, u64 bytes)
+{
+	u64_stats_update_begin(&tx_ring->syncp);
+	ice_update_ring_stats(tx_ring, &tx_ring->q_vector->tx, pkts, bytes);
+	u64_stats_update_end(&tx_ring->syncp);
+}
+
+/**
+ * ice_update_rx_ring_stats - Update Rx ring specific counters
+ * @rx_ring: ring to update
+ * @pkts: number of processed packets
+ * @bytes: number of processed bytes
+ */
+void ice_update_rx_ring_stats(struct ice_ring *rx_ring, u64 pkts, u64 bytes)
+{
+	u64_stats_update_begin(&rx_ring->syncp);
+	ice_update_ring_stats(rx_ring, &rx_ring->q_vector->rx, pkts, bytes);
+	u64_stats_update_end(&rx_ring->syncp);
+}
+
 /**
  * ice_vsi_cfg_mac_fltr - Add or remove a MAC address filter for a VSI
  * @vsi: the VSI being configured MAC filter
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 8e92c37a0f21..8d5a7978e066 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -83,6 +83,10 @@ void ice_vsi_free_tx_rings(struct ice_vsi *vsi);
 
 int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
 
+void ice_update_tx_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes);
+
+void ice_update_rx_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes);
+
 void ice_vsi_cfg_frame_size(struct ice_vsi *vsi);
 
 u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6f69a44ac1cf..98022ed9aaf4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1692,6 +1692,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		if (ice_setup_tx_ring(xdp_ring))
 			goto free_xdp_rings;
 		ice_set_ring_xdp(xdp_ring);
+		xdp_ring->xsk_umem = ice_xsk_umem(xdp_ring);
 	}
 
 	return 0;
@@ -1925,6 +1926,14 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	if (if_running)
 		ret = ice_up(vsi);
 
+	if (!ret && prog && vsi->xsk_umems)
+		ice_for_each_rxq(vsi, i) {
+			struct ice_ring *rx_ring = vsi->rx_rings[i];
+
+			if (rx_ring->xsk_umem)
+				napi_schedule(&rx_ring->q_vector->napi);
+		}
+
 skip_setting_prog:
 	return ret;
 }
@@ -1951,6 +1960,9 @@ static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_QUERY_PROG:
 		xdp->prog_id = vsi->xdp_prog ? vsi->xdp_prog->aux->id : 0;
 		return 0;
+	case XDP_SETUP_XSK_UMEM:
+		return ice_xsk_umem_setup(vsi, xdp->xsk.umem,
+					  xdp->xsk.queue_id);
 	default:
 		NL_SET_ERR_MSG_MOD(xdp->extack, "Unknown XDP command");
 		return -EINVAL;
@@ -5198,4 +5210,5 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_tx_timeout = ice_tx_timeout,
 	.ndo_bpf = ice_xdp,
 	.ndo_xdp_xmit = ice_xdp_xmit,
+	.ndo_xsk_wakeup = ice_xsk_wakeup,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index f8a9eafc945a..acf834a7130a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -11,6 +11,7 @@
 #include "ice_lib.h"
 #include "ice.h"
 #include "ice_dcb_lib.h"
+#include "ice_xsk.h"
 
 #define ICE_RX_HDR_SIZE		256
 
@@ -58,6 +59,11 @@ void ice_clean_tx_ring(struct ice_ring *tx_ring)
 {
 	u16 i;
 
+	if (ice_ring_is_xdp(tx_ring) && tx_ring->xsk_umem) {
+		ice_xsk_clean_xdp_ring(tx_ring);
+		goto tx_skip_free;
+	}
+
 	/* ring already cleared, nothing to do */
 	if (!tx_ring->tx_buf)
 		return;
@@ -66,6 +72,7 @@ void ice_clean_tx_ring(struct ice_ring *tx_ring)
 	for (i = 0; i < tx_ring->count; i++)
 		ice_unmap_and_free_tx_buf(tx_ring, &tx_ring->tx_buf[i]);
 
+tx_skip_free:
 	memset(tx_ring->tx_buf, 0, sizeof(*tx_ring->tx_buf) * tx_ring->count);
 
 	/* Zero out the descriptor ring */
@@ -198,12 +205,8 @@ static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
 
 	i += tx_ring->count;
 	tx_ring->next_to_clean = i;
-	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->stats.bytes += total_bytes;
-	tx_ring->stats.pkts += total_pkts;
-	u64_stats_update_end(&tx_ring->syncp);
-	tx_ring->q_vector->tx.total_bytes += total_bytes;
-	tx_ring->q_vector->tx.total_pkts += total_pkts;
+
+	ice_update_tx_ring_stats(tx_ring, total_pkts, total_bytes);
 
 	if (ice_ring_is_xdp(tx_ring))
 		return !!budget;
@@ -286,6 +289,11 @@ void ice_clean_rx_ring(struct ice_ring *rx_ring)
 	if (!rx_ring->rx_buf)
 		return;
 
+	if (rx_ring->xsk_umem) {
+		ice_xsk_clean_rx_ring(rx_ring);
+		goto rx_skip_free;
+	}
+
 	/* Free all the Rx ring sk_buffs */
 	for (i = 0; i < rx_ring->count; i++) {
 		struct ice_rx_buf *rx_buf = &rx_ring->rx_buf[i];
@@ -313,6 +321,7 @@ void ice_clean_rx_ring(struct ice_ring *rx_ring)
 		rx_buf->page_offset = 0;
 	}
 
+rx_skip_free:
 	memset(rx_ring->rx_buf, 0, sizeof(*rx_ring->rx_buf) * rx_ring->count);
 
 	/* Zero out the descriptor ring */
@@ -1073,13 +1082,7 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 	if (xdp_prog)
 		ice_finalize_xdp_rx(rx_ring, xdp_xmit);
 
-	/* update queue and vector specific stats */
-	u64_stats_update_begin(&rx_ring->syncp);
-	rx_ring->stats.pkts += total_rx_pkts;
-	rx_ring->stats.bytes += total_rx_bytes;
-	u64_stats_update_end(&rx_ring->syncp);
-	rx_ring->q_vector->rx.total_pkts += total_rx_pkts;
-	rx_ring->q_vector->rx.total_bytes += total_rx_bytes;
+	ice_update_rx_ring_stats(rx_ring, total_rx_pkts, total_rx_bytes);
 
 	/* guarantee a trip back through this routine if there was a failure */
 	return failure ? budget : (int)total_rx_pkts;
@@ -1457,9 +1460,14 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	/* Since the actual Tx work is minimal, we can give the Tx a larger
 	 * budget and be more aggressive about cleaning up the Tx descriptors.
 	 */
-	ice_for_each_ring(ring, q_vector->tx)
-		if (!ice_clean_tx_irq(ring, budget))
+	ice_for_each_ring(ring, q_vector->tx) {
+		bool wd = ring->xsk_umem ?
+			  ice_clean_tx_irq_zc(ring, budget) :
+			  ice_clean_tx_irq(ring, budget);
+
+		if (!wd)
 			clean_complete = false;
+	}
 
 	/* Handle case where we are called by netpoll with a budget of 0 */
 	if (unlikely(budget <= 0))
@@ -1479,7 +1487,13 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	ice_for_each_ring(ring, q_vector->rx) {
 		int cleaned;
 
-		cleaned = ice_clean_rx_irq(ring, budget_per_ring);
+		/* A dedicated path for zero-copy allows making a single
+		 * comparison in the irq context instead of many inside the
+		 * ice_clean_rx_irq function and makes the codebase cleaner.
+		 */
+		cleaned = ring->xsk_umem ?
+			  ice_clean_rx_irq_zc(ring, budget_per_ring) :
+			  ice_clean_rx_irq(ring, budget_per_ring);
 		work_done += cleaned;
 		/* if we clean as many as budgeted, we must not be done */
 		if (cleaned >= budget_per_ring)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index a07101b13226..d5d243b8e69f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -4,6 +4,8 @@
 #ifndef _ICE_TXRX_H_
 #define _ICE_TXRX_H_
 
+#include "ice_type.h"
+
 #define ICE_DFLT_IRQ_WORK	256
 #define ICE_RXBUF_2048		2048
 #define ICE_MAX_CHAINED_RX_BUFS	5
@@ -88,9 +90,17 @@ struct ice_tx_offload_params {
 struct ice_rx_buf {
 	struct sk_buff *skb;
 	dma_addr_t dma;
-	struct page *page;
-	unsigned int page_offset;
-	u16 pagecnt_bias;
+	union {
+		struct {
+			struct page *page;
+			unsigned int page_offset;
+			u16 pagecnt_bias;
+		};
+		struct {
+			void *addr;
+			u64 handle;
+		};
+	};
 };
 
 struct ice_q_stats {
@@ -211,6 +221,8 @@ struct ice_ring {
 
 	struct rcu_head rcu;		/* to avoid race on free */
 	struct bpf_prog *xdp_prog;
+	struct xdp_umem *xsk_umem;
+	struct zero_copy_allocator zca;
 	/* CL3 - 3rd cacheline starts here */
 	struct xdp_rxq_info xdp_rxq;
 	/* CLX - the below items are only accessed infrequently and should be
@@ -250,6 +262,8 @@ struct ice_ring_container {
 #define ice_for_each_ring(pos, head) \
 	for (pos = (head).ring; pos; pos = pos->next)
 
+union ice_32b_rx_flex_desc;
+
 bool ice_alloc_rx_bufs(struct ice_ring *rxr, u16 cleaned_count);
 netdev_tx_t ice_start_xmit(struct sk_buff *skb, struct net_device *netdev);
 void ice_clean_tx_ring(struct ice_ring *tx_ring);
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
new file mode 100644
index 000000000000..baf8a1c21f71
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -0,0 +1,1181 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include <linux/bpf_trace.h>
+#include <net/xdp_sock.h>
+#include <net/xdp.h>
+#include "ice.h"
+#include "ice_base.h"
+#include "ice_type.h"
+#include "ice_xsk.h"
+#include "ice_txrx.h"
+#include "ice_txrx_lib.h"
+#include "ice_lib.h"
+
+/**
+ * ice_qp_reset_stats - Resets all stats for rings of given index
+ * @vsi: VSI that contains rings of interest
+ * @q_idx: ring index in array
+ */
+static void ice_qp_reset_stats(struct ice_vsi *vsi, u16 q_idx)
+{
+	memset(&vsi->rx_rings[q_idx]->rx_stats, 0,
+	       sizeof(vsi->rx_rings[q_idx]->rx_stats));
+	memset(&vsi->tx_rings[q_idx]->stats, 0,
+	       sizeof(vsi->tx_rings[q_idx]->stats));
+	if (ice_is_xdp_ena_vsi(vsi))
+		memset(&vsi->xdp_rings[q_idx]->stats, 0,
+		       sizeof(vsi->xdp_rings[q_idx]->stats));
+}
+
+/**
+ * ice_qp_clean_rings - Cleans all the rings of a given index
+ * @vsi: VSI that contains rings of interest
+ * @q_idx: ring index in array
+ */
+static void ice_qp_clean_rings(struct ice_vsi *vsi, u16 q_idx)
+{
+	ice_clean_tx_ring(vsi->tx_rings[q_idx]);
+	if (ice_is_xdp_ena_vsi(vsi))
+		ice_clean_tx_ring(vsi->xdp_rings[q_idx]);
+	ice_clean_rx_ring(vsi->rx_rings[q_idx]);
+}
+
+/**
+ * ice_qvec_toggle_napi - Enables/disables NAPI for a given q_vector
+ * @vsi: VSI that has netdev
+ * @q_vector: q_vector that has NAPI context
+ * @enable: true for enable, false for disable
+ */
+static void
+ice_qvec_toggle_napi(struct ice_vsi *vsi, struct ice_q_vector *q_vector,
+		     bool enable)
+{
+	if (!vsi->netdev || !q_vector)
+		return;
+
+	if (enable)
+		napi_enable(&q_vector->napi);
+	else
+		napi_disable(&q_vector->napi);
+}
+
+/**
+ * ice_qvec_dis_irq - Mask off queue interrupt generation on given ring
+ * @vsi: the VSI that contains queue vector being un-configured
+ * @rx_ring: Rx ring that will have its IRQ disabled
+ * @q_vector: queue vector
+ */
+static void
+ice_qvec_dis_irq(struct ice_vsi *vsi, struct ice_ring *rx_ring,
+		 struct ice_q_vector *q_vector)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	int base = vsi->base_vector;
+	u16 reg;
+	u32 val;
+
+	/* QINT_TQCTL is being cleared in ice_vsi_stop_tx_ring, so handle
+	 * here only QINT_RQCTL
+	 */
+	reg = rx_ring->reg_idx;
+	val = rd32(hw, QINT_RQCTL(reg));
+	val &= ~QINT_RQCTL_CAUSE_ENA_M;
+	wr32(hw, QINT_RQCTL(reg), val);
+
+	if (q_vector) {
+		u16 v_idx = q_vector->v_idx;
+
+		wr32(hw, GLINT_DYN_CTL(q_vector->reg_idx), 0);
+		ice_flush(hw);
+		synchronize_irq(pf->msix_entries[v_idx + base].vector);
+	}
+}
+
+/**
+ * ice_qvec_cfg_msix - Enable IRQ for given queue vector
+ * @vsi: the VSI that contains queue vector
+ * @q_vector: queue vector
+ */
+static void
+ice_qvec_cfg_msix(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
+{
+	u16 reg_idx = q_vector->reg_idx;
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	struct ice_ring *ring;
+
+	ice_cfg_itr(hw, q_vector);
+
+	wr32(hw, GLINT_RATE(reg_idx),
+	     ice_intrl_usec_to_reg(q_vector->intrl, hw->intrl_gran));
+
+	ice_for_each_ring(ring, q_vector->tx)
+		ice_cfg_txq_interrupt(vsi, ring->reg_idx, reg_idx,
+				      q_vector->tx.itr_idx);
+
+	ice_for_each_ring(ring, q_vector->rx)
+		ice_cfg_rxq_interrupt(vsi, ring->reg_idx, reg_idx,
+				      q_vector->rx.itr_idx);
+
+	ice_flush(hw);
+}
+
+/**
+ * ice_qvec_ena_irq - Enable IRQ for given queue vector
+ * @vsi: the VSI that contains queue vector
+ * @q_vector: queue vector
+ */
+static void ice_qvec_ena_irq(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+
+	ice_irq_dynamic_ena(hw, vsi, q_vector);
+
+	ice_flush(hw);
+}
+
+/**
+ * ice_qp_dis - Disables a queue pair
+ * @vsi: VSI of interest
+ * @q_idx: ring index in array
+ *
+ * Returns 0 on success, negative on failure.
+ */
+static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
+{
+	struct ice_txq_meta txq_meta = { };
+	struct ice_ring *tx_ring, *rx_ring;
+	struct ice_q_vector *q_vector;
+	int timeout = 50;
+	int err;
+
+	if (q_idx >= vsi->num_rxq || q_idx >= vsi->num_txq)
+		return -EINVAL;
+
+	tx_ring = vsi->tx_rings[q_idx];
+	rx_ring = vsi->rx_rings[q_idx];
+	q_vector = rx_ring->q_vector;
+
+	while (test_and_set_bit(__ICE_CFG_BUSY, vsi->state)) {
+		timeout--;
+		if (!timeout)
+			return -EBUSY;
+		usleep_range(1000, 2000);
+	}
+	netif_tx_stop_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
+
+	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
+
+	ice_fill_txq_meta(vsi, tx_ring, &txq_meta);
+	err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, 0, tx_ring, &txq_meta);
+	if (err)
+		return err;
+	if (ice_is_xdp_ena_vsi(vsi)) {
+		struct ice_ring *xdp_ring = vsi->xdp_rings[q_idx];
+
+		memset(&txq_meta, 0, sizeof(txq_meta));
+		ice_fill_txq_meta(vsi, xdp_ring, &txq_meta);
+		err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, 0, xdp_ring,
+					   &txq_meta);
+		if (err)
+			return err;
+	}
+	err = ice_vsi_ctrl_rx_ring(vsi, false, q_idx);
+	if (err)
+		return err;
+
+	ice_qvec_toggle_napi(vsi, q_vector, false);
+	ice_qp_clean_rings(vsi, q_idx);
+	ice_qp_reset_stats(vsi, q_idx);
+
+	return 0;
+}
+
+/**
+ * ice_qp_ena - Enables a queue pair
+ * @vsi: VSI of interest
+ * @q_idx: ring index in array
+ *
+ * Returns 0 on success, negative on failure.
+ */
+static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
+{
+	struct ice_aqc_add_tx_qgrp *qg_buf;
+	struct ice_ring *tx_ring, *rx_ring;
+	struct ice_q_vector *q_vector;
+	int err;
+
+	if (q_idx >= vsi->num_rxq || q_idx >= vsi->num_txq)
+		return -EINVAL;
+
+	qg_buf = kzalloc(sizeof(*qg_buf), GFP_KERNEL);
+	if (!qg_buf)
+		return -ENOMEM;
+
+	qg_buf->num_txqs = 1;
+
+	tx_ring = vsi->tx_rings[q_idx];
+	rx_ring = vsi->rx_rings[q_idx];
+	q_vector = rx_ring->q_vector;
+
+	err = ice_vsi_cfg_txq(vsi, tx_ring, qg_buf);
+	if (err)
+		goto free_buf;
+
+	if (ice_is_xdp_ena_vsi(vsi)) {
+		struct ice_ring *xdp_ring = vsi->xdp_rings[q_idx];
+
+		memset(qg_buf, 0, sizeof(*qg_buf));
+		qg_buf->num_txqs = 1;
+		err = ice_vsi_cfg_txq(vsi, xdp_ring, qg_buf);
+		if (err)
+			goto free_buf;
+		ice_set_ring_xdp(xdp_ring);
+		xdp_ring->xsk_umem = ice_xsk_umem(xdp_ring);
+	}
+
+	err = ice_setup_rx_ctx(rx_ring);
+	if (err)
+		goto free_buf;
+
+	ice_qvec_cfg_msix(vsi, q_vector);
+
+	err = ice_vsi_ctrl_rx_ring(vsi, true, q_idx);
+	if (err)
+		goto free_buf;
+
+	clear_bit(__ICE_CFG_BUSY, vsi->state);
+	ice_qvec_toggle_napi(vsi, q_vector, true);
+	ice_qvec_ena_irq(vsi, q_vector);
+
+	netif_tx_start_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
+free_buf:
+	kfree(qg_buf);
+	return err;
+}
+
+/**
+ * ice_xsk_alloc_umems - allocate a UMEM region for an XDP socket
+ * @vsi: VSI to allocate the UMEM on
+ *
+ * Returns 0 on success, negative on error
+ */
+static int ice_xsk_alloc_umems(struct ice_vsi *vsi)
+{
+	if (vsi->xsk_umems)
+		return 0;
+
+	vsi->xsk_umems = kcalloc(vsi->num_xsk_umems, sizeof(*vsi->xsk_umems),
+				 GFP_KERNEL);
+
+	if (!vsi->xsk_umems) {
+		vsi->num_xsk_umems = 0;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_xsk_add_umem - add a UMEM region for XDP sockets
+ * @vsi: VSI to which the UMEM will be added
+ * @umem: pointer to a requested UMEM region
+ * @qid: queue ID
+ *
+ * Returns 0 on success, negative on error
+ */
+static int ice_xsk_add_umem(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
+{
+	int err;
+
+	err = ice_xsk_alloc_umems(vsi);
+	if (err)
+		return err;
+
+	vsi->xsk_umems[qid] = umem;
+	vsi->num_xsk_umems_used++;
+
+	return 0;
+}
+
+/**
+ * ice_xsk_remove_umem - Remove an UMEM for a certain ring/qid
+ * @vsi: VSI from which the VSI will be removed
+ * @qid: Ring/qid associated with the UMEM
+ */
+static void ice_xsk_remove_umem(struct ice_vsi *vsi, u16 qid)
+{
+	vsi->xsk_umems[qid] = NULL;
+	vsi->num_xsk_umems_used--;
+
+	if (vsi->num_xsk_umems_used == 0) {
+		kfree(vsi->xsk_umems);
+		vsi->xsk_umems = NULL;
+		vsi->num_xsk_umems = 0;
+	}
+}
+
+/**
+ * ice_xsk_umem_dma_map - DMA map UMEM region for XDP sockets
+ * @vsi: VSI to map the UMEM region
+ * @umem: UMEM to map
+ *
+ * Returns 0 on success, negative on error
+ */
+static int ice_xsk_umem_dma_map(struct ice_vsi *vsi, struct xdp_umem *umem)
+{
+	struct ice_pf *pf = vsi->back;
+	struct device *dev;
+	unsigned int i;
+
+	dev = &pf->pdev->dev;
+	for (i = 0; i < umem->npgs; i++) {
+		dma_addr_t dma = dma_map_page_attrs(dev, umem->pgs[i], 0,
+						    PAGE_SIZE,
+						    DMA_BIDIRECTIONAL,
+						    ICE_RX_DMA_ATTR);
+		if (dma_mapping_error(dev, dma)) {
+			dev_dbg(dev,
+				"XSK UMEM DMA mapping error on page num %d", i);
+			goto out_unmap;
+		}
+
+		umem->pages[i].dma = dma;
+	}
+
+	return 0;
+
+out_unmap:
+	for (; i > 0; i--) {
+		dma_unmap_page_attrs(dev, umem->pages[i].dma, PAGE_SIZE,
+				     DMA_BIDIRECTIONAL, ICE_RX_DMA_ATTR);
+		umem->pages[i].dma = 0;
+	}
+
+	return -EFAULT;
+}
+
+/**
+ * ice_xsk_umem_dma_unmap - DMA unmap UMEM region for XDP sockets
+ * @vsi: VSI from which the UMEM will be unmapped
+ * @umem: UMEM to unmap
+ */
+static void ice_xsk_umem_dma_unmap(struct ice_vsi *vsi, struct xdp_umem *umem)
+{
+	struct ice_pf *pf = vsi->back;
+	struct device *dev;
+	unsigned int i;
+
+	dev = &pf->pdev->dev;
+	for (i = 0; i < umem->npgs; i++) {
+		dma_unmap_page_attrs(dev, umem->pages[i].dma, PAGE_SIZE,
+				     DMA_BIDIRECTIONAL, ICE_RX_DMA_ATTR);
+
+		umem->pages[i].dma = 0;
+	}
+}
+
+/**
+ * ice_xsk_umem_disable - disable a UMEM region
+ * @vsi: Current VSI
+ * @qid: queue ID
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int ice_xsk_umem_disable(struct ice_vsi *vsi, u16 qid)
+{
+	if (!vsi->xsk_umems || qid >= vsi->num_xsk_umems ||
+	    !vsi->xsk_umems[qid])
+		return -EINVAL;
+
+	ice_xsk_umem_dma_unmap(vsi, vsi->xsk_umems[qid]);
+	ice_xsk_remove_umem(vsi, qid);
+
+	return 0;
+}
+
+/**
+ * ice_xsk_umem_enable - enable a UMEM region
+ * @vsi: Current VSI
+ * @umem: pointer to a requested UMEM region
+ * @qid: queue ID
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int
+ice_xsk_umem_enable(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
+{
+	struct xdp_umem_fq_reuse *reuseq;
+	int err;
+
+	if (vsi->type != ICE_VSI_PF)
+		return -EINVAL;
+
+	vsi->num_xsk_umems = min_t(u16, vsi->num_rxq, vsi->num_txq);
+	if (qid >= vsi->num_xsk_umems)
+		return -EINVAL;
+
+	if (vsi->xsk_umems && vsi->xsk_umems[qid])
+		return -EBUSY;
+
+	reuseq = xsk_reuseq_prepare(vsi->rx_rings[0]->count);
+	if (!reuseq)
+		return -ENOMEM;
+
+	xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));
+
+	err = ice_xsk_umem_dma_map(vsi, umem);
+	if (err)
+		return err;
+
+	err = ice_xsk_add_umem(vsi, umem, qid);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/**
+ * ice_xsk_umem_setup - enable/disable a UMEM region depending on its state
+ * @vsi: Current VSI
+ * @umem: UMEM to enable/associate to a ring, NULL to disable
+ * @qid: queue ID
+ *
+ * Returns 0 on success, negative on failure
+ */
+int ice_xsk_umem_setup(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
+{
+	bool if_running, umem_present = !!umem;
+	int ret = 0, umem_failure = 0;
+
+	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
+
+	if (if_running) {
+		ret = ice_qp_dis(vsi, qid);
+		if (ret) {
+			netdev_err(vsi->netdev, "ice_qp_dis error = %d", ret);
+			goto xsk_umem_if_up;
+		}
+	}
+
+	umem_failure = umem_present ? ice_xsk_umem_enable(vsi, umem, qid) :
+				      ice_xsk_umem_disable(vsi, qid);
+
+xsk_umem_if_up:
+	if (if_running) {
+		ret = ice_qp_ena(vsi, qid);
+		if (!ret && umem_present)
+			napi_schedule(&vsi->xdp_rings[qid]->q_vector->napi);
+		else if (ret)
+			netdev_err(vsi->netdev, "ice_qp_ena error = %d", ret);
+	}
+
+	if (umem_failure) {
+		netdev_err(vsi->netdev, "Could not %sable UMEM, error = %d",
+			   umem_present ? "en" : "dis", umem_failure);
+		return umem_failure;
+	}
+
+	return ret;
+}
+
+/**
+ * ice_zca_free - Callback for MEM_TYPE_ZERO_COPY allocations
+ * @zca: zero-cpoy allocator
+ * @handle: Buffer handle
+ */
+void ice_zca_free(struct zero_copy_allocator *zca, unsigned long handle)
+{
+	struct ice_rx_buf *rx_buf;
+	struct ice_ring *rx_ring;
+	struct xdp_umem *umem;
+	u64 hr, mask;
+	u16 nta;
+
+	rx_ring = container_of(zca, struct ice_ring, zca);
+	umem = rx_ring->xsk_umem;
+	hr = umem->headroom + XDP_PACKET_HEADROOM;
+
+	mask = umem->chunk_mask;
+
+	nta = rx_ring->next_to_alloc;
+	rx_buf = &rx_ring->rx_buf[nta];
+
+	nta++;
+	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
+
+	handle &= mask;
+
+	rx_buf->dma = xdp_umem_get_dma(umem, handle);
+	rx_buf->dma += hr;
+
+	rx_buf->addr = xdp_umem_get_data(umem, handle);
+	rx_buf->addr += hr;
+
+	rx_buf->handle = (u64)handle + umem->headroom;
+}
+
+/**
+ * ice_alloc_buf_fast_zc - Retrieve buffer address from XDP umem
+ * @rx_ring: ring with an xdp_umem bound to it
+ * @rx_buf: buffer to which xsk page address will be assigned
+ *
+ * This function allocates an Rx buffer in the hot path.
+ * The buffer can come from fill queue or recycle queue.
+ *
+ * Returns true if an assignment was successful, false if not.
+ */
+static __always_inline bool
+ice_alloc_buf_fast_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
+{
+	struct xdp_umem *umem = rx_ring->xsk_umem;
+	void *addr = rx_buf->addr;
+	u64 handle, hr;
+
+	if (addr) {
+		rx_ring->rx_stats.page_reuse_count++;
+		return true;
+	}
+
+	if (!xsk_umem_peek_addr(umem, &handle)) {
+		rx_ring->rx_stats.alloc_page_failed++;
+		return false;
+	}
+
+	hr = umem->headroom + XDP_PACKET_HEADROOM;
+
+	rx_buf->dma = xdp_umem_get_dma(umem, handle);
+	rx_buf->dma += hr;
+
+	rx_buf->addr = xdp_umem_get_data(umem, handle);
+	rx_buf->addr += hr;
+
+	rx_buf->handle = handle + umem->headroom;
+
+	xsk_umem_discard_addr(umem);
+	return true;
+}
+
+/**
+ * ice_alloc_buf_slow_zc - Retrieve buffer address from XDP umem
+ * @rx_ring: ring with an xdp_umem bound to it
+ * @rx_buf: buffer to which xsk page address will be assigned
+ *
+ * This function allocates an Rx buffer in the slow path.
+ * The buffer can come from fill queue or recycle queue.
+ *
+ * Returns true if an assignment was successful, false if not.
+ */
+static __always_inline bool
+ice_alloc_buf_slow_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
+{
+	struct xdp_umem *umem = rx_ring->xsk_umem;
+	u64 handle, headroom;
+
+	if (!xsk_umem_peek_addr_rq(umem, &handle)) {
+		rx_ring->rx_stats.alloc_page_failed++;
+		return false;
+	}
+
+	handle &= umem->chunk_mask;
+	headroom = umem->headroom + XDP_PACKET_HEADROOM;
+
+	rx_buf->dma = xdp_umem_get_dma(umem, handle);
+	rx_buf->dma += headroom;
+
+	rx_buf->addr = xdp_umem_get_data(umem, handle);
+	rx_buf->addr += headroom;
+
+	rx_buf->handle = handle + umem->headroom;
+
+	xsk_umem_discard_addr_rq(umem);
+	return true;
+}
+
+/**
+ * ice_alloc_rx_bufs_zc - allocate a number of Rx buffers
+ * @rx_ring: Rx ring
+ * @count: The number of buffers to allocate
+ * @alloc: the function pointer to call for allocation
+ *
+ * This function allocates a number of Rx buffers from the fill ring
+ * or the internal recycle mechanism and places them on the Rx ring.
+ *
+ * Returns false if all allocations were successful, true if any fail.
+ */
+static bool
+ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, int count,
+		     bool alloc(struct ice_ring *, struct ice_rx_buf *))
+{
+	union ice_32b_rx_flex_desc *rx_desc;
+	u16 ntu = rx_ring->next_to_use;
+	struct ice_rx_buf *rx_buf;
+	bool ret = false;
+
+	if (!count)
+		return false;
+
+	rx_desc = ICE_RX_DESC(rx_ring, ntu);
+	rx_buf = &rx_ring->rx_buf[ntu];
+
+	do {
+		if (!alloc(rx_ring, rx_buf)) {
+			ret = true;
+			break;
+		}
+
+		dma_sync_single_range_for_device(rx_ring->dev, rx_buf->dma, 0,
+						 rx_ring->rx_buf_len,
+						 DMA_BIDIRECTIONAL);
+
+		rx_desc->read.pkt_addr = cpu_to_le64(rx_buf->dma);
+		rx_desc->wb.status_error0 = 0;
+
+		rx_desc++;
+		rx_buf++;
+		ntu++;
+
+		if (unlikely(ntu == rx_ring->count)) {
+			rx_desc = ICE_RX_DESC(rx_ring, 0);
+			rx_buf = rx_ring->rx_buf;
+			ntu = 0;
+		}
+	} while (--count);
+
+	if (rx_ring->next_to_use != ntu)
+		ice_release_rx_desc(rx_ring, ntu);
+
+	return ret;
+}
+
+/**
+ * ice_alloc_rx_bufs_fast_zc - allocate zero copy bufs in the hot path
+ * @rx_ring: Rx ring
+ * @count: number of bufs to allocate
+ *
+ * Returns false on success, true on failure.
+ */
+static bool ice_alloc_rx_bufs_fast_zc(struct ice_ring *rx_ring, u16 count)
+{
+	return ice_alloc_rx_bufs_zc(rx_ring, count,
+				    ice_alloc_buf_fast_zc);
+}
+
+/**
+ * ice_alloc_rx_bufs_slow_zc - allocate zero copy bufs in the slow path
+ * @rx_ring: Rx ring
+ * @count: number of bufs to allocate
+ *
+ * Returns false on success, true on failure.
+ */
+bool ice_alloc_rx_bufs_slow_zc(struct ice_ring *rx_ring, u16 count)
+{
+	return ice_alloc_rx_bufs_zc(rx_ring, count,
+				    ice_alloc_buf_slow_zc);
+}
+
+/**
+ * ice_bump_ntc - Bump the next_to_clean counter of an Rx ring
+ * @rx_ring: Rx ring
+ */
+static void ice_bump_ntc(struct ice_ring *rx_ring)
+{
+	int ntc = rx_ring->next_to_clean + 1;
+
+	ntc = (ntc < rx_ring->count) ? ntc : 0;
+	rx_ring->next_to_clean = ntc;
+	prefetch(ICE_RX_DESC(rx_ring, ntc));
+}
+
+/**
+ * ice_get_rx_buf_zc - Fetch the current Rx buffer
+ * @rx_ring: Rx ring
+ * @size: size of a buffer
+ *
+ * This function returns the current, received Rx buffer and does
+ * DMA synchronization.
+ *
+ * Returns a pointer to the received Rx buffer.
+ */
+static struct ice_rx_buf *ice_get_rx_buf_zc(struct ice_ring *rx_ring, int size)
+{
+	struct ice_rx_buf *rx_buf;
+
+	rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
+
+	dma_sync_single_range_for_cpu(rx_ring->dev, rx_buf->dma, 0,
+				      size, DMA_BIDIRECTIONAL);
+
+	return rx_buf;
+}
+
+/**
+ * ice_reuse_rx_buf_zc - reuse an Rx buffer
+ * @rx_ring: Rx ring
+ * @old_buf: The buffer to recycle
+ *
+ * This function recycles a finished Rx buffer, and places it on the recycle
+ * queue (next_to_alloc).
+ */
+static void
+ice_reuse_rx_buf_zc(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
+{
+	unsigned long mask = (unsigned long)rx_ring->xsk_umem->chunk_mask;
+	u64 hr = rx_ring->xsk_umem->headroom + XDP_PACKET_HEADROOM;
+	u16 nta = rx_ring->next_to_alloc;
+	struct ice_rx_buf *new_buf;
+
+	new_buf = &rx_ring->rx_buf[nta++];
+	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
+
+	new_buf->dma = old_buf->dma & mask;
+	new_buf->dma += hr;
+
+	new_buf->addr = (void *)((unsigned long)old_buf->addr & mask);
+	new_buf->addr += hr;
+
+	new_buf->handle = old_buf->handle & mask;
+	new_buf->handle += rx_ring->xsk_umem->headroom;
+
+	old_buf->addr = NULL;
+}
+
+/**
+ * ice_construct_skb_zc - Create an sk_buff from zero-copy buffer
+ * @rx_ring: Rx ring
+ * @rx_buf: zero-copy Rx buffer
+ * @xdp: XDP buffer
+ *
+ * This function allocates a new skb from a zero-copy Rx buffer.
+ *
+ * Returns the skb on success, NULL on failure.
+ */
+static struct sk_buff *
+ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
+		     struct xdp_buff *xdp)
+{
+	unsigned int metasize = xdp->data - xdp->data_meta;
+	unsigned int datasize = xdp->data_end - xdp->data;
+	unsigned int datasize_hard = xdp->data_end -
+				     xdp->data_hard_start;
+	struct sk_buff *skb;
+
+	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize_hard,
+			       GFP_ATOMIC | __GFP_NOWARN);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
+	ice_reuse_rx_buf_zc(rx_ring, rx_buf);
+
+	return skb;
+}
+
+/**
+ * ice_run_xdp_zc - Executes an XDP program in zero-copy path
+ * @rx_ring: Rx ring
+ * @xdp: xdp_buff used as input to the XDP program
+ *
+ * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
+ */
+static int
+ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
+{
+	int err, result = ICE_XDP_PASS;
+	struct bpf_prog *xdp_prog;
+	struct ice_ring *xdp_ring;
+	u32 act;
+
+	rcu_read_lock();
+	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+	if (!xdp_prog) {
+		rcu_read_unlock();
+		return ICE_XDP_PASS;
+	}
+
+	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	xdp->handle += xdp->data - xdp->data_hard_start;
+	switch (act) {
+	case XDP_PASS:
+		break;
+	case XDP_TX:
+		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];
+		result = ice_xmit_xdp_buff(xdp, xdp_ring);
+		break;
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		/* fallthrough -- not supported action */
+	case XDP_ABORTED:
+		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
+		/* fallthrough -- handle aborts by dropping frame */
+	case XDP_DROP:
+		result = ICE_XDP_CONSUMED;
+		break;
+	}
+
+	rcu_read_unlock();
+	return result;
+}
+
+/**
+ * ice_clean_rx_irq_zc - consumes packets from the hardware ring
+ * @rx_ring: AF_XDP Rx ring
+ * @budget: NAPI budget
+ *
+ * Returns number of processed packets on success, remaining budget on failure.
+ */
+int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
+{
+	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
+	unsigned int xdp_xmit = 0;
+	struct xdp_buff xdp;
+	bool failure = 0;
+
+	xdp.rxq = &rx_ring->xdp_rxq;
+
+	while (likely(total_rx_packets < (unsigned int)budget)) {
+		union ice_32b_rx_flex_desc *rx_desc;
+		unsigned int size, xdp_res = 0;
+		struct ice_rx_buf *rx_buf;
+		struct sk_buff *skb;
+		u16 stat_err_bits;
+		u16 vlan_tag = 0;
+		u8 rx_ptype;
+
+		if (cleaned_count >= ICE_RX_BUF_WRITE) {
+			failure |= ice_alloc_rx_bufs_fast_zc(rx_ring,
+							     cleaned_count);
+			cleaned_count = 0;
+		}
+
+		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
+
+		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S);
+		if (!ice_test_staterr(rx_desc, stat_err_bits))
+			break;
+
+		/* This memory barrier is needed to keep us from reading
+		 * any other fields out of the rx_desc until we have
+		 * verified the descriptor has been written back.
+		 */
+		dma_rmb();
+
+		size = le16_to_cpu(rx_desc->wb.pkt_len) &
+				   ICE_RX_FLX_DESC_PKT_LEN_M;
+		if (!size)
+			break;
+
+		rx_buf = ice_get_rx_buf_zc(rx_ring, size);
+		if (!rx_buf->addr)
+			break;
+
+		xdp.data = rx_buf->addr;
+		xdp.data_meta = xdp.data;
+		xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
+		xdp.data_end = xdp.data + size;
+		xdp.handle = rx_buf->handle;
+
+		xdp_res = ice_run_xdp_zc(rx_ring, &xdp);
+		if (xdp_res) {
+			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
+				xdp_xmit |= xdp_res;
+				rx_buf->addr = NULL;
+			} else {
+				ice_reuse_rx_buf_zc(rx_ring, rx_buf);
+			}
+
+			total_rx_bytes += size;
+			total_rx_packets++;
+			cleaned_count++;
+
+			ice_bump_ntc(rx_ring);
+			continue;
+		}
+
+		/* XDP_PASS path */
+		skb = ice_construct_skb_zc(rx_ring, rx_buf, &xdp);
+		if (!skb) {
+			rx_ring->rx_stats.alloc_buf_failed++;
+			break;
+		}
+
+		cleaned_count++;
+		ice_bump_ntc(rx_ring);
+
+		if (eth_skb_pad(skb)) {
+			skb = NULL;
+			continue;
+		}
+
+		total_rx_bytes += skb->len;
+		total_rx_packets++;
+
+		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_L2TAG1P_S);
+		if (ice_test_staterr(rx_desc, stat_err_bits))
+			vlan_tag = le16_to_cpu(rx_desc->wb.l2tag1);
+
+		rx_ptype = le16_to_cpu(rx_desc->wb.ptype_flex_flags0) &
+				       ICE_RX_FLEX_DESC_PTYPE_M;
+
+		ice_process_skb_fields(rx_ring, rx_desc, skb, rx_ptype);
+		ice_receive_skb(rx_ring, skb, vlan_tag);
+	}
+
+	ice_finalize_xdp_rx(rx_ring, xdp_xmit);
+	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
+
+	return failure ? budget : (int)total_rx_packets;
+}
+
+/**
+ * ice_xmit_zc - Completes AF_XDP entries, and cleans XDP entries
+ * @xdp_ring: XDP Tx ring
+ * @budget: max number of frames to xmit
+ *
+ * Returns true if cleanup/transmission is done.
+ */
+static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
+{
+	struct ice_tx_desc *tx_desc = NULL;
+	bool work_done = true;
+	struct xdp_desc desc;
+	dma_addr_t dma;
+
+	while (likely(budget-- > 0)) {
+		struct ice_tx_buf *tx_buf;
+
+		if (unlikely(!ICE_DESC_UNUSED(xdp_ring))) {
+			xdp_ring->tx_stats.tx_busy++;
+			work_done = false;
+			break;
+		}
+
+		tx_buf = &xdp_ring->tx_buf[xdp_ring->next_to_use];
+
+		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
+			break;
+
+		dma = xdp_umem_get_dma(xdp_ring->xsk_umem, desc.addr);
+
+		dma_sync_single_for_device(xdp_ring->dev, dma, desc.len,
+					   DMA_BIDIRECTIONAL);
+
+		tx_buf->bytecount = desc.len;
+
+		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use);
+		tx_desc->buf_addr = cpu_to_le64(dma);
+		tx_desc->cmd_type_offset_bsz =
+			ice_build_ctob(ICE_TXD_LAST_DESC_CMD, 0, desc.len, 0);
+
+		xdp_ring->next_to_use++;
+		if (xdp_ring->next_to_use == xdp_ring->count)
+			xdp_ring->next_to_use = 0;
+	}
+
+	if (tx_desc) {
+		ice_xdp_ring_update_tail(xdp_ring);
+		xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
+	}
+
+	return budget > 0 && work_done;
+}
+
+/**
+ * ice_clean_xdp_tx_buf - Free and unmap XDP Tx buffer
+ * @xdp_ring: XDP Tx ring
+ * @tx_buf: Tx buffer to clean
+ */
+static void
+ice_clean_xdp_tx_buf(struct ice_ring *xdp_ring, struct ice_tx_buf *tx_buf)
+{
+	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
+	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
+			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
+	dma_unmap_len_set(tx_buf, len, 0);
+}
+
+/**
+ * ice_clean_tx_irq_zc - Completes AF_XDP entries, and cleans XDP entries
+ * @xdp_ring: XDP Tx ring
+ * @budget: NAPI budget
+ *
+ * Returns true if cleanup/tranmission is done.
+ */
+bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget)
+{
+	int total_packets = 0, total_bytes = 0;
+	s16 ntc = xdp_ring->next_to_clean;
+	struct ice_tx_desc *tx_desc;
+	struct ice_tx_buf *tx_buf;
+	bool xmit_done = true;
+	u32 xsk_frames = 0;
+
+	tx_desc = ICE_TX_DESC(xdp_ring, ntc);
+	tx_buf = &xdp_ring->tx_buf[ntc];
+	ntc -= xdp_ring->count;
+
+	do {
+		if (!(tx_desc->cmd_type_offset_bsz &
+		      cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
+			break;
+
+		total_bytes += tx_buf->bytecount;
+		total_packets++;
+
+		if (tx_buf->raw_buf) {
+			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
+			tx_buf->raw_buf = NULL;
+		} else {
+			xsk_frames++;
+		}
+
+		tx_desc->cmd_type_offset_bsz = 0;
+		tx_buf++;
+		tx_desc++;
+		ntc++;
+
+		if (unlikely(!ntc)) {
+			ntc -= xdp_ring->count;
+			tx_buf = xdp_ring->tx_buf;
+			tx_desc = ICE_TX_DESC(xdp_ring, 0);
+		}
+
+		prefetch(tx_desc);
+
+	} while (likely(--budget));
+
+	ntc += xdp_ring->count;
+	xdp_ring->next_to_clean = ntc;
+
+	if (xsk_frames)
+		xsk_umem_complete_tx(xdp_ring->xsk_umem, xsk_frames);
+
+	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
+	xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);
+
+	return budget > 0 && xmit_done;
+}
+
+/**
+ * ice_xsk_wakeup - Implements ndo_xsk_wakeup
+ * @netdev: net_device
+ * @queue_id: queue to wake up
+ * @flags: ignored in our case, since we have Rx and Tx in the same NAPI
+ *
+ * Returns negative on error, zero otherwise.
+ */
+int
+ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
+	       u32 __always_unused flags)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_q_vector *q_vector;
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_ring *ring;
+
+	if (test_bit(__ICE_DOWN, vsi->state))
+		return -ENETDOWN;
+
+	if (!ice_is_xdp_ena_vsi(vsi))
+		return -ENXIO;
+
+	if (queue_id >= vsi->num_txq)
+		return -ENXIO;
+
+	if (!vsi->xdp_rings[queue_id]->xsk_umem)
+		return -ENXIO;
+
+	ring = vsi->xdp_rings[queue_id];
+
+	/* The idea here is that if NAPI is running, mark a miss, so
+	 * it will run again. If not, trigger an interrupt and
+	 * schedule the NAPI from interrupt context. If NAPI would be
+	 * scheduled here, the interrupt affinity would not be
+	 * honored.
+	 */
+	q_vector = ring->q_vector;
+	if (!napi_if_scheduled_mark_missed(&q_vector->napi))
+		ice_trigger_sw_intr(&vsi->back->hw, q_vector);
+
+	return 0;
+}
+
+/**
+ * ice_xsk_any_rx_ring_ena - Checks if Rx rings have AF_XDP UMEM attached
+ * @vsi: VSI to be checked
+ *
+ * Returns true if any of the Rx rings has an AF_XDP UMEM attached
+ */
+bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi)
+{
+	int i;
+
+	if (!vsi->xsk_umems)
+		return false;
+
+	for (i = 0; i < vsi->num_xsk_umems; i++) {
+		if (vsi->xsk_umems[i])
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * ice_xsk_clean_rx_ring - clean UMEM queues connected to a given Rx ring
+ * @rx_ring: ring to be cleaned
+ */
+void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring)
+{
+	u16 i;
+
+	for (i = 0; i < rx_ring->count; i++) {
+		struct ice_rx_buf *rx_buf = &rx_ring->rx_buf[i];
+
+		if (!rx_buf->addr)
+			continue;
+
+		xsk_umem_fq_reuse(rx_ring->xsk_umem, rx_buf->handle);
+		rx_buf->addr = NULL;
+	}
+}
+
+/**
+ * ice_xsk_clean_xdp_ring - Clean the XDP Tx ring and its UMEM queues
+ * @xdp_ring: XDP_Tx ring
+ */
+void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring)
+{
+	u16 ntc = xdp_ring->next_to_clean, ntu = xdp_ring->next_to_use;
+	u32 xsk_frames = 0;
+
+	while (ntc != ntu) {
+		struct ice_tx_buf *tx_buf = &xdp_ring->tx_buf[ntc];
+
+		if (tx_buf->raw_buf)
+			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
+		else
+			xsk_frames++;
+
+		tx_buf->raw_buf = NULL;
+
+		ntc++;
+		if (ntc >= xdp_ring->count)
+			ntc = 0;
+	}
+
+	if (xsk_frames)
+		xsk_umem_complete_tx(xdp_ring->xsk_umem, xsk_frames);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
new file mode 100644
index 000000000000..3479e1de98fe
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_XSK_H_
+#define _ICE_XSK_H_
+#include "ice_txrx.h"
+#include "ice.h"
+
+struct ice_vsi;
+
+#ifdef CONFIG_XDP_SOCKETS
+int ice_xsk_umem_setup(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid);
+void ice_zca_free(struct zero_copy_allocator *zca, unsigned long handle);
+int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget);
+bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget);
+int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
+bool ice_alloc_rx_bufs_slow_zc(struct ice_ring *rx_ring, u16 count);
+bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
+void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring);
+void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring);
+#else
+static inline int
+ice_xsk_umem_setup(struct ice_vsi __always_unused *vsi,
+		   struct xdp_umem __always_unused *umem,
+		   u16 __always_unused qid)
+{
+	return -ENOTSUPP;
+}
+
+static inline void
+ice_zca_free(struct zero_copy_allocator __always_unused *zca,
+	     unsigned long __always_unused handle)
+{
+}
+
+static inline int
+ice_clean_rx_irq_zc(struct ice_ring __always_unused *rx_ring,
+		    int __always_unused budget)
+{
+	return 0;
+}
+
+static inline bool
+ice_clean_tx_irq_zc(struct ice_ring __always_unused *xdp_ring,
+		    int __always_unused budget)
+{
+	return false;
+}
+
+static inline bool
+ice_alloc_rx_bufs_slow_zc(struct ice_ring __always_unused *rx_ring,
+			  u16 __always_unused count)
+{
+	return false;
+}
+
+static inline bool ice_xsk_any_rx_ring_ena(struct ice_vsi __always_unused *vsi)
+{
+	return false;
+}
+
+static inline int
+ice_xsk_wakeup(struct net_device __always_unused *netdev,
+	       u32 __always_unused queue_id, u32 __always_unused flags)
+{
+	return -ENOTSUPP;
+}
+
+#define ice_xsk_clean_rx_ring(rx_ring) do {} while (0)
+#define ice_xsk_clean_xdp_ring(xdp_ring) do {} while (0)
+#endif /* CONFIG_XDP_SOCKETS */
+#endif /* !_ICE_XSK_H_ */
-- 
2.21.0

