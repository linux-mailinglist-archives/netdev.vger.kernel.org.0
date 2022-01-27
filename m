Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC23449EC91
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344069AbiA0UkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:40:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37762 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344064AbiA0UkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:40:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADD796188A
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 20:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D45DC340EA;
        Thu, 27 Jan 2022 20:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643316017;
        bh=90XNzF/+JcPDm2+EHKJk4BgNk4Ud7zH7ghMhKoJ08Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRsft/LL4P/v0x5dWaHYbML7xpkBDKw1iao7ErRTxVZgT6hJlg9u13OupkwYNpAtm
         GU/dLPJCq9hoM01GXszavlsgkQ77ZQTahn5H87uqQegtaLWZOIUinaTObTclPLjoeo
         BWH6ZksBdg+GlyDJfHEBMae6aIuYRHtq5FmtLEOPnmh8XeNP9LK86Fy7y4ctHMc1sK
         LIPVx8qasBLEOHvbnOab0bFK3gvEdBNWDr1mseVlAlwkWm1cgui2qYbxjyqa+rPtiG
         zwPrCuW4RK0mLZy+ZDwxqSOGckD6WLiKCcmON8xt6IdOpnErwAJd40E4CA5bEOo2um
         1SHEdaincx3jw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next RESEND 13/17] net/mlx5e: TC, Store mapped tunnel id on flow attr
Date:   Thu, 27 Jan 2022 12:40:03 -0800
Message-Id: <20220127204007.146300-14-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127204007.146300-1-saeed@kernel.org>
References: <20220127204007.146300-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

In preparation for multiple attr instances the tunnel_id should
be attr specific and not flow specific.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.h |  6 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  4 +---
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 14 ++++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  4 +---
 6 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 7b60926f4d77..32230e677029 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -492,8 +492,7 @@ del_post_rule(struct mlx5_eswitch *esw, struct mlx5e_sample_flow *sample_flow,
 struct mlx5_flow_handle *
 mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_flow_attr *attr,
-			u32 tunnel_id)
+			struct mlx5_flow_attr *attr)
 {
 	struct mlx5e_post_act_handle *post_act_handle = NULL;
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
@@ -502,6 +501,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	struct mlx5e_sample_flow *sample_flow;
 	struct mlx5e_sample_attr *sample_attr;
 	struct mlx5_flow_attr *pre_attr;
+	u32 tunnel_id = attr->tunnel_id;
 	struct mlx5_eswitch *esw;
 	u32 default_tbl_id;
 	u32 obj_id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
index 9ef8a49d7801..a569367eae4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
@@ -26,8 +26,7 @@ void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj
 struct mlx5_flow_handle *
 mlx5e_tc_sample_offload(struct mlx5e_tc_psample *sample_priv,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_flow_attr *attr,
-			u32 tunnel_id);
+			struct mlx5_flow_attr *attr);
 
 void
 mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *sample_priv,
@@ -45,8 +44,7 @@ mlx5e_tc_sample_cleanup(struct mlx5e_tc_psample *tc_psample);
 static inline struct mlx5_flow_handle *
 mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_flow_attr *attr,
-			u32 tunnel_id)
+			struct mlx5_flow_attr *attr)
 { return ERR_PTR(-EOPNOTSUPP); }
 
 static inline void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index b7e8f20bd9e6..1fe6c9c786a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1871,12 +1871,10 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	 */
 	if ((pre_ct_attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
 	    attr->chain == 0) {
-		u32 tun_id = mlx5e_tc_get_flow_tun_id(flow);
-
 		err = mlx5e_tc_match_to_reg_set(priv->mdev, &pre_mod_acts,
 						ct_priv->ns_type,
 						TUNNEL_TO_REG,
-						tun_id);
+						attr->tunnel_id);
 		if (err) {
 			ct_dbg("Failed to set tunnel register mapping");
 			goto err_mapping;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index e13619133d53..b7d14aff5f3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -108,7 +108,6 @@ struct mlx5e_tc_flow {
 	struct rcu_head rcu_head;
 	struct completion init_done;
 	struct completion del_hw_done;
-	int tunnel_id; /* the mapped tunnel id of this flow */
 	struct mlx5_flow_attr *attr;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 31fdc8192879..83ca036528bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -308,7 +308,6 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
 		      struct mlx5_flow_attr *attr)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	u32 tun_id = mlx5e_tc_get_flow_tun_id(flow);
 
 	if (attr->flags & MLX5_ATTR_FLAG_CT) {
 		struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts =
@@ -323,7 +322,7 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
 		return mlx5e_add_offloaded_nic_rule(priv, spec, attr);
 
 	if (attr->flags & MLX5_ATTR_FLAG_SAMPLE)
-		return mlx5e_tc_sample_offload(get_sample_priv(priv), spec, attr, tun_id);
+		return mlx5e_tc_sample_offload(get_sample_priv(priv), spec, attr);
 
 	return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 }
@@ -1933,7 +1932,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	}
 
-	flow->tunnel_id = value;
+	flow->attr->tunnel_id = value;
 	return 0;
 
 err_set:
@@ -1947,8 +1946,8 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
 {
-	u32 enc_opts_id = flow->tunnel_id & ENC_OPTS_BITS_MASK;
-	u32 tun_id = flow->tunnel_id >> ENC_OPTS_BITS;
+	u32 enc_opts_id = flow->attr->tunnel_id & ENC_OPTS_BITS_MASK;
+	u32 tun_id = flow->attr->tunnel_id >> ENC_OPTS_BITS;
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *uplink_rpriv;
 	struct mlx5_eswitch *esw;
@@ -1964,11 +1963,6 @@ static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
 			       enc_opts_id);
 }
 
-u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow)
-{
-	return flow->tunnel_id;
-}
-
 void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
 			    struct flow_match_basic *match, bool outer,
 			    void *headers_c, void *headers_v)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 722702be7e91..c6221728b767 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -82,6 +82,7 @@ struct mlx5_flow_attr {
 	u8 outer_match_level;
 	u8 ip_version;
 	u8 tun_ip_version;
+	int tunnel_id; /* mapped tunnel id */
 	u32 flags;
 	union {
 		struct mlx5_esw_flow_attr esw_attr[0];
@@ -263,9 +264,6 @@ int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow,
 			      struct mlx5_flow_attr *attr);
 
-struct mlx5e_tc_flow;
-u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow);
-
 void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
 			    struct flow_match_basic *match, bool outer,
 			    void *headers_c, void *headers_v);
-- 
2.34.1

