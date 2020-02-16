Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F116416019B
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgBPDpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:45:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:33361 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727592AbgBPDoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916580"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: Add helper to determine if VF link is up
Date:   Sat, 15 Feb 2020 19:44:40 -0800
Message-Id: <20200216034452.1251706-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
References: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

The check for vf->link_up is incorrect because this field is only valid if
vf->link_forced is true. Fix this by adding the helper ice_is_vf_link_up()
to determine if the VF's link is up.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 42 +++++++++++--------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 82319597c48c..62ef3be4b184 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -90,6 +90,26 @@ ice_set_pfe_link(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
 	}
 }
 
+/**
+ * ice_is_vf_link_up - check if the VF's link is up
+ * @vf: VF to check if link is up
+ */
+static bool ice_is_vf_link_up(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+
+	if (ice_check_vf_init(pf, vf))
+		return false;
+
+	if (!vf->num_qs_ena)
+		return false;
+	else if (vf->link_forced)
+		return vf->link_up;
+	else
+		return pf->hw.port_info->phy.link_info.link_info &
+			ICE_AQ_LINK_UP;
+}
+
 /**
  * ice_vc_notify_vf_link_state - Inform a VF of link status
  * @vf: pointer to the VF structure
@@ -99,28 +119,16 @@ ice_set_pfe_link(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
 static void ice_vc_notify_vf_link_state(struct ice_vf *vf)
 {
 	struct virtchnl_pf_event pfe = { 0 };
-	struct ice_link_status *ls;
-	struct ice_pf *pf = vf->pf;
-	struct ice_hw *hw;
-
-	hw = &pf->hw;
-	ls = &hw->port_info->phy.link_info;
+	struct ice_hw *hw = &vf->pf->hw;
 
 	pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
 	pfe.severity = PF_EVENT_SEVERITY_INFO;
 
-	/* Always report link is down if the VF queues aren't enabled */
-	if (!vf->num_qs_ena) {
+	if (ice_is_vf_link_up(vf))
+		ice_set_pfe_link(vf, &pfe,
+				 hw->port_info->phy.link_info.link_speed, true);
+	else
 		ice_set_pfe_link(vf, &pfe, ICE_AQ_LINK_SPEED_UNKNOWN, false);
-	} else if (vf->link_forced) {
-		u16 link_speed = vf->link_up ?
-			ls->link_speed : ICE_AQ_LINK_SPEED_UNKNOWN;
-
-		ice_set_pfe_link(vf, &pfe, link_speed, vf->link_up);
-	} else {
-		ice_set_pfe_link(vf, &pfe, ls->link_speed,
-				 ls->link_info & ICE_AQ_LINK_UP);
-	}
 
 	ice_aq_send_msg_to_vf(hw, vf->vf_id, VIRTCHNL_OP_EVENT,
 			      VIRTCHNL_STATUS_SUCCESS, (u8 *)&pfe,
-- 
2.24.1

