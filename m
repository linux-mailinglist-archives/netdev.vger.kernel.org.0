Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C653F2620
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238049AbhHTE4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233825AbhHTE4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2207B610A1;
        Fri, 20 Aug 2021 04:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435328;
        bh=WkMtPdIh8e7Do3NIeQ42g74vI2+mhke/Obc9fAyFIjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBkerteZIKJdqK2aTNekAu3Nqt86XhEOMRNDXJ1ezjReBkXOJAkzh+CT4AAsObCCl
         HSZQXVz1SCx3pNutIvtuCSUnS+H/wLOeCLdTy4L8ef5uExysU8rc+5z2CKInMTcEUr
         O8zbHaRQjUuEXJpFPQsHk0rgXWz/S+BWy760ThhRVmYDtsvoVl39sMHv9y6HYzSQkH
         EUQrdxGuknMd/RCNVQhfRFBkbCtHnAvsRbILS3/HWinhp0R/UTA7JgQ8XXvAgxwsbz
         yBSzzPQ/qTieTL6Y7DfYt2dL4JpyXvRI2rebE933C5csw51quo+ni98SrVdK7ICquC
         Wcx68tiNmZxpQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: TC, Support sample offload action for tunneled traffic
Date:   Thu, 19 Aug 2021 21:55:09 -0700
Message-Id: <20210820045515.265297-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently the sample offload actions send the encapsulated packet
to software. This commit decapsulates the packet before performing
the sampling and set the tunnel properties on the skb metadata
fields to make the behavior consistent with OVS sFlow.

If decapsulating first, we can't use the same match like before in
default table. So instantiate a post action instance to continue
processing the action list. If HW can preserve reg_c, also use the
post action instance.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/sample.c         | 294 +++++++++++++-----
 .../mellanox/mlx5/core/en/tc/sample.h         |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |   5 +-
 4 files changed, 214 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 739292d52aca..6552ecee3f9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -4,6 +4,7 @@
 #include <linux/skbuff.h>
 #include <net/psample.h>
 #include "en/mapping.h"
+#include "en/tc/post_act.h"
 #include "sample.h"
 #include "eswitch.h"
 #include "en_tc.h"
@@ -25,6 +26,7 @@ struct mlx5e_tc_psample {
 	struct mutex ht_lock; /* protect hashtbl */
 	DECLARE_HASHTABLE(restore_hashtbl, 8);
 	struct mutex restore_lock; /* protect restore_hashtbl */
+	struct mlx5e_post_act *post_act;
 };
 
 struct mlx5e_sampler {
@@ -41,13 +43,16 @@ struct mlx5e_sample_flow {
 	struct mlx5e_sample_restore *restore;
 	struct mlx5_flow_attr *pre_attr;
 	struct mlx5_flow_handle *pre_rule;
-	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_attr *post_attr;
+	struct mlx5_flow_handle *post_rule;
+	struct mlx5e_post_act_handle *post_act_handle;
 };
 
 struct mlx5e_sample_restore {
 	struct hlist_node hlist;
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_flow_handle *rule;
+	struct mlx5e_post_act_handle *post_act_handle;
 	u32 obj_id;
 	int count;
 };
@@ -217,8 +222,15 @@ sampler_put(struct mlx5e_tc_psample *tc_psample, struct mlx5e_sampler *sampler)
 	mutex_unlock(&tc_psample->ht_lock);
 }
 
+/* obj_id is used to restore the sample parameters.
+ * Set fte_id in original flow table, then match it in the default table.
+ * Only set it for NICs can preserve reg_c or decap action. For other cases,
+ * use the same match in the default table.
+ * Use one header rewrite for both obj_id and fte_id.
+ */
 static struct mlx5_modify_hdr *
