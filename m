Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714DA30244
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfE3Su6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:30429 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfE3Suh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:35 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ice: Add support for Forward Error Correction (FEC)
Date:   Thu, 30 May 2019 11:50:34 -0700
Message-Id: <20190530185045.3886-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

This patch adds driver support for Forward Error Correction (FEC)
and ethtool handlers to set/get FEC params.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  70 ++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |   6 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 216 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_main.c     |  47 +++-
 drivers/net/ethernet/intel/ice/ice_type.h     |   9 +
 6 files changed, 349 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 8680ee2ffa1b..b233f6ca8f0f 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -920,6 +920,8 @@ struct ice_aqc_get_phy_caps_data {
 #define ICE_AQC_PHY_EN_LINK				BIT(3)
 #define ICE_AQC_PHY_AN_MODE				BIT(4)
 #define ICE_AQC_GET_PHY_EN_MOD_QUAL			BIT(5)
+#define ICE_AQC_PHY_EN_AUTO_FEC				BIT(7)
+#define ICE_AQC_PHY_CAPS_MASK				ICE_M(0xff, 0)
 	u8 low_power_ctrl;
 #define ICE_AQC_PHY_EN_D3COLD_LOW_POWER_AUTONEG		BIT(0)
 	__le16 eee_cap;
@@ -940,6 +942,7 @@ struct ice_aqc_get_phy_caps_data {
 #define ICE_AQC_PHY_FEC_25G_RS_544_REQ			BIT(4)
 #define ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN		BIT(6)
 #define ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN		BIT(7)
+#define ICE_AQC_PHY_FEC_MASK				ICE_M(0xdf, 0)
 	u8 extended_compliance_code;
 #define ICE_MODULE_TYPE_TOTAL_BYTE			3
 	u8 module_type[ICE_MODULE_TYPE_TOTAL_BYTE];
@@ -1062,6 +1065,7 @@ struct ice_aqc_get_link_status_data {
 #define ICE_AQ_LINK_25G_KR_FEC_EN	BIT(0)
 #define ICE_AQ_LINK_25G_RS_528_FEC_EN	BIT(1)
 #define ICE_AQ_LINK_25G_RS_544_FEC_EN	BIT(2)
+#define ICE_AQ_FEC_MASK			ICE_M(0x7, 0)
 	/* Pacing Config */
 #define ICE_AQ_CFG_PACING_S		3
 #define ICE_AQ_CFG_PACING_M		(0xF << ICE_AQ_CFG_PACING_S)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 16c694a1b076..c24dc9969858 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -304,6 +304,8 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 	hw_link_info->an_info = link_data.an_info;
 	hw_link_info->ext_info = link_data.ext_info;
 	hw_link_info->max_frame_size = le16_to_cpu(link_data.max_frame_size);
+	hw_link_info->fec_info = link_data.cfg & ICE_AQ_FEC_MASK;
+	hw_link_info->topo_media_conflict = link_data.topo_media_conflict;
 	hw_link_info->pacing = link_data.cfg & ICE_AQ_CFG_PACING_M;
 
 	/* update fc info */
@@ -2129,6 +2131,74 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 	return status;
 }
 
+/**
+ * ice_copy_phy_caps_to_cfg - Copy PHY ability data to configuration data
+ * @caps: PHY ability structure to copy date from
+ * @cfg: PHY configuration structure to copy data to
+ *
+ * Helper function to copy AQC PHY get ability data to PHY set configuration
+ * data structure
+ */
+void
+ice_copy_phy_caps_to_cfg(struct ice_aqc_get_phy_caps_data *caps,
+			 struct ice_aqc_set_phy_cfg_data *cfg)
+{
+	if (!caps || !cfg)
+		return;
+
+	cfg->phy_type_low = caps->phy_type_low;
+	cfg->phy_type_high = caps->phy_type_high;
+	cfg->caps = caps->caps;
+	cfg->low_power_ctrl = caps->low_power_ctrl;
+	cfg->eee_cap = caps->eee_cap;
+	cfg->eeer_value = caps->eeer_value;
+	cfg->link_fec_opt = caps->link_fec_options;
+}
+
+/**
+ * ice_cfg_phy_fec - Configure PHY FEC data based on FEC mode
+ * @cfg: PHY configuration data to set FEC mode
+ * @fec: FEC mode to configure
+ *
+ * Caller should copy ice_aqc_get_phy_caps_data.caps ICE_AQC_PHY_EN_AUTO_FEC
+ * (bit 7) and ice_aqc_get_phy_caps_data.link_fec_options to cfg.caps
+ * ICE_AQ_PHY_ENA_AUTO_FEC (bit 7) and cfg.link_fec_options before calling.
+ */
+void
+ice_cfg_phy_fec(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fec_mode fec)
+{
+	switch (fec) {
+	case ICE_FEC_BASER:
+		/* Clear auto FEC and RS bits, and AND BASE-R ability
+		 * bits and OR request bits.
+		 */
+		cfg->caps &= ~ICE_AQC_PHY_EN_AUTO_FEC;
+		cfg->link_fec_opt &= ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN |
+				     ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN;
+		cfg->link_fec_opt |= ICE_AQC_PHY_FEC_10G_KR_40G_KR4_REQ |
+				     ICE_AQC_PHY_FEC_25G_KR_REQ;
+		break;
+	case ICE_FEC_RS:
+		/* Clear auto FEC and BASE-R bits, and AND RS ability
+		 * bits and OR request bits.
+		 */
+		cfg->caps &= ~ICE_AQC_PHY_EN_AUTO_FEC;
+		cfg->link_fec_opt &= ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN;
+		cfg->link_fec_opt |= ICE_AQC_PHY_FEC_25G_RS_528_REQ |
+				     ICE_AQC_PHY_FEC_25G_RS_544_REQ;
+		break;
+	case ICE_FEC_NONE:
+		/* Clear auto FEC and all FEC option bits. */
+		cfg->caps &= ~ICE_AQC_PHY_EN_AUTO_FEC;
+		cfg->link_fec_opt &= ~ICE_AQC_PHY_FEC_MASK;
+		break;
+	case ICE_FEC_AUTO:
+		/* AND auto FEC bit, and all caps bits. */
+		cfg->caps &= ICE_AQC_PHY_CAPS_MASK;
+		break;
+	}
+}
+
 /**
  * ice_get_link_status - get status of the HW network link
  * @pi: port information structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 9773d7b2e9c9..d1f8353fe6bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -86,7 +86,11 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
 enum ice_status
 ice_set_fc(struct ice_port_info *pi, u8 *aq_failures,
 	   bool ena_auto_link_update);
-
+void
+ice_cfg_phy_fec(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fec_mode fec);
+void
+ice_copy_phy_caps_to_cfg(struct ice_aqc_get_phy_caps_data *caps,
+			 struct ice_aqc_set_phy_cfg_data *cfg);
 enum ice_status
 ice_aq_set_link_restart_an(struct ice_port_info *pi, bool ena_link,
 			   struct ice_sq_cd *cd);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 9dde6dd78643..2da83847b9dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -959,6 +959,185 @@ ice_set_phys_id(struct net_device *netdev, enum ethtool_phys_id_state state)
 	return 0;
 }
 
+/**
+ * ice_set_fec_cfg - Set link FEC options
+ * @netdev: network interface device structure
+ * @req_fec: FEC mode to configure
+ */
+static int ice_set_fec_cfg(struct net_device *netdev, enum ice_fec_mode req_fec)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_aqc_set_phy_cfg_data config = { 0 };
+	struct ice_aqc_get_phy_caps_data *caps;
+	struct ice_vsi *vsi = np->vsi;
+	u8 sw_cfg_caps, sw_cfg_fec;
+	struct ice_port_info *pi;
+	enum ice_status status;
+	int err = 0;
+
+	pi = vsi->port_info;
+	if (!pi)
+		return -EOPNOTSUPP;
+
+	/* Changing the FEC parameters is not supported if not the PF VSI */
+	if (vsi->type != ICE_VSI_PF) {
+		netdev_info(netdev, "Changing FEC parameters only supported for PF VSI\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* Get last SW configuration */
+	caps = devm_kzalloc(&vsi->back->pdev->dev, sizeof(*caps), GFP_KERNEL);
+	if (!caps)
+		return -ENOMEM;
+
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG,
+				     caps, NULL);
+	if (status) {
+		err = -EAGAIN;
+		goto done;
+	}
+
+	/* Copy SW configuration returned from PHY caps to PHY config */
+	ice_copy_phy_caps_to_cfg(caps, &config);
+	sw_cfg_caps = caps->caps;
+	sw_cfg_fec = caps->link_fec_options;
+
+	/* Get toloplogy caps, then copy PHY FEC topoloy caps to PHY config */
+	memset(caps, 0, sizeof(*caps));
+
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP,
+				     caps, NULL);
+	if (status) {
+		err = -EAGAIN;
+		goto done;
+	}
+
+	config.caps |= (caps->caps & ICE_AQC_PHY_EN_AUTO_FEC);
+	config.link_fec_opt = caps->link_fec_options;
+
+	ice_cfg_phy_fec(&config, req_fec);
+
+	/* If FEC mode has changed, then set PHY configuration and enable AN. */
+	if ((config.caps & ICE_AQ_PHY_ENA_AUTO_FEC) !=
+	    (sw_cfg_caps & ICE_AQC_PHY_EN_AUTO_FEC) ||
+	    config.link_fec_opt != sw_cfg_fec) {
+		if (caps->caps & ICE_AQC_PHY_AN_MODE)
+			config.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
+
+		status = ice_aq_set_phy_cfg(pi->hw, pi->lport, &config, NULL);
+
+		if (status)
+			err = -EAGAIN;
+	}
+
+done:
+	devm_kfree(&vsi->back->pdev->dev, caps);
+	return err;
+}
+
+/**
+ * ice_set_fecparam - Set FEC link options
+ * @netdev: network interface device structure
+ * @fecparam: Ethtool structure to retrieve FEC parameters
+ */
+static int
+ice_set_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	enum ice_fec_mode fec;
+
+	switch (fecparam->fec) {
+	case ETHTOOL_FEC_AUTO:
+		fec = ICE_FEC_AUTO;
+		break;
+	case ETHTOOL_FEC_RS:
+		fec = ICE_FEC_RS;
+		break;
+	case ETHTOOL_FEC_BASER:
+		fec = ICE_FEC_BASER;
+		break;
+	case ETHTOOL_FEC_OFF:
+	case ETHTOOL_FEC_NONE:
+		fec = ICE_FEC_NONE;
+		break;
+	default:
+		dev_warn(&vsi->back->pdev->dev, "Unsupported FEC mode: %d\n",
+			 fecparam->fec);
+		return -EINVAL;
+	}
+
+	return ice_set_fec_cfg(netdev, fec);
+}
+
+/**
+ * ice_get_fecparam - Get link FEC options
+ * @netdev: network interface device structure
+ * @fecparam: Ethtool structure to retrieve FEC parameters
+ */
+static int
+ice_get_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_aqc_get_phy_caps_data *caps;
+	struct ice_link_status *link_info;
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_port_info *pi;
+	enum ice_status status;
+	int err = 0;
+
+	pi = vsi->port_info;
+
+	if (!pi)
+		return -EOPNOTSUPP;
+	link_info = &pi->phy.link_info;
+
+	/* Set FEC mode based on negotiated link info */
+	switch (link_info->fec_info) {
+	case ICE_AQ_LINK_25G_KR_FEC_EN:
+		fecparam->active_fec = ETHTOOL_FEC_BASER;
+		break;
+	case ICE_AQ_LINK_25G_RS_528_FEC_EN:
+		/* fall through */
+	case ICE_AQ_LINK_25G_RS_544_FEC_EN:
+		fecparam->active_fec = ETHTOOL_FEC_RS;
+		break;
+	default:
+		fecparam->active_fec = ETHTOOL_FEC_OFF;
+		break;
+	}
+
+	caps = devm_kzalloc(&vsi->back->pdev->dev, sizeof(*caps), GFP_KERNEL);
+	if (!caps)
+		return -ENOMEM;
+
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP,
+				     caps, NULL);
+	if (status) {
+		err = -EAGAIN;
+		goto done;
+	}
+
+	/* Set supported/configured FEC modes based on PHY capability */
+	if (caps->caps & ICE_AQC_PHY_EN_AUTO_FEC)
+		fecparam->fec |= ETHTOOL_FEC_AUTO;
+	if (caps->link_fec_options & ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_10G_KR_40G_KR4_REQ ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_KR_REQ)
+		fecparam->fec |= ETHTOOL_FEC_BASER;
+	if (caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_528_REQ ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_544_REQ ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN)
+		fecparam->fec |= ETHTOOL_FEC_RS;
+	if (caps->link_fec_options == 0)
+		fecparam->fec |= ETHTOOL_FEC_OFF;
+
+done:
+	devm_kfree(&vsi->back->pdev->dev, caps);
+	return err;
+}
+
 /**
  * ice_get_priv_flags - report device private flags
  * @netdev: network interface device structure
@@ -1885,6 +2064,7 @@ ice_get_link_ksettings(struct net_device *netdev,
 		       struct ethtool_link_ksettings *ks)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_aqc_get_phy_caps_data *caps;
 	struct ice_link_status *hw_link_info;
 	struct ice_vsi *vsi = np->vsi;
 
@@ -1955,6 +2135,40 @@ ice_get_link_ksettings(struct net_device *netdev,
 		break;
 	}
 
+	caps = devm_kzalloc(&vsi->back->pdev->dev, sizeof(*caps), GFP_KERNEL);
+	if (!caps)
+		goto done;
+
+	if (ice_aq_get_phy_caps(vsi->port_info, false, ICE_AQC_REPORT_TOPO_CAP,
+				caps, NULL))
+		netdev_info(netdev, "Get phy capability failed.\n");
+
+	/* Set supported FEC modes based on PHY capability */
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_NONE);
+
+	if (caps->link_fec_options & ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN)
+		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
+	if (caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN)
+		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
+
+	if (ice_aq_get_phy_caps(vsi->port_info, false, ICE_AQC_REPORT_SW_CFG,
+				caps, NULL))
+		netdev_info(netdev, "Get phy capability failed.\n");
+
+	/* Set advertised FEC modes based on PHY capability */
+	ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_NONE);
+
+	if (caps->link_fec_options & ICE_AQC_PHY_FEC_10G_KR_40G_KR4_REQ ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_KR_REQ)
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     FEC_BASER);
+	if (caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_528_REQ ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_544_REQ)
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
+
+done:
+	devm_kfree(&vsi->back->pdev->dev, caps);
 	return 0;
 }
 
