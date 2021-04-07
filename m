Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AD43562C4
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348610AbhDGEzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348559AbhDGEyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 073D5613C6;
        Wed,  7 Apr 2021 04:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771281;
        bh=hOhz8GNtagpiF7Hh81o4vzaFZAEYrgZdbTf948qQJ6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnuKzkOwytuwAJmSx9P2L8QMMb2F6AYUQ09xBquX+qebX06erUzFdg8z8HhrgOFcZ
         L/atlsNzVp8V+wbhp4vlrsrJ2swETDpocp8RsmkY05RgNku+J+r4NEZqn4xsiGueeF
         nTFGzKmRqrsnrgMB4XX2BDrVlxXmW/AxcXqIHJ1UteVgn9OoYZhP0Dc4i38RZVUWVA
         nH8QqdXYBsGeSWE8p087oghWiNnMHQ/kqI74aimlKrNFuUAvmgC5XWLuajGfbtEMhd
         z5JiaXrChmFlcLoRaXtdNG155acYdMnzMWCuSHv10uRSJr5kN4LuxbP6PP2S+VN94/
         PXB2FlESlll9A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/13] net/mlx5e: TC, Add support to offload sample action
Date:   Tue,  6 Apr 2021 21:54:21 -0700
Message-Id: <20210407045421.148987-14-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

The following diagram illustrates the hardware model for tc sample action:

        +---------------------+
        + original flow table +
        +---------------------+
        +   original match    +
        +---------------------+
                   |
                   v
+------------------------------------------------+
+                Flow Sampler Object             +
+------------------------------------------------+
+                    sample ratio                +
+------------------------------------------------+
+    sample table id    |    default table id    +
+------------------------------------------------+
           |                            |
           v                            v
+-----------------------------+  +----------------------------------------+
+        sample table         +  + default table per <vport, chain, prio> +
+-----------------------------+  +----------------------------------------+
+ forward to management vport +  +            original match              +
+-----------------------------+  +----------------------------------------+
                                 +            other actions               +
                                 +----------------------------------------+

The sample action is translated to a goto flow table object
destination which samples packets according to the provided
sample ratio. Sampled packets are duplicated. One copy is
processed by a termination table, named the sample table,
which sends the packet to the eswitch manager port (that will
be processed by software).

The second copy is processed by the default table which executes
the subsequent actions. The default table is created per <vport,
chain, prio> tuple as rules with different prios and chains may
overlap.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  30 +++
 .../ethernet/mellanox/mlx5/core/esw/sample.c  | 235 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/esw/sample.h  |  18 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   4 +
 .../mellanox/mlx5/core/eswitch_offloads.c     |  43 +++-
 5 files changed, 328 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1a403112defd..d157d1b9cad6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -223,6 +223,25 @@ get_ct_priv(struct mlx5e_priv *priv)
 	return priv->fs.tc.ct;
 }
 
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+static struct mlx5_esw_psample *
+get_sample_priv(struct mlx5e_priv *priv)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+
+	if (is_mdev_switchdev_mode(priv->mdev)) {
+		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+		uplink_priv = &uplink_rpriv->uplink_priv;
+
+		return uplink_priv->esw_psample;
+	}
+
+	return NULL;
+}
+#endif
+
 struct mlx5_flow_handle *
 mlx5_tc_rule_insert(struct mlx5e_priv *priv,
 		    struct mlx5_flow_spec *spec,
@@ -1092,6 +1111,10 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 		rule = mlx5_tc_ct_flow_offload(get_ct_priv(flow->priv),
 					       flow, spec, attr,
 					       mod_hdr_acts);
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+	} else if (flow_flag_test(flow, SAMPLE)) {
+		rule = mlx5_esw_sample_offload(get_sample_priv(flow->priv), spec, attr);
+#endif
 	} else {
 		rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 	}
