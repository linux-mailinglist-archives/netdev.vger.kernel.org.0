Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71E967272B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjARShC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjARSgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECE459B78
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 865EFB81EA0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163BEC433EF;
        Wed, 18 Jan 2023 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066980;
        bh=rdMsYVjhpZPLWRcZ+1xrG2Cb9LHesnu+ZKq47OXI5oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMixyU8dxzPptPgPLYUKigsxLpUdunoe1Af0kN/abaBErivwXcUvgdBNgBGRB++xY
         jZFNNJuXUSRahcy8t6dlB9MUvd4s0t90lOtrSzlgNWEOcj3skPnXlsit+7H61ixzZb
         pQp1ubT23v6xGDWAhfVoLsae3pCVkkLYw5wd9JUFzTuNlSS49I1kAhMxEhYC3Ax9C1
         1emP6HOETAGelckukrrsI0+SiLvqPMDwr1XiIpZ5CrTdDFd4EiWkE6sqx3eLBof8Lw
         7nquJokVCbWbF2B+4kRgWRUTbHoM6/oTj1fsToxRZSPmgP46VU9ltAd4ldoCzP86k9
         tuwCrVMw4wk9g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Support Geneve and GRE with VF tunnel offload
Date:   Wed, 18 Jan 2023 10:36:00 -0800
Message-Id: <20230118183602.124323-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

Today VF tunnel offload (tunnel endpoint is on VF) is implemented
by indirect table which use rules that match on VXLAN VNI to
recirculated to root table, this limit the support for only
VXLAN tunnels.

This patch change indirect table to use one single match all rule
to recirculated to root table which is added when any tunnel decap
rule is added with tunnel endpoint is VF. This allow support of
Geneve and GRE with this configuration.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |   2 -
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   2 -
 .../mellanox/mlx5/core/esw/indir_table.c      | 203 +++---------------
 .../mellanox/mlx5/core/esw/indir_table.h      |   4 -
 .../mellanox/mlx5/core/eswitch_offloads.c     |  23 +-
 6 files changed, 48 insertions(+), 195 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index e6f64d890fb3..83bb0811e774 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -745,8 +745,6 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 		if (err)
 			goto out;
 
-		esw_attr->rx_tun_attr->vni = MLX5_GET(fte_match_param, spec->match_value,
-						      misc_parameters.vxlan_vni);
 		esw_attr->rx_tun_attr->decap_vport = vport_num;
 	} else if (netif_is_ovs_master(attr.route_dev) && mlx5e_tc_int_port_supported(esw)) {
 		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c978f4b12131..c8377b4c8c8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2595,13 +2595,13 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		err = mlx5e_tc_set_attr_rx_tun(flow, spec);
 		if (err)
 			return err;
-	} else if (tunnel && tunnel->tunnel_type == MLX5E_TC_TUNNEL_TYPE_VXLAN) {
+	} else if (tunnel) {
 		struct mlx5_flow_spec *tmp_spec;
 
 		tmp_spec = kvzalloc(sizeof(*tmp_spec), GFP_KERNEL);
 		if (!tmp_spec) {
-			NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory for vxlan tmp spec");
-			netdev_warn(priv->netdev, "Failed to allocate memory for vxlan tmp spec");
+			NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory for tunnel tmp spec");
+			netdev_warn(priv->netdev, "Failed to allocate memory for tunnel tmp spec");
 			return -ENOMEM;
 		}
 		memcpy(tmp_spec, spec, sizeof(*tmp_spec));
@@ -4623,9 +4623,6 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
-	/* always set IP version for indirect table handling */
-	flow->attr->ip_version = mlx5e_tc_get_ip_version(&parse_attr->spec, true);
-
 	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack);
 	if (err)
 		goto err_free;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 66e8d9d89082..ce516dc7f3fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -84,7 +84,6 @@ struct mlx5_flow_attr {
 	struct mlx5_flow_table *dest_ft;
 	u8 inner_match_level;
 	u8 outer_match_level;
-	u8 ip_version;
 	u8 tun_ip_version;
 	int tunnel_id; /* mapped tunnel id */
 	u32 flags;
@@ -136,7 +135,6 @@ struct mlx5_rx_tun_attr {
 		__be32 v4;
 		struct in6_addr v6;
 	} dst_ip; /* Valid if decap_vport is not zero */
-	u32 vni;
 };
 
 #define MLX5E_TC_TABLE_CHAIN_TAG_BITS 16
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index c9a91158e99c..8a94870c5b43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -16,18 +16,12 @@
 #include "lib/fs_chains.h"
 #include "en/mod_hdr.h"
 
