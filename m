Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952F7130042
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgADCuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:50:18 -0500
Received: from mga12.intel.com ([192.55.52.136]:64694 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgADCt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757873"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/16] ice: Fix VF link state when it's IFLA_VF_LINK_STATE_AUTO
Date:   Fri,  3 Jan 2020 18:49:46 -0800
Message-Id: <20200104024953.2336731-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the flow for ice_set_vf_link_state() is not configuring link
the same as all other VF link configuration flows. Fix this by only
setting the necessary VF members in ice_set_vf_link_state() and then
call ice_vc_notify_link_state() to actually configure link for the
VF. This made ice_set_pfe_link_forced() unnecessary, so it was
deleted. Also, this commonizes the link flows for the VF to all call
ice_vc_notify_link_state().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 56 ++++---------------
 2 files changed, 12 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0c46e7fe7250..3adeb7059ac5 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -844,8 +844,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	ice_vsi_link_event(vsi, link_up);
 	ice_print_link_msg(vsi, link_up);
 
-	if (pf->num_alloc_vfs)
-		ice_vc_notify_link_state(pf);
+	ice_vc_notify_link_state(pf);
 
 	return result;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 88cb0f9e928e..f080f3af182a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -121,26 +121,6 @@ ice_set_pfe_link(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
 	}
 }
 
-/**
- * ice_set_pfe_link_forced - Force the virtchnl_pf_event link speed/status
- * @vf: pointer to the VF structure
- * @pfe: pointer to the virtchnl_pf_event to set link speed/status for
- * @link_up: whether or not to set the link up/down
- */
-static void
-ice_set_pfe_link_forced(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
-			bool link_up)
-{
-	u16 link_speed;
-
-	if (link_up)
-		link_speed = ICE_AQ_LINK_SPEED_100GB;
-	else
-		link_speed = ICE_AQ_LINK_SPEED_UNKNOWN;
-
-	ice_set_pfe_link(vf, pfe, link_speed, link_up);
-}
-
 /**
  * ice_vc_notify_vf_link_state - Inform a VF of link status
  * @vf: pointer to the VF structure
@@ -161,13 +141,17 @@ static void ice_vc_notify_vf_link_state(struct ice_vf *vf)
 	pfe.severity = PF_EVENT_SEVERITY_INFO;
 
 	/* Always report link is down if the VF queues aren't enabled */
-	if (!vf->num_qs_ena)
+	if (!vf->num_qs_ena) {
 		ice_set_pfe_link(vf, &pfe, ICE_AQ_LINK_SPEED_UNKNOWN, false);
-	else if (vf->link_forced)
-		ice_set_pfe_link_forced(vf, &pfe, vf->link_up);
-	else
-		ice_set_pfe_link(vf, &pfe, ls->link_speed, ls->link_info &
-				 ICE_AQ_LINK_UP);
+	} else if (vf->link_forced) {
+		u16 link_speed = vf->link_up ?
+			ls->link_speed : ICE_AQ_LINK_SPEED_UNKNOWN;
+
+		ice_set_pfe_link(vf, &pfe, link_speed, vf->link_up);
+	} else {
+		ice_set_pfe_link(vf, &pfe, ls->link_speed,
+				 ls->link_info & ICE_AQ_LINK_UP);
+	}
 
 	ice_aq_send_msg_to_vf(hw, vf->vf_id, VIRTCHNL_OP_EVENT,
 			      VIRTCHNL_STATUS_SUCCESS, (u8 *)&pfe,
@@ -3392,28 +3376,18 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state)
 {
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	struct virtchnl_pf_event pfe = { 0 };
-	struct ice_link_status *ls;
 	struct ice_vf *vf;
-	struct ice_hw *hw;
 
 	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
 
 	vf = &pf->vf[vf_id];
-	hw = &pf->hw;
-	ls = &pf->hw.port_info->phy.link_info;
-
 	if (ice_check_vf_init(pf, vf))
 		return -EBUSY;
 
-	pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
-	pfe.severity = PF_EVENT_SEVERITY_INFO;
-
 	switch (link_state) {
 	case IFLA_VF_LINK_STATE_AUTO:
 		vf->link_forced = false;
-		vf->link_up = ls->link_info & ICE_AQ_LINK_UP;
 		break;
 	case IFLA_VF_LINK_STATE_ENABLE:
 		vf->link_forced = true;
@@ -3427,15 +3401,7 @@ int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state)
 		return -EINVAL;
 	}
 
-	if (vf->link_forced)
-		ice_set_pfe_link_forced(vf, &pfe, vf->link_up);
-	else
-		ice_set_pfe_link(vf, &pfe, ls->link_speed, vf->link_up);
-
-	/* Notify the VF of its new link state */
-	ice_aq_send_msg_to_vf(hw, vf->vf_id, VIRTCHNL_OP_EVENT,
-			      VIRTCHNL_STATUS_SUCCESS, (u8 *)&pfe,
-			      sizeof(pfe), NULL);
+	ice_vc_notify_vf_link_state(vf);
 
 	return 0;
 }
-- 
2.24.1

