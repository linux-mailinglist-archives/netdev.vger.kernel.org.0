Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C272769DE
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 08:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgIXG7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 02:59:07 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:35800 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgIXG7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 02:59:07 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08O6wpZY003518;
        Wed, 23 Sep 2020 23:58:52 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     vakul.garg@nxp.com, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH] net/tls: race causes kernel panic
Date:   Thu, 24 Sep 2020 12:28:45 +0530
Message-Id: <20200924065845.30594-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BUG: kernel NULL pointer dereference, address: 00000000000000b8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 80000008b6fef067 P4D 80000008b6fef067 PUD 8b6fe6067 PMD 0
 Oops: 0000 [#1] SMP PTI
 CPU: 12 PID: 23871 Comm: kworker/12:80 Kdump: loaded Tainted: G S
 5.9.0-rc3+ #1
 Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.1 03/29/2018
 Workqueue: events tx_work_handler [tls]
 RIP: 0010:tx_work_handler+0x1b/0x70 [tls]
 Code: dc fe ff ff e8 16 d4 a3 f6 66 0f 1f 44 00 00 0f 1f 44 00 00 55 53 48 8b
 6f 58 48 8b bd a0 04 00 00 48 85 ff 74 1c 48 8b 47 28 <48> 8b 90 b8 00 00 00 83
 e2 02 75 0c f0 48 0f ba b0 b8 00 00 00 00
 RSP: 0018:ffffa44ace61fe88 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: ffff91da9e45cc30 RCX: dead000000000122
 RDX: 0000000000000001 RSI: ffff91da9e45cc38 RDI: ffff91d95efac200
 RBP: ffff91da133fd780 R08: 0000000000000000 R09: 000073746e657665
 R10: 8080808080808080 R11: 0000000000000000 R12: ffff91dad7d30700
 R13: ffff91dab6561080 R14: 0ffff91dad7d3070 R15: ffff91da9e45cc38
 FS:  0000000000000000(0000) GS:ffff91dad7d00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00000000000000b8 CR3: 0000000906478003 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  process_one_work+0x1a7/0x370
  worker_thread+0x30/0x370
  ? process_one_work+0x370/0x370
  kthread+0x114/0x130
  ? kthread_park+0x80/0x80
  ret_from_fork+0x22/0x30

tls_sw_release_resources_tx() waits for encrypt_pending, which
can have race, so we need similar changes as in commit
0cada33241d9de205522e3858b18e506ca5cce2c here as well.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 net/tls/tls_sw.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9a3d9fedd7aa..95ab5545a931 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2143,10 +2143,15 @@ void tls_sw_release_resources_tx(struct sock *sk)
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec, *tmp;
+	int pending;
 
 	/* Wait for any pending async encryptions to complete */
-	smp_store_mb(ctx->async_notify, true);
-	if (atomic_read(&ctx->encrypt_pending))
+	spin_lock_bh(&ctx->encrypt_compl_lock);
+	ctx->async_notify = true;
+	pending = atomic_read(&ctx->encrypt_pending);
+	spin_unlock_bh(&ctx->encrypt_compl_lock);
+
+	if (pending)
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 
 	tls_tx_records(sk, -1);
-- 
2.18.1