-sample_metadata_rule_get(struct mlx5_core_dev *mdev, u32 obj_id)
+sample_modify_hdr_get(struct mlx5_core_dev *mdev, u32 obj_id,
+		      struct mlx5e_post_act_handle *handle)
 {
 	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
 	struct mlx5_modify_hdr *modify_hdr;
@@ -229,6 +241,12 @@ sample_metadata_rule_get(struct mlx5_core_dev *mdev, u32 obj_id)
 	if (err)
 		goto err_set_regc0;
 
+	if (handle) {
+		err = mlx5e_tc_post_act_set_handle(mdev, handle, &mod_acts);
+		if (err)
+			goto err_post_act;
+	}
+
 	modify_hdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_FDB,
 					      mod_acts.num_actions,
 					      mod_acts.actions);
@@ -241,23 +259,40 @@ sample_metadata_rule_get(struct mlx5_core_dev *mdev, u32 obj_id)
 	return modify_hdr;
 
 err_modify_hdr:
+err_post_act:
 	dealloc_mod_hdr_actions(&mod_acts);
 err_set_regc0:
 	return ERR_PTR(err);
 }
 
+static u32
+restore_hash(u32 obj_id, struct mlx5e_post_act_handle *post_act_handle)
+{
+	return jhash_2words(obj_id, hash32_ptr(post_act_handle), 0);
+}
+
+static bool
+restore_equal(struct mlx5e_sample_restore *restore, u32 obj_id,
+	      struct mlx5e_post_act_handle *post_act_handle)
+{
+	return restore->obj_id == obj_id && restore->post_act_handle == post_act_handle;
+}
+
 static struct mlx5e_sample_restore *
-sample_restore_get(struct mlx5e_tc_psample *tc_psample, u32 obj_id)
+sample_restore_get(struct mlx5e_tc_psample *tc_psample, u32 obj_id,
+		   struct mlx5e_post_act_handle *post_act_handle)
 {
 	struct mlx5_eswitch *esw = tc_psample->esw;
 	struct mlx5_core_dev *mdev = esw->dev;
 	struct mlx5e_sample_restore *restore;
 	struct mlx5_modify_hdr *modify_hdr;
+	u32 hash_key;
 	int err;
 
 	mutex_lock(&tc_psample->restore_lock);
-	hash_for_each_possible(tc_psample->restore_hashtbl, restore, hlist, obj_id)
-		if (restore->obj_id == obj_id)
+	hash_key = restore_hash(obj_id, post_act_handle);
+	hash_for_each_possible(tc_psample->restore_hashtbl, restore, hlist, hash_key)
+		if (restore_equal(restore, obj_id, post_act_handle))
 			goto add_ref;
 
 	restore = kzalloc(sizeof(*restore), GFP_KERNEL);
@@ -266,8 +301,9 @@ sample_restore_get(struct mlx5e_tc_psample *tc_psample, u32 obj_id)
 		goto err_alloc;
 	}
 	restore->obj_id = obj_id;
+	restore->post_act_handle = post_act_handle;
 
-	modify_hdr = sample_metadata_rule_get(mdev, obj_id);
+	modify_hdr = sample_modify_hdr_get(mdev, obj_id, post_act_handle);
 	if (IS_ERR(modify_hdr)) {
 		err = PTR_ERR(modify_hdr);
 		goto err_modify_hdr;
@@ -280,7 +316,7 @@ sample_restore_get(struct mlx5e_tc_psample *tc_psample, u32 obj_id)
 		goto err_restore;
 	}
 
-	hash_add(tc_psample->restore_hashtbl, &restore->hlist, obj_id);
+	hash_add(tc_psample->restore_hashtbl, &restore->hlist, hash_key);
 add_ref:
 	restore->count++;
 	mutex_unlock(&tc_psample->restore_lock);
@@ -325,6 +361,87 @@ void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj
 	psample_sample_packet(&psample_group, skb, mapped_obj->sample.rate, &md);
 }
 
