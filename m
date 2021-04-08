Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392D335895C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhDHQMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:12:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:26214 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232053AbhDHQLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:53 -0400
IronPort-SDR: 6cW/mmxE4O5OONIxfOY0GNykuL3VRTEv6xA15Yz9BZGCvYQ2Bif+U1e0t1ryMuRqnDNPiR5Hvc
 XL+WVJoLFMnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="191424030"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="191424030"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:42 -0700
IronPort-SDR: ugDJJo4pzLgEl9o7OiTFZFxS99M1h3n8yaOoA6Gl27G6cYXAtf9EVyGB83EooT04AaD3xqC+OD
 wqVMnZ2iHoEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841444"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 12/15] ice: Use local variable instead of pointer derefs
Date:   Thu,  8 Apr 2021 09:13:18 -0700
Message-Id: <20210408161321.3218024-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Replace multiple instances of vsi->back and pi->phy with equivalent
local variables

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 27 ++++++++++-------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c81eb27e83a6..73dd272acbf9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1857,27 +1857,24 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 static int ice_configure_phy(struct ice_vsi *vsi)
 {
 	struct device *dev = ice_pf_to_dev(vsi->back);
+	struct ice_port_info *pi = vsi->port_info;
 	struct ice_aqc_get_phy_caps_data *pcaps;
 	struct ice_aqc_set_phy_cfg_data *cfg;
-	struct ice_port_info *pi;
+	struct ice_phy_info *phy = &pi->phy;
+	struct ice_pf *pf = vsi->back;
 	enum ice_status status;
 	int err = 0;
 
-	pi = vsi->port_info;
-	if (!pi)
-		return -EINVAL;
-
 	/* Ensure we have media as we cannot configure a medialess port */
-	if (!(pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE))
+	if (!(phy->link_info.link_info & ICE_AQ_MEDIA_AVAILABLE))
 		return -EPERM;
 
 	ice_print_topo_conflict(vsi);
 
-	if (vsi->port_info->phy.link_info.topo_media_conflict ==
-	    ICE_AQ_LINK_TOPO_UNSUPP_MEDIA)
+	if (phy->link_info.topo_media_conflict == ICE_AQ_LINK_TOPO_UNSUPP_MEDIA)
 		return -EPERM;
 
-	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags))
+	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags))
 		return ice_force_phys_link_state(vsi, true);
 
 	pcaps = kzalloc(sizeof(*pcaps), GFP_KERNEL);
@@ -1898,7 +1895,7 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	 * there's nothing to do
 	 */
 	if (pcaps->caps & ICE_AQC_PHY_EN_LINK &&
-	    ice_phy_caps_equals_cfg(pcaps, &pi->phy.curr_user_phy_cfg))
+	    ice_phy_caps_equals_cfg(pcaps, &phy->curr_user_phy_cfg))
 		goto done;
 
 	/* Use PHY topology as baseline for configuration */
@@ -1929,8 +1926,8 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	 */
 	if (test_and_clear_bit(__ICE_LINK_DEFAULT_OVERRIDE_PENDING,
 			       vsi->back->state)) {
-		cfg->phy_type_low = pi->phy.curr_user_phy_cfg.phy_type_low;
-		cfg->phy_type_high = pi->phy.curr_user_phy_cfg.phy_type_high;
+		cfg->phy_type_low = phy->curr_user_phy_cfg.phy_type_low;
+		cfg->phy_type_high = phy->curr_user_phy_cfg.phy_type_high;
 	} else {
 		u64 phy_low = 0, phy_high = 0;
 
@@ -1948,7 +1945,7 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	}
 
 	/* FEC */
-	ice_cfg_phy_fec(pi, cfg, pi->phy.curr_user_fec_req);
+	ice_cfg_phy_fec(pi, cfg, phy->curr_user_fec_req);
 
 	/* Can't provide what was requested; use PHY capabilities */
 	if (cfg->link_fec_opt !=
@@ -1960,12 +1957,12 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	/* Flow Control - always supported; no need to check against
 	 * capabilities
 	 */
-	ice_cfg_phy_fc(pi, cfg, pi->phy.curr_user_fc_req);
+	ice_cfg_phy_fc(pi, cfg, phy->curr_user_fc_req);
 
 	/* Enable link and link update */
 	cfg->caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT | ICE_AQ_PHY_ENA_LINK;
 
-	status = ice_aq_set_phy_cfg(&vsi->back->hw, pi, cfg, NULL);
+	status = ice_aq_set_phy_cfg(&pf->hw, pi, cfg, NULL);
 	if (status) {
 		dev_err(dev, "Failed to set phy config, VSI %d error %s\n",
 			vsi->vsi_num, ice_stat_str(status));
-- 
2.26.2

