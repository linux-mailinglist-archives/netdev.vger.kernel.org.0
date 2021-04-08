Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15FA35895B
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhDHQMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:12:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:47829 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232023AbhDHQLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:53 -0400
IronPort-SDR: K62MYo9irp0AAWy+oZCGNjoKnyZe+a5ZWos7FXYXOmU89IGAAqd4cKX8vRQ06Sne9w9AKTKE4q
 0F+TqtuT9s9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="180707314"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="180707314"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:41 -0700
IronPort-SDR: hCW/2CMVa1ccJvIXBbBvNXjTMH2I6bU68GJBvAMQoj8LCKntT88Ds1kFWwTtqDlhc1t5QPGSUU
 TEAZrChDUXOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841429"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Mateusz Pacuszka <mateuszx.pacuszka@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 09/15] ice: Use default configuration mode for PHY configuration
Date:   Thu,  8 Apr 2021 09:13:15 -0700
Message-Id: <20210408161321.3218024-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Recent firmware supports a new "get PHY capabilities" mode
ICE_AQC_REPORT_DFLT_CFG which makes it unnecessary for the driver
to track and apply NVM based default link overrides.

If FW AQ API version supports it, use Report Default Configuration.
Add check function for Report Default Configuration support and update
accordingly.

Also change adv_phy_type_[lo|hi] to advert_phy_type[lo|hi] for
clarity.

Co-developed-by: Mateusz Pacuszka <mateuszx.pacuszka@intel.com>
Signed-off-by: Mateusz Pacuszka <mateuszx.pacuszka@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 12 ++--
 drivers/net/ethernet/intel/ice/ice_common.c   | 33 ++++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 59 +++++++++++--------
 drivers/net/ethernet/intel/ice/ice_main.c     | 35 +++++++----
 drivers/net/ethernet/intel/ice/ice_type.h     |  5 ++
 6 files changed, 103 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 3f3d51bf0019..5cdfe406af84 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -877,16 +877,18 @@ struct ice_aqc_get_phy_caps {
 	__le16 param0;
 	/* 18.0 - Report qualified modules */
 #define ICE_AQC_GET_PHY_RQM		BIT(0)
-	/* 18.1 - 18.2 : Report mode
-	 * 00b - Report NVM capabilities
-	 * 01b - Report topology capabilities
-	 * 10b - Report SW configured
+	/* 18.1 - 18.3 : Report mode
+	 * 000b - Report NVM capabilities
+	 * 001b - Report topology capabilities
+	 * 010b - Report SW configured
+	 * 100b - Report default capabilities
 	 */
 #define ICE_AQC_REPORT_MODE_S			1
-#define ICE_AQC_REPORT_MODE_M			(3 << ICE_AQC_REPORT_MODE_S)
+#define ICE_AQC_REPORT_MODE_M			(7 << ICE_AQC_REPORT_MODE_S)
 #define ICE_AQC_REPORT_TOPO_CAP_NO_MEDIA	0
 #define ICE_AQC_REPORT_TOPO_CAP_MEDIA		BIT(1)
 #define ICE_AQC_REPORT_ACTIVE_CFG		BIT(2)
+#define ICE_AQC_REPORT_DFLT_CFG		BIT(3)
 	__le32 reserved1;
 	__le32 addr_high;
 	__le32 addr_low;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 509dce475bff..8485450aff80 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -158,6 +158,10 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 		return ICE_ERR_PARAM;
 	hw = pi->hw;
 
+	if (report_mode == ICE_AQC_REPORT_DFLT_CFG &&
+	    !ice_fw_supports_report_dflt_cfg(hw))
+		return ICE_ERR_PARAM;
+
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_phy_caps);
 
 	if (qual_mods)
@@ -3034,16 +3038,21 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 {
 	struct ice_aqc_get_phy_caps_data *pcaps;
 	enum ice_status status;
+	struct ice_hw *hw;
 
 	if (!pi || !cfg)
 		return ICE_ERR_BAD_PTR;
 
+	hw = pi->hw;
+
 	pcaps = kzalloc(sizeof(*pcaps), GFP_KERNEL);
 	if (!pcaps)
 		return ICE_ERR_NO_MEMORY;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
-				     NULL);
+	status = ice_aq_get_phy_caps(pi, false,
+				     (ice_fw_supports_report_dflt_cfg(hw) ?
+				      ICE_AQC_REPORT_DFLT_CFG :
+				      ICE_AQC_REPORT_TOPO_CAP_MEDIA), pcaps, NULL);
 	if (status)
 		goto out;
 
@@ -4492,3 +4501,23 @@ ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add)
 
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
 }
