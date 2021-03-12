Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669F5338777
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhCLIdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbhCLIde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:33:34 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F8BC061574;
        Fri, 12 Mar 2021 00:33:34 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id s21so4812763pjq.1;
        Fri, 12 Mar 2021 00:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l7GcfrciSHzeUBQFcGqT0M9FB2DYQ7LxbgF7KxX4yTo=;
        b=sfvSKqESlNFIVstI2dGZdxAEXmXfF+1KLvheh5V45r2NGRqJzhpttY8AR7MAhm9OJv
         NXtTLOF91UFxXONnIgZE6ZniNzMFT0pLlhvFjXyP6A9i0dKCM4duqoHLj66xyGeVnu0J
         UQuYiA7SaRg3R3P87Wde/4zo29x/6BCC91QP16rMW4LCXNox3oQ7k/QXn7UW6IJ7AcLI
         EhLV2McOhsrKmScNFm2wo5OZAGGSWP2yESWGiDNeqawWkKmNMLT82HXKA+Btql/ynIMK
         YMEINhUmx/WPIqUBofVYracTg0YHXAl3xSH4PSbGtKNnG0nEXfoO0QuuPG0fRzD06GcX
         +V1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l7GcfrciSHzeUBQFcGqT0M9FB2DYQ7LxbgF7KxX4yTo=;
        b=JQh/s+BBldhOKQ5YzYPImIPc0y8mdW1YOjVGapz+AtCVHEzJAxqvocPirXyYLP2R0n
         KPOzxkt/hMQ2MH5goxCDBALq3Xv9aL8QBW1jSzvSAZ0EDB0tA7Xcnk/JNGMcEGCVOrzd
         9WKB7qJ6BVQZtBw45QXKNvJBQrCF9hRsCeIe0HcWf8m56FS4GGcM3HUB8T7ugMvRdU13
         MJEzZFX4P+tYgTawI9QRBJTPN8e+M+p6FTU03yPtMWTSQb8mo/1ZrIen50+cJ12Y/YUF
         +dATJeJlWBKy87H/4DTNEKJkledzJlRQpnLOYoAsOOwKLW3kQsAnnqoWMxD2NFUuDyps
         zAGw==
X-Gm-Message-State: AOAM533eXGVDsXQRpqcXamrVWYc7Hk2szSEmayPXtmdPtM8xM0eIiEPH
        jhQ3AJH/pVnCNRzalYaw8XI1g9psUb0=
X-Google-Smtp-Source: ABdhPJx+Kuejipv0L83gxQ+MKQZeLnEAZma3OIC2PaN9si+4od+041BbKYMX/ChB8QvtTYV9Xi8LWQ==
X-Received: by 2002:a17:90a:f314:: with SMTP id ca20mr9613684pjb.136.1615538013716;
        Fri, 12 Mar 2021 00:33:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5186:d796:2218:6442])
        by smtp.gmail.com with ESMTPSA id w1sm4258173pgs.15.2021.03.12.00.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 00:33:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 4.19-stable 2/3] tcp: annotate tp->write_seq lockless reads
Date:   Fri, 12 Mar 2021 00:33:22 -0800
Message-Id: <20210312083323.3720479-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210312083323.3720479-1-eric.dumazet@gmail.com>
References: <20210312083323.3720479-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0f31746452e6793ad6271337438af8f4defb8940 ]

There are few places where we fetch tp->write_seq while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write sides use corresponding WRITE_ONCE() to avoid
store-tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
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
index 4fe3ab47b4803700e50346c0a85bc347046f6730..3f0d654984cf43fbbc5a51ebd4d654803d0e3649 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1880,7 +1880,7 @@ static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 static inline bool tcp_stream_memory_free(const struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
-	u32 notsent_bytes = tp->write_seq - tp->snd_nxt;
+	u32 notsent_bytes = READ_ONCE(tp->write_seq) - tp->snd_nxt;
 
 	return notsent_bytes < tcp_notsent_lowat(tp);
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f639c7d6083821c8725f5e28312eff3cbfa82e54..370faff782cd363e82014969331df459b8188d94 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -637,7 +637,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
 			answ = 0;
 		else
-			answ = tp->write_seq - tp->snd_una;
+			answ = READ_ONCE(tp->write_seq) - tp->snd_una;
 		break;
 	case SIOCOUTQNSD:
 		if (sk->sk_state == TCP_LISTEN)
@@ -646,7 +646,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
 			answ = 0;
 		else
-			answ = tp->write_seq - tp->snd_nxt;
+			answ = READ_ONCE(tp->write_seq) - tp->snd_nxt;
 		break;
 	default:
 		return -ENOIOCTLCMD;
@@ -1037,7 +1037,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		sk->sk_wmem_queued += copy;
 		sk_mem_charge(sk, copy);
 		skb->ip_summed = CHECKSUM_PARTIAL;
-		tp->write_seq += copy;
+		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
 		TCP_SKB_CB(skb)->end_seq += copy;
 		tcp_skb_pcount_set(skb, 0);
 
@@ -1391,7 +1391,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (!copied)
 			TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
 
-		tp->write_seq += copy;
+		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
 		TCP_SKB_CB(skb)->end_seq += copy;
 		tcp_skb_pcount_set(skb, 0);
 
@@ -2556,6 +2556,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int old_state = sk->sk_state;
+	u32 seq;
 
 	if (old_state != TCP_CLOSE)
 		tcp_set_state(sk, TCP_CLOSE);
@@ -2593,9 +2594,12 @@ int tcp_disconnect(struct sock *sk, int flags)
 	sock_reset_flag(sk, SOCK_DONE);
 	tp->srtt_us = 0;
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
 	tp->snd_cwnd = 2;
 	icsk->icsk_probes_out = 0;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
@@ -2885,7 +2889,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		if (sk->sk_state != TCP_CLOSE)
 			err = -EPERM;
 		else if (tp->repair_queue == TCP_SEND_QUEUE)
-			tp->write_seq = val;
+			WRITE_ONCE(tp->write_seq, val);
 		else if (tp->repair_queue == TCP_RECV_QUEUE) {
 			WRITE_ONCE(tp->rcv_nxt, val);
 			WRITE_ONCE(tp->copied_seq, val);
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index a96b252c742cb58108123a5ccad15511634dcfc5..2a46f9f81ba09278195e4fe310cc06c1b3c772f0 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -32,7 +32,7 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 
 		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) -
 					     READ_ONCE(tp->copied_seq), 0);
