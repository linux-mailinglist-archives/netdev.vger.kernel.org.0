Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F0C1A5B1F
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgDKXri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbgDKXE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FAEC216FD;
        Sat, 11 Apr 2020 23:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646299;
        bh=t9x4P5NVHxHGYe5KmsPV4BKz1QVfqricyfnD2ieor6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsA5pXvTTySguJj5ajuHTpQXMTrk69PPvzboD3Emak/+EDzhpyBixwuwLmA5zkgG9
         KnMyN7GfdQHtLLBYvR0pvaTv9HpmWiQzKfY4z4gefuEbdqpOHierCkfJrwp73vMmXY
         4lxmsDNXEAucXBYPlWLXinlejuDghTHbXsZIBFyk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 058/149] ice: Add helper to determine if VF link is up
Date:   Sat, 11 Apr 2020 19:02:15 -0400
Message-Id: <20200411230347.22371-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit 0b6c6a8bb6d541aad9e0f3bb2307316707aec723 ]

The check for vf->link_up is incorrect because this field is only valid if
vf->link_forced is true. Fix this by adding the helper ice_is_vf_link_up()
to determine if the VF's link is up.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 42 +++++++++++--------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 75c70d432c724..5924924b464a4 100644
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
2.20.1