-#define MLX5_ESW_INDIR_TABLE_SIZE 128
-#define MLX5_ESW_INDIR_TABLE_RECIRC_IDX_MAX (MLX5_ESW_INDIR_TABLE_SIZE - 2)
+#define MLX5_ESW_INDIR_TABLE_SIZE 2
+#define MLX5_ESW_INDIR_TABLE_RECIRC_IDX (MLX5_ESW_INDIR_TABLE_SIZE - 2)
 #define MLX5_ESW_INDIR_TABLE_FWD_IDX (MLX5_ESW_INDIR_TABLE_SIZE - 1)
 
 struct mlx5_esw_indir_table_rule {
-	struct list_head list;
 	struct mlx5_flow_handle *handle;
-	union {
-		__be32 v4;
-		struct in6_addr v6;
-	} dst_ip;
-	u32 vni;
 	struct mlx5_modify_hdr *mh;
 	refcount_t refcnt;
 };
@@ -38,12 +32,10 @@ struct mlx5_esw_indir_table_entry {
 	struct mlx5_flow_group *recirc_grp;
 	struct mlx5_flow_group *fwd_grp;
 	struct mlx5_flow_handle *fwd_rule;
-	struct list_head recirc_rules;
-	int recirc_cnt;
+	struct mlx5_esw_indir_table_rule *recirc_rule;
 	int fwd_ref;
 
 	u16 vport;
-	u8 ip_version;
 };
 
 struct mlx5_esw_indir_table {
@@ -89,7 +81,6 @@ mlx5_esw_indir_table_needed(struct mlx5_eswitch *esw,
 	return esw_attr->in_rep->vport == MLX5_VPORT_UPLINK &&
 		vf_sf_vport &&
 		esw->dev == dest_mdev &&
-		attr->ip_version &&
 		attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE;
 }
 
@@ -101,27 +92,8 @@ mlx5_esw_indir_table_decap_vport(struct mlx5_flow_attr *attr)
 	return esw_attr->rx_tun_attr ? esw_attr->rx_tun_attr->decap_vport : 0;
 }
 
-static struct mlx5_esw_indir_table_rule *
-mlx5_esw_indir_table_rule_lookup(struct mlx5_esw_indir_table_entry *e,
-				 struct mlx5_esw_flow_attr *attr)
-{
-	struct mlx5_esw_indir_table_rule *rule;
-
-	list_for_each_entry(rule, &e->recirc_rules, list)
-		if (rule->vni == attr->rx_tun_attr->vni &&
-		    !memcmp(&rule->dst_ip, &attr->rx_tun_attr->dst_ip,
-			    sizeof(attr->rx_tun_attr->dst_ip)))
-			goto found;
-	return NULL;
-
-found:
-	refcount_inc(&rule->refcnt);
-	return rule;
-}
-
 static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 					 struct mlx5_flow_attr *attr,
-					 struct mlx5_flow_spec *spec,
 					 struct mlx5_esw_indir_table_entry *e)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
@@ -130,73 +102,18 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_esw_indir_table_rule *rule;
 	struct mlx5_flow_act flow_act = {};
-	struct mlx5_flow_spec *rule_spec;
 	struct mlx5_flow_handle *handle;
 	int err = 0;
 	u32 data;
 
