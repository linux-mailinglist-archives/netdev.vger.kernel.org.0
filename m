Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F407D647A9D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLIAPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLIAOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B138D1A8
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1F5B826BE
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDE6C433D2;
        Fri,  9 Dec 2022 00:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544884;
        bh=K77CLk/hq2sk0fufElKcVrYFDepnACNMp0fFsThCLp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trvrLt0PcZR6wfcuPt9KI4qBEmCLybRJ8RDtO1J8EpmYmTgbeFgNCadVJedVSSZ42
         HUCp9sv9r9BuLJ4CUZwERrYViIjk2AsC6lAdayOHz2uE0cDJK1DwW2n2r6duAXz5Xk
         FyufLumQ+YVrmxT6lG2zFr3GmNwSKH9YeYNRVyLaGIvx2b3FWok6NdN0wQLBL6qh7A
         R4J+xrSHM8YEurEGoYvCWQ1SfIpz/pjUMA82QRwo0KlyPGwYJmUN64dxE6T7Ii2Zw7
         Rb4BPVXnKCuLC3HY6idJ5s9RtsLHbHTH1Hj6tY3OQcq2aEJIU/EAaDqQ5HdjGODIGT
         RWklu+90dkHDA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: TC, add support for meter mtu offload
Date:   Thu,  8 Dec 2022 16:14:17 -0800
Message-Id: <20221209001420.142794-13-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

Initialize the meter object with the TC police mtu parameter.
Use the hardware range destination to compare the pkt len to the mtu setting.
Assign the range destination hit/miss ft to the police conform/exceed
attributes.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/police.c     | 20 +++++++++++++---
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c | 15 +++++++++---
 .../ethernet/mellanox/mlx5/core/en/tc/meter.h |  1 +
 .../mellanox/mlx5/core/en/tc/post_meter.c     | 12 ++++++++++
 .../mellanox/mlx5/core/en/tc/post_meter.h     | 24 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  9 ++++---
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 19 +++++++++++++++
 8 files changed, 92 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
index 898fe16a4384..512d43148922 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
@@ -3,6 +3,7 @@
 
 #include "act.h"
 #include "en/tc_priv.h"
+#include "fs_core.h"
 
 static bool police_act_validate_control(enum flow_action_id act_id,
 					struct netlink_ext_ack *extack)
@@ -71,6 +72,8 @@ fill_meter_params_from_act(const struct flow_action_entry *act,
 		params->mode = MLX5_RATE_LIMIT_PPS;
 		params->rate = act->police.rate_pkt_ps;
 		params->burst = act->police.burst_pkt;
+	} else if (act->police.mtu) {
+		params->mtu = act->police.mtu;
 	} else {
 		return -EOPNOTSUPP;
 	}
@@ -84,14 +87,25 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
 		    struct mlx5e_priv *priv,
 		    struct mlx5_flow_attr *attr)
 {
+	enum mlx5_flow_namespace_type ns =  mlx5e_get_flow_namespace(parse_state->flow);
+	struct mlx5e_flow_meter_params *params = &attr->meter_attr.params;
 	int err;
 
-	err = fill_meter_params_from_act(act, &attr->meter_attr.params);
+	err = fill_meter_params_from_act(act, params);
 	if (err)
 		return err;
 
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
-	attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
+	if (params->mtu) {
+		if (!(mlx5_fs_get_capabilities(priv->mdev, ns) &
+		      MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
+			return -EOPNOTSUPP;
+
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		attr->flags |= MLX5_ATTR_FLAG_MTU;
+	} else {
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
+		attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index 4e5f4aa44724..9c1c24da9453 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -241,7 +241,7 @@ mlx5e_flow_meter_destroy_aso_obj(struct mlx5_core_dev *mdev, u32 obj_id)
 }
 
 static struct mlx5e_flow_meter_handle *
-__mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters)
+__mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters, bool alloc_aso)
 {
 	struct mlx5_core_dev *mdev = flow_meters->mdev;
 	struct mlx5e_flow_meter_aso_obj *meters_obj;
@@ -268,6 +268,9 @@ __mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters)
 	}
 	meter->act_counter = counter;
 
+	if (!alloc_aso)
+		goto no_aso;
+
 	meters_obj = list_first_entry_or_null(&flow_meters->partial_list,
 					      struct mlx5e_flow_meter_aso_obj,
 					      entry);
@@ -300,11 +303,12 @@ __mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters)
 	}
 
 	bitmap_set(meters_obj->meters_map, pos, 1);
