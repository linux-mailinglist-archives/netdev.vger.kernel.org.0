Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3E239E48A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhFGQxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:53:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:16640 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231441AbhFGQxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:53:06 -0400
IronPort-SDR: TrEooIQ8E9Yj6M/96CpdNdPQ0KRPBW7Jul4cLKCBHlCRWy7yQ2GQXIlYRKuuHGpW0AQOjdtN5l
 gbGBnRK0DtEg==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="268516247"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="268516247"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:53 -0700
IronPort-SDR: G/e5Uk2imgMuMt4HstGrwulnmsqX8C8J7smmaSnXpD8EYAnnUmBo7wJUCbW2+QPcLCAyHYuXcj
 OnJGymwFWoQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841225"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 03/15] ice: Save VF's MAC across reboot
Date:   Mon,  7 Jun 2021 09:53:13 -0700
Message-Id: <20210607165325.182087-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

If a VM reboots and/or VF driver is unloaded, its cached hardware MAC
address (hw_lan_addr.addr) is cleared in some cases. If the VF is
trusted, then the PF driver allows the VF to clear its old MAC address
even if this MAC was configured by a host administrator. If the VF is
untrusted, then the PF driver allows the VF to clear its old MAC
address only if the host admin did not set it.

For the trusted VF case, this is unexpected and will cause issues
because the host configured MAC (i.e. via XML) will be cleared on VM
reboot. For the untrusted VF case, this is done to be consistent and it
will allow the VF to keep the same MAC across VM reboot.

Fix this by introducing dev_lan_addr to the VF structure. This will be
the VF's MAC address when it's up and running and in most cases will be
the same as the hw_lan_addr. However, to address the VM reboot and
unload/reload problem, the driver will never allow the hw_lan_addr to be
cleared via VIRTCHNL_OP_DEL_ETH_ADDR. When the VF's MAC is changed, the
dev_lan_addr and hw_lan_addr will always be updated with the same value.
The only ways the VF's MAC can change are the following:

- Set the VF's MAC administratively on the host via iproute2.
- If the VF is trusted and changes/sets its own MAC.
- If the VF is untrusted and the host has not set the MAC via iproute2.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 47 ++++++++++++-------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  1 +
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index b0a15b821b15..677d29fd0885 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -947,6 +947,8 @@ static int ice_vf_rebuild_host_mac_cfg(struct ice_vf *vf)
 			return ice_status_to_errno(status);
 		}
 		vf->num_mac++;
+
+		ether_addr_copy(vf->dev_lan_addr.addr, vf->hw_lan_addr.addr);
 	}
 
 	return 0;
@@ -3709,17 +3711,19 @@ ice_vfhw_mac_add(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
 	if (!is_valid_ether_addr(mac_addr))
 		return;
 
-	/* only allow legacy VF drivers to set the hardware MAC if it is zero
-	 * and allow new VF drivers to set the hardware MAC if the type was
-	 * correctly specified over VIRTCHNL
+	/* only allow legacy VF drivers to set the device and hardware MAC if it
+	 * is zero and allow new VF drivers to set the hardware MAC if the type
+	 * was correctly specified over VIRTCHNL
 	 */
 	if ((ice_is_vc_addr_legacy(vc_ether_addr) &&
 	     is_zero_ether_addr(vf->hw_lan_addr.addr)) ||
-	    ice_is_vc_addr_primary(vc_ether_addr))
+	    ice_is_vc_addr_primary(vc_ether_addr)) {
+		ether_addr_copy(vf->dev_lan_addr.addr, mac_addr);
 		ether_addr_copy(vf->hw_lan_addr.addr, mac_addr);
+	}
 
