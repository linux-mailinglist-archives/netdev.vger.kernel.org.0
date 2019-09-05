Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E16AAD15
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403956AbfIEUeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:45343 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391666AbfIEUeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136566"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/16] ice: Allow for delayed LLDP MIB change registration
Date:   Thu,  5 Sep 2019 13:34:03 -0700
Message-Id: <20190905203406.4152-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Add an additional boolean parameter to the ice_init_dcb
function.  This boolean controls if the LLDP MIB change
events are registered for.  Also, add a new function
defined ice_cfg_lldp_mib_change.  The additional function
is necessary to be able to register for LLDP MIB change
events after calling ice_init_dcb.  The net effect of these
two changes is to allow a delayed registration for MIB change
events so that the driver is not accepting events before it
is ready for them.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c     | 39 ++++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_dcb.h     | 11 ++----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 10 ++++-
 drivers/net/ethernet/intel/ice/ice_main.c    |  2 +
 5 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index c5ee8d930611..dd7efff121bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -60,7 +60,7 @@ ice_aq_get_lldp_mib(struct ice_hw *hw, u8 bridge_type, u8 mib_type, void *buf,
  * Enable or Disable posting of an event on ARQ when LLDP MIB
  * associated with the interface changes (0x0A01)
  */
-enum ice_status
+static enum ice_status
 ice_aq_cfg_lldp_mib_change(struct ice_hw *hw, bool ena_update,
 			   struct ice_sq_cd *cd)
 {
@@ -943,10 +943,11 @@ enum ice_status ice_get_dcb_cfg(struct ice_port_info *pi)
 /**
  * ice_init_dcb
  * @hw: pointer to the HW struct
+ * @enable_mib_change: enable MIB change event
  *
  * Update DCB configuration from the Firmware
  */
-enum ice_status ice_init_dcb(struct ice_hw *hw)
+enum ice_status ice_init_dcb(struct ice_hw *hw, bool enable_mib_change)
 {
 	struct ice_port_info *pi = hw->port_info;
 	enum ice_status ret = 0;
@@ -972,9 +973,39 @@ enum ice_status ice_init_dcb(struct ice_hw *hw)
 	}
 
 	/* Configure the LLDP MIB change event */
-	ret = ice_aq_cfg_lldp_mib_change(hw, true, NULL);
+	if (enable_mib_change) {
+		ret = ice_aq_cfg_lldp_mib_change(hw, true, NULL);
+		if (!ret)
+			pi->is_sw_lldp = false;
+	}
+
+	return ret;
+}
+
+/**
+ * ice_cfg_lldp_mib_change
+ * @hw: pointer to the HW struct
+ * @ena_mib: enable/disable MIB change event
+ *
+ * Configure (disable/enable) MIB
+ */
+enum ice_status ice_cfg_lldp_mib_change(struct ice_hw *hw, bool ena_mib)
+{
+	struct ice_port_info *pi = hw->port_info;
+	enum ice_status ret;
+
+	if (!hw->func_caps.common_cap.dcb)
+		return ICE_ERR_NOT_SUPPORTED;
+
+	/* Get DCBX status */
+	pi->dcbx_status = ice_get_dcbx_status(hw);
+
+	if (pi->dcbx_status == ICE_DCBX_STATUS_DIS)
+		return ICE_ERR_NOT_READY;
+
+	ret = ice_aq_cfg_lldp_mib_change(hw, ena_mib, NULL);
 	if (!ret)
-		pi->is_sw_lldp = false;
+		pi->is_sw_lldp = !ena_mib;
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.h b/drivers/net/ethernet/intel/ice/ice_dcb.h
index 522e1452abe2..ee138f9bdc7c 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.h
@@ -125,7 +125,7 @@ ice_aq_get_dcb_cfg(struct ice_hw *hw, u8 mib_type, u8 bridgetype,
 		   struct ice_dcbx_cfg *dcbcfg);
 enum ice_status ice_get_dcb_cfg(struct ice_port_info *pi);
 enum ice_status ice_set_dcb_cfg(struct ice_port_info *pi);
-enum ice_status ice_init_dcb(struct ice_hw *hw);
+enum ice_status ice_init_dcb(struct ice_hw *hw, bool enable_mib_change);
 enum ice_status
 ice_query_port_ets(struct ice_port_info *pi,
 		   struct ice_aqc_port_ets_elem *buf, u16 buf_size,
@@ -139,9 +139,7 @@ ice_aq_start_lldp(struct ice_hw *hw, bool persist, struct ice_sq_cd *cd);
 enum ice_status
 ice_aq_start_stop_dcbx(struct ice_hw *hw, bool start_dcbx_agent,
 		       bool *dcbx_agent_status, struct ice_sq_cd *cd);
-enum ice_status
-ice_aq_cfg_lldp_mib_change(struct ice_hw *hw, bool ena_update,
-			   struct ice_sq_cd *cd);
+enum ice_status ice_cfg_lldp_mib_change(struct ice_hw *hw, bool ena_mib);
 #else /* CONFIG_DCB */
 static inline enum ice_status
 ice_aq_stop_lldp(struct ice_hw __always_unused *hw,
@@ -172,9 +170,8 @@ ice_aq_start_stop_dcbx(struct ice_hw __always_unused *hw,
 }
 
 static inline enum ice_status
-ice_aq_cfg_lldp_mib_change(struct ice_hw __always_unused *hw,
-			   bool __always_unused ena_update,
-			   struct ice_sq_cd __always_unused *cd)
+ice_cfg_lldp_mib_change(struct ice_hw __always_unused *hw,
+			bool __always_unused ena_mib)
 {
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 20f440a64650..97c22d4aae1d 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -318,7 +318,7 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 		goto dcb_error;
 	}
 
-	ice_init_dcb(&pf->hw);
+	ice_init_dcb(&pf->hw, true);
 	if (pf->hw.port_info->dcbx_status == ICE_DCBX_STATUS_DIS)
 		pf->hw.port_info->is_sw_lldp = true;
 	else
@@ -451,7 +451,7 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 
 	port_info = hw->port_info;
 
-	err = ice_init_dcb(hw);
+	err = ice_init_dcb(hw, false);
 	if (err && !port_info->is_sw_lldp) {
 		dev_err(&pf->pdev->dev, "Error initializing DCB %d\n", err);
 		goto dcb_init_err;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index ae9921b7de7b..d5db1426d484 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1206,8 +1206,8 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			enum ice_status status;
 
 			/* Disable FW LLDP engine */
-			status = ice_aq_cfg_lldp_mib_change(&pf->hw, false,
-							    NULL);
+			status = ice_cfg_lldp_mib_change(&pf->hw, false);
+
 			/* If unregistering for LLDP events fails, this is
 			 * not an error state, as there shouldn't be any
 			 * events to respond to.
@@ -1273,6 +1273,12 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			 * The FW LLDP engine will now be consuming them.
 			 */
 			ice_cfg_sw_lldp(vsi, false, false);
+
+			/* Register for MIB change events */
+			status = ice_cfg_lldp_mib_change(&pf->hw, true);
+			if (status)
+				dev_dbg(&pf->pdev->dev,
+					"Fail to enable MIB change events\n");
 		}
 	}
 	clear_bit(ICE_FLAG_ETHTOOL_CTXT, pf->flags);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8bb3b81876a9..2d92d8591a8a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2536,6 +2536,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		if (ice_init_pf_dcb(pf, false)) {
 			clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 			clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
+		} else {
+			ice_cfg_lldp_mib_change(&pf->hw, true);
 		}
 	}
 
-- 
2.21.0

