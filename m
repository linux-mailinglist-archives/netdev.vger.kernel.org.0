Return-Path: <netdev+bounces-3063-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23E11705530
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4C142815D2
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4468111C96;
	Tue, 16 May 2023 17:44:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4E911C8C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:44:05 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3167DA4
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684259043; x=1715795043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FHIIBw+vO2l6EFuent30Et59RiQtlqB2lNY8sZlDwbc=;
  b=Zv6xvGkm6RromAtBOeMbbfFjbkIucBxKomup96zlmdcC2ljU5X9UOdz2
   /Wvnl6zeeVPqsgjm64t65kAiTbboWG3qr0jRkyMUTwsaXU88cnzkho9Fu
   +ALrIWGWKQMP38X5hmwq0WZqPWkpu1rx9Wub+dA+CYLIo3R2/Iz0T5zWI
   /LgdRJN7s1BMPRv7BssgdhLvacUb5lZKwzhboUMhBc1MA/USN7oav+qsn
   uIq+2Q3Qc9xDzs1ZqK70N/+q7XrTs0FS+mbGgblwMcbzZp8bmmi/6YfwO
   h5G+B3mQvMiNwbcgpwcxf1WZnt42LoYcDM7+GlB5bjvEdjsBO3HIS3oo3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="353831923"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="353831923"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 10:44:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="875733040"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="875733040"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2023 10:44:00 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Piotr Raczynski <piotr.raczynski@intel.com>,
	anthony.l.nguyen@intel.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next v2 2/8] ice: use pci_irq_vector helper function
Date: Tue, 16 May 2023 10:40:15 -0700
Message-Id: <20230516174021.2707029-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230516174021.2707029-1-anthony.l.nguyen@intel.com>
References: <20230516174021.2707029-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Piotr Raczynski <piotr.raczynski@intel.com>

Currently, driver gets interrupt number directly from ice_pf::msix_entries
array. Use helper function dedicated to do just that.

While at it use a variable to store interrupt number in
ice_free_irq_msix_misc instead of calling the helper function twice.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
index 450317dfcca7..79e1557f77e8 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3056,7 +3056,7 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 		u16 vector = i + base;
 		int irq_num;
 
-		irq_num = pf->msix_entries[vector].vector;
+		irq_num = pci_irq_vector(pf->pdev, vector);
 
 		/* free only the irqs that were actually requested */
 		if (!vsi->q_vectors[i] ||
@@ -3235,7 +3235,7 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 		return;
 
 	ice_for_each_q_vector(vsi, i)
-		synchronize_irq(pf->msix_entries[i + base].vector);
+		synchronize_irq(pci_irq_vector(pf->pdev, i + base));
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c377bacc5e2e..c103be660a9c 100644
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


