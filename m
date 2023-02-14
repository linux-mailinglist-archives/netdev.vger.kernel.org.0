Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53AED697076
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbjBNWOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBNWOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:14:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E654E14EAF
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:14:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73B5B61943
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC98C433EF;
        Tue, 14 Feb 2023 22:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412847;
        bh=VwUU63f2LkR2AxKaU5cF7BWSG4VVkY2spCsksSIzFKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwV4aSw8k5opVVqnhPfR5Rt1PAic1U1+v4Ls1KlGVlsTxShi18XJZmxVMm/vXJ/8n
         gLtxm92jj922O9YQj8tB5xsDkVxtgZZSCo7AQZaYI+2jEMY9i9iHRRsHxtI9tAm710
         FTF3Uc2BAZRGJN7SL/Yy2OyA9mz7kXY0HdlI8Ta3Mo3qHyD/CVZqC3AnwxCOznQYBY
         VyXTyReUmHboclu0yWVNRmktLc0AInMm4OE/Iz7fkS6+PDs/4ETMbWSzJtDSKa7v6y
         re/SrOsTt2kpgW99XR/v1TgH+D3FqN5htBn1XoYLFQ9Iq2TJ+h6WkW0NeQNhjuLJLg
         YcGFbEtOTdsXA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next V2 01/15] net/mlx5: Lag, Control MultiPort E-Switch single FDB mode
Date:   Tue, 14 Feb 2023 14:12:25 -0800
Message-Id: <20230214221239.159033-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214221239.159033-1-saeed@kernel.org>
References: <20230214221239.159033-1-saeed@kernel.org>
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

MultiPort E-Switch builds on newer hardware's capabilities and introduces
a mode where a single E-Switch is used and all the vports and physical
ports on the NIC are connected to it.

The new mode will allow in the future a decrease in the memory used by the
driver and advanced features that aren't possible today.

This represents a big change in the current E-Switch implantation in mlx5.
Currently, by default, each E-Switch manager manages its E-Switch.
Steering rules in each E-Switch can only forward traffic to the native
physical port associated with that E-Switch. While there are ways to target
non-native physical ports, for example using a bond or via special TC
rules. None of the ways allows a user to configure the driver
to operate by default in such a mode nor can the driver decide
to move to this mode by default as it's user configuration-driven right now.

While MultiPort E-Switch single FDB mode is the preferred mode, older
generations of ConnectX hardware couldn't support this mode so it was never
implemented. Now that there is capable hardware present, start the
transition to having this mode by default.

Introduce a devlink parameter to control MultiPort E-Switch single FDB mode.
This will allow users to select this mode on their system right now
and in the future will allow the driver to move to this mode by default.

Example:
    $ devlink dev param set pci/0000:00:0b.0 name esw_multiport value 1 \
                  cmode runtime

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst     | 18 +++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 54 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  1 +
 .../mellanox/mlx5/core/en/tc/act/mirred.c     |  9 ----
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 22 +-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  6 ---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 46 +++++++---------
 .../ethernet/mellanox/mlx5/core/lag/mpesw.h   | 12 +----
 10 files changed, 99 insertions(+), 74 deletions(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 29ad304e6fba..3321117cf605 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -54,6 +54,24 @@ parameters.
      - Control the number of large groups (size > 1) in the FDB table.
 
        * The default value is 15, and the range is between 1 and 1024.
+   * - ``esw_multiport``
+     - Boolean
+     - runtime
+     - Control MultiPort E-Switch shared fdb mode.
+
+       An experimental mode where a single E-Switch is used and all the vports
+       and physical ports on the NIC are connected to it.
+
+       An example is to send traffic from a VF that is created on PF0 to an
+       uplink that is natively associated with the uplink of PF1
+
+       Note: Future devices, ConnectX-8 and onward, will eventually have this
+       as the default to allow forwarding between all NIC ports in a single
+       E-switch environment and the dual E-switch mode will likely get
+       deprecated.
+
+       Default: disabled
+
 
 The ``mlx5`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index b742e04deec1..4c9dde377e7d 100644
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
@@ -437,6 +438,53 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
 	return 0;
 }
 
+static int mlx5_devlink_esw_multiport_set(struct devlink *devlink, u32 id,
+					  struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!MLX5_ESWITCH_MANAGER(dev))
+		return -EOPNOTSUPP;
+
+	if (ctx->val.vbool)
+		return mlx5_lag_mpesw_enable(dev);
+
+	mlx5_lag_mpesw_disable(dev);
+	return 0;
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
@@ -455,6 +503,12 @@ static const struct devlink_param mlx5_devlink_params[] = {
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
index 2d06b4412762..dcfeb0077152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2152,9 +2152,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	free_branch_attr(flow, attr->branch_true);
 	free_branch_attr(flow, attr->branch_false);
 
-	if (flow->attr->lag.count)
-		mlx5_lag_del_mpesw_rule(esw->dev);
-
 	kvfree(attr->esw_attr->rx_tun_attr);
 	kvfree(attr->parse_attr);
 	kfree(flow->attr);
@@ -4314,12 +4311,7 @@ static bool is_lag_dev(struct mlx5e_priv *priv,
 
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
@@ -4621,7 +4613,6 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		     struct mlx5_core_dev *in_mdev)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_tc_flow *flow;
@@ -4654,26 +4645,17 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
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
index e8e39fdcda73..f6b10bd3368b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -92,12 +92,6 @@ struct mlx5_flow_attr {
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

