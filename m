Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730EDD37CC
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfJKDSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:18:09 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:45938 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKDSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:18:08 -0400
Received: by mail-pl1-f202.google.com with SMTP id t12so5165515plo.12
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QTe9jqjnt+UWIgEzzS7JKF/kyPhTO//d/WjfUHbqoK8=;
        b=fL7YPePNhBwNcVU3La+9lWf8hOOsQeS5pq4nfURhuT/0BahLvFzx5hKps66hNB94AL
         eM1/pJd8w5/wnNn3A45BnACJEGBgLxXxnAFnC/f2ct1A3T71nOHtW14aiXx57dC67jPG
         509vz6ulfk3GjivhCsTvKx6dy4YSB2X8xOV7JybxK009vfUjAiPapKxTbCMRnaUkrAS1
         v7qSJj9DTMXZ22fQXi+gsSIIL/E7KAwM6hdD5jlgkK5+ivurlA7Wz/GoyjupR25yJqVo
         LAQM1HftVdyfuqvxbT9TjhBalyFduxnZtb+giImcRKQ54o5cbXtPv5D2PXM+2EuRK/qX
         8xVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QTe9jqjnt+UWIgEzzS7JKF/kyPhTO//d/WjfUHbqoK8=;
        b=EuvJfAKGYMUoFn96NSlXKT0A7NTOtWMdW7J49Lj9XpZs1cajbh4NrA7Im/TXNBvKfl
         kFA41tPdd02eU7RtYTJHkRB3B4VCygeUoaOoL4MEytsBa9OS6XeDeTg5o/sWhA8vphlx
         kjSGjq4PN2ssDaX/GNYFSdUDDaAAppO4JUgB5xd4PVSJ3GY/P2eVaA6NYSLC1OgXgVkM
         S4UQPrUvdvzdf++PDYKkKLHppY4rkB9oIRdO8YKIKlKRvb2pEAIDH8ZIPL1OY126kKdq
         kkPsPjrQk8HBDwBgQKiT92/8icJuWEP3BLeXYKKlQqFQYNrkuPDexXNKEhZ7KTSLqsEK
         RvhA==
X-Gm-Message-State: APjAAAV8dnUCNrM/k8mGQ+JsdFKx9e9INYh/dJWI3OmXVCPPOKOKzx7X
        dntBCMCRE6aM35lckTRb6Gpiuzn33GVPXg==
X-Google-Smtp-Source: APXvYqxu+strdeoBTWwRXol7xLvzfawsd89eBJqWLYNj4SU0LLhqUxHwN6v9hDH7Na/u57p7/1BUOyQ6hsgVFw==
X-Received: by 2002:a63:ff54:: with SMTP id s20mr14067830pgk.398.1570763887619;
 Thu, 10 Oct 2019 20:18:07 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:39 -0700
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
Message-Id: <20191011031746.16220-3-edumazet@google.com>
Mime-Version: 1.0
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 2/9] tcp: annotate tp->rcv_nxt lockless reads
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are few places where we fetch tp->rcv_nxt while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write sides use corresponding WRITE_ONCE() to avoid
store-tearing.

Note that tcp_inq_hint() was already using READ_ONCE(tp->rcv_nxt)

syzbot reported :

BUG: KCSAN: data-race in tcp_poll / tcp_queue_rcv

write to 0xffff888120425770 of 4 bytes by interrupt on cpu 0:
 tcp_rcv_nxt_update net/ipv4/tcp_input.c:3365 [inline]
 tcp_queue_rcv+0x180/0x380 net/ipv4/tcp_input.c:4638
 tcp_rcv_established+0xbf1/0xf50 net/ipv4/tcp_input.c:5616
 tcp_v4_do_rcv+0x381/0x4e0 net/ipv4/tcp_ipv4.c:1542
 tcp_v4_rcv+0x1a03/0x1bf0 net/ipv4/tcp_ipv4.c:1923
 ip_protocol_deliver_rcu+0x51/0x470 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x110/0x140 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_local_deliver+0x133/0x210 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x121/0x160 net/ipv4/ip_input.c:413
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_rcv+0x18f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5004
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5118
 netif_receive_skb_internal+0x59/0x190 net/core/dev.c:5208
 napi_skb_finish net/core/dev.c:5671 [inline]
 napi_gro_receive+0x28f/0x330 net/core/dev.c:5704
 receive_buf+0x284/0x30b0 drivers/net/virtio_net.c:1061

