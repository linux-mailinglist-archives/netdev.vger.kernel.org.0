Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7757691327
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 23:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjBIWVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 17:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIWVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 17:21:20 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F2212F14
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 14:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675981278; x=1707517278;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KeSWT5wEivWt5gPjUj8q+kjlhTHtq1f/vAKzBGL7ptw=;
  b=BK8SXzI5kUsV6bIbUbCn4rxDgEtk0ZxBnvTvwkNDGe1/9LO6PNSUMkdk
   pPU25EBxgX+o4kVH5W2F6HSK7QYjGTSNm2RTe2EGVXvDkZg+jsOEG3sn8
   ZqzlRAjxNhg4iA5oDSxOsDqisCdUIHZqML91hVYQBkoDzVSDG3YK9Vd25
   WryUIMZfsSOp/eSY2GIH5/5ySzRiIUhIG7TqMmRBOkpqtH8vdvNDN2XIY
   0UBpdtiyuYMU84l39lT56IawxkuXfqJgX31m8S1Iq314TVrfCz52yvM0J
   kF5CD1TsMg3hCktERinVG/phcr+UkFeC6pQuy2Q9olXBgpRcuGhuCM2P4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="394862435"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="394862435"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 14:21:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="996716519"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="996716519"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.1])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 14:20:57 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next] devlink: stop using NL_SET_ERR_MSG_MOD
