Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CD2EF020
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388663AbfKDWZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:25:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:57657 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbfKDVv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:51:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:51:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="219818353"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2019 13:51:26 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 1/9] ice: Introduce ice_base.c
Date:   Mon,  4 Nov 2019 13:51:17 -0800
Message-Id: <20191104215125.16745-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191104215125.16745-1-jeffrey.t.kirsher@intel.com>
References: <20191104215125.16745-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Remove a few uses of kernel configuration flags from ice_lib.c by
introducing a new source file ice_base.c. Also move corresponding
function prototypes from ice_lib.h to ice_base.h and include ice_base.h
where required.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   8 +
 drivers/net/ethernet/intel/ice/ice_base.c     | 767 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_base.h     |  31 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 787 +-----------------
 drivers/net/ethernet/intel/ice/ice_lib.h      |  39 -
 drivers/net/ethernet/intel/ice/ice_main.c     |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   2 -
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   1 +
 10 files changed, 811 insertions(+), 827 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_base.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_base.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 9edde960b4f2..101313e55a11 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -13,6 +13,7 @@ ice-y := ice_main.o	\
 	 ice_nvm.o	\
 	 ice_switch.o	\
 	 ice_sched.o	\
+	 ice_base.o	\
 	 ice_lib.o	\
 	 ice_txrx.o	\
 	 ice_flex_pipe.o	\
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 45e100666049..0b5aa8feae26 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -127,6 +127,14 @@ extern const char ice_drv_ver[];
 				     ICE_PROMISC_VLAN_TX  | \
 				     ICE_PROMISC_VLAN_RX)
 
