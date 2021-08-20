Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D268D3F2619
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhHTE4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232776AbhHTE4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7F8A61056;
        Fri, 20 Aug 2021 04:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435325;
        bh=OHFDwrPVadS/x4XEjhkoeGMShA6IXf1/nyv2wuQwfRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JG1v341navEPwcOCGTNoRgSxH87F7vMQwCQLzhvyimRB69qy7/CnH5X1vEb1nY+U4
         wUTjbQ3bgyozKJpbPJH3Bv8q8sdtlADh1OooPtN83jxq+dWI36bTlFPXKeVB1WGjlV
         FKUdGUQIhocA1wi4DewrFd/Nlw7MAknXrY0VqrH2uwzrTBSYmscAeTxswp6vR1uqie
         /D/3jb10GeM4YQVCaA9FZumMUJUnsndQl9uLChaGOx+YHmIYYxBWN03o7jki2DNIAS
         o+iBREUcqbhNcnIC8x5XhM+5moQJ1WSrOmdkM9jcy59vyGY97vkcTcI57JsEXcbcxE
         tFJQ7xnHLiyeg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: Move sample attribute to flow attribute
Date:   Thu, 19 Aug 2021 21:55:03 -0700
Message-Id: <20210820045515.265297-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently it is in eswitch attribute. Move it to flow attribute to
reflect the change in previous patch.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/sample.c         | 27 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 16 +++++------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 -
 .../mellanox/mlx5/core/eswitch_offloads.c     | 12 ++++-----
 5 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 8e12e56f639f..a6e19946e80f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -391,7 +391,8 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	sample_flow = kzalloc(sizeof(*sample_flow), GFP_KERNEL);
 	if (!sample_flow)
 		return ERR_PTR(-ENOMEM);
-	esw_attr->sample->sample_flow = sample_flow;
+	sample_attr = attr->sample_attr;
+	sample_attr->sample_flow = sample_flow;
 
 	/* Allocate default table per vport, chain and prio. Otherwise, there is
 	 * only one default table for the same sampler object. Rules with different
@@ -411,7 +412,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	/* Perform the original matches on the default table.
 	 * Offload all actions except the sample action.
 	 */
-	esw_attr->sample->sample_default_tbl = default_tbl;
+	sample_attr->sample_default_tbl = default_tbl;
 	/* When offloading sample and encap action, if there is no valid
 	 * neigh data struct, a slow path rule is offloaded first. Source
 	 * port metadata match is set at that time. A per vport table is
@@ -426,7 +427,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	}
 
 	/* Create sampler object. */
-	sample_flow->sampler = sampler_get(tc_psample, esw_attr->sample->rate, default_tbl->id);
+	sample_flow->sampler = sampler_get(tc_psample, sample_attr->rate, default_tbl->id);
 	if (IS_ERR(sample_flow->sampler)) {
 		err = PTR_ERR(sample_flow->sampler);
 		goto err_sampler;
@@ -434,13 +435,13 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 
 	/* Create an id mapping reg_c0 value to sample object. */
 	restore_obj.type = MLX5_MAPPED_OBJ_SAMPLE;
-	restore_obj.sample.group_id = esw_attr->sample->group_num;
-	restore_obj.sample.rate = esw_attr->sample->rate;
-	restore_obj.sample.trunc_size = esw_attr->sample->trunc_size;
+	restore_obj.sample.group_id = sample_attr->group_num;
+	restore_obj.sample.rate = sample_attr->rate;
+	restore_obj.sample.trunc_size = sample_attr->trunc_size;
 	err = mapping_add(esw->offloads.reg_c0_obj_pool, &restore_obj, &obj_id);
 	if (err)
 		goto err_obj_id;
-	esw_attr->sample->restore_obj_id = obj_id;
+	sample_attr->restore_obj_id = obj_id;
 
 	/* Create sample restore context. */
 	sample_flow->restore = sample_restore_get(tc_psample, obj_id);
@@ -462,14 +463,14 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 		err = -ENOMEM;
 		goto err_alloc_sample_attr;
 	}
-	pre_esw_attr = pre_attr->esw_attr;
 	pre_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	pre_attr->modify_hdr = sample_flow->restore->modify_hdr;
 	pre_attr->flags = MLX5_ESW_ATTR_FLAG_SAMPLE;
 	pre_attr->chain = attr->chain;
 	pre_attr->prio = attr->prio;
-	pre_esw_attr->sample = sample_attr;
-	pre_esw_attr->sample->sampler_id = sample_flow->sampler->sampler_id;
+	pre_attr->sample_attr = sample_attr;
+	sample_attr->sampler_id = sample_flow->sampler->sampler_id;
+	pre_esw_attr = pre_attr->esw_attr;
 	pre_esw_attr->in_mdev = esw_attr->in_mdev;
 	pre_esw_attr->in_rep = esw_attr->in_rep;
 	sample_flow->pre_rule = mlx5_eswitch_add_offloaded_rule(esw, spec, pre_attr);
@@ -528,14 +529,14 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 		return;
 	}
 
-	sample_flow = esw_attr->sample->sample_flow;
+	sample_flow = attr->sample_attr->sample_flow;
 	pre_attr = sample_flow->pre_attr;
 	memset(pre_attr, 0, sizeof(*pre_attr));
 	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, pre_attr);
 	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->rule, attr);
 
 	sample_restore_put(tc_psample, sample_flow->restore);
