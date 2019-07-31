Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEA17CEE8
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbfGaUmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:42:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:2709 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbfGaUlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901047"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/16] ice: Remove unnecessary flag ICE_FLAG_MSIX_ENA
Date:   Wed, 31 Jul 2019 13:41:45 -0700
Message-Id: <20190731204147.8582-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

This flag is not needed and is called every time we re-enable interrupts
in the hotpath so remove it. Also remove ice_vsi_req_irq() because it
was a wrapper function for ice_vsi_req_irq_msix() whose sole purpose was
checking the ICE_FLAG_MSIX_ENA flag.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 -
 drivers/net/ethernet/intel/ice/ice_lib.c  | 71 +++++++++-------------
 drivers/net/ethernet/intel/ice/ice_main.c | 74 ++++++-----------------
 drivers/net/ethernet/intel/ice/ice_txrx.c |  4 +-
 4 files changed, 48 insertions(+), 102 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 596b09a905aa..794d97460fc7 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -329,7 +329,6 @@ struct ice_q_vector {
 } ____cacheline_internodealigned_in_smp;
 
 enum ice_pf_flags {
-	ICE_FLAG_MSIX_ENA,
 	ICE_FLAG_FLTR_SYNC,
 	ICE_FLAG_RSS_ENA,
 	ICE_FLAG_SRIOV_ENA,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 2add10e02280..6e34c40e7840 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1129,12 +1129,7 @@ static int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 		return -EEXIST;
 	}
 
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags)) {
-		num_q_vectors = vsi->num_q_vectors;
-	} else {
-		err = -EINVAL;
-		goto err_out;
-	}
+	num_q_vectors = vsi->num_q_vectors;
 
 	for (v_idx = 0; v_idx < num_q_vectors; v_idx++) {
 		err = ice_vsi_alloc_q_vector(vsi, v_idx);
@@ -1180,9 +1175,6 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 		return -EEXIST;
 	}
 
-	if (!test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
-		return -ENOENT;
-
 	num_q_vectors = vsi->num_q_vectors;
 	/* reserve slots from OS requested IRQs */
 	vsi->base_vector = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
@@ -2605,39 +2597,36 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	int base = vsi->base_vector;
+	int i;
 
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags)) {
-		int i;
-
-		if (!vsi->q_vectors || !vsi->irqs_ready)
-			return;
+	if (!vsi->q_vectors || !vsi->irqs_ready)
+		return;
 
-		ice_vsi_release_msix(vsi);
-		if (vsi->type == ICE_VSI_VF)
-			return;
+	ice_vsi_release_msix(vsi);
+	if (vsi->type == ICE_VSI_VF)
+		return;
 
-		vsi->irqs_ready = false;
-		ice_for_each_q_vector(vsi, i) {
-			u16 vector = i + base;
-			int irq_num;
+	vsi->irqs_ready = false;
+	ice_for_each_q_vector(vsi, i) {
+		u16 vector = i + base;
+		int irq_num;
 
-			irq_num = pf->msix_entries[vector].vector;
+		irq_num = pf->msix_entries[vector].vector;
 
-			/* free only the irqs that were actually requested */
-			if (!vsi->q_vectors[i] ||
-			    !(vsi->q_vectors[i]->num_ring_tx ||
-			      vsi->q_vectors[i]->num_ring_rx))
-				continue;
+		/* free only the irqs that were actually requested */
+		if (!vsi->q_vectors[i] ||
+		    !(vsi->q_vectors[i]->num_ring_tx ||
+		      vsi->q_vectors[i]->num_ring_rx))
+			continue;
 
-			/* clear the affinity notifier in the IRQ descriptor */
-			irq_set_affinity_notifier(irq_num, NULL);
+		/* clear the affinity notifier in the IRQ descriptor */
+		irq_set_affinity_notifier(irq_num, NULL);
 
-			/* clear the affinity_mask in the IRQ descriptor */
-			irq_set_affinity_hint(irq_num, NULL);
-			synchronize_irq(irq_num);
-			devm_free_irq(&pf->pdev->dev, irq_num,
-				      vsi->q_vectors[i]);
-		}
+		/* clear the affinity_mask in the IRQ descriptor */
+		irq_set_affinity_hint(irq_num, NULL);
+		synchronize_irq(irq_num);
+		devm_free_irq(&pf->pdev->dev, irq_num,
+			      vsi->q_vectors[i]);
 	}
 }
 
