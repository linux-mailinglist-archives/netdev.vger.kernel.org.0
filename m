Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A53F1D1A
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbfKFSEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:04:16 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:47024 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfKFSEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 13:04:16 -0500
Received: by mail-pf1-f202.google.com with SMTP id 187so15294884pfu.13
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 10:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hCigKU6xFbQBdEU04ORL4QnWVuiZ77aLf14SYjf/7t4=;
        b=giyfoDscjVQseGHOxbaKiXJWSQCqq5LYvDjlnxRM6Tiru3QQZuM6Yfki5OOnKhn/kP
         Lji3fx9QVIfixAj9P5Vb7+BeH/nQPO1zVGYqzFJh4AlGTkvHA5tM3n2tOuEbqXW8RqKp
         F67edqyugrLJCgLXJgMn0GSp0l6ECCkx5HxxWPs0UaZKoK8I9tcC1DxyAKIBLbrxtlql
         ZxTU867F278lUtqvxJ+VYRVZ0F3kzbku2IwTtlRByOefKVUJWu+a/pwlnvPS9z0v5jLK
         XAbVa2xBL0pBpgzMvtXZWZJXh5HVzl2hvc8n45RvGNO0yO7LZZaNRRMjfX8DB8wSbqEM
         B1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hCigKU6xFbQBdEU04ORL4QnWVuiZ77aLf14SYjf/7t4=;
        b=Z6HqojHd9DNP7g/rkQoO72ypHmgsJ0+8iVFXdDSozATfk9GGHp2kFZgUPAWOLoOhs8
         vIjvK6V4fO1G7gZPgALLDcb51W9xJsYZ5yFiKjWE/oxMojTE4FbmLullt4Et5vbNI5aU
         4DwcZODKVB9/VDD958s9x1LpNJ+bo26l11uFwPo/HIq7grN1PwOk6xciIqttp7DiLKo2
         ODH9KgpKIItGGZ37Ls4iq0lG1/2gxBuqxNe7lT/VGkSEOVWH4qHtUbP5IIhsULw2QX6e
         eMI7i13kSL2PTV8aaaOvuagIEBEuiYf8cHOjdvUMzd7fv1B/COYV3lcRKU2q3BCwU5Ht
         CM0g==
X-Gm-Message-State: APjAAAUFh7eQlsvxrunfJLqpunSBaSM+2LTuLw2Gky1qWF0bIj1PmZzn
        1lw0j0ECX0x6Py48RH7S+jixrWpnyEAR2Q==
X-Google-Smtp-Source: APXvYqwFd8keDf6HOR8k5DWVM1nRkiAqVH0Yr7hWsa5nTixtBhsfORzzM3MUgY316o/zqbTrQJ4sxkbUlC8XTw==
X-Received: by 2002:a63:a05c:: with SMTP id u28mr4579460pgn.333.1573063455208;
 Wed, 06 Nov 2019 10:04:15 -0800 (PST)
Date:   Wed,  6 Nov 2019 10:04:11 -0800
Message-Id: <20191106180411.113080-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next] net: silence data-races on sk_backlog.tail
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 10 +++++-----
 include/net/sock.h                      |  4 ++--
 net/ipv4/tcp.c                          |  2 +-
 net/llc/af_llc.c                        |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 98bc5a4cd5e7014990f064a92777308ae98b13e4..599dec59c6cc90637dea43f269862df802ba52e8 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1437,7 +1437,7 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 				      csk->wr_max_credits))
 			sk->sk_write_space(sk);
 
-		if (copied >= target && !sk->sk_backlog.tail)
+		if (copied >= target && !READ_ONCE(sk->sk_backlog.tail))
 			break;
 
 		if (copied) {
@@ -1470,7 +1470,7 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 				break;
 			}
 		}
-		if (sk->sk_backlog.tail) {
+		if (READ_ONCE(sk->sk_backlog.tail)) {
 			release_sock(sk);
 			lock_sock(sk);
 			chtls_cleanup_rbuf(sk, copied);
@@ -1615,7 +1615,7 @@ static int peekmsg(struct sock *sk, struct msghdr *msg,
 			break;
 		}
 
-		if (sk->sk_backlog.tail) {
+		if (READ_ONCE(sk->sk_backlog.tail)) {
 			/* Do not sleep, just process backlog. */
 			release_sock(sk);
 			lock_sock(sk);
@@ -1743,7 +1743,7 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 				      csk->wr_max_credits))
 			sk->sk_write_space(sk);
 
-		if (copied >= target && !sk->sk_backlog.tail)
+		if (copied >= target && !READ_ONCE(sk->sk_backlog.tail))
 			break;
 
 		if (copied) {
@@ -1774,7 +1774,7 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			}
 		}
 
-		if (sk->sk_backlog.tail) {
+		if (READ_ONCE(sk->sk_backlog.tail)) {
 			release_sock(sk);
 			lock_sock(sk);
 			chtls_cleanup_rbuf(sk, copied);
diff --git a/include/net/sock.h b/include/net/sock.h
index d4d3ef5ba0490366e1e25884a5edf54186c940d8..bd210c78dc9d00e96c35c2319662adc9bb581185 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -899,11 +899,11 @@ static inline void __sk_add_backlog(struct sock *sk, struct sk_buff *skb)
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
index fb1666440e1064a9ab2f2993b23fdb744e82f5c5..8fb4fefcfd544943e9c92870d4d0da25f3813448 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2047,7 +2047,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 		/* Well, if we have backlog, try to process it now yet. */
 
-		if (copied >= target && !sk->sk_backlog.tail)
+		if (copied >= target && !READ_ONCE(sk->sk_backlog.tail))
 			break;
 
 		if (copied) {
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 50d2c9749db36da84f0e84c254771ee5e6c9cef9..2922d4150d88e2cf63fa75a75f0718b19a558251 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -780,7 +780,7 @@ static int llc_ui_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		}
 		/* Well, if we have backlog, try to process it now yet. */
 
-		if (copied >= target && !sk->sk_backlog.tail)
+		if (copied >= target && !READ_ONCE(sk->sk_backlog.tail))
 			break;
 
 		if (copied) {
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

