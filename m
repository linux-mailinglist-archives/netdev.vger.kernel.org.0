Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A183404BF2
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241971AbhIILyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240211AbhIILwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:52:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFC5D6135D;
        Thu,  9 Sep 2021 11:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187857;
        bh=sYydYxRyDsnWxhv0ACQkOPeeGjMFpExS/qG7QDvFyBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ap9PZr4V66Bsa3yqBKUUwQixqUBhBR2yt+Vx3+4BUwm9K8phxW5cgvTtG6zBfILpq
         j//h5NTgBU102DkSE6fLxsoinEmsnSfYEqTkrPsumIQp0EjVsVawoIsflU2QVQXGUI
         1AL9Mk6PYh9jaZqUv5XKT47uN346rMGNesri+sWokVEoegJst2lm9RQ/11e5T9k1e3
         nnI0Tv9S8t0wL5QReUgsXohGvMdmiQh9YpIQzEF+ljs3ScFN7dheiGkXlmSBQMXVsh
         Uhlo4fqzmPi9oNuo1DLx5ChW94D8/KEsybxEkkmoFxRpAaN4nEtUdMEztL+qRsgP58
         wcffXeAyPngDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eran Ben Elisha <eranbe@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 146/252] net/mlx5: Fix variable type to match 64bit
Date:   Thu,  9 Sep 2021 07:39:20 -0400
Message-Id: <20210909114106.141462-146-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

[ Upstream commit 979aa51967add26b37f9d77e01729d44a2da8e5f ]

Fix the following smatch warning:
wait_func_handle_exec_timeout() warn: should '1 << ent->idx' be a 64 bit type?

Use 1ULL, to have a 64 bit type variable.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 9d79c5ec31e9..db5dfff585c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -877,7 +877,7 @@ static void cb_timeout_handler(struct work_struct *work)
 	ent->ret = -ETIMEDOUT;
 	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, timeout. Will cause a leak of a command resource\n",
 		       ent->idx, mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
-	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 
 out:
 	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
@@ -994,7 +994,7 @@ static void cmd_work_handler(struct work_struct *work)
 		MLX5_SET(mbox_out, ent->out, status, status);
 		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
 
-		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 		return;
 	}
 
@@ -1008,7 +1008,7 @@ static void cmd_work_handler(struct work_struct *work)
 		poll_timeout(ent);
 		/* make sure we read the descriptor after ownership is SW */
 		rmb();
-		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, (ent->ret == -ETIMEDOUT));
+		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, (ent->ret == -ETIMEDOUT));
 	}
 }
 
@@ -1068,7 +1068,7 @@ static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
 		       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
 
 	ent->ret = -ETIMEDOUT;
-	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 }
 
 static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
-- 
2.30.2

