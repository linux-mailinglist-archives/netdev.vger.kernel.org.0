Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAB61A675C
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 15:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgDMNwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 09:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730165AbgDMNwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 09:52:40 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD572075E;
        Mon, 13 Apr 2020 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586785960;
        bh=LbEsQ+sVIB4fA3yKyftqSlYMsfGAnEHvDqt5tas/UQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6DvAYvoapA2Z5CQFgJDnl5vZUuL2Vqum4oTZoAyOVNLrQ94vyOpZ5uPFRVq50/s7
         fYZaFOFP8reZ26IBzVmMng3h0ZPIOzSZphvjEXLVrwgeP0AXNpdzZC2CqW381Pa5dN
         s7QC1+KO6/V2yUiuTFSAh29eNM1RRgX5H3mrC6Eo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/4] {IB/net}/mlx5: Simplify don't trap code
Date:   Mon, 13 Apr 2020 16:52:17 +0300
Message-Id: <20200413135220.934007-2-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200413135220.934007-1-leon@kernel.org>
References: <20200413135220.934007-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

The fs_core already supports creation of rules with multiple
actions/destinations. Refactor fs_core to handle the case
when don't trap rule is created with destination. Adapt the
calling code in the driver.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             | 46 +++--------
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 79 +++++++++++--------
 2 files changed, 55 insertions(+), 70 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 953c1d6b23aa..c6bece8f6b2f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3698,12 +3698,13 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 		if (!dest_num)
 			rule_dst = NULL;
 	} else {
+		if (flow_attr->flags & IB_FLOW_ATTR_FLAGS_DONT_TRAP)
+			flow_act.action |=
+				MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
 		if (is_egress)
 			flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-		else
-			flow_act.action |=
-				dest_num ?  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
-					MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
+		else if (dest_num)
+			flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
 	if ((spec->flow_context.flags & FLOW_CONTEXT_HAS_TAG)  &&
@@ -3747,30 +3748,6 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 	return _create_flow_rule(dev, ft_prio, flow_attr, dst, 0, NULL);
 }
 
-static struct mlx5_ib_flow_handler *create_dont_trap_rule(struct mlx5_ib_dev *dev,
-							  struct mlx5_ib_flow_prio *ft_prio,
-							  struct ib_flow_attr *flow_attr,
-							  struct mlx5_flow_destination *dst)
-{
-	struct mlx5_ib_flow_handler *handler_dst = NULL;
-	struct mlx5_ib_flow_handler *handler = NULL;
-
-	handler = create_flow_rule(dev, ft_prio, flow_attr, NULL);
-	if (!IS_ERR(handler)) {
-		handler_dst = create_flow_rule(dev, ft_prio,
-					       flow_attr, dst);
-		if (IS_ERR(handler_dst)) {
-			mlx5_del_flow_rules(handler->rule);
-			ft_prio->refcount--;
-			kfree(handler);
-			handler = handler_dst;
-		} else {
-			list_add(&handler_dst->list, &handler->list);
-		}
-	}
-
-	return handler;
-}
 enum {
 	LEFTOVERS_MC,
 	LEFTOVERS_UC,
@@ -3974,15 +3951,10 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	}
 
 	if (flow_attr->type == IB_FLOW_ATTR_NORMAL) {
-		if (flow_attr->flags & IB_FLOW_ATTR_FLAGS_DONT_TRAP)  {
-			handler = create_dont_trap_rule(dev, ft_prio,
-							flow_attr, dst);
-		} else {
-			underlay_qpn = (mqp->flags & MLX5_IB_QP_UNDERLAY) ?
-					mqp->underlay_qpn : 0;
-			handler = _create_flow_rule(dev, ft_prio, flow_attr,
-						    dst, underlay_qpn, ucmd);
-		}
+		underlay_qpn = (mqp->flags & MLX5_IB_QP_UNDERLAY) ?
+			mqp->underlay_qpn : 0;
+		handler = _create_flow_rule(dev, ft_prio, flow_attr,
+					    dst, underlay_qpn, ucmd);
 	} else if (flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT ||
 		   flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT) {
 		handler = create_leftovers_rule(dev, ft_prio, flow_attr,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d5defe09339a..9afe942f7aa2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -254,7 +254,7 @@ static void del_sw_flow_group(struct fs_node *node);
 static void del_sw_fte(struct fs_node *node);
 static void del_sw_prio(struct fs_node *node);
 static void del_sw_ns(struct fs_node *node);
-/* Delete rule (destination) is special case that 
+/* Delete rule (destination) is special case that
  * requires to lock the FTE for all the deletion process.
  */
 static void del_sw_hw_rule(struct fs_node *node);
@@ -1899,48 +1899,61 @@ mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 {
 	struct mlx5_flow_root_namespace *root = find_root(&ft->node);
 	static const struct mlx5_flow_spec zero_spec = {};
-	struct mlx5_flow_destination gen_dest = {};
+	struct mlx5_flow_destination *gen_dest = NULL;
 	struct mlx5_flow_table *next_ft = NULL;
 	struct mlx5_flow_handle *handle = NULL;
 	u32 sw_action = flow_act->action;
 	struct fs_prio *prio;
+	int i;
 
 	if (!spec)
 		spec = &zero_spec;
 
-	fs_get_obj(prio, ft->node.parent);
-	if (flow_act->action == MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO) {
-		if (!fwd_next_prio_supported(ft))
-			return ERR_PTR(-EOPNOTSUPP);
-		if (num_dest)
-			return ERR_PTR(-EINVAL);
-		mutex_lock(&root->chain_lock);
-		next_ft = find_next_chained_ft(prio);
-		if (next_ft) {
-			gen_dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-			gen_dest.ft = next_ft;
-			dest = &gen_dest;
-			num_dest = 1;
-			flow_act->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-		} else {
-			mutex_unlock(&root->chain_lock);
-			return ERR_PTR(-EOPNOTSUPP);
-		}
-	}
+	if (!(sw_action & MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO))
+		return _mlx5_add_flow_rules(ft, spec, flow_act, dest, num_dest);
 
-	handle = _mlx5_add_flow_rules(ft, spec, flow_act, dest, num_dest);
+	if (!fwd_next_prio_supported(ft))
+		return ERR_PTR(-EOPNOTSUPP);
 
-	if (sw_action == MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO) {
-		if (!IS_ERR_OR_NULL(handle) &&
-		    (list_empty(&handle->rule[0]->next_ft))) {
-			mutex_lock(&next_ft->lock);
-			list_add(&handle->rule[0]->next_ft,
-				 &next_ft->fwd_rules);
-			mutex_unlock(&next_ft->lock);
-			handle->rule[0]->sw_action = MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
-		}
-		mutex_unlock(&root->chain_lock);
-	}
+	mutex_lock(&root->chain_lock);
+	fs_get_obj(prio, ft->node.parent);
+	next_ft = find_next_chained_ft(prio);
+	if (!next_ft) {
+		handle = ERR_PTR(-EOPNOTSUPP);
+		goto unlock;
+	}
+
+	gen_dest = kcalloc(num_dest + 1, sizeof(*dest),
+			   GFP_KERNEL);
+	if (!gen_dest) {
+		handle = ERR_PTR(-ENOMEM);
+		goto unlock;
+	}
+	for (i = 0; i < num_dest; i++)
+		gen_dest[i] = dest[i];
+	gen_dest[i].type =
+		MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	gen_dest[i].ft = next_ft;
+	dest = gen_dest;
+	num_dest++;
+	flow_act->action &=
+		~MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
+	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	handle = _mlx5_add_flow_rules(ft, spec, flow_act, dest, num_dest);
+	if (IS_ERR_OR_NULL(handle))
+		goto unlock;
+
+	if (list_empty(&handle->rule[num_dest - 1]->next_ft)) {
+		mutex_lock(&next_ft->lock);
+		list_add(&handle->rule[num_dest - 1]->next_ft,
+			 &next_ft->fwd_rules);
+		mutex_unlock(&next_ft->lock);
+		handle->rule[num_dest - 1]->sw_action =
+			MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
+	}
+unlock:
+	mutex_unlock(&root->chain_lock);
+	kfree(gen_dest);
 	return handle;
 }
 EXPORT_SYMBOL(mlx5_add_flow_rules);
-- 
2.25.2

