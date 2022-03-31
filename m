Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4EB4EDE9D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbiCaQVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239801AbiCaQVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:21:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26B81F1279
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648743585; x=1680279585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GujeS4tBu6uAdvGB1xBpE6Cc5wtp2ZZRM/WiaQF/LX4=;
  b=jNGiR9W+AO1GMT7yPu/l+9Yfw1rjfhs5MmU7QiSs/AzlHsQd/yfkCN3B
   W2OCjONtrjwvzr5AOu0qiJsCGI6hbKgvMfUHYQdJjUKwpbFRtrIdrb9AC
   yId1ec3n0kPG/0wlCsFAT0I8UWI5lPVy8FEqTpzwYqFUyepcZriIICdw6
   t24+MazDz5xzjrZqUcEGDYfZ/k9i4HzcodKPTwn3hrxEK3E/KCN2RdcME
   nhLR3ultcLbj3SpPhmOwuFGfNyby3je4cTHs7kbaTOXlJHw4sRkxS3Hqz
   TkgtaXtmkAS829tZl3m54fc+bejla4OT01CV37upCdBgFPa05OJJHhR6H
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="260067494"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="260067494"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 09:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="522407024"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 31 Mar 2022 09:19:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     alice.michael@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net 3/3] ice: Fix broken IFF_ALLMULTI handling
Date:   Thu, 31 Mar 2022 09:20:08 -0700
Message-Id: <20220331162008.1891935-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
References: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

Handling of all-multicast flag and associated multicast promiscuous
mode is broken in ice driver. When an user switches allmulticast
flag on or off the driver checks whether any VLANs are configured
over the interface (except default VLAN 0).

If any extra VLANs are registered it enables multicast promiscuous
mode for all these VLANs (including default VLAN 0) using
ICE_SW_LKUP_PROMISC_VLAN look-up type. In this situation all
multicast packets tagged with known VLAN ID or untagged are received
and multicast packets tagged with unknown VLAN ID ignored.

If no extra VLANs are registered (so only VLAN 0 exists) it enables
multicast promiscuous mode for VLAN 0 and uses ICE_SW_LKUP_PROMISC
look-up type. In this situation any multicast packets including
tagged ones are received.

The driver handles IFF_ALLMULTI in ice_vsi_sync_fltr() this way:

ice_vsi_sync_fltr() {
  ...
  if (changed_flags & IFF_ALLMULTI) {
    if (netdev->flags & IFF_ALLMULTI) {
      if (vsi->num_vlans > 1)
        ice_set_promisc(..., ICE_MCAST_VLAN_PROMISC_BITS);
      else
        ice_set_promisc(..., ICE_MCAST_PROMISC_BITS);
    } else {
      if (vsi->num_vlans > 1)
        ice_clear_promisc(..., ICE_MCAST_VLAN_PROMISC_BITS);
      else
        ice_clear_promisc(..., ICE_MCAST_PROMISC_BITS);
    }
  }
  ...
}

The code above depends on value vsi->num_vlan that specifies number
of VLANs configured over the interface (including VLAN 0) and
this is problem because that value is modified in NDO callbacks
ice_vlan_rx_add_vid() and ice_vlan_rx_kill_vid().

Scenario 1:
1. ip link set ens7f0 allmulticast on
2. ip link add vlan10 link ens7f0 type vlan id 10
3. ip link set ens7f0 allmulticast off
4. ip link set ens7f0 allmulticast on

[1] In this scenario IFF_ALLMULTI is enabled and the driver calls
    ice_set_promisc(..., ICE_MCAST_PROMISC_BITS) that installs
    multicast promisc rule with non-VLAN look-up type.
[2] Then VLAN with ID 10 is added and vsi->num_vlan incremented to 2
[3] Command switches IFF_ALLMULTI off and the driver calls
    ice_clear_promisc(..., ICE_MCAST_VLAN_PROMISC_BITS) but this
    call is effectively NOP because it looks for multicast promisc
    rules for VLAN 0 and VLAN 10 with VLAN look-up type but no such
    rules exist. So the all-multicast remains enabled silently
    in hardware.