@@ -1127,6 +1150,13 @@ void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 		return;
 	}
 
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+	if (flow_flag_test(flow, SAMPLE)) {
+		mlx5_esw_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
+		return;
+	}
+#endif
+
 	if (attr->esw_attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
index 629a0a28a7ba..794012c5c476 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
@@ -3,11 +3,20 @@
 
 #include <linux/skbuff.h>
 #include <net/psample.h>
+#include "en/mapping.h"
 #include "esw/sample.h"
 #include "eswitch.h"
 #include "en_tc.h"
 #include "fs_core.h"
 
+#define MLX5_ESW_VPORT_TBL_SIZE_SAMPLE (64 * 1024)
+
+static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_sample_ns = {
+	.max_fte = MLX5_ESW_VPORT_TBL_SIZE_SAMPLE,
+	.max_num_groups = 0,    /* default num of groups */
+	.flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT | MLX5_FLOW_TABLE_TUNNEL_EN_DECAP,
+};
+
 struct mlx5_esw_psample {
 	struct mlx5e_priv *priv;
 	struct mlx5_flow_table *termtbl;
@@ -30,6 +39,9 @@ struct mlx5_sampler {
 struct mlx5_sample_flow {
 	struct mlx5_sampler *sampler;
 	struct mlx5_sample_restore *restore;
+	struct mlx5_flow_attr *pre_attr;
+	struct mlx5_flow_handle *pre_rule;
+	struct mlx5_flow_handle *rule;
 };
 
 struct mlx5_sample_restore {
@@ -313,6 +325,229 @@ void mlx5_esw_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj
 	psample_sample_packet(&psample_group, skb, mapped_obj->sample.rate, &md);
 }
 
+/* For the following typical flow table:
+ *
+ * +-------------------------------+
+ * +       original flow table     +
+ * +-------------------------------+
+ * +         original match        +
+ * +-------------------------------+
+ * + sample action + other actions +
+ * +-------------------------------+
+ *
+ * We translate the tc filter with sample action to the following HW model:
+ *
+ *         +---------------------+
+ *         + original flow table +
+ *         +---------------------+
+ *         +   original match    +
+ *         +---------------------+
+ *                    |
+ *                    v
+ * +------------------------------------------------+
+ * +                Flow Sampler Object             +
+ * +------------------------------------------------+
+ * +                    sample ratio                +
+ * +------------------------------------------------+
+ * +    sample table id    |    default table id    +
+ * +------------------------------------------------+
+ *            |                            |
+ *            v                            v
+ * +-----------------------------+  +----------------------------------------+
+ * +        sample table         +  + default table per <vport, chain, prio> +
+ * +-----------------------------+  +----------------------------------------+
+ * + forward to management vport +  +            original match              +
+ * +-----------------------------+  +----------------------------------------+
+ *                                  +            other actions               +
+ *                                  +----------------------------------------+
+ */
+struct mlx5_flow_handle *
+mlx5_esw_sample_offload(struct mlx5_esw_psample *esw_psample,
+			struct mlx5_flow_spec *spec,
+			struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct mlx5_vport_tbl_attr per_vport_tbl_attr;
+	struct mlx5_esw_flow_attr *pre_esw_attr;
+	struct mlx5_mapped_obj restore_obj = {};
+	struct mlx5_sample_flow *sample_flow;
+	struct mlx5_sample_attr *sample_attr;
+	struct mlx5_flow_table *default_tbl;
+	struct mlx5_flow_attr *pre_attr;
+	struct mlx5_eswitch *esw;
+	u32 obj_id;
+	int err;
+
+	if (IS_ERR_OR_NULL(esw_psample))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* If slow path flag is set, eg. when the neigh is invalid for encap,
+	 * don't offload sample action.
+	 */
+	esw = esw_psample->priv->mdev->priv.eswitch;
+	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
+		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
+
+	sample_flow = kzalloc(sizeof(*sample_flow), GFP_KERNEL);
+	if (!sample_flow)
+		return ERR_PTR(-ENOMEM);
+	esw_attr->sample->sample_flow = sample_flow;
+
+	/* Allocate default table per vport, chain and prio. Otherwise, there is
+	 * only one default table for the same sampler object. Rules with different
+	 * prio and chain may overlap. For CT sample action, per vport default
+	 * table is needed to resotre the metadata.
+	 */
+	per_vport_tbl_attr.chain = attr->chain;
+	per_vport_tbl_attr.prio = attr->prio;
+	per_vport_tbl_attr.vport = esw_attr->in_rep->vport;
+	per_vport_tbl_attr.vport_ns = &mlx5_esw_vport_tbl_sample_ns;
+	default_tbl = mlx5_esw_vporttbl_get(esw, &per_vport_tbl_attr);
+	if (IS_ERR(default_tbl)) {
+		err = PTR_ERR(default_tbl);
+		goto err_default_tbl;
+	}
+
+	/* Perform the original matches on the default table.
+	 * Offload all actions except the sample action.
+	 */
+	esw_attr->sample->sample_default_tbl = default_tbl;
+	/* When offloading sample and encap action, if there is no valid
+	 * neigh data struct, a slow path rule is offloaded first. Source
+	 * port metadata match is set at that time. A per vport table is
+	 * already allocated. No need to match it again. So clear the source
+	 * port metadata match.
+	 */
+	mlx5_eswitch_clear_rule_source_port(esw, spec);
+	sample_flow->rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
+	if (IS_ERR(sample_flow->rule)) {
+		err = PTR_ERR(sample_flow->rule);
+		goto err_offload_rule;
+	}
+
+	/* Create sampler object. */
+	sample_flow->sampler = sampler_get(esw_psample, esw_attr->sample->rate, default_tbl->id);
+	if (IS_ERR(sample_flow->sampler)) {
+		err = PTR_ERR(sample_flow->sampler);
+		goto err_sampler;
+	}
+
+	/* Create an id mapping reg_c0 value to sample object. */
+	restore_obj.type = MLX5_MAPPED_OBJ_SAMPLE;
+	restore_obj.sample.group_id = esw_attr->sample->group_num;
+	restore_obj.sample.rate = esw_attr->sample->rate;
+	restore_obj.sample.trunc_size = esw_attr->sample->trunc_size;
+	err = mapping_add(esw->offloads.reg_c0_obj_pool, &restore_obj, &obj_id);
+	if (err)
+		goto err_obj_id;
+	esw_attr->sample->restore_obj_id = obj_id;
+
+	/* Create sample restore context. */
+	sample_flow->restore = sample_restore_get(esw_psample, obj_id);
+	if (IS_ERR(sample_flow->restore)) {
+		err = PTR_ERR(sample_flow->restore);
+		goto err_sample_restore;
+	}
+
+	/* Perform the original matches on the original table. Offload the
+	 * sample action. The destination is the sampler object.
+	 */
+	pre_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	if (!pre_attr) {
+		err = -ENOMEM;
+		goto err_alloc_flow_attr;
+	}
+	sample_attr = kzalloc(sizeof(*sample_attr), GFP_KERNEL);
+	if (!sample_attr) {
+		err = -ENOMEM;
+		goto err_alloc_sample_attr;
+	}
+	pre_esw_attr = pre_attr->esw_attr;
+	pre_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	pre_attr->modify_hdr = sample_flow->restore->modify_hdr;
+	pre_attr->flags = MLX5_ESW_ATTR_FLAG_SAMPLE;
+	pre_attr->chain = attr->chain;
+	pre_attr->prio = attr->prio;
+	pre_esw_attr->sample = sample_attr;
+	pre_esw_attr->sample->sampler_id = sample_flow->sampler->sampler_id;
+	pre_esw_attr->in_mdev = esw_attr->in_mdev;
+	pre_esw_attr->in_rep = esw_attr->in_rep;
+	sample_flow->pre_rule = mlx5_eswitch_add_offloaded_rule(esw, spec, pre_attr);
+	if (IS_ERR(sample_flow->pre_rule)) {
+		err = PTR_ERR(sample_flow->pre_rule);
+		goto err_pre_offload_rule;
+	}
+	sample_flow->pre_attr = pre_attr;
+
+	return sample_flow->rule;
+
+err_pre_offload_rule:
+	kfree(sample_attr);
+err_alloc_sample_attr:
+	kfree(pre_attr);
+err_alloc_flow_attr:
+	sample_restore_put(esw_psample, sample_flow->restore);
+err_sample_restore:
+	mapping_remove(esw->offloads.reg_c0_obj_pool, obj_id);
+err_obj_id:
+	sampler_put(esw_psample, sample_flow->sampler);
+err_sampler:
+	/* For sample offload, rule is added in default_tbl. No need to call
+	 * mlx5_esw_chains_put_table()
+	 */
+	attr->prio = 0;
+	attr->chain = 0;
+	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->rule, attr);
+err_offload_rule:
+	mlx5_esw_vporttbl_put(esw, &per_vport_tbl_attr);
+err_default_tbl:
+	return ERR_PTR(err);
+}
+
+void
+mlx5_esw_sample_unoffload(struct mlx5_esw_psample *esw_psample,
+			  struct mlx5_flow_handle *rule,
+			  struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct mlx5_sample_flow *sample_flow;
+	struct mlx5_vport_tbl_attr tbl_attr;
+	struct mlx5_flow_attr *pre_attr;
+	struct mlx5_eswitch *esw;
+
+	if (IS_ERR_OR_NULL(esw_psample))
+		return;
+
+	/* If slow path flag is set, sample action is not offloaded.
+	 * No need to delete sample rule.
+	 */
+	esw = esw_psample->priv->mdev->priv.eswitch;
+	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
+		mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
+		return;
+	}
+
+	sample_flow = esw_attr->sample->sample_flow;
+	pre_attr = sample_flow->pre_attr;
+	memset(pre_attr, 0, sizeof(*pre_attr));
+	esw = esw_psample->priv->mdev->priv.eswitch;
+	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, pre_attr);
+	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->rule, attr);
+
+	sample_restore_put(esw_psample, sample_flow->restore);
+	mapping_remove(esw->offloads.reg_c0_obj_pool, esw_attr->sample->restore_obj_id);
+	sampler_put(esw_psample, sample_flow->sampler);
+	tbl_attr.chain = attr->chain;
+	tbl_attr.prio = attr->prio;
+	tbl_attr.vport = esw_attr->in_rep->vport;
+	tbl_attr.vport_ns = &mlx5_esw_vport_tbl_sample_ns;
+	mlx5_esw_vporttbl_put(esw, &tbl_attr);
+
+	kfree(pre_attr->esw_attr->sample);
+	kfree(pre_attr);
+	kfree(sample_flow);
+}
+
 struct mlx5_esw_psample *
 mlx5_esw_sample_init(struct mlx5e_priv *priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
index 82bff97bd9b7..2a3f4be10030 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
@@ -7,14 +7,32 @@
 #include "en.h"
 #include "eswitch.h"
 
+struct mlx5e_priv;
+struct mlx5_flow_attr;
+struct mlx5_esw_psample;
+
 struct mlx5_sample_attr {
 	u32 group_num;
 	u32 rate;
 	u32 trunc_size;
+	u32 restore_obj_id;
+	u32 sampler_id;
+	struct mlx5_flow_table *sample_default_tbl;
+	struct mlx5_sample_flow *sample_flow;
 };
 
 void mlx5_esw_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj);
 