+static int
+add_post_rule(struct mlx5_eswitch *esw, struct mlx5e_sample_flow *sample_flow,
+	      struct mlx5_flow_spec *spec, struct mlx5_flow_attr *attr,
+	      u32 *default_tbl_id)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	u32 attr_sz = ns_to_attr_sz(MLX5_FLOW_NAMESPACE_FDB);
+	struct mlx5_vport_tbl_attr per_vport_tbl_attr;
+	struct mlx5_flow_table *default_tbl;
+	struct mlx5_flow_attr *post_attr;
+	int err;
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
+	*default_tbl_id = default_tbl->id;
+
+	post_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
+	if (!post_attr) {
+		err = -ENOMEM;
+		goto err_attr;
+	}
+	sample_flow->post_attr = post_attr;
+	memcpy(post_attr, attr, attr_sz);
+	/* Perform the original matches on the default table.
+	 * Offload all actions except the sample action.
+	 */
+	post_attr->chain = 0;
+	post_attr->prio = 0;
+	post_attr->ft = default_tbl;
+	post_attr->flags = MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
+
+	/* When offloading sample and encap action, if there is no valid
+	 * neigh data struct, a slow path rule is offloaded first. Source
+	 * port metadata match is set at that time. A per vport table is
+	 * already allocated. No need to match it again. So clear the source
+	 * port metadata match.
+	 */
+	mlx5_eswitch_clear_rule_source_port(esw, spec);
+	sample_flow->post_rule = mlx5_eswitch_add_offloaded_rule(esw, spec, post_attr);
+	if (IS_ERR(sample_flow->post_rule)) {
+		err = PTR_ERR(sample_flow->post_rule);
+		goto err_rule;
+	}
+	return 0;
+
+err_rule:
+	kfree(post_attr);
+err_attr:
+	mlx5_esw_vporttbl_put(esw, &per_vport_tbl_attr);
+err_default_tbl:
+	return err;
+}
+
+static void
+del_post_rule(struct mlx5_eswitch *esw, struct mlx5e_sample_flow *sample_flow,
+	      struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct mlx5_vport_tbl_attr tbl_attr;
+
+	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->post_rule, sample_flow->post_attr);
+	kfree(sample_flow->post_attr);
+	tbl_attr.chain = attr->chain;
+	tbl_attr.prio = attr->prio;
+	tbl_attr.vport = esw_attr->in_rep->vport;
+	tbl_attr.vport_ns = &mlx5_esw_vport_tbl_sample_ns;
+	mlx5_esw_vporttbl_put(esw, &tbl_attr);
+}
+
 /* For the following typical flow table:
  *
  * +-------------------------------+
@@ -342,8 +459,9 @@ void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj
  *         +---------------------+
  *         +   original match    +
  *         +---------------------+
- *                    |
- *                    v
+ *               | set fte_id (if reg_c preserve cap)
+ *               | do decap (if required)
+ *               v
  * +------------------------------------------------+
  * +                Flow Sampler Object             +
  * +------------------------------------------------+
@@ -353,13 +471,22 @@ void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj
  * +------------------------------------------------+
  *            |                            |
  *            v                            v
- * +-----------------------------+  +----------------------------------------+
- * +        sample table         +  + default table per <vport, chain, prio> +
- * +-----------------------------+  +----------------------------------------+
- * + forward to management vport +  +            original match              +
- * +-----------------------------+  +----------------------------------------+
- *                                  +            other actions               +
- *                                  +----------------------------------------+
+ * +-----------------------------+  +-------------------+
+ * +        sample table         +  +   default table   +
+ * +-----------------------------+  +-------------------+
+ * + forward to management vport +             |
+ * +-----------------------------+             |
+ *                                     +-------+------+
+ *                                     |              |reg_c preserve cap
+ *                                     |              |or decap action
+ *                                     v              v
+ *                        +-----------------+   +-------------+
+ *                        + per vport table +   + post action +
+ *                        +-----------------+   +-------------+
+ *                        + original match  +
+ *                        +-----------------+
+ *                        + other actions   +
+ *                        +-----------------+
  */
 struct mlx5_flow_handle *
 mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
