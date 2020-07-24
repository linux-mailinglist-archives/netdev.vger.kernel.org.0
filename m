Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7BE22BA5D
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgGWXrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:41 -0400
Received: from mga05.intel.com ([192.55.52.43]:43317 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgGWXrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:33 -0400
IronPort-SDR: TqsRPRRETIo/MgfFBEc/wCs8kKdlVGina6dS2yqcPNKo+zAZ0iZUKZ5aebi3u6iNXc01X90G0u
 rIx27RnaXk7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515438"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515438"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:26 -0700
IronPort-SDR: uzlvgwvYa0gVj7P2BEH6+CaF6F9QNBsfpcYf/oPxHIuXRe+JJUhXf5NZx9cijyli/8eQ6lkPeT
 YGw0BO9qjRIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742304"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Evan Swanson <evan.swanson@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 08/15] ice: add link lenient and default override support
Date:   Thu, 23 Jul 2020 16:47:13 -0700
Message-Id: <20200723234720.1547308-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Adds functions to check for link override firmware support and get
the override settings for a port. The previously supported/default link
mode was strict mode.

In strict mode link is configured based on get PHY capabilities PHY types
with media.

Lenient mode is now the default link mode. In lenient mode the link is
configured based on get PHY capabilities PHY types without media. This
allows the user to configure link that the media does not report. Limit the
minimum supported link mode to 25G for devices that support 100G, and 1G
for devices that support less than 100G.

Default override is only supported in lenient mode. If default override
is supported and enabled, then default override values are used for
configuring speed and FEC. Default override provide persistent link
settings in the NVM.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Evan Swanson <evan.swanson@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   3 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   5 +-
 drivers/net/ethernet/intel/ice/ice_common.c   | 170 +++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   8 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 519 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_main.c     |  99 +++-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h      |   3 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  35 ++
 9 files changed, 628 insertions(+), 216 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 132abfd068df..e67f4290fa92 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -222,6 +222,7 @@ enum ice_state {
 	__ICE_OICR_INTR_DIS,		/* Global OICR interrupt disabled */
 	__ICE_MDD_VF_PRINT_PENDING,	/* set when MDD event handle */
 	__ICE_VF_RESETS_DISABLED,	/* disable resets during ice_remove */
+	__ICE_LINK_DEFAULT_OVERRIDE_PENDING,
 	__ICE_PHY_INIT_COMPLETE,
 	__ICE_STATE_NBITS		/* must be last */
 };
@@ -364,6 +365,7 @@ enum ice_pf_flags {
 	ICE_FLAG_LEGACY_RX,
 	ICE_FLAG_VF_TRUE_PROMISC_ENA,
 	ICE_FLAG_MDD_AUTO_RESET_VF,
+	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
@@ -441,6 +443,7 @@ struct ice_pf {
 
 	__le64 nvm_phy_type_lo; /* NVM PHY type low */
 	__le64 nvm_phy_type_hi; /* NVM PHY type high */
+	struct ice_link_default_override_tlv link_dflt_override;
 };
 
 struct ice_netdev_priv {
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 352f3b278698..02a8d46540dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -983,7 +983,8 @@ struct ice_aqc_get_phy_caps_data {
 #define ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN		BIT(6)
 #define ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN		BIT(7)
 #define ICE_AQC_PHY_FEC_MASK				ICE_M(0xdf, 0)
-	u8 rsvd1;	/* Byte 35 reserved */
+	u8 module_compliance_enforcement;
+#define ICE_AQC_MOD_ENFORCE_STRICT_MODE			BIT(0)
 	u8 extended_compliance_code;
 #define ICE_MODULE_TYPE_TOTAL_BYTE			3
 	u8 module_type[ICE_MODULE_TYPE_TOTAL_BYTE];
@@ -1036,7 +1037,7 @@ struct ice_aqc_set_phy_cfg_data {
 	__le16 eee_cap; /* Value from ice_aqc_get_phy_caps */
 	__le16 eeer_value;
 	u8 link_fec_opt; /* Use defines from ice_aqc_get_phy_caps */
-	u8 rsvd1;
+	u8 module_compliance_enforcement;
 };
 
 /* Set MAC Config command data structure (direct 0x0603) */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 803b894472ee..606e69086cb8 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -20,7 +20,40 @@ static enum ice_status ice_set_mac_type(struct ice_hw *hw)
 	if (hw->vendor_id != PCI_VENDOR_ID_INTEL)
 		return ICE_ERR_DEVICE_NOT_SUPPORTED;
 
-	hw->mac_type = ICE_MAC_GENERIC;
+	switch (hw->device_id) {
+	case ICE_DEV_ID_E810C_BACKPLANE:
+	case ICE_DEV_ID_E810C_QSFP:
+	case ICE_DEV_ID_E810C_SFP:
+	case ICE_DEV_ID_E810_XXV_SFP:
+		hw->mac_type = ICE_MAC_E810;
+		break;
+	case ICE_DEV_ID_E823C_10G_BASE_T:
+	case ICE_DEV_ID_E823C_BACKPLANE:
+	case ICE_DEV_ID_E823C_QSFP:
+	case ICE_DEV_ID_E823C_SFP:
+	case ICE_DEV_ID_E823C_SGMII:
+	case ICE_DEV_ID_E822C_10G_BASE_T:
+	case ICE_DEV_ID_E822C_BACKPLANE:
+	case ICE_DEV_ID_E822C_QSFP:
+	case ICE_DEV_ID_E822C_SFP:
+	case ICE_DEV_ID_E822C_SGMII:
+	case ICE_DEV_ID_E822L_10G_BASE_T:
+	case ICE_DEV_ID_E822L_BACKPLANE:
+	case ICE_DEV_ID_E822L_SFP:
+	case ICE_DEV_ID_E822L_SGMII:
+	case ICE_DEV_ID_E823L_10G_BASE_T:
+	case ICE_DEV_ID_E823L_1GBE:
+	case ICE_DEV_ID_E823L_BACKPLANE:
+	case ICE_DEV_ID_E823L_QSFP:
+	case ICE_DEV_ID_E823L_SFP:
+		hw->mac_type = ICE_MAC_GENERIC;
+		break;
+	default:
+		hw->mac_type = ICE_MAC_UNKNOWN;
+		break;
+	}
+
+	ice_debug(hw, ICE_DBG_INIT, "mac_type: %d\n", hw->mac_type);
 	return 0;
 }
 
@@ -2675,7 +2708,7 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 		goto out;
 	}
 
-	ice_copy_phy_caps_to_cfg(pcaps, &cfg);
+	ice_copy_phy_caps_to_cfg(pi, pcaps, &cfg);
 
 	/* Configure the set PHY data */
 	status = ice_cfg_phy_fc(pi, &cfg, pi->fc.req_mode);
@@ -2757,6 +2790,7 @@ ice_phy_caps_equals_cfg(struct ice_aqc_get_phy_caps_data *phy_caps,
 
 /**
  * ice_copy_phy_caps_to_cfg - Copy PHY ability data to configuration data
+ * @pi: port information structure
  * @caps: PHY ability structure to copy date from
  * @cfg: PHY configuration structure to copy data to
  *
@@ -2764,10 +2798,11 @@ ice_phy_caps_equals_cfg(struct ice_aqc_get_phy_caps_data *phy_caps,
  * data structure
  */
 void
-ice_copy_phy_caps_to_cfg(struct ice_aqc_get_phy_caps_data *caps,
+ice_copy_phy_caps_to_cfg(struct ice_port_info *pi,
+			 struct ice_aqc_get_phy_caps_data *caps,
 			 struct ice_aqc_set_phy_cfg_data *cfg)
 {
-	if (!caps || !cfg)
+	if (!pi || !caps || !cfg)
 		return;
 
 	memset(cfg, 0, sizeof(*cfg));
@@ -2778,6 +2813,19 @@ ice_copy_phy_caps_to_cfg(struct ice_aqc_get_phy_caps_data *caps,
 	cfg->eee_cap = caps->eee_cap;
 	cfg->eeer_value = caps->eeer_value;
 	cfg->link_fec_opt = caps->link_fec_options;
+	cfg->module_compliance_enforcement =
+		caps->module_compliance_enforcement;
+
+	if (ice_fw_supports_link_override(pi->hw)) {
+		struct ice_link_default_override_tlv tlv;
+
+		if (ice_get_link_default_override(&tlv, pi))
+			return;
+
+		if (tlv.options & ICE_LINK_OVERRIDE_STRICT_MODE)
+			cfg->module_compliance_enforcement |=
+				ICE_LINK_OVERRIDE_STRICT_MODE;
+	}
 }
 
 /**
@@ -2840,6 +2888,17 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 		break;
 	}
 
+	if (fec == ICE_FEC_AUTO && ice_fw_supports_link_override(pi->hw)) {
+		struct ice_link_default_override_tlv tlv;
+
+		if (ice_get_link_default_override(&tlv, pi))
+			goto out;
+
+		if (!(tlv.options & ICE_LINK_OVERRIDE_STRICT_MODE) &&
+		    (tlv.options & ICE_LINK_OVERRIDE_EN))
+			cfg->link_fec_opt = tlv.fec_options;
+	}
+
 out:
 	kfree(pcaps);
 
@@ -4043,3 +4102,106 @@ ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 		ice_debug(hw, ICE_DBG_SCHED, "query element failed\n");
 	return status;
 }
+
+/**
+ * ice_fw_supports_link_override
+ * @hw: pointer to the hardware structure
+ *
+ * Checks if the firmware supports link override
+ */
+bool ice_fw_supports_link_override(struct ice_hw *hw)
+{
+	/* Currently, only supported for E810 devices */
+	if (hw->mac_type != ICE_MAC_E810)
+		return false;
+
+	if (hw->api_maj_ver == ICE_FW_API_LINK_OVERRIDE_MAJ) {
+		if (hw->api_min_ver > ICE_FW_API_LINK_OVERRIDE_MIN)
+			return true;
+		if (hw->api_min_ver == ICE_FW_API_LINK_OVERRIDE_MIN &&
+		    hw->api_patch >= ICE_FW_API_LINK_OVERRIDE_PATCH)
+			return true;
+	} else if (hw->api_maj_ver > ICE_FW_API_LINK_OVERRIDE_MAJ) {
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * ice_get_link_default_override
+ * @ldo: pointer to the link default override struct
+ * @pi: pointer to the port info struct
+ *
+ * Gets the link default override for a port
+ */
+enum ice_status
+ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
+			      struct ice_port_info *pi)
+{
+	u16 i, tlv, tlv_len, tlv_start, buf, offset;
+	struct ice_hw *hw = pi->hw;
+	enum ice_status status;
+
+	status = ice_get_pfa_module_tlv(hw, &tlv, &tlv_len,
+					ICE_SR_LINK_DEFAULT_OVERRIDE_PTR);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Failed to read link override TLV.\n");
+		return status;
+	}
+
+	/* Each port has its own config; calculate for our port */
+	tlv_start = tlv + pi->lport * ICE_SR_PFA_LINK_OVERRIDE_WORDS +
+		ICE_SR_PFA_LINK_OVERRIDE_OFFSET;
+
+	/* link options first */
+	status = ice_read_sr_word(hw, tlv_start, &buf);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Failed to read override link options.\n");
+		return status;
+	}
+	ldo->options = buf & ICE_LINK_OVERRIDE_OPT_M;
+	ldo->phy_config = (buf & ICE_LINK_OVERRIDE_PHY_CFG_M) >>
+		ICE_LINK_OVERRIDE_PHY_CFG_S;
+
+	/* link PHY config */
+	offset = tlv_start + ICE_SR_PFA_LINK_OVERRIDE_FEC_OFFSET;
+	status = ice_read_sr_word(hw, offset, &buf);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Failed to read override phy config.\n");
+		return status;
+	}
+	ldo->fec_options = buf & ICE_LINK_OVERRIDE_FEC_OPT_M;
+
+	/* PHY types low */
+	offset = tlv_start + ICE_SR_PFA_LINK_OVERRIDE_PHY_OFFSET;
+	for (i = 0; i < ICE_SR_PFA_LINK_OVERRIDE_PHY_WORDS; i++) {
+		status = ice_read_sr_word(hw, (offset + i), &buf);
+		if (status) {
+			ice_debug(hw, ICE_DBG_INIT,
+				  "Failed to read override link options.\n");
+			return status;
+		}
+		/* shift 16 bits at a time to fill 64 bits */
+		ldo->phy_type_low |= ((u64)buf << (i * 16));
+	}
+
+	/* PHY types high */
+	offset = tlv_start + ICE_SR_PFA_LINK_OVERRIDE_PHY_OFFSET +
+		ICE_SR_PFA_LINK_OVERRIDE_PHY_WORDS;
+	for (i = 0; i < ICE_SR_PFA_LINK_OVERRIDE_PHY_WORDS; i++) {
+		status = ice_read_sr_word(hw, (offset + i), &buf);
+		if (status) {
+			ice_debug(hw, ICE_DBG_INIT,
+				  "Failed to read override link options.\n");
+			return status;
+		}
+		/* shift 16 bits at a time to fill 64 bits */
+		ldo->phy_type_high |= ((u64)buf << (i * 16));
+	}
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 5246f6138506..1b8b02bb4399 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -100,6 +100,11 @@ enum ice_status ice_clear_pf_cfg(struct ice_hw *hw);
 enum ice_status
 ice_aq_set_phy_cfg(struct ice_hw *hw, struct ice_port_info *pi,
 		   struct ice_aqc_set_phy_cfg_data *cfg, struct ice_sq_cd *cd);
+bool ice_fw_supports_link_override(struct ice_hw *hw);
+enum ice_status
+ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
+			      struct ice_port_info *pi);
+
 enum ice_fc_mode ice_caps_to_fc_mode(u8 caps);
 enum ice_fec_mode ice_caps_to_fec_mode(u8 caps, u8 fec_options);
 enum ice_status
@@ -112,7 +117,8 @@ bool
 ice_phy_caps_equals_cfg(struct ice_aqc_get_phy_caps_data *caps,
 			struct ice_aqc_set_phy_cfg_data *cfg);
 void
-ice_copy_phy_caps_to_cfg(struct ice_aqc_get_phy_caps_data *caps,
+ice_copy_phy_caps_to_cfg(struct ice_port_info *pi,
+			 struct ice_aqc_get_phy_caps_data *caps,
 			 struct ice_aqc_set_phy_cfg_data *cfg);
 enum ice_status
 ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a20474208b7d..f382faaf64e3 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1387,6 +1387,77 @@ ice_get_ethtool_stats(struct net_device *netdev,
 	}
 }
 
+#define ICE_PHY_TYPE_LOW_MASK_MIN_1G	(ICE_PHY_TYPE_LOW_100BASE_TX | \
+					 ICE_PHY_TYPE_LOW_100M_SGMII)
+
+#define ICE_PHY_TYPE_LOW_MASK_MIN_25G	(ICE_PHY_TYPE_LOW_MASK_MIN_1G | \
+					 ICE_PHY_TYPE_LOW_1000BASE_T | \
+					 ICE_PHY_TYPE_LOW_1000BASE_SX | \
+					 ICE_PHY_TYPE_LOW_1000BASE_LX | \
+					 ICE_PHY_TYPE_LOW_1000BASE_KX | \
+					 ICE_PHY_TYPE_LOW_1G_SGMII | \
+					 ICE_PHY_TYPE_LOW_2500BASE_T | \
+					 ICE_PHY_TYPE_LOW_2500BASE_X | \
+					 ICE_PHY_TYPE_LOW_2500BASE_KX | \
+					 ICE_PHY_TYPE_LOW_5GBASE_T | \
+					 ICE_PHY_TYPE_LOW_5GBASE_KR | \
+					 ICE_PHY_TYPE_LOW_10GBASE_T | \
+					 ICE_PHY_TYPE_LOW_10G_SFI_DA | \
+					 ICE_PHY_TYPE_LOW_10GBASE_SR | \
+					 ICE_PHY_TYPE_LOW_10GBASE_LR | \
+					 ICE_PHY_TYPE_LOW_10GBASE_KR_CR1 | \
+					 ICE_PHY_TYPE_LOW_10G_SFI_AOC_ACC | \
+					 ICE_PHY_TYPE_LOW_10G_SFI_C2C)
+
+#define ICE_PHY_TYPE_LOW_MASK_100G	(ICE_PHY_TYPE_LOW_100GBASE_CR4 | \
+					 ICE_PHY_TYPE_LOW_100GBASE_SR4 | \
+					 ICE_PHY_TYPE_LOW_100GBASE_LR4 | \
+					 ICE_PHY_TYPE_LOW_100GBASE_KR4 | \
+					 ICE_PHY_TYPE_LOW_100G_CAUI4_AOC_ACC | \
+					 ICE_PHY_TYPE_LOW_100G_CAUI4 | \
+					 ICE_PHY_TYPE_LOW_100G_AUI4_AOC_ACC | \
+					 ICE_PHY_TYPE_LOW_100G_AUI4 | \
+					 ICE_PHY_TYPE_LOW_100GBASE_CR_PAM4 | \
+					 ICE_PHY_TYPE_LOW_100GBASE_KR_PAM4 | \
+					 ICE_PHY_TYPE_LOW_100GBASE_CP2 | \
+					 ICE_PHY_TYPE_LOW_100GBASE_SR2 | \
+					 ICE_PHY_TYPE_LOW_100GBASE_DR)
+
+#define ICE_PHY_TYPE_HIGH_MASK_100G	(ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4 | \
+					 ICE_PHY_TYPE_HIGH_100G_CAUI2_AOC_ACC |\
+					 ICE_PHY_TYPE_HIGH_100G_CAUI2 | \
+					 ICE_PHY_TYPE_HIGH_100G_AUI2_AOC_ACC | \
+					 ICE_PHY_TYPE_HIGH_100G_AUI2)
+
+/**
+ * ice_mask_min_supported_speeds
+ * @phy_types_high: PHY type high
+ * @phy_types_low: PHY type low to apply minimum supported speeds mask
+ *
+ * Apply minimum supported speeds mask to PHY type low. These are the speeds
+ * for ethtool supported link mode.
+ */
+static
+void ice_mask_min_supported_speeds(u64 phy_types_high, u64 *phy_types_low)
+{
+	/* if QSFP connection with 100G speed, minimum supported speed is 25G */
+	if (*phy_types_low & ICE_PHY_TYPE_LOW_MASK_100G ||
+	    phy_types_high & ICE_PHY_TYPE_HIGH_MASK_100G)
+		*phy_types_low &= ~ICE_PHY_TYPE_LOW_MASK_MIN_25G;
+	else
+		*phy_types_low &= ~ICE_PHY_TYPE_LOW_MASK_MIN_1G;
+}
+
+#define ice_ethtool_advertise_link_mode(aq_link_speed, ethtool_link_mode)    \
+	do {								     \
+		if (req_speeds & (aq_link_speed) ||			     \
+		    (!req_speeds &&					     \
+		     (adv_phy_type_lo & phy_type_mask_lo ||		     \
+		      adv_phy_type_hi & phy_type_mask_hi)))		     \
+			ethtool_link_ksettings_add_link_mode(ks, advertising,\
+							ethtool_link_mode);  \
+	} while (0)
+
 /**
  * ice_phy_type_to_ethtool - convert the phy_types to ethtool link modes
  * @netdev: network interface device structure
@@ -1397,277 +1468,312 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 			struct ethtool_link_ksettings *ks)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_link_status *hw_link_info;
-	bool need_add_adv_mode = false;
 	struct ice_vsi *vsi = np->vsi;
-	u64 phy_types_high;
-	u64 phy_types_low;
+	struct ice_pf *pf = vsi->back;
+	u64 phy_type_mask_lo = 0;
+	u64 phy_type_mask_hi = 0;
+	u64 adv_phy_type_lo = 0;
+	u64 adv_phy_type_hi = 0;
+	u64 phy_types_high = 0;
+	u64 phy_types_low = 0;
+	u16 req_speeds;
+
+	req_speeds = vsi->port_info->phy.link_info.req_speeds;
+
+	/* Check if lenient mode is supported and enabled, or in strict mode.
+	 *
+	 * In lenient mode the Supported link modes are the PHY types without
+	 * media. The Advertising link mode is either 1. the user requested
+	 * speed, 2. the override PHY mask, or 3. the PHY types with media.
+	 *
+	 * In strict mode Supported link mode are the PHY type with media,
+	 * and Advertising link modes are the media PHY type or the speed
+	 * requested by user.
+	 */
+	if (test_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, pf->flags)) {
+		struct ice_link_default_override_tlv *ldo;
 
-	hw_link_info = &vsi->port_info->phy.link_info;
-	phy_types_low = vsi->port_info->phy.phy_type_low;
-	phy_types_high = vsi->port_info->phy.phy_type_high;
+		ldo = &pf->link_dflt_override;
+		phy_types_low = le64_to_cpu(pf->nvm_phy_type_lo);
+		phy_types_high = le64_to_cpu(pf->nvm_phy_type_hi);
+
+		ice_mask_min_supported_speeds(phy_types_high, &phy_types_low);
+
+		/* If override enabled and PHY mask set, then
+		 * Advertising link mode is the intersection of the PHY
+		 * types without media and the override PHY mask.
+		 */
+		if (ldo->options & ICE_LINK_OVERRIDE_EN &&
+		    (ldo->phy_type_low || ldo->phy_type_high)) {
+			adv_phy_type_lo =
+				le64_to_cpu(pf->nvm_phy_type_lo) &
+				ldo->phy_type_low;
+			adv_phy_type_hi =
+				le64_to_cpu(pf->nvm_phy_type_hi) &
+				ldo->phy_type_high;
+		}
+	} else {
+		phy_types_low = vsi->port_info->phy.phy_type_low;
+		phy_types_high = vsi->port_info->phy.phy_type_high;
+	}
+
+	/* If Advertising link mode PHY type is not using override PHY type,
+	 * then use PHY type with media.
+	 */
+	if (!adv_phy_type_lo && !adv_phy_type_hi) {
+		adv_phy_type_lo = vsi->port_info->phy.phy_type_low;
+		adv_phy_type_hi = vsi->port_info->phy.phy_type_high;
+	}
 
 	ethtool_link_ksettings_zero_link_mode(ks, supported);
 	ethtool_link_ksettings_zero_link_mode(ks, advertising);
 
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100BASE_TX ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100M_SGMII) {
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100BASE_TX |
+			   ICE_PHY_TYPE_LOW_100M_SGMII;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100baseT_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100MB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     100baseT_Full);
+
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100MB,
+						100baseT_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_1G_SGMII) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_1000BASE_T |
+			   ICE_PHY_TYPE_LOW_1G_SGMII;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     1000baseT_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_1000MB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     1000baseT_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_1000MB,
+						1000baseT_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_KX) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_1000BASE_KX;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     1000baseKX_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_1000MB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     1000baseKX_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_1000MB,
+						1000baseKX_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_SX ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_LX) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_1000BASE_SX |
+			   ICE_PHY_TYPE_LOW_1000BASE_LX;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     1000baseX_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_1000MB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     1000baseX_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_1000MB,
+						1000baseX_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_2500BASE_T) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_2500BASE_T;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     2500baseT_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_2500MB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     2500baseT_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_2500MB,
+						2500baseT_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_2500BASE_X ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_2500BASE_KX) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_2500BASE_X |
+			   ICE_PHY_TYPE_LOW_2500BASE_KX;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     2500baseX_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_2500MB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     2500baseX_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_2500MB,
+						2500baseX_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_5GBASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_5GBASE_KR) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_5GBASE_T |
+			   ICE_PHY_TYPE_LOW_5GBASE_KR;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     5000baseT_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_5GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     5000baseT_Full);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_10G_SFI_DA ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_10G_SFI_AOC_ACC ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_10G_SFI_C2C) {
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_5GB,
+						5000baseT_Full);
+	}
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_10GBASE_T |
+			   ICE_PHY_TYPE_LOW_10G_SFI_DA |
+			   ICE_PHY_TYPE_LOW_10G_SFI_AOC_ACC |
+			   ICE_PHY_TYPE_LOW_10G_SFI_C2C;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseT_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     10000baseT_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_10GB,
+						10000baseT_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_KR_CR1) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_10GBASE_KR_CR1;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseKR_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     10000baseKR_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_10GB,
+						10000baseKR_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_SR) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_10GBASE_SR;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseSR_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     10000baseSR_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_10GB,
+						10000baseSR_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_LR) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_10GBASE_LR;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseLR_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     10000baseLR_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_10GB,
+						10000baseLR_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_CR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_CR_S ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_CR1 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25G_AUI_AOC_ACC ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25G_AUI_C2C) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_25GBASE_T |
+			   ICE_PHY_TYPE_LOW_25GBASE_CR |
+			   ICE_PHY_TYPE_LOW_25GBASE_CR_S |
+			   ICE_PHY_TYPE_LOW_25GBASE_CR1 |
+			   ICE_PHY_TYPE_LOW_25G_AUI_AOC_ACC |
+			   ICE_PHY_TYPE_LOW_25G_AUI_C2C;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     25000baseCR_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_25GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     25000baseCR_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_25GB,
+						25000baseCR_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_SR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_LR) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_25GBASE_SR |
+			   ICE_PHY_TYPE_LOW_25GBASE_LR;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     25000baseSR_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_25GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     25000baseSR_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_25GB,
+						25000baseSR_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR_S ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR1) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_25GBASE_KR |
+			   ICE_PHY_TYPE_LOW_25GBASE_KR_S |
+			   ICE_PHY_TYPE_LOW_25GBASE_KR1;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     25000baseKR_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_25GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     25000baseKR_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_25GB,
+						25000baseKR_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_KR4) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_40GBASE_KR4;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseKR4_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     40000baseKR4_Full);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_CR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_40G_XLAUI_AOC_ACC ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_40G_XLAUI) {
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_40GB,
+						40000baseKR4_Full);
+	}
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_40GBASE_CR4 |
+			   ICE_PHY_TYPE_LOW_40G_XLAUI_AOC_ACC |
+			   ICE_PHY_TYPE_LOW_40G_XLAUI;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseCR4_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     40000baseCR4_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_40GB,
+						40000baseCR4_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_SR4) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_40GBASE_SR4;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseSR4_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     40000baseSR4_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_40GB,
+						40000baseSR4_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_LR4) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_40GBASE_LR4;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseLR4_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     40000baseLR4_Full);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_CR2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50G_LAUI2_AOC_ACC ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50G_LAUI2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50G_AUI2_AOC_ACC ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50G_AUI2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_CP ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_SR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50G_AUI1_AOC_ACC ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50G_AUI1) {
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_40GB,
+						40000baseLR4_Full);
+	}
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_50GBASE_CR2 |
+			   ICE_PHY_TYPE_LOW_50G_LAUI2_AOC_ACC |
+			   ICE_PHY_TYPE_LOW_50G_LAUI2 |
+			   ICE_PHY_TYPE_LOW_50G_AUI2_AOC_ACC |
+			   ICE_PHY_TYPE_LOW_50G_AUI2 |
+			   ICE_PHY_TYPE_LOW_50GBASE_CP |
+			   ICE_PHY_TYPE_LOW_50GBASE_SR |
+			   ICE_PHY_TYPE_LOW_50G_AUI1_AOC_ACC |
+			   ICE_PHY_TYPE_LOW_50G_AUI1;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     50000baseCR2_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_50GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     50000baseCR2_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_50GB,
+						50000baseCR2_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_KR2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_KR_PAM4) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_50GBASE_KR2 |
+			   ICE_PHY_TYPE_LOW_50GBASE_KR_PAM4;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     50000baseKR2_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_50GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     50000baseKR2_Full);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_SR2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_LR2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_FR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_LR) {
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_50GB,
+						50000baseKR2_Full);
+	}
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_50GBASE_SR2 |
+			   ICE_PHY_TYPE_LOW_50GBASE_LR2 |
+			   ICE_PHY_TYPE_LOW_50GBASE_FR |
+			   ICE_PHY_TYPE_LOW_50GBASE_LR;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     50000baseSR2_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_50GB)
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     50000baseSR2_Full);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_CR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100G_CAUI4_AOC_ACC ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100G_CAUI4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100G_AUI4_AOC_ACC ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100G_AUI4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_CR_PAM4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_CP2  ||
-	    phy_types_high & ICE_PHY_TYPE_HIGH_100G_CAUI2_AOC_ACC ||
-	    phy_types_high & ICE_PHY_TYPE_HIGH_100G_CAUI2 ||
-	    phy_types_high & ICE_PHY_TYPE_HIGH_100G_AUI2_AOC_ACC ||
-	    phy_types_high & ICE_PHY_TYPE_HIGH_100G_AUI2) {
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_50GB,
+						50000baseSR2_Full);
+	}
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_CR4 |
+			   ICE_PHY_TYPE_LOW_100G_CAUI4_AOC_ACC |
+			   ICE_PHY_TYPE_LOW_100G_CAUI4 |
+			   ICE_PHY_TYPE_LOW_100G_AUI4_AOC_ACC |
+			   ICE_PHY_TYPE_LOW_100G_AUI4 |
+			   ICE_PHY_TYPE_LOW_100GBASE_CR_PAM4 |
+			   ICE_PHY_TYPE_LOW_100GBASE_CP2;
+	phy_type_mask_hi = ICE_PHY_TYPE_HIGH_100G_CAUI2_AOC_ACC |
+			   ICE_PHY_TYPE_HIGH_100G_CAUI2 |
+			   ICE_PHY_TYPE_HIGH_100G_AUI2_AOC_ACC |
+			   ICE_PHY_TYPE_HIGH_100G_AUI2;
+	if (phy_types_low & phy_type_mask_lo ||
+	    phy_types_high & phy_type_mask_hi) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseCR4_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
-			need_add_adv_mode = true;
-	}
-	if (need_add_adv_mode) {
-		need_add_adv_mode = false;
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     100000baseCR4_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
+						100000baseCR4_Full);
 	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_SR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_SR2) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_SR4 |