Date:   Thu,  9 Feb 2023 14:20:45 -0800
Message-Id: <20230209222045.3832693-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f83
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NL_SET_ERR_MSG_MOD inserts the KBUILD_MODNAME and a ':' before the actual
extended error message. The devlink feature hasn't been able to be compiled
as a module since commit f4b6bcc7002f ("net: devlink: turn devlink into a
built-in").

Stop using NL_SET_ERR_MSG_MOD, and just use the base NL_SET_ERR_MSG. This
aligns the extended error messages better with the NL_SET_ERR_MSG_ATTR
messages as well.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
From [1] I think we can just stop using the _MOD version in devlink code
because its not a module. I haven't yet figured out a good way to handle
GENL_REQ_ATTR_CHECK so I've punted on that for now...

[1]: https://lore.kernel.org/netdev/68042dc7-0025-48bc-07e9-7051494ba2e5@intel.com/

 net/devlink/dev.c      |  20 +++----
 net/devlink/leftover.c | 115 ++++++++++++++++++++---------------------
 2 files changed, 65 insertions(+), 70 deletions(-)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 78d824eda5ec..7cf2de44e02f 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -305,7 +305,7 @@ static struct net *devlink_netns_get(struct sk_buff *skb,
 	struct net *net;
 
 	if (!!netns_pid_attr + !!netns_fd_attr + !!netns_id_attr > 1) {
-		NL_SET_ERR_MSG_MOD(info->extack, "multiple netns identifying attributes specified");
+		NL_SET_ERR_MSG(info->extack, "multiple netns identifying attributes specified");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -323,7 +323,7 @@ static struct net *devlink_netns_get(struct sk_buff *skb,
 		net = ERR_PTR(-EINVAL);
 	}
 	if (IS_ERR(net)) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Unknown network namespace");
+		NL_SET_ERR_MSG(info->extack, "Unknown network namespace");
 		return ERR_PTR(-EINVAL);
 	}
 	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
@@ -425,7 +425,7 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 
 	err = devlink_resources_validate(devlink, NULL, info);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(info->extack, "resources size validation failed");
+		NL_SET_ERR_MSG(info->extack, "resources size validation failed");
 		return err;
 	}
 
@@ -435,8 +435,7 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 		action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
 
 	if (!devlink_reload_action_is_supported(devlink, action)) {
-		NL_SET_ERR_MSG_MOD(info->extack,
-				   "Requested reload action is not supported by the driver");
+		NL_SET_ERR_MSG(info->extack, "Requested reload action is not supported by the driver");
 		return -EOPNOTSUPP;
 	}
 
@@ -448,7 +447,7 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 		limits = nla_get_bitfield32(info->attrs[DEVLINK_ATTR_RELOAD_LIMITS]);
 		limits_selected = limits.value & limits.selector;
 		if (!limits_selected) {
-			NL_SET_ERR_MSG_MOD(info->extack, "Invalid limit selected");
+			NL_SET_ERR_MSG(info->extack, "Invalid limit selected");
 			return -EINVAL;
 		}
 		for (limit = 0 ; limit <= DEVLINK_RELOAD_LIMIT_MAX ; limit++)
@@ -456,18 +455,15 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 				break;
 		/* UAPI enables multiselection, but currently it is not used */
 		if (limits_selected != BIT(limit)) {
-			NL_SET_ERR_MSG_MOD(info->extack,
-					   "Multiselection of limit is not supported");
+			NL_SET_ERR_MSG(info->extack, "Multiselection of limit is not supported");
 			return -EOPNOTSUPP;
 		}
 		if (!devlink_reload_limit_is_supported(devlink, limit)) {
-			NL_SET_ERR_MSG_MOD(info->extack,
-					   "Requested limit is not supported by the driver");
+			NL_SET_ERR_MSG(info->extack, "Requested limit is not supported by the driver");
 			return -EOPNOTSUPP;
 		}
 		if (devlink_reload_combination_is_invalid(action, limit)) {
-			NL_SET_ERR_MSG_MOD(info->extack,
-					   "Requested limit is invalid for this action");
+			NL_SET_ERR_MSG(info->extack, "Requested limit is invalid for this action");
 			return -EINVAL;
 		}
 	}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 9d6373603340..760bea94b834 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -810,13 +810,12 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
 	}
 	if (!devlink_port_fn_state_valid(state)) {
 		WARN_ON_ONCE(1);
-		NL_SET_ERR_MSG_MOD(extack, "Invalid state read from driver");
+		NL_SET_ERR_MSG(extack, "Invalid state read from driver");
 		return -EINVAL;
 	}
 	if (!devlink_port_fn_opstate_valid(opstate)) {
 		WARN_ON_ONCE(1);
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Invalid operational state read from driver");
+		NL_SET_ERR_MSG(extack, "Invalid operational state read from driver");
 		return -EINVAL;
 	}
 	if (nla_put_u8(msg, DEVLINK_PORT_FN_ATTR_STATE, state) ||
@@ -1171,16 +1170,16 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
 	hw_addr = nla_data(attr);
 	hw_addr_len = nla_len(attr);
 	if (hw_addr_len > MAX_ADDR_LEN) {
-		NL_SET_ERR_MSG_MOD(extack, "Port function hardware address too long");
+		NL_SET_ERR_MSG(extack, "Port function hardware address too long");
 		return -EINVAL;
 	}
 	if (port->type == DEVLINK_PORT_TYPE_ETH) {
 		if (hw_addr_len != ETH_ALEN) {
-			NL_SET_ERR_MSG_MOD(extack, "Address must be 6 bytes for Ethernet device");
+			NL_SET_ERR_MSG(extack, "Address must be 6 bytes for Ethernet device");
 			return -EINVAL;
 		}
 		if (!is_unicast_ether_addr(hw_addr)) {
-			NL_SET_ERR_MSG_MOD(extack, "Non-unicast hardware address unsupported");
+			NL_SET_ERR_MSG(extack, "Non-unicast hardware address unsupported");
 			return -EINVAL;
 		}
 	}
@@ -1256,7 +1255,7 @@ static int devlink_port_function_set(struct devlink_port *port,
 	err = nla_parse_nested(tb, DEVLINK_PORT_FUNCTION_ATTR_MAX, attr,
 			       devlink_function_nl_policy, extack);
 	if (err < 0) {
-		NL_SET_ERR_MSG_MOD(extack, "Fail to parse port function attributes");
+		NL_SET_ERR_MSG(extack, "Fail to parse port function attributes");
 		return err;
 	}
 
@@ -1335,14 +1334,14 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 	if (!devlink_port->attrs.splittable) {
 		/* Split ports cannot be split. */
 		if (devlink_port->attrs.split)
-			NL_SET_ERR_MSG_MOD(info->extack, "Port cannot be split further");
+			NL_SET_ERR_MSG(info->extack, "Port cannot be split further");
 		else
-			NL_SET_ERR_MSG_MOD(info->extack, "Port cannot be split");
+			NL_SET_ERR_MSG(info->extack, "Port cannot be split");
 		return -EINVAL;
 	}
 
 	if (count < 2 || !is_power_of_2(count) || count > devlink_port->attrs.lanes) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Invalid split count");
+		NL_SET_ERR_MSG(info->extack, "Invalid split count");
 		return -EINVAL;
 	}
 
@@ -1406,7 +1405,7 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 
 	if (!info->attrs[DEVLINK_ATTR_PORT_FLAVOUR] ||
 	    !info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
-		NL_SET_ERR_MSG_MOD(extack, "Port flavour or PCI PF are not specified");
+		NL_SET_ERR_MSG(extack, "Port flavour or PCI PF are not specified");
 		return -EINVAL;
 	}
 	new_attrs.flavour = nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_FLAVOUR]);
