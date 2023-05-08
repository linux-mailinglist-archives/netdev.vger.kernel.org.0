Return-Path: <netdev+bounces-862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 869926FB07D
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A02881C209C9
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DEAE193;
	Mon,  8 May 2023 12:43:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8DF257E
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:43:50 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A5B72BE
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 05:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683549828; x=1715085828;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4aKcVSAIuqqZ38XOHxYuf7wLT3ZVlUbkHE0wfkHGrqg=;
  b=T0A72nrLgcxG47AQQYQ5i+N3A7z8Yn4gQCTvzAvpfmM1CtvAUI74gpei
   Zzsp8w0yDV0bzljHM8TGBmXI6YbTloBZeOLVobfn8RuvdCw5m0YSQYRSL
   xSEfEckLXUEO3hCN1fbbb3kO6Hidp4UjKgryEIDXwRhUoClk0Ur/0tYlD
   G4zRAHw5WK0ohS0h5+jg7Cun36y1Lf1niUanZA7V+g2zdoKv0BXuHa33f
   asxKNZ6IISQXVrDA1DfxK8p/JawkG+I0R8wujNAND9HavcUekXYZvmBjH
   RC7xJOutAwgwQqRrFmGcydm8dOA9UQaEIZWctQh5lyKWeA6AwvwMfr6y6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="349665169"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="349665169"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 05:43:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="676048013"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="676048013"
Received: from nimitz.igk.intel.com ([10.102.21.231])
  by orsmga006.jf.intel.com with ESMTP; 08 May 2023 05:43:44 -0700
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
Subject: [PATCH net-next v4 7/8] ice: track interrupt vectors with xarray
Date: Mon,  8 May 2023 14:43:20 +0200
Message-Id: <20230508124321.2927867-8-piotr.raczynski@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230508124321.2927867-1-piotr.raczynski@intel.com>
References: <20230508124321.2927867-1-piotr.raczynski@intel.com>
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

Replace custom interrupt tracker with generic xarray data structure.
Remove all code responsible for searching for a new entry with xa_alloc,
which always tries to allocate at the lowes possible index. As a result
driver is always using a contiguous region of the MSIX vector table.

New tracker keeps ice_irq_entry entries in xarray as opaque for the rest
of the driver hiding the entry details from the caller.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h       |   9 +-
 drivers/net/ethernet/intel/ice/ice_irq.c   | 101 ++++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_irq.h   |   9 ++
 drivers/net/ethernet/intel/ice/ice_lib.c   |  45 ---------
 drivers/net/ethernet/intel/ice/ice_lib.h   |   5 -
 drivers/net/ethernet/intel/ice/ice_sriov.c |   4 +-
 6 files changed, 89 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 56ea4438846d..42236f315bcb 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -105,7 +105,6 @@
 #define ICE_Q_WAIT_RETRY_LIMIT	10
 #define ICE_Q_WAIT_MAX_RETRY	(5 * ICE_Q_WAIT_RETRY_LIMIT)
 #define ICE_MAX_LG_RSS_QS	256
-#define ICE_RES_VALID_BIT	0x8000
 #define ICE_INVAL_Q_INDEX	0xffff
 
 #define ICE_MAX_RXQS_PER_TC		256	/* Used when setting VSI context per TC Rx queues */
@@ -243,12 +242,6 @@ struct ice_tc_cfg {
 	struct ice_tc_info tc_info[ICE_MAX_TRAFFIC_CLASS];
 };
 
