Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296DC3F261A
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhHTE4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232848AbhHTE4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 694316108B;
        Fri, 20 Aug 2021 04:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435325;
        bh=93patY7AWTL7iDBlH51ykHLddHt8CQqNO7jB1cv7Zfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrL5gmXserbD+r9XlO3X+4mNjqTWGnO/T49DnZE1qvQm9UMI+jr45ItHv4hLE2HCf
         T/8try+JxNRBV5OwyTrxf9RUOcCRs4R8ySm1k8mCCn4mpSxz1oFBm5MWdJ4cyiQDRg
         UKjGBuNUU5A1iBAPMaweoRimdRM07RUX8XC1w6M1Oygc8RPfrJNopd/naWbFVl2ft5
         M1zkF4ht6WU4xKKaly7jM9M0BEm92fHOFrR36bxaqpSLEu7fomPGORamOqRQ0JW54R
         fGt0ddu78lpK8VCag51tcRuEcz3iZEscvMNF8Kx+c/UUdcEJnueeuhcItRYAOACy/v
         SwkLCFEBDa8xw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: CT, Use xarray to manage fte ids
Date:   Thu, 19 Aug 2021 21:55:04 -0700
Message-Id: <20210820045515.265297-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

IDR is deprecated. Use xarray instead.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index b1707b86aa16..9609692e5837 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -46,7 +46,7 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_core_dev *dev;
 	const struct net_device *netdev;
 	struct mod_hdr_tbl *mod_hdr_tbl;
-	struct idr fte_ids;
+	struct xarray fte_ids;
 	struct xarray tuple_ids;
 	struct rhashtable zone_ht;
 	struct rhashtable ct_tuples_ht;
@@ -1773,12 +1773,12 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	}
 	ct_flow->ft = ft;
 
-	err = idr_alloc_u32(&ct_priv->fte_ids, ct_flow, &fte_id,
-			    MLX5_FTE_ID_MAX, GFP_KERNEL);
+	err = xa_alloc(&ct_priv->fte_ids, &fte_id, ct_flow,
+		       XA_LIMIT(1, MLX5_FTE_ID_MAX), GFP_KERNEL);
 	if (err) {
 		netdev_warn(priv->netdev,
 			    "Failed to allocate fte id, err: %d\n", err);
-		goto err_idr;
+		goto err_xarray;
 	}
 	ct_flow->fte_id = fte_id;
 
@@ -1914,8 +1914,8 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 err_alloc_post:
 	kfree(ct_flow->pre_ct_attr);
 err_alloc_pre:
-	idr_remove(&ct_priv->fte_ids, fte_id);
-err_idr:
+	xa_erase(&ct_priv->fte_ids, fte_id);
+err_xarray:
 	mlx5_tc_ct_del_ft_cb(ct_priv, ft);
 err_ft:
 	kvfree(post_ct_spec);
@@ -2033,7 +2033,7 @@ __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
 		mlx5_tc_rule_delete(priv, ct_flow->post_ct_rule,
 				    ct_flow->post_ct_attr);
 		mlx5_chains_put_chain_mapping(ct_priv->chains, ct_flow->chain_mapping);
-		idr_remove(&ct_priv->fte_ids, ct_flow->fte_id);
+		xa_erase(&ct_priv->fte_ids, ct_flow->fte_id);
 		mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
 	}
 
@@ -2203,7 +2203,7 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 		goto err_post_ct_tbl;
 	}
 
-	idr_init(&ct_priv->fte_ids);
+	xa_init_flags(&ct_priv->fte_ids, XA_FLAGS_ALLOC1);
 	mutex_init(&ct_priv->control_lock);
 	rhashtable_init(&ct_priv->zone_ht, &zone_params);
 	rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params);
@@ -2247,7 +2247,7 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
 	rhashtable_destroy(&ct_priv->zone_ht);
 	mutex_destroy(&ct_priv->control_lock);
-	idr_destroy(&ct_priv->fte_ids);
+	xa_destroy(&ct_priv->fte_ids);
 	kfree(ct_priv);
 }
 
-- 
2.31.1

