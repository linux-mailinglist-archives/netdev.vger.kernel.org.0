Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1667B543880
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245031AbiFHQMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245001AbiFHQMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:12:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1084036E35
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654704721; x=1686240721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SW7GPZuZrgdCJxi+z+ouaY2Br9QTeHdk9JibaseqYZs=;
  b=P6w+/VyJ5WGzEmNSBZ9qWPZsqwQR13IKQEa3IWTLjLRO3TCTQLditGZX
   LUxIZSy1COvWGyv6c8vvml4b6qXl9qyrcyd6tSm1CraK55e1/fXLGioiW
   yaJigLLqDOAwFZksE5/2+Ttve+VbfxqqUeb7y3HheBRh0qZbd+XOtPFAX
   TLZ08GOCT/niOuAFk97SUs1IRgAPIBPKyXrsKQO1Bg2amzTzra21WvV3Z
   h3JUEjhkmZOszQ+xHtRJWpPrfrodCi+dBbeU2OwCaJ5i4nY/S8Dv2BCwr
   /mOYJajWH+deQBAiadlOLuUgQ8k0ES3+qH1pEOD1aVo3JmYe3CzUDbhf+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="260099535"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="260099535"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 09:11:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="827049668"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jun 2022 09:10:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 1/4] ice: don't set VF VLAN caps in switchdev
Date:   Wed,  8 Jun 2022 09:07:54 -0700
Message-Id: <20220608160757.2395729-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608160757.2395729-1-anthony.l.nguyen@intel.com>
References: <20220608160757.2395729-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

In switchdev mode any VLAN manipulation from VF side isn't allowed.
In order to prevent parsing VLAN commands don't set VF VLAN caps.
This will result in removing VLAN specific opcodes from allowlist.
If VF send any VLAN specific opcode PF driver will answer with not
supported error.

With this approach VF driver know that VLAN caps aren't supported so it
shouldn't send VLAN specific opcodes. Thanks to that, some ugly errors
will not show up in dmesg (ex. on creating VFs in switchdev mode
there are errors about not supported VLAN insertion and stripping)

Move setting VLAN caps to separate function, including
switchdev mode specific code.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 77 ++++++++++++-------
 1 file changed, 50 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 1d9b84c3937a..9b2d862e11d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -359,6 +359,54 @@ static u16 ice_vc_get_max_frame_size(struct ice_vf *vf)
 	return max_frame_size;
 }
 
+/**
+ * ice_vc_get_vlan_caps
+ * @hw: pointer to the hw
+ * @vf: pointer to the VF info
+ * @vsi: pointer to the VSI
+ * @driver_caps: current driver caps
+ *
+ * Return 0 if there is no VLAN caps supported, or VLAN caps value
+ */
+static u32
+ice_vc_get_vlan_caps(struct ice_hw *hw, struct ice_vf *vf, struct ice_vsi *vsi,
+		     u32 driver_caps)
+{
+	if (ice_is_eswitch_mode_switchdev(vf->pf))
+		/* In switchdev setting VLAN from VF isn't supported */
+		return 0;
+
+	if (driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN_V2) {
+		/* VLAN offloads based on current device configuration */
+		return VIRTCHNL_VF_OFFLOAD_VLAN_V2;
+	} else if (driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN) {
+		/* allow VF to negotiate VIRTCHNL_VF_OFFLOAD explicitly for
+		 * these two conditions, which amounts to guest VLAN filtering
+		 * and offloads being based on the inner VLAN or the
+		 * inner/single VLAN respectively and don't allow VF to
+		 * negotiate VIRTCHNL_VF_OFFLOAD in any other cases
+		 */
+		if (ice_is_dvm_ena(hw) && ice_vf_is_port_vlan_ena(vf)) {
+			return VIRTCHNL_VF_OFFLOAD_VLAN;
+		} else if (!ice_is_dvm_ena(hw) &&
+			   !ice_vf_is_port_vlan_ena(vf)) {
+			/* configure backward compatible support for VFs that
+			 * only support VIRTCHNL_VF_OFFLOAD_VLAN, the PF is
+			 * configured in SVM, and no port VLAN is configured
+			 */
+			ice_vf_vsi_cfg_svm_legacy_vlan_mode(vsi);
+			return VIRTCHNL_VF_OFFLOAD_VLAN;
+		} else if (ice_is_dvm_ena(hw)) {
+			/* configure software offloaded VLAN support when DVM
+			 * is enabled, but no port VLAN is enabled
+			 */
+			ice_vf_vsi_cfg_dvm_legacy_vlan_mode(vsi);
+		}
+	}
+
+	return 0;
+}
+
 /**
  * ice_vc_get_vf_res_msg
  * @vf: pointer to the VF info
@@ -402,33 +450,8 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 		goto err;
 	}
 
-	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN_V2) {
-		/* VLAN offloads based on current device configuration */
-		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN_V2;
-	} else if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_VLAN) {
-		/* allow VF to negotiate VIRTCHNL_VF_OFFLOAD explicitly for
-		 * these two conditions, which amounts to guest VLAN filtering
-		 * and offloads being based on the inner VLAN or the
-		 * inner/single VLAN respectively and don't allow VF to
-		 * negotiate VIRTCHNL_VF_OFFLOAD in any other cases
-		 */
-		if (ice_is_dvm_ena(hw) && ice_vf_is_port_vlan_ena(vf)) {
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
-		} else if (!ice_is_dvm_ena(hw) &&
-			   !ice_vf_is_port_vlan_ena(vf)) {
-			vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
-			/* configure backward compatible support for VFs that
-			 * only support VIRTCHNL_VF_OFFLOAD_VLAN, the PF is
-			 * configured in SVM, and no port VLAN is configured
-			 */
-			ice_vf_vsi_cfg_svm_legacy_vlan_mode(vsi);
-		} else if (ice_is_dvm_ena(hw)) {
-			/* configure software offloaded VLAN support when DVM
-			 * is enabled, but no port VLAN is enabled
-			 */
-			ice_vf_vsi_cfg_dvm_legacy_vlan_mode(vsi);
-		}
-	}
+	vfres->vf_cap_flags |= ice_vc_get_vlan_caps(hw, vf, vsi,
+						    vf->driver_caps);
 
 	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
 		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_RSS_PF;
-- 
2.35.1