read to 0xffff888120425770 of 4 bytes by task 7254 on cpu 1:
 tcp_stream_is_readable net/ipv4/tcp.c:480 [inline]
 tcp_poll+0x204/0x6b0 net/ipv4/tcp.c:554
 sock_poll+0xed/0x250 net/socket.c:1256
 vfs_poll include/linux/poll.h:90 [inline]
 ep_item_poll.isra.0+0x90/0x190 fs/eventpoll.c:892
 ep_send_events_proc+0x113/0x5c0 fs/eventpoll.c:1749
 ep_scan_ready_list.constprop.0+0x189/0x500 fs/eventpoll.c:704
 ep_send_events fs/eventpoll.c:1793 [inline]
 ep_poll+0xe3/0x900 fs/eventpoll.c:1930
 do_epoll_wait+0x162/0x180 fs/eventpoll.c:2294
 __do_sys_epoll_pwait fs/eventpoll.c:2325 [inline]
 __se_sys_epoll_pwait fs/eventpoll.c:2311 [inline]
 __x64_sys_epoll_pwait+0xcd/0x170 fs/eventpoll.c:2311
 do_syscall_64+0xcf/0x2f0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7254 Comm: syz-fuzzer Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/tcp.c           | 4 ++--
 net/ipv4/tcp_diag.c      | 2 +-
 net/ipv4/tcp_input.c     | 6 +++---
 net/ipv4/tcp_ipv4.c      | 3 ++-
 net/ipv4/tcp_minisocks.c | 7 +++++--
 net/ipv6/tcp_ipv6.c      | 3 ++-
 6 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c59d0bd29c5c6fcbe38edb12b37c47ba4ed68899..883ee863db434b90096cdb4a597ae43c95711ad7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -477,7 +477,7 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
 					  int target, struct sock *sk)
 {
-	return (tp->rcv_nxt - tp->copied_seq >= target) ||
+	return (READ_ONCE(tp->rcv_nxt) - tp->copied_seq >= target) ||
 		(sk->sk_prot->stream_memory_read ?
 		sk->sk_prot->stream_memory_read(sk) : false);
 }
@@ -2935,7 +2935,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		else if (tp->repair_queue == TCP_SEND_QUEUE)
 			tp->write_seq = val;
 		else if (tp->repair_queue == TCP_RECV_QUEUE)
-			tp->rcv_nxt = val;
+			WRITE_ONCE(tp->rcv_nxt, val);
 		else
 			err = -EINVAL;
 		break;
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index 81a8221d650a94be53d17354c60ddd0c655eaccf..cd219161f1061cf2625a3ee476410ab95fd2ccec 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -26,7 +26,7 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	} else if (sk->sk_type == SOCK_STREAM) {
 		const struct tcp_sock *tp = tcp_sk(sk);
 
-		r->idiag_rqueue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
+		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) - tp->copied_seq, 0);
 		r->idiag_wqueue = tp->write_seq - tp->snd_una;
 	}
 	if (info)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5f9b102c3b55c5a40bceb945d0f5d288f682824c..5b7c8768ed5f63ec7e8b3bdd335ce437ce716799 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3362,7 +3362,7 @@ static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
 
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_received += delta;
-	tp->rcv_nxt = seq;
+	WRITE_ONCE(tp->rcv_nxt, seq);
 }
 
 /* Update our send window.
@@ -5932,7 +5932,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		/* Ok.. it's good. Set up sequence numbers and
 		 * move to established.
 		 */
-		tp->rcv_nxt = TCP_SKB_CB(skb)->seq + 1;
+		WRITE_ONCE(tp->rcv_nxt, TCP_SKB_CB(skb)->seq + 1);
 		tp->rcv_wup = TCP_SKB_CB(skb)->seq + 1;
 
 		/* RFC1323: The window in SYN & SYN/ACK segments is
@@ -6035,7 +6035,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			tp->tcp_header_len = sizeof(struct tcphdr);
 		}
 
-		tp->rcv_nxt = TCP_SKB_CB(skb)->seq + 1;
+		WRITE_ONCE(tp->rcv_nxt, TCP_SKB_CB(skb)->seq + 1);
 		tp->copied_seq = tp->rcv_nxt;
 		tp->rcv_wup = TCP_SKB_CB(skb)->seq + 1;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ffa366099eb29145c37341ca00976844cd1185dc..5089dd6bee0ffaef22a5f1cd9a4bbcf4d68d4f3d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2455,7 +2455,8 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 		/* Because we don't lock the socket,
 		 * we might find a transient negative value.
 		 */
-		rx_queue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
+		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
+				      tp->copied_seq, 0);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
 			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 5401dbd39c8fd34d147e0202a410dfc7cefafc26..adc6ce486a383caad502db05f51cdc7205fe009c 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -462,6 +462,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	struct tcp_request_sock *treq = tcp_rsk(req);
 	struct inet_connection_sock *newicsk;
 	struct tcp_sock *oldtp, *newtp;
+	u32 seq;
 
 	if (!newsk)
 		return NULL;
@@ -475,8 +476,10 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	/* Now setup tcp_sock */
 	newtp->pred_flags = 0;
 
-	newtp->rcv_wup = newtp->copied_seq =
-	newtp->rcv_nxt = treq->rcv_isn + 1;
+	seq = treq->rcv_isn + 1;
+	newtp->rcv_wup = seq;
+	newtp->copied_seq = seq;
+	WRITE_ONCE(newtp->rcv_nxt, seq);
 	newtp->segs_in = 1;
 
 	newtp->snd_sml = newtp->snd_una =
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 45a95e032bdfe8ffb05309bed8a967ee08690293..89ea0a7018b567aacefba9e8570607629d1185a8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1895,7 +1895,8 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		/* Because we don't lock the socket,
 		 * we might find a transient negative value.
 		 */
-		rx_queue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
+		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
+				      tp->copied_seq, 0);
 
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-- 
2.23.0.700.g56cf767bdb-goog

