Return-Path: <netdev+bounces-5202-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF40171036E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:49:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AEAA280D73
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB37F1FB0;
	Thu, 25 May 2023 03:48:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4636A23C3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28BBC433A1;
	Thu, 25 May 2023 03:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986533;
	bh=ldBR4MzDgI2wWB4UGDy3VELkdJZCNpln8VB7FZdqqxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0C5v8VO+yz/t/XJaqm475xXcQdZUWfX1kM1Q23IQp7DjAl0OGWgtGL4HXKnfur+k
	 ehT7GlHc/qd1w40gffrn2ODs+CVZUG617tu5S9qIOWPjcHYKDhOrmadhrWzJeJkwm2
	 PahWeCaKJdva38w6vr1eWCsYQaM8hUGJiWMUSHHqAwuw5pYCYFREpRJFPRHpPex83M
	 fYH2taiadQTX8TYKZ0iFEJWO33otTJqbXnvp/aIQl/Nesdn/RCJPqCAW+WV1xoiPWQ
	 88XeXTtNnu+wo1l4vn8FEXwtZMf6uC9oJFhkRh68DxuGTEc3wsHfNh/o3lizcbYg8r
	 gCwQ7DWPo58yg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Chris Mi <cmi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: [net 02/17] net/mlx5e: Prevent encap offload when neigh update is running
Date: Wed, 24 May 2023 20:48:32 -0700
Message-Id: <20230525034847.99268-3-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

The cited commit adds a compeletion to remove dependency on rtnl
lock. But it causes a deadlock for multiple encapsulations:

 crash> bt ffff8aece8a64000
 PID: 1514557  TASK: ffff8aece8a64000  CPU: 3    COMMAND: "tc"
  #0 [ffffa6d14183f368] __schedule at ffffffffb8ba7f45
  #1 [ffffa6d14183f3f8] schedule at ffffffffb8ba8418
  #2 [ffffa6d14183f418] schedule_preempt_disabled at ffffffffb8ba8898
  #3 [ffffa6d14183f428] __mutex_lock at ffffffffb8baa7f8
  #4 [ffffa6d14183f4d0] mutex_lock_nested at ffffffffb8baabeb
  #5 [ffffa6d14183f4e0] mlx5e_attach_encap at ffffffffc0f48c17 [mlx5_core]
  #6 [ffffa6d14183f628] mlx5e_tc_add_fdb_flow at ffffffffc0f39680 [mlx5_core]
  #7 [ffffa6d14183f688] __mlx5e_add_fdb_flow at ffffffffc0f3b636 [mlx5_core]
  #8 [ffffa6d14183f6f0] mlx5e_tc_add_flow at ffffffffc0f3bcdf [mlx5_core]
  #9 [ffffa6d14183f728] mlx5e_configure_flower at ffffffffc0f3c1d1 [mlx5_core]
 #10 [ffffa6d14183f790] mlx5e_rep_setup_tc_cls_flower at ffffffffc0f3d529 [mlx5_core]
 #11 [ffffa6d14183f7a0] mlx5e_rep_setup_tc_cb at ffffffffc0f3d714 [mlx5_core]
 #12 [ffffa6d14183f7b0] tc_setup_cb_add at ffffffffb8931bb8
 #13 [ffffa6d14183f810] fl_hw_replace_filter at ffffffffc0dae901 [cls_flower]
 #14 [ffffa6d14183f8d8] fl_change at ffffffffc0db5c57 [cls_flower]
 #15 [ffffa6d14183f970] tc_new_tfilter at ffffffffb8936047
 #16 [ffffa6d14183fac8] rtnetlink_rcv_msg at ffffffffb88c7c31
 #17 [ffffa6d14183fb50] netlink_rcv_skb at ffffffffb8942853
 #18 [ffffa6d14183fbc0] rtnetlink_rcv at ffffffffb88c1835
 #19 [ffffa6d14183fbd0] netlink_unicast at ffffffffb8941f27
 #20 [ffffa6d14183fc18] netlink_sendmsg at ffffffffb8942245
 #21 [ffffa6d14183fc98] sock_sendmsg at ffffffffb887d482
 #22 [ffffa6d14183fcb8] ____sys_sendmsg at ffffffffb887d81a
 #23 [ffffa6d14183fd38] ___sys_sendmsg at ffffffffb88806e2
 #24 [ffffa6d14183fe90] __sys_sendmsg at ffffffffb88807a2
 #25 [ffffa6d14183ff28] __x64_sys_sendmsg at ffffffffb888080f
 #26 [ffffa6d14183ff38] do_syscall_64 at ffffffffb8b9b6a8
 #27 [ffffa6d14183ff50] entry_SYSCALL_64_after_hwframe at ffffffffb8c0007c
 crash> bt 0xffff8aeb07544000
 PID: 1110766  TASK: ffff8aeb07544000  CPU: 0    COMMAND: "kworker/u20:9"
  #0 [ffffa6d14e6b7bd8] __schedule at ffffffffb8ba7f45
  #1 [ffffa6d14e6b7c68] schedule at ffffffffb8ba8418
  #2 [ffffa6d14e6b7c88] schedule_timeout at ffffffffb8baef88
  #3 [ffffa6d14e6b7d10] wait_for_completion at ffffffffb8ba968b
  #4 [ffffa6d14e6b7d60] mlx5e_take_all_encap_flows at ffffffffc0f47ec4 [mlx5_core]
  #5 [ffffa6d14e6b7da0] mlx5e_rep_update_flows at ffffffffc0f3e734 [mlx5_core]
  #6 [ffffa6d14e6b7df8] mlx5e_rep_neigh_update at ffffffffc0f400bb [mlx5_core]
  #7 [ffffa6d14e6b7e50] process_one_work at ffffffffb80acc9c
  #8 [ffffa6d14e6b7ed0] worker_thread at ffffffffb80ad012
  #9 [ffffa6d14e6b7f10] kthread at ffffffffb80b615d
 #10 [ffffa6d14e6b7f50] ret_from_fork at ffffffffb8001b2f

