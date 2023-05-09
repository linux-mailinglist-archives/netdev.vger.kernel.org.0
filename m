Return-Path: <netdev+bounces-1228-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3036FCC5B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF64E1C20C7C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8122717ADB;
	Tue,  9 May 2023 17:06:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E993F9E3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:06:32 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5866C46B5
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683651974; x=1715187974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3zafn5xi1VndVcys9CwaY/uKnLoYeQ1+V8IMSfgyqao=;
  b=a42nkRRmdzwzGFPYZXCH/POdgBQAVte/yzJQJJLXMbbjvClMtKi1+CL1
   LMRMi10WylybIz6h/hg+KXBR61qsiKKaTKp6bAt9lISx9vk+Z/kbz+yKv
   beJ/kAeVxI94smxWhuoM6wfAHnqNs+LWMcWyzYMtMvecpgELBBk1a7LpR
   +UiAd+iYKe5V64TpNkCzdxE1QAaEFkV4PHIokcNNOMF4CaF2ySR2S6IrM
   Tti/ls3dfsQjGtGM1wHwYJ2vcUV04SN1YsXibZWVnDSNCv2GeH5H7P5+Y
   W8mL9VsBAxzZCSfmme66ZDKGCub0hInnfUqVCbv2IkJ5JSjj/Ea0f7Yjz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="350023337"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="350023337"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:04:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="649409452"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="649409452"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 09 May 2023 10:04:13 -0700
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
Subject: [PATCH net-next 8/8] ice: add dynamic interrupt allocation
Date: Tue,  9 May 2023 10:00:48 -0700
Message-Id: <20230509170048.2235678-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230509170048.2235678-1-anthony.l.nguyen@intel.com>
References: <20230509170048.2235678-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Piotr Raczynski <piotr.raczynski@intel.com>

Currently driver can only allocate interrupt vectors during init phase by
calling pci_alloc_irq_vectors. Change that and make use of new
pci_msix_alloc_irq_at/pci_msix_free_irq API and enable to allocate and free
more interrupts after MSIX has been enabled. Since not all platforms
supports dynamic allocation, check it with pci_msix_can_alloc_dyn.

Extend the tracker to keep track how many interrupts are allocated
initially so when all such vectors are already used, additional interrupts
are automatically allocated dynamically. Remember each interrupt allocation
method to then free appropriately. Since some features may require
interrupts allocated dynamically add appropriate VSI flag and take it into
account when allocating new interrupt.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h       |   3 +
 drivers/net/ethernet/intel/ice/ice_base.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_idc.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_irq.c   | 109 ++++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_irq.h   |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c |   5 +-
 7 files changed, 107 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 8541d986ec7f..d637032c8139 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -338,6 +338,9 @@ struct ice_vsi {
 	u32 rx_buf_failed;
 	u32 rx_page_failed;
 	u16 num_q_vectors;
+	/* tell if only dynamic irq allocation is allowed */
+	bool irq_dyn_alloc;
+
 	enum ice_vsi_type type;
 	u16 vsi_num;			/* HW (absolute) index of this VSI */
 	u16 idx;			/* software index in pf->vsi[] */
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 7dd7a0f32471..998dc7d81e51 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -133,7 +133,7 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
 		}
 	}
 
