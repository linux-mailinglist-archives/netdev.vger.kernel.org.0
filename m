Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0CB6280E5
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbiKNNMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbiKNNMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:12:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD7A2B61A
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668431533; x=1699967533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qVmbCiixoxgd5wqB6Vt3p8AnCwMjCYDT/JqiFV+0Qi4=;
  b=hwDIDb7pdDrlpdEUGBLwyjmkq3SW9fuMVTC92ewjX9elMS6fViH4lmcU
   HEshoPCUHOctgoAMJwjV7AvEnGIuQfpW3jCja5fkQR6/HcLSFVnugJNR5
   3hDHBd1ER2mIkukqgS9SbYjnB1fu6MpJkEROyMDZ62Rr3cedm0e9Vn8xc
   uK9iUCmKt3ZH0AxtNZB9BeQVkBpUvV7694Ir/8piTtN8MR/EWZ02TBvO2
   hHUieVcyl/lSeBpXCStc5gX4MKvCksgRlzDeysQNnCGjaTpoh/SmYAfNL
   s4gWEoTza2Bab3xMWha5qM0pFAS42wYlhGzp4VYux1IubhKQlRGPJ5fJU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="291679901"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="291679901"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:12:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616305939"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="616305939"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 05:12:06 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 04/13] ice: split ice_vsi_setup into smaller functions
Date:   Mon, 14 Nov 2022 13:57:46 +0100
Message-Id: <20221114125755.13659-5-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Main goal is to reuse the same functions in VSI config and rebuild
paths.
To do this split ice_vsi_setup into smaller pieces and reuse it during
rebuild.

ice_vsi_alloc() should only alloc memory, not set the default values
for VSI.
Move setting defaults to separate function. This will allow config of
already allocated VSI, for example in reload path.

The path is mostly moving code around without introducing new
functionality. Functions ice_vsi_cfg() and ice_vsi_decfg() were
added, but they are using code that already exist.

Use flag to pass information about VSI initialization during rebuild
instead of using boolean value.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Co-developed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c    | 648 +++++++++-----------
 drivers/net/ethernet/intel/ice/ice_lib.h    |   7 +-
 drivers/net/ethernet/intel/ice/ice_main.c   |  12 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c |   2 +-
 4 files changed, 301 insertions(+), 368 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 42203a0efcac..298bb901e4e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -447,9 +447,55 @@ static irqreturn_t ice_eswitch_msix_clean_rings(int __always_unused irq, void *d
 	return IRQ_HANDLED;
 }
 