-	rule = mlx5_esw_indir_table_rule_lookup(e, esw_attr);
-	if (rule)
+	if (e->recirc_rule) {
+		refcount_inc(&e->recirc_rule->refcnt);
 		return 0;
-
-	if (e->recirc_cnt == MLX5_ESW_INDIR_TABLE_RECIRC_IDX_MAX)
-		return -EINVAL;
-
-	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
-	if (!rule_spec)
-		return -ENOMEM;
-
-	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
-	if (!rule) {
-		err = -ENOMEM;
-		goto out;
 	}
 
-	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS |
-					   MLX5_MATCH_MISC_PARAMETERS |
-					   MLX5_MATCH_MISC_PARAMETERS_2;
-	if (MLX5_CAP_FLOWTABLE_NIC_RX(esw->dev, ft_field_support.outer_ip_version)) {
-		MLX5_SET(fte_match_param, rule_spec->match_criteria,
-			 outer_headers.ip_version, 0xf);
-		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.ip_version,
-			 attr->ip_version);
-	} else if (attr->ip_version) {
-		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
-				 outer_headers.ethertype);
-		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.ethertype,
-			 (attr->ip_version == 4 ? ETH_P_IP : ETH_P_IPV6));
-	} else {
-		err = -EOPNOTSUPP;
-		goto err_ethertype;
-	}
-
-	if (attr->ip_version == 4) {
-		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
-				 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
-		MLX5_SET(fte_match_param, rule_spec->match_value,
-			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(esw_attr->rx_tun_attr->dst_ip.v4));
-	} else if (attr->ip_version == 6) {
-		int len = sizeof(struct in6_addr);
-
-		memset(MLX5_ADDR_OF(fte_match_param, rule_spec->match_criteria,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       0xff, len);
-		memcpy(MLX5_ADDR_OF(fte_match_param, rule_spec->match_value,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &esw_attr->rx_tun_attr->dst_ip.v6, len);
-	}
-
-	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
-			 misc_parameters.vxlan_vni);
-	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters.vxlan_vni,
-		 MLX5_GET(fte_match_param, spec->match_value, misc_parameters.vxlan_vni));
-
-	MLX5_SET(fte_match_param, rule_spec->match_criteria,
-		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
-	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
-		 mlx5_eswitch_get_vport_metadata_for_match(esw_attr->in_mdev->priv.eswitch,
-							   MLX5_VPORT_UPLINK));
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return -ENOMEM;
 
 	/* Modify flow source to recirculate packet */
 	data = mlx5_eswitch_get_vport_metadata_for_set(esw, esw_attr->rx_tun_attr->decap_vport);
@@ -219,13 +136,14 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	flow_act.flags = FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
+	flow_act.fg = e->recirc_grp;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = mlx5_chains_get_table(chains, 0, 1, 0);
 	if (IS_ERR(dest.ft)) {
 		err = PTR_ERR(dest.ft);
 		goto err_table;
 	}
-	handle = mlx5_add_flow_rules(e->ft, rule_spec, &flow_act, &dest, 1);
+	handle = mlx5_add_flow_rules(e->ft, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		goto err_handle;
@@ -233,14 +151,10 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 
 	mlx5e_mod_hdr_dealloc(&mod_acts);
 	rule->handle = handle;
-	rule->vni = esw_attr->rx_tun_attr->vni;
 	rule->mh = flow_act.modify_hdr;
-	memcpy(&rule->dst_ip, &esw_attr->rx_tun_attr->dst_ip,
-	       sizeof(esw_attr->rx_tun_attr->dst_ip));
 	refcount_set(&rule->refcnt, 1);
-	list_add(&rule->list, &e->recirc_rules);
-	e->recirc_cnt++;
-	goto out;
+	e->recirc_rule = rule;
+	return 0;
 
 err_handle:
 	mlx5_chains_put_table(chains, 0, 1, 0);
@@ -250,89 +164,44 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 err_mod_hdr_regc1:
 	mlx5e_mod_hdr_dealloc(&mod_acts);
 err_mod_hdr_regc0:
-err_ethertype:
 	kfree(rule);
-out:
-	kvfree(rule_spec);
 	return err;
 }
 
 static void mlx5_esw_indir_table_rule_put(struct mlx5_eswitch *esw,
-					  struct mlx5_flow_attr *attr,
 					  struct mlx5_esw_indir_table_entry *e)
 {
-	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct mlx5_esw_indir_table_rule *rule = e->recirc_rule;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
-	struct mlx5_esw_indir_table_rule *rule;
 
-	list_for_each_entry(rule, &e->recirc_rules, list)
-		if (rule->vni == esw_attr->rx_tun_attr->vni &&
-		    !memcmp(&rule->dst_ip, &esw_attr->rx_tun_attr->dst_ip,
-			    sizeof(esw_attr->rx_tun_attr->dst_ip)))
-			goto found;
-
-	return;
+	if (!rule)
+		return;
 
-found:
 	if (!refcount_dec_and_test(&rule->refcnt))
 		return;
 
 	mlx5_del_flow_rules(rule->handle);
 	mlx5_chains_put_table(chains, 0, 1, 0);
 	mlx5_modify_header_dealloc(esw->dev, rule->mh);
-	list_del(&rule->list);
 	kfree(rule);
-	e->recirc_cnt--;
+	e->recirc_rule = NULL;
 }
 
