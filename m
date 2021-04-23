Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446CA369743
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242301AbhDWQla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:41:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:13567 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231341AbhDWQl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:41:28 -0400
IronPort-SDR: 1m46Ic6DbQgMp7zjV7P6XroQW3ESoQOKFhmqBT6PmZDtkTSvQIM0a63lzlW0qIvHND/ZXyIMI7
 O6AojbbeFo2w==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="176218634"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="176218634"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 09:40:51 -0700
IronPort-SDR: HhJ85F/XQ7b5T9Ojg4I+o9/t8aVEpIWJenQoiHVI99ivS+PylkCKbrJUAijUSRi9uvkGcD/XFF
 0hSHMa4zTGOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="456285959"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2021 09:40:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 1/8] i40e: refactor repeated link state reporting code
Date:   Fri, 23 Apr 2021 09:42:40 -0700
Message-Id: <20210423164247.3252913-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
References: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Refactor repeated link state reporting code into a separate helper
functions: i40e_set_vf_link_state() i40e_vc_link_speed2mbps().
Add support of VIRTCHNL_VF_CAP_ADV_LINK_SPEED;

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 108 +++++++++++-------
 1 file changed, 69 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 5d301a466f5c..eff0a30790dd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -39,6 +39,66 @@ static void i40e_vc_vf_broadcast(struct i40e_pf *pf,
 	}
 }
 
+/**
+ * i40e_vc_link_speed2mbps
+ * converts i40e_aq_link_speed to integer value of Mbps
+ * @link_speed: the speed to convert
+ *
+ * return the speed as direct value of Mbps.
+ **/
+static u32
+i40e_vc_link_speed2mbps(enum i40e_aq_link_speed link_speed)
+{
+	switch (link_speed) {
+	case I40E_LINK_SPEED_100MB:
+		return SPEED_100;
+	case I40E_LINK_SPEED_1GB:
+		return SPEED_1000;
+	case I40E_LINK_SPEED_2_5GB:
+		return SPEED_2500;
+	case I40E_LINK_SPEED_5GB:
+		return SPEED_5000;
+	case I40E_LINK_SPEED_10GB:
+		return SPEED_10000;
+	case I40E_LINK_SPEED_20GB:
+		return SPEED_20000;
+	case I40E_LINK_SPEED_25GB:
+		return SPEED_25000;
+	case I40E_LINK_SPEED_40GB:
+		return SPEED_40000;
+	case I40E_LINK_SPEED_UNKNOWN:
+		return SPEED_UNKNOWN;
+	}
+	return SPEED_UNKNOWN;
+}
+
+/**
+ * i40e_set_vf_link_state
+ * @vf: pointer to the VF structure
+ * @pfe: pointer to PF event structure
+ * @ls: pointer to link status structure
+ *
+ * set a link state on a single vf
+ **/
+static void i40e_set_vf_link_state(struct i40e_vf *vf,
+				   struct virtchnl_pf_event *pfe, struct i40e_link_status *ls)
+{
+	u8 link_status = ls->link_info & I40E_AQ_LINK_UP;
+
+	if (vf->link_forced)
+		link_status = vf->link_up;
+
+	if (vf->driver_caps & VIRTCHNL_VF_CAP_ADV_LINK_SPEED) {
+		pfe->event_data.link_event_adv.link_speed = link_status ?
+			i40e_vc_link_speed2mbps(ls->link_speed) : 0;
+		pfe->event_data.link_event_adv.link_status = link_status;
+	} else {
+		pfe->event_data.link_event.link_speed = link_status ?
+			i40e_virtchnl_link_speed(ls->link_speed) : 0;
+		pfe->event_data.link_event.link_status = link_status;
+	}
+}
+
 /**
  * i40e_vc_notify_vf_link_state
  * @vf: pointer to the VF structure
@@ -55,16 +115,9 @@ static void i40e_vc_notify_vf_link_state(struct i40e_vf *vf)
 
 	pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
 	pfe.severity = PF_EVENT_SEVERITY_INFO;
-	if (vf->link_forced) {
-		pfe.event_data.link_event.link_status = vf->link_up;
-		pfe.event_data.link_event.link_speed =
-			(vf->link_up ? i40e_virtchnl_link_speed(ls->link_speed) : 0);
-	} else {
-		pfe.event_data.link_event.link_status =
-			ls->link_info & I40E_AQ_LINK_UP;
-		pfe.event_data.link_event.link_speed =
-			i40e_virtchnl_link_speed(ls->link_speed);
-	}
+
+	i40e_set_vf_link_state(vf, &pfe, ls);
+
 	i40e_aq_send_msg_to_vf(hw, abs_vf_id, VIRTCHNL_OP_EVENT,
 			       0, (u8 *)&pfe, sizeof(pfe), NULL);
 }
@@ -1949,6 +2002,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 				  VIRTCHNL_VF_OFFLOAD_VLAN;
 
 	vfres->vf_cap_flags = VIRTCHNL_VF_OFFLOAD_L2;
+	vfres->vf_cap_flags |= VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	if (!vsi->info.pvid)
 		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
@@ -3696,26 +3750,8 @@ static int i40e_vc_add_qch_msg(struct i40e_vf *vf, u8 *msg)
 	}
 
 	/* get link speed in MB to validate rate limit */
-	switch (ls->link_speed) {
-	case VIRTCHNL_LINK_SPEED_100MB:
-		speed = SPEED_100;
-		break;
-	case VIRTCHNL_LINK_SPEED_1GB:
-		speed = SPEED_1000;
-		break;
-	case VIRTCHNL_LINK_SPEED_10GB:
-		speed = SPEED_10000;
-		break;
-	case VIRTCHNL_LINK_SPEED_20GB:
-		speed = SPEED_20000;
-		break;
-	case VIRTCHNL_LINK_SPEED_25GB:
-		speed = SPEED_25000;
-		break;
-	case VIRTCHNL_LINK_SPEED_40GB:
-		speed = SPEED_40000;
-		break;
-	default:
+	speed = i40e_vc_link_speed2mbps(ls->link_speed);
+	if (speed == SPEED_UNKNOWN) {
 		dev_err(&pf->pdev->dev,
 			"Cannot detect link speed\n");
 		aq_ret = I40E_ERR_PARAM;
@@ -4464,23 +4500,17 @@ int i40e_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link)
 	switch (link) {
 	case IFLA_VF_LINK_STATE_AUTO:
 		vf->link_forced = false;
-		pfe.event_data.link_event.link_status =
-			pf->hw.phy.link_info.link_info & I40E_AQ_LINK_UP;
-		pfe.event_data.link_event.link_speed =
-			(enum virtchnl_link_speed)
-			pf->hw.phy.link_info.link_speed;
+		i40e_set_vf_link_state(vf, &pfe, ls);
 		break;
 	case IFLA_VF_LINK_STATE_ENABLE:
 		vf->link_forced = true;
 		vf->link_up = true;
-		pfe.event_data.link_event.link_status = true;
-		pfe.event_data.link_event.link_speed = i40e_virtchnl_link_speed(ls->link_speed);
+		i40e_set_vf_link_state(vf, &pfe, ls);
 		break;
 	case IFLA_VF_LINK_STATE_DISABLE:
 		vf->link_forced = true;
 		vf->link_up = false;
-		pfe.event_data.link_event.link_status = false;
-		pfe.event_data.link_event.link_speed = 0;
+		i40e_set_vf_link_state(vf, &pfe, ls);
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.26.2

