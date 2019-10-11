Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC16D37CD
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfJKDSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:18:13 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:52117 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKDSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:18:13 -0400
Received: by mail-pf1-f201.google.com with SMTP id s137so6362941pfs.18
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=znAAlOOlPO6BgTzUNiUdzrfghfJl+ODT88x224AkuZE=;
        b=jB6eyBBnEDcr3BfyXD0tDQg+mDpsfFY6wqyPsZkR4oQC4IZHJpBxpuvxyu43dgwsz4
         0HY8ae27zsV8ISxLTAzvwcJrtKdQPcnuvjV2BDQlDpZpn6HVKvtG+DzBT0uFVFcFyrXx
         WBg/fBO0ZhgebYe8And06c1bQZ1yynnjDK8k9X4K+dSDz2D/yN4aEKtCkQuV+zbUB3KT
         VG9VrIHBHOGeNAMkHk1CTQfQPIGDoKfSPTH+iUPF8Vj0FYzz56INmMiHjZuNmc4X1RYd
         E1/HkHrta1c5tzbpacEJtPRsKGgUy6aaz31skiXoLWLaCYhnaXt4J2rk3XD7qZf18LzA
         oFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=znAAlOOlPO6BgTzUNiUdzrfghfJl+ODT88x224AkuZE=;
        b=Bs0jS0E+/cr1e+ZbWVw8YcdltuzmUh4QS9yKX6q5zgmMQ28H9cf8GKI2GgIrLcrkYo
         LaAKmr9NK9UgeadQ1wmj/PPEO1Unrk1osPHFqYx094x71lqaM8kiMoTcbkLLDaK7laGG
         Fy8sf+t8tQgYV1NHhEOx/Jo+KYxlL//BVvO3g5jrGS4GvbNI8anbJI7IJAVZ0XT0AjJs
         RzXzAtgWQkEDE7IbqKA7Jg8oakWM6PSkKJIz5mPlN0lnKcwXwZxQ078kDOUupvcfp1y1
         U97gticPJihwtomEjayCD+x9/uEkfqHflpl0Qt7q+n+bdIjaVJOHJ63pXsybIyVYgzTg
         oC6w==
X-Gm-Message-State: APjAAAWXyLv/Xue4DsvmA/ZeDcJunWrhYmLVkE2FhFtaVY71Nwrijste
        ZUeN0AlK3vLiEQABx/HzrGtVA4SiAGWW5g==
X-Google-Smtp-Source: APXvYqwP+4HRMmXFdb2NBzU9CnlFHM6vHFzoNkIswp/hXCVKywpLGd09DCK/RO6nQBYNot5FGm+J5SM+Rmb5jg==
X-Received: by 2002:a63:575a:: with SMTP id h26mr14672240pgm.178.1570763890609;
 Thu, 10 Oct 2019 20:18:10 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:40 -0700
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
Message-Id: <20191011031746.16220-4-edumazet@google.com>
Mime-Version: 1.0
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 3/9] tcp: annotate tp->copied_seq lockless reads
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are few places where we fetch tp->copied_seq while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write sides use corresponding WRITE_ONCE() to avoid
store-tearing.

Note that tcp_inq_hint() was already using READ_ONCE(tp->copied_seq)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c           | 20 ++++++++++----------
 net/ipv4/tcp_diag.c      |  3 ++-
 net/ipv4/tcp_input.c     |  6 +++---
 net/ipv4/tcp_ipv4.c      |  2 +-
 net/ipv4/tcp_minisocks.c |  2 +-
 net/ipv4/tcp_output.c    |  2 +-
 net/ipv6/tcp_ipv6.c      |  2 +-
 7 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 883ee863db434b90096cdb4a597ae43c95711ad7..c322ad071e1773a07e4f1bf98adf6dd65f6506b1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -477,7 +477,7 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
 					  int target, struct sock *sk)
 {
-	return (READ_ONCE(tp->rcv_nxt) - tp->copied_seq >= target) ||
+	return (READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq) >= target) ||
 		(sk->sk_prot->stream_memory_read ?
 		sk->sk_prot->stream_memory_read(sk) : false);
 }
