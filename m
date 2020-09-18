Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD40126F176
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgIRCv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728084AbgIRCIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 127A023770;
        Fri, 18 Sep 2020 02:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394903;
        bh=GvuGjSjWwz0DFmHpgx+jzVuphObB9/IiWmb8l5lUXQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2/W8pUDz3ZOGhPvMuW2CJl4dTxWm2e8U5o06pGKBks62U7aAa15pFZii3s6GLBlT
         720DS7D45v/hJfuPK1ICIeuRaFk4SW2DoTceh3P2L6QvBOa/Dup1rpUblr+bEQbwOz
         0C8LQHD7suXMRNJlojUi97GgHWp8aatuORekrCOk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 017/206] net: silence data-races on sk_backlog.tail
Date:   Thu, 17 Sep 2020 22:04:53 -0400
Message-Id: <20200918020802.2065198-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9ed498c6280a2f2b51d02df96df53037272ede49 ]

sk->sk_backlog.tail might be read without holding the socket spinlock,
we need to add proper READ_ONCE()/WRITE_ONCE() to silence the warnings.

KCSAN reported :

BUG: KCSAN: data-race in tcp_add_backlog / tcp_recvmsg

write to 0xffff8881265109f8 of 8 bytes by interrupt on cpu 1:
 __sk_add_backlog include/net/sock.h:907 [inline]
 sk_add_backlog include/net/sock.h:938 [inline]
 tcp_add_backlog+0x476/0xce0 net/ipv4/tcp_ipv4.c:1759
 tcp_v4_rcv+0x1a70/0x1bd0 net/ipv4/tcp_ipv4.c:1947
 ip_protocol_deliver_rcu+0x4d/0x420 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x110/0x140 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_local_deliver+0x133/0x210 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x121/0x160 net/ipv4/ip_input.c:413
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_rcv+0x18f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:4929
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5043
 netif_receive_skb_internal+0x59/0x190 net/core/dev.c:5133
 napi_skb_finish net/core/dev.c:5596 [inline]
 napi_gro_receive+0x28f/0x330 net/core/dev.c:5629
 receive_buf+0x284/0x30b0 drivers/net/virtio_net.c:1061
 virtnet_receive drivers/net/virtio_net.c:1323 [inline]
 virtnet_poll+0x436/0x7d0 drivers/net/virtio_net.c:1428
 napi_poll net/core/dev.c:6311 [inline]
 net_rx_action+0x3ae/0xa90 net/core/dev.c:6379
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0xbb/0xe0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 do_IRQ+0xa6/0x180 arch/x86/kernel/irq.c:263
 ret_from_intr+0x0/0x19
 native_safe_halt+0xe/0x10 arch/x86/kernel/paravirt.c:71
 arch_cpu_idle+0x1f/0x30 arch/x86/kernel/process.c:571
 default_idle_call+0x1e/0x40 kernel/sched/idle.c:94
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x1af/0x280 kernel/sched/idle.c:263
 cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:355
 start_secondary+0x208/0x260 arch/x86/kernel/smpboot.c:264
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

read to 0xffff8881265109f8 of 8 bytes by task 8057 on cpu 0:
 tcp_recvmsg+0x46e/0x1b40 net/ipv4/tcp.c:2050
 inet_recvmsg+0xbb/0x250 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec net/socket.c:871 [inline]
 sock_recvmsg net/socket.c:889 [inline]
 sock_recvmsg+0x92/0xb0 net/socket.c:885
 sock_read_iter+0x15f/0x1e0 net/socket.c:967
 call_read_iter include/linux/fs.h:1889 [inline]
 new_sync_read+0x389/0x4f0 fs/read_write.c:414
 __vfs_read+0xb1/0xc0 fs/read_write.c:427
 vfs_read fs/read_write.c:461 [inline]
 vfs_read+0x143/0x2c0 fs/read_write.c:446
 ksys_read+0xd5/0x1b0 fs/read_write.c:587
 __do_sys_read fs/read_write.c:597 [inline]
 __se_sys_read fs/read_write.c:595 [inline]
 __x64_sys_read+0x4c/0x60 fs/read_write.c:595
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 8057 Comm: syz-fuzzer Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 10 +++++-----
 include/net/sock.h                      |  4 ++--
 net/ipv4/tcp.c                          |  2 +-
 net/llc/af_llc.c                        |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 1e0cc96306dd7..2c1f3ddb0cc79 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1449,7 +1449,7 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 				      csk->wr_max_credits))
 			sk->sk_write_space(sk);
 
-		if (copied >= target && !sk->sk_backlog.tail)
+		if (copied >= target && !READ_ONCE(sk->sk_backlog.tail))
 			break;
 
 		if (copied) {
@@ -1482,7 +1482,7 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 				break;
 			}
 		}
-		if (sk->sk_backlog.tail) {
+		if (READ_ONCE(sk->sk_backlog.tail)) {
 			release_sock(sk);
 			lock_sock(sk);
 			chtls_cleanup_rbuf(sk, copied);
@@ -1627,7 +1627,7 @@ static int peekmsg(struct sock *sk, struct msghdr *msg,
 			break;
 		}
 
-		if (sk->sk_backlog.tail) {
+		if (READ_ONCE(sk->sk_backlog.tail)) {
 			/* Do not sleep, just process backlog. */
 			release_sock(sk);
 			lock_sock(sk);
@@ -1759,7 +1759,7 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 				      csk->wr_max_credits))
 			sk->sk_write_space(sk);
 
-		if (copied >= target && !sk->sk_backlog.tail)
+		if (copied >= target && !READ_ONCE(sk->sk_backlog.tail))
 			break;
 
 		if (copied) {
@@ -1790,7 +1790,7 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			}
 		}
 
-		if (sk->sk_backlog.tail) {
+		if (READ_ONCE(sk->sk_backlog.tail)) {
 			release_sock(sk);
 			lock_sock(sk);
 			chtls_cleanup_rbuf(sk, copied);
diff --git a/include/net/sock.h b/include/net/sock.h
index 77f36257cac97..bc752237dff3f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -900,11 +900,11 @@ static inline void __sk_add_backlog(struct sock *sk, struct sk_buff *skb)
 	skb_dst_force(skb);
 
 	if (!sk->sk_backlog.tail)
-		sk->sk_backlog.head = skb;
+		WRITE_ONCE(sk->sk_backlog.head, skb);
 	else
 		sk->sk_backlog.tail->next = skb;
 
-	sk->sk_backlog.tail = skb;
+	WRITE_ONCE(sk->sk_backlog.tail, skb);
 	skb->next = NULL;
 }
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 616ff2970f4fc..4ce3397e6fcf7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2038,7 +2038,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 		/* Well, if we have backlog, try to process it now yet. */
 
-		if (copied >= target && !sk->sk_backlog.tail)
+		if (copied >= target && !READ_ONCE(sk->sk_backlog.tail))
 			break;
 
 		if (copied) {
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 6ead3c39f3566..bcba579e292ff 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -785,7 +785,7 @@ static int llc_ui_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		}
 		/* Well, if we have backlog, try to process it now yet. */
 
-		if (copied >= target && !sk->sk_backlog.tail)
+		if (copied >= target && !READ_ONCE(sk->sk_backlog.tail))
 			break;
 
 		if (copied) {
-- 
2.25.1

