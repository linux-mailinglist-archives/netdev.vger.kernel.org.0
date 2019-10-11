Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524C6D37CE
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfJKDSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:18:15 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:39452 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKDSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:18:15 -0400
Received: by mail-pg1-f201.google.com with SMTP id m20so5931892pgv.6
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4lhqAldasenN+flr1zqipm1RRVuJ2FQbrgcVtENJHFI=;
        b=Zf+8bDSbmSaMzlFFyILwDqzC1oUfwEdamaJqTXGkDspyfVcx0R/ml2Q4Uq75v2cVjE
         /G023Y/sxCCryupBbWotmRfD9unpT5Ocii2UCwPqCffUesiD9Uu381TjuctwnSVvGvmE
         FxXUTFCmk+eVzHZEeNLI2TDddg3Fd4loddMP5wqfbJfcq4OCv6wvQEbOxkY4MJMNfEId
         EG1CZbX5uOW/m/ct20LvFa/spP5yqBoKpBz/4gozVkFWk4pg91M9pxD4mhlSQshtOGDf
         UCtdVkIdhHPhCAZrA9ua6vFmYtHo6+WFmi8KuCsYDa/+M9P9hcrP/ZAvPD9zE/dWhTPv
         uX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4lhqAldasenN+flr1zqipm1RRVuJ2FQbrgcVtENJHFI=;
        b=c00SjY98KF9gQZwpOwJmZNUDY7mntaDdxRpDU4ZlB7nQjvZC7FTVylF1IRdVbGf+g+
         TZ31ueovGS8F+3nrtZO7V51Ip5GzsuAfknS3v8LDsuZLl7pAdBeo7tViLPR8c7jJ/uKG
         A9EYABEfpCXC1VriqFSHfE5kj0UqKbEn2AgQ7Lwlyz7a52mY0d16Re0xD+Cr6zNKL+rO
         t3BLZ5k+d4qcjqkztvKguDtS1qQaEBLlEXSgEnn82JSjkJ9LgFErCDEzdqSB/JGo+M7N
         HxNo0VLOR9CTYPXHr0q0Jn5PL/+qHx4jeXqBBZiDJaC3NLplo6msUgr40s0CxWUDi/6g
         M9AQ==
X-Gm-Message-State: APjAAAUan8COHyRIGtWrLj7/FLzzLfkbcLO2ckYAGwtOU5HsyxJ4mryi
        ah9Fop64u++R+bjBcsOx4wui14l3RT8Dfg==
X-Google-Smtp-Source: APXvYqxMqVgqGFuQhKCyivRMDriX0OQi36/2UBp7W+h6Ji6WCFdTgVMbuugE9E87V4vCNj+P8xhgcB9RO0ye1w==
X-Received: by 2002:a63:cd08:: with SMTP id i8mr14732506pgg.45.1570763893640;
 Thu, 10 Oct 2019 20:18:13 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:41 -0700
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
Message-Id: <20191011031746.16220-5-edumazet@google.com>
Mime-Version: 1.0
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 4/9] tcp: annotate tp->write_seq lockless reads
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

There are few places where we fetch tp->write_seq while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write sides use corresponding WRITE_ONCE() to avoid
store-tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h        |  2 +-
 net/ipv4/tcp.c           | 20 ++++++++++++--------
 net/ipv4/tcp_diag.c      |  2 +-
 net/ipv4/tcp_ipv4.c      | 21 ++++++++++++---------
 net/ipv4/tcp_minisocks.c |  2 +-
 net/ipv4/tcp_output.c    |  4 ++--
 net/ipv6/tcp_ipv6.c      | 13 +++++++------
 7 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 35f6f7e0fdc29d303614c101d172d87d9a4ed28d..8e7c3f6801a935c2ef4c76e7e3790ce39adcf5cb 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1917,7 +1917,7 @@ static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 static inline bool tcp_stream_memory_free(const struct sock *sk, int wake)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
-	u32 notsent_bytes = tp->write_seq - tp->snd_nxt;
+	u32 notsent_bytes = READ_ONCE(tp->write_seq) - tp->snd_nxt;
 
 	return (notsent_bytes << wake) < tcp_notsent_lowat(tp);
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c322ad071e1773a07e4f1bf98adf6dd65f6506b1..96dd65cbeb85732cb14dd30b73b97c9aca4e26c3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -616,7 +616,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
 			answ = 0;
 		else
