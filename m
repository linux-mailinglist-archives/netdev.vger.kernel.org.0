Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8803E51AC
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhHJEAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236937AbhHJEAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 00:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A114060FDA;
        Tue, 10 Aug 2021 03:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567980;
        bh=+wwuvY9UNTFkgFQJ6yxAY8w5RaAndG1QQZuWlHDAfNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHE+4MvJYttnQmA+ZnPQEdLk8xNM+vXnD0kFnAhX/6gqRVs3RJJyl0zJGa2gTwaEg
         hFQiUxVe4Ic3bGPJ+H8eDgfUHL/mjjt9uyQ2aJH15cFcKBSpLX5h5igaYSoFWimjAI
         5sLqvOZAGlVS4XPpOWVbf6KpPnmUWtxkSgtX9xnzPzUVjre6ZcX1X64ItBXeSUp9kr
         aHDOn9pkINV+KEdOaIDeotWpUExOjpDAZ3pJvXSpWFHbr7se8Tq1V8iJnMwcLUEZ3Q
         aWbadWmlRszMerzrqpEDhJxV5ZC1VJ75+aNssCCu+RONapDYJv/k4aBvjSp9yRuFLS
         PKtKXtL65fRRw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/12] net/mlx5: Block switchdev mode while devlink traps are active
Date:   Mon,  9 Aug 2021 20:59:17 -0700
Message-Id: <20210810035923.345745-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Since switchdev mode can't support  devlink traps, verify there are
no active devlink traps before moving eswitch to switchdev mode. If
there are active traps, prevent the switchdev mode configuration.

Fixes: eb3862a0525d ("net/mlx5e: Enable traps according to link state")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 011e766e4f67..3bb71a186004 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -48,6 +48,7 @@
 #include "lib/fs_chains.h"
 #include "en_tc.h"
 #include "en/mapping.h"
+#include "devlink.h"
 
 #define mlx5_esw_for_each_rep(esw, i, rep) \
 	xa_for_each(&((esw)->offloads.vport_reps), i, rep)
@@ -3001,12 +3002,19 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (cur_mlx5_mode == mlx5_mode)
 		goto unlock;
 
-	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
+	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV) {
+		if (mlx5_devlink_trap_get_num_active(esw->dev)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Can't change mode while devlink traps are active");
+			err = -EOPNOTSUPP;
+			goto unlock;
+		}
 		err = esw_offloads_start(esw, extack);
-	else if (mode == DEVLINK_ESWITCH_MODE_LEGACY)
+	} else if (mode == DEVLINK_ESWITCH_MODE_LEGACY) {
 		err = esw_offloads_stop(esw, extack);
-	else
+	} else {
 		err = -EINVAL;
+	}
 
 unlock:
 	mlx5_esw_unlock(esw);
-- 
2.31.1

