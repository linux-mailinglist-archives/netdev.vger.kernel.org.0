Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FA559E98A
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiHWR2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiHWR01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:26:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979F9F2D52
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661267090; x=1692803090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zj5GRdQaa85EBVt9ESDyvR5NoyghiRnMhimXFv/8/fI=;
  b=jSpmrpgjfrLz2bdVUS/vskeSgxyhofsX8rA+aapunKh7nFiXchOIDGGN
   vkpya9E2TuIFgrfsX8IsZdKtJgXksD1j3Y5x0Grb4lpdsFbuKwzqRiNNP
   wC8dt6/cmQ9lbMLRy6QA7HENzU6eQsAg2qcsbdBV2RNKSmL2XrK3bTdvS
   iY74N+Mv+fpKnQ1EiagNZUWDEtN7bYxGmUZNu1n8H8PUFaK7fIA+3spc1
   6FhV3XoEo07/lc9V3yTODW/en8Dsir7gNTj4denKvjvHLSu7lm7dWJT/C
   kTsEkjU+dsQeP21UhhWq2RWQMEY1CGV+sv24akRsSaN0JhNvowbZeMLjT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="273464967"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="273464967"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 08:04:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="854894272"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 08:04:49 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Paul Greenwalt <paul.greenwalt@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC disabled via ETHTOOL_SFECPARAM
Date:   Tue, 23 Aug 2022 08:04:38 -0700
Message-Id: <20220823150438.3613327-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
In-Reply-To: <20220823150438.3613327-1-jacob.e.keller@intel.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default Link Establishment State Machine (LESM) behavior does not
allow the use of FEC disabled if the media does not support FEC
disabled. However users may want to override this behavior.

To support this, accept the ETHTOOL_FEC_AUTO | ETHTOOL_FEC_OFF as a request
to automatically select an appropriate FEC mode including potentially
disabling FEC.

This is distinct from ETHTOOL_FEC_AUTO because that will not allow the LESM
to select FEC disabled. It is distinct from ETHTOOL_FEC_OFF because
FEC_OFF will always disable FEC without any LESM automatic selection.

This *does* mean that ice is now accepting one "bitwise OR" set for FEC
configuration, which is somewhat against the recommendations made in
6dbf94b264e6 ("ethtool: clarify the ethtool FEC interface"), but I am not
sure if the addition of an entirely new ETHTOOL_FEC_AUTO_DIS would make any
sense here.

