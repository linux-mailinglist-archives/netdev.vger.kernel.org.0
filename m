Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD0742603B
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241414AbhJGXKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:15518 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234184AbhJGXKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226340364"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="226340364"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344360"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Grzegorz Nitka <grzegorz.nitka@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 10/12] ice: rebuild switchdev when resetting all VFs
Date:   Thu,  7 Oct 2021 16:06:18 -0700
Message-Id: <20211007230620.3413290-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
References: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

As resetting all VFs behaves mostly like creating new VFs also
eswitch infrastructure has to be recreated. The easiest way to
do that is to rebuild eswitch after resetting VFs.

Implement helper functions to start and stop all representors
queues. This is used to disable traffic on port representors.

In rebuild path:
- NAPI has to be disabled
- eswitch environment has to be set up
- new port representors have to be created, because the old
one had pointer to not existing VFs
- new control plane VSI ring should be remapped
- NAPI hast to be enabled
- rxdid has to be set to FLEX_NIC_2, because this descriptor id
support source_vsi, which is needed on control plane VSI queues
- port representors queues have to be started

Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c  | 83 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_eswitch.h  | 10 +++
 drivers/net/ethernet/intel/ice/ice_main.c     | 11 ++-
 drivers/net/ethernet/intel/ice/ice_repr.c     | 20 +++++
 drivers/net/ethernet/intel/ice/ice_repr.h     |  3 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  4 +
 6 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index e558070d9ae5..0acbe29fa091 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -290,6 +290,18 @@ ice_eswitch_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
 	return ice_vsi_setup(pf, pi, ICE_VSI_SWITCHDEV_CTRL, ICE_INVAL_VFID);
 }
 
+/**
+ * ice_eswitch_napi_del - remove NAPI handle for all port representors
+ * @pf: pointer to PF structure
+ */
+static void ice_eswitch_napi_del(struct ice_pf *pf)
+{
+	int i;
+
+	ice_for_each_vf(pf, i)
+		netif_napi_del(&pf->vf[i].repr->q_vector->napi);
+}
+
 /**
  * ice_eswitch_napi_enable - enable NAPI for all port representors
  * @pf: pointer to PF structure
@@ -492,3 +504,74 @@ int ice_eswitch_configure(struct ice_pf *pf)
 	pf->switchdev.is_running = true;
 	return 0;
 }
+
+/**
+ * ice_eswitch_start_all_tx_queues - start Tx queues of all port representors
+ * @pf: pointer to PF structure
+ */
+static void ice_eswitch_start_all_tx_queues(struct ice_pf *pf)
+{
+	struct ice_repr *repr;
+	int i;
+
+	if (test_bit(ICE_DOWN, pf->state))
+		return;
+
+	ice_for_each_vf(pf, i) {
+		repr = pf->vf[i].repr;
+		if (repr)
+			ice_repr_start_tx_queues(repr);
+	}
+}
+
+/**
+ * ice_eswitch_stop_all_tx_queues - stop Tx queues of all port representors
+ * @pf: pointer to PF structure
+ */
+void ice_eswitch_stop_all_tx_queues(struct ice_pf *pf)
+{
+	struct ice_repr *repr;
+	int i;
+
+	if (test_bit(ICE_DOWN, pf->state))
+		return;
+
+	ice_for_each_vf(pf, i) {
+		repr = pf->vf[i].repr;
+		if (repr)
+			ice_repr_stop_tx_queues(repr);
+	}
+}
+
+/**
+ * ice_eswitch_rebuild - rebuild eswitch
+ * @pf: pointer to PF structure
+ */
+int ice_eswitch_rebuild(struct ice_pf *pf)
+{
+	struct ice_vsi *ctrl_vsi = pf->switchdev.control_vsi;
+	int status;
+
+	ice_eswitch_napi_disable(pf);
+	ice_eswitch_napi_del(pf);
+
+	status = ice_eswitch_setup_env(pf);
+	if (status)
+		return status;
+
+	status = ice_eswitch_setup_reprs(pf);
+	if (status)
+		return status;
+
+	ice_eswitch_remap_rings_to_vectors(pf);
+
+	status = ice_vsi_open(ctrl_vsi);
+	if (status)
+		return status;
+
+	ice_eswitch_napi_enable(pf);
+	ice_eswitch_set_rxdid(ctrl_vsi, ICE_RXDID_FLEX_NIC_2);
+	ice_eswitch_start_all_tx_queues(pf);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.h b/drivers/net/ethernet/intel/ice/ice_eswitch.h
index 7cf81708dd82..609774bf1c3e 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.h
@@ -9,6 +9,7 @@
 #ifdef CONFIG_ICE_SWITCHDEV
 void ice_eswitch_release(struct ice_pf *pf);
 int ice_eswitch_configure(struct ice_pf *pf);
+int ice_eswitch_rebuild(struct ice_pf *pf);
 
 int ice_eswitch_mode_get(struct devlink *devlink, u16 *mode);
 int
@@ -17,9 +18,13 @@ ice_eswitch_mode_set(struct devlink *devlink, u16 mode,
 bool ice_is_eswitch_mode_switchdev(struct ice_pf *pf);
 
 void ice_eswitch_update_repr(struct ice_vsi *vsi);
+
+void ice_eswitch_stop_all_tx_queues(struct ice_pf *pf);
 #else /* CONFIG_ICE_SWITCHDEV */
 static inline void ice_eswitch_release(struct ice_pf *pf) { }
 
+static inline void ice_eswitch_stop_all_tx_queues(struct ice_pf *pf) { }
+
 static inline void ice_eswitch_update_repr(struct ice_vsi *vsi) { }
 
 static inline int ice_eswitch_configure(struct ice_pf *pf)
@@ -27,6 +32,11 @@ static inline int ice_eswitch_configure(struct ice_pf *pf)
 	return -EOPNOTSUPP;
 }
 
+static inline int ice_eswitch_rebuild(struct ice_pf *pf)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int ice_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 {
 	return DEVLINK_ESWITCH_MODE_LEGACY;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4c112111e4d6..b3066cfca6b7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -19,6 +19,7 @@
  */
 #define CREATE_TRACE_POINTS
 #include "ice_trace.h"
+#include "ice_eswitch.h"
 
 #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800 Series Linux Driver"
 static const char ice_driver_string[] = DRV_SUMMARY;
@@ -5992,9 +5993,11 @@ int ice_down(struct ice_vsi *vsi)
 	/* Caller of this function is expected to set the
 	 * vsi->state ICE_DOWN bit
 	 */
-	if (vsi->netdev) {
+	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
 		netif_carrier_off(vsi->netdev);
 		netif_tx_disable(vsi->netdev);
+	} else if (vsi->type == ICE_VSI_SWITCHDEV_CTRL) {
+		ice_eswitch_stop_all_tx_queues(vsi->back);
 	}
 
 	ice_vsi_dis_irq(vsi);
@@ -6440,6 +6443,12 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 		goto err_vsi_rebuild;
 	}
 
+	err = ice_vsi_rebuild_by_type(pf, ICE_VSI_SWITCHDEV_CTRL);
+	if (err) {
+		dev_err(dev, "Switchdev CTRL VSI rebuild failed: %d\n", err);
+		goto err_vsi_rebuild;
+	}
+
 	/* If Flow Director is active */
 	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
 		err = ice_vsi_rebuild_by_type(pf, ICE_VSI_CTRL);
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index c88c5e65dc01..c558fb583e97 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -266,6 +266,26 @@ void ice_repr_rem_from_all_vfs(struct ice_pf *pf)
 	}
 }
 
