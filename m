Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FD9358955
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhDHQLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:11:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:15195 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231909AbhDHQLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:51 -0400
IronPort-SDR: O7Lhk1HytjUU1tJV8fBOxRWjvCmjBGpAcreSqiBSk9rrqhWq2f3O8o8elNJiiJjnLFitz8rMdi
 39dnXWMTatBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="257557986"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="257557986"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:39 -0700
IronPort-SDR: e2wqLRhCyyWAeUoBIZaGQIXR75EtknllFWB7LdMViE81AR+h3A3+5+LkHytQZSZRpJMYhHHbKO
 OIsJdIghDRpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841403"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:39 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 04/15] ice: Ignore EMODE return for opcode 0x0605
Date:   Thu,  8 Apr 2021 09:13:10 -0700
Message-Id: <20210408161321.3218024-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

When link is owned by manageability, the driver is not allowed to fiddle
with link. FW returns ICE_AQ_RC_EMODE if the driver attempts to do so.
This patch adds a new function ice_set_link which abstracts the call to
ice_aq_set_link_restart_an and provides a clean way to turn on/off link.

While making this change, I also spotted that an int variable was being
used to hold both an ice_status return code and the Linux errno return
code. This pattern more often than not results in the driver inadvertently
returning ice_status back to kernel which is a major boo-boo. Clean it up.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 17 ++------
 drivers/net/ethernet/intel/ice/ice_lib.c     | 37 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h     |  2 +
 drivers/net/ethernet/intel/ice/ice_main.c    | 41 ++++++++------------
 4 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 84e42e598c85..0db31a89658a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1095,24 +1095,15 @@ static int ice_nway_reset(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
-	struct ice_port_info *pi;
-	enum ice_status status;
+	int err;
 
-	pi = vsi->port_info;
 	/* If VSI state is up, then restart autoneg with link up */
 	if (!test_bit(__ICE_DOWN, vsi->back->state))
-		status = ice_aq_set_link_restart_an(pi, true, NULL);
+		err = ice_set_link(vsi, true);
 	else
-		status = ice_aq_set_link_restart_an(pi, false, NULL);
+		err = ice_set_link(vsi, false);
 
-	if (status) {
-		netdev_info(netdev, "link restart failed, err %s aq_err %s\n",
-			    ice_stat_str(status),
-			    ice_aq_str(pi->hw->adminq.sq_last_status));
-		return -EIO;
-	}
-
-	return 0;
+	return err;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6041ca2830de..5edc0da8b8c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3423,3 +3423,40 @@ int ice_clear_dflt_vsi(struct ice_sw *sw)
 
 	return 0;
 }
