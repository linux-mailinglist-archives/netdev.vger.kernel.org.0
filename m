Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A1242034E
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhJCSPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231432AbhJCSOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 14:14:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6746561354;
        Sun,  3 Oct 2021 18:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633284742;
        bh=9DFdhAX8N7+habw3ZKrzONe1qGnmgGDQssi2lRZsN38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHXBJ8ZwzlRpZ7SFElFjeioOFoemKS9c45o0COT+B9cqHy8jw5RK9VSXwuwddXL+R
         PRsdQ4d4IA3qIbllNavDj+lbUseEYZ06d581OSvexvOBP4pkOqjWsU5PTxJVnnORJP
         roHm1KHnjuI78vQJ3zVTLQIHkN9CLqh+QmXMxBw1wbbQKexGGNoKSwT2K0aY+UOEPN
         tn+D4n8qTvJveXzz6FzvhMCeQ8V4+QANIXwfXvnhu5xd1YbDh265ieRjjO/wNmKBWO
         b186DId10NTG2pcJs+JrcNwQs+Lm0vHiV+quGaBIP7rRZ6pjuR3OLEf2Yy7Q73FPBv
         rp6NWB0PNQNiQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v2 4/5] net/mlx5: Register separate reload devlink ops for multiport device
Date:   Sun,  3 Oct 2021 21:12:05 +0300
Message-Id: <55e53f5c557156ad3f469ee3dfe5731373b61b84.1633284302.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633284302.git.leonro@nvidia.com>
References: <cover.1633284302.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Mulitport slave device doesn't support devlink reload, so instead of
complicating initialization flow with devlink_reload_enable() which
will be removed in next patch, set specialized devlink ops callbacks
for reload operations.

This fixes an error when reload counters exposed (and equal zero) for
the mode that is not supported at all.

Fixes: d89ddaae1766 ("net/mlx5: Disable devlink reload for multi port slave device")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index b9a6cea03951..2b769e8c97e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -314,14 +314,17 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
+	.trap_init = mlx5_devlink_trap_init,
+	.trap_fini = mlx5_devlink_trap_fini,
+	.trap_action_set = mlx5_devlink_trap_action_set,
+};
+
+static struct devlink_ops mlx5_devlink_reload = {
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_limits = BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
-	.trap_init = mlx5_devlink_trap_init,
-	.trap_fini = mlx5_devlink_trap_fini,
-	.trap_action_set = mlx5_devlink_trap_action_set,
 };
 
 void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, struct sk_buff *skb,
@@ -796,6 +799,7 @@ static void mlx5_devlink_traps_unregister(struct devlink *devlink)
 
 int mlx5_devlink_register(struct devlink *devlink)
 {
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
 	err = devlink_params_register(devlink, mlx5_devlink_params,
@@ -813,6 +817,9 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	if (!mlx5_core_is_mp_slave(dev))
+		devlink_set_ops(devlink, &mlx5_devlink_reload);
+
 	return 0;
 
 traps_reg_err:
-- 
2.31.1

