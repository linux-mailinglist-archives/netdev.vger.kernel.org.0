Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2307CEEE
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbfGaUmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:42:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:2709 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729104AbfGaUlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901021"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/16] ice: Do not configure port with no media
Date:   Wed, 31 Jul 2019 13:41:37 -0700
Message-Id: <20190731204147.8582-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

The firmware reports an error when trying to configure a port with no
media. Instead of always configuring the port, check for media before
attempting to configure it. In the absence of media, turn off link and
poll for media to become available before re-enabling link.

Move ice_force_phys_link_state() up to avoid forward declaration.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c | 239 ++++++++++++++--------
 2 files changed, 158 insertions(+), 82 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 9ee6b55553c0..596b09a905aa 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -337,6 +337,7 @@ enum ice_pf_flags {
 	ICE_FLAG_DCB_CAPABLE,
 	ICE_FLAG_DCB_ENA,
 	ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA,
+	ICE_FLAG_NO_MEDIA,
 	ICE_FLAG_ENABLE_FW_LLDP,
 	ICE_FLAG_ETHTOOL_CTXT,		/* set when ethtool holds RTNL lock */
 	ICE_PF_FLAGS_NBITS		/* must be last */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f490e65c64bc..91334d1e83ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -810,6 +810,20 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	if (!vsi || !vsi->port_info)
 		return -EINVAL;
 
+	/* turn off PHY if media was removed */
+	if (!test_bit(ICE_FLAG_NO_MEDIA, pf->flags) &&
+	    !(pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE)) {
+		set_bit(ICE_FLAG_NO_MEDIA, pf->flags);
+
+		result = ice_aq_set_link_restart_an(pi, false, NULL);
+		if (result) {
+			dev_dbg(&pf->pdev->dev,
+				"Failed to set link down, VSI %d error %d\n",
+				vsi->vsi_num, result);
+			return result;
+		}
+	}
+
 	ice_vsi_link_event(vsi, link_up);
 	ice_print_link_msg(vsi, link_up);
 
@@ -1314,6 +1328,124 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 	}
 }
 
