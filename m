Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BE06929F5
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbjBJWSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjBJWSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEA04C0FB
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B5F61EB2
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FE0C4339B;
        Fri, 10 Feb 2023 22:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067510;
        bh=QeT//OQVSe9KR4FFJfTjjiDvL3+2QBSjw7YLfV+B0NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7smrQIi047LPhBZcUPbH6VOeE1n5cTut0L0m6I8qBoVcewTDQlyGe1Oxvk7O+LRI
         iu8qDPUoBIdkjrxQ5P3aoaV+XK8S40d3F+xUzT+kgIoPAGtdGXKNbINNoo/bwo8n64
         rjg3q8hGeZwrHQjpkAx7nTXAhFc64g3X7ZC3G1I9v4v9UYRb4JQCbImTM1I0E/C0c0
         fipynP0LqeKEW27ilxJkQvxWTqpdBhm5mU7Jh0FfwM+dELkTSNt8yxwqscooBX1Fsc
         9evg0sb3QuWZM18oU0tbRjMu9iKKHgFBrgG5+y9IvTuMGXgwNWccb8h2jArsmI/Fr4
         HUTOmERHRrpzw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Lag, Let user configure multiport eswitch
Date:   Fri, 10 Feb 2023 14:18:07 -0800
Message-Id: <20230210221821.271571-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210221821.271571-1-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Instead of activating multiport eswitch dynamically through
adding a TC rule and meeting certain conditions, allow the user
to activate it through devlink.
This will remove the forced requirement of using TC.
e.g. Bridge offload.

