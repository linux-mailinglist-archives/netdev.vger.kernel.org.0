Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194534D3AE3
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbiCIUQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbiCIUQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:16:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C93F90261
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 12:15:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C2506194C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934F4C340F6;
        Wed,  9 Mar 2022 20:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646856925;
        bh=eoFnkxCVBJ+w+TROoOJiRwbBBz/7xJBRxwaQk9lKHdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbBsUsiDV9vJC1Zo1E0tw3trtvTXVdvCoyaW1SeWyktLpdGC3S/to0NXXv6Ak0Qu0
         aCxB11ZX9n1KEq7fD1U8ponVjNce/dXWXMRZZ5dFCqY3wpLy+RmmFMiuxoSbiy84u7
         dEuodJ/teyBC64dj3nDFFGf0922kvgrbskygIZIOh94N351ztankhDumzXInq751gB
         4xNATgw8FMM7hLth/4VQwp8LTGenSrQ8wsXvkba8hGJVzutC6E38mZHrY7gS/1k8Z0
         xEXPEUfTQs7cvNnwO3La47UU6z2e9jycN8XJokFpDhqXcKIby2pOCbI7AbiHBwxSLp
         RvO98fkG7o6Dg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/5] net/mlx5: Fix a race on command flush flow
Date:   Wed,  9 Mar 2022 12:15:14 -0800
Message-Id: <20220309201517.589132-3-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309201517.589132-1-saeed@kernel.org>
References: <20220309201517.589132-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Fix a refcount use after free warning due to a race on command entry.
Such race occurs when one of the commands releases its last refcount and
frees its index and entry while another process running command flush
flow takes refcount to this command entry. The process which handles
commands flush may see this command as needed to be flushed if the other
process released its refcount but didn't release the index yet. Fix it
by adding the needed spin lock.

It fixes the following warning trace:

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 11 PID: 540311 at lib/refcount.c:25 refcount_warn_saturate+0x80/0xe0
...
RIP: 0010:refcount_warn_saturate+0x80/0xe0
...
Call Trace:
 <TASK>
 mlx5_cmd_trigger_completions+0x293/0x340 [mlx5_core]
 mlx5_cmd_flush+0x3a/0xf0 [mlx5_core]
 enter_error_state+0x44/0x80 [mlx5_core]
 mlx5_fw_fatal_reporter_err_work+0x37/0xe0 [mlx5_core]
 process_one_work+0x1be/0x390
 worker_thread+0x4d/0x3d0
 ? rescuer_thread+0x350/0x350
 kthread+0x141/0x160
 ? set_kthread_struct+0x40/0x40
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: 50b2412b7e78 ("net/mlx5: Avoid possible free of command entry while timeout comp handler")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 17fe05809653..3eacd8739929 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -131,11 +131,8 @@ static int cmd_alloc_index(struct mlx5_cmd *cmd)
 
 static void cmd_free_index(struct mlx5_cmd *cmd, int idx)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&cmd->alloc_lock, flags);
+	lockdep_assert_held(&cmd->alloc_lock);
 	set_bit(idx, &cmd->bitmask);
-	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 }
 
 static void cmd_ent_get(struct mlx5_cmd_work_ent *ent)
@@ -145,17 +142,21 @@ static void cmd_ent_get(struct mlx5_cmd_work_ent *ent)
 
 static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
 {
+	struct mlx5_cmd *cmd = ent->cmd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cmd->alloc_lock, flags);
 	if (!refcount_dec_and_test(&ent->refcnt))
-		return;
+		goto out;
 
 	if (ent->idx >= 0) {
-		struct mlx5_cmd *cmd = ent->cmd;
-
 		cmd_free_index(cmd, ent->idx);
 		up(ent->page_queue ? &cmd->pages_sem : &cmd->sem);
 	}
 
 	cmd_free_ent(ent);
+out:
+	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 }
 
 static struct mlx5_cmd_layout *get_inst(struct mlx5_cmd *cmd, int idx)
-- 
2.35.1

