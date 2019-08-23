Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4BF9B8F7
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfHWXiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:38:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:14901 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbfHWXhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354444"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/14] ice: Fix issues updating VSI MAC filters
Date:   Fri, 23 Aug 2019 16:37:49 -0700
Message-Id: <20190823233750.7997-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

VSI, especially VF could request to add or remove filter for another VSI,
driver should really guide such request and disallow it.
However, instead of returning error for such malicious request, driver
can simply return success.

In addition, we are not tracking number of MAC filters configured per
VF correctly - and this leads to issue updating VF MAC filters whenever
they were removed and re-configured via bringing VF interface down and
up. Also, since VF could send request to update multiple MAC filters at
once, driver should program those filters individually in the switch, in
order to determine which action resulted to error, and communicate
accordingly to the VF.

So, with this changes, we now track number of filters added right from
when VF resources allocation is done, and could properly add filters for
both trusted and non_trusted VFs, without MAC filters mis-match issue in
the switch...

Also refactor code, so that driver can use new function to add or remove
MAC filters.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c      | 30 +++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h      |  4 ++
 drivers/net/ethernet/intel/ice/ice_main.c     | 64 +++++--------------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 42 ++++++------
 4 files changed, 73 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 343d0c305423..8d5d6635a123 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3181,3 +3181,33 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 	return ret;
 }
 #endif /* CONFIG_DCB */
+
+/**
+ * ice_vsi_cfg_mac_fltr - Add or remove a MAC address filter for a VSI
+ * @vsi: the VSI being configured MAC filter
+ * @macaddr: the MAC address to be added.
+ * @set: Add or delete a MAC filter
+ *
+ * Adds or removes MAC address filter entry for VF VSI
+ */
+enum ice_status
+ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set)
+{
+	LIST_HEAD(tmp_add_list);
+	enum ice_status status;
+
+	 /* Update MAC filter list to be added or removed for a VSI */
+	if (ice_add_mac_to_list(vsi, &tmp_add_list, macaddr)) {
+		status = ICE_ERR_NO_MEMORY;
+		goto cfg_mac_fltr_exit;
+	}
+
+	if (set)
+		status = ice_add_mac(&vsi->back->hw, &tmp_add_list);
+	else
+		status = ice_remove_mac(&vsi->back->hw, &tmp_add_list);
+
+cfg_mac_fltr_exit:
+	ice_free_fltr_list(&vsi->back->pdev->dev, &tmp_add_list);
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 6e43ef03bfc3..969ba27cba95 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -95,4 +95,8 @@ void ice_vsi_free_tx_rings(struct ice_vsi *vsi);
 int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
 
 u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran);
