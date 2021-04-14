Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A8A35FE52
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbhDNXQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233061AbhDNXQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8F2E611CC;
        Wed, 14 Apr 2021 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442172;
        bh=zkggHjS2SLIru19Y3l9SQjQUyTCqTvGaIw9d87uhwCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXZ1bTgF/FKpE9CwapIqA5LQYvw57PQrTy2YDiIOmwBNoSuLoDDI/egxDhofY5LbT
         +X6YmoauL4VSbE8DoOfjQNv1OATItDx+2BZBf+/L671IcuAD7MH89Q6ymU0556AORJ
         Zz7pGq31rcjSMNzeU2uS6JN3f+fKBv3qXhGiaV8cwzVQmlz+sO/ZFwQkbADEETbp8N
         yXTfWiejOL+JJ0tARg36sVou+VkE0CBHIMo/2MhPIDicpF6ffjkmrGIsVDO1Iy2N4e
         gCEs2D50jP6fg8hFzh1lX8ARkxun1rFbrhmUyQcU9Nx5C5/SVcsnCBPO18u2GGPrAn
         YEpxaSh7kG4Gg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/3] net/mlx5: Fix setting of devlink traps in switchdev mode
Date:   Wed, 14 Apr 2021 16:16:08 -0700
Message-Id: <20210414231610.136376-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414231610.136376-1-saeed@kernel.org>
References: <20210414231610.136376-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Prevent setting of devlink traps on the uplink while in switchdev mode.
In this mode, it is the SW switch responsibility to handle both packets
with a mismatch in destination MAC or VLAN ID. Therefore, there are no
flow steering tables to trap undesirable packets and driver crashes upon
setting a trap.

Fixes: 241dc159391f ("net/mlx5: Notify on trap action by blocking event")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d7d8a68ef23d..d0f9d3cee97d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -246,6 +246,11 @@ static int mlx5_devlink_trap_action_set(struct devlink *devlink,
 	struct mlx5_devlink_trap *dl_trap;
 	int err = 0;
 
+	if (is_mdev_switchdev_mode(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Devlink traps can't be set in switchdev mode");
+		return -EOPNOTSUPP;
+	}
+
 	dl_trap = mlx5_find_trap_by_id(dev, trap->id);
 	if (!dl_trap) {
 		mlx5_core_err(dev, "Devlink trap: Set action on invalid trap id 0x%x", trap->id);
-- 
2.30.2

