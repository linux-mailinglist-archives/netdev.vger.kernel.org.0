Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2954F3E3A0B
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 13:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhHHLl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 07:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhHHLlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 07:41:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8A1161055;
        Sun,  8 Aug 2021 11:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628422886;
        bh=g7YPEs4kPsZM/2lvYeRL5dCNCIsahRGJrYW8WDzemQ8=;
        h=From:To:Cc:Subject:Date:From;
        b=TgoQgjc+JqpGgcf/q+r5+W9bP2PD/0rZo1uLiUS8ki799JEpIRrgcRp1a7cAGmYi5
         D4Hf4yAGb2SW6AX14aXkCL3fJpCRMjH8QkK6e9x2EQOR14gd8W32aEMWzJwrIVW6Ga
         r6GEi+3IsaQsL0EaGfLAl5JuhSOteiRttB4q8JvnyLGjCTMfguJIxH5Q9liQujQAiW
         0Wtkm87NlTepInHLO/bGvwWuTE7NoUMvFWt/dG2JmX8a+VnsRhTfsR6tWOlahFvCvD
         vX+3xACPkaYLzFnd2jEgc74+vG4loXJlr5N6LJKMF/nR+HgCpCqYYc490Oe0MA+d/m
         VqLYc+B1eqGTw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next] devlink: Simplify devlink port API calls
Date:   Sun,  8 Aug 2021 14:41:21 +0300
Message-Id: <c9f15f122181f05f09fffd2380365b9925dd6427.1628422645.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink port already has pointer to the devlink instance and all API
calls that forward these devlink ports to the drivers perform same
"devlink_port->devlink" assignment before actual call.

This patch removes useless parameter and allows us in the future
to create specific devlink_port_ops to manage user space access with
reliable ops assignment.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 10 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  6 +-
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |  8 +-
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  4 +-
 include/net/devlink.h                         | 12 +--
 net/core/devlink.c                            | 95 +++++++++----------
 6 files changed, 64 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 97e6cb6f13c1..2b90388ef209 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1889,8 +1889,7 @@ is_port_function_supported(struct mlx5_eswitch *esw, u16 vport_num)
 	       mlx5_esw_is_sf_vport(esw, vport_num);
 }
 
-int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
-					   struct devlink_port *port,
+int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 					   u8 *hw_addr, int *hw_addr_len,
 					   struct netlink_ext_ack *extack)
 {
@@ -1899,7 +1898,7 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
 	int err = -EOPNOTSUPP;
 	u16 vport_num;
 
-	esw = mlx5_devlink_eswitch_get(devlink);
+	esw = mlx5_devlink_eswitch_get(port->devlink);
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
@@ -1923,8 +1922,7 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
 	return err;
 }
 
-int mlx5_devlink_port_function_hw_addr_set(struct devlink *devlink,
-					   struct devlink_port *port,
+int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 					   const u8 *hw_addr, int hw_addr_len,
 					   struct netlink_ext_ack *extack)
 {
@@ -1933,7 +1931,7 @@ int mlx5_devlink_port_function_hw_addr_set(struct devlink *devlink,
 	int err = -EOPNOTSUPP;
 	u16 vport_num;
 
-	esw = mlx5_devlink_eswitch_get(devlink);
+	esw = mlx5_devlink_eswitch_get(port->devlink);
 	if (IS_ERR(esw)) {
 		NL_SET_ERR_MSG_MOD(extack, "Eswitch doesn't support set hw_addr");
 		return PTR_ERR(esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index d562edf5b0bc..41eff9dd1bf6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -475,12 +475,10 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 					struct netlink_ext_ack *extack);
 int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 					enum devlink_eswitch_encap_mode *encap);
-int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
-					   struct devlink_port *port,
+int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 					   u8 *hw_addr, int *hw_addr_len,
 					   struct netlink_ext_ack *extack);
-int mlx5_devlink_port_function_hw_addr_set(struct devlink *devlink,
-					   struct devlink_port *port,
+int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 					   const u8 *hw_addr, int hw_addr_len,
 					   struct netlink_ext_ack *extack);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 1be048769309..720195c4be7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -164,12 +164,12 @@ static bool mlx5_sf_is_active(const struct mlx5_sf *sf)
 	return sf->hw_state == MLX5_VHCA_STATE_ACTIVE || sf->hw_state == MLX5_VHCA_STATE_IN_USE;
 }
 
