Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2973EC347
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 16:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbhHNOY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 10:24:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:45192 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238633AbhHNOYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 10:24:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="279426340"
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="279426340"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2021 07:23:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="447568503"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 14 Aug 2021 07:23:16 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 intel-next 8/9] ice: introduce XDP_TX fallback path
Date:   Sat, 14 Aug 2021 16:08:11 +0200
Message-Id: <20210814140812.46632-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under rare circumstances there might be a situation where a requirement
of having XDP Tx queue per CPU could not be fulfilled and some of the Tx
resources have to be shared between CPUs. This yields a need for placing
accesses to xdp_ring inside a critical section protected by spinlock.
These accesses happen to be in the hot path, so let's introduce the
static branch that will be triggered from the control plane when driver
could not provide Tx queue dedicated for XDP on each CPU.

Currently, the design that has been picked is to allow any number of XDP
Tx queues that is at least half of a count of CPUs that platform has.
For lower number driver will bail out with a response to user that there
were not enough Tx resources that would allow configuring XDP. The
sharing of rings is signalled via static branch enablement which in turn
indicates that lock for xdp_ring accesses needs to be taken in hot path.

Approach based on static branch has no impact on performance of a
non-fallback path. One thing that is needed to be mentioned is a fact
that the static branch will act as a global driver switch, meaning that
if one PF got out of Tx resources, then other PFs that ice driver is
servicing will suffer. However, given the fact that HW that ice driver
is handling has 1024 Tx queues per each PF, this is currently an
unlikely scenario.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  3 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 53 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 16 +++++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  7 ++-
 6 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 191bb8e97aad..2dc8d408aa26 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -158,6 +158,8 @@
 
 #define ice_pf_to_dev(pf) (&((pf)->pdev->dev))
 
+DECLARE_STATIC_KEY_FALSE(ice_xdp_locking_key);
+
 struct ice_txq_meta {
 	u32 q_teid;	/* Tx-scheduler element identifier */
 	u16 q_id;	/* Entry in VSI's txq_map bitmap */
@@ -665,6 +667,7 @@ int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
 int ice_vsi_cfg(struct ice_vsi *vsi);
 struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
+int ice_vsi_determine_xdp_res(struct ice_vsi *vsi);
 int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog);
 int ice_destroy_xdp_rings(struct ice_vsi *vsi);
 int
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 33b60c2ab1b4..8d4363fba95a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3168,7 +3168,9 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 		ice_vsi_map_rings_to_vectors(vsi);
 		if (ice_is_xdp_ena_vsi(vsi)) {
-			vsi->num_xdp_txq = num_possible_cpus();
+			ret = ice_vsi_determine_xdp_res(vsi);
+			if (ret)
+				goto err_vectors;
 			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
 			if (ret)
 				goto err_vectors;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 737b52b51101..aa84f2c988df 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -42,6 +42,8 @@ MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
 #endif /* !CONFIG_DYNAMIC_DEBUG */
 
 static DEFINE_IDA(ice_aux_ida);
+DEFINE_STATIC_KEY_FALSE(ice_xdp_locking_key);
+EXPORT_SYMBOL(ice_xdp_locking_key);
 
 static struct workqueue_struct *ice_wq;
 static const struct net_device_ops ice_netdev_safe_mode_ops;
@@ -2392,14 +2394,19 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 			goto free_xdp_rings;
 		ice_set_ring_xdp(xdp_ring);
 		xdp_ring->xsk_pool = ice_tx_xsk_pool(xdp_ring);
+		spin_lock_init(&xdp_ring->tx_lock);
 		for (j = 0; j < xdp_ring->count; j++) {
 			tx_desc = ICE_TX_DESC(xdp_ring, j);
 			tx_desc->cmd_type_offset_bsz = cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE);
 		}
 	}
 
-	ice_for_each_rxq(vsi, i)
-		vsi->rx_rings[i]->xdp_ring = vsi->xdp_rings[i];
+	ice_for_each_rxq(vsi, i) {
+		if (static_key_enabled(&ice_xdp_locking_key))
+			vsi->rx_rings[i]->xdp_ring = vsi->xdp_rings[i % vsi->num_xdp_txq];
+		else
+			vsi->rx_rings[i]->xdp_ring = vsi->xdp_rings[i];
+	}
 
 	return 0;
 
@@ -2464,6 +2471,10 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 	if (__ice_vsi_get_qs(&xdp_qs_cfg))
 		goto err_map_xdp;
 
+	if (static_key_enabled(&ice_xdp_locking_key))
+		netdev_warn(vsi->netdev,
+			    "Could not allocate one XDP Tx ring per CPU, XDP_TX/XDP_REDIRECT actions will be slower\n");
+
 	if (ice_xdp_alloc_setup_rings(vsi))
 		goto clear_xdp_rings;
 