@@ -3167,6 +3381,8 @@ static const struct ethtool_ops ice_ethtool_ops = {
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_per_queue_coalesce = ice_get_per_q_coalesce,
 	.set_per_queue_coalesce = ice_set_per_q_coalesce,
+	.get_fecparam		= ice_get_fecparam,
+	.set_fecparam		= ice_set_fecparam,
 };
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index da62a901b355..c8cf2c35ecbb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -624,7 +624,11 @@ static void ice_reset_subtask(struct ice_pf *pf)
  */
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 {
+	struct ice_aqc_get_phy_caps_data *caps;
+	enum ice_status status;
+	const char *fec_req;
 	const char *speed;
+	const char *fec;
 	const char *fc;
 
 	if (!vsi)
@@ -688,8 +692,47 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 		break;
 	}
 
-	netdev_info(vsi->netdev, "NIC Link is up %sbps, Flow Control: %s\n",
-		    speed, fc);
+	/* Get FEC mode based on negotiated link info */
+	switch (vsi->port_info->phy.link_info.fec_info) {
+	case ICE_AQ_LINK_25G_RS_528_FEC_EN:
+		/* fall through */
+	case ICE_AQ_LINK_25G_RS_544_FEC_EN:
+		fec = "RS-FEC";
+		break;
+	case ICE_AQ_LINK_25G_KR_FEC_EN:
+		fec = "FC-FEC/BASE-R";
+		break;
+	default:
+		fec = "NONE";
+		break;
+	}
+
+	/* Get FEC mode requested based on PHY caps last SW configuration */
+	caps = devm_kzalloc(&vsi->back->pdev->dev, sizeof(*caps), GFP_KERNEL);
+	if (!caps) {
+		fec_req = "Unknown";
+		goto done;
+	}
+
+	status = ice_aq_get_phy_caps(vsi->port_info, false,
+				     ICE_AQC_REPORT_SW_CFG, caps, NULL);
+	if (status)
+		netdev_info(vsi->netdev, "Get phy capability failed.\n");
+
+	if (caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_528_REQ ||
+	    caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_544_REQ)
+		fec_req = "RS-FEC";
+	else if (caps->link_fec_options & ICE_AQC_PHY_FEC_10G_KR_40G_KR4_REQ ||
+		 caps->link_fec_options & ICE_AQC_PHY_FEC_25G_KR_REQ)
+		fec_req = "FC-FEC/BASE-R";
+	else
+		fec_req = "NONE";
+
+	devm_kfree(&vsi->back->pdev->dev, caps);
+
+done:
+	netdev_info(vsi->netdev, "NIC Link is up %sbps, Requested FEC: %s, FEC: %s, Flow Control: %s\n",
+		    speed, fec_req, fec, fc);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 0a0fa30a85bb..b6d0399f49b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -61,6 +61,13 @@ enum ice_fc_mode {
 	ICE_FC_DFLT
 };
 
+enum ice_fec_mode {
+	ICE_FEC_NONE = 0,
+	ICE_FEC_RS,
+	ICE_FEC_BASER,
+	ICE_FEC_AUTO
+};
+
 enum ice_set_fc_aq_failures {
 	ICE_SET_FC_AQ_FAIL_NONE = 0,
 	ICE_SET_FC_AQ_FAIL_GET,
@@ -93,6 +100,7 @@ struct ice_link_status {
 	/* Refer to ice_aq_phy_type for bits definition */
 	u64 phy_type_low;
 	u64 phy_type_high;
+	u8 topo_media_conflict;
 	u16 max_frame_size;
 	u16 link_speed;
 	u16 req_speeds;
@@ -100,6 +108,7 @@ struct ice_link_status {
 	u8 link_info;
 	u8 an_info;
 	u8 ext_info;
+	u8 fec_info;
 	u8 pacing;
 	/* Refer to #define from module_type[ICE_MODULE_TYPE_TOTAL_BYTE] of
 	 * ice_aqc_get_phy_caps structure
-- 
2.21.0

