Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76548A542
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346291AbiAKBoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346234AbiAKBny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFE0C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 17:43:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1E8EB81863
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5789CC36AF2;
        Tue, 11 Jan 2022 01:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865431;
        bh=InZREv0FTC4oO2XS+AP2TAV+pH32ACp+QM00ezaVviE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPa7uEtorhDyrN/7IMMjtFPK8giIAyorZI0+s2H9VvF4h3M/JbE2oW/s2D/g1et9q
         LxhK2QMbq1QwFWRWx0f+UlWyoyp5UxyQzNlj6CzD6LmjSLml0AC30vkBh0wFYUGNE+
         q4j3dxbffWo/F/8Ifs5GW1lfJ8M9rXr59GH7jaw7d34yuv7uzfyHi6eW6pSSLbR+ad
         oYrhF7sbxIbHjk4knQ89ao7cdpyXq9WJoxhFpNEW+fqhxbe2Yffcr8IS0+VMQCn29K
         rzrti3ayfkPSDbYo2lQx09jznuLnnmORL76Az0o0XNkGtR0zVodtZzpkXgpuXno6St
         MUwy1PRv5Qwmw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/17] net/mlx5e: Refactor eswitch attr flags to just attr flags
Date:   Mon, 10 Jan 2022 17:43:30 -0800
Message-Id: <20220111014335.178121-13-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The flags are flow attrs and not esw specific attr flags.
Refactor to remove the esw prefix and move from eswitch.h
to en_tc.h where struct mlx5_flow_attr exists.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/accept.c     |  2 +-
 .../mellanox/mlx5/core/en/tc/act/trap.c       |  2 +-
 .../mellanox/mlx5/core/en/tc/sample.c         |  4 +--
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  8 +++---
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   | 16 ++++++++++++
 .../mellanox/mlx5/core/esw/indir_table.c      |  2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 16 ------------
 .../mellanox/mlx5/core/eswitch_offloads.c     | 26 +++++++++----------
 .../mlx5/core/eswitch_offloads_termtbl.c      |  2 +-
 10 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
