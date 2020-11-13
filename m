Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91ED82B2704
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgKMVey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:34:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:21118 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgKMVen (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:43 -0500
IronPort-SDR: zfLKELChylRUwnqvarOJo4Ucny+4oeb1ZXGJjJkQD2VhAHbVY5UMLnkkrEZL0gVgeBZbwmPHhS
 mNOCIxrLg0Gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="170639936"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="170639936"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:34:40 -0800
IronPort-SDR: y1AV2+ZePGwnGuTOH18kSBqYYRWOfonHxX+1T/M4Jh60BovwK9RTlql6wKe7WgLpdNNYVXZHJl
 q0gLPwHp+WqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="366861619"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Nov 2020 13:34:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.neti, kuba@kernel.org
Cc:     Nick Nunley <nicholas.d.nunley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 11/15] ice: Remove vlan_ena from vsi structure
Date:   Fri, 13 Nov 2020 13:34:03 -0800
Message-Id: <20201113213407.2131340-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Nunley <nicholas.d.nunley@intel.com>

vlan_ena was introduced to track whether VLAN filters are enabled on
the device, but
1) checking for num_vlan > 1 already gives us this information, and is
currently used in this way throughout the code
2) the logic for vlan_ena is broken when multiple VLANs are active

Just remove vlan_ena and use num_vlan instead.

Signed-off-by: Nick Nunley <nicholas.d.nunley@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 -
 drivers/net/ethernet/intel/ice/ice_main.c | 11 ++++-------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index fa24826c5af7..f3aff465b483 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -308,7 +308,6 @@ struct ice_vsi {
 	u8 irqs_ready:1;
 	u8 current_isup:1;		 /* Sync 'link up' logging */
 	u8 stat_offsets_loaded:1;
-	u8 vlan_ena:1;
 	u16 num_vlan;
 
 	/* queue information */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 67bab35d590b..166d177bf91a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -224,7 +224,7 @@ static int ice_cfg_promisc(struct ice_vsi *vsi, u8 promisc_m, bool set_promisc)
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	if (vsi->vlan_ena) {
+	if (vsi->num_vlan > 1) {
 		status = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_m,
 						  set_promisc);
 	} else {
@@ -326,7 +326,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	/* check for changes in promiscuous modes */
 	if (changed_flags & IFF_ALLMULTI) {
 		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
-			if (vsi->vlan_ena)
+			if (vsi->num_vlan > 1)
 				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
 			else
 				promisc_m = ICE_MCAST_PROMISC_BITS;
@@ -340,7 +340,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 			}
 		} else {
 			/* !(vsi->current_netdev_flags & IFF_ALLMULTI) */
-			if (vsi->vlan_ena)
+			if (vsi->num_vlan > 1)
 				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
 			else
 				promisc_m = ICE_MCAST_PROMISC_BITS;
@@ -3116,10 +3116,8 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
 	 * packets aren't pruned by the device's internal switch on Rx
 	 */
 	ret = ice_vsi_add_vlan(vsi, vid, ICE_FWD_TO_VSI);
-	if (!ret) {
-		vsi->vlan_ena = true;
+	if (!ret)
 		set_bit(ICE_VSI_FLAG_VLAN_FLTR_CHANGED, vsi->flags);
-	}
 
 	return ret;
 }
@@ -3158,7 +3156,6 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
 	if (vsi->num_vlan == 1 && ice_vsi_is_vlan_pruning_ena(vsi))
 		ret = ice_cfg_vlan_pruning(vsi, false, false);
 
-	vsi->vlan_ena = false;
 	set_bit(ICE_VSI_FLAG_VLAN_FLTR_CHANGED, vsi->flags);
 	return ret;
 }
-- 
2.26.2