-		r->idiag_wqueue = tp->write_seq - tp->snd_una;
+		r->idiag_wqueue = READ_ONCE(tp->write_seq) - tp->snd_una;
 	}
 	if (info)
 		tcp_get_info(sk, info);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 627b5fb1eac8ecf808ea33d2994198b4551f3fc9..ac6135555e24a9b9244d1cd27e3d5619f8252490 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -169,9 +169,11 @@ int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
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
@@ -258,7 +260,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		tp->rx_opt.ts_recent	   = 0;
 		tp->rx_opt.ts_recent_stamp = 0;
 		if (likely(!tp->repair))
-			tp->write_seq	   = 0;
+			WRITE_ONCE(tp->write_seq, 0);
 	}
 
 	inet->inet_dport = usin->sin_port;
@@ -296,10 +298,11 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 
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
@@ -2345,7 +2348,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
 			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
 		i, src, srcp, dest, destp, state,
-		tp->write_seq - tp->snd_una,
+		READ_ONCE(tp->write_seq) - tp->snd_una,
 		rx_queue,
 		timer_active,
 		jiffies_delta_to_clock_t(timer_expires - jiffies),
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0b1a04fa54392fdb3325d45fd1d5e0aaa3170b6c..9436fb9b6a3d384b265b080fc41246987fbb0ea4 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -510,7 +510,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->app_limited = ~0U;
 
 	tcp_init_xmit_timers(newsk);
-	newtp->write_seq = newtp->pushed_seq = treq->snt_isn + 1;
+	WRITE_ONCE(newtp->write_seq, newtp->pushed_seq = treq->snt_isn + 1);
 
 	newtp->rx_opt.saw_tstamp = 0;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 662aa48173b8197e006127e4d84fb2c1961836a4..9b74041e8dd100a0123f89025cee3bed7c58d30e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1175,7 +1175,7 @@ static void tcp_queue_skb(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	/* Advance write_seq and place onto the write_queue. */
-	tp->write_seq = TCP_SKB_CB(skb)->end_seq;
+	WRITE_ONCE(tp->write_seq, TCP_SKB_CB(skb)->end_seq);
 	__skb_header_release(skb);
 	tcp_add_write_queue_tail(sk, skb);
 	sk->sk_wmem_queued += skb->truesize;
@@ -3397,7 +3397,7 @@ static void tcp_connect_queue_skb(struct sock *sk, struct sk_buff *skb)
 	__skb_header_release(skb);
 	sk->sk_wmem_queued += skb->truesize;
 	sk_mem_charge(sk, skb->truesize);
-	tp->write_seq = tcb->end_seq;
+	WRITE_ONCE(tp->write_seq, tcb->end_seq);
 	tp->packets_out += tcp_skb_pcount(skb);
 }
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index de9b9c0bf18f721f44d7ee0e4eec74c0b5576947..6e84f2eb08d643c2c79f34e90b05329a3dbabb56 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -206,7 +206,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	    !ipv6_addr_equal(&sk->sk_v6_daddr, &usin->sin6_addr)) {
 		tp->rx_opt.ts_recent = 0;
 		tp->rx_opt.ts_recent_stamp = 0;
-		tp->write_seq = 0;
+		WRITE_ONCE(tp->write_seq, 0);
 	}
 
 	sk->sk_v6_daddr = usin->sin6_addr;
@@ -304,10 +304,11 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
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
@@ -1850,7 +1851,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		   dest->s6_addr32[0], dest->s6_addr32[1],
 		   dest->s6_addr32[2], dest->s6_addr32[3], destp,
 		   state,
-		   tp->write_seq - tp->snd_una,
+		   READ_ONCE(tp->write_seq) - tp->snd_una,
 		   rx_queue,
 		   timer_active,
 		   jiffies_delta_to_clock_t(timer_expires - jiffies),
-- 
2.31.0.rc2.261.g7f71774620-goog