+			   ICE_PHY_TYPE_LOW_100GBASE_SR2;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseSR4_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
-			need_add_adv_mode = true;
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
+						100000baseSR4_Full);
 	}
-	if (need_add_adv_mode) {
-		need_add_adv_mode = false;
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     100000baseSR4_Full);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_LR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_DR) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_LR4 |
+			   ICE_PHY_TYPE_LOW_100GBASE_DR;
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseLR4_ER4_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
-			need_add_adv_mode = true;
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
+						100000baseLR4_ER4_Full);
 	}
-	if (need_add_adv_mode) {
-		need_add_adv_mode = false;
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     100000baseLR4_ER4_Full);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_KR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_KR_PAM4 ||
-	    phy_types_high & ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4) {
+
+	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_KR4 |
+			   ICE_PHY_TYPE_LOW_100GBASE_KR_PAM4;
+	phy_type_mask_hi = ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4;
+	if (phy_types_low & phy_type_mask_lo ||
+	    phy_types_high & phy_type_mask_hi) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseKR4_Full);
-		if (!hw_link_info->req_speeds ||
-		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
-			need_add_adv_mode = true;
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
+						100000baseKR4_Full);
 	}
-	if (need_add_adv_mode)
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     100000baseKR4_Full);
 
 	/* Autoneg PHY types */
 	if (phy_types_low & ICE_PHY_TYPE_LOW_100BASE_TX ||
@@ -2105,8 +2211,8 @@ ice_set_link_ksettings(struct net_device *netdev,
 	struct ice_port_info *p;
 	u8 autoneg_changed = 0;
 	enum ice_status status;
-	u64 phy_type_high;
-	u64 phy_type_low;
+	u64 phy_type_high = 0;
+	u64 phy_type_low = 0;
 	int err = 0;
 	bool linkup;
 
@@ -2159,6 +2265,8 @@ ice_set_link_ksettings(struct net_device *netdev,
 	if (!bitmap_subset(copy_ks.link_modes.advertising,
 			   safe_ks.link_modes.supported,
 			   __ETHTOOL_LINK_MODE_MASK_NBITS)) {
+		if (!test_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, pf->flags))
+			netdev_info(netdev, "The selected speed is not supported by the current media. Please select a link speed that is supported by the current media.\n");
 		err = -EINVAL;
 		goto done;
 	}
@@ -2255,9 +2363,20 @@ ice_set_link_ksettings(struct net_device *netdev,
 			abilities->phy_type_low;
 
 	if (!(config.phy_type_high || config.phy_type_low)) {
-		netdev_info(netdev, "The selected speed is not supported by the current media. Please select a link speed that is supported by the current media.\n");
-		err = -EAGAIN;
-		goto done;
+		/* If there is no intersection and lenient mode is enabled, then
+		 * intersect the requested advertised speed with NVM media type
+		 * PHY types.
+		 */
+		if (test_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, pf->flags)) {
+			config.phy_type_high = cpu_to_le64(phy_type_high) &
+					       pf->nvm_phy_type_hi;
+			config.phy_type_low = cpu_to_le64(phy_type_low) &
+					      pf->nvm_phy_type_lo;
+		} else {
+			netdev_info(netdev, "The selected speed is not supported by the current media. Please select a link speed that is supported by the current media.\n");
+			err = -EAGAIN;
+			goto done;
+		}
 	}
 
 	/* If link is up put link down */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4c515bdf0c2c..9580c6096e56 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1413,7 +1413,7 @@ static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
  * ice_init_nvm_phy_type - Initialize the NVM PHY type
  * @pi: port info structure
  *
- * Initialize nvm_phy_type_[low|high]
+ * Initialize nvm_phy_type_[low|high] for link lenient mode support
  */
 static int ice_init_nvm_phy_type(struct ice_port_info *pi)
 {
@@ -1443,6 +1443,59 @@ static int ice_init_nvm_phy_type(struct ice_port_info *pi)
 	return err;
 }
 
+/**
+ * ice_init_link_dflt_override - Initialize link default override
+ * @pi: port info structure
+ */
+static void ice_init_link_dflt_override(struct ice_port_info *pi)
+{
+	struct ice_link_default_override_tlv *ldo;
+	struct ice_pf *pf = pi->hw->back;
+
+	ldo = &pf->link_dflt_override;
+	ice_get_link_default_override(ldo, pi);
+}
+
+/**
+ * ice_init_phy_cfg_dflt_override - Initialize PHY cfg default override settings
+ * @pi: port info structure
+ *
+ * If default override is enabled, initialized the user PHY cfg speed and FEC
+ * settings using the default override mask from the NVM.
+ *
+ * The PHY should only be configured with the default override settings the
+ * first time media is available. The __ICE_LINK_DEFAULT_OVERRIDE_PENDING state
+ * is used to indicate that the user PHY cfg default override is initialized
+ * and the PHY has not been configured with the default override settings. The
+ * state is set here, and cleared in ice_configure_phy the first time the PHY is
+ * configured.
+ */
+static void ice_init_phy_cfg_dflt_override(struct ice_port_info *pi)
+{
+	struct ice_link_default_override_tlv *ldo;
+	struct ice_aqc_set_phy_cfg_data *cfg;
+	struct ice_phy_info *phy = &pi->phy;
+	struct ice_pf *pf = pi->hw->back;
+
+	ldo = &pf->link_dflt_override;
+
+	/* If link default override is enabled, use to mask NVM PHY capabilities
+	 * for speed and FEC default configuration.
+	 */
+	cfg = &phy->curr_user_phy_cfg;
+
+	if (ldo->phy_type_low || ldo->phy_type_high) {
+		cfg->phy_type_low = pf->nvm_phy_type_lo &
+				    cpu_to_le64(ldo->phy_type_low);
+		cfg->phy_type_high = pf->nvm_phy_type_hi &
+				     cpu_to_le64(ldo->phy_type_high);
+	}
+	cfg->link_fec_opt = ldo->fec_options;
+	phy->curr_user_fec_req = ICE_FEC_AUTO;
+
+	set_bit(__ICE_LINK_DEFAULT_OVERRIDE_PENDING, pf->state);
+}
+
 /**
  * ice_init_phy_user_cfg - Initialize the PHY user configuration
  * @pi: port info structure
@@ -1485,12 +1538,31 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 		goto err_out;
 	}
 
-	ice_copy_phy_caps_to_cfg(pcaps, &pi->phy.curr_user_phy_cfg);
-	/* initialize PHY using topology with media */
+	ice_copy_phy_caps_to_cfg(pi, pcaps, &pi->phy.curr_user_phy_cfg);
+
+	/* check if lenient mode is supported and enabled */
+	if (ice_fw_supports_link_override(&vsi->back->hw) &&
+	    !(pcaps->module_compliance_enforcement &
+	      ICE_AQC_MOD_ENFORCE_STRICT_MODE)) {
+		set_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, pf->flags);
+
+		/* if link default override is enabled, initialize user PHY
+		 * configuration with link default override values
+		 */
+		if (pf->link_dflt_override.options & ICE_LINK_OVERRIDE_EN) {
+			ice_init_phy_cfg_dflt_override(pi);
+			goto out;
+		}
+	}
+
+	/* if link default override is not enabled, initialize PHY using
+	 * topology with media
+	 */
 	phy->curr_user_fec_req = ice_caps_to_fec_mode(pcaps->caps,
 						      pcaps->link_fec_options);
 	phy->curr_user_fc_req = ice_caps_to_fc_mode(pcaps->caps);
 
+out:
 	phy->curr_user_speed_req = ICE_AQ_LINK_SPEED_M;
 	set_bit(__ICE_PHY_INIT_COMPLETE, pf->state);
 err_out:
@@ -1511,7 +1583,6 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	struct device *dev = ice_pf_to_dev(vsi->back);
 	struct ice_aqc_get_phy_caps_data *pcaps;
 	struct ice_aqc_set_phy_cfg_data *cfg;
-	u64 phy_low = 0, phy_high = 0;
 	struct ice_port_info *pi;
 	enum ice_status status;
 	int err = 0;
@@ -1571,14 +1642,24 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 		goto done;
 	}
 
