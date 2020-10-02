Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834D1281A80
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 20:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388422AbgJBSHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 14:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388174AbgJBSHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 14:07:08 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198D52177B;
        Fri,  2 Oct 2020 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601662027;
        bh=fUdoqY/U1lt6LJV0V8BgmigzUIZs6e0XLOTNZB6wCss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIi8xDEjy7vBFCK3NHaqrmFHmPwG+4CKDICx108JLaEt9V2ImZWXqyzHlc0mG88O0
         Qdbdb+FdlABUIR1J2PTal1otr6gdUrPLL8wAR1/b7YfNfq7jVcBdGnF1h0w5oVLFSa
         2ojqduITuhyIYMrfKDTx8GFoTjQPeRtDYKhoLHMg=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V3 04/14] net/mlx5: Add retry mechanism to the command entry index allocation
Date:   Fri,  2 Oct 2020 11:06:44 -0700
Message-Id: <20201002180654.262800-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002180654.262800-1-saeed@kernel.org>
References: <20201002180654.262800-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

It is possible that new command entry index allocation will temporarily
fail. The new command holds the semaphore, so it means that a free entry
should be ready soon. Add one second retry mechanism before returning an
error.

Patch "net/mlx5: Avoid possible free of command entry while timeout comp
handler" increase the possibility to bump into this temporarily failure
as it delays the entry index release for non-callback commands.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 37dae95e61d5..2b597ac365f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -883,6 +883,25 @@ static bool opcode_allowed(struct mlx5_cmd *cmd, u16 opcode)
 	return cmd->allowed_opcode == opcode;
 }
 
+static int cmd_alloc_index_retry(struct mlx5_cmd *cmd)
+{
+	unsigned long alloc_end = jiffies + msecs_to_jiffies(1000);
+	int idx;
+
+retry:
+	idx = cmd_alloc_index(cmd);
+	if (idx < 0 && time_before(jiffies, alloc_end)) {
+		/* Index allocation can fail on heavy load of commands. This is a temporary
+		 * situation as the current command already holds the semaphore, meaning that
+		 * another command completion is being handled and it is expected to release
+		 * the entry index soon.
+		 */
+		cpu_relax();
+		goto retry;
+	}
+	return idx;
+}
+
 static void cmd_work_handler(struct work_struct *work)
 {
 	struct mlx5_cmd_work_ent *ent = container_of(work, struct mlx5_cmd_work_ent, work);
@@ -900,7 +919,7 @@ static void cmd_work_handler(struct work_struct *work)
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
-		alloc_ret = cmd_alloc_index(cmd);
+		alloc_ret = cmd_alloc_index_retry(cmd);
 		if (alloc_ret < 0) {
 			mlx5_core_err_rl(dev, "failed to allocate command entry\n");
 			if (ent->callback) {
-- 
2.26.2

