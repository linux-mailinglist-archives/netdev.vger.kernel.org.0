Return-Path: <netdev+bounces-4185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C1470B891
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA2F8280EDA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1129EA922;
	Mon, 22 May 2023 09:07:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE97AD52
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:07:07 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496B5E4D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 02:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684746424; x=1716282424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hacv2fi9e1FSp2ww1DQDntIAcGEWssv2Y3CFVch0QM8=;
  b=Locd/gxrc7JNhtqFx7H/zZm29N5nbwoqQfEp8gKeJIZUSJf25KxzWz1D
   VnWLT1E4B6w77ue/l2HolNZvBOUb1Zme1RBf/r4htgT8w0wGnTT3b1e2Y
   Y6jZ42YLiC0FPzpt+spwgLk1T14691k3yL00VciFt+daKDp8pPEDjO8ds
   +hUpqRdnFcoRX9dCUD/0Ewbu1hXMBCZO3RjCS3GGcXKXSNVswLnSNZkVp
   anS9YiwdR6rx/o+qz9TcwBVaP6LNq2NNNy+lbMWqyOqCZBg6ivAKae2nH
   /nWFVQySaQiuZJ+9Eole4qJqvb8rLW4fuD3pSuUASPUPbco8p0tPMzJbl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="337459282"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="337459282"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 02:06:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="847765483"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="847765483"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2023 02:06:52 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id F2509369E1;
	Mon, 22 May 2023 10:06:50 +0100 (IST)
From: Wojciech Drewek <wojciech.drewek@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	alexandr.lobakin@intel.com,
	david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com,
	marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com,
	sridhar.samudrala@intel.com
Subject: [PATCH iwl-next v3 04/10] ice: Switchdev FDB events support
Date: Mon, 22 May 2023 11:05:36 +0200
Message-Id: <20230522090542.45679-5-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522090542.45679-1-wojciech.drewek@intel.com>
References: <20230522090542.45679-1-wojciech.drewek@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Listen for SWITCHDEV_FDB_{ADD|DEL}_TO_DEVICE events while in switchdev
mode. Accept these events on both uplink and VF PR ports. Add HW
rules in newly created workqueue. FDB entries are stored in rhashtable
for lookup when removing the entry and in the list for cleanup
purpose. Direction of the HW rule depends on the type of the ports
on which the FDB event was received:

ICE_ESWITCH_BR_UPLINK_PORT:
TX rule that forwards the packet to the LAN (egress).

ICE_ESWITCH_BR_VF_REPR_PORT:
RX rule that forwards the packet to the VF associated
with the port representor.

In both cases the rule matches on the dst mac address.
All the FDB entries are stored in the bridge structure.
When the port is removed all the FDB entries associated with
this port are removed as well. This is achieved thanks to the reference
to the port that FDB entry holds.

In the fwd rule we use only one lookup type (MAC address)
but lkups_cnt variable is already introduced because
we will have more lookups in the subsequent patches.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v2: declare-time initialization, code style nitpicks,
    use typeof instead of full type name in the container_of
    macro, use PTR_ERR_OR_ZERO in ice_eswitch_br_flow_create
---
 .../net/ethernet/intel/ice/ice_eswitch_br.c   | 448 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_eswitch_br.h   |  46 ++
 2 files changed, 493 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
index 1e5fd9c5a8b6..0fc4807e1d0c 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
@@ -4,6 +4,14 @@
 #include "ice.h"
 #include "ice_eswitch_br.h"
 #include "ice_repr.h"
+#include "ice_switch.h"
+
+static const struct rhashtable_params ice_fdb_ht_params = {
+	.key_offset = offsetof(struct ice_esw_br_fdb_entry, data),
+	.key_len = sizeof(struct ice_esw_br_fdb_data),
+	.head_offset = offsetof(struct ice_esw_br_fdb_entry, ht_node),
+	.automatic_shrinking = true,
+};
 
 static bool ice_eswitch_br_is_dev_valid(const struct net_device *dev)
 {
@@ -27,15 +35,421 @@ ice_eswitch_br_netdev_to_port(struct net_device *dev)
 	return NULL;
 }
 
