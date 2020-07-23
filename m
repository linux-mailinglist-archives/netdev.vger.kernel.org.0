Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B5922BA59
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgGWXrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:43322 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbgGWXrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:32 -0400
IronPort-SDR: 8mQFf0F3MS1stKlnauLrB2IgTJsYS4gxKbC2xdUjMMD1UY1UxbjVi6dJNK8AG3EYQs36slQ/4V
 HwmWSs/ytiJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515434"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515434"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:26 -0700
IronPort-SDR: hdMFd3CIAYTP4QpxVh3+9XZUvZAXc2HUa4UOPej+9WeUlPcNQ91F356Azid+GkWgYDw62TC8H/
 fS05EctJQoeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742295"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 05/15] ice: refactor FC functions
Date:   Thu, 23 Jul 2020 16:47:10 -0700
Message-Id: <20200723234720.1547308-6-anthony.l.nguyen@intel.com>
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

Create a helper function for configuring requested flow control so that it
can be utilized by other functions looking to configure flow control
settings. Utilize the existing helper ice_copy_phy_caps_to_cfg() to copy a
PHY capability to configuration instead duplicating the code for it.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 75 +++++++++++++--------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 04e28090fef3..18bfd9a47ee0 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2515,28 +2515,19 @@ enum ice_status ice_update_link_info(struct ice_port_info *pi)
 }
 
 /**
- * ice_set_fc
- * @pi: port information structure
- * @aq_failures: pointer to status code, specific to ice_set_fc routine
- * @ena_auto_link_update: enable automatic link update
- *
- * Set the requested flow control mode.
+ * ice_cfg_phy_fc - Configure PHY FC data based on FC mode
+ * @cfg: PHY configuration data to set FC mode
+ * @req_mode: FC mode to configure
  */
-enum ice_status
-ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
+static enum ice_status
+ice_cfg_phy_fc(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fc_mode req_mode)
 {
-	struct ice_aqc_set_phy_cfg_data cfg = { 0 };
-	struct ice_aqc_get_phy_caps_data *pcaps;
-	enum ice_status status;
 	u8 pause_mask = 0x0;
-	struct ice_hw *hw;
 
-	if (!pi)
-		return ICE_ERR_PARAM;
-	hw = pi->hw;
-	*aq_failures = ICE_SET_FC_AQ_FAIL_NONE;
+	if (!cfg)
+		return ICE_ERR_BAD_PTR;
 
-	switch (pi->fc.req_mode) {
+	switch (req_mode) {
 	case ICE_FC_FULL:
 		pause_mask |= ICE_AQC_PHY_EN_TX_LINK_PAUSE;
 		pause_mask |= ICE_AQC_PHY_EN_RX_LINK_PAUSE;
@@ -2551,6 +2542,38 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 		break;
 	}
 
+	/* clear the old pause settings */
+	cfg->caps &= ~(ICE_AQC_PHY_EN_TX_LINK_PAUSE |
+		ICE_AQC_PHY_EN_RX_LINK_PAUSE);
+
+	/* set the new capabilities */
+	cfg->caps |= pause_mask;
+
+	return 0;
+}
+
+/**
+ * ice_set_fc
+ * @pi: port information structure
+ * @aq_failures: pointer to status code, specific to ice_set_fc routine
+ * @ena_auto_link_update: enable automatic link update
+ *
+ * Set the requested flow control mode.
+ */
+enum ice_status
+ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
+{
+	struct ice_aqc_set_phy_cfg_data  cfg = { 0 };
+	struct ice_aqc_get_phy_caps_data *pcaps;
+	enum ice_status status;
+	struct ice_hw *hw;
+
+	if (!pi)
+		return ICE_ERR_BAD_PTR;
+
+	*aq_failures = 0;
+	hw = pi->hw;
+
 	pcaps = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*pcaps), GFP_KERNEL);
 	if (!pcaps)
 		return ICE_ERR_NO_MEMORY;
@@ -2563,12 +2586,12 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 		goto out;
 	}
 
-	/* clear the old pause settings */
-	cfg.caps = pcaps->caps & ~(ICE_AQC_PHY_EN_TX_LINK_PAUSE |
-				   ICE_AQC_PHY_EN_RX_LINK_PAUSE);
+	ice_copy_phy_caps_to_cfg(pcaps, &cfg);
 
-	/* set the new capabilities */
-	cfg.caps |= pause_mask;
+	/* Configure the set PHY data */
+	status = ice_cfg_phy_fc(&cfg, pi->fc.req_mode);
+	if (status)
+		goto out;
 
 	/* If the capabilities have changed, then set the new config */
 	if (cfg.caps != pcaps->caps) {
@@ -2577,13 +2600,6 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 		/* Auto restart link so settings take effect */
 		if (ena_auto_link_update)
 			cfg.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
-		/* Copy over all the old settings */
-		cfg.phy_type_high = pcaps->phy_type_high;
-		cfg.phy_type_low = pcaps->phy_type_low;
-		cfg.low_power_ctrl = pcaps->low_power_ctrl;
-		cfg.eee_cap = pcaps->eee_cap;
-		cfg.eeer_value = pcaps->eeer_value;
-		cfg.link_fec_opt = pcaps->link_fec_options;
 
 		status = ice_aq_set_phy_cfg(hw, pi->lport, &cfg, NULL);
 		if (status) {
@@ -2629,6 +2645,7 @@ ice_copy_phy_caps_to_cfg(struct ice_aqc_get_phy_caps_data *caps,
 	if (!caps || !cfg)
 		return;
 
+	memset(cfg, 0, sizeof(*cfg));
 	cfg->phy_type_low = caps->phy_type_low;
 	cfg->phy_type_high = caps->phy_type_high;
 	cfg->caps = caps->caps;
-- 
2.26.2