+struct mlx5_flow_handle *
+mlx5_esw_sample_offload(struct mlx5_esw_psample *sample_priv,
+			struct mlx5_flow_spec *spec,
+			struct mlx5_flow_attr *attr);
+
+void
+mlx5_esw_sample_unoffload(struct mlx5_esw_psample *sample_priv,
+			  struct mlx5_flow_handle *rule,
+			  struct mlx5_flow_attr *attr);
+
 struct mlx5_esw_psample *
 mlx5_esw_sample_init(struct mlx5e_priv *priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ed4d7f8f798f..deafb0e03787 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -376,6 +376,9 @@ void
 mlx5_eswitch_termtbl_put(struct mlx5_eswitch *esw,
 			 struct mlx5_termtbl_handle *tt);
 
+void
+mlx5_eswitch_clear_rule_source_port(struct mlx5_eswitch *esw, struct mlx5_flow_spec *spec);
+
 struct mlx5_flow_handle *
 mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 				struct mlx5_flow_spec *spec,
@@ -423,6 +426,7 @@ enum {
 	MLX5_ESW_ATTR_FLAG_SLOW_PATH     = BIT(1),
 	MLX5_ESW_ATTR_FLAG_NO_IN_PORT    = BIT(2),
 	MLX5_ESW_ATTR_FLAG_SRC_REWRITE   = BIT(3),
+	MLX5_ESW_ATTR_FLAG_SAMPLE        = BIT(4),
 };
 
 struct mlx5_esw_flow_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 510e9b8b24fe..ac92ffc8a5d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -86,6 +86,26 @@ mlx5_eswitch_set_rule_flow_source(struct mlx5_eswitch *esw,
 				MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
 }
 
+/* Actually only the upper 16 bits of reg c0 need to be cleared, but the lower 16 bits
+ * are not needed as well in the following process. So clear them all for simplicity.
+ */
+void
+mlx5_eswitch_clear_rule_source_port(struct mlx5_eswitch *esw, struct mlx5_flow_spec *spec)
+{
+	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+		void *misc2;
+
+		misc2 = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_2);
+		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0, 0);
+
+		misc2 = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_2);
+		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0, 0);
+
+		if (!memchr_inv(misc2, 0, MLX5_ST_SZ_BYTES(fte_match_set_misc2)))
+			spec->match_criteria_enable &= ~MLX5_MATCH_MISC_PARAMETERS_2;
+	}
+}
+
 static void
 mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 				  struct mlx5_flow_spec *spec,