-			answ = tp->write_seq - tp->snd_una;
+			answ = READ_ONCE(tp->write_seq) - tp->snd_una;
 		break;
 	case SIOCOUTQNSD:
 		if (sk->sk_state == TCP_LISTEN)
@@ -625,7 +625,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
 			answ = 0;
 		else
-			answ = tp->write_seq - tp->snd_nxt;
+			answ = READ_ONCE(tp->write_seq) - tp->snd_nxt;
 		break;
 	default:
 		return -ENOIOCTLCMD;
@@ -1035,7 +1035,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		sk->sk_wmem_queued += copy;
 		sk_mem_charge(sk, copy);
 		skb->ip_summed = CHECKSUM_PARTIAL;
-		tp->write_seq += copy;
+		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
 		TCP_SKB_CB(skb)->end_seq += copy;
 		tcp_skb_pcount_set(skb, 0);
 
@@ -1362,7 +1362,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (!copied)
 			TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
 
-		tp->write_seq += copy;
+		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
 		TCP_SKB_CB(skb)->end_seq += copy;
 		tcp_skb_pcount_set(skb, 0);
 
@@ -2562,6 +2562,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int old_state = sk->sk_state;
+	u32 seq;
 
 	if (old_state != TCP_CLOSE)
 		tcp_set_state(sk, TCP_CLOSE);
@@ -2604,9 +2605,12 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->srtt_us = 0;
 	tp->mdev_us = jiffies_to_usecs(TCP_TIMEOUT_INIT);
 	tp->rcv_rtt_last_tsecr = 0;
-	tp->write_seq += tp->max_window + 2;
-	if (tp->write_seq == 0)
-		tp->write_seq = 1;
+
+	seq = tp->write_seq + tp->max_window + 2;
+	if (!seq)
+		seq = 1;
+	WRITE_ONCE(tp->write_seq, seq);
+
 	icsk->icsk_backoff = 0;
 	tp->snd_cwnd = 2;
 	icsk->icsk_probes_out = 0;
@@ -2933,7 +2937,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		if (sk->sk_state != TCP_CLOSE)
 			err = -EPERM;
 		else if (tp->repair_queue == TCP_SEND_QUEUE)
-			tp->write_seq = val;
+			WRITE_ONCE(tp->write_seq, val);
 		else if (tp->repair_queue == TCP_RECV_QUEUE)
 			WRITE_ONCE(tp->rcv_nxt, val);
 		else
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index 66273c8a55c247ca133d8d9cb69c79e6fc3d4dd0..549506162ddeca22f6dd87dfe1c5c13cea6e2b69 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -28,7 +28,7 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 
 		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) -
 					     READ_ONCE(tp->copied_seq), 0);
-		r->idiag_wqueue = tp->write_seq - tp->snd_una;
+		r->idiag_wqueue = READ_ONCE(tp->write_seq) - tp->snd_una;
 	}
 	if (info)
 		tcp_get_info(sk, info);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 39560f482e0b7689903f814fc09322206e24f182..6be568334848c7841a4a09126937f71f60420103 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -164,9 +164,11 @@ int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 		 * without appearing to create any others.
 		 */
 		if (likely(!tp->repair)) {
-			tp->write_seq = tcptw->tw_snd_nxt + 65535 + 2;
-			if (tp->write_seq == 0)
-				tp->write_seq = 1;
+			u32 seq = tcptw->tw_snd_nxt + 65535 + 2;
+
+			if (!seq)
+				seq = 1;
+			WRITE_ONCE(tp->write_seq, seq);
 			tp->rx_opt.ts_recent	   = tcptw->tw_ts_recent;
 			tp->rx_opt.ts_recent_stamp = tcptw->tw_ts_recent_stamp;
 		}
@@ -253,7 +255,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		tp->rx_opt.ts_recent	   = 0;
 		tp->rx_opt.ts_recent_stamp = 0;
 		if (likely(!tp->repair))
-			tp->write_seq	   = 0;
+			WRITE_ONCE(tp->write_seq, 0);
 	}
 
 	inet->inet_dport = usin->sin_port;