+/**
+ * ice_force_phys_link_state - Force the physical link state
+ * @vsi: VSI to force the physical link state to up/down
+ * @link_up: true/false indicates to set the physical link to up/down
+ *
+ * Force the physical link state by getting the current PHY capabilities from
+ * hardware and setting the PHY config based on the determined capabilities. If
+ * link changes a link event will be triggered because both the Enable Automatic
+ * Link Update and LESM Enable bits are set when setting the PHY capabilities.
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
+{
+	struct ice_aqc_get_phy_caps_data *pcaps;
+	struct ice_aqc_set_phy_cfg_data *cfg;
+	struct ice_port_info *pi;
+	struct device *dev;
+	int retcode;
+
+	if (!vsi || !vsi->port_info || !vsi->back)
+		return -EINVAL;
+	if (vsi->type != ICE_VSI_PF)
+		return 0;
+
+	dev = &vsi->back->pdev->dev;
+
+	pi = vsi->port_info;
+
+	pcaps = devm_kzalloc(dev, sizeof(*pcaps), GFP_KERNEL);
+	if (!pcaps)
+		return -ENOMEM;
+
+	retcode = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+				      NULL);
+	if (retcode) {
+		dev_err(dev,
+			"Failed to get phy capabilities, VSI %d error %d\n",
+			vsi->vsi_num, retcode);
+		retcode = -EIO;
+		goto out;
+	}
+
+	/* No change in link */
+	if (link_up == !!(pcaps->caps & ICE_AQC_PHY_EN_LINK) &&
+	    link_up == !!(pi->phy.link_info.link_info & ICE_AQ_LINK_UP))
+		goto out;
+
+	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
+	if (!cfg) {
+		retcode = -ENOMEM;
+		goto out;
+	}
+
+	cfg->phy_type_low = pcaps->phy_type_low;
+	cfg->phy_type_high = pcaps->phy_type_high;
+	cfg->caps = pcaps->caps | ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
+	cfg->low_power_ctrl = pcaps->low_power_ctrl;
+	cfg->eee_cap = pcaps->eee_cap;
+	cfg->eeer_value = pcaps->eeer_value;
+	cfg->link_fec_opt = pcaps->link_fec_options;
+	if (link_up)
+		cfg->caps |= ICE_AQ_PHY_ENA_LINK;
+	else
+		cfg->caps &= ~ICE_AQ_PHY_ENA_LINK;
+
+	retcode = ice_aq_set_phy_cfg(&vsi->back->hw, pi->lport, cfg, NULL);
+	if (retcode) {
+		dev_err(dev, "Failed to set phy config, VSI %d error %d\n",
+			vsi->vsi_num, retcode);
+		retcode = -EIO;
+	}
+
+	devm_kfree(dev, cfg);
+out:
+	devm_kfree(dev, pcaps);
+	return retcode;
+}
+
+/**
+ * ice_check_media_subtask - Check for media; bring link up if detected.
+ * @pf: pointer to PF struct
+ */
+static void ice_check_media_subtask(struct ice_pf *pf)
+{
+	struct ice_port_info *pi;
+	struct ice_vsi *vsi;
+	int err;
+
+	vsi = ice_find_vsi_by_type(pf, ICE_VSI_PF);
+	if (!vsi)
+		return;
+
+	/* No need to check for media if it's already present or the interface
+	 * is down
+	 */
+	if (!test_bit(ICE_FLAG_NO_MEDIA, pf->flags) ||
+	    test_bit(__ICE_DOWN, vsi->state))
+		return;
+
+	/* Refresh link info and check if media is present */
+	pi = vsi->port_info;
+	err = ice_update_link_info(pi);
+	if (err)
+		return;
+
+	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
+		err = ice_force_phys_link_state(vsi, true);
+		if (err)
+			return;
+		clear_bit(ICE_FLAG_NO_MEDIA, pf->flags);
+
+		/* A Link Status Event will be generated; the event handler
+		 * will complete bringing the interface up
+		 */
+	}
+}
+
 /**
  * ice_service_task - manage and run subtasks
  * @work: pointer to work_struct contained by the PF struct
@@ -1336,6 +1468,7 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	ice_check_media_subtask(pf);
 	ice_check_for_hang_subtask(pf);
 	ice_sync_fltr_subtask(pf);
 	ice_handle_mdd_event(pf);
@@ -3357,85 +3490,6 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
 	}
 }
 
-/**
- * ice_force_phys_link_state - Force the physical link state
- * @vsi: VSI to force the physical link state to up/down
- * @link_up: true/false indicates to set the physical link to up/down
- *
- * Force the physical link state by getting the current PHY capabilities from
- * hardware and setting the PHY config based on the determined capabilities. If
- * link changes a link event will be triggered because both the Enable Automatic
- * Link Update and LESM Enable bits are set when setting the PHY capabilities.
- *
- * Returns 0 on success, negative on failure
- */
-static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
-{
-	struct ice_aqc_get_phy_caps_data *pcaps;
-	struct ice_aqc_set_phy_cfg_data *cfg;
-	struct ice_port_info *pi;
-	struct device *dev;
-	int retcode;
-
-	if (!vsi || !vsi->port_info || !vsi->back)
-		return -EINVAL;
-	if (vsi->type != ICE_VSI_PF)
-		return 0;
-
-	dev = &vsi->back->pdev->dev;
-
-	pi = vsi->port_info;
-
-	pcaps = devm_kzalloc(dev, sizeof(*pcaps), GFP_KERNEL);
-	if (!pcaps)
-		return -ENOMEM;
-
-	retcode = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
-				      NULL);
-	if (retcode) {
-		dev_err(dev,
-			"Failed to get phy capabilities, VSI %d error %d\n",
-			vsi->vsi_num, retcode);
-		retcode = -EIO;
-		goto out;
-	}
-
-	/* No change in link */
-	if (link_up == !!(pcaps->caps & ICE_AQC_PHY_EN_LINK) &&
-	    link_up == !!(pi->phy.link_info.link_info & ICE_AQ_LINK_UP))
-		goto out;
-
-	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
-	if (!cfg) {
-		retcode = -ENOMEM;
-		goto out;
-	}
-
-	cfg->phy_type_low = pcaps->phy_type_low;
-	cfg->phy_type_high = pcaps->phy_type_high;
-	cfg->caps = pcaps->caps | ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
-	cfg->low_power_ctrl = pcaps->low_power_ctrl;
-	cfg->eee_cap = pcaps->eee_cap;
-	cfg->eeer_value = pcaps->eeer_value;
-	cfg->link_fec_opt = pcaps->link_fec_options;
-	if (link_up)
-		cfg->caps |= ICE_AQ_PHY_ENA_LINK;
-	else
-		cfg->caps &= ~ICE_AQ_PHY_ENA_LINK;
-
-	retcode = ice_aq_set_phy_cfg(&vsi->back->hw, pi->lport, cfg, NULL);
-	if (retcode) {
-		dev_err(dev, "Failed to set phy config, VSI %d error %d\n",
-			vsi->vsi_num, retcode);
-		retcode = -EIO;
-	}
-
-	devm_kfree(dev, cfg);
-out:
-	devm_kfree(dev, pcaps);
-	return retcode;
-}
-
 /**
  * ice_down - Shutdown the connection
  * @vsi: The VSI being stopped
@@ -4281,6 +4335,7 @@ int ice_open(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
+	struct ice_port_info *pi;
 	int err;
 
 	if (test_bit(__ICE_NEEDS_RESTART, vsi->back->state)) {
@@ -4290,13 +4345,33 @@ int ice_open(struct net_device *netdev)
 
 	netif_carrier_off(netdev);
 
-	err = ice_force_phys_link_state(vsi, true);
+	pi = vsi->port_info;
+	err = ice_update_link_info(pi);
 	if (err) {
-		netdev_err(netdev,
-			   "Failed to set physical link up, error %d\n", err);
+		netdev_err(netdev, "Failed to get link info, error %d\n",
+			   err);
 		return err;
 	}
 
+	/* Set PHY if there is media, otherwise, turn off PHY */
+	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
+		err = ice_force_phys_link_state(vsi, true);
+		if (err) {
+			netdev_err(netdev,
+				   "Failed to set physical link up, error %d\n",
+				   err);
+			return err;
+		}
+	} else {
+		err = ice_aq_set_link_restart_an(pi, false, NULL);
+		if (err) {
+			netdev_err(netdev, "Failed to set PHY state, VSI %d error %d\n",
+				   vsi->vsi_num, err);
+			return err;
+		}
+		set_bit(ICE_FLAG_NO_MEDIA, vsi->back->flags);
+	}
+
 	err = ice_vsi_open(vsi);
 	if (err)
 		netdev_err(netdev, "Failed to open VSI 0x%04X on switch 0x%04X\n",
-- 
2.21.0