+
+/**
+ * ice_set_link - turn on/off physical link
+ * @vsi: VSI to modify physical link on
+ * @ena: turn on/off physical link
+ */
+int ice_set_link(struct ice_vsi *vsi, bool ena)
+{
+	struct device *dev = ice_pf_to_dev(vsi->back);
+	struct ice_port_info *pi = vsi->port_info;
+	struct ice_hw *hw = pi->hw;
+	enum ice_status status;
+
+	if (vsi->type != ICE_VSI_PF)
+		return -EINVAL;
+
+	status = ice_aq_set_link_restart_an(pi, ena, NULL);
+
+	/* if link is owned by manageability, FW will return ICE_AQ_RC_EMODE.
+	 * this is not a fatal error, so print a warning message and return
+	 * a success code. Return an error if FW returns an error code other
+	 * than ICE_AQ_RC_EMODE
+	 */
+	if (status == ICE_ERR_AQ_ERROR) {
+		if (hw->adminq.sq_last_status == ICE_AQ_RC_EMODE)
+			dev_warn(dev, "can't set link to %s, err %s aq_err %s. not fatal, continuing\n",
+				 (ena ? "ON" : "OFF"), ice_stat_str(status),
+				 ice_aq_str(hw->adminq.sq_last_status));
+	} else if (status) {
+		dev_err(dev, "can't set link to %s, err %s aq_err %s\n",
+			(ena ? "ON" : "OFF"), ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		return -EIO;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 3da17895a2b1..462c3ab7abad 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -45,6 +45,8 @@ int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc);
 
 void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
 
+int ice_set_link(struct ice_vsi *vsi, bool ena);
+
 #ifdef CONFIG_DCB
 int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc);
 #endif /* CONFIG_DCB */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4379bbece4d9..b976de4b5e6f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -873,10 +873,10 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_phy_info *phy_info;
+	enum ice_status status;
 	struct ice_vsi *vsi;
 	u16 old_link_speed;
 	bool old_link;
-	int result;
 
 	phy_info = &pi->phy;
 	phy_info->link_info_old = phy_info->link_info;
@@ -887,10 +887,11 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	/* update the link info structures and re-enable link events,
 	 * don't bail on failure due to other book keeping needed
 	 */
-	result = ice_update_link_info(pi);
-	if (result)
-		dev_dbg(dev, "Failed to update link status and re-enable link events for port %d\n",
-			pi->lport);
+	status = ice_update_link_info(pi);
+	if (status)
+		dev_dbg(dev, "Failed to update link status on port %d, err %s aq_err %s\n",
+			pi->lport, ice_stat_str(status),
+			ice_aq_str(pi->hw->adminq.sq_last_status));
 
 	/* Check if the link state is up after updating link info, and treat
 	 * this event as an UP event since the link is actually UP now.
@@ -906,18 +907,12 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	if (!test_bit(ICE_FLAG_NO_MEDIA, pf->flags) &&
 	    !(pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE)) {
 		set_bit(ICE_FLAG_NO_MEDIA, pf->flags);
-
-		result = ice_aq_set_link_restart_an(pi, false, NULL);
-		if (result) {
-			dev_dbg(dev, "Failed to set link down, VSI %d error %d\n",
-				vsi->vsi_num, result);
-			return result;
-		}
+		ice_set_link(vsi, false);
 	}
 
 	/* if the old link up/down and speed is the same as the new */
 	if (link_up == old_link && link_speed == old_link_speed)
-		return result;
+		return 0;
 
 	if (ice_is_dcb_active(pf)) {
 		if (test_bit(ICE_FLAG_DCB_ENA, pf->flags))
@@ -931,7 +926,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 
 	ice_vc_notify_link_state(pf);
 
-	return result;
+	return 0;
 }
 
 /**
@@ -6678,6 +6673,7 @@ int ice_open(struct net_device *netdev)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct ice_port_info *pi;
+	enum ice_status status;
 	int err;
 
 	if (test_bit(__ICE_NEEDS_RESTART, pf->state)) {
@@ -6688,11 +6684,11 @@ int ice_open(struct net_device *netdev)
 	netif_carrier_off(netdev);
 
 	pi = vsi->port_info;
-	err = ice_update_link_info(pi);
-	if (err) {
-		netdev_err(netdev, "Failed to get link info, error %d\n",
-			   err);
-		return err;
+	status = ice_update_link_info(pi);
+	if (status) {
+		netdev_err(netdev, "Failed to get link info, error %s\n",
+			   ice_stat_str(status));
+		return -EIO;
 	}
 
 	/* Set PHY if there is media, otherwise, turn off PHY */
@@ -6715,12 +6711,7 @@ int ice_open(struct net_device *netdev)
 		}
 	} else {
 		set_bit(ICE_FLAG_NO_MEDIA, pf->flags);
-		err = ice_aq_set_link_restart_an(pi, false, NULL);
-		if (err) {
-			netdev_err(netdev, "Failed to set PHY state, VSI %d error %d\n",
-				   vsi->vsi_num, err);
-			return err;
-		}
+		ice_set_link(vsi, false);
 	}
 
 	err = ice_vsi_open(vsi);
-- 
2.26.2