@@ -156,6 +176,19 @@ esw_cleanup_decap_indir(struct mlx5_eswitch *esw,
 					 true);
 }
 
+static int
+esw_setup_sampler_dest(struct mlx5_flow_destination *dest,
+		       struct mlx5_flow_act *flow_act,
+		       struct mlx5_esw_flow_attr *esw_attr,
+		       int i)
+{
+	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER;
+	dest[i].sampler_id = esw_attr->sample->sampler_id;
+
+	return 0;
+}
+
 static int
 esw_setup_ft_dest(struct mlx5_flow_destination *dest,
 		  struct mlx5_flow_act *flow_act,
@@ -385,7 +418,10 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 	    MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level))
 		attr->flags |= MLX5_ESW_ATTR_FLAG_SRC_REWRITE;
 
-	if (attr->dest_ft) {
+	if (attr->flags & MLX5_ESW_ATTR_FLAG_SAMPLE) {
+		esw_setup_sampler_dest(dest, flow_act, esw_attr, *i);
+		(*i)++;
+	} else if (attr->dest_ft) {
 		esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
 		(*i)++;
 	} else if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
@@ -488,7 +524,10 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_hdr = attr->modify_hdr;
 
-	if (split) {
+	/* esw_attr->sample is allocated only when there is a sample action */
+	if (esw_attr->sample && esw_attr->sample->sample_default_tbl) {
+		fdb = esw_attr->sample->sample_default_tbl;
+	} else if (split) {
 		fwd_attr.chain = attr->chain;
 		fwd_attr.prio = attr->prio;
 		fwd_attr.vport = esw_attr->in_rep->vport;
-- 
2.30.2

