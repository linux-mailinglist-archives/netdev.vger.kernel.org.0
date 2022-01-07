Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDB9486F4B
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345024AbiAGA7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:59:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36550 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344886AbiAGA6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62678B82497
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFA1C36AE5;
        Fri,  7 Jan 2022 00:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517129;
        bh=KjSYjEeubz2tyOr4uiNVBQaGSr8JTa7Uf1n2Sll4djc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccZgCvmP3tDvby8uHsFb1qXWlJVyWPEVqINEfZUzT9eZEDYC1HSILOAc36abU4erU
         dSIZO2z6OFuOetj0DV5EGgP/nBsuhpKqt3OdzwM3Rf5BkS2erb7w2jcW0wmEqcUlHo
         vteAHNMAgqAcEc03Lh70AuqNS7BIaYrGB/ZoWsOPQPXKM8vBr21tbpAvwQMn0yfNVt
         fGMhVkHyjCLGlNVA40jAoNXRAH4YIKoiP7fNybRwUaahZTHn/kS2jkN/uoEn/WQhxD
         BQrPTTVCZo/VUQ3qMzaiL3YJJgUUHxDwcltOHcOAPar/Tyia5UclYnjUWQK6ZnUJhA
         X1uDDcdzB7mLg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/11] Revert "net/mlx5: Add retry mechanism to the command entry index allocation"
Date:   Thu,  6 Jan 2022 16:58:31 -0800
Message-Id: <20220107005831.78909-12-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

This reverts commit 410bd754cd73c4a2ac3856d9a03d7b08f9c906bf.

The reverted commit had added a retry mechanism to the command entry
index allocation. The previous patch ensures that there is a free
command entry index once the command work handler holds the command
semaphore. Thus the retry mechanism is not needed.

Fixes: 410bd754cd73 ("net/mlx5: Add retry mechanism to the command entry index allocation")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 21 +------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index f588503157d0..17fe05809653 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -904,25 +904,6 @@ static bool opcode_allowed(struct mlx5_cmd *cmd, u16 opcode)
 	return cmd->allowed_opcode == opcode;
 }
 
-static int cmd_alloc_index_retry(struct mlx5_cmd *cmd)
-{
-	unsigned long alloc_end = jiffies + msecs_to_jiffies(1000);
-	int idx;
-
-retry:
-	idx = cmd_alloc_index(cmd);
-	if (idx < 0 && time_before(jiffies, alloc_end)) {
-		/* Index allocation can fail on heavy load of commands. This is a temporary
-		 * situation as the current command already holds the semaphore, meaning that
-		 * another command completion is being handled and it is expected to release
-		 * the entry index soon.
-		 */
-		cpu_relax();
-		goto retry;
-	}
-	return idx;
-}
-
 bool mlx5_cmd_is_down(struct mlx5_core_dev *dev)
 {
 	return pci_channel_offline(dev->pdev) ||
@@ -950,7 +931,7 @@ static void cmd_work_handler(struct work_struct *work)
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
-		alloc_ret = cmd_alloc_index_retry(cmd);
+		alloc_ret = cmd_alloc_index(cmd);
 		if (alloc_ret < 0) {
 			mlx5_core_err_rl(dev, "failed to allocate command entry\n");
 			if (ent->callback) {
-- 
2.33.1

