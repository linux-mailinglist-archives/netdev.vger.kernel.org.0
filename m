Return-Path: <netdev+bounces-11122-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5C0731979
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2DA02817FB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38AF013AE0;
	Thu, 15 Jun 2023 13:01:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD72111AE
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:01:57 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E79C213F
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686834116; x=1718370116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i9UIlvuRTaS3ZKgBOXyiRDAuXi0ltYQuP4N2h9H7+5c=;
  b=AI9eguT7048ZoPck+4a52XW8TtVd5CIpfXw0bqr9dro/BYX1NYAxR2Tx
   YNhi/ddfMoPqDmuWJJr5qwJu4o4WxtH4zmY6D1Ng12VwCpTevvy7wZLSi
   XF3fIaU/fQS+do8hcKKtkjrWTYSkR8VY7fayU7HfUB/TgE8nr8wKDL7/v
   BDUXS3w/qiAOCrfQdzvbnYVL1udyiBW1fkLGCJQBC2cshtDNhOFG9hXX4
   4/c7E7OZ6x++BcHryduuNEBZgLW7TZKEAQp65Gdgl5yzmJwDPFafA+sHq
   TwdO43CPAaSAlrvJI6GsWLiYH53sZkYGBhiH2stdt4HGYMuD8lZ5Q18XX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="424794842"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="424794842"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 05:59:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="825259773"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="825259773"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jun 2023 05:59:29 -0700
From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	jacob.e.keller@intel.com,
	przemyslaw.kitszel@intel.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource tracking
Date: Thu, 15 Jun 2023 14:38:30 +0200
Message-Id: <20230615123830.155927-5-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
References: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Track MSI-X for VFs using bitmap, by setting and clearing bitmap during
allocation and freeing.

Try to linearize irqs usage for VFs, by freeing them and allocating once
again. Do it only for VFs that aren't currently running.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 170 ++++++++++++++++++---
 1 file changed, 151 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index e20ef1924fae..78a41163755b 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -246,22 +246,6 @@ static struct ice_vsi *ice_vf_vsi_setup(struct ice_vf *vf)
 	return vsi;
 }
 
-/**
- * ice_calc_vf_first_vector_idx - Calculate MSIX vector index in the PF space
- * @pf: pointer to PF structure
- * @vf: pointer to VF that the first MSIX vector index is being calculated for
- *
- * This returns the first MSIX vector index in PF space that is used by this VF.
- * This index is used when accessing PF relative registers such as
- * GLINT_VECT2FUNC and GLINT_DYN_CTL.
- * This will always be the OICR index in the AVF driver so any functionality
- * using vf->first_vector_idx for queue configuration will have to increment by
- * 1 to avoid meddling with the OICR index.
- */
-static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf *vf)
-{
-	return pf->sriov_base_vector + vf->vf_id * pf->vfs.num_msix_per;
-}
 
 /**
  * ice_ena_vf_msix_mappings - enable VF MSIX mappings in hardware
@@ -528,6 +512,52 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 	return 0;
 }
 
+/**
+ * ice_sriov_get_irqs - get irqs for SR-IOV usacase
+ * @pf: pointer to PF structure
+ * @needed: number of irqs to get
+ *
+ * This returns the first MSI-X vector index in PF space that is used by this
+ * VF. This index is used when accessing PF relative registers such as
+ * GLINT_VECT2FUNC and GLINT_DYN_CTL.
+ * This will always be the OICR index in the AVF driver so any functionality
+ * using vf->first_vector_idx for queue configuration_id: id of VF which will
+ * use this irqs
+ *
+ * Only SRIOV specific vectors are tracked in sriov_irq_bm. SRIOV vectors are
+ * allocated from the end of global irq index. First bit in sriov_irq_bm means
+ * last irq index etc. It simplifies extension of SRIOV vectors.
+ * They will be always located from sriov_base_vector to the last irq
+ * index. While increasing/decreasing sriov_base_vector can be moved.
+ */
+static int ice_sriov_get_irqs(struct ice_pf *pf, u16 needed)
+{
+	int res = bitmap_find_next_zero_area(pf->sriov_irq_bm,
+					     pf->sriov_irq_size, 0, needed, 0);
+	/* conversion from number in bitmap to global irq index */
+	int index = pf->sriov_irq_size - res - needed;
+
+	if (res >= pf->sriov_irq_size || index < pf->sriov_base_vector)
+		return -ENOENT;
+
+	bitmap_set(pf->sriov_irq_bm, res, needed);
+	return index;
+}
+
+/**
+ * ice_sriov_free_irqs - free irqs used by the VF
+ * @pf: pointer to PF structure
+ * @vf: pointer to VF structure
+ */
+static void ice_sriov_free_irqs(struct ice_pf *pf, struct ice_vf *vf)
+{
+	/* Move back from first vector index to first index in bitmap */
+	int bm_i = pf->sriov_irq_size - vf->first_vector_idx - vf->num_msix;
+
+	bitmap_clear(pf->sriov_irq_bm, bm_i, vf->num_msix);
+	vf->first_vector_idx = 0;
+}
+
 /**
  * ice_init_vf_vsi_res - initialize/setup VF VSI resources
  * @vf: VF to initialize/setup the VSI for
@@ -541,7 +571,9 @@ static int ice_init_vf_vsi_res(struct ice_vf *vf)
 	struct ice_vsi *vsi;
 	int err;
 
-	vf->first_vector_idx = ice_calc_vf_first_vector_idx(pf, vf);
+	vf->first_vector_idx = ice_sriov_get_irqs(pf, vf->num_msix);
+	if (vf->first_vector_idx < 0)
+		return -ENOMEM;
 
 	vsi = ice_vf_vsi_setup(vf);
 	if (!vsi)
@@ -984,6 +1016,52 @@ u32 ice_sriov_get_vf_total_msix(struct pci_dev *pdev)
 	return pf->sriov_irq_size - ice_get_max_used_msix_vector(pf);
 }
 
+static int ice_sriov_move_base_vector(struct ice_pf *pf, int move)
+{
+	if (pf->sriov_base_vector - move < ice_get_max_used_msix_vector(pf))
+		return -ENOMEM;
+
+	pf->sriov_base_vector -= move;
+	return 0;
+}
+
+static void ice_sriov_remap_vectors(struct ice_pf *pf, u16 restricted_id)
+{
+	u16 vf_ids[ICE_MAX_SRIOV_VFS];
+	struct ice_vf *tmp_vf;
+	int to_remap = 0, bkt;
+
+	/* For better irqs usage try to remap irqs of VFs
+	 * that aren't running yet
+	 */
+	ice_for_each_vf(pf, bkt, tmp_vf) {
+		/* skip VF which is changing the number of MSI-X */
+		if (restricted_id == tmp_vf->vf_id ||
+		    test_bit(ICE_VF_STATE_ACTIVE, tmp_vf->vf_states))
+			continue;
+
+		ice_dis_vf_mappings(tmp_vf);
+		ice_sriov_free_irqs(pf, tmp_vf);
+
+		vf_ids[to_remap] = tmp_vf->vf_id;
+		to_remap += 1;
+	}
+
+	for (int i = 0; i < to_remap; i++) {
+		tmp_vf = ice_get_vf_by_id(pf, vf_ids[i]);
+		if (!tmp_vf)
+			continue;
+
+		tmp_vf->first_vector_idx =
+			ice_sriov_get_irqs(pf, tmp_vf->num_msix);
+		/* there is no need to rebuild VSI as we are only changing the
+		 * vector indexes not amount of MSI-X or queues
+		 */
+		ice_ena_vf_mappings(tmp_vf);
+		ice_put_vf(tmp_vf);
+	}
+}
+
 /**
  * ice_sriov_set_msix_vec_count
  * @vf_dev: pointer to pci_dev struct of VF device
@@ -1002,8 +1080,9 @@ int ice_sriov_set_msix_vec_count(struct pci_dev *vf_dev, int msix_vec_count)
 {
 	struct pci_dev *pdev = pci_physfn(vf_dev);
 	struct ice_pf *pf = pci_get_drvdata(pdev);
+	u16 prev_msix, prev_queues, queues;
+	bool needs_rebuild = false;
 	struct ice_vf *vf;
-	u16 queues;
 	int id;
 
 	if (!ice_get_num_vfs(pf))
@@ -1016,6 +1095,13 @@ int ice_sriov_set_msix_vec_count(struct pci_dev *vf_dev, int msix_vec_count)
 	/* add 1 MSI-X for OICR */
 	msix_vec_count += 1;
 
