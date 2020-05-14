Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6B01D3AD4
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgENS4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729577AbgENS4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:56:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D40E62074A;
        Thu, 14 May 2020 18:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482566;
        bh=oRzOtKeM3gwOwne4JOUunDae+meR9aQTN2zQLyJ8T2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akBCseKZ5JJRMqZth2dIyPwO0shqQ474wKco4FDcNAIua8+TOfn6yWC63LYFIbq/k
         z3pDpR4xC+8VZw6DCfQ97Y63H8GY/3+IruBQSnunNKRfcrzbrFOHMpy0R3Q7QexF0Q
         7tdVf9Feai21NGmccxtJmj+kXH2rj0QLeD+CItCg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/27] net/mlx5: Fix forced completion access non initialized command entry
Date:   Thu, 14 May 2020 14:55:36 -0400
Message-Id: <20200514185550.21462-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185550.21462-1-sashal@kernel.org>
References: <20200514185550.21462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit f3cb3cebe26ed4c8036adbd9448b372129d3c371 ]

mlx5_cmd_flush() will trigger forced completions to all valid command
entries. Triggered by an asynch event such as fast teardown it can
happen at any stage of the command, including command initialization.
It will trigger forced completion and that can lead to completion on an
uninitialized command entry.

Setting MLX5_CMD_ENT_STATE_PENDING_COMP only after command entry is
initialized will ensure force completion is treated only if command
entry is initialized.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 1d5263c46eee0..a1057efa2294e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -813,7 +813,6 @@ static void cmd_work_handler(struct work_struct *work)
 	}
 
 	cmd->ent_arr[ent->idx] = ent;
-	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 	lay = get_inst(cmd, ent->idx);
 	ent->lay = lay;
 	memset(lay, 0, sizeof(*lay));
@@ -835,6 +834,7 @@ static void cmd_work_handler(struct work_struct *work)
 
 	if (ent->callback)
 		schedule_delayed_work(&ent->cb_timeout_work, cb_timeout);
+	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
 	/* Skip sending command to fw if internal error */
 	if (pci_channel_offline(dev->pdev) ||
-- 
2.20.1

