Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E323421B9B
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhJEBQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231185AbhJEBQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FE75613AC;
        Tue,  5 Oct 2021 01:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396488;
        bh=7WxCVfrlfePgRSv+/N0cO5NXF0/ZphXwK1B79Ov+pmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1lv61H7cpnJdKTkyszkW2n+d/rtdQ/r/A4Lm1+/9maVByanudathElZ+uMN25EUX
         x/Ni6/tT5lWPm41Pa+snp5Hk0O6p/TZcbGvHe9OHREbZTlN4UPOScn5c4kaEiS1ekQ
         qvfOFvY+o5W1SHoNK80TUuawNKqa7eJ0KTruNAfGmQDaS27TlY0tvITl2sPR8gDXsQ
         WoPu/rKRiFPu9MXHYF1Zc8QSKYBRyYv7kF8u5rht5Og/mulYRL3eMb4pHLIxPHTF6E
         jxNOlfSIDbVP1BxmQtOT1TqgkkaUFQKzuCP5L6P4FPGLZ4TQ85Ywes0KlbTxBO+tvJ
         TQn9udZD0hy5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Bridge, mark reg_c1 when pushing VLAN
Date:   Mon,  4 Oct 2021 18:12:59 -0700
Message-Id: <20211005011302.41793-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

On ingress VLAN push also assign value 0x7FE to reg_c1 tunnel id+opts
bits (tunnel id 0, which is not a valid tunnel id, and option 0x7FE which
was reserved by one of previous patches in the series). In following patch
the reg value is matched on egress miss to restore the packet to its
original state by removing the VLAN before passing it to the software data
path.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 40 ++++++++++++++++++-
 .../mellanox/mlx5/core/esw/bridge_priv.h      |  1 +
 include/linux/mlx5/eswitch.h                  |  9 +++++
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 8361dfc0bf1a..439b67b4380f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -465,8 +465,10 @@ mlx5_esw_bridge_ingress_flow_with_esw_create(u16 vport_num, const unsigned char
 		 mlx5_eswitch_get_vport_metadata_for_match(esw, vport_num));
 
 	if (vlan && vlan->pkt_reformat_push) {
-		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
+			MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 		flow_act.pkt_reformat = vlan->pkt_reformat_push;
+		flow_act.modify_hdr = vlan->pkt_mod_hdr_push_mark;
 	} else if (vlan) {
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
 				 outer_headers.cvlan_tag);
@@ -845,6 +847,33 @@ mlx5_esw_bridge_vlan_pop_cleanup(struct mlx5_esw_bridge_vlan *vlan, struct mlx5_
 	vlan->pkt_reformat_pop = NULL;
 }
 
+static int
+mlx5_esw_bridge_vlan_push_mark_create(struct mlx5_esw_bridge_vlan *vlan, struct mlx5_eswitch *esw)
+{
+	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
+	struct mlx5_modify_hdr *pkt_mod_hdr;
+
+	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
+	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_C_1);
+	MLX5_SET(set_action_in, action, offset, 8);
+	MLX5_SET(set_action_in, action, length, ESW_TUN_OPTS_BITS + ESW_TUN_ID_BITS);
+	MLX5_SET(set_action_in, action, data, ESW_TUN_BRIDGE_INGRESS_PUSH_VLAN);
+
+	pkt_mod_hdr = mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_FDB, 1, action);
+	if (IS_ERR(pkt_mod_hdr))
+		return PTR_ERR(pkt_mod_hdr);
+
+	vlan->pkt_mod_hdr_push_mark = pkt_mod_hdr;
+	return 0;
+}
+
+static void
+mlx5_esw_bridge_vlan_push_mark_cleanup(struct mlx5_esw_bridge_vlan *vlan, struct mlx5_eswitch *esw)
+{
+	mlx5_modify_header_dealloc(esw->dev, vlan->pkt_mod_hdr_push_mark);
+	vlan->pkt_mod_hdr_push_mark = NULL;
+}
+
 static struct mlx5_esw_bridge_vlan *
 mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *port,
 			    struct mlx5_eswitch *esw)
@@ -864,6 +893,10 @@ mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *por
 		err = mlx5_esw_bridge_vlan_push_create(vlan, esw);
 		if (err)
 			goto err_vlan_push;