With this change, users can opt to allow automatic FEC disable via

  ethtool --set-fec ethX encoding auto off

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c   | 54 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 11 +++-
 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  9 +++-
 6 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 9d2fa67d873e..5c5ebd70483c 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1123,6 +1123,7 @@ struct ice_aqc_get_phy_caps_data {
 #define ICE_AQC_PHY_FEC_25G_RS_528_REQ			BIT(2)
 #define ICE_AQC_PHY_FEC_25G_KR_REQ			BIT(3)
 #define ICE_AQC_PHY_FEC_25G_RS_544_REQ			BIT(4)
+#define ICE_AQC_PHY_FEC_DIS				BIT(5)
 #define ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN		BIT(6)
 #define ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN		BIT(7)
 #define ICE_AQC_PHY_FEC_MASK				ICE_M(0xdf, 0)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2c8c3fcc3dcd..96f51b7c9898 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3253,8 +3253,11 @@ enum ice_fc_mode ice_caps_to_fc_mode(u8 caps)
  */
 enum ice_fec_mode ice_caps_to_fec_mode(u8 caps, u8 fec_options)
 {
-	if (caps & ICE_AQC_PHY_EN_AUTO_FEC)
+	if (caps & ICE_AQC_PHY_EN_AUTO_FEC) {
+		if (fec_options & ICE_AQC_PHY_FEC_DIS)
+			return ICE_FEC_DIS_AUTO;
 		return ICE_FEC_AUTO;
+	}
 
 	if (fec_options & (ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN |
 			   ICE_AQC_PHY_FEC_10G_KR_40G_KR4_REQ |
@@ -3513,6 +3516,12 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 		/* Clear all FEC option bits. */
 		cfg->link_fec_opt &= ~ICE_AQC_PHY_FEC_MASK;
 		break;
+	case ICE_FEC_DIS_AUTO:
+		/* Set No FEC and auto FEC */
+		if (!ice_fw_supports_fec_dis_auto(hw))
+			return -EOPNOTSUPP;
+		cfg->link_fec_opt |= ICE_AQC_PHY_FEC_DIS;
+		fallthrough;
 	case ICE_FEC_AUTO:
 		/* AND auto FEC bit, and all caps bits. */
 		cfg->caps &= ICE_AQC_PHY_CAPS_MASK;
@@ -5289,6 +5298,35 @@ ice_aq_get_gpio(struct ice_hw *hw, u16 gpio_ctrl_handle, u8 pin_idx,
 	return 0;
 }
 
+/**
+ * ice_is_fw_min_ver
+ * @hw: pointer to the hardware structure
+ * @branch: branch version
+ * @maj: major version
+ * @min: minor version
+ * @patch: patch version
+ *
+ * Checks if the firmware is minimum version
+ */
+static bool ice_is_fw_min_ver(struct ice_hw *hw, u8 branch, u8 maj, u8 min,
+			      u8 patch)
+{
+	if (hw->fw_branch == branch) {
+		if (hw->fw_maj_ver > maj)
+			return true;
+		if (hw->fw_maj_ver == maj) {
+			if (hw->fw_min_ver > min)
+				return true;
+			if (hw->fw_min_ver == min && hw->fw_patch >= patch)
+				return true;
+		}
+	} else if (hw->fw_branch > branch) {
+		return true;
+	}
+
+	return false;
+}
+
 /**
  * ice_fw_supports_link_override
  * @hw: pointer to the hardware structure
@@ -5510,3 +5548,17 @@ bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
 	}
 	return false;
 }
+
+/**
+ * ice_fw_supports_fec_dis_auto
+ * @hw: pointer to the hardware structure
+ *
+ * Checks if the firmware supports FEC disable in Auto FEC mode
+ */
+bool ice_fw_supports_fec_dis_auto(struct ice_hw *hw)
+{
+	return ice_is_fw_min_ver(hw, ICE_FW_FEC_DIS_AUTO_BRANCH,
+				     ICE_FW_FEC_DIS_AUTO_MAJ,
+				     ICE_FW_FEC_DIS_AUTO_MIN,
+				     ICE_FW_FEC_DIS_AUTO_PATCH);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index f339bdc48062..a0baf80df356 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -110,6 +110,7 @@ int
 ice_aq_set_phy_cfg(struct ice_hw *hw, struct ice_port_info *pi,
 		   struct ice_aqc_set_phy_cfg_data *cfg, struct ice_sq_cd *cd);
 bool ice_fw_supports_link_override(struct ice_hw *hw);
+bool ice_fw_supports_fec_dis_auto(struct ice_hw *hw);
 int
 ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
 			      struct ice_port_info *pi);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 770101577a94..a83b127a00b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1020,9 +1020,17 @@ ice_set_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam,
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
 	enum ice_fec_mode fec;
 
 	switch (fecparam->fec) {
+	case ETHTOOL_FEC_AUTO | ETHTOOL_FEC_OFF:
+		if (!ice_fw_supports_fec_dis_auto(&pf->hw)) {
+			NL_SET_ERR_MSG_MOD(extack, "FEC automatic disable is not supported by current firmware\n");
+			return -EOPNOTSUPP;
+		}
+		fec = ICE_FEC_DIS_AUTO;
+		break;
 	case ETHTOOL_FEC_AUTO:
 		fec = ICE_FEC_AUTO;
 		break;
@@ -1037,8 +1045,7 @@ ice_set_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam,
 		fec = ICE_FEC_NONE;
 		break;
 	default:
-		dev_warn(ice_pf_to_dev(vsi->back), "Unsupported FEC mode: %d\n",
-			 fecparam->fec);
+		NL_SET_ERR_MSG_MOD(extack, "Requested FEC mode is not supported\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3dbd91d8d83e..98fc40f20abd 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2190,7 +2190,8 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	ice_cfg_phy_fec(pi, cfg, phy->curr_user_fec_req);
 
 	/* Can't provide what was requested; use PHY capabilities */
-	if (cfg->link_fec_opt !=
+	if (phy->curr_user_fec_req != ICE_FEC_DIS_AUTO &&
+	    cfg->link_fec_opt !=
 	    (cfg->link_fec_opt & pcaps->link_fec_options)) {
 		cfg->caps |= pcaps->caps & ICE_AQC_PHY_EN_AUTO_FEC;
 		cfg->link_fec_opt = pcaps->link_fec_options;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index e1abfcee96dc..0b71c40e881b 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -107,7 +107,8 @@ enum ice_fec_mode {
 	ICE_FEC_NONE = 0,
 	ICE_FEC_RS,
 	ICE_FEC_BASER,
-	ICE_FEC_AUTO
+	ICE_FEC_AUTO,
+	ICE_FEC_DIS_AUTO
 };
 
 struct ice_phy_cache_mode_data {
@@ -1145,4 +1146,10 @@ struct ice_aq_get_set_rss_lut_params {
 #define ICE_FW_API_REPORT_DFLT_CFG_MIN		7
 #define ICE_FW_API_REPORT_DFLT_CFG_PATCH	3
 
+/* FW version for FEC disable in Auto FEC mode */
+#define ICE_FW_FEC_DIS_AUTO_BRANCH	1
+#define ICE_FW_FEC_DIS_AUTO_MAJ		7
+#define ICE_FW_FEC_DIS_AUTO_MIN		0
+#define ICE_FW_FEC_DIS_AUTO_PATCH	5
+
 #endif /* _ICE_TYPE_H_ */
-- 
2.37.1.394.gc50926e1f488