+/**
+ * ice_vsi_alloc_def - set default values for already allocated VSI
+ * @vsi_type: type of VSI
+ * @ch: ptr to channel
+ * @vf: VF for ICE_VSI_VF and ICE_VSI_CTRL
+ */
+static int
+ice_vsi_alloc_def(struct ice_vsi *vsi, struct ice_vf *vf,
+		  struct ice_channel *ch)
+{
+	if (vsi->type != ICE_VSI_CHNL) {
+		ice_vsi_set_num_qs(vsi, vf);
+		if (ice_vsi_alloc_arrays(vsi))
+			return -ENOMEM;
+	}
+
+	switch (vsi->type) {
+	case ICE_VSI_SWITCHDEV_CTRL:
+		/* Setup eswitch MSIX irq handler for VSI */
+		vsi->irq_handler = ice_eswitch_msix_clean_rings;
+		break;
+	case ICE_VSI_PF:
+		/* Setup default MSIX irq handler for VSI */
+		vsi->irq_handler = ice_msix_clean_rings;
+		break;
+	case ICE_VSI_CTRL:
+		/* Setup ctrl VSI MSIX irq handler */
+		vsi->irq_handler = ice_msix_clean_ctrl_vsi;
+		break;
+	case ICE_VSI_CHNL:
+		if (!ch)
+			return -EINVAL;
+
+		vsi->num_rxq = ch->num_rxq;
+		vsi->num_txq = ch->num_txq;
+		vsi->next_base_q = ch->base_q;
+		break;
+	default:
+		ice_vsi_free_arrays(vsi);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * ice_vsi_alloc - Allocates the next available struct VSI in the PF
  * @pf: board private structure
+ * @pi: pointer to the port_info instance
  * @vsi_type: type of VSI
  * @ch: ptr to channel
  * @vf: VF for ICE_VSI_VF and ICE_VSI_CTRL
@@ -461,8 +507,9 @@ static irqreturn_t ice_eswitch_msix_clean_rings(int __always_unused irq, void *d
  * returns a pointer to a VSI on success, NULL on failure.
  */
 static struct ice_vsi *
-ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type,
-	      struct ice_channel *ch, struct ice_vf *vf)
+ice_vsi_alloc(struct ice_pf *pf, struct ice_port_info *pi,
+	      enum ice_vsi_type vsi_type, struct ice_channel *ch,
+	      struct ice_vf *vf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_vsi *vsi = NULL;
@@ -488,61 +535,11 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type,
 
 	vsi->type = vsi_type;
 	vsi->back = pf;
+	vsi->port_info = pi;
+	/* For VSIs which don't have a connected VF, this will be NULL */
+	vsi->vf = vf;
 	set_bit(ICE_VSI_DOWN, vsi->state);
 
-	if (vsi_type == ICE_VSI_VF)
-		ice_vsi_set_num_qs(vsi, vf);
-	else if (vsi_type != ICE_VSI_CHNL)
-		ice_vsi_set_num_qs(vsi, NULL);
-
-	switch (vsi->type) {
-	case ICE_VSI_SWITCHDEV_CTRL:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-
-		/* Setup eswitch MSIX irq handler for VSI */
-		vsi->irq_handler = ice_eswitch_msix_clean_rings;
-		break;
-	case ICE_VSI_PF:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-
-		/* Setup default MSIX irq handler for VSI */
-		vsi->irq_handler = ice_msix_clean_rings;
-		break;
-	case ICE_VSI_CTRL:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-
-		/* Setup ctrl VSI MSIX irq handler */
-		vsi->irq_handler = ice_msix_clean_ctrl_vsi;
-
-		/* For the PF control VSI this is NULL, for the VF control VSI
-		 * this will be the first VF to allocate it.
-		 */
-		vsi->vf = vf;
-		break;
-	case ICE_VSI_VF:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-		vsi->vf = vf;
-		break;
-	case ICE_VSI_CHNL:
-		if (!ch)
-			goto err_rings;
-		vsi->num_rxq = ch->num_rxq;
-		vsi->num_txq = ch->num_txq;
-		vsi->next_base_q = ch->base_q;
-		break;
-	case ICE_VSI_LB:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-		break;
-	default:
-		dev_warn(dev, "Unknown VSI type %d\n", vsi->type);
-		goto unlock_pf;
-	}
-
 	if (vsi->type == ICE_VSI_CTRL && !vf) {
 		/* Use the last VSI slot as the index for PF control VSI */
 		vsi->idx = pf->num_alloc_vsi - 1;
@@ -560,11 +557,7 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type,
 
 	if (vsi->type == ICE_VSI_CTRL && vf)
 		vf->ctrl_vsi_idx = vsi->idx;
-	goto unlock_pf;
 
-err_rings:
-	devm_kfree(dev, vsi);
-	vsi = NULL;
 unlock_pf:
 	mutex_unlock(&pf->sw_mutex);
 	return vsi;
@@ -1129,12 +1122,12 @@ ice_chnl_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 /**
  * ice_vsi_init - Create and initialize a VSI
  * @vsi: the VSI being configured
- * @init_vsi: is this call creating a VSI
+ * @init_vsi: flag, tell if VSI need to be initialized
  *
  * This initializes a VSI context depending on the VSI type to be added and
  * passes it down to the add_vsi aq command to create a new VSI.
  */
-static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
+static int ice_vsi_init(struct ice_vsi *vsi, int init_vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
@@ -1196,7 +1189,7 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 		/* if updating VSI context, make sure to set valid_section:
 		 * to indicate which section of VSI context being updated
 		 */
-		if (!init_vsi)
+		if (!(init_vsi & ICE_VSI_FLAG_INIT))
 			ctxt->info.valid_sections |=
 				cpu_to_le16(ICE_AQ_VSI_PROP_Q_OPT_VALID);
 	}
@@ -1209,7 +1202,8 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 		if (ret)
 			goto out;
 
-		if (!init_vsi) /* means VSI being updated */
+		if (!(init_vsi & ICE_VSI_FLAG_INIT))
+			/* means VSI being updated */
 			/* must to indicate which section of VSI context are
 			 * being modified
 			 */
@@ -1224,7 +1218,7 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 			cpu_to_le16(ICE_AQ_VSI_PROP_SECURITY_VALID);
 	}
 
-	if (init_vsi) {
+	if (init_vsi & ICE_VSI_FLAG_INIT) {
 		ret = ice_add_vsi(hw, vsi->idx, ctxt, NULL);
 		if (ret) {
 			dev_err(dev, "Add VSI failed, err %d\n", ret);
@@ -2493,39 +2487,89 @@ static void ice_set_agg_vsi(struct ice_vsi *vsi)
 }
 
 /**
- * ice_vsi_setup - Set up a VSI by a given type
- * @pf: board private structure
- * @pi: pointer to the port_info instance
- * @vsi_type: VSI type
- * @vf: pointer to VF to which this VSI connects. This field is used primarily
- *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
- * @ch: ptr to channel
- *
- * This allocates the sw VSI structure and its queue resources.
+ * ice_free_vf_ctrl_res - Free the VF control VSI resource
+ * @pf: pointer to PF structure
+ * @vsi: the VSI to free resources for
  *
- * Returns pointer to the successfully allocated and configured VSI sw struct on
- * success, NULL on failure.
+ * Check if the VF control VSI resource is still in use. If no VF is using it
+ * any more, release the VSI resource. Otherwise, leave it to be cleaned up
+ * once no other VF uses it.
  */
-struct ice_vsi *
-ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
-	      enum ice_vsi_type vsi_type, struct ice_vf *vf,
-	      struct ice_channel *ch)
+static void ice_free_vf_ctrl_res(struct ice_pf *pf,  struct ice_vsi *vsi)
+{
+	struct ice_vf *vf;
+	unsigned int bkt;
+
+	rcu_read_lock();
+	ice_for_each_vf_rcu(pf, bkt, vf) {
+		if (vf != vsi->vf && vf->ctrl_vsi_idx != ICE_NO_VSI) {
+			rcu_read_unlock();
+			return;
+		}
+	}
+	rcu_read_unlock();
+
+	/* No other VFs left that have control VSI. It is now safe to reclaim
+	 * SW interrupts back to the common pool.
+	 */
+	ice_free_res(pf->irq_tracker, vsi->base_vector,
+		     ICE_RES_VF_CTRL_VEC_ID);
+	pf->num_avail_sw_msix += vsi->num_q_vectors;
+}
+
+static int ice_vsi_cfg_tc_lan(struct ice_pf *pf, struct ice_vsi *vsi)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_vsi *vsi;
 	int ret, i;
 
-	vsi = ice_vsi_alloc(pf, vsi_type, ch, vf);
+	/* configure VSI nodes based on number of queues and TC's */
+	ice_for_each_traffic_class(i) {
+		if (!(vsi->tc_cfg.ena_tc & BIT(i)))
+			continue;
 
-	if (!vsi) {
-		dev_err(dev, "could not allocate VSI\n");
-		return NULL;
+		if (vsi->type == ICE_VSI_CHNL) {
+			if (!vsi->alloc_txq && vsi->num_txq)
+				max_txqs[i] = vsi->num_txq;
+			else
+				max_txqs[i] = pf->num_lan_tx;
+		} else {
+			max_txqs[i] = vsi->alloc_txq;
+		}
 	}
 
-	vsi->port_info = pi;
+	dev_dbg(dev, "vsi->tc_cfg.ena_tc = %d\n", vsi->tc_cfg.ena_tc);
+	ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
+			      max_txqs);
+	if (ret) {
+		dev_err(dev, "VSI %d failed lan queue config, error %d\n",
+			vsi->vsi_num, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_vsi_cfg_def - configure default VSI based on the type
+ * @vsi: pointer to VSI
+ * @vf: pointer to VF to which this VSI connects. This field is used primarily
+ *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
+ * @ch: ptr to channel
+ */
+static int
+ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
+{
+	struct device *dev = ice_pf_to_dev(vsi->back);
+	struct ice_pf *pf = vsi->back;
+	int ret;
+
 	vsi->vsw = pf->first_sw;
 
+	ret = ice_vsi_alloc_def(vsi, vf, ch);
+	if (ret)
+		return ret;
+
 	ice_alloc_fd_res(vsi);
 
 	if (ice_vsi_get_qs(vsi)) {
@@ -2568,6 +2612,14 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 			goto unroll_vector_base;
 
 		ice_vsi_map_rings_to_vectors(vsi);
+		if (ice_is_xdp_ena_vsi(vsi)) {
+			ret = ice_vsi_determine_xdp_res(vsi);
+			if (ret)
+				goto unroll_vector_base;
+			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
+			if (ret)
+				goto unroll_vector_base;
+		}
 
 		/* ICE_VSI_CTRL does not need RSS so skip RSS processing */
 		if (vsi->type != ICE_VSI_CTRL)
@@ -2624,29 +2676,135 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		goto unroll_vsi_init;
 	}
 
-	/* configure VSI nodes based on number of queues and TC's */
-	ice_for_each_traffic_class(i) {
-		if (!(vsi->tc_cfg.ena_tc & BIT(i)))
-			continue;
+	return 0;
 
-		if (vsi->type == ICE_VSI_CHNL) {
-			if (!vsi->alloc_txq && vsi->num_txq)
-				max_txqs[i] = vsi->num_txq;
-			else
-				max_txqs[i] = pf->num_lan_tx;
-		} else {
-			max_txqs[i] = vsi->alloc_txq;
-		}
+unroll_vector_base:
+	/* reclaim SW interrupts back to the common pool */
+	ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
+	pf->num_avail_sw_msix += vsi->num_q_vectors;
+unroll_alloc_q_vector:
+	ice_vsi_free_q_vectors(vsi);
+unroll_vsi_init:
+	ice_vsi_delete(vsi);
+unroll_get_qs:
+	ice_vsi_put_qs(vsi);
+unroll_vsi_alloc:
+	ice_vsi_free_arrays(vsi);
+	return ret;
+}
+
+/**
+ * ice_vsi_cfg - configure VSI and tc on it
+ * @vsi: pointer to VSI
+ * @vf: pointer to VF to which this VSI connects. This field is used primarily
+ *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
+ * @ch: ptr to channel
+ */
+int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
+{
+	int ret;
+
+	ret = ice_vsi_cfg_def(vsi, vf, ch);
+	if (ret)
+		return ret;
+
+	ret = ice_vsi_cfg_tc_lan(vsi->back, vsi);
+	if (ret)
+		ice_vsi_decfg(vsi);
+
+	return ret;
+}
+
+/**
+ * ice_vsi_decfg - remove all VSI configuration
+ * @vsi: pointer to VSI
+ */
+void ice_vsi_decfg(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	int err;
+
+	/* The Rx rule will only exist to remove if the LLDP FW
+	 * engine is currently stopped
+	 */
+	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF &&
+	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
+		ice_cfg_sw_lldp(vsi, false, false);
+
+	ice_fltr_remove_all(vsi);
+	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
+	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
+	if (err)
+		dev_err(ice_pf_to_dev(pf), "Failed to remove RDMA scheduler config for VSI %u, err %d\n",
+			vsi->vsi_num, err);
+
+	if (ice_is_xdp_ena_vsi(vsi))
+		/* return value check can be skipped here, it always returns
+		 * 0 if reset is in progress
+		 */
+		ice_destroy_xdp_rings(vsi);
+
+	ice_vsi_clear_rings(vsi);
+	ice_vsi_free_q_vectors(vsi);
+	ice_vsi_delete(vsi);
+	ice_vsi_put_qs(vsi);
+	ice_vsi_free_arrays(vsi);
+
+	/* SR-IOV determines needed MSIX resources all at once instead of per
+	 * VSI since when VFs are spawned we know how many VFs there are and how
+	 * many interrupts each VF needs. SR-IOV MSIX resources are also
+	 * cleared in the same manner.
+	 */
+	if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
+		ice_free_vf_ctrl_res(pf, vsi);
+	} else if (vsi->type != ICE_VSI_VF) {
+		/* reclaim SW interrupts back to the common pool */
+		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
+		pf->num_avail_sw_msix += vsi->num_q_vectors;
+		vsi->base_vector = 0;
 	}
 
-	dev_dbg(dev, "vsi->tc_cfg.ena_tc = %d\n", vsi->tc_cfg.ena_tc);
-	ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
-			      max_txqs);
-	if (ret) {
-		dev_err(dev, "VSI %d failed lan queue config, error %d\n",
-			vsi->vsi_num, ret);
-		goto unroll_clear_rings;
+	if (vsi->type == ICE_VSI_VF &&
+	    vsi->agg_node && vsi->agg_node->valid)
+		vsi->agg_node->num_vsis--;
+	if (vsi->agg_node) {
+		vsi->agg_node->valid = false;
+		vsi->agg_node->agg_id = 0;
 	}
+}
+
+/**
+ * ice_vsi_setup - Set up a VSI by a given type
+ * @pf: board private structure
+ * @pi: pointer to the port_info instance
+ * @vsi_type: VSI type
+ * @vf: pointer to VF to which this VSI connects. This field is used primarily
+ *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
+ * @ch: ptr to channel
+ *
+ * This allocates the sw VSI structure and its queue resources.
+ *
+ * Returns pointer to the successfully allocated and configured VSI sw struct on
+ * success, NULL on failure.
+ */
+struct ice_vsi *
+ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
+	      enum ice_vsi_type vsi_type, struct ice_vf *vf,
+	      struct ice_channel *ch)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_vsi *vsi;
+	int ret;
+
+	vsi = ice_vsi_alloc(pf, pi, vsi_type, ch, vf);
+	if (!vsi) {
+		dev_err(dev, "could not allocate VSI\n");
+		return NULL;
+	}
+
+	ret = ice_vsi_cfg(vsi, vf, ch);
+	if (ret)
+		goto err_vsi_cfg;
 
 	/* Add switch rule to drop all Tx Flow Control Frames, of look up
 	 * type ETHERTYPE from VSIs, and restrict malicious VF from sending
@@ -2657,30 +2815,18 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	 * be dropped so that VFs cannot send LLDP packets to reconfig DCB
 	 * settings in the HW.
 	 */
-	if (!ice_is_safe_mode(pf))
-		if (vsi->type == ICE_VSI_PF) {
-			ice_fltr_add_eth(vsi, ETH_P_PAUSE, ICE_FLTR_TX,
-					 ICE_DROP_PACKET);
-			ice_cfg_sw_lldp(vsi, true, true);
-		}
+	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF) {
+		ice_fltr_add_eth(vsi, ETH_P_PAUSE, ICE_FLTR_TX,
+				 ICE_DROP_PACKET);
+		ice_cfg_sw_lldp(vsi, true, true);
+	}
 
 	if (!vsi->agg_node)
 		ice_set_agg_vsi(vsi);
+
 	return vsi;
 
-unroll_clear_rings:
-	ice_vsi_clear_rings(vsi);
-unroll_vector_base:
-	/* reclaim SW interrupts back to the common pool */
-	ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
-	pf->num_avail_sw_msix += vsi->num_q_vectors;
-unroll_alloc_q_vector:
-	ice_vsi_free_q_vectors(vsi);
-unroll_vsi_init:
-	ice_vsi_delete(vsi);
-unroll_get_qs:
-	ice_vsi_put_qs(vsi);
-unroll_vsi_alloc:
+err_vsi_cfg:
 	if (vsi_type == ICE_VSI_VF)
 		ice_enable_lag(pf->lag);
 	ice_vsi_free(vsi);
@@ -2946,37 +3092,6 @@ void ice_napi_del(struct ice_vsi *vsi)
 		netif_napi_del(&vsi->q_vectors[v_idx]->napi);
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
 /**
  * ice_vsi_release - Delete a VSI and free its resources
  * @vsi: the VSI being removed
@@ -2986,7 +3101,6 @@ static void ice_free_vf_ctrl_res(struct ice_pf *pf,  struct ice_vsi *vsi)
 int ice_vsi_release(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf;
-	int err;
 
 	if (!vsi->back)
 		return -ENODEV;
@@ -3004,41 +3118,14 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 	}
 
+	if (vsi->type == ICE_VSI_PF)
+		ice_devlink_destroy_pf_port(pf);
+
 	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 		ice_rss_clean(vsi);
 
 	ice_vsi_close(vsi);
-
-	/* SR-IOV determines needed MSIX resources all at once instead of per
-	 * VSI since when VFs are spawned we know how many VFs there are and how
-	 * many interrupts each VF needs. SR-IOV MSIX resources are also
-	 * cleared in the same manner.
-	 */
-	if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
-		ice_free_vf_ctrl_res(pf, vsi);
-	} else if (vsi->type != ICE_VSI_VF) {
-		/* reclaim SW interrupts back to the common pool */
-		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
-		pf->num_avail_sw_msix += vsi->num_q_vectors;
-	}
-
-	/* The Rx rule will only exist to remove if the LLDP FW
-	 * engine is currently stopped
-	 */
-	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF &&
-	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
-		ice_cfg_sw_lldp(vsi, false, false);
-
-	if (ice_is_vsi_dflt_vsi(vsi))
-		ice_clear_dflt_vsi(vsi);
-	ice_fltr_remove_all(vsi);
-	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
-	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
-	if (err)
-		dev_err(ice_pf_to_dev(vsi->back), "Failed to remove RDMA scheduler config for VSI %u, err %d\n",
-			vsi->vsi_num, err);
-	ice_vsi_delete(vsi);
-	ice_vsi_free_q_vectors(vsi);
+	ice_vsi_decfg(vsi);
 
 	if (vsi->netdev) {
 		if (test_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state)) {
@@ -3052,16 +3139,6 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		}
 	}
 
-	if (vsi->type == ICE_VSI_PF)
-		ice_devlink_destroy_pf_port(pf);
-
-	if (vsi->type == ICE_VSI_VF &&
-	    vsi->agg_node && vsi->agg_node->valid)
-		vsi->agg_node->num_vsis--;
-	ice_vsi_clear_rings(vsi);
-
-	ice_vsi_put_qs(vsi);
-
 	/* retain SW VSI data structure since it is needed to unregister and
 	 * free VSI netdev when PF is not in reset recovery pending state,\
 	 * for ex: during rmmod.
@@ -3189,29 +3266,24 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 /**
  * ice_vsi_rebuild - Rebuild VSI after reset
  * @vsi: VSI to be rebuild
- * @init_vsi: is this an initialization or a reconfigure of the VSI
+ * @init_vsi: flag, tell if VSI need to be initialized
  *
  * Returns 0 on success and negative value on failure
  */
-int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
+int ice_vsi_rebuild(struct ice_vsi *vsi, int init_vsi)
 {
-	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct ice_coalesce_stored *coalesce;
-	int prev_num_q_vectors = 0;
-	enum ice_vsi_type vtype;
+	int prev_num_q_vectors;
 	struct ice_pf *pf;
-	int ret, i;
+	int ret;
 
 	if (!vsi)
 		return -EINVAL;
 
 	pf = vsi->back;
-	vtype = vsi->type;
-	if (WARN_ON(vtype == ICE_VSI_VF && !vsi->vf))
+	if (WARN_ON(vsi->type == ICE_VSI_VF && !vsi->vf))
 		return -EINVAL;
 
-	ice_vsi_init_vlan_ops(vsi);
-
 	coalesce = kcalloc(vsi->num_q_vectors,
 			   sizeof(struct ice_coalesce_stored), GFP_KERNEL);
 	if (!coalesce)
@@ -3219,174 +3291,30 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 	prev_num_q_vectors = ice_vsi_rebuild_get_coalesce(vsi, coalesce);
 
-	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
-	ret = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
+	ice_vsi_decfg(vsi);
+	ret = ice_vsi_cfg_def(vsi, vsi->vf, vsi->ch);
 	if (ret)
-		dev_err(ice_pf_to_dev(vsi->back), "Failed to remove RDMA scheduler config for VSI %u, err %d\n",
-			vsi->vsi_num, ret);
-	ice_vsi_free_q_vectors(vsi);
-
-	/* SR-IOV determines needed MSIX resources all at once instead of per
-	 * VSI since when VFs are spawned we know how many VFs there are and how
-	 * many interrupts each VF needs. SR-IOV MSIX resources are also
-	 * cleared in the same manner.
-	 */
-	if (vtype != ICE_VSI_VF) {
-		/* reclaim SW interrupts back to the common pool */
-		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
-		pf->num_avail_sw_msix += vsi->num_q_vectors;
-		vsi->base_vector = 0;
-	}
-
-	if (ice_is_xdp_ena_vsi(vsi))
-		/* return value check can be skipped here, it always returns
-		 * 0 if reset is in progress
-		 */
-		ice_destroy_xdp_rings(vsi);
-	ice_vsi_put_qs(vsi);
-	ice_vsi_clear_rings(vsi);
-	ice_vsi_free_arrays(vsi);
-	if (vtype == ICE_VSI_VF)
-		ice_vsi_set_num_qs(vsi, vsi->vf);
-	else
-		ice_vsi_set_num_qs(vsi, NULL);
-
-	ret = ice_vsi_alloc_arrays(vsi);
-	if (ret < 0)
-		goto err_vsi;
-
-	ice_vsi_get_qs(vsi);
-
-	ice_alloc_fd_res(vsi);
-	ice_vsi_set_tc_cfg(vsi);
-
-	/* Initialize VSI struct elements and create VSI in FW */
-	ret = ice_vsi_init(vsi, init_vsi);
-	if (ret < 0)
-		goto err_vsi;
-
-	switch (vtype) {
-	case ICE_VSI_CTRL:
-	case ICE_VSI_SWITCHDEV_CTRL:
-	case ICE_VSI_PF:
-		ret = ice_vsi_alloc_q_vectors(vsi);
-		if (ret)
-			goto err_rings;
-
-		ret = ice_vsi_setup_vector_base(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ret = ice_vsi_alloc_rings(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ice_vsi_map_rings_to_vectors(vsi);
-		if (ice_is_xdp_ena_vsi(vsi)) {
-			ret = ice_vsi_determine_xdp_res(vsi);
-			if (ret)
-				goto err_vectors;
-			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
-			if (ret)
-				goto err_vectors;
-		}
-		/* ICE_VSI_CTRL does not need RSS so skip RSS processing */
-		if (vtype != ICE_VSI_CTRL)
-			/* Do not exit if configuring RSS had an issue, at
-			 * least receive traffic on first queue. Hence no
-			 * need to capture return value
-			 */
-			if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
-				ice_vsi_cfg_rss_lut_key(vsi);
-
-		/* disable or enable CRC stripping */
-		if (vsi->netdev)
-			ice_vsi_cfg_crc_strip(vsi, !!(vsi->netdev->features &
-					      NETIF_F_RXFCS));
-
-		break;
-	case ICE_VSI_VF:
-		ret = ice_vsi_alloc_q_vectors(vsi);
-		if (ret)
-			goto err_rings;
-
-		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ret = ice_vsi_alloc_rings(vsi);
-		if (ret)
-			goto err_vectors;
-
-		break;
-	case ICE_VSI_CHNL:
-		if (test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
-			ice_vsi_cfg_rss_lut_key(vsi);
-			ice_vsi_set_rss_flow_fld(vsi);
-		}
-		break;
-	default:
-		break;
-	}
-
-	/* configure VSI nodes based on number of queues and TC's */
-	for (i = 0; i < vsi->tc_cfg.numtc; i++) {
-		/* configure VSI nodes based on number of queues and TC's.
-		 * ADQ creates VSIs for each TC/Channel but doesn't
-		 * allocate queues instead it reconfigures the PF queues
-		 * as per the TC command. So max_txqs should point to the
-		 * PF Tx queues.
-		 */
-		if (vtype == ICE_VSI_CHNL)
-			max_txqs[i] = pf->num_lan_tx;
-		else
-			max_txqs[i] = vsi->alloc_txq;
-
-		if (ice_is_xdp_ena_vsi(vsi))
-			max_txqs[i] += vsi->num_xdp_txq;
-	}
-
-	if (test_bit(ICE_FLAG_TC_MQPRIO, pf->flags))
-		/* If MQPRIO is set, means channel code path, hence for main
-		 * VSI's, use TC as 1
-		 */
-		ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, 1, max_txqs);
-	else
-		ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx,
-				      vsi->tc_cfg.ena_tc, max_txqs);
+		goto err_vsi_cfg;
 
+	ret = ice_vsi_cfg_tc_lan(pf, vsi);
 	if (ret) {
-		dev_err(ice_pf_to_dev(pf), "VSI %d failed lan queue config, error %d\n",
-			vsi->vsi_num, ret);
-		if (init_vsi) {
+		if (init_vsi & ICE_VSI_FLAG_INIT) {
 			ret = -EIO;
-			goto err_vectors;
+			goto err_vsi_cfg_tc_lan;
 		} else {
 			kfree(coalesce);
 			return ice_schedule_reset(pf, ICE_RESET_PFR);
 		}
 	}
+
 	ice_vsi_rebuild_set_coalesce(vsi, coalesce, prev_num_q_vectors);
 	kfree(coalesce);
 
 	return 0;
 
-err_vectors:
-	ice_vsi_free_q_vectors(vsi);
-err_rings:
-	if (vsi->netdev) {
-		vsi->current_netdev_flags = 0;
-		unregister_netdev(vsi->netdev);
-		free_netdev(vsi->netdev);
-		vsi->netdev = NULL;
-	}
-err_vsi:
-	ice_vsi_free(vsi);
-	set_bit(ICE_RESET_FAILED, pf->state);
+err_vsi_cfg_tc_lan:
+	ice_vsi_decfg(vsi);
+err_vsi_cfg:
 	kfree(coalesce);
 	return ret;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 6203114b805c..ad4d5314ca76 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -61,8 +61,11 @@ int ice_vsi_release(struct ice_vsi *vsi);
 
 void ice_vsi_close(struct ice_vsi *vsi);
 
+int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vf *vf,
+		struct ice_channel *ch);
 int ice_ena_vsi(struct ice_vsi *vsi, bool locked);
 
+void ice_vsi_decfg(struct ice_vsi *vsi);
 void ice_dis_vsi(struct ice_vsi *vsi, bool locked);
 
 int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id);
@@ -70,7 +73,9 @@ int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id);
 int
 ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id);
 
