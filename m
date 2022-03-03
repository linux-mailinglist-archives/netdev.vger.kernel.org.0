Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C5B4CC7B8
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiCCVP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236440AbiCCVP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:15:26 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E461673CE
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646342080; x=1677878080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5aV1AT0KdsTGCaig5LGuMDyN/+V7w7gi9aVh2OwoF3E=;
  b=glCHbfE+BNNAetQTT2HQCNTMl7gHTAxA00f0xIvIStbSC54grsCUlumg
   VS0Yuu7aH486JxvaH3/8VP8ISpLkkcw4YeM3un80Lskd0HRVIxXtxfD9a
   VIwmwc/rIZ8+BeCObTvZzFS5DpfovXR02jc2BlYJ9tcYDQbWUajn/nMxJ
   xVa9fOGRheT3qEFZo46lXKnDE5B+962aarvwv94cfRjqiGb229z15AMXP
   +ZJBF7KgrFHEBPdTgZfxSwoAMj+N0YRO4LyqVShLo2yJH1iJud/NR0lSs
   0w9j3dZrFfteOGMUePTE0yNb/sN2XVoGW1tExTDwDNmpwDz4f/V2VsNBK
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="340245699"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="340245699"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 13:14:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="640347683"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 13:14:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 01/11] ice: refactor unwind cleanup in eswitch mode
Date:   Thu,  3 Mar 2022 13:14:39 -0800
Message-Id: <20220303211449.899956-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
References: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The code for supporting eswitch mode and port representors on VFs uses
an unwind based cleanup flow when handling errors.

These flows are used to cleanup and get everything back to the state
prior to attempting to switch from legacy to representor mode or back.

The unwind iterations make sense, but complicate a plan to refactor the
VF array structure. In the future we won't have a clean method of
reversing an iteration of the VFs.

Instead, we can change the cleanup flow to just iterate over all VF
structures and clean up appropriately.

First notice that ice_repr_add_for_all_vfs and ice_repr_rem_from_all_vfs
have an additional step of re-assigning the VC ops. There is no good
reason to do this outside of ice_repr_add and ice_repr_rem. It can
simply be done as the last step of these functions.

Second, make sure ice_repr_rem is safe to call on a VF which does not
have a representor. Check if vf->repr is NULL first and exit early if
so.

Move ice_repr_rem_from_all_vfs above ice_repr_add_for_all_vfs so that we
can call it from the cleanup function.

In ice_eswitch.c, replace the unwind iteration with a call to
ice_eswitch_release_reprs. This will go through all of the VFs and
revert the VF back to the standard model without the eswitch mode.

To make this safe, ensure this function checks whether or not the
represent or has been moved. Rely on the metadata destination in
vf->repr->dst. This must be NULL if the representor has not been moved
to eswitch mode.

Ensure that we always re-assign this value back to NULL after freeing
it, and move the ice_eswitch_release_reprs so that it can be called from
the setup function.

With these changes, eswitch cleanup no longer uses an unwind flow that
is problematic for the planned VF data structure change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 63 ++++++++++----------
 drivers/net/ethernet/intel/ice/ice_repr.c    | 45 +++++++-------
 2 files changed, 53 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 95c81fc9ec9f..22babf59d40b 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -202,6 +202,34 @@ static void ice_eswitch_remap_rings_to_vectors(struct ice_pf *pf)
 	}
 }
 
