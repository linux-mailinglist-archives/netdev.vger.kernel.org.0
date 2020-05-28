Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8DE1E5F6C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389484AbgE1MCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389063AbgE1L5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:57:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 531D920DD4;
        Thu, 28 May 2020 11:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667062;
        bh=PRrxJNePypOa7RjsrGgEC4LoK0Qb1/BQRsFjdZmdxjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3H8b3zIMrwhU8QxCX0lEzx+GcP3aH3WhG1oCrY0vY8VTgTyheKr60j0dSBsRZVKY
         gVCY4U3B/R569NsD8+qg6dxElq76+WBjXCBQBb9JpfW+8Z8W7kvgUj4XxD5FLi7cti
         ICfWZSlFIDpyZ3TvuhEJkb5llUUlsifEHxI9S9tI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/17] net/mlx5: Add command entry handling completion
Date:   Thu, 28 May 2020 07:57:22 -0400
Message-Id: <20200528115724.1406376-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115724.1406376-1-sashal@kernel.org>
References: <20200528115724.1406376-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit 17d00e839d3b592da9659c1977d45f85b77f986a ]

When FW response to commands is very slow and all command entries in
use are waiting for completion we can have a race where commands can get
timeout before they get out of the queue and handled. Timeout
completion on uninitialized command will cause releasing command's
buffers before accessing it for initialization and then we will get NULL
pointer exception while trying access it. It may also cause releasing
buffers of another command since we may have timeout completion before
even allocating entry index for this command.
Add entry handling completion to avoid this race.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 14 ++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 300456684728..a686082762df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -835,6 +835,7 @@ static void cmd_work_handler(struct work_struct *work)
 	int alloc_ret;
 	int cmd_mode;
 
+	complete(&ent->handling);
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
@@ -953,6 +954,11 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int err;
 
+	if (!wait_for_completion_timeout(&ent->handling, timeout) &&
+	    cancel_work_sync(&ent->work)) {
+		ent->ret = -ECANCELED;
+		goto out_err;
+	}
 	if (cmd->mode == CMD_MODE_POLLING || ent->polling) {
 		wait_for_completion(&ent->done);
 	} else if (!wait_for_completion_timeout(&ent->done, timeout)) {
@@ -960,12 +966,17 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
 	}
 
+out_err:
 	err = ent->ret;
 
 	if (err == -ETIMEDOUT) {
 		mlx5_core_warn(dev, "%s(0x%x) timeout. Will cause a leak of a command resource\n",
 			       mlx5_command_str(msg_to_opcode(ent->in)),
 			       msg_to_opcode(ent->in));
+	} else if (err == -ECANCELED) {
+		mlx5_core_warn(dev, "%s(0x%x) canceled on out of queue timeout.\n",
+			       mlx5_command_str(msg_to_opcode(ent->in)),
+			       msg_to_opcode(ent->in));
 	}
 	mlx5_core_dbg(dev, "err %d, delivery status %s(%d)\n",
 		      err, deliv_status_to_str(ent->status), ent->status);
@@ -1001,6 +1012,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	ent->token = token;
 	ent->polling = force_polling;
 
+	init_completion(&ent->handling);
 	if (!callback)
 		init_completion(&ent->done);
 
@@ -1020,6 +1032,8 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	err = wait_func(dev, ent);
 	if (err == -ETIMEDOUT)
 		goto out;
+	if (err == -ECANCELED)
+		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
 	op = MLX5_GET(mbox_in, in->first.data, opcode);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ae64fced188d..dc89a964c1f3 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -902,6 +902,7 @@ struct mlx5_cmd_work_ent {
 	struct delayed_work	cb_timeout_work;
 	void		       *context;
 	int			idx;
+	struct completion	handling;
 	struct completion	done;
 	struct mlx5_cmd        *cmd;
 	struct work_struct	work;
-- 
2.25.1

