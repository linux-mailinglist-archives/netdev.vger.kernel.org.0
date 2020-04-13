Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A6E1A6757
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 15:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgDMNwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 09:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbgDMNwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 09:52:30 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B761F2075E;
        Mon, 13 Apr 2020 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586785949;
        bh=CURBttHoTFf9CjWIyPxgDlZ6/OdrPOdq6SebAJMDkb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDwQ5hsvY2fsHSN7HK7Fxu+OIyNkM5S8YY5bthz3xZp7895nZPR5QnIgstPyZ/XZr
         4ZQ90D0gSRybYJ3cn4B6mN/hvxIbBrW1YB0+ooP0a0CKHugcdqXAMsh1rf0AcN12BW
         XyOUREUfvBcl+YXpbFaqe+kCVReRnicIzt0fteFg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 2/4] net/mlx5: Add support in forward to namespace
Date:   Mon, 13 Apr 2020 16:52:18 +0300
Message-Id: <20200413135220.934007-3-leon@kernel.org>
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

Currently, fs_core supports rule of forward the traffic
to continue matching in the next priority, now we add support
to forward the traffic matching in the next namespace.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 56 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  2 +
 include/linux/mlx5/fs.h                       |  1 +
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9afe942f7aa2..b297bdbeaf50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -384,6 +384,12 @@ static struct fs_prio *find_prio(struct mlx5_flow_namespace *ns,
 	return NULL;
 }
 
+static bool is_fwd_next_action(u32 action)
+{
+	return action & (MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO |
+			 MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS);
+}
+
 static bool check_valid_spec(const struct mlx5_flow_spec *spec)
 {
 	int i;
@@ -502,7 +508,7 @@ static void del_sw_hw_rule(struct fs_node *node)
 	fs_get_obj(rule, node);
 	fs_get_obj(fte, rule->node.parent);
 	trace_mlx5_fs_del_rule(rule);
-	if (rule->sw_action == MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO) {
+	if (is_fwd_next_action(rule->sw_action)) {
 		mutex_lock(&rule->dest_attr.ft->lock);
 		list_del(&rule->next_ft);
 		mutex_unlock(&rule->dest_attr.ft->lock);
@@ -826,6 +832,36 @@ static struct mlx5_flow_table *find_prev_chained_ft(struct fs_prio *prio)
 	return find_closest_ft(prio, true);
 }
 
+static struct fs_prio *find_fwd_ns_prio(struct mlx5_flow_root_namespace *root,
+					struct mlx5_flow_namespace *ns)
+{
+	struct mlx5_flow_namespace *root_ns = &root->ns;
+	struct fs_prio *iter_prio;
+	struct fs_prio *prio;
+
+	fs_get_obj(prio, ns->node.parent);
+	list_for_each_entry(iter_prio, &root_ns->node.children, node.list) {
+		if (iter_prio == prio &&
+		    !list_is_last(&prio->node.children, &iter_prio->node.list))
+			return list_next_entry(iter_prio, node.list);
+	}
+	return NULL;
+}
+
+static struct mlx5_flow_table *find_next_fwd_ft(struct mlx5_flow_table *ft,
+						struct mlx5_flow_act *flow_act)
+{
+	struct mlx5_flow_root_namespace *root = find_root(&ft->node);
+	struct fs_prio *prio;
+
+	if (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS)
+		prio = find_fwd_ns_prio(root, ft->ns);
+	else
+		fs_get_obj(prio, ft->node.parent);
+
+	return (prio) ? find_next_chained_ft(prio) : NULL;
+}
+
 static int connect_fts_in_prio(struct mlx5_core_dev *dev,
 			       struct fs_prio *prio,
 			       struct mlx5_flow_table *ft)
@@ -976,6 +1012,10 @@ static int connect_fwd_rules(struct mlx5_core_dev *dev,
 	list_splice_init(&old_next_ft->fwd_rules, &new_next_ft->fwd_rules);
 	mutex_unlock(&old_next_ft->lock);
 	list_for_each_entry(iter, &new_next_ft->fwd_rules, next_ft) {
+		if ((iter->sw_action & MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS) &&
+		    iter->ft->ns == new_next_ft->ns)
+			continue;
+
 		err = _mlx5_modify_rule_destination(iter, &dest);
 		if (err)
 			pr_err("mlx5_core: failed to modify rule to point on flow table %d\n",
@@ -1077,6 +1117,7 @@ static struct mlx5_flow_table *__mlx5_create_flow_table(struct mlx5_flow_namespa
 	next_ft = unmanaged ? ft_attr->next_ft :
 			      find_next_chained_ft(fs_prio);
 	ft->def_miss_action = ns->def_miss_action;
+	ft->ns = ns;
 	err = root->cmds->create_flow_table(root, ft, log_table_sz, next_ft);
 	if (err)
 		goto free_ft;
@@ -1903,21 +1944,19 @@ mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 	struct mlx5_flow_table *next_ft = NULL;
 	struct mlx5_flow_handle *handle = NULL;
 	u32 sw_action = flow_act->action;
-	struct fs_prio *prio;
 	int i;
 
 	if (!spec)
 		spec = &zero_spec;
 
-	if (!(sw_action & MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO))
+	if (!is_fwd_next_action(sw_action))
 		return _mlx5_add_flow_rules(ft, spec, flow_act, dest, num_dest);
 
 	if (!fwd_next_prio_supported(ft))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&root->chain_lock);
-	fs_get_obj(prio, ft->node.parent);
-	next_ft = find_next_chained_ft(prio);
+	next_ft = find_next_fwd_ft(ft, flow_act);
 	if (!next_ft) {
 		handle = ERR_PTR(-EOPNOTSUPP);
 		goto unlock;
@@ -1937,7 +1976,8 @@ mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 	dest = gen_dest;
 	num_dest++;
 	flow_act->action &=
-		~MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
+		~(MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO |
+		  MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS);
 	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	handle = _mlx5_add_flow_rules(ft, spec, flow_act, dest, num_dest);
 	if (IS_ERR_OR_NULL(handle))
@@ -1948,8 +1988,8 @@ mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 		list_add(&handle->rule[num_dest - 1]->next_ft,
 			 &next_ft->fwd_rules);
 		mutex_unlock(&next_ft->lock);
-		handle->rule[num_dest - 1]->sw_action =
-			MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
+		handle->rule[num_dest - 1]->sw_action = sw_action;
+		handle->rule[num_dest - 1]->ft = ft;
 	}
 unlock:
 	mutex_unlock(&root->chain_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 508108c58dae..825b662f809b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -138,6 +138,7 @@ struct fs_node {
 
 struct mlx5_flow_rule {
 	struct fs_node				node;
+	struct mlx5_flow_table			*ft;
 	struct mlx5_flow_destination		dest_attr;
 	/* next_ft should be accessed under chain_lock and only of
 	 * destination type is FWD_NEXT_fT.
@@ -175,6 +176,7 @@ struct mlx5_flow_table {
 	u32				flags;
 	struct rhltable			fgs_hash;
 	enum mlx5_flow_table_miss_action def_miss_action;
+	struct mlx5_flow_namespace	*ns;
 };
 
 struct mlx5_ft_underlay_qp {
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index e2d13e074067..6c5aa0a21425 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -42,6 +42,7 @@ enum {
 	MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO	= 1 << 16,
 	MLX5_FLOW_CONTEXT_ACTION_ENCRYPT	= 1 << 17,
 	MLX5_FLOW_CONTEXT_ACTION_DECRYPT	= 1 << 18,
+	MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS	= 1 << 19,
 };
 
 enum {
-- 
2.25.2

