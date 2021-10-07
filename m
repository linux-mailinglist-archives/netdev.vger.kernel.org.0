Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76E7424D7E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240345AbhJGG5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240305AbhJGG5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 02:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1D6B6135E;
        Thu,  7 Oct 2021 06:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633589731;
        bh=VyKmKs3uexnRx4Qg22Ytb+0RmzuWEaXuX5WBQSO4P44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMHfhVDICB9ilPPLOcc15fDpiTyyQ7vmvLk4snNqrIeeK56wcnftNhmrlDumqze5V
         aCBlChkos5bbXb7btLU/EsCsgZ0qFIwAEUcIj2SjIpQ+SZ+252MDwP3N9GnZTuWGcW
         qAHFOQ2wRyvIFRlPs7L7T+3KVyPHrr0N5l4czmdSNGPApfWA3ecAte5g8tDuaTvPME
         r3HrRoa2VzjHQfZhkyfYzwnJJ4+ijb5TqU7CpIDzVs3VIMT7n6kuoOEibmFPo5uP/+
         AwSZZIkaCqB5vmBmvd8/gVXusnrBT62f8uXVsovPtlIBLJ0V4oUCYsCIyFtXA6qFhj
         OCCL7OfChkE5Q==
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
Subject: [PATCH net-next v3 3/5] devlink: Allow set reload ops callbacks separately
Date:   Thu,  7 Oct 2021 09:55:17 +0300
Message-Id: <614978ec71da19e14dcc132f5f56daad49b5296c.1633589385.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633589385.git.leonro@nvidia.com>
References: <cover.1633589385.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Introduce new devlink call to set reload ops callbacks during
device initialization phase after devlink_alloc() is already
called.

This allows us to set reload ops based on device property which
is not known at the beginning of driver initialization.

