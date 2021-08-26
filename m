Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE533F909C
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243762AbhHZWTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 18:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243744AbhHZWTC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 18:19:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 666F46103C;
        Thu, 26 Aug 2021 22:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630016294;
        bh=lnQAeGTn+8M+vYaerizPHMRYbpoc1/SJmABsVzBx88w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCyqju6Hbp/DfZ1EnP2Rvsa1NaptQ9EbeCD/6B87IiGGar8LBCXOI4mMsSxE+AHGH
         IF5yftrbNM0OH4ZGe1k7//fZxEsCMRDw8e1A5T7tvDgdQ7bGdIDHQP2PNDSijfdfpi
         Gg8SQ8q8dHbwPAHC83l8n5jY2j4lLjLGr3HPRrYoVTnGVLsvQaT48WQ9zrt+vpTBLx
         a5nPDBzAj20fXpfxqNiyxnyBeyarW/8m+nwXFgDBv9JHwWlBE3h/vaEFpuOq1rhPOZ
         Ni4b2bUsE+0saUC0/lrC9rBMfL3uyjYAdbWHjli5L1yffKT85Qy/Fr+Ra+9C08Dudq
         +Vf5Fk1rlYo8g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/6] net/mlx5e: Use correct eswitch for stack devices with lag
Date:   Thu, 26 Aug 2021 15:18:09 -0700
Message-Id: <20210826221810.215968-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826221810.215968-1-saeed@kernel.org>
References: <20210826221810.215968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

If link aggregation is used within stack devices driver rejects encap
rules if PF of the VF tunnel device is down. This happens because route
resolved for other PF and its eswitch instance is used to determine
correct vport.
To fix that use devcom feature to retrieve other eswitch instance if
failed to find vport for the 1st eswitch and LAG is active.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c    | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d273758255c3..6eba574c5a36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1338,6 +1338,7 @@ bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device *route_
 int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *route_dev, u16 *vport)
 {
 	struct mlx5e_priv *out_priv, *route_priv;
+	struct mlx5_devcom *devcom = NULL;
 	struct mlx5_core_dev *route_mdev;
 	struct mlx5_eswitch *esw;
 	u16 vhca_id;
@@ -1349,7 +1350,24 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 	route_mdev = route_priv->mdev;
 
 	vhca_id = MLX5_CAP_GEN(route_mdev, vhca_id);
+	if (mlx5_lag_is_active(out_priv->mdev)) {
+		/* In lag case we may get devices from different eswitch instances.
+		 * If we failed to get vport num, it means, mostly, that we on the wrong
+		 * eswitch.
+		 */
+		err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+		if (err != -ENOENT)
+			return err;
+
+		devcom = out_priv->mdev->priv.devcom;
+		esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+		if (!esw)
+			return -ENODEV;
+	}
+
 	err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
+	if (devcom)
+		mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 	return err;
 }
 
-- 
2.31.1

