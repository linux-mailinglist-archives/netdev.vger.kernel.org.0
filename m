Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3830227642A
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgIWWsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgIWWsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:48:41 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C64D2388A;
        Wed, 23 Sep 2020 22:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600901320;
        bh=+hUWoqh4w38JR/7l3MCp2vzKmrHehetKBU+MRghsRo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+IMI23e+GYCaaViZNYm8ZV19yoC9bbj0pZbo2hBhK0Bpt3AGY/d5u9RnuClo2Riv
         TGpQDbwtqGqcysOVdjVz8n+UfvIc9+RTN+fJKnnanK1HCNA3DwkmDiI4xvpN4nOklF
         zMqFSCBnpz7NytYTu25rQ1ejD6NWZLrUVeXTBgYI=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 07/15] net/mlx5e: rework ct offload init messages
Date:   Wed, 23 Sep 2020 15:48:16 -0700
Message-Id: <20200923224824.67340-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923224824.67340-1-saeed@kernel.org>
References: <20200923224824.67340-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

The changes are:
- Use mlx5_core print macros instead of netdev_warn since
  netdev is not always initialized at that stage.

- Print a warning message in case the issue is with lack of
  support for CT offload without indicating an error.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 39 ++++++++-----------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 9509f8674e5a..bc7589711357 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1803,24 +1803,14 @@ mlx5_tc_ct_init_check_support(struct mlx5_eswitch *esw,
 	return 0;
 }
 
-static void
-mlx5_tc_ct_init_err(struct mlx5e_rep_priv *rpriv, const char *msg, int err)
-{
-	if (msg)
-		netdev_warn(rpriv->netdev,
-			    "tc ct offload not supported, %s, err: %d\n",
-			    msg, err);
-	else
-		netdev_warn(rpriv->netdev,
-			    "tc ct offload not supported, err: %d\n",
-			    err);
-}
+#define INIT_ERR_PREFIX "tc ct offload init failed"
 
 int
 mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 {
 	struct mlx5_tc_ct_priv *ct_priv;
 	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_core_dev *dev;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
 	const char *msg;
@@ -1828,19 +1818,20 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 
 	rpriv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
 	priv = netdev_priv(rpriv->netdev);
-	esw = priv->mdev->priv.eswitch;
+	dev = priv->mdev;
+	esw = dev->priv.eswitch;
 
 	err = mlx5_tc_ct_init_check_support(esw, &msg);
 	if (err) {
-		mlx5_tc_ct_init_err(rpriv, msg, err);
+		mlx5_core_warn(dev,
+			       "tc ct offload not supported, %s\n",
+			       msg);
 		goto err_support;
 	}
 
 	ct_priv = kzalloc(sizeof(*ct_priv), GFP_KERNEL);
-	if (!ct_priv) {
-		mlx5_tc_ct_init_err(rpriv, NULL, -ENOMEM);
+	if (!ct_priv)
 		goto err_alloc;
-	}
 
 	ct_priv->zone_mapping = mapping_create(sizeof(u16), 0, true);
 	if (IS_ERR(ct_priv->zone_mapping)) {
@@ -1859,23 +1850,27 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 	ct_priv->ct = mlx5_chains_create_global_table(esw_chains(esw));
 	if (IS_ERR(ct_priv->ct)) {
 		err = PTR_ERR(ct_priv->ct);
-		mlx5_tc_ct_init_err(rpriv, "failed to create ct table", err);
+		mlx5_core_warn(dev,
+			       "%s, failed to create ct table err: %d\n",
+			       INIT_ERR_PREFIX, err);
 		goto err_ct_tbl;
 	}
 
 	ct_priv->ct_nat = mlx5_chains_create_global_table(esw_chains(esw));
 	if (IS_ERR(ct_priv->ct_nat)) {
 		err = PTR_ERR(ct_priv->ct_nat);
-		mlx5_tc_ct_init_err(rpriv, "failed to create ct nat table",
-				    err);
+		mlx5_core_warn(dev,
+			       "%s, failed to create ct nat table err: %d\n",
+			       INIT_ERR_PREFIX, err);
 		goto err_ct_nat_tbl;
 	}
 
 	ct_priv->post_ct = mlx5_chains_create_global_table(esw_chains(esw));
 	if (IS_ERR(ct_priv->post_ct)) {
 		err = PTR_ERR(ct_priv->post_ct);
-		mlx5_tc_ct_init_err(rpriv, "failed to create post ct table",
-				    err);
+		mlx5_core_warn(dev,
+			       "%s, failed to create post ct table err: %d\n",
+			       INIT_ERR_PREFIX, err);
 		goto err_post_ct_tbl;
 	}
 
-- 
2.26.2

