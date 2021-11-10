Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CA944BBE8
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 08:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhKJHF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 02:05:26 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:41864 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhKJHFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 02:05:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UvtXNbN_1636527754;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UvtXNbN_1636527754)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Nov 2021 15:02:35 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.vnet.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, guwen@linux.alibaba.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net] net/smc: fix sk_refcnt underflow on linkdown and fallback
Date:   Wed, 10 Nov 2021 15:02:34 +0800
Message-Id: <20211110070234.60527-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We got the following WARNING when running ab/nginx
test with RDMA link flapping (up-down-up).
The reason is when smc_sock fallback and at linkdown
happens simultaneously, we may got the following situation:

__smc_lgr_terminate()
 --> smc_conn_kill()
    --> smc_close_active_abort()
           smc_sock->sk_state = SMC_CLOSED
           sock_put(smc_sock)

smc_sock was set to SMC_CLOSED and sock_put() been called
when terminate the link group. But later application call
close() on the socket, then we got:

__smc_release():
    if (smc_sock->fallback)
        smc_sock->sk_state = SMC_CLOSED
        sock_put(smc_sock)

Again we set the smc_sock to CLOSED through it's already
in CLOSED state, and double put the refcnt, so the following
warning happens:

refcount_t: underflow; use-after-free.
WARNING: CPU: 5 PID: 860 at lib/refcount.c:28 refcount_warn_saturate+0x8d/0xf0
Modules linked in:
CPU: 5 PID: 860 Comm: nginx Not tainted 5.10.46+ #403
Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 8c24b4c 04/01/2014
RIP: 0010:refcount_warn_saturate+0x8d/0xf0
Code: 05 5c 1e b5 01 01 e8 52 25 bc ff 0f 0b c3 80 3d 4f 1e b5 01 00 75 ad 48

RSP: 0018:ffffc90000527e50 EFLAGS: 00010286
RAX: 0000000000000026 RBX: ffff8881300df2c0 RCX: 0000000000000027
RDX: 0000000000000000 RSI: ffff88813bd58040 RDI: ffff88813bd58048
RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000001
R10: ffff8881300df2c0 R11: ffffc90000527c78 R12: ffff8881300df340
R13: ffff8881300df930 R14: ffff88810b3dad80 R15: ffff8881300df4f8
FS:  00007f739de8fb80(0000) GS:ffff88813bd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000a01b008 CR3: 0000000111b64003 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 smc_release+0x353/0x3f0
 __sock_release+0x3d/0xb0
 sock_close+0x11/0x20
 __fput+0x93/0x230
 task_work_run+0x65/0xa0
 exit_to_user_mode_prepare+0xf9/0x100
 syscall_exit_to_user_mode+0x27/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This patch adds check in __smc_release() to make
sure we won't do an extra sock_put() and set the
socket to CLOSED when its already in CLOSED state.

Fixes: 51f1de79ad8e (net/smc: replace sock_put worker by socket refcounting)
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/af_smc.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0cf7ed2f5d41..59284da9116d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -149,14 +149,18 @@ static int __smc_release(struct smc_sock *smc)
 		sock_set_flag(sk, SOCK_DEAD);
 		sk->sk_shutdown |= SHUTDOWN_MASK;
 	} else {
-		if (sk->sk_state != SMC_LISTEN && sk->sk_state != SMC_INIT)
-			sock_put(sk); /* passive closing */
-		if (sk->sk_state == SMC_LISTEN) {
-			/* wake up clcsock accept */
-			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
+		if (sk->sk_state != SMC_CLOSED) {
+			if (sk->sk_state != SMC_LISTEN &&
+			    sk->sk_state != SMC_INIT)
+				sock_put(sk); /* passive closing */
+			if (sk->sk_state == SMC_LISTEN) {
+				/* wake up clcsock accept */
+				rc = kernel_sock_shutdown(smc->clcsock,
+							  SHUT_RDWR);
+			}
+			sk->sk_state = SMC_CLOSED;
+			sk->sk_state_change(sk);
 		}
-		sk->sk_state = SMC_CLOSED;
-		sk->sk_state_change(sk);
 		smc_restore_fallback_changes(smc);
 	}
 
-- 
2.19.1.3.ge56e4f7

