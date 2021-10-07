Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5433424D8A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbhJGG5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240319AbhJGG5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 02:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05F2A61245;
        Thu,  7 Oct 2021 06:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633589741;
        bh=a+rBVbxC2su0WUjhwNHbC68VaTfhjtVchRK6aUlv3+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL7LR2CyRAtyAo6D9BbGnZ8umgCsy3HOpv5y9VUzs6dnt8NsC+E0vDqNNF/yrvOyA
         IMG0TRbu2Kof/Fn65gA5XCpFhzkqaJ4A5LE2/qc3SpFIQGR4iG/mR8jPrGOMFmD3eW
         6XyKhtMzBnfaApV6epMuwVPpL0v7LuAHccSzvLDT+XC/DfVSgTSCGMQbu/a1v6yX20
         /+DITDlDVKtvqY1/1owg7Dvg+TPy4rg1iiTTQBZi4sIxFllDFOXJq5/7SKq8ygEpuU
         t3OBbTnOea/ElHlGro6hxlW6lH+FYj/2unOW1v1rnzRswgRB5Guv1Qz4rW4zWK9pV8
         Pm0yk4mg83o3Q==
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
Subject: [PATCH net-next v3 4/5] net/mlx5: Separate reload devlink ops for multiport device
Date:   Thu,  7 Oct 2021 09:55:18 +0300
Message-Id: <7916d08b6cdcd946e7e2a243798faec99f90fb12.1633589385.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633589385.git.leonro@nvidia.com>
References: <cover.1633589385.git.leonro@nvidia.com>
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
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 22c4afbc77dc..2eefed353e0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -799,6 +799,7 @@ static void mlx5_devlink_traps_unregister(struct devlink *devlink)
 
 int mlx5_devlink_register(struct devlink *devlink)
 {
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
 	err = devlink_params_register(devlink, mlx5_devlink_params,
@@ -816,7 +817,9 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
-	devlink_set_reload_ops(devlink, &mlx5_devlink_reload_ops);
+	if (!mlx5_core_is_mp_slave(dev))
+		devlink_set_reload_ops(devlink, &mlx5_devlink_reload_ops);
+
 	return 0;
 
 traps_reg_err:
-- 
2.31.1