-int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi);
+#define ICE_VSI_FLAG_INIT	BIT(0)
+#define ICE_VSI_FLAG_NO_INIT	0
+int ice_vsi_rebuild(struct ice_vsi *vsi, int init_vsi);
 
 bool ice_is_reset_in_progress(unsigned long *state);
 int ice_wait_for_reset(struct ice_pf *pf, unsigned long timeout);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d39ceb3a3b72..c71f60c3bb15 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4204,13 +4204,13 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
 
 	/* set for the next time the netdev is started */
 	if (!netif_running(vsi->netdev)) {
-		ice_vsi_rebuild(vsi, false);
+		ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
 		dev_dbg(ice_pf_to_dev(pf), "Link is down, queue count change happens when link is brought up\n");
 		goto done;
 	}
 
 	ice_vsi_close(vsi);
-	ice_vsi_rebuild(vsi, false);
+	ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
 	ice_pf_dcb_recfg(pf);
 	ice_vsi_open(vsi);
 done:
@@ -6994,7 +6994,7 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 			continue;
 
 		/* rebuild the VSI */
-		err = ice_vsi_rebuild(vsi, true);
+		err = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_INIT);
 		if (err) {
 			dev_err(dev, "rebuild VSI failed, err %d, VSI index %d, type %s\n",
 				err, vsi->idx, ice_vsi_type_str(type));
@@ -8403,7 +8403,7 @@ static int ice_rebuild_channels(struct ice_pf *pf)
 		type = vsi->type;
 
 		/* rebuild ADQ VSI */
-		err = ice_vsi_rebuild(vsi, true);
+		err = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_INIT);
 		if (err) {
 			dev_err(dev, "VSI (type:%s) at index %d rebuild failed, err %d\n",
 				ice_vsi_type_str(type), vsi->idx, err);
@@ -8629,14 +8629,14 @@ static int ice_setup_tc_mqprio_qdisc(struct net_device *netdev, void *type_data)
 	cur_rxq = vsi->num_rxq;
 
 	/* proceed with rebuild main VSI using correct number of queues */
-	ret = ice_vsi_rebuild(vsi, false);
+	ret = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
 	if (ret) {
 		/* fallback to current number of queues */
 		dev_info(dev, "Rebuild failed with new queues, try with current number of queues\n");
 		vsi->req_txq = cur_txq;
 		vsi->req_rxq = cur_rxq;
 		clear_bit(ICE_RESET_FAILED, pf->state);
-		if (ice_vsi_rebuild(vsi, false)) {
+		if (ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT)) {
 			dev_err(dev, "Rebuild of main VSI failed again\n");
 			return ret;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 1c51778db951..149642765874 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -256,7 +256,7 @@ static int ice_vf_rebuild_vsi(struct ice_vf *vf)
 	if (WARN_ON(!vsi))
 		return -EINVAL;
 
-	if (ice_vsi_rebuild(vsi, true)) {
+	if (ice_vsi_rebuild(vsi, ICE_VSI_FLAG_INIT)) {
 		dev_err(ice_pf_to_dev(pf), "failed to rebuild VF %d VSI\n",
 			vf->vf_id);
 		return -EIO;
-- 
2.36.1