+struct ice_txq_meta {
+	u32 q_teid;	/* Tx-scheduler element identifier */
+	u16 q_id;	/* Entry in VSI's txq_map bitmap */
+	u16 q_handle;	/* Relative index of Tx queue within TC */
+	u16 vsi_idx;	/* VSI index that Tx queue belongs to */
+	u8 tc;		/* TC number that Tx queue belongs to */
+};
+
 struct ice_tc_info {
 	u16 qoffset;
 	u16 qcount_tx;
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
new file mode 100644
index 000000000000..735922a4d632
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -0,0 +1,767 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include "ice_base.h"
+#include "ice_dcb_lib.h"
+
+/**
+ * __ice_vsi_get_qs_contig - Assign a contiguous chunk of queues to VSI
+ * @qs_cfg: gathered variables needed for PF->VSI queues assignment
+ *
+ * Return 0 on success and -ENOMEM in case of no left space in PF queue bitmap
+ */
+static int __ice_vsi_get_qs_contig(struct ice_qs_cfg *qs_cfg)
+{
+	int offset, i;
+
+	mutex_lock(qs_cfg->qs_mutex);
+	offset = bitmap_find_next_zero_area(qs_cfg->pf_map, qs_cfg->pf_map_size,
+					    0, qs_cfg->q_count, 0);
+	if (offset >= qs_cfg->pf_map_size) {
+		mutex_unlock(qs_cfg->qs_mutex);
+		return -ENOMEM;
+	}
+
+	bitmap_set(qs_cfg->pf_map, offset, qs_cfg->q_count);
+	for (i = 0; i < qs_cfg->q_count; i++)
+		qs_cfg->vsi_map[i + qs_cfg->vsi_map_offset] = i + offset;
+	mutex_unlock(qs_cfg->qs_mutex);
+
+	return 0;
+}
+
+/**
+ * __ice_vsi_get_qs_sc - Assign a scattered queues from PF to VSI
+ * @qs_cfg: gathered variables needed for pf->vsi queues assignment
+ *
+ * Return 0 on success and -ENOMEM in case of no left space in PF queue bitmap
+ */
+static int __ice_vsi_get_qs_sc(struct ice_qs_cfg *qs_cfg)
+{
+	int i, index = 0;
+
+	mutex_lock(qs_cfg->qs_mutex);
+	for (i = 0; i < qs_cfg->q_count; i++) {
+		index = find_next_zero_bit(qs_cfg->pf_map,
+					   qs_cfg->pf_map_size, index);
+		if (index >= qs_cfg->pf_map_size)
+			goto err_scatter;
+		set_bit(index, qs_cfg->pf_map);
+		qs_cfg->vsi_map[i + qs_cfg->vsi_map_offset] = index;
+	}
+	mutex_unlock(qs_cfg->qs_mutex);
+
+	return 0;
+err_scatter:
+	for (index = 0; index < i; index++) {
+		clear_bit(qs_cfg->vsi_map[index], qs_cfg->pf_map);
+		qs_cfg->vsi_map[index + qs_cfg->vsi_map_offset] = 0;
+	}
+	mutex_unlock(qs_cfg->qs_mutex);
+
+	return -ENOMEM;
+}
+
+/**
+ * ice_pf_rxq_wait - Wait for a PF's Rx queue to be enabled or disabled
+ * @pf: the PF being configured
+ * @pf_q: the PF queue
+ * @ena: enable or disable state of the queue
+ *
+ * This routine will wait for the given Rx queue of the PF to reach the
+ * enabled or disabled state.
+ * Returns -ETIMEDOUT in case of failing to reach the requested state after
+ * multiple retries; else will return 0 in case of success.
+ */
+static int ice_pf_rxq_wait(struct ice_pf *pf, int pf_q, bool ena)
+{
+	int i;
+
+	for (i = 0; i < ICE_Q_WAIT_MAX_RETRY; i++) {
+		if (ena == !!(rd32(&pf->hw, QRX_CTRL(pf_q)) &
+			      QRX_CTRL_QENA_STAT_M))
+			return 0;
+
+		usleep_range(20, 40);
+	}
+
+	return -ETIMEDOUT;
+}
+
+/**
+ * ice_vsi_alloc_q_vector - Allocate memory for a single interrupt vector
+ * @vsi: the VSI being configured
+ * @v_idx: index of the vector in the VSI struct
+ *
+ * We allocate one q_vector. If allocation fails we return -ENOMEM.
+ */
+static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, int v_idx)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_q_vector *q_vector;
+
+	/* allocate q_vector */
+	q_vector = devm_kzalloc(&pf->pdev->dev, sizeof(*q_vector), GFP_KERNEL);
+	if (!q_vector)
+		return -ENOMEM;
+
+	q_vector->vsi = vsi;
+	q_vector->v_idx = v_idx;
+	if (vsi->type == ICE_VSI_VF)
+		goto out;
+	/* only set affinity_mask if the CPU is online */
+	if (cpu_online(v_idx))
+		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
+
+	/* This will not be called in the driver load path because the netdev
+	 * will not be created yet. All other cases with register the NAPI
+	 * handler here (i.e. resume, reset/rebuild, etc.)
+	 */
+	if (vsi->netdev)
+		netif_napi_add(vsi->netdev, &q_vector->napi, ice_napi_poll,
+			       NAPI_POLL_WEIGHT);
+
+out:
+	/* tie q_vector and VSI together */
+	vsi->q_vectors[v_idx] = q_vector;
+
+	return 0;
+}
+
+/**
+ * ice_free_q_vector - Free memory allocated for a specific interrupt vector
+ * @vsi: VSI having the memory freed
+ * @v_idx: index of the vector to be freed
+ */
+static void ice_free_q_vector(struct ice_vsi *vsi, int v_idx)
+{
+	struct ice_q_vector *q_vector;
+	struct ice_pf *pf = vsi->back;
+	struct ice_ring *ring;
+
+	if (!vsi->q_vectors[v_idx]) {
+		dev_dbg(&pf->pdev->dev, "Queue vector at index %d not found\n",
+			v_idx);
+		return;
+	}
+	q_vector = vsi->q_vectors[v_idx];
+
+	ice_for_each_ring(ring, q_vector->tx)
+		ring->q_vector = NULL;
+	ice_for_each_ring(ring, q_vector->rx)
+		ring->q_vector = NULL;
+
+	/* only VSI with an associated netdev is set up with NAPI */
+	if (vsi->netdev)
+		netif_napi_del(&q_vector->napi);
+
+	devm_kfree(&pf->pdev->dev, q_vector);
+	vsi->q_vectors[v_idx] = NULL;
+}
+
+/**
+ * ice_cfg_itr_gran - set the ITR granularity to 2 usecs if not already set
+ * @hw: board specific structure
+ */
+static void ice_cfg_itr_gran(struct ice_hw *hw)
+{
+	u32 regval = rd32(hw, GLINT_CTL);
+
+	/* no need to update global register if ITR gran is already set */
+	if (!(regval & GLINT_CTL_DIS_AUTOMASK_M) &&
+	    (((regval & GLINT_CTL_ITR_GRAN_200_M) >>
+	     GLINT_CTL_ITR_GRAN_200_S) == ICE_ITR_GRAN_US) &&
+	    (((regval & GLINT_CTL_ITR_GRAN_100_M) >>
+	     GLINT_CTL_ITR_GRAN_100_S) == ICE_ITR_GRAN_US) &&
+	    (((regval & GLINT_CTL_ITR_GRAN_50_M) >>
+	     GLINT_CTL_ITR_GRAN_50_S) == ICE_ITR_GRAN_US) &&
+	    (((regval & GLINT_CTL_ITR_GRAN_25_M) >>
+	      GLINT_CTL_ITR_GRAN_25_S) == ICE_ITR_GRAN_US))
+		return;
+
+	regval = ((ICE_ITR_GRAN_US << GLINT_CTL_ITR_GRAN_200_S) &
+		  GLINT_CTL_ITR_GRAN_200_M) |
+		 ((ICE_ITR_GRAN_US << GLINT_CTL_ITR_GRAN_100_S) &
+		  GLINT_CTL_ITR_GRAN_100_M) |
+		 ((ICE_ITR_GRAN_US << GLINT_CTL_ITR_GRAN_50_S) &
+		  GLINT_CTL_ITR_GRAN_50_M) |
+		 ((ICE_ITR_GRAN_US << GLINT_CTL_ITR_GRAN_25_S) &
+		  GLINT_CTL_ITR_GRAN_25_M);
+	wr32(hw, GLINT_CTL, regval);
+}
+
+/**
+ * ice_setup_tx_ctx - setup a struct ice_tlan_ctx instance
+ * @ring: The Tx ring to configure
+ * @tlan_ctx: Pointer to the Tx LAN queue context structure to be initialized
+ * @pf_q: queue index in the PF space
+ *
+ * Configure the Tx descriptor ring in TLAN context.
+ */
+static void
+ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
+{
+	struct ice_vsi *vsi = ring->vsi;
+	struct ice_hw *hw = &vsi->back->hw;
+
+	tlan_ctx->base = ring->dma >> ICE_TLAN_CTX_BASE_S;
+
+	tlan_ctx->port_num = vsi->port_info->lport;
+
+	/* Transmit Queue Length */
+	tlan_ctx->qlen = ring->count;
+
+	ice_set_cgd_num(tlan_ctx, ring);
+
+	/* PF number */
+	tlan_ctx->pf_num = hw->pf_id;
+
+	/* queue belongs to a specific VSI type
+	 * VF / VM index should be programmed per vmvf_type setting:
+	 * for vmvf_type = VF, it is VF number between 0-256
+	 * for vmvf_type = VM, it is VM number between 0-767
+	 * for PF or EMP this field should be set to zero
+	 */
+	switch (vsi->type) {
+	case ICE_VSI_LB:
+		/* fall through */
+	case ICE_VSI_PF:
+		tlan_ctx->vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_PF;
+		break;
+	case ICE_VSI_VF:
+		/* Firmware expects vmvf_num to be absolute VF ID */
+		tlan_ctx->vmvf_num = hw->func_caps.vf_base_id + vsi->vf_id;
+		tlan_ctx->vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_VF;
+		break;
+	default:
+		return;
+	}
+
+	/* make sure the context is associated with the right VSI */
+	tlan_ctx->src_vsi = ice_get_hw_vsi_num(hw, vsi->idx);
+
+	tlan_ctx->tso_ena = ICE_TX_LEGACY;
+	tlan_ctx->tso_qnum = pf_q;
+
+	/* Legacy or Advanced Host Interface:
+	 * 0: Advanced Host Interface
+	 * 1: Legacy Host Interface
+	 */
+	tlan_ctx->legacy_int = ICE_TX_LEGACY;
+}
+
+/**
+ * ice_setup_rx_ctx - Configure a receive ring context
+ * @ring: The Rx ring to configure
+ *
+ * Configure the Rx descriptor ring in RLAN context.
+ */
+int ice_setup_rx_ctx(struct ice_ring *ring)
+{
+	struct ice_vsi *vsi = ring->vsi;
+	struct ice_hw *hw = &vsi->back->hw;
+	u32 rxdid = ICE_RXDID_FLEX_NIC;
+	struct ice_rlan_ctx rlan_ctx;
+	u32 regval;
+	u16 pf_q;
+	int err;
+
+	/* what is Rx queue number in global space of 2K Rx queues */
+	pf_q = vsi->rxq_map[ring->q_index];
+
+	/* clear the context structure first */
+	memset(&rlan_ctx, 0, sizeof(rlan_ctx));
+
+	rlan_ctx.base = ring->dma >> 7;
+
+	rlan_ctx.qlen = ring->count;
+
+	/* Receive Packet Data Buffer Size.
+	 * The Packet Data Buffer Size is defined in 128 byte units.
+	 */
+	rlan_ctx.dbuf = vsi->rx_buf_len >> ICE_RLAN_CTX_DBUF_S;
+
+	/* use 32 byte descriptors */
+	rlan_ctx.dsize = 1;
+
+	/* Strip the Ethernet CRC bytes before the packet is posted to host
+	 * memory.
+	 */
+	rlan_ctx.crcstrip = 1;
+
+	/* L2TSEL flag defines the reported L2 Tags in the receive descriptor */
+	rlan_ctx.l2tsel = 1;
+
+	rlan_ctx.dtype = ICE_RX_DTYPE_NO_SPLIT;
+	rlan_ctx.hsplit_0 = ICE_RLAN_RX_HSPLIT_0_NO_SPLIT;
+	rlan_ctx.hsplit_1 = ICE_RLAN_RX_HSPLIT_1_NO_SPLIT;
+
+	/* This controls whether VLAN is stripped from inner headers
+	 * The VLAN in the inner L2 header is stripped to the receive
+	 * descriptor if enabled by this flag.
+	 */
+	rlan_ctx.showiv = 0;
+
+	/* Max packet size for this queue - must not be set to a larger value
+	 * than 5 x DBUF
+	 */
+	rlan_ctx.rxmax = min_t(u16, vsi->max_frame,
+			       ICE_MAX_CHAINED_RX_BUFS * vsi->rx_buf_len);
+
+	/* Rx queue threshold in units of 64 */
+	rlan_ctx.lrxqthresh = 1;
+
+	 /* Enable Flexible Descriptors in the queue context which
+	  * allows this driver to select a specific receive descriptor format
+	  */
+	if (vsi->type != ICE_VSI_VF) {
+		regval = rd32(hw, QRXFLXP_CNTXT(pf_q));
+		regval |= (rxdid << QRXFLXP_CNTXT_RXDID_IDX_S) &
+			QRXFLXP_CNTXT_RXDID_IDX_M;
+
+		/* increasing context priority to pick up profile ID;
+		 * default is 0x01; setting to 0x03 to ensure profile
+		 * is programming if prev context is of same priority
+		 */
+		regval |= (0x03 << QRXFLXP_CNTXT_RXDID_PRIO_S) &
+			QRXFLXP_CNTXT_RXDID_PRIO_M;
+
+		wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
+	}
+
+	/* Absolute queue number out of 2K needs to be passed */
+	err = ice_write_rxq_ctx(hw, &rlan_ctx, pf_q);
+	if (err) {
+		dev_err(&vsi->back->pdev->dev,
+			"Failed to set LAN Rx queue context for absolute Rx queue %d error: %d\n",
+			pf_q, err);
+		return -EIO;
+	}
+
+	if (vsi->type == ICE_VSI_VF)
+		return 0;
+
+	/* init queue specific tail register */
+	ring->tail = hw->hw_addr + QRX_TAIL(pf_q);
+	writel(0, ring->tail);
+	ice_alloc_rx_bufs(ring, ICE_DESC_UNUSED(ring));
+
+	return 0;
+}
+
+/**
+ * __ice_vsi_get_qs - helper function for assigning queues from PF to VSI
+ * @qs_cfg: gathered variables needed for pf->vsi queues assignment
+ *
+ * This function first tries to find contiguous space. If it is not successful,
+ * it tries with the scatter approach.
+ *
+ * Return 0 on success and -ENOMEM in case of no left space in PF queue bitmap
+ */
+int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg)
+{
+	int ret = 0;
+
+	ret = __ice_vsi_get_qs_contig(qs_cfg);
+	if (ret) {
+		/* contig failed, so try with scatter approach */
+		qs_cfg->mapping_mode = ICE_VSI_MAP_SCATTER;
+		qs_cfg->q_count = min_t(u16, qs_cfg->q_count,
+					qs_cfg->scatter_count);
+		ret = __ice_vsi_get_qs_sc(qs_cfg);
+	}
+	return ret;
+}
+
+/**
+ * ice_vsi_ctrl_rx_ring - Start or stop a VSI's Rx ring
+ * @vsi: the VSI being configured
+ * @ena: start or stop the Rx rings
+ * @rxq_idx: Rx queue index
+ */
+int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
+{
+	int pf_q = vsi->rxq_map[rxq_idx];
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	int ret = 0;
+	u32 rx_reg;
+
+	rx_reg = rd32(hw, QRX_CTRL(pf_q));
+
+	/* Skip if the queue is already in the requested state */
+	if (ena == !!(rx_reg & QRX_CTRL_QENA_STAT_M))
+		return 0;
+
+	/* turn on/off the queue */
+	if (ena)
+		rx_reg |= QRX_CTRL_QENA_REQ_M;
+	else
+		rx_reg &= ~QRX_CTRL_QENA_REQ_M;
+	wr32(hw, QRX_CTRL(pf_q), rx_reg);
+
+	/* wait for the change to finish */
+	ret = ice_pf_rxq_wait(pf, pf_q, ena);
+	if (ret)
+		dev_err(&pf->pdev->dev,
+			"VSI idx %d Rx ring %d %sable timeout\n",
+			vsi->idx, pf_q, (ena ? "en" : "dis"));
+
+	return ret;
+}
+
+/**
+ * ice_vsi_alloc_q_vectors - Allocate memory for interrupt vectors
+ * @vsi: the VSI being configured
+ *
+ * We allocate one q_vector per queue interrupt. If allocation fails we
+ * return -ENOMEM.
+ */
+int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	int v_idx = 0, num_q_vectors;
+	int err;
+
+	if (vsi->q_vectors[0]) {
+		dev_dbg(&pf->pdev->dev, "VSI %d has existing q_vectors\n",
+			vsi->vsi_num);
+		return -EEXIST;
+	}
+
+	num_q_vectors = vsi->num_q_vectors;
+
+	for (v_idx = 0; v_idx < num_q_vectors; v_idx++) {
+		err = ice_vsi_alloc_q_vector(vsi, v_idx);
+		if (err)
+			goto err_out;
+	}
+
+	return 0;
+
+err_out:
+	while (v_idx--)
+		ice_free_q_vector(vsi, v_idx);
+
+	dev_err(&pf->pdev->dev,
+		"Failed to allocate %d q_vector for VSI %d, ret=%d\n",
+		vsi->num_q_vectors, vsi->vsi_num, err);
+	vsi->num_q_vectors = 0;
+	return err;
+}
+
+/**
+ * ice_vsi_map_rings_to_vectors - Map VSI rings to interrupt vectors
+ * @vsi: the VSI being configured
+ *
+ * This function maps descriptor rings to the queue-specific vectors allotted
+ * through the MSI-X enabling code. On a constrained vector budget, we map Tx
+ * and Rx rings to the vector as "efficiently" as possible.
+ */
+void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi)
+{
+	int q_vectors = vsi->num_q_vectors;
+	int tx_rings_rem, rx_rings_rem;
+	int v_id;
+
+	/* initially assigning remaining rings count to VSIs num queue value */
+	tx_rings_rem = vsi->num_txq;
+	rx_rings_rem = vsi->num_rxq;
+
+	for (v_id = 0; v_id < q_vectors; v_id++) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[v_id];
+		int tx_rings_per_v, rx_rings_per_v, q_id, q_base;
+
+		/* Tx rings mapping to vector */
+		tx_rings_per_v = DIV_ROUND_UP(tx_rings_rem, q_vectors - v_id);
+		q_vector->num_ring_tx = tx_rings_per_v;
+		q_vector->tx.ring = NULL;
+		q_vector->tx.itr_idx = ICE_TX_ITR;
+		q_base = vsi->num_txq - tx_rings_rem;
+
+		for (q_id = q_base; q_id < (q_base + tx_rings_per_v); q_id++) {
+			struct ice_ring *tx_ring = vsi->tx_rings[q_id];
+
+			tx_ring->q_vector = q_vector;
+			tx_ring->next = q_vector->tx.ring;
+			q_vector->tx.ring = tx_ring;
+		}
+		tx_rings_rem -= tx_rings_per_v;
+
+		/* Rx rings mapping to vector */
+		rx_rings_per_v = DIV_ROUND_UP(rx_rings_rem, q_vectors - v_id);
+		q_vector->num_ring_rx = rx_rings_per_v;
+		q_vector->rx.ring = NULL;
+		q_vector->rx.itr_idx = ICE_RX_ITR;
+		q_base = vsi->num_rxq - rx_rings_rem;
+
+		for (q_id = q_base; q_id < (q_base + rx_rings_per_v); q_id++) {
+			struct ice_ring *rx_ring = vsi->rx_rings[q_id];
+
+			rx_ring->q_vector = q_vector;
+			rx_ring->next = q_vector->rx.ring;
+			q_vector->rx.ring = rx_ring;
+		}
+		rx_rings_rem -= rx_rings_per_v;
+	}
+}
+
+/**
+ * ice_vsi_free_q_vectors - Free memory allocated for interrupt vectors
+ * @vsi: the VSI having memory freed
+ */
+void ice_vsi_free_q_vectors(struct ice_vsi *vsi)
+{
+	int v_idx;
+
+	ice_for_each_q_vector(vsi, v_idx)
+		ice_free_q_vector(vsi, v_idx);
+}
+
+/**
+ * ice_vsi_cfg_txq - Configure single Tx queue
+ * @vsi: the VSI that queue belongs to
+ * @ring: Tx ring to be configured
+ * @tc_q_idx: queue index within given TC
+ * @qg_buf: queue group buffer
+ * @tc: TC that Tx ring belongs to
+ */
+int
+ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring, u16 tc_q_idx,
+		struct ice_aqc_add_tx_qgrp *qg_buf, u8 tc)
+{
+	struct ice_tlan_ctx tlan_ctx = { 0 };
+	struct ice_aqc_add_txqs_perq *txq;
+	struct ice_pf *pf = vsi->back;
+	u8 buf_len = sizeof(*qg_buf);
+	enum ice_status status;
+	u16 pf_q;
+
+	pf_q = ring->reg_idx;
+	ice_setup_tx_ctx(ring, &tlan_ctx, pf_q);
+	/* copy context contents into the qg_buf */
+	qg_buf->txqs[0].txq_id = cpu_to_le16(pf_q);
+	ice_set_ctx((u8 *)&tlan_ctx, qg_buf->txqs[0].txq_ctx,
+		    ice_tlan_ctx_info);
+
+	/* init queue specific tail reg. It is referred as
+	 * transmit comm scheduler queue doorbell.
+	 */
+	ring->tail = pf->hw.hw_addr + QTX_COMM_DBELL(pf_q);
+
+	/* Add unique software queue handle of the Tx queue per
+	 * TC into the VSI Tx ring
+	 */
+	ring->q_handle = tc_q_idx;
+
+	status = ice_ena_vsi_txq(vsi->port_info, vsi->idx, tc, ring->q_handle,
+				 1, qg_buf, buf_len, NULL);
+	if (status) {
+		dev_err(&pf->pdev->dev,
+			"Failed to set LAN Tx queue context, error: %d\n",
+			status);
+		return -ENODEV;
+	}
+
+	/* Add Tx Queue TEID into the VSI Tx ring from the
+	 * response. This will complete configuring and
+	 * enabling the queue.
+	 */
+	txq = &qg_buf->txqs[0];
+	if (pf_q == le16_to_cpu(txq->txq_id))
+		ring->txq_teid = le32_to_cpu(txq->q_teid);
+
+	return 0;
+}
+
+/**
+ * ice_cfg_itr - configure the initial interrupt throttle values
+ * @hw: pointer to the HW structure
+ * @q_vector: interrupt vector that's being configured
+ *
+ * Configure interrupt throttling values for the ring containers that are
+ * associated with the interrupt vector passed in.
+ */
+void ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector)
+{
+	ice_cfg_itr_gran(hw);
+
+	if (q_vector->num_ring_rx) {
+		struct ice_ring_container *rc = &q_vector->rx;
+
+		/* if this value is set then don't overwrite with default */
+		if (!rc->itr_setting)
+			rc->itr_setting = ICE_DFLT_RX_ITR;
+
+		rc->target_itr = ITR_TO_REG(rc->itr_setting);
+		rc->next_update = jiffies + 1;
+		rc->current_itr = rc->target_itr;
+		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
+		     ITR_REG_ALIGN(rc->current_itr) >> ICE_ITR_GRAN_S);
+	}
+
+	if (q_vector->num_ring_tx) {
+		struct ice_ring_container *rc = &q_vector->tx;
+
+		/* if this value is set then don't overwrite with default */
+		if (!rc->itr_setting)
+			rc->itr_setting = ICE_DFLT_TX_ITR;
+
+		rc->target_itr = ITR_TO_REG(rc->itr_setting);
+		rc->next_update = jiffies + 1;
+		rc->current_itr = rc->target_itr;
+		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
+		     ITR_REG_ALIGN(rc->current_itr) >> ICE_ITR_GRAN_S);
+	}
+}
+
+/**
+ * ice_cfg_txq_interrupt - configure interrupt on Tx queue
+ * @vsi: the VSI being configured
+ * @txq: Tx queue being mapped to MSI-X vector
+ * @msix_idx: MSI-X vector index within the function
+ * @itr_idx: ITR index of the interrupt cause
+ *
+ * Configure interrupt on Tx queue by associating Tx queue to MSI-X vector
+ * within the function space.
+ */
+void
+ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	u32 val;
+
+	itr_idx = (itr_idx << QINT_TQCTL_ITR_INDX_S) & QINT_TQCTL_ITR_INDX_M;
+
+	val = QINT_TQCTL_CAUSE_ENA_M | itr_idx |
+	      ((msix_idx << QINT_TQCTL_MSIX_INDX_S) & QINT_TQCTL_MSIX_INDX_M);
+
+	wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), val);
+}
+
+/**
+ * ice_cfg_rxq_interrupt - configure interrupt on Rx queue
+ * @vsi: the VSI being configured
+ * @rxq: Rx queue being mapped to MSI-X vector
+ * @msix_idx: MSI-X vector index within the function
+ * @itr_idx: ITR index of the interrupt cause
+ *
+ * Configure interrupt on Rx queue by associating Rx queue to MSI-X vector
+ * within the function space.
+ */
+void
+ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	u32 val;
+
+	itr_idx = (itr_idx << QINT_RQCTL_ITR_INDX_S) & QINT_RQCTL_ITR_INDX_M;
+
+	val = QINT_RQCTL_CAUSE_ENA_M | itr_idx |
+	      ((msix_idx << QINT_RQCTL_MSIX_INDX_S) & QINT_RQCTL_MSIX_INDX_M);
+
+	wr32(hw, QINT_RQCTL(vsi->rxq_map[rxq]), val);
+
+	ice_flush(hw);
+}
+
+/**
+ * ice_trigger_sw_intr - trigger a software interrupt
+ * @hw: pointer to the HW structure
+ * @q_vector: interrupt vector to trigger the software interrupt for
+ */
+void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector)
+{
+	wr32(hw, GLINT_DYN_CTL(q_vector->reg_idx),
+	     (ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S) |
+	     GLINT_DYN_CTL_SWINT_TRIG_M |
+	     GLINT_DYN_CTL_INTENA_M);
+}
+
+/**
+ * ice_vsi_stop_tx_ring - Disable single Tx ring
+ * @vsi: the VSI being configured
+ * @rst_src: reset source
+ * @rel_vmvf_num: Relative ID of VF/VM
+ * @ring: Tx ring to be stopped
+ * @txq_meta: Meta data of Tx ring to be stopped
+ */
+int
+ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
+		     u16 rel_vmvf_num, struct ice_ring *ring,
+		     struct ice_txq_meta *txq_meta)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_q_vector *q_vector;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	u32 val;
+
+	/* clear cause_ena bit for disabled queues */
+	val = rd32(hw, QINT_TQCTL(ring->reg_idx));
+	val &= ~QINT_TQCTL_CAUSE_ENA_M;
+	wr32(hw, QINT_TQCTL(ring->reg_idx), val);
+
+	/* software is expected to wait for 100 ns */
+	ndelay(100);
+
+	/* trigger a software interrupt for the vector
+	 * associated to the queue to schedule NAPI handler
+	 */
+	q_vector = ring->q_vector;
+	if (q_vector)
+		ice_trigger_sw_intr(hw, q_vector);
+
+	status = ice_dis_vsi_txq(vsi->port_info, txq_meta->vsi_idx,
+				 txq_meta->tc, 1, &txq_meta->q_handle,
+				 &txq_meta->q_id, &txq_meta->q_teid, rst_src,
+				 rel_vmvf_num, NULL);
+
+	/* if the disable queue command was exercised during an
+	 * active reset flow, ICE_ERR_RESET_ONGOING is returned.
+	 * This is not an error as the reset operation disables
+	 * queues at the hardware level anyway.
+	 */
+	if (status == ICE_ERR_RESET_ONGOING) {
+		dev_dbg(&vsi->back->pdev->dev,
+			"Reset in progress. LAN Tx queues already disabled\n");
+	} else if (status == ICE_ERR_DOES_NOT_EXIST) {
+		dev_dbg(&vsi->back->pdev->dev,
+			"LAN Tx queues do not exist, nothing to disable\n");
+	} else if (status) {
+		dev_err(&vsi->back->pdev->dev,
+			"Failed to disable LAN Tx queues, error: %d\n", status);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_fill_txq_meta - Prepare the Tx queue's meta data
+ * @vsi: VSI that ring belongs to
+ * @ring: ring that txq_meta will be based on
+ * @txq_meta: a helper struct that wraps Tx queue's information
+ *
+ * Set up a helper struct that will contain all the necessary fields that
+ * are needed for stopping Tx queue
+ */
+void
+ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
+		  struct ice_txq_meta *txq_meta)
+{
+	u8 tc;
+
+	if (IS_ENABLED(CONFIG_DCB))
+		tc = ring->dcb_tc;
+	else
+		tc = 0;
+
+	txq_meta->q_id = ring->reg_idx;
+	txq_meta->q_teid = ring->txq_teid;
+	txq_meta->q_handle = ring->q_handle;
+	txq_meta->vsi_idx = vsi->idx;
+	txq_meta->tc = tc;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_base.h b/drivers/net/ethernet/intel/ice/ice_base.h
new file mode 100644
index 000000000000..db456862b35b
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_base.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_BASE_H_
+#define _ICE_BASE_H_
+
+#include "ice.h"
+
+int ice_setup_rx_ctx(struct ice_ring *ring);
+int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg);
+int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx);
+int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi);
+void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi);
+void ice_vsi_free_q_vectors(struct ice_vsi *vsi);
+int
+ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring, u16 tc_q_idx,
+		struct ice_aqc_add_tx_qgrp *qg_buf, u8 tc);
+void ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector);
+void
+ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx);
+void
+ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx);
+void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector);
+int
+ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
+		     u16 rel_vmvf_num, struct ice_ring *ring,
+		     struct ice_txq_meta *txq_meta);
+void
+ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
+		  struct ice_txq_meta *txq_meta);
+#endif /* _ICE_BASE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 661a6f7bca64..d11a0aab01ac 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -5,6 +5,7 @@
 #define _ICE_DCB_LIB_H_
 
 #include "ice.h"
