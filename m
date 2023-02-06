Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED88968C8F5
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjBFVt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBFVtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:49:19 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632C52E0E8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720139; x=1707256139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v3EN85akknQy5HVVXTWaI7WBUGlX1ohYcnpUn4pgFdI=;
  b=OVn9jWcwWykVgSqgzaOCp4JN8Z8GZ5fCITmzmts/EGg3E5mgzqEk+Obq
   24JH9EzSeUG0YZS+65djWziIhLw9uMWKZQ1IkY2rxCNVCwxOHi1k4pI81
   wIKeuo2rXqQRmRhHFEwuM1R/QGaUN8YEsEwm/9M2gxsqWOW1Wugfh0H1z
   /VzFXrZr0vvY6h2AhxIIbZL4fnA0lWTKQ1Tfh8NvcX3r6fgLg5QfakRlZ
   8TjkBAt6U4ew/1MY8MOh3WPyFm8JogBlAWWV+DQfR8Tv/BTwgtXtBQJmq
   PVNirF8DBnZb0kbR+QoNN50yZL/S/DBJwZfxnBMnsMT08AVfj0rTpgb+g
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338157"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338157"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576218"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576218"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 13/13] ice: remove unnecessary virtchnl_ether_addr struct use
Date:   Mon,  6 Feb 2023 13:48:13 -0800
Message-Id: <20230206214813.20107-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The dev_lan_addr and hw_lan_addr members of ice_vf are used only to store
the MAC address for the VF. They are defined using virtchnl_ether_addr, but
only the .addr sub-member is actually used. Drop the use of
virtchnl_ether_addr and just use a u8 array of length [ETH_ALEN].

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c  | 18 +++++++-------
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 16 ++++++-------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  8 +++----
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  4 ++--
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 24 +++++++++----------
 5 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index b86d173a20af..f6dd3f8fd936 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -71,17 +71,17 @@ void ice_eswitch_replay_vf_mac_rule(struct ice_vf *vf)
 	if (!ice_is_switchdev_running(vf->pf))
 		return;
 
-	if (is_valid_ether_addr(vf->hw_lan_addr.addr)) {
+	if (is_valid_ether_addr(vf->hw_lan_addr)) {
 		err = ice_eswitch_add_vf_mac_rule(vf->pf, vf,
-						  vf->hw_lan_addr.addr);
+						  vf->hw_lan_addr);
 		if (err) {
 			dev_err(ice_pf_to_dev(vf->pf), "Failed to add MAC %pM for VF %d\n, error %d\n",
-				vf->hw_lan_addr.addr, vf->vf_id, err);
+				vf->hw_lan_addr, vf->vf_id, err);
 			return;
 		}
 		vf->num_mac++;
 
-		ether_addr_copy(vf->dev_lan_addr.addr, vf->hw_lan_addr.addr);
+		ether_addr_copy(vf->dev_lan_addr, vf->hw_lan_addr);
 	}
 }
 
@@ -237,7 +237,7 @@ ice_eswitch_release_reprs(struct ice_pf *pf, struct ice_vsi *ctrl_vsi)
 		ice_vsi_update_security(vsi, ice_vsi_ctx_set_antispoof);
 		metadata_dst_free(vf->repr->dst);
 		vf->repr->dst = NULL;
-		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr.addr,
+		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr,
 					       ICE_FWD_TO_VSI);
 
 		netif_napi_del(&vf->repr->q_vector->napi);
