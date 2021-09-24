Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F7241760D
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345575AbhIXNkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:40:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344429AbhIXNkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 09:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632490739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ybTr5KkUc7OB8bdojeHmsNtY0fywhpsHQhE+7ucgF6o=;
        b=JpXdV/Z5ixJ9EIeAeeAj1df1yTLkIsjq6cRy0xO6wy8XN80wgSLZz08/Dam2YAE9c5rOD9
        vWfZegUnQDHZhI6XR2MDD0kDy/uEhKzhLsPa5bHw+ekvEyiQ4/zCjJupdZ5Qv6kr3J1tOE
        Ve2yi/g+YC7XkZufI/TBm36R1K3YERw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-pTg15AwOO46SvVkgZ5Nsqg-1; Fri, 24 Sep 2021 09:38:58 -0400
X-MC-Unique: pTg15AwOO46SvVkgZ5Nsqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 967A41006AAC;
        Fri, 24 Sep 2021 13:38:57 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8E1560C5F;
        Fri, 24 Sep 2021 13:38:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, fwestpha@redhat.com
Subject: [PATCH v2 mptcp-net] mptcp: fix possible stall on recvmsg()
Date:   Fri, 24 Sep 2021 15:38:46 +0200
Message-Id: <9052bd061a82d1527fa34a74939c0df7f69cdf54.1632490689.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

recvmsg() can enter an infinite loop if the caller provides the
MSG_WAITALL, the data present in the receive queue is not
sufficient to fulfill the request and no more data is received by
the peer.

When the above happens, mptcp_wait_data() will always return with
no wait, as the MPTCP_DATA_READY flag checked by such function is
set and never cleared in such code path.

Leveraging the above syzbot was able to trigger an RCU stall:

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu:    0-...!: (10499 ticks this GP) idle=0af/1/0x4000000000000000 softirq=10678/10678 fqs=1
        (t=10500 jiffies g=13089 q=109)
rcu: rcu_preempt kthread starved for 10497 jiffies! g13089 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28696 pid:   14 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:4955 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6236
 schedule+0xd3/0x270 kernel/sched/core.c:6315
 schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1881
 rcu_gp_fqs_loop+0x186/0x810 kernel/rcu/tree.c:1955
 rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2128
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 8510 Comm: syz-executor827 Not tainted 5.15.0-rc2-next-20210920-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:84 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:102 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:128 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:159 [inline]
RIP: 0010:check_region_inline mm/kasan/generic.c:180 [inline]
RIP: 0010:kasan_check_range+0xc8/0x180 mm/kasan/generic.c:189
Code: 38 00 74 ed 48 8d 50 08 eb 09 48 83 c0 01 48 39 d0 74 7a 80 38 00 74 f2 48 89 c2 b8 01 00 00 00 48 85 d2 75 56 5b 5d 41 5c c3 <48> 85 d2 74 5e 48 01 ea eb 09 48 83 c0 01 48 39 d0 74 50 80 38 00
RSP: 0018:ffffc9000cd676c8 EFLAGS: 00000283
RAX: ffffed100e9a110e RBX: ffffed100e9a110f RCX: ffffffff88ea062a
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888074d08870
RBP: ffffed100e9a110e R08: 0000000000000001 R09: ffff888074d08877
R10: ffffed100e9a110e R11: 0000000000000000 R12: ffff888074d08000
R13: ffff888074d08000 R14: ffff888074d08088 R15: ffff888074d08000
FS:  0000555556d8e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
S:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000180 CR3: 0000000068909000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 test_and_clear_bit include/asm-generic/bitops/instrumented-atomic.h:83 [inline]
 mptcp_release_cb+0x14a/0x210 net/mptcp/protocol.c:3016
 release_sock+0xb4/0x1b0 net/core/sock.c:3204
 mptcp_wait_data net/mptcp/protocol.c:1770 [inline]
 mptcp_recvmsg+0xfd1/0x27b0 net/mptcp/protocol.c:2080
 inet6_recvmsg+0x11b/0x5e0 net/ipv6/af_inet6.c:659
 sock_recvmsg_nosec net/socket.c:944 [inline]
 ____sys_recvmsg+0x527/0x600 net/socket.c:2626
 ___sys_recvmsg+0x127/0x200 net/socket.c:2670
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2764
 __sys_recvmmsg net/socket.c:2843 [inline]
 __do_sys_recvmmsg net/socket.c:2866 [inline]
 __se_sys_recvmmsg net/socket.c:2859 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2859
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc200d2dc39
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc5758e5a8 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc200d2dc39
RDX: 0000000000000002 RSI: 00000000200017c0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000f0b5ff
R10: 0000000000000100 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffc5758e5d0 R14: 00007ffc5758e5c0 R15: 0000000000000003

Fix the issue replacing the MPTCP_DATA_READY bit with direct
inspection of the msk receive queue.

