Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1DEE0E77
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 01:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389659AbfJVXLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 19:11:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40973 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389652AbfJVXLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 19:11:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so10874709pga.8
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 16:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ygGNdoBgn8tpdMEsmC6SVnJ6LIduM2eem+TxJOEVG/k=;
        b=G14Lj8hbHDoUOoIIylPbRcewfCyfMY8zChE17X9+sBe+ezAKQ8uftfJTdEBVudJrRb
         ZdzmENcjdCuGS0bgZIJgCfJs0YRK23Dk5Jj77/TNwE6gPX+OBgR6ineGDwd57KEksSeG
         lsUQ30lxgzvAUdzSG+MbNcq/YQl6HYrD+SVJh9hlVYlclGvP3HeURCUqVjWi2i+6hyu/
         XoUsBiR8pXrH8UrTZFsvQz1qYXrWLFK2u06yjfi/BofxHEFt0qPxkfKpS9a50hFcudf2
         oYWRmBW9yQ2tsDoYY8mOOtfDYocO3RWZeK6tS7zlAhsbtVn1LXcGXjcfZXZe8YZAAzEq
         wgmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ygGNdoBgn8tpdMEsmC6SVnJ6LIduM2eem+TxJOEVG/k=;
        b=cL95VTiS1NpkUzVAbi03Ncs+bWSORqpFxVbvrq/i8Jz34OTLIGhCbQoitmjSyDIglU
         oQ+K8DVrdNZ9FPeeBDjlG59KZDDcG28XKQt6Gc0yM7I3VY90fFM7weRG/qcFPKquMNmK
         Qs0vDbSnpabMjDP3uXb7HEYKB46Rqgoo43Pi17/hBXbleZ6yXC1vcFg/La3x173Vny5Z
         UopZ9+Lwkk6xkpNfODyuOHlDgM8M7s+QEOl+YInXnxIrUzv1w/sP85GccwzI0vA6ZAbm
         wO3RULqFvGFkN7FqzAyYEr7nhf5B4WccBtvuqqhWWzEPJvzpgSmRCRKmIj/jdrJ9ABeZ
         f/1A==
X-Gm-Message-State: APjAAAUxt4annCcSCveqLNDe193Q5Ngd+c9a1Wxhdvzbx7ft96QQWjIa
        qX0xwQnpoNIwMl8VLBQyXJy54Jaa
X-Google-Smtp-Source: APXvYqyEUkllX4RrIEnLRG92WQPtFpMhcRebcY2IM5lbeXqx3z+fxJCKYsPDvF+KXrT+gXPlEC6XUQ==
X-Received: by 2002:a62:750d:: with SMTP id q13mr6912364pfc.58.1571785878869;
        Tue, 22 Oct 2019 16:11:18 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id j24sm20619284pff.71.2019.10.22.16.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 16:11:16 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ycheng@google.com, ncardwell@google.com, edumazet@google.com,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net-next 3/3] tcp: decouple TLP timer from RTO timer
Date:   Tue, 22 Oct 2019 16:10:51 -0700
Message-Id: <20191022231051.30770-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently RTO, TLP and PROBE0 all share a same timer instance
in kernel and use icsk->icsk_pending to dispatch the work.
This causes spinlock contention when resetting the timer is
too frequent, as clearly shown in the perf report:

   61.72%    61.71%  swapper          [kernel.kallsyms]                        [k] queued_spin_lock_slowpath
   ...
    - 58.83% tcp_v4_rcv
      - 58.80% tcp_v4_do_rcv
         - 58.80% tcp_rcv_established
            - 52.88% __tcp_push_pending_frames
               - 52.88% tcp_write_xmit
                  - 28.16% tcp_event_new_data_sent
                     - 28.15% sk_reset_timer
                        + mod_timer
                  - 24.68% tcp_schedule_loss_probe
                     - 24.68% sk_reset_timer
                        + 24.68% mod_timer

This patch decouples TLP timer from RTO timer by adding a new
timer instance but still uses icsk->icsk_pending to dispatch,
in order to minimize the risk of this patch.