+/**
+ * ice_eswitch_release_reprs - clear PR VSIs configuration
+ * @pf: poiner to PF struct
+ * @ctrl_vsi: pointer to switchdev control VSI
+ */
+static void
+ice_eswitch_release_reprs(struct ice_pf *pf, struct ice_vsi *ctrl_vsi)
+{
+	int i;
+
+	ice_for_each_vf(pf, i) {
+		struct ice_vsi *vsi = pf->vf[i].repr->src_vsi;
+		struct ice_vf *vf = &pf->vf[i];
+
+		/* Skip VFs that aren't configured */
+		if (!vf->repr->dst)
+			continue;
+
+		ice_vsi_update_security(vsi, ice_vsi_ctx_set_antispoof);
+		metadata_dst_free(vf->repr->dst);
+		vf->repr->dst = NULL;
+		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr.addr,
+					       ICE_FWD_TO_VSI);
+
+		netif_napi_del(&vf->repr->q_vector->napi);
+	}
+}
+
 /**
  * ice_eswitch_setup_reprs - configure port reprs to run in switchdev mode
  * @pf: pointer to PF struct
@@ -231,6 +259,7 @@ static int ice_eswitch_setup_reprs(struct ice_pf *pf)
 						       vf->hw_lan_addr.addr,
 						       ICE_FWD_TO_VSI);
 			metadata_dst_free(vf->repr->dst);
+			vf->repr->dst = NULL;
 			goto err;
 		}
 
@@ -239,6 +268,7 @@ static int ice_eswitch_setup_reprs(struct ice_pf *pf)
 						       vf->hw_lan_addr.addr,
 						       ICE_FWD_TO_VSI);
 			metadata_dst_free(vf->repr->dst);
+			vf->repr->dst = NULL;
 			ice_vsi_update_security(vsi, ice_vsi_ctx_set_antispoof);
 			goto err;
 		}
@@ -266,42 +296,11 @@ static int ice_eswitch_setup_reprs(struct ice_pf *pf)
 	return 0;
 
 err:
-	for (i = i - 1; i >= 0; i--) {
-		struct ice_vsi *vsi = pf->vf[i].repr->src_vsi;
-		struct ice_vf *vf = &pf->vf[i];
-
-		ice_vsi_update_security(vsi, ice_vsi_ctx_set_antispoof);
-		metadata_dst_free(vf->repr->dst);
-		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr.addr,
-					       ICE_FWD_TO_VSI);
-	}
+	ice_eswitch_release_reprs(pf, ctrl_vsi);
 
 	return -ENODEV;
 }
 
-/**
- * ice_eswitch_release_reprs - clear PR VSIs configuration
- * @pf: poiner to PF struct
- * @ctrl_vsi: pointer to switchdev control VSI
- */
-static void
-ice_eswitch_release_reprs(struct ice_pf *pf, struct ice_vsi *ctrl_vsi)
-{
-	int i;
-
-	ice_for_each_vf(pf, i) {
-		struct ice_vsi *vsi = pf->vf[i].repr->src_vsi;
-		struct ice_vf *vf = &pf->vf[i];
-
-		ice_vsi_update_security(vsi, ice_vsi_ctx_set_antispoof);
-		metadata_dst_free(vf->repr->dst);
-		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr.addr,
-					       ICE_FWD_TO_VSI);
-
-		netif_napi_del(&vf->repr->q_vector->napi);
-	}
-}
-
 /**
  * ice_eswitch_update_repr - reconfigure VF port representor
  * @vsi: VF VSI for which port representor is configured
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index dcc310e29300..787f51c8ddb2 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -284,6 +284,8 @@ static int ice_repr_add(struct ice_vf *vf)
 
 	devlink_port_type_eth_set(&vf->devlink_port, repr->netdev);
 
+	ice_vc_change_ops_to_repr(&vf->vc_ops);
+
 	return 0;
 
 err_netdev:
@@ -311,6 +313,9 @@ static int ice_repr_add(struct ice_vf *vf)
  */
 static void ice_repr_rem(struct ice_vf *vf)
 {
+	if (!vf->repr)
+		return;
+
 	ice_devlink_destroy_vf_port(vf);
 	kfree(vf->repr->q_vector);
 	vf->repr->q_vector = NULL;
@@ -323,54 +328,48 @@ static void ice_repr_rem(struct ice_vf *vf)
 #endif
 	kfree(vf->repr);
 	vf->repr = NULL;
+
+	ice_vc_set_dflt_vf_ops(&vf->vc_ops);
 }
 
 /**
- * ice_repr_add_for_all_vfs - add port representor for all VFs
+ * ice_repr_rem_from_all_vfs - remove port representor for all VFs
  * @pf: pointer to PF structure
  */
-int ice_repr_add_for_all_vfs(struct ice_pf *pf)
+void ice_repr_rem_from_all_vfs(struct ice_pf *pf)
 {
-	int err;
 	int i;
 
 	ice_for_each_vf(pf, i) {
 		struct ice_vf *vf = &pf->vf[i];
 
-		err = ice_repr_add(vf);
-		if (err)
-			goto err;
-
-		ice_vc_change_ops_to_repr(&vf->vc_ops);
-	}
-
-	return 0;
-
-err:
-	for (i = i - 1; i >= 0; i--) {
-		struct ice_vf *vf = &pf->vf[i];
-
 		ice_repr_rem(vf);
-		ice_vc_set_dflt_vf_ops(&vf->vc_ops);
 	}
-
-	return err;
 }
 
 /**
- * ice_repr_rem_from_all_vfs - remove port representor for all VFs
+ * ice_repr_add_for_all_vfs - add port representor for all VFs
  * @pf: pointer to PF structure
  */
-void ice_repr_rem_from_all_vfs(struct ice_pf *pf)
+int ice_repr_add_for_all_vfs(struct ice_pf *pf)
 {
+	int err;
 	int i;
 
 	ice_for_each_vf(pf, i) {
 		struct ice_vf *vf = &pf->vf[i];
 
-		ice_repr_rem(vf);
-		ice_vc_set_dflt_vf_ops(&vf->vc_ops);
+		err = ice_repr_add(vf);
+		if (err)
+			goto err;
 	}
+
+	return 0;
+
+err:
+	ice_repr_rem_from_all_vfs(pf);
+
+	return err;
 }
 
 /**
-- 
2.31.1

