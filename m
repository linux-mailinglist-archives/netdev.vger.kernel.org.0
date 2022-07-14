Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7161575466
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbiGNSGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239969AbiGNSGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:06:14 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32761474EB
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657821973; x=1689357973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PoS68scuPdm0E76PyCiefSHD3dy+WIOdQdCVh1MCoJc=;
  b=e+szQ3x07sZ3vAY1CDjbrZAtNMGeht8LIOnTbkTVTKoc8/VTUo+s8jiA
   Wbx1L8MsBzLCvyqG5qEXkgUHEjpdzoibO4JDVunAC1ffjYGqg68erQGxS
   0vjnOzFXX7gjeIh04P6LfYEUGace6yrdYVZ2i4+ZbjY0pagfElFzucg0i
   jhRQ4famXW0yDsHd5tav6XaTc6eweoqtiQx9ji7A/o1hulfdXmIhz8930
   QYSu2d0ub22nq00gNfWdoDdZj1EjH2e2IanMG1IKrVXkRji3r5w+8ww4g
   T655NeR5q4WFF6TpbZKLKtuJuMkeiIw3tbIQUisEthxzX/EHwCBI4dniC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286336083"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="286336083"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:06:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="685666823"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jul 2022 11:06:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/3] ice: add support for Auto FEC with FEC disabled
Date:   Thu, 14 Jul 2022 11:03:09 -0700
Message-Id: <20220714180311.933648-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714180311.933648-1-anthony.l.nguyen@intel.com>
References: <20220714180311.933648-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

The default Link Establishment State Machine (LESM) behavior does not
allow the use of FEC disabled if the media does not support FEC
disabled. However users may want to override this behavior.

Add ethtool private flag allow-no-fec-modules-in-auto to allow Auto FEC
with no-FEC mode.

	ethtool --set-priv-flags ethX allow-no-fec-modules-in-auto