-static int mlx5_create_indir_recirc_group(struct mlx5_eswitch *esw,
-					  struct mlx5_flow_attr *attr,
-					  struct mlx5_flow_spec *spec,
-					  struct mlx5_esw_indir_table_entry *e)
+static int mlx5_create_indir_recirc_group(struct mlx5_esw_indir_table_entry *e)
 {
 	int err = 0, inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	u32 *in, *match;
+	u32 *in;
 
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
-	MLX5_SET(create_flow_group_in, in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS |
-		 MLX5_MATCH_MISC_PARAMETERS | MLX5_MATCH_MISC_PARAMETERS_2);
-	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
-
-	if (MLX5_CAP_FLOWTABLE_NIC_RX(esw->dev, ft_field_support.outer_ip_version))
-		MLX5_SET(fte_match_param, match, outer_headers.ip_version, 0xf);
-	else
-		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.ethertype);
-
-	if (attr->ip_version == 4) {
-		MLX5_SET_TO_ONES(fte_match_param, match,
-				 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
-	} else if (attr->ip_version == 6) {
-		memset(MLX5_ADDR_OF(fte_match_param, match,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       0xff, sizeof(struct in6_addr));
-	} else {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	MLX5_SET_TO_ONES(fte_match_param, match, misc_parameters.vxlan_vni);
-	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
-		 mlx5_eswitch_get_vport_metadata_mask());
 	MLX5_SET(create_flow_group_in, in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_ESW_INDIR_TABLE_RECIRC_IDX_MAX);
+	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_ESW_INDIR_TABLE_RECIRC_IDX);
 	e->recirc_grp = mlx5_create_flow_group(e->ft, in);
-	if (IS_ERR(e->recirc_grp)) {
+	if (IS_ERR(e->recirc_grp))
 		err = PTR_ERR(e->recirc_grp);
-		goto out;
-	}
 
-	INIT_LIST_HEAD(&e->recirc_rules);
-	e->recirc_cnt = 0;
-
-out:
 	kvfree(in);
 	return err;
 }
@@ -366,6 +235,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 	}
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	flow_act.fg = e->fwd_grp;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	dest.vport.num = e->vport;
 	dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
@@ -384,7 +254,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 
 static struct mlx5_esw_indir_table_entry *
 mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr,
-				  struct mlx5_flow_spec *spec, u16 vport, bool decap)
+				  u16 vport, bool decap)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_namespace *root_ns;
@@ -412,15 +282,14 @@ mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_att
 	}
 	e->ft = ft;
 	e->vport = vport;
-	e->ip_version = attr->ip_version;
 	e->fwd_ref = !decap;
 
-	err = mlx5_create_indir_recirc_group(esw, attr, spec, e);
+	err = mlx5_create_indir_recirc_group(e);
 	if (err)
 		goto recirc_grp_err;
 
 	if (decap) {
-		err = mlx5_esw_indir_table_rule_get(esw, attr, spec, e);
+		err = mlx5_esw_indir_table_rule_get(esw, attr, e);
 		if (err)
 			goto recirc_rule_err;
 	}
@@ -430,13 +299,13 @@ mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_att
 		goto fwd_grp_err;
 
 	hash_add(esw->fdb_table.offloads.indir->table, &e->hlist,
-		 vport << 16 | attr->ip_version);
+		 vport << 16);
 
 	return e;
 
 fwd_grp_err:
 	if (decap)
-		mlx5_esw_indir_table_rule_put(esw, attr, e);
+		mlx5_esw_indir_table_rule_put(esw, e);
 recirc_rule_err:
 	mlx5_destroy_flow_group(e->recirc_grp);
 recirc_grp_err:
@@ -447,13 +316,13 @@ mlx5_esw_indir_table_entry_create(struct mlx5_eswitch *esw, struct mlx5_flow_att
 }
 
 static struct mlx5_esw_indir_table_entry *
