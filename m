Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944A711604
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfEBJGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:47595 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfEBJG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615374"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] ice: Refactor link event flow
Date:   Thu,  2 May 2019 02:06:19 -0700
Message-Id: <20190502090620.21281-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the link event flow works, but can be much better.
Refactor the link event flow to make it cleaner and more clear
on what is going on.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 20 +++++
 drivers/net/ethernet/intel/ice/ice_main.c | 93 +++++++++++------------
 2 files changed, 65 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index d66aad49bfd4..804d12c2f1df 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -420,6 +420,26 @@ ice_irq_dynamic_ena(struct ice_hw *hw, struct ice_vsi *vsi,
 	wr32(hw, GLINT_DYN_CTL(vector), val);
 }
 
+/**
+ * ice_find_vsi_by_type - Find and return VSI of a given type
+ * @pf: PF to search for VSI
+ * @type: Value indicating type of VSI we are looking for
+ */
+static inline struct ice_vsi *
+ice_find_vsi_by_type(struct ice_pf *pf, enum ice_vsi_type type)
+{
+	int i;
+
+	for (i = 0; i < pf->num_alloc_vsi; i++) {
+		struct ice_vsi *vsi = pf->vsi[i];
+
+		if (vsi && vsi->type == type)
+			return vsi;
+	}
+
+	return NULL;
+}
+
 void ice_set_ethtool_ops(struct net_device *netdev);
 int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 51af6b9a7ea2..6b27be93bdf5 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -590,6 +590,9 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	const char *speed;
 	const char *fc;
 
+	if (!vsi)
+		return;
+
 	if (vsi->current_isup == isup)
 		return;
 
@@ -659,15 +662,16 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
  */
 static void ice_vsi_link_event(struct ice_vsi *vsi, bool link_up)
 {
-	if (!vsi || test_bit(__ICE_DOWN, vsi->state))
+	if (!vsi)
+		return;
+
+	if (test_bit(__ICE_DOWN, vsi->state) || !vsi->netdev)
 		return;
 
 	if (vsi->type == ICE_VSI_PF) {
-		if (!vsi->netdev) {
-			dev_dbg(&vsi->back->pdev->dev,
-				"vsi->netdev is not initialized!\n");
+		if (link_up == netif_carrier_ok(vsi->netdev))
 			return;
-		}
+
 		if (link_up) {
 			netif_carrier_on(vsi->netdev);
 			netif_tx_wake_all_queues(vsi->netdev);
@@ -682,61 +686,51 @@ static void ice_vsi_link_event(struct ice_vsi *vsi, bool link_up)
  * ice_link_event - process the link event
  * @pf: pf that the link event is associated with
  * @pi: port_info for the port that the link event is associated with
+ * @link_up: true if the physical link is up and false if it is down
+ * @link_speed: current link speed received from the link event
  *
- * Returns -EIO if ice_get_link_status() fails
- * Returns 0 on success
+ * Returns 0 on success and negative on failure
  */
 static int
-ice_link_event(struct ice_pf *pf, struct ice_port_info *pi)
+ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
+	       u16 link_speed)
 {
-	u8 new_link_speed, old_link_speed;
 	struct ice_phy_info *phy_info;
-	bool new_link_same_as_old;
-	bool new_link, old_link;
-	u8 lport;
-	u16 v;
+	struct ice_vsi *vsi;
+	u16 old_link_speed;
+	bool old_link;
+	int result;
 
 	phy_info = &pi->phy;
 	phy_info->link_info_old = phy_info->link_info;
-	/* Force ice_get_link_status() to update link info */
-	phy_info->get_link_info = true;
 
-	old_link = (phy_info->link_info_old.link_info & ICE_AQ_LINK_UP);
+	old_link = !!(phy_info->link_info_old.link_info & ICE_AQ_LINK_UP);
 	old_link_speed = phy_info->link_info_old.link_speed;
 
-	lport = pi->lport;
-	if (ice_get_link_status(pi, &new_link)) {
+	/* update the link info structures and re-enable link events,
+	 * don't bail on failure due to other book keeping needed
+	 */
+	result = ice_update_link_info(pi);
+	if (result)
 		dev_dbg(&pf->pdev->dev,
-			"Could not get link status for port %d\n", lport);
-		return -EIO;
-	}
-
-	new_link_speed = phy_info->link_info.link_speed;
-
-	new_link_same_as_old = (new_link == old_link &&
-				new_link_speed == old_link_speed);
+			"Failed to update link status and re-enable link events for port %d\n",
+			pi->lport);
 
-	ice_for_each_vsi(pf, v) {
-		struct ice_vsi *vsi = pf->vsi[v];
+	/* if the old link up/down and speed is the same as the new */
+	if (link_up == old_link && link_speed == old_link_speed)
+		return result;
 
-		if (!vsi || !vsi->port_info)
-			continue;
+	vsi = ice_find_vsi_by_type(pf, ICE_VSI_PF);
+	if (!vsi || !vsi->port_info)
+		return -EINVAL;
 
-		if (new_link_same_as_old &&
-		    (test_bit(__ICE_DOWN, vsi->state) ||
-		    new_link == netif_carrier_ok(vsi->netdev)))
-			continue;
+	ice_vsi_link_event(vsi, link_up);
+	ice_print_link_msg(vsi, link_up);
 
-		if (vsi->port_info->lport == lport) {
-			ice_print_link_msg(vsi, new_link);
-			ice_vsi_link_event(vsi, new_link);
-		}
-	}
-
-	if (!new_link_same_as_old && pf->num_alloc_vfs)
+	if (pf->num_alloc_vfs)
 		ice_vc_notify_link_state(pf);
 
-	return 0;
+	return result;
 }
 
 /**
@@ -801,20 +795,23 @@ static int ice_init_link_events(struct ice_port_info *pi)
 /**
  * ice_handle_link_event - handle link event via ARQ
  * @pf: pf that the link event is associated with
- *
- * Return -EINVAL if port_info is null
- * Return status on success
+ * @event: event structure containing link status info
  */
-static int ice_handle_link_event(struct ice_pf *pf)
+static int
+ice_handle_link_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 {
+	struct ice_aqc_get_link_status_data *link_data;
 	struct ice_port_info *port_info;
 	int status;
 
+	link_data = (struct ice_aqc_get_link_status_data *)event->msg_buf;
 	port_info = pf->hw.port_info;
 	if (!port_info)
 		return -EINVAL;
 
-	status = ice_link_event(pf, port_info);
+	status = ice_link_event(pf, port_info,
+				!!(link_data->link_info & ICE_AQ_LINK_UP),
+				le16_to_cpu(link_data->link_speed));
 	if (status)
 		dev_dbg(&pf->pdev->dev,
 			"Could not process link event, error %d\n", status);
@@ -926,7 +923,7 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 
 		switch (opcode) {
 		case ice_aqc_opc_get_link_status:
-			if (ice_handle_link_event(pf))
+			if (ice_handle_link_event(pf, &event))
 				dev_err(&pf->pdev->dev,
 					"Could not handle link event\n");
 			break;
-- 
2.20.1