+
+/**
+ * ice_fw_supports_report_dflt_cfg
+ * @hw: pointer to the hardware structure
+ *
+ * Checks if the firmware supports report default configuration
+ */
+bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
+{
+	if (hw->api_maj_ver == ICE_FW_API_REPORT_DFLT_CFG_MAJ) {
+		if (hw->api_min_ver > ICE_FW_API_REPORT_DFLT_CFG_MIN)
+			return true;
+		if (hw->api_min_ver == ICE_FW_API_REPORT_DFLT_CFG_MIN &&
+		    hw->api_patch >= ICE_FW_API_REPORT_DFLT_CFG_PATCH)
+			return true;
+	} else if (hw->api_maj_ver > ICE_FW_API_REPORT_DFLT_CFG_MAJ) {
+		return true;
+	}
+	return false;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index d14406b11c92..7a9d2dfb21a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -179,4 +179,5 @@ ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
 bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw);
 enum ice_status
 ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add);
+bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw);
 #endif /* _ICE_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 5dd84ccf6756..4ca8d5880cfc 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1445,8 +1445,8 @@ void ice_mask_min_supported_speeds(u64 phy_types_high, u64 *phy_types_low)
 	do {								     \
 		if (req_speeds & (aq_link_speed) ||			     \
 		    (!req_speeds &&					     \
-		     (adv_phy_type_lo & phy_type_mask_lo ||		     \
-		      adv_phy_type_hi & phy_type_mask_hi)))		     \
+		     (advert_phy_type_lo & phy_type_mask_lo ||		     \
+		      advert_phy_type_hi & phy_type_mask_hi)))		     \
 			ethtool_link_ksettings_add_link_mode(ks, advertising,\
 							ethtool_link_mode);  \
 	} while (0)
@@ -1463,10 +1463,10 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	u64 advert_phy_type_lo = 0;
+	u64 advert_phy_type_hi = 0;
 	u64 phy_type_mask_lo = 0;
 	u64 phy_type_mask_hi = 0;
-	u64 adv_phy_type_lo = 0;
-	u64 adv_phy_type_hi = 0;
 	u64 phy_types_high = 0;
 	u64 phy_types_low = 0;
 	u16 req_speeds;
@@ -1484,28 +1484,35 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	 * requested by user.
 	 */
 	if (test_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, pf->flags)) {
-		struct ice_link_default_override_tlv *ldo;
-
-		ldo = &pf->link_dflt_override;
 		phy_types_low = le64_to_cpu(pf->nvm_phy_type_lo);
 		phy_types_high = le64_to_cpu(pf->nvm_phy_type_hi);
 
 		ice_mask_min_supported_speeds(phy_types_high, &phy_types_low);
-
-		/* If override enabled and PHY mask set, then
-		 * Advertising link mode is the intersection of the PHY
-		 * types without media and the override PHY mask.
+		/* determine advertised modes based on link override only
+		 * if it's supported and if the FW doesn't abstract the
+		 * driver from having to account for link overrides
 		 */
-		if (ldo->options & ICE_LINK_OVERRIDE_EN &&
-		    (ldo->phy_type_low || ldo->phy_type_high)) {
-			adv_phy_type_lo =
-				le64_to_cpu(pf->nvm_phy_type_lo) &
-				ldo->phy_type_low;
-			adv_phy_type_hi =
-				le64_to_cpu(pf->nvm_phy_type_hi) &
-				ldo->phy_type_high;
+		if (ice_fw_supports_link_override(&pf->hw) &&
+		    !ice_fw_supports_report_dflt_cfg(&pf->hw)) {
+			struct ice_link_default_override_tlv *ldo;
+
+			ldo = &pf->link_dflt_override;
+			/* If override enabled and PHY mask set, then
+			 * Advertising link mode is the intersection of the PHY
+			 * types without media and the override PHY mask.
+			 */
+			if (ldo->options & ICE_LINK_OVERRIDE_EN &&
+			    (ldo->phy_type_low || ldo->phy_type_high)) {
+				advert_phy_type_lo =
+					le64_to_cpu(pf->nvm_phy_type_lo) &
+					ldo->phy_type_low;
+				advert_phy_type_hi =
+					le64_to_cpu(pf->nvm_phy_type_hi) &
+					ldo->phy_type_high;
+			}
 		}
 	} else {
+		/* strict mode */
 		phy_types_low = vsi->port_info->phy.phy_type_low;
 		phy_types_high = vsi->port_info->phy.phy_type_high;
 	}
@@ -1513,9 +1520,9 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	/* If Advertising link mode PHY type is not using override PHY type,
 	 * then use PHY type with media.
 	 */
-	if (!adv_phy_type_lo && !adv_phy_type_hi) {
-		adv_phy_type_lo = vsi->port_info->phy.phy_type_low;
-		adv_phy_type_hi = vsi->port_info->phy.phy_type_high;
+	if (!advert_phy_type_lo && !advert_phy_type_hi) {
+		advert_phy_type_lo = vsi->port_info->phy.phy_type_low;
+		advert_phy_type_hi = vsi->port_info->phy.phy_type_high;
 	}
 
 	ethtool_link_ksettings_zero_link_mode(ks, supported);
@@ -2227,8 +2234,12 @@ ice_set_link_ksettings(struct net_device *netdev,
 		return -ENOMEM;
 
 	/* Get the PHY capabilities based on media */
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
-				     phy_caps, NULL);
+	if (ice_fw_supports_report_dflt_cfg(pi->hw))
+		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_DFLT_CFG,
+					     phy_caps, NULL);
+	else
+		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
+					     phy_caps, NULL);
 	if (status) {
 		err = -EIO;
 		goto done;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b976de4b5e6f..6bc2215b674d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1732,7 +1732,7 @@ static void ice_init_link_dflt_override(struct ice_port_info *pi)
  * ice_init_phy_cfg_dflt_override - Initialize PHY cfg default override settings
  * @pi: port info structure
  *
- * If default override is enabled, initialized the user PHY cfg speed and FEC
+ * If default override is enabled, initialize the user PHY cfg speed and FEC
  * settings using the default override mask from the NVM.
  *
  * The PHY should only be configured with the default override settings the
@@ -1741,6 +1741,9 @@ static void ice_init_link_dflt_override(struct ice_port_info *pi)
  * and the PHY has not been configured with the default override settings. The
  * state is set here, and cleared in ice_configure_phy the first time the PHY is
  * configured.
+ *
+ * This function should be called only if the FW doesn't support default
+ * configuration mode, as reported by ice_fw_supports_report_dflt_cfg.
  */
 static void ice_init_phy_cfg_dflt_override(struct ice_port_info *pi)
 {
@@ -1802,8 +1805,12 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 	if (!pcaps)
 		return -ENOMEM;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
-				     NULL);
+	if (ice_fw_supports_report_dflt_cfg(pi->hw))
+		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_DFLT_CFG,
+					     pcaps, NULL);
+	else
+		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
+					     pcaps, NULL);
 	if (status) {
 		dev_err(ice_pf_to_dev(pf), "Get PHY capability failed.\n");
 		err = -EIO;
@@ -1818,17 +1825,19 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 	      ICE_AQC_MOD_ENFORCE_STRICT_MODE)) {
 		set_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, pf->flags);
 
