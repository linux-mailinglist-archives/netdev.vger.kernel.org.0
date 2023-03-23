Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8316C6830
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjCWMZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbjCWMYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:24:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F9C27D73
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679574286; x=1711110286;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7U5qnF3r8pR+uKKqTb2lm1RrXca4U8WD0rL2rksVtbU=;
  b=M+9/iMsXjnLCgtl7/onOwcyB+KBRuVRkG621tyXF3Z/87cOBfOBmFLLz
   i3fIbFYfehKKlp+hFHfPfhqqNTNU9Maik55vJCUw9PxMOpKSlHkkt3OjE
   9JnV/H6cTAN0hr3IT8YW4WYTsMES56zT5nRkqvL4ARv7kED8iYlvoUPCT
   ZBD6wHr6iGXHjiB8GTJIwnEqEYXyvZ0Qv3I/Q6eH8jLX6C/mvpD4N8gSP
   xFZ2K+SFE7x0/GmAwljeSLwuyoic+XgiiNwIgL3uNu20jL20QXp8+snwc
   GdOXFIfBYc2v5rgvw3ppH0+t/v68tiJ0TwUhH+R3LZt/BWU/XyA/421hz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="319125422"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="319125422"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 05:24:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="751473446"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="751473446"
Received: from nimitz.igk.intel.com ([10.102.21.231])
  by fmsmga004.fm.intel.com with ESMTP; 23 Mar 2023 05:24:44 -0700
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, michal.swiatkowski@intel.com,
        shiraz.saleem@intel.com, jacob.e.keller@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        aleksander.lobakin@intel.com, lukasz.czapnik@intel.com,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v3 3/8] ice: use preferred MSIX allocation api
Date:   Thu, 23 Mar 2023 13:24:35 +0100
Message-Id: <20230323122440.3419214-4-piotr.raczynski@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230323122440.3419214-1-piotr.raczynski@intel.com>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move away from using pci_enable_msix_range/pci_disable_msix and use
pci_alloc_irq_vectors/pci_free_irq_vectors instead.

As a result stop tracking msix_entries since with newer API entries are
handled by MSIX core. However, due to current design of communication
with RDMA driver which accesses ice_pf::msix_entries directly, keep
using the array just for RDMA driver use.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_idc.c  | 29 ++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_irq.c  | 40 +++++------------------
 drivers/net/ethernet/intel/ice/ice_main.c |  6 ++--
 3 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index e6bc2285071e..1000759505d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -235,14 +235,33 @@ EXPORT_SYMBOL_GPL(ice_get_qos_params);
 static int ice_reserve_rdma_qvector(struct ice_pf *pf)
 {
 	if (ice_is_rdma_ena(pf)) {
-		int index;
+		int index, i;
 
 		index = ice_get_res(pf, pf->irq_tracker, pf->num_rdma_msix,
 				    ICE_RES_RDMA_VEC_ID);
 		if (index < 0)
 			return index;
+
+		pf->msix_entries = kcalloc(pf->num_rdma_msix,
+					   sizeof(*pf->msix_entries),
+						  GFP_KERNEL);
+		if (!pf->msix_entries) {
+			ice_free_res(pf->irq_tracker, pf->rdma_base_vector,
+				     ICE_RES_RDMA_VEC_ID);
+			return -ENOMEM;
+		}
+
 		pf->num_avail_sw_msix -= pf->num_rdma_msix;
-		pf->rdma_base_vector = (u16)index;
+
+		/* RDMA is the only user of pf->msix_entries array */
+		pf->rdma_base_vector = 0;
+
+		for (i = 0; i < pf->num_rdma_msix; i++, index++) {
+			struct msix_entry *entry = &pf->msix_entries[i];
+
+			entry->entry = index;
+			entry->vector = pci_irq_vector(pf->pdev, index);
+		}
 	}
 	return 0;
 }
