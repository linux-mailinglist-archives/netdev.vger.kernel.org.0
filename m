Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F3D564256
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiGBTFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbiGBTEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7069FE6
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B266561007
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080D6C34114;
        Sat,  2 Jul 2022 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788673;
        bh=9WXfAccaWQfGIQfHOAhylNDmhfaT6iSx09r6YXj5aMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7VVnsLFNpDDnjAoiKfXvIzQZ7WoBRqcsnptUSn9Ol4NQyK8UmXABBOs88tCJY4fS
         SV6pUunfM/Is17N7tAtVojzM/UQBoz+McXELUCgMfY3cPLqNyhnAUUwkdLzRwQWOdW
         6TJHRCi7mFYo7U7tMhjt3EXWALDd2X4D6XQgfB+5Cdc8SWRhrKjvMi/jG0nv60iHRM
         9UZ2rBXl5apzg+YuEe+CxNP4r2pBHXGRThRJn7cQ22bZdW1wL3wWl2Oj83munnIYPd
         fS1qAiiDVkD7S+uMjO1VyouStH3lv3uMtG9zrNeeVqVpZ0xZn7iUZQCSmuL24ijmX5
         9VW6wT6pZ5OVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [net-next v2 13/15] net/mlx5e: Add post meter table for flow metering
Date:   Sat,  2 Jul 2022 12:02:11 -0700
Message-Id: <20220702190213.80858-14-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702190213.80858-1-saeed@kernel.org>
References: <20220702190213.80858-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

Flow meter object monitors the packets rate for the flows it is
attached to, and color packets with GREEN or RED. The post meter table
is used to check the color. Packet is dropped if it's RED, or
forwarded to post_act table if GREEN.

Packet color will be set to 8 LSB of the register C5, so they are
reserved for metering, which are previously used for matching fte id.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c |  12 ++
 .../mellanox/mlx5/core/en/tc/post_meter.c     | 198 ++++++++++++++++++
 .../mellanox/mlx5/core/en/tc/post_meter.h     |  27 +++
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   1 +
 7 files changed, 245 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 1553d94ba3d2..7c33512e2512 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -45,7 +45,8 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					esw/indir_table.o en/tc_tun_encap.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
 					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o \
-					en/tc/post_act.o en/tc/int_port.o en/tc/meter.o
+					en/tc/post_act.o en/tc/int_port.o en/tc/meter.o \
+					en/tc/post_meter.o
 
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/act/trap.o \
 					en/tc/act/accept.o en/tc/act/mark.o en/tc/act/goto.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index e406651a1dc2..d847181a6c37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -5,6 +5,7 @@
 #include "en/tc/post_act.h"
 #include "meter.h"
 #include "en/tc_priv.h"
+#include "post_meter.h"
 
 #define MLX5_START_COLOR_SHIFT 28
 #define MLX5_METER_MODE_SHIFT 24
@@ -45,6 +46,8 @@ struct mlx5e_flow_meters {
 
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_post_act *post_act;
+
+	struct mlx5e_post_meter_priv *post_meter;
 };
 
 static void
@@ -422,6 +425,12 @@ mlx5e_flow_meters_init(struct mlx5e_priv *priv,
 		goto err_sq;
 	}
 
+	flow_meters->post_meter = mlx5e_post_meter_init(priv, ns_type, post_act);
+	if (IS_ERR(flow_meters->post_meter)) {
+		err = PTR_ERR(flow_meters->post_meter);
+		goto err_post_meter;
+	}
+
 	mutex_init(&flow_meters->sync_lock);
 	INIT_LIST_HEAD(&flow_meters->partial_list);
 	INIT_LIST_HEAD(&flow_meters->full_list);