@@ -265,14 +265,14 @@ static int ice_eswitch_setup_reprs(struct ice_pf *pf)
 						   GFP_KERNEL);
 		if (!vf->repr->dst) {
 			ice_fltr_add_mac_and_broadcast(vsi,
-						       vf->hw_lan_addr.addr,
+						       vf->hw_lan_addr,
 						       ICE_FWD_TO_VSI);
 			goto err;
 		}
 
 		if (ice_vsi_update_security(vsi, ice_vsi_ctx_clear_antispoof)) {
 			ice_fltr_add_mac_and_broadcast(vsi,
-						       vf->hw_lan_addr.addr,
+						       vf->hw_lan_addr,
 						       ICE_FWD_TO_VSI);
 			metadata_dst_free(vf->repr->dst);
 			vf->repr->dst = NULL;
@@ -281,7 +281,7 @@ static int ice_eswitch_setup_reprs(struct ice_pf *pf)
 
 		if (ice_vsi_add_vlan_zero(vsi)) {
 			ice_fltr_add_mac_and_broadcast(vsi,
-						       vf->hw_lan_addr.addr,
+						       vf->hw_lan_addr,
 						       ICE_FWD_TO_VSI);
 			metadata_dst_free(vf->repr->dst);
 			vf->repr->dst = NULL;
@@ -338,7 +338,7 @@ void ice_eswitch_update_repr(struct ice_vsi *vsi)
 
 	ret = ice_vsi_update_security(vsi, ice_vsi_ctx_clear_antispoof);
 	if (ret) {
-		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr.addr, ICE_FWD_TO_VSI);
+		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr, ICE_FWD_TO_VSI);
 		dev_err(ice_pf_to_dev(pf), "Failed to update VF %d port representor",
 			vsi->vf->vf_id);
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 356ac76ef90f..96a64c25e2ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1242,7 +1242,7 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 		goto out_put_vf;
 
 	ivi->vf = vf_id;
-	ether_addr_copy(ivi->mac, vf->hw_lan_addr.addr);
+	ether_addr_copy(ivi->mac, vf->hw_lan_addr);
 
 	/* VF configuration for VLAN and applicable QoS */
 	ivi->vlan = ice_vf_get_port_vlan_id(vf);
@@ -1290,8 +1290,8 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		return -EINVAL;
 
 	/* nothing left to do, unicast MAC already set */
-	if (ether_addr_equal(vf->dev_lan_addr.addr, mac) &&
-	    ether_addr_equal(vf->hw_lan_addr.addr, mac)) {
+	if (ether_addr_equal(vf->dev_lan_addr, mac) &&
+	    ether_addr_equal(vf->hw_lan_addr, mac)) {
 		ret = 0;
 		goto out_put_vf;
 	}
@@ -1305,8 +1305,8 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	/* VF is notified of its new MAC via the PF's response to the
 	 * VIRTCHNL_OP_GET_VF_RESOURCES message after the VF has been reset
 	 */
-	ether_addr_copy(vf->dev_lan_addr.addr, mac);
-	ether_addr_copy(vf->hw_lan_addr.addr, mac);
+	ether_addr_copy(vf->dev_lan_addr, mac);
+	ether_addr_copy(vf->hw_lan_addr, mac);
 	if (is_zero_ether_addr(mac)) {
 		/* VF will send VIRTCHNL_OP_ADD_ETH_ADDR message with its MAC */
 		vf->pf_set_mac = false;
@@ -1707,7 +1707,7 @@ void ice_print_vf_rx_mdd_event(struct ice_vf *vf)
 
 	dev_info(dev, "%d Rx Malicious Driver Detection events detected on PF %d VF %d MAC %pM. mdd-auto-reset-vfs=%s\n",
 		 vf->mdd_rx_events.count, pf->hw.pf_id, vf->vf_id,
-		 vf->dev_lan_addr.addr,
+		 vf->dev_lan_addr,
 		 test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags)
 			  ? "on" : "off");
 }
@@ -1751,7 +1751,7 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf)
 
 			dev_info(dev, "%d Tx Malicious Driver Detection events detected on PF %d VF %d MAC %pM.\n",
 				 vf->mdd_tx_events.count, hw->pf_id, vf->vf_id,
-				 vf->dev_lan_addr.addr);
+				 vf->dev_lan_addr);
 		}
 	}
 	mutex_unlock(&pf->vfs.table_lock);
@@ -1841,7 +1841,7 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 
 			if (pf_vsi)
 				dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
-					 &vf->dev_lan_addr.addr[0],
+					 &vf->dev_lan_addr[0],
 					 pf_vsi->netdev->dev_addr);
 		}
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index d16c2ea83873..0e57bd1b85fd 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -1008,18 +1008,18 @@ static int ice_vf_rebuild_host_mac_cfg(struct ice_vf *vf)
 
 	vf->num_mac++;
 