+/**
+ * ice_repr_start_tx_queues - start Tx queues of port representor
+ * @repr: pointer to repr structure
+ */
+void ice_repr_start_tx_queues(struct ice_repr *repr)
+{
+	netif_carrier_on(repr->netdev);
+	netif_tx_start_all_queues(repr->netdev);
+}
+
+/**
+ * ice_repr_stop_tx_queues - stop Tx queues of port representor
+ * @repr: pointer to repr structure
+ */
+void ice_repr_stop_tx_queues(struct ice_repr *repr)
+{
+	netif_carrier_off(repr->netdev);
+	netif_tx_stop_all_queues(repr->netdev);
+}
+
 /**
  * ice_repr_set_traffic_vsi - set traffic VSI for port representor
  * @repr: repr on with VSI will be set
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.h b/drivers/net/ethernet/intel/ice/ice_repr.h
index f469fdba96b0..806de22933c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.h
+++ b/drivers/net/ethernet/intel/ice/ice_repr.h
@@ -18,6 +18,9 @@ struct ice_repr {
 int ice_repr_add_for_all_vfs(struct ice_pf *pf);
 void ice_repr_rem_from_all_vfs(struct ice_pf *pf);
 
+void ice_repr_start_tx_queues(struct ice_repr *repr);
+void ice_repr_stop_tx_queues(struct ice_repr *repr);
+
 void ice_repr_set_traffic_vsi(struct ice_repr *repr, struct ice_vsi *vsi);
 
 struct ice_repr *ice_netdev_to_repr(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 634ffeb23ee0..2f5c0215c9b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1587,6 +1587,10 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		ice_vf_post_vsi_rebuild(vf);
 	}
 
+	if (ice_is_eswitch_mode_switchdev(pf))
+		if (ice_eswitch_rebuild(pf))
+			dev_warn(dev, "eswitch rebuild failed\n");
+
 	ice_flush(hw);
 	clear_bit(ICE_VF_DIS, pf->state);
 
-- 
2.31.1