+
+		err = mlx5_esw_bridge_vlan_push_mark_create(vlan, esw);
+		if (err)
+			goto err_vlan_push_mark;
 	}
 	if (flags & BRIDGE_VLAN_INFO_UNTAGGED) {
 		err = mlx5_esw_bridge_vlan_pop_create(vlan, esw);
@@ -882,6 +915,9 @@ mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *por
 	if (vlan->pkt_reformat_pop)
 		mlx5_esw_bridge_vlan_pop_cleanup(vlan, esw);
 err_vlan_pop:
+	if (vlan->pkt_mod_hdr_push_mark)
+		mlx5_esw_bridge_vlan_push_mark_cleanup(vlan, esw);
+err_vlan_push_mark:
 	if (vlan->pkt_reformat_push)
 		mlx5_esw_bridge_vlan_push_cleanup(vlan, esw);
 err_vlan_push:
@@ -908,6 +944,8 @@ static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_vlan *vlan,
 
 	if (vlan->pkt_reformat_pop)
 		mlx5_esw_bridge_vlan_pop_cleanup(vlan, esw);
+	if (vlan->pkt_mod_hdr_push_mark)
+		mlx5_esw_bridge_vlan_push_mark_cleanup(vlan, esw);
 	if (vlan->pkt_reformat_push)
 		mlx5_esw_bridge_vlan_push_cleanup(vlan, esw);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
index 52964a82d6a6..878311fe950a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -49,6 +49,7 @@ struct mlx5_esw_bridge_vlan {
 	struct list_head fdb_list;
 	struct mlx5_pkt_reformat *pkt_reformat_push;
 	struct mlx5_pkt_reformat *pkt_reformat_pop;
+	struct mlx5_modify_hdr *pkt_mod_hdr_push_mark;
 };
 
 struct mlx5_esw_bridge_port {
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 4ab5c1fc1270..97afcea39a7b 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -130,11 +130,20 @@ u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
 #define ESW_TUN_OPTS_MASK GENMASK(31 - ESW_TUN_ID_BITS - ESW_RESERVED_BITS, ESW_TUN_OPTS_OFFSET)
 #define ESW_TUN_MASK GENMASK(31 - ESW_RESERVED_BITS, ESW_TUN_OFFSET)
 #define ESW_TUN_ID_SLOW_TABLE_GOTO_VPORT 0 /* 0 is not a valid tunnel id */
+#define ESW_TUN_ID_BRIDGE_INGRESS_PUSH_VLAN ESW_TUN_ID_SLOW_TABLE_GOTO_VPORT
 /* 0x7FF is a reserved mapping */
 #define ESW_TUN_OPTS_SLOW_TABLE_GOTO_VPORT GENMASK(ESW_TUN_OPTS_BITS - 1, 0)
 #define ESW_TUN_SLOW_TABLE_GOTO_VPORT ((ESW_TUN_ID_SLOW_TABLE_GOTO_VPORT << ESW_TUN_OPTS_BITS) | \
 				       ESW_TUN_OPTS_SLOW_TABLE_GOTO_VPORT)
 #define ESW_TUN_SLOW_TABLE_GOTO_VPORT_MARK ESW_TUN_OPTS_MASK
+/* 0x7FE is a reserved mapping for bridge ingress push vlan mark */
+#define ESW_TUN_OPTS_BRIDGE_INGRESS_PUSH_VLAN (ESW_TUN_OPTS_SLOW_TABLE_GOTO_VPORT - 1)
+#define ESW_TUN_BRIDGE_INGRESS_PUSH_VLAN ((ESW_TUN_ID_BRIDGE_INGRESS_PUSH_VLAN << \
+					   ESW_TUN_OPTS_BITS) | \
+					  ESW_TUN_OPTS_BRIDGE_INGRESS_PUSH_VLAN)
+#define ESW_TUN_BRIDGE_INGRESS_PUSH_VLAN_MARK \
+	GENMASK(31 - ESW_TUN_ID_BITS - ESW_RESERVED_BITS, \
+		ESW_TUN_OPTS_OFFSET + 1)
 
 u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev);
 u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev);
-- 
2.31.1

