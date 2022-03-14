Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B94D4D8B6F
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243718AbiCNSLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243608AbiCNSLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E7A3AA7A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281406; x=1678817406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x7FGGWmJCgEGRSNUQY8We0TslhYb7u9JqfhMZJ3V6QU=;
  b=lCN9jniYtzrBloKeT56tBUhp74/i0TPHSFS/QlRKepppDCgPsO5aDGsQ
   kW9Z/kCUjqIFaMggnSTQ93i45XIyY2e2JHitBidUfLWltB/qfOhDDDouk
   BLLj6vpltJjOx+P3yH29RMkGuK2UTQT1yb9T8DBcnWcvuI7UygRt2aQEL
   tf+Qwb/VNaKnYpdIW9OmmAIkNsX/cfs7U0WAtPZSrnI4WjEwULOEzS63W
   J43BcyaK29QySpDWFw/Qjvv5vHDt4zFzoTQLRJxITsw8K0Ks23FHVYYGt
   aMPRSBQKkyxLUNCHVBFzDml6UHg20VmOhwzydCP8RIPlX265XVX7epIkk
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236711782"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="236711782"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP; 14 Mar 2022 11:10:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297763"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:10:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 25/25] ice: remove PF pointer from ice_check_vf_init
Date:   Mon, 14 Mar 2022 11:10:16 -0700
Message-Id: <20220314181016.1690595-26-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
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

The ice_check_vf_init function takes both a PF and a VF pointer. Every
caller looks up the PF pointer from the VF structure. Some callers only
use of the PF pointer is call this function. Move the lookup inside
ice_check_vf_init and drop the unnecessary argument.

Cleanup the callers to drop the now unnecessary local variables. In
particular, replace the local PF pointer with a HW structure pointer in
ice_vc_get_vf_res_msg which simplifies a few accesses to the HW
structure in that function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c      | 16 +++++++---------
 .../net/ethernet/intel/ice/ice_vf_lib_private.h  |  2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c    | 12 ++++++------
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index c584f5123ba7..6578059d9479 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -174,15 +174,12 @@ static void ice_wait_on_vf_reset(struct ice_vf *vf)
  */
 int ice_check_vf_ready_for_cfg(struct ice_vf *vf)
 {
-	struct ice_pf *pf;
-
 	ice_wait_on_vf_reset(vf);
 
 	if (ice_is_vf_disabled(vf))
 		return -EINVAL;
 
-	pf = vf->pf;
-	if (ice_check_vf_init(pf, vf))
+	if (ice_check_vf_init(vf))
 		return -EBUSY;
 
 	return 0;
@@ -620,11 +617,12 @@ void ice_dis_vf_qs(struct ice_vf *vf)
 
 /**
  * ice_check_vf_init - helper to check if VF init complete
- * @pf: pointer to the PF structure
  * @vf: the pointer to the VF to check
  */
-int ice_check_vf_init(struct ice_pf *pf, struct ice_vf *vf)
+int ice_check_vf_init(struct ice_vf *vf)
 {
+	struct ice_pf *pf = vf->pf;
+
 	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
 		dev_err(ice_pf_to_dev(pf), "VF ID: %u in reset. Try again.\n",
 			vf->vf_id);
@@ -752,9 +750,9 @@ bool ice_vf_has_no_qs_ena(struct ice_vf *vf)
  */
 bool ice_is_vf_link_up(struct ice_vf *vf)
 {
-	struct ice_pf *pf = vf->pf;
+	struct ice_port_info *pi = ice_vf_get_port_info(vf);
 
-	if (ice_check_vf_init(pf, vf))
+	if (ice_check_vf_init(vf))
 		return false;
 
 	if (ice_vf_has_no_qs_ena(vf))
@@ -762,7 +760,7 @@ bool ice_is_vf_link_up(struct ice_vf *vf)
 	else if (vf->link_forced)
 		return vf->link_up;
 	else
-		return pf->hw.port_info->phy.link_info.link_info &
+		return pi->phy.link_info.link_info &
 			ICE_AQ_LINK_UP;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
index e9374693496e..15887e772c76 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
@@ -24,7 +24,7 @@
 #endif
 
 void ice_dis_vf_qs(struct ice_vf *vf);
-int ice_check_vf_init(struct ice_pf *pf, struct ice_vf *vf);
+int ice_check_vf_init(struct ice_vf *vf);
 struct ice_port_info *ice_vf_get_port_info(struct ice_vf *vf);
 int ice_vsi_apply_spoofchk(struct ice_vsi *vsi, bool enable);
 bool ice_is_vf_trusted(struct ice_vf *vf);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index d820ec622640..3f1a63815bac 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -370,12 +370,12 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_vf_resource *vfres = NULL;
-	struct ice_pf *pf = vf->pf;
+	struct ice_hw *hw = &vf->pf->hw;
 	struct ice_vsi *vsi;
 	int len = 0;
 	int ret;
 
-	if (ice_check_vf_init(pf, vf)) {
+	if (ice_check_vf_init(vf)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto err;
 	}
@@ -412,9 +412,9 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 		 * inner/single VLAN respectively and don't allow VF to
 		 * negotiate VIRTCHNL_VF_OFFLOAD in any other cases
 		 */
-		if (ice_is_dvm_ena(&pf->hw) && ice_vf_is_port_vlan_ena(vf)) {
+		if (ice_is_dvm_ena(hw) && ice_vf_is_port_vlan_ena(vf)) {
 			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
-		} else if (!ice_is_dvm_ena(&pf->hw) &&
+		} else if (!ice_is_dvm_ena(hw) &&
 			   !ice_vf_is_port_vlan_ena(vf)) {
 			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
 			/* configure backward compatible support for VFs that
@@ -422,7 +422,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 			 * configured in SVM, and no port VLAN is configured
 			 */
 			ice_vf_vsi_cfg_svm_legacy_vlan_mode(vsi);
-		} else if (ice_is_dvm_ena(&pf->hw)) {
+		} else if (ice_is_dvm_ena(hw)) {
 			/* configure software offloaded VLAN support when DVM
 			 * is enabled, but no port VLAN is enabled
 			 */
@@ -472,7 +472,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	vfres->num_vsis = 1;
 	/* Tx and Rx queue are equal for VF */
 	vfres->num_queue_pairs = vsi->num_txq;
-	vfres->max_vectors = pf->vfs.num_msix_per;
+	vfres->max_vectors = vf->pf->vfs.num_msix_per;
 	vfres->rss_key_size = ICE_VSIQF_HKEY_ARRAY_SIZE;
 	vfres->rss_lut_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
 	vfres->max_mtu = ice_vc_get_max_frame_size(vf);
-- 
2.31.1

