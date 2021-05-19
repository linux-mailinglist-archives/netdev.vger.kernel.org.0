Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E17388747
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241518AbhESGHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238146AbhESGH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39637613AD;
        Wed, 19 May 2021 06:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404367;
        bh=llFr4F2UGZWhuMSZ3QUVxCo0lBZbcydnsxLp5MzYasM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IX1ThkO4yJhorcFWKIMxKlwPgwFRo7Rj6GWfAu7yTgEsBXh2FWlqP0VVB9dvtLtJ1
         qh6ijnT4MP7AbsBzrFNUymac7VjfZR/CkAkXg7JcLbtXvT4WOupT+1g6ARgCR4pgOR
         2d093zn29l+LfLSPPaFeBCtLtvFXJ03doW/lGV4R+MAzFcblQLH5EbUODbr1Kpm+Si
         p9Fksk+Wi5WhlqXXFmteiYgHm0U/bef698TwM4kFAOtUyHutQ+HjHQNFxqfeNUEB7G
         shLmP+QN78AQULtWNEIEz254W2qV8hGJ2Xjf2lBLqGAmwATg50NlHI/Qp5kAYZ8udp
         E3pmQosZ9QlQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/16] net/mlx5: SF, Fix show state inactive when its inactivated
Date:   Tue, 18 May 2021 23:05:12 -0700
Message-Id: <20210519060523.17875-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

When a SF is inactivated and when it is in a TEARDOWN_REQUEST
state, driver still returns its state as active. This is incorrect.
Fix it by treating TEARDOWN_REQEUST as inactive state. When a SF
is still attached to the driver, on user request to reactivate EINVAL
error is returned. Inform user about it with better code EBUSY and
informative error message.

Fixes: 6a3273217469 ("net/mlx5: SF, Port function state change support")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/sf/devlink.c   | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index a8e73c9ed1ea..1be048769309 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -136,10 +136,10 @@ static enum devlink_port_fn_state mlx5_sf_to_devlink_state(u8 hw_state)
 	switch (hw_state) {
 	case MLX5_VHCA_STATE_ACTIVE:
 	case MLX5_VHCA_STATE_IN_USE:
-	case MLX5_VHCA_STATE_TEARDOWN_REQUEST:
 		return DEVLINK_PORT_FN_STATE_ACTIVE;
 	case MLX5_VHCA_STATE_INVALID:
 	case MLX5_VHCA_STATE_ALLOCATED:
+	case MLX5_VHCA_STATE_TEARDOWN_REQUEST:
 	default:
 		return DEVLINK_PORT_FN_STATE_INACTIVE;
 	}
@@ -192,14 +192,17 @@ int mlx5_devlink_sf_port_fn_state_get(struct devlink *devlink, struct devlink_po
 	return err;
 }
 
-static int mlx5_sf_activate(struct mlx5_core_dev *dev, struct mlx5_sf *sf)
+static int mlx5_sf_activate(struct mlx5_core_dev *dev, struct mlx5_sf *sf,
+			    struct netlink_ext_ack *extack)
 {
 	int err;
 
 	if (mlx5_sf_is_active(sf))
 		return 0;
-	if (sf->hw_state != MLX5_VHCA_STATE_ALLOCATED)
-		return -EINVAL;
+	if (sf->hw_state != MLX5_VHCA_STATE_ALLOCATED) {
+		NL_SET_ERR_MSG_MOD(extack, "SF is inactivated but it is still attached");
+		return -EBUSY;
+	}
 
 	err = mlx5_cmd_sf_enable_hca(dev, sf->hw_fn_id);
 	if (err)
@@ -226,7 +229,8 @@ static int mlx5_sf_deactivate(struct mlx5_core_dev *dev, struct mlx5_sf *sf)
 
 static int mlx5_sf_state_set(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 			     struct mlx5_sf *sf,
-			     enum devlink_port_fn_state state)
+			     enum devlink_port_fn_state state,
+			     struct netlink_ext_ack *extack)
 {
 	int err = 0;
 
@@ -234,7 +238,7 @@ static int mlx5_sf_state_set(struct mlx5_core_dev *dev, struct mlx5_sf_table *ta
 	if (state == mlx5_sf_to_devlink_state(sf->hw_state))
 		goto out;
 	if (state == DEVLINK_PORT_FN_STATE_ACTIVE)
-		err = mlx5_sf_activate(dev, sf);
+		err = mlx5_sf_activate(dev, sf, extack);
 	else if (state == DEVLINK_PORT_FN_STATE_INACTIVE)
 		err = mlx5_sf_deactivate(dev, sf);
 	else
@@ -265,7 +269,7 @@ int mlx5_devlink_sf_port_fn_state_set(struct devlink *devlink, struct devlink_po
 		goto out;
 	}
 
-	err = mlx5_sf_state_set(dev, table, sf, state);
+	err = mlx5_sf_state_set(dev, table, sf, state, extack);
 out:
 	mlx5_sf_table_put(table);
 	return err;
-- 
2.31.1

