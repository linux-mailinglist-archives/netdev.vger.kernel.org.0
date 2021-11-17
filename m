Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B248453F90
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhKQEhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhKQEhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21DE361155;
        Wed, 17 Nov 2021 04:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123651;
        bh=Dr/RM5IMWN97wlWq6QEcpwKh6cRWK6NlljFkbHtJSc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXxOQlJ4EqfFlDBY6tVP8oFI+0pDDnZZCa7euxyuf7rZGS1RZ239X6PfIhJUNZ707
         1/MNbSPF0BCN54/2/zcdYKv8mOEiV1hV6YU05yXtQO5h1ZPGNNmtGl1ag5A+v8OIGQ
         Yi9uZ0CwBLh8NfYbFTaLQtl2Mb2F7jZdpRA7oPJOdTWXjUqiX3i+9+kWH1OQqdU8H7
         7HoBRx7L5jYDPNgj3NlahiQUntEdDIUr4hQko6ASVgohyDvdSihOTaibIZSnw9TcTy
         omVK4CNBecP6zTRUSdDYrpdCTSVwSGxNSxLaqQmSgiXlMyu/d+uPxM4R4tp6YQpt52
         1FOddpOsfPRnQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 11/15] net/mlx5: E-switch, Remove vport enabled check
Date:   Tue, 16 Nov 2021 20:33:53 -0800
Message-Id: <20211117043357.345072-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

An eswitch vport of the devlink port is always enabled before a
devlink port is registered. And a eswitch vport is always disabled
after a devlink port is unregistered.
Hence avoid the vport enabled check in the devlink callback routine.
Such check is only applicable in the legacy SR-IOV callbacks.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Sunil Sudhakar Rani <sunrani@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c   | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index ec136b499204..b039f8b07d31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1704,7 +1704,6 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 {
 	struct mlx5_eswitch *esw;
 	struct mlx5_vport *vport;
-	int err = -EOPNOTSUPP;
 	u16 vport_num;
 
 	esw = mlx5_devlink_eswitch_get(port->devlink);
@@ -1722,13 +1721,10 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 	}
 
 	mutex_lock(&esw->state_lock);
-	if (vport->enabled) {
-		ether_addr_copy(hw_addr, vport->info.mac);
-		*hw_addr_len = ETH_ALEN;
-		err = 0;
-	}
+	ether_addr_copy(hw_addr, vport->info.mac);
+	*hw_addr_len = ETH_ALEN;
 	mutex_unlock(&esw->state_lock);
-	return err;
+	return 0;
 }
 
 int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
@@ -1737,8 +1733,8 @@ int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 {
 	struct mlx5_eswitch *esw;
 	struct mlx5_vport *vport;
-	int err = -EOPNOTSUPP;
 	u16 vport_num;
+	int err;
 
 	esw = mlx5_devlink_eswitch_get(port->devlink);
 	if (IS_ERR(esw)) {
@@ -1758,10 +1754,7 @@ int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 	}
 
 	mutex_lock(&esw->state_lock);
-	if (vport->enabled)
-		err = mlx5_esw_set_vport_mac_locked(esw, vport, hw_addr);
-	else
-		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
+	err = mlx5_esw_set_vport_mac_locked(esw, vport, hw_addr);
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
-- 
2.31.1

