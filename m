Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947C53BC1E9
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhGERAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 13:00:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:50107 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhGERAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 13:00:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="294646412"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="294646412"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 09:58:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="562686311"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jul 2021 09:58:04 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, joamaki@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-next 4/4] ice: introduce XDP_TX fallback path
Date:   Mon,  5 Jul 2021 18:43:38 +0200
Message-Id: <20210705164338.58313-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210705164338.58313-1-maciej.fijalkowski@intel.com>
References: <20210705164338.58313-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under rare circumstances there might be a situation where a requirement
of having XDP Tx queue per CPU could not be fulfilled and some of the Tx
resources have to be shared between CPUs. This yields a need for placing
accesses to xdp_rings array inside a critical section protected by
spinlock. These accesses happen to be in the hot path, so let's
introduce the static branch that will be triggered from the control
plane when driver could not provide Tx queue dedicated for XDP on each
CPU.

Currently, the design that has been picked is to allow any number of XDP
Tx queues that is at least half of a count of CPUs that platform has.
For lower number driver will bail out with a response to user that there
were not enough Tx resources that would allow configuring XDP. The
sharing of rings is signalled via static branch enablement which in turn
indicates that lock for xdp_ring accesses needs to be taken in hot path.

Approach based on static branch has no impact on performance of a
non-fallback path. The static branch will act as a global driver
switch, meaning that if one PF got out of Tx resources, then other PFs
that ice driver is servicing will suffer. However, given the fact that
HW that ice driver is handling has 1024 Tx queues per each PF, this is
currently an unlikely scenario.

One thing to note in the fallback path is that it can result in a
situation where one NAPI instance is producing descriptors to the
xdp_ring that belongs to different NAPI, which would mean that an
explicit raise of a software interrupt needs to be issued so that remote
NAPI is scheduled and descriptors are cleaned on the xdp_ring.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  3 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 45 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 44 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 22 ++++++---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h | 16 +++++++
 7 files changed, 117 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index a450343fbb92..3ddf079a6bf3 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -158,6 +158,8 @@
 
 #define ice_pf_to_dev(pf) (&((pf)->pdev->dev))
 
+DECLARE_STATIC_KEY_FALSE(ice_xdp_locking_key);
+
 struct ice_txq_meta {
 	u32 q_teid;	/* Tx-scheduler element identifier */
 	u16 q_id;	/* Entry in VSI's txq_map bitmap */
@@ -647,6 +649,7 @@ int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
 int ice_vsi_cfg(struct ice_vsi *vsi);
 struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
+int ice_vsi_determine_xdp_res(struct ice_vsi *vsi);
 int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog);
 int ice_destroy_xdp_rings(struct ice_vsi *vsi);
 int
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 20d02e9d6635..9aa8e711aaef 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3154,7 +3154,9 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
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
index f26db305b797..151868c7c485 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -42,6 +42,8 @@ MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
 #endif /* !CONFIG_DYNAMIC_DEBUG */
 
 static DEFINE_IDA(ice_aux_ida);
+DEFINE_STATIC_KEY_FALSE(ice_xdp_locking_key);
+EXPORT_SYMBOL(ice_xdp_locking_key);
 
 static struct workqueue_struct *ice_wq;
 static const struct net_device_ops ice_netdev_safe_mode_ops;
@@ -2382,6 +2384,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 			goto free_xdp_rings;
 		ice_set_ring_xdp(xdp_ring);
 		xdp_ring->xsk_pool = ice_xsk_pool(xdp_ring);
+		spin_lock_init(&xdp_ring->tx_lock);
 	}
 
 	return 0;
@@ -2447,6 +2450,10 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 	if (__ice_vsi_get_qs(&xdp_qs_cfg))
 		goto err_map_xdp;
 
+	if (static_key_enabled(&ice_xdp_locking_key))
+		netdev_warn(vsi->netdev,
+			    "Could not allocate one XDP Tx ring per CPU, XDP_TX/XDP_REDIRECT actions will be slower\n");
+
 	if (ice_xdp_alloc_setup_rings(vsi))
 		goto clear_xdp_rings;
 
@@ -2563,6 +2570,9 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 	devm_kfree(ice_pf_to_dev(pf), vsi->xdp_rings);
 	vsi->xdp_rings = NULL;
 
+	if (static_key_enabled(&ice_xdp_locking_key))
+		static_branch_dec(&ice_xdp_locking_key);
+
 	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
 		return 0;
 
