Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91853F2624
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhHTE42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237795AbhHTE4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 154DC610D2;
        Fri, 20 Aug 2021 04:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435331;
        bh=z+iBSI/l2yuzs7ihzLw+TTlvSlREQiqzLdrt8RyDQkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQAKPkucj6v4V2k3qXetu34zb8XW17051fAOiAVK60hBEHMq4c+qtv7r1zcfFaXaL
         zcRIKlTHuGDO3oktihLyNh2wWCRl+UOpvu7/YsC56PL/kXgoqRQGPmBhDkttf0a38Z
         W2UD+C30Q40427tyeJxHvvvxpk3eqSQyoDGTiQgb2MPJc2JJaCbKswqyqgglDpQmOe
         VxHTAOc7Tk92IO27P5polxbTNtgLjGE4T0ytpoHdV+NJlZF2b7Czzc2IA5DSjZRM+L
         wvYWonJ4crQtMncJQzp9jdujKkKUqvn5GMj84PU8f889457hWz/ounspHXVYQk8lQ0
         p4RyTeT5tlo5g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Huy Nguyen <huyn@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: E-switch, Allow to add vports to rate groups
Date:   Thu, 19 Aug 2021 21:55:14 -0700
Message-Id: <20210820045515.265297-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Implement eswitch API that allows updating rate groups. If group
pointer is NULL, then move the vport to internal unlimited group zero.

Implement devlink_ops->rate_parent_node_set() callback in the terms of
the new eswitch group update API.

Enable QoS for all group's elements if a group has allocated BW share.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   1 +
 .../mellanox/mlx5/core/esw/devlink_port.c     |   8 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c | 206 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h |   4 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 +
 5 files changed, 199 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index e41b7d7cf654..e84287ffc7ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -299,6 +299,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.rate_node_tx_max_set = mlx5_esw_devlink_rate_node_tx_max_set,
 	.rate_node_new = mlx5_esw_devlink_rate_node_new,
 	.rate_node_del = mlx5_esw_devlink_rate_node_del,
+	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index bbfc498cb3dd..20af557ae30c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -116,8 +116,10 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vpo
 	if (IS_ERR(vport))
 		return;
 
-	if (vport->dl_port->devlink_rate)
+	if (vport->dl_port->devlink_rate) {
+		mlx5_esw_qos_vport_update_group(esw, vport, NULL, NULL);
 		devlink_rate_leaf_destroy(vport->dl_port);
+	}
 
 	devlink_port_unregister(vport->dl_port);
 	mlx5_esw_dl_port_free(vport->dl_port);
@@ -178,8 +180,10 @@ void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num
 	if (IS_ERR(vport))
 		return;
 