-	ice_copy_phy_caps_to_cfg(pcaps, cfg);
+	ice_copy_phy_caps_to_cfg(pi, pcaps, cfg);
 
 	/* Speed - If default override pending, use curr_user_phy_cfg set in
 	 * ice_init_phy_user_cfg_ldo.
 	 */
-	ice_update_phy_type(&phy_low, &phy_high, pi->phy.curr_user_speed_req);
-	cfg->phy_type_low = pcaps->phy_type_low & cpu_to_le64(phy_low);
-	cfg->phy_type_high = pcaps->phy_type_high & cpu_to_le64(phy_high);
+	if (test_and_clear_bit(__ICE_LINK_DEFAULT_OVERRIDE_PENDING,
+			       vsi->back->state)) {
+		cfg->phy_type_low = pi->phy.curr_user_phy_cfg.phy_type_low;
+		cfg->phy_type_high = pi->phy.curr_user_phy_cfg.phy_type_high;
+	} else {
+		u64 phy_low = 0, phy_high = 0;
+
+		ice_update_phy_type(&phy_low, &phy_high,
+				    pi->phy.curr_user_speed_req);
+		cfg->phy_type_low = pcaps->phy_type_low & cpu_to_le64(phy_low);
+		cfg->phy_type_high = pcaps->phy_type_high &
+				     cpu_to_le64(phy_high);
+	}
 
 	/* Can't provide what was requested; use PHY capabilities */
 	if (!cfg->phy_type_low && !cfg->phy_type_high) {
@@ -3749,6 +3830,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_alloc_sw_unroll;
 	}
 