@@ -1454,7 +1453,7 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 		return -EOPNOTSUPP;
 
 	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_PORT_INDEX)) {
-		NL_SET_ERR_MSG_MOD(extack, "Port index is not specified");
+		NL_SET_ERR_MSG(extack, "Port index is not specified");
 		return -EINVAL;
 	}
 	port_index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
@@ -1496,13 +1495,13 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 			return -ENODEV;
 
 		if (parent == devlink_rate) {
-			NL_SET_ERR_MSG_MOD(info->extack, "Parent to self is not allowed");
+			NL_SET_ERR_MSG(info->extack, "Parent to self is not allowed");
 			return -EINVAL;
 		}
 
 		if (devlink_rate_is_node(devlink_rate) &&
 		    devlink_rate_is_parent_node(devlink_rate, parent->parent)) {
-			NL_SET_ERR_MSG_MOD(info->extack, "Node is already a parent of parent node.");
+			NL_SET_ERR_MSG(info->extack, "Node is already a parent of parent node.");
 			return -EEXIST;
 		}
 
@@ -1611,16 +1610,16 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 
 	if (type == DEVLINK_RATE_TYPE_LEAF) {
 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_leaf_tx_share_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the leafs");
+			NL_SET_ERR_MSG(info->extack, "TX share set isn't supported for the leafs");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_TX_MAX] && !ops->rate_leaf_tx_max_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the leafs");
+			NL_SET_ERR_MSG(info->extack, "TX max set isn't supported for the leafs");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] &&
 		    !ops->rate_leaf_parent_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the leafs");
+			NL_SET_ERR_MSG(info->extack, "Parent set isn't supported for the leafs");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_leaf_tx_priority_set) {
@@ -1637,16 +1636,16 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 		}
 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
+			NL_SET_ERR_MSG(info->extack, "TX share set isn't supported for the nodes");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_TX_MAX] && !ops->rate_node_tx_max_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the nodes");
+			NL_SET_ERR_MSG(info->extack, "TX max set isn't supported for the nodes");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] &&
 		    !ops->rate_node_parent_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the nodes");