@@ -367,15 +494,15 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 			struct mlx5_flow_attr *attr,
 			u32 tunnel_id)
 {
+	struct mlx5e_post_act_handle *post_act_handle = NULL;
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
-	struct mlx5_vport_tbl_attr per_vport_tbl_attr;
 	struct mlx5_esw_flow_attr *pre_esw_attr;
 	struct mlx5_mapped_obj restore_obj = {};
 	struct mlx5e_sample_flow *sample_flow;
 	struct mlx5e_sample_attr *sample_attr;
-	struct mlx5_flow_table *default_tbl;
 	struct mlx5_flow_attr *pre_attr;
 	struct mlx5_eswitch *esw;
+	u32 default_tbl_id;
 	u32 obj_id;
 	int err;
 
@@ -395,40 +522,31 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	sample_attr = attr->sample_attr;
 	sample_attr->sample_flow = sample_flow;
 
-	/* Allocate default table per vport, chain and prio. Otherwise, there is
-	 * only one default table for the same sampler object. Rules with different
-	 * prio and chain may overlap. For CT sample action, per vport default
-	 * table is needed to resotre the metadata.
-	 */
-	per_vport_tbl_attr.chain = attr->chain;
-	per_vport_tbl_attr.prio = attr->prio;
-	per_vport_tbl_attr.vport = esw_attr->in_rep->vport;
-	per_vport_tbl_attr.vport_ns = &mlx5_esw_vport_tbl_sample_ns;
-	default_tbl = mlx5_esw_vporttbl_get(esw, &per_vport_tbl_attr);
-	if (IS_ERR(default_tbl)) {
-		err = PTR_ERR(default_tbl);
-		goto err_default_tbl;
-	}
-
-	/* Perform the original matches on the default table.
-	 * Offload all actions except the sample action.
-	 */
-	sample_attr->sample_default_tbl = default_tbl;
-	/* When offloading sample and encap action, if there is no valid
-	 * neigh data struct, a slow path rule is offloaded first. Source
-	 * port metadata match is set at that time. A per vport table is
-	 * already allocated. No need to match it again. So clear the source
-	 * port metadata match.
+	/* For NICs with reg_c_preserve support or decap action, use
+	 * post action instead of the per vport, chain and prio table.
+	 * Only match the fte id instead of the same match in the
+	 * original flow table.
 	 */
-	mlx5_eswitch_clear_rule_source_port(esw, spec);
-	sample_flow->rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
-	if (IS_ERR(sample_flow->rule)) {
-		err = PTR_ERR(sample_flow->rule);
-		goto err_offload_rule;
+	if (MLX5_CAP_GEN(esw->dev, reg_c_preserve) ||
+	    attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP) {
+		struct mlx5_flow_table *ft;
+
+		ft = mlx5e_tc_post_act_get_ft(tc_psample->post_act);
+		default_tbl_id = ft->id;
+		post_act_handle = mlx5e_tc_post_act_add(tc_psample->post_act, attr);
+		if (IS_ERR(post_act_handle)) {
+			err = PTR_ERR(post_act_handle);
+			goto err_post_act;
+		}
+		sample_flow->post_act_handle = post_act_handle;
+	} else {
+		err = add_post_rule(esw, sample_flow, spec, attr, &default_tbl_id);
+		if (err)
+			goto err_post_rule;
 	}
 
 	/* Create sampler object. */
-	sample_flow->sampler = sampler_get(tc_psample, sample_attr->rate, default_tbl->id);
+	sample_flow->sampler = sampler_get(tc_psample, sample_attr->rate, default_tbl_id);
 	if (IS_ERR(sample_flow->sampler)) {
 		err = PTR_ERR(sample_flow->sampler);
 		goto err_sampler;
@@ -446,7 +564,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	sample_attr->restore_obj_id = obj_id;
 
 	/* Create sample restore context. */
-	sample_flow->restore = sample_restore_get(tc_psample, obj_id);
+	sample_flow->restore = sample_restore_get(tc_psample, obj_id, post_act_handle);
 	if (IS_ERR(sample_flow->restore)) {
 		err = PTR_ERR(sample_flow->restore);
 		goto err_sample_restore;
@@ -458,19 +576,21 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	pre_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
 	if (!pre_attr) {
 		err = -ENOMEM;
-		goto err_alloc_flow_attr;
-	}
-	sample_attr = kzalloc(sizeof(*sample_attr), GFP_KERNEL);
-	if (!sample_attr) {
-		err = -ENOMEM;
-		goto err_alloc_sample_attr;
+		goto err_alloc_pre_flow_attr;
 	}
 	pre_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	/* For decap action, do decap in the original flow table instead of the
+	 * default flow table.
+	 */
+	if (tunnel_id)
+		pre_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
 	pre_attr->modify_hdr = sample_flow->restore->modify_hdr;
 	pre_attr->flags = MLX5_ESW_ATTR_FLAG_SAMPLE;
+	pre_attr->inner_match_level = attr->inner_match_level;
+	pre_attr->outer_match_level = attr->outer_match_level;
 	pre_attr->chain = attr->chain;
 	pre_attr->prio = attr->prio;
-	pre_attr->sample_attr = sample_attr;
+	pre_attr->sample_attr = attr->sample_attr;
 	sample_attr->sampler_id = sample_flow->sampler->sampler_id;
 	pre_esw_attr = pre_attr->esw_attr;
 	pre_esw_attr->in_mdev = esw_attr->in_mdev;
@@ -482,28 +602,23 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	}
 	sample_flow->pre_attr = pre_attr;
 
-	return sample_flow->rule;
+	return sample_flow->post_rule;
 
 err_pre_offload_rule:
-	kfree(sample_attr);
-err_alloc_sample_attr:
 	kfree(pre_attr);
-err_alloc_flow_attr:
+err_alloc_pre_flow_attr:
 	sample_restore_put(tc_psample, sample_flow->restore);
 err_sample_restore:
 	mapping_remove(esw->offloads.reg_c0_obj_pool, obj_id);
 err_obj_id:
 	sampler_put(tc_psample, sample_flow->sampler);
 err_sampler:
-	/* For sample offload, rule is added in default_tbl. No need to call
-	 * mlx5_esw_chains_put_table()
-	 */
-	attr->prio = 0;
-	attr->chain = 0;
-	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->rule, attr);
-err_offload_rule:
-	mlx5_esw_vporttbl_put(esw, &per_vport_tbl_attr);
-err_default_tbl:
+	if (!post_act_handle)
+		del_post_rule(esw, sample_flow, attr);
+err_post_rule:
+	if (post_act_handle)
+		mlx5e_tc_post_act_del(tc_psample->post_act, post_act_handle);
+err_post_act:
 	kfree(sample_flow);
 	return ERR_PTR(err);
 }
@@ -516,7 +631,6 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5e_sample_flow *sample_flow;
 	struct mlx5_vport_tbl_attr tbl_attr;
-	struct mlx5_flow_attr *pre_attr;
 	struct mlx5_eswitch *esw;
 
 	if (IS_ERR_OR_NULL(tc_psample))
@@ -531,28 +645,35 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 		return;
 	}
 
