Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7991E711E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438026AbgE2AJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:09:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:2082 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437977AbgE2AIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:35 -0400
IronPort-SDR: b6zST9s5TX11US2Mo0RsuvPPRhzWtakBqZnolZ7ZftrQwjczvdhBmlJKilGiraa/Bxlbl9gpyr
 DyXLa/1ByXuw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:34 -0700
IronPort-SDR: W8IwzA8P9Wv83ESniIpVMotJiQjs1Q7PZ1Zu4UND9s+h/QcUZUK4BzQrNbldzGt3cJb4OYLSx+
 9Oo+RF2Ws1/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651631"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] ice: Refactor ice_ena_vf_mappings to split MSIX and queue mappings
Date:   Thu, 28 May 2020 17:08:22 -0700
Message-Id: <20200529000831.2803870-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently ice_ena_vf_mappings() does all of the VF's MSIX and queue
mapping in one function. This makes it hard to digest. Fix this by
creating a new function for enabling MSIX mappings and one for enabling
queue mappings.

Also, rename some variables in the functions for clarity.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 91 ++++++++++++-------
 1 file changed, 59 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index efd54299a220..621ec0cc6fff 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -651,55 +651,70 @@ static int ice_alloc_vf_res(struct ice_vf *vf)
 }
 
 /**
- * ice_ena_vf_mappings
- * @vf: pointer to the VF structure
+ * ice_ena_vf_msix_mappings - enable VF MSIX mappings in hardware
+ * @vf: VF to enable MSIX mappings for
  *
- * Enable VF vectors and queues allocation by writing the details into
- * respective registers.
+ * Some of the registers need to be indexed/configured using hardware global
+ * device values and other registers need 0-based values, which represent PF
+ * based values.
  */
