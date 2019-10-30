Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A825E9548
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfJ3D3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:29:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:2937 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfJ3D3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 23:29:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 20:29:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="205673638"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2019 20:29:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/9] ice: get rid of per-tc flow in Tx queue configuration routines
Date:   Tue, 29 Oct 2019 20:29:03 -0700
Message-Id: <20191030032910.24261-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
References: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

There's no reason for treating DCB as first class citizen when configuring
the Tx queues and going through TCs. Reverse the logic and base the
configuration logic on rings, which is the object of interest anyway.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 29 +++++++++--
 drivers/net/ethernet/intel/ice/ice_base.h |  4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c  | 63 ++++++++---------------
 3 files changed, 47 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 735922a4d632..df9f9bacbdf8 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -190,6 +190,21 @@ static void ice_cfg_itr_gran(struct ice_hw *hw)
 	wr32(hw, GLINT_CTL, regval);
 }
 
+/**
+ * ice_calc_q_handle - calculate the queue handle
+ * @vsi: VSI that ring belongs to
+ * @ring: ring to get the absolute queue index
+ * @tc: traffic class number
+ */
+static u16 ice_calc_q_handle(struct ice_vsi *vsi, struct ice_ring *ring, u8 tc)
+{
+	/* Idea here for calculation is that we subtract the number of queue
+	 * count from TC that ring belongs to from it's absolute queue index
+	 * and as a result we get the queue's index within TC.
+	 */
+	return ring->q_index - vsi->tc_cfg.tc_info[tc].qoffset;
+}
+
 /**
  * ice_setup_tx_ctx - setup a struct ice_tlan_ctx instance
  * @ring: The Tx ring to configure
@@ -522,13 +537,11 @@ void ice_vsi_free_q_vectors(struct ice_vsi *vsi)
  * ice_vsi_cfg_txq - Configure single Tx queue
  * @vsi: the VSI that queue belongs to
  * @ring: Tx ring to be configured
- * @tc_q_idx: queue index within given TC
  * @qg_buf: queue group buffer
- * @tc: TC that Tx ring belongs to
  */
 int
-ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring, u16 tc_q_idx,
-		struct ice_aqc_add_tx_qgrp *qg_buf, u8 tc)
+ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
+		struct ice_aqc_add_tx_qgrp *qg_buf)
 {
 	struct ice_tlan_ctx tlan_ctx = { 0 };
 	struct ice_aqc_add_txqs_perq *txq;
@@ -536,6 +549,7 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring, u16 tc_q_idx,
 	u8 buf_len = sizeof(*qg_buf);
 	enum ice_status status;
 	u16 pf_q;
+	u8 tc;
 
 	pf_q = ring->reg_idx;
 	ice_setup_tx_ctx(ring, &tlan_ctx, pf_q);
@@ -549,10 +563,15 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring, u16 tc_q_idx,
 	 */
 	ring->tail = pf->hw.hw_addr + QTX_COMM_DBELL(pf_q);
 
+	if (IS_ENABLED(CONFIG_DCB))
+		tc = ring->dcb_tc;
+	else
+		tc = 0;
+
 	/* Add unique software queue handle of the Tx queue per
 	 * TC into the VSI Tx ring
 	 */
-	ring->q_handle = tc_q_idx;
+	ring->q_handle = ice_calc_q_handle(vsi, ring, tc);
 
 	status = ice_ena_vsi_txq(vsi->port_info, vsi->idx, tc, ring->q_handle,
 				 1, qg_buf, buf_len, NULL);
diff --git a/drivers/net/ethernet/intel/ice/ice_base.h b/drivers/net/ethernet/intel/ice/ice_base.h
index db456862b35b..407995e8e944 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.h
+++ b/drivers/net/ethernet/intel/ice/ice_base.h
@@ -13,8 +13,8 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi);
 void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi);
 void ice_vsi_free_q_vectors(struct ice_vsi *vsi);
 int
-ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring, u16 tc_q_idx,
-		struct ice_aqc_add_tx_qgrp *qg_buf, u8 tc);
+ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
+		struct ice_aqc_add_tx_qgrp *qg_buf);
 void ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector);
 void
 ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b6bdf624c6e6..87f890363608 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1225,42 +1225,31 @@ int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
  * ice_vsi_cfg_txqs - Configure the VSI for Tx
  * @vsi: the VSI being configured
  * @rings: Tx ring array to be configured
- * @offset: offset within vsi->txq_map
  *
  * Return 0 on success and a negative value on error
  * Configure the Tx VSI for operation.
  */
 static int
-ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings, int offset)
+ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings)
 {
 	struct ice_aqc_add_tx_qgrp *qg_buf;
-	struct ice_pf *pf = vsi->back;
-	u16 q_idx = 0, i;
+	u16 q_idx = 0;
 	int err = 0;
-	u8 tc;
 
-	qg_buf = devm_kzalloc(&pf->pdev->dev, sizeof(*qg_buf), GFP_KERNEL);
+	qg_buf = kzalloc(sizeof(*qg_buf), GFP_KERNEL);
 	if (!qg_buf)
 		return -ENOMEM;
 
 	qg_buf->num_txqs = 1;
 
-	/* set up and configure the Tx queues for each enabled TC */
-	ice_for_each_traffic_class(tc) {
-		if (!(vsi->tc_cfg.ena_tc & BIT(tc)))
-			break;
-
-		for (i = 0; i < vsi->tc_cfg.tc_info[tc].qcount_tx; i++) {
-			err = ice_vsi_cfg_txq(vsi, rings[q_idx], i + offset,
-					      qg_buf, tc);
-			if (err)
-				goto err_cfg_txqs;
-
-			q_idx++;
-		}
+	for (q_idx = 0; q_idx < vsi->num_txq; q_idx++) {
+		err = ice_vsi_cfg_txq(vsi, rings[q_idx], qg_buf);
+		if (err)
+			goto err_cfg_txqs;
 	}
+
 err_cfg_txqs:
-	devm_kfree(&pf->pdev->dev, qg_buf);
+	kfree(qg_buf);
 	return err;
 }
 
@@ -1273,7 +1262,7 @@ ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings, int offset)
  */
 int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi)
 {
-	return ice_vsi_cfg_txqs(vsi, vsi->tx_rings, 0);
+	return ice_vsi_cfg_txqs(vsi, vsi->tx_rings);
 }
 
 /**
@@ -1463,34 +1452,24 @@ static int
 ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 		      u16 rel_vmvf_num, struct ice_ring **rings)
 {
-	u16 i, q_idx = 0;
-	int status;
-	u8 tc;
+	u16 q_idx;
 
 	if (vsi->num_txq > ICE_LAN_TXQ_MAX_QDIS)
 		return -EINVAL;
 
-	/* set up the Tx queue list to be disabled for each enabled TC */
-	ice_for_each_traffic_class(tc) {
-		if (!(vsi->tc_cfg.ena_tc & BIT(tc)))
-			break;
-
-		for (i = 0; i < vsi->tc_cfg.tc_info[tc].qcount_tx; i++) {
-			struct ice_txq_meta txq_meta = { };
+	for (q_idx = 0; q_idx < vsi->num_txq; q_idx++) {
+		struct ice_txq_meta txq_meta = { };
+		int status;
 
-			if (!rings || !rings[q_idx])
-				return -EINVAL;
+		if (!rings || !rings[q_idx])
+			return -EINVAL;
 
-			ice_fill_txq_meta(vsi, rings[q_idx], &txq_meta);
-			status = ice_vsi_stop_tx_ring(vsi, rst_src,
-						      rel_vmvf_num,
-						      rings[q_idx], &txq_meta);
+		ice_fill_txq_meta(vsi, rings[q_idx], &txq_meta);
+		status = ice_vsi_stop_tx_ring(vsi, rst_src, rel_vmvf_num,
+					      rings[q_idx], &txq_meta);
 
-			if (status)
-				return status;
-
-			q_idx++;
-		}
+		if (status)
+			return status;
 	}
 
 	return 0;
-- 
2.21.0