@@ -2580,6 +2591,9 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 	devm_kfree(ice_pf_to_dev(pf), vsi->xdp_rings);
 	vsi->xdp_rings = NULL;
 
+	if (static_key_enabled(&ice_xdp_locking_key))
+		static_branch_dec(&ice_xdp_locking_key);
+
 	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
 		return 0;
 
@@ -2614,6 +2628,29 @@ static void ice_vsi_rx_napi_schedule(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_vsi_determine_xdp_res - figure out how many Tx qs can XDP have
+ * @vsi: VSI to determine the count of XDP Tx qs
+ *
+ * returns 0 if Tx qs count is higher than at least half of CPU count,
+ * -ENOMEM otherwise
+ */
+int ice_vsi_determine_xdp_res(struct ice_vsi *vsi)
+{
+	u16 avail = ice_get_avail_txq_count(vsi->back);
+	u16 cpus = num_possible_cpus();
+
+	if (avail < cpus / 2)
+		return -ENOMEM;
+
+	vsi->num_xdp_txq = min_t(u16, avail, cpus);
+
+	if (vsi->num_xdp_txq < cpus)
+		static_branch_inc(&ice_xdp_locking_key);
+
+	return 0;
+}
+
 /**
  * ice_xdp_setup_prog - Add or remove XDP eBPF program
  * @vsi: VSI to setup XDP for
@@ -2643,10 +2680,14 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	}
 
 	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
-		vsi->num_xdp_txq = num_possible_cpus();
-		xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
-		if (xdp_ring_err)
-			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
+		xdp_ring_err = ice_vsi_determine_xdp_res(vsi);
+		if (xdp_ring_err) {
+			NL_SET_ERR_MSG_MOD(extack, "Not enough Tx resources for XDP");
+		} else {
+			xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
+			if (xdp_ring_err)
+				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
+		}
 	} else if (ice_is_xdp_ena_vsi(vsi) && !prog) {
 		xdp_ring_err = ice_destroy_xdp_rings(vsi);
 		if (xdp_ring_err)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index ca1f24deb3fd..eff50a0896c5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -545,7 +545,11 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	case XDP_PASS:
 		return ICE_XDP_PASS;
 	case XDP_TX:
+		if (static_branch_unlikely(&ice_xdp_locking_key))
+			spin_lock(&xdp_ring->tx_lock);
 		err = ice_xmit_xdp_ring(xdp->data, xdp->data_end - xdp->data, xdp_ring);
+		if (static_branch_unlikely(&ice_xdp_locking_key))
+			spin_unlock(&xdp_ring->tx_lock);
 		if (err == ICE_XDP_CONSUMED)
 			goto out_failure;
 		return err;
@@ -597,7 +601,14 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
 
-	xdp_ring = vsi->xdp_rings[queue_index];
+	if (static_branch_unlikely(&ice_xdp_locking_key)) {
+		queue_index %= vsi->num_xdp_txq;
+		xdp_ring = vsi->xdp_rings[queue_index];
+		spin_lock(&xdp_ring->tx_lock);
+	} else {
+		xdp_ring = vsi->xdp_rings[queue_index];
+	}
+
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
 		int err;
@@ -611,6 +622,9 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		ice_xdp_ring_update_tail(xdp_ring);
 
+	if (static_branch_unlikely(&ice_xdp_locking_key))
+		spin_unlock(&xdp_ring->tx_lock);
+
 	return nxmit;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 7f6811f6ae42..024f03767be0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -332,6 +332,7 @@ struct ice_tx_ring {
 	struct rcu_head rcu;		/* to avoid race on free */
 	DECLARE_BITMAP(xps_state, ICE_TX_NBITS);	/* XPS Config State */
 	struct ice_ptp_tx *tx_tstamps;
+	spinlock_t tx_lock;
 	u32 txq_teid;			/* Added Tx queue TEID */
 #define ICE_TX_FLAGS_RING_XDP		BIT(0)
 	u8 flags;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index c31c451e67af..db7ace46c39f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -348,6 +348,11 @@ void ice_finalize_xdp_rx(struct ice_tx_ring *xdp_ring, unsigned int xdp_res)
 	if (xdp_res & ICE_XDP_REDIR)
 		xdp_do_flush_map();
 
-	if (xdp_res & ICE_XDP_TX)
+	if (xdp_res & ICE_XDP_TX) {
+		if (static_branch_unlikely(&ice_xdp_locking_key))
+			spin_lock(&xdp_ring->tx_lock);
 		ice_xdp_ring_update_tail(xdp_ring);
+		if (static_branch_unlikely(&ice_xdp_locking_key))
+			spin_unlock(&xdp_ring->tx_lock);
+	}
 }
-- 
2.20.1

