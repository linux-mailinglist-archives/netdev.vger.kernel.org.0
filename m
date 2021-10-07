Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66FD42603C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240940AbhJGXKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:15526 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234360AbhJGXKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226340362"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="226340362"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344352"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Grzegorz Nitka <grzegorz.nitka@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 09/12] ice: enable/disable switchdev when managing VFs
Date:   Thu,  7 Oct 2021 16:06:17 -0700
Message-Id: <20211007230620.3413290-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
References: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

Only way to enable switchdev is to create VFs when the eswitch
mode is set to switchdev. Check if correct mode is set and
enable switchdev in function which creating VFs.

Disable switchdev when user change number of VFs to 0. Changing
eswitch mode back to legacy when VFs are created in switchdev
mode isn't allowed.

As switchdev takes care of managing filter rules, adding new
rules on VF is blocked.

In case of resetting VF driver has to update pointer in ice_repr
struct, because after reset VSI related things can change.

Co-developed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c  | 38 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_eswitch.h  |  4 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |  6 ++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 17 +++++++++
 4 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 8d8f80f45788..e558070d9ae5 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -232,6 +232,32 @@ ice_eswitch_release_reprs(struct ice_pf *pf, struct ice_vsi *ctrl_vsi)
 	}
 }
 
+/**
+ * ice_eswitch_update_repr - reconfigure VF port representor
+ * @vsi: VF VSI for which port representor is configured
+ */
+void ice_eswitch_update_repr(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_repr *repr;
+	struct ice_vf *vf;
+	int ret;
+
+	if (!ice_is_switchdev_running(pf))
+		return;
+
+	vf = &pf->vf[vsi->vf_id];
+	repr = vf->repr;
+	repr->src_vsi = vsi;
+	repr->dst->u.port_info.port_id = vsi->vsi_num;
+
+	ret = ice_vsi_update_security(vsi, ice_vsi_ctx_clear_antispoof);
+	if (ret) {
+		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr.addr, ICE_FWD_TO_VSI);
+		dev_err(ice_pf_to_dev(pf), "Failed to update VF %d port representor", vsi->vf_id);
+	}
+}
+
 /**
  * ice_eswitch_release_env - clear switchdev HW filters
  * @pf: pointer to PF struct
@@ -423,6 +449,18 @@ int ice_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	return 0;
 }
 
+/**
+ * ice_is_eswitch_mode_switchdev - check if eswitch mode is set to switchdev
+ * @pf: pointer to PF structure
+ *
+ * Returns true if eswitch mode is set to DEVLINK_ESWITCH_MODE_SWITCHDEV,
+ * false otherwise.
+ */
+bool ice_is_eswitch_mode_switchdev(struct ice_pf *pf)
+{
+	return pf->eswitch_mode == DEVLINK_ESWITCH_MODE_SWITCHDEV;
+}
+
 /**
  * ice_eswitch_release - cleanup eswitch
  * @pf: pointer to PF structure
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.h b/drivers/net/ethernet/intel/ice/ice_eswitch.h
index 2bf10f5b7025..7cf81708dd82 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.h
@@ -15,9 +15,13 @@ int
 ice_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		     struct netlink_ext_ack *extack);
 bool ice_is_eswitch_mode_switchdev(struct ice_pf *pf);
+
+void ice_eswitch_update_repr(struct ice_vsi *vsi);
 #else /* CONFIG_ICE_SWITCHDEV */
 static inline void ice_eswitch_release(struct ice_pf *pf) { }
 
+static inline void ice_eswitch_update_repr(struct ice_vsi *vsi) { }
+
 static inline int ice_eswitch_configure(struct ice_pf *pf)
 {
 	return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 819d4912d84e..4c112111e4d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6061,7 +6061,8 @@ int ice_vsi_setup_tx_rings(struct ice_vsi *vsi)
 		if (!ring)
 			return -EINVAL;
 
-		ring->netdev = vsi->netdev;
+		if (vsi->netdev)
+			ring->netdev = vsi->netdev;
 		err = ice_setup_tx_ring(ring);
 		if (err)
 			break;
@@ -6092,7 +6093,8 @@ int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
 		if (!ring)
 			return -EINVAL;
 
-		ring->netdev = vsi->netdev;
+		if (vsi->netdev)
+			ring->netdev = vsi->netdev;
 		err = ice_setup_rx_ring(ring);
 		if (err)
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 0b80b5a52e8a..634ffeb23ee0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -6,6 +6,7 @@
 #include "ice_lib.h"
 #include "ice_fltr.h"
 #include "ice_flow.h"
+#include "ice_eswitch.h"
 #include "ice_virtchnl_allowlist.h"
 
 #define FIELD_SELECTOR(proto_hdr_field) \
@@ -620,6 +621,8 @@ void ice_free_vfs(struct ice_pf *pf)
 	if (!pf->vf)
 		return;
 
+	ice_eswitch_release(pf);
+
 	while (test_and_set_bit(ICE_VF_DIS, pf->state))
 		usleep_range(1000, 2000);
 
@@ -932,6 +935,9 @@ static int ice_vf_rebuild_host_mac_cfg(struct ice_vf *vf)
 	enum ice_status status;
 	u8 broadcast[ETH_ALEN];
 
+	if (ice_is_eswitch_mode_switchdev(vf->pf))
+		return 0;
+
 	eth_broadcast_addr(broadcast);
 	status = ice_fltr_add_mac(vsi, broadcast, ICE_FWD_TO_VSI);
 	if (status) {
@@ -1711,6 +1717,8 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	}
 
 	ice_vf_post_vsi_rebuild(vf);
+	vsi = ice_get_vf_vsi(vf);
+	ice_eswitch_update_repr(vsi);
 
 	/* if the VF has been reset allow it to come up again */
 	if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->malvfs, ICE_MAX_VF_COUNT, vf->vf_id))
@@ -1962,6 +1970,10 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 	}
 
 	clear_bit(ICE_VF_DIS, pf->state);
+
+	if (ice_eswitch_configure(pf))
+		goto err_unroll_sriov;
+
 	return 0;
 
 err_unroll_sriov:
@@ -4783,6 +4795,11 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	struct ice_vf *vf;
 	int ret;
 
+	if (ice_is_eswitch_mode_switchdev(pf)) {
+		dev_info(ice_pf_to_dev(pf), "Trusted VF is forbidden in switchdev mode\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
 
-- 
2.31.1

