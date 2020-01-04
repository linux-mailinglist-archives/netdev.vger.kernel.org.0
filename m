Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630D2130039
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbgADCt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:49:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:64696 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbgADCt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757865"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/16] ice: Restore interrupt throttle settings after VSI rebuild
Date:   Fri,  3 Jan 2020 18:49:43 -0800
Message-Id: <20200104024953.2336731-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

After each rebuild driver deallocates q_vectors, so the interrupt
throttle rate (ITR) settings get lost.

Create a function to save and restore ITR for each queue. If a user
increases the number of queues, restore all the previous queue
settings for each existing queue, and the additional queues will
get the default setting.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 102 ++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.h |   6 ++
 2 files changed, 108 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b5cd275606bb..4cfad81ba496 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2403,6 +2403,97 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	return 0;
 }
 
+/**
+ * ice_vsi_rebuild_update_coalesce - set coalesce for a q_vector
+ * @q_vector: pointer to q_vector which is being updated
+ * @coalesce: pointer to array of struct with stored coalesce
+ *
+ * Set coalesce param in q_vector and update these parameters in HW.
+ */
+static void
+ice_vsi_rebuild_update_coalesce(struct ice_q_vector *q_vector,
+				struct ice_coalesce_stored *coalesce)
+{
+	struct ice_ring_container *rx_rc = &q_vector->rx;
+	struct ice_ring_container *tx_rc = &q_vector->tx;
+	struct ice_hw *hw = &q_vector->vsi->back->hw;
+
+	tx_rc->itr_setting = coalesce->itr_tx;
+	rx_rc->itr_setting = coalesce->itr_rx;
+
+	/* dynamic ITR values will be updated during Tx/Rx */
+	if (!ITR_IS_DYNAMIC(tx_rc->itr_setting))
+		wr32(hw, GLINT_ITR(tx_rc->itr_idx, q_vector->reg_idx),
+		     ITR_REG_ALIGN(tx_rc->itr_setting) >>
+		     ICE_ITR_GRAN_S);
+	if (!ITR_IS_DYNAMIC(rx_rc->itr_setting))
+		wr32(hw, GLINT_ITR(rx_rc->itr_idx, q_vector->reg_idx),
+		     ITR_REG_ALIGN(rx_rc->itr_setting) >>
+		     ICE_ITR_GRAN_S);
+
+	q_vector->intrl = coalesce->intrl;
+	wr32(hw, GLINT_RATE(q_vector->reg_idx),
+	     ice_intrl_usec_to_reg(q_vector->intrl, hw->intrl_gran));
+}
+
+/**
+ * ice_vsi_rebuild_get_coalesce - get coalesce from all q_vectors
+ * @vsi: VSI connected with q_vectors
+ * @coalesce: array of struct with stored coalesce
+ *
+ * Returns array size.
+ */
+static int
+ice_vsi_rebuild_get_coalesce(struct ice_vsi *vsi,
+			     struct ice_coalesce_stored *coalesce)
+{
+	int i;
+
+	ice_for_each_q_vector(vsi, i) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[i];
+
+		coalesce[i].itr_tx = q_vector->tx.itr_setting;
+		coalesce[i].itr_rx = q_vector->rx.itr_setting;
+		coalesce[i].intrl = q_vector->intrl;
+	}
+
+	return vsi->num_q_vectors;
+}
+
+/**
+ * ice_vsi_rebuild_set_coalesce - set coalesce from earlier saved arrays
+ * @vsi: VSI connected with q_vectors
+ * @coalesce: pointer to array of struct with stored coalesce
+ * @size: size of coalesce array
+ *
+ * Before this function, ice_vsi_rebuild_get_coalesce should be called to save
+ * ITR params in arrays. If size is 0 or coalesce wasn't stored set coalesce
+ * to default value.
+ */
+static void
+ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
+			     struct ice_coalesce_stored *coalesce, int size)
+{
+	int i;
+
+	if ((size && !coalesce) || !vsi)
+		return;
+
+	for (i = 0; i < size && i < vsi->num_q_vectors; i++)
+		ice_vsi_rebuild_update_coalesce(vsi->q_vectors[i],
+						&coalesce[i]);
+
+	for (; i < vsi->num_q_vectors; i++) {
+		struct ice_coalesce_stored coalesce_dflt = {
+			.itr_tx = ICE_DFLT_TX_ITR,
+			.itr_rx = ICE_DFLT_RX_ITR,
+			.intrl = 0
+		};
+		ice_vsi_rebuild_update_coalesce(vsi->q_vectors[i],
+						&coalesce_dflt);
+	}
+}
+
 /**
  * ice_vsi_rebuild - Rebuild VSI after reset
  * @vsi: VSI to be rebuild
@@ -2413,6 +2504,8 @@ int ice_vsi_release(struct ice_vsi *vsi)
 int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
+	struct ice_coalesce_stored *coalesce;
+	int prev_num_q_vectors = 0;
 	struct ice_vf *vf = NULL;
 	enum ice_status status;
 	struct ice_pf *pf;
@@ -2425,6 +2518,11 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	if (vsi->type == ICE_VSI_VF)
 		vf = &pf->vf[vsi->vf_id];
 
+	coalesce = kcalloc(vsi->num_q_vectors,
+			   sizeof(struct ice_coalesce_stored), GFP_KERNEL);
+	if (coalesce)
+		prev_num_q_vectors = ice_vsi_rebuild_get_coalesce(vsi,
+								  coalesce);
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	ice_vsi_free_q_vectors(vsi);
 
@@ -2537,6 +2635,9 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 			return ice_schedule_reset(pf, ICE_RESET_PFR);
 		}
 	}
+	ice_vsi_rebuild_set_coalesce(vsi, coalesce, prev_num_q_vectors);
+	kfree(coalesce);
+
 	return 0;
 
 err_vectors:
@@ -2551,6 +2652,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 err_vsi:
 	ice_vsi_clear(vsi);
 	set_bit(__ICE_RESET_FAILED, pf->state);
+	kfree(coalesce);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index a84cc0e6dd27..a86270696df1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -341,6 +341,12 @@ struct ice_ring_container {
 	u16 itr_setting;
 };
 
+struct ice_coalesce_stored {
+	u16 itr_tx;
+	u16 itr_rx;
+	u8 intrl;
+};
+
 /* iterator for handling rings in ring container */
 #define ice_for_each_ring(pos, head) \
 	for (pos = (head).ring; pos; pos = pos->next)
-- 
2.24.1