index 84c1e8719d34..2b53738938a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
@@ -21,7 +21,7 @@ tc_act_parse_accept(struct mlx5e_tc_act_parse_state *parse_state,
 {
 	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			MLX5_FLOW_CONTEXT_ACTION_COUNT;
-	attr->flags |= MLX5_ESW_ATTR_FLAG_ACCEPT;
+	attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
index 72811e0430c1..9ea293fdc434 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
@@ -28,7 +28,7 @@ tc_act_parse_trap(struct mlx5e_tc_act_parse_state *parse_state,
 {
 	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			MLX5_FLOW_CONTEXT_ACTION_COUNT;
-	attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+	attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 0faaf9a4b531..7b60926f4d77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -403,7 +403,7 @@ add_post_rule(struct mlx5_eswitch *esw, struct mlx5e_sample_flow *sample_flow,
 	post_attr->chain = 0;
 	post_attr->prio = 0;
 	post_attr->ft = default_tbl;
-	post_attr->flags = MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
+	post_attr->flags = MLX5_ATTR_FLAG_NO_IN_PORT;
 
 	/* When offloading sample and encap action, if there is no valid
 	 * neigh data struct, a slow path rule is offloaded first. Source
@@ -581,7 +581,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	if (tunnel_id)
 		pre_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
 	pre_attr->modify_hdr = sample_flow->restore->modify_hdr;
-	pre_attr->flags = MLX5_ESW_ATTR_FLAG_SAMPLE;
+	pre_attr->flags = MLX5_ATTR_FLAG_SAMPLE;
 	pre_attr->inner_match_level = attr->inner_match_level;
 	pre_attr->outer_match_level = attr->outer_match_level;
 	pre_attr->chain = attr->chain;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 090e02548a75..b7e8f20bd9e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -809,7 +809,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	attr->ft = nat ? ct_priv->ct_nat : ct_priv->ct;
 	attr->outer_match_level = MLX5_MATCH_L4;
 	attr->counter = entry->counter->counter;
-	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
+	attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
 	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB)
 		attr->esw_attr->in_mdev = priv->mdev;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a1007af89ddc..d37a5f752b1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1157,7 +1157,7 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
 	struct mlx5_flow_handle *rule;
 
-	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
+	if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH)
 		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 
 	if (flow_flag_test(flow, CT)) {
@@ -1196,7 +1196,7 @@ void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 {
 	flow_flag_clear(flow, OFFLOADED);
 
-	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
+	if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH)
 		goto offload_rule_0;
 
 	if (attr->esw_attr->split_count)
@@ -1226,7 +1226,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 	memcpy(slow_attr, flow->attr, ESW_FLOW_ATTR_SZ);
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	slow_attr->esw_attr->split_count = 0;
-	slow_attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+	slow_attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
 
 	rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, slow_attr);
 	if (!IS_ERR(rule))
@@ -1251,7 +1251,7 @@ void mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 	memcpy(slow_attr, flow->attr, ESW_FLOW_ATTR_SZ);
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	slow_attr->esw_attr->split_count = 0;
-	slow_attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
+	slow_attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
 	mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
 	flow_flag_clear(flow, SLOW);
 	kfree(slow_attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index c68730250fb3..277515916526 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -89,6 +89,22 @@ struct mlx5_flow_attr {
 	};
 };
 
+enum {
+	MLX5_ATTR_FLAG_VLAN_HANDLED  = BIT(0),
+	MLX5_ATTR_FLAG_SLOW_PATH     = BIT(1),
+	MLX5_ATTR_FLAG_NO_IN_PORT    = BIT(2),
+	MLX5_ATTR_FLAG_SRC_REWRITE   = BIT(3),
+	MLX5_ATTR_FLAG_SAMPLE        = BIT(4),
+	MLX5_ATTR_FLAG_ACCEPT        = BIT(5),
+};
+
+/* Returns true if any of the flags that require skipping further TC/NF processing are set. */
+static inline bool
+mlx5e_tc_attr_flags_skip(u32 attr_flags)
+{
+	return attr_flags & (MLX5_ATTR_FLAG_SLOW_PATH | MLX5_ATTR_FLAG_ACCEPT);
+}
+
 struct mlx5_rx_tun_attr {
 	u16 decap_vport;
 	union {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index c275fe028b6d..0abef71cb839 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -86,7 +86,7 @@ mlx5_esw_indir_table_needed(struct mlx5_eswitch *esw,
 		mlx5_eswitch_is_vf_vport(esw, vport_num) &&
 		esw->dev == dest_mdev &&
 		attr->ip_version &&
-		attr->flags & MLX5_ESW_ATTR_FLAG_SRC_REWRITE;
+		attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE;
 }
 
 u16
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ead5e8acc8be..44321cdfe928 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -448,22 +448,6 @@ enum {
 	MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE  = BIT(2),
 };
 
-enum {
-	MLX5_ESW_ATTR_FLAG_VLAN_HANDLED  = BIT(0),
-	MLX5_ESW_ATTR_FLAG_SLOW_PATH     = BIT(1),
-	MLX5_ESW_ATTR_FLAG_NO_IN_PORT    = BIT(2),
-	MLX5_ESW_ATTR_FLAG_SRC_REWRITE   = BIT(3),
-	MLX5_ESW_ATTR_FLAG_SAMPLE        = BIT(4),
-	MLX5_ESW_ATTR_FLAG_ACCEPT        = BIT(5),
-};
-
-/* Returns true if any of the flags that require skipping further TC/NF processing are set. */
-static inline bool
-mlx5_esw_attr_flags_skip(u32 attr_flags)
-{
-	return attr_flags & (MLX5_ESW_ATTR_FLAG_SLOW_PATH | MLX5_ESW_ATTR_FLAG_ACCEPT);
-}
-
 struct mlx5_esw_flow_attr {
 	struct mlx5_eswitch_rep *in_rep;
 	struct mlx5_core_dev	*in_mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8642e041d2e3..133f5cf23c3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -180,7 +180,7 @@ esw_setup_decap_indir(struct mlx5_eswitch *esw,
 {
 	struct mlx5_flow_table *ft;
 
-	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SRC_REWRITE))
+	if (!(attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE))
 		return -EOPNOTSUPP;
 
 	ft = mlx5_esw_indir_table_get(esw, attr, spec,
@@ -297,7 +297,7 @@ esw_setup_chain_src_port_rewrite(struct mlx5_flow_destination *dest,
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	int err;
 
-	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SRC_REWRITE))
+	if (!(attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE))
 		return -EOPNOTSUPP;
 
 	/* flow steering cannot handle more than one dest with the same ft
@@ -364,7 +364,7 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	int j, err;
 
-	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SRC_REWRITE))
+	if (!(attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE))
 		return -EOPNOTSUPP;
 
 	for (j = esw_attr->split_count; j < esw_attr->out_count; j++, (*i)++) {
@@ -463,15 +463,15 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 
 	if (!mlx5_eswitch_termtbl_required(esw, attr, flow_act, spec) &&
 	    esw_src_port_rewrite_supported(esw))
-		attr->flags |= MLX5_ESW_ATTR_FLAG_SRC_REWRITE;
+		attr->flags |= MLX5_ATTR_FLAG_SRC_REWRITE;
 
-	if (attr->flags & MLX5_ESW_ATTR_FLAG_SAMPLE) {
+	if (attr->flags & MLX5_ATTR_FLAG_SAMPLE) {
 		esw_setup_sampler_dest(dest, flow_act, attr->sample_attr.sampler_id, *i);
 		(*i)++;
 	} else if (attr->dest_ft) {
 		esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
 		(*i)++;
-	} else if (mlx5_esw_attr_flags_skip(attr->flags)) {
+	} else if (mlx5e_tc_attr_flags_skip(attr->flags)) {
 		esw_setup_slow_path_dest(dest, flow_act, chains, *i);
 		(*i)++;
 	} else if (attr->dest_chain) {
@@ -498,7 +498,7 @@ esw_cleanup_dests(struct mlx5_eswitch *esw,
 
 	if (attr->dest_ft) {
 		esw_cleanup_decap_indir(esw, attr);
-	} else if (!mlx5_esw_attr_flags_skip(attr->flags)) {
+	} else if (!mlx5e_tc_attr_flags_skip(attr->flags)) {
 		if (attr->dest_chain)
 			esw_cleanup_chain_dest(chains, attr->dest_chain, 1, 0);
 		else if (esw_is_indir_table(esw, attr))
@@ -589,7 +589,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		else
 			fdb = attr->ft;
 
-		if (!(attr->flags & MLX5_ESW_ATTR_FLAG_NO_IN_PORT))
+		if (!(attr->flags & MLX5_ATTR_FLAG_NO_IN_PORT))
 			mlx5_eswitch_set_rule_source_port(esw, spec, attr,
 							  esw_attr->in_mdev->priv.eswitch,
 							  esw_attr->in_rep->vport);
@@ -721,7 +721,7 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 
 	mlx5_del_flow_rules(rule);
 
-	if (!mlx5_esw_attr_flags_skip(attr->flags)) {
+	if (!mlx5e_tc_attr_flags_skip(attr->flags)) {
 		/* unref the term table */
 		for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
 			if (esw_attr->dests[i].termtbl)
@@ -863,7 +863,7 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 	if (err)
 		goto unlock;
 
-	attr->flags &= ~MLX5_ESW_ATTR_FLAG_VLAN_HANDLED;
+	attr->flags &= ~MLX5_ATTR_FLAG_VLAN_HANDLED;
 
 	vport = esw_vlan_action_get_vport(esw_attr, push, pop);
 
@@ -871,7 +871,7 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 		/* tracks VF --> wire rules without vlan push action */
 		if (esw_attr->dests[0].rep->vport == MLX5_VPORT_UPLINK) {
 			vport->vlan_refcount++;
-			attr->flags |= MLX5_ESW_ATTR_FLAG_VLAN_HANDLED;
+			attr->flags |= MLX5_ATTR_FLAG_VLAN_HANDLED;
 		}
 
 		goto unlock;
@@ -902,7 +902,7 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 	}
 out:
 	if (!err)
-		attr->flags |= MLX5_ESW_ATTR_FLAG_VLAN_HANDLED;
+		attr->flags |= MLX5_ATTR_FLAG_VLAN_HANDLED;
 unlock:
 	mutex_unlock(&esw->state_lock);
 	return err;
@@ -921,7 +921,7 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 	if (mlx5_eswitch_vlan_actions_supported(esw->dev, 1))
 		return 0;
 
-	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_VLAN_HANDLED))
+	if (!(attr->flags & MLX5_ATTR_FLAG_VLAN_HANDLED))
 		return 0;
 
 	push = !!(attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 182306bbefaa..4b354aed784a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -219,7 +219,7 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table) ||
 	    !MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level) ||
-	    mlx5_esw_attr_flags_skip(attr->flags) ||
+	    mlx5e_tc_attr_flags_skip(attr->flags) ||
 	    (!mlx5_eswitch_offload_is_uplink_port(esw, spec) && !esw_attr->int_port))
 		return false;
 
-- 
2.34.1

