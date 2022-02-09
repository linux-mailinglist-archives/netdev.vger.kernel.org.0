Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686D84AFF9C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbiBIV5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:57:24 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbiBIV5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD96E00ED74
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443835; x=1675979835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CD7PYZ1C3fJSchm8whjN2i7FvvKcSoqBLlT2ynZJeMI=;
  b=VFnEhDY4Glqy8iKnI6Cwwow78daH9k173xNBb8vHh4vLLAw36NHh/a1H
   7ertT3jELqkolwprhF96Gnm2dYsDvg/jAC5G8w57oqxfe+eRU1UzlzeSE
   CTMrPS8RghSO6SCIhPgP50gDgD5L6cesSe0L/d5VOBQFq5Hkvgyy4sVz3
   TkSepH5+kLot8qguqxQIunnyuwj0bNhSX8PYH7Aj+OYF1i3B10MSUURhN
   ZP8Q1zkwZ7LrWl8/SdtcozEpxAsFMTDCbuJ8A4PerVbtVmFHGylDQ1nqY
   usDC169XCVlrhHTfnwFsW/luVPyN+mH2LV5Uf3gaHlbILIXPacDZvaVX3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104086"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104086"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790473"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 02/14] ice: Add helper function for adding VLAN 0
Date:   Wed,  9 Feb 2022 13:56:54 -0800
Message-Id: <20220209215706.2468371-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
References: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

There are multiple places where VLAN 0 is being added. Create a function
to be called in order to minimize changes as the implementation is expanded
to support double VLAN and avoid duplicated code.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c     |  4 ++--
 drivers/net/ethernet/intel/ice/ice_lib.c         | 11 ++++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.h         |  2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |  2 +-
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 864692b157b6..a55c046a607d 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -126,7 +126,7 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
 	__dev_mc_unsync(uplink_netdev, NULL);
 	netif_addr_unlock_bh(uplink_netdev);
 
-	if (ice_vsi_add_vlan(uplink_vsi, 0, ICE_FWD_TO_VSI))
+	if (ice_vsi_add_vlan_zero(uplink_vsi))
 		goto err_def_rx;
 
 	if (!ice_is_dflt_vsi_in_use(uplink_vsi->vsw)) {
@@ -230,7 +230,7 @@ static int ice_eswitch_setup_reprs(struct ice_pf *pf)
 			goto err;
 		}
 
-		if (ice_vsi_add_vlan(vsi, 0, ICE_FWD_TO_VSI)) {
+		if (ice_vsi_add_vlan_zero(vsi)) {
 			ice_fltr_add_mac_and_broadcast(vsi,
 						       vf->hw_lan_addr.addr,
 						       ICE_FWD_TO_VSI);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 5b5480c3d254..b5d6b317182a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2663,7 +2663,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		 * so this handles those cases (i.e. adding the PF to a bridge
 		 * without the 8021q module loaded).
 		 */
-		ret = ice_vsi_add_vlan(vsi, 0, ICE_FWD_TO_VSI);
+		ret = ice_vsi_add_vlan_zero(vsi);
 		if (ret)
 			goto unroll_clear_rings;
 
@@ -4111,6 +4111,15 @@ int ice_set_link(struct ice_vsi *vsi, bool ena)
 	return 0;
 }
 
+/**
+ * ice_vsi_add_vlan_zero - add VLAN 0 filter(s) for this VSI
+ * @vsi: VSI used to add VLAN filters
+ */
+int ice_vsi_add_vlan_zero(struct ice_vsi *vsi)
+{
+	return ice_vsi_add_vlan(vsi, 0, ICE_FWD_TO_VSI);
+}
+
 /**
  * ice_is_feature_supported
  * @pf: pointer to the struct ice_pf instance
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index b2ed189527d6..9a554bee4b03 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -132,7 +132,7 @@ void ice_vsi_ctx_clear_antispoof(struct ice_vsi_ctx *ctx);
 void ice_vsi_ctx_set_allow_override(struct ice_vsi_ctx *ctx);
 
 void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx);
-
+int ice_vsi_add_vlan_zero(struct ice_vsi *vsi);
 bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
 void ice_clear_feature_support(struct ice_pf *pf, enum ice_feature f);
 void ice_init_feature_support(struct ice_pf *pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 81974dbc1625..bd57d8f65257 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1857,7 +1857,7 @@ static int ice_init_vf_vsi_res(struct ice_vf *vf)
 	if (!vsi)
 		return -ENOMEM;
 
-	err = ice_vsi_add_vlan(vsi, 0, ICE_FWD_TO_VSI);
+	err = ice_vsi_add_vlan_zero(vsi);
 	if (err) {
 		dev_warn(dev, "Failed to add VLAN 0 filter for VF %d\n",
 			 vf->vf_id);
-- 
2.31.1