Reported-and-tested-by: syzbot+3360da629681aa0d22fe@syzkaller.appspotmail.com
Fixes: 7a6a6cbc3e59 ("mptcp: recvmsg() can drain data from multiple subflow")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
 - instead of do more fiddling with the DATA_READY bit, just
   check sk_receive_queue
---
 net/mptcp/protocol.c | 52 ++++++++++----------------------------------
 1 file changed, 12 insertions(+), 40 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e5df0b5971c8..cc996e8973b3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -528,7 +528,6 @@ static bool mptcp_check_data_fin(struct sock *sk)
 
 		sk->sk_shutdown |= RCV_SHUTDOWN;
 		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
-		set_bit(MPTCP_DATA_READY, &msk->flags);
 
 		switch (sk->sk_state) {
 		case TCP_ESTABLISHED:
@@ -742,10 +741,9 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 
 	/* Wake-up the reader only for in-sequence data */
 	mptcp_data_lock(sk);
-	if (move_skbs_to_msk(msk, ssk)) {
-		set_bit(MPTCP_DATA_READY, &msk->flags);
+	if (move_skbs_to_msk(msk, ssk))
 		sk->sk_data_ready(sk);
-	}
+
 	mptcp_data_unlock(sk);
 }
 
@@ -847,7 +845,6 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 		sk->sk_shutdown |= RCV_SHUTDOWN;
 
 		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
-		set_bit(MPTCP_DATA_READY, &msk->flags);
 		sk->sk_data_ready(sk);
 	}
 
@@ -1759,21 +1756,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	return copied ? : ret;
 }
 
-static void mptcp_wait_data(struct sock *sk, long *timeo)
-{
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	add_wait_queue(sk_sleep(sk), &wait);
-	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-
-	sk_wait_event(sk, timeo,
-		      test_bit(MPTCP_DATA_READY, &msk->flags), &wait);
-
-	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
-	remove_wait_queue(sk_sleep(sk), &wait);
-}
-
 static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 				struct msghdr *msg,
 				size_t len, int flags,
@@ -2077,19 +2059,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		}
 
 		pr_debug("block timeout %ld", timeo);
-		mptcp_wait_data(sk, &timeo);
-	}
-
-	if (skb_queue_empty_lockless(&sk->sk_receive_queue) &&
-	    skb_queue_empty(&msk->receive_queue)) {
-		/* entire backlog drained, clear DATA_READY. */
-		clear_bit(MPTCP_DATA_READY, &msk->flags);
-
-		/* .. race-breaker: ssk might have gotten new data
-		 * after last __mptcp_move_skbs() returned false.
-		 */
-		if (unlikely(__mptcp_move_skbs(msk)))
-			set_bit(MPTCP_DATA_READY, &msk->flags);
+		sk_wait_data(sk, &timeo, NULL);
 	}
 
 out_err:
@@ -2098,9 +2068,9 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			tcp_recv_timestamp(msg, sk, &tss);
 	}
 
-	pr_debug("msk=%p data_ready=%d rx queue empty=%d copied=%d",
-		 msk, test_bit(MPTCP_DATA_READY, &msk->flags),
-		 skb_queue_empty_lockless(&sk->sk_receive_queue), copied);
+	pr_debug("msk=%p rx queue empty=%d:%d copied=%d",
+		 msk, skb_queue_empty_lockless(&sk->sk_receive_queue),
+		 skb_queue_empty(&msk->receive_queue), copied);
 	if (!(flags & MSG_PEEK))
 		mptcp_rcv_space_adjust(msk, copied);
 
@@ -2368,7 +2338,6 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 	inet_sk_state_store(sk, TCP_CLOSE);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 	smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
-	set_bit(MPTCP_DATA_READY, &msk->flags);
 	set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags);
 
 	mptcp_close_wake_up(sk);
@@ -3385,8 +3354,11 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 
 static __poll_t mptcp_check_readable(struct mptcp_sock *msk)
 {
-	return test_bit(MPTCP_DATA_READY, &msk->flags) ? EPOLLIN | EPOLLRDNORM :
-	       0;
+	if (skb_queue_empty_lockless(&((struct sock *)msk)->sk_receive_queue) &&
+            skb_queue_empty_lockless(&msk->receive_queue))
+		return 0;
+
+	return EPOLLIN | EPOLLRDNORM;
 }
 
 static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
@@ -3421,7 +3393,7 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	state = inet_sk_state_load(sk);
 	pr_debug("msk=%p state=%d flags=%lx", msk, state, msk->flags);
 	if (state == TCP_LISTEN)
-		return mptcp_check_readable(msk);
+		return test_bit(MPTCP_DATA_READY, &msk->flags) ? EPOLLIN | EPOLLRDNORM : 0;
 
 	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
 		mask |= mptcp_check_readable(msk);
-- 
2.26.3

