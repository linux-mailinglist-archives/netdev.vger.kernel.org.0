Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC5830248
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfE3SvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:51:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:30427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3Sug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:35 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] ice: Introduce ice_init_mac_fltr and move ice_napi_del
Date:   Thu, 30 May 2019 11:50:32 -0700
Message-Id: <20190530185045.3886-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

Consolidate adding unicast and broadcast MAC filters in a single new
function ice_init_mac_fltr.

Move ice_napi_del to ice_lib.c

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  15 +++
 drivers/net/ethernet/intel/ice/ice_lib.h  |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c | 106 +++++++++++++---------
 3 files changed, 79 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8db9427d863f..230f733817d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2733,6 +2733,21 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_napi_del - Remove NAPI handler for the VSI
+ * @vsi: VSI for which NAPI handler is to be removed
+ */
+void ice_napi_del(struct ice_vsi *vsi)
+{
+	int v_idx;
+
+	if (!vsi->netdev)
+		return;
+
+	ice_for_each_q_vector(vsi, v_idx)
+		netif_napi_del(&vsi->q_vectors[v_idx]->napi);
+}
+
 /**
  * ice_vsi_release - Delete a VSI and free its resources
  * @vsi: the VSI being removed
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 3605b7ca9120..e223767755cb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -49,6 +49,8 @@ struct ice_vsi *
 ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	      enum ice_vsi_type type, u16 vf_id);
 
+void ice_napi_del(struct ice_vsi *vsi);
+
 int ice_vsi_release(struct ice_vsi *vsi);
 
 void ice_vsi_close(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0bcc8402a5ee..da62a901b355 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -108,6 +108,67 @@ static void ice_check_for_hang_subtask(struct ice_pf *pf)
 	}
 }
 
+/**
+ * ice_init_mac_fltr - Set initial MAC filters
+ * @pf: board private structure
+ *
+ * Set initial set of mac filters for PF VSI; configure filters for permanent
+ * address and broadcast address. If an error is encountered, netdevice will be
+ * unregistered.
+ */
+static int ice_init_mac_fltr(struct ice_pf *pf)
+{
+	LIST_HEAD(tmp_add_list);
+	u8 broadcast[ETH_ALEN];
+	struct ice_vsi *vsi;
+	int status;
+
+	vsi = ice_find_vsi_by_type(pf, ICE_VSI_PF);
+	if (!vsi)
+		return -EINVAL;
+
+	/* To add a MAC filter, first add the MAC to a list and then
+	 * pass the list to ice_add_mac.
+	 */
+
+	 /* Add a unicast MAC filter so the VSI can get its packets */
+	status = ice_add_mac_to_list(vsi, &tmp_add_list,
+				     vsi->port_info->mac.perm_addr);
+	if (status)
+		goto unregister;
+
+	/* VSI needs to receive broadcast traffic, so add the broadcast
+	 * MAC address to the list as well.
+	 */
+	eth_broadcast_addr(broadcast);
+	status = ice_add_mac_to_list(vsi, &tmp_add_list, broadcast);
+	if (status)
+		goto free_mac_list;
+
+	/* Program MAC filters for entries in tmp_add_list */
+	status = ice_add_mac(&pf->hw, &tmp_add_list);
+	if (status)
+		status = -ENOMEM;
+
+free_mac_list:
+	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
+
+unregister:
+	/* We aren't useful with no MAC filters, so unregister if we
+	 * had an error
+	 */
+	if (status && vsi->netdev->reg_state == NETREG_REGISTERED) {
+		dev_err(&pf->pdev->dev,
+			"Could not add MAC filters error %d. Unregistering device\n",
+			status);
+		unregister_netdev(vsi->netdev);
+		free_netdev(vsi->netdev);
+		vsi->netdev = NULL;
+	}
+
+	return status;
+}
+
 /**
  * ice_add_mac_to_sync_list - creates list of MAC addresses to be synced
  * @netdev: the net device on which the sync is happening
@@ -1649,21 +1710,6 @@ static int ice_req_irq_msix_misc(struct ice_pf *pf)
 	return 0;
 }
 
-/**
- * ice_napi_del - Remove NAPI handler for the VSI
- * @vsi: VSI for which NAPI handler is to be removed
- */
-static void ice_napi_del(struct ice_vsi *vsi)
-{
-	int v_idx;
-
-	if (!vsi->netdev)
-		return;
-
-	ice_for_each_q_vector(vsi, v_idx)
-		netif_napi_del(&vsi->q_vectors[v_idx]->napi);
-}
-
 /**
  * ice_napi_add - register NAPI handler for the VSI
  * @vsi: VSI for which NAPI handler is to be registered
@@ -1900,8 +1946,6 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
  */
 static int ice_setup_pf_sw(struct ice_pf *pf)
 {
-	LIST_HEAD(tmp_add_list);
-	u8 broadcast[ETH_ALEN];
 	struct ice_vsi *vsi;
 	int status = 0;
 
@@ -1926,38 +1970,12 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 	 */
 	ice_napi_add(vsi);
 
-	/* To add a MAC filter, first add the MAC to a list and then
-	 * pass the list to ice_add_mac.
-	 */
-
-	 /* Add a unicast MAC filter so the VSI can get its packets */
-	status = ice_add_mac_to_list(vsi, &tmp_add_list,
-				     vsi->port_info->mac.perm_addr);
+	status = ice_init_mac_fltr(pf);
 	if (status)
 		goto unroll_napi_add;
 
-	/* VSI needs to receive broadcast traffic, so add the broadcast
-	 * MAC address to the list as well.
-	 */
-	eth_broadcast_addr(broadcast);
-	status = ice_add_mac_to_list(vsi, &tmp_add_list, broadcast);
-	if (status)
-		goto free_mac_list;
-
-	/* program MAC filters for entries in tmp_add_list */
-	status = ice_add_mac(&pf->hw, &tmp_add_list);
-	if (status) {
-		dev_err(&pf->pdev->dev, "Could not add MAC filters\n");
-		status = -ENOMEM;
-		goto free_mac_list;
-	}
-
-	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
 	return status;
 
-free_mac_list:
-	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
-
 unroll_napi_add:
 	if (vsi) {
 		ice_napi_del(vsi);
-- 
2.21.0

