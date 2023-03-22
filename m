Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B696C5089
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCVQZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCVQZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:25:43 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604BD4D603
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679502341; x=1711038341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7hphK7kHKcezrUhu4SM5k2mOA/Tvbqb9EI11BCa4WXM=;
  b=f5PJeXmis4h+Oxk4ta+crpI6m+wdgMtbGhXWge9GJzRNh5AZMFVWmnsn
   lNSfbiznAuZojFH/V1huiGXZeUzk7QCtTLfbgEVj2fEolnchCQWMQxp3T
   7EeFG3DuJ0FzoilbyD3Pq4GSzwBJlhhphVvfe3bSUOKE40T1zYHgo8qd6
   mBTnhOmZLTb41EBgoUo4bvhphrqRlDauqofiYb0a5169zPF/nZGeQrZhs
   enqmSsgtjEgh3kaTXpi0l+7Z0vBPqXCLFOivhkVyIWwO02bghIqtZ20Y/
   kWWUb9eO2C5GoYkUhLjW6pWFHklS3gFz3CN0FI+j6IAh7RjEkB4nt2FQb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="404151305"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="404151305"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 09:25:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="825462738"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="825462738"
Received: from nimitz.igk.intel.com ([10.102.21.231])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2023 09:25:38 -0700
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, michal.swiatkowski@intel.com,
        shiraz.saleem@intel.com, jacob.e.keller@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        aleksander.lobakin@intel.com, lukasz.czapnik@intel.com,
        Piotr Raczynski <piotr.raczynski@intel.com>
Subject: [PATCH net-next v2 4/8] ice: refactor VF control VSI interrupt handling
Date:   Wed, 22 Mar 2023 17:25:26 +0100
Message-Id: <20230322162530.3317238-5-piotr.raczynski@intel.com>
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

All VF contrl VSIs share the same interrupt vector. Currently, a helper
function dedicated for that directly sets ice_vsi::base_vector.

Use helper that returns pointer to first found VF control VSI instead.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 109 ++++++++++-------------
 drivers/net/ethernet/intel/ice/ice_lib.h |   2 +
 2 files changed, 48 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a707c0f7ae29..4c3289aa4376 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1475,36 +1475,6 @@ ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id)
 	return ice_search_res(res, needed, id);
 }
 
-/**
- * ice_get_vf_ctrl_res - Get VF control VSI resource
- * @pf: pointer to the PF structure
- * @vsi: the VSI to allocate a resource for
- *
- * Look up whether another VF has already allocated the control VSI resource.
- * If so, re-use this resource so that we share it among all VFs.
- *
- * Otherwise, allocate the resource and return it.
- */
-static int ice_get_vf_ctrl_res(struct ice_pf *pf, struct ice_vsi *vsi)
-{
-	struct ice_vf *vf;
-	unsigned int bkt;
-	int base;
-
-	rcu_read_lock();
-	ice_for_each_vf_rcu(pf, bkt, vf) {
-		if (vf != vsi->vf && vf->ctrl_vsi_idx != ICE_NO_VSI) {
-			base = pf->vsi[vf->ctrl_vsi_idx]->base_vector;
-			rcu_read_unlock();
-			return base;
-		}
-	}
-	rcu_read_unlock();
-
-	return ice_get_res(pf, pf->irq_tracker, vsi->num_q_vectors,
-			   ICE_RES_VF_CTRL_VEC_ID);
-}
-
 /**
  * ice_vsi_setup_vector_base - Set up the base vector for the given VSI
  * @vsi: ptr to the VSI
@@ -1538,7 +1508,14 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 	num_q_vectors = vsi->num_q_vectors;
 	/* reserve slots from OS requested IRQs */
 	if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
-		base = ice_get_vf_ctrl_res(pf, vsi);
+		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
+
+		if (ctrl_vsi)
+			base = ctrl_vsi->base_vector;
+		else
+			base = ice_get_res(pf, pf->irq_tracker,
+					   vsi->num_q_vectors,
+					   ICE_RES_VF_CTRL_VEC_ID);
 	} else {
 		base = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
 				   vsi->idx);
