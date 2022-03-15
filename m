Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E66F4DA53E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352194AbiCOWXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344265AbiCOWXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:23:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46AB5C660
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647382919; x=1678918919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aVCVPq6hZZLeAWuU4zcsnQU+/RPsQAwN7Zw4ZjvjBQA=;
  b=ALuVREHUVApRZuTJ503tA2uP8bkJEES9kT9OrMSYkjLAl2SYMH4ib5UY
   hMGKrhCWP8hyJ/YdyO7IOVbBdo5JzIW/dWDQSxgjo/+J9KF6Y1+L9Wbi7
   qum0TqtjEDwfuxSEtE4MvInnxHMfL10JEERDYX0qQAeMAsJIvh4gL5EBd
   hNrQJHKGmhnBMUmlWFcV7DZH/B3VxZeA2i+U8/ULuh5uasnmVc//iSsko
   GCmlpPI+ttI6RN+1QI+z+2DbSXwHfPOQgTxPmD3RkULgxJPld2dMr5jpL
   fKMaNuTVo+fd5FwIfZjfMwWXfIWBhVO6m+T3URBMtpNgPhSqwv0F52Knw
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255264548"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="255264548"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:21:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690362209"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 15:21:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 03/14] ice: introduce VF operations structure for reset flows
Date:   Tue, 15 Mar 2022 15:22:09 -0700
Message-Id: <20220315222220.2925324-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
References: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice driver currently supports virtualization using Single Root IOV,
with code in the ice_sriov.c file. In the future, we plan to also
implement support for Scalable IOV, which uses slightly different
hardware implementations for some functionality.

To eventually allow this, we introduce a new ice_vf_ops structure which
will contain the basic operations that are different between the two IOV
implementations. This primarily includes logic for how to handle the VF
reset registers, as well as what to do before and after rebuilding the
VF's VSI.

