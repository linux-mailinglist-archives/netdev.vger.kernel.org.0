Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F72838874C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhESGHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238536AbhESGH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEB8F6139A;
        Wed, 19 May 2021 06:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404370;
        bh=gCLf+KEkQXx0HxdGLek+PXYfewqPtk4IS+zuurD8L8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCzLApiOlsM10zWHkUlsaTAGRT0/qS8G26TwCBiOG0jvoIvVtm/WIEwCrhCihttV/
         kx1i6f7evoUpG6ll4LOLc2U7+w+iKkUtG7hmC8KZe+PI13ECA3wrA+IDC6SAMNKCrf
         jvBqRC3vvCfSQm7/jyR1wwRxkQrBbRWalJo6VvFvWAGfCUw55uz0GNt/pavae8ElCb
         zYAWY7O1mkJBaeI6aDwSAUXvpb2RG20ShCtZ2ebEW7AkIgkZfwMcso06cve2bbrU8+
         b09iyeo3UOsrsrPgnDbduEN58mRZvZdPzBntr3wFoOn1HAoK/ic3FU7XOEneNquESN
         t3GhJKeE8RVuw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/16] net/mlx5e: Fix multipath lag activation
Date:   Tue, 18 May 2021 23:05:17 -0700
Message-Id: <20210519060523.17875-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

When handling FIB_EVENT_ENTRY_REPLACE event for a new multipath route,
lag activation can be missed if a stale (struct lag_mp)->mfi pointer
exists, which was associated with an older multipath route that had been
removed.

Normally, when a route is removed, it triggers mlx5_lag_fib_event(),
which handles FIB_EVENT_ENTRY_DEL and clears mfi pointer. But, if
mlx5_lag_check_prereq() condition isn't met, for example when eswitch is
in legacy mode, the fib event is skipped and mfi pointer becomes stale.

Fix by resetting mfi pointer to NULL every time mlx5_lag_mp_init() is
called.

Fixes: 544fe7c2e654 ("net/mlx5e: Activate HW multipath and handle port affinity based on FIB events")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 2c41a6920264..fd6196b5e163 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -307,6 +307,11 @@ int mlx5_lag_mp_init(struct mlx5_lag *ldev)
 	struct lag_mp *mp = &ldev->lag_mp;
 	int err;
 
+	/* always clear mfi, as it might become stale when a route delete event
+	 * has been missed
+	 */
+	mp->mfi = NULL;
+
 	if (mp->fib_nb.notifier_call)
 		return 0;
 
@@ -335,4 +340,5 @@ void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev)
 	unregister_fib_notifier(&init_net, &mp->fib_nb);
 	destroy_workqueue(mp->wq);
 	mp->fib_nb.notifier_call = NULL;
+	mp->mfi = NULL;
 }
-- 
2.31.1

