Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2F948A53E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346236AbiAKBn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346237AbiAKBny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D64C061756
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 17:43:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C0226147C
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A14C36AFB;
        Tue, 11 Jan 2022 01:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865433;
        bh=p5IJCdoJsn6GB4p/cu6GWb2VpCCWTzihPqg/yoZq9Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=giv9UtbvmmLj5XomcIxMIeygBAYN4ufxXduNX6Qj4gr3xHk7I5rckOSQs7BxewT6+
         sMNJIhGJSpk2Xpm0bUzckUi6QUqM5Moq7xmOkcNpihVaf+OvLRcjDV4bF7y02LU87g
         p/ZDv8Zdxwfc6XjvfDmVWy2s8iXsyDFYJiwPGBeA2jWTR3W7HuU8+uzWPFEFmzFgfU
         u6wFGM2tpjLlJsOcNlH70j155ntWvykI2ygLShlDLlvL2qxISEXb3d/avcUHsv+3Ub
         lr5xQFRp2cAzc4mzofSW81y3VoBlJVxgS6cbyi4s2wIEq34XIHhuOZjvWC9eFTheJL
         8jFpTElccj8wA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/17] net/mlx5: Introduce software defined steering capabilities
Date:   Mon, 10 Jan 2022 17:43:34 -0800
Message-Id: <20220111014335.178121-17-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

There are two different internal steering modes, abstracted from the
rest of the driver. In order to keep upper layer of the driver agnostic
to the differences in capabilities of the steering modes, this patch
introduces mlx5_fs_get_capabilities() API to check if a certain software
defined capability is supported. It differs from the capabilities
exposed by the hardware, as it takes into account the flow steering mode
(SMFS/DMFS) currently enabled.

This implementation supports only two capability flags:

  MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX
  MLX5_FLOW_STEERING_CAP_VLAN_POP_ON_TX

They map to DR_ACTION_STATE_PUSH_VLAN and DR_ACTION_STATE_POP_VLAN
actions, implemented in SW steering earlier in commit f5e22be534e0
("net/mlx5: DR, Split modify VLAN state to separate pop/push states").
Which enables using of pop/push vlan without restrictions, e.g. doing
vlan pop on TX and RX, compared to FW steering that supports only vlan
pop on RX and push on TX.

Other capabilities can be added in the future.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 14 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h |  3 +++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c    | 16 ++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/fs_core.h    |  7 +++++++
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c | 11 +++++++++++
 5 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index dafe341358c7..a0ac17c3f12f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -152,6 +152,12 @@ static int mlx5_cmd_stub_destroy_ns(struct mlx5_flow_root_namespace *ns)
 	return 0;
 }
 
