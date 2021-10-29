Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9DF44047D
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhJ2U7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhJ2U7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E04610CF;
        Fri, 29 Oct 2021 20:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541006;
        bh=lHr+lHs683YsbvumHe8tGggV4FGGP9YyA9UgvxViyy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjSV4iLiaUnhsa5SBmlgB72HbCeQ33u+ExjC5TIQPcTNrwQGj2uY4DULv5OXU1h7w
         kfbsTJIt/v+B5QXvrVSj056UdrEzJcoPM5i4puRvHbP8b4O+3rn4opi/lYkz4KjQW7
         6+jtRKJl3hClq2xrwhOALaSXYcG2B6ITCk3KeNi4DK185Bl0RaHf4yMY/UX1JjX+fX
         xiAm5NqCk3RJpVwru8LMJ97sT15RrXxG+24nhqFrfc/UO8jQCSFmub9TqofqfkYe+R
         +ktODPUmMndtWEtHZD6p475DXE3VvR0Y9szlAF87MaQbwfftuGnzqwwjd6b2yh1DkJ
         tZCcavpecV+/g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/14] net/mlx5e: Refactor rx handler of represetor device
Date:   Fri, 29 Oct 2021 13:56:24 -0700
Message-Id: <20211029205632.390403-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Move the ownership of skb forwarding to network stack to the
tc update_skb handler as different cases will require different
handling of the skb.

While the tc handler will take care of the various cases and
properly handle the handover of the skb to the network stack
and freeing the skb, the main rx handler will be kept clean
from branches and usage of flags.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 41 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/rep/tc.h   | 13 ++----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 22 +---------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  1 -
 4 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 398c6761eeb3..eb960eba6027 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -19,6 +19,7 @@
 #include "en/tc_tun.h"
 #include "lib/port_tun.h"
 #include "en/tc/sample.h"
+#include "en_accel/ipsec_rxtx.h"
 
 struct mlx5e_rep_indr_block_priv {
 	struct net_device *netdev;
@@ -652,6 +653,12 @@ static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
 	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 }
 
+static void mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv)
+{
+	if (tc_priv->tun_dev)
+		dev_put(tc_priv->tun_dev);
+}
+
 static void mlx5e_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *skb,
 				     struct mlx5_mapped_obj *mapped_obj,
 				     struct mlx5e_tc_update_priv *tc_priv)
@@ -665,10 +672,10 @@ static void mlx5e_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *sk
 	mlx5_rep_tc_post_napi_receive(tc_priv);
 }
 
-bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
-			     struct sk_buff *skb,
-			     struct mlx5e_tc_update_priv *tc_priv)
+void mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
+			  struct sk_buff *skb)
 {
+	struct mlx5e_tc_update_priv tc_priv = {};
 	struct mlx5_mapped_obj mapped_obj;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
@@ -677,7 +684,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
 	if (!reg_c0 || reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
-		return true;
+		goto forward;
 
 	/* If reg_c0 is not equal to the default flow tag then skb->mark
 	 * is not supported and must be reset back to 0.
@@ -691,26 +698,30 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 		netdev_dbg(priv->netdev,
 			   "Couldn't find mapped object for reg_c0: %d, err: %d\n",
 			   reg_c0, err);
-		return false;
+		goto free_skb;
 	}
 
 	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
 		u32 reg_c1 = be32_to_cpu(cqe->ft_metadata);
 
-		return mlx5e_restore_skb_chain(skb, mapped_obj.chain, reg_c1, tc_priv);
+		if (!mlx5e_restore_skb_chain(skb, mapped_obj.chain, reg_c1, &tc_priv) &&
+		    !mlx5_ipsec_is_rx_flow(cqe))
+			goto free_skb;
 	} else if (mapped_obj.type == MLX5_MAPPED_OBJ_SAMPLE) {
-		mlx5e_restore_skb_sample(priv, skb, &mapped_obj, tc_priv);
-		return false;
+		mlx5e_restore_skb_sample(priv, skb, &mapped_obj, &tc_priv);
+		goto free_skb;
 	} else {
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
-		return false;
+		goto free_skb;
 	}
 
-	return true;
-}
+forward:
+	napi_gro_receive(rq->cq.napi, skb);
 
-void mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv)
-{
-	if (tc_priv->tun_dev)
-		dev_put(tc_priv->tun_dev);
+	mlx5_rep_tc_post_napi_receive(&tc_priv);
+
+	return;
+
+free_skb:
+	dev_kfree_skb_any(skb);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
index d0661578467b..0a8334d20b3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
@@ -36,10 +36,8 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
 int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		       void *type_data);
 
-bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
-			     struct sk_buff *skb,
-			     struct mlx5e_tc_update_priv *tc_priv);
-void mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv);
+void mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
+			  struct sk_buff *skb);
 
 #else /* CONFIG_MLX5_CLS_ACT */
 
@@ -67,12 +65,9 @@ mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		   void *type_data) { return -EOPNOTSUPP; }
 
 struct mlx5e_tc_update_priv;
-static inline bool
-mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
-			struct sk_buff *skb,
-			struct mlx5e_tc_update_priv *tc_priv) { return true; }
 static inline void
-mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv) {}
+mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
+		     struct sk_buff *skb) {}
 
 #endif /* CONFIG_MLX5_CLS_ACT */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index f63c8ff3ef3f..96967b0a2441 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1660,7 +1660,6 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_rep_priv *rpriv  = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	struct mlx5e_tc_update_priv tc_priv = {};
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	struct mlx5e_wqe_frag_info *wi;
 	struct sk_buff *skb;
@@ -1696,15 +1695,7 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
-	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
-		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
-		dev_kfree_skb_any(skb);
-		goto free_wqe;
-	}
-
-	napi_gro_receive(rq->cq.napi, skb);
-
-	mlx5_rep_tc_post_napi_receive(&tc_priv);
+	mlx5e_rep_tc_receive(cqe, rq, skb);
 
 free_wqe:
 	mlx5e_free_rx_wqe(rq, wi, true);
@@ -1721,7 +1712,6 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 	u32 wqe_offset     = stride_ix << rq->mpwqe.log_stride_sz;
 	u32 head_offset    = wqe_offset & (PAGE_SIZE - 1);
 	u32 page_idx       = wqe_offset >> PAGE_SHIFT;
-	struct mlx5e_tc_update_priv tc_priv = {};
 	struct mlx5e_rx_wqe_ll *wqe;
 	struct mlx5_wq_ll *wq;
 	struct sk_buff *skb;
@@ -1754,15 +1744,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
-	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
-		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
-		dev_kfree_skb_any(skb);
-		goto mpwrq_cqe_out;
-	}
-
-	napi_gro_receive(rq->cq.napi, skb);
-
-	mlx5_rep_tc_post_napi_receive(&tc_priv);
+	mlx5e_rep_tc_receive(cqe, rq, skb);
 
 mpwrq_cqe_out:
 	if (likely(wi->consumed_strides < rq->mpwqe.num_strides))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3af3da214a5b..f458f7f6b299 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -60,7 +60,6 @@
 #include "en/mapping.h"
 #include "en/tc_ct.h"
 #include "en/mod_hdr.h"
-#include "en/tc_priv.h"
 #include "en/tc_tun_encap.h"
 #include "en/tc/sample.h"
 #include "lib/devcom.h"
-- 
2.31.1