-static void ice_ena_vf_mappings(struct ice_vf *vf)
+static void ice_ena_vf_msix_mappings(struct ice_vf *vf)
 {
-	int abs_vf_id, abs_first, abs_last;
+	int device_based_first_msix, device_based_last_msix;
+	int pf_based_first_msix, pf_based_last_msix, v;
 	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-	struct device *dev;
-	int first, last, v;
+	int device_based_vf_id;
 	struct ice_hw *hw;
 	u32 reg;
 
-	dev = ice_pf_to_dev(pf);
 	hw = &pf->hw;
-	vsi = pf->vsi[vf->lan_vsi_idx];
-	first = vf->first_vector_idx;
-	last = (first + pf->num_msix_per_vf) - 1;
-	abs_first = first + pf->hw.func_caps.common_cap.msix_vector_first_id;
-	abs_last = (abs_first + pf->num_msix_per_vf) - 1;
-	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
-
-	/* VF Vector allocation */
-	reg = (((abs_first << VPINT_ALLOC_FIRST_S) & VPINT_ALLOC_FIRST_M) |
-	       ((abs_last << VPINT_ALLOC_LAST_S) & VPINT_ALLOC_LAST_M) |
-	       VPINT_ALLOC_VALID_M);
+	pf_based_first_msix = vf->first_vector_idx;
+	pf_based_last_msix = (pf_based_first_msix + pf->num_msix_per_vf) - 1;
+
+	device_based_first_msix = pf_based_first_msix +
+		pf->hw.func_caps.common_cap.msix_vector_first_id;
+	device_based_last_msix =
+		(device_based_first_msix + pf->num_msix_per_vf) - 1;
+	device_based_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
+
+	reg = (((device_based_first_msix << VPINT_ALLOC_FIRST_S) &
+		VPINT_ALLOC_FIRST_M) |
+	       ((device_based_last_msix << VPINT_ALLOC_LAST_S) &
+		VPINT_ALLOC_LAST_M) | VPINT_ALLOC_VALID_M);
 	wr32(hw, VPINT_ALLOC(vf->vf_id), reg);
 
-	reg = (((abs_first << VPINT_ALLOC_PCI_FIRST_S)
+	reg = (((device_based_first_msix << VPINT_ALLOC_PCI_FIRST_S)
 		 & VPINT_ALLOC_PCI_FIRST_M) |
-	       ((abs_last << VPINT_ALLOC_PCI_LAST_S) & VPINT_ALLOC_PCI_LAST_M) |
-	       VPINT_ALLOC_PCI_VALID_M);
+	       ((device_based_last_msix << VPINT_ALLOC_PCI_LAST_S) &
+		VPINT_ALLOC_PCI_LAST_M) | VPINT_ALLOC_PCI_VALID_M);
 	wr32(hw, VPINT_ALLOC_PCI(vf->vf_id), reg);
+
 	/* map the interrupts to its functions */
-	for (v = first; v <= last; v++) {
-		reg = (((abs_vf_id << GLINT_VECT2FUNC_VF_NUM_S) &
+	for (v = pf_based_first_msix; v <= pf_based_last_msix; v++) {
+		reg = (((device_based_vf_id << GLINT_VECT2FUNC_VF_NUM_S) &
 			GLINT_VECT2FUNC_VF_NUM_M) |
 		       ((hw->pf_id << GLINT_VECT2FUNC_PF_NUM_S) &
 			GLINT_VECT2FUNC_PF_NUM_M));
 		wr32(hw, GLINT_VECT2FUNC(v), reg);
 	}
 
-	/* Map mailbox interrupt. We put an explicit 0 here to remind us that
-	 * VF admin queue interrupts will go to VF MSI-X vector 0.
-	 */
-	wr32(hw, VPINT_MBX_CTL(abs_vf_id), VPINT_MBX_CTL_CAUSE_ENA_M | 0);
+	/* Map mailbox interrupt to VF MSI-X vector 0 */
+	wr32(hw, VPINT_MBX_CTL(device_based_vf_id), VPINT_MBX_CTL_CAUSE_ENA_M);
+}
+
+/**
+ * ice_ena_vf_q_mappings - enable Rx/Tx queue mappings for a VF
+ * @vf: VF to enable the mappings for
+ * @max_txq: max Tx queues allowed on the VF's VSI
+ * @max_rxq: max Rx queues allowed on the VF's VSI
+ */
+static void ice_ena_vf_q_mappings(struct ice_vf *vf, u16 max_txq, u16 max_rxq)
+{
+	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
+	u32 reg;
+
 	/* set regardless of mapping mode */
 	wr32(hw, VPLAN_TXQ_MAPENA(vf->vf_id), VPLAN_TXQ_MAPENA_TX_ENA_M);
 
@@ -711,7 +726,7 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 		 */
 		reg = (((vsi->txq_map[0] << VPLAN_TX_QBASE_VFFIRSTQ_S) &
 			VPLAN_TX_QBASE_VFFIRSTQ_M) |
-		       (((vsi->alloc_txq - 1) << VPLAN_TX_QBASE_VFNUMQ_S) &
+		       (((max_txq - 1) << VPLAN_TX_QBASE_VFNUMQ_S) &
 			VPLAN_TX_QBASE_VFNUMQ_M));
 		wr32(hw, VPLAN_TX_QBASE(vf->vf_id), reg);
 	} else {
@@ -729,7 +744,7 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 		 */
 		reg = (((vsi->rxq_map[0] << VPLAN_RX_QBASE_VFFIRSTQ_S) &
 			VPLAN_RX_QBASE_VFFIRSTQ_M) |
-		       (((vsi->alloc_txq - 1) << VPLAN_RX_QBASE_VFNUMQ_S) &
+		       (((max_rxq - 1) << VPLAN_RX_QBASE_VFNUMQ_S) &
 			VPLAN_RX_QBASE_VFNUMQ_M));
 		wr32(hw, VPLAN_RX_QBASE(vf->vf_id), reg);
 	} else {
@@ -737,6 +752,18 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 	}
 }
 
+/**
+ * ice_ena_vf_mappings - enable VF MSIX and queue mapping
+ * @vf: pointer to the VF structure
+ */
+static void ice_ena_vf_mappings(struct ice_vf *vf)
+{
+	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+
+	ice_ena_vf_msix_mappings(vf);
+	ice_ena_vf_q_mappings(vf, vsi->alloc_txq, vsi->alloc_rxq);
+}
+
 /**
  * ice_determine_res
  * @pf: pointer to the PF structure
-- 
2.26.2

