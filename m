Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F3B311B6A
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhBFFOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:14:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhBFFHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:07:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6BC64FE7;
        Sat,  6 Feb 2021 05:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587769;
        bh=GGMCabt/sjWFnqVxFkKclinSu0Igen6967to3HYD4DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBwK9KldagwjqZjL+NLCF+hb7aBzkTFmAWXS70UIuDF4SR2KBEQtmikqSCtqn9xvw
         AMSLEYzSVucfU4m5XxVsPRVbRQ1fwn5u4mK1P7/DWxG/fYZSr3GeohsDK6Gv6fkm1l
         A1zgs0ojc1ZU3+QNYzwQC6/x6Nz/ky8KzR0Fiyd/sTfKmyV24My/c2b64wcqHffylt
         eu7bldLnVc7ffjNuSIu6pKwYd3LhtVcAqOPHkoxfP+Y0ePYcjXRn3JVHtyIXAVtCTU
         ZlfNGExopc++wfUcUraSTJY8DqdgUSxFRF0SlmtCQmgAREzG3usvC/wZu+cT334L1N
         RUCeDFh+fjnFg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 16/17] net/mlx5e: Rename some encap-specific API to generic names
Date:   Fri,  5 Feb 2021 21:02:39 -0800
Message-Id: <20210206050240.48410-17-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Some of the encap-specific functions and fields will also be used by route
update infrastructure in following patches. Rename them to generic names.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h        |  2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index a7ba1c84371d..065126370acd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -124,7 +124,7 @@ void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
 	}
 unlock:
 	mutex_unlock(&esw->offloads.encap_tbl_lock);
-	mlx5e_put_encap_flow_list(priv, &flow_list);
+	mlx5e_put_flow_list(priv, &flow_list);
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 14db9b5accb1..4f35b486fb44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -95,7 +95,7 @@ struct mlx5e_tc_flow {
 				   * due to missing route)
 				   */
 	struct net_device *orig_dev; /* netdev adding flow first */
-	int tmp_efi_index;
+	int tmp_entry_index;
 	struct list_head tmp_list; /* temporary flow list used by neigh update */
 	refcount_t refcnt;
 	struct rcu_head rcu_head;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 577216744a17..bc0e26f3fd4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -106,8 +106,8 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 		esw_attr = attr->esw_attr;
 		spec = &attr->parse_attr->spec;
 
-		esw_attr->dests[flow->tmp_efi_index].pkt_reformat = e->pkt_reformat;
-		esw_attr->dests[flow->tmp_efi_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
+		esw_attr->dests[flow->tmp_entry_index].pkt_reformat = e->pkt_reformat;
+		esw_attr->dests[flow->tmp_entry_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
 		/* Flow can be associated with multiple encap entries.
 		 * Before offloading the flow verify that all of them have
 		 * a valid neighbour.
@@ -161,7 +161,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 		/* update from encap rule to slow path rule */
 		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
 		/* mark the flow's encap dest as non-valid */
-		esw_attr->dests[flow->tmp_efi_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
+		esw_attr->dests[flow->tmp_entry_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
 
 		if (IS_ERR(rule)) {
 			err = PTR_ERR(rule);
@@ -195,7 +195,7 @@ void mlx5e_take_all_encap_flows(struct mlx5e_encap_entry *e, struct list_head *f
 			continue;
 		wait_for_completion(&flow->init_done);
 
-		flow->tmp_efi_index = efi->index;
+		flow->tmp_entry_index = efi->index;
 		list_add(&flow->tmp_list, flow_list);
 	}
 }
@@ -294,7 +294,7 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
 		}
 		mutex_unlock(&esw->offloads.encap_tbl_lock);
 
-		mlx5e_put_encap_flow_list(priv, &flow_list);
+		mlx5e_put_flow_list(priv, &flow_list);
 		if (neigh_used) {
 			/* release current encap before breaking the loop */
 			mlx5e_encap_put(priv, e);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e6150c7597f0..c5ecb9e4e767 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1451,7 +1451,7 @@ struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow)
 }
 
 /* Iterate over tmp_list of flows attached to flow_list head. */
-void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list_head *flow_list)
+void mlx5e_put_flow_list(struct mlx5e_priv *priv, struct list_head *flow_list)
 {
 	struct mlx5e_tc_flow *flow, *tmp;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 9042e64a96ca..89003ae7775a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -174,7 +174,7 @@ bool mlx5e_encap_take(struct mlx5e_encap_entry *e);
 void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e);
 
 void mlx5e_take_all_encap_flows(struct mlx5e_encap_entry *e, struct list_head *flow_list);
-void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list_head *flow_list);
+void mlx5e_put_flow_list(struct mlx5e_priv *priv, struct list_head *flow_list);
 
 struct mlx5e_neigh_hash_entry;
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
-- 
2.29.2

