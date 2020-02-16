Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE16160199
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgBPDpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:45:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:33363 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727723AbgBPDo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916589"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:56 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] ice: Add support to enable/disable all Rx queues before waiting
Date:   Sat, 15 Feb 2020 19:44:43 -0800
Message-Id: <20200216034452.1251706-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
References: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when we enable/disable all Rx queues we do the following
sequence for each Rx queue and then move to the next queue.

1. Enable/Disable the Rx queue via register write.
2. Read the configuration register to determine if the Rx queue was
enabled/disabled successfully.

In some cases enabling/disabling queue 0 fails because of step 2 above.
Fix this by doing step 1 for all of the Rx queues and then step 2 for
all of the Rx queues.

Also, there are cases where we enable/disable a single queue (i.e.
SR-IOV and XDP) so add a new function that does step 1 and 2 above with
a read flush in between.

This change also required a single Rx queue to be enabled/disabled with
and without waiting for the change to propagate through hardware. Fix
this by adding a boolean wait flag to the necessary functions.

Also, add the keywords "one" and "all" to distinguish between
enabling/disabling a single Rx queue and all Rx queues respectively.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c     | 42 ++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_base.h     |  4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 32 +++++++++-----
 drivers/net/ethernet/intel/ice/ice_lib.h      |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  4 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  7 ++--
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  4 +-
 8 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 81885efadc7a..1c41e7e6d548 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -459,17 +459,20 @@ int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg)
 }
 
 /**
- * ice_vsi_ctrl_rx_ring - Start or stop a VSI's Rx ring
+ * ice_vsi_ctrl_one_rx_ring - start/stop VSI's Rx ring with no busy wait
  * @vsi: the VSI being configured
- * @ena: start or stop the Rx rings
- * @rxq_idx: Rx queue index
+ * @ena: start or stop the Rx ring
+ * @rxq_idx: 0-based Rx queue index for the VSI passed in
+ * @wait: wait or don't wait for configuration to finish in hardware
+ *
+ * Return 0 on success and negative on error.
  */
-int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
+int
+ice_vsi_ctrl_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx, bool wait)
 {
 	int pf_q = vsi->rxq_map[rxq_idx];
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
-	int ret = 0;
 	u32 rx_reg;
 
 	rx_reg = rd32(hw, QRX_CTRL(pf_q));
@@ -485,13 +488,30 @@ int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
 		rx_reg &= ~QRX_CTRL_QENA_REQ_M;
 	wr32(hw, QRX_CTRL(pf_q), rx_reg);
 
-	/* wait for the change to finish */
-	ret = ice_pf_rxq_wait(pf, pf_q, ena);
-	if (ret)
-		dev_err(ice_pf_to_dev(pf), "VSI idx %d Rx ring %d %sable timeout\n",
-			vsi->idx, pf_q, (ena ? "en" : "dis"));
+	if (!wait)
+		return 0;
+
+	ice_flush(hw);
+	return ice_pf_rxq_wait(pf, pf_q, ena);
+}
 
-	return ret;
+/**
+ * ice_vsi_wait_one_rx_ring - wait for a VSI's Rx ring to be stopped/started
+ * @vsi: the VSI being configured
+ * @ena: true/false to verify Rx ring has been enabled/disabled respectively
+ * @rxq_idx: 0-based Rx queue index for the VSI passed in
+ *
+ * This routine will wait for the given Rx queue of the VSI to reach the
+ * enabled or disabled state. Returns -ETIMEDOUT in case of failing to reach
+ * the requested state after multiple retries; else will return 0 in case of
+ * success.
+ */
+int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
+{
+	int pf_q = vsi->rxq_map[rxq_idx];
+	struct ice_pf *pf = vsi->back;
+
+	return ice_pf_rxq_wait(pf, pf_q, ena);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_base.h b/drivers/net/ethernet/intel/ice/ice_base.h
index 407995e8e944..44efdb627043 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.h
+++ b/drivers/net/ethernet/intel/ice/ice_base.h
@@ -8,7 +8,9 @@
 
 int ice_setup_rx_ctx(struct ice_ring *ring);
 int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg);
-int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx);
+int
+ice_vsi_ctrl_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx, bool wait);
+int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx);
 int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi);
 void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi);
 void ice_vsi_free_q_vectors(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index b002ab4e5838..c02af503764e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -462,7 +462,7 @@ static int ice_lbtest_prepare_rings(struct ice_vsi *vsi)
 	if (status)
 		goto err_setup_rx_ring;
 
-	status = ice_vsi_start_rx_rings(vsi);
+	status = ice_vsi_start_all_rx_rings(vsi);
 	if (status)
 		goto err_start_rx_ring;
 
@@ -494,7 +494,7 @@ static int ice_lbtest_disable_rings(struct ice_vsi *vsi)
 		netdev_err(vsi->netdev, "Failed to stop Tx rings, VSI %d error %d\n",
 			   vsi->vsi_num, status);
 
-	status = ice_vsi_stop_rx_rings(vsi);
+	status = ice_vsi_stop_all_rx_rings(vsi);
 	if (status)
 		netdev_err(vsi->netdev, "Failed to stop Rx rings, VSI %d error %d\n",
 			   vsi->vsi_num, status);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 263d25630072..8bb8f8c73f3d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -26,16 +26,26 @@ const char *ice_vsi_type_str(enum ice_vsi_type type)
 }
 
 /**
- * ice_vsi_ctrl_rx_rings - Start or stop a VSI's Rx rings
+ * ice_vsi_ctrl_all_rx_rings - Start or stop a VSI's Rx rings
  * @vsi: the VSI being configured
  * @ena: start or stop the Rx rings
+ *
+ * First enable/disable all of the Rx rings, flush any remaining writes, and
+ * then verify that they have all been enabled/disabled successfully. This will
+ * let all of the register writes complete when enabling/disabling the Rx rings
+ * before waiting for the change in hardware to complete.
  */
