Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A922D28081A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733048AbgJATxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732933AbgJATxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:14 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EE0820882;
        Thu,  1 Oct 2020 19:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581993;
        bh=JLtBBaLBa8IxkfO215riZykvji3154cSfHFgMwEbkuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPjTV9RfwwGA/a9ldMICD1S9Sw4kv6hZJIKg7F5OYoRJhDT/VHu1BTnsrdPibPiI2
         Ov5Zqa1a9GpT/JbewENLfo/LrKCSSo6ljQMsHtMioHpkrE2bPAsJ96wdCFvm2qUNJB
         SsPyt6tgWnjTMmPKIntL01dVHz0lyUG+rfa1CTUA=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net V2 05/15] net/mlx5: Add retry mechanism to the command entry index allocation
Date:   Thu,  1 Oct 2020 12:52:37 -0700
Message-Id: <20201001195247.66636-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
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
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 65ae6ef2039e..4b54c9241fd7 100644
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
+		cond_resched();
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

