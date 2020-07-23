Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3E422BA57
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgGWXrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:33987 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgGWXra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:30 -0400
IronPort-SDR: mk1+LW175XgYliq9f5yE7gmz2VgcW97BhsuCkYId/J58HDyY9shKBZpE8GC0XOAXxNquZRUTcG
 p4B198twBLvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="130200243"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="130200243"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:26 -0700
IronPort-SDR: 4k3OVLiiCfiIlajl6eqn6/OleXOU8NZli/c1u453CyVUUTocpfp78jhNZW48Fy1IlEXsOTO2me
 hBJKEQOVOQvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742300"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Chinh T Cao <chinh.t.cao@intel.com>,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 07/15] ice: restore PHY settings on media insertion
Date:   Thu, 23 Jul 2020 16:47:12 -0700
Message-Id: <20200723234720.1547308-8-anthony.l.nguyen@intel.com>
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

After the transition from no media to media FW will clear the
set-phy-cfg data set by the user. Save initial PHY settings and any
settings later requested by the user and use that data to restore PHY
settings on media insertion. Since PHY configuration is now being stored,
replace calls that were calling FW to get the configuration with the saved
copy.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   4 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c   | 145 ++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |  14 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 120 +++----
 drivers/net/ethernet/intel/ice/ice_main.c     | 308 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_type.h     |  21 ++
 7 files changed, 518 insertions(+), 95 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 2a0a69fe8b2b..132abfd068df 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -222,6 +222,7 @@ enum ice_state {
 	__ICE_OICR_INTR_DIS,		/* Global OICR interrupt disabled */
 	__ICE_MDD_VF_PRINT_PENDING,	/* set when MDD event handle */
 	__ICE_VF_RESETS_DISABLED,	/* disable resets during ice_remove */
+	__ICE_PHY_INIT_COMPLETE,
 	__ICE_STATE_NBITS		/* must be last */
 };
 
@@ -437,6 +438,9 @@ struct ice_pf {
 	u32 tx_timeout_recovery_level;
 	char int_name[ICE_INT_NAME_STR_LEN];
 	u32 sw_int_count;
+
+	__le64 nvm_phy_type_lo; /* NVM PHY type low */
+	__le64 nvm_phy_type_hi; /* NVM PHY type high */
 };
 
 struct ice_netdev_priv {
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 99c39249613a..352f3b278698 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1147,6 +1147,7 @@ struct ice_aqc_get_link_status_data {
 #define ICE_AQ_LINK_PWR_QSFP_CLASS_3	2
 #define ICE_AQ_LINK_PWR_QSFP_CLASS_4	3
 	__le16 link_speed;
+#define ICE_AQ_LINK_SPEED_M		0x7FF
 #define ICE_AQ_LINK_SPEED_10MB		BIT(0)
 #define ICE_AQ_LINK_SPEED_100MB		BIT(1)
 #define ICE_AQ_LINK_SPEED_1000MB	BIT(2)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 59890eeb8339..803b894472ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2424,7 +2424,7 @@ ice_update_phy_type(u64 *phy_type_low, u64 *phy_type_high,
 /**
  * ice_aq_set_phy_cfg
  * @hw: pointer to the HW struct
- * @lport: logical port number
+ * @pi: port info structure of the interested logical port
  * @cfg: structure with PHY configuration data to be set
  * @cd: pointer to command details structure or NULL
  *
@@ -2434,7 +2434,7 @@ ice_update_phy_type(u64 *phy_type_low, u64 *phy_type_high,
  * parameters. This status will be indicated by the command response (0x0601).
  */
 enum ice_status
-ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
+ice_aq_set_phy_cfg(struct ice_hw *hw, struct ice_port_info *pi,
 		   struct ice_aqc_set_phy_cfg_data *cfg, struct ice_sq_cd *cd)
 {
 	struct ice_aq_desc desc;
@@ -2453,7 +2453,7 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
 	}
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_phy_cfg);
-	desc.params.set_phy.lport_num = lport;
+	desc.params.set_phy.lport_num = pi->lport;
 	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
 
 	ice_debug(hw, ICE_DBG_LINK, "phy_type_low = 0x%llx\n",
@@ -2471,6 +2471,9 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
 	if (hw->adminq.sq_last_status == ICE_AQ_RC_EMODE)
 		status = 0;
 
+	if (!status)
+		pi->phy.curr_user_phy_cfg = *cfg;
+
 	return status;
 }
 
@@ -2514,17 +2517,99 @@ enum ice_status ice_update_link_info(struct ice_port_info *pi)
 	return status;
 }
 