-	/* hardware MAC is already set, but its possible that the VF driver sent
-	 * the VIRTCHNL_OP_ADD_ETH_ADDR message before the
+	/* hardware and device MACs are already set, but its possible that the
+	 * VF driver sent the VIRTCHNL_OP_ADD_ETH_ADDR message before the
 	 * VIRTCHNL_OP_DEL_ETH_ADDR when trying to update its MAC, so save it
 	 * away for the legacy VF driver case as it will be updated in the
 	 * delete flow for this case
@@ -3745,8 +3749,8 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 	u8 *mac_addr = vc_ether_addr->addr;
 	enum ice_status status;
 
-	/* default unicast MAC already added */
-	if (ether_addr_equal(mac_addr, vf->hw_lan_addr.addr))
+	/* device MAC already added */
+	if (ether_addr_equal(mac_addr, vf->dev_lan_addr.addr))
 		return 0;
 
 	if (is_unicast_ether_addr(mac_addr) && !ice_can_vf_change_mac(vf)) {
@@ -3794,19 +3798,26 @@ ice_vfhw_mac_del(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
 	u8 *mac_addr = vc_ether_addr->addr;
 
 	if (!is_valid_ether_addr(mac_addr) ||
-	    !ether_addr_equal(vf->hw_lan_addr.addr, mac_addr))
+	    !ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
 		return;
 
-	/* allow the hardware MAC to be repopulated in the add flow */
-	eth_zero_addr(vf->hw_lan_addr.addr);
+	/* allow the device MAC to be repopulated in the add flow and don't
+	 * clear the hardware MAC (i.e. hw_lan_addr.addr) here as that is meant
+	 * to be persistent on VM reboot and across driver unload/load, which
+	 * won't work if we clear the hardware MAC here
+	 */
+	eth_zero_addr(vf->dev_lan_addr.addr);
 
 	/* only update cached hardware MAC for legacy VF drivers on delete
 	 * because we cannot guarantee order/type of MAC from the VF driver
 	 */
 	if (ice_is_vc_addr_legacy(vc_ether_addr) &&
-	    !ice_is_legacy_umac_expired(&vf->legacy_last_added_umac))
+	    !ice_is_legacy_umac_expired(&vf->legacy_last_added_umac)) {
+		ether_addr_copy(vf->dev_lan_addr.addr,
+				vf->legacy_last_added_umac.addr);
 		ether_addr_copy(vf->hw_lan_addr.addr,
 				vf->legacy_last_added_umac.addr);
+	}
 }
 
 /**
@@ -3824,7 +3835,7 @@ ice_vc_del_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 	enum ice_status status;
 
 	if (!ice_can_vf_change_mac(vf) &&
-	    ether_addr_equal(mac_addr, vf->hw_lan_addr.addr))
+	    ether_addr_equal(vf->dev_lan_addr.addr, mac_addr))
 		return 0;
 
 	status = ice_fltr_remove_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
@@ -4621,7 +4632,8 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 
 	vf = &pf->vf[vf_id];
 	/* nothing left to do, unicast MAC already set */
-	if (ether_addr_equal(vf->hw_lan_addr.addr, mac))
+	if (ether_addr_equal(vf->dev_lan_addr.addr, mac) &&
+	    ether_addr_equal(vf->hw_lan_addr.addr, mac))
 		return 0;
 
 	ret = ice_check_vf_ready_for_cfg(vf);
@@ -4637,6 +4649,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	/* VF is notified of its new MAC via the PF's response to the
 	 * VIRTCHNL_OP_GET_VF_RESOURCES message after the VF has been reset
 	 */
+	ether_addr_copy(vf->dev_lan_addr.addr, mac);
 	ether_addr_copy(vf->hw_lan_addr.addr, mac);
 	if (is_zero_ether_addr(mac)) {
 		/* VF will send VIRTCHNL_OP_ADD_ETH_ADDR message with its MAC */
@@ -4790,7 +4803,7 @@ void ice_print_vf_rx_mdd_event(struct ice_vf *vf)
 
 	dev_info(dev, "%d Rx Malicious Driver Detection events detected on PF %d VF %d MAC %pM. mdd-auto-reset-vfs=%s\n",
 		 vf->mdd_rx_events.count, pf->hw.pf_id, vf->vf_id,
-		 vf->hw_lan_addr.addr,
+		 vf->dev_lan_addr.addr,
 		 test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags)
 			  ? "on" : "off");
 }
@@ -4834,7 +4847,7 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf)
 
 			dev_info(dev, "%d Tx Malicious Driver Detection events detected on PF %d VF %d MAC %pM.\n",
 				 vf->mdd_tx_events.count, hw->pf_id, i,
-				 vf->hw_lan_addr.addr);
+				 vf->dev_lan_addr.addr);
 		}
 	}
 }
@@ -4924,7 +4937,7 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 
 			if (pf_vsi)
 				dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
-					 &vf->hw_lan_addr.addr[0],
+					 &vf->dev_lan_addr.addr[0],
 					 pf_vsi->netdev->dev_addr);
 		}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 91749c67129b..77ff0023f7be 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -83,6 +83,7 @@ struct ice_vf {
 	struct ice_sw *vf_sw_id;	/* switch ID the VF VSIs connect to */
 	struct virtchnl_version_info vf_ver;
 	u32 driver_caps;		/* reported by VF driver */
+	struct virtchnl_ether_addr dev_lan_addr;
 	struct virtchnl_ether_addr hw_lan_addr;
 	struct ice_time_mac legacy_last_added_umac;
 	DECLARE_BITMAP(txq_ena, ICE_MAX_RSS_QS_PER_VF);
-- 
2.26.2

