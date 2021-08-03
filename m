Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C0B3DF85A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhHCXUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233362AbhHCXUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31ABC60F9C;
        Tue,  3 Aug 2021 23:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032819;
        bh=V5VFVrJWUkXo8/cOXZnkCjvTJpHkG/7Y51NWhGHWV0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3yvlFpQsrpwgSNYYBMJhEqsuaaVHjjFSSd0KM6wRTK4L7vnNA+rhq7XyndnIeZs4
         v24zTCDjOAVAJMB/tXzeZmCLqMD0O0MJRVugGV0+aOMAHJuwJtAhhrtizpZ7Hx1iPO
         EYH6Lj2FjCK09cTg/CqywJI3G/nC1mtYBo9GFewqewoxExMydHX5890VWHrEkkpESC
         cGNqXnn1Vvo9Ryw4YN6hrZ4mOFw8+bSybb8m4PE6gNVRbCVVvmEZvkHp3N/9nY6g7Z
         c9KRmIQzQrF5Y9wJ0YQPtW0WZu09yJKH9FBgcxwFzqbG4RtE40j8swGDX/NAxy86N6
         TaSDfRo513fQA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH mlx5-next 04/14] {net, RDMA}/mlx5: Extend send to vport rules
Date:   Tue,  3 Aug 2021 16:19:49 -0700
Message-Id: <20210803231959.26513-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

In shared FDB there is only one eswitch which is active and it receives
traffic from all representors and all vports in the HCA.

While the Ethernet representor will always reside on its native PF
the IB representor will not. Extend send to vport rule creation to
support such flows. Need to account for source vport that sends the
traffic (on which the representors resides) and the target eswitch
the traffic which reach.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c                        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c           | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 +++--
 include/linux/mlx5/eswitch.h                               | 1 +
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index b25e0b33a11a..bf5a6e4d1c03 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -123,7 +123,7 @@ struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 
 	rep = dev->port[port - 1].rep;
 
-	return mlx5_eswitch_add_send_to_vport_rule(esw, rep, sq->base.mqp.qpn);
+	return mlx5_eswitch_add_send_to_vport_rule(esw, esw, rep, sq->base.mqp.qpn);
 }
 
 static int mlx5r_rep_probe(struct auxiliary_device *adev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index bf94bcb6fa5d..1d016cc64015 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -337,7 +337,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 		}
 
 		/* Add re-inject rule to the PF/representor sqs */
-		flow_rule = mlx5_eswitch_add_send_to_vport_rule(esw, rep,
+		flow_rule = mlx5_eswitch_add_send_to_vport_rule(esw, esw, rep,
 								sqns_array[i]);
 		if (IS_ERR(flow_rule)) {
 			err = PTR_ERR(flow_rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7579f3402776..12567002997f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -925,6 +925,7 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 
 struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
+				    struct mlx5_eswitch *from_esw,
 				    struct mlx5_eswitch_rep *rep,
 				    u32 sqn)
 {
@@ -943,10 +944,10 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
 	MLX5_SET(fte_match_set_misc, misc, source_sqn, sqn);
 	/* source vport is the esw manager */
-	MLX5_SET(fte_match_set_misc, misc, source_port, rep->esw->manager_vport);
+	MLX5_SET(fte_match_set_misc, misc, source_port, from_esw->manager_vport);
 	if (MLX5_CAP_ESW(on_esw->dev, merged_eswitch))
 		MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id,
-			 MLX5_CAP_GEN(rep->esw->dev, vhca_id));
+			 MLX5_CAP_GEN(from_esw->dev, vhca_id));
 
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
 	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_sqn);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index c2a34ff85188..0bfcf7b8ecf9 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -63,6 +63,7 @@ struct mlx5_eswitch_rep *mlx5_eswitch_vport_rep(struct mlx5_eswitch *esw,
 void *mlx5_eswitch_uplink_get_proto_dev(struct mlx5_eswitch *esw, u8 rep_type);
 struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
+				    struct mlx5_eswitch *from_esw,
 				    struct mlx5_eswitch_rep *rep, u32 sqn);
 
 #ifdef CONFIG_MLX5_ESWITCH
-- 
2.31.1

