Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DD63F2618
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhHTE4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232649AbhHTE4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6551C61042;
        Fri, 20 Aug 2021 04:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435324;
        bh=uRoeXVe5EzdiUmIrJj+zg90VXATwy91KujgwEUK29nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUaI0TEnvGynfqvPFD76eEWxpuOkDgr1UjUDB8CSbMA5MN243+NA4EgmrWfHJfVpT
         zyFzxopl7iaxkDw6MwHZiSGbAaLMBF3qW4Z/yVxS5VlvJDcJvrHjfxhT7x2O5fSZ+F
         RvjUy2/rTwwIRQS7VDQxErxDISvINGpukobfh2u6gAv6t+/Eka2HdfGWgm8Klu8iLk
         cFjTC25fBTEUAOR1dnZE8ikvaGZ77AzYJdSGa0yq/KNupMPY3/YyQ2ZlUPbK/3oCiI
         ekefnJIwIHkEMUA27ESV+oIPTDvJzIGXZWqxkzngqpBaVrwntoUX6ntvAxLiMZwm/3
         jHsHkZAOzt1mw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Move esw/sample to en/tc/sample
Date:   Thu, 19 Aug 2021 21:55:02 -0700
Message-Id: <20210820045515.265297-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Module sample belongs to en/tc instead of esw. Move it and rename
accordingly.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   4 +-
 .../mlx5/core/{esw => en/tc}/sample.c         | 160 +++++++++---------
 .../mlx5/core/{esw => en/tc}/sample.h         |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  18 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   4 +-
 7 files changed, 104 insertions(+), 104 deletions(-)
 rename drivers/net/ethernet/mellanox/mlx5/core/{esw => en/tc}/sample.c (79%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{esw => en/tc}/sample.h (58%)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 4fccc9bc0328..34e17e502e40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -46,6 +46,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
 					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
+mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
 
 #
 # Core extra
@@ -56,7 +57,6 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
 				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o \
 				      esw/devlink_port.o esw/vporttbl.o
-mlx5_core-$(CONFIG_MLX5_TC_SAMPLE) += esw/sample.o
 mlx5_core-$(CONFIG_MLX5_BRIDGE)    += esw/bridge.o en/rep/bridge.o
 
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 059799e4f483..b35aa1ccd250 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -17,7 +17,7 @@
 #include "en/mapping.h"
 #include "en/tc_tun.h"
 #include "lib/port_tun.h"
-#include "esw/sample.h"
+#include "en/tc/sample.h"
 
 struct mlx5e_rep_indr_block_priv {
 	struct net_device *netdev;
@@ -677,7 +677,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 #endif /* CONFIG_NET_TC_SKB_EXT */
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	if (mapped_obj.type == MLX5_MAPPED_OBJ_SAMPLE) {
-		mlx5_esw_sample_skb(skb, &mapped_obj);
+		mlx5e_tc_sample_skb(skb, &mapped_obj);
 		return false;
 	}
 #endif /* CONFIG_MLX5_TC_SAMPLE */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
similarity index 79%
rename from drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
rename to drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 34e1fd908686..8e12e56f639f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -4,7 +4,7 @@
 #include <linux/skbuff.h>
 #include <net/psample.h>
 #include "en/mapping.h"
-#include "esw/sample.h"
+#include "sample.h"
 #include "eswitch.h"
 #include "en_tc.h"
 #include "fs_core.h"
@@ -17,7 +17,7 @@ static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_sample_ns = {
 	.flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT | MLX5_FLOW_TABLE_TUNNEL_EN_DECAP,
 };
 
-struct mlx5_esw_psample {
+struct mlx5e_tc_psample {
 	struct mlx5_eswitch *esw;
 	struct mlx5_flow_table *termtbl;
 	struct mlx5_flow_handle *termtbl_rule;
@@ -27,7 +27,7 @@ struct mlx5_esw_psample {
 	struct mutex restore_lock; /* protect restore_hashtbl */
 };
 
-struct mlx5_sampler {
+struct mlx5e_sampler {
 	struct hlist_node hlist;
 	u32 sampler_id;
 	u32 sample_ratio;
@@ -36,15 +36,15 @@ struct mlx5_sampler {
 	int count;
 };
 
-struct mlx5_sample_flow {
-	struct mlx5_sampler *sampler;
-	struct mlx5_sample_restore *restore;
+struct mlx5e_sample_flow {
+	struct mlx5e_sampler *sampler;
+	struct mlx5e_sample_restore *restore;
 	struct mlx5_flow_attr *pre_attr;
 	struct mlx5_flow_handle *pre_rule;
 	struct mlx5_flow_handle *rule;
 };
 
-struct mlx5_sample_restore {
+struct mlx5e_sample_restore {
 	struct hlist_node hlist;
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_flow_handle *rule;
@@ -53,9 +53,9 @@ struct mlx5_sample_restore {
 };
 
 static int
-sampler_termtbl_create(struct mlx5_esw_psample *esw_psample)
+sampler_termtbl_create(struct mlx5e_tc_psample *tc_psample)
 {
-	struct mlx5_eswitch *esw = esw_psample->esw;
+	struct mlx5_eswitch *esw = tc_psample->esw;
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_core_dev *dev = esw->dev;
@@ -79,20 +79,20 @@ sampler_termtbl_create(struct mlx5_esw_psample *esw_psample)
 	ft_attr.prio = FDB_SLOW_PATH;
 	ft_attr.max_fte = 1;
 	ft_attr.level = 1;
-	esw_psample->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
-	if (IS_ERR(esw_psample->termtbl)) {
-		err = PTR_ERR(esw_psample->termtbl);
+	tc_psample->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
+	if (IS_ERR(tc_psample->termtbl)) {
+		err = PTR_ERR(tc_psample->termtbl);
 		mlx5_core_warn(dev, "failed to create termtbl, err: %d\n", err);
 		return err;
 	}
 
 	act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	dest.vport.num = esw->manager_vport;
-	esw_psample->termtbl_rule = mlx5_add_flow_rules(esw_psample->termtbl, NULL, &act, &dest, 1);
-	if (IS_ERR(esw_psample->termtbl_rule)) {
-		err = PTR_ERR(esw_psample->termtbl_rule);
+	tc_psample->termtbl_rule = mlx5_add_flow_rules(tc_psample->termtbl, NULL, &act, &dest, 1);
+	if (IS_ERR(tc_psample->termtbl_rule)) {
+		err = PTR_ERR(tc_psample->termtbl_rule);
 		mlx5_core_warn(dev, "failed to create termtbl rule, err: %d\n", err);
-		mlx5_destroy_flow_table(esw_psample->termtbl);
+		mlx5_destroy_flow_table(tc_psample->termtbl);
 		return err;
 	}
 
@@ -100,14 +100,14 @@ sampler_termtbl_create(struct mlx5_esw_psample *esw_psample)
 }
 
 static void
-sampler_termtbl_destroy(struct mlx5_esw_psample *esw_psample)
+sampler_termtbl_destroy(struct mlx5e_tc_psample *tc_psample)
 {
-	mlx5_del_flow_rules(esw_psample->termtbl_rule);
-	mlx5_destroy_flow_table(esw_psample->termtbl);
+	mlx5_del_flow_rules(tc_psample->termtbl_rule);
+	mlx5_destroy_flow_table(tc_psample->termtbl);
 }
 
 static int
-sampler_obj_create(struct mlx5_core_dev *mdev, struct mlx5_sampler *sampler)
+sampler_obj_create(struct mlx5_core_dev *mdev, struct mlx5e_sampler *sampler)
 {
 	u32 in[MLX5_ST_SZ_DW(create_sampler_obj_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
@@ -163,16 +163,16 @@ sampler_cmp(u32 sample_ratio1, u32 default_table_id1, u32 sample_ratio2, u32 def
 	return sample_ratio1 != sample_ratio2 || default_table_id1 != default_table_id2;
 }
 
-static struct mlx5_sampler *
-sampler_get(struct mlx5_esw_psample *esw_psample, u32 sample_ratio, u32 default_table_id)
+static struct mlx5e_sampler *
+sampler_get(struct mlx5e_tc_psample *tc_psample, u32 sample_ratio, u32 default_table_id)
 {
-	struct mlx5_sampler *sampler;
+	struct mlx5e_sampler *sampler;
 	u32 hash_key;
 	int err;
 
-	mutex_lock(&esw_psample->ht_lock);
+	mutex_lock(&tc_psample->ht_lock);
 	hash_key = sampler_hash(sample_ratio, default_table_id);
-	hash_for_each_possible(esw_psample->hashtbl, sampler, hlist, hash_key)
+	hash_for_each_possible(tc_psample->hashtbl, sampler, hlist, hash_key)
 		if (!sampler_cmp(sampler->sample_ratio, sampler->default_table_id,
 				 sample_ratio, default_table_id))
 			goto add_ref;
@@ -183,38 +183,38 @@ sampler_get(struct mlx5_esw_psample *esw_psample, u32 sample_ratio, u32 default_
 		goto err_alloc;
 	}
 
-	sampler->sample_table_id = esw_psample->termtbl->id;
+	sampler->sample_table_id = tc_psample->termtbl->id;
 	sampler->default_table_id = default_table_id;
 	sampler->sample_ratio = sample_ratio;
 
-	err = sampler_obj_create(esw_psample->esw->dev, sampler);
+	err = sampler_obj_create(tc_psample->esw->dev, sampler);
 	if (err)
 		goto err_create;
 
-	hash_add(esw_psample->hashtbl, &sampler->hlist, hash_key);
+	hash_add(tc_psample->hashtbl, &sampler->hlist, hash_key);
 
 add_ref:
 	sampler->count++;
-	mutex_unlock(&esw_psample->ht_lock);
+	mutex_unlock(&tc_psample->ht_lock);
 	return sampler;
 
 err_create:
 	kfree(sampler);
 err_alloc:
-	mutex_unlock(&esw_psample->ht_lock);
+	mutex_unlock(&tc_psample->ht_lock);
 	return ERR_PTR(err);
 }
 
 static void
-sampler_put(struct mlx5_esw_psample *esw_psample, struct mlx5_sampler *sampler)
+sampler_put(struct mlx5e_tc_psample *tc_psample, struct mlx5e_sampler *sampler)
 {
-	mutex_lock(&esw_psample->ht_lock);
+	mutex_lock(&tc_psample->ht_lock);
 	if (--sampler->count == 0) {
 		hash_del(&sampler->hlist);
-		sampler_obj_destroy(esw_psample->esw->dev, sampler->sampler_id);
+		sampler_obj_destroy(tc_psample->esw->dev, sampler->sampler_id);
 		kfree(sampler);
 	}
-	mutex_unlock(&esw_psample->ht_lock);
+	mutex_unlock(&tc_psample->ht_lock);
 }
 
 static struct mlx5_modify_hdr *
@@ -246,17 +246,17 @@ sample_metadata_rule_get(struct mlx5_core_dev *mdev, u32 obj_id)
 	return ERR_PTR(err);
 }
 
-static struct mlx5_sample_restore *
-sample_restore_get(struct mlx5_esw_psample *esw_psample, u32 obj_id)
+static struct mlx5e_sample_restore *
+sample_restore_get(struct mlx5e_tc_psample *tc_psample, u32 obj_id)
 {
-	struct mlx5_eswitch *esw = esw_psample->esw;
+	struct mlx5_eswitch *esw = tc_psample->esw;
 	struct mlx5_core_dev *mdev = esw->dev;
-	struct mlx5_sample_restore *restore;
+	struct mlx5e_sample_restore *restore;
 	struct mlx5_modify_hdr *modify_hdr;
 	int err;
 
-	mutex_lock(&esw_psample->restore_lock);
-	hash_for_each_possible(esw_psample->restore_hashtbl, restore, hlist, obj_id)
+	mutex_lock(&tc_psample->restore_lock);
+	hash_for_each_possible(tc_psample->restore_hashtbl, restore, hlist, obj_id)
 		if (restore->obj_id == obj_id)
 			goto add_ref;
 
@@ -280,10 +280,10 @@ sample_restore_get(struct mlx5_esw_psample *esw_psample, u32 obj_id)
 		goto err_restore;
 	}
 
-	hash_add(esw_psample->restore_hashtbl, &restore->hlist, obj_id);
+	hash_add(tc_psample->restore_hashtbl, &restore->hlist, obj_id);
 add_ref:
 	restore->count++;
-	mutex_unlock(&esw_psample->restore_lock);
+	mutex_unlock(&tc_psample->restore_lock);
 	return restore;
 
 err_restore:
@@ -291,26 +291,26 @@ sample_restore_get(struct mlx5_esw_psample *esw_psample, u32 obj_id)
 err_modify_hdr:
 	kfree(restore);
 err_alloc:
-	mutex_unlock(&esw_psample->restore_lock);
+	mutex_unlock(&tc_psample->restore_lock);
 	return ERR_PTR(err);
 }
 
 static void
-sample_restore_put(struct mlx5_esw_psample *esw_psample, struct mlx5_sample_restore *restore)
+sample_restore_put(struct mlx5e_tc_psample *tc_psample, struct mlx5e_sample_restore *restore)
 {
-	mutex_lock(&esw_psample->restore_lock);
+	mutex_lock(&tc_psample->restore_lock);
 	if (--restore->count == 0)
 		hash_del(&restore->hlist);
-	mutex_unlock(&esw_psample->restore_lock);
+	mutex_unlock(&tc_psample->restore_lock);
 
 	if (!restore->count) {
 		mlx5_del_flow_rules(restore->rule);
-		mlx5_modify_header_dealloc(esw_psample->esw->dev, restore->modify_hdr);
+		mlx5_modify_header_dealloc(tc_psample->esw->dev, restore->modify_hdr);
 		kfree(restore);
 	}
 }
 
-void mlx5_esw_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj)
+void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj)
 {
 	u32 trunc_size = mapped_obj->sample.trunc_size;
 	struct psample_group psample_group = {};
@@ -362,7 +362,7 @@ void mlx5_esw_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj
  *                                  +----------------------------------------+
  */
 struct mlx5_flow_handle *
-mlx5_esw_sample_offload(struct mlx5_esw_psample *esw_psample,
+mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 			struct mlx5_flow_spec *spec,
 			struct mlx5_flow_attr *attr)
 {
@@ -370,21 +370,21 @@ mlx5_esw_sample_offload(struct mlx5_esw_psample *esw_psample,
 	struct mlx5_vport_tbl_attr per_vport_tbl_attr;
 	struct mlx5_esw_flow_attr *pre_esw_attr;
 	struct mlx5_mapped_obj restore_obj = {};
-	struct mlx5_sample_flow *sample_flow;
-	struct mlx5_sample_attr *sample_attr;
+	struct mlx5e_sample_flow *sample_flow;
+	struct mlx5e_sample_attr *sample_attr;
 	struct mlx5_flow_table *default_tbl;
 	struct mlx5_flow_attr *pre_attr;
 	struct mlx5_eswitch *esw;
 	u32 obj_id;
 	int err;
 
-	if (IS_ERR_OR_NULL(esw_psample))
+	if (IS_ERR_OR_NULL(tc_psample))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	/* If slow path flag is set, eg. when the neigh is invalid for encap,
 	 * don't offload sample action.
 	 */
-	esw = esw_psample->esw;
+	esw = tc_psample->esw;
 	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
 		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 
@@ -426,7 +426,7 @@ mlx5_esw_sample_offload(struct mlx5_esw_psample *esw_psample,
 	}
 
 	/* Create sampler object. */
-	sample_flow->sampler = sampler_get(esw_psample, esw_attr->sample->rate, default_tbl->id);
+	sample_flow->sampler = sampler_get(tc_psample, esw_attr->sample->rate, default_tbl->id);
 	if (IS_ERR(sample_flow->sampler)) {
 		err = PTR_ERR(sample_flow->sampler);
 		goto err_sampler;
@@ -443,7 +443,7 @@ mlx5_esw_sample_offload(struct mlx5_esw_psample *esw_psample,
 	esw_attr->sample->restore_obj_id = obj_id;
 
 	/* Create sample restore context. */
-	sample_flow->restore = sample_restore_get(esw_psample, obj_id);
+	sample_flow->restore = sample_restore_get(tc_psample, obj_id);
 	if (IS_ERR(sample_flow->restore)) {
 		err = PTR_ERR(sample_flow->restore);
 		goto err_sample_restore;
@@ -486,11 +486,11 @@ mlx5_esw_sample_offload(struct mlx5_esw_psample *esw_psample,
 err_alloc_sample_attr:
 	kfree(pre_attr);
 err_alloc_flow_attr:
-	sample_restore_put(esw_psample, sample_flow->restore);
+	sample_restore_put(tc_psample, sample_flow->restore);
 err_sample_restore:
 	mapping_remove(esw->offloads.reg_c0_obj_pool, obj_id);
 err_obj_id:
-	sampler_put(esw_psample, sample_flow->sampler);
+	sampler_put(tc_psample, sample_flow->sampler);
 err_sampler:
 	/* For sample offload, rule is added in default_tbl. No need to call
 	 * mlx5_esw_chains_put_table()
@@ -506,23 +506,23 @@ mlx5_esw_sample_offload(struct mlx5_esw_psample *esw_psample,
 }
 
 void
-mlx5_esw_sample_unoffload(struct mlx5_esw_psample *esw_psample,
+mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 			  struct mlx5_flow_handle *rule,
 			  struct mlx5_flow_attr *attr)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
-	struct mlx5_sample_flow *sample_flow;
+	struct mlx5e_sample_flow *sample_flow;
 	struct mlx5_vport_tbl_attr tbl_attr;
 	struct mlx5_flow_attr *pre_attr;
 	struct mlx5_eswitch *esw;
 
-	if (IS_ERR_OR_NULL(esw_psample))
+	if (IS_ERR_OR_NULL(tc_psample))
 		return;
 
 	/* If slow path flag is set, sample action is not offloaded.
 	 * No need to delete sample rule.
 	 */
-	esw = esw_psample->esw;
+	esw = tc_psample->esw;
 	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
 		mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
 		return;
@@ -534,9 +534,9 @@ mlx5_esw_sample_unoffload(struct mlx5_esw_psample *esw_psample,
 	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, pre_attr);
 	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->rule, attr);
 
-	sample_restore_put(esw_psample, sample_flow->restore);
+	sample_restore_put(tc_psample, sample_flow->restore);
 	mapping_remove(esw->offloads.reg_c0_obj_pool, esw_attr->sample->restore_obj_id);
-	sampler_put(esw_psample, sample_flow->sampler);
+	sampler_put(tc_psample, sample_flow->sampler);
 	tbl_attr.chain = attr->chain;
 	tbl_attr.prio = attr->prio;
 	tbl_attr.vport = esw_attr->in_rep->vport;
@@ -548,38 +548,38 @@ mlx5_esw_sample_unoffload(struct mlx5_esw_psample *esw_psample,
 	kfree(sample_flow);
 }
 
-struct mlx5_esw_psample *
-mlx5_esw_sample_init(struct mlx5_eswitch *esw)
+struct mlx5e_tc_psample *
+mlx5e_tc_sample_init(struct mlx5_eswitch *esw)
 {
-	struct mlx5_esw_psample *esw_psample;
+	struct mlx5e_tc_psample *tc_psample;
 	int err;
 
-	esw_psample = kzalloc(sizeof(*esw_psample), GFP_KERNEL);
-	if (!esw_psample)
+	tc_psample = kzalloc(sizeof(*tc_psample), GFP_KERNEL);
+	if (!tc_psample)
 		return ERR_PTR(-ENOMEM);
-	esw_psample->esw = esw;
-	err = sampler_termtbl_create(esw_psample);
+	tc_psample->esw = esw;
+	err = sampler_termtbl_create(tc_psample);
 	if (err)
 		goto err_termtbl;
 
-	mutex_init(&esw_psample->ht_lock);
-	mutex_init(&esw_psample->restore_lock);
+	mutex_init(&tc_psample->ht_lock);
+	mutex_init(&tc_psample->restore_lock);
 
-	return esw_psample;
+	return tc_psample;
 
 err_termtbl:
-	kfree(esw_psample);
+	kfree(tc_psample);
 	return ERR_PTR(err);
 }
 
 void
-mlx5_esw_sample_cleanup(struct mlx5_esw_psample *esw_psample)
+mlx5e_tc_sample_cleanup(struct mlx5e_tc_psample *tc_psample)
 {
-	if (IS_ERR_OR_NULL(esw_psample))
+	if (IS_ERR_OR_NULL(tc_psample))
 		return;
 
-	mutex_destroy(&esw_psample->restore_lock);
-	mutex_destroy(&esw_psample->ht_lock);
-	sampler_termtbl_destroy(esw_psample);
-	kfree(esw_psample);
+	mutex_destroy(&tc_psample->restore_lock);
+	mutex_destroy(&tc_psample->ht_lock);
+	sampler_termtbl_destroy(tc_psample);
+	kfree(tc_psample);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
similarity index 58%
rename from drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
rename to drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
index c27525bd82d0..c8aa42ee0075 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
@@ -7,34 +7,34 @@
 #include "eswitch.h"
 
 struct mlx5_flow_attr;
-struct mlx5_esw_psample;
+struct mlx5e_tc_psample;
 
-struct mlx5_sample_attr {
+struct mlx5e_sample_attr {
 	u32 group_num;
 	u32 rate;
 	u32 trunc_size;
 	u32 restore_obj_id;
 	u32 sampler_id;
 	struct mlx5_flow_table *sample_default_tbl;
-	struct mlx5_sample_flow *sample_flow;
+	struct mlx5e_sample_flow *sample_flow;
 };
 
-void mlx5_esw_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj);
+void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj);
 
 struct mlx5_flow_handle *
-mlx5_esw_sample_offload(struct mlx5_esw_psample *sample_priv,
+mlx5e_tc_sample_offload(struct mlx5e_tc_psample *sample_priv,
 			struct mlx5_flow_spec *spec,
 			struct mlx5_flow_attr *attr);
 
 void
-mlx5_esw_sample_unoffload(struct mlx5_esw_psample *sample_priv,
+mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *sample_priv,
 			  struct mlx5_flow_handle *rule,
 			  struct mlx5_flow_attr *attr);
 
-struct mlx5_esw_psample *
-mlx5_esw_sample_init(struct mlx5_eswitch *esw);
+struct mlx5e_tc_psample *
+mlx5e_tc_sample_init(struct mlx5_eswitch *esw);
 
 void
-mlx5_esw_sample_cleanup(struct mlx5_esw_psample *esw_psample);
+mlx5e_tc_sample_cleanup(struct mlx5e_tc_psample *tc_psample);
 
 #endif /* __MLX5_EN_TC_SAMPLE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 756f806401d7..e46698b42031 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -89,7 +89,7 @@ struct mlx5_rep_uplink_priv {
 	struct mapping_ctx *tunnel_enc_opts_mapping;
 
 	struct mlx5_tc_ct_priv *ct_priv;
-	struct mlx5_esw_psample *esw_psample;
+	struct mlx5e_tc_psample *tc_psample;
 
 	/* support eswitch vports bonding */
 	struct mlx5e_rep_bond *bond;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2257c1321385..f1725f1ae693 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -60,7 +60,7 @@
 #include "en/mod_hdr.h"
 #include "en/tc_priv.h"
 #include "en/tc_tun_encap.h"
-#include "esw/sample.h"
+#include "en/tc/sample.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
@@ -246,7 +246,7 @@ get_ct_priv(struct mlx5e_priv *priv)
 }
 
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
-static struct mlx5_esw_psample *
+static struct mlx5e_tc_psample *
 get_sample_priv(struct mlx5e_priv *priv)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
@@ -257,7 +257,7 @@ get_sample_priv(struct mlx5e_priv *priv)
 		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 		uplink_priv = &uplink_rpriv->uplink_priv;
 
-		return uplink_priv->esw_psample;
+		return uplink_priv->tc_psample;
 	}
 
 	return NULL;
@@ -1147,7 +1147,7 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 					       mod_hdr_acts);
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	} else if (flow_flag_test(flow, SAMPLE)) {
-		rule = mlx5_esw_sample_offload(get_sample_priv(flow->priv), spec, attr);
+		rule = mlx5e_tc_sample_offload(get_sample_priv(flow->priv), spec, attr);
 #endif
 	} else {
 		rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
@@ -1186,7 +1186,7 @@ void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	if (flow_flag_test(flow, SAMPLE)) {
-		mlx5_esw_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
+		mlx5e_tc_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
 		return;
 	}
 #endif
@@ -3722,7 +3722,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
-	struct mlx5_sample_attr sample = {};
+	struct mlx5e_sample_attr sample = {};
 	bool encap = false, decap = false;
 	u32 action = attr->action;
 	int err, i, if_count = 0;
@@ -4976,7 +4976,7 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 					       MLX5_FLOW_NAMESPACE_FDB);
 
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
-	uplink_priv->esw_psample = mlx5_esw_sample_init(esw);
+	uplink_priv->tc_psample = mlx5e_tc_sample_init(esw);
 #endif
 
 	mapping_id = mlx5_query_nic_system_image_guid(esw->dev);
@@ -5022,7 +5022,7 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	mapping_destroy(uplink_priv->tunnel_mapping);
 err_tun_mapping:
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
-	mlx5_esw_sample_cleanup(uplink_priv->esw_psample);
+	mlx5e_tc_sample_cleanup(uplink_priv->tc_psample);
 #endif
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 	netdev_warn(priv->netdev,
@@ -5043,7 +5043,7 @@ void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
 	mapping_destroy(uplink_priv->tunnel_mapping);
 
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
-	mlx5_esw_sample_cleanup(uplink_priv->esw_psample);
+	mlx5e_tc_sample_cleanup(uplink_priv->tc_psample);
 #endif
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index d3a5ff4f6140..0c6ddd7ad7ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -46,7 +46,7 @@
 #include "lib/fs_chains.h"
 #include "sf/sf.h"
 #include "en/tc_ct.h"
-#include "esw/sample.h"
+#include "en/tc/sample.h"
 
 enum mlx5_mapped_obj_type {
 	MLX5_MAPPED_OBJ_CHAIN,
@@ -469,7 +469,7 @@ struct mlx5_esw_flow_attr {
 	} dests[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5_rx_tun_attr *rx_tun_attr;
 	struct mlx5_pkt_reformat *decap_pkt_reformat;
-	struct mlx5_sample_attr *sample;
+	struct mlx5e_sample_attr *sample;
 };
 
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
-- 
2.31.1