@@ -435,6 +444,8 @@ mlx5e_flow_meters_init(struct mlx5e_priv *priv,
 
 	return flow_meters;
 
+err_post_meter:
+	mlx5_aso_destroy(flow_meters->aso);
 err_sq:
 	mlx5_core_dealloc_pd(mdev, flow_meters->pdn);
 err_out:
@@ -448,6 +459,7 @@ mlx5e_flow_meters_cleanup(struct mlx5e_flow_meters *flow_meters)
 	if (IS_ERR_OR_NULL(flow_meters))
 		return;
 
+	mlx5e_post_meter_cleanup(flow_meters->post_meter);
 	mlx5_aso_destroy(flow_meters->aso);
 	mlx5_core_dealloc_pd(flow_meters->mdev, flow_meters->pdn);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
new file mode 100644
index 000000000000..efa20356764e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "en/tc_priv.h"
+#include "post_meter.h"
+#include "en/tc/post_act.h"
+
+#define MLX5_PACKET_COLOR_BITS MLX5_REG_MAPPING_MBITS(PACKET_COLOR_TO_REG)
+#define MLX5_PACKET_COLOR_MASK MLX5_REG_MAPPING_MASK(PACKET_COLOR_TO_REG)
+
+struct mlx5e_post_meter_priv {
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *fg;
+	struct mlx5_flow_handle *fwd_green_rule;
+	struct mlx5_flow_handle *drop_red_rule;
+};
+
+struct mlx5_flow_table *
+mlx5e_post_meter_get_ft(struct mlx5e_post_meter_priv *post_meter)
+{
+	return post_meter->ft;
+}
+
+static int
+mlx5e_post_meter_table_create(struct mlx5e_priv *priv,
+			      enum mlx5_flow_namespace_type ns_type,
+			      struct mlx5e_post_meter_priv *post_meter)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_namespace *root_ns;
+
+	root_ns = mlx5_get_flow_namespace(priv->mdev, ns_type);
+	if (!root_ns) {
+		mlx5_core_warn(priv->mdev, "Failed to get namespace for flow meter\n");
+		return -EOPNOTSUPP;
+	}
+
+	ft_attr.flags = MLX5_FLOW_TABLE_UNMANAGED;
+	ft_attr.prio = FDB_SLOW_PATH;
+	ft_attr.max_fte = 2;
+	ft_attr.level = 1;
+
+	post_meter->ft = mlx5_create_flow_table(root_ns, &ft_attr);
+	if (IS_ERR(post_meter->ft)) {
+		mlx5_core_warn(priv->mdev, "Failed to create post_meter table\n");
+		return PTR_ERR(post_meter->ft);
+	}
+
+	return 0;
+}
+
+static int
+mlx5e_post_meter_fg_create(struct mlx5e_priv *priv,
+			   struct mlx5e_post_meter_priv *post_meter)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	void *misc2, *match_criteria;
+	u32 *flow_group_in;
+	int err = 0;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		return -ENOMEM;
+
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_MISC_PARAMETERS_2);
+	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
+				      match_criteria);
+	misc2 = MLX5_ADDR_OF(fte_match_param, match_criteria, misc_parameters_2);
+	MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_5, MLX5_PACKET_COLOR_MASK);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
+
+	post_meter->fg = mlx5_create_flow_group(post_meter->ft, flow_group_in);
+	if (IS_ERR(post_meter->fg)) {
+		mlx5_core_warn(priv->mdev, "Failed to create post_meter flow group\n");
+		err = PTR_ERR(post_meter->fg);
+	}
+
+	kvfree(flow_group_in);
+	return err;
+}
+
+static int
+mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
+			      struct mlx5e_post_meter_priv *post_meter,
+			      struct mlx5e_post_act *post_act)
+{
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	int err;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
+				    MLX5_FLOW_METER_COLOR_RED, MLX5_PACKET_COLOR_MASK);
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
+	flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+
+	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, NULL, 0);
+	if (IS_ERR(rule)) {
+		mlx5_core_warn(priv->mdev, "Failed to create post_meter flow drop rule\n");
+		err = PTR_ERR(rule);
+		goto err_red;
+	}
+	post_meter->drop_red_rule = rule;
+
+	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
+				    MLX5_FLOW_METER_COLOR_GREEN, MLX5_PACKET_COLOR_MASK);
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = mlx5e_tc_post_act_get_ft(post_act);
+
+	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		mlx5_core_warn(priv->mdev, "Failed to create post_meter flow fwd rule\n");
+		err = PTR_ERR(rule);
+		goto err_green;
+	}
+	post_meter->fwd_green_rule = rule;
+
+	kvfree(spec);
+	return 0;
+
+err_green:
+	mlx5_del_flow_rules(post_meter->drop_red_rule);
+err_red:
+	kvfree(spec);
+	return err;
+}
+
+static void
+mlx5e_post_meter_rules_destroy(struct mlx5e_post_meter_priv *post_meter)
+{
+	mlx5_del_flow_rules(post_meter->drop_red_rule);
+	mlx5_del_flow_rules(post_meter->fwd_green_rule);
+}
+
+static void
+mlx5e_post_meter_fg_destroy(struct mlx5e_post_meter_priv *post_meter)
+{
+	mlx5_destroy_flow_group(post_meter->fg);
+}
+
+static void
+mlx5e_post_meter_table_destroy(struct mlx5e_post_meter_priv *post_meter)
+{
+	mlx5_destroy_flow_table(post_meter->ft);
+}
+
+struct mlx5e_post_meter_priv *
+mlx5e_post_meter_init(struct mlx5e_priv *priv,
+		      enum mlx5_flow_namespace_type ns_type,
+		      struct mlx5e_post_act *post_act)
+{
+	struct mlx5e_post_meter_priv *post_meter;
+	int err;
+
+	post_meter = kzalloc(sizeof(*post_meter), GFP_KERNEL);
+	if (!post_meter)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx5e_post_meter_table_create(priv, ns_type, post_meter);
+	if (err)
+		goto err_ft;
+
+	err = mlx5e_post_meter_fg_create(priv, post_meter);
+	if (err)
+		goto err_fg;
+
+	err = mlx5e_post_meter_rules_create(priv, post_meter, post_act);
+	if (err)
+		goto err_rules;
+
+	return post_meter;
+
+err_rules:
+	mlx5e_post_meter_fg_destroy(post_meter);
+err_fg:
+	mlx5e_post_meter_table_destroy(post_meter);
+err_ft:
+	kfree(post_meter);
+	return ERR_PTR(err);
+}
+
+void
+mlx5e_post_meter_cleanup(struct mlx5e_post_meter_priv *post_meter)
+{
+	mlx5e_post_meter_rules_destroy(post_meter);
+	mlx5e_post_meter_fg_destroy(post_meter);
+	mlx5e_post_meter_table_destroy(post_meter);
+	kfree(post_meter);
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
new file mode 100644
index 000000000000..c74f3cbd810d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_EN_POST_METER_H__
+#define __MLX5_EN_POST_METER_H__
+
+#define packet_color_to_reg { \
+	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_5, \
+	.moffset = 0, \
+	.mlen = 8, \
+	.soffset = MLX5_BYTE_OFF(fte_match_param, \
+				 misc_parameters_2.metadata_reg_c_5), \
+}
+
+struct mlx5e_post_meter_priv;
+
+struct mlx5_flow_table *
+mlx5e_post_meter_get_ft(struct mlx5e_post_meter_priv *post_meter);
+
+struct mlx5e_post_meter_priv *
+mlx5e_post_meter_init(struct mlx5e_priv *priv,
+		      enum mlx5_flow_namespace_type ns_type,
+		      struct mlx5e_post_act *post_act);
+void
+mlx5e_post_meter_cleanup(struct mlx5e_post_meter_priv *post_meter);
+
+#endif /* __MLX5_EN_POST_METER_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 6a9933925c4f..5bbd6b92840f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -62,10 +62,11 @@ struct mlx5_ct_attr {
 				 misc_parameters_2.metadata_reg_c_4),\
 }
 