+
+enum ice_status
+ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
+
 #endif /* !_ICE_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6dd806b763ea..f3923dec32b7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -116,10 +116,9 @@ static void ice_check_for_hang_subtask(struct ice_pf *pf)
  */
 static int ice_init_mac_fltr(struct ice_pf *pf)
 {
-	LIST_HEAD(tmp_add_list);
+	enum ice_status status;
 	u8 broadcast[ETH_ALEN];
 	struct ice_vsi *vsi;
-	int status;
 
 	vsi = ice_find_vsi_by_type(pf, ICE_VSI_PF);
 	if (!vsi)
@@ -130,8 +129,7 @@ static int ice_init_mac_fltr(struct ice_pf *pf)
 	 */
 
 	 /* Add a unicast MAC filter so the VSI can get its packets */
-	status = ice_add_mac_to_list(vsi, &tmp_add_list,
-				     vsi->port_info->mac.perm_addr);
+	status = ice_vsi_cfg_mac_fltr(vsi, vsi->port_info->mac.perm_addr, true);
 	if (status)
 		goto unregister;
 
@@ -139,18 +137,11 @@ static int ice_init_mac_fltr(struct ice_pf *pf)
 	 * MAC address to the list as well.
 	 */
 	eth_broadcast_addr(broadcast);
-	status = ice_add_mac_to_list(vsi, &tmp_add_list, broadcast);
-	if (status)
-		goto free_mac_list;
-
-	/* Program MAC filters for entries in tmp_add_list */
-	status = ice_add_mac(&pf->hw, &tmp_add_list);
+	status = ice_vsi_cfg_mac_fltr(vsi, broadcast, true);
 	if (status)
-		status = -ENOMEM;
-
-free_mac_list:
-	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
+		goto unregister;
 
+	return 0;
 unregister:
 	/* We aren't useful with no MAC filters, so unregister if we
 	 * had an error
@@ -164,7 +155,7 @@ static int ice_init_mac_fltr(struct ice_pf *pf)
 		vsi->netdev = NULL;
 	}
 
-	return status;
+	return -EIO;
 }
 
 /**
@@ -2834,10 +2825,8 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	struct ice_hw *hw = &pf->hw;
 	struct sockaddr *addr = pi;
 	enum ice_status status;
-	LIST_HEAD(a_mac_list);
-	LIST_HEAD(r_mac_list);
 	u8 flags = 0;
-	int err;
+	int err = 0;
 	u8 *mac;
 
 	mac = (u8 *)addr->sa_data;
@@ -2860,42 +2849,23 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	/* When we change the MAC address we also have to change the MAC address
 	 * based filter rules that were created previously for the old MAC
 	 * address. So first, we remove the old filter rule using ice_remove_mac
-	 * and then create a new filter rule using ice_add_mac. Note that for
-	 * both these operations, we first need to form a "list" of MAC
-	 * addresses (even though in this case, we have only 1 MAC address to be
-	 * added/removed) and this done using ice_add_mac_to_list. Depending on
-	 * the ensuing operation this "list" of MAC addresses is either to be
-	 * added or removed from the filter.
+	 * and then create a new filter rule using ice_add_mac via
+	 * ice_vsi_cfg_mac_fltr function call for both add and/or remove
+	 * filters.
 	 */
-	err = ice_add_mac_to_list(vsi, &r_mac_list, netdev->dev_addr);
-	if (err) {
-		err = -EADDRNOTAVAIL;
-		goto free_lists;
-	}
-
-	status = ice_remove_mac(hw, &r_mac_list);
+	status = ice_vsi_cfg_mac_fltr(vsi, netdev->dev_addr, false);
 	if (status) {
 		err = -EADDRNOTAVAIL;
-		goto free_lists;
-	}
-
-	err = ice_add_mac_to_list(vsi, &a_mac_list, mac);
-	if (err) {
-		err = -EADDRNOTAVAIL;
-		goto free_lists;
+		goto err_update_filters;
 	}
 
-	status = ice_add_mac(hw, &a_mac_list);
+	status = ice_vsi_cfg_mac_fltr(vsi, mac, true);
 	if (status) {
 		err = -EADDRNOTAVAIL;
-		goto free_lists;
+		goto err_update_filters;
 	}
 
-free_lists:
-	/* free list entries */
-	ice_free_fltr_list(&pf->pdev->dev, &r_mac_list);
-	ice_free_fltr_list(&pf->pdev->dev, &a_mac_list);
-
+err_update_filters:
 	if (err) {
 		netdev_err(netdev, "can't set MAC %pM. filter update failed\n",
 			   mac);
@@ -2911,8 +2881,8 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	flags = ICE_AQC_MAN_MAC_UPDATE_LAA_WOL;
 	status = ice_aq_manage_mac_write(hw, mac, flags, NULL);
 	if (status) {
-		netdev_err(netdev, "can't set MAC %pM. write to firmware failed.\n",
-			   mac);
+		netdev_err(netdev, "can't set MAC %pM. write to firmware failed error %d\n",
+			   mac, status);
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index de0a1ef54e83..86637d99ee77 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -540,7 +540,10 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 
 	status = ice_add_mac(&pf->hw, &tmp_add_list);
 	if (status)
-		dev_err(&pf->pdev->dev, "could not add mac filters\n");
+		dev_err(&pf->pdev->dev,
+			"could not add mac filters error %d\n", status);
+	else
+		vf->num_mac = 1;
 
 	/* Clear this bit after VF initialization since we shouldn't reclaim
 	 * and reassign interrupts for synchronous or asynchronous VFR events.
@@ -2208,7 +2211,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 	    (struct virtchnl_ether_addr_list *)msg;
 	struct ice_pf *pf = vf->pf;
 	enum virtchnl_ops vc_op;
-	LIST_HEAD(mac_list);
+	enum ice_status status;
 	struct ice_vsi *vsi;
 	int mac_count = 0;
 	int i;
@@ -2282,33 +2285,32 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 			goto handle_mac_exit;
 		}
 
-		/* get here if maddr is multicast or if VF can change MAC */
-		if (ice_add_mac_to_list(vsi, &mac_list, al->list[i].addr)) {
-			v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
+		/* program the updated filter list */
+		status = ice_vsi_cfg_mac_fltr(vsi, maddr, set);
+		if (status == ICE_ERR_DOES_NOT_EXIST ||
+		    status == ICE_ERR_ALREADY_EXISTS) {
+			dev_info(&pf->pdev->dev,
+				 "can't %s MAC filters %pM for VF %d, error %d\n",
+				 set ? "add" : "remove", maddr, vf->vf_id,
+				 status);
+		} else if (status) {
+			dev_err(&pf->pdev->dev,
+				"can't %s MAC filters for VF %d, error %d\n",
+				set ? "add" : "remove", vf->vf_id, status);
+			v_ret = ice_err_to_virt_err(status);
 			goto handle_mac_exit;
 		}
+
 		mac_count++;
 	}
 
-	/* program the updated filter list */
+	/* Track number of MAC filters programmed for the VF VSI */
 	if (set)
-		v_ret = ice_err_to_virt_err(ice_add_mac(&pf->hw, &mac_list));
+		vf->num_mac += mac_count;
 	else
-		v_ret = ice_err_to_virt_err(ice_remove_mac(&pf->hw, &mac_list));
-
-	if (v_ret) {
-		dev_err(&pf->pdev->dev,
-			"can't %s MAC filters for VF %d, error %d\n",
-			set ? "add" : "remove", vf->vf_id, v_ret);
-	} else {
-		if (set)
-			vf->num_mac += mac_count;
-		else
-			vf->num_mac -= mac_count;
-	}
+		vf->num_mac -= mac_count;
 
 handle_mac_exit:
-	ice_free_fltr_list(&pf->pdev->dev, &mac_list);
 	/* send the response to the VF */
 	return ice_vc_send_msg_to_vf(vf, vc_op, v_ret, NULL, 0);
 }
-- 
2.21.0

