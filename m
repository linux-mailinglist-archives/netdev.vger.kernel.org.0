Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03EF6176F7
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiKCG4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiKCG4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:56:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA47625C0
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 23:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87859B82675
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 06:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22286C433C1;
        Thu,  3 Nov 2022 06:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667458566;
        bh=yCIqxIoXfc5kamIuxwM4Y1tlh9EQbVTy+Nv9vethuz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECSIb/M82O5EGvHwbj0T+hpJJD7sjnoHg6/Tz2mpLFO57P/7HLtp2hvCHl8/HCw8Y
         kbVYPqVnRAzbwmkPr5LopBm03Z5Si4GNpj4cqwsitrqBjRYeTOlEFi1MvYdULYzvRX
         SwRTLXAMhCD2ypfFXQh/g219ufGA7W/l3VIjqhtStQ4vslPjDeu0TLT/9Rb8cAiwjG
         vS2Hxyvipy3b3J7xkioxPC/FlILY5Xsli6+Mm7Qk6X3MjyJKTZlLW8dkt2C9dwnf+7
         jOLCuffCjLxImyTv51RdvtEtz0R8lKwOhIDgbpxidzvRdRQdq3RMAVOFUdrPub5R2m
         EbjvN4X2+FMPA==
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
Subject: [net 02/11] net/mlx5: Allow async trigger completion execution on single CPU systems
Date:   Wed,  2 Nov 2022 23:55:38 -0700
Message-Id: <20221103065547.181550-3-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221103065547.181550-1-saeed@kernel.org>
References: <20221103065547.181550-1-saeed@kernel.org>
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

