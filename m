Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB1213E321
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbgAPRAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:00:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387676AbgAPRAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CD6624686;
        Thu, 16 Jan 2020 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194008;
        bh=HhTOEnfVPXjkdgMI5j2Rj7f81dghYJkTfY6kVie9fZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhjDfcP4eTcGSP5jAbPvpQSQibbmMz/2JbyYcM2bXtWx598RB7tyL+NMkp2QC9LEH
         TQL53P+c/angnZ9Izpw3u5E4Po4euHD/PkV5FVffy34n6f6pCBxBT6pSAnM86TZMcn
         N+67QuqMHr5xKLtEQj0XjL5BrP72vym8Yq5EEniQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moni Shoua <monis@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 133/671] net/mlx5: Take lock with IRQs disabled to avoid deadlock
Date:   Thu, 16 Jan 2020 11:50:42 -0500
Message-Id: <20200116165940.10720-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

[ Upstream commit 33814e5d127e21f53b52e17b0722c1b57d4f4d29 ]

The lock in qp_table might be taken from process context or from
interrupt context. This may lead to a deadlock unless it is taken with
IRQs disabled.

Discovered by lockdep

================================
WARNING: inconsistent lock state
4.20.0-rc6
--------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W}

python/12572 [HC1[1]:SC0[0]:HE0:SE1] takes:
00000000052a4df4 (&(&table->lock)->rlock#2){?.+.}, /0x50 [mlx5_core]
{HARDIRQ-ON-W} state was registered at:
  _raw_spin_lock+0x33/0x70
  mlx5_get_rsc+0x1a/0x50 [mlx5_core]
  mlx5_ib_eqe_pf_action+0x493/0x1be0 [mlx5_ib]
  process_one_work+0x90c/0x1820
  worker_thread+0x87/0xbb0
  kthread+0x320/0x3e0
  ret_from_fork+0x24/0x30
irq event stamp: 103928
hardirqs last  enabled at (103927): [] nk+0x1a/0x1c
hardirqs last disabled at (103928): [] unk+0x1a/0x1c
softirqs last  enabled at (103924): [] tcp_sendmsg+0x31/0x40
softirqs last disabled at (103922): [] 80

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&table->lock)->rlock#2);

    lock(&(&table->lock)->rlock#2);

 *** DEADLOCK ***

Fixes: 032080ab43ac ("IB/mlx5: Lock QP during page fault handling")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index f33707ce8b6b..479ac21cdbc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -44,14 +44,15 @@ static struct mlx5_core_rsc_common *mlx5_get_rsc(struct mlx5_core_dev *dev,
 {
 	struct mlx5_qp_table *table = &dev->priv.qp_table;
 	struct mlx5_core_rsc_common *common;
+	unsigned long flags;
 
-	spin_lock(&table->lock);
+	spin_lock_irqsave(&table->lock, flags);
 
 	common = radix_tree_lookup(&table->tree, rsn);
 	if (common)
 		atomic_inc(&common->refcount);
 
-	spin_unlock(&table->lock);
+	spin_unlock_irqrestore(&table->lock, flags);
 
 	if (!common) {
 		mlx5_core_warn(dev, "Async event for bogus resource 0x%x\n",
-- 
2.20.1