@@ -2613,37 +2590,6 @@ static void ice_set_agg_vsi(struct ice_vsi *vsi)
 		vsi->agg_node->num_vsis);
 }
 
-/**
- * ice_free_vf_ctrl_res - Free the VF control VSI resource
- * @pf: pointer to PF structure
- * @vsi: the VSI to free resources for
- *
- * Check if the VF control VSI resource is still in use. If no VF is using it
- * any more, release the VSI resource. Otherwise, leave it to be cleaned up
- * once no other VF uses it.
- */
-static void ice_free_vf_ctrl_res(struct ice_pf *pf,  struct ice_vsi *vsi)
-{
-	struct ice_vf *vf;
-	unsigned int bkt;
-
-	rcu_read_lock();
-	ice_for_each_vf_rcu(pf, bkt, vf) {
-		if (vf != vsi->vf && vf->ctrl_vsi_idx != ICE_NO_VSI) {
-			rcu_read_unlock();
-			return;
-		}
-	}
-	rcu_read_unlock();
-
-	/* No other VFs left that have control VSI. It is now safe to reclaim
-	 * SW interrupts back to the common pool.
-	 */
-	ice_free_res(pf->irq_tracker, vsi->base_vector,
-		     ICE_RES_VF_CTRL_VEC_ID);
-	pf->num_avail_sw_msix += vsi->num_q_vectors;
-}
-
 static int ice_vsi_cfg_tc_lan(struct ice_pf *pf, struct ice_vsi *vsi)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
@@ -2918,7 +2864,11 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
 	 * cleared in the same manner.
 	 */
 	if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
-		ice_free_vf_ctrl_res(pf, vsi);
+		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
+
+		if (!ctrl_vsi)
+			ice_free_res(pf->irq_tracker, vsi->base_vector,
+				     ICE_RES_VF_CTRL_VEC_ID);
 	} else if (vsi->type != ICE_VSI_VF) {
 		/* reclaim SW interrupts back to the common pool */
 		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
@@ -4400,3 +4350,36 @@ void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx)
 {
 	ctx->info.sec_flags &= ~ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD;
 }
+
+/**
+ * ice_get_vf_ctrl_vsi - Get first VF control VSI pointer
+ * @pf: the PF private structure
+ * @vsi: pointer to the VSI
+ *
+ * Return first found VF control VSI other than the vsi
+ * passed by parameter. This function is used to determine
+ * whether new resources have to be allocated for control VSI
+ * or they can be shared with existing one.
+ *
+ * Return found VF control VSI pointer other itself. Return
+ * NULL Otherwise.
+ *
+ */
+struct ice_vsi*
+ice_get_vf_ctrl_vsi(struct ice_pf *pf, struct ice_vsi *vsi)
+{
+	struct ice_vsi *ctrl_vsi = NULL;
+	struct ice_vf *vf;
+	unsigned int bkt;
+
+	rcu_read_lock();
+	ice_for_each_vf_rcu(pf, bkt, vf) {
+		if (vf != vsi->vf && vf->ctrl_vsi_idx != ICE_NO_VSI) {
+			ctrl_vsi = pf->vsi[vf->ctrl_vsi_idx];
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+	return ctrl_vsi;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 75221478f2dc..b4687a81aaf9 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -170,4 +170,6 @@ bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
 void ice_clear_feature_support(struct ice_pf *pf, enum ice_feature f);
 void ice_init_feature_support(struct ice_pf *pf);
 bool ice_vsi_is_rx_queue_active(struct ice_vsi *vsi);
+struct ice_vsi *
+ice_get_vf_ctrl_vsi(struct ice_pf *pf, struct ice_vsi *vsi);
 #endif /* !_ICE_LIB_H_ */
-- 
2.38.1