@@ -2816,15 +2805,13 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 	}
 
 	/* disable each interrupt */
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags)) {
-		ice_for_each_q_vector(vsi, i)
-			wr32(hw, GLINT_DYN_CTL(vsi->q_vectors[i]->reg_idx), 0);
+	ice_for_each_q_vector(vsi, i)
+		wr32(hw, GLINT_DYN_CTL(vsi->q_vectors[i]->reg_idx), 0);
 
-		ice_flush(hw);
+	ice_flush(hw);
 
-		ice_for_each_q_vector(vsi, i)
-			synchronize_irq(pf->msix_entries[i + base].vector);
-	}
+	ice_for_each_q_vector(vsi, i)
+		synchronize_irq(pf->msix_entries[i + base].vector);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e4be9aa79337..8a8f9170e219 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1547,15 +1547,11 @@ static void ice_irq_affinity_release(struct kref __always_unused *ref) {}
  */
 static int ice_vsi_ena_irq(struct ice_vsi *vsi)
 {
-	struct ice_pf *pf = vsi->back;
-	struct ice_hw *hw = &pf->hw;
-
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags)) {
-		int i;
+	struct ice_hw *hw = &vsi->back->hw;
+	int i;
 
-		ice_for_each_q_vector(vsi, i)
-			ice_irq_dynamic_ena(hw, vsi, vsi->q_vectors[i]);
-	}
+	ice_for_each_q_vector(vsi, i)
+		ice_irq_dynamic_ena(hw, vsi, vsi->q_vectors[i]);
 
 	ice_flush(hw);
 	return 0;