Example:
    $ devlink dev param set pci/0000:00:0b.0 name esw_multiport value 1 \
                  cmode runtime

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst     |  4 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 56 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  1 +
 .../mellanox/mlx5/core/en/tc/act/mirred.c     |  9 ---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 22 +-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  6 --
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 46 +++++++--------
 .../ethernet/mellanox/mlx5/core/lag/mpesw.h   | 12 +---
 10 files changed, 87 insertions(+), 74 deletions(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 29ad304e6fba..1d2ad2727da1 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -54,6 +54,10 @@ parameters.
      - Control the number of large groups (size > 1) in the FDB table.
 
        * The default value is 15, and the range is between 1 and 1024.
+   * - ``esw_multiport``
+     - Boolean
+     - runtime
+     - Set the E-Switch lag mode to multiport.
 
 The ``mlx5`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index b742e04deec1..49392870f695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -7,6 +7,7 @@
 #include "fw_reset.h"
 #include "fs_core.h"
 #include "eswitch.h"
+#include "lag/lag.h"
 #include "esw/qos.h"
 #include "sf/dev/dev.h"
 #include "sf/sf.h"
@@ -437,6 +438,55 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
 	return 0;
 }
 
+static int mlx5_devlink_esw_multiport_set(struct devlink *devlink, u32 id,
+					  struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	int err = 0;
+
+	if (!MLX5_ESWITCH_MANAGER(dev))
+		return -EOPNOTSUPP;
+
+	if (ctx->val.vbool)
+		err = mlx5_lag_mpesw_enable(dev);
+	else
+		mlx5_lag_mpesw_disable(dev);
+
+	return err;
+}
+
+static int mlx5_devlink_esw_multiport_get(struct devlink *devlink, u32 id,
+					  struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!MLX5_ESWITCH_MANAGER(dev))
+		return -EOPNOTSUPP;
+
+	ctx->val.vbool = mlx5_lag_mpesw_is_activated(dev);
+	return 0;
+}
+
+static int mlx5_devlink_esw_multiport_validate(struct devlink *devlink, u32 id,
+					       union devlink_param_value val,
+					       struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!MLX5_ESWITCH_MANAGER(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "E-Switch is unsupported");
+		return -EOPNOTSUPP;
+	}
+
+	if (mlx5_eswitch_mode(dev) != MLX5_ESWITCH_OFFLOADS) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "E-Switch must be in switchdev mode");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 #endif
 
 static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
@@ -455,6 +505,12 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			     NULL, NULL,
 			     mlx5_devlink_large_group_num_validate),
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_ESW_MULTIPORT,
+			     "esw_multiport", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     mlx5_devlink_esw_multiport_get,
+			     mlx5_devlink_esw_multiport_set,
+			     mlx5_devlink_esw_multiport_validate),
 #endif
 	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_eq_depth_validate),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index b561107e0df1..212b12424146 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -11,6 +11,7 @@ enum mlx5_devlink_param_id {
 	MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 	MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
 	MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
+	MLX5_DEVLINK_PARAM_ID_ESW_MULTIPORT,
 };
 
 struct mlx5_trap_ctx {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index c095a12346de..07cc65596f89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -216,7 +216,6 @@ parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 	struct net_device *uplink_dev;
 	struct mlx5e_priv *out_priv;
 	struct mlx5_eswitch *esw;
-	bool is_uplink_rep;
 	int *ifindexes;
 	int if_count;
 	int err;
@@ -231,7 +230,6 @@ parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 
 	parse_state->ifindexes[if_count] = out_dev->ifindex;
 	parse_state->if_count++;
-	is_uplink_rep = mlx5e_eswitch_uplink_rep(out_dev);
 
 	if (mlx5_lag_mpesw_do_mirred(priv->mdev, out_dev, extack))
 		return -EOPNOTSUPP;
@@ -275,13 +273,6 @@ parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 	esw_attr->dests[esw_attr->out_count].rep = rpriv->rep;
 	esw_attr->dests[esw_attr->out_count].mdev = out_priv->mdev;
 
-	/* If output device is bond master then rules are not explicit
-	 * so we don't attempt to count them.
-	 */
-	if (is_uplink_rep && MLX5_CAP_PORT_SELECTION(priv->mdev, port_select_flow_table) &&
-	    MLX5_CAP_GEN(priv->mdev, create_lag_when_not_master_up))
-		attr->lag.count = true;
-
 	esw_attr->out_count++;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e2ec80ebde58..00d5b0aa295b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2124,9 +2124,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	free_branch_attr(flow, attr->branch_true);
 	free_branch_attr(flow, attr->branch_false);
 
-	if (flow->attr->lag.count)
-		mlx5_lag_del_mpesw_rule(esw->dev);
-
 	kvfree(attr->esw_attr->rx_tun_attr);
 	kvfree(attr->parse_attr);
 	kfree(flow->attr);
@@ -4277,12 +4274,7 @@ static bool is_lag_dev(struct mlx5e_priv *priv,
 
 static bool is_multiport_eligible(struct mlx5e_priv *priv, struct net_device *out_dev)
 {
-	if (same_hw_reps(priv, out_dev) &&
-	    MLX5_CAP_PORT_SELECTION(priv->mdev, port_select_flow_table) &&
-	    MLX5_CAP_GEN(priv->mdev, create_lag_when_not_master_up))
-		return true;
-
-	return false;
+	return same_hw_reps(priv, out_dev) && mlx5_lag_mpesw_is_activated(priv->mdev);
 }
 
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
@@ -4584,7 +4576,6 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		     struct mlx5_core_dev *in_mdev)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_tc_flow *flow;
@@ -4617,26 +4608,17 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
-	if (flow->attr->lag.count) {
-		err = mlx5_lag_add_mpesw_rule(esw->dev);
-		if (err)
-			goto err_free;
-	}
-
 	err = mlx5e_tc_add_fdb_flow(priv, flow, extack);
 	complete_all(&flow->init_done);
 	if (err) {
 		if (!(err == -ENETUNREACH && mlx5_lag_is_multipath(in_mdev)))
-			goto err_lag;
+			goto err_free;
 
 		add_unready_flow(flow);
 	}
 
 	return flow;
 
-err_lag:
-	if (flow->attr->lag.count)
-		mlx5_lag_del_mpesw_rule(esw->dev);
 err_free:
 	mlx5e_flow_put(priv, flow);
 out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ce516dc7f3fd..a0ed9d95a634 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -90,12 +90,6 @@ struct mlx5_flow_attr {
 	u32 exe_aso_type;
 	struct list_head list;
 	struct mlx5e_post_act_handle *post_act_handle;
-	struct {
-		/* Indicate whether the parsed flow should be counted for lag mode decision
-		 * making
-		 */
-		bool count;
-	} lag;
 	struct mlx5_flow_attr *branch_true;
 	struct mlx5_flow_attr *branch_false;
 	struct mlx5_flow_attr *jumping_attr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index dbf218cac535..301994741b08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -230,7 +230,6 @@ static void mlx5_ldev_free(struct kref *ref)
 	mlx5_lag_mp_cleanup(ldev);
 	cancel_delayed_work_sync(&ldev->bond_work);
 	destroy_workqueue(ldev->wq);
-	mlx5_lag_mpesw_cleanup(ldev);
 	mutex_destroy(&ldev->lock);
 	kfree(ldev);
 }
@@ -276,7 +275,6 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
 			      err);
 
-	mlx5_lag_mpesw_init(ldev);
 	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
 	ldev->buckets = 1;
 
@@ -688,7 +686,7 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 }
 
 #define MLX5_LAG_OFFLOADS_SUPPORTED_PORTS 2
-static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
+bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 {
 #ifdef CONFIG_MLX5_ESWITCH
 	struct mlx5_core_dev *dev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 66013bef9939..2dbd96a86ef8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -102,6 +102,7 @@ mlx5_lag_is_ready(struct mlx5_lag *ldev)
 	return test_bit(MLX5_LAG_FLAG_NDEVS_READY, &ldev->state_flags);
 }
 
+bool mlx5_lag_check_prereq(struct mlx5_lag *ldev);
 void mlx5_modify_lag(struct mlx5_lag *ldev,
 		     struct lag_tracker *tracker);
 int mlx5_activate_lag(struct mlx5_lag *ldev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 3799f89ed1a6..3f8fc965cec6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -7,18 +7,19 @@
 #include "eswitch.h"
 #include "lib/mlx5.h"
 
-static int add_mpesw_rule(struct mlx5_lag *ldev)
+static int enable_mpesw(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
 	int err;
 
-	if (atomic_add_return(1, &ldev->lag_mpesw.mpesw_rule_count) != 1)
-		return 0;
+	if (ldev->mode != MLX5_LAG_MODE_NONE)
+		return -EINVAL;
 
-	if (ldev->mode != MLX5_LAG_MODE_NONE) {
-		err = -EINVAL;
-		goto out_err;
-	}
+	if (mlx5_eswitch_mode(dev) != MLX5_ESWITCH_OFFLOADS ||
+	    !MLX5_CAP_PORT_SELECTION(dev, port_select_flow_table) ||
+	    !MLX5_CAP_GEN(dev, create_lag_when_not_master_up) ||
+	    !mlx5_lag_check_prereq(ldev))
+		return -EOPNOTSUPP;
 
 	err = mlx5_activate_lag(ldev, NULL, MLX5_LAG_MODE_MPESW, false);
 	if (err) {
@@ -29,14 +30,12 @@ static int add_mpesw_rule(struct mlx5_lag *ldev)
 	return 0;
 
 out_err:
-	atomic_dec(&ldev->lag_mpesw.mpesw_rule_count);
 	return err;
 }
 
-static void del_mpesw_rule(struct mlx5_lag *ldev)
+static void disable_mpesw(struct mlx5_lag *ldev)
 {
-	if (!atomic_dec_return(&ldev->lag_mpesw.mpesw_rule_count) &&
-	    ldev->mode == MLX5_LAG_MODE_MPESW)
+	if (ldev->mode == MLX5_LAG_MODE_MPESW)
 		mlx5_disable_lag(ldev);
 }
 
@@ -46,12 +45,17 @@ static void mlx5_mpesw_work(struct work_struct *work)
 	struct mlx5_lag *ldev = mpesww->lag;
 
 	mutex_lock(&ldev->lock);
+	if (ldev->mode_changes_in_progress) {
+		mpesww->result = -EAGAIN;
+		goto unlock;
+	}
+
 	if (mpesww->op == MLX5_MPESW_OP_ENABLE)
-		mpesww->result = add_mpesw_rule(ldev);
+		mpesww->result = enable_mpesw(ldev);
 	else if (mpesww->op == MLX5_MPESW_OP_DISABLE)
-		del_mpesw_rule(ldev);
+		disable_mpesw(ldev);
+unlock:
 	mutex_unlock(&ldev->lock);
-
 	complete(&mpesww->comp);
 }
 
@@ -86,12 +90,12 @@ static int mlx5_lag_mpesw_queue_work(struct mlx5_core_dev *dev,
 	return err;
 }
 
-void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev)
+void mlx5_lag_mpesw_disable(struct mlx5_core_dev *dev)
 {
 	mlx5_lag_mpesw_queue_work(dev, MLX5_MPESW_OP_DISABLE);
 }
 
-int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev)
+int mlx5_lag_mpesw_enable(struct mlx5_core_dev *dev)
 {
 	return mlx5_lag_mpesw_queue_work(dev, MLX5_MPESW_OP_ENABLE);
 }
@@ -118,13 +122,3 @@ bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev)
 
 	return ldev && ldev->mode == MLX5_LAG_MODE_MPESW;
 }
-
-void mlx5_lag_mpesw_init(struct mlx5_lag *ldev)
-{
-	atomic_set(&ldev->lag_mpesw.mpesw_rule_count, 0);
-}
-
-void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev)
-{
-	WARN_ON(atomic_read(&ldev->lag_mpesw.mpesw_rule_count));
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index 818f19b5a984..571e4acf262e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -9,7 +9,6 @@
 
 struct lag_mpesw {
 	struct work_struct mpesw_work;
-	atomic_t mpesw_rule_count;
 };
 
 enum mpesw_op {
@@ -29,14 +28,7 @@ int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
 			     struct net_device *out_dev,
 			     struct netlink_ext_ack *extack);
 bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev);
-void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev);
-int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev);
-#if IS_ENABLED(CONFIG_MLX5_ESWITCH)
-void mlx5_lag_mpesw_init(struct mlx5_lag *ldev);
-void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev);
-#else
-static inline void mlx5_lag_mpesw_init(struct mlx5_lag *ldev) {}
-static inline void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev) {}
-#endif
+void mlx5_lag_mpesw_disable(struct mlx5_core_dev *dev);
+int mlx5_lag_mpesw_enable(struct mlx5_core_dev *dev);
 
 #endif /* __MLX5_LAG_MPESW_H__ */
-- 
2.39.1

