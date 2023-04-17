Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16AA6E441A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjDQJjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjDQJix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:38:53 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF8F5B85
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681724288; x=1713260288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IS20tENj5H6UsBevNe1so2szwJ0jlbv0z6cyTpgzxW0=;
  b=SBjDhLe6irWwfa7qh/MfgshdWB2YaBvD/Ab14qgB44p19Mp2l1TQORZl
   TSCWfnps9XQZTlhTZiO3qygYEHMWEFOfsiKo3ExoV4Qm9YFicSoQ4gFNP
   1zyvoQQdWctxT42Hoa8T3RBiCjGDOufVdkMCGgd7dTJny0t2jI3TpaAYW
   sVcFHywbX8ad1F4UVhqpsJgCyai5SgM08TgEfQyBkE9aiNPpi7TnjzMhK
   LarHvdg5+RzZ+mn1mPHyWVfz6GQ/9fRYHo060Ra5i1a1djCKJ7Sd4G/TZ
   V6F1np28nYmzWpTyhfhjqHEPK7fqpcrc3mBMn/cPHycrwoZHcpOkQ3EA2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="333644102"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="333644102"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 02:35:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="640899274"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="640899274"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2023 02:35:23 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id ED98D37F5D;
        Mon, 17 Apr 2023 10:35:21 +0100 (IST)
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        david.m.ertman@intel.com, michal.swiatkowski@linux.intel.com,
        marcin.szycik@linux.intel.com, pawel.chmielewski@intel.com,
        sridhar.samudrala@intel.com
Subject: [PATCH net-next 08/12] ice: Add VLAN FDB support in switchdev mode
Date:   Mon, 17 Apr 2023 11:34:08 +0200
Message-Id: <20230417093412.12161-9-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417093412.12161-1-wojciech.drewek@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@intel.com>

Add support for matching on VLAN tag in bridge offloads.
Currently only trunk mode is supported.

To enable VLAN filtering (existing FDB entries will be deleted):
ip link set $BR type bridge vlan_filtering 1

To add VLANs to bridge in trunk mode:
bridge vlan add dev $PF1 vid 110-111
bridge vlan add dev $VF1_PR vid 110-111

Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
---
 .../net/ethernet/intel/ice/ice_eswitch_br.c   | 319 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_eswitch_br.h   |  12 +
 2 files changed, 317 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