-mlx5_esw_indir_table_entry_lookup(struct mlx5_eswitch *esw, u16 vport, u8 ip_version)
+mlx5_esw_indir_table_entry_lookup(struct mlx5_eswitch *esw, u16 vport)
 {
 	struct mlx5_esw_indir_table_entry *e;
-	u32 key = vport << 16 | ip_version;
+	u32 key = vport << 16;
 
 	hash_for_each_possible(esw->fdb_table.offloads.indir->table, e, hlist, key)
-		if (e->vport == vport && e->ip_version == ip_version)
+		if (e->vport == vport)
 			return e;
 
 	return NULL;
@@ -461,24 +330,23 @@ mlx5_esw_indir_table_entry_lookup(struct mlx5_eswitch *esw, u16 vport, u8 ip_ver
 
 struct mlx5_flow_table *mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 						 struct mlx5_flow_attr *attr,
-						 struct mlx5_flow_spec *spec,
 						 u16 vport, bool decap)
 {
 	struct mlx5_esw_indir_table_entry *e;
 	int err;
 
 	mutex_lock(&esw->fdb_table.offloads.indir->lock);
-	e = mlx5_esw_indir_table_entry_lookup(esw, vport, attr->ip_version);
+	e = mlx5_esw_indir_table_entry_lookup(esw, vport);
 	if (e) {
 		if (!decap) {
 			e->fwd_ref++;
 		} else {
-			err = mlx5_esw_indir_table_rule_get(esw, attr, spec, e);
+			err = mlx5_esw_indir_table_rule_get(esw, attr, e);
 			if (err)
 				goto out_err;
 		}
 	} else {
-		e = mlx5_esw_indir_table_entry_create(esw, attr, spec, vport, decap);
+		e = mlx5_esw_indir_table_entry_create(esw, attr, vport, decap);
 		if (IS_ERR(e)) {
 			err = PTR_ERR(e);
 			esw_warn(esw->dev, "Failed to create indirection table, err %d.\n", err);
@@ -494,22 +362,21 @@ struct mlx5_flow_table *mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 }
 
 void mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
-			      struct mlx5_flow_attr *attr,
 			      u16 vport, bool decap)
 {
 	struct mlx5_esw_indir_table_entry *e;
 
 	mutex_lock(&esw->fdb_table.offloads.indir->lock);
-	e = mlx5_esw_indir_table_entry_lookup(esw, vport, attr->ip_version);
+	e = mlx5_esw_indir_table_entry_lookup(esw, vport);
 	if (!e)
 		goto out;
 
 	if (!decap)
 		e->fwd_ref--;
 	else
-		mlx5_esw_indir_table_rule_put(esw, attr, e);
+		mlx5_esw_indir_table_rule_put(esw, e);
 
-	if (e->fwd_ref || e->recirc_cnt)
+	if (e->fwd_ref || e->recirc_rule)
 		goto out;
 
 	hash_del(&e->hlist);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
index 21d56b49d14b..036f5b3a341b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
@@ -13,10 +13,8 @@ mlx5_esw_indir_table_destroy(struct mlx5_esw_indir_table *indir);
 
 struct mlx5_flow_table *mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 						 struct mlx5_flow_attr *attr,
-						 struct mlx5_flow_spec *spec,
 						 u16 vport, bool decap);
 void mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
-			      struct mlx5_flow_attr *attr,
 			      u16 vport, bool decap);
 
 bool
@@ -44,7 +42,6 @@ mlx5_esw_indir_table_destroy(struct mlx5_esw_indir_table *indir)
 static inline struct mlx5_flow_table *
 mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 			 struct mlx5_flow_attr *attr,
-			 struct mlx5_flow_spec *spec,
 			 u16 vport, bool decap)
 {
 	return ERR_PTR(-EOPNOTSUPP);
@@ -52,7 +49,6 @@ mlx5_esw_indir_table_get(struct mlx5_eswitch *esw,
 
 static inline void
 mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
-			 struct mlx5_flow_attr *attr,
 			 u16 vport, bool decap)
 {
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c981fa77f439..4eeb2dcbfc0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -179,15 +179,14 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 
 static int
 esw_setup_decap_indir(struct mlx5_eswitch *esw,
-		      struct mlx5_flow_attr *attr,
-		      struct mlx5_flow_spec *spec)
+		      struct mlx5_flow_attr *attr)
 {
 	struct mlx5_flow_table *ft;
 
 	if (!(attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE))
 		return -EOPNOTSUPP;
 
-	ft = mlx5_esw_indir_table_get(esw, attr, spec,
+	ft = mlx5_esw_indir_table_get(esw, attr,
 				      mlx5_esw_indir_table_decap_vport(attr), true);
 	return PTR_ERR_OR_ZERO(ft);
 }
@@ -197,7 +196,7 @@ esw_cleanup_decap_indir(struct mlx5_eswitch *esw,
 			struct mlx5_flow_attr *attr)
 {
 	if (mlx5_esw_indir_table_decap_vport(attr))
-		mlx5_esw_indir_table_put(esw, attr,
+		mlx5_esw_indir_table_put(esw,
 					 mlx5_esw_indir_table_decap_vport(attr),
 					 true);
 }
@@ -235,7 +234,6 @@ esw_setup_ft_dest(struct mlx5_flow_destination *dest,
 		  struct mlx5_flow_act *flow_act,
 		  struct mlx5_eswitch *esw,
 		  struct mlx5_flow_attr *attr,
-		  struct mlx5_flow_spec *spec,
 		  int i)
 {
 	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
@@ -243,7 +241,7 @@ esw_setup_ft_dest(struct mlx5_flow_destination *dest,
 	dest[i].ft = attr->dest_ft;
 
 	if (mlx5_esw_indir_table_decap_vport(attr))
-		return esw_setup_decap_indir(esw, attr, spec);
+		return esw_setup_decap_indir(esw, attr);
 	return 0;
 }
 
@@ -298,7 +296,7 @@ static void esw_put_dest_tables_loop(struct mlx5_eswitch *esw, struct mlx5_flow_
 			mlx5_chains_put_table(chains, 0, 1, 0);
 		else if (mlx5_esw_indir_table_needed(esw, attr, esw_attr->dests[i].rep->vport,
 						     esw_attr->dests[i].mdev))
-			mlx5_esw_indir_table_put(esw, attr, esw_attr->dests[i].rep->vport,
+			mlx5_esw_indir_table_put(esw, esw_attr->dests[i].rep->vport,
 						 false);
 }
 
@@ -384,7 +382,6 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
 		      struct mlx5_flow_act *flow_act,
 		      struct mlx5_eswitch *esw,
 		      struct mlx5_flow_attr *attr,
-		      struct mlx5_flow_spec *spec,
 		      bool ignore_flow_lvl,
 		      int *i)
 {
@@ -399,7 +396,7 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
 			flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 		dest[*i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 
-		dest[*i].ft = mlx5_esw_indir_table_get(esw, attr, spec,
+		dest[*i].ft = mlx5_esw_indir_table_get(esw, attr,
 						       esw_attr->dests[j].rep->vport, false);
 		if (IS_ERR(dest[*i].ft)) {
 			err = PTR_ERR(dest[*i].ft);
@@ -408,7 +405,7 @@ esw_setup_indir_table(struct mlx5_flow_destination *dest,
 	}
 
 	if (mlx5_esw_indir_table_decap_vport(attr)) {
-		err = esw_setup_decap_indir(esw, attr, spec);
+		err = esw_setup_decap_indir(esw, attr);
 		if (err)
 			goto err_indir_tbl_get;
 	}
@@ -511,14 +508,14 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 		err = esw_setup_mtu_dest(dest, &attr->meter_attr, *i);
 		(*i)++;
 	} else if (esw_is_indir_table(esw, attr)) {
-		err = esw_setup_indir_table(dest, flow_act, esw, attr, spec, true, i);
+		err = esw_setup_indir_table(dest, flow_act, esw, attr, true, i);
 	} else if (esw_is_chain_src_port_rewrite(esw, esw_attr)) {
 		err = esw_setup_chain_src_port_rewrite(dest, flow_act, esw, chains, attr, i);
 	} else {
 		*i = esw_setup_vport_dests(dest, flow_act, esw, esw_attr, *i);
 
 		if (attr->dest_ft) {
-			err = esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
+			err = esw_setup_ft_dest(dest, flow_act, esw, attr, *i);
 			(*i)++;
 		} else if (attr->dest_chain) {
 			err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
@@ -727,7 +724,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	for (i = 0; i < esw_attr->split_count; i++) {
 		if (esw_is_indir_table(esw, attr))
-			err = esw_setup_indir_table(dest, &flow_act, esw, attr, spec, false, &i);
+			err = esw_setup_indir_table(dest, &flow_act, esw, attr, false, &i);
 		else if (esw_is_chain_src_port_rewrite(esw, esw_attr))
 			err = esw_setup_chain_src_port_rewrite(dest, &flow_act, esw, chains, attr,
 							       &i);
-- 
2.39.0

