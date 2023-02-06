Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4A368C8ED
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjBFVtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjBFVs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:56 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F71C10A94
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720135; x=1707256135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+yOu9yBW4vJ5d0zOZONeM6ZmyOeSzPN1KX+QrNWfCEw=;
  b=bjdIj13fW9oixCWLKw1+rTEAeza2Q1SFhPMAcWuisnn1JUk/vaVJnfZ/
   9l5cHg+PCM+HvhPFj2EQVLo0jxqJlIanmCWk3WgxZ8Drw5TGesi5HjW8y
   75DF6UVTLNNoOxo18TzPjicGzlVg+PZwKu/dJ2/ZD7rqw8zVJ65PYIfM7
   VNgZ++cavRvqFJ3LcsDheYm+HdKrRBlq6JOSK/5dh+/tB73i7ZYr21cuV
   x1QYw2/ixnwVe13OqKHxM8OJIJBBJqdtdES/EgOmcaOb6icWHmiJ5otvL
   9MftH/rLsvfZImZ9+mN7oIi3+pElFnzrTMA55IzPhsm1EZxmMSwsKdSuC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338113"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338113"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576193"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576193"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:32 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 05/13] ice: move vsi_type assignment from ice_vsi_alloc to ice_vsi_cfg
Date:   Mon,  6 Feb 2023 13:48:05 -0800
Message-Id: <20230206214813.20107-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_vsi_alloc and ice_vsi_cfg functions are used together to allocate
and configure a new VSI, called as part of the ice_vsi_setup function.

In the future with the addition of the subfunction code the ice driver
will want to be able to allocate a VSI while delaying the configuration to
a later point of the port activation.

Currently this requires that the port code know what type of VSI should
be allocated. This is required because ice_vsi_alloc assigns the VSI type.

Refactor the ice_vsi_alloc and ice_vsi_cfg functions so that VSI type
assignment isn't done until the configuration stage. This will allow the
devlink port addition logic to reserve a VSI as early as possible before
the type of the port is known. In this way, the port add can fail in the
event that all hardware VSI resources are exhausted.

Since the ice_vsi_cfg function already takes the ice_vsi_cfg_params
structure, this is relatively straight forward.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 51 ++++++++++++------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 90592a231bcb..960197b2301c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -639,23 +639,18 @@ ice_vsi_alloc_def(struct ice_vsi *vsi, struct ice_channel *ch)
 /**
  * ice_vsi_alloc - Allocates the next available struct VSI in the PF
  * @pf: board private structure
- * @params: parameters to use when allocating the new VSI
  *
- * The VF pointer is used for ICE_VSI_VF and ICE_VSI_CTRL. For ICE_VSI_CTRL,
- * it may be NULL in the case there is no association with a VF. For
- * ICE_VSI_VF the VF pointer *must not* be NULL.
+ * Reserves a VSI index from the PF and allocates an empty VSI structure
+ * without a type. The VSI structure must later be initialized by calling
+ * ice_vsi_cfg().
  *
  * returns a pointer to a VSI on success, NULL on failure.
  */
-static struct ice_vsi *
-ice_vsi_alloc(struct ice_pf *pf, struct ice_vsi_cfg_params *params)
+static struct ice_vsi *ice_vsi_alloc(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_vsi *vsi = NULL;
 
-	if (WARN_ON(params->type == ICE_VSI_VF && !params->vf))
-		return NULL;
-
 	/* Need to protect the allocation of the VSIs at the PF level */
 	mutex_lock(&pf->sw_mutex);
 
@@ -672,11 +667,7 @@ ice_vsi_alloc(struct ice_pf *pf, struct ice_vsi_cfg_params *params)
 	if (!vsi)
 		goto unlock_pf;
 
-	vsi->type = params->type;
 	vsi->back = pf;
-	vsi->port_info = params->pi;
-	/* For VSIs which don't have a connected VF, this will be NULL */
-	vsi->vf = params->vf;
 	set_bit(ICE_VSI_DOWN, vsi->state);
 
 	/* fill slot and make note of the index */
@@ -687,16 +678,6 @@ ice_vsi_alloc(struct ice_pf *pf, struct ice_vsi_cfg_params *params)
 	pf->next_vsi = ice_get_free_slot(pf->vsi, pf->num_alloc_vsi,
 					 pf->next_vsi);
 
-	if (vsi->type == ICE_VSI_CTRL) {
-		if (vsi->vf) {
-			WARN_ON(vsi->vf->ctrl_vsi_idx != ICE_NO_VSI);
-			vsi->vf->ctrl_vsi_idx = vsi->idx;
-		} else {
-			WARN_ON(pf->ctrl_vsi_idx != ICE_NO_VSI);
-			pf->ctrl_vsi_idx = vsi->idx;
-		}
-	}
-
 unlock_pf:
 	mutex_unlock(&pf->sw_mutex);
 	return vsi;
@@ -2856,14 +2837,24 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
 }
 
 /**
- * ice_vsi_cfg - configure VSI and tc on it
+ * ice_vsi_cfg - configure a previously allocated VSI
  * @vsi: pointer to VSI
  * @params: parameters used to configure this VSI
  */
 int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
 {
+	struct ice_pf *pf = vsi->back;
 	int ret;
 
+	if (WARN_ON(params->type == ICE_VSI_VF && !params->vf))
+		return -EINVAL;
+
+	vsi->type = params->type;
+	vsi->port_info = params->pi;
+
+	/* For VSIs which don't have a connected VF, this will be NULL */
+	vsi->vf = params->vf;
+
 	ret = ice_vsi_cfg_def(vsi, params);
 	if (ret)
 		return ret;
@@ -2872,6 +2863,16 @@ int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
 	if (ret)
 		ice_vsi_decfg(vsi);
 
+	if (vsi->type == ICE_VSI_CTRL) {
+		if (vsi->vf) {
+			WARN_ON(vsi->vf->ctrl_vsi_idx != ICE_NO_VSI);
+			vsi->vf->ctrl_vsi_idx = vsi->idx;
+		} else {
+			WARN_ON(pf->ctrl_vsi_idx != ICE_NO_VSI);
+			pf->ctrl_vsi_idx = vsi->idx;
+		}
+	}
+
 	return ret;
 }
 
@@ -2956,7 +2957,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_vsi_cfg_params *params)
 	    WARN_ON(!params->pi))
 		return NULL;
 
-	vsi = ice_vsi_alloc(pf, params);
+	vsi = ice_vsi_alloc(pf);
 	if (!vsi) {
 		dev_err(dev, "could not allocate VSI\n");
 		return NULL;
-- 
2.38.1

