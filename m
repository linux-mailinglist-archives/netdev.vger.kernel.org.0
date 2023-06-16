Return-Path: <netdev+bounces-11575-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B34DF733A54
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6F941C20B79
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A87A200AF;
	Fri, 16 Jun 2023 20:01:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBF61F953
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522F7C433AD;
	Fri, 16 Jun 2023 20:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945689;
	bh=wsIjT8LxzmX0bCB5RWtf+RttD7WbTbOBDCUAIsKiQEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ero2IRsHoyEl4wKvRvFNgeU3m5m7OCVziAqsuZZL7UTW/Ir53B6KK0fu/YIQ7xJQP
	 inZxQbB1tDjfOm+kKsjH/kbephzifboPtHIbiblecKovlfv47oPo/H3n1/Vvpxd2Sr
	 7W9aZlMx6WnMvQ1B5ahPH+C/z1/JyCL7GPLufvgfomV+qCh6r+U4uweC7qwEAl09xA
	 qiuqAvOpj8AYqpisLkmYPSzz0GwUkRQNwxO/0ftN7q9QJoDgR3O8sVpCWW7sfH6JIY
	 SyPzuEfEWe1wGiOJPZ/NHC3Wu1yKECyliGxkcvdgZS0h9j8QXTENEsoDDC9jKFScO1
	 dwe+S6Z0kwiyA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>
Subject: [net 06/12] net/mlx5: DR, Support SW created encap actions for FW table
Date: Fri, 16 Jun 2023 13:01:13 -0700
Message-Id: <20230616200119.44163-7-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616200119.44163-1-saeed@kernel.org>
References: <20230616200119.44163-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

In some cases, steering might need to use SW-created action in
FW table, which results in wrong packet reformat being used:

  mlx5_core 0000:81:00.1: mlx5_cmd_check:756:(pid 1154):
      SET_FLOW_TABLE_ENTRY(0×936) op_mod(0×0) failed,
      status bad resource(0×5), syndrome (0xf2ff71)

This patch adds support for usage of SW-created packet reformat (encap)
actions in FW tables, and adds clear error flow for attempt to use
SW-created modify header on FW tables.

Fixes: 6a48faeeca10 ("net/mlx5: Add direct rule fs_cmd implementation")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 50 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  7 +++
 .../mellanox/mlx5/core/steering/dr_action.c   |  5 ++
 .../mellanox/mlx5/core/steering/fs_dr.c       | 27 +++++++++-
 .../mellanox/mlx5/core/steering/fs_dr.h       |  7 +++
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  2 +
 6 files changed, 83 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 144e59480686..ec83e6483d1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -511,10 +511,11 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 	struct mlx5_flow_rule *dst;
 	void *in_flow_context, *vlan;
 	void *in_match_value;
+	int reformat_id = 0;
 	unsigned int inlen;
 	int dst_cnt_size;
+	u32 *in, action;
 	void *in_dests;
-	u32 *in;
 	int err;
 
 	if (mlx5_set_extended_dest(dev, fte, &extended_dest))
@@ -553,22 +554,42 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 
 	MLX5_SET(flow_context, in_flow_context, extended_destination,
 		 extended_dest);
-	if (extended_dest) {
-		u32 action;
 
-		action = fte->action.action &
-			~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-		MLX5_SET(flow_context, in_flow_context, action, action);
-	} else {
-		MLX5_SET(flow_context, in_flow_context, action,
-			 fte->action.action);
-		if (fte->action.pkt_reformat)
-			MLX5_SET(flow_context, in_flow_context, packet_reformat_id,
-				 fte->action.pkt_reformat->id);
+	action = fte->action.action;
+	if (extended_dest)
+		action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+
+	MLX5_SET(flow_context, in_flow_context, action, action);
+
+	if (!extended_dest && fte->action.pkt_reformat) {
+		struct mlx5_pkt_reformat *pkt_reformat = fte->action.pkt_reformat;
+
+		if (pkt_reformat->owner == MLX5_FLOW_RESOURCE_OWNER_SW) {
+			reformat_id = mlx5_fs_dr_action_get_pkt_reformat_id(pkt_reformat);
+			if (reformat_id < 0) {
+				mlx5_core_err(dev,
+					      "Unsupported SW-owned pkt_reformat type (%d) in FW-owned table\n",
+					      pkt_reformat->reformat_type);
+				err = reformat_id;
+				goto err_out;
+			}
+		} else {
+			reformat_id = fte->action.pkt_reformat->id;
+		}
 	}
-	if (fte->action.modify_hdr)
+
+	MLX5_SET(flow_context, in_flow_context, packet_reformat_id, (u32)reformat_id);
+
+	if (fte->action.modify_hdr) {
+		if (fte->action.modify_hdr->owner == MLX5_FLOW_RESOURCE_OWNER_SW) {
+			mlx5_core_err(dev, "Can't use SW-owned modify_hdr in FW-owned table\n");
+			err = -EOPNOTSUPP;
+			goto err_out;
+		}
+
 		MLX5_SET(flow_context, in_flow_context, modify_header_id,
 			 fte->action.modify_hdr->id);
+	}
 
 	MLX5_SET(flow_context, in_flow_context, encrypt_decrypt_type,
 		 fte->action.crypto.type);
@@ -885,6 +906,8 @@ static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
 
 	pkt_reformat->id = MLX5_GET(alloc_packet_reformat_context_out,
 				    out, packet_reformat_id);
+	pkt_reformat->owner = MLX5_FLOW_RESOURCE_OWNER_FW;
+
 	kfree(in);
 	return err;
 }
