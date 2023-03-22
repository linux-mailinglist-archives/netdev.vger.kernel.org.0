Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9FF6C5087
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCVQZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjCVQZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:25:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29AB4FF12
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679502336; x=1711038336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gAsQzJ59pmnWmAAC6QxZVDz8YEgx+tQPfsfxFYHtWdE=;
  b=JWH+5SE6CsQv8TPSeCgy8p+JSeURWGJ3mtWZiinnYeC900fGJPLKVD7F
   DggOItpLQvEzk5YlcBH0qGZyXHCNXD7b8iMKxXU7az6QERqpich8kcIIo
   7hMc7H/wItQH33MU2WCK3+Q41Zw1sKQfmSXpPtatlF2wV+inAam1P1CcM
   OS08sOKr/7epSOZSuAEk4e6+aAj3p21GNvExCkROIK72pbSPEX97RC2G0
   TZNkSjfZrwXG5HPNOTZspG435AiOYLd/djqJh78EMniC+uKoqhXnEmOB9
   zW3ZePazyunVRL+vvnDaMihGYOgF0SD7P8Js1zzyKuse23FA+XUiCzmGr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="404151290"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="404151290"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 09:25:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="825462725"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="825462725"
Received: from nimitz.igk.intel.com ([10.102.21.231])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2023 09:25:33 -0700
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, michal.swiatkowski@intel.com,
        shiraz.saleem@intel.com, jacob.e.keller@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        aleksander.lobakin@intel.com, lukasz.czapnik@intel.com,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v2 2/8] ice: use pci_irq_vector helper function
Date:   Wed, 22 Mar 2023 17:25:24 +0100
Message-Id: <20230322162530.3317238-3-piotr.raczynski@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230322162530.3317238-1-piotr.raczynski@intel.com>
References: <20230322162530.3317238-1-piotr.raczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, driver gets interrupt number directly from ice_pf::msix_entries
array. Use helper function dedicated to do just that.

While at it use a variable to store interrupt number in
ice_free_irq_msix_misc instead of calling the helper function twice.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_arfs.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c  |  4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_ptp.c  |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  |  2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
index b38710b2540f..59146e4bdf3b 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
@@ -654,7 +654,7 @@ int ice_set_cpu_rx_rmap(struct ice_vsi *vsi)
 	base_idx = vsi->base_vector;
 	ice_for_each_q_vector(vsi, i)
 		if (irq_cpu_rmap_add(netdev->rx_cpu_rmap,
-				     pf->msix_entries[base_idx + i].vector)) {
+				     pci_irq_vector(pf->pdev, base_idx + i))) {
 			ice_free_cpu_rx_rmap(vsi);
 			return -EINVAL;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8d229011ffc3..a707c0f7ae29 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3058,7 +3058,7 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 		u16 vector = i + base;
 		int irq_num;
 
-		irq_num = pf->msix_entries[vector].vector;
+		irq_num = pci_irq_vector(pf->pdev, vector);
 
 		/* free only the irqs that were actually requested */
 		if (!vsi->q_vectors[i] ||
@@ -3237,7 +3237,7 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 		return;
 
 	ice_for_each_q_vector(vsi, i)
-		synchronize_irq(pf->msix_entries[i + base].vector);
+		synchronize_irq(pci_irq_vector(pf->pdev, i + base));
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6ed5a7a68653..f3032096e5dd 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2539,7 +2539,7 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 	for (vector = 0; vector < q_vectors; vector++) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[vector];
 
-		irq_num = pf->msix_entries[base + vector].vector;
+		irq_num = pci_irq_vector(pf->pdev, base + vector);
 
 		if (q_vector->tx.tx_ring && q_vector->rx.rx_ring) {
 			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
@@ -2595,7 +2595,7 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 free_q_irqs:
 	while (vector) {
 		vector--;
-		irq_num = pf->msix_entries[base + vector].vector;
+		irq_num = pci_irq_vector(pf->pdev, base + vector);
 		if (!IS_ENABLED(CONFIG_RFS_ACCEL))
 			irq_set_affinity_notifier(irq_num, NULL);
 		irq_set_affinity_hint(irq_num, NULL);
@@ -3272,6 +3272,7 @@ static void ice_dis_ctrlq_interrupts(struct ice_hw *hw)
  */
 static void ice_free_irq_msix_misc(struct ice_pf *pf)
 {
+	int misc_irq_num = pci_irq_vector(pf->pdev, pf->oicr_idx);
 	struct ice_hw *hw = &pf->hw;
 
 	ice_dis_ctrlq_interrupts(hw);
@@ -3281,9 +3282,8 @@ static void ice_free_irq_msix_misc(struct ice_pf *pf)
 	ice_flush(hw);
 
 	if (pf->msix_entries) {
-		synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
-		devm_free_irq(ice_pf_to_dev(pf),
-			      pf->msix_entries[pf->oicr_idx].vector, pf);
+		synchronize_irq(misc_irq_num);
+		devm_free_irq(ice_pf_to_dev(pf), misc_irq_num, pf);
 	}
 
 	pf->num_avail_sw_msix += 1;
@@ -3355,7 +3355,7 @@ static int ice_req_irq_msix_misc(struct ice_pf *pf)
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