After this patch, the CPU time spent in tcp_write_xmit() reduced
down to 10.92%.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/net/inet_connection_sock.h |  9 +++++--
 include/net/tcp.h                  |  1 +
 net/dccp/timer.c                   |  2 +-
 net/ipv4/inet_connection_sock.c    |  5 +++-
 net/ipv4/inet_diag.c               |  8 ++++--
 net/ipv4/tcp_input.c               |  8 ++++--
 net/ipv4/tcp_ipv4.c                |  6 +++--
 net/ipv4/tcp_output.c              |  1 +
 net/ipv4/tcp_timer.c               | 43 +++++++++++++++++++++++++++---
 net/ipv6/tcp_ipv6.c                |  6 +++--
 10 files changed, 73 insertions(+), 16 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index e46958460739..2a129fc6b522 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -121,6 +121,7 @@ struct inet_connection_sock {
 		__u16		  last_seg_size; /* Size of last incoming segment	   */
 		__u16		  rcv_mss;	 /* MSS used for delayed ACK decisions	   */
 	} icsk_ack;
+	struct timer_list	  icsk_tlp_timer;
 	struct {
 		int		  enabled;
 
@@ -170,7 +171,8 @@ enum inet_csk_ack_state_t {
 void inet_csk_init_xmit_timers(struct sock *sk,
 			       void (*retransmit_handler)(struct timer_list *),
 			       void (*delack_handler)(struct timer_list *),
-			       void (*keepalive_handler)(struct timer_list *));
+			       void (*keepalive_handler)(struct timer_list *),
+			       void (*tlp_handler)(struct timer_list *));
 void inet_csk_clear_xmit_timers(struct sock *sk);
 
 static inline void inet_csk_schedule_ack(struct sock *sk)
@@ -226,7 +228,7 @@ static inline void inet_csk_reset_xmit_timer(struct sock *sk, const int what,
 	}
 
 	if (what == ICSK_TIME_RETRANS || what == ICSK_TIME_PROBE0 ||
-	    what == ICSK_TIME_LOSS_PROBE || what == ICSK_TIME_REO_TIMEOUT) {
+	    what == ICSK_TIME_REO_TIMEOUT) {
 		icsk->icsk_pending = what;
 		icsk->icsk_timeout = jiffies + when;
 		sk_reset_timer(sk, &icsk->icsk_retransmit_timer, icsk->icsk_timeout);
@@ -234,6 +236,9 @@ static inline void inet_csk_reset_xmit_timer(struct sock *sk, const int what,
 		icsk->icsk_ack.pending |= ICSK_ACK_TIMER;
 		icsk->icsk_ack.timeout = jiffies + when;
 		sk_reset_timer(sk, &icsk->icsk_delack_timer, icsk->icsk_ack.timeout);
+	} else if (what == ICSK_TIME_LOSS_PROBE) {
+		icsk->icsk_pending = what;
+		sk_reset_timer(sk, &icsk->icsk_tlp_timer, jiffies + when);
 	} else {
 		pr_debug("inet_csk BUG: unknown timer value\n");
 	}
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0ee5400e751c..3319d2b6b1c4 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -331,6 +331,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 void tcp_release_cb(struct sock *sk);
 void tcp_wfree(struct sk_buff *skb);
 void tcp_write_timer_handler(struct sock *sk);
+void tcp_tail_loss_probe_handler(struct sock *sk);
 void tcp_delack_timer_handler(struct sock *sk);
 int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb);
diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index c0b3672637c4..897a0469e8f1 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -246,7 +246,7 @@ void dccp_init_xmit_timers(struct sock *sk)
 	tasklet_init(&dp->dccps_xmitlet, dccp_write_xmitlet, (unsigned long)sk);
 	timer_setup(&dp->dccps_xmit_timer, dccp_write_xmit_timer, 0);
 	inet_csk_init_xmit_timers(sk, &dccp_write_timer, &dccp_delack_timer,
-				  &dccp_keepalive_timer);
+				  &dccp_keepalive_timer, NULL);
 }
 
 static ktime_t dccp_timestamp_seed;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index eb30fc1770de..4b279a86308e 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -503,12 +503,14 @@ EXPORT_SYMBOL(inet_csk_accept);
 void inet_csk_init_xmit_timers(struct sock *sk,
 			       void (*retransmit_handler)(struct timer_list *t),
 			       void (*delack_handler)(struct timer_list *t),
-			       void (*keepalive_handler)(struct timer_list *t))
+			       void (*keepalive_handler)(struct timer_list *t),
+			       void (*tlp_handler)(struct timer_list *t))
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	timer_setup(&icsk->icsk_retransmit_timer, retransmit_handler, 0);
 	timer_setup(&icsk->icsk_delack_timer, delack_handler, 0);
