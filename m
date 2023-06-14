Return-Path: <netdev+bounces-10339-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D6F72DEFF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BD6B1C20C50
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A5638CD8;
	Tue, 13 Jun 2023 10:14:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508292A9E9
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:14:50 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BD9188
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686651287; x=1718187287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1sdP0r/cXPD+RwKAHyErmFnp9vVx/tw48B7qD8VX7ZE=;
  b=V0B5UKFxeT41VK0X79UGdX5gSiiSJ6x+D4I/N5SDctz8MNwzF2HP9mv5
   RPnKjiYqXSe4kmTiv7QLyb9nc75qnr9Kulu/baDGzCd+nWkpyGJ5ZJWZ2
   bVeoQNP1rdKt22gu2QJdl470lpmiX643qn18gRUwWLA/STEvWC4QtkH7I
   uXVry+KeHs0VCTs0sHFU9WGs+CrNQWkU2FZYDasjko3ppHPcMoMIPr38N
   V69UExtl0PR+mxtqw9PEfqk+sBZxx7tlom16KyU18JT/hJaXJJ4Ly5DUV
   NqtxLceyG/nQR5KlHumKt7r3QytTumqQQ84aE9BJshsAOaVedm8bDqjrM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="424168086"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="424168086"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 03:14:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="885787135"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="885787135"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2023 03:14:42 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 7E49235832;
	Tue, 13 Jun 2023 11:14:41 +0100 (IST)
From: Wojciech Drewek <wojciech.drewek@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	alexandr.lobakin@intel.com,
	david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com,
	marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com,
	sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de,
	simon.horman@corigine.com,
	dan.carpenter@linaro.org
Subject: [PATCH iwl-next v5 06/12] ice: Implement basic eswitch bridge setup
Date: Tue, 13 Jun 2023 12:13:24 +0200
Message-Id: <20230613101330.87734-7-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613101330.87734-1-wojciech.drewek@intel.com>
References: <20230613101330.87734-1-wojciech.drewek@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

With this patch, ice driver is able to track if the port
representors or uplink port were added to the linux bridge in
switchdev mode. Listen for NETDEV_CHANGEUPPER events in order to
detect this. ice_esw_br data structure reflects the linux bridge
and stores all the ports of the bridge (ice_esw_br_port) in
xarray, it's created when the first port is added to the bridge and
freed once the last port is removed. Note that only one bridge is
supported per eswitch.

Bridge port (ice_esw_br_port) can be either a VF port representor
port or uplink port (ice_esw_br_port_type). In both cases bridge port
holds a reference to the VSI, VF's VSI in case of the PR and uplink
VSI in case of the uplink. VSI's index is used as an index to the
xarray in which ports are stored.

Add a check which prevents configuring switchdev mode if uplink is
already added to any bridge. This is needed because we need to listen
for NETDEV_CHANGEUPPER events to record if the uplink was added to
the bridge. Netdevice notifier is registered after eswitch mode
is changed to switchdev.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v2: fix structure holes, wrapping improvements
v4: fix potential Null pointer dereference in
    ice_eswitch_br_port_unlink
v5: update ice_esw_br_port::vsi on VF reset
---
 drivers/net/ethernet/intel/ice/Makefile       |   2 +-
 drivers/net/ethernet/intel/ice/ice.h          |   4 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |  26 +-
 .../net/ethernet/intel/ice/ice_eswitch_br.c   | 384 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_eswitch_br.h   |  42 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_repr.h     |   3 +-
 8 files changed, 456 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch_br.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch_br.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 817977e3039d..960277d78e09 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -47,5 +47,5 @@ ice-$(CONFIG_PTP_1588_CLOCK) += ice_ptp.o ice_ptp_hw.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
-ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o
+ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o ice_eswitch_br.o
 ice-$(CONFIG_GNSS) += ice_gnss.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b4bca1d964a9..8876ed8ba268 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -511,6 +511,7 @@ enum ice_pf_flags {
 struct ice_switchdev_info {
 	struct ice_vsi *control_vsi;
 	struct ice_vsi *uplink_vsi;
+	struct ice_esw_br_offloads *br_offloads;
 	bool is_running;
 };
 
@@ -619,6 +620,7 @@ struct ice_pf {
 	struct ice_lag *lag; /* Link Aggregation information */
 
 	struct ice_switchdev_info switchdev;
+	struct ice_esw_br_port *br_port;
 
 #define ICE_INVALID_AGG_NODE_ID		0
 #define ICE_PF_AGG_NODE_ID_START	1
@@ -846,7 +848,7 @@ static inline bool ice_is_adq_active(struct ice_pf *pf)
 	return false;
 }
 
-bool netif_is_ice(struct net_device *dev);
+bool netif_is_ice(const struct net_device *dev);
 int ice_vsi_setup_tx_rings(struct ice_vsi *vsi);
 int ice_vsi_setup_rx_rings(struct ice_vsi *vsi);
 int ice_vsi_open_ctrl(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 4fe235da1182..9a53a5e5d73e 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -4,6 +4,7 @@
 #include "ice.h"
 #include "ice_lib.h"
 #include "ice_eswitch.h"
+#include "ice_eswitch_br.h"
 #include "ice_fltr.h"
 #include "ice_repr.h"
 #include "ice_devlink.h"
@@ -317,6 +318,9 @@ void ice_eswitch_update_repr(struct ice_vsi *vsi)
 	repr->src_vsi = vsi;
 	repr->dst->u.port_info.port_id = vsi->vsi_num;
 
+	if (repr->br_port)
+		repr->br_port->vsi = vsi;
+
 	ret = ice_vsi_update_security(vsi, ice_vsi_ctx_clear_antispoof);
 	if (ret) {
 		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr, ICE_FWD_TO_VSI);
@@ -474,16 +478,24 @@ static void ice_eswitch_napi_disable(struct ice_pf *pf)
  */
 static int ice_eswitch_enable_switchdev(struct ice_pf *pf)
 {
-	struct ice_vsi *ctrl_vsi;
+	struct ice_vsi *ctrl_vsi, *uplink_vsi;
+
+	uplink_vsi = ice_get_main_vsi(pf);
+	if (!uplink_vsi)
+		return -ENODEV;
+
+	if (netif_is_any_bridge_port(uplink_vsi->netdev)) {
+		dev_err(ice_pf_to_dev(pf),
+			"Uplink port cannot be a bridge port\n");
+		return -EINVAL;
+	}
 
 	pf->switchdev.control_vsi = ice_eswitch_vsi_setup(pf, pf->hw.port_info);
 	if (!pf->switchdev.control_vsi)
 		return -ENODEV;
 
 	ctrl_vsi = pf->switchdev.control_vsi;
-	pf->switchdev.uplink_vsi = ice_get_main_vsi(pf);
-	if (!pf->switchdev.uplink_vsi)
-		goto err_vsi;
+	pf->switchdev.uplink_vsi = uplink_vsi;
 
 	if (ice_eswitch_setup_env(pf))
 		goto err_vsi;
@@ -499,10 +511,15 @@ static int ice_eswitch_enable_switchdev(struct ice_pf *pf)
 	if (ice_vsi_open(ctrl_vsi))
 		goto err_setup_reprs;
 
+	if (ice_eswitch_br_offloads_init(pf))
+		goto err_br_offloads;
+
 	ice_eswitch_napi_enable(pf);
 
 	return 0;
 
+err_br_offloads:
+	ice_vsi_close(ctrl_vsi);
 err_setup_reprs:
 	ice_repr_rem_from_all_vfs(pf);
 err_repr_add:
@@ -521,6 +538,7 @@ static void ice_eswitch_disable_switchdev(struct ice_pf *pf)
 	struct ice_vsi *ctrl_vsi = pf->switchdev.control_vsi;
 
 	ice_eswitch_napi_disable(pf);
+	ice_eswitch_br_offloads_deinit(pf);
 	ice_eswitch_release_env(pf);
 	ice_eswitch_release_reprs(pf, ctrl_vsi);
 	ice_vsi_release(ctrl_vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
new file mode 100644
index 000000000000..8b9ab68dfd53
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
@@ -0,0 +1,384 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2023, Intel Corporation. */
+
+#include "ice.h"
+#include "ice_eswitch_br.h"
+#include "ice_repr.h"
+
+static bool ice_eswitch_br_is_dev_valid(const struct net_device *dev)
+{
+	/* Accept only PF netdev and PRs */
+	return ice_is_port_repr_netdev(dev) || netif_is_ice(dev);
+}
+
+static struct ice_esw_br_port *
+ice_eswitch_br_netdev_to_port(struct net_device *dev)
+{
+	if (ice_is_port_repr_netdev(dev)) {
+		struct ice_repr *repr = ice_netdev_to_repr(dev);
+
+		return repr->br_port;
+	} else if (netif_is_ice(dev)) {
+		struct ice_pf *pf = ice_netdev_to_pf(dev);
+
+		return pf->br_port;
+	}
+
+	return NULL;
+}
+
+static void
+ice_eswitch_br_port_deinit(struct ice_esw_br *bridge,
+			   struct ice_esw_br_port *br_port)
+{
+	struct ice_vsi *vsi = br_port->vsi;
+
+	if (br_port->type == ICE_ESWITCH_BR_UPLINK_PORT && vsi->back)
+		vsi->back->br_port = NULL;
+	else if (vsi->vf)
+		vsi->vf->repr->br_port = NULL;
+
+	xa_erase(&bridge->ports, br_port->vsi_idx);
+	kfree(br_port);
+}
+
+static struct ice_esw_br_port *
+ice_eswitch_br_port_init(struct ice_esw_br *bridge)
+{
+	struct ice_esw_br_port *br_port;
+
+	br_port = kzalloc(sizeof(*br_port), GFP_KERNEL);
+	if (!br_port)
+		return ERR_PTR(-ENOMEM);
+
+	br_port->bridge = bridge;
+
+	return br_port;
+}
+
+static int
+ice_eswitch_br_vf_repr_port_init(struct ice_esw_br *bridge,
+				 struct ice_repr *repr)
+{
+	struct ice_esw_br_port *br_port;
+	int err;
+
+	br_port = ice_eswitch_br_port_init(bridge);
+	if (IS_ERR(br_port))
+		return PTR_ERR(br_port);
+
+	br_port->vsi = repr->src_vsi;
+	br_port->vsi_idx = br_port->vsi->idx;
+	br_port->type = ICE_ESWITCH_BR_VF_REPR_PORT;
+	repr->br_port = br_port;
+
+	err = xa_insert(&bridge->ports, br_port->vsi_idx, br_port, GFP_KERNEL);
+	if (err) {
+		ice_eswitch_br_port_deinit(bridge, br_port);
+		return err;
+	}
+
+	return 0;
+}
+
+static int
+ice_eswitch_br_uplink_port_init(struct ice_esw_br *bridge, struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = pf->switchdev.uplink_vsi;
+	struct ice_esw_br_port *br_port;
+	int err;
+
+	br_port = ice_eswitch_br_port_init(bridge);
+	if (IS_ERR(br_port))
+		return PTR_ERR(br_port);
+
+	br_port->vsi = vsi;
+	br_port->vsi_idx = br_port->vsi->idx;
+	br_port->type = ICE_ESWITCH_BR_UPLINK_PORT;
+	pf->br_port = br_port;
+
+	err = xa_insert(&bridge->ports, br_port->vsi_idx, br_port, GFP_KERNEL);
+	if (err) {
+		ice_eswitch_br_port_deinit(bridge, br_port);
+		return err;
+	}
+
+	return 0;
+}
+
+static void
+ice_eswitch_br_ports_flush(struct ice_esw_br *bridge)
+{
+	struct ice_esw_br_port *port;
+	unsigned long i;
+
+	xa_for_each(&bridge->ports, i, port)
+		ice_eswitch_br_port_deinit(bridge, port);
+}
+
+static void
+ice_eswitch_br_deinit(struct ice_esw_br_offloads *br_offloads,
+		      struct ice_esw_br *bridge)
+{
+	if (!bridge)
+		return;
+
+	/* Cleanup all the ports that were added asynchronously
+	 * through NETDEV_CHANGEUPPER event.
+	 */
+	ice_eswitch_br_ports_flush(bridge);
+	WARN_ON(!xa_empty(&bridge->ports));
+	xa_destroy(&bridge->ports);
+	br_offloads->bridge = NULL;
+	kfree(bridge);
+}
+
+static struct ice_esw_br *
+ice_eswitch_br_init(struct ice_esw_br_offloads *br_offloads, int ifindex)
+{
+	struct ice_esw_br *bridge;
+
+	bridge = kzalloc(sizeof(*bridge), GFP_KERNEL);
+	if (!bridge)
+		return ERR_PTR(-ENOMEM);
+
+	bridge->br_offloads = br_offloads;
+	bridge->ifindex = ifindex;
+	xa_init(&bridge->ports);
+	br_offloads->bridge = bridge;
+
+	return bridge;
+}
+
+static struct ice_esw_br *
+ice_eswitch_br_get(struct ice_esw_br_offloads *br_offloads, int ifindex,
+		   struct netlink_ext_ack *extack)
+{
+	struct ice_esw_br *bridge = br_offloads->bridge;
+
+	if (bridge) {
+		if (bridge->ifindex != ifindex) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only one bridge is supported per eswitch");
+			return ERR_PTR(-EOPNOTSUPP);
+		}
+		return bridge;
+	}
+
+	/* Create the bridge if it doesn't exist yet */
+	bridge = ice_eswitch_br_init(br_offloads, ifindex);
+	if (IS_ERR(bridge))
+		NL_SET_ERR_MSG_MOD(extack, "Failed to init the bridge");
+
+	return bridge;
+}
+
+static void
+ice_eswitch_br_verify_deinit(struct ice_esw_br_offloads *br_offloads,
+			     struct ice_esw_br *bridge)
+{
+	/* Remove the bridge if it exists and there are no ports left */
+	if (!bridge || !xa_empty(&bridge->ports))
+		return;
+
+	ice_eswitch_br_deinit(br_offloads, bridge);
+}
+
+static int
+ice_eswitch_br_port_unlink(struct ice_esw_br_offloads *br_offloads,
+			   struct net_device *dev, int ifindex,
+			   struct netlink_ext_ack *extack)
+{
+	struct ice_esw_br_port *br_port = ice_eswitch_br_netdev_to_port(dev);
+	struct ice_esw_br *bridge;
+
+	if (!br_port) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port representor is not attached to any bridge");
+		return -EINVAL;
+	}
+
+	if (br_port->bridge->ifindex != ifindex) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port representor is attached to another bridge");
+		return -EINVAL;
+	}
+
+	bridge = br_port->bridge;
+
+	ice_eswitch_br_port_deinit(br_port->bridge, br_port);
+	ice_eswitch_br_verify_deinit(br_offloads, bridge);
+
+	return 0;
+}
+
+static int
+ice_eswitch_br_port_link(struct ice_esw_br_offloads *br_offloads,
+			 struct net_device *dev, int ifindex,
+			 struct netlink_ext_ack *extack)
+{
+	struct ice_esw_br *bridge;
+	int err;
+
+	if (ice_eswitch_br_netdev_to_port(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port is already attached to the bridge");
+		return -EINVAL;
+	}
+
+	bridge = ice_eswitch_br_get(br_offloads, ifindex, extack);
+	if (IS_ERR(bridge))
+		return PTR_ERR(bridge);
+
+	if (ice_is_port_repr_netdev(dev)) {
+		struct ice_repr *repr = ice_netdev_to_repr(dev);
+
+		err = ice_eswitch_br_vf_repr_port_init(bridge, repr);
+	} else {
+		struct ice_pf *pf = ice_netdev_to_pf(dev);
+
+		err = ice_eswitch_br_uplink_port_init(bridge, pf);
+	}
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to init bridge port");
+		goto err_port_init;
+	}
+
+	return 0;
+
+err_port_init:
+	ice_eswitch_br_verify_deinit(br_offloads, bridge);
+	return err;
+}
+
+static int
+ice_eswitch_br_port_changeupper(struct notifier_block *nb, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct ice_esw_br_offloads *br_offloads;
+	struct netlink_ext_ack *extack;
+	struct net_device *upper;
+
+	br_offloads = ice_nb_to_br_offloads(nb, netdev_nb);
+
+	if (!ice_eswitch_br_is_dev_valid(dev))
+		return 0;
+
+	upper = info->upper_dev;
+	if (!netif_is_bridge_master(upper))
+		return 0;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	if (info->linking)
+		return ice_eswitch_br_port_link(br_offloads, dev,
+						upper->ifindex, extack);
+	else
+		return ice_eswitch_br_port_unlink(br_offloads, dev,
+						  upper->ifindex, extack);
+}
+
+static int
+ice_eswitch_br_port_event(struct notifier_block *nb,
+			  unsigned long event, void *ptr)
+{
+	int err = 0;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		err = ice_eswitch_br_port_changeupper(nb, ptr);
+		break;
+	}
+
+	return notifier_from_errno(err);
+}
+
+static void
+ice_eswitch_br_offloads_dealloc(struct ice_pf *pf)
+{
+	struct ice_esw_br_offloads *br_offloads = pf->switchdev.br_offloads;
+
+	ASSERT_RTNL();
+
+	if (!br_offloads)
+		return;
+
+	ice_eswitch_br_deinit(br_offloads, br_offloads->bridge);
+
+	pf->switchdev.br_offloads = NULL;
+	kfree(br_offloads);
+}
+
+static struct ice_esw_br_offloads *
+ice_eswitch_br_offloads_alloc(struct ice_pf *pf)
+{
+	struct ice_esw_br_offloads *br_offloads;
+
+	ASSERT_RTNL();
+
+	if (pf->switchdev.br_offloads)
+		return ERR_PTR(-EEXIST);
+
+	br_offloads = kzalloc(sizeof(*br_offloads), GFP_KERNEL);
+	if (!br_offloads)
+		return ERR_PTR(-ENOMEM);
+
+	pf->switchdev.br_offloads = br_offloads;
+	br_offloads->pf = pf;
+
+	return br_offloads;
+}
+
+void
+ice_eswitch_br_offloads_deinit(struct ice_pf *pf)
+{
+	struct ice_esw_br_offloads *br_offloads;
+
+	br_offloads = pf->switchdev.br_offloads;
+	if (!br_offloads)
+		return;
+
+	unregister_netdevice_notifier(&br_offloads->netdev_nb);
+	/* Although notifier block is unregistered just before,
+	 * so we don't get any new events, some events might be
+	 * already in progress. Hold the rtnl lock and wait for
+	 * them to finished.
+	 */
+	rtnl_lock();
+	ice_eswitch_br_offloads_dealloc(pf);
+	rtnl_unlock();
+}
+
+int
+ice_eswitch_br_offloads_init(struct ice_pf *pf)
+{
+	struct ice_esw_br_offloads *br_offloads;
+	struct device *dev = ice_pf_to_dev(pf);
+	int err;
+
+	rtnl_lock();
+	br_offloads = ice_eswitch_br_offloads_alloc(pf);
+	rtnl_unlock();
+	if (IS_ERR(br_offloads)) {
+		dev_err(dev, "Failed to init eswitch bridge\n");
+		return PTR_ERR(br_offloads);
+	}
+
+	br_offloads->netdev_nb.notifier_call = ice_eswitch_br_port_event;
+	err = register_netdevice_notifier(&br_offloads->netdev_nb);
+	if (err) {
+		dev_err(dev,
+			"Failed to register bridge port event notifier\n");
+		goto err_reg_netdev_nb;
+	}
+
+	return 0;
+
+err_reg_netdev_nb:
+	rtnl_lock();
+	ice_eswitch_br_offloads_dealloc(pf);
+	rtnl_unlock();
+
+	return err;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
new file mode 100644
index 000000000000..3ad28a17298f
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2023, Intel Corporation. */
+
+#ifndef _ICE_ESWITCH_BR_H_
+#define _ICE_ESWITCH_BR_H_
+
+enum ice_esw_br_port_type {
+	ICE_ESWITCH_BR_UPLINK_PORT = 0,
+	ICE_ESWITCH_BR_VF_REPR_PORT = 1,
+};
+
+struct ice_esw_br_port {
+	struct ice_esw_br *bridge;
+	struct ice_vsi *vsi;
+	enum ice_esw_br_port_type type;
+	u16 vsi_idx;
+};
+
+struct ice_esw_br {
+	struct ice_esw_br_offloads *br_offloads;
+	struct xarray ports;
+
+	int ifindex;
+};
+
+struct ice_esw_br_offloads {
+	struct ice_pf *pf;
+	struct ice_esw_br *bridge;
+	struct notifier_block netdev_nb;
+};
+
+#define ice_nb_to_br_offloads(nb, nb_name) \
+	container_of(nb, \
+		     struct ice_esw_br_offloads, \
+		     nb_name)
+
+void
+ice_eswitch_br_offloads_deinit(struct ice_pf *pf);
+int
+ice_eswitch_br_offloads_init(struct ice_pf *pf);
+
+#endif /* _ICE_ESWITCH_BR_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d8193de0715a..e940b9009d7a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -80,7 +80,7 @@ ice_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch,
 		     void *data,
 		     void (*cleanup)(struct flow_block_cb *block_cb));
 
