Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A70F2D3349
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbgLHUQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731142AbgLHUPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:07 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 01/15] net/mlx5e: Free drop RQ in a dedicated function
Date:   Tue,  8 Dec 2020 11:35:41 -0800
Message-Id: <20201208193555.674504-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

The drop RQ has very limited objects to be freed, and differs
from regular RQs in the context that it is freed from.
Add a dedicated function for it, use it where needed, and remove
the drop_rq-specific checks in the generic function.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c  | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 330201dfe9a4..e88730606da3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -613,14 +613,11 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 static void mlx5e_free_rq(struct mlx5e_rq *rq)
 {
-	struct mlx5e_channel *c = rq->channel;
-	struct bpf_prog *old_prog = NULL;
+	struct bpf_prog *old_prog;
 	int i;
 
-	/* drop_rq has neither channel nor xdp_prog. */
-	if (c)
-		old_prog = rcu_dereference_protected(rq->xdp_prog,
-						     lockdep_is_held(&c->priv->state_lock));
+	old_prog = rcu_dereference_protected(rq->xdp_prog,
+					     lockdep_is_held(&rq->channel->priv->state_lock));
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
@@ -3196,6 +3193,11 @@ int mlx5e_close(struct net_device *netdev)
 	return err;
 }
 
+static void mlx5e_free_drop_rq(struct mlx5e_rq *rq)
+{
+	mlx5_wq_destroy(&rq->wq_ctrl);
+}
+
 static int mlx5e_alloc_drop_rq(struct mlx5_core_dev *mdev,
 			       struct mlx5e_rq *rq,
 			       struct mlx5e_rq_param *param)
@@ -3263,7 +3265,7 @@ int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
 	return 0;
 
 err_free_rq:
-	mlx5e_free_rq(drop_rq);
+	mlx5e_free_drop_rq(drop_rq);
 
 err_destroy_cq:
 	mlx5e_destroy_cq(cq);
@@ -3277,7 +3279,7 @@ int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
 void mlx5e_close_drop_rq(struct mlx5e_rq *drop_rq)
 {
 	mlx5e_destroy_rq(drop_rq);
-	mlx5e_free_rq(drop_rq);
+	mlx5e_free_drop_rq(drop_rq);
 	mlx5e_destroy_cq(&drop_rq->cq);
 	mlx5e_free_cq(&drop_rq->cq);
 }
-- 
2.26.2

