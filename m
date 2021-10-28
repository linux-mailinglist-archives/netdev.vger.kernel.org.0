Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D64043E802
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhJ1SLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:11:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:46223 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230121AbhJ1SLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 14:11:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230427781"
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="230427781"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 11:08:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="725849085"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Oct 2021 11:08:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 7/9] ice: Add support to print error on PHY FW load failure
Date:   Thu, 28 Oct 2021 11:06:57 -0700
Message-Id: <20211028180659.218912-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
References: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Some devices have support for loading the PHY FW and in some cases this
can fail. When this fails, the FW will set the corresponding bit in the
link info structure. Also, the FW will send a link event if the correct
link event mask bit is set. Add support for printing an error message
when the PHY FW load fails during any link configuration flow and the
link event flow.

Since ice_check_module_power() is already doing something very similar
add a new function ice_check_link_cfg_err() so any failures reported in
the link info's link_cfg_err member can be printed in this one function.

Also, add the new ICE_FLAG_PHY_FW_LOAD_FAILED bit to the PF's flags so
we don't constantly print this error message during link polling if the
value never changed.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  2 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 49 +++++++++++++++++--
 3 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 763add09559c..bf4ecd9a517c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -480,6 +480,7 @@ enum ice_pf_flags {
 	ICE_FLAG_NO_MEDIA,
 	ICE_FLAG_FW_LLDP_AGENT,
 	ICE_FLAG_MOD_POWER_UNSUPPORTED,
+	ICE_FLAG_PHY_FW_LOAD_FAILED,
 	ICE_FLAG_ETHTOOL_CTXT,		/* set when ethtool holds RTNL lock */
 	ICE_FLAG_LEGACY_RX,
 	ICE_FLAG_VF_TRUE_PROMISC_ENA,
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index a5425f0dce3f..4eef3488d86f 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1185,6 +1185,7 @@ struct ice_aqc_get_link_status_data {
 #define ICE_AQ_LINK_TOPO_UNSUPP_MEDIA	BIT(7)
 	u8 link_cfg_err;
 #define ICE_AQ_LINK_MODULE_POWER_UNSUPPORTED	BIT(5)
+#define ICE_AQ_LINK_EXTERNAL_PHY_LOAD_FAILURE	BIT(6)
 #define ICE_AQ_LINK_INVAL_MAX_POWER_LIMIT	BIT(7)
 	u8 link_info;
 #define ICE_AQ_LINK_UP			BIT(0)	/* Link Status */
@@ -1268,6 +1269,7 @@ struct ice_aqc_set_event_mask {
 #define ICE_AQ_LINK_EVENT_AN_COMPLETED		BIT(7)
 #define ICE_AQ_LINK_EVENT_MODULE_QUAL_FAIL	BIT(8)
 #define ICE_AQ_LINK_EVENT_PORT_TX_SUSPENDED	BIT(9)
+#define ICE_AQ_LINK_EVENT_PHY_FW_LOAD_FAIL	BIT(12)
 	u8	reserved1[6];
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2ebbbe1edd82..66112addfb9a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -936,6 +936,29 @@ static void ice_set_dflt_mib(struct ice_pf *pf)
 	kfree(lldpmib);
 }
 
+/**
+ * ice_check_phy_fw_load - check if PHY FW load failed
+ * @pf: pointer to PF struct
+ * @link_cfg_err: bitmap from the link info structure
+ *
+ * check if external PHY FW load failed and print an error message if it did
+ */
+static void ice_check_phy_fw_load(struct ice_pf *pf, u8 link_cfg_err)
+{
+	if (!(link_cfg_err & ICE_AQ_LINK_EXTERNAL_PHY_LOAD_FAILURE)) {
+		clear_bit(ICE_FLAG_PHY_FW_LOAD_FAILED, pf->flags);
+		return;
+	}
+
+	if (test_bit(ICE_FLAG_PHY_FW_LOAD_FAILED, pf->flags))
+		return;
+
+	if (link_cfg_err & ICE_AQ_LINK_EXTERNAL_PHY_LOAD_FAILURE) {
+		dev_err(ice_pf_to_dev(pf), "Device failed to load the FW for the external PHY. Please download and install the latest NVM for your device and try again\n");
+		set_bit(ICE_FLAG_PHY_FW_LOAD_FAILED, pf->flags);
+	}
+}
+
 /**
  * ice_check_module_power
  * @pf: pointer to PF struct
@@ -968,6 +991,20 @@ static void ice_check_module_power(struct ice_pf *pf, u8 link_cfg_err)
 	}
 }
 
+/**
+ * ice_check_link_cfg_err - check if link configuration failed
+ * @pf: pointer to the PF struct
+ * @link_cfg_err: bitmap from the link info structure
+ *
+ * print if any link configuration failure happens due to the value in the
+ * link_cfg_err parameter in the link info structure
+ */
+static void ice_check_link_cfg_err(struct ice_pf *pf, u8 link_cfg_err)
+{
+	ice_check_module_power(pf, link_cfg_err);
+	ice_check_phy_fw_load(pf, link_cfg_err);
+}
+
 /**
  * ice_link_event - process the link event
  * @pf: PF that the link event is associated with
@@ -1003,7 +1040,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 			pi->lport, ice_stat_str(status),
 			ice_aq_str(pi->hw->adminq.sq_last_status));
 
-	ice_check_module_power(pf, pi->phy.link_info.link_cfg_err);
+	ice_check_link_cfg_err(pf, pi->phy.link_info.link_cfg_err);
 
 	/* Check if the link state is up after updating link info, and treat
 	 * this event as an UP event since the link is actually UP now.
@@ -1081,7 +1118,8 @@ static int ice_init_link_events(struct ice_port_info *pi)
 	u16 mask;
 
 	mask = ~((u16)(ICE_AQ_LINK_EVENT_UPDOWN | ICE_AQ_LINK_EVENT_MEDIA_NA |
-		       ICE_AQ_LINK_EVENT_MODULE_QUAL_FAIL));
+		       ICE_AQ_LINK_EVENT_MODULE_QUAL_FAIL |
+		       ICE_AQ_LINK_EVENT_PHY_FW_LOAD_FAIL));
 
 	if (ice_aq_set_event_mask(pi->hw, pi->lport, mask, NULL)) {
 		dev_dbg(ice_hw_to_dev(pi->hw), "Failed to set link event mask for port %d\n",
@@ -2152,7 +2190,7 @@ static void ice_check_media_subtask(struct ice_pf *pf)
 	if (err)
 		return;
 
-	ice_check_module_power(pf, pi->phy.link_info.link_cfg_err);
+	ice_check_link_cfg_err(pf, pi->phy.link_info.link_cfg_err);
 
 	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
 		if (!test_bit(ICE_PHY_INIT_COMPLETE, pf->state))
@@ -4600,7 +4638,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	ice_init_link_dflt_override(pf->hw.port_info);
 
-	ice_check_module_power(pf, pf->hw.port_info->phy.link_info.link_cfg_err);
+	ice_check_link_cfg_err(pf,
+			       pf->hw.port_info->phy.link_info.link_cfg_err);
 
 	/* if media available, initialize PHY settings */
 	if (pf->hw.port_info->phy.link_info.link_info &
@@ -8402,7 +8441,7 @@ int ice_open_internal(struct net_device *netdev)
 		return -EIO;
 	}
 
-	ice_check_module_power(pf, pi->phy.link_info.link_cfg_err);
+	ice_check_link_cfg_err(pf, pi->phy.link_info.link_cfg_err);
 
 	/* Set PHY if there is media, otherwise, turn off PHY */
 	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
-- 
2.31.1