@@ -253,6 +272,12 @@ static int ice_reserve_rdma_qvector(struct ice_pf *pf)
  */
 static void ice_free_rdma_qvector(struct ice_pf *pf)
 {
+	if (!pf->msix_entries)
+		return;
+
+	kfree(pf->msix_entries);
+	pf->msix_entries = NULL;
+
 	pf->num_avail_sw_msix -= pf->num_rdma_msix;
 	ice_free_res(pf->irq_tracker, pf->rdma_base_vector,
 		     ICE_RES_RDMA_VEC_ID);
diff --git a/drivers/net/ethernet/intel/ice/ice_irq.c b/drivers/net/ethernet/intel/ice/ice_irq.c
index 1fc7daec9732..f61be5d76373 100644
--- a/drivers/net/ethernet/intel/ice/ice_irq.c
+++ b/drivers/net/ethernet/intel/ice/ice_irq.c
@@ -59,7 +59,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 {
 	int num_cpus, hw_num_msix, v_other, v_wanted, v_actual;
 	struct device *dev = ice_pf_to_dev(pf);
-	int err, i;
+	int err;
 
 	hw_num_msix = pf->hw.func_caps.common_cap.num_msix_vectors;
 	num_cpus = num_online_cpus();
@@ -113,23 +113,13 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 				   pf->num_rdma_msix);
 	}
 
-	pf->msix_entries = devm_kcalloc(dev, v_wanted,
-					sizeof(*pf->msix_entries), GFP_KERNEL);
-	if (!pf->msix_entries) {
-		err = -ENOMEM;
-		goto exit_err;
-	}
-
-	for (i = 0; i < v_wanted; i++)
-		pf->msix_entries[i].entry = i;
-
 	/* actually reserve the vectors */
-	v_actual = pci_enable_msix_range(pf->pdev, pf->msix_entries,
-					 ICE_MIN_MSIX, v_wanted);
+	v_actual = pci_alloc_irq_vectors(pf->pdev, ICE_MIN_MSIX, v_wanted,
+					 PCI_IRQ_MSIX);
 	if (v_actual < 0) {
 		dev_err(dev, "unable to reserve MSI-X vectors\n");
 		err = v_actual;
-		goto msix_err;
+		goto exit_err;
 	}
 
 	if (v_actual < v_wanted) {
@@ -138,9 +128,9 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 
 		if (v_actual < ICE_MIN_MSIX) {
 			/* error if we can't get minimum vectors */
-			pci_disable_msix(pf->pdev);
+			pci_free_irq_vectors(pf->pdev);
 			err = -ERANGE;
-			goto msix_err;
+			goto exit_err;
 		} else {
 			int v_remain = v_actual - v_other;
 
@@ -160,33 +150,19 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 
 	return v_actual;
 
-msix_err:
-	devm_kfree(dev, pf->msix_entries);
-
 exit_err:
 	pf->num_rdma_msix = 0;
 	pf->num_lan_msix = 0;
 	return err;
 }
 
-/**
- * ice_dis_msix - Disable MSI-X interrupt setup in OS
- * @pf: board private structure
- */
-static void ice_dis_msix(struct ice_pf *pf)
-{
-	pci_disable_msix(pf->pdev);
-	devm_kfree(ice_pf_to_dev(pf), pf->msix_entries);
-	pf->msix_entries = NULL;
-}
-
 /**
  * ice_clear_interrupt_scheme - Undo things done by ice_init_interrupt_scheme
  * @pf: board private structure
  */
 void ice_clear_interrupt_scheme(struct ice_pf *pf)
 {
-	ice_dis_msix(pf);
+	pci_free_irq_vectors(pf->pdev);
 
 	if (pf->irq_tracker) {
 		devm_kfree(ice_pf_to_dev(pf), pf->irq_tracker);
@@ -213,7 +189,7 @@ int ice_init_interrupt_scheme(struct ice_pf *pf)
 						   vectors),
 				       GFP_KERNEL);
 	if (!pf->irq_tracker) {
-		ice_dis_msix(pf);
+		pci_free_irq_vectors(pf->pdev);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f3032096e5dd..9ccb6092b937 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3281,10 +3281,8 @@ static void ice_free_irq_msix_misc(struct ice_pf *pf)
 	wr32(hw, PFINT_OICR_ENA, 0);
 	ice_flush(hw);
 
-	if (pf->msix_entries) {
-		synchronize_irq(misc_irq_num);
-		devm_free_irq(ice_pf_to_dev(pf), misc_irq_num, pf);
-	}
+	synchronize_irq(misc_irq_num);
+	devm_free_irq(ice_pf_to_dev(pf), misc_irq_num, pf);
 
 	pf->num_avail_sw_msix += 1;
 	ice_free_res(pf->irq_tracker, pf->oicr_idx, ICE_RES_MISC_VEC_ID);
-- 
2.38.1