+	if (queues > min(ice_get_avail_txq_count(pf),
+			 ice_get_avail_rxq_count(pf)))
+		return -EINVAL;
+
+	if (msix_vec_count < ICE_MIN_INTR_PER_VF)
+		return -EINVAL;
+
 	/* Transition of PCI VF function number to function_id */
 	for (id = 0; id < pci_num_vf(pdev); id++) {
 		if (vf_dev->devfn == pci_iov_virtfn_devfn(pdev, id))
@@ -1030,14 +1116,60 @@ int ice_sriov_set_msix_vec_count(struct pci_dev *vf_dev, int msix_vec_count)
 	if (!vf)
 		return -ENOENT;
 
+	prev_msix = vf->num_msix;
+	prev_queues = vf->num_vf_qs;
+
+	if (ice_sriov_move_base_vector(pf, msix_vec_count - prev_msix)) {
+		ice_put_vf(vf);
+		return -ENOSPC;
+	}
+
 	ice_dis_vf_mappings(vf);
+	ice_sriov_free_irqs(pf, vf);
+
+	/* Remap all VFs beside the one is now configured */
+	ice_sriov_remap_vectors(pf, vf->vf_id);
+
 	vf->num_msix = msix_vec_count;
 	vf->num_vf_qs = queues;
-	ice_vsi_rebuild(ice_get_vf_vsi(vf), ICE_VSI_FLAG_NO_INIT);
+	vf->first_vector_idx = ice_sriov_get_irqs(pf, vf->num_msix);
+	if (vf->first_vector_idx < 0)
+		goto unroll;
+
+	ice_vf_vsi_release(vf);
+	if (vf->vf_ops->create_vsi(vf)) {
+		/* Try to rebuild with previous values */
+		needs_rebuild = true;
+		goto unroll;
+	}
+
+	dev_info(ice_pf_to_dev(pf),
+		 "Changing VF %d resources to %d vectors and %d queues\n",
+		 vf->vf_id, vf->num_msix, vf->num_vf_qs);
+
 	ice_ena_vf_mappings(vf);
 	ice_put_vf(vf);
 
 	return 0;
+
+unroll:
+	dev_info(ice_pf_to_dev(pf),
+		 "Can't set %d vectors on VF %d, falling back to %d\n",
+		 vf->num_msix, vf->vf_id, prev_msix);
+
+	vf->num_msix = prev_msix;
+	vf->num_vf_qs = prev_queues;
+	vf->first_vector_idx = ice_sriov_get_irqs(pf, vf->num_msix);
+	if (vf->first_vector_idx < 0)
+		return -EINVAL;
+
+	if (needs_rebuild)
+		vf->vf_ops->create_vsi(vf);
+
+	ice_ena_vf_mappings(vf);
+	ice_put_vf(vf);
+
+	return -EINVAL;
 }
 
 /**
-- 
2.40.1


