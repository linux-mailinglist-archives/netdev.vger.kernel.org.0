Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16933F9098
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243732AbhHZWTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 18:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243685AbhHZWTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 18:19:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78E9060FF2;
        Thu, 26 Aug 2021 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630016292;
        bh=vBt6+pcdSdh460c7TPs8dIPxFMQIOFsWNoqpL6c6Mc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddf+f8t+1OTsfDt40VxMAd500Irg8Sl5d5+/afTw17/IKcz8KqIAvWUyOuKWcgaYp
         +nEBkwf8ApNI9aQ4R+AL1ykOLOkh7+QPT0KSZ+SD6nKS9VYNLlt7fmXo4ct5YyBId9
         ZjUJEkLo/Y/PpvQCa2jT98Ps1ncchMUnEhGVSbVgjId5hPkW7HBRDnen51pXajnl/R
         sqJrgwNS1N/JrvkG+lVp80JQJDPnblA6KoVJeByjxlC9vZGbskbsHj84ilXMwRRo8+
         VWKMP/658ggnYHqyHxuykagdEkLWvFfMXHVkIarlvWyV1gFvFMDNJPFHDvpMoazcjZ
         t86ti+80eCp5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/6] net/mlx5: Lag, fix multipath lag activation
Date:   Thu, 26 Aug 2021 15:18:05 -0700
Message-Id: <20210826221810.215968-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826221810.215968-1-saeed@kernel.org>
References: <20210826221810.215968-1-saeed@kernel.org>
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

Fix by resetting mfi pointer to NULL in mlx5_deactivate_lag().

Fixes: 8a66e4585979 ("net/mlx5: Change ownership model for lag")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 5c043c5cc403..40ef60f562b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -277,6 +277,7 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	int err;
 
 	ldev->flags &= ~MLX5_LAG_MODE_FLAGS;
+	mlx5_lag_mp_reset(ldev);
 
 	MLX5_SET(destroy_lag_in, in, opcode, MLX5_CMD_OP_DESTROY_LAG);
 	err = mlx5_cmd_exec_in(dev0, destroy_lag, in);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index c4bf8b679541..516bfc2bd797 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -302,6 +302,14 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+void mlx5_lag_mp_reset(struct mlx5_lag *ldev)
+{
+	/* Clear mfi, as it might become stale when a route delete event
+	 * has been missed, see mlx5_lag_fib_route_event().
+	 */
+	ldev->lag_mp.mfi = NULL;
+}
+
 int mlx5_lag_mp_init(struct mlx5_lag *ldev)
 {
 	struct lag_mp *mp = &ldev->lag_mp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
index 258ac7b2964e..729c839397a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
@@ -21,11 +21,13 @@ struct lag_mp {
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+void mlx5_lag_mp_reset(struct mlx5_lag *ldev);
 int mlx5_lag_mp_init(struct mlx5_lag *ldev);
 void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev);
 
 #else /* CONFIG_MLX5_ESWITCH */
 
+static inline void mlx5_lag_mp_reset(struct mlx5_lag *ldev) {};
 static inline int mlx5_lag_mp_init(struct mlx5_lag *ldev) { return 0; }
 static inline void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev) {}
 
-- 
2.31.1