on|off

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c   | 80 ++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_common.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 40 +++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c     |  8 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  8 +-
 7 files changed, 105 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 60453b3b8d23..70ed8afdbf2b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -487,6 +487,7 @@ enum ice_pf_flags {
 	ICE_FLAG_PLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
+	ICE_FLAG_ALLOW_FEC_DIS_AUTO,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 05cb9dd7035a..c018f6ff8ee2 100644
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
index 9619bdb9e49a..237a2296ff96 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3107,8 +3107,11 @@ enum ice_fc_mode ice_caps_to_fc_mode(u8 caps)
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
@@ -3367,6 +3370,11 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 		/* Clear all FEC option bits. */
 		cfg->link_fec_opt &= ~ICE_AQC_PHY_FEC_MASK;
 		break;
+	case ICE_FEC_DIS_AUTO:
+		/* Set No FEC and auto FEC */
+		if (!ice_fw_supports_fec_dis_auto(hw))
+			return -EOPNOTSUPP;
+		fallthrough;
 	case ICE_FEC_AUTO:
 		/* AND auto FEC bit, and all caps bits. */
 		cfg->caps &= ICE_AQC_PHY_CAPS_MASK;
@@ -4984,26 +4992,41 @@ ice_aq_get_gpio(struct ice_hw *hw, u16 gpio_ctrl_handle, u8 pin_idx,
 }
 
 /**
- * ice_fw_supports_link_override
+ * ice_is_fw_min_ver
  * @hw: pointer to the hardware structure
+ * @maj: major version
+ * @min: minor version
+ * @patch: patch version
  *
- * Checks if the firmware supports link override
+ * Checks if the firmware is minimum version
  */
-bool ice_fw_supports_link_override(struct ice_hw *hw)
+static bool ice_is_fw_min_ver(struct ice_hw *hw, u8 maj, u8 min, u8 patch)
 {
-	if (hw->api_maj_ver == ICE_FW_API_LINK_OVERRIDE_MAJ) {
-		if (hw->api_min_ver > ICE_FW_API_LINK_OVERRIDE_MIN)
+	if (hw->api_maj_ver == maj) {
+		if (hw->api_min_ver > min)
 			return true;
-		if (hw->api_min_ver == ICE_FW_API_LINK_OVERRIDE_MIN &&
-		    hw->api_patch >= ICE_FW_API_LINK_OVERRIDE_PATCH)
+		if (hw->api_min_ver == min && hw->api_patch >= patch)
 			return true;
-	} else if (hw->api_maj_ver > ICE_FW_API_LINK_OVERRIDE_MAJ) {
+	} else if (hw->api_maj_ver > maj) {
 		return true;
 	}
 
 	return false;
 }
 
+/**
+ * ice_fw_supports_link_override
+ * @hw: pointer to the hardware structure
+ *
+ * Checks if the firmware supports link override
+ */
+bool ice_fw_supports_link_override(struct ice_hw *hw)
+{
+	return ice_is_fw_min_ver(hw, ICE_FW_API_LINK_OVERRIDE_MAJ,
+				 ICE_FW_API_LINK_OVERRIDE_MIN,
+				 ICE_FW_API_LINK_OVERRIDE_PATCH);
+}
+
 /**
  * ice_get_link_default_override
  * @ldo: pointer to the link default override struct
@@ -5134,16 +5157,9 @@ bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw)
 	if (hw->mac_type != ICE_MAC_E810)
 		return false;
 
-	if (hw->api_maj_ver == ICE_FW_API_LLDP_FLTR_MAJ) {
-		if (hw->api_min_ver > ICE_FW_API_LLDP_FLTR_MIN)
-			return true;
-		if (hw->api_min_ver == ICE_FW_API_LLDP_FLTR_MIN &&
-		    hw->api_patch >= ICE_FW_API_LLDP_FLTR_PATCH)
-			return true;
-	} else if (hw->api_maj_ver > ICE_FW_API_LLDP_FLTR_MAJ) {
-		return true;
-	}
-	return false;
+	return ice_is_fw_min_ver(hw, ICE_FW_API_LLDP_FLTR_MAJ,
+				 ICE_FW_API_LLDP_FLTR_MIN,
+				 ICE_FW_API_LLDP_FLTR_PATCH);
 }
 
 /**
@@ -5180,14 +5196,20 @@ ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add)
  */
 bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
 {
-	if (hw->api_maj_ver == ICE_FW_API_REPORT_DFLT_CFG_MAJ) {
-		if (hw->api_min_ver > ICE_FW_API_REPORT_DFLT_CFG_MIN)
-			return true;
-		if (hw->api_min_ver == ICE_FW_API_REPORT_DFLT_CFG_MIN &&
-		    hw->api_patch >= ICE_FW_API_REPORT_DFLT_CFG_PATCH)
-			return true;
-	} else if (hw->api_maj_ver > ICE_FW_API_REPORT_DFLT_CFG_MAJ) {
-		return true;
-	}
-	return false;
+	return ice_is_fw_min_ver(hw, ICE_FW_API_REPORT_DFLT_CFG_MAJ,
+				 ICE_FW_API_REPORT_DFLT_CFG_MIN,
+				 ICE_FW_API_REPORT_DFLT_CFG_PATCH);
+}
+
+/**
+ * ice_fw_supports_fec_dis_auto
+ * @hw: pointer to the hardware structure
+ *
+ * Checks if the firmware supports FEC disable in Auto FEC mode
+ */
+bool ice_fw_supports_fec_dis_auto(struct ice_hw *hw)
+{
+	return ice_is_fw_min_ver(hw, ICE_FW_API_FEC_DIS_AUTO_MAJ,
+				 ICE_FW_API_FEC_DIS_AUTO_MIN,
+				 ICE_FW_API_FEC_DIS_AUTO_PATCH);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 872ea7d2332d..6a7764dd264c 100644
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
index 70335f6e8524..46d8ac7906ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -166,6 +166,8 @@ static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
 	ICE_PRIV_FLAG("mdd-auto-reset-vf", ICE_FLAG_MDD_AUTO_RESET_VF),
 	ICE_PRIV_FLAG("vf-vlan-pruning", ICE_FLAG_VF_VLAN_PRUNING),
 	ICE_PRIV_FLAG("legacy-rx", ICE_FLAG_LEGACY_RX),
+	ICE_PRIV_FLAG("allow-no-fec-modules-in-auto",
+		      ICE_FLAG_ALLOW_FEC_DIS_AUTO),
 };
 
 #define ICE_PRIV_FLAG_ARRAY_SIZE	ARRAY_SIZE(ice_gstrings_priv_flags)
@@ -1012,11 +1014,16 @@ ice_set_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
 	enum ice_fec_mode fec;
 
 	switch (fecparam->fec) {
 	case ETHTOOL_FEC_AUTO:
-		fec = ICE_FEC_AUTO;
+		if (ice_fw_supports_fec_dis_auto(&pf->hw) &&
+		    test_bit(ICE_FLAG_ALLOW_FEC_DIS_AUTO, pf->flags))
+			fec = ICE_FEC_DIS_AUTO;
+		else
+			fec = ICE_FEC_AUTO;
 		break;
 	case ETHTOOL_FEC_RS:
 		fec = ICE_FEC_RS;
@@ -1029,7 +1036,7 @@ ice_set_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
 		fec = ICE_FEC_NONE;
 		break;
 	default:
-		dev_warn(ice_pf_to_dev(vsi->back), "Unsupported FEC mode: %d\n",
+		dev_warn(ice_pf_to_dev(pf), "Unsupported FEC mode: %d\n",
 			 fecparam->fec);
 		return -EINVAL;
 	}
@@ -1306,6 +1313,35 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 		change_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags);
 		ret = -EOPNOTSUPP;
 	}
+
+	if (test_bit(ICE_FLAG_ALLOW_FEC_DIS_AUTO, change_flags)) {
+		enum ice_fec_mode fec = ICE_FEC_AUTO;
+
+		if (!ice_fw_supports_fec_dis_auto(&pf->hw)) {
+			netdev_info(vsi->netdev, "Unsupported Firmware to Enable/Disable auto configuration of No FEC modules\n");
+			change_bit(ICE_FLAG_ALLOW_FEC_DIS_AUTO, pf->flags);
+			ret = -EOPNOTSUPP;
+			goto ethtool_exit;
+		}
+
+		/* Set FEC configuration */
+		if (test_bit(ICE_FLAG_ALLOW_FEC_DIS_AUTO, pf->flags))
+			fec = ICE_FEC_DIS_AUTO;
+
+		ret = ice_set_fec_cfg(netdev, fec);
+
+		/* If FEC configuration fails, restore original FEC flags */
+		if (ret) {
+			netdev_warn(vsi->netdev, "Failed to Enable/Disable auto configuration of No FEC modules\n");
+			change_bit(ICE_FLAG_ALLOW_FEC_DIS_AUTO, pf->flags);
+			goto ethtool_exit;
+		}
+
+		if (test_bit(ICE_FLAG_ALLOW_FEC_DIS_AUTO, pf->flags))
+			netdev_info(vsi->netdev, "Enabled auto configuration of No FEC modules\n");
+		else
+			netdev_info(vsi->netdev, "Auto configuration of No FEC modules reset to NVM defaults\n");
+	}
 ethtool_exit:
 	clear_bit(ICE_FLAG_ETHTOOL_CTXT, pf->flags);
 	return ret;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c1ac2f746714..2309a6b96a52 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2187,8 +2187,12 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	/* FEC */
 	ice_cfg_phy_fec(pi, cfg, phy->curr_user_fec_req);
 
-	/* Can't provide what was requested; use PHY capabilities */
-	if (cfg->link_fec_opt !=
+	/* Can't provide what was requested; use PHY capabilities.
+	 * The user can force FEC disabled Auto mode via ethtool private
+	 * flag allow-no-fec-modules-in-auto, so allow ICE_FEC_DIS_AUTO.
+	 */
+	if (phy->curr_user_fec_req != ICE_FEC_DIS_AUTO &&
+	    cfg->link_fec_opt !=
 	    (cfg->link_fec_opt & pcaps->link_fec_options)) {
 		cfg->caps |= pcaps->caps & ICE_AQC_PHY_EN_AUTO_FEC;
 		cfg->link_fec_opt = pcaps->link_fec_options;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index f2a518a1fd94..1584078ab83d 100644
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
@@ -1147,4 +1148,9 @@ struct ice_aq_get_set_rss_lut_params {
 #define ICE_FW_API_REPORT_DFLT_CFG_MIN		7
 #define ICE_FW_API_REPORT_DFLT_CFG_PATCH	3
 
+/* AQ API version for FEC disable in Auto FEC mode */
+#define ICE_FW_API_FEC_DIS_AUTO_MAJ		1
+#define ICE_FW_API_FEC_DIS_AUTO_MIN		7
+#define ICE_FW_API_FEC_DIS_AUTO_PATCH		5
+
 #endif /* _ICE_TYPE_H_ */
-- 
2.35.1