-	meter->flow_meters = flow_meters;
 	meter->meters_obj = meters_obj;
 	meter->obj_id = meters_obj->base_id + pos / 2;
 	meter->idx = pos % 2;
 
+no_aso:
+	meter->flow_meters = flow_meters;
 	mlx5_core_dbg(mdev, "flow meter allocated, obj_id=0x%x, index=%d\n",
 		      meter->obj_id, meter->idx);
 
@@ -332,6 +336,9 @@ __mlx5e_flow_meter_free(struct mlx5e_flow_meter_handle *meter)
 	mlx5_fc_destroy(mdev, meter->act_counter);
 	mlx5_fc_destroy(mdev, meter->drop_counter);
 
+	if (meter->params.mtu)
+		goto out_no_aso;
+
 	meters_obj = meter->meters_obj;
 	pos = (meter->obj_id - meters_obj->base_id) * 2 + meter->idx;
 	bitmap_clear(meters_obj->meters_map, pos, 1);
@@ -345,6 +352,7 @@ __mlx5e_flow_meter_free(struct mlx5e_flow_meter_handle *meter)
 		list_add(&meters_obj->entry, &flow_meters->partial_list);
 	}
 
+out_no_aso:
 	mlx5_core_dbg(mdev, "flow meter freed, obj_id=0x%x, index=%d\n",
 		      meter->obj_id, meter->idx);
 	kfree(meter);