-		/* if link default override is enabled, initialize user PHY
-		 * configuration with link default override values
+		/* if the FW supports default PHY configuration mode, then the driver
+		 * does not have to apply link override settings. If not,
+		 * initialize user PHY configuration with link override values
 		 */
-		if (pf->link_dflt_override.options & ICE_LINK_OVERRIDE_EN) {
+		if (!ice_fw_supports_report_dflt_cfg(pi->hw) &&
+		    (pf->link_dflt_override.options & ICE_LINK_OVERRIDE_EN)) {
 			ice_init_phy_cfg_dflt_override(pi);
 			goto out;
 		}
 	}
 
-	/* if link default override is not enabled, initialize PHY using
-	 * topology with media
+	/* if link default override is not enabled, set user flow control and
+	 * FEC settings based on what get_phy_caps returned
 	 */
 	phy->curr_user_fec_req = ice_caps_to_fec_mode(pcaps->caps,
 						      pcaps->link_fec_options);
@@ -1899,10 +1908,14 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 
 	/* Use PHY topology as baseline for configuration */
 	memset(pcaps, 0, sizeof(*pcaps));
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
-				     NULL);
+	if (ice_fw_supports_report_dflt_cfg(pi->hw))
+		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_DFLT_CFG,
+					     pcaps, NULL);
+	else
+		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
+					     pcaps, NULL);
 	if (status) {
-		dev_err(dev, "Failed to get PHY topology, VSI %d error %s\n",
+		dev_err(dev, "Failed to get PHY caps, VSI %d error %s\n",
 			vsi->vsi_num, ice_stat_str(status));
 		err = -EIO;
 		goto done;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 276ebcc309dc..2efc91b58c9e 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -941,4 +941,9 @@ struct ice_aq_get_set_rss_lut_params {
 #define ICE_FW_API_LLDP_FLTR_MIN	7
 #define ICE_FW_API_LLDP_FLTR_PATCH	1
 
+/* AQ API version for report default configuration */
+#define ICE_FW_API_REPORT_DFLT_CFG_MAJ		1
+#define ICE_FW_API_REPORT_DFLT_CFG_MIN		7
+#define ICE_FW_API_REPORT_DFLT_CFG_PATCH	3
+
 #endif /* _ICE_TYPE_H_ */
-- 
2.26.2