+/**
+ * ice_cache_phy_user_req
+ * @pi: port information structure
+ * @cache_data: PHY logging data
+ * @cache_mode: PHY logging mode
+ *
+ * Log the user request on (FC, FEC, SPEED) for later use.
+ */
+static void
+ice_cache_phy_user_req(struct ice_port_info *pi,
+		       struct ice_phy_cache_mode_data cache_data,
+		       enum ice_phy_cache_mode cache_mode)
+{
+	if (!pi)
+		return;
+
+	switch (cache_mode) {
+	case ICE_FC_MODE:
+		pi->phy.curr_user_fc_req = cache_data.data.curr_user_fc_req;
+		break;
+	case ICE_SPEED_MODE:
+		pi->phy.curr_user_speed_req =
+			cache_data.data.curr_user_speed_req;
+		break;
+	case ICE_FEC_MODE:
+		pi->phy.curr_user_fec_req = cache_data.data.curr_user_fec_req;
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * ice_caps_to_fc_mode
+ * @caps: PHY capabilities
+ *
+ * Convert PHY FC capabilities to ice FC mode
+ */
+enum ice_fc_mode ice_caps_to_fc_mode(u8 caps)
+{
+	if (caps & ICE_AQC_PHY_EN_TX_LINK_PAUSE &&
+	    caps & ICE_AQC_PHY_EN_RX_LINK_PAUSE)
+		return ICE_FC_FULL;
+
+	if (caps & ICE_AQC_PHY_EN_TX_LINK_PAUSE)
+		return ICE_FC_TX_PAUSE;
+
+	if (caps & ICE_AQC_PHY_EN_RX_LINK_PAUSE)
+		return ICE_FC_RX_PAUSE;
+
+	return ICE_FC_NONE;
+}
+
+/**
+ * ice_caps_to_fec_mode
+ * @caps: PHY capabilities
+ * @fec_options: Link FEC options
+ *
+ * Convert PHY FEC capabilities to ice FEC mode
+ */
+enum ice_fec_mode ice_caps_to_fec_mode(u8 caps, u8 fec_options)
+{
+	if (caps & ICE_AQC_PHY_EN_AUTO_FEC)
+		return ICE_FEC_AUTO;
+
+	if (fec_options & (ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN |
+			   ICE_AQC_PHY_FEC_10G_KR_40G_KR4_REQ |
+			   ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN |
+			   ICE_AQC_PHY_FEC_25G_KR_REQ))
+		return ICE_FEC_BASER;
+
+	if (fec_options & (ICE_AQC_PHY_FEC_25G_RS_528_REQ |
+			   ICE_AQC_PHY_FEC_25G_RS_544_REQ |
+			   ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN))
+		return ICE_FEC_RS;
+
+	return ICE_FEC_NONE;
+}
+
 /**
  * ice_cfg_phy_fc - Configure PHY FC data based on FC mode
+ * @pi: port information structure
  * @cfg: PHY configuration data to set FC mode
  * @req_mode: FC mode to configure
  */
-static enum ice_status
-ice_cfg_phy_fc(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fc_mode req_mode)
+enum ice_status
+ice_cfg_phy_fc(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
+	       enum ice_fc_mode req_mode)
 {
+	struct ice_phy_cache_mode_data cache_data;
 	u8 pause_mask = 0x0;
 
-	if (!cfg)
+	if (!pi || !cfg)
 		return ICE_ERR_BAD_PTR;
 
 	switch (req_mode) {
@@ -2549,6 +2634,10 @@ ice_cfg_phy_fc(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fc_mode req_mode)
 	/* set the new capabilities */
 	cfg->caps |= pause_mask;
 
+	/* Cache user FC request */
+	cache_data.data.curr_user_fc_req = req_mode;
+	ice_cache_phy_user_req(pi, cache_data, ICE_FC_MODE);
+
 	return 0;
 }
 
@@ -2563,12 +2652,12 @@ ice_cfg_phy_fc(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fc_mode req_mode)
 enum ice_status
 ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 {
-	struct ice_aqc_set_phy_cfg_data  cfg = { 0 };
+	struct ice_aqc_set_phy_cfg_data cfg = { 0 };
 	struct ice_aqc_get_phy_caps_data *pcaps;
 	enum ice_status status;
 	struct ice_hw *hw;
 
-	if (!pi)
+	if (!pi || !aq_failures)
 		return ICE_ERR_BAD_PTR;
 
 	*aq_failures = 0;
@@ -2589,7 +2678,7 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 	ice_copy_phy_caps_to_cfg(pcaps, &cfg);
 
 	/* Configure the set PHY data */
-	status = ice_cfg_phy_fc(&cfg, pi->fc.req_mode);
+	status = ice_cfg_phy_fc(pi, &cfg, pi->fc.req_mode);
 	if (status)
 		goto out;
 
@@ -2601,7 +2690,7 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 		if (ena_auto_link_update)
 			cfg.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
 
-		status = ice_aq_set_phy_cfg(hw, pi->lport, &cfg, NULL);
+		status = ice_aq_set_phy_cfg(hw, pi, &cfg, NULL);
 		if (status) {
 			*aq_failures = ICE_SET_FC_AQ_FAIL_SET;
 			goto out;
@@ -2630,6 +2719,42 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 	return status;
 }
 
+/**
+ * ice_phy_caps_equals_cfg
+ * @phy_caps: PHY capabilities
+ * @phy_cfg: PHY configuration
+ *
+ * Helper function to determine if PHY capabilities matches PHY
+ * configuration
+ */
+bool
+ice_phy_caps_equals_cfg(struct ice_aqc_get_phy_caps_data *phy_caps,
+			struct ice_aqc_set_phy_cfg_data *phy_cfg)
+{
+	u8 caps_mask, cfg_mask;
+
+	if (!phy_caps || !phy_cfg)
+		return false;
+
+	/* These bits are not common between capabilities and configuration.
+	 * Do not use them to determine equality.
+	 */
+	caps_mask = ICE_AQC_PHY_CAPS_MASK & ~(ICE_AQC_PHY_AN_MODE |
+					      ICE_AQC_GET_PHY_EN_MOD_QUAL);
+	cfg_mask = ICE_AQ_PHY_ENA_VALID_MASK & ~ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
+
+	if (phy_caps->phy_type_low != phy_cfg->phy_type_low ||
+	    phy_caps->phy_type_high != phy_cfg->phy_type_high ||
+	    ((phy_caps->caps & caps_mask) != (phy_cfg->caps & cfg_mask)) ||
+	    phy_caps->low_power_ctrl != phy_cfg->low_power_ctrl ||
+	    phy_caps->eee_cap != phy_cfg->eee_cap ||
+	    phy_caps->eeer_value != phy_cfg->eeer_value ||
+	    phy_caps->link_fec_options != phy_cfg->link_fec_opt)
+		return false;
+
+	return true;
+}
+
 /**
  * ice_copy_phy_caps_to_cfg - Copy PHY ability data to configuration data
  * @caps: PHY ability structure to copy date from
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 2f912c671e6b..5246f6138506 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -98,18 +98,26 @@ ice_aq_manage_mac_write(struct ice_hw *hw, const u8 *mac_addr, u8 flags,
 			struct ice_sq_cd *cd);
 enum ice_status ice_clear_pf_cfg(struct ice_hw *hw);
 enum ice_status
-ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
+ice_aq_set_phy_cfg(struct ice_hw *hw, struct ice_port_info *pi,
 		   struct ice_aqc_set_phy_cfg_data *cfg, struct ice_sq_cd *cd);
+enum ice_fc_mode ice_caps_to_fc_mode(u8 caps);
+enum ice_fec_mode ice_caps_to_fec_mode(u8 caps, u8 fec_options);
 enum ice_status
 ice_set_fc(struct ice_port_info *pi, u8 *aq_failures,
 	   bool ena_auto_link_update);
 enum ice_status
-ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
-		enum ice_fec_mode fec);
+ice_cfg_phy_fc(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
+	       enum ice_fc_mode fc);
+bool
+ice_phy_caps_equals_cfg(struct ice_aqc_get_phy_caps_data *caps,
+			struct ice_aqc_set_phy_cfg_data *cfg);
 void
 ice_copy_phy_caps_to_cfg(struct ice_aqc_get_phy_caps_data *caps,
 			 struct ice_aqc_set_phy_cfg_data *cfg);
 enum ice_status
+ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
+		enum ice_fec_mode fec);
+enum ice_status
 ice_aq_set_link_restart_an(struct ice_port_info *pi, bool ena_link,
 			   struct ice_sq_cd *cd);
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4567b0175712..a20474208b7d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -966,11 +966,8 @@ static int ice_set_fec_cfg(struct net_device *netdev, enum ice_fec_mode req_fec)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_aqc_set_phy_cfg_data config = { 0 };
-	struct ice_aqc_get_phy_caps_data *caps;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_port_info *pi;
-	enum ice_status status;
-	int err = 0;
 
 	pi = vsi->port_info;
 	if (!pi)
@@ -982,30 +979,26 @@ static int ice_set_fec_cfg(struct net_device *netdev, enum ice_fec_mode req_fec)
 		return -EOPNOTSUPP;
 	}
 
-	/* Get last SW configuration */
-	caps = kzalloc(sizeof(*caps), GFP_KERNEL);
-	if (!caps)
-		return -ENOMEM;
-
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG,
-				     caps, NULL);
-	if (status) {
-		err = -EAGAIN;
-		goto done;
-	}
+	/* Proceed only if requesting different FEC mode */
+	if (pi->phy.curr_user_fec_req == req_fec)
+		return 0;
 
-	/* Copy SW configuration returned from PHY caps to PHY config */
-	ice_copy_phy_caps_to_cfg(caps, &config);
+	/* Copy the current user PHY configuration. The current user PHY
+	 * configuration is initialized during probe from PHY capabilities
+	 * software mode, and updated on set PHY configuration.
+	 */
+	memcpy(&config, &pi->phy.curr_user_phy_cfg, sizeof(config));
 
 	ice_cfg_phy_fec(pi, &config, req_fec);
 	config.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
 
-	if (ice_aq_set_phy_cfg(pi->hw, pi->lport, &config, NULL))
-		err = -EAGAIN;
+	if (ice_aq_set_phy_cfg(pi->hw, pi, &config, NULL))
+		return -EAGAIN;
 
-done:
-	kfree(caps);
-	return err;
+	/* Save requested FEC config */
+	pi->phy.curr_user_fec_req = req_fec;
+
+	return 0;
 }
 
 /**
@@ -2102,10 +2095,10 @@ static int
 ice_set_link_ksettings(struct net_device *netdev,
 		       const struct ethtool_link_ksettings *ks)
 {
-	u8 autoneg, timeout = TEST_SET_BITS_TIMEOUT, lport = 0;
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ethtool_link_ksettings safe_ks, copy_ks;
 	struct ice_aqc_get_phy_caps_data *abilities;
+	u8 autoneg, timeout = TEST_SET_BITS_TIMEOUT;
 	u16 adv_link_speed, curr_link_speed, idx;
 	struct ice_aqc_set_phy_cfg_data config;
 	struct ice_pf *pf = np->vsi->back;
@@ -2137,6 +2130,18 @@ ice_set_link_ksettings(struct net_device *netdev,
 	    p->phy.link_info.link_info & ICE_AQ_LINK_UP)
 		return -EOPNOTSUPP;
 
+	abilities = kzalloc(sizeof(*abilities), GFP_KERNEL);
+	if (!abilities)
+		return -ENOMEM;
+
+	/* Get the PHY capabilities based on media */
+	status = ice_aq_get_phy_caps(p, false, ICE_AQC_REPORT_TOPO_CAP,
+				     abilities, NULL);
+	if (status) {
+		err = -EAGAIN;
+		goto done;
+	}
+
 	/* copy the ksettings to copy_ks to avoid modifying the original */
 	memcpy(&copy_ks, ks, sizeof(copy_ks));
 
@@ -2153,8 +2158,10 @@ ice_set_link_ksettings(struct net_device *netdev,
 	 */
 	if (!bitmap_subset(copy_ks.link_modes.advertising,
 			   safe_ks.link_modes.supported,
-			   __ETHTOOL_LINK_MODE_MASK_NBITS))
-		return -EINVAL;
+			   __ETHTOOL_LINK_MODE_MASK_NBITS)) {
+		err = -EINVAL;
+		goto done;
+	}
 
 	/* get our own copy of the bits to check against */
 	memset(&safe_ks, 0, sizeof(safe_ks));
@@ -2171,33 +2178,27 @@ ice_set_link_ksettings(struct net_device *netdev,
 	/* If copy_ks.base and safe_ks.base are not the same now, then they are
 	 * trying to set something that we do not support.
 	 */
-	if (memcmp(&copy_ks.base, &safe_ks.base, sizeof(copy_ks.base)))
-		return -EOPNOTSUPP;
+	if (memcmp(&copy_ks.base, &safe_ks.base, sizeof(copy_ks.base))) {
+		err = -EOPNOTSUPP;
+		goto done;
+	}
 
 	while (test_and_set_bit(__ICE_CFG_BUSY, pf->state)) {
 		timeout--;
-		if (!timeout)
-			return -EBUSY;
+		if (!timeout) {
+			err = -EBUSY;
+			goto done;
+		}
 		usleep_range(TEST_SET_BITS_SLEEP_MIN, TEST_SET_BITS_SLEEP_MAX);
 	}
 
-	abilities = kzalloc(sizeof(*abilities), GFP_KERNEL);
-	if (!abilities)
-		return -ENOMEM;
-
-	/* Get the current PHY config */
-	status = ice_aq_get_phy_caps(p, false, ICE_AQC_REPORT_SW_CFG, abilities,
-				     NULL);
-	if (status) {
-		err = -EAGAIN;
-		goto done;
-	}
+	/* Copy the current user PHY configuration. The current user PHY
+	 * configuration is initialized during probe from PHY capabilities
+	 * software mode, and updated on set PHY configuration.
+	 */
+	memcpy(&config, &p->phy.curr_user_phy_cfg, sizeof(config));
 
-	/* Copy abilities to config in case autoneg is not set below */
-	memset(&config, 0, sizeof(config));
-	config.caps = abilities->caps & ~ICE_AQC_PHY_AN_MODE;
-	if (abilities->caps & ICE_AQC_PHY_AN_MODE)
-		config.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
+	config.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
 
 	/* Check autoneg */
 	err = ice_setup_autoneg(p, &safe_ks, &config, autoneg, &autoneg_changed,
@@ -2232,26 +2233,30 @@ ice_set_link_ksettings(struct net_device *netdev,
 		goto done;
 	}
 
-	/* copy over the rest of the abilities */
-	config.low_power_ctrl = abilities->low_power_ctrl;
-	config.eee_cap = abilities->eee_cap;
-	config.eeer_value = abilities->eeer_value;
-	config.link_fec_opt = abilities->link_fec_options;
-
 	/* save the requested speeds */
 	p->phy.link_info.req_speeds = adv_link_speed;
 
 	/* set link and auto negotiation so changes take effect */
 	config.caps |= ICE_AQ_PHY_ENA_LINK;
 
-	if (phy_type_low || phy_type_high) {
-		config.phy_type_high = cpu_to_le64(phy_type_high) &
+	/* check if there is a PHY type for the requested advertised speed */
+	if (!(phy_type_low || phy_type_high)) {
+		netdev_info(netdev, "The selected speed is not supported by the current media. Please select a link speed that is supported by the current media.\n");
+		err = -EAGAIN;
+		goto done;
+	}
+
+	/* intersect requested advertised speed PHY types with media PHY types
+	 * for set PHY configuration
+	 */
+	config.phy_type_high = cpu_to_le64(phy_type_high) &
 			abilities->phy_type_high;
-		config.phy_type_low = cpu_to_le64(phy_type_low) &
+	config.phy_type_low = cpu_to_le64(phy_type_low) &
 			abilities->phy_type_low;
-	} else {
+
+	if (!(config.phy_type_high || config.phy_type_low)) {
+		netdev_info(netdev, "The selected speed is not supported by the current media. Please select a link speed that is supported by the current media.\n");
 		err = -EAGAIN;
-		netdev_info(netdev, "Nothing changed. No PHY_TYPE is corresponded to advertised link speed.\n");
 		goto done;
 	}
 
@@ -2266,12 +2271,15 @@ ice_set_link_ksettings(struct net_device *netdev,
 	}
 
 	/* make the aq call */
-	status = ice_aq_set_phy_cfg(&pf->hw, lport, &config, NULL);
+	status = ice_aq_set_phy_cfg(&pf->hw, p, &config, NULL);
 	if (status) {
 		netdev_info(netdev, "Set phy config failed,\n");
 		err = -EAGAIN;
+		goto done;
 	}
 
+	/* Save speed request */
+	p->phy.curr_user_speed_req = adv_link_speed;
 done:
 	kfree(abilities);
 	clear_bit(__ICE_CFG_BUSY, pf->state);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 794ec145d9cf..4c515bdf0c2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -796,10 +796,6 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 		dev_dbg(dev, "Failed to update link status and re-enable link events for port %d\n",
 			pi->lport);
 
-	/* if the old link up/down and speed is the same as the new */
-	if (link_up == old_link && link_speed == old_link_speed)
-		return result;
-
 	vsi = ice_get_main_vsi(pf);
 	if (!vsi || !vsi->port_info)
 		return -EINVAL;
@@ -817,6 +813,10 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 		}
 	}
 
+	/* if the old link up/down and speed is the same as the new */
+	if (link_up == old_link && link_speed == old_link_speed)
+		return result;
+
 	ice_dcb_rebuild(pf);
 	ice_vsi_link_event(vsi, link_up);
 	ice_print_link_msg(vsi, link_up);
@@ -1380,25 +1380,23 @@ static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
 	    link_up == !!(pi->phy.link_info.link_info & ICE_AQ_LINK_UP))
 		goto out;
 
-	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	/* Use the current user PHY configuration. The current user PHY
+	 * configuration is initialized during probe from PHY capabilities
+	 * software mode, and updated on set PHY configuration.
+	 */
+	cfg = kmemdup(&pi->phy.curr_user_phy_cfg, sizeof(*cfg), GFP_KERNEL);
 	if (!cfg) {
 		retcode = -ENOMEM;
 		goto out;
 	}
 
-	cfg->phy_type_low = pcaps->phy_type_low;
-	cfg->phy_type_high = pcaps->phy_type_high;
-	cfg->caps = pcaps->caps | ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
-	cfg->low_power_ctrl = pcaps->low_power_ctrl;
-	cfg->eee_cap = pcaps->eee_cap;
-	cfg->eeer_value = pcaps->eeer_value;
-	cfg->link_fec_opt = pcaps->link_fec_options;
+	cfg->caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
 	if (link_up)
 		cfg->caps |= ICE_AQ_PHY_ENA_LINK;
 	else
 		cfg->caps &= ~ICE_AQ_PHY_ENA_LINK;
 
-	retcode = ice_aq_set_phy_cfg(&vsi->back->hw, pi->lport, cfg, NULL);
+	retcode = ice_aq_set_phy_cfg(&vsi->back->hw, pi, cfg, NULL);
 	if (retcode) {
 		dev_err(dev, "Failed to set phy config, VSI %d error %d\n",
 			vsi->vsi_num, retcode);
@@ -1412,8 +1410,219 @@ static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
 }
 
 /**
- * ice_check_media_subtask - Check for media; bring link up if detected.
+ * ice_init_nvm_phy_type - Initialize the NVM PHY type
+ * @pi: port info structure
+ *
+ * Initialize nvm_phy_type_[low|high]
+ */
+static int ice_init_nvm_phy_type(struct ice_port_info *pi)
+{
+	struct ice_aqc_get_phy_caps_data *pcaps;
+	struct ice_pf *pf = pi->hw->back;
+	enum ice_status status;
+	int err = 0;
+
+	pcaps = kzalloc(sizeof(*pcaps), GFP_KERNEL);
+	if (!pcaps)
+		return -ENOMEM;
+
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_NVM_CAP, pcaps,
+				     NULL);
+
+	if (status) {
+		dev_err(ice_pf_to_dev(pf), "Get PHY capability failed.\n");
+		err = -EIO;
+		goto out;
+	}
+
+	pf->nvm_phy_type_hi = pcaps->phy_type_high;
+	pf->nvm_phy_type_lo = pcaps->phy_type_low;
+
+out:
+	kfree(pcaps);
+	return err;
+}
+
+/**
+ * ice_init_phy_user_cfg - Initialize the PHY user configuration
+ * @pi: port info structure
+ *
+ * Initialize the current user PHY configuration, speed, FEC, and FC requested
+ * mode to default. The PHY defaults are from get PHY capabilities topology
+ * with media so call when media is first available. An error is returned if
+ * called when media is not available. The PHY initialization completed state is
+ * set here.
+ *
+ * These configurations are used when setting PHY
+ * configuration. The user PHY configuration is updated on set PHY
+ * configuration. Returns 0 on success, negative on failure
+ */
+static int ice_init_phy_user_cfg(struct ice_port_info *pi)
+{
+	struct ice_aqc_get_phy_caps_data *pcaps;
+	struct ice_phy_info *phy = &pi->phy;
+	struct ice_pf *pf = pi->hw->back;
+	enum ice_status status;
+	struct ice_vsi *vsi;
+	int err = 0;
+
+	if (!(phy->link_info.link_info & ICE_AQ_MEDIA_AVAILABLE))
+		return -EIO;
+
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi)
+		return -EINVAL;
+
+	pcaps = kzalloc(sizeof(*pcaps), GFP_KERNEL);
+	if (!pcaps)
+		return -ENOMEM;
+
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP, pcaps,
+				     NULL);
+	if (status) {
+		dev_err(ice_pf_to_dev(pf), "Get PHY capability failed.\n");
+		err = -EIO;
+		goto err_out;
+	}
+
+	ice_copy_phy_caps_to_cfg(pcaps, &pi->phy.curr_user_phy_cfg);
+	/* initialize PHY using topology with media */
+	phy->curr_user_fec_req = ice_caps_to_fec_mode(pcaps->caps,
+						      pcaps->link_fec_options);
+	phy->curr_user_fc_req = ice_caps_to_fc_mode(pcaps->caps);
+
+	phy->curr_user_speed_req = ICE_AQ_LINK_SPEED_M;
+	set_bit(__ICE_PHY_INIT_COMPLETE, pf->state);
+err_out:
+	kfree(pcaps);
+	return err;
+}
+
+/**
+ * ice_configure_phy - configure PHY
+ * @vsi: VSI of PHY
+ *
+ * Set the PHY configuration. If the current PHY configuration is the same as
+ * the curr_user_phy_cfg, then do nothing to avoid link flap. Otherwise
+ * configure the based get PHY capabilities for topology with media.
+ */
+static int ice_configure_phy(struct ice_vsi *vsi)
+{
+	struct device *dev = ice_pf_to_dev(vsi->back);
+	struct ice_aqc_get_phy_caps_data *pcaps;
+	struct ice_aqc_set_phy_cfg_data *cfg;
+	u64 phy_low = 0, phy_high = 0;
+	struct ice_port_info *pi;
+	enum ice_status status;
+	int err = 0;
+
+	pi = vsi->port_info;
+	if (!pi)
+		return -EINVAL;
+
+	/* Ensure we have media as we cannot configure a medialess port */
+	if (!(pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE))
+		return -EPERM;
+
+	ice_print_topo_conflict(vsi);
+
+	if (vsi->port_info->phy.link_info.topo_media_conflict ==
+	    ICE_AQ_LINK_TOPO_UNSUPP_MEDIA)
+		return -EPERM;
+
+	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags))
+		return ice_force_phys_link_state(vsi, true);
+
+	pcaps = kzalloc(sizeof(*pcaps), GFP_KERNEL);
+	if (!pcaps)
+		return -ENOMEM;
+
+	/* Get current PHY config */
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+				     NULL);
+	if (status) {
+		dev_err(dev, "Failed to get PHY configuration, VSI %d error %s\n",
+			vsi->vsi_num, ice_stat_str(status));
+		err = -EIO;
+		goto done;
+	}
+
+	/* If PHY enable link is configured and configuration has not changed,
+	 * there's nothing to do
+	 */
+	if (pcaps->caps & ICE_AQC_PHY_EN_LINK &&
+	    ice_phy_caps_equals_cfg(pcaps, &pi->phy.curr_user_phy_cfg))
+		goto done;
+
+	/* Use PHY topology as baseline for configuration */
+	memset(pcaps, 0, sizeof(*pcaps));
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP, pcaps,
+				     NULL);
+	if (status) {
+		dev_err(dev, "Failed to get PHY topology, VSI %d error %s\n",
+			vsi->vsi_num, ice_stat_str(status));
+		err = -EIO;
+		goto done;
+	}
+
+	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	ice_copy_phy_caps_to_cfg(pcaps, cfg);
+
+	/* Speed - If default override pending, use curr_user_phy_cfg set in
+	 * ice_init_phy_user_cfg_ldo.
+	 */
+	ice_update_phy_type(&phy_low, &phy_high, pi->phy.curr_user_speed_req);
+	cfg->phy_type_low = pcaps->phy_type_low & cpu_to_le64(phy_low);
+	cfg->phy_type_high = pcaps->phy_type_high & cpu_to_le64(phy_high);
+
+	/* Can't provide what was requested; use PHY capabilities */
+	if (!cfg->phy_type_low && !cfg->phy_type_high) {
+		cfg->phy_type_low = pcaps->phy_type_low;
+		cfg->phy_type_high = pcaps->phy_type_high;
+	}
+
+	/* FEC */
+	ice_cfg_phy_fec(pi, cfg, pi->phy.curr_user_fec_req);
+
+	/* Can't provide what was requested; use PHY capabilities */
+	if (cfg->link_fec_opt !=
+	    (cfg->link_fec_opt & pcaps->link_fec_options)) {
+		cfg->caps |= pcaps->caps & ICE_AQC_PHY_EN_AUTO_FEC;
+		cfg->link_fec_opt = pcaps->link_fec_options;
+	}
+
+	/* Flow Control - always supported; no need to check against
+	 * capabilities
+	 */
+	ice_cfg_phy_fc(pi, cfg, pi->phy.curr_user_fc_req);
+
+	/* Enable link and link update */
+	cfg->caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT | ICE_AQ_PHY_ENA_LINK;
+
+	status = ice_aq_set_phy_cfg(&vsi->back->hw, pi, cfg, NULL);
+	if (status) {
+		dev_err(dev, "Failed to set phy config, VSI %d error %s\n",
+			vsi->vsi_num, ice_stat_str(status));
+		err = -EIO;
+	}
+
+	kfree(cfg);
+done:
+	kfree(pcaps);
+	return err;
+}
+
+/**
+ * ice_check_media_subtask - Check for media
  * @pf: pointer to PF struct
+ *
+ * If media is available, then initialize PHY user configuration if it is not
+ * been, and configure the PHY if the interface is up.
  */
 static void ice_check_media_subtask(struct ice_pf *pf)
 {
@@ -1421,15 +1630,12 @@ static void ice_check_media_subtask(struct ice_pf *pf)
 	struct ice_vsi *vsi;
 	int err;
 
-	vsi = ice_get_main_vsi(pf);
-	if (!vsi)
+	/* No need to check for media if it's already present */
+	if (!test_bit(ICE_FLAG_NO_MEDIA, pf->flags))
 		return;
 
-	/* No need to check for media if it's already present or the interface
-	 * is down
-	 */
-	if (!test_bit(ICE_FLAG_NO_MEDIA, pf->flags) ||
-	    test_bit(__ICE_DOWN, vsi->state))
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi)
 		return;
 
 	/* Refresh link info and check if media is present */