+			NL_SET_ERR_MSG(info->extack, "Parent set isn't supported for the nodes");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_node_tx_priority_set) {
@@ -1697,7 +1696,7 @@ static int devlink_nl_cmd_rate_new_doit(struct sk_buff *skb,
 
 	ops = devlink->ops;
 	if (!ops || !ops->rate_node_new || !ops->rate_node_del) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Rate nodes aren't supported");
+		NL_SET_ERR_MSG(info->extack, "Rate nodes aren't supported");
 		return -EOPNOTSUPP;
 	}
 
@@ -1753,7 +1752,7 @@ static int devlink_nl_cmd_rate_del_doit(struct sk_buff *skb,
 	int err;
 
 	if (refcount_read(&rate_node->refcnt) > 1) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Node has children. Cannot delete node.");
+		NL_SET_ERR_MSG(info->extack, "Node has children. Cannot delete node.");
 		return -EBUSY;
 	}
 
@@ -1941,26 +1940,26 @@ static int devlink_linecard_type_set(struct devlink_linecard *linecard,
 
 	mutex_lock(&linecard->state_lock);
 	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING) {
-		NL_SET_ERR_MSG_MOD(extack, "Line card is currently being provisioned");
+		NL_SET_ERR_MSG(extack, "Line card is currently being provisioned");
 		err = -EBUSY;
 		goto out;
 	}
 	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONING) {
-		NL_SET_ERR_MSG_MOD(extack, "Line card is currently being unprovisioned");
+		NL_SET_ERR_MSG(extack, "Line card is currently being unprovisioned");
 		err = -EBUSY;
 		goto out;
 	}
 
 	linecard_type = devlink_linecard_type_lookup(linecard, type);
 	if (!linecard_type) {
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported line card type provided");
+		NL_SET_ERR_MSG(extack, "Unsupported line card type provided");
 		err = -EINVAL;
 		goto out;
 	}
 
 	if (linecard->state != DEVLINK_LINECARD_STATE_UNPROVISIONED &&
 	    linecard->state != DEVLINK_LINECARD_STATE_PROVISIONING_FAILED) {
-		NL_SET_ERR_MSG_MOD(extack, "Line card already provisioned");
+		NL_SET_ERR_MSG(extack, "Line card already provisioned");
 		err = -EBUSY;
 		/* Check if the line card is provisioned in the same
 		 * way the user asks. In case it is, make the operation
@@ -2004,12 +2003,12 @@ static int devlink_linecard_type_unset(struct devlink_linecard *linecard,
 
 	mutex_lock(&linecard->state_lock);
 	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING) {
-		NL_SET_ERR_MSG_MOD(extack, "Line card is currently being provisioned");
+		NL_SET_ERR_MSG(extack, "Line card is currently being provisioned");
 		err = -EBUSY;
 		goto out;
 	}
 	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONING) {
-		NL_SET_ERR_MSG_MOD(extack, "Line card is currently being unprovisioned");
+		NL_SET_ERR_MSG(extack, "Line card is currently being unprovisioned");
 		err = -EBUSY;
 		goto out;
 	}
@@ -2022,7 +2021,7 @@ static int devlink_linecard_type_unset(struct devlink_linecard *linecard,
 	}
 
 	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONED) {
-		NL_SET_ERR_MSG_MOD(extack, "Line card is not provisioned");
+		NL_SET_ERR_MSG(extack, "Line card is not provisioned");
 		err = 0;
 		goto out;
 	}
@@ -2846,7 +2845,7 @@ int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
 
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list)
 		if (devlink_rate_is_node(devlink_rate)) {
-			NL_SET_ERR_MSG_MOD(extack, "Rate node(s) exists.");
+			NL_SET_ERR_MSG(extack, "Rate node(s) exists.");
 			return -EBUSY;
 		}
 	return 0;
@@ -3612,18 +3611,18 @@ devlink_resource_validate_size(struct devlink_resource *resource, u64 size,
 	int err = 0;
 
 	if (size > resource->size_params.size_max) {
-		NL_SET_ERR_MSG_MOD(extack, "Size larger than maximum");
+		NL_SET_ERR_MSG(extack, "Size larger than maximum");
 		err = -EINVAL;
 	}
 
 	if (size < resource->size_params.size_min) {
-		NL_SET_ERR_MSG_MOD(extack, "Size smaller than minimum");
+		NL_SET_ERR_MSG(extack, "Size smaller than minimum");
 		err = -EINVAL;
 	}
 
 	div64_u64_rem(size, resource->size_params.size_granularity, &reminder);
 	if (reminder) {
-		NL_SET_ERR_MSG_MOD(extack, "Wrong granularity");
+		NL_SET_ERR_MSG(extack, "Wrong granularity");
 		err = -EINVAL;
 	}
 
@@ -4419,21 +4418,21 @@ static int devlink_nl_cmd_param_set_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 						struct netlink_callback *cb)
 {
-	NL_SET_ERR_MSG_MOD(cb->extack, "Port params are not supported");
+	NL_SET_ERR_MSG(cb->extack, "Port params are not supported");
 	return msg->len;
 }
 
 static int devlink_nl_cmd_port_param_get_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	NL_SET_ERR_MSG_MOD(info->extack, "Port params are not supported");
+	NL_SET_ERR_MSG(info->extack, "Port params are not supported");
 	return -EINVAL;
 }
 
 static int devlink_nl_cmd_port_param_set_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	NL_SET_ERR_MSG_MOD(info->extack, "Port params are not supported");
+	NL_SET_ERR_MSG(info->extack, "Port params are not supported");
 	return -EINVAL;
 }
 
@@ -5002,7 +5001,7 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 	int err;
 
 	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_REGION_NAME)) {
-		NL_SET_ERR_MSG_MOD(info->extack, "No region name provided");
+		NL_SET_ERR_MSG(info->extack, "No region name provided");
 		return -EINVAL;
 	}
 
@@ -5022,19 +5021,19 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 		region = devlink_region_get_by_name(devlink, region_name);
 
 	if (!region) {
-		NL_SET_ERR_MSG_MOD(info->extack, "The requested region does not exist");
+		NL_SET_ERR_MSG(info->extack, "The requested region does not exist");
 		return -EINVAL;
 	}
 
 	if (!region->ops->snapshot) {
-		NL_SET_ERR_MSG_MOD(info->extack, "The requested region does not support taking an immediate snapshot");
+		NL_SET_ERR_MSG(info->extack, "The requested region does not support taking an immediate snapshot");
 		return -EOPNOTSUPP;
 	}
 
 	mutex_lock(&region->snapshot_lock);
 
 	if (region->cur_snapshots == region->max_snapshots) {
-		NL_SET_ERR_MSG_MOD(info->extack, "The region has reached the maximum number of stored snapshots");
+		NL_SET_ERR_MSG(info->extack, "The region has reached the maximum number of stored snapshots");
 		err = -ENOSPC;
 		goto unlock;
 	}
@@ -5044,7 +5043,7 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 		snapshot_id = nla_get_u32(snapshot_id_attr);
 
 		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
-			NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
+			NL_SET_ERR_MSG(info->extack, "The requested snapshot id is already in use");
 			err = -EEXIST;
 			goto unlock;
 		}
@@ -5055,7 +5054,7 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 	} else {
 		err = __devlink_region_snapshot_id_get(devlink, &snapshot_id);
 		if (err) {
-			NL_SET_ERR_MSG_MOD(info->extack, "Failed to allocate a new snapshot id");
+			NL_SET_ERR_MSG(info->extack, "Failed to allocate a new snapshot id");
 			goto unlock;
 		}
 	}
@@ -6667,7 +6666,7 @@ devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 		state->dump_ts = reporter->dump_ts;
 	}
 	if (!reporter->dump_fmsg || state->dump_ts != reporter->dump_ts) {
-		NL_SET_ERR_MSG_MOD(cb->extack, "Dump trampled, please retry");
+		NL_SET_ERR_MSG(cb->extack, "Dump trampled, please retry");
 		err = -EAGAIN;
 		goto unlock;
 	}
@@ -7025,7 +7024,7 @@ static int devlink_nl_cmd_trap_get_doit(struct sk_buff *skb,
 
 	trap_item = devlink_trap_item_get_from_info(devlink, info);
 	if (!trap_item) {
-		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
+		NL_SET_ERR_MSG(extack, "Device did not register this trap");
 		return -ENOENT;
 	}
 
@@ -7088,7 +7087,7 @@ static int __devlink_trap_action_set(struct devlink *devlink,
 
 	if (trap_item->action != trap_action &&
 	    trap_item->trap->type != DEVLINK_TRAP_TYPE_DROP) {
-		NL_SET_ERR_MSG_MOD(extack, "Cannot change action of non-drop traps. Skipping");
+		NL_SET_ERR_MSG(extack, "Cannot change action of non-drop traps. Skipping");
 		return 0;
 	}
 
@@ -7114,7 +7113,7 @@ static int devlink_trap_action_set(struct devlink *devlink,
 
 	err = devlink_trap_action_get_from_info(info, &trap_action);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Invalid trap action");
+		NL_SET_ERR_MSG(info->extack, "Invalid trap action");
 		return -EINVAL;
 	}
 
@@ -7134,7 +7133,7 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
 
 	trap_item = devlink_trap_item_get_from_info(devlink, info);
 	if (!trap_item) {
-		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
+		NL_SET_ERR_MSG(extack, "Device did not register this trap");
 		return -ENOENT;
 	}
 
@@ -7236,7 +7235,7 @@ static int devlink_nl_cmd_trap_group_get_doit(struct sk_buff *skb,
 
 	group_item = devlink_trap_group_item_get_from_info(devlink, info);
 	if (!group_item) {
-		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap group");
+		NL_SET_ERR_MSG(extack, "Device did not register this trap group");
 		return -ENOENT;
 	}
 
@@ -7345,7 +7344,7 @@ devlink_trap_group_action_set(struct devlink *devlink,
 
 	err = devlink_trap_action_get_from_info(info, &trap_action);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Invalid trap action");
+		NL_SET_ERR_MSG(info->extack, "Invalid trap action");
 		return -EINVAL;
 	}
 
@@ -7379,7 +7378,7 @@ static int devlink_trap_group_set(struct devlink *devlink,
 	policer_id = nla_get_u32(attrs[DEVLINK_ATTR_TRAP_POLICER_ID]);
 	policer_item = devlink_trap_policer_item_lookup(devlink, policer_id);
 	if (policer_id && !policer_item) {
-		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
+		NL_SET_ERR_MSG(extack, "Device did not register this trap policer");
 		return -ENOENT;
 	}
 	policer = policer_item ? policer_item->policer : NULL;
@@ -7408,7 +7407,7 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 
 	group_item = devlink_trap_group_item_get_from_info(devlink, info);
 	if (!group_item) {
-		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap group");
+		NL_SET_ERR_MSG(extack, "Device did not register this trap group");
 		return -ENOENT;
 	}
 
@@ -7425,7 +7424,7 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 
 err_trap_group_set:
 	if (modified)
-		NL_SET_ERR_MSG_MOD(extack, "Trap group set failed, but some changes were committed already");
+		NL_SET_ERR_MSG(extack, "Trap group set failed, but some changes were committed already");
 	return err;
 }
 
@@ -7530,7 +7529,7 @@ static int devlink_nl_cmd_trap_policer_get_doit(struct sk_buff *skb,
 
 	policer_item = devlink_trap_policer_item_get_from_info(devlink, info);
 	if (!policer_item) {
-		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
+		NL_SET_ERR_MSG(extack, "Device did not register this trap policer");
 		return -ENOENT;
 	}
 
@@ -7605,22 +7604,22 @@ devlink_trap_policer_set(struct devlink *devlink,
 		burst = nla_get_u64(attrs[DEVLINK_ATTR_TRAP_POLICER_BURST]);
 
 	if (rate < policer_item->policer->min_rate) {
-		NL_SET_ERR_MSG_MOD(extack, "Policer rate lower than limit");
+		NL_SET_ERR_MSG(extack, "Policer rate lower than limit");
 		return -EINVAL;
 	}
 
 	if (rate > policer_item->policer->max_rate) {
-		NL_SET_ERR_MSG_MOD(extack, "Policer rate higher than limit");
+		NL_SET_ERR_MSG(extack, "Policer rate higher than limit");
 		return -EINVAL;
 	}
 
 	if (burst < policer_item->policer->min_burst) {
-		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
+		NL_SET_ERR_MSG(extack, "Policer burst size lower than limit");
 		return -EINVAL;
 	}
 
 	if (burst > policer_item->policer->max_burst) {
-		NL_SET_ERR_MSG_MOD(extack, "Policer burst size higher than limit");
+		NL_SET_ERR_MSG(extack, "Policer burst size higher than limit");
 		return -EINVAL;
 	}
 
@@ -7650,7 +7649,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 
 	policer_item = devlink_trap_policer_item_get_from_info(devlink, info);
 	if (!policer_item) {
-		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
+		NL_SET_ERR_MSG(extack, "Device did not register this trap policer");
 		return -ENOENT;
 	}
 
-- 
2.39.1.405.gd4c25cc71f83