-	q_vector->irq = ice_alloc_irq(pf);
+	q_vector->irq = ice_alloc_irq(pf, vsi->irq_dyn_alloc);
 	if (q_vector->irq.index < 0) {
 		kfree(q_vector);
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index bc016bb4440c..145b27f2a4ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -250,7 +250,7 @@ static int ice_alloc_rdma_qvectors(struct ice_pf *pf)
 			struct msix_entry *entry = &pf->msix_entries[i];
 			struct msi_map map;
 
-			map = ice_alloc_irq(pf);
+			map = ice_alloc_irq(pf, false);
 			if (map.index < 0)
 				break;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_irq.c b/drivers/net/ethernet/intel/ice/ice_irq.c
index 1713347c577f..ad82ff7d1995 100644
--- a/drivers/net/ethernet/intel/ice/ice_irq.c
+++ b/drivers/net/ethernet/intel/ice/ice_irq.c
@@ -9,11 +9,14 @@
  * ice_init_irq_tracker - initialize interrupt tracker
  * @pf: board private structure
  * @max_vectors: maximum number of vectors that tracker can hold
+ * @num_static: number of preallocated interrupts
  */
 static void
-ice_init_irq_tracker(struct ice_pf *pf, unsigned int max_vectors)
+ice_init_irq_tracker(struct ice_pf *pf, unsigned int max_vectors,
+		     unsigned int num_static)
 {
 	pf->irq_tracker.num_entries = max_vectors;
+	pf->irq_tracker.num_static = num_static;
 	xa_init_flags(&pf->irq_tracker.entries, XA_FLAGS_ALLOC);
 }
 
@@ -42,6 +45,7 @@ static void ice_free_irq_res(struct ice_pf *pf, u16 index)
 /**
  * ice_get_irq_res - get an interrupt resource
  * @pf: board private structure
+ * @dyn_only: force entry to be dynamically allocated
  *
  * Allocate new irq entry in the free slot of the tracker. Since xarray
  * is used, always allocate new entry at the lowest possible index. Set
@@ -49,10 +53,11 @@ static void ice_free_irq_res(struct ice_pf *pf, u16 index)
  *
  * Returns allocated irq entry or NULL on failure.
  */
-static struct ice_irq_entry *ice_get_irq_res(struct ice_pf *pf)
+static struct ice_irq_entry *ice_get_irq_res(struct ice_pf *pf, bool dyn_only)
 {
 	struct xa_limit limit = { .max = pf->irq_tracker.num_entries,
 				  .min = 0 };
+	unsigned int num_static = pf->irq_tracker.num_static;
 	struct ice_irq_entry *entry;
 	unsigned int index;
 	int ret;
@@ -61,6 +66,10 @@ static struct ice_irq_entry *ice_get_irq_res(struct ice_pf *pf)
 	if (!entry)
 		return NULL;
 
+	/* skip preallocated entries if the caller says so */
+	if (dyn_only)
+		limit.min = num_static;
+
 	ret = xa_alloc(&pf->irq_tracker.entries, &index, entry, limit,
 		       GFP_KERNEL);
 
@@ -69,6 +78,7 @@ static struct ice_irq_entry *ice_get_irq_res(struct ice_pf *pf)
 		entry = NULL;
 	} else {
 		entry->index = index;
+		entry->dynamic = index >= num_static;
 	}
 
 	return entry;
@@ -241,14 +251,20 @@ void ice_clear_interrupt_scheme(struct ice_pf *pf)
  */
 int ice_init_interrupt_scheme(struct ice_pf *pf)
 {
-	int vectors;
+	int total_vectors = pf->hw.func_caps.common_cap.num_msix_vectors;
+	int vectors, max_vectors;
 
 	vectors = ice_ena_msix_range(pf);
 
 	if (vectors < 0)
-		return vectors;
+		return -ENOMEM;
+
+	if (pci_msix_can_alloc_dyn(pf->pdev))
+		max_vectors = total_vectors;
+	else
+		max_vectors = vectors;
 
-	ice_init_irq_tracker(pf, vectors);
+	ice_init_irq_tracker(pf, max_vectors, vectors);
 
 	return 0;
 }
@@ -256,33 +272,55 @@ int ice_init_interrupt_scheme(struct ice_pf *pf)
 /**
  * ice_alloc_irq - Allocate new interrupt vector
  * @pf: board private structure
+ * @dyn_only: force dynamic allocation of the interrupt
  *
  * Allocate new interrupt vector for a given owner id.
  * return struct msi_map with interrupt details and track
  * allocated interrupt appropriately.
  *
- * This function mimics individual interrupt allocation,
- * even interrupts are actually already allocated with
- * pci_alloc_irq_vectors. Individual allocation helps
- * to track interrupts and simplifies interrupt related
- * handling.
+ * This function reserves new irq entry from the irq_tracker.
+ * if according to the tracker information all interrupts that
+ * were allocated with ice_pci_alloc_irq_vectors are already used
+ * and dynamically allocated interrupts are supported then new
+ * interrupt will be allocated with pci_msix_alloc_irq_at.
+ *
+ * Some callers may only support dynamically allocated interrupts.
+ * This is indicated with dyn_only flag.
  *
  * On failure, return map with negative .index. The caller
  * is expected to check returned map index.
  *
  */
-struct msi_map ice_alloc_irq(struct ice_pf *pf)
+struct msi_map ice_alloc_irq(struct ice_pf *pf, bool dyn_only)
 {
+	int sriov_base_vector = pf->sriov_base_vector;
 	struct msi_map map = { .index = -ENOENT };
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_irq_entry *entry;
 
-	entry = ice_get_irq_res(pf);
+	entry = ice_get_irq_res(pf, dyn_only);
 	if (!entry)
 		return map;
 
-	map.index = entry->index;
-	map.virq = pci_irq_vector(pf->pdev, map.index);
+	/* fail if we're about to violate SRIOV vectors space */
+	if (sriov_base_vector && entry->index >= sriov_base_vector)
+		goto exit_free_res;
+
+	if (pci_msix_can_alloc_dyn(pf->pdev) && entry->dynamic) {
+		map = pci_msix_alloc_irq_at(pf->pdev, entry->index, NULL);
+		if (map.index < 0)
+			goto exit_free_res;
+		dev_dbg(dev, "allocated new irq at index %d\n", map.index);
+	} else {
+		map.index = entry->index;
+		map.virq = pci_irq_vector(pf->pdev, map.index);
+	}
+
+	return map;
 
+exit_free_res:
+	dev_err(dev, "Could not allocate irq at idx %d\n", entry->index);
+	ice_free_irq_res(pf, entry->index);
 	return map;
 }
 
@@ -291,9 +329,50 @@ struct msi_map ice_alloc_irq(struct ice_pf *pf)
  * @pf: board private structure
  * @map: map with interrupt details
  *
- * Remove allocated interrupt from the interrupt tracker.
+ * Remove allocated interrupt from the interrupt tracker. If interrupt was
+ * allocated dynamically, free respective interrupt vector.
  */
 void ice_free_irq(struct ice_pf *pf, struct msi_map map)
 {
+	struct ice_irq_entry *entry;
+
+	entry = xa_load(&pf->irq_tracker.entries, map.index);
+
+	if (!entry) {
+		dev_err(ice_pf_to_dev(pf), "Failed to get MSIX interrupt entry at index %d",
+			map.index);
+		return;
+	}
+
+	dev_dbg(ice_pf_to_dev(pf), "Free irq at index %d\n", map.index);
+
+	if (entry->dynamic)
+		pci_msix_free_irq(pf->pdev, map);
+
 	ice_free_irq_res(pf, map.index);
 }
+
+/**
+ * ice_get_max_used_msix_vector - Get the max used interrupt vector
+ * @pf: board private structure
+ *
+ * Return index of maximum used interrupt vectors with respect to the
+ * beginning of the MSIX table. Take into account that some interrupts
+ * may have been dynamically allocated after MSIX was initially enabled.
+ */
+int ice_get_max_used_msix_vector(struct ice_pf *pf)
+{
+	unsigned long start, index, max_idx;
+	void *entry;
+
+	/* Treat all preallocated interrupts as used */
+	start = pf->irq_tracker.num_static;
+	max_idx = start - 1;
+
+	xa_for_each_start(&pf->irq_tracker.entries, index, entry, start) {
+		if (index > max_idx)
+			max_idx = index;
+	}
+
+	return max_idx;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_irq.h b/drivers/net/ethernet/intel/ice/ice_irq.h
index da5cdb1f0d3a..f35efc08575e 100644
--- a/drivers/net/ethernet/intel/ice/ice_irq.h
+++ b/drivers/net/ethernet/intel/ice/ice_irq.h
@@ -6,17 +6,20 @@
 
 struct ice_irq_entry {
 	unsigned int index;
+	bool dynamic;	/* allocation type flag */
 };
 
 struct ice_irq_tracker {
 	struct xarray entries;
 	u16 num_entries;	/* total vectors available */
+	u16 num_static;	/* preallocated entries */
 };
 
 int ice_init_interrupt_scheme(struct ice_pf *pf);
 void ice_clear_interrupt_scheme(struct ice_pf *pf);
 
-struct msi_map ice_alloc_irq(struct ice_pf *pf);
+struct msi_map ice_alloc_irq(struct ice_pf *pf, bool dyn_only);
 void ice_free_irq(struct ice_pf *pf, struct msi_map map);
+int ice_get_max_used_msix_vector(struct ice_pf *pf);
 
 #endif
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index efc621c0bd6c..62e91512aeab 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3305,7 +3305,7 @@ static int ice_req_irq_msix_misc(struct ice_pf *pf)
 		goto skip_req_irq;
 
 	/* reserve one vector in irq_tracker for misc interrupts */
-	oicr_irq = ice_alloc_irq(pf);
+	oicr_irq = ice_alloc_irq(pf, false);
 	if (oicr_irq.index < 0)
 		return oicr_irq.index;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 195105ce9039..80c643fb9f2f 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -418,7 +418,7 @@ int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector)
 static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
 {
 	u16 total_vectors = pf->hw.func_caps.common_cap.num_msix_vectors;
-	int vectors_used = pf->irq_tracker.num_entries;
+	int vectors_used = ice_get_max_used_msix_vector(pf);
 	int sriov_base_vector;
 
 	sriov_base_vector = total_vectors - num_msix_needed;
@@ -458,6 +458,7 @@ static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
  */
 static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 {
+	int vectors_used = ice_get_max_used_msix_vector(pf);
 	u16 num_msix_per_vf, num_txq, num_rxq, avail_qs;
 	int msix_avail_per_vf, msix_avail_for_sriov;
 	struct device *dev = ice_pf_to_dev(pf);
@@ -470,7 +471,7 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 
 	/* determine MSI-X resources per VF */
 	msix_avail_for_sriov = pf->hw.func_caps.common_cap.num_msix_vectors -
-		pf->irq_tracker.num_entries;
+		vectors_used;
 	msix_avail_per_vf = msix_avail_for_sriov / num_vfs;
 	if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_MED) {
 		num_msix_per_vf = ICE_NUM_VF_MSIX_MED;
-- 
2.38.1


