Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FE36C318B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjCUMWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjCUMV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:21:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1803D08B
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 05:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679401310; x=1710937310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4COKy9P1WkW/lYvaLYqdWGYhWYGDt+dwrS2vVJchwiM=;
  b=hYATtPiu9hwhCu/1l6mWigokO3xXQaCXcz+tBK5RGoMb2YZ0KvZLKGph
   tRbCkddt6BjgBtBQNmLbCbXPEJV5LxYYafuNpU3FVP2Pj4OqL2OXXluzW
   254K6c/5gVN+T6g0eW//dSsVHz/rC3+qoXKCbakYbOwEzKXP3aW/wkV1S
   O76BDEF9YLqJFRdSvG5zIbrg9oOzLmbfW/wAoh6ExFLZmJwVQl5Ru7/NV
   sIRw/FVnb4BPNT4fLOczrlSFd9P9kLYRk5+z/Y4XfEWuihZXzHMgZxr2T
   04oFP00bXe3auf6h9b9uaB4QzL0k4lOPOk3TvGmqqYnNlPp0JMZRkDraU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="318578082"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="318578082"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 05:21:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="855673509"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="855673509"
Received: from nimitz.igk.intel.com ([10.102.21.231])
  by orsmga005.jf.intel.com with ESMTP; 21 Mar 2023 05:21:47 -0700
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, michal.swiatkowski@intel.com,
        shiraz.saleem@intel.com, jacob.e.keller@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        aleksander.lobakin@intel.com, lukasz.czapnik@intel.com,
        Piotr Raczynski <piotr.raczynski@intel.com>
Subject: [PATCH net-next v1 4/8] ice: refactor VF control VSI interrupt handling
Date:   Tue, 21 Mar 2023 13:21:34 +0100
Message-Id: <20230321122138.3151670-5-piotr.raczynski@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230321122138.3151670-1-piotr.raczynski@intel.com>
References: <20230321122138.3151670-1-piotr.raczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All VF contrl VSIs share the same interrupt vector. Rurrently, a helper
function dedicated for that directly sets ice_vsi::base_vector.

Use helper that returns pointer to first found VF control VSI instead.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c    | 76 ++++-----------------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 33 +++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h |  3 +
 3 files changed, 49 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 79e1557f77e8..f8c9c2c20e6d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1473,36 +1473,6 @@ ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id)
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
@@ -1536,7 +1506,14 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
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
@@ -2611,37 +2588,6 @@ static void ice_set_agg_vsi(struct ice_vsi *vsi)
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
@@ -2916,7 +2862,11 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
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
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 89fd6982df09..de5ae6163fd0 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -1310,3 +1310,36 @@ void ice_vf_set_initialized(struct ice_vf *vf)
 	set_bit(ICE_VF_STATE_INIT, vf->vf_states);
 	memset(&vf->vlan_v2_caps, 0, sizeof(vf->vlan_v2_caps));
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
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index e3cda6fb71ab..01a173c36bcc 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -207,6 +207,9 @@ static inline u16 ice_vf_get_port_vlan_tpid(struct ice_vf *vf)
 #define ice_for_each_vf_rcu(pf, bkt, vf) \
 	hash_for_each_rcu((pf)->vfs.table, (bkt), (vf), entry)
 
+struct ice_vsi *
+ice_get_vf_ctrl_vsi(struct ice_pf *pf, struct ice_vsi *vsi);
+
 #ifdef CONFIG_PCI_IOV
 struct ice_vf *ice_get_vf_by_id(struct ice_pf *pf, u16 vf_id);
 void ice_put_vf(struct ice_vf *vf);
-- 
2.38.1