[4] Command tries to switch IFF_ALLMULTI on and the driver calls
    ice_clear_promisc(..., ICE_MCAST_PROMISC_BITS) but this call
    fails (-EEXIST) because non-VLAN multicast promisc rule already
    exists.

Scenario 2:
1. ip link add vlan10 link ens7f0 type vlan id 10
2. ip link set ens7f0 allmulticast on
3. ip link add vlan20 link ens7f0 type vlan id 20
4. ip link del vlan10 ; ip link del vlan20
5. ip link set ens7f0 allmulticast off

[1] VLAN with ID 10 is added and vsi->num_vlan==2
[2] Command switches IFF_ALLMULTI on and driver installs multicast
    promisc rules with VLAN look-up type for VLAN 0 and 10
[3] VLAN with ID 20 is added and vsi->num_vlan==3 but no multicast
    promisc rules is added for this new VLAN so the interface does
    not receive MC packets from VLAN 20
[4] Both VLANs are removed but multicast rule for VLAN 10 remains
    installed so interface receives multicast packets from VLAN 10
[5] Command switches IFF_ALLMULTI off and because vsi->num_vlan is 1
    the driver tries to remove multicast promisc rule for VLAN 0
    with non-VLAN look-up that does not exist.
    All-multicast looks disabled from user point of view but it
    is partially enabled in HW (interface receives all multicast
    packets either untagged or tagged with VLAN ID 10)

To resolve these issues the patch introduces these changes:
1. Adds handling for IFF_ALLMULTI to ice_vlan_rx_add_vid() and
   ice_vlan_rx_kill_vid() callbacks. So when VLAN is added/removed
   and IFF_ALLMULTI is enabled an appropriate multicast promisc
   rule for that VLAN ID is added/removed.
2. In ice_vlan_rx_add_vid() when first VLAN besides VLAN 0 is added
   so (vsi->num_vlan == 2) and IFF_ALLMULTI is enabled then look-up
   type for existing multicast promisc rule for VLAN 0 is updated
   to ICE_MCAST_VLAN_PROMISC_BITS.
3. In ice_vlan_rx_kill_vid() when last VLAN besides VLAN 0 is removed
   so (vsi->num_vlan == 1) and IFF_ALLMULTI is enabled then look-up
   type for existing multicast promisc rule for VLAN 0 is updated
   to ICE_MCAST_PROMISC_BITS.
4. Both ice_vlan_rx_{add,kill}_vid() have to run under ICE_CFG_BUSY
   bit protection to avoid races with ice_vsi_sync_fltr() that runs
   in ice_service_task() context.
5. Bit ICE_VSI_VLAN_FLTR_CHANGED is use-less and can be removed.
6. Error messages added to ice_fltr_*_vsi_promisc() helper functions
   to avoid them in their callers
7. Small improvements to increase readability

