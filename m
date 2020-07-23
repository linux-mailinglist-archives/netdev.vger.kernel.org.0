Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05FA22BA56
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgGWXre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:43317 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgGWXrb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:31 -0400
IronPort-SDR: gDsg1JoO9E1k5wIKsUfFOxWAN/QWYd9q3WMl2fFN4KkvAim4jeDk+OrnXcLHXyTtMwM42RKz4a
 jBVgTkHugB+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515437"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515437"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:26 -0700
IronPort-SDR: DuIo4/VoAFl9qlhhtjvTKRUrSMQu05nyAFjXqNpymA4+4kxDBItHs0KPENFG6VRn6sZWQONdAh
 6LnxctyUi30g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742297"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Chinh T Cao <chinh.t.cao@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 06/15] ice: move auto FEC checks into ice_cfg_phy_fec()
Date:   Thu, 23 Jul 2020 16:47:11 -0700
Message-Id: <20200723234720.1547308-7-anthony.l.nguyen@intel.com>
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

The call to ice_cfg_phy_fec() requires the caller to perform certain
actions before calling it. Instead of imposing these preconditions move
the operations into the function and perform them ourselves.

Also, fix some style issues in nearby touched code.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c  | 43 ++++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_common.h  |  5 ++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 31 ++------------
 3 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 18bfd9a47ee0..59890eeb8339 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2657,25 +2657,41 @@ ice_copy_phy_caps_to_cfg(struct ice_aqc_get_phy_caps_data *caps,
 
 /**
  * ice_cfg_phy_fec - Configure PHY FEC data based on FEC mode
+ * @pi: port information structure
  * @cfg: PHY configuration data to set FEC mode
  * @fec: FEC mode to configure
- *
- * Caller should copy ice_aqc_get_phy_caps_data.caps ICE_AQC_PHY_EN_AUTO_FEC
- * (bit 7) and ice_aqc_get_phy_caps_data.link_fec_options to cfg.caps
- * ICE_AQ_PHY_ENA_AUTO_FEC (bit 7) and cfg.link_fec_options before calling.
  */
-void
-ice_cfg_phy_fec(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fec_mode fec)
+enum ice_status
+ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
+		enum ice_fec_mode fec)
 {
+	struct ice_aqc_get_phy_caps_data *pcaps;
+	enum ice_status status;
+
+	if (!pi || !cfg)
+		return ICE_ERR_BAD_PTR;
+
+	pcaps = kzalloc(sizeof(*pcaps), GFP_KERNEL);
+	if (!pcaps)
+		return ICE_ERR_NO_MEMORY;
+
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP, pcaps,
+				     NULL);
+	if (status)
+		goto out;
+
+	cfg->caps |= pcaps->caps & ICE_AQC_PHY_EN_AUTO_FEC;
+	cfg->link_fec_opt = pcaps->link_fec_options;
+
 	switch (fec) {
 	case ICE_FEC_BASER:
 		/* Clear RS bits, and AND BASE-R ability
 		 * bits and OR request bits.
 		 */
 		cfg->link_fec_opt &= ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN |
-				     ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN;
+			ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN;
 		cfg->link_fec_opt |= ICE_AQC_PHY_FEC_10G_KR_40G_KR4_REQ |
-				     ICE_AQC_PHY_FEC_25G_KR_REQ;
+			ICE_AQC_PHY_FEC_25G_KR_REQ;
 		break;
 	case ICE_FEC_RS:
 		/* Clear BASE-R bits, and AND RS ability
@@ -2683,7 +2699,7 @@ ice_cfg_phy_fec(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fec_mode fec)
 		 */
 		cfg->link_fec_opt &= ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN;
 		cfg->link_fec_opt |= ICE_AQC_PHY_FEC_25G_RS_528_REQ |
-				     ICE_AQC_PHY_FEC_25G_RS_544_REQ;
+			ICE_AQC_PHY_FEC_25G_RS_544_REQ;
 		break;
 	case ICE_FEC_NONE:
 		/* Clear all FEC option bits. */
@@ -2692,8 +2708,17 @@ ice_cfg_phy_fec(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fec_mode fec)
 	case ICE_FEC_AUTO:
 		/* AND auto FEC bit, and all caps bits. */
 		cfg->caps &= ICE_AQC_PHY_CAPS_MASK;
+		cfg->link_fec_opt |= pcaps->link_fec_options;
+		break;
+	default:
+		status = ICE_ERR_PARAM;
 		break;
 	}
+
+out:
+	kfree(pcaps);
+
+	return status;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index d1238f43e872..2f912c671e6b 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -103,8 +103,9 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
 enum ice_status
 ice_set_fc(struct ice_port_info *pi, u8 *aq_failures,
 	   bool ena_auto_link_update);
-void
-ice_cfg_phy_fec(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fec_mode fec);
+enum ice_status
+ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
+		enum ice_fec_mode fec);
 void
 ice_copy_phy_caps_to_cfg(struct ice_aqc_get_phy_caps_data *caps,
 			 struct ice_aqc_set_phy_cfg_data *cfg);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index c2291cf4dc6e..4567b0175712 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -968,7 +968,6 @@ static int ice_set_fec_cfg(struct net_device *netdev, enum ice_fec_mode req_fec)
 	struct ice_aqc_set_phy_cfg_data config = { 0 };
 	struct ice_aqc_get_phy_caps_data *caps;
 	struct ice_vsi *vsi = np->vsi;
-	u8 sw_cfg_caps, sw_cfg_fec;
 	struct ice_port_info *pi;
 	enum ice_status status;
 	int err = 0;
@@ -997,36 +996,12 @@ static int ice_set_fec_cfg(struct net_device *netdev, enum ice_fec_mode req_fec)
 
 	/* Copy SW configuration returned from PHY caps to PHY config */
 	ice_copy_phy_caps_to_cfg(caps, &config);
-	sw_cfg_caps = caps->caps;
-	sw_cfg_fec = caps->link_fec_options;
 
-	/* Get toloplogy caps, then copy PHY FEC topoloy caps to PHY config */
-	memset(caps, 0, sizeof(*caps));
+	ice_cfg_phy_fec(pi, &config, req_fec);
+	config.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP,
-				     caps, NULL);
-	if (status) {
+	if (ice_aq_set_phy_cfg(pi->hw, pi->lport, &config, NULL))
 		err = -EAGAIN;
-		goto done;
-	}
-
-	config.caps |= (caps->caps & ICE_AQC_PHY_EN_AUTO_FEC);
-	config.link_fec_opt = caps->link_fec_options;
-
-	ice_cfg_phy_fec(&config, req_fec);
-
-	/* If FEC mode has changed, then set PHY configuration and enable AN. */
-	if ((config.caps & ICE_AQ_PHY_ENA_AUTO_FEC) !=
-	    (sw_cfg_caps & ICE_AQC_PHY_EN_AUTO_FEC) ||
-	    config.link_fec_opt != sw_cfg_fec) {
-		if (caps->caps & ICE_AQC_PHY_AN_MODE)
-			config.caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
-
-		status = ice_aq_set_phy_cfg(pi->hw, pi->lport, &config, NULL);
-
-		if (status)
-			err = -EAGAIN;
-	}
 
 done:
 	kfree(caps);
-- 
2.26.2