+	ice_init_link_dflt_override(pf->hw.port_info);
+
 	/* if media available, initialize PHY settings */
 	if (pf->hw.port_info->phy.link_info.link_info &
 	    ICE_AQ_MEDIA_AVAILABLE) {
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index b1172a67573b..7c2a06892bbb 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -196,7 +196,7 @@ enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
  * Area (PFA) and returns the TLV pointer and length. The caller can
  * use these to read the variable length TLV value.
  */
-static enum ice_status
+enum ice_status
 ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
 		       u16 module_type)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index e3993c04c97a..999f273ba6ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -11,6 +11,9 @@ enum ice_status
 ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
 		  bool read_shadow_ram);
 enum ice_status
+ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
+		       u16 module_type);
+enum ice_status
 ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
 enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index f08913611ed9..08c616d9fffd 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -118,6 +118,7 @@ enum ice_set_fc_aq_failures {
 /* Various MAC types */
 enum ice_mac_type {
 	ICE_MAC_UNKNOWN = 0,
+	ICE_MAC_E810,
 	ICE_MAC_GENERIC,
 };
 
@@ -314,6 +315,28 @@ struct ice_nvm_info {
 	u8 blank_nvm_mode;        /* is NVM empty (no FW present) */
 };
 
+struct ice_link_default_override_tlv {
+	u8 options;
+#define ICE_LINK_OVERRIDE_OPT_M		0x3F
+#define ICE_LINK_OVERRIDE_STRICT_MODE	BIT(0)
+#define ICE_LINK_OVERRIDE_EPCT_DIS	BIT(1)
+#define ICE_LINK_OVERRIDE_PORT_DIS	BIT(2)
+#define ICE_LINK_OVERRIDE_EN		BIT(3)
+#define ICE_LINK_OVERRIDE_AUTO_LINK_DIS	BIT(4)
+#define ICE_LINK_OVERRIDE_EEE_EN	BIT(5)
+	u8 phy_config;
+#define ICE_LINK_OVERRIDE_PHY_CFG_S	8
+#define ICE_LINK_OVERRIDE_PHY_CFG_M	(0xC3 << ICE_LINK_OVERRIDE_PHY_CFG_S)
+#define ICE_LINK_OVERRIDE_PAUSE_M	0x3
+#define ICE_LINK_OVERRIDE_LESM_EN	BIT(6)
+#define ICE_LINK_OVERRIDE_AUTO_FEC_EN	BIT(7)
+	u8 fec_options;
+#define ICE_LINK_OVERRIDE_FEC_OPT_M	0xFF
+	u8 rsvd1;
+	u64 phy_type_low;
+	u64 phy_type_high;
+};
+
 #define ICE_NVM_VER_LEN	32
 
 /* netlist version information */
@@ -465,6 +488,7 @@ struct ice_dcb_app_priority_table {
 #define ICE_APP_SEL_ETHTYPE	0x1
 #define ICE_APP_SEL_TCPIP	0x2
 #define ICE_CEE_APP_SEL_ETHTYPE	0x0
+#define ICE_SR_LINK_DEFAULT_OVERRIDE_PTR	0x134
 #define ICE_CEE_APP_SEL_TCPIP	0x1
 
 struct ice_dcbx_cfg {
@@ -748,6 +772,17 @@ struct ice_hw_port_stats {
 #define ICE_OROM_VER_MASK		(0xff << ICE_OROM_VER_SHIFT)
 #define ICE_SR_PFA_PTR			0x40
 #define ICE_SR_SECTOR_SIZE_IN_WORDS	0x800
+
+/* Link override related */
+#define ICE_SR_PFA_LINK_OVERRIDE_WORDS		10
+#define ICE_SR_PFA_LINK_OVERRIDE_PHY_WORDS	4
+#define ICE_SR_PFA_LINK_OVERRIDE_OFFSET		2
+#define ICE_SR_PFA_LINK_OVERRIDE_FEC_OFFSET	1
+#define ICE_SR_PFA_LINK_OVERRIDE_PHY_OFFSET	2
+#define ICE_FW_API_LINK_OVERRIDE_MAJ		1
+#define ICE_FW_API_LINK_OVERRIDE_MIN		5
+#define ICE_FW_API_LINK_OVERRIDE_PATCH		2
+
 #define ICE_SR_WORDS_IN_1KB		512
 
 /* Hash redirection LUT for VSI - maximum array size */
-- 
2.26.2

