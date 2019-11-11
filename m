Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3052DF838A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfKKXew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:34:52 -0500
Received: from correo.us.es ([193.147.175.20]:43032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727284AbfKKXev (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:34:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE9EE2A2BBC
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDD9EB7FF6
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B3568A8E5; Tue, 12 Nov 2019 00:34:45 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA971D2B1F;
        Tue, 12 Nov 2019 00:34:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:34:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6BB6942EF4E0;
        Tue, 12 Nov 2019 00:34:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeedm@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 7/7] net/mlx5: TC: Offload flow table rules
Date:   Tue, 12 Nov 2019 00:34:30 +0100
Message-Id: <20191111233430.25120-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111233430.25120-1-pablo@netfilter.org>
References: <20191111233430.25120-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Since both tc rules and flow table rules are of the same format,
we can re-use tc parsing for that, and move the flow table rules
to their steering domain - In this case, the next chain after
max tc chain.

Issue: 1929510
Change-Id: I68bf14d5398b91cf26cc7c7f19dab64ba8757c01
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 45 ++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 28 ++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h  |  3 +-
 3 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index cd9bb7c7b341..c9cb037d7f79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1243,21 +1243,60 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static LIST_HEAD(mlx5e_rep_block_cb_list);
+static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
+				 void *cb_priv)
+{
+	struct flow_cls_offload *f = type_data;
+	struct flow_cls_offload cls_flower;
+	struct mlx5e_priv *priv = cb_priv;
+	struct mlx5_eswitch *esw;
+	unsigned long flags;
+	int err;
+
+	flags = MLX5_TC_FLAG(INGRESS) |
+		MLX5_TC_FLAG(ESW_OFFLOAD) |
+		MLX5_TC_FLAG(FT_OFFLOAD);
+	esw = priv->mdev->priv.eswitch;
 
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		if (!mlx5_eswitch_prios_supported(esw) || f->common.chain_index)
+			return -EOPNOTSUPP;
+
+		/* Re-use tc offload path by moving the ft flow to the
+		 * reserved ft chain.
+		 */
+		memcpy(&cls_flower, f, sizeof(*f));
+		cls_flower.common.chain_index = FDB_FT_CHAIN;
+		err = mlx5e_rep_setup_tc_cls_flower(priv, &cls_flower, flags);
+		memcpy(&f->stats, &cls_flower.stats, sizeof(f->stats));
+		return err;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static LIST_HEAD(mlx5e_rep_block_tc_cb_list);
+static LIST_HEAD(mlx5e_rep_block_ft_cb_list);
 static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct flow_block_offload *f = type_data;
 
+	f->unlocked_driver_cb = true;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		f->unlocked_driver_cb = true;
 		return flow_block_cb_setup_simple(type_data,
-						  &mlx5e_rep_block_cb_list,
+						  &mlx5e_rep_block_tc_cb_list,
 						  mlx5e_rep_setup_tc_cb,
 						  priv, priv, true);
+	case TC_SETUP_FT:
+		return flow_block_cb_setup_simple(type_data,
+						  &mlx5e_rep_block_ft_cb_list,
+						  mlx5e_rep_setup_ft_cb,
+						  priv, priv, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0c1022cda128..3a707d788022 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -74,6 +74,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_INGRESS	= MLX5E_TC_FLAG_INGRESS_BIT,
 	MLX5E_TC_FLOW_FLAG_EGRESS	= MLX5E_TC_FLAG_EGRESS_BIT,
 	MLX5E_TC_FLOW_FLAG_ESWITCH	= MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
+	MLX5E_TC_FLOW_FLAG_FT		= MLX5E_TC_FLAG_FT_OFFLOAD_BIT,
 	MLX5E_TC_FLOW_FLAG_NIC		= MLX5E_TC_FLAG_NIC_OFFLOAD_BIT,
 	MLX5E_TC_FLOW_FLAG_OFFLOADED	= MLX5E_TC_FLOW_BASE,
 	MLX5E_TC_FLOW_FLAG_HAIRPIN	= MLX5E_TC_FLOW_BASE + 1,
@@ -276,6 +277,11 @@ static bool mlx5e_is_eswitch_flow(struct mlx5e_tc_flow *flow)
 	return flow_flag_test(flow, ESWITCH);
 }
 
+static bool mlx5e_is_ft_flow(struct mlx5e_tc_flow *flow)
+{
+	return flow_flag_test(flow, FT);
+}
+
 static bool mlx5e_is_offloaded_flow(struct mlx5e_tc_flow *flow)
 {
 	return flow_flag_test(flow, OFFLOADED);
@@ -1168,7 +1174,12 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (attr->chain > max_chain) {
+	/* We check chain range only for tc flows.
+	 * For ft flows, we checked attr->chain was originally 0 and set it to
+	 * FDB_FT_CHAIN which is outside tc range.
+	 * See mlx5e_rep_setup_ft_cb().
+	 */
+	if (!mlx5e_is_ft_flow(flow) && attr->chain > max_chain) {
 		NL_SET_ERR_MSG(extack, "Requested chain is out of supported range");
 		return -EOPNOTSUPP;
 	}
@@ -3217,6 +3228,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr = attr->parse_attr;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	const struct ip_tunnel_info *info = NULL;
+	bool ft_flow = mlx5e_is_ft_flow(flow);
 	const struct flow_action_entry *act;
 	bool encap = false;
 	u32 action = 0;
@@ -3261,6 +3273,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EINVAL;
 			}
 
+			if (ft_flow && out_dev == priv->netdev) {
+				/* Ignore forward to self rules generated
+				 * by adding both mlx5 devs to the flow table
+				 * block on a normal nft offload setup.
+				 */
+				return -EOPNOTSUPP;
+			}
+
 			if (attr->out_count >= MLX5_MAX_FLOW_FWD_VPORTS) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "can't support more output ports, can't offload forwarding");
@@ -3385,6 +3405,10 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			u32 dest_chain = act->chain_index;
 			u32 max_chain = mlx5_eswitch_get_chain_range(esw);
 
+			if (ft_flow) {
+				NL_SET_ERR_MSG_MOD(extack, "Goto action is not supported");
+				return -EOPNOTSUPP;
+			}
 			if (dest_chain <= attr->chain) {
 				NL_SET_ERR_MSG(extack, "Goto earlier chain isn't supported");
 				return -EOPNOTSUPP;
@@ -3475,6 +3499,8 @@ static void get_flags(int flags, unsigned long *flow_flags)
 		__flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_ESWITCH);
 	if (flags & MLX5_TC_FLAG(NIC_OFFLOAD))
 		__flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_NIC);
+	if (flags & MLX5_TC_FLAG(FT_OFFLOAD))
+		__flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_FT);
 
 	*flow_flags = __flow_flags;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 924c6ef86a14..262cdb7b69b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -44,7 +44,8 @@ enum {
 	MLX5E_TC_FLAG_EGRESS_BIT,
 	MLX5E_TC_FLAG_NIC_OFFLOAD_BIT,
 	MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
-	MLX5E_TC_FLAG_LAST_EXPORTED_BIT = MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
+	MLX5E_TC_FLAG_FT_OFFLOAD_BIT,
+	MLX5E_TC_FLAG_LAST_EXPORTED_BIT = MLX5E_TC_FLAG_FT_OFFLOAD_BIT,
 };
 
 #define MLX5_TC_FLAG(flag) BIT(MLX5E_TC_FLAG_##flag##_BIT)
-- 
2.11.0