-	mapping_remove(esw->offloads.reg_c0_obj_pool, esw_attr->sample->restore_obj_id);
+	mapping_remove(esw->offloads.reg_c0_obj_pool, attr->sample_attr->restore_obj_id);
 	sampler_put(tc_psample, sample_flow->sampler);
 	tbl_attr.chain = attr->chain;
 	tbl_attr.prio = attr->prio;
@@ -543,7 +544,7 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 	tbl_attr.vport_ns = &mlx5_esw_vport_tbl_sample_ns;
 	mlx5_esw_vporttbl_put(esw, &tbl_attr);
 
-	kfree(pre_attr->esw_attr->sample);
+	kfree(pre_attr->sample_attr);
 	kfree(pre_attr);
 	kfree(sample_flow);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f1725f1ae693..040acef4e669 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1550,6 +1550,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		else
 			mlx5e_detach_mod_hdr(priv, flow);
 	}
+	kfree(attr->sample_attr);
 	kvfree(attr->parse_attr);
 	kvfree(attr->esw_attr->rx_tun_attr);
 
@@ -1559,7 +1560,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
 
-	kfree(flow->attr->esw_attr->sample);
 	kfree(flow->attr);
 }
 
@@ -3716,13 +3716,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5e_sample_attr sample_attr = {};
 	const struct ip_tunnel_info *info = NULL;
 	struct mlx5_flow_attr *attr = flow->attr;
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
-	struct mlx5e_sample_attr sample = {};
 	bool encap = false, decap = false;
 	u32 action = attr->action;
 	int err, i, if_count = 0;
@@ -3993,10 +3993,10 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
 				return -EOPNOTSUPP;
 			}
-			sample.rate = act->sample.rate;
-			sample.group_num = act->sample.psample_group->group_num;
+			sample_attr.rate = act->sample.rate;
+			sample_attr.group_num = act->sample.psample_group->group_num;
 			if (act->sample.truncate)
-				sample.trunc_size = act->sample.trunc_size;
+				sample_attr.trunc_size = act->sample.trunc_size;
 			flow_flag_set(flow, SAMPLE);
 			break;
 		default:
@@ -4081,10 +4081,10 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	 * no errors after parsing.
 	 */
 	if (flow_flag_test(flow, SAMPLE)) {
-		esw_attr->sample = kzalloc(sizeof(*esw_attr->sample), GFP_KERNEL);
-		if (!esw_attr->sample)
+		attr->sample_attr = kzalloc(sizeof(*attr->sample_attr), GFP_KERNEL);
+		if (!attr->sample_attr)
 			return -ENOMEM;
-		*esw_attr->sample = sample;
+		*attr->sample_attr = sample_attr;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index f7cbeb0b66d2..1a4cd882f0fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -70,6 +70,7 @@ struct mlx5_flow_attr {
 	struct mlx5_fc *counter;
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_ct_attr ct_attr;
+	struct mlx5e_sample_attr *sample_attr;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	u32 chain;
 	u16 prio;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 0c6ddd7ad7ec..3aae1152184b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -469,7 +469,6 @@ struct mlx5_esw_flow_attr {
 	} dests[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5_rx_tun_attr *rx_tun_attr;
 	struct mlx5_pkt_reformat *decap_pkt_reformat;
-	struct mlx5e_sample_attr *sample;
 };
 
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 49c7bf94332c..61175992a789 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -187,12 +187,12 @@ esw_cleanup_decap_indir(struct mlx5_eswitch *esw,
 static int
 esw_setup_sampler_dest(struct mlx5_flow_destination *dest,
 		       struct mlx5_flow_act *flow_act,
-		       struct mlx5_esw_flow_attr *esw_attr,
+		       struct mlx5_flow_attr *attr,
 		       int i)
 {
 	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER;
-	dest[i].sampler_id = esw_attr->sample->sampler_id;
+	dest[i].sampler_id = attr->sample_attr->sampler_id;
 
 	return 0;
 }
@@ -435,7 +435,7 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 		attr->flags |= MLX5_ESW_ATTR_FLAG_SRC_REWRITE;
 
 	if (attr->flags & MLX5_ESW_ATTR_FLAG_SAMPLE) {
-		esw_setup_sampler_dest(dest, flow_act, esw_attr, *i);
+		esw_setup_sampler_dest(dest, flow_act, attr, *i);
 		(*i)++;
 	} else if (attr->dest_ft) {
 		esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
@@ -540,9 +540,9 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_hdr = attr->modify_hdr;
 
-	/* esw_attr->sample is allocated only when there is a sample action */
-	if (esw_attr->sample && esw_attr->sample->sample_default_tbl) {
-		fdb = esw_attr->sample->sample_default_tbl;
+	/* sample_attr is allocated only when there is a sample action */
+	if (attr->sample_attr && attr->sample_attr->sample_default_tbl) {
+		fdb = attr->sample_attr->sample_default_tbl;
 	} else if (split) {
 		fwd_attr.chain = attr->chain;
 		fwd_attr.prio = attr->prio;
-- 
2.31.1

