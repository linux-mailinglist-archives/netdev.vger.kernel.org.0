Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AFA486F4A
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345011AbiAGA7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:59:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46290 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiAGA6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA56661E84
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609BFC36AE3;
        Fri,  7 Jan 2022 00:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517128;
        bh=HCdMmbkNdb4qKiNjfamKhwwJDmWpAWhItj9At4B2D6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJ+e0qJKHjA2Pnt6D0Hcou9APPlf4EV4IqTo2yW/knM+3JN13O9mJbm9cM+D1kydO
         rDaKDSMeeMknjDU/vkW0PhraSysRv0p+vY3WCL2mJLixdq5b/KXgrOen7wlinCIorD
         dYZwooz6CDSbpwzBcmT1UaOvawiS9f6nMH39exWT27gqeMJFQLiwMwpByFeEAeTc/l
         byhbZzpqjH3hxe9BtXZaCET7X8jKMkHaOE30IT5WXI9SeX4UwwZoG6by0CWVcRfGnp
         lbw1HlXkGyYpQyYSISiWziVBOpWoKLVtjdpNjuGMb4okjGozzAPqUMOo55SiSUqbQF
         uRpzecZKFtUYQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/11] net/mlx5: Set command entry semaphore up once got index free
Date:   Thu,  6 Jan 2022 16:58:30 -0800
Message-Id: <20220107005831.78909-11-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Avoid a race where command work handler may fail to allocate command
entry index, by holding the command semaphore down till command entry
index is being freed.

Fixes: 410bd754cd73 ("net/mlx5: Add retry mechanism to the command entry index allocation")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index a46284ca5172..f588503157d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -148,8 +148,12 @@ static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
 	if (!refcount_dec_and_test(&ent->refcnt))
 		return;
 
-	if (ent->idx >= 0)
-		cmd_free_index(ent->cmd, ent->idx);
+	if (ent->idx >= 0) {
+		struct mlx5_cmd *cmd = ent->cmd;
+
+		cmd_free_index(cmd, ent->idx);
+		up(ent->page_queue ? &cmd->pages_sem : &cmd->sem);
+	}
 
 	cmd_free_ent(ent);
 }
@@ -1602,8 +1606,6 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 	vector = vec & 0xffffffff;
 	for (i = 0; i < (1 << cmd->log_sz); i++) {
 		if (test_bit(i, &vector)) {
-			struct semaphore *sem;
-
 			ent = cmd->ent_arr[i];
 
 			/* if we already completed the command, ignore it */
@@ -1626,10 +1628,6 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 			    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 				cmd_ent_put(ent);
 
-			if (ent->page_queue)
-				sem = &cmd->pages_sem;
-			else
-				sem = &cmd->sem;
 			ent->ts2 = ktime_get_ns();
 			memcpy(ent->out->first.data, ent->lay->out, sizeof(ent->lay->out));
 			dump_command(dev, ent, 0);
@@ -1683,7 +1681,6 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				 */
 				complete(&ent->done);
 			}
-			up(sem);
 		}
 	}
 }
-- 
2.33.1