+	/* The following delete order can't be changed, otherwise,
+	 * will hit fw syndromes.
+	 */
 	sample_flow = attr->sample_attr->sample_flow;
-	pre_attr = sample_flow->pre_attr;
-	memset(pre_attr, 0, sizeof(*pre_attr));
-	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, pre_attr);
-	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->rule, attr);
+	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, sample_flow->pre_attr);
+	if (!sample_flow->post_act_handle)
+		mlx5_eswitch_del_offloaded_rule(esw, sample_flow->post_rule,
+						sample_flow->post_attr);
 
 	sample_restore_put(tc_psample, sample_flow->restore);
 	mapping_remove(esw->offloads.reg_c0_obj_pool, attr->sample_attr->restore_obj_id);
 	sampler_put(tc_psample, sample_flow->sampler);
-	tbl_attr.chain = attr->chain;
-	tbl_attr.prio = attr->prio;
-	tbl_attr.vport = esw_attr->in_rep->vport;
-	tbl_attr.vport_ns = &mlx5_esw_vport_tbl_sample_ns;
-	mlx5_esw_vporttbl_put(esw, &tbl_attr);
+	if (sample_flow->post_act_handle) {
+		mlx5e_tc_post_act_del(tc_psample->post_act, sample_flow->post_act_handle);
+	} else {
+		tbl_attr.chain = attr->chain;
+		tbl_attr.prio = attr->prio;
+		tbl_attr.vport = esw_attr->in_rep->vport;
+		tbl_attr.vport_ns = &mlx5_esw_vport_tbl_sample_ns;
+		mlx5_esw_vporttbl_put(esw, &tbl_attr);
+		kfree(sample_flow->post_attr);
+	}
 