@@ -2597,6 +2607,29 @@ static void ice_vsi_rx_napi_schedule(struct ice_vsi *vsi)
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
@@ -2626,10 +2659,14 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
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
index fef1f74562e5..97d205fb19da 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -577,19 +577,35 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 	    struct bpf_prog *xdp_prog)
 {
 	struct ice_ring *xdp_ring;
-	int err, result;
+	int err;
 	u32 act;
+	u16 idx;
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
 		return ICE_XDP_PASS;
 	case XDP_TX:
-		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
-		result = ice_xmit_xdp_ring(xdp->data, xdp->data_end - xdp->data, xdp_ring);
-		if (result == ICE_XDP_CONSUMED)
+		idx = smp_processor_id();
+		if (static_branch_unlikely(&ice_xdp_locking_key)) {
+			idx %= rx_ring->vsi->num_xdp_txq;
+			xdp_ring = rx_ring->vsi->xdp_rings[idx];
+			spin_lock(&xdp_ring->tx_lock);
+		} else {
+			xdp_ring = rx_ring->vsi->xdp_rings[idx];
+		}
+		err = ice_xmit_xdp_ring(xdp->data, xdp->data_end - xdp->data, xdp_ring);
+		if (static_branch_unlikely(&ice_xdp_locking_key)) {
+			spin_unlock(&xdp_ring->tx_lock);
+			if (err == ICE_XDP_CONSUMED) {
+				/* kick the remote NAPI that xdp_ring belongs to */
+				ice_trigger_sw_intr(&xdp_ring->vsi->back->hw, xdp_ring->q_vector);
+				goto out_failure;
+			}
+		}
+		if (err == ICE_XDP_CONSUMED)
 			goto out_failure;
-		return result;
+		return err;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
 		if (err)
@@ -638,7 +654,14 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
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
@@ -649,8 +672,15 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		nxmit++;
 	}
 
-	if (unlikely(flags & XDP_XMIT_FLUSH))
+	if (unlikely(flags & XDP_XMIT_FLUSH)) {
+		ice_xdp_ring_set_rs(xdp_ring);
 		ice_xdp_ring_update_tail(xdp_ring);
+	}
+
+	if (static_branch_unlikely(&ice_xdp_locking_key)) {
+		spin_unlock(&xdp_ring->tx_lock);
+		ice_trigger_sw_intr(&vsi->back->hw, xdp_ring->q_vector);
+	}
 
 	return nxmit;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index b43d471ce05d..63538cb3b632 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -303,6 +303,7 @@ struct ice_ring {
 	u16 rx_offset;
 	/* CL3 - 3rd cacheline starts here */
 	struct xdp_rxq_info xdp_rxq;
+	spinlock_t tx_lock;
 	struct sk_buff *skb;
 	/* CLX - the below items are only accessed infrequently and should be
 	 * in their own cache line if possible
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 0b3d51c9869b..164008e26869 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019, Intel Corporation. */
 
 #include "ice_txrx_lib.h"
+#include "ice_base.h"
 
 /**
  * ice_release_rx_desc - Store the new tail and head values
@@ -288,12 +289,21 @@ void ice_finalize_xdp_rx(struct ice_ring *rx_ring, unsigned int xdp_res)
 		xdp_do_flush_map();
 
 	if (xdp_res & ICE_XDP_TX) {
-		struct ice_ring *xdp_ring =
-			rx_ring->vsi->xdp_rings[smp_processor_id()];
-		struct ice_tx_desc *next_rs_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs_idx);
-
-		next_rs_desc->cmd_type_offset_bsz |=
-			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
+		u16 idx = smp_processor_id();
+		struct ice_ring *xdp_ring;
+
+		if (static_branch_unlikely(&ice_xdp_locking_key)) {
+			idx %= rx_ring->vsi->num_xdp_txq;
+			xdp_ring = rx_ring->vsi->xdp_rings[idx];
+			spin_lock(&xdp_ring->tx_lock);
+		} else {
+			xdp_ring = rx_ring->vsi->xdp_rings[idx];
+		}
+		ice_xdp_ring_set_rs(xdp_ring);
 		ice_xdp_ring_update_tail(xdp_ring);
+		if (static_branch_unlikely(&ice_xdp_locking_key)) {
+			spin_unlock(&xdp_ring->tx_lock);
+			ice_trigger_sw_intr(&rx_ring->vsi->back->hw, xdp_ring->q_vector);
+		}
 	}
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index 05ac30752902..319b4bfcecfc 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -31,6 +31,22 @@ ice_build_ctob(u64 td_cmd, u64 td_offset, unsigned int size, u64 td_tag)
 			   (td_tag    << ICE_TXD_QW1_L2TAG1_S));
 }
 
+/**
+ * ice_xdp_ring_set_rs - Sets RS bit on a Tx descriptor
+ * @xdp_ring: XDP Tx ring
+ *
+ * This function sets RS bit on the last descriptor of a batch,
+ * before the update of HW tail register
+ */
+static inline void ice_xdp_ring_set_rs(struct ice_ring *xdp_ring)
+{
+	struct ice_tx_desc *next_rs_desc;
+
+	next_rs_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs_idx);
+	next_rs_desc->cmd_type_offset_bsz |=
+		cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
+}
+
 /**
  * ice_xdp_ring_update_tail - Updates the XDP Tx ring tail register
  * @xdp_ring: XDP Tx ring
-- 
2.20.1