@@ -1439,10 +1645,19 @@ static void ice_check_media_subtask(struct ice_pf *pf)
 		return;
 
 	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
-		err = ice_force_phys_link_state(vsi, true);
-		if (err)
+		if (!test_bit(__ICE_PHY_INIT_COMPLETE, pf->state))
+			ice_init_phy_user_cfg(pi);
+
+		/* PHY settings are reset on media insertion, reconfigure
+		 * PHY to preserve settings.
+		 */
+		if (test_bit(__ICE_DOWN, vsi->state) &&
+		    test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags))
 			return;
-		clear_bit(ICE_FLAG_NO_MEDIA, pf->flags);
+
+		err = ice_configure_phy(vsi);
+		if (!err)
+			clear_bit(ICE_FLAG_NO_MEDIA, pf->flags);
 
 		/* A Link Status Event will be generated; the event handler
 		 * will complete bringing the interface up
@@ -3522,6 +3737,37 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_alloc_sw_unroll;
 	}
 
+	err = ice_init_nvm_phy_type(pf->hw.port_info);
+	if (err) {
+		dev_err(dev, "ice_init_nvm_phy_type failed: %d\n", err);
+		goto err_alloc_sw_unroll;
+	}
+
+	err = ice_update_link_info(pf->hw.port_info);
+	if (err) {
+		dev_err(dev, "ice_update_link_info failed: %d\n", err);
+		goto err_alloc_sw_unroll;
+	}
+
+	/* if media available, initialize PHY settings */
+	if (pf->hw.port_info->phy.link_info.link_info &
+	    ICE_AQ_MEDIA_AVAILABLE) {
+		err = ice_init_phy_user_cfg(pf->hw.port_info);
+		if (err) {
+			dev_err(dev, "ice_init_phy_user_cfg failed: %d\n", err);
+			goto err_alloc_sw_unroll;
+		}
+
+		if (!test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags)) {
+			struct ice_vsi *vsi = ice_get_main_vsi(pf);
+
+			if (vsi)
+				ice_configure_phy(vsi);
+		}
+	} else {
+		set_bit(ICE_FLAG_NO_MEDIA, pf->flags);
+	}
+
 	ice_verify_cacheline_size(pf);
 
 	/* Save wakeup reason register for later use */