+#include "ice_base.h"
 #include "ice_lib.h"
 
 #ifdef CONFIG_DCB
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index cc755382df25..b6bdf624c6e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2,234 +2,10 @@
 /* Copyright (c) 2018, Intel Corporation. */
 
 #include "ice.h"
+#include "ice_base.h"
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
-/**
- * ice_setup_rx_ctx - Configure a receive ring context
- * @ring: The Rx ring to configure
- *
- * Configure the Rx descriptor ring in RLAN context.
- */
-static int ice_setup_rx_ctx(struct ice_ring *ring)
-{
-	struct ice_vsi *vsi = ring->vsi;
-	struct ice_hw *hw = &vsi->back->hw;
-	u32 rxdid = ICE_RXDID_FLEX_NIC;
-	struct ice_rlan_ctx rlan_ctx;
-	u32 regval;
-	u16 pf_q;
-	int err;
-
-	/* what is Rx queue number in global space of 2K Rx queues */
-	pf_q = vsi->rxq_map[ring->q_index];
-
-	/* clear the context structure first */
-	memset(&rlan_ctx, 0, sizeof(rlan_ctx));
-
-	rlan_ctx.base = ring->dma >> 7;
-
-	rlan_ctx.qlen = ring->count;
-
-	/* Receive Packet Data Buffer Size.
-	 * The Packet Data Buffer Size is defined in 128 byte units.
-	 */
-	rlan_ctx.dbuf = vsi->rx_buf_len >> ICE_RLAN_CTX_DBUF_S;
-
-	/* use 32 byte descriptors */
-	rlan_ctx.dsize = 1;
-
-	/* Strip the Ethernet CRC bytes before the packet is posted to host
-	 * memory.
-	 */
-	rlan_ctx.crcstrip = 1;
-
-	/* L2TSEL flag defines the reported L2 Tags in the receive descriptor */
-	rlan_ctx.l2tsel = 1;
-
-	rlan_ctx.dtype = ICE_RX_DTYPE_NO_SPLIT;
-	rlan_ctx.hsplit_0 = ICE_RLAN_RX_HSPLIT_0_NO_SPLIT;
-	rlan_ctx.hsplit_1 = ICE_RLAN_RX_HSPLIT_1_NO_SPLIT;
-
-	/* This controls whether VLAN is stripped from inner headers
-	 * The VLAN in the inner L2 header is stripped to the receive
-	 * descriptor if enabled by this flag.
-	 */
-	rlan_ctx.showiv = 0;
-
-	/* Max packet size for this queue - must not be set to a larger value
-	 * than 5 x DBUF
-	 */
-	rlan_ctx.rxmax = min_t(u16, vsi->max_frame,
-			       ICE_MAX_CHAINED_RX_BUFS * vsi->rx_buf_len);
-
-	/* Rx queue threshold in units of 64 */
-	rlan_ctx.lrxqthresh = 1;
-
-	 /* Enable Flexible Descriptors in the queue context which
-	  * allows this driver to select a specific receive descriptor format
-	  */
-	if (vsi->type != ICE_VSI_VF) {
-		regval = rd32(hw, QRXFLXP_CNTXT(pf_q));
-		regval |= (rxdid << QRXFLXP_CNTXT_RXDID_IDX_S) &
-			QRXFLXP_CNTXT_RXDID_IDX_M;
-
-		/* increasing context priority to pick up profile ID;
-		 * default is 0x01; setting to 0x03 to ensure profile
-		 * is programming if prev context is of same priority
-		 */
-		regval |= (0x03 << QRXFLXP_CNTXT_RXDID_PRIO_S) &
-			QRXFLXP_CNTXT_RXDID_PRIO_M;
-
-		wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
-	}
-
-	/* Absolute queue number out of 2K needs to be passed */
-	err = ice_write_rxq_ctx(hw, &rlan_ctx, pf_q);
-	if (err) {
-		dev_err(&vsi->back->pdev->dev,
-			"Failed to set LAN Rx queue context for absolute Rx queue %d error: %d\n",
-			pf_q, err);
-		return -EIO;
-	}
-
-	if (vsi->type == ICE_VSI_VF)
-		return 0;
-
-	/* init queue specific tail register */
-	ring->tail = hw->hw_addr + QRX_TAIL(pf_q);
-	writel(0, ring->tail);
-	ice_alloc_rx_bufs(ring, ICE_DESC_UNUSED(ring));
-
-	return 0;
-}
-
-/**
- * ice_setup_tx_ctx - setup a struct ice_tlan_ctx instance
- * @ring: The Tx ring to configure
- * @tlan_ctx: Pointer to the Tx LAN queue context structure to be initialized
- * @pf_q: queue index in the PF space
- *
- * Configure the Tx descriptor ring in TLAN context.
- */
-static void
-ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
-{
-	struct ice_vsi *vsi = ring->vsi;
-	struct ice_hw *hw = &vsi->back->hw;
-
-	tlan_ctx->base = ring->dma >> ICE_TLAN_CTX_BASE_S;
-
-	tlan_ctx->port_num = vsi->port_info->lport;
-
-	/* Transmit Queue Length */
-	tlan_ctx->qlen = ring->count;
-
-	ice_set_cgd_num(tlan_ctx, ring);
-
-	/* PF number */
-	tlan_ctx->pf_num = hw->pf_id;
-
-	/* queue belongs to a specific VSI type
-	 * VF / VM index should be programmed per vmvf_type setting:
-	 * for vmvf_type = VF, it is VF number between 0-256
-	 * for vmvf_type = VM, it is VM number between 0-767
-	 * for PF or EMP this field should be set to zero
-	 */
-	switch (vsi->type) {
-	case ICE_VSI_LB:
-		/* fall through */
-	case ICE_VSI_PF:
-		tlan_ctx->vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_PF;
-		break;
-	case ICE_VSI_VF:
-		/* Firmware expects vmvf_num to be absolute VF ID */
-		tlan_ctx->vmvf_num = hw->func_caps.vf_base_id + vsi->vf_id;
-		tlan_ctx->vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_VF;
-		break;
-	default:
-		return;
-	}
-
-	/* make sure the context is associated with the right VSI */
-	tlan_ctx->src_vsi = ice_get_hw_vsi_num(hw, vsi->idx);
-
-	tlan_ctx->tso_ena = ICE_TX_LEGACY;
-	tlan_ctx->tso_qnum = pf_q;
-
-	/* Legacy or Advanced Host Interface:
-	 * 0: Advanced Host Interface
-	 * 1: Legacy Host Interface
-	 */
-	tlan_ctx->legacy_int = ICE_TX_LEGACY;
-}
-
-/**
- * ice_pf_rxq_wait - Wait for a PF's Rx queue to be enabled or disabled
- * @pf: the PF being configured
- * @pf_q: the PF queue
- * @ena: enable or disable state of the queue
- *
- * This routine will wait for the given Rx queue of the PF to reach the
- * enabled or disabled state.
- * Returns -ETIMEDOUT in case of failing to reach the requested state after
- * multiple retries; else will return 0 in case of success.
- */
-static int ice_pf_rxq_wait(struct ice_pf *pf, int pf_q, bool ena)
-{
-	int i;
-
-	for (i = 0; i < ICE_Q_WAIT_MAX_RETRY; i++) {
-		if (ena == !!(rd32(&pf->hw, QRX_CTRL(pf_q)) &
-			      QRX_CTRL_QENA_STAT_M))
-			return 0;
-
-		usleep_range(20, 40);
-	}
-
-	return -ETIMEDOUT;
-}
-
-/**
- * ice_vsi_ctrl_rx_ring - Start or stop a VSI's Rx ring
- * @vsi: the VSI being configured
- * @ena: start or stop the Rx rings
- * @rxq_idx: Rx queue index
- */
-#ifndef CONFIG_PCI_IOV
-static
-#endif /* !CONFIG_PCI_IOV */
-int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
-{
-	int pf_q = vsi->rxq_map[rxq_idx];
-	struct ice_pf *pf = vsi->back;
-	struct ice_hw *hw = &pf->hw;
-	int ret = 0;
-	u32 rx_reg;
-
-	rx_reg = rd32(hw, QRX_CTRL(pf_q));
-
-	/* Skip if the queue is already in the requested state */
-	if (ena == !!(rx_reg & QRX_CTRL_QENA_STAT_M))
-		return 0;
-
-	/* turn on/off the queue */
-	if (ena)
-		rx_reg |= QRX_CTRL_QENA_REQ_M;
-	else
-		rx_reg &= ~QRX_CTRL_QENA_REQ_M;
-	wr32(hw, QRX_CTRL(pf_q), rx_reg);
-
-	/* wait for the change to finish */
-	ret = ice_pf_rxq_wait(pf, pf_q, ena);
-	if (ret)
-		dev_err(&pf->pdev->dev,
-			"VSI idx %d Rx ring %d %sable timeout\n",
-			vsi->idx, pf_q, (ena ? "en" : "dis"));
-
-	return ret;
-}
-
 /**
  * ice_vsi_ctrl_rx_rings - Start or stop a VSI's Rx rings
  * @vsi: the VSI being configured
@@ -281,7 +57,6 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 	if (!vsi->rxq_map)
 		goto err_rxq_map;
 
-
 	/* There is no need to allocate q_vectors for a loopback VSI. */
 	if (vsi->type == ICE_VSI_LB)
 		return 0;
