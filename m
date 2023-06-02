Return-Path: <netdev+bounces-7549-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C04EE720995
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42A561C21184
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D9A1E507;
	Fri,  2 Jun 2023 19:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9941DDEA
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE6FC433D2;
	Fri,  2 Jun 2023 19:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685733184;
	bh=OkCBSdBZ5u+HiH7wk55JNZlGQf0V/f/Cd/aB9oK7+rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzHF7EadtYckXmB34WGXk2bZ2PL7rYsqguFBq7amGqvwWLaqnS8GLKIvGjfW2e3XP
	 j0stmAaX29H5aEbJ8DPIFJYo1YV/ylyKYoxGocK80Ej2cHQMLYuLs1XZJb7LRoPKTu
	 vu5vwOd52IfSE2hzHfq8klNVNxIzseMhE8Q2IEpiDF3dHz0f7gWIa2bI0OrGydKNRT
	 Emoa8FyZJjVdbN1bZZA/eAKdZ8s8mrZBPEFX/75DrMIvkQFIUAtUAvMv0PRGZXYoLm
	 1aN4Nuf2Q7aU6FoomiFya+Hd2naaNxVyPiHFqiW/WQUITrs+ar8qvwS6D6+3efpIOv
	 aObAmK/AMUWog==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next V2 01/14] net/mlx5e: en_tc, Extend peer flows to a list
Date: Fri,  2 Jun 2023 12:12:48 -0700
Message-Id: <20230602191301.47004-2-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602191301.47004-1-saeed@kernel.org>
References: <20230602191301.47004-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Bloch <mbloch@nvidia.com>

Currently, mlx5e_flow is holding a pointer to a peer_flow, in case one
was created. e.g. There is an assumption that mlx5e_flow can have only
one peer.
In order to support more than one peer, refactor mlx5e_flow to hold a
list of peer flows.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 43 ++++++++++++-------
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index ba2b1f24ff14..8a500a966f06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -94,13 +94,13 @@ struct mlx5e_tc_flow {
 	 * destinations.
 	 */
 	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
-	struct mlx5e_tc_flow *peer_flow;
 	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
 	struct list_head hairpin; /* flows sharing the same hairpin */
 	struct list_head peer;    /* flows with peer flow */
 	struct list_head unready; /* flows not ready to be offloaded (e.g
 				   * due to missing route)
 				   */
+	struct list_head peer_flows; /* flows on peer */
 	struct net_device *orig_dev; /* netdev adding flow first */
 	int tmp_entry_index;
 	struct list_head tmp_list; /* temporary flow list used by neigh update */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index fd9f928e25c7..9c9c7024772f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1989,6 +1989,8 @@ void mlx5e_put_flow_list(struct mlx5e_priv *priv, struct list_head *flow_list)
 static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw = flow->priv->mdev->priv.eswitch;
+	struct mlx5e_tc_flow *peer_flow;
+	struct mlx5e_tc_flow *tmp;
 
 	if (!flow_flag_test(flow, ESWITCH) ||
 	    !flow_flag_test(flow, DUP))
@@ -2000,12 +2002,13 @@ static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
 
 	flow_flag_clear(flow, DUP);
 
-	if (refcount_dec_and_test(&flow->peer_flow->refcnt)) {
-		mlx5e_tc_del_fdb_flow(flow->peer_flow->priv, flow->peer_flow);
-		kfree(flow->peer_flow);
+	list_for_each_entry_safe(peer_flow, tmp, &flow->peer_flows, peer_flows) {
+		if (refcount_dec_and_test(&peer_flow->refcnt)) {
+			mlx5e_tc_del_fdb_flow(peer_flow->priv, peer_flow);
+			list_del(&peer_flow->peer_flows);
+			kfree(peer_flow);
+		}
 	}
-
-	flow->peer_flow = NULL;
 }
 
 static void mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
@@ -4295,6 +4298,7 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	INIT_LIST_HEAD(&flow->hairpin);
 	INIT_LIST_HEAD(&flow->l3_to_l2_reformat);
 	INIT_LIST_HEAD(&flow->attrs);
+	INIT_LIST_HEAD(&flow->peer_flows);
 	refcount_set(&flow->refcnt, 1);
 	init_completion(&flow->init_done);
 	init_completion(&flow->del_hw_done);
@@ -4443,7 +4447,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 		goto out;
 	}
 
-	flow->peer_flow = peer_flow;
+	list_add_tail(&peer_flow->peer_flows, &flow->peer_flows);
 	flow_flag_set(flow, DUP);
 	mutex_lock(&esw->offloads.peer_mutex);
 	list_add_tail(&flow->peer, &esw->offloads.peer_flows);
@@ -4741,19 +4745,26 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	if (!peer_esw)
 		goto out;
 
-	if (flow_flag_test(flow, DUP) &&
-	    flow_flag_test(flow->peer_flow, OFFLOADED)) {
-		u64 bytes2;
-		u64 packets2;
-		u64 lastuse2;
+	if (flow_flag_test(flow, DUP)) {
+		struct mlx5e_tc_flow *peer_flow;
 
-		if (flow_flag_test(flow, USE_ACT_STATS)) {
-			f->use_act_stats = true;
-		} else {
-			counter = mlx5e_tc_get_counter(flow->peer_flow);
+		list_for_each_entry(peer_flow, &flow->peer_flows, peer_flows) {
+			u64 packets2;
+			u64 lastuse2;
+			u64 bytes2;
+
+			if (!flow_flag_test(peer_flow, OFFLOADED))
+				continue;
+			if (flow_flag_test(flow, USE_ACT_STATS)) {
+				f->use_act_stats = true;
+				break;
+			}
+
+			counter = mlx5e_tc_get_counter(peer_flow);
 			if (!counter)
 				goto no_peer_counter;
-			mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
+			mlx5_fc_query_cached(counter, &bytes2, &packets2,
+					     &lastuse2);
 
 			bytes += bytes2;
 			packets += packets2;
-- 
2.40.1


