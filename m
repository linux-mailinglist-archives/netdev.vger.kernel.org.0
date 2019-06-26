Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDC156C2B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfFZOgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:33 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59975 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728172AbfFZOgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:23 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:17 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGYC027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 14/16] net/mlx5e: Encapsulate open/close queues into a function
Date:   Wed, 26 Jun 2019 17:35:36 +0300
Message-Id: <1561559738-4213-15-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Create new functions mlx5e_{open,close}_queues to encapsulate opening
and closing RQs and SQs, and call the new functions from
mlx5e_{open,close}_channel. It simplifies the existing functions a bit
and prepares them for the upcoming AF_XDP changes.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 125 +++++++++++++---------
 1 file changed, 73 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 96fb3fa32d63..c099f5a6124e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1768,49 +1768,16 @@ static void mlx5e_free_xps_cpumask(struct mlx5e_channel *c)
 	free_cpumask_var(c->xps_cpumask);
 }
 
-static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
-			      struct mlx5e_params *params,
-			      struct mlx5e_channel_param *cparam,
-			      struct mlx5e_channel **cp)
+static int mlx5e_open_queues(struct mlx5e_channel *c,
+			     struct mlx5e_params *params,
+			     struct mlx5e_channel_param *cparam)
 {
-	int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
 	struct net_dim_cq_moder icocq_moder = {0, 0};
-	struct net_device *netdev = priv->netdev;
-	struct mlx5e_channel *c;
-	unsigned int irq;
 	int err;
-	int eqn;
-
-	err = mlx5_vector2eqn(priv->mdev, ix, &eqn, &irq);
-	if (err)
-		return err;
-
-	c = kvzalloc_node(sizeof(*c), GFP_KERNEL, cpu_to_node(cpu));
-	if (!c)
-		return -ENOMEM;
-
-	c->priv     = priv;
-	c->mdev     = priv->mdev;
-	c->tstamp   = &priv->tstamp;
-	c->ix       = ix;
-	c->cpu      = cpu;
-	c->pdev     = priv->mdev->device;
-	c->netdev   = priv->netdev;
-	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
-	c->num_tc   = params->num_tc;
-	c->xdp      = !!params->xdp_prog;
-	c->stats    = &priv->channel_stats[ix].ch;
-	c->irq_desc = irq_to_desc(irq);
-
-	err = mlx5e_alloc_xps_cpumask(c, params);
-	if (err)
-		goto err_free_channel;
-
-	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll, 64);
 
 	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->icosq.cq);
 	if (err)
-		goto err_napi_del;
+		return err;
 
 	err = mlx5e_open_tx_cqs(c, params, cparam);
 	if (err)
@@ -1855,8 +1822,6 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	if (err)
 		goto err_close_rq;
 
-	*cp = c;
-
 	return 0;
 
 err_close_rq:
@@ -1874,6 +1839,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 
 err_disable_napi:
 	napi_disable(&c->napi);
+
 	if (c->xdp)
 		mlx5e_close_cq(&c->rq_xdpsq.cq);
 
@@ -1889,6 +1855,73 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 err_close_icosq_cq:
 	mlx5e_close_cq(&c->icosq.cq);
 
+	return err;
+}
+
+static void mlx5e_close_queues(struct mlx5e_channel *c)
+{
+	mlx5e_close_xdpsq(&c->xdpsq);
+	mlx5e_close_rq(&c->rq);
+	if (c->xdp)
+		mlx5e_close_xdpsq(&c->rq_xdpsq);
+	mlx5e_close_sqs(c);
+	mlx5e_close_icosq(&c->icosq);
+	napi_disable(&c->napi);
+	if (c->xdp)
+		mlx5e_close_cq(&c->rq_xdpsq.cq);
+	mlx5e_close_cq(&c->rq.cq);
+	mlx5e_close_cq(&c->xdpsq.cq);
+	mlx5e_close_tx_cqs(c);
+	mlx5e_close_cq(&c->icosq.cq);
+}
+
+static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
+			      struct mlx5e_params *params,
+			      struct mlx5e_channel_param *cparam,
+			      struct mlx5e_channel **cp)
+{
+	int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
+	struct net_device *netdev = priv->netdev;
+	struct mlx5e_channel *c;
+	unsigned int irq;
+	int err;
+	int eqn;
+
+	err = mlx5_vector2eqn(priv->mdev, ix, &eqn, &irq);
+	if (err)
+		return err;
+
+	c = kvzalloc_node(sizeof(*c), GFP_KERNEL, cpu_to_node(cpu));
+	if (!c)
+		return -ENOMEM;
+
+	c->priv     = priv;
+	c->mdev     = priv->mdev;
+	c->tstamp   = &priv->tstamp;
+	c->ix       = ix;
+	c->cpu      = cpu;
+	c->pdev     = priv->mdev->device;
+	c->netdev   = priv->netdev;
+	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
+	c->num_tc   = params->num_tc;
+	c->xdp      = !!params->xdp_prog;
+	c->stats    = &priv->channel_stats[ix].ch;
+	c->irq_desc = irq_to_desc(irq);
+
+	err = mlx5e_alloc_xps_cpumask(c, params);
+	if (err)
+		goto err_free_channel;
+
+	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll, 64);
+
+	err = mlx5e_open_queues(c, params, cparam);
+	if (unlikely(err))
+		goto err_napi_del;
+
+	*cp = c;
+
+	return 0;
+
 err_napi_del:
 	netif_napi_del(&c->napi);
 	mlx5e_free_xps_cpumask(c);
@@ -1920,19 +1953,7 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 
 static void mlx5e_close_channel(struct mlx5e_channel *c)
 {
-	mlx5e_close_xdpsq(&c->xdpsq);
-	mlx5e_close_rq(&c->rq);
-	if (c->xdp)
-		mlx5e_close_xdpsq(&c->rq_xdpsq);
-	mlx5e_close_sqs(c);
-	mlx5e_close_icosq(&c->icosq);
-	napi_disable(&c->napi);
-	if (c->xdp)
-		mlx5e_close_cq(&c->rq_xdpsq.cq);
-	mlx5e_close_cq(&c->rq.cq);
-	mlx5e_close_cq(&c->xdpsq.cq);
-	mlx5e_close_tx_cqs(c);
-	mlx5e_close_cq(&c->icosq.cq);
+	mlx5e_close_queues(c);
 	netif_napi_del(&c->napi);
 	mlx5e_free_xps_cpumask(c);
 
-- 
1.8.3.1