index 49381e4bf62a..56d36e397b12 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
@@ -59,13 +59,19 @@ ice_eswitch_br_netdev_to_port(struct net_device *dev)
 static void
 ice_eswitch_br_ingress_rule_setup(struct ice_adv_lkup_elem *list,
 				  struct ice_adv_rule_info *rule_info,
-				  const unsigned char *mac,
+				  const unsigned char *mac, bool vlan, u16 vid,
 				  u8 pf_id, u16 vf_vsi_idx)
 {
 	list[0].type = ICE_MAC_OFOS;
 	ether_addr_copy(list[0].h_u.eth_hdr.dst_addr, mac);
 	eth_broadcast_addr(list[0].m_u.eth_hdr.dst_addr);
 
+	if (vlan) {
+		list[1].type = ICE_VLAN_OFOS;
+		list[1].h_u.vlan_hdr.vlan = cpu_to_be16(vid & VLAN_VID_MASK);
+		list[1].m_u.vlan_hdr.vlan = cpu_to_be16(0xFFFF);
+	}
+
 	rule_info->sw_act.vsi_handle = vf_vsi_idx;
 	rule_info->sw_act.flag |= ICE_FLTR_RX;
 	rule_info->sw_act.src = pf_id;
@@ -75,13 +81,19 @@ ice_eswitch_br_ingress_rule_setup(struct ice_adv_lkup_elem *list,
 static void
 ice_eswitch_br_egress_rule_setup(struct ice_adv_lkup_elem *list,
 				 struct ice_adv_rule_info *rule_info,
-				 const unsigned char *mac,
+				 const unsigned char *mac, bool vlan, u16 vid,
 				 u16 pf_vsi_idx)
 {
 	list[0].type = ICE_MAC_OFOS;
 	ether_addr_copy(list[0].h_u.eth_hdr.dst_addr, mac);
 	eth_broadcast_addr(list[0].m_u.eth_hdr.dst_addr);
 
+	if (vlan) {
+		list[1].type = ICE_VLAN_OFOS;
+		list[1].h_u.vlan_hdr.vlan = cpu_to_be16(vid & VLAN_VID_MASK);
+		list[1].m_u.vlan_hdr.vlan = cpu_to_be16(0xFFFF);
+	}
+
 	rule_info->sw_act.vsi_handle = pf_vsi_idx;
 	rule_info->sw_act.flag |= ICE_FLTR_TX;
 	rule_info->flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
@@ -105,12 +117,12 @@ ice_eswitch_br_rule_delete(struct ice_hw *hw, struct ice_rule_query_data *rule)
 
 static struct ice_rule_query_data *
 ice_eswitch_br_fwd_rule_create(struct ice_hw *hw, u16 vsi_idx, int port_type,
-			       const unsigned char *mac)
+			       const unsigned char *mac, bool vlan, u16 vid)
 {
 	struct ice_adv_rule_info rule_info = { 0 };
 	struct ice_rule_query_data *rule;
 	struct ice_adv_lkup_elem *list;
-	u16 lkups_cnt = 1;
+	u16 lkups_cnt = vlan ? 2 : 1;
 	int err;
 
 	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
@@ -125,12 +137,12 @@ ice_eswitch_br_fwd_rule_create(struct ice_hw *hw, u16 vsi_idx, int port_type,
 
 	switch (port_type) {
 	case ICE_ESWITCH_BR_UPLINK_PORT:
-		ice_eswitch_br_egress_rule_setup(list, &rule_info, mac,
-						 vsi_idx);
+		ice_eswitch_br_egress_rule_setup(list, &rule_info, mac, vlan,
+						 vid, vsi_idx);
 		break;
 	case ICE_ESWITCH_BR_VF_REPR_PORT:
-		ice_eswitch_br_ingress_rule_setup(list, &rule_info, mac,
-						  hw->pf_id, vsi_idx);
+		ice_eswitch_br_ingress_rule_setup(list, &rule_info, mac, vlan,
+						  vid, hw->pf_id, vsi_idx);
 		break;
 	default:
 		err = -EINVAL;
@@ -159,12 +171,12 @@ ice_eswitch_br_fwd_rule_create(struct ice_hw *hw, u16 vsi_idx, int port_type,
 
 static struct ice_rule_query_data *
 ice_eswitch_br_guard_rule_create(struct ice_hw *hw, u16 vsi_idx,
-				 const unsigned char *mac)
+				 const unsigned char *mac, bool vlan, u16 vid)
 {
 	struct ice_adv_rule_info rule_info = { 0 };
 	struct ice_rule_query_data *rule;
 	struct ice_adv_lkup_elem *list;
-	const u16 lkups_cnt = 1;
+	u16 lkups_cnt = vlan ? 2 : 1;
 	int err;
 
 	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
@@ -183,6 +195,12 @@ ice_eswitch_br_guard_rule_create(struct ice_hw *hw, u16 vsi_idx,
 	ether_addr_copy(list[0].h_u.eth_hdr.src_addr, mac);
 	eth_broadcast_addr(list[0].m_u.eth_hdr.src_addr);
 
+	if (vlan) {
+		list[1].type = ICE_VLAN_OFOS;
+		list[1].h_u.vlan_hdr.vlan = cpu_to_be16(vid & VLAN_VID_MASK);
+		list[1].m_u.vlan_hdr.vlan = cpu_to_be16(0xFFFF);
+	}
+
 	rule_info.allow_pass_l2 = true;
 	rule_info.sw_act.vsi_handle = vsi_idx;
 	rule_info.sw_act.fltr_act = ICE_NOP;
@@ -204,7 +222,8 @@ ice_eswitch_br_guard_rule_create(struct ice_hw *hw, u16 vsi_idx,
 
 static struct ice_esw_br_flow *
 ice_eswitch_br_flow_create(struct device *dev, struct ice_hw *hw, u16 vsi_idx,
-			   int port_type, const unsigned char *mac)
+			   int port_type, const unsigned char *mac,
+			   bool add_vlan, u16 vid)
 {
 	struct ice_rule_query_data *fwd_rule, *guard_rule;
 	struct ice_esw_br_flow *flow;
@@ -214,7 +233,8 @@ ice_eswitch_br_flow_create(struct device *dev, struct ice_hw *hw, u16 vsi_idx,
 	if (!flow)
 		return ERR_PTR(-ENOMEM);
 
-	fwd_rule = ice_eswitch_br_fwd_rule_create(hw, vsi_idx, port_type, mac);
+	fwd_rule = ice_eswitch_br_fwd_rule_create(hw, vsi_idx, port_type, mac,
+						  add_vlan, vid);
 	if (IS_ERR(fwd_rule)) {
 		err = PTR_ERR(fwd_rule);
 		dev_err(dev, "Failed to create eswitch bridge %sgress forward rule, err: %d\n",
@@ -223,7 +243,8 @@ ice_eswitch_br_flow_create(struct device *dev, struct ice_hw *hw, u16 vsi_idx,
 		goto err_fwd_rule;
 	}
 
-	guard_rule = ice_eswitch_br_guard_rule_create(hw, vsi_idx, mac);
+	guard_rule = ice_eswitch_br_guard_rule_create(hw, vsi_idx, mac,
+						      add_vlan, vid);
 	if (IS_ERR(guard_rule)) {
 		err = PTR_ERR(guard_rule);
 		dev_err(dev, "Failed to create eswitch bridge %sgress guard rule, err: %d\n",
@@ -276,6 +297,30 @@ ice_eswitch_br_flow_delete(struct ice_pf *pf, struct ice_esw_br_flow *flow)
 	kfree(flow);
 }
 
+static struct ice_esw_br_vlan *
+ice_esw_br_port_vlan_lookup(struct ice_esw_br *bridge, u16 vsi_idx, u16 vid)
+{
+	struct ice_pf *pf = bridge->br_offloads->pf;
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_esw_br_port *port;
+	struct ice_esw_br_vlan *vlan;
+
+	port = xa_load(&bridge->ports, vsi_idx);
+	if (!port) {
+		dev_info(dev, "Bridge port lookup failed (vsi=%u)\n", vsi_idx);
+		return ERR_PTR(-EINVAL);
+	}
+
+	vlan = xa_load(&port->vlans, vid);
+	if (!vlan) {
+		dev_info(dev, "Bridge port vlan metadata lookup failed (vsi=%u)\n",
+			 vsi_idx);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return vlan;
+}
+
 static void
 ice_eswitch_br_fdb_entry_delete(struct ice_esw_br *bridge,
 				struct ice_esw_br_fdb_entry *fdb_entry)
@@ -344,10 +389,33 @@ ice_eswitch_br_fdb_entry_create(struct net_device *netdev,
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_esw_br_fdb_entry *fdb_entry;
 	struct ice_esw_br_flow *flow;
+	struct ice_esw_br_vlan *vlan;
 	struct ice_hw *hw = &pf->hw;
+	bool add_vlan = false;
 	unsigned long event;
 	int err;
 
+	/* FIXME: untagged filtering is not yet supported
+	 */
+	if (!(bridge->flags & ICE_ESWITCH_BR_VLAN_FILTERING) && vid)
+		return;
+
+	/* In trunk VLAN mode, for untagged traffic the bridge sends requests
+	 * to offload VLAN 1 with pvid and untagged flags set. Since these
+	 * flags are not supported, add a MAC filter instead.
+	 */
+	if ((bridge->flags & ICE_ESWITCH_BR_VLAN_FILTERING) && vid != 1) {
+		vlan = ice_esw_br_port_vlan_lookup(bridge, br_port->vsi_idx,
+						   vid);
+		if (IS_ERR(vlan)) {
+			dev_err(dev, "Failed to find vlan lookup, err: %ld\n",
+				PTR_ERR(vlan));
+			return;
+		}
+
+		add_vlan = true;
+	}
+
 	fdb_entry = ice_eswitch_br_fdb_find(bridge, mac, vid);
 	if (fdb_entry)
 		ice_eswitch_br_fdb_entry_notify_and_cleanup(bridge, fdb_entry);
@@ -359,7 +427,7 @@ ice_eswitch_br_fdb_entry_create(struct net_device *netdev,
 	}
 
 	flow = ice_eswitch_br_flow_create(dev, hw, br_port->vsi_idx,
-					  br_port->type, mac);
+					  br_port->type, mac, add_vlan, vid);
 	if (IS_ERR(flow)) {
 		err = PTR_ERR(flow);
 		goto err_add_flow;
@@ -519,6 +587,214 @@ ice_eswitch_br_switchdev_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void ice_eswitch_br_fdb_flush(struct ice_esw_br *bridge)
+{
+	struct ice_esw_br_fdb_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list)
+		ice_eswitch_br_fdb_entry_notify_and_cleanup(bridge, entry);
+}
+
+static void
+ice_eswitch_br_vlan_filtering_set(struct ice_esw_br *bridge, bool enable)
+{
+	bool filtering = bridge->flags & ICE_ESWITCH_BR_VLAN_FILTERING;
+
+	if (filtering == enable)
+		return;
+
+	ice_eswitch_br_fdb_flush(bridge);
+	if (enable)
+		bridge->flags |= ICE_ESWITCH_BR_VLAN_FILTERING;
+	else
+		bridge->flags &= ~ICE_ESWITCH_BR_VLAN_FILTERING;
+}
+
+static void
+ice_eswitch_br_vlan_cleanup(struct ice_esw_br_port *port,
+			    struct ice_esw_br_vlan *vlan)
+{
+	xa_erase(&port->vlans, vlan->vid);
+	kfree(vlan);
+}
+
+static void ice_eswitch_br_port_vlans_flush(struct ice_esw_br_port *port)
+{
+	struct ice_esw_br_vlan *vlan;
+	unsigned long index;
+
+	xa_for_each(&port->vlans, index, vlan)
+		ice_eswitch_br_vlan_cleanup(port, vlan);
+}
+
+static struct ice_esw_br_vlan *
+ice_eswitch_br_vlan_create(u16 vid, u16 flags, struct ice_esw_br_port *port)
+{
+	struct ice_esw_br_vlan *vlan;
+	int err;
+
+	vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
+	if (!vlan)
+		return ERR_PTR(-ENOMEM);
+
+	vlan->vid = vid;
+	vlan->flags = flags;
+
+	err = xa_insert(&port->vlans, vlan->vid, vlan, GFP_KERNEL);
+	if (err) {
+		kfree(vlan);
+		return ERR_PTR(err);
+	}
+
+	return vlan;
+}
+
+static int
+ice_eswitch_br_port_vlan_add(struct ice_esw_br *bridge, u16 vsi_idx, u16 vid,
+			     u16 flags, struct netlink_ext_ack *extack)
+{
+	struct ice_esw_br_port *port;
+	struct ice_esw_br_vlan *vlan;
+
+	port = xa_load(&bridge->ports, vsi_idx);
+	if (!port)
+		return -EINVAL;
+
+	vlan = xa_load(&port->vlans, vid);
+	if (vlan) {
+		if (vlan->flags == flags)
+			return 0;
+
+		ice_eswitch_br_vlan_cleanup(port, vlan);
+	}
+
+	vlan = ice_eswitch_br_vlan_create(vid, flags, port);
+	if (IS_ERR(vlan)) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to create VLAN entry");
+		return PTR_ERR(vlan);
+	}
+
+	return 0;
+}
+
+static void
+ice_eswitch_br_port_vlan_del(struct ice_esw_br *bridge, u16 vsi_idx, u16 vid)
+{
+	struct ice_esw_br_port *port;
+	struct ice_esw_br_vlan *vlan;
+
+	port = xa_load(&bridge->ports, vsi_idx);
+	if (!port)
+		return;
+
+	vlan = xa_load(&port->vlans, vid);
+	if (!vlan)
+		return;
+
+	ice_eswitch_br_vlan_cleanup(port, vlan);
+}
+
+static int
+ice_eswitch_br_port_obj_add(struct net_device *netdev, const void *ctx,
+			    const struct switchdev_obj *obj,
+			    struct netlink_ext_ack *extack)
+{
+	struct ice_esw_br_port *br_port = ice_eswitch_br_netdev_to_port(netdev);
+	struct switchdev_obj_port_vlan *vlan;
+	int err;
+
+	if (!br_port)
+		return -EINVAL;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+		err = ice_eswitch_br_port_vlan_add(br_port->bridge,
+						   br_port->vsi_idx, vlan->vid,
+						   vlan->flags, extack);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int
+ice_eswitch_br_port_obj_del(struct net_device *netdev, const void *ctx,
+			    const struct switchdev_obj *obj)
+{
+	struct ice_esw_br_port *br_port = ice_eswitch_br_netdev_to_port(netdev);
+	struct switchdev_obj_port_vlan *vlan;
+
+	if (!br_port)
+		return -EINVAL;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+		ice_eswitch_br_port_vlan_del(br_port->bridge, br_port->vsi_idx,
+					     vlan->vid);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+ice_eswitch_br_port_obj_attr_set(struct net_device *netdev, const void *ctx,
+				 const struct switchdev_attr *attr,
+				 struct netlink_ext_ack *extack)
+{
+	struct ice_esw_br_port *br_port = ice_eswitch_br_netdev_to_port(netdev);
+
+	if (!br_port)
+		return -EINVAL;
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		ice_eswitch_br_vlan_filtering_set(br_port->bridge,
+						  attr->u.vlan_filtering);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+ice_eswitch_br_event_blocking(struct notifier_block *nb, unsigned long event,
+			      void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = switchdev_handle_port_obj_add(dev, ptr,
+						    ice_eswitch_br_is_dev_valid,
+						    ice_eswitch_br_port_obj_add);
+		break;
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = switchdev_handle_port_obj_del(dev, ptr,
+						    ice_eswitch_br_is_dev_valid,
+						    ice_eswitch_br_port_obj_del);
+		break;
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     ice_eswitch_br_is_dev_valid,
+						     ice_eswitch_br_port_obj_attr_set);
+		break;
+	default:
+		err = 0;
+	}
+
+	return notifier_from_errno(err);
+}
+
 static void
 ice_eswitch_br_port_deinit(struct ice_esw_br *bridge,
 			   struct ice_esw_br_port *br_port)
@@ -537,6 +813,7 @@ ice_eswitch_br_port_deinit(struct ice_esw_br *bridge,
 		vsi->vf->repr->br_port = NULL;
 
 	xa_erase(&bridge->ports, br_port->vsi_idx);
+	ice_eswitch_br_port_vlans_flush(br_port);
 	kfree(br_port);
 }
 
@@ -549,6 +826,8 @@ ice_eswitch_br_port_init(struct ice_esw_br *bridge)
 	if (!br_port)
 		return ERR_PTR(-ENOMEM);
 
+	xa_init(&br_port->vlans);
+
 	br_port->bridge = bridge;
 
 	return br_port;
@@ -852,6 +1131,7 @@ ice_eswitch_br_offloads_deinit(struct ice_pf *pf)
 		return;
 
 	unregister_netdevice_notifier(&br_offloads->netdev_nb);
+	unregister_switchdev_blocking_notifier(&br_offloads->switchdev_blk);
 	unregister_switchdev_notifier(&br_offloads->switchdev_nb);
 	destroy_workqueue(br_offloads->wq);
 	/* Although notifier block is unregistered just before,
@@ -895,6 +1175,15 @@ ice_eswitch_br_offloads_init(struct ice_pf *pf)
 		goto err_reg_switchdev_nb;
 	}
 
+	br_offloads->switchdev_blk.notifier_call =
+		ice_eswitch_br_event_blocking;
+	err = register_switchdev_blocking_notifier(&br_offloads->switchdev_blk);
+	if (err) {
+		dev_err(dev,
+			"Failed to register bridge blocking switchdev notifier\n");
+		goto err_reg_switchdev_blk;
+	}
+
 	br_offloads->netdev_nb.notifier_call = ice_eswitch_br_port_event;
 	err = register_netdevice_notifier(&br_offloads->netdev_nb);
 	if (err) {
@@ -906,6 +1195,8 @@ ice_eswitch_br_offloads_init(struct ice_pf *pf)
 	return 0;
 
 err_reg_netdev_nb:
+	unregister_switchdev_blocking_notifier(&br_offloads->switchdev_blk);
+err_reg_switchdev_blk:
 	unregister_switchdev_notifier(&br_offloads->switchdev_nb);
 err_reg_switchdev_nb:
 	destroy_workqueue(br_offloads->wq);
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
index 73ad81bad655..cf3e2615a62a 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
@@ -42,10 +42,16 @@ struct ice_esw_br_port {
 	enum ice_esw_br_port_type type;
 	struct ice_vsi *vsi;
 	u16 vsi_idx;
+	struct xarray vlans;
+};
+
+enum {
+	ICE_ESWITCH_BR_VLAN_FILTERING = BIT(0),
 };
 
 struct ice_esw_br {
 	struct ice_esw_br_offloads *br_offloads;
+	int flags;
 	int ifindex;
 
 	struct xarray ports;
@@ -57,6 +63,7 @@ struct ice_esw_br_offloads {
 	struct ice_pf *pf;
 	struct ice_esw_br *bridge;
 	struct notifier_block netdev_nb;
+	struct notifier_block switchdev_blk;
 	struct notifier_block switchdev_nb;
 
 	struct workqueue_struct *wq;
@@ -70,6 +77,11 @@ struct ice_esw_br_fdb_work {
 	unsigned long event;
 };
 
+struct ice_esw_br_vlan {
+	u16 vid;
+	u16 flags;
+};
+
 #define ice_nb_to_br_offloads(nb, nb_name) \
 	container_of(nb, \
 		     struct ice_esw_br_offloads, \
-- 
2.39.2

