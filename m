Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDFC3F261B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbhHTE4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233073AbhHTE4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7DC460FF2;
        Fri, 20 Aug 2021 04:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435326;
        bh=q5prN//hKPuQsMDIrmHHS2ddHAxCEB/ocOW4V14wKDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcIe5QafImpdLes+0eU37ETSGRc7TCKZIaRK57a20fWYNtC1KnHtPHRKy53/pAW+U
         EEfPpm99NW6Tob+Ye5xUm9Osr8ngIhKsir6PfcQStDCbb2ZDpoMOJy6QbJJ+5OiCgL
         XMxvX/vm+qkxh+RTVMeHZZ6RFgwb57+M6Q6EEjH9yeYB+feQmQwofn2HU5uzmwWIvI
         6YApdW1+mCAlrVvb2Jb8NxDcUJO5dc742E00VgzSy6BGrtsThSn7aJsTsYHEAfhjQL
         uJemsA63ZyBM+OMOTjwFlSdUM/Q7GunVsGOBG8rMtC+qu+UB9W64Uz0UiAgX1Kbtwa
         zfWPpuQWX2oew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Introduce post action infrastructure
Date:   Thu, 19 Aug 2021 21:55:05 -0700
Message-Id: <20210820045515.265297-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Some tc actions are modeled in hardware using multiple tables
causing a tc action list split. For example, CT action is modeled
by jumping to a ct table which is controlled by nf flowtable.
sFlow jumps in hardware to a sample table, which continues to a
"default table" where it should continue processing the action list.

Multi table actions are modeled in hardware using a unique fte_id.
The fte_id is set before jumping to a table. Split actions continue
to a post-action table where the matched fte_id value continues the
execution the tc action list.

Currently the post-action design is implemented only by the ct
action. Introduce post action infrastructure as a pre-step for
reusing it with the sFlow offload feature. Init and destroy the
common post action table. Refactor the ct offload to use the
common post table infrastructure in the next patch.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../mellanox/mlx5/core/en/tc/post_act.c       | 62 +++++++++++++++++++
 .../mellanox/mlx5/core/en/tc/post_act.h       | 17 +++++
 3 files changed, 81 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 34e17e502e40..024d72b3b1aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -44,7 +44,8 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					lib/fs_chains.o en/tc_tun.o \
 					esw/indir_table.o en/tc_tun_encap.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
-					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o
+					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o \
+					en/tc/post_act.o
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
new file mode 100644
index 000000000000..cd729557b17b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "post_act.h"
+#include "mlx5_core.h"
+
+struct mlx5e_post_act {
+	enum mlx5_flow_namespace_type ns_type;
+	struct mlx5_fs_chains *chains;
+	struct mlx5_flow_table *ft;
+	struct mlx5e_priv *priv;
+};
+
+struct mlx5e_post_act *
+mlx5e_tc_post_act_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
+		       enum mlx5_flow_namespace_type ns_type)
+{
+	struct mlx5e_post_act *post_act;
+	int err;
+
+	if (ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+	    !MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev, ignore_flow_level)) {
+		mlx5_core_warn(priv->mdev, "firmware level support is missing\n");
+		err = -EOPNOTSUPP;
+		goto err_check;
+	} else if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level)) {
+		mlx5_core_warn(priv->mdev, "firmware level support is missing\n");
+		err = -EOPNOTSUPP;
+		goto err_check;
+	}
+
+	post_act = kzalloc(sizeof(*post_act), GFP_KERNEL);
+	if (!post_act) {
+		err = -ENOMEM;
+		goto err_check;
+	}
+	post_act->ft = mlx5_chains_create_global_table(chains);
+	if (IS_ERR(post_act->ft)) {
+		err = PTR_ERR(post_act->ft);
+		mlx5_core_warn(priv->mdev, "failed to create post action table, err: %d\n", err);
+		goto err_ft;
+	}
+	post_act->chains = chains;
+	post_act->ns_type = ns_type;
+	post_act->priv = priv;
+	return post_act;
+
+err_ft:
+	kfree(post_act);
+err_check:
+	return ERR_PTR(err);
+}
+
+void
+mlx5e_tc_post_act_destroy(struct mlx5e_post_act *post_act)
+{
+	if (IS_ERR_OR_NULL(post_act))
+		return;
+
+	mlx5_chains_destroy_global_table(post_act->chains, post_act->ft);
+	kfree(post_act);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
new file mode 100644
index 000000000000..a7ac69ef7b07
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_POST_ACTION_H__
+#define __MLX5_POST_ACTION_H__
+
+#include "en.h"
+#include "lib/fs_chains.h"
+
+struct mlx5e_post_act *
+mlx5e_tc_post_act_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
+		       enum mlx5_flow_namespace_type ns_type);
+
+void
+mlx5e_tc_post_act_destroy(struct mlx5e_post_act *post_act);
+
+#endif /* __MLX5_POST_ACTION_H__ */
-- 
2.31.1

