Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988AA42950B
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 19:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhJKRBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:01:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:22642 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233260AbhJKRBo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 13:01:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="250312415"
X-IronPort-AV: E=Sophos;i="5.85,364,1624345200"; 
   d="scan'208";a="250312415"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 09:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="591405475"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 11 Oct 2021 09:59:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 9/9] ice: ndo_setup_tc implementation for PR
Date:   Mon, 11 Oct 2021 09:57:42 -0700
Message-Id: <20211011165742.1144861-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
References: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Add tc-flower support for VF port representor devices.

Implement ndo_setup_tc callback for TC HW offload on VF port representors
devices. Implemented both methods: add and delete tc-flower flows.

Mark NETIF_F_HW_TC bit in net device's feature set to enable offload TC
infrastructure for port representor.

Implement TC filters replay function required to restore filters settings
while switchdev configuration is rebuilt.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c |  3 ++
 drivers/net/ethernet/intel/ice/ice_repr.c    | 53 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.c  | 17 +++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.h  |  1 +
 4 files changed, 74 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 477e3f2d616d..d91a7834f91f 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -7,6 +7,7 @@
 #include "ice_fltr.h"
 #include "ice_repr.h"
 #include "ice_devlink.h"
+#include "ice_tc_lib.h"
 
 /**
  * ice_eswitch_setup_env - configure switchdev HW filters
@@ -645,6 +646,8 @@ int ice_eswitch_rebuild(struct ice_pf *pf)
 
 	ice_eswitch_remap_rings_to_vectors(pf);
 
+	ice_replay_tc_fltrs(pf);
+
 	status = ice_vsi_open(ctrl_vsi);
 	if (status)
 		return status;
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index cb83f58d7c71..c49eeea7cb67 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -5,6 +5,7 @@
 #include "ice_eswitch.h"
 #include "ice_devlink.h"
 #include "ice_virtchnl_pf.h"
+#include "ice_tc_lib.h"
 
 /**
  * ice_repr_get_sw_port_id - get port ID associated with representor
@@ -141,6 +142,55 @@ ice_repr_get_devlink_port(struct net_device *netdev)
 	return &repr->vf->devlink_port;
 }
 
+static int
+ice_repr_setup_tc_cls_flower(struct ice_repr *repr,
+			     struct flow_cls_offload *flower)
+{
+	switch (flower->command) {
+	case FLOW_CLS_REPLACE:
+		return ice_add_cls_flower(repr->netdev, repr->src_vsi, flower);
+	case FLOW_CLS_DESTROY:
+		return ice_del_cls_flower(repr->src_vsi, flower);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int
+ice_repr_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
+			   void *cb_priv)
+{
+	struct flow_cls_offload *flower = (struct flow_cls_offload *)type_data;
+	struct ice_netdev_priv *np = (struct ice_netdev_priv *)cb_priv;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return ice_repr_setup_tc_cls_flower(np->repr, flower);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static LIST_HEAD(ice_repr_block_cb_list);
+
+static int
+ice_repr_setup_tc(struct net_device *netdev, enum tc_setup_type type,
+		  void *type_data)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return flow_block_cb_setup_simple((struct flow_block_offload *)
+						  type_data,
+						  &ice_repr_block_cb_list,
+						  ice_repr_setup_tc_block_cb,
+						  np, np, true);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops ice_repr_netdev_ops = {
 	.ndo_get_phys_port_name = ice_repr_get_phys_port_name,
 	.ndo_get_stats64 = ice_repr_get_stats64,
@@ -148,6 +198,7 @@ static const struct net_device_ops ice_repr_netdev_ops = {
 	.ndo_stop = ice_repr_stop,
 	.ndo_start_xmit = ice_eswitch_port_start_xmit,
 	.ndo_get_devlink_port = ice_repr_get_devlink_port,
+	.ndo_setup_tc = ice_repr_setup_tc,
 };
 
 /**
@@ -170,6 +221,8 @@ ice_repr_reg_netdev(struct net_device *netdev)
 	netdev->netdev_ops = &ice_repr_netdev_ops;
 	ice_set_ethtool_repr_ops(netdev);
 
+	netdev->hw_features |= NETIF_F_HW_TC;
+
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index d2b6490efd6b..4c1daa1a02a1 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -836,3 +836,20 @@ ice_del_cls_flower(struct ice_vsi *vsi, struct flow_cls_offload *cls_flower)
 
 	return 0;
 }
+
+/**
+ * ice_replay_tc_fltrs - replay TC filters
+ * @pf: pointer to PF struct
+ */
+void ice_replay_tc_fltrs(struct ice_pf *pf)
+{
+	struct ice_tc_flower_fltr *fltr;
+	struct hlist_node *node;
+
+	hlist_for_each_entry_safe(fltr, node,
+				  &pf->tc_flower_fltr_list,
+				  tc_flower_node) {
+		fltr->extack = NULL;
+		ice_add_switch_fltr(fltr->src_vsi, fltr);
+	}
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index 883d2891f92c..d90e9e37ae25 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -125,5 +125,6 @@ ice_add_cls_flower(struct net_device *netdev, struct ice_vsi *vsi,
 		   struct flow_cls_offload *cls_flower);
 int
 ice_del_cls_flower(struct ice_vsi *vsi, struct flow_cls_offload *cls_flower);
+void ice_replay_tc_fltrs(struct ice_pf *pf);
 
 #endif /* _ICE_TC_LIB_H_ */
-- 
2.31.1

