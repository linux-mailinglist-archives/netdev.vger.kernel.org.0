Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A357842A537
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbhJLNR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236720AbhJLNRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:17:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9D58610C7;
        Tue, 12 Oct 2021 13:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634044547;
        bh=7eBB3Rs2L8djkV/T9wam6oB1DyFLMH2beGvo55O0y9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8TMjRU1LS67HcIMsIgRy8ACID7p4c2ZJE6N+R0oe9vUq0kvXap961lbs+GLTZ2Lc
         Bgd31uQ/zaVVa/9Fx5WEj0j77zLM+Psl0FsTVC+3AQwVx9Ptp+wHihVE+fGrKSQot/
         tJG1wICy4GwgoxDaQauDacnQvMdqNxBO1HVR9hcsdXPajjn//hzbQvu+yIGTvheBkD
         6XjvyyRl2CuFRv9tE324ngliEo4SNTap/a6nBpeFDKXCTclbDaROtlgy7/CwyExEvH
         xbBPiT1usvqCnqz1Jedk9yy+XfhhoZHM+j22lN9HyLIdJqPFrp0C46CJG32T4afKhn
         Jjn1855DLuxBw==
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
Subject: [PATCH net-next v4 5/6] net/mlx5: Set devlink reload feature bit for supported devices only
Date:   Tue, 12 Oct 2021 16:15:25 +0300
Message-Id: <146ef10bd26c37d5099f9b9b8007d21f69327408.1634044267.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634044267.git.leonro@nvidia.com>
References: <cover.1634044267.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Mulitport slave device doesn't support devlink reload, so instead of
complicating initialization flow with devlink_reload_enable() which
will be removed in next patch, don't set DEVLINK_F_RELOAD feature bit
for such devices.

This fixes an error when reload counters exposed (and equal zero) for
the mode that is not supported at all.

Fixes: d89ddaae1766 ("net/mlx5: Disable devlink reload for multi port slave device")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index fa98b7b95990..a85341a41cd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -796,6 +796,7 @@ static void mlx5_devlink_traps_unregister(struct devlink *devlink)
 
 int mlx5_devlink_register(struct devlink *devlink)
 {
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
 	err = devlink_params_register(devlink, mlx5_devlink_params,
@@ -813,7 +814,9 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
+	if (!mlx5_core_is_mp_slave(dev))
+		devlink_set_features(devlink, DEVLINK_F_RELOAD);
+
 	return 0;
 
 traps_reg_err:
-- 
2.31.1

