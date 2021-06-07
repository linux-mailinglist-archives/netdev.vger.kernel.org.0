Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BFB39E485
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhFGQxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:53:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:57113 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhFGQwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:47 -0400
IronPort-SDR: 1W+/u/sKFoSSb/ftFhWEu1VpJMJsFTrlR2LIjKb4BVnwFyNKqREC3d8Bfa/ZfqZ1nIEOG1LzkJ
 OhC9IoKLdzcw==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474565"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474565"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:55 -0700
IronPort-SDR: XqlYE1rEesURFuoTKZhfrJvirhIHGn6Xsj3ehl/FX+c8zzft0ngbH6/9YrxWK63t6UwO5ijuji
 RFVkHEBQDpZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841270"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Jeb Cramer <jeb.j.cramer@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 13/15] ice: Detect and report unsupported module power levels
Date:   Mon,  7 Jun 2021 09:53:23 -0700
Message-Id: <20210607165325.182087-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Determine whether an unsupported power configuration is preventing link
establishment by storing and checking the link_cfg_err_byte. Print error
messages when module power levels are unsupported. Also add a new flag
bit to prevent spamming said error messages.

Co-developed-by: Jeb Cramer <jeb.j.cramer@intel.com>
Signed-off-by: Jeb Cramer <jeb.j.cramer@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  6 ++-
 drivers/net/ethernet/intel/ice/ice_common.c   |  2 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 40 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_type.h     |  1 +
 5 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 21f8b36df11a..1fd2362f73b6 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -392,6 +392,7 @@ enum ice_pf_flags {
 	ICE_FLAG_TOTAL_PORT_SHUTDOWN_ENA,
 	ICE_FLAG_NO_MEDIA,
 	ICE_FLAG_FW_LLDP_AGENT,
+	ICE_FLAG_MOD_POWER_UNSUPPORTED,
 	ICE_FLAG_ETHTOOL_CTXT,		/* set when ethtool holds RTNL lock */
 	ICE_FLAG_LEGACY_RX,
 	ICE_FLAG_VF_TRUE_PROMISC_ENA,
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index ff11a618bef7..a9a7d2d1aca7 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1123,7 +1123,9 @@ struct ice_aqc_get_link_status_data {
 #define ICE_AQ_LINK_TOPO_UNDRUTIL_PRT	BIT(5)
 #define ICE_AQ_LINK_TOPO_UNDRUTIL_MEDIA	BIT(6)
 #define ICE_AQ_LINK_TOPO_UNSUPP_MEDIA	BIT(7)
-	u8 reserved1;
+	u8 link_cfg_err;
+#define ICE_AQ_LINK_MODULE_POWER_UNSUPPORTED	BIT(5)
+#define ICE_AQ_LINK_INVAL_MAX_POWER_LIMIT	BIT(7)
 	u8 link_info;
 #define ICE_AQ_LINK_UP			BIT(0)	/* Link Status */
 #define ICE_AQ_LINK_FAULT		BIT(1)
@@ -1166,7 +1168,7 @@ struct ice_aqc_get_link_status_data {
 #define ICE_AQ_CFG_PACING_TYPE_FIXED	ICE_AQ_CFG_PACING_TYPE_M
 	/* External Device Power Ability */
 	u8 power_desc;
-#define ICE_AQ_PWR_CLASS_M		0x3
+#define ICE_AQ_PWR_CLASS_M		0x3F
 #define ICE_AQ_LINK_PWR_BASET_LOW_HIGH	0
 #define ICE_AQ_LINK_PWR_BASET_HIGH	1
 #define ICE_AQ_LINK_PWR_QSFP_CLASS_1	0
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index b8cc737ea261..f687d1f6b765 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -425,6 +425,7 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 	li->phy_type_high = le64_to_cpu(link_data.phy_type_high);
 	*hw_media_type = ice_get_media_type(pi);
 	li->link_info = link_data.link_info;
+	li->link_cfg_err = link_data.link_cfg_err;
 	li->an_info = link_data.an_info;
 	li->ext_info = link_data.ext_info;
 	li->max_frame_size = le16_to_cpu(link_data.max_frame_size);
@@ -455,6 +456,7 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 		  (unsigned long long)li->phy_type_high);
 	ice_debug(hw, ICE_DBG_LINK, "	media_type = 0x%x\n", *hw_media_type);
 	ice_debug(hw, ICE_DBG_LINK, "	link_info = 0x%x\n", li->link_info);
+	ice_debug(hw, ICE_DBG_LINK, "	link_cfg_err = 0x%x\n", li->link_cfg_err);
 	ice_debug(hw, ICE_DBG_LINK, "	an_info = 0x%x\n", li->an_info);
 	ice_debug(hw, ICE_DBG_LINK, "	ext_info = 0x%x\n", li->ext_info);
 	ice_debug(hw, ICE_DBG_LINK, "	fec_info = 0x%x\n", li->fec_info);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7606ded59a84..4c0412d87b1a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -864,6 +864,38 @@ static void ice_set_dflt_mib(struct ice_pf *pf)
 	kfree(lldpmib);
 }
 
+/**
+ * ice_check_module_power
+ * @pf: pointer to PF struct
+ * @link_cfg_err: bitmap from the link info structure
+ *
+ * check module power level returned by a previous call to aq_get_link_info
+ * and print error messages if module power level is not supported
+ */
+static void ice_check_module_power(struct ice_pf *pf, u8 link_cfg_err)
+{
+	/* if module power level is supported, clear the flag */
+	if (!(link_cfg_err & (ICE_AQ_LINK_INVAL_MAX_POWER_LIMIT |
+			      ICE_AQ_LINK_MODULE_POWER_UNSUPPORTED))) {
+		clear_bit(ICE_FLAG_MOD_POWER_UNSUPPORTED, pf->flags);
+		return;
+	}
+
+	/* if ICE_FLAG_MOD_POWER_UNSUPPORTED was previously set and the
+	 * above block didn't clear this bit, there's nothing to do
+	 */
+	if (test_bit(ICE_FLAG_MOD_POWER_UNSUPPORTED, pf->flags))
+		return;
+
+	if (link_cfg_err & ICE_AQ_LINK_INVAL_MAX_POWER_LIMIT) {
+		dev_err(ice_pf_to_dev(pf), "The installed module is incompatible with the device's NVM image. Cannot start link\n");
+		set_bit(ICE_FLAG_MOD_POWER_UNSUPPORTED, pf->flags);
+	} else if (link_cfg_err & ICE_AQ_LINK_MODULE_POWER_UNSUPPORTED) {
+		dev_err(ice_pf_to_dev(pf), "The module's power requirements exceed the device's power supply. Cannot start link\n");
+		set_bit(ICE_FLAG_MOD_POWER_UNSUPPORTED, pf->flags);
+	}
+}
+
 /**
  * ice_link_event - process the link event
  * @pf: PF that the link event is associated with
@@ -899,6 +931,8 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 			pi->lport, ice_stat_str(status),
 			ice_aq_str(pi->hw->adminq.sq_last_status));
 
+	ice_check_module_power(pf, pi->phy.link_info.link_cfg_err);
+
 	/* Check if the link state is up after updating link info, and treat
 	 * this event as an UP event since the link is actually UP now.
 	 */
@@ -2013,6 +2047,8 @@ static void ice_check_media_subtask(struct ice_pf *pf)
 	if (err)
 		return;
 
+	ice_check_module_power(pf, pi->phy.link_info.link_cfg_err);
+
 	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
 		if (!test_bit(ICE_PHY_INIT_COMPLETE, pf->state))
 			ice_init_phy_user_cfg(pi);
@@ -4269,6 +4305,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	ice_init_link_dflt_override(pf->hw.port_info);
 
+	ice_check_module_power(pf, pf->hw.port_info->phy.link_info.link_cfg_err);
+
 	/* if media available, initialize PHY settings */
 	if (pf->hw.port_info->phy.link_info.link_info &
 	    ICE_AQ_MEDIA_AVAILABLE) {
@@ -6929,6 +6967,8 @@ int ice_open_internal(struct net_device *netdev)
 		return -EIO;
 	}
 
+	ice_check_module_power(pf, pi->phy.link_info.link_cfg_err);
+
 	/* Set PHY if there is media, otherwise, turn off PHY */
 	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
 		clear_bit(ICE_FLAG_NO_MEDIA, pf->flags);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 2e235646ede2..61ea46dd80b7 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -147,6 +147,7 @@ struct ice_link_status {
 	u16 max_frame_size;
 	u16 link_speed;
 	u16 req_speeds;
+	u8 link_cfg_err;
 	u8 lse_ena;	/* Link Status Event notification */
 	u8 link_info;
 	u8 an_info;
-- 
2.26.2