Fixes: 5eda8afd6bcc ("ice: Add support for PF/VF promiscuous mode")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |   1 -
 drivers/net/ethernet/intel/ice/ice_fltr.c |  44 ++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c | 114 +++++++++++++++-------
 3 files changed, 121 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 1084c5d202c0..8b5b4b11b339 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -301,7 +301,6 @@ enum ice_vsi_state {
 	ICE_VSI_NETDEV_REGISTERED,
 	ICE_VSI_UMAC_FLTR_CHANGED,
 	ICE_VSI_MMAC_FLTR_CHANGED,
-	ICE_VSI_VLAN_FLTR_CHANGED,
 	ICE_VSI_PROMISC_CHANGED,
 	ICE_VSI_STATE_NBITS		/* must be last */
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index af57eb114966..85a94483c2ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -58,7 +58,16 @@ int
 ice_fltr_set_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
 			      u8 promisc_mask)
 {
-	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, false);
+	struct ice_pf *pf = hw->back;
+	int result;
+
+	result = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, false);
+	if (result)
+		dev_err(ice_pf_to_dev(pf),
+			"Error setting promisc mode on VSI %i (rc=%d)\n",
+			vsi->vsi_num, result);
+
+	return result;
 }
 
 /**
@@ -73,7 +82,16 @@ int
 ice_fltr_clear_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
 				u8 promisc_mask)
 {
-	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, true);
+	struct ice_pf *pf = hw->back;
+	int result;
+
+	result = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, true);
+	if (result)
+		dev_err(ice_pf_to_dev(pf),
+			"Error clearing promisc mode on VSI %i (rc=%d)\n",
+			vsi->vsi_num, result);
+
+	return result;
 }
 
 /**
@@ -87,7 +105,16 @@ int
 ice_fltr_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 			   u16 vid)
 {
-	return ice_clear_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+	struct ice_pf *pf = hw->back;
+	int result;
+
+	result = ice_clear_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+	if (result)
+		dev_err(ice_pf_to_dev(pf),
+			"Error clearing promisc mode on VSI %i for VID %u (rc=%d)\n",
+			ice_get_hw_vsi_num(hw, vsi_handle), vid, result);
+
+	return result;
 }
 
 /**
@@ -101,7 +128,16 @@ int
 ice_fltr_set_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 			 u16 vid)
 {
-	return ice_set_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+	struct ice_pf *pf = hw->back;
+	int result;
+
+	result = ice_set_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+	if (result)
+		dev_err(ice_pf_to_dev(pf),
+			"Error setting promisc mode on VSI %i for VID %u (rc=%d)\n",
+			ice_get_hw_vsi_num(hw, vsi_handle), vid, result);
+
+	return result;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1f944b3bd795..d768925785ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -243,8 +243,7 @@ static int ice_add_mac_to_unsync_list(struct net_device *netdev, const u8 *addr)
 static bool ice_vsi_fltr_changed(struct ice_vsi *vsi)
 {
 	return test_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state) ||
-	       test_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state) ||
-	       test_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
+	       test_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
 }
 
 /**
@@ -260,10 +259,15 @@ static int ice_set_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	if (ice_vsi_has_non_zero_vlans(vsi))
-		status = ice_fltr_set_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
-	else
-		status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
+	if (ice_vsi_has_non_zero_vlans(vsi)) {
+		promisc_m |= (ICE_PROMISC_VLAN_RX | ICE_PROMISC_VLAN_TX);
+		status = ice_fltr_set_vlan_vsi_promisc(&vsi->back->hw, vsi,
+						       promisc_m);
+	} else {
+		status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
+						  promisc_m, 0);
+	}
+
 	return status;
 }
 
@@ -280,10 +284,15 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	if (ice_vsi_has_non_zero_vlans(vsi))
-		status = ice_fltr_clear_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
-	else
-		status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
+	if (ice_vsi_has_non_zero_vlans(vsi)) {
+		promisc_m |= (ICE_PROMISC_VLAN_RX | ICE_PROMISC_VLAN_TX);
+		status = ice_fltr_clear_vlan_vsi_promisc(&vsi->back->hw, vsi,
+							 promisc_m);
+	} else {
+		status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+						    promisc_m, 0);
+	}
+
 	return status;
 }
 
@@ -302,7 +311,6 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	u32 changed_flags = 0;
-	u8 promisc_m;
 	int err;
 
 	if (!vsi->netdev)
@@ -320,7 +328,6 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	if (ice_vsi_fltr_changed(vsi)) {
 		clear_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state);
 		clear_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
-		clear_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 
 		/* grab the netdev's addr_list_lock */
 		netif_addr_lock_bh(netdev);
