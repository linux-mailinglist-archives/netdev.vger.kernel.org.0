Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DF447D894
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbhLVVMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41306 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237972AbhLVVMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AD6561D0B
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36517C36AEA;
        Wed, 22 Dec 2021 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207528;
        bh=cUUPqYxbAKUyUbKLm8jEs0leHgmdcYFykgQGxi7X/kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F924JSeb0ibYAIZdNO0zdbTMl7fegb3pYn+Ywqwc0DMFgXun94HOhpVrv+e6qfoD3
         3HyTtoZFXZTpxcV2mPVf91SS0dOjffQJCZBPKT02ja4f0Vt1+s7GmgN8Uf7efdM1lp
         6CVKOCxIix5FvbePVw4lClwfEL+sY3cqfGGRm4Fp91LcSr6k1OtZQ9P0oShFZY8lO0
         5GfaiTZm9nnRG68KiBR3T1/kEC8fWhUeqfQar1loYIC3VRr/l7ZGAoMEr3uJqnuL/J
         LHAzKctRh2j6yzZL0Rd6La4PMrQDKs4lZ9ib3YKBw2KJSD8EHUmyj1at6PuZCf6FBS
         OuURJG+O3n86A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Amir Tzin <amirtz@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/11] net/mlx5e: Wrap the tx reporter dump callback to extract the sq
Date:   Wed, 22 Dec 2021 13:11:57 -0800
Message-Id: <20211222211201.77469-8-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amir Tzin <amirtz@nvidia.com>

Function mlx5e_tx_reporter_dump_sq() casts its void * argument to struct
mlx5e_txqsq *, but in TX-timeout-recovery flow the argument is actually
of type struct mlx5e_tx_timeout_ctx *.

 mlx5_core 0000:08:00.1 enp8s0f1: TX timeout detected
 mlx5_core 0000:08:00.1 enp8s0f1: TX timeout on queue: 1, SQ: 0x11ec, CQ: 0x146d, SQ Cons: 0x0 SQ Prod: 0x1, usecs since last trans: 21565000
 BUG: stack guard page was hit at 0000000093f1a2de (stack is 00000000b66ea0dc..000000004d932dae)
 kernel stack overflow (page fault): 0000 [#1] SMP NOPTI
 CPU: 5 PID: 95 Comm: kworker/u20:1 Tainted: G W OE 5.13.0_mlnx #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Workqueue: mlx5e mlx5e_tx_timeout_work [mlx5_core]
 RIP: 0010:mlx5e_tx_reporter_dump_sq+0xd3/0x180
 [mlx5_core]
 Call Trace:
 mlx5e_tx_reporter_dump+0x43/0x1c0 [mlx5_core]
 devlink_health_do_dump.part.91+0x71/0xd0
 devlink_health_report+0x157/0x1b0
 mlx5e_reporter_tx_timeout+0xb9/0xf0 [mlx5_core]
 ? mlx5e_tx_reporter_err_cqe_recover+0x1d0/0x1d0
 [mlx5_core]
 ? mlx5e_health_queue_dump+0xd0/0xd0 [mlx5_core]
 ? update_load_avg+0x19b/0x550
 ? set_next_entity+0x72/0x80
 ? pick_next_task_fair+0x227/0x340
 ? finish_task_switch+0xa2/0x280
   mlx5e_tx_timeout_work+0x83/0xb0 [mlx5_core]
   process_one_work+0x1de/0x3a0
   worker_thread+0x2d/0x3c0
 ? process_one_work+0x3a0/0x3a0
   kthread+0x115/0x130
 ? kthread_park+0x90/0x90
   ret_from_fork+0x1f/0x30
 --[ end trace 51ccabea504edaff ]---
 RIP: 0010:mlx5e_tx_reporter_dump_sq+0xd3/0x180
 PKRU: 55555554
 Kernel panic - not syncing: Fatal exception
 Kernel Offset: disabled
 end Kernel panic - not syncing: Fatal exception

To fix this bug add a wrapper for mlx5e_tx_reporter_dump_sq() which
extracts the sq from struct mlx5e_tx_timeout_ctx and set it as the
TX-timeout-recovery flow dump callback.

Fixes: 5f29458b77d5 ("net/mlx5e: Support dump callback in TX reporter")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 4f4bc8726ec4..614cd9477600 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -466,6 +466,14 @@ static int mlx5e_tx_reporter_dump_sq(struct mlx5e_priv *priv, struct devlink_fms
 	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
+static int mlx5e_tx_reporter_timeout_dump(struct mlx5e_priv *priv, struct devlink_fmsg *fmsg,
+					  void *ctx)
+{
+	struct mlx5e_tx_timeout_ctx *to_ctx = ctx;
+
+	return mlx5e_tx_reporter_dump_sq(priv, fmsg, to_ctx->sq);
+}
+
 static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
 					  struct devlink_fmsg *fmsg)
 {
@@ -561,7 +569,7 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 	to_ctx.sq = sq;
 	err_ctx.ctx = &to_ctx;
 	err_ctx.recover = mlx5e_tx_reporter_timeout_recover;
-	err_ctx.dump = mlx5e_tx_reporter_dump_sq;
+	err_ctx.dump = mlx5e_tx_reporter_timeout_dump;
 	snprintf(err_str, sizeof(err_str),
 		 "TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u",
 		 sq->ch_ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
-- 
2.33.1