Implement these ops structures and call the ops table instead of
directly calling the SR-IOV specific function. This will allow us to
easily add the Scalable IOV implementation in the future. Additionally,
it helps separate the generalized VF logic from SR-IOV specifics. This
change allows us to move the reset logic out of ice_sriov.c and into
ice_vf_lib.c without placing any Single Root specific details into the
generic file.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  | 318 +++++++++++---------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h |  13 +
 3 files changed, 196 insertions(+), 139 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 91d106528b66..be6ec42f97c1 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -478,16 +478,6 @@ void ice_free_vfs(struct ice_pf *pf)
  */
 static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 {
-	struct ice_pf *pf = vf->pf;
-	u32 reg, reg_idx, bit_idx;
-	unsigned int vf_abs_id, i;
-	struct device *dev;
-	struct ice_hw *hw;
-
-	dev = ice_pf_to_dev(pf);
-	hw = &pf->hw;
-	vf_abs_id = vf->vf_id + hw->func_caps.vf_base_id;
-
 	/* Inform VF that it is no longer active, as a warning */
 	clear_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
 
@@ -501,37 +491,10 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 	 * PFR, it can mess up VF resets because the VF driver may already
 	 * have started cleanup by the time we get here.
 	 */
-	if (!is_pfr) {
-		wr32(hw, VF_MBX_ARQLEN(vf->vf_id), 0);
-		wr32(hw, VF_MBX_ATQLEN(vf->vf_id), 0);
-	}
-
-	/* In the case of a VFLR, the HW has already reset the VF and we
-	 * just need to clean up, so don't hit the VFRTRIG register.
-	 */
-	if (!is_vflr) {
-		/* reset VF using VPGEN_VFRTRIG reg */
-		reg = rd32(hw, VPGEN_VFRTRIG(vf->vf_id));
-		reg |= VPGEN_VFRTRIG_VFSWR_M;
-		wr32(hw, VPGEN_VFRTRIG(vf->vf_id), reg);
-	}
-	/* clear the VFLR bit in GLGEN_VFLRSTAT */
-	reg_idx = (vf_abs_id) / 32;
-	bit_idx = (vf_abs_id) % 32;
-	wr32(hw, GLGEN_VFLRSTAT(reg_idx), BIT(bit_idx));
-	ice_flush(hw);
+	if (!is_pfr)
+		vf->vf_ops->clear_mbx_register(vf);
 
-	wr32(hw, PF_PCI_CIAA,
-	     VF_DEVICE_STATUS | (vf_abs_id << PF_PCI_CIAA_VF_NUM_S));
-	for (i = 0; i < ICE_PCI_CIAD_WAIT_COUNT; i++) {
-		reg = rd32(hw, PF_PCI_CIAD);
-		/* no transactions pending so stop polling */
-		if ((reg & VF_TRANS_PENDING_M) == 0)
-			break;
-
-		dev_err(dev, "VF %u PCI transactions stuck\n", vf->vf_id);
-		udelay(ICE_PCI_CIAD_WAIT_DELAY_US);
-	}
+	vf->vf_ops->trigger_reset_register(vf, is_vflr);
 }
 
 /**
@@ -995,21 +958,6 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16 num_vfs)
 	return 0;
 }
 
-/**
- * ice_clear_vf_reset_trigger - enable VF to access hardware
- * @vf: VF to enabled hardware access for
- */
-static void ice_clear_vf_reset_trigger(struct ice_vf *vf)
-{
-	struct ice_hw *hw = &vf->pf->hw;
-	u32 reg;
-
-	reg = rd32(hw, VPGEN_VFRTRIG(vf->vf_id));
-	reg &= ~VPGEN_VFRTRIG_VFSWR_M;
-	wr32(hw, VPGEN_VFRTRIG(vf->vf_id), reg);
-	ice_flush(hw);
-}
-
 static void ice_vf_clear_counters(struct ice_vf *vf)
 {
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
@@ -1030,7 +978,7 @@ static void ice_vf_clear_counters(struct ice_vf *vf)
 static void ice_vf_pre_vsi_rebuild(struct ice_vf *vf)
 {
 	ice_vf_clear_counters(vf);
-	ice_clear_vf_reset_trigger(vf);
+	vf->vf_ops->clear_reset_trigger(vf);
 }
 
 /**
@@ -1097,22 +1045,6 @@ static void ice_vf_rebuild_host_cfg(struct ice_vf *vf)
 	ice_vf_rebuild_aggregator_node_cfg(vsi);
 }
 
-/**
- * ice_vf_rebuild_vsi_with_release - release and setup the VF's VSI
- * @vf: VF to release and setup the VSI for
- *
- * This is only called when a single VF is being reset (i.e. VFR, VFLR, host VF
- * configuration change, etc.).
- */
-static int ice_vf_rebuild_vsi_with_release(struct ice_vf *vf)
-{
-	ice_vf_vsi_release(vf);
-	if (!ice_vf_vsi_setup(vf))
-		return -ENOMEM;
-
-	return 0;
-}
-
 /**
  * ice_vf_rebuild_vsi - rebuild the VF's VSI
  * @vf: VF to rebuild the VSI for
@@ -1139,24 +1071,6 @@ static int ice_vf_rebuild_vsi(struct ice_vf *vf)
 	return 0;
 }
 
-/**
- * ice_vf_post_vsi_rebuild - tasks to do after the VF's VSI have been rebuilt
- * @vf: VF to perform tasks on
- */
-static void ice_vf_post_vsi_rebuild(struct ice_vf *vf)
-{
-	struct ice_pf *pf = vf->pf;
-	struct ice_hw *hw;
-
-	hw = &pf->hw;
-
-	ice_vf_rebuild_host_cfg(vf);
-
-	ice_vf_set_initialized(vf);
-	ice_ena_vf_mappings(vf);
-	wr32(hw, VFGEN_RSTAT(vf->vf_id), VIRTCHNL_VFR_VFACTIVE);
-}
-
 /**
  * ice_reset_all_vfs - reset all allocated VFs in one go
  * @pf: pointer to the PF structure
@@ -1200,28 +1114,11 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		ice_trigger_vf_reset(vf, is_vflr, true);
 
 	/* HW requires some time to make sure it can flush the FIFO for a VF
-	 * when it resets it. Poll the VPGEN_VFRSTAT register for each VF in
-	 * sequence to make sure that it has completed. We'll keep track of
-	 * the VFs using a simple iterator that increments once that VF has
-	 * finished resetting.
+	 * when it resets it. Now that we've triggered all of the VFs, iterate
+	 * the table again and wait for each VF to complete.
 	 */
 	ice_for_each_vf(pf, bkt, vf) {
-		bool done = false;
-		unsigned int i;
-		u32 reg;
-
-		for (i = 0; i < 10; i++) {
-			reg = rd32(&pf->hw, VPGEN_VFRSTAT(vf->vf_id));
-			if (reg & VPGEN_VFRSTAT_VFRD_M) {
-				done = true;
-				break;
-			}
-
-			/* only delay if check failed */
-			usleep_range(10, 20);
-		}
-
-		if (!done) {
+		if (!vf->vf_ops->poll_reset_status(vf)) {
 			/* Display a warning if at least one VF didn't manage
 			 * to reset in time, but continue on with the
 			 * operation.
@@ -1248,7 +1145,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 
 		ice_vf_pre_vsi_rebuild(vf);
 		ice_vf_rebuild_vsi(vf);
-		ice_vf_post_vsi_rebuild(vf);
+		vf->vf_ops->post_vsi_rebuild(vf);
 
 		mutex_unlock(&vf->cfg_lock);
 	}
@@ -1279,14 +1176,13 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	struct ice_vsi *vsi;
 	struct device *dev;
 	struct ice_hw *hw;
-	bool rsd = false;
 	u8 promisc_m;
-	u32 reg;
-	int i;
+	bool rsd;
 
 	lockdep_assert_held(&vf->cfg_lock);
 
 	dev = ice_pf_to_dev(pf);
+	hw = &pf->hw;
 
 	if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
 		dev_dbg(dev, "Trying to reset VF %d, but all VF resets are disabled\n",
@@ -1312,29 +1208,12 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	 * enabled. This is needed for successful completion of VFR.
 	 */
 	ice_dis_vsi_txq(vsi->port_info, vsi->idx, 0, 0, NULL, NULL,
-			NULL, ICE_VF_RESET, vf->vf_id, NULL);
+			NULL, vf->vf_ops->reset_type, vf->vf_id, NULL);
 
-	hw = &pf->hw;
 	/* poll VPGEN_VFRSTAT reg to make sure
 	 * that reset is complete
 	 */
-	for (i = 0; i < 10; i++) {
-		/* VF reset requires driver to first reset the VF and then
-		 * poll the status register to make sure that the reset
-		 * completed successfully.
-		 */
-		reg = rd32(hw, VPGEN_VFRSTAT(vf->vf_id));
-		if (reg & VPGEN_VFRSTAT_VFRD_M) {
-			rsd = true;
-			break;
-		}
-
-		/* only sleep if the reset is not done */
-		usleep_range(10, 20);
-	}
-
-	vf->driver_caps = 0;
-	ice_vc_set_default_allowlist(vf);
+	rsd = vf->vf_ops->poll_reset_status(vf);
 
 	/* Display a warning if VF didn't manage to reset in time, but need to
 	 * continue on with the operation.
@@ -1342,6 +1221,9 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	if (!rsd)
 		dev_warn(dev, "VF reset check timeout on VF %d\n", vf->vf_id);
 
+	vf->driver_caps = 0;
+	ice_vc_set_default_allowlist(vf);
+
 	/* disable promiscuous modes in case they were enabled
 	 * ignore any error if disabling process failed
 	 */
@@ -1368,12 +1250,12 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	ice_vf_pre_vsi_rebuild(vf);
 
-	if (ice_vf_rebuild_vsi_with_release(vf)) {
+	if (vf->vf_ops->vsi_rebuild(vf)) {
 		dev_err(dev, "Failed to release and setup the VF%u's VSI\n", vf->vf_id);
 		return false;
 	}
 
-	ice_vf_post_vsi_rebuild(vf);
+	vf->vf_ops->post_vsi_rebuild(vf);
 	vsi = ice_get_vf_vsi(vf);
 	ice_eswitch_update_repr(vsi);
 	ice_eswitch_replay_vf_mac_rule(vf);
@@ -1522,7 +1404,7 @@ static int ice_start_vfs(struct ice_pf *pf)
 
 	it_cnt = 0;
 	ice_for_each_vf(pf, bkt, vf) {
-		ice_clear_vf_reset_trigger(vf);
+		vf->vf_ops->clear_reset_trigger(vf);
 
 		retval = ice_init_vf_vsi_res(vf);
 		if (retval) {
@@ -1553,6 +1435,167 @@ static int ice_start_vfs(struct ice_pf *pf)
 	return retval;
 }
 
+/**
+ * ice_sriov_free_vf - Free VF memory after all references are dropped
+ * @vf: pointer to VF to free
+ *
+ * Called by ice_put_vf through ice_release_vf once the last reference to a VF
+ * structure has been dropped.
+ */
+static void ice_sriov_free_vf(struct ice_vf *vf)
+{
+	mutex_destroy(&vf->cfg_lock);
+
+	kfree_rcu(vf, rcu);
+}
+
+/**
+ * ice_sriov_clear_mbx_register - clears SRIOV VF's mailbox registers
+ * @vf: the vf to configure
+ */
+static void ice_sriov_clear_mbx_register(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+
+	wr32(&pf->hw, VF_MBX_ARQLEN(vf->vf_id), 0);
+	wr32(&pf->hw, VF_MBX_ATQLEN(vf->vf_id), 0);
+}
+
+/**
+ * ice_sriov_trigger_reset_register - trigger VF reset for SRIOV VF
+ * @vf: pointer to VF structure
+ * @is_vflr: true if reset occurred due to VFLR
+ *
+ * Trigger and cleanup after a VF reset for a SR-IOV VF.
+ */
+static void ice_sriov_trigger_reset_register(struct ice_vf *vf, bool is_vflr)
+{
+	struct ice_pf *pf = vf->pf;
+	u32 reg, reg_idx, bit_idx;
+	unsigned int vf_abs_id, i;
+	struct device *dev;
+	struct ice_hw *hw;
+
+	dev = ice_pf_to_dev(pf);
+	hw = &pf->hw;
+	vf_abs_id = vf->vf_id + hw->func_caps.vf_base_id;
+
+	/* In the case of a VFLR, HW has already reset the VF and we just need
+	 * to clean up. Otherwise we must first trigger the reset using the
+	 * VFRTRIG register.
+	 */
+	if (!is_vflr) {
+		reg = rd32(hw, VPGEN_VFRTRIG(vf->vf_id));
+		reg |= VPGEN_VFRTRIG_VFSWR_M;
+		wr32(hw, VPGEN_VFRTRIG(vf->vf_id), reg);
+	}
+
+	/* clear the VFLR bit in GLGEN_VFLRSTAT */
+	reg_idx = (vf_abs_id) / 32;
+	bit_idx = (vf_abs_id) % 32;
+	wr32(hw, GLGEN_VFLRSTAT(reg_idx), BIT(bit_idx));
+	ice_flush(hw);
+
+	wr32(hw, PF_PCI_CIAA,
+	     VF_DEVICE_STATUS | (vf_abs_id << PF_PCI_CIAA_VF_NUM_S));
+	for (i = 0; i < ICE_PCI_CIAD_WAIT_COUNT; i++) {
+		reg = rd32(hw, PF_PCI_CIAD);
+		/* no transactions pending so stop polling */
+		if ((reg & VF_TRANS_PENDING_M) == 0)
+			break;
+
+		dev_err(dev, "VF %u PCI transactions stuck\n", vf->vf_id);
+		udelay(ICE_PCI_CIAD_WAIT_DELAY_US);
+	}
+}
+
+/**
+ * ice_sriov_poll_reset_status - poll SRIOV VF reset status
+ * @vf: pointer to VF structure
+ *
+ * Returns true when reset is successful, else returns false
+ */
+static bool ice_sriov_poll_reset_status(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+	unsigned int i;
+	u32 reg;
+
+	for (i = 0; i < 10; i++) {
+		/* VF reset requires driver to first reset the VF and then
+		 * poll the status register to make sure that the reset
+		 * completed successfully.
+		 */
+		reg = rd32(&pf->hw, VPGEN_VFRSTAT(vf->vf_id));
+		if (reg & VPGEN_VFRSTAT_VFRD_M)
+			return true;
+
+		/* only sleep if the reset is not done */
+		usleep_range(10, 20);
+	}
+	return false;
+}
+
+/**
+ * ice_sriov_clear_reset_trigger - enable VF to access hardware
+ * @vf: VF to enabled hardware access for
+ */
+static void ice_sriov_clear_reset_trigger(struct ice_vf *vf)
+{
+	struct ice_hw *hw = &vf->pf->hw;
+	u32 reg;
+
+	reg = rd32(hw, VPGEN_VFRTRIG(vf->vf_id));
+	reg &= ~VPGEN_VFRTRIG_VFSWR_M;
+	wr32(hw, VPGEN_VFRTRIG(vf->vf_id), reg);
+	ice_flush(hw);
+}
+
+/**
+ * ice_sriov_vsi_rebuild - release and rebuild VF's VSI
+ * @vf: VF to release and setup the VSI for
+ *
+ * This is only called when a single VF is being reset (i.e. VFR, VFLR, host VF
+ * configuration change, etc.).
+ */
+static int ice_sriov_vsi_rebuild(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+
+	ice_vf_vsi_release(vf);
+	if (!ice_vf_vsi_setup(vf)) {
+		dev_err(ice_pf_to_dev(pf),
+			"Failed to release and setup the VF%u's VSI\n",
+			vf->vf_id);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_sriov_post_vsi_rebuild - tasks to do after the VF's VSI have been rebuilt
+ * @vf: VF to perform tasks on
+ */
+static void ice_sriov_post_vsi_rebuild(struct ice_vf *vf)
+{
+	ice_vf_rebuild_host_cfg(vf);
+	ice_vf_set_initialized(vf);
+	ice_ena_vf_mappings(vf);
+	wr32(&vf->pf->hw, VFGEN_RSTAT(vf->vf_id), VIRTCHNL_VFR_VFACTIVE);
+}
+
+static const struct ice_vf_ops ice_sriov_vf_ops = {
+	.reset_type = ICE_VF_RESET,
+	.free = ice_sriov_free_vf,
+	.clear_mbx_register = ice_sriov_clear_mbx_register,
+	.trigger_reset_register = ice_sriov_trigger_reset_register,
+	.poll_reset_status = ice_sriov_poll_reset_status,
+	.clear_reset_trigger = ice_sriov_clear_reset_trigger,
+	.vsi_rebuild = ice_sriov_vsi_rebuild,
+	.post_vsi_rebuild = ice_sriov_post_vsi_rebuild,
+};
+
 /**
  * ice_create_vf_entries - Allocate and insert VF entries
  * @pf: pointer to the PF structure
@@ -1586,6 +1629,9 @@ static int ice_create_vf_entries(struct ice_pf *pf, u16 num_vfs)
 		vf->pf = pf;
 		vf->vf_id = vf_id;
 
+		/* set sriov vf ops for VFs created during SRIOV flow */
+		vf->vf_ops = &ice_sriov_vf_ops;
+
 		vf->vf_sw_id = pf->first_sw;
 		/* assign default capabilities */
 		vf->spoofchk = true;
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 7ac06aa8b25a..6fee0a12c996 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -56,9 +56,7 @@ static void ice_release_vf(struct kref *ref)
 {
 	struct ice_vf *vf = container_of(ref, struct ice_vf, refcnt);
 
-	mutex_destroy(&vf->cfg_lock);
-
-	kfree_rcu(vf, rcu);
+	vf->vf_ops->free(vf);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 8c5a5a2258e6..df8c293d874a 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -52,6 +52,18 @@ struct ice_mdd_vf_events {
 	u16 last_printed;
 };
 
+/* VF operations */
+struct ice_vf_ops {
+	enum ice_disq_rst_src reset_type;
+	void (*free)(struct ice_vf *vf);
+	void (*clear_mbx_register)(struct ice_vf *vf);
+	void (*trigger_reset_register)(struct ice_vf *vf, bool is_vflr);
+	bool (*poll_reset_status)(struct ice_vf *vf);
+	void (*clear_reset_trigger)(struct ice_vf *vf);
+	int (*vsi_rebuild)(struct ice_vf *vf);
+	void (*post_vsi_rebuild)(struct ice_vf *vf);
+};
+
 /* Virtchnl/SR-IOV config info */
 struct ice_vfs {
 	DECLARE_HASHTABLE(table, 8);	/* table of VF entries */
@@ -115,6 +127,7 @@ struct ice_vf {
 
 	struct ice_repr *repr;
 	const struct ice_virtchnl_ops *virtchnl_ops;
+	const struct ice_vf_ops *vf_ops;
 
 	/* devlink port data */
 	struct devlink_port devlink_port;
-- 
2.31.1