+	timer_setup(&icsk->icsk_tlp_timer, tlp_handler, 0);
 	timer_setup(&sk->sk_timer, keepalive_handler, 0);
 	icsk->icsk_pending = icsk->icsk_ack.pending = 0;
 }
@@ -522,6 +524,7 @@ void inet_csk_clear_xmit_timers(struct sock *sk)
 
 	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
 	sk_stop_timer(sk, &icsk->icsk_delack_timer);
+	sk_stop_timer(sk, &icsk->icsk_tlp_timer);
 	sk_stop_timer(sk, &sk->sk_timer);
 }
 EXPORT_SYMBOL(inet_csk_clear_xmit_timers);
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 7dc79b973e6e..e87fe87571a1 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -221,8 +221,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	}
 
 	if (icsk->icsk_pending == ICSK_TIME_RETRANS ||
-	    icsk->icsk_pending == ICSK_TIME_REO_TIMEOUT ||
-	    icsk->icsk_pending == ICSK_TIME_LOSS_PROBE) {
+	    icsk->icsk_pending == ICSK_TIME_REO_TIMEOUT) {
 		r->idiag_timer = 1;
 		r->idiag_retrans = icsk->icsk_retransmits;
 		r->idiag_expires =
@@ -232,6 +231,11 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 		r->idiag_retrans = icsk->icsk_probes_out;
 		r->idiag_expires =
 			jiffies_to_msecs(icsk->icsk_timeout - jiffies);
+	} else if (icsk->icsk_pending == ICSK_TIME_LOSS_PROBE) {
+		r->idiag_timer = 1;
+		r->idiag_retrans = icsk->icsk_retransmits;
+		r->idiag_expires =
+			jiffies_to_msecs(icsk->icsk_tlp_timer.expires - jiffies);
 	} else if (timer_pending(&sk->sk_timer)) {
 		r->idiag_timer = 2;
 		r->idiag_retrans = icsk->icsk_probes_out;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a2e52ad7cdab..71cbb486ef85 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3008,8 +3008,12 @@ void tcp_rearm_rto(struct sock *sk)
 			 */
 			rto = usecs_to_jiffies(max_t(int, delta_us, 1));
 		}
