Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46A2453F91
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhKQEhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233110AbhKQEhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D4F6613A2;
        Wed, 17 Nov 2021 04:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123651;
        bh=A+5PETo5MR9vCScCQQmU0qbqMXgepGG2kkXw8HPUlbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMpIpHo8cGkc7Q9JTZJiKfyRoXTpv3NiL7VR0m/LlvYJ72XGMNYCO4dz7AXJjZPkK
         xZb3JorY6ZdrsTsh2iSU6FqCeP+bFxgTLVfnhhqrTtmxuGhlQrXtPaT+mhekSM06ke
         AebDkiUTEJlvvAGnJx2spuywLQ7/J5PfVTMJrnzCUBJVBKio4awMRlPNRt8u2GLKuy
         6HmQFGi68HnRMpBxRtl3iOTkQBBHifDvbGV/YYEjWR5KQMRyA4sxIJem20Rg+6NJbt
         lP4r7H4P4i0Q1/h1ecRo55uS9tqhWyecNNKxcZW8cZd3Hu6DmkLI2o5Qb6QDzamqKB
         VtLyn/ZSv7cUQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 12/15] net/mlx5: E-switch, Reuse mlx5_eswitch_set_vport_mac
Date:   Tue, 16 Nov 2021 20:33:54 -0800
Message-Id: <20211117043357.345072-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

mlx5_eswitch_set_vport_mac() routine already does necessary checks which
are duplicated in implementation of
mlx5_devlink_port_function_hw_addr_set().

Hence, reuse mlx5_eswitch_set_vport_mac() and cut down the code.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b039f8b07d31..c0526fc27ad6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1732,9 +1732,7 @@ int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 					   struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw;
-	struct mlx5_vport *vport;
 	u16 vport_num;
-	int err;
 
 	esw = mlx5_devlink_eswitch_get(port->devlink);
 	if (IS_ERR(esw)) {
@@ -1747,16 +1745,8 @@ int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support set hw_addr");
 		return -EINVAL;
 	}
-	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	if (IS_ERR(vport)) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
-		return PTR_ERR(vport);
-	}
 
-	mutex_lock(&esw->state_lock);
-	err = mlx5_esw_set_vport_mac_locked(esw, vport, hw_addr);
-	mutex_unlock(&esw->state_lock);
-	return err;
+	return mlx5_eswitch_set_vport_mac(esw, vport_num, hw_addr);
 }
 
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
-- 
2.31.1