@@ -291,10 +293,11 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 
 	if (likely(!tp->repair)) {
 		if (!tp->write_seq)
-			tp->write_seq = secure_tcp_seq(inet->inet_saddr,
-						       inet->inet_daddr,
-						       inet->inet_sport,
-						       usin->sin_port);
+			WRITE_ONCE(tp->write_seq,
+				   secure_tcp_seq(inet->inet_saddr,
+						  inet->inet_daddr,
+						  inet->inet_sport,
+						  usin->sin_port));
 		tp->tsoffset = secure_tcp_ts_off(sock_net(sk),
 						 inet->inet_saddr,
 						 inet->inet_daddr);
@@ -2461,7 +2464,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
 			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
 		i, src, srcp, dest, destp, state,
-		tp->write_seq - tp->snd_una,
+		READ_ONCE(tp->write_seq) - tp->snd_una,
 		rx_queue,
 		timer_active,
 		jiffies_delta_to_clock_t(timer_expires - jiffies),
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index c4731d26ab4a5a23e74d72889365ae4e3f2e0958..33994469032936bc1ff36bc95bf22fba7cdfa180 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -498,7 +498,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->total_retrans = req->num_retrans;
 
 	tcp_init_xmit_timers(newsk);
-	newtp->write_seq = newtp->pushed_seq = treq->snt_isn + 1;
+	WRITE_ONCE(newtp->write_seq, newtp->pushed_seq = treq->snt_isn + 1);
 
 	if (sock_flag(newsk, SOCK_KEEPOPEN))
 		inet_csk_reset_keepalive_timer(newsk,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 7dda12720169b89eb112f217ac1b73012aa5beaf..c17c2a78809d3daf9a5b44ffe1fa286582729273 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1196,7 +1196,7 @@ static void tcp_queue_skb(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	/* Advance write_seq and place onto the write_queue. */
-	tp->write_seq = TCP_SKB_CB(skb)->end_seq;
+	WRITE_ONCE(tp->write_seq, TCP_SKB_CB(skb)->end_seq);
 	__skb_header_release(skb);
 	tcp_add_write_queue_tail(sk, skb);
 	sk->sk_wmem_queued += skb->truesize;
@@ -3449,7 +3449,7 @@ static void tcp_connect_queue_skb(struct sock *sk, struct sk_buff *skb)
 	__skb_header_release(skb);
 	sk->sk_wmem_queued += skb->truesize;
 	sk_mem_charge(sk, skb->truesize);
-	tp->write_seq = tcb->end_seq;
+	WRITE_ONCE(tp->write_seq, tcb->end_seq);
 	tp->packets_out += tcp_skb_pcount(skb);
 }
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index a62c7042fc4a478d501d6cd32a7b446bd411249d..4804b6dc5e6519a457e631bc1438a14f85477567 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -215,7 +215,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	    !ipv6_addr_equal(&sk->sk_v6_daddr, &usin->sin6_addr)) {
 		tp->rx_opt.ts_recent = 0;
 		tp->rx_opt.ts_recent_stamp = 0;
-		tp->write_seq = 0;
+		WRITE_ONCE(tp->write_seq, 0);
 	}
 
 	sk->sk_v6_daddr = usin->sin6_addr;
@@ -311,10 +311,11 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 	if (likely(!tp->repair)) {
 		if (!tp->write_seq)
-			tp->write_seq = secure_tcpv6_seq(np->saddr.s6_addr32,
-							 sk->sk_v6_daddr.s6_addr32,
-							 inet->inet_sport,
-							 inet->inet_dport);
+			WRITE_ONCE(tp->write_seq,
+				   secure_tcpv6_seq(np->saddr.s6_addr32,
+						    sk->sk_v6_daddr.s6_addr32,
+						    inet->inet_sport,
+						    inet->inet_dport));
 		tp->tsoffset = secure_tcpv6_ts_off(sock_net(sk),
 						   np->saddr.s6_addr32,
 						   sk->sk_v6_daddr.s6_addr32);
@@ -1907,7 +1908,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		   dest->s6_addr32[0], dest->s6_addr32[1],
 		   dest->s6_addr32[2], dest->s6_addr32[3], destp,
 		   state,
-		   tp->write_seq - tp->snd_una,
+		   READ_ONCE(tp->write_seq) - tp->snd_una,
 		   rx_queue,
 		   timer_active,
 		   jiffies_delta_to_clock_t(timer_expires - jiffies),
-- 
2.23.0.700.g56cf767bdb-goog