@@ -546,7 +546,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	    (state != TCP_SYN_RECV || rcu_access_pointer(tp->fastopen_rsk))) {
 		int target = sock_rcvlowat(sk, 0, INT_MAX);
 
-		if (tp->urg_seq == tp->copied_seq &&
+		if (tp->urg_seq == READ_ONCE(tp->copied_seq) &&
 		    !sock_flag(sk, SOCK_URGINLINE) &&
 		    tp->urg_data)
 			target++;
@@ -607,7 +607,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		unlock_sock_fast(sk, slow);
 		break;
 	case SIOCATMARK:
-		answ = tp->urg_data && tp->urg_seq == tp->copied_seq;
+		answ = tp->urg_data && tp->urg_seq == READ_ONCE(tp->copied_seq);
 		break;
 	case SIOCOUTQ:
 		if (sk->sk_state == TCP_LISTEN)
@@ -1668,9 +1668,9 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		sk_eat_skb(sk, skb);
 		if (!desc->count)
 			break;
-		tp->copied_seq = seq;
+		WRITE_ONCE(tp->copied_seq, seq);
 	}
-	tp->copied_seq = seq;
+	WRITE_ONCE(tp->copied_seq, seq);
 
 	tcp_rcv_space_adjust(sk);
 
@@ -1819,7 +1819,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 out:
 	up_read(&current->mm->mmap_sem);
 	if (length) {
-		tp->copied_seq = seq;
+		WRITE_ONCE(tp->copied_seq, seq);
 		tcp_rcv_space_adjust(sk);
 
 		/* Clean up data we have read: This will do ACK frames. */
@@ -2117,7 +2117,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 			if (urg_offset < used) {
 				if (!urg_offset) {
 					if (!sock_flag(sk, SOCK_URGINLINE)) {
-						++*seq;
+						WRITE_ONCE(*seq, *seq + 1);
 						urg_hole++;
 						offset++;
 						used--;
@@ -2139,7 +2139,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 			}
 		}
 
-		*seq += used;
+		WRITE_ONCE(*seq, *seq + used);
 		copied += used;
 		len -= used;
 
@@ -2166,7 +2166,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 found_fin_ok:
 		/* Process the FIN. */
-		++*seq;
+		WRITE_ONCE(*seq, *seq + 1);
 		if (!(flags & MSG_PEEK))
 			sk_eat_skb(sk, skb);
 		break;
@@ -2588,7 +2588,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 		__kfree_skb(sk->sk_rx_skb_cache);
 		sk->sk_rx_skb_cache = NULL;
 	}
-	tp->copied_seq = tp->rcv_nxt;
+	WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 	tp->urg_data = 0;
 	tcp_write_queue_purge(sk);
 	tcp_fastopen_active_disable_ofo_check(sk);
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index cd219161f1061cf2625a3ee476410ab95fd2ccec..66273c8a55c247ca133d8d9cb69c79e6fc3d4dd0 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -26,7 +26,8 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	} else if (sk->sk_type == SOCK_STREAM) {
 		const struct tcp_sock *tp = tcp_sk(sk);
 
-		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) - tp->copied_seq, 0);
+		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) -
+					     READ_ONCE(tp->copied_seq), 0);
 		r->idiag_wqueue = tp->write_seq - tp->snd_una;
 	}
 	if (info)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5b7c8768ed5f63ec7e8b3bdd335ce437ce716799..a30aae3a6a182a3ba3d262171ebd9c1441cd5cd6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5961,7 +5961,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		/* Remember, tcp_poll() does not lock socket!
 		 * Change state from SYN-SENT only after copied_seq
 		 * is initialized. */
-		tp->copied_seq = tp->rcv_nxt;
+		WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 
 		smc_check_reset_syn(tp);
 
@@ -6036,7 +6036,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		}
 
 		WRITE_ONCE(tp->rcv_nxt, TCP_SKB_CB(skb)->seq + 1);
-		tp->copied_seq = tp->rcv_nxt;
+		WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 		tp->rcv_wup = TCP_SKB_CB(skb)->seq + 1;
 
 		/* RFC1323: The window in SYN & SYN/ACK segments is
@@ -6216,7 +6216,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			tcp_try_undo_spurious_syn(sk);
 			tp->retrans_stamp = 0;
 			tcp_init_transfer(sk, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB);
-			tp->copied_seq = tp->rcv_nxt;
+			WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 		}
 		smp_mb();
 		tcp_set_state(sk, TCP_ESTABLISHED);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5089dd6bee0ffaef22a5f1cd9a4bbcf4d68d4f3d..39560f482e0b7689903f814fc09322206e24f182 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2456,7 +2456,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 		 * we might find a transient negative value.
 		 */
 		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
-				      tp->copied_seq, 0);
+				      READ_ONCE(tp->copied_seq), 0);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
 			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index adc6ce486a383caad502db05f51cdc7205fe009c..c4731d26ab4a5a23e74d72889365ae4e3f2e0958 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -478,7 +478,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 
 	seq = treq->rcv_isn + 1;
 	newtp->rcv_wup = seq;
-	newtp->copied_seq = seq;
+	WRITE_ONCE(newtp->copied_seq, seq);
 	WRITE_ONCE(newtp->rcv_nxt, seq);
 	newtp->segs_in = 1;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 84ae4d1449ea7eb9da2c536363b88807f35a4283..7dda12720169b89eb112f217ac1b73012aa5beaf 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3433,7 +3433,7 @@ static void tcp_connect_init(struct sock *sk)
 	else
 		tp->rcv_tstamp = tcp_jiffies32;
 	tp->rcv_wup = tp->rcv_nxt;
-	tp->copied_seq = tp->rcv_nxt;
+	WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 
 	inet_csk(sk)->icsk_rto = tcp_timeout_init(sk);
 	inet_csk(sk)->icsk_retransmits = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 89ea0a7018b567aacefba9e8570607629d1185a8..a62c7042fc4a478d501d6cd32a7b446bd411249d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1896,7 +1896,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		 * we might find a transient negative value.
 		 */
 		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
-				      tp->copied_seq, 0);
+				      READ_ONCE(tp->copied_seq), 0);
 
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-- 
2.23.0.700.g56cf767bdb-goog