-struct ice_res_tracker {
-	u16 num_entries;
-	u16 end;
-	u16 list[];
-};
-
 struct ice_qs_cfg {
 	struct mutex *qs_mutex;  /* will be assigned to &pf->avail_q_mutex */
 	unsigned long *pf_map;
@@ -537,7 +530,7 @@ struct ice_pf {
 
 	/* OS reserved IRQ details */
 	struct msix_entry *msix_entries;
-	struct ice_res_tracker *irq_tracker;
+	struct ice_irq_tracker irq_tracker;
 	/* First MSIX vector used by SR-IOV VFs. Calculated by subtracting the
 	 * number of MSIX vectors needed for all SR-IOV VFs from the number of
 	 * MSIX vectors allowed on this PF.
diff --git a/drivers/net/ethernet/intel/ice/ice_irq.c b/drivers/net/ethernet/intel/ice/ice_irq.c
index ca1a1de26766..1713347c577f 100644
--- a/drivers/net/ethernet/intel/ice/ice_irq.c
+++ b/drivers/net/ethernet/intel/ice/ice_irq.c
@@ -5,6 +5,75 @@
 #include "ice_lib.h"
 #include "ice_irq.h"
 
+/**
+ * ice_init_irq_tracker - initialize interrupt tracker
+ * @pf: board private structure
+ * @max_vectors: maximum number of vectors that tracker can hold
+ */
+static void
+ice_init_irq_tracker(struct ice_pf *pf, unsigned int max_vectors)
+{
+	pf->irq_tracker.num_entries = max_vectors;
+	xa_init_flags(&pf->irq_tracker.entries, XA_FLAGS_ALLOC);
+}
+
+/**
+ * ice_deinit_irq_tracker - free xarray tracker
+ * @pf: board private structure
+ */
+static void ice_deinit_irq_tracker(struct ice_pf *pf)
+{
+	xa_destroy(&pf->irq_tracker.entries);
+}
+
+/**
+ * ice_free_irq_res - free a block of resources
+ * @pf: board private structure
+ * @index: starting index previously returned by ice_get_res
+ */
+static void ice_free_irq_res(struct ice_pf *pf, u16 index)
+{
+	struct ice_irq_entry *entry;
+
+	entry = xa_erase(&pf->irq_tracker.entries, index);
+	kfree(entry);
+}
+
+/**
+ * ice_get_irq_res - get an interrupt resource
+ * @pf: board private structure
+ *
+ * Allocate new irq entry in the free slot of the tracker. Since xarray
+ * is used, always allocate new entry at the lowest possible index. Set
+ * proper allocation limit for maximum tracker entries.
+ *
+ * Returns allocated irq entry or NULL on failure.
+ */
+static struct ice_irq_entry *ice_get_irq_res(struct ice_pf *pf)
+{
+	struct xa_limit limit = { .max = pf->irq_tracker.num_entries,
+				  .min = 0 };
+	struct ice_irq_entry *entry;
+	unsigned int index;
+	int ret;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return NULL;
+
+	ret = xa_alloc(&pf->irq_tracker.entries, &index, entry, limit,
+		       GFP_KERNEL);
+
+	if (ret) {
+		kfree(entry);
+		entry = NULL;
+	} else {
+		entry->index = index;
+	}
+
+	return entry;
+}
+
 /**
  * ice_reduce_msix_usage - Reduce usage of MSI-X vectors
  * @pf: board private structure
@@ -163,11 +232,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 void ice_clear_interrupt_scheme(struct ice_pf *pf)
 {
 	pci_free_irq_vectors(pf->pdev);
-
-	if (pf->irq_tracker) {
-		devm_kfree(ice_pf_to_dev(pf), pf->irq_tracker);
-		pf->irq_tracker = NULL;
-	}
+	ice_deinit_irq_tracker(pf);
 }
 
 /**
@@ -183,19 +248,7 @@ int ice_init_interrupt_scheme(struct ice_pf *pf)
 	if (vectors < 0)
 		return vectors;
 
-	/* set up vector assignment tracking */
-	pf->irq_tracker = devm_kzalloc(ice_pf_to_dev(pf),
-				       struct_size(pf->irq_tracker, list,
-						   vectors),
-				       GFP_KERNEL);
-	if (!pf->irq_tracker) {
-		pci_free_irq_vectors(pf->pdev);
-		return -ENOMEM;
-	}
-
-	/* populate SW interrupts pool with number of OS granted IRQs. */
-	pf->irq_tracker->num_entries = (u16)vectors;
-	pf->irq_tracker->end = pf->irq_tracker->num_entries;
+	ice_init_irq_tracker(pf, vectors);
 
 	return 0;
 }
@@ -221,13 +274,13 @@ int ice_init_interrupt_scheme(struct ice_pf *pf)
 struct msi_map ice_alloc_irq(struct ice_pf *pf)
 {
 	struct msi_map map = { .index = -ENOENT };
-	int entry;
+	struct ice_irq_entry *entry;
 
-	entry = ice_get_res(pf, pf->irq_tracker);
-	if (entry < 0)
+	entry = ice_get_irq_res(pf);
+	if (!entry)
 		return map;
 
-	map.index = entry;
+	map.index = entry->index;
 	map.virq = pci_irq_vector(pf->pdev, map.index);
 
 	return map;
@@ -238,9 +291,9 @@ struct msi_map ice_alloc_irq(struct ice_pf *pf)
  * @pf: board private structure
  * @map: map with interrupt details
  *
- * Remove allocated interrupt from the interrupt tracker
+ * Remove allocated interrupt from the interrupt tracker.
  */
 void ice_free_irq(struct ice_pf *pf, struct msi_map map)
 {
-	ice_free_res(pf->irq_tracker, map.index);
+	ice_free_irq_res(pf, map.index);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_irq.h b/drivers/net/ethernet/intel/ice/ice_irq.h
index 26e80dfe22b5..da5cdb1f0d3a 100644
--- a/drivers/net/ethernet/intel/ice/ice_irq.h
+++ b/drivers/net/ethernet/intel/ice/ice_irq.h
@@ -4,6 +4,15 @@
 #ifndef _ICE_IRQ_H_
 #define _ICE_IRQ_H_
 
+struct ice_irq_entry {
+	unsigned int index;
+};
+
+struct ice_irq_tracker {
+	struct xarray entries;
+	u16 num_entries;	/* total vectors available */
+};
+
 int ice_init_interrupt_scheme(struct ice_pf *pf);
 void ice_clear_interrupt_scheme(struct ice_pf *pf);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 3bf3cfab0b3e..d9731476cd7f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1370,51 +1370,6 @@ static int ice_vsi_init(struct ice_vsi *vsi, u32 vsi_flags)
 	return ret;
 }
 
-/**
- * ice_free_res - free a block of resources
- * @res: pointer to the resource
- * @index: starting index previously returned by ice_get_res
- *
- * Returns number of resources freed
- */
-int ice_free_res(struct ice_res_tracker *res, u16 index)
-{
-	if (!res || index >= res->end)
-		return -EINVAL;
-
-	res->list[index] = 0;
-
-	return 0;
-}
-
-/**
- * ice_get_res - get a resource from the tracker
- * @pf: board private structure
- * @res: pointer to the resource
- *
- * Returns the item index, or negative for error
- */
-int
-ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res)
-{
-	u16 i;
-
-	if (!res || !pf)
-		return -EINVAL;
-
-	/* skip already allocated entries */
-	for (i = 0; i < res->end; i++)
-		if (!(res->list[i] & ICE_RES_VALID_BIT))
-			break;
-
-	if (i < res->end) {
-		res->list[i] = ICE_RES_VALID_BIT;
-		return i;
-	} else {
-		return -ENOMEM;
-	}
-}
-
 /**
  * ice_vsi_clear_rings - Deallocates the Tx and Rx rings for VSI
  * @vsi: the VSI having rings deallocated
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 2f52f9e32858..e985766e6bb5 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -104,11 +104,6 @@ int ice_ena_vsi(struct ice_vsi *vsi, bool locked);
 void ice_vsi_decfg(struct ice_vsi *vsi);
 void ice_dis_vsi(struct ice_vsi *vsi, bool locked);
 
-int ice_free_res(struct ice_res_tracker *res, u16 index);
-
-int
-ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res);
-
 int ice_vsi_rebuild(struct ice_vsi *vsi, u32 vsi_flags);
 int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 6f3c3ba0ba41..68b7f6f0bb6b 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -418,7 +418,7 @@ int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector)
 static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
 {
 	u16 total_vectors = pf->hw.func_caps.common_cap.num_msix_vectors;
-	int vectors_used = pf->irq_tracker->num_entries;
+	int vectors_used = pf->irq_tracker.num_entries;
 	int sriov_base_vector;
 
 	sriov_base_vector = total_vectors - num_msix_needed;
@@ -470,7 +470,7 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 
 	/* determine MSI-X resources per VF */
 	msix_avail_for_sriov = pf->hw.func_caps.common_cap.num_msix_vectors -
-		pf->irq_tracker->num_entries;
+		pf->irq_tracker.num_entries;
 	msix_avail_per_vf = msix_avail_for_sriov / num_vfs;
 	if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_MED) {
 		num_msix_per_vf = ICE_NUM_VF_MSIX_MED;
-- 
2.38.1


