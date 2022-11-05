Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A310661D81E
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKEHLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKEHKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F622ED69
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 00:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18193609EB
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296DAC433D7;
        Sat,  5 Nov 2022 07:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667632236;
        bh=yCIqxIoXfc5kamIuxwM4Y1tlh9EQbVTy+Nv9vethuz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcswD1NiQ9div8b/3enjhlkZAd+W/sFhGYkx5x0CmQhyYHVBvJQ7P5qXsQ0JTKRpS
         Mice2qQr9XYX7diadpqu7ygY4zLVNC2qum8lAbqiHcCJnUsAJBN5xYdO8c1qosOTWK
         uotPFJK8n6gzaR6ROVTrT3xPHBWwv3O0rV4XHhVgORe7+wgljJhCda4oFo9//ExucU
         TmNaE0UpndIhIjdrWfAfYmmKgsZ5CUZFiCIldmVE3LmKLhIiLJRZB8guHkrB9Mnp70
         GtoivjaUgmwLb5/mnDne0B5O9D3/KQkemUVA7xjbuEQT5MyFtaBXGmjekuXyTW2p8v
         HptYsTxVeFmNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Roy Novich <royno@nvidia.com>,
        Alexander Schmidt <alexschm@de.ibm.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [V2 net 02/11] net/mlx5: Allow async trigger completion execution on single CPU systems
Date:   Sat,  5 Nov 2022 00:10:19 -0700
Message-Id: <20221105071028.578594-3-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221105071028.578594-1-saeed@kernel.org>
References: <20221105071028.578594-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roy Novich <royno@nvidia.com>

For a single CPU system, the kernel thread executing mlx5_cmd_flush()
never releases the CPU but calls down_trylock(&cmd→sem) in a busy loop.
On a single processor system, this leads to a deadlock as the kernel
thread which executes mlx5_cmd_invoke() never gets scheduled. Fix this,
by adding the cond_resched() call to the loop, allow the command
completion kernel thread to execute.

Fixes: 8e715cd613a1 ("net/mlx5: Set command entry semaphore up once got index free")
Signed-off-by: Alexander Schmidt <alexschm@de.ibm.com>
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 46ba4c2faad2..2e0d59ca62b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1770,12 +1770,17 @@ void mlx5_cmd_flush(struct mlx5_core_dev *dev)
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int i;
 
-	for (i = 0; i < cmd->max_reg_cmds; i++)
-		while (down_trylock(&cmd->sem))
+	for (i = 0; i < cmd->max_reg_cmds; i++) {
+		while (down_trylock(&cmd->sem)) {
 			mlx5_cmd_trigger_completions(dev);
+			cond_resched();
+		}
+	}
 
-	while (down_trylock(&cmd->pages_sem))
+	while (down_trylock(&cmd->pages_sem)) {
 		mlx5_cmd_trigger_completions(dev);
+		cond_resched();
+	}
 
 	/* Unlock cmdif */
 	up(&cmd->pages_sem);
-- 
2.38.1