-static int ice_vsi_ctrl_rx_rings(struct ice_vsi *vsi, bool ena)
+static int ice_vsi_ctrl_all_rx_rings(struct ice_vsi *vsi, bool ena)
 {
 	int i, ret = 0;
 
+	for (i = 0; i < vsi->num_rxq; i++)
+		ice_vsi_ctrl_one_rx_ring(vsi, ena, i, false);
+
+	ice_flush(&vsi->back->hw);
+
 	for (i = 0; i < vsi->num_rxq; i++) {
-		ret = ice_vsi_ctrl_rx_ring(vsi, ena, i);
+		ret = ice_vsi_wait_one_rx_ring(vsi, ena, i);
 		if (ret)
 			break;
 	}
@@ -1682,25 +1692,25 @@ int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena)
 }
 
 /**
- * ice_vsi_start_rx_rings - start VSI's Rx rings
- * @vsi: the VSI whose rings are to be started
+ * ice_vsi_start_all_rx_rings - start/enable all of a VSI's Rx rings
+ * @vsi: the VSI whose rings are to be enabled
  *
  * Returns 0 on success and a negative value on error
  */
-int ice_vsi_start_rx_rings(struct ice_vsi *vsi)
+int ice_vsi_start_all_rx_rings(struct ice_vsi *vsi)
 {
-	return ice_vsi_ctrl_rx_rings(vsi, true);
+	return ice_vsi_ctrl_all_rx_rings(vsi, true);
 }
 
 /**
- * ice_vsi_stop_rx_rings - stop VSI's Rx rings
- * @vsi: the VSI
+ * ice_vsi_stop_all_rx_rings - stop/disable all of a VSI's Rx rings
+ * @vsi: the VSI whose rings are to be disabled
  *
  * Returns 0 on success and a negative value on error
  */
-int ice_vsi_stop_rx_rings(struct ice_vsi *vsi)
+int ice_vsi_stop_all_rx_rings(struct ice_vsi *vsi)
 {
-	return ice_vsi_ctrl_rx_rings(vsi, false);
+	return ice_vsi_ctrl_all_rx_rings(vsi, false);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 3c87e6b509ed..585f1350403f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -30,9 +30,9 @@ int ice_vsi_manage_vlan_insertion(struct ice_vsi *vsi);
 
 int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena);
 
-int ice_vsi_start_rx_rings(struct ice_vsi *vsi);
+int ice_vsi_start_all_rx_rings(struct ice_vsi *vsi);
 
-int ice_vsi_stop_rx_rings(struct ice_vsi *vsi);
+int ice_vsi_stop_all_rx_rings(struct ice_vsi *vsi);
 
 int
 ice_vsi_stop_lan_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index bd6e84f51fd4..ced070427fd7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3968,7 +3968,7 @@ static int ice_up_complete(struct ice_vsi *vsi)
 	 * Tx queue group list was configured and the context bits were
 	 * programmed using ice_vsi_cfg_txqs
 	 */
-	err = ice_vsi_start_rx_rings(vsi);
+	err = ice_vsi_start_all_rx_rings(vsi);
 	if (err)
 		return err;
 
@@ -4347,7 +4347,7 @@ int ice_down(struct ice_vsi *vsi)
 				   vsi->vsi_num, tx_err);
 	}
 
-	rx_err = ice_vsi_stop_rx_rings(vsi);
+	rx_err = ice_vsi_stop_all_rx_rings(vsi);
 	if (rx_err)
 		netdev_err(vsi->netdev, "Failed stop Rx rings, VSI %d error %d\n",
 			   vsi->vsi_num, rx_err);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 19c576625762..3666647da096 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -271,7 +271,7 @@ static void ice_dis_vf_qs(struct ice_vf *vf)
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
-	ice_vsi_stop_rx_rings(vsi);
+	ice_vsi_stop_all_rx_rings(vsi);
 	ice_set_vf_state_qs_dis(vf);
 }
 
@@ -2051,7 +2051,7 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 		if (test_bit(vf_q_id, vf->rxq_ena))
 			continue;
 
-		if (ice_vsi_ctrl_rx_ring(vsi, true, vf_q_id)) {
+		if (ice_vsi_ctrl_one_rx_ring(vsi, true, vf_q_id, true)) {
 			dev_err(ice_pf_to_dev(vsi->back), "Failed to enable Rx ring %d on VSI %d\n",
 				vf_q_id, vsi->vsi_num);
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2179,7 +2179,8 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 			if (!test_bit(vf_q_id, vf->rxq_ena))
 				continue;
 
-			if (ice_vsi_ctrl_rx_ring(vsi, false, vf_q_id)) {
+			if (ice_vsi_ctrl_one_rx_ring(vsi, false, vf_q_id,
+						     true)) {
 				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Rx ring %d on VSI %d\n",
 					vf_q_id, vsi->vsi_num);
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 4d3407bbd4c4..fd96301e59bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -183,7 +183,7 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 		if (err)
 			return err;
 	}
-	err = ice_vsi_ctrl_rx_ring(vsi, false, q_idx);
+	err = ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, true);
 	if (err)
 		return err;
 
@@ -243,7 +243,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 
 	ice_qvec_cfg_msix(vsi, q_vector);
 
-	err = ice_vsi_ctrl_rx_ring(vsi, true, q_idx);
+	err = ice_vsi_ctrl_one_rx_ring(vsi, true, q_idx, true);
 	if (err)
 		goto free_buf;
 
-- 
2.24.1