+static u32 mlx5_cmd_stub_get_capabilities(struct mlx5_flow_root_namespace *ns,
+					  enum fs_flow_table_type ft_type)
+{
+	return 0;
+}
+
 static int mlx5_cmd_set_slave_root_fdb(struct mlx5_core_dev *master,
 				       struct mlx5_core_dev *slave,
 				       bool ft_id_valid,
@@ -971,6 +977,12 @@ static int mlx5_cmd_create_match_definer(struct mlx5_flow_root_namespace *ns,
 	return err ? err : MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
 }
 
+static u32 mlx5_cmd_get_capabilities(struct mlx5_flow_root_namespace *ns,
+				     enum fs_flow_table_type ft_type)
+{
+	return 0;
+}
+
 static const struct mlx5_flow_cmds mlx5_flow_cmds = {
 	.create_flow_table = mlx5_cmd_create_flow_table,
 	.destroy_flow_table = mlx5_cmd_destroy_flow_table,
@@ -990,6 +1002,7 @@ static const struct mlx5_flow_cmds mlx5_flow_cmds = {
 	.set_peer = mlx5_cmd_stub_set_peer,
 	.create_ns = mlx5_cmd_stub_create_ns,
 	.destroy_ns = mlx5_cmd_stub_destroy_ns,
+	.get_capabilities = mlx5_cmd_get_capabilities,
 };
 
 static const struct mlx5_flow_cmds mlx5_flow_cmd_stubs = {
@@ -1011,6 +1024,7 @@ static const struct mlx5_flow_cmds mlx5_flow_cmd_stubs = {
 	.set_peer = mlx5_cmd_stub_set_peer,
 	.create_ns = mlx5_cmd_stub_create_ns,
 	.destroy_ns = mlx5_cmd_stub_destroy_ns,
+	.get_capabilities = mlx5_cmd_stub_get_capabilities,
 };
 
 const struct mlx5_flow_cmds *mlx5_fs_cmd_get_fw_cmds(void)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
index 220ec632d35a..274004e80f03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -101,6 +101,9 @@ struct mlx5_flow_cmds {
 				    u16 format_id, u32 *match_mask);
 	int (*destroy_match_definer)(struct mlx5_flow_root_namespace *ns,
 				     int definer_id);
+
+	u32 (*get_capabilities)(struct mlx5_flow_root_namespace *ns,
+				enum fs_flow_table_type ft_type);
 };
 
 int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index b628917e38e4..42f878e21fea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -3040,6 +3040,22 @@ void mlx5_fs_ingress_acls_cleanup(struct mlx5_core_dev *dev)
 	steering->esw_ingress_root_ns = NULL;
 }
 
+u32 mlx5_fs_get_capabilities(struct mlx5_core_dev *dev, enum mlx5_flow_namespace_type type)
+{
+	struct mlx5_flow_root_namespace *root;
+	struct mlx5_flow_namespace *ns;
+
+	ns = mlx5_get_flow_namespace(dev, type);
+	if (!ns)
+		return 0;
+
+	root = find_root(&ns->node);
+	if (!root)
+		return 0;
+
+	return root->cmds->get_capabilities(root, root->table_type);
+}
+
 static int init_egress_root_ns(struct mlx5_flow_steering *steering)
 {
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 5469b08d635f..c488a7c5b07e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -120,6 +120,11 @@ enum mlx5_flow_steering_mode {
 	MLX5_FLOW_STEERING_MODE_SMFS
 };
 
+enum mlx5_flow_steering_capabilty {
+	MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX = 1UL << 0,
+	MLX5_FLOW_STEERING_CAP_VLAN_POP_ON_TX = 1UL << 1,
+};
+
 struct mlx5_flow_steering {
 	struct mlx5_core_dev *dev;
 	enum   mlx5_flow_steering_mode	mode;
@@ -301,6 +306,8 @@ void mlx5_fs_egress_acls_cleanup(struct mlx5_core_dev *dev);
 int mlx5_fs_ingress_acls_init(struct mlx5_core_dev *dev, int total_vports);
 void mlx5_fs_ingress_acls_cleanup(struct mlx5_core_dev *dev);
 
+u32 mlx5_fs_get_capabilities(struct mlx5_core_dev *dev, enum mlx5_flow_namespace_type type);
+
 struct mlx5_flow_root_namespace *find_root(struct fs_node *node);
 
 #define fs_get_obj(v, _node)  {v = container_of((_node), typeof(*v), node); }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index a476da2424f8..033757bfdf64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -735,6 +735,16 @@ static int mlx5_cmd_dr_destroy_ns(struct mlx5_flow_root_namespace *ns)
 	return mlx5dr_domain_destroy(ns->fs_dr_domain.dr_domain);
 }
 
+static u32 mlx5_cmd_dr_get_capabilities(struct mlx5_flow_root_namespace *ns,
+					enum fs_flow_table_type ft_type)
+{
+	if (ft_type != FS_FT_FDB ||
+	    MLX5_CAP_GEN(ns->dev, steering_format_version) != MLX5_STEERING_FORMAT_CONNECTX_6DX)
+		return 0;
+
+	return MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX | MLX5_FLOW_STEERING_CAP_VLAN_POP_ON_TX;
+}
+
 bool mlx5_fs_dr_is_supported(struct mlx5_core_dev *dev)
 {
 	return mlx5dr_is_supported(dev);
@@ -759,6 +769,7 @@ static const struct mlx5_flow_cmds mlx5_flow_cmds_dr = {
 	.set_peer = mlx5_cmd_dr_set_peer,
 	.create_ns = mlx5_cmd_dr_create_ns,
 	.destroy_ns = mlx5_cmd_dr_destroy_ns,
+	.get_capabilities = mlx5_cmd_dr_get_capabilities,
 };
 
 const struct mlx5_flow_cmds *mlx5_fs_cmd_get_dr_cmds(void)
-- 
2.34.1

