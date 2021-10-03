Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7242B420345
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhJCSOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231426AbhJCSOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 14:14:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81587619F8;
        Sun,  3 Oct 2021 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633284738;
        bh=7sc4F6Zvk1spJyzCjDZHUdgHbs9sYuSdzz4zu7zGOkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzzDqL2+aDianhLvoZqZRHRrfRCLDbrMvOXiqUFeb7rQXZpfBW/s2EwDaT8o9p3m7
         Zf6mPjGTuU2z0D1e69v7FSM9RB6GvdsUYk6nIKr34S/+I7YLwyyysrHxyMn8HHpDzz
         PIPtNBifTC8ZBSIeeii7wRtWcZiEJjzXn5dHiaZLAGFm2cJTlpPb53JUpHG2jfmx2q
         PFIbU9x1lfrL0bRqb0vosNolrDxzITsgl3uESi/Sm/y9ixzWVz9WOlWv7/YcnRRREJ
         FdPRzkOk6+ih3ZYoI04n0LJwNQaP/zsDesQiEM6dafDL+ygPiZ8C2VHXHYMFeTue9z
         HhWJ2E4nxq82g==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v2 3/5] devlink: Allow set specific ops callbacks dynamically
Date:   Sun,  3 Oct 2021 21:12:04 +0300
Message-Id: <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633284302.git.leonro@nvidia.com>
References: <cover.1633284302.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Introduce new devlink call to set specific ops callback during
device initialization phase after devlink_alloc() is already
called.

This allows us to set specific ops based on device property which
is not known at the beginning of driver initialization.

