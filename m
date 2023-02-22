Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B188169FF31
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 00:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbjBVXDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 18:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjBVXCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 18:02:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E904989B
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 15:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C62615C7
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 23:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6685EC433EF;
        Wed, 22 Feb 2023 23:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677106932;
        bh=x7QcyxihVxbtFF+SbFW3c0SnjWYdp9O97pJz4+wu17I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAjaK16vbAY40CJ+ofm1vwkvsbl045R/9gxzFskUKNPP5jV1aac3GDOTc7wNbgQEl
         my1SdP4Td14XUMJUbiKuJwfTrFD0r6XmygAuTweuizmYfUrE1ws0//goyTqTfjj2VU
         1Em0aqvYg5EUo6/7l3324yobMvOzjvhYCFS+Mb/EGwh33StM0UZ6dQvx1frwH9QVok
         mX/96nqMiKLwPRZws48dhZoBvUGYONLnKUjC/N0iYeC5Ln1stBH3IBf0jkrMcESD1B
         NBwMt4W3S/2PHcBg8Y21S10Th3HCGhlK+XWajmp9GoMw62gHNj61NtDg15zKnTKTYH
         lJPM9xfpnM4Iw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next V2 3/4] net/mlx5e: Add devlink hairpin queues parameters
Date:   Wed, 22 Feb 2023 15:02:01 -0800
Message-Id: <20230222230202.523667-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230222230202.523667-1-saeed@kernel.org>
References: <20230222230202.523667-1-saeed@kernel.org>
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

From: Gal Pressman <gal@nvidia.com>

We refer to a TC NIC rule that involves forwarding as "hairpin".
Hairpin queues are mlx5 hardware specific implementation for hardware
forwarding of such packets.

Per the discussion in [1], move the hairpin queues control (number and
size) from debugfs to devlink.

Expose two devlink params:
- hairpin_num_queues: control the number of hairpin queues
- hairpin_queue_size: control the size (in packets) of the hairpin queues

[1] https://lore.kernel.org/all/20230111194608.7f15b9a1@kernel.org/

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/devlink.rst        | 35 ++++++++++
 Documentation/networking/devlink/mlx5.rst     | 12 ++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 66 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 50 ++++++--------
 5 files changed, 134 insertions(+), 31 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index 9b5c40ba7f0d..0995e4e5acd7 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -122,6 +122,41 @@ users try to enable them.
 
     $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
 
+hairpin_num_queues: Number of hairpin queues
+--------------------------------------------
+We refer to a TC NIC rule that involves forwarding as "hairpin".
+
+Hairpin queues are mlx5 hardware specific implementation for hardware
+forwarding of such packets.
+
+- Show the number of hairpin queues::
+
+    $ devlink dev param show pci/0000:06:00.0 name hairpin_num_queues
+      pci/0000:06:00.0:
+        name hairpin_num_queues type driver-specific
+          values:
+            cmode driverinit value 2
+
+- Change the number of hairpin queues::
+
+    $ devlink dev param set pci/0000:06:00.0 name hairpin_num_queues value 4 cmode driverinit
+
+hairpin_queue_size: Size of the hairpin queues
+----------------------------------------------
+Control the size of the hairpin queues.
+
+- Show the size of the hairpin queues::
+
+    $ devlink dev param show pci/0000:06:00.0 name hairpin_queue_size
+      pci/0000:06:00.0:
+        name hairpin_queue_size type driver-specific
+          values:
+            cmode driverinit value 1024
+
+- Change the size (in packets) of the hairpin queues::
+
+    $ devlink dev param set pci/0000:06:00.0 name hairpin_queue_size value 512 cmode driverinit
+
 Health reporters
 ================
 
diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 3321117cf605..202798d6501e 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -72,6 +72,18 @@ parameters.
 
        Default: disabled
 
