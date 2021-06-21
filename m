Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314453AF30C
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhFUR6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231755AbhFUR4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8EE76135D;
        Mon, 21 Jun 2021 17:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298005;
        bh=RzxDdIN5EDuz7jc7Z+FNQzLcj8ro80T6F2VwM5zCKXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cu0ekAOgjzfa8Y0rgxtqz2E8TX9fGY7vBFExek93vFlM482UXSlgLJADdqAe1nh28
         7jC7vE64ptEm/z2+aMAhuUvGyWTRKFCruNaNlQmUUBbxISMJDYduO9GaEcv6qiIY+M
         GMGbEcklOX79+OqmsuylAz96rTqllyZe1DaqGgTQnizMYmltL08p7HmhmJZtsFdXCv
         dlesDOSE6FEfX/rhu/+XoJE/WVkT/VNmucD/U9cMTZWPz1TFFoF+e9yfZ4990ATrKp
         SF+cixBUQUUDFc/7vXbSNUCMPUBmUMrzXLStUKy8cwLRUHRVBIVJ6vZEvaOAsNc3+b
         95EbrvxJx5HAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/35] net: annotate data race in sock_error()
Date:   Mon, 21 Jun 2021 13:52:42 -0400
Message-Id: <20210621175300.735437-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f13ef10059ccf5f4ed201cd050176df62ec25bb8 ]

sock_error() is known to be racy. The code avoids
an atomic operation is sk_err is zero, and this field
could be changed under us, this is fine.

Sysbot reported:

BUG: KCSAN: data-race in sock_alloc_send_pskb / unix_release_sock

write to 0xffff888131855630 of 4 bytes by task 9365 on cpu 1:
 unix_release_sock+0x2e9/0x6e0 net/unix/af_unix.c:550
 unix_release+0x2f/0x50 net/unix/af_unix.c:859
 __sock_release net/socket.c:599 [inline]
 sock_close+0x6c/0x150 net/socket.c:1258
 __fput+0x25b/0x4e0 fs/file_table.c:280
 ____fput+0x11/0x20 fs/file_table.c:313
 task_work_run+0xae/0x130 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x156/0x190 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:301
 do_syscall_64+0x56/0x90 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888131855630 of 4 bytes by task 9385 on cpu 0:
 sock_error include/net/sock.h:2269 [inline]
 sock_alloc_send_pskb+0xe4/0x4e0 net/core/sock.c:2336
 unix_dgram_sendmsg+0x478/0x1610 net/unix/af_unix.c:1671
 unix_seqpacket_sendmsg+0xc2/0x100 net/unix/af_unix.c:2055
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 __sys_sendmsg_sock+0x25/0x30 net/socket.c:2416
 io_sendmsg fs/io_uring.c:4367 [inline]
 io_issue_sqe+0x231a/0x6750 fs/io_uring.c:6135
 __io_queue_sqe+0xe9/0x360 fs/io_uring.c:6414
 __io_req_task_submit fs/io_uring.c:2039 [inline]
 io_async_task_func+0x312/0x590 fs/io_uring.c:5074
 __tctx_task_work fs/io_uring.c:1910 [inline]
 tctx_task_work+0x1d4/0x3d0 fs/io_uring.c:1924
 task_work_run+0xae/0x130 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:145 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0xf8/0x190 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:301
 do_syscall_64+0x56/0x90 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0x00000068

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 9385 Comm: syz-executor.3 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index f68184b8c0aa..9199ab7ab2da 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2232,8 +2232,13 @@ struct sk_buff *sock_dequeue_err_skb(struct sock *sk);
 static inline int sock_error(struct sock *sk)
 {
 	int err;
-	if (likely(!sk->sk_err))
+
+	/* Avoid an atomic operation for the common case.
+	 * This is racy since another cpu/thread can change sk_err under us.
+	 */
+	if (likely(data_race(!sk->sk_err)))
 		return 0;
+
 	err = xchg(&sk->sk_err, 0);
 	return -err;
 }
-- 
2.30.2