For the sake of simplicity, this API lacks any type of locking and
needs to be called before devlink_register() to make sure that no
parallel access to the ops is possible at this stage.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h |   1 +
 net/core/devlink.c    | 270 ++++++++++++++++++++++++++++--------------
 2 files changed, 180 insertions(+), 91 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ae03eb1c6cc9..320146d95fb8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1520,6 +1520,7 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 {
 	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
+void devlink_set_ops(struct devlink *devlink, const struct devlink_ops *ops);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_reload_enable(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4e484afeadea..25c2aa2b35cd 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -53,7 +53,7 @@ struct devlink {
 	struct list_head trap_list;
 	struct list_head trap_group_list;
 	struct list_head trap_policer_list;
-	const struct devlink_ops *ops;
+	struct devlink_ops ops;
 	struct xarray snapshot_ids;
 	struct devlink_dev_stats stats;
 	struct device *dev;
@@ -683,13 +683,13 @@ devlink_reload_combination_is_invalid(enum devlink_reload_action action,
 static bool
 devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
 {
-	return test_bit(action, &devlink->ops->reload_actions);
+	return test_bit(action, &devlink->ops.reload_actions);
 }
 
 static bool
 devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_limit limit)
 {
-	return test_bit(limit, &devlink->ops->reload_limits);
+	return test_bit(limit, &devlink->ops.reload_limits);
 }
 
 static int devlink_reload_stat_put(struct sk_buff *msg,
@@ -1036,7 +1036,7 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 	if (!function_attr)
 		return -EMSGSIZE;
 
-	ops = port->devlink->ops;
+	ops = &port->devlink->ops;
 	err = devlink_port_fn_hw_addr_fill(ops, port, msg, extack,
 					   &msg_updated);
 	if (err)
@@ -1384,14 +1384,13 @@ static int devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	int err;
 
-	if (!devlink_port->devlink->ops->port_type_set)
+	if (!devlink_port->devlink->ops.port_type_set)
 		return -EOPNOTSUPP;
 
 	if (port_type == devlink_port->type)
 		return 0;
 
-	err = devlink_port->devlink->ops->port_type_set(devlink_port,
-							port_type);
+	err = devlink_port->devlink->ops.port_type_set(devlink_port, port_type);
 	if (err)
 		return err;
 
@@ -1404,7 +1403,7 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
 					     const struct nlattr *attr,
 					     struct netlink_ext_ack *extack)
 {
-	const struct devlink_ops *ops = port->devlink->ops;
+	const struct devlink_ops *ops = &port->devlink->ops;
 	const u8 *hw_addr;
 	int hw_addr_len;
 
@@ -1442,7 +1441,7 @@ static int devlink_port_fn_state_set(struct devlink_port *port,
 	const struct devlink_ops *ops;
 
 	state = nla_get_u8(attr);
-	ops = port->devlink->ops;
+	ops = &port->devlink->ops;
 	if (!ops->port_fn_state_set) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Function does not support state setting");
@@ -1515,9 +1514,9 @@ static int devlink_port_split(struct devlink *devlink, u32 port_index,
 			      u32 count, struct netlink_ext_ack *extack)
 
 {
-	if (devlink->ops->port_split)
-		return devlink->ops->port_split(devlink, port_index, count,
-						extack);
+	if (devlink->ops.port_split)
+		return devlink->ops.port_split(devlink, port_index, count,
+					       extack);
 	return -EOPNOTSUPP;
 }
 
@@ -1561,8 +1560,8 @@ static int devlink_port_unsplit(struct devlink *devlink, u32 port_index,
 				struct netlink_ext_ack *extack)
 
 {
-	if (devlink->ops->port_unsplit)
-		return devlink->ops->port_unsplit(devlink, port_index, extack);
+	if (devlink->ops.port_unsplit)
+		return devlink->ops.port_unsplit(devlink, port_index, extack);
 	return -EOPNOTSUPP;
 }
 
@@ -1622,7 +1621,7 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 	unsigned int new_port_index;
 	int err;
 
-	if (!devlink->ops->port_new || !devlink->ops->port_del)
+	if (!devlink->ops.port_new || !devlink->ops.port_del)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[DEVLINK_ATTR_PORT_FLAVOUR] ||
@@ -1651,15 +1650,15 @@ static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
 		new_attrs.sfnum_valid = true;
 	}
 
-	err = devlink->ops->port_new(devlink, &new_attrs, extack,
-				     &new_port_index);
+	err = devlink->ops.port_new(devlink, &new_attrs, extack,
+				    &new_port_index);
 	if (err)
 		return err;
 
 	err = devlink_port_new_notifiy(devlink, new_port_index, info);
 	if (err && err != -ENODEV) {
 		/* Fail to send the response; destroy newly created port. */
-		devlink->ops->port_del(devlink, new_port_index, extack);
+		devlink->ops.port_del(devlink, new_port_index, extack);
 	}
 	return err;
 }
@@ -1671,7 +1670,7 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 	struct devlink *devlink = info->user_ptr[0];
 	unsigned int port_index;
 
-	if (!devlink->ops->port_del)
+	if (!devlink->ops.port_del)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
@@ -1680,7 +1679,7 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 	}
 	port_index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
 
-	return devlink->ops->port_del(devlink, port_index, extack);
+	return devlink->ops.port_del(devlink, port_index, extack);
 }
 
 static int
@@ -1690,7 +1689,7 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 {
 	struct devlink *devlink = devlink_rate->devlink;
 	const char *parent_name = nla_data(nla_parent);
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 	size_t len = strlen(parent_name);
 	struct devlink_rate *parent;
 	int err = -EOPNOTSUPP;
@@ -1839,7 +1838,7 @@ static int devlink_nl_cmd_rate_set_doit(struct sk_buff *skb,
 {
 	struct devlink_rate *devlink_rate = info->user_ptr[1];
 	struct devlink *devlink = devlink_rate->devlink;
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 	int err;
 
 	if (!ops || !devlink_rate_set_ops_supported(ops, info, devlink_rate->type))
@@ -1860,7 +1859,7 @@ static int devlink_nl_cmd_rate_new_doit(struct sk_buff *skb,
 	const struct devlink_ops *ops;
 	int err;
 
-	ops = devlink->ops;
+	ops = &devlink->ops;
 	if (!ops || !ops->rate_node_new || !ops->rate_node_del) {
 		NL_SET_ERR_MSG_MOD(info->extack, "Rate nodes aren't supported");
 		return -EOPNOTSUPP;
@@ -1914,7 +1913,7 @@ static int devlink_nl_cmd_rate_del_doit(struct sk_buff *skb,
 {
 	struct devlink_rate *rate_node = info->user_ptr[1];
 	struct devlink *devlink = rate_node->devlink;
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 	int err;
 
 	if (refcount_read(&rate_node->refcnt) > 1) {
@@ -2053,8 +2052,8 @@ static int devlink_nl_sb_pool_fill(struct sk_buff *msg, struct devlink *devlink,
 	void *hdr;
 	int err;
 
-	err = devlink->ops->sb_pool_get(devlink, devlink_sb->index,
-					pool_index, &pool_info);
+	err = devlink->ops.sb_pool_get(devlink, devlink_sb->index, pool_index,
+				       &pool_info);
 	if (err)
 		return err;
 
@@ -2105,7 +2104,7 @@ static int devlink_nl_cmd_sb_pool_get_doit(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if (!devlink->ops->sb_pool_get)
+	if (!devlink->ops.sb_pool_get)
 		return -EOPNOTSUPP;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -2165,7 +2164,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 			continue;
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
-		    !devlink->ops->sb_pool_get)
+		    !devlink->ops.sb_pool_get)
 			goto retry;
 
 		mutex_lock(&devlink->lock);
@@ -2202,7 +2201,7 @@ static int devlink_sb_pool_set(struct devlink *devlink, unsigned int sb_index,
 			       struct netlink_ext_ack *extack)
 
 {
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 
 	if (ops->sb_pool_set)
 		return ops->sb_pool_set(devlink, sb_index, pool_index,
@@ -2250,7 +2249,7 @@ static int devlink_nl_sb_port_pool_fill(struct sk_buff *msg,
 					enum devlink_command cmd,
 					u32 portid, u32 seq, int flags)
 {
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 	u32 threshold;
 	void *hdr;
 	int err;
@@ -2320,7 +2319,7 @@ static int devlink_nl_cmd_sb_port_pool_get_doit(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if (!devlink->ops->sb_port_pool_get)
+	if (!devlink->ops.sb_port_pool_get)
 		return -EOPNOTSUPP;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -2386,7 +2385,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 			continue;
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
-		    !devlink->ops->sb_port_pool_get)
+		    !devlink->ops.sb_port_pool_get)
 			goto retry;
 
 		mutex_lock(&devlink->lock);
@@ -2423,7 +2422,7 @@ static int devlink_sb_port_pool_set(struct devlink_port *devlink_port,
 				    struct netlink_ext_ack *extack)
 
 {
-	const struct devlink_ops *ops = devlink_port->devlink->ops;
+	const struct devlink_ops *ops = &devlink_port->devlink->ops;
 
 	if (ops->sb_port_pool_set)
 		return ops->sb_port_pool_set(devlink_port, sb_index,
@@ -2466,7 +2465,7 @@ devlink_nl_sb_tc_pool_bind_fill(struct sk_buff *msg, struct devlink *devlink,
 				enum devlink_command cmd,
 				u32 portid, u32 seq, int flags)
 {
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 	u16 pool_index;
 	u32 threshold;
 	void *hdr;
@@ -2547,7 +2546,7 @@ static int devlink_nl_cmd_sb_tc_pool_bind_get_doit(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if (!devlink->ops->sb_tc_pool_bind_get)
+	if (!devlink->ops.sb_tc_pool_bind_get)
 		return -EOPNOTSUPP;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -2635,7 +2634,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 			continue;
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
-		    !devlink->ops->sb_tc_pool_bind_get)
+		    !devlink->ops.sb_tc_pool_bind_get)
 			goto retry;
 
 		mutex_lock(&devlink->lock);
@@ -2674,7 +2673,7 @@ static int devlink_sb_tc_pool_bind_set(struct devlink_port *devlink_port,
 				       struct netlink_ext_ack *extack)
 
 {
-	const struct devlink_ops *ops = devlink_port->devlink->ops;
+	const struct devlink_ops *ops = &devlink_port->devlink->ops;
 
 	if (ops->sb_tc_pool_bind_set)
 		return ops->sb_tc_pool_bind_set(devlink_port, sb_index,
@@ -2726,7 +2725,7 @@ static int devlink_nl_cmd_sb_occ_snapshot_doit(struct sk_buff *skb,
 					       struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 	struct devlink_sb *devlink_sb;
 
 	devlink_sb = devlink_sb_get_from_info(devlink, info);
@@ -2742,7 +2741,7 @@ static int devlink_nl_cmd_sb_occ_max_clear_doit(struct sk_buff *skb,
 						struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 	struct devlink_sb *devlink_sb;
 
 	devlink_sb = devlink_sb_get_from_info(devlink, info);
@@ -2758,7 +2757,7 @@ static int devlink_nl_eswitch_fill(struct sk_buff *msg, struct devlink *devlink,
 				   enum devlink_command cmd, u32 portid,
 				   u32 seq, int flags)
 {
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 	enum devlink_eswitch_encap_mode encap_mode;
 	u8 inline_mode;
 	void *hdr;
@@ -2852,7 +2851,7 @@ static int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb,
 					   struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 	enum devlink_eswitch_encap_mode encap_mode;
 	u8 inline_mode;
 	int err = 0;
@@ -4042,14 +4041,16 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 
 	curr_net = devlink_net(devlink);
 	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
-	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
+	err = devlink->ops.reload_down(devlink, !!dest_net, action, limit,
+				       extack);
 	if (err)
 		return err;
 
 	if (dest_net && !net_eq(dest_net, curr_net))
 		write_pnet(&devlink->_net, dest_net);
 
-	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
+	err = devlink->ops.reload_up(devlink, action, limit, actions_performed,
+				     extack);
 	devlink_reload_failed_set(devlink, !!err);
 	if (err)
 		return err;
@@ -4104,7 +4105,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	u32 actions_performed;
 	int err;
 
-	if (!devlink_reload_supported(devlink->ops))
+	if (!devlink_reload_supported(&devlink->ops))
 		return -EOPNOTSUPP;
 
 	err = devlink_resources_validate(devlink, NULL, info);
@@ -4314,13 +4315,13 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	u32 supported_params;
 	int ret;
 
-	if (!devlink->ops->flash_update)
+	if (!devlink->ops.flash_update)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME])
 		return -EINVAL;
 
-	supported_params = devlink->ops->supported_flash_update_params;
+	supported_params = devlink->ops.supported_flash_update_params;
 
 	nla_component = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
 	if (nla_component) {
@@ -4354,7 +4355,7 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	}
 
 	devlink_flash_update_begin_notify(devlink);
-	ret = devlink->ops->flash_update(devlink, &params, info->extack);
+	ret = devlink->ops.flash_update(devlink, &params, info->extack);
 	devlink_flash_update_end_notify(devlink);
 
 	release_firmware(params.fw);
@@ -6055,7 +6056,7 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		goto err_cancel_msg;
 
 	req.msg = msg;
-	err = devlink->ops->info_get(devlink, &req, extack);
+	err = devlink->ops.info_get(devlink, &req, extack);
 	if (err)
 		goto err_cancel_msg;
 
@@ -6074,7 +6075,7 @@ static int devlink_nl_cmd_info_get_doit(struct sk_buff *skb,
 	struct sk_buff *msg;
 	int err;
 
-	if (!devlink->ops->info_get)
+	if (!devlink->ops.info_get)
 		return -EOPNOTSUPP;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -6109,7 +6110,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		if (idx < start || !devlink->ops->info_get)
+		if (idx < start || !devlink->ops.info_get)
 			goto inc;
 
 		mutex_lock(&devlink->lock);
@@ -7746,10 +7747,10 @@ static int devlink_trap_stats_put(struct sk_buff *msg, struct devlink *devlink,
 	u64 drops = 0;
 	int err;
 
-	if (devlink->ops->trap_drop_counter_get) {
-		err = devlink->ops->trap_drop_counter_get(devlink,
-							  trap_item->trap,
-							  &drops);
+	if (devlink->ops.trap_drop_counter_get) {
+		err = devlink->ops.trap_drop_counter_get(devlink,
+							 trap_item->trap,
+							 &drops);
 		if (err)
 			return err;
 	}
@@ -7760,7 +7761,7 @@ static int devlink_trap_stats_put(struct sk_buff *msg, struct devlink *devlink,
 	if (!attr)
 		return -EMSGSIZE;
 
-	if (devlink->ops->trap_drop_counter_get &&
+	if (devlink->ops.trap_drop_counter_get &&
 	    nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
 			      DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
@@ -7927,8 +7928,8 @@ static int __devlink_trap_action_set(struct devlink *devlink,
 		return 0;
 	}
 
-	err = devlink->ops->trap_action_set(devlink, trap_item->trap,
-					    trap_action, extack);
+	err = devlink->ops.trap_action_set(devlink, trap_item->trap,
+					   trap_action, extack);
 	if (err)
 		return err;
 
@@ -8152,9 +8153,11 @@ __devlink_trap_group_action_set(struct devlink *devlink,
 	struct devlink_trap_item *trap_item;
 	int err;
 
-	if (devlink->ops->trap_group_action_set) {
-		err = devlink->ops->trap_group_action_set(devlink, group_item->group,
-							  trap_action, extack);
+	if (devlink->ops.trap_group_action_set) {
+		err = devlink->ops.trap_group_action_set(devlink,
+							 group_item->group,
+							 trap_action,
+							 extack);
 		if (err)
 			return err;
 
@@ -8222,7 +8225,7 @@ static int devlink_trap_group_set(struct devlink *devlink,
 	if (!attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
 		return 0;
 
-	if (!devlink->ops->trap_group_set)
+	if (!devlink->ops.trap_group_set)
 		return -EOPNOTSUPP;
 
 	policer_item = group_item->policer_item;
@@ -8239,8 +8242,8 @@ static int devlink_trap_group_set(struct devlink *devlink,
 	}
 	policer = policer_item ? policer_item->policer : NULL;
 
-	err = devlink->ops->trap_group_set(devlink, group_item->group, policer,
-					   extack);
+	err = devlink->ops.trap_group_set(devlink, group_item->group, policer,
+					  extack);
 	if (err)
 		return err;
 
@@ -8305,10 +8308,10 @@ devlink_trap_policer_stats_put(struct sk_buff *msg, struct devlink *devlink,
 	u64 drops;
 	int err;
 
-	if (!devlink->ops->trap_policer_counter_get)
+	if (!devlink->ops.trap_policer_counter_get)
 		return 0;
 
-	err = devlink->ops->trap_policer_counter_get(devlink, policer, &drops);
+	err = devlink->ops.trap_policer_counter_get(devlink, policer, &drops);
 	if (err)
 		return err;
 
@@ -8495,8 +8498,8 @@ devlink_trap_policer_set(struct devlink *devlink,
 		return -EINVAL;
 	}
 
-	err = devlink->ops->trap_policer_set(devlink, policer_item->policer,
-					     rate, burst, info->extack);
+	err = devlink->ops.trap_policer_set(devlink, policer_item->policer,
+					    rate, burst, info->extack);
 	if (err)
 		return err;
 
@@ -8516,7 +8519,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	if (list_empty(&devlink->trap_policer_list))
 		return -EOPNOTSUPP;
 
-	if (!devlink->ops->trap_policer_set)
+	if (!devlink->ops.trap_policer_set)
 		return -EOPNOTSUPP;
 
 	policer_item = devlink_trap_policer_item_get_from_info(devlink, info);
@@ -8987,6 +8990,92 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
 	return true;
 }
 
+/**
+ *	devlink_set_ops - Set devlink ops dynamically
+ *
+ *	@devlink: devlink
+ *	@ops: devlink ops to set
+ *
+ *	This interface allows us to set ops based on device property
+ *	which is known after devlink_alloc() was already called.
+ *
+ *	This call sets fields that are not initialized yet and ignores
+ *	already set fields.
+ *
+ *	It should be called before devlink_register(), so doesn't have any
+ *	protection from concurent access.
+ */
+void devlink_set_ops(struct devlink *devlink, const struct devlink_ops *ops)
+{
+	struct devlink_ops *dev_ops = &devlink->ops;
+
+	WARN_ON(!devlink_reload_actions_valid(ops));
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
+#define SET_DEVICE_OP(ptr, op, name)                                           \
+	do {                                                                   \
+		if ((op)->name)                                                \
+			if (!((ptr)->name))                                    \
+				(ptr)->name = (op)->name;                      \
+	} while (0)
+
+	/* Keep sorte alphabetically for readability */
+	SET_DEVICE_OP(dev_ops, ops, eswitch_encap_mode_get);
+	SET_DEVICE_OP(dev_ops, ops, eswitch_encap_mode_set);
+	SET_DEVICE_OP(dev_ops, ops, eswitch_inline_mode_get);
+	SET_DEVICE_OP(dev_ops, ops, eswitch_inline_mode_set);
+	SET_DEVICE_OP(dev_ops, ops, eswitch_mode_get);
+	SET_DEVICE_OP(dev_ops, ops, eswitch_mode_set);
+	SET_DEVICE_OP(dev_ops, ops, flash_update);
+	SET_DEVICE_OP(dev_ops, ops, info_get);
+	SET_DEVICE_OP(dev_ops, ops, port_del);
+	SET_DEVICE_OP(dev_ops, ops, port_fn_state_get);
+	SET_DEVICE_OP(dev_ops, ops, port_fn_state_set);
+	SET_DEVICE_OP(dev_ops, ops, port_function_hw_addr_get);
+	SET_DEVICE_OP(dev_ops, ops, port_function_hw_addr_set);
+	SET_DEVICE_OP(dev_ops, ops, port_new);
+	SET_DEVICE_OP(dev_ops, ops, port_split);
+	SET_DEVICE_OP(dev_ops, ops, port_type_set);
+	SET_DEVICE_OP(dev_ops, ops, port_unsplit);
+	SET_DEVICE_OP(dev_ops, ops, rate_leaf_parent_set);
+	SET_DEVICE_OP(dev_ops, ops, rate_leaf_tx_max_set);
+	SET_DEVICE_OP(dev_ops, ops, rate_leaf_tx_share_set);
+	SET_DEVICE_OP(dev_ops, ops, rate_node_del);
+	SET_DEVICE_OP(dev_ops, ops, rate_node_new);
+	SET_DEVICE_OP(dev_ops, ops, rate_node_parent_set);
+	SET_DEVICE_OP(dev_ops, ops, rate_node_tx_max_set);
+	SET_DEVICE_OP(dev_ops, ops, rate_node_tx_share_set);
+	SET_DEVICE_OP(dev_ops, ops, reload_actions);
+	SET_DEVICE_OP(dev_ops, ops, reload_down);
+	SET_DEVICE_OP(dev_ops, ops, reload_limits);
+	SET_DEVICE_OP(dev_ops, ops, reload_up);
+	SET_DEVICE_OP(dev_ops, ops, sb_occ_max_clear);
+	SET_DEVICE_OP(dev_ops, ops, sb_occ_port_pool_get);
+	SET_DEVICE_OP(dev_ops, ops, sb_occ_snapshot);
+	SET_DEVICE_OP(dev_ops, ops, sb_occ_tc_port_bind_get);
+	SET_DEVICE_OP(dev_ops, ops, sb_pool_get);
+	SET_DEVICE_OP(dev_ops, ops, sb_pool_set);
+	SET_DEVICE_OP(dev_ops, ops, sb_port_pool_get);
+	SET_DEVICE_OP(dev_ops, ops, sb_port_pool_set);
+	SET_DEVICE_OP(dev_ops, ops, sb_tc_pool_bind_get);
+	SET_DEVICE_OP(dev_ops, ops, sb_tc_pool_bind_set);
+	SET_DEVICE_OP(dev_ops, ops, supported_flash_update_params);
+	SET_DEVICE_OP(dev_ops, ops, trap_action_set);
+	SET_DEVICE_OP(dev_ops, ops, trap_drop_counter_get);
+	SET_DEVICE_OP(dev_ops, ops, trap_fini);
+	SET_DEVICE_OP(dev_ops, ops, trap_group_action_set);
+	SET_DEVICE_OP(dev_ops, ops, trap_group_init);
+	SET_DEVICE_OP(dev_ops, ops, trap_group_set);
+	SET_DEVICE_OP(dev_ops, ops, trap_init);
+	SET_DEVICE_OP(dev_ops, ops, trap_policer_counter_get);
+	SET_DEVICE_OP(dev_ops, ops, trap_policer_fini);
+	SET_DEVICE_OP(dev_ops, ops, trap_policer_init);
+	SET_DEVICE_OP(dev_ops, ops, trap_policer_set);
+
+#undef SET_DEVICE_OP
+}
+EXPORT_SYMBOL_GPL(devlink_set_ops);
+
 /**
  *	devlink_alloc_ns - Allocate new devlink instance resources
  *	in specific namespace
@@ -9008,8 +9097,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	int ret;
 
 	WARN_ON(!ops || !dev);
-	if (!devlink_reload_actions_valid(ops))
-		return NULL;
 
 	devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
 	if (!devlink)
@@ -9023,7 +9110,8 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	}
 
 	devlink->dev = dev;
-	devlink->ops = ops;
+
+	devlink_set_ops(devlink, ops);
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	write_pnet(&devlink->_net, net);
 	INIT_LIST_HEAD(&devlink->port_list);
@@ -9157,7 +9245,7 @@ void devlink_unregister(struct devlink *devlink)
 	wait_for_completion(&devlink->comp);
 
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink_reload_supported(devlink->ops) &&
+	WARN_ON(devlink_reload_supported(&devlink->ops) &&
 		devlink->reload_enabled);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
@@ -9616,7 +9704,7 @@ EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
 void devlink_rate_nodes_destroy(struct devlink *devlink)
 {
 	static struct devlink_rate *devlink_rate, *tmp;
-	const struct devlink_ops *ops = devlink->ops;
+	const struct devlink_ops *ops = &devlink->ops;
 
 	mutex_lock(&devlink->lock);
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
@@ -10315,7 +10403,7 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
-	if (!devlink_reload_supported(devlink->ops))
+	if (!devlink_reload_supported(&devlink->ops))
 		return -EOPNOTSUPP;
 
 	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
@@ -10901,7 +10989,7 @@ devlink_trap_register(struct devlink *devlink,
 	if (err)
 		goto err_group_link;
 
-	err = devlink->ops->trap_init(devlink, trap, trap_item);
+	err = devlink->ops.trap_init(devlink, trap, trap_item);
 	if (err)
 		goto err_trap_init;
 
@@ -10929,8 +11017,8 @@ static void devlink_trap_unregister(struct devlink *devlink,
 
 	devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_DEL);
 	list_del(&trap_item->list);
-	if (devlink->ops->trap_fini)
-		devlink->ops->trap_fini(devlink, trap, trap_item);
+	if (devlink->ops.trap_fini)
+		devlink->ops.trap_fini(devlink, trap, trap_item);
 	free_percpu(trap_item->stats);
 	kfree(trap_item);
 }
@@ -10944,8 +11032,8 @@ static void devlink_trap_disable(struct devlink *devlink,
 	if (WARN_ON_ONCE(!trap_item))
 		return;
 
-	devlink->ops->trap_action_set(devlink, trap, DEVLINK_TRAP_ACTION_DROP,
-				      NULL);
+	devlink->ops.trap_action_set(devlink, trap, DEVLINK_TRAP_ACTION_DROP,
+				     NULL);
 	trap_item->action = DEVLINK_TRAP_ACTION_DROP;
 }
 
@@ -10964,7 +11052,7 @@ int devlink_traps_register(struct devlink *devlink,
 {
 	int i, err;
 
-	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
+	if (!devlink->ops.trap_init || !devlink->ops.trap_action_set)
 		return -EINVAL;
 
 	mutex_lock(&devlink->lock);
@@ -11134,8 +11222,8 @@ devlink_trap_group_register(struct devlink *devlink,
 	if (err)
 		goto err_policer_link;
 
-	if (devlink->ops->trap_group_init) {
-		err = devlink->ops->trap_group_init(devlink, group);
+	if (devlink->ops.trap_group_init) {
+		err = devlink->ops.trap_group_init(devlink, group);
 		if (err)
 			goto err_group_init;
 	}
@@ -11275,8 +11363,8 @@ devlink_trap_policer_register(struct devlink *devlink,
 	policer_item->rate = policer->init_rate;
 	policer_item->burst = policer->init_burst;
 
-	if (devlink->ops->trap_policer_init) {
-		err = devlink->ops->trap_policer_init(devlink, policer);
+	if (devlink->ops.trap_policer_init) {
+		err = devlink->ops.trap_policer_init(devlink, policer);
 		if (err)
 			goto err_policer_init;
 	}
@@ -11305,8 +11393,8 @@ devlink_trap_policer_unregister(struct devlink *devlink,
 	devlink_trap_policer_notify(devlink, policer_item,
 				    DEVLINK_CMD_TRAP_POLICER_DEL);
 	list_del(&policer_item->list);
-	if (devlink->ops->trap_policer_fini)
-		devlink->ops->trap_policer_fini(devlink, policer);
+	if (devlink->ops.trap_policer_fini)
+		devlink->ops.trap_policer_fini(devlink, policer);
 	kfree(policer_item);
 }
 
@@ -11386,7 +11474,7 @@ static void __devlink_compat_running_version(struct devlink *devlink,
 		return;
 
 	req.msg = msg;
-	err = devlink->ops->info_get(devlink, &req, NULL);
+	err = devlink->ops.info_get(devlink, &req, NULL);
 	if (err)
 		goto free_msg;
 
@@ -11418,7 +11506,7 @@ void devlink_compat_running_version(struct net_device *dev,
 	rtnl_unlock();
 
 	devlink = netdev_to_devlink(dev);
-	if (!devlink || !devlink->ops->info_get)
+	if (!devlink || !devlink->ops.info_get)
 		goto out;
 
 	mutex_lock(&devlink->lock);
@@ -11440,7 +11528,7 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 	rtnl_unlock();
 
 	devlink = netdev_to_devlink(dev);
-	if (!devlink || !devlink->ops->flash_update) {
+	if (!devlink || !devlink->ops.flash_update) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -11451,7 +11539,7 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 
 	mutex_lock(&devlink->lock);
 	devlink_flash_update_begin_notify(devlink);
-	ret = devlink->ops->flash_update(devlink, &params, NULL);
+	ret = devlink->ops.flash_update(devlink, &params, NULL);
 	devlink_flash_update_end_notify(devlink);
 	mutex_unlock(&devlink->lock);
 
@@ -11518,7 +11606,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		if (!net_eq(devlink_net(devlink), net))
 			goto retry;
 
-		WARN_ON(!devlink_reload_supported(devlink->ops));
+		WARN_ON(!devlink_reload_supported(&devlink->ops));
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 				     DEVLINK_RELOAD_LIMIT_UNSPEC,
-- 
2.31.1