For the sake of simplicity, this API lacks any type of locking and
needs to be called before devlink_register() to make sure that no
parallel access to the ops is possible at this stage.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  4 ++
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  4 ++
 drivers/net/ethernet/mellanox/mlx4/main.c     |  8 +++-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 10 ++--
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 12 +++--
 drivers/net/netdevsim/dev.c                   | 10 ++--
 include/net/devlink.h                         | 25 ++++++----
 net/core/devlink.c                            | 48 ++++++++++++++-----
 8 files changed, 87 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 59b0ae7d59e0..27b485427c5d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -99,6 +99,9 @@ static int hclge_devlink_reload_up(struct devlink *devlink,
 
 static const struct devlink_ops hclge_devlink_ops = {
 	.info_get = hclge_devlink_info_get,
+};
+
+static const struct devlink_reload_ops hclge_devlink_reload_ops = {
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down = hclge_devlink_reload_down,
 	.reload_up = hclge_devlink_reload_up,
@@ -119,6 +122,7 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
+	devlink_set_reload_ops(devlink, &hclge_devlink_reload_ops);
 	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index d60cc9426f70..77545f841246 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -100,6 +100,9 @@ static int hclgevf_devlink_reload_up(struct devlink *devlink,
 
 static const struct devlink_ops hclgevf_devlink_ops = {
 	.info_get = hclgevf_devlink_info_get,
+};
+
+static const struct devlink_reload_ops hclgevf_devlink_reload_ops = {
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down = hclgevf_devlink_reload_down,
 	.reload_up = hclgevf_devlink_reload_up,
@@ -121,6 +124,7 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
+	devlink_set_reload_ops(devlink, &hclgevf_devlink_reload_ops);
 	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 9541f3a920c8..4c0846727888 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3982,9 +3982,12 @@ static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 
 static const struct devlink_ops mlx4_devlink_ops = {
 	.port_type_set	= mlx4_devlink_port_type_set,
+};
+
+static const struct devlink_reload_ops mlx4_devlink_reload_ops = {
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
-	.reload_down	= mlx4_devlink_reload_down,
-	.reload_up	= mlx4_devlink_reload_up,
+	.reload_down = mlx4_devlink_reload_down,
+	.reload_up = mlx4_devlink_reload_up,
 };
 
 static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -4025,6 +4028,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_params_unregister;
 
 	pci_save_state(pdev);
+	devlink_set_reload_ops(devlink, &mlx4_devlink_reload_ops);
 	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index b9a6cea03951..22c4afbc77dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -314,14 +314,17 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
+	.trap_init = mlx5_devlink_trap_init,
+	.trap_fini = mlx5_devlink_trap_fini,
+	.trap_action_set = mlx5_devlink_trap_action_set,
+};
+
+static const struct devlink_reload_ops mlx5_devlink_reload_ops = {
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_limits = BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
-	.trap_init = mlx5_devlink_trap_init,
-	.trap_fini = mlx5_devlink_trap_fini,
-	.trap_action_set = mlx5_devlink_trap_action_set,
 };
 
 void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, struct sk_buff *skb,
@@ -813,6 +816,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	devlink_set_reload_ops(devlink, &mlx5_devlink_reload_ops);
 	return 0;
 
 traps_reg_err:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 9e831e8b607a..c42ab675a1d6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1615,10 +1615,6 @@ mlxsw_devlink_trap_policer_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops mlxsw_devlink_ops = {
-	.reload_actions		= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
-				  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
-	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
-	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
 	.port_type_set			= mlxsw_devlink_port_type_set,
 	.port_split			= mlxsw_devlink_port_split,
 	.port_unsplit			= mlxsw_devlink_port_unsplit,
@@ -1645,6 +1641,13 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 	.trap_policer_counter_get	= mlxsw_devlink_trap_policer_counter_get,
 };
 
+static const struct devlink_reload_ops mlxsw_devlink_reload_ops = {
+	.reload_actions		= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+				  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
+	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
+	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
+};
+
 static int mlxsw_core_params_register(struct mlxsw_core *mlxsw_core)
 {
 	int err;
@@ -2008,6 +2011,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	}
 
 	if (!reload) {
+		devlink_set_reload_ops(devlink, &mlxsw_devlink_reload_ops);
 		devlink_register(devlink);
 		devlink_reload_enable(devlink);
 	}
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index cb6645012a30..a7a09d49a402 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1246,9 +1246,6 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.eswitch_mode_get = nsim_devlink_eswitch_mode_get,
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
 					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
-	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
-	.reload_down = nsim_dev_reload_down,
-	.reload_up = nsim_dev_reload_up,
 	.info_get = nsim_dev_info_get,
 	.flash_update = nsim_dev_flash_update,
 	.trap_init = nsim_dev_devlink_trap_init,
@@ -1267,6 +1264,12 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.trap_drop_counter_get = nsim_dev_devlink_trap_drop_counter_get,
 };
 
+static const struct devlink_reload_ops nsim_dev_devlink_reload_ops = {
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.reload_down = nsim_dev_reload_down,
+	.reload_up = nsim_dev_reload_up,
+};
+
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
 #define NSIM_DEV_TEST1_DEFAULT true
 
@@ -1511,6 +1514,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_psample_exit;
 
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
+	devlink_set_reload_ops(devlink, &nsim_dev_devlink_reload_ops);
 	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ae03eb1c6cc9..568343cc45f5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1193,15 +1193,6 @@ struct devlink_ops {
 	 * implemementation.
 	 */
 	u32 supported_flash_update_params;
-	unsigned long reload_actions;
-	unsigned long reload_limits;
-	int (*reload_down)(struct devlink *devlink, bool netns_change,
-			   enum devlink_reload_action action,
-			   enum devlink_reload_limit limit,
-			   struct netlink_ext_ack *extack);
-	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
-			 enum devlink_reload_limit limit, u32 *actions_performed,
-			 struct netlink_ext_ack *extack);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
 	int (*port_split)(struct devlink *devlink, unsigned int port_index,
@@ -1482,6 +1473,20 @@ struct devlink_ops {
 				    struct netlink_ext_ack *extack);
 };
 
+struct devlink_reload_ops {
+	unsigned long reload_actions;
+	unsigned long reload_limits;
+	int (*reload_down)(struct devlink *devlink, bool netns_change,
+			   enum devlink_reload_action action,
+			   enum devlink_reload_limit limit,
+			   struct netlink_ext_ack *extack);
+	int (*reload_up)(struct devlink *devlink,
+			 enum devlink_reload_action action,
+			 enum devlink_reload_limit limit,
+			 u32 *actions_performed,
+			 struct netlink_ext_ack *extack);
+};
+
 void *devlink_priv(struct devlink *devlink);
 struct devlink *priv_to_devlink(void *priv);
 struct device *devlink_to_dev(const struct devlink *devlink);
@@ -1520,6 +1525,8 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 {
 	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
+void devlink_set_reload_ops(struct devlink *devlink,
+			    const struct devlink_reload_ops *ops);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_reload_enable(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4e484afeadea..b0596a9065e2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -54,6 +54,7 @@ struct devlink {
 	struct list_head trap_group_list;
 	struct list_head trap_policer_list;
 	const struct devlink_ops *ops;
+	const struct devlink_reload_ops *reload_ops;
 	struct xarray snapshot_ids;
 	struct devlink_dev_stats stats;
 	struct device *dev;
@@ -683,13 +684,15 @@ devlink_reload_combination_is_invalid(enum devlink_reload_action action,
 static bool
 devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
 {
-	return test_bit(action, &devlink->ops->reload_actions);
+	return devlink->reload_ops &&
+	       test_bit(action, &devlink->reload_ops->reload_actions);
 }
 
 static bool
 devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_limit limit)
 {
-	return test_bit(limit, &devlink->ops->reload_limits);
+	return devlink->reload_ops &&
+	       test_bit(limit, &devlink->reload_ops->reload_limits);
 }
 
 static int devlink_reload_stat_put(struct sk_buff *msg,
@@ -3954,9 +3957,9 @@ static void devlink_ns_change_notify(struct devlink *devlink,
 		devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
 
-static bool devlink_reload_supported(const struct devlink_ops *ops)
+static bool devlink_reload_supported(const struct devlink_reload_ops *ops)
 {
-	return ops->reload_down && ops->reload_up;
+	return ops && ops->reload_down && ops->reload_up;
 }
 
 static void devlink_reload_failed_set(struct devlink *devlink,
@@ -4042,14 +4045,16 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 
 	curr_net = devlink_net(devlink);
 	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
-	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
+	err = devlink->reload_ops->reload_down(devlink, !!dest_net, action,
+					       limit, extack);
 	if (err)
 		return err;
 
 	if (dest_net && !net_eq(dest_net, curr_net))
 		write_pnet(&devlink->_net, dest_net);
 
-	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
+	err = devlink->reload_ops->reload_up(devlink, action, limit,
+					     actions_performed, extack);
 	devlink_reload_failed_set(devlink, !!err);
 	if (err)
 		return err;
@@ -4104,7 +4109,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	u32 actions_performed;
 	int err;
 
-	if (!devlink_reload_supported(devlink->ops))
+	if (!devlink_reload_supported(devlink->reload_ops))
 		return -EOPNOTSUPP;
 
 	err = devlink_resources_validate(devlink, NULL, info);
@@ -8958,7 +8963,7 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
 };
 
-static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
+static bool devlink_reload_actions_valid(const struct devlink_reload_ops *ops)
 {
 	const struct devlink_reload_combination *comb;
 	int i;
@@ -8987,6 +8992,25 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
 	return true;
 }
 
+/**
+ *	devlink_set_reload_ops - Set devlink reload ops
+ *
+ *	@devlink: devlink
+ *	@ops: devlink reload ops to set
+ *
+ *	This interface allows us to set reload ops separatelly from
+ *	the devlink_alloc.
+ */
+void devlink_set_reload_ops(struct devlink *devlink,
+			    const struct devlink_reload_ops *ops)
+{
+	WARN_ON(!devlink_reload_actions_valid(ops));
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
+	devlink->reload_ops = ops;
+}
+EXPORT_SYMBOL_GPL(devlink_set_reload_ops);
+
 /**
  *	devlink_alloc_ns - Allocate new devlink instance resources
  *	in specific namespace
@@ -9008,8 +9032,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	int ret;
 
 	WARN_ON(!ops || !dev);
-	if (!devlink_reload_actions_valid(ops))
-		return NULL;
 
 	devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
 	if (!devlink)
@@ -9157,7 +9179,7 @@ void devlink_unregister(struct devlink *devlink)
 	wait_for_completion(&devlink->comp);
 
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink_reload_supported(devlink->ops) &&
+	WARN_ON(devlink_reload_supported(devlink->reload_ops) &&
 		devlink->reload_enabled);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
@@ -10315,7 +10337,7 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
-	if (!devlink_reload_supported(devlink->ops))
+	if (!devlink_reload_supported(devlink->reload_ops))
 		return -EOPNOTSUPP;
 
 	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
@@ -11518,7 +11540,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		if (!net_eq(devlink_net(devlink), net))
 			goto retry;
 
-		WARN_ON(!devlink_reload_supported(devlink->ops));
+		WARN_ON(!devlink_reload_supported(devlink->reload_ops));
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 				     DEVLINK_RELOAD_LIMIT_UNSPEC,
-- 
2.31.1

