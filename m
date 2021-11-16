Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99226453AEB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhKPU0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230028AbhKPU0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7591963215;
        Tue, 16 Nov 2021 20:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094219;
        bh=otLAPoWGXPVjbkIRA+G4zvYxo3ptUWD3KZSDvxGFLeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aifLGYdSvQ00XsdztH54CB5NmRMUpE3apNHMi6HYq6yotUyCueU3Ez2+zqaKIEZmf
         9PIMzxKB32X+Yw4WgcAdNU5SN512meCd8BwayGDeNVi7GZ7JmA3XG+UvfKJlWN8Pey
         7FqjzdMZc4WQSDGE/W3iRyZTX/TXPQRv30OcSClr/8UwyvpAKs5tR+8t6XOwy2QIhr
         qAoyE0vpt4BSL+OkQAvRgRl+GCGwcrSR+6zznb9BZ+Cp2rKjPGQGkaSaxR4gr2j6Vx
         ToTat6nWFsnKZP+gD9JnycTTYbKpJcTu1oQKzn3e4DubGMIwzSu4FnAeBJnO52dxLY
         Hx5D7spSNiU9g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/12] net/mlx5e: CT, Fix multiple allocations and memleak of mod acts
Date:   Tue, 16 Nov 2021 12:23:19 -0800
Message-Id: <20211116202321.283874-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

CT clear action offload adds additional mod hdr actions to the
flow's original mod actions in order to clear the registers which
hold ct_state.
When such flow also includes encap action, a neigh update event
can cause the driver to unoffload the flow and then reoffload it.

Each time this happens, the ct clear handling adds that same set
of mod hdr actions to reset ct_state until the max of mod hdr
actions is reached.

Also the driver never releases the allocated mod hdr actions and
causing a memleak.

Fix above two issues by moving CT clear mod acts allocation
into the parsing actions phase and only use it when offloading the rule.
The release of mod acts will be done in the normal flow_put().

 backtrace:
    [<000000007316e2f3>] krealloc+0x83/0xd0
    [<00000000ef157de1>] mlx5e_mod_hdr_alloc+0x147/0x300 [mlx5_core]
    [<00000000970ce4ae>] mlx5e_tc_match_to_reg_set_and_get_id+0xd7/0x240 [mlx5_core]
    [<0000000067c5fa17>] mlx5e_tc_match_to_reg_set+0xa/0x20 [mlx5_core]
    [<00000000d032eb98>] mlx5_tc_ct_entry_set_registers.isra.0+0x36/0xc0 [mlx5_core]
    [<00000000fd23b869>] mlx5_tc_ct_flow_offload+0x272/0x1f10 [mlx5_core]
    [<000000004fc24acc>] mlx5e_tc_offload_fdb_rules.part.0+0x150/0x620 [mlx5_core]
    [<00000000dc741c17>] mlx5e_tc_encap_flows_add+0x489/0x690 [mlx5_core]
    [<00000000e92e49d7>] mlx5e_rep_update_flows+0x6e4/0x9b0 [mlx5_core]
    [<00000000f60f5602>] mlx5e_rep_neigh_update+0x39a/0x5d0 [mlx5_core]

Fixes: 1ef3018f5af3 ("net/mlx5e: CT: Support clear action")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 26 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  8 ++++--
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index c1c6e74c79c4..2445e2ae3324 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1356,9 +1356,13 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
+			struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
+	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
+	int err;
+
 	if (!priv) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "offload of ct action isn't available");
@@ -1369,6 +1373,17 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 	attr->ct_attr.ct_action = act->ct.action;
 	attr->ct_attr.nf_ft = act->ct.flow_table;
 
+	if (!clear_action)
+		goto out;
+
+	err = mlx5_tc_ct_entry_set_registers(priv, mod_acts, 0, 0, 0, 0);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to set registers for ct clear");
+		return err;
+	}
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+
+out:
 	return 0;
 }
 
@@ -1898,23 +1913,16 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5_tc_ct_priv *ct_priv,
 
 	memcpy(pre_ct_attr, attr, attr_sz);
 
-	err = mlx5_tc_ct_entry_set_registers(ct_priv, mod_acts, 0, 0, 0, 0);
-	if (err) {
-		ct_dbg("Failed to set register for ct clear");
-		goto err_set_registers;
-	}
-
 	mod_hdr = mlx5_modify_header_alloc(priv->mdev, ct_priv->ns_type,
 					   mod_acts->num_actions,
 					   mod_acts->actions);
 	if (IS_ERR(mod_hdr)) {
 		err = PTR_ERR(mod_hdr);
 		ct_dbg("Failed to add create ct clear mod hdr");
-		goto err_set_registers;
+		goto err_mod_hdr;
 	}
 
 	pre_ct_attr->modify_hdr = mod_hdr;
-	pre_ct_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
 	rule = mlx5_tc_rule_insert(priv, orig_spec, pre_ct_attr);
 	if (IS_ERR(rule)) {
@@ -1930,7 +1938,7 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5_tc_ct_priv *ct_priv,
 
 err_insert:
 	mlx5_modify_header_dealloc(priv->mdev, mod_hdr);
-err_set_registers:
+err_mod_hdr:
 	netdev_warn(priv->netdev,
 		    "Failed to offload ct clear flow, err %d\n", err);
 	kfree(pre_ct_attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 363329f4aac6..99662af1e41a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -110,6 +110,7 @@ int mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec);
 int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
+			struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack);
 
@@ -172,6 +173,7 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec)
 static inline int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
+			struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cb76c41fe163..3d45f4ae80c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3608,7 +3608,9 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
-			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr, act, extack);
+			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr,
+						      &parse_attr->mod_hdr_acts,
+						      act, extack);
 			if (err)
 				return err;
 
@@ -4277,7 +4279,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
 				return -EOPNOTSUPP;
 			}
-			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr, act, extack);
+			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr,
+						      &parse_attr->mod_hdr_acts,
+						      act, extack);
 			if (err)
 				return err;
 
-- 
2.31.1