After the first encap is attached, flow will be added to encap
entry's flows list. If neigh update is running at this time, the
following encaps of the flow can't hold the encap_tbl_lock and
sleep. If neigh update thread is waiting for that flow's init_done,
deadlock happens.

Fix it by holding lock outside of the for loop. If neigh update is
running, prevent encap flows from offloading. Since the lock is held
outside of the for loop, concurrent creation of encap entries is not
allowed. So remove unnecessary wait_for_completion call for res_ready.

Fixes: 95435ad7999b ("net/mlx5e: Only access fully initialized flows in neigh update")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 37 ++++++++++---------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index d516227b8fe8..f0c3464f037f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -492,6 +492,19 @@ void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
 	mlx5e_encap_dealloc(priv, e);
 }
 
+static void mlx5e_encap_put_locked(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+	lockdep_assert_held(&esw->offloads.encap_tbl_lock);
+
+	if (!refcount_dec_and_test(&e->refcnt))
+		return;
+	list_del(&e->route_list);
+	hash_del_rcu(&e->encap_hlist);
+	mlx5e_encap_dealloc(priv, e);
+}
+
 static void mlx5e_decap_put(struct mlx5e_priv *priv, struct mlx5e_decap_entry *d)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
@@ -816,6 +829,8 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	uintptr_t hash_key;
 	int err = 0;
 
+	lockdep_assert_held(&esw->offloads.encap_tbl_lock);
+
 	parse_attr = attr->parse_attr;
 	tun_info = parse_attr->tun_info[out_index];
 	mpls_info = &parse_attr->mpls_info[out_index];
@@ -829,7 +844,6 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 
 	hash_key = hash_encap_info(&key);
 
-	mutex_lock(&esw->offloads.encap_tbl_lock);
 	e = mlx5e_encap_get(priv, &key, hash_key);
 
 	/* must verify if encap is valid or not */
@@ -840,15 +854,6 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			goto out_err;
 		}
 
-		mutex_unlock(&esw->offloads.encap_tbl_lock);
-		wait_for_completion(&e->res_ready);
-
-		/* Protect against concurrent neigh update. */
-		mutex_lock(&esw->offloads.encap_tbl_lock);
-		if (e->compl_result < 0) {
-			err = -EREMOTEIO;
-			goto out_err;
-		}
 		goto attach_flow;
 	}
 
@@ -877,15 +882,12 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	INIT_LIST_HEAD(&e->flows);
 	hash_add_rcu(esw->offloads.encap_tbl, &e->encap_hlist, hash_key);
 	tbl_time_before = mlx5e_route_tbl_get_last_update(priv);
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
 
 	if (family == AF_INET)
 		err = mlx5e_tc_tun_create_header_ipv4(priv, mirred_dev, e);
 	else if (family == AF_INET6)
 		err = mlx5e_tc_tun_create_header_ipv6(priv, mirred_dev, e);
 
-	/* Protect against concurrent neigh update. */
-	mutex_lock(&esw->offloads.encap_tbl_lock);
 	complete_all(&e->res_ready);
 	if (err) {
 		e->compl_result = err;
@@ -920,18 +922,15 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	} else {
 		flow_flag_set(flow, SLOW);
 	}
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
 
 	return err;
 
 out_err:
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
 	if (e)
-		mlx5e_encap_put(priv, e);
+		mlx5e_encap_put_locked(priv, e);
 	return err;
 
 out_err_init:
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
 	kfree(tun_info);
 	kfree(e);
 	return err;
@@ -1027,6 +1026,7 @@ int mlx5e_tc_tun_encap_dests_set(struct mlx5e_priv *priv,
 	struct net_device *encap_dev = NULL;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_priv *out_priv;
+	struct mlx5_eswitch *esw;
 	int out_index;
 	int err = 0;
 
@@ -1037,6 +1037,8 @@ int mlx5e_tc_tun_encap_dests_set(struct mlx5e_priv *priv,
 	esw_attr = attr->esw_attr;
 	*vf_tun = false;
 
+	esw = priv->mdev->priv.eswitch;
+	mutex_lock(&esw->offloads.encap_tbl_lock);
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
 		struct net_device *out_dev;
 		int mirred_ifindex;
@@ -1075,6 +1077,7 @@ int mlx5e_tc_tun_encap_dests_set(struct mlx5e_priv *priv,
 	}
 
 out:
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
 	return err;
 }
 
-- 
2.40.1