+/* 8 LSB of metadata C5 are reserved for packet color */
 #define fteid_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_5,\
-	.moffset = 0,\
-	.mlen = 32,\
+	.moffset = 8,\
+	.mlen = 24,\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
 				 misc_parameters_2.metadata_reg_c_5),\
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 24ff87a0c20f..fd2bcd5a03e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -59,6 +59,7 @@
 #include "en/tc_tun_encap.h"
 #include "en/tc/sample.h"
 #include "en/tc/act/act.h"
+#include "en/tc/post_meter.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
@@ -104,6 +105,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 		.mlen = 16,
 	},
 	[NIC_ZONE_RESTORE_TO_REG] = nic_zone_restore_to_reg_ct,
+	[PACKET_COLOR_TO_REG] = packet_color_to_reg,
 };
 
 /* To avoid false lock dependency warning set the tc_ht lock
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ea12a8bbc7e3..941e0143577a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -230,6 +230,7 @@ enum mlx5e_tc_attr_to_reg {
 	FTEID_TO_REG,
 	NIC_CHAIN_TO_REG,
 	NIC_ZONE_RESTORE_TO_REG,
+	PACKET_COLOR_TO_REG,
 };
 
 struct mlx5e_tc_attr_to_reg_mapping {
-- 
2.36.1