@@ -409,12 +417,13 @@ mlx5e_tc_meter_alloc(struct mlx5e_flow_meters *flow_meters,
 {
 	struct mlx5e_flow_meter_handle *meter;
 
-	meter = __mlx5e_flow_meter_alloc(flow_meters);
+	meter = __mlx5e_flow_meter_alloc(flow_meters, !params->mtu);
 	if (IS_ERR(meter))
 		return meter;
 
 	hash_add(flow_meters->hashtbl, &meter->hlist, params->index);
 	meter->params.index = params->index;
+	meter->params.mtu = params->mtu;
 	meter->refcnt++;
 
 	return meter;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
index f16abf33bb51..9b795cd106bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
@@ -20,6 +20,7 @@ struct mlx5e_flow_meter_params {
 	u32 index;
 	u64 rate;
 	u64 burst;
+	u32 mtu;
 };
 
 struct mlx5e_flow_meter_handle {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
index ffed3af7d01e..8d7d761482d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
@@ -43,6 +43,18 @@ mlx5e_post_meter_get_ft(struct mlx5e_post_meter_priv *post_meter)
 	return post_meter->rate_steering_table.ft;
 }
 
+struct mlx5_flow_table *
+mlx5e_post_meter_get_mtu_true_ft(struct mlx5e_post_meter_priv *post_meter)
+{
+	return post_meter->mtu_tables.green_table.ft;
+}
+
+struct mlx5_flow_table *
+mlx5e_post_meter_get_mtu_false_ft(struct mlx5e_post_meter_priv *post_meter)
+{
+	return post_meter->mtu_tables.red_table.ft;
+}
+
 static struct mlx5_flow_table *
 mlx5e_post_meter_table_create(struct mlx5e_priv *priv,
 			      enum mlx5_flow_namespace_type ns_type)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
index 0a3dbf5ed86d..e013b77186b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
@@ -19,9 +19,17 @@ enum mlx5e_post_meter_type {
 	MLX5E_POST_METER_MTU
 };
 
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+
 struct mlx5_flow_table *
 mlx5e_post_meter_get_ft(struct mlx5e_post_meter_priv *post_meter);
 
+struct mlx5_flow_table *
+mlx5e_post_meter_get_mtu_true_ft(struct mlx5e_post_meter_priv *post_meter);
+
+struct mlx5_flow_table *
+mlx5e_post_meter_get_mtu_false_ft(struct mlx5e_post_meter_priv *post_meter);
+
 struct mlx5e_post_meter_priv *
 mlx5e_post_meter_init(struct mlx5e_priv *priv,
 		      enum mlx5_flow_namespace_type ns_type,
@@ -35,4 +43,20 @@ mlx5e_post_meter_init(struct mlx5e_priv *priv,
 void
 mlx5e_post_meter_cleanup(struct mlx5_eswitch *esw, struct mlx5e_post_meter_priv *post_meter);
 
+#else /* CONFIG_MLX5_CLS_ACT */
+
+static inline struct mlx5_flow_table *
+mlx5e_post_meter_get_mtu_true_ft(struct mlx5e_post_meter_priv *post_meter)
+{
+	return NULL;
+}
+
+static inline struct mlx5_flow_table *
+mlx5e_post_meter_get_mtu_false_ft(struct mlx5e_post_meter_priv *post_meter)
+{
+	return NULL;
+}
+
+#endif
+
 #endif /* __MLX5_EN_POST_METER_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f66a2546003e..9af2aa2922f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -402,8 +402,9 @@ mlx5_tc_rule_delete(struct mlx5e_priv *priv,
 static bool
 is_flow_meter_action(struct mlx5_flow_attr *attr)
 {
-	return ((attr->action & MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO) &&
-		(attr->exe_aso_type == MLX5_EXE_ASO_FLOW_METER));
+	return (((attr->action & MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO) &&
+		 (attr->exe_aso_type == MLX5_EXE_ASO_FLOW_METER)) ||
+		attr->flags & MLX5_ATTR_FLAG_MTU);
 }
 
 static int
@@ -414,6 +415,7 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 	struct mlx5e_post_meter_priv *post_meter;
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5e_flow_meter_handle *meter;
+	enum mlx5e_post_meter_type type;
 
 	meter = mlx5e_tc_meter_replace(priv->mdev, &attr->meter_attr.params);
 	if (IS_ERR(meter)) {
@@ -422,8 +424,9 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 	}
 
 	ns_type = mlx5e_tc_meter_get_namespace(meter->flow_meters);
+	type = meter->params.mtu ? MLX5E_POST_METER_MTU : MLX5E_POST_METER_RATE;
 	post_meter = mlx5e_post_meter_init(priv, ns_type, post_act,
-					   MLX5E_POST_METER_RATE,
+					   type,
 					   meter->act_counter, meter->drop_counter,
 					   attr->branch_true, attr->branch_false);
 	if (IS_ERR(post_meter)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index f2677d9ca0b4..50af70ef22f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -114,6 +114,7 @@ enum {
 	MLX5_ATTR_FLAG_ACCEPT        = BIT(5),
 	MLX5_ATTR_FLAG_CT            = BIT(6),
 	MLX5_ATTR_FLAG_TERMINATING   = BIT(7),
+	MLX5_ATTR_FLAG_MTU           = BIT(8),
 };
 
 /* Returns true if any of the flags that require skipping further TC/NF processing are set. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1987a9d9d40c..e455b215c708 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -50,6 +50,7 @@
 #include "en/mapping.h"
 #include "devlink.h"
 #include "lag/lag.h"
+#include "en/tc/post_meter.h"
 
 #define mlx5_esw_for_each_rep(esw, i, rep) \
 	xa_for_each(&((esw)->offloads.vport_reps), i, rep)
@@ -201,6 +202,21 @@ esw_cleanup_decap_indir(struct mlx5_eswitch *esw,
 					 true);
 }
 
+static int
+esw_setup_mtu_dest(struct mlx5_flow_destination *dest,
+		   struct mlx5e_meter_attr *meter,
+		   int i)
+{
+	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_RANGE;
+	dest[i].range.field = MLX5_FLOW_DEST_RANGE_FIELD_PKT_LEN;
+	dest[i].range.min = 0;
+	dest[i].range.max = meter->params.mtu;
+	dest[i].range.hit_ft = mlx5e_post_meter_get_mtu_true_ft(meter->post_meter);
+	dest[i].range.miss_ft = mlx5e_post_meter_get_mtu_false_ft(meter->post_meter);
+
+	return 0;
+}
+
 static int
 esw_setup_sampler_dest(struct mlx5_flow_destination *dest,
 		       struct mlx5_flow_act *flow_act,
@@ -491,6 +507,9 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 	} else if (attr->flags & MLX5_ATTR_FLAG_ACCEPT) {
 		esw_setup_accept_dest(dest, flow_act, chains, *i);
 		(*i)++;
+	} else if (attr->flags & MLX5_ATTR_FLAG_MTU) {
+		err = esw_setup_mtu_dest(dest, &attr->meter_attr, *i);
+		(*i)++;
 	} else if (esw_is_indir_table(esw, attr)) {
 		err = esw_setup_indir_table(dest, flow_act, esw, attr, spec, true, i);
 	} else if (esw_is_chain_src_port_rewrite(esw, esw_attr)) {
-- 
2.38.1

