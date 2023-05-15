Return-Path: <netdev+bounces-2748-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D52703D3E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:04:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2C9A2812B4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A59219503;
	Mon, 15 May 2023 19:03:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDD718C30
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:03:33 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B2811A
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684177411; x=1715713411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bXRaV1aiZMGyppP7QXHDkN4Kg3dT8hLklOXXNNK0LM4=;
  b=bmoQ/UuTQ5yJvH09hrQW+c9KCBqEKcF1gpEEqtrofN5zCcQd/ReT7DsF
   oDFFPZNlunOv4JbU3Br8S11w3yKo70OAFjbrPqd6VRUF9j09w2S3qnV3S
   V4v3Rl+vZQoTapltHWPk5uu5lDBmE9KjuQGehinrEeFjr/yy48WP0LwXV
   +0lBi5daUi77EFpuy178zagL4vn6hv0YDFBvIt3CW08lcmLbVGRY7P04i
   UxxQPYjtoTjvsabVB1Xo7EFPdVLsw1aNRE/6WUbY//xCzEJee4ORT6cbP
   dH0wXQLYVsO2WgSnmzarHggNZQG56Csh5gRExNb8ENSCoeU3V9meeFEen
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="354450601"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="354450601"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 12:03:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="766074956"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="766074956"
Received: from nimitz.igk.intel.com ([10.102.21.231])
  by fmsmga008.fm.intel.com with ESMTP; 15 May 2023 12:03:28 -0700
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: intel-wired-lan@osuosl.org
Cc: netdev@vger.kernel.org,
	michal.swiatkowski@intel.com,
	shiraz.saleem@intel.com,
	jacob.e.keller@intel.com,
	sridhar.samudrala@intel.com,
	jesse.brandeburg@intel.com,
	aleksander.lobakin@intel.com,
	lukasz.czapnik@intel.com,
	simon.horman@corigine.com,
	Piotr Raczynski <piotr.raczynski@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH iwl-next v5 2/8] ice: use pci_irq_vector helper function
Date: Mon, 15 May 2023 21:03:13 +0200
Message-Id: <20230515190319.808985-3-piotr.raczynski@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230515190319.808985-1-piotr.raczynski@intel.com>
References: <20230515190319.808985-1-piotr.raczynski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, driver gets interrupt number directly from ice_pf::msix_entries
array. Use helper function dedicated to do just that.

While at it use a variable to store interrupt number in
ice_free_irq_msix_misc instead of calling the helper function twice.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_arfs.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c  |  4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_ptp.c  |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  |  2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
index fba178e07600..e81797344f5e 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
@@ -616,7 +616,7 @@ int ice_set_cpu_rx_rmap(struct ice_vsi *vsi)
 	base_idx = vsi->base_vector;
 	ice_for_each_q_vector(vsi, i)
 		if (irq_cpu_rmap_add(netdev->rx_cpu_rmap,
-				     pf->msix_entries[base_idx + i].vector)) {
+				     pci_irq_vector(pf->pdev, base_idx + i))) {
 			ice_free_cpu_rx_rmap(vsi);
 			return -EINVAL;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 4fa400450827..7459826a99bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3059,7 +3059,7 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 		u16 vector = i + base;
 		int irq_num;
 
-		irq_num = pf->msix_entries[vector].vector;
+		irq_num = pci_irq_vector(pf->pdev, vector);
 
 		/* free only the irqs that were actually requested */
 		if (!vsi->q_vectors[i] ||
@@ -3238,7 +3238,7 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 		return;
 
 	ice_for_each_q_vector(vsi, i)
-		synchronize_irq(pf->msix_entries[i + base].vector);
+		synchronize_irq(pci_irq_vector(pf->pdev, i + base));
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a8bf099cf5c4..1e3b2821fdc3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2501,7 +2501,7 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 	for (vector = 0; vector < q_vectors; vector++) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[vector];
 
-		irq_num = pf->msix_entries[base + vector].vector;
+		irq_num = pci_irq_vector(pf->pdev, base + vector);
 
 		if (q_vector->tx.tx_ring && q_vector->rx.rx_ring) {
 			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
@@ -2557,7 +2557,7 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 free_q_irqs:
 	while (vector) {
 		vector--;
-		irq_num = pf->msix_entries[base + vector].vector;
+		irq_num = pci_irq_vector(pf->pdev, base + vector);
 		if (!IS_ENABLED(CONFIG_RFS_ACCEL))
 			irq_set_affinity_notifier(irq_num, NULL);
 		irq_set_affinity_hint(irq_num, NULL);
@@ -3234,6 +3234,7 @@ static void ice_dis_ctrlq_interrupts(struct ice_hw *hw)
  */
 static void ice_free_irq_msix_misc(struct ice_pf *pf)
 {
+	int misc_irq_num = pci_irq_vector(pf->pdev, pf->oicr_idx);
 	struct ice_hw *hw = &pf->hw;
 
 	ice_dis_ctrlq_interrupts(hw);
@@ -3243,9 +3244,8 @@ static void ice_free_irq_msix_misc(struct ice_pf *pf)
 	ice_flush(hw);
 
 	if (pf->msix_entries) {
-		synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
-		devm_free_irq(ice_pf_to_dev(pf),
-			      pf->msix_entries[pf->oicr_idx].vector, pf);
+		synchronize_irq(misc_irq_num);
+		devm_free_irq(ice_pf_to_dev(pf), misc_irq_num, pf);
 	}
 
 	pf->num_avail_sw_msix += 1;
@@ -3317,7 +3317,7 @@ static int ice_req_irq_msix_misc(struct ice_pf *pf)
 	pf->oicr_idx = (u16)oicr_idx;
 
 	err = devm_request_threaded_irq(dev,
-					pf->msix_entries[pf->oicr_idx].vector,
+					pci_irq_vector(pf->pdev, pf->oicr_idx),
 					ice_misc_intr, ice_misc_intr_thread_fn,
 					0, pf->int_name, pf);
 	if (err) {
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ac6f06f9a2ed..972d4f6fd615 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -911,7 +911,7 @@ ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 	spin_unlock(&tx->lock);
 
 	/* wait for potentially outstanding interrupt to complete */
-	synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
+	synchronize_irq(pci_irq_vector(pf->pdev, pf->oicr_idx));
 
 	ice_ptp_flush_tx_tracker(pf, tx);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index d1e489da7363..4102416d7a41 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -107,7 +107,7 @@ ice_qvec_dis_irq(struct ice_vsi *vsi, struct ice_rx_ring *rx_ring,
 
 		wr32(hw, GLINT_DYN_CTL(q_vector->reg_idx), 0);
 		ice_flush(hw);
-		synchronize_irq(pf->msix_entries[v_idx + base].vector);
+		synchronize_irq(pci_irq_vector(pf->pdev, v_idx + base));
 	}
 }
 
-- 
2.38.1