+   * - ``hairpin_num_queues``
+     - u32
+     - driverinit
+     - We refer to a TC NIC rule that involves forwarding as "hairpin".
+       Hairpin queues are mlx5 hardware specific implementation for hardware
+       forwarding of such packets.
+
+       Control the number of hairpin queues.
+   * - ``hairpin_queue_size``
+     - u32
+     - driverinit
+     - Control the size (in packets) of the hairpin queues.
 
 The ``mlx5`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c5d2fdcabd56..d4a47f2ec8d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -494,6 +494,61 @@ static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
 	return (val.vu32 >= 64 && val.vu32 <= 4096) ? 0 : -EINVAL;
 }
 
+static int
+mlx5_devlink_hairpin_num_queues_validate(struct devlink *devlink, u32 id,
+					 union devlink_param_value val,
+					 struct netlink_ext_ack *extack)
+{
+	return val.vu32 ? 0 : -EINVAL;
+}
+
+static int
+mlx5_devlink_hairpin_queue_size_validate(struct devlink *devlink, u32 id,
+					 union devlink_param_value val,
+					 struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u32 val32 = val.vu32;
+
+	if (!is_power_of_2(val32)) {
+		NL_SET_ERR_MSG_MOD(extack, "Value is not power of two");
+		return -EINVAL;
+	}
+
+	if (val32 > BIT(MLX5_CAP_GEN(dev, log_max_hairpin_num_packets))) {
+		NL_SET_ERR_MSG_FMT_MOD(
+			extack, "Maximum hairpin queue size is %lu",
+			BIT(MLX5_CAP_GEN(dev, log_max_hairpin_num_packets)));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void mlx5_devlink_hairpin_params_init_values(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	union devlink_param_value value;
+	u64 link_speed64;
+	u32 link_speed;
+
+	/* set hairpin pair per each 50Gbs share of the link */
+	mlx5_port_max_linkspeed(dev, &link_speed);
+	link_speed = max_t(u32, link_speed, 50000);
+	link_speed64 = link_speed;
+	do_div(link_speed64, 50000);
+
+	value.vu32 = link_speed64;
+	devl_param_driverinit_value_set(
+		devlink, MLX5_DEVLINK_PARAM_ID_HAIRPIN_NUM_QUEUES, value);
+
+	value.vu32 =
+		BIT(min_t(u32, 16 - MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(dev),
+			  MLX5_CAP_GEN(dev, log_max_hairpin_num_packets)));
+	devl_param_driverinit_value_set(
+		devlink, MLX5_DEVLINK_PARAM_ID_HAIRPIN_QUEUE_SIZE, value);
+}
+
 static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_ROCE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_enable_roce_validate),
@@ -547,6 +602,14 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 static const struct devlink_param mlx5_devlink_eth_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_ETH, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_HAIRPIN_NUM_QUEUES,
+			     "hairpin_num_queues", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT), NULL, NULL,
+			     mlx5_devlink_hairpin_num_queues_validate),
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_HAIRPIN_QUEUE_SIZE,
+			     "hairpin_queue_size", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT), NULL, NULL,
+			     mlx5_devlink_hairpin_queue_size_validate),
 };
 
 static int mlx5_devlink_eth_params_register(struct devlink *devlink)
@@ -567,6 +630,9 @@ static int mlx5_devlink_eth_params_register(struct devlink *devlink)
 	devl_param_driverinit_value_set(devlink,
 					DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
 					value);
+
+	mlx5_devlink_hairpin_params_init_values(devlink);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index 212b12424146..5dcfb4d86d8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -12,6 +12,8 @@ enum mlx5_devlink_param_id {
 	MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
 	MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
 	MLX5_DEVLINK_PARAM_ID_ESW_MULTIPORT,
+	MLX5_DEVLINK_PARAM_ID_HAIRPIN_NUM_QUEUES,
+	MLX5_DEVLINK_PARAM_ID_HAIRPIN_QUEUE_SIZE,
 };
 
 struct mlx5_trap_ctx {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 79dd8ad5ede7..2e6351ef4d9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -44,6 +44,7 @@
 #include <net/bareudp.h>
 #include <net/bonding.h>
 #include <net/dst_metadata.h>
+#include "devlink.h"
 #include "en.h"
 #include "en/tc/post_act.h"
 #include "en/tc/act_stats.h"
@@ -73,12 +74,6 @@
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
 #define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(18)
 
-struct mlx5e_hairpin_params {
-	struct mlx5_core_dev *mdev;
-	u32 num_queues;
-	u32 queue_size;
-};
-
 struct mlx5e_tc_table {
 	/* Protects the dynamic assignment of the t parameter
 	 * which is the nic tc root table.
@@ -101,7 +96,6 @@ struct mlx5e_tc_table {
 
 	struct mlx5_tc_ct_priv         *ct;
 	struct mapping_ctx             *mapping;
-	struct mlx5e_hairpin_params    hairpin_params;
 	struct dentry                  *dfs_root;
 
 	/* tc action stats */
@@ -1099,33 +1093,15 @@ static void mlx5e_tc_debugfs_init(struct mlx5e_tc_table *tc,
 			    &debugfs_hairpin_table_dump_fops);
 }
 
-static void
-mlx5e_hairpin_params_init(struct mlx5e_hairpin_params *hairpin_params,
-			  struct mlx5_core_dev *mdev)
-{
-	u64 link_speed64;
-	u32 link_speed;
-
-	hairpin_params->mdev = mdev;
-	/* set hairpin pair per each 50Gbs share of the link */
-	mlx5_port_max_linkspeed(mdev, &link_speed);
-	link_speed = max_t(u32, link_speed, 50000);
-	link_speed64 = link_speed;
-	do_div(link_speed64, 50000);
-	hairpin_params->num_queues = link_speed64;
-
-	hairpin_params->queue_size =
-		BIT(min_t(u32, 16 - MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(mdev),
-			  MLX5_CAP_GEN(mdev, log_max_hairpin_num_packets)));
-}
-
 static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow,
 				  struct mlx5e_tc_flow_parse_attr *parse_attr,
 				  struct netlink_ext_ack *extack)
 {
 	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
+	struct devlink *devlink = priv_to_devlink(priv->mdev);
 	int peer_ifindex = parse_attr->mirred_ifindex[0];
+	union devlink_param_value val = {};
 	struct mlx5_hairpin_params params;
 	struct mlx5_core_dev *peer_mdev;
 	struct mlx5e_hairpin_entry *hpe;
@@ -1182,7 +1158,14 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 		 hash_hairpin_info(peer_id, match_prio));
 	mutex_unlock(&tc->hairpin_tbl_lock);
 
-	params.log_num_packets = ilog2(tc->hairpin_params.queue_size);
+	err = devl_param_driverinit_value_get(
+		devlink, MLX5_DEVLINK_PARAM_ID_HAIRPIN_QUEUE_SIZE, &val);
+	if (err) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	params.log_num_packets = ilog2(val.vu32);
 	params.log_data_size =
 		clamp_t(u32,
 			params.log_num_packets +
@@ -1191,7 +1174,14 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 			MLX5_CAP_GEN(priv->mdev, log_max_hairpin_wq_data_sz));
 
 	params.q_counter = priv->q_counter;
-	params.num_channels = tc->hairpin_params.num_queues;
+	err = devl_param_driverinit_value_get(
+		devlink, MLX5_DEVLINK_PARAM_ID_HAIRPIN_NUM_QUEUES, &val);
+	if (err) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	params.num_channels = val.vu32;
 
 	hp = mlx5e_hairpin_create(priv, &params, peer_ifindex);
 	hpe->hp = hp;
@@ -5289,8 +5279,6 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &tc->mod_hdr,
 				 MLX5_FLOW_NAMESPACE_KERNEL, tc->post_act);
 
-	mlx5e_hairpin_params_init(&tc->hairpin_params, dev);
-
 	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
 	err = register_netdevice_notifier_dev_net(priv->netdev,
 						  &tc->netdevice_nb,
-- 
2.39.1