-	kfree(pre_attr->sample_attr);
-	kfree(pre_attr);
+	kfree(sample_flow->pre_attr);
 	kfree(sample_flow);
 }
 
 struct mlx5e_tc_psample *
-mlx5e_tc_sample_init(struct mlx5_eswitch *esw)
+mlx5e_tc_sample_init(struct mlx5_eswitch *esw, struct mlx5e_post_act *post_act)
 {
 	struct mlx5e_tc_psample *tc_psample;
 	int err;
@@ -560,17 +681,22 @@ mlx5e_tc_sample_init(struct mlx5_eswitch *esw)
 	tc_psample = kzalloc(sizeof(*tc_psample), GFP_KERNEL);
 	if (!tc_psample)
 		return ERR_PTR(-ENOMEM);
+	if (IS_ERR_OR_NULL(post_act)) {
+		err = PTR_ERR(post_act);
+		goto err_post_act;
+	}
+	tc_psample->post_act = post_act;
 	tc_psample->esw = esw;
 	err = sampler_termtbl_create(tc_psample);
 	if (err)
-		goto err_termtbl;
+		goto err_post_act;
 
 	mutex_init(&tc_psample->ht_lock);
 	mutex_init(&tc_psample->restore_lock);
 
 	return tc_psample;
 
-err_termtbl:
+err_post_act:
 	kfree(tc_psample);
 	return ERR_PTR(err);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
index 1bcf4d399ccd..db0146df9b30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
@@ -8,6 +8,7 @@
 
 struct mlx5_flow_attr;
 struct mlx5e_tc_psample;
+struct mlx5e_post_act;
 
 struct mlx5e_sample_attr {
 	u32 group_num;
@@ -15,7 +16,6 @@ struct mlx5e_sample_attr {
 	u32 trunc_size;
 	u32 restore_obj_id;
 	u32 sampler_id;
-	struct mlx5_flow_table *sample_default_tbl;
 	struct mlx5e_sample_flow *sample_flow;
 };
 
@@ -33,7 +33,7 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *sample_priv,
 			  struct mlx5_flow_attr *attr);
 
 struct mlx5e_tc_psample *
-mlx5e_tc_sample_init(struct mlx5_eswitch *esw);
+mlx5e_tc_sample_init(struct mlx5_eswitch *esw, struct mlx5e_post_act *post_act);
 
 void
 mlx5e_tc_sample_cleanup(struct mlx5e_tc_psample *tc_psample);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 38cf5bdfbd4b..1bd2bc05fb94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4989,7 +4989,7 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 					       uplink_priv->post_act);
 
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
-	uplink_priv->tc_psample = mlx5e_tc_sample_init(esw);
+	uplink_priv->tc_psample = mlx5e_tc_sample_init(esw, uplink_priv->post_act);
 #endif
 
 	mapping_id = mlx5_query_nic_system_image_guid(esw->dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 61175992a789..0d461e38add3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -540,10 +540,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_hdr = attr->modify_hdr;
 
-	/* sample_attr is allocated only when there is a sample action */
-	if (attr->sample_attr && attr->sample_attr->sample_default_tbl) {
-		fdb = attr->sample_attr->sample_default_tbl;
-	} else if (split) {
+	if (split) {
 		fwd_attr.chain = attr->chain;
 		fwd_attr.prio = attr->prio;
 		fwd_attr.vport = esw_attr->in_rep->vport;
-- 
2.31.1