-bool netif_is_ice(struct net_device *dev)
+bool netif_is_ice(const struct net_device *dev)
 {
 	return dev && (dev->netdev_ops == &ice_netdev_ops);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index e30e12321abd..c686ac0935eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -254,7 +254,7 @@ static const struct net_device_ops ice_repr_netdev_ops = {
  * ice_is_port_repr_netdev - Check if a given netdevice is a port representor netdev
  * @netdev: pointer to netdev
  */
-bool ice_is_port_repr_netdev(struct net_device *netdev)
+bool ice_is_port_repr_netdev(const struct net_device *netdev)
 {
 	return netdev && (netdev->netdev_ops == &ice_repr_netdev_ops);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.h b/drivers/net/ethernet/intel/ice/ice_repr.h
index 9c2a6f496b3b..e1ee2d2c1d2d 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.h
+++ b/drivers/net/ethernet/intel/ice/ice_repr.h
@@ -12,6 +12,7 @@ struct ice_repr {
 	struct ice_q_vector *q_vector;
 	struct net_device *netdev;
 	struct metadata_dst *dst;
+	struct ice_esw_br_port *br_port;
 #ifdef CONFIG_ICE_SWITCHDEV
 	/* info about slow path rule */
 	struct ice_rule_query_data sp_rule;
@@ -27,5 +28,5 @@ void ice_repr_stop_tx_queues(struct ice_repr *repr);
 void ice_repr_set_traffic_vsi(struct ice_repr *repr, struct ice_vsi *vsi);
 
 struct ice_repr *ice_netdev_to_repr(struct net_device *netdev);
-bool ice_is_port_repr_netdev(struct net_device *netdev);
+bool ice_is_port_repr_netdev(const struct net_device *netdev);
 #endif
-- 
2.40.1