@@ -369,29 +376,15 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	/* check for changes in promiscuous modes */
 	if (changed_flags & IFF_ALLMULTI) {
 		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
-			if (ice_vsi_has_non_zero_vlans(vsi))
-				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_MCAST_PROMISC_BITS;
-
-			err = ice_set_promisc(vsi, promisc_m);
+			err = ice_set_promisc(vsi, ICE_MCAST_PROMISC_BITS);
 			if (err) {
-				netdev_err(netdev, "Error setting Multicast promiscuous mode on VSI %i\n",
-					   vsi->vsi_num);
 				vsi->current_netdev_flags &= ~IFF_ALLMULTI;
 				goto out_promisc;
 			}
 		} else {
 			/* !(vsi->current_netdev_flags & IFF_ALLMULTI) */
-			if (ice_vsi_has_non_zero_vlans(vsi))
-				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_MCAST_PROMISC_BITS;
-
-			err = ice_clear_promisc(vsi, promisc_m);
+			err = ice_clear_promisc(vsi, ICE_MCAST_PROMISC_BITS);
 			if (err) {
-				netdev_err(netdev, "Error clearing Multicast promiscuous mode on VSI %i\n",
-					   vsi->vsi_num);
 				vsi->current_netdev_flags |= IFF_ALLMULTI;
 				goto out_promisc;
 			}
@@ -3490,6 +3483,20 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	if (!vid)
 		return 0;
 
+	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
+		usleep_range(1000, 2000);
+
+	/* Add multicast promisc rule for the VLAN ID to be added if
+	 * all-multicast is currently enabled.
+	 */
+	if (vsi->current_netdev_flags & IFF_ALLMULTI) {
+		ret = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
+					       ICE_MCAST_VLAN_PROMISC_BITS,
+					       vid);
+		if (ret)
+			goto finish;
+	}
+
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
 	/* Add a switch rule for this VLAN ID so its corresponding VLAN tagged
@@ -3497,8 +3504,23 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	 */
 	vlan = ICE_VLAN(be16_to_cpu(proto), vid, 0);
 	ret = vlan_ops->add_vlan(vsi, &vlan);
-	if (!ret)
-		set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
+	if (ret)
+		goto finish;
+
+	/* If all-multicast is currently enabled and this VLAN ID is only one
+	 * besides VLAN-0 we have to update look-up type of multicast promisc
+	 * rule for VLAN-0 from ICE_SW_LKUP_PROMISC to ICE_SW_LKUP_PROMISC_VLAN.
+	 */
+	if ((vsi->current_netdev_flags & IFF_ALLMULTI) &&
+	    ice_vsi_num_non_zero_vlans(vsi) == 1) {
+		ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+					   ICE_MCAST_PROMISC_BITS, 0);
+		ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
+					 ICE_MCAST_VLAN_PROMISC_BITS, 0);
+	}
+
+finish:
+	clear_bit(ICE_CFG_BUSY, vsi->state);
 
 	return ret;
 }
@@ -3524,6 +3546,9 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	if (!vid)
 		return 0;
 
+	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
+		usleep_range(1000, 2000);
+
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
 	/* Make sure VLAN delete is successful before updating VLAN
@@ -3532,10 +3557,33 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	vlan = ICE_VLAN(be16_to_cpu(proto), vid, 0);
 	ret = vlan_ops->del_vlan(vsi, &vlan);
 	if (ret)
-		return ret;
+		goto finish;
 
-	set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
-	return 0;
+	/* Remove multicast promisc rule for the removed VLAN ID if
+	 * all-multicast is enabled.
+	 */
+	if (vsi->current_netdev_flags & IFF_ALLMULTI)
+		ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+					   ICE_MCAST_VLAN_PROMISC_BITS, vid);
+
+	if (!ice_vsi_has_non_zero_vlans(vsi)) {
+		/* Update look-up type of multicast promisc rule for VLAN 0
+		 * from ICE_SW_LKUP_PROMISC_VLAN to ICE_SW_LKUP_PROMISC when
+		 * all-multicast is enabled and VLAN 0 is the only VLAN rule.
+		 */
+		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
+			ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+						   ICE_MCAST_VLAN_PROMISC_BITS,
+						   0);
+			ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
+						 ICE_MCAST_PROMISC_BITS, 0);
+		}
+	}
+
+finish:
+	clear_bit(ICE_CFG_BUSY, vsi->state);
+
+	return ret;
 }
 
 /**
-- 
2.31.1