@@ -1803,7 +1799,7 @@ static void ice_free_irq_msix_misc(struct ice_pf *pf)
 	wr32(hw, PFINT_OICR_ENA, 0);
 	ice_flush(hw);
 
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags) && pf->msix_entries) {
+	if (pf->msix_entries) {
 		synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
 		devm_free_irq(&pf->pdev->dev,
 			      pf->msix_entries[pf->oicr_idx].vector, pf);
@@ -2229,7 +2225,6 @@ static void ice_deinit_pf(struct ice_pf *pf)
 static void ice_init_pf(struct ice_pf *pf)
 {
 	bitmap_zero(pf->flags, ICE_PF_FLAGS_NBITS);
-	set_bit(ICE_FLAG_MSIX_ENA, pf->flags);
 #ifdef CONFIG_PCI_IOV
 	if (pf->hw.func_caps.common_cap.sr_iov_1_1) {
 		struct ice_hw *hw = &pf->hw;
@@ -2329,7 +2324,6 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 
 exit_err:
 	pf->num_lan_msix = 0;
-	clear_bit(ICE_FLAG_MSIX_ENA, pf->flags);
 	return err;
 }
 
@@ -2342,7 +2336,6 @@ static void ice_dis_msix(struct ice_pf *pf)
 	pci_disable_msix(pf->pdev);
 	devm_kfree(&pf->pdev->dev, pf->msix_entries);
 	pf->msix_entries = NULL;
-	clear_bit(ICE_FLAG_MSIX_ENA, pf->flags);
 }
 
 /**
@@ -2351,8 +2344,7 @@ static void ice_dis_msix(struct ice_pf *pf)
  */
 static void ice_clear_interrupt_scheme(struct ice_pf *pf)
 {
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
-		ice_dis_msix(pf);
+	ice_dis_msix(pf);
 
 	if (pf->irq_tracker) {
 		devm_kfree(&pf->pdev->dev, pf->irq_tracker);
@@ -2368,10 +2360,7 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 {
 	int vectors;
 
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
-		vectors = ice_ena_msix_range(pf);
-	else
-		return -ENODEV;
+	vectors = ice_ena_msix_range(pf);
 
 	if (vectors < 0)
 		return vectors;
@@ -2528,12 +2517,10 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	 * the misc functionality and queue processing is combined in
 	 * the same vector and that gets setup at open.
 	 */
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags)) {
-		err = ice_req_irq_msix_misc(pf);
-		if (err) {
-			dev_err(dev, "setup of misc vector failed: %d\n", err);
-			goto err_init_interrupt_unroll;
-		}
+	err = ice_req_irq_msix_misc(pf);
+	if (err) {
+		dev_err(dev, "setup of misc vector failed: %d\n", err);
+		goto err_init_interrupt_unroll;
 	}
 
 	/* create switch struct for the switch element created by FW on boot */
@@ -3146,10 +3133,7 @@ static int ice_up_complete(struct ice_vsi *vsi)
 	struct ice_pf *pf = vsi->back;
 	int err;
 
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
-		ice_vsi_cfg_msix(vsi);
-	else
-		return -ENOTSUPP;
+	ice_vsi_cfg_msix(vsi);
 
 	/* Enable only Rx rings, Tx rings were enabled by the FW when the
 	 * Tx queue group list was configured and the context bits were
@@ -3609,24 +3593,6 @@ int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
 	return err;
 }
 
-/**
- * ice_vsi_req_irq - Request IRQ from the OS
- * @vsi: The VSI IRQ is being requested for
- * @basename: name for the vector
- *
- * Return 0 on success and a negative value on error
- */
-static int ice_vsi_req_irq(struct ice_vsi *vsi, char *basename)
-{
-	struct ice_pf *pf = vsi->back;
-	int err = -EINVAL;
-
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
-		err = ice_vsi_req_irq_msix(vsi, basename);
-
-	return err;
-}
-
 /**
  * ice_vsi_open - Called when a network interface is made active
  * @vsi: the VSI to open
@@ -3656,7 +3622,7 @@ static int ice_vsi_open(struct ice_vsi *vsi)
 
 	snprintf(int_name, sizeof(int_name) - 1, "%s-%s",
 		 dev_driver_string(&pf->pdev->dev), vsi->netdev->name);
-	err = ice_vsi_req_irq(vsi, int_name);
+	err = ice_vsi_req_irq_msix(vsi, int_name);
 	if (err)
 		goto err_setup_rx;
 
@@ -3893,12 +3859,10 @@ static void ice_rebuild(struct ice_pf *pf)
 	}
 
 	/* start misc vector */
-	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags)) {
-		err = ice_req_irq_msix_misc(pf);
-		if (err) {
-			dev_err(dev, "misc vector setup failed: %d\n", err);
-			goto err_vsi_rebuild;
-		}
+	err = ice_req_irq_msix_misc(pf);
+	if (err) {
+		dev_err(dev, "misc vector setup failed: %d\n", err);
+		goto err_vsi_rebuild;
 	}
 
 	/* restart the VSIs that were rebuilt and running before the reset */
@@ -4295,9 +4259,7 @@ static void ice_tx_timeout(struct net_device *netdev)
 		head = (rd32(hw, QTX_COMM_HEAD(vsi->txq_map[hung_queue])) &
 			QTX_COMM_HEAD_HEAD_M) >> QTX_COMM_HEAD_HEAD_S;
 		/* Read interrupt register */
-		if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
-			val = rd32(hw,
-				   GLINT_DYN_CTL(tx_ring->q_vector->reg_idx));
+		val = rd32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx));
 
 		netdev_info(netdev, "tx_timeout: VSI_num: %d, Q %d, NTC: 0x%x, HW_HEAD: 0x%x, NTU: 0x%x, INT: 0x%x\n",
 			    vsi->vsi_num, hung_queue, tx_ring->next_to_clean,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 020dac283f07..9234fd203929 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1413,7 +1413,6 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	struct ice_q_vector *q_vector =
 				container_of(napi, struct ice_q_vector, napi);
 	struct ice_vsi *vsi = q_vector->vsi;
-	struct ice_pf *pf = vsi->back;
 	bool clean_complete = true;
 	int budget_per_ring = 0;
 	struct ice_ring *ring;
@@ -1454,8 +1453,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	 * poll us due to busy-polling
 	 */
 	if (likely(napi_complete_done(napi, work_done)))
-		if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
-			ice_update_ena_itr(vsi, q_vector);
+		ice_update_ena_itr(vsi, q_vector);
 
 	return min_t(int, work_done, budget - 1);
 }
-- 
2.21.0