+static void
+ice_eswitch_br_ingress_rule_setup(struct ice_adv_lkup_elem *list,
+				  struct ice_adv_rule_info *rule_info,
+				  const unsigned char *mac,
+				  u8 pf_id, u16 vf_vsi_idx)
+{
+	list[0].type = ICE_MAC_OFOS;
+	ether_addr_copy(list[0].h_u.eth_hdr.dst_addr, mac);
+	eth_broadcast_addr(list[0].m_u.eth_hdr.dst_addr);
+
+	rule_info->sw_act.vsi_handle = vf_vsi_idx;
+	rule_info->sw_act.flag |= ICE_FLTR_RX;
+	rule_info->sw_act.src = pf_id;
+	rule_info->priority = 5;
+}
+
+static void
+ice_eswitch_br_egress_rule_setup(struct ice_adv_lkup_elem *list,
+				 struct ice_adv_rule_info *rule_info,
+				 const unsigned char *mac,
+				 u16 pf_vsi_idx)
+{
+	list[0].type = ICE_MAC_OFOS;
+	ether_addr_copy(list[0].h_u.eth_hdr.dst_addr, mac);
+	eth_broadcast_addr(list[0].m_u.eth_hdr.dst_addr);
+
+	rule_info->sw_act.vsi_handle = pf_vsi_idx;
+	rule_info->sw_act.flag |= ICE_FLTR_TX;
+	rule_info->flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
+	rule_info->flags_info.act_valid = true;
+	rule_info->priority = 5;
+}
+
+static int
+ice_eswitch_br_rule_delete(struct ice_hw *hw, struct ice_rule_query_data *rule)
+{
+	int err;
+
+	if (!rule)
+		return -EINVAL;
+
+	err = ice_rem_adv_rule_by_id(hw, rule);
+	kfree(rule);
+
+	return err;
+}
+
+static struct ice_rule_query_data *
+ice_eswitch_br_fwd_rule_create(struct ice_hw *hw, int vsi_idx, int port_type,
+			       const unsigned char *mac)
+{
+	struct ice_adv_rule_info rule_info = { 0 };
+	struct ice_rule_query_data *rule;
+	struct ice_adv_lkup_elem *list;
+	u16 lkups_cnt = 1;
+	int err;
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return ERR_PTR(-ENOMEM);
+
+	list = kcalloc(lkups_cnt, sizeof(*list), GFP_ATOMIC);
+	if (!list) {
+		err = -ENOMEM;
+		goto err_list_alloc;
+	}
+
+	switch (port_type) {
+	case ICE_ESWITCH_BR_UPLINK_PORT:
+		ice_eswitch_br_egress_rule_setup(list, &rule_info, mac,
+						 vsi_idx);
+		break;
+	case ICE_ESWITCH_BR_VF_REPR_PORT:
+		ice_eswitch_br_ingress_rule_setup(list, &rule_info, mac,
+						  hw->pf_id, vsi_idx);
+		break;
+	default:
+		err = -EINVAL;
+		goto err_add_rule;
+	}
+
+	rule_info.sw_act.fltr_act = ICE_FWD_TO_VSI;
+
+	err = ice_add_adv_rule(hw, list, lkups_cnt, &rule_info, rule);
+	if (err)
+		goto err_add_rule;
+
+	kfree(list);
+
+	return rule;
+
+err_add_rule:
+	kfree(list);
+err_list_alloc:
+	kfree(rule);
+
+	return ERR_PTR(err);
+}
+
+static struct ice_esw_br_flow *
+ice_eswitch_br_flow_create(struct device *dev, struct ice_hw *hw, int vsi_idx,
+			   int port_type, const unsigned char *mac)
+{
+	struct ice_rule_query_data *fwd_rule;
+	struct ice_esw_br_flow *flow;
+	int err;
+
+	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
+	if (!flow)
+		return ERR_PTR(-ENOMEM);
+
+	fwd_rule = ice_eswitch_br_fwd_rule_create(hw, vsi_idx, port_type, mac);
+	err = PTR_ERR_OR_ZERO(fwd_rule);
+	if (err) {
+		dev_err(dev, "Failed to create eswitch bridge %sgress forward rule, err: %d\n",
+			port_type == ICE_ESWITCH_BR_UPLINK_PORT ? "e" : "in",
+			err);
+		goto err_fwd_rule;
+	}
+
+	flow->fwd_rule = fwd_rule;
+
+	return flow;
+
+err_fwd_rule:
+	kfree(flow);
+
+	return ERR_PTR(err);
+}
+
+static struct ice_esw_br_fdb_entry *
+ice_eswitch_br_fdb_find(struct ice_esw_br *bridge, const unsigned char *mac,
+			u16 vid)
+{
+	struct ice_esw_br_fdb_data data = {
+		.vid = vid,
+	};
+
+	ether_addr_copy(data.addr, mac);
+	return rhashtable_lookup_fast(&bridge->fdb_ht, &data,
+				      ice_fdb_ht_params);
+}
+
+static void
+ice_eswitch_br_flow_delete(struct ice_pf *pf, struct ice_esw_br_flow *flow)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	int err;
+
+	err = ice_eswitch_br_rule_delete(&pf->hw, flow->fwd_rule);
+	if (err)
+		dev_err(dev, "Failed to delete FDB forward rule, err: %d\n",
+			err);
+
+	kfree(flow);
+}
+
+static void
+ice_eswitch_br_fdb_entry_delete(struct ice_esw_br *bridge,
+				struct ice_esw_br_fdb_entry *fdb_entry)
+{
+	struct ice_pf *pf = bridge->br_offloads->pf;
+
+	rhashtable_remove_fast(&bridge->fdb_ht, &fdb_entry->ht_node,
+			       ice_fdb_ht_params);
+	list_del(&fdb_entry->list);
+
+	ice_eswitch_br_flow_delete(pf, fdb_entry->flow);
+
+	kfree(fdb_entry);
+}
+
+static void
+ice_eswitch_br_fdb_offload_notify(struct net_device *dev,
+				  const unsigned char *mac, u16 vid,
+				  unsigned long val)
+{
+	struct switchdev_notifier_fdb_info fdb_info = {
+		.addr = mac,
+		.vid = vid,
+		.offloaded = true,
+	};
+
+	call_switchdev_notifiers(val, dev, &fdb_info.info, NULL);
+}
+
+static void
+ice_eswitch_br_fdb_entry_notify_and_cleanup(struct ice_esw_br *bridge,
+					    struct ice_esw_br_fdb_entry *entry)
+{
+	if (!(entry->flags & ICE_ESWITCH_BR_FDB_ADDED_BY_USER))
+		ice_eswitch_br_fdb_offload_notify(entry->dev, entry->data.addr,
+						  entry->data.vid,
+						  SWITCHDEV_FDB_DEL_TO_BRIDGE);
+	ice_eswitch_br_fdb_entry_delete(bridge, entry);
+}
+
+static void
+ice_eswitch_br_fdb_entry_find_and_delete(struct ice_esw_br *bridge,
+					 const unsigned char *mac, u16 vid)
+{
+	struct ice_pf *pf = bridge->br_offloads->pf;
+	struct ice_esw_br_fdb_entry *fdb_entry;
+	struct device *dev = ice_pf_to_dev(pf);
+
+	fdb_entry = ice_eswitch_br_fdb_find(bridge, mac, vid);
+	if (!fdb_entry) {
+		dev_err(dev, "FDB entry with mac: %pM and vid: %u not found\n",
+			mac, vid);
+		return;
+	}
+
+	ice_eswitch_br_fdb_entry_notify_and_cleanup(bridge, fdb_entry);
+}
+
+static void
+ice_eswitch_br_fdb_entry_create(struct net_device *netdev,
+				struct ice_esw_br_port *br_port,
+				bool added_by_user,
+				const unsigned char *mac, u16 vid)
+{
+	struct ice_esw_br *bridge = br_port->bridge;
+	struct ice_pf *pf = bridge->br_offloads->pf;
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_esw_br_fdb_entry *fdb_entry;
+	struct ice_esw_br_flow *flow;
+	struct ice_hw *hw = &pf->hw;
+	unsigned long event;
+	int err;
+
+	fdb_entry = ice_eswitch_br_fdb_find(bridge, mac, vid);
+	if (fdb_entry)
+		ice_eswitch_br_fdb_entry_notify_and_cleanup(bridge, fdb_entry);
+
+	fdb_entry = kzalloc(sizeof(*fdb_entry), GFP_KERNEL);
+	if (!fdb_entry) {
+		err = -ENOMEM;
+		goto err_exit;
+	}
+
+	flow = ice_eswitch_br_flow_create(dev, hw, br_port->vsi_idx,
+					  br_port->type, mac);
+	if (IS_ERR(flow)) {
+		err = PTR_ERR(flow);
+		goto err_add_flow;
+	}
+
+	ether_addr_copy(fdb_entry->data.addr, mac);
+	fdb_entry->data.vid = vid;
+	fdb_entry->br_port = br_port;
+	fdb_entry->flow = flow;
+	fdb_entry->dev = netdev;
+	event = SWITCHDEV_FDB_ADD_TO_BRIDGE;
+
+	if (added_by_user) {
+		fdb_entry->flags |= ICE_ESWITCH_BR_FDB_ADDED_BY_USER;
+		event = SWITCHDEV_FDB_OFFLOADED;
+	}
+
+	err = rhashtable_insert_fast(&bridge->fdb_ht, &fdb_entry->ht_node,
+				     ice_fdb_ht_params);
+	if (err)
+		goto err_fdb_insert;
+
+	list_add(&fdb_entry->list, &bridge->fdb_list);
+
+	ice_eswitch_br_fdb_offload_notify(netdev, mac, vid, event);
+
+	return;
+
+err_fdb_insert:
+	ice_eswitch_br_flow_delete(pf, flow);
+err_add_flow:
+	kfree(fdb_entry);
+err_exit:
+	dev_err(dev, "Failed to create fdb entry, err: %d\n", err);
+}
+
+static void
+ice_eswitch_br_fdb_work_dealloc(struct ice_esw_br_fdb_work *fdb_work)
+{
+	kfree(fdb_work->fdb_info.addr);
+	kfree(fdb_work);
+}
+
+static void
+ice_eswitch_br_fdb_event_work(struct work_struct *work)
+{
+	struct ice_esw_br_fdb_work *fdb_work = ice_work_to_fdb_work(work);
+	bool added_by_user = fdb_work->fdb_info.added_by_user;
+	struct ice_esw_br_port *br_port = fdb_work->br_port;
+	const unsigned char *mac = fdb_work->fdb_info.addr;
+	u16 vid = fdb_work->fdb_info.vid;
+
+	rtnl_lock();
+
+	if (!br_port || !br_port->bridge)
+		goto err_exit;
+
+	switch (fdb_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		ice_eswitch_br_fdb_entry_create(fdb_work->dev, br_port,
+						added_by_user, mac, vid);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		ice_eswitch_br_fdb_entry_find_and_delete(br_port->bridge,
+							 mac, vid);
+		break;
+	default:
+		goto err_exit;
+	}
+
+err_exit:
+	rtnl_unlock();
+	dev_put(fdb_work->dev);
+	ice_eswitch_br_fdb_work_dealloc(fdb_work);
+}
+
+static struct ice_esw_br_fdb_work *
+ice_eswitch_br_fdb_work_alloc(struct switchdev_notifier_fdb_info *fdb_info,
+			      struct ice_esw_br_port *br_port,
+			      struct net_device *dev,
+			      unsigned long event)
+{
+	struct ice_esw_br_fdb_work *work;
+	unsigned char *mac;
+
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_WORK(&work->work, ice_eswitch_br_fdb_event_work);
+	memcpy(&work->fdb_info, fdb_info, sizeof(work->fdb_info));
+
+	mac = kzalloc(ETH_ALEN, GFP_ATOMIC);
+	if (!mac) {
+		kfree(work);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ether_addr_copy(mac, fdb_info->addr);
+	work->fdb_info.addr = mac;
+	work->br_port = br_port;
+	work->event = event;
+	work->dev = dev;
+
+	return work;
+}
+
+static int
+ice_eswitch_br_switchdev_event(struct notifier_block *nb,
+			       unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct switchdev_notifier_info *info = ptr;
+	struct ice_esw_br_offloads *br_offloads;
+	struct ice_esw_br_fdb_work *work;
+	struct ice_esw_br_port *br_port;
+	struct netlink_ext_ack *extack;
+	struct net_device *upper;
+
+	br_offloads = ice_nb_to_br_offloads(nb, switchdev_nb);
+	extack = switchdev_notifier_info_to_extack(ptr);
+
+	upper = netdev_master_upper_dev_get_rcu(dev);
+	if (!upper)
+		return NOTIFY_DONE;
+
+	if (!netif_is_bridge_master(upper))
+		return NOTIFY_DONE;
+
+	if (!ice_eswitch_br_is_dev_valid(dev))
+		return NOTIFY_DONE;
+
+	br_port = ice_eswitch_br_netdev_to_port(dev);
+	if (!br_port)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		fdb_info = container_of(info, typeof(*fdb_info), info);
+
+		work = ice_eswitch_br_fdb_work_alloc(fdb_info, br_port, dev,
+						     event);
+		if (IS_ERR(work)) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to init switchdev fdb work");
+			return notifier_from_errno(PTR_ERR(work));
+		}
+		dev_hold(dev);
+
+		queue_work(br_offloads->wq, &work->work);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
 static void
 ice_eswitch_br_port_deinit(struct ice_esw_br *bridge,
 			   struct ice_esw_br_port *br_port)
 {
+	struct ice_esw_br_fdb_entry *fdb_entry, *tmp;
 	struct ice_vsi *vsi = br_port->vsi;
 
+	list_for_each_entry_safe(fdb_entry, tmp, &bridge->fdb_list, list) {
+		if (br_port == fdb_entry->br_port)
+			ice_eswitch_br_fdb_entry_delete(bridge, fdb_entry);
+	}
+
 	if (br_port->type == ICE_ESWITCH_BR_UPLINK_PORT && vsi->back)
 		vsi->back->br_port = NULL;
-	else if (vsi->vf)
+	else if (vsi->vf && vsi->vf->repr)
 		vsi->vf->repr->br_port = NULL;
 
 	xa_erase(&bridge->ports, br_port->vsi_idx);
@@ -129,6 +543,8 @@ ice_eswitch_br_deinit(struct ice_esw_br_offloads *br_offloads,
 	ice_eswitch_br_ports_flush(bridge);
 	WARN_ON(!xa_empty(&bridge->ports));
 	xa_destroy(&bridge->ports);
+	rhashtable_destroy(&bridge->fdb_ht);
+
 	br_offloads->bridge = NULL;
 	kfree(bridge);
 }
@@ -137,11 +553,19 @@ static struct ice_esw_br *
 ice_eswitch_br_init(struct ice_esw_br_offloads *br_offloads, int ifindex)
 {
 	struct ice_esw_br *bridge;
+	int err;
 
 	bridge = kzalloc(sizeof(*bridge), GFP_KERNEL);
 	if (!bridge)
 		return ERR_PTR(-ENOMEM);
 
+	err = rhashtable_init(&bridge->fdb_ht, &ice_fdb_ht_params);
+	if (err) {
+		kfree(bridge);
+		return ERR_PTR(err);
+	}
+
+	INIT_LIST_HEAD(&bridge->fdb_list);
 	bridge->br_offloads = br_offloads;
 	bridge->ifindex = ifindex;
 	xa_init(&bridge->ports);
@@ -337,6 +761,8 @@ ice_eswitch_br_offloads_deinit(struct ice_pf *pf)
 		return;
 
 	unregister_netdevice_notifier(&br_offloads->netdev_nb);
+	unregister_switchdev_notifier(&br_offloads->switchdev_nb);
+	destroy_workqueue(br_offloads->wq);
 	/* Although notifier block is unregistered just before,
 	 * so we don't get any new events, some events might be
 	 * already in progress. Hold the rtnl lock and wait for
@@ -362,6 +788,22 @@ ice_eswitch_br_offloads_init(struct ice_pf *pf)
 		return PTR_ERR(br_offloads);
 	}
 
+	br_offloads->wq = alloc_ordered_workqueue("ice_bridge_wq", 0);
+	if (!br_offloads->wq) {
+		err = -ENOMEM;
+		dev_err(dev, "Failed to allocate bridge workqueue\n");
+		goto err_alloc_wq;
+	}
+
+	br_offloads->switchdev_nb.notifier_call =
+		ice_eswitch_br_switchdev_event;
+	err = register_switchdev_notifier(&br_offloads->switchdev_nb);
+	if (err) {
+		dev_err(dev,
+			"Failed to register switchdev notifier\n");
+		goto err_reg_switchdev_nb;
+	}
+
 	br_offloads->netdev_nb.notifier_call = ice_eswitch_br_port_event;
 	err = register_netdevice_notifier(&br_offloads->netdev_nb);
 	if (err) {
@@ -373,6 +815,10 @@ ice_eswitch_br_offloads_init(struct ice_pf *pf)
 	return 0;
 
 err_reg_netdev_nb:
+	unregister_switchdev_notifier(&br_offloads->switchdev_nb);
+err_reg_switchdev_nb:
+	destroy_workqueue(br_offloads->wq);
+err_alloc_wq:
 	rtnl_lock();
 	ice_eswitch_br_offloads_dealloc(pf);
 	rtnl_unlock();
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
index 3ad28a17298f..6fcacf545b98 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
@@ -4,6 +4,33 @@
 #ifndef _ICE_ESWITCH_BR_H_
 #define _ICE_ESWITCH_BR_H_
 
+#include <linux/rhashtable.h>
+
+struct ice_esw_br_fdb_data {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
+struct ice_esw_br_flow {
+	struct ice_rule_query_data *fwd_rule;
+};
+
+enum {
+	ICE_ESWITCH_BR_FDB_ADDED_BY_USER = BIT(0),
+};
+
+struct ice_esw_br_fdb_entry {
+	struct ice_esw_br_fdb_data data;
+	struct rhash_head ht_node;
+	struct list_head list;
+
+	int flags;
+
+	struct net_device *dev;
+	struct ice_esw_br_port *br_port;
+	struct ice_esw_br_flow *flow;
+};
+
 enum ice_esw_br_port_type {
 	ICE_ESWITCH_BR_UPLINK_PORT = 0,
 	ICE_ESWITCH_BR_VF_REPR_PORT = 1,
@@ -20,6 +47,9 @@ struct ice_esw_br {
 	struct ice_esw_br_offloads *br_offloads;
 	struct xarray ports;
 
+	struct rhashtable fdb_ht;
+	struct list_head fdb_list;
+
 	int ifindex;
 };
 
@@ -27,6 +57,17 @@ struct ice_esw_br_offloads {
 	struct ice_pf *pf;
 	struct ice_esw_br *bridge;
 	struct notifier_block netdev_nb;
+	struct notifier_block switchdev_nb;
+
+	struct workqueue_struct *wq;
+};
+
+struct ice_esw_br_fdb_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct ice_esw_br_port *br_port;
+	struct net_device *dev;
+	unsigned long event;
 };
 
 #define ice_nb_to_br_offloads(nb, nb_name) \
@@ -34,6 +75,11 @@ struct ice_esw_br_offloads {
 		     struct ice_esw_br_offloads, \
 		     nb_name)
 
+#define ice_work_to_fdb_work(w) \
+	container_of(w, \
+		     struct ice_esw_br_fdb_work, \
+		     work)
+
 void
 ice_eswitch_br_offloads_deinit(struct ice_pf *pf);
 int
-- 
2.40.1