@@ -605,88 +380,6 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
 	return vsi;
 }
 
-/**
- * __ice_vsi_get_qs_contig - Assign a contiguous chunk of queues to VSI
- * @qs_cfg: gathered variables needed for PF->VSI queues assignment
- *
- * Return 0 on success and -ENOMEM in case of no left space in PF queue bitmap
- */
-static int __ice_vsi_get_qs_contig(struct ice_qs_cfg *qs_cfg)
-{
-	int offset, i;
-
-	mutex_lock(qs_cfg->qs_mutex);
-	offset = bitmap_find_next_zero_area(qs_cfg->pf_map, qs_cfg->pf_map_size,
-					    0, qs_cfg->q_count, 0);
-	if (offset >= qs_cfg->pf_map_size) {
-		mutex_unlock(qs_cfg->qs_mutex);
-		return -ENOMEM;
-	}
-
-	bitmap_set(qs_cfg->pf_map, offset, qs_cfg->q_count);
-	for (i = 0; i < qs_cfg->q_count; i++)
-		qs_cfg->vsi_map[i + qs_cfg->vsi_map_offset] = i + offset;
-	mutex_unlock(qs_cfg->qs_mutex);
-
-	return 0;
-}
-
-/**
- * __ice_vsi_get_qs_sc - Assign a scattered queues from PF to VSI
- * @qs_cfg: gathered variables needed for pf->vsi queues assignment
- *
- * Return 0 on success and -ENOMEM in case of no left space in PF queue bitmap
- */
-static int __ice_vsi_get_qs_sc(struct ice_qs_cfg *qs_cfg)
-{
-	int i, index = 0;
-
-	mutex_lock(qs_cfg->qs_mutex);
-	for (i = 0; i < qs_cfg->q_count; i++) {
-		index = find_next_zero_bit(qs_cfg->pf_map,
-					   qs_cfg->pf_map_size, index);
-		if (index >= qs_cfg->pf_map_size)
-			goto err_scatter;
-		set_bit(index, qs_cfg->pf_map);
-		qs_cfg->vsi_map[i + qs_cfg->vsi_map_offset] = index;
-	}
-	mutex_unlock(qs_cfg->qs_mutex);
-
-	return 0;
-err_scatter:
-	for (index = 0; index < i; index++) {
-		clear_bit(qs_cfg->vsi_map[index], qs_cfg->pf_map);
-		qs_cfg->vsi_map[index + qs_cfg->vsi_map_offset] = 0;
-	}
-	mutex_unlock(qs_cfg->qs_mutex);
-
-	return -ENOMEM;
-}
-
-/**
- * __ice_vsi_get_qs - helper function for assigning queues from PF to VSI
- * @qs_cfg: gathered variables needed for pf->vsi queues assignment
- *
- * This function first tries to find contiguous space. If it is not successful,
- * it tries with the scatter approach.
- *
- * Return 0 on success and -ENOMEM in case of no left space in PF queue bitmap
- */
-static int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg)
-{
-	int ret = 0;
-
-	ret = __ice_vsi_get_qs_contig(qs_cfg);
-	if (ret) {
-		/* contig failed, so try with scatter approach */
-		qs_cfg->mapping_mode = ICE_VSI_MAP_SCATTER;
-		qs_cfg->q_count = min_t(u16, qs_cfg->q_count,
-					qs_cfg->scatter_count);
-		ret = __ice_vsi_get_qs_sc(qs_cfg);
-	}
-	return ret;
-}
-
 /**
  * ice_vsi_get_qs - Assign queues from PF to VSI
  * @vsi: the VSI to assign queues to
@@ -1097,129 +790,6 @@ static int ice_vsi_init(struct ice_vsi *vsi)
 	return ret;
 }
 
-/**
- * ice_free_q_vector - Free memory allocated for a specific interrupt vector
- * @vsi: VSI having the memory freed
- * @v_idx: index of the vector to be freed
- */
-static void ice_free_q_vector(struct ice_vsi *vsi, int v_idx)
-{
-	struct ice_q_vector *q_vector;
-	struct ice_pf *pf = vsi->back;
-	struct ice_ring *ring;
-
-	if (!vsi->q_vectors[v_idx]) {
-		dev_dbg(&pf->pdev->dev, "Queue vector at index %d not found\n",
-			v_idx);
-		return;
-	}
-	q_vector = vsi->q_vectors[v_idx];
-
-	ice_for_each_ring(ring, q_vector->tx)
-		ring->q_vector = NULL;
-	ice_for_each_ring(ring, q_vector->rx)
-		ring->q_vector = NULL;
-
-	/* only VSI with an associated netdev is set up with NAPI */
-	if (vsi->netdev)
-		netif_napi_del(&q_vector->napi);
-
-	devm_kfree(&pf->pdev->dev, q_vector);
-	vsi->q_vectors[v_idx] = NULL;
-}
-
-/**
- * ice_vsi_free_q_vectors - Free memory allocated for interrupt vectors
- * @vsi: the VSI having memory freed
- */
-void ice_vsi_free_q_vectors(struct ice_vsi *vsi)
-{
-	int v_idx;
-
-	ice_for_each_q_vector(vsi, v_idx)
-		ice_free_q_vector(vsi, v_idx);
-}
-
-/**
- * ice_vsi_alloc_q_vector - Allocate memory for a single interrupt vector
- * @vsi: the VSI being configured
- * @v_idx: index of the vector in the VSI struct
- *
- * We allocate one q_vector. If allocation fails we return -ENOMEM.
- */
-static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, int v_idx)
-{
-	struct ice_pf *pf = vsi->back;
-	struct ice_q_vector *q_vector;
-
-	/* allocate q_vector */
-	q_vector = devm_kzalloc(&pf->pdev->dev, sizeof(*q_vector), GFP_KERNEL);
-	if (!q_vector)
-		return -ENOMEM;
-
-	q_vector->vsi = vsi;
-	q_vector->v_idx = v_idx;
-	if (vsi->type == ICE_VSI_VF)
-		goto out;
-	/* only set affinity_mask if the CPU is online */
-	if (cpu_online(v_idx))
-		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
-
-	/* This will not be called in the driver load path because the netdev
-	 * will not be created yet. All other cases with register the NAPI
-	 * handler here (i.e. resume, reset/rebuild, etc.)
-	 */
-	if (vsi->netdev)
-		netif_napi_add(vsi->netdev, &q_vector->napi, ice_napi_poll,
-			       NAPI_POLL_WEIGHT);
-
-out:
-	/* tie q_vector and VSI together */
-	vsi->q_vectors[v_idx] = q_vector;
-
-	return 0;
-}
-
-/**
- * ice_vsi_alloc_q_vectors - Allocate memory for interrupt vectors
- * @vsi: the VSI being configured
- *
- * We allocate one q_vector per queue interrupt. If allocation fails we
- * return -ENOMEM.
- */
-static int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
-{
-	struct ice_pf *pf = vsi->back;
-	int v_idx = 0, num_q_vectors;
-	int err;
-
-	if (vsi->q_vectors[0]) {
-		dev_dbg(&pf->pdev->dev, "VSI %d has existing q_vectors\n",
-			vsi->vsi_num);
-		return -EEXIST;
-	}
-
-	num_q_vectors = vsi->num_q_vectors;
-
-	for (v_idx = 0; v_idx < num_q_vectors; v_idx++) {
-		err = ice_vsi_alloc_q_vector(vsi, v_idx);
-		if (err)
-			goto err_out;
-	}
-
-	return 0;
-
-err_out:
-	while (v_idx--)
-		ice_free_q_vector(vsi, v_idx);
-
-	dev_err(&pf->pdev->dev,
-		"Failed to allocate %d q_vector for VSI %d, ret=%d\n",
-		vsi->num_q_vectors, vsi->vsi_num, err);
-	vsi->num_q_vectors = 0;
-	return err;
-}
-
 /**
  * ice_vsi_setup_vector_base - Set up the base vector for the given VSI
  * @vsi: ptr to the VSI
@@ -1340,66 +910,6 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 	return -ENOMEM;
 }
 
-/**
- * ice_vsi_map_rings_to_vectors - Map VSI rings to interrupt vectors
- * @vsi: the VSI being configured
- *
- * This function maps descriptor rings to the queue-specific vectors allotted
- * through the MSI-X enabling code. On a constrained vector budget, we map Tx
- * and Rx rings to the vector as "efficiently" as possible.
- */
-#ifdef CONFIG_DCB
-void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi)
-#else
-static void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi)
-#endif /* CONFIG_DCB */
-{
-	int q_vectors = vsi->num_q_vectors;
-	int tx_rings_rem, rx_rings_rem;
-	int v_id;
-
-	/* initially assigning remaining rings count to VSIs num queue value */
-	tx_rings_rem = vsi->num_txq;
-	rx_rings_rem = vsi->num_rxq;
-
-	for (v_id = 0; v_id < q_vectors; v_id++) {
-		struct ice_q_vector *q_vector = vsi->q_vectors[v_id];
-		int tx_rings_per_v, rx_rings_per_v, q_id, q_base;
-
-		/* Tx rings mapping to vector */
-		tx_rings_per_v = DIV_ROUND_UP(tx_rings_rem, q_vectors - v_id);
-		q_vector->num_ring_tx = tx_rings_per_v;
-		q_vector->tx.ring = NULL;
-		q_vector->tx.itr_idx = ICE_TX_ITR;
-		q_base = vsi->num_txq - tx_rings_rem;
-
-		for (q_id = q_base; q_id < (q_base + tx_rings_per_v); q_id++) {
-			struct ice_ring *tx_ring = vsi->tx_rings[q_id];
-
-			tx_ring->q_vector = q_vector;
-			tx_ring->next = q_vector->tx.ring;
-			q_vector->tx.ring = tx_ring;
-		}
-		tx_rings_rem -= tx_rings_per_v;
-
-		/* Rx rings mapping to vector */
-		rx_rings_per_v = DIV_ROUND_UP(rx_rings_rem, q_vectors - v_id);
-		q_vector->num_ring_rx = rx_rings_per_v;
-		q_vector->rx.ring = NULL;
-		q_vector->rx.itr_idx = ICE_RX_ITR;
-		q_base = vsi->num_rxq - rx_rings_rem;
-
-		for (q_id = q_base; q_id < (q_base + rx_rings_per_v); q_id++) {
-			struct ice_ring *rx_ring = vsi->rx_rings[q_id];
-
-			rx_ring->q_vector = q_vector;
-			rx_ring->next = q_vector->rx.ring;
-			q_vector->rx.ring = rx_ring;
-		}
-		rx_rings_rem -= rx_rings_per_v;
-	}
-}
-
 /**
  * ice_vsi_manage_rss_lut - disable/enable RSS
  * @vsi: the VSI being changed
@@ -1711,62 +1221,6 @@ int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
 	return 0;
 }
 
-/**
- * ice_vsi_cfg_txq - Configure single Tx queue
- * @vsi: the VSI that queue belongs to
- * @ring: Tx ring to be configured
- * @tc_q_idx: queue index within given TC
- * @qg_buf: queue group buffer
- * @tc: TC that Tx ring belongs to
- */
-static int
-ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring, u16 tc_q_idx,
-		struct ice_aqc_add_tx_qgrp *qg_buf, u8 tc)
-{
-	struct ice_tlan_ctx tlan_ctx = { 0 };
-	struct ice_aqc_add_txqs_perq *txq;
-	struct ice_pf *pf = vsi->back;
-	u8 buf_len = sizeof(*qg_buf);
-	enum ice_status status;
-	u16 pf_q;
-
-	pf_q = ring->reg_idx;
-	ice_setup_tx_ctx(ring, &tlan_ctx, pf_q);
-	/* copy context contents into the qg_buf */
-	qg_buf->txqs[0].txq_id = cpu_to_le16(pf_q);
-	ice_set_ctx((u8 *)&tlan_ctx, qg_buf->txqs[0].txq_ctx,
-		    ice_tlan_ctx_info);
-
-	/* init queue specific tail reg. It is referred as
-	 * transmit comm scheduler queue doorbell.
-	 */
-	ring->tail = pf->hw.hw_addr + QTX_COMM_DBELL(pf_q);
-
-	/* Add unique software queue handle of the Tx queue per
-	 * TC into the VSI Tx ring
-	 */
-	ring->q_handle = tc_q_idx;
-
-	status = ice_ena_vsi_txq(vsi->port_info, vsi->idx, tc, ring->q_handle,
-				 1, qg_buf, buf_len, NULL);
-	if (status) {
-		dev_err(&pf->pdev->dev,
-			"Failed to set LAN Tx queue context, error: %d\n",
-			status);
-		return -ENODEV;
-	}
-
-	/* Add Tx Queue TEID into the VSI Tx ring from the
-	 * response. This will complete configuring and
-	 * enabling the queue.
-	 */
-	txq = &qg_buf->txqs[0];
-	if (pf_q == le16_to_cpu(txq->txq_id))
-		ring->txq_teid = le32_to_cpu(txq->q_teid);
-
-	return 0;
-}
-
 /**
  * ice_vsi_cfg_txqs - Configure the VSI for Tx
  * @vsi: the VSI being configured
@@ -1839,141 +1293,6 @@ u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran)
 	return 0;
 }
 
-/**
- * ice_cfg_itr_gran - set the ITR granularity to 2 usecs if not already set
- * @hw: board specific structure
- */
-static void ice_cfg_itr_gran(struct ice_hw *hw)
-{
-	u32 regval = rd32(hw, GLINT_CTL);
-
-	/* no need to update global register if ITR gran is already set */
-	if (!(regval & GLINT_CTL_DIS_AUTOMASK_M) &&
-	    (((regval & GLINT_CTL_ITR_GRAN_200_M) >>
-	     GLINT_CTL_ITR_GRAN_200_S) == ICE_ITR_GRAN_US) &&
-	    (((regval & GLINT_CTL_ITR_GRAN_100_M) >>
-	     GLINT_CTL_ITR_GRAN_100_S) == ICE_ITR_GRAN_US) &&
-	    (((regval & GLINT_CTL_ITR_GRAN_50_M) >>
-	     GLINT_CTL_ITR_GRAN_50_S) == ICE_ITR_GRAN_US) &&
-	    (((regval & GLINT_CTL_ITR_GRAN_25_M) >>
-	      GLINT_CTL_ITR_GRAN_25_S) == ICE_ITR_GRAN_US))
-		return;
-
-	regval = ((ICE_ITR_GRAN_US << GLINT_CTL_ITR_GRAN_200_S) &
-		  GLINT_CTL_ITR_GRAN_200_M) |
-		 ((ICE_ITR_GRAN_US << GLINT_CTL_ITR_GRAN_100_S) &
-		  GLINT_CTL_ITR_GRAN_100_M) |
-		 ((ICE_ITR_GRAN_US << GLINT_CTL_ITR_GRAN_50_S) &
-		  GLINT_CTL_ITR_GRAN_50_M) |
-		 ((ICE_ITR_GRAN_US << GLINT_CTL_ITR_GRAN_25_S) &
-		  GLINT_CTL_ITR_GRAN_25_M);
-	wr32(hw, GLINT_CTL, regval);
-}
-
-/**
- * ice_cfg_itr - configure the initial interrupt throttle values
- * @hw: pointer to the HW structure
- * @q_vector: interrupt vector that's being configured
- *
- * Configure interrupt throttling values for the ring containers that are
- * associated with the interrupt vector passed in.
- */
-static void
-ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector)
-{
-	ice_cfg_itr_gran(hw);
-
-	if (q_vector->num_ring_rx) {
-		struct ice_ring_container *rc = &q_vector->rx;
-
-		/* if this value is set then don't overwrite with default */
-		if (!rc->itr_setting)
-			rc->itr_setting = ICE_DFLT_RX_ITR;
-
-		rc->target_itr = ITR_TO_REG(rc->itr_setting);
-		rc->next_update = jiffies + 1;
-		rc->current_itr = rc->target_itr;
-		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
-		     ITR_REG_ALIGN(rc->current_itr) >> ICE_ITR_GRAN_S);
-	}
-
-	if (q_vector->num_ring_tx) {
-		struct ice_ring_container *rc = &q_vector->tx;
-
-		/* if this value is set then don't overwrite with default */
-		if (!rc->itr_setting)
-			rc->itr_setting = ICE_DFLT_TX_ITR;
-
-		rc->target_itr = ITR_TO_REG(rc->itr_setting);
-		rc->next_update = jiffies + 1;
-		rc->current_itr = rc->target_itr;
-		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
-		     ITR_REG_ALIGN(rc->current_itr) >> ICE_ITR_GRAN_S);
-	}
-}
-
-/**
- * ice_cfg_txq_interrupt - configure interrupt on Tx queue
- * @vsi: the VSI being configured
- * @txq: Tx queue being mapped to MSI-X vector
- * @msix_idx: MSI-X vector index within the function
- * @itr_idx: ITR index of the interrupt cause
- *
- * Configure interrupt on Tx queue by associating Tx queue to MSI-X vector
- * within the function space.
- */
-#ifdef CONFIG_PCI_IOV
-void
-ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx)
-#else
-static void
-ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx)
-#endif /* CONFIG_PCI_IOV */
-{
-	struct ice_pf *pf = vsi->back;
-	struct ice_hw *hw = &pf->hw;
-	u32 val;
-
-	itr_idx = (itr_idx << QINT_TQCTL_ITR_INDX_S) & QINT_TQCTL_ITR_INDX_M;
-
-	val = QINT_TQCTL_CAUSE_ENA_M | itr_idx |
-	      ((msix_idx << QINT_TQCTL_MSIX_INDX_S) & QINT_TQCTL_MSIX_INDX_M);
-
-	wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), val);
-}
-
-/**
- * ice_cfg_rxq_interrupt - configure interrupt on Rx queue
- * @vsi: the VSI being configured
- * @rxq: Rx queue being mapped to MSI-X vector
- * @msix_idx: MSI-X vector index within the function
- * @itr_idx: ITR index of the interrupt cause
- *
- * Configure interrupt on Rx queue by associating Rx queue to MSI-X vector
- * within the function space.
- */
-#ifdef CONFIG_PCI_IOV
-void
-ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx)
-#else
-static void
-ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx)
-#endif /* CONFIG_PCI_IOV */
-{
-	struct ice_pf *pf = vsi->back;
-	struct ice_hw *hw = &pf->hw;
-	u32 val;
-
-	itr_idx = (itr_idx << QINT_RQCTL_ITR_INDX_S) & QINT_RQCTL_ITR_INDX_M;
-
-	val = QINT_RQCTL_CAUSE_ENA_M | itr_idx |
-	      ((msix_idx << QINT_RQCTL_MSIX_INDX_S) & QINT_RQCTL_MSIX_INDX_M);
-
-	wr32(hw, QINT_RQCTL(vsi->rxq_map[rxq]), val);
-
-	ice_flush(hw);
-}
-
 /**
  * ice_vsi_cfg_msix - MSIX mode Interrupt Config in the HW
  * @vsi: the VSI being configured
@@ -2133,109 +1452,6 @@ int ice_vsi_stop_rx_rings(struct ice_vsi *vsi)
 	return ice_vsi_ctrl_rx_rings(vsi, false);
 }
 
-/**
- * ice_trigger_sw_intr - trigger a software interrupt
- * @hw: pointer to the HW structure
- * @q_vector: interrupt vector to trigger the software interrupt for
- */
-void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector)
-{
-	wr32(hw, GLINT_DYN_CTL(q_vector->reg_idx),
-	     (ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S) |
-	     GLINT_DYN_CTL_SWINT_TRIG_M |
-	     GLINT_DYN_CTL_INTENA_M);
-}
-
-/**
- * ice_vsi_stop_tx_ring - Disable single Tx ring
- * @vsi: the VSI being configured
- * @rst_src: reset source
- * @rel_vmvf_num: Relative ID of VF/VM
- * @ring: Tx ring to be stopped
- * @txq_meta: Meta data of Tx ring to be stopped
- */
-#ifndef CONFIG_PCI_IOV
-static
-#endif /* !CONFIG_PCI_IOV */
-int
-ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
-		     u16 rel_vmvf_num, struct ice_ring *ring,
-		     struct ice_txq_meta *txq_meta)
-{
-	struct ice_pf *pf = vsi->back;
-	struct ice_q_vector *q_vector;
-	struct ice_hw *hw = &pf->hw;
-	enum ice_status status;
-	u32 val;
-
-	/* clear cause_ena bit for disabled queues */
-	val = rd32(hw, QINT_TQCTL(ring->reg_idx));
-	val &= ~QINT_TQCTL_CAUSE_ENA_M;
-	wr32(hw, QINT_TQCTL(ring->reg_idx), val);
-
-	/* software is expected to wait for 100 ns */
-	ndelay(100);
-
-	/* trigger a software interrupt for the vector
-	 * associated to the queue to schedule NAPI handler
-	 */
-	q_vector = ring->q_vector;
-	if (q_vector)
-		ice_trigger_sw_intr(hw, q_vector);
-
-	status = ice_dis_vsi_txq(vsi->port_info, txq_meta->vsi_idx,
-				 txq_meta->tc, 1, &txq_meta->q_handle,
-				 &txq_meta->q_id, &txq_meta->q_teid, rst_src,
-				 rel_vmvf_num, NULL);
-
-	/* if the disable queue command was exercised during an
-	 * active reset flow, ICE_ERR_RESET_ONGOING is returned.
-	 * This is not an error as the reset operation disables
-	 * queues at the hardware level anyway.
-	 */
-	if (status == ICE_ERR_RESET_ONGOING) {
-		dev_dbg(&vsi->back->pdev->dev,
-			"Reset in progress. LAN Tx queues already disabled\n");
-	} else if (status == ICE_ERR_DOES_NOT_EXIST) {
-		dev_dbg(&vsi->back->pdev->dev,
-			"LAN Tx queues do not exist, nothing to disable\n");
-	} else if (status) {
-		dev_err(&vsi->back->pdev->dev,
-			"Failed to disable LAN Tx queues, error: %d\n", status);
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-/**
- * ice_fill_txq_meta - Prepare the Tx queue's meta data
- * @vsi: VSI that ring belongs to
- * @ring: ring that txq_meta will be based on
- * @txq_meta: a helper struct that wraps Tx queue's information
- *
- * Set up a helper struct that will contain all the necessary fields that
- * are needed for stopping Tx queue
- */
-#ifndef CONFIG_PCI_IOV
-static
-#endif /* !CONFIG_PCI_IOV */
-void
-ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
-		  struct ice_txq_meta *txq_meta)
-{
-	u8 tc = 0;
-
-#ifdef CONFIG_DCB
-	tc = ring->dcb_tc;
-#endif /* CONFIG_DCB */
-	txq_meta->q_id = ring->reg_idx;
-	txq_meta->q_teid = ring->txq_teid;
-	txq_meta->q_handle = ring->q_handle;
-	txq_meta->vsi_idx = vsi->idx;
-	txq_meta->tc = tc;
-}
-
 /**
  * ice_vsi_stop_tx_rings - Disable Tx rings
  * @vsi: the VSI being configured
@@ -3085,7 +2301,6 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	if (ret < 0)
 		goto err_vsi;
 
-
 	switch (vsi->type) {
 	case ICE_VSI_PF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 47bc033fff20..2fd5da3d0275 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -6,19 +6,6 @@
 
 #include "ice.h"
 
-struct ice_txq_meta {
-	/* Tx-scheduler element identifier */
-	u32 q_teid;
-	/* Entry in VSI's txq_map bitmap */
-	u16 q_id;
-	/* Relative index of Tx queue within TC */
-	u16 q_handle;
-	/* VSI index that Tx queue belongs to */
-	u16 vsi_idx;
-	/* TC number that Tx queue belongs to */
-	u8 tc;
-};
-
 int
 ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
 		    const u8 *macaddr);
