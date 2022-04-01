Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705FD4EEFAD
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347172AbiDAO3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347078AbiDAO2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:28:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A543428256B;
        Fri,  1 Apr 2022 07:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3568061C3F;
        Fri,  1 Apr 2022 14:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4FCC2BBE4;
        Fri,  1 Apr 2022 14:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823215;
        bh=6oDoP0Q28YCI0QRjMe8GAq0uKPQEXJq/i8fibSIytJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CoGPGaIG5UHK99kKbNxYFBIA76FzkP37jUG9I9LQRXfTf+oqFVT9HPFtCP5Lppn/X
         NOm7j92kxDkQICUmZF7Bu5IRpW3IeKOegj4+kMYXHVjfizIcS89ykIwayPy1KqOQfq
         uCAWPtwKVU7Jph4/tPRdeV3/SpLE2cmvsXiAVd1sgZSsuzC8heExvrjcYO9v4lYN+y
         p9bO8c059e+KwIatWO69Dsp7xCKfp7CH1ekiaOB0K6PZHuTec2h+B+fgrSDsSYn+P+
         rkgmfbTPIlPWGL0WBouPQ16g9oBo9ooVXBQJ1k9eUTHBFjncD149FvY3EN36x/aRL/
         v2mwAXgbdYEMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roi Dayan <roid@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, cmi@nvidia.com,
        mbloch@nvidia.com, paulb@nvidia.com, nathan@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 020/149] net/mlx5e: TC, Hold sample_attr on stack instead of pointer
Date:   Fri,  1 Apr 2022 10:23:27 -0400
Message-Id: <20220401142536.1948161-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit eeed226ed110ed40598e60e29b66643012277be7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c |  7 +------
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h        |  2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |  6 +++---
 5 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
index 6699bdf5cf01..b895c378cfaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
@@ -27,11 +27,7 @@ tc_act_parse_sample(struct mlx5e_tc_act_parse_state *parse_state,
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
@@ -39,7 +35,6 @@ tc_act_parse_sample(struct mlx5e_tc_act_parse_state *parse_state,
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
index b27532a9301e..7e5c00349ccf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1634,7 +1634,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
 
-	kfree(attr->sample_attr);
 	kvfree(attr->esw_attr->rx_tun_attr);
 	kvfree(attr->parse_attr);
 	kfree(flow->attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 5ffae9b13066..2f09e34db9ff 100644
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
index cfcd72bad9af..e7e7b4b0dcdb 100644
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