-	if (vport->dl_port->devlink_rate)
+	if (vport->dl_port->devlink_rate) {
+		mlx5_esw_qos_vport_update_group(esw, vport, NULL, NULL);
 		devlink_rate_leaf_destroy(vport->dl_port);
+	}
 
 	devlink_port_unregister(vport->dl_port);
 	vport->dl_port = NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 138b11073278..692c9d543f75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -63,20 +63,23 @@ static int esw_qos_vport_config(struct mlx5_eswitch *esw,
 				struct netlink_ext_ack *extack)
 {
 	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
+	struct mlx5_esw_rate_group *group = vport->qos.group;
 	struct mlx5_core_dev *dev = esw->dev;
+	u32 parent_tsar_ix;
 	void *vport_elem;
 	int err;
 
 	if (!vport->qos.enabled)
 		return -EIO;
 
+	parent_tsar_ix = group ? group->tsar_ix : esw->qos.root_tsar_ix;
 	MLX5_SET(scheduling_context, sched_ctx, element_type,
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
 	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx,
 				  element_attributes);
 	MLX5_SET(vport_element, vport_elem, vport_number, vport->vport);
 
-	err = esw_qos_tsar_config(dev, sched_ctx, esw->qos.root_tsar_ix, vport->qos.esw_tsar_ix,
+	err = esw_qos_tsar_config(dev, sched_ctx, parent_tsar_ix, vport->qos.esw_tsar_ix,
 				  max_rate, bw_share);
 	if (err) {
 		esw_warn(esw->dev,
@@ -109,7 +112,7 @@ static u32 esw_qos_calculate_min_rate_divider(struct mlx5_eswitch *esw,
 	} else {
 		mlx5_esw_for_each_vport(esw, i, evport) {
 			if (!evport->enabled || !evport->qos.enabled ||
-			    evport->qos.min_rate < max_guarantee)
+			    evport->qos.group != group || evport->qos.min_rate < max_guarantee)
 				continue;
 			max_guarantee = evport->qos.min_rate;
 		}
@@ -117,6 +120,12 @@ static u32 esw_qos_calculate_min_rate_divider(struct mlx5_eswitch *esw,
 
 	if (max_guarantee)
 		return max_t(u32, max_guarantee / fw_max_bw_share, 1);
+
+	/* If vports min rate divider is 0 but their group has bw_share configured, then
+	 * need to set bw_share for vports to minimal value.
+	 */
+	if (!group_level && !max_guarantee && group->bw_share)
+		return 1;
 	return 0;
 }
 
@@ -140,7 +149,7 @@ static int esw_qos_normalize_vports_min_rate(struct mlx5_eswitch *esw,
 	int err;
 
 	mlx5_esw_for_each_vport(esw, i, evport) {
-		if (!evport->enabled || !evport->qos.enabled)
+		if (!evport->enabled || !evport->qos.enabled || evport->qos.group != group)
 			continue;
 		bw_share = esw_qos_calc_bw_share(evport->qos.min_rate, divider, fw_max_bw_share);
 
@@ -176,6 +185,14 @@ static int esw_qos_normalize_groups_min_rate(struct mlx5_eswitch *esw, u32 divid
 			return err;
 
 		group->bw_share = bw_share;
+
+		/* All the group's vports need to be set with default bw_share
+		 * to enable them with QOS
+		 */
+		err = esw_qos_normalize_vports_min_rate(esw, group, extack);
+
+		if (err)
+			return err;
 	}
 
 	return 0;
@@ -201,7 +218,7 @@ int mlx5_esw_qos_set_vport_min_rate(struct mlx5_eswitch *esw,
 
 	previous_min_rate = evport->qos.min_rate;
 	evport->qos.min_rate = min_rate;
-	err = esw_qos_normalize_vports_min_rate(esw, NULL, extack);
+	err = esw_qos_normalize_vports_min_rate(esw, evport->qos.group, extack);
 	if (err)
 		evport->qos.min_rate = previous_min_rate;
 
@@ -213,6 +230,7 @@ int mlx5_esw_qos_set_vport_max_rate(struct mlx5_eswitch *esw,
 				    u32 max_rate,
 				    struct netlink_ext_ack *extack)
 {
+	u32 act_max_rate = max_rate;
 	bool max_rate_supported;
 	int err;
 
@@ -224,7 +242,13 @@ int mlx5_esw_qos_set_vport_max_rate(struct mlx5_eswitch *esw,
 	if (max_rate == evport->qos.max_rate)
 		return 0;
 
-	err = esw_qos_vport_config(esw, evport, max_rate, evport->qos.bw_share, extack);
+	/* If parent group has rate limit need to set to group
+	 * value when new max rate is 0.
+	 */
+	if (evport->qos.group && !max_rate)
+		act_max_rate = evport->qos.group->max_rate;
+
+	err = esw_qos_vport_config(esw, evport, act_max_rate, evport->qos.bw_share, extack);
 
 	if (!err)
 		evport->qos.max_rate = max_rate;
@@ -267,6 +291,8 @@ static int esw_qos_set_group_max_rate(struct mlx5_eswitch *esw,
 				      struct mlx5_esw_rate_group *group,
 				      u32 max_rate, struct netlink_ext_ack *extack)
 {
+	struct mlx5_vport *vport;
+	unsigned long i;
 	int err;
 
 	if (group->max_rate == max_rate)
@@ -278,9 +304,127 @@ static int esw_qos_set_group_max_rate(struct mlx5_eswitch *esw,
 
 	group->max_rate = max_rate;
 
+	/* Any unlimited vports in the group should be set
+	 * with the value of the group.
+	 */
+	mlx5_esw_for_each_vport(esw, i, vport) {
+		if (!vport->enabled || !vport->qos.enabled ||
+		    vport->qos.group != group || vport->qos.max_rate)
+			continue;
+
+		err = esw_qos_vport_config(esw, vport, max_rate, vport->qos.bw_share, extack);
+		if (err)
+			NL_SET_ERR_MSG_MOD(extack,
+					   "E-Switch vport implicit rate limit setting failed");
+	}
+
+	return err;
+}
+
+static int esw_qos_vport_create_sched_element(struct mlx5_eswitch *esw,
+					      struct mlx5_vport *vport,
+					      u32 max_rate, u32 bw_share)
+{
+	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
+	struct mlx5_esw_rate_group *group = vport->qos.group;
+	struct mlx5_core_dev *dev = esw->dev;
+	u32 parent_tsar_ix;
+	void *vport_elem;
+	int err;
+
+	parent_tsar_ix = group ? group->tsar_ix : esw->qos.root_tsar_ix;
+	MLX5_SET(scheduling_context, sched_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
+	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx, element_attributes);
+	MLX5_SET(vport_element, vport_elem, vport_number, vport->vport);
+	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_tsar_ix);
+	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_rate);
+	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
+
+	err = mlx5_create_scheduling_element_cmd(dev,
+						 SCHEDULING_HIERARCHY_E_SWITCH,
+						 sched_ctx,
+						 &vport->qos.esw_tsar_ix);
+	if (err) {
+		esw_warn(esw->dev, "E-Switch create TSAR vport element failed (vport=%d,err=%d)\n",
+			 vport->vport, err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int esw_qos_update_group_scheduling_element(struct mlx5_eswitch *esw,
+						   struct mlx5_vport *vport,
+						   struct mlx5_esw_rate_group *curr_group,
+						   struct mlx5_esw_rate_group *new_group,
+						   struct netlink_ext_ack *extack)
+{
+	u32 max_rate;
+	int err;
+
+	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
+						  SCHEDULING_HIERARCHY_E_SWITCH,
+						  vport->qos.esw_tsar_ix);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "E-Switch destroy TSAR vport element failed");
+		return err;
+	}
+
+	vport->qos.group = new_group;
+	max_rate = vport->qos.max_rate ? vport->qos.max_rate : new_group->max_rate;
+
+	/* If vport is unlimited, we set the group's value.
+	 * Therefore, if the group is limited it will apply to
+	 * the vport as well and if not, vport will remain unlimited.
+	 */
+	err = esw_qos_vport_create_sched_element(esw, vport, max_rate, vport->qos.bw_share);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "E-Switch vport group set failed.");
+		goto err_sched;
+	}
+
+	return 0;
+
+err_sched:
+	vport->qos.group = curr_group;
+	max_rate = vport->qos.max_rate ? vport->qos.max_rate : curr_group->max_rate;
+	if (esw_qos_vport_create_sched_element(esw, vport, max_rate, vport->qos.bw_share))
+		esw_warn(esw->dev, "E-Switch vport group restore failed (vport=%d)\n",
+			 vport->vport);
+
 	return err;
 }
 
+static int esw_qos_vport_update_group(struct mlx5_eswitch *esw,
+				      struct mlx5_vport *vport,
+				      struct mlx5_esw_rate_group *group,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlx5_esw_rate_group *new_group, *curr_group;
+	int err;
+
+	if (!vport->enabled)
+		return -EINVAL;
+
+	curr_group = vport->qos.group;
+	new_group = group ?: esw->qos.group0;
+	if (curr_group == new_group)
+		return 0;
+
+	err = esw_qos_update_group_scheduling_element(esw, vport, curr_group, new_group, extack);
+	if (err)
+		return err;
+
+	/* Recalculate bw share weights of old and new groups */
+	if (vport->qos.bw_share) {
+		esw_qos_normalize_vports_min_rate(esw, curr_group, extack);
+		esw_qos_normalize_vports_min_rate(esw, new_group, extack);
+	}
+
+	return 0;
+}
+
 static struct mlx5_esw_rate_group *
 esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack)
 {
@@ -457,9 +601,6 @@ void mlx5_esw_qos_destroy(struct mlx5_eswitch *esw)
 int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 			      u32 max_rate, u32 bw_share)
 {
-	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
-	struct mlx5_core_dev *dev = esw->dev;
-	void *vport_elem;
 	int err;
 
 	lockdep_assert_held(&esw->state_lock);
@@ -469,22 +610,10 @@ int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	if (vport->qos.enabled)
 		return -EEXIST;
 
-	MLX5_SET(scheduling_context, sched_ctx, element_type,
-		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
-	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx, element_attributes);
-	MLX5_SET(vport_element, vport_elem, vport_number, vport->vport);
-	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, esw->qos.root_tsar_ix);
-	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_rate);
-	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
+	vport->qos.group = esw->qos.group0;
 
-	err = mlx5_create_scheduling_element_cmd(dev,
-						 SCHEDULING_HIERARCHY_E_SWITCH,
-						 sched_ctx,
-						 &vport->qos.esw_tsar_ix);
-	if (err)
-		esw_warn(dev, "E-Switch create TSAR vport element failed (vport=%d,err=%d)\n",
-			 vport->vport, err);
-	else
+	err = esw_qos_vport_create_sched_element(esw, vport, max_rate, bw_share);
+	if (!err)
 		vport->qos.enabled = true;
 
 	return err;
@@ -497,6 +626,8 @@ void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vpo
 	lockdep_assert_held(&esw->state_lock);
 	if (!esw->qos.enabled || !vport->qos.enabled)
 		return;
+	WARN(vport->qos.group && vport->qos.group != esw->qos.group0,
+	     "Disabling QoS on port before detaching it from group");
 
 	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
 						  SCHEDULING_HIERARCHY_E_SWITCH,
@@ -696,3 +827,32 @@ int mlx5_esw_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
+
+int mlx5_esw_qos_vport_update_group(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *vport,
+				    struct mlx5_esw_rate_group *group,
+				    struct netlink_ext_ack *extack)
+{
+	int err;
+
+	mutex_lock(&esw->state_lock);
+	err = esw_qos_vport_update_group(esw, vport, group, extack);
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
+int mlx5_esw_devlink_rate_parent_set(struct devlink_rate *devlink_rate,
+				     struct devlink_rate *parent,
+				     void *priv, void *parent_priv,
+				     struct netlink_ext_ack *extack)
+{
+	struct mlx5_esw_rate_group *group;
+	struct mlx5_vport *vport = priv;
+
+	if (!parent)
+		return mlx5_esw_qos_vport_update_group(vport->dev->priv.eswitch,
+						       vport, NULL, extack);
+
+	group = parent_priv;
+	return mlx5_esw_qos_vport_update_group(vport->dev->priv.eswitch, vport, group, extack);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
index b2e301a436bd..28451abe2d2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
@@ -32,6 +32,10 @@ int mlx5_esw_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv,
 				   struct netlink_ext_ack *extack);
 int mlx5_esw_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 				   struct netlink_ext_ack *extack);
+int mlx5_esw_devlink_rate_parent_set(struct devlink_rate *devlink_rate,
+				     struct devlink_rate *parent,
+				     void *priv, void *parent_priv,
+				     struct netlink_ext_ack *extack);
 #endif
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index d7cfad168312..2c7444101bb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -177,6 +177,7 @@ struct mlx5_vport {
 		u32             bw_share;
 		u32 min_rate;
 		u32 max_rate;
+		struct mlx5_esw_rate_group *group;
 	} qos;
 
 	u16 vport;
@@ -356,6 +357,10 @@ int mlx5_eswitch_set_vport_trust(struct mlx5_eswitch *esw,
 				 u16 vport_num, bool setting);
 int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *esw, u16 vport,
 				u32 max_rate, u32 min_rate);
+int mlx5_esw_qos_vport_update_group(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *vport,
+				    struct mlx5_esw_rate_group *group,
+				    struct netlink_ext_ack *extack);
 int mlx5_eswitch_set_vepa(struct mlx5_eswitch *esw, u8 setting);
 int mlx5_eswitch_get_vepa(struct mlx5_eswitch *esw, u8 *setting);
 int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
-- 
2.31.1