@@ -6018,20 +6264,30 @@ int ice_open(struct net_device *netdev)
 
 	/* Set PHY if there is media, otherwise, turn off PHY */
 	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
-		err = ice_force_phys_link_state(vsi, true);
+		clear_bit(ICE_FLAG_NO_MEDIA, pf->flags);
+		if (!test_bit(__ICE_PHY_INIT_COMPLETE, pf->state)) {
+			err = ice_init_phy_user_cfg(pi);
+			if (err) {
+				netdev_err(netdev, "Failed to initialize PHY settings, error %d\n",
+					   err);
+				return err;
+			}
+		}
+
+		err = ice_configure_phy(vsi);
 		if (err) {
 			netdev_err(netdev, "Failed to set physical link up, error %d\n",
 				   err);
 			return err;
 		}
 	} else {
+		set_bit(ICE_FLAG_NO_MEDIA, pf->flags);
 		err = ice_aq_set_link_restart_an(pi, false, NULL);
 		if (err) {
 			netdev_err(netdev, "Failed to set PHY state, VSI %d error %d\n",
 				   vsi->vsi_num, err);
 			return err;
 		}
-		set_bit(ICE_FLAG_NO_MEDIA, vsi->back->flags);
 	}
 
 	err = ice_vsi_open(vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 21fe9221a6f3..f08913611ed9 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -87,6 +87,12 @@ enum ice_fc_mode {
 	ICE_FC_DFLT
 };
 
+enum ice_phy_cache_mode {
+	ICE_FC_MODE = 0,
+	ICE_SPEED_MODE,
+	ICE_FEC_MODE
+};
+
 enum ice_fec_mode {
 	ICE_FEC_NONE = 0,
 	ICE_FEC_RS,
@@ -94,6 +100,14 @@ enum ice_fec_mode {
 	ICE_FEC_AUTO
 };
 
+struct ice_phy_cache_mode_data {
+	union {
+		enum ice_fec_mode curr_user_fec_req;
+		enum ice_fc_mode curr_user_fc_req;
+		u16 curr_user_speed_req;
+	} data;
+};
+
 enum ice_set_fc_aq_failures {
 	ICE_SET_FC_AQ_FAIL_NONE = 0,
 	ICE_SET_FC_AQ_FAIL_GET,
@@ -160,6 +174,13 @@ struct ice_phy_info {
 	u64 phy_type_high;
 	enum ice_media_type media_type;
 	u8 get_link_info;
+	/* Please refer to struct ice_aqc_get_link_status_data to get
+	 * detail of enable bit in curr_user_speed_req
+	 */
+	u16 curr_user_speed_req;
+	enum ice_fec_mode curr_user_fec_req;
+	enum ice_fc_mode curr_user_fc_req;
+	struct ice_aqc_set_phy_cfg_data curr_user_phy_cfg;
 };
 
 /* protocol enumeration for filters */
-- 
2.26.2