@@ -33,24 +20,6 @@ int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi);
 
 void ice_vsi_cfg_msix(struct ice_vsi *vsi);
 
-#ifdef CONFIG_PCI_IOV
-void
-ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx);
-
-void
-ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx);
-
-int
-ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
-		     u16 rel_vmvf_num, struct ice_ring *ring,
-		     struct ice_txq_meta *txq_meta);
-
-void ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
-		       struct ice_txq_meta *txq_meta);
-
-int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx);
-#endif /* CONFIG_PCI_IOV */
-
 int ice_vsi_add_vlan(struct ice_vsi *vsi, u16 vid);
 
 int ice_vsi_kill_vlan(struct ice_vsi *vsi, u16 vid);
@@ -98,16 +67,8 @@ int ice_vsi_rebuild(struct ice_vsi *vsi);
 
 bool ice_is_reset_in_progress(unsigned long *state);
 
-void ice_vsi_free_q_vectors(struct ice_vsi *vsi);
-
-void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector);
-
 void ice_vsi_put_qs(struct ice_vsi *vsi);
 
-#ifdef CONFIG_DCB
-void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi);
-#endif /* CONFIG_DCB */
-
 void ice_vsi_dis_irq(struct ice_vsi *vsi);
 
 void ice_vsi_free_irq(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 214cd6eca405..bf9c4438cbfb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6,6 +6,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include "ice.h"
+#include "ice_base.h"
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 94a9280193e2..a914e603b2ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -205,9 +205,7 @@ struct ice_ring {
 	unsigned int size;		/* length of descriptor ring in bytes */
 	u32 txq_teid;			/* Added Tx queue TEID */
 	u16 rx_buf_len;
-#ifdef CONFIG_DCB
 	u8 dcb_tc;			/* Traffic class of ring */
-#endif /* CONFIG_DCB */
 } ____cacheline_internodealigned_in_smp;
 
 struct ice_ring_container {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index b45797f39b2f..ad757412bb04 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2018, Intel Corporation. */
 
 #include "ice.h"
+#include "ice_base.h"
 #include "ice_lib.h"
 
 /**
-- 
2.21.0