-int mlx5_devlink_sf_port_fn_state_get(struct devlink *devlink, struct devlink_port *dl_port,
+int mlx5_devlink_sf_port_fn_state_get(struct devlink_port *dl_port,
 				      enum devlink_port_fn_state *state,
 				      enum devlink_port_fn_opstate *opstate,
 				      struct netlink_ext_ack *extack)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_core_dev *dev = devlink_priv(dl_port->devlink);
 	struct mlx5_sf_table *table;
 	struct mlx5_sf *sf;
 	int err = 0;
@@ -248,11 +248,11 @@ static int mlx5_sf_state_set(struct mlx5_core_dev *dev, struct mlx5_sf_table *ta
 	return err;
 }
 
-int mlx5_devlink_sf_port_fn_state_set(struct devlink *devlink, struct devlink_port *dl_port,
+int mlx5_devlink_sf_port_fn_state_set(struct devlink_port *dl_port,
 				      enum devlink_port_fn_state state,
 				      struct netlink_ext_ack *extack)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_core_dev *dev = devlink_priv(dl_port->devlink);
 	struct mlx5_sf_table *table;
 	struct mlx5_sf *sf;
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index 81ce13b19ee8..3a480e06ecc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -24,11 +24,11 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     unsigned int *new_port_index);
 int mlx5_devlink_sf_port_del(struct devlink *devlink, unsigned int port_index,
 			     struct netlink_ext_ack *extack);
-int mlx5_devlink_sf_port_fn_state_get(struct devlink *devlink, struct devlink_port *dl_port,
+int mlx5_devlink_sf_port_fn_state_get(struct devlink_port *dl_port,
 				      enum devlink_port_fn_state *state,
 				      enum devlink_port_fn_opstate *opstate,
 				      struct netlink_ext_ack *extack);
-int mlx5_devlink_sf_port_fn_state_set(struct devlink *devlink, struct devlink_port *dl_port,
+int mlx5_devlink_sf_port_fn_state_set(struct devlink_port *dl_port,
 				      enum devlink_port_fn_state state,
 				      struct netlink_ext_ack *extack);
 #else
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 08f4c6191e72..ccbfb3a844aa 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1396,8 +1396,8 @@ struct devlink_ops {
 	 *
 	 * Note: @extack can be NULL when port notifier queries the port function.
 	 */
-	int (*port_function_hw_addr_get)(struct devlink *devlink, struct devlink_port *port,
-					 u8 *hw_addr, int *hw_addr_len,
+	int (*port_function_hw_addr_get)(struct devlink_port *port, u8 *hw_addr,
+					 int *hw_addr_len,
 					 struct netlink_ext_ack *extack);
 	/**
 	 * @port_function_hw_addr_set: Port function's hardware address set function.
@@ -1406,7 +1406,7 @@ struct devlink_ops {
 	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't support port
 	 * function handling for a particular port.
 	 */
-	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
+	int (*port_function_hw_addr_set)(struct devlink_port *port,
 					 const u8 *hw_addr, int hw_addr_len,
 					 struct netlink_ext_ack *extack);
 	/**
@@ -1462,8 +1462,7 @@ struct devlink_ops {
 	 *
 	 * Return: 0 on success, negative value otherwise.
 	 */
-	int (*port_fn_state_get)(struct devlink *devlink,
-				 struct devlink_port *port,
+	int (*port_fn_state_get)(struct devlink_port *port,
 				 enum devlink_port_fn_state *state,
 				 enum devlink_port_fn_opstate *opstate,
 				 struct netlink_ext_ack *extack);
@@ -1478,8 +1477,7 @@ struct devlink_ops {
 	 *
 	 * Return: 0 on success, negative value otherwise.
 	 */
-	int (*port_fn_state_set)(struct devlink *devlink,
-				 struct devlink_port *port,
+	int (*port_fn_state_set)(struct devlink_port *port,
 				 enum devlink_port_fn_state state,
 				 struct netlink_ext_ack *extack);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8fa015319af6..ee95eee8d0ed 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -804,10 +804,11 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	return 0;
 }
 
-static int
-devlink_port_fn_hw_addr_fill(struct devlink *devlink, const struct devlink_ops *ops,
-			     struct devlink_port *port, struct sk_buff *msg,
-			     struct netlink_ext_ack *extack, bool *msg_updated)
+static int devlink_port_fn_hw_addr_fill(const struct devlink_ops *ops,
+					struct devlink_port *port,
+					struct sk_buff *msg,
+					struct netlink_ext_ack *extack,
+					bool *msg_updated)
 {
 	u8 hw_addr[MAX_ADDR_LEN];
 	int hw_addr_len;
@@ -816,7 +817,8 @@ devlink_port_fn_hw_addr_fill(struct devlink *devlink, const struct devlink_ops *
 	if (!ops->port_function_hw_addr_get)
 		return 0;
 
-	err = ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_len, extack);
+	err = ops->port_function_hw_addr_get(port, hw_addr, &hw_addr_len,
+					     extack);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
@@ -893,12 +895,11 @@ devlink_port_fn_opstate_valid(enum devlink_port_fn_opstate opstate)
 	       opstate == DEVLINK_PORT_FN_OPSTATE_ATTACHED;
 }
 
-static int
-devlink_port_fn_state_fill(struct devlink *devlink,
-			   const struct devlink_ops *ops,
-			   struct devlink_port *port, struct sk_buff *msg,
-			   struct netlink_ext_ack *extack,
-			   bool *msg_updated)
+static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
+				      struct devlink_port *port,
+				      struct sk_buff *msg,
+				      struct netlink_ext_ack *extack,
+				      bool *msg_updated)
 {
 	enum devlink_port_fn_opstate opstate;
 	enum devlink_port_fn_state state;
@@ -907,7 +908,7 @@ devlink_port_fn_state_fill(struct devlink *devlink,
 	if (!ops->port_fn_state_get)
 		return 0;
 
-	err = ops->port_fn_state_get(devlink, port, &state, &opstate, extack);
+	err = ops->port_fn_state_get(port, &state, &opstate, extack);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
@@ -935,7 +936,6 @@ static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
 				   struct netlink_ext_ack *extack)
 {
-	struct devlink *devlink = port->devlink;
 	const struct devlink_ops *ops;
 	struct nlattr *function_attr;
 	bool msg_updated = false;
@@ -945,13 +945,12 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 	if (!function_attr)
 		return -EMSGSIZE;
 
-	ops = devlink->ops;
-	err = devlink_port_fn_hw_addr_fill(devlink, ops, port, msg,
-					   extack, &msg_updated);
+	ops = port->devlink->ops;
+	err = devlink_port_fn_hw_addr_fill(ops, port, msg, extack,
+					   &msg_updated);
 	if (err)
 		goto out;
-	err = devlink_port_fn_state_fill(devlink, ops, port, msg, extack,
-					 &msg_updated);
+	err = devlink_port_fn_state_fill(ops, port, msg, extack, &msg_updated);
 out:
 	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
@@ -1269,31 +1268,33 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	return msg->len;
 }
 
-static int devlink_port_type_set(struct devlink *devlink,
-				 struct devlink_port *devlink_port,
+static int devlink_port_type_set(struct devlink_port *devlink_port,
 				 enum devlink_port_type port_type)
 
 {
 	int err;
 
-	if (devlink->ops->port_type_set) {
-		if (port_type == devlink_port->type)
-			return 0;
-		err = devlink->ops->port_type_set(devlink_port, port_type);
-		if (err)
-			return err;
-		devlink_port->desired_type = port_type;
-		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+	if (devlink_port->devlink->ops->port_type_set)
+		return -EOPNOTSUPP;
+
+	if (port_type == devlink_port->type)
 		return 0;
-	}
-	return -EOPNOTSUPP;
+
+	err = devlink_port->devlink->ops->port_type_set(devlink_port,
+							port_type);
+	if (err)
+		return err;
+
+	devlink_port->desired_type = port_type;
+	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+	return 0;
 }
 
-static int
-devlink_port_function_hw_addr_set(struct devlink *devlink, struct devlink_port *port,
-				  const struct nlattr *attr, struct netlink_ext_ack *extack)
+static int devlink_port_function_hw_addr_set(struct devlink_port *port,
+					     const struct nlattr *attr,
+					     struct netlink_ext_ack *extack)
 {
-	const struct devlink_ops *ops;
+	const struct devlink_ops *ops = port->devlink->ops;
 	const u8 *hw_addr;
 	int hw_addr_len;
 
@@ -1314,17 +1315,16 @@ devlink_port_function_hw_addr_set(struct devlink *devlink, struct devlink_port *
 		}
 	}
 
-	ops = devlink->ops;
 	if (!ops->port_function_hw_addr_set) {
 		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support function attributes");
 		return -EOPNOTSUPP;
 	}
 
-	return ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_len, extack);
+	return ops->port_function_hw_addr_set(port, hw_addr, hw_addr_len,
+					      extack);
 }
 
-static int devlink_port_fn_state_set(struct devlink *devlink,
-				     struct devlink_port *port,
+static int devlink_port_fn_state_set(struct devlink_port *port,
 				     const struct nlattr *attr,
 				     struct netlink_ext_ack *extack)
 {
@@ -1332,18 +1332,18 @@ static int devlink_port_fn_state_set(struct devlink *devlink,
 	const struct devlink_ops *ops;
 
 	state = nla_get_u8(attr);
-	ops = devlink->ops;
+	ops = port->devlink->ops;
 	if (!ops->port_fn_state_set) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Function does not support state setting");
 		return -EOPNOTSUPP;
 	}
-	return ops->port_fn_state_set(devlink, port, state, extack);
+	return ops->port_fn_state_set(port, state, extack);
 }
 
-static int
-devlink_port_function_set(struct devlink *devlink, struct devlink_port *port,
-			  const struct nlattr *attr, struct netlink_ext_ack *extack)
+static int devlink_port_function_set(struct devlink_port *port,
+				     const struct nlattr *attr,
+				     struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1];
 	int err;
@@ -1357,7 +1357,7 @@ devlink_port_function_set(struct devlink *devlink, struct devlink_port *port,
 
 	attr = tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR];
 	if (attr) {
-		err = devlink_port_function_hw_addr_set(devlink, port, attr, extack);
+		err = devlink_port_function_hw_addr_set(port, attr, extack);
 		if (err)
 			return err;
 	}
@@ -1367,7 +1367,7 @@ devlink_port_function_set(struct devlink *devlink, struct devlink_port *port,
 	 */
 	attr = tb[DEVLINK_PORT_FN_ATTR_STATE];
 	if (attr)
-		err = devlink_port_fn_state_set(devlink, port, attr, extack);
+		err = devlink_port_fn_state_set(port, attr, extack);
 
 	if (!err)
 		devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
@@ -1378,14 +1378,13 @@ static int devlink_nl_cmd_port_set_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
 	struct devlink_port *devlink_port = info->user_ptr[1];
-	struct devlink *devlink = devlink_port->devlink;
 	int err;
 
 	if (info->attrs[DEVLINK_ATTR_PORT_TYPE]) {
 		enum devlink_port_type port_type;
 
 		port_type = nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_TYPE]);
-		err = devlink_port_type_set(devlink, devlink_port, port_type);
+		err = devlink_port_type_set(devlink_port, port_type);
 		if (err)
 			return err;
 	}
@@ -1394,7 +1393,7 @@ static int devlink_nl_cmd_port_set_doit(struct sk_buff *skb,
 		struct nlattr *attr = info->attrs[DEVLINK_ATTR_PORT_FUNCTION];
 		struct netlink_ext_ack *extack = info->extack;
 
-		err = devlink_port_function_set(devlink, devlink_port, attr, extack);
+		err = devlink_port_function_set(devlink_port, attr, extack);
 		if (err)
 			return err;
 	}
-- 
2.31.1