-	if (is_valid_ether_addr(vf->hw_lan_addr.addr)) {
-		status = ice_fltr_add_mac(vsi, vf->hw_lan_addr.addr,
+	if (is_valid_ether_addr(vf->hw_lan_addr)) {
+		status = ice_fltr_add_mac(vsi, vf->hw_lan_addr,
 					  ICE_FWD_TO_VSI);
 		if (status) {
 			dev_err(dev, "failed to add default unicast MAC filter %pM for VF %u, error %d\n",
-				&vf->hw_lan_addr.addr[0], vf->vf_id,
+				&vf->hw_lan_addr[0], vf->vf_id,
 				status);
 			return status;
 		}
 		vf->num_mac++;
 
-		ether_addr_copy(vf->dev_lan_addr.addr, vf->hw_lan_addr.addr);
+		ether_addr_copy(vf->dev_lan_addr, vf->hw_lan_addr);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index b4e6480f30a7..ef30f05b5d02 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -98,8 +98,8 @@ struct ice_vf {
 	struct ice_sw *vf_sw_id;	/* switch ID the VF VSIs connect to */
 	struct virtchnl_version_info vf_ver;
 	u32 driver_caps;		/* reported by VF driver */
-	struct virtchnl_ether_addr dev_lan_addr;
-	struct virtchnl_ether_addr hw_lan_addr;
+	u8 dev_lan_addr[ETH_ALEN];
+	u8 hw_lan_addr[ETH_ALEN];
 	struct ice_time_mac legacy_last_added_umac;
 	DECLARE_BITMAP(txq_ena, ICE_MAX_RSS_QS_PER_VF);
 	DECLARE_BITMAP(rxq_ena, ICE_MAX_RSS_QS_PER_VF);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index dab3cd5d300e..e24e3f5017ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -507,7 +507,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	vfres->vsi_res[0].vsi_type = VIRTCHNL_VSI_SRIOV;
 	vfres->vsi_res[0].num_queue_pairs = vsi->num_txq;
 	ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
-			vf->hw_lan_addr.addr);
+			vf->hw_lan_addr);
 
 	/* match guest capabilities */
 	vf->driver_caps = vfres->vf_cap_flags;
@@ -1802,10 +1802,10 @@ ice_vfhw_mac_add(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
 	 * was correctly specified over VIRTCHNL
 	 */
 	if ((ice_is_vc_addr_legacy(vc_ether_addr) &&
-	     is_zero_ether_addr(vf->hw_lan_addr.addr)) ||
+	     is_zero_ether_addr(vf->hw_lan_addr)) ||
 	    ice_is_vc_addr_primary(vc_ether_addr)) {
-		ether_addr_copy(vf->dev_lan_addr.addr, mac_addr);
-		ether_addr_copy(vf->hw_lan_addr.addr, mac_addr);
+		ether_addr_copy(vf->dev_lan_addr, mac_addr);
+		ether_addr_copy(vf->hw_lan_addr, mac_addr);
 	}
 
 	/* hardware and device MACs are already set, but its possible that the
@@ -1836,7 +1836,7 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 	int ret;
 
 	/* device MAC already added */
-	if (ether_addr_equal(mac_addr, vf->dev_lan_addr.addr))
+	if (ether_addr_equal(mac_addr, vf->dev_lan_addr))
 		return 0;
 
 	if (is_unicast_ether_addr(mac_addr) && !ice_can_vf_change_mac(vf)) {
@@ -1891,8 +1891,8 @@ ice_update_legacy_cached_mac(struct ice_vf *vf,
 	    ice_is_legacy_umac_expired(&vf->legacy_last_added_umac))
 		return;
 
-	ether_addr_copy(vf->dev_lan_addr.addr, vf->legacy_last_added_umac.addr);
-	ether_addr_copy(vf->hw_lan_addr.addr, vf->legacy_last_added_umac.addr);
+	ether_addr_copy(vf->dev_lan_addr, vf->legacy_last_added_umac.addr);
+	ether_addr_copy(vf->hw_lan_addr, vf->legacy_last_added_umac.addr);
 }
 
 /**
@@ -1906,15 +1906,15 @@ ice_vfhw_mac_del(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
 	u8 *mac_addr = vc_ether_addr->addr;
 
 	if (!is_valid_ether_addr(mac_addr) ||
-	    !ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
+	    !ether_addr_equal(vf->dev_lan_addr, mac_addr))
 		return;
 
 	/* allow the device MAC to be repopulated in the add flow and don't
-	 * clear the hardware MAC (i.e. hw_lan_addr.addr) here as that is meant
+	 * clear the hardware MAC (i.e. hw_lan_addr) here as that is meant
 	 * to be persistent on VM reboot and across driver unload/load, which
 	 * won't work if we clear the hardware MAC here
 	 */
-	eth_zero_addr(vf->dev_lan_addr.addr);
+	eth_zero_addr(vf->dev_lan_addr);
 
 	ice_update_legacy_cached_mac(vf, vc_ether_addr);
 }
@@ -1934,7 +1934,7 @@ ice_vc_del_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 	int status;
 
 	if (!ice_can_vf_change_mac(vf) &&
-	    ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
+	    ether_addr_equal(vf->dev_lan_addr, mac_addr))
 		return 0;
 
 	status = ice_fltr_remove_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
@@ -3733,7 +3733,7 @@ static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
 		int result;
 
 		if (!is_unicast_ether_addr(mac_addr) ||
-		    ether_addr_equal(mac_addr, vf->hw_lan_addr.addr))
+		    ether_addr_equal(mac_addr, vf->hw_lan_addr))
 			continue;
 
 		if (vf->pf_set_mac) {
-- 
2.38.1

