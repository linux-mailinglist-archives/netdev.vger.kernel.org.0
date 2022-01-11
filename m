Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EA548A53A
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346265AbiAKBnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48874 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346236AbiAKBnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3001561474
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459E7C36AF2;
        Tue, 11 Jan 2022 01:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865430;
        bh=kNorj7Ohy+YaLC3X/Plnp4EZl4IvQNT4mgWlJM5NDG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pdd+YikjAMS1SgR9HytAHWpv2GvjvyUh/84k4XaDWJfc9WX1Jupwl9Mrx3O3mqtf5
         CvbKThmHfql0DpCZDLkbjn6bvLTx2TPWuU5sDx2Mco/irV9FAnarYUZzg4+Uo8zHF2
         j+3EX3MmI3/slB5Lb1dHJSibXoy4SKhcfufm4xX/kifZ0REJDOpHFBnfxfX/YAGu8S
         sA5E01HBy+DkusEMdvi2dezb0KVvGAJxQN1NlMraKd/tBMIjaXB8KbHxUEI+1zRDB9
         dBgAGIFlRHo7OMjUCKIAZTrk1eBxRUIteSwfRmH4k2PQWzS64Go4gk4XCl/kqdtX29
         bnhtOoGi9ArUg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/17] net/mlx5e: TC, Hold sample_attr on stack instead of pointer
Date:   Mon, 10 Jan 2022 17:43:28 -0800
Message-Id: <20220111014335.178121-11-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

In later commit we are going to instantiate multiple attr instances
for flow instead of single attr.
Parsing TC sample allocates a new memory but there is no symmetric
cleanup in the infrastructure.
To avoid asymmetric alloc/free use sample_attr as part of the flow attr
and not allocated and held as a pointer.
This will avoid a cleanup leak when sample action is not on the first
attr.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c |  7 +------
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h        |  2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |  6 +++---
 5 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
index 0d71e97f4eb9..8f261204fdb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
@@ -28,11 +28,7 @@ tc_act_parse_sample(struct mlx5e_tc_act_parse_state *parse_state,
 		    struct mlx5e_priv *priv,
 		    struct mlx5_flow_attr *attr)
 {
-	struct mlx5e_sample_attr *sample_attr;
-
-	sample_attr = kzalloc(sizeof(*attr->sample_attr), GFP_KERNEL);
-	if (!sample_attr)
-		return -ENOMEM;
+	struct mlx5e_sample_attr *sample_attr = &attr->sample_attr;
 
 	sample_attr->rate = act->sample.rate;
 	sample_attr->group_num = act->sample.psample_group->group_num;
@@ -40,7 +36,6 @@ tc_act_parse_sample(struct mlx5e_tc_act_parse_state *parse_state,
 	if (act->sample.truncate)
 		sample_attr->trunc_size = act->sample.trunc_size;
 
-	attr->sample_attr = sample_attr;
 	flow_flag_set(parse_state->flow, SAMPLE);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index ff4b4f8a5a9d..0faaf9a4b531 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -513,7 +513,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	sample_flow = kzalloc(sizeof(*sample_flow), GFP_KERNEL);
 	if (!sample_flow)
 		return ERR_PTR(-ENOMEM);
-	sample_attr = attr->sample_attr;
+	sample_attr = &attr->sample_attr;
 	sample_attr->sample_flow = sample_flow;
 
 	/* For NICs with reg_c_preserve support or decap action, use
@@ -546,6 +546,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 		err = PTR_ERR(sample_flow->sampler);
 		goto err_sampler;
 	}
+	sample_attr->sampler_id = sample_flow->sampler->sampler_id;
 
 	/* Create an id mapping reg_c0 value to sample object. */
 	restore_obj.type = MLX5_MAPPED_OBJ_SAMPLE;
@@ -585,8 +586,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	pre_attr->outer_match_level = attr->outer_match_level;
 	pre_attr->chain = attr->chain;
 	pre_attr->prio = attr->prio;
-	pre_attr->sample_attr = attr->sample_attr;
-	sample_attr->sampler_id = sample_flow->sampler->sampler_id;
+	pre_attr->sample_attr = *sample_attr;
 	pre_esw_attr = pre_attr->esw_attr;
 	pre_esw_attr->in_mdev = esw_attr->in_mdev;
 	pre_esw_attr->in_rep = esw_attr->in_rep;
@@ -633,11 +633,11 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 	 * will hit fw syndromes.
 	 */
 	esw = tc_psample->esw;
-	sample_flow = attr->sample_attr->sample_flow;
+	sample_flow = attr->sample_attr.sample_flow;
 	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, sample_flow->pre_attr);
 
 	sample_restore_put(tc_psample, sample_flow->restore);
-	mapping_remove(esw->offloads.reg_c0_obj_pool, attr->sample_attr->restore_obj_id);
+	mapping_remove(esw->offloads.reg_c0_obj_pool, attr->sample_attr.restore_obj_id);
 	sampler_put(tc_psample, sample_flow->sampler);
 	if (sample_flow->post_act_handle)
 		mlx5e_tc_post_act_del(tc_psample->post_act, sample_flow->post_act_handle);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9201ba8fa509..e3195f6e67c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1682,7 +1682,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
 
-	kfree(attr->sample_attr);
 	kvfree(attr->esw_attr->rx_tun_attr);
 	kvfree(attr->parse_attr);
 	kfree(flow->attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 0da5ea44f607..c68730250fb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -71,7 +71,7 @@ struct mlx5_flow_attr {
 	struct mlx5_fc *counter;
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_ct_attr ct_attr;
-	struct mlx5e_sample_attr *sample_attr;
+	struct mlx5e_sample_attr sample_attr;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	u32 chain;
 	u16 prio;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9a7b25692505..8642e041d2e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -201,12 +201,12 @@ esw_cleanup_decap_indir(struct mlx5_eswitch *esw,
 static int
 esw_setup_sampler_dest(struct mlx5_flow_destination *dest,
 		       struct mlx5_flow_act *flow_act,
-		       struct mlx5_flow_attr *attr,
+		       u32 sampler_id,
 		       int i)
 {
 	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER;
-	dest[i].sampler_id = attr->sample_attr->sampler_id;
+	dest[i].sampler_id = sampler_id;
 
 	return 0;
 }
@@ -466,7 +466,7 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 		attr->flags |= MLX5_ESW_ATTR_FLAG_SRC_REWRITE;
 
 	if (attr->flags & MLX5_ESW_ATTR_FLAG_SAMPLE) {
-		esw_setup_sampler_dest(dest, flow_act, attr, *i);
+		esw_setup_sampler_dest(dest, flow_act, attr->sample_attr.sampler_id, *i);
 		(*i)++;
 	} else if (attr->dest_ft) {
 		esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
-- 
2.34.1

