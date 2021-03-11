Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24B33380A4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbhCKWhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhCKWhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C7164F8D;
        Thu, 11 Mar 2021 22:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502254;
        bh=QOCIQTlj6mCKctzKcYbsi0/ICt1+lnxtqbWBqyjknNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXGWkm04E5krwRw9Ug/iTQBQXNGHud7U/7qsy2a9JcATIzs6ul1C5Gn3X8rLuc+9Q
         6d9NPc/wtoolQJ4GguksOdondN4Tp7RsW6VnKQnLJ+1jO/MqRbLv9W8WBKMJfXcZ5N
         aPPWhrYEPhNq8CDcO9XrwjZBjZiW+H7aabGTG8fSuAXg6O9kug533b/rMdbqY0Vixi
         gSWnwK53maJzJ4Kl21MYTQ7ylrij3QnCznhPeotDo0v3HsYF1AmRxz78uJA1PhY+a1
         QEqSKm5/CYFL1OAtkPOxGEyZxTMJCNl78Hz8n6bf99KIDcEABI3RbFABph5dvlPkbZ
         yhb/Hk9sYGcjw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Eli Cohen <elic@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Don't skip vport check
Date:   Thu, 11 Mar 2021 14:37:09 -0800
Message-Id: <20210311223723.361301-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Users of mlx5_eswitch_get_vport() are required to check return value
prior to passing mlx5_vport further. Fix all the places to do not skip
that check.

Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index cb1e181f4c6a..7bfc84238b3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -120,7 +120,7 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
 	struct mlx5_vport *vport;
 
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	return vport->dl_port;
+	return IS_ERR(vport) ? ERR_CAST(vport) : vport->dl_port;
 }
 
 int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index aba17835465b..fe1e06d95a12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1141,6 +1141,8 @@ int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 	struct mlx5_vport *vport;
 
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
 
 	if (!vport->qos.enabled)
 		return -EOPNOTSUPP;
@@ -1279,6 +1281,8 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 	int ret;
 
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
 
 	mutex_lock(&esw->state_lock);
 	WARN_ON(vport->enabled);
@@ -1326,6 +1330,8 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	struct mlx5_vport *vport;
 
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return;
 
 	mutex_lock(&esw->state_lock);
 	if (!vport->enabled)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 94cb0217b4f3..703753ac2e02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2554,6 +2554,9 @@ static int esw_create_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 	struct mlx5_vport *vport;
 
 	vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
 	return esw_vport_create_offloads_acl_tables(esw, vport);
 }
 
@@ -2562,6 +2565,9 @@ static void esw_destroy_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 	struct mlx5_vport *vport;
 
 	vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
+	if (IS_ERR(vport))
+		return;
+
 	esw_vport_destroy_offloads_acl_tables(esw, vport);
 }
 
-- 
2.29.2