@@ -969,6 +992,7 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 
 	modify_hdr->id = MLX5_GET(alloc_modify_header_context_out, out, modify_header_id);
+	modify_hdr->owner = MLX5_FLOW_RESOURCE_OWNER_FW;
 	kfree(in);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index f137a0611b77..b043190e50a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -54,8 +54,14 @@ struct mlx5_flow_definer {
 	u32 id;
 };
 
+enum mlx5_flow_resource_owner {
+	MLX5_FLOW_RESOURCE_OWNER_FW,
+	MLX5_FLOW_RESOURCE_OWNER_SW,
+};
+
 struct mlx5_modify_hdr {
 	enum mlx5_flow_namespace_type ns_type;
+	enum mlx5_flow_resource_owner owner;
 	union {
 		struct mlx5_fs_dr_action action;
 		u32 id;
@@ -65,6 +71,7 @@ struct mlx5_modify_hdr {
 struct mlx5_pkt_reformat {
 	enum mlx5_flow_namespace_type ns_type;
 	int reformat_type; /* from mlx5_ifc */
+	enum mlx5_flow_resource_owner owner;
 	union {
 		struct mlx5_fs_dr_action action;
 		u32 id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 0eb9a8d7f282..57e22c5170df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -2129,6 +2129,11 @@ mlx5dr_action_create_aso(struct mlx5dr_domain *dmn, u32 obj_id,
 	return action;
 }
 
+u32 mlx5dr_action_get_pkt_reformat_id(struct mlx5dr_action *action)
+{
+	return action->reformat->id;
+}
+
 int mlx5dr_action_destroy(struct mlx5dr_action *action)
 {
 	if (WARN_ON_ONCE(refcount_read(&action->refcount) > 1))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 984653756779..cc215beb7436 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -331,8 +331,16 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	}
 
 	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT) {
-		bool is_decap = fte->action.pkt_reformat->reformat_type ==
-			MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2;
+		bool is_decap;
+
+		if (fte->action.pkt_reformat->owner == MLX5_FLOW_RESOURCE_OWNER_FW) {
+			err = -EINVAL;
+			mlx5dr_err(domain, "FW-owned reformat can't be used in SW rule\n");
+				goto free_actions;
+		}
+
+		is_decap = fte->action.pkt_reformat->reformat_type ==
+			   MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2;
 
 		if (is_decap)
 			actions[num_actions++] =
@@ -661,6 +669,7 @@ static int mlx5_cmd_dr_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns
 		return -EINVAL;
 	}
 
+	pkt_reformat->owner = MLX5_FLOW_RESOURCE_OWNER_SW;
 	pkt_reformat->action.dr_action = action;
 
 	return 0;
@@ -691,6 +700,7 @@ static int mlx5_cmd_dr_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 		return -EINVAL;
 	}
 
+	modify_hdr->owner = MLX5_FLOW_RESOURCE_OWNER_SW;
 	modify_hdr->action.dr_action = action;
 
 	return 0;
@@ -816,6 +826,19 @@ static u32 mlx5_cmd_dr_get_capabilities(struct mlx5_flow_root_namespace *ns,
 	return steering_caps;
 }
 
+int mlx5_fs_dr_action_get_pkt_reformat_id(struct mlx5_pkt_reformat *pkt_reformat)
+{
+	switch (pkt_reformat->reformat_type) {
+	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
+	case MLX5_REFORMAT_TYPE_L2_TO_NVGRE:
+	case MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL:
+	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
+	case MLX5_REFORMAT_TYPE_INSERT_HDR:
+		return mlx5dr_action_get_pkt_reformat_id(pkt_reformat->action.dr_action);
+	}
+	return -EOPNOTSUPP;
+}
+
 bool mlx5_fs_dr_is_supported(struct mlx5_core_dev *dev)
 {
 	return mlx5dr_is_supported(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
index d168622063d5..99a3b2eff6b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.h
@@ -38,6 +38,8 @@ struct mlx5_fs_dr_table {
 
 bool mlx5_fs_dr_is_supported(struct mlx5_core_dev *dev);
 
+int mlx5_fs_dr_action_get_pkt_reformat_id(struct mlx5_pkt_reformat *pkt_reformat);
+
 const struct mlx5_flow_cmds *mlx5_fs_cmd_get_dr_cmds(void);
 
 #else
@@ -47,6 +49,11 @@ static inline const struct mlx5_flow_cmds *mlx5_fs_cmd_get_dr_cmds(void)
 	return NULL;
 }
 
+static inline u32 mlx5_fs_dr_action_get_pkt_reformat_id(struct mlx5_pkt_reformat *pkt_reformat)
+{
+	return 0;
+}
+
 static inline bool mlx5_fs_dr_is_supported(struct mlx5_core_dev *dev)
 {
 	return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 9afd268a2573..d1c04f43d86d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -150,6 +150,8 @@ mlx5dr_action_create_dest_match_range(struct mlx5dr_domain *dmn,
 
 int mlx5dr_action_destroy(struct mlx5dr_action *action);
 
+u32 mlx5dr_action_get_pkt_reformat_id(struct mlx5dr_action *action);
+
 int mlx5dr_definer_get(struct mlx5dr_domain *dmn, u16 format_id,
 		       u8 *dw_selectors, u8 *byte_selectors,
 		       u8 *match_mask, u32 *definer_id);
-- 
2.40.1


