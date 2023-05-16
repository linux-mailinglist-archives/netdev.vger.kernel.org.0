Return-Path: <netdev+bounces-3066-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CA170553C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:45:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 861081C20DA9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F3811C92;
	Tue, 16 May 2023 17:44:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFD221080
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:44:06 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6323A8B
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684259044; x=1715795044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vufonN69eJQMCAbxVtYpJolrvdxK/Geli0+aeZQZf74=;
  b=IPIpuxsXsCpOgNErkYemZQBMVomnPYTCUwFLYYwnQuFJvWrB4hv+xXJ6
   nwAKCfNbulldwWjHLzhZpuNlBUwFS5eVtBmuuIbF6xTnNz0OrLftguyL+
   sZrIuezn8Jch5Fww7j+VNdRhH2HUsmEr+pEf9KIIWunvNyCdHBBysh6QT
   AJc2AVfvsr1IjUuQbN29rfyG2aPZFrlkAjEYqqrBkYjKj/dI2rai4egcc
   aTO+lLqMAKeOzmY3SQIEFpkq0/3R6MX9BAxMgFjdVdZ8K0Ts71ewmjJ5H
   6h4sXXdsgHsni7m8AkVxNtPDijXQAI9PWTHvrkhgElsIjccakPXq+1c5j
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="353831935"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="353831935"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 10:44:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="875733046"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="875733046"
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
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net-next v2 4/8] ice: refactor VF control VSI interrupt handling
Date: Tue, 16 May 2023 10:40:17 -0700
Message-Id: <20230516174021.2707029-5-anthony.l.nguyen@intel.com>
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

All VF control VSIs share the same interrupt vector. Currently, a helper
function dedicated for that directly sets ice_vsi::base_vector.

Use helper that returns pointer to first found VF control VSI instead.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c    | 85 +++++----------------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 32 ++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h |  7 ++
 3 files changed, 58 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 79e1557f77e8..25511240685d 100644
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
@@ -1516,8 +1486,8 @@ static int ice_get_vf_ctrl_res(struct ice_pf *pf, struct ice_vsi *vsi)
 static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
+	u16 num_q_vectors, id;
 	struct device *dev;
-	u16 num_q_vectors;
 	int base;
 
 	dev = ice_pf_to_dev(pf);
@@ -1536,12 +1506,20 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 	num_q_vectors = vsi->num_q_vectors;
 	/* reserve slots from OS requested IRQs */
 	if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
-		base = ice_get_vf_ctrl_res(pf, vsi);
+		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
+
+		/* reuse VF control VSI interrupt vector */
+		if (ctrl_vsi) {
+			vsi->base_vector = ctrl_vsi->base_vector;
+			return 0;
+		}
+
+		id = ICE_RES_VF_CTRL_VEC_ID;
 	} else {
-		base = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
-				   vsi->idx);
+		id = vsi->idx;
 	}
 
+	base = ice_get_res(pf, pf->irq_tracker, num_q_vectors, id);
 	if (base < 0) {
 		dev_err(dev, "%d MSI-X interrupts available. %s %d failed to get %d MSI-X vectors\n",
 			ice_get_free_res_count(pf->irq_tracker),
@@ -2611,37 +2589,6 @@ static void ice_set_agg_vsi(struct ice_vsi *vsi)
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
@@ -2916,7 +2863,13 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
 	 * cleared in the same manner.
 	 */
 	if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
-		ice_free_vf_ctrl_res(pf, vsi);
+		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
+
+		if (!ctrl_vsi) {
+			ice_free_res(pf->irq_tracker, vsi->base_vector,
+				     ICE_RES_VF_CTRL_VEC_ID);
+			pf->num_avail_sw_msix += vsi->num_q_vectors;
+		}
 	} else if (vsi->type != ICE_VSI_VF) {
 		/* reclaim SW interrupts back to the common pool */
 		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 89fd6982df09..68142facc85d 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -1310,3 +1310,35 @@ void ice_vf_set_initialized(struct ice_vf *vf)
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
+struct ice_vsi *ice_get_vf_ctrl_vsi(struct ice_pf *pf, struct ice_vsi *vsi)
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
index e3cda6fb71ab..48fea6fa0362 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -226,6 +226,7 @@ int
 ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m);
 int ice_reset_vf(struct ice_vf *vf, u32 flags);
 void ice_reset_all_vfs(struct ice_pf *pf);
+struct ice_vsi *ice_get_vf_ctrl_vsi(struct ice_pf *pf, struct ice_vsi *vsi);
 #else /* CONFIG_PCI_IOV */
 static inline struct ice_vf *ice_get_vf_by_id(struct ice_pf *pf, u16 vf_id)
 {
@@ -290,6 +291,12 @@ static inline int ice_reset_vf(struct ice_vf *vf, u32 flags)
 static inline void ice_reset_all_vfs(struct ice_pf *pf)
 {
 }
+
+static inline struct ice_vsi *
+ice_get_vf_ctrl_vsi(struct ice_pf *pf, struct ice_vsi *vsi)
+{
+	return NULL;
+}
 #endif /* !CONFIG_PCI_IOV */
 
 #endif /* _ICE_VF_LIB_H_ */
-- 
2.38.1