-		tcp_reset_xmit_timer(sk, ICSK_TIME_RETRANS, rto,
-				     TCP_RTO_MAX, tcp_rtx_queue_head(sk));
+		if (icsk->icsk_pending == ICSK_TIME_LOSS_PROBE)
+			tcp_reset_xmit_timer(sk, ICSK_TIME_LOSS_PROBE, rto,
+					     TCP_RTO_MAX, tcp_rtx_queue_head(sk));
+		else
+			tcp_reset_xmit_timer(sk, ICSK_TIME_RETRANS, rto,
+					     TCP_RTO_MAX, tcp_rtx_queue_head(sk));
 	}
 }
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c616f0ad1fa0..f5e34fe7b2e6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2434,13 +2434,15 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 	int state;
 
 	if (icsk->icsk_pending == ICSK_TIME_RETRANS ||
-	    icsk->icsk_pending == ICSK_TIME_REO_TIMEOUT ||
-	    icsk->icsk_pending == ICSK_TIME_LOSS_PROBE) {
+	    icsk->icsk_pending == ICSK_TIME_REO_TIMEOUT) {
 		timer_active	= 1;
 		timer_expires	= icsk->icsk_timeout;
 	} else if (icsk->icsk_pending == ICSK_TIME_PROBE0) {
 		timer_active	= 4;
 		timer_expires	= icsk->icsk_timeout;
+	} else if (icsk->icsk_pending == ICSK_TIME_LOSS_PROBE) {
+		timer_active	= 1;
+		timer_expires	= icsk->icsk_tlp_timer.expires;
 	} else if (timer_pending(&sk->sk_timer)) {
 		timer_active	= 2;
 		timer_expires	= sk->sk_timer.expires;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9822820edca4..9038d7d61d0f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -882,6 +882,7 @@ void tcp_release_cb(struct sock *sk)
 
 	if (flags & TCPF_WRITE_TIMER_DEFERRED) {
 		tcp_write_timer_handler(sk);
+		tcp_tail_loss_probe_handler(sk);
 		__sock_put(sk);
 	}
 	if (flags & TCPF_DELACK_TIMER_DEFERRED) {
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index dd5a6317a801..f112aa979e8c 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -591,9 +591,6 @@ void tcp_write_timer_handler(struct sock *sk)
 	case ICSK_TIME_REO_TIMEOUT:
 		tcp_rack_reo_timeout(sk);
 		break;
-	case ICSK_TIME_LOSS_PROBE:
-		tcp_send_loss_probe(sk);
-		break;
 	case ICSK_TIME_RETRANS:
 		icsk->icsk_pending = 0;
 		tcp_retransmit_timer(sk);
@@ -626,6 +623,42 @@ static void tcp_write_timer(struct timer_list *t)
 	sock_put(sk);
 }
 
+void tcp_tail_loss_probe_handler(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	if ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN) ||
+	    icsk->icsk_pending != ICSK_TIME_LOSS_PROBE)
+		goto out;
+
+	if (timer_pending(&icsk->icsk_tlp_timer))
+		goto out;
+
+	tcp_mstamp_refresh(tcp_sk(sk));
+	if (tcp_send_loss_probe(sk))
+		icsk->icsk_retransmits++;
+out:
+	sk_mem_reclaim(sk);
+}
+
+static void tcp_tail_loss_probe_timer(struct timer_list *t)
+{
+	struct inet_connection_sock *icsk =
+			from_timer(icsk, t, icsk_tlp_timer);
+	struct sock *sk = &icsk->icsk_inet.sk;
+
+	bh_lock_sock(sk);
+	if (!sock_owned_by_user(sk)) {
+		tcp_tail_loss_probe_handler(sk);
+	} else {
+		/* delegate our work to tcp_release_cb() */
+		if (!test_and_set_bit(TCP_WRITE_TIMER_DEFERRED, &sk->sk_tsq_flags))
+			sock_hold(sk);
+	}
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
 void tcp_syn_ack_timeout(const struct request_sock *req)
 {
 	struct net *net = read_pnet(&inet_rsk(req)->ireq_net);
@@ -758,7 +791,9 @@ static enum hrtimer_restart tcp_compressed_ack_kick(struct hrtimer *timer)
 void tcp_init_xmit_timers(struct sock *sk)
 {
 	inet_csk_init_xmit_timers(sk, &tcp_write_timer, &tcp_delack_timer,
-				  &tcp_keepalive_timer);
+				  &tcp_keepalive_timer,
+				  &tcp_tail_loss_probe_timer);
+
 	hrtimer_init(&tcp_sk(sk)->pacing_timer, CLOCK_MONOTONIC,
 		     HRTIMER_MODE_ABS_PINNED_SOFT);
 	tcp_sk(sk)->pacing_timer.function = tcp_pace_kick;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4804b6dc5e65..7cc8dbe412af 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1874,13 +1874,15 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 	srcp  = ntohs(inet->inet_sport);
 
 	if (icsk->icsk_pending == ICSK_TIME_RETRANS ||
-	    icsk->icsk_pending == ICSK_TIME_REO_TIMEOUT ||
-	    icsk->icsk_pending == ICSK_TIME_LOSS_PROBE) {
+	    icsk->icsk_pending == ICSK_TIME_REO_TIMEOUT) {
 		timer_active	= 1;
 		timer_expires	= icsk->icsk_timeout;
 	} else if (icsk->icsk_pending == ICSK_TIME_PROBE0) {
 		timer_active	= 4;
 		timer_expires	= icsk->icsk_timeout;
+	} else if (icsk->icsk_pending == ICSK_TIME_LOSS_PROBE) {
+		timer_active	= 1;
+		timer_expires	= icsk->icsk_tlp_timer.expires;
 	} else if (timer_pending(&sp->sk_timer)) {
 		timer_active	= 2;
 		timer_expires	= sp->sk_timer.expires;
-- 
2.21.0

