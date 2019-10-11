Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA044D37CB
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfJKDSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:18:05 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:35341 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKDSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:18:04 -0400
Received: by mail-pf1-f202.google.com with SMTP id r7so6392925pfg.2
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lwVr41TsoTTOGCqZqKkQ1nc/0RZq4Wt4DP7ipDcrhec=;
        b=ihsFbkNW8FmD+yxDFsW33LMExi0P693gkFtT/LE6ITHbQhBPJ16RSJIe5dU96lOZ8r
         OhloFtsI7inAgqRucxe9+jmqt9d7dm1+UBs1TVIiVATPmOWucqBUd9UMbnJkgYUP4bR5
         WVEsJEbfPjITz++dGRMeJn6YEURLdF2l4eazhk899ShHaclRhh0CEzdfCitJw3iTmkka
         7By85Ysj6iwZEbFJYs5xmAmTtTSIAoXm1MEon65tNTRIbBb6XmSXGwg0o3/dMQwGyjmH
         G85iUoTbk8+8TMELL1hxo7pZ59BJYlQSY7H0dcMKFC9Ez3d22e72pZw7I1cy+kYciknb
         bOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lwVr41TsoTTOGCqZqKkQ1nc/0RZq4Wt4DP7ipDcrhec=;
        b=nX9JE3eP10uVzn17odGGnUjGMMDNBkPUg4ouQOdCWDmJxar7MUFuo/zIz3QOueJDi0
         WfXmNmTp3h1Vc7O3jWcuuOOJntKrYGFPmOdcVEc6fCYnytK1VPk6ULVhgE0dhMrozwPO
         iFgsY5oC2RVQ0TYkXkin41Sh5uAAahvx+DQbfi2oJd5G+XIYh7LLxYq8eKhUFV63kPno
         JVMC+1wbh02Zm51RCy7xJFkSf1hmPbDg6DtvU3M/S0WQ2vnwG505ob/KmdERO0aFlfXW
         np0Nv4axncpsUXIV30T09586JFs0gDPiwyATAbmRveZbqzimGggG/MQ4AzQPcFop9OnB
         s5XQ==
X-Gm-Message-State: APjAAAXtKl5JmjNTNNXb1flsIwo/j+oiilzG9grD6BYYBwfK+eB5N1wi
        K0gt5QQRJ0tA3x7vbdqGwYrUZTD+WXA/aw==
X-Google-Smtp-Source: APXvYqzqVF2u+yGqD1O4H2IlHOoengSwDPp1pQ1tD1XQgTjlmNPlVgaTqNlF5TiXr1HPMsrfNylfDgpwB/05OQ==
X-Received: by 2002:a63:5918:: with SMTP id n24mr14485798pgb.362.1570763883731;
 Thu, 10 Oct 2019 20:18:03 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:38 -0700
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
Message-Id: <20191011031746.16220-2-edumazet@google.com>
Mime-Version: 1.0
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 1/9] tcp: add rcu protection around tp->fastopen_rsk
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

Both tcp_v4_err() and tcp_v6_err() do the following operations
while they do not own the socket lock :

	fastopen = tp->fastopen_rsk;
 	snd_una = fastopen ? tcp_rsk(fastopen)->snt_isn : tp->snd_una;

The problem is that without appropriate barrier, the compiler
might reload tp->fastopen_rsk and trigger a NULL deref.

request sockets are protected by RCU, we can simply add
the missing annotations and barriers to solve the issue.

Fixes: 168a8f58059a ("tcp: TCP Fast Open Server - main code path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/tcp.h             |  6 +++---
 net/core/request_sock.c         |  2 +-
 net/ipv4/inet_connection_sock.c |  4 ++--
 net/ipv4/tcp.c                  | 11 ++++++++---
 net/ipv4/tcp_fastopen.c         |  2 +-
 net/ipv4/tcp_input.c            | 13 +++++++++----
 net/ipv4/tcp_ipv4.c             |  4 ++--
 net/ipv4/tcp_minisocks.c        |  2 +-
 net/ipv4/tcp_output.c           |  2 +-
 net/ipv4/tcp_timer.c            | 11 ++++++-----
 net/ipv6/tcp_ipv6.c             |  2 +-
 11 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 99617e528ea2906b234cadc1fb3d79d0efd46331..668e25a76d69809b5ade30f5774a4c62833b8b9b 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -393,7 +393,7 @@ struct tcp_sock {
 	/* fastopen_rsk points to request_sock that resulted in this big
 	 * socket. Used to retransmit SYNACKs etc.
 	 */
-	struct request_sock *fastopen_rsk;
+	struct request_sock __rcu *fastopen_rsk;
 	u32	*saved_syn;
 };
 
@@ -447,8 +447,8 @@ static inline struct tcp_timewait_sock *tcp_twsk(const struct sock *sk)
 
 static inline bool tcp_passive_fastopen(const struct sock *sk)
 {
-	return (sk->sk_state == TCP_SYN_RECV &&
-		tcp_sk(sk)->fastopen_rsk != NULL);
+	return sk->sk_state == TCP_SYN_RECV &&
+	       rcu_access_pointer(tcp_sk(sk)->fastopen_rsk) != NULL;
 }
 
 static inline void fastopen_queue_tune(struct sock *sk, int backlog)
diff --git a/net/core/request_sock.c b/net/core/request_sock.c
index c9bb00008528414486bb58ba4c26b003545c6ae4..f35c2e9984062ba4bed637eaeace4eb9e71dadc0 100644
--- a/net/core/request_sock.c
+++ b/net/core/request_sock.c
@@ -96,7 +96,7 @@ void reqsk_fastopen_remove(struct sock *sk, struct request_sock *req,
 
 	fastopenq = &inet_csk(lsk)->icsk_accept_queue.fastopenq;
 
-	tcp_sk(sk)->fastopen_rsk = NULL;
+	RCU_INIT_POINTER(tcp_sk(sk)->fastopen_rsk, NULL);
 	spin_lock_bh(&fastopenq->lock);
 	fastopenq->qlen--;
 	tcp_rsk(req)->tfo_listener = false;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index dbcf34ec8dd208d2144a590d40501c4eb82e5111..eb30fc1770def741950215f59a4e3ab0f91c6293 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -906,7 +906,7 @@ static void inet_child_forget(struct sock *sk, struct request_sock *req,
 	percpu_counter_inc(sk->sk_prot->orphan_count);
 
 	if (sk->sk_protocol == IPPROTO_TCP && tcp_rsk(req)->tfo_listener) {
-		BUG_ON(tcp_sk(child)->fastopen_rsk != req);
+		BUG_ON(rcu_access_pointer(tcp_sk(child)->fastopen_rsk) != req);
 		BUG_ON(sk != req->rsk_listener);
 
 		/* Paranoid, to prevent race condition if
@@ -915,7 +915,7 @@ static void inet_child_forget(struct sock *sk, struct request_sock *req,
 		 * Also to satisfy an assertion in
 		 * tcp_v4_destroy_sock().
 		 */
-		tcp_sk(child)->fastopen_rsk = NULL;
+		RCU_INIT_POINTER(tcp_sk(child)->fastopen_rsk, NULL);
 	}
 	inet_csk_destroy_sock(child);
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8781a92ea4b6e4ee9ceeb763dae01970e7f4438a..c59d0bd29c5c6fcbe38edb12b37c47ba4ed68899 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -543,7 +543,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 
 	/* Connected or passive Fast Open socket? */
 	if (state != TCP_SYN_SENT &&
-	    (state != TCP_SYN_RECV || tp->fastopen_rsk)) {
+	    (state != TCP_SYN_RECV || rcu_access_pointer(tp->fastopen_rsk))) {
 		int target = sock_rcvlowat(sk, 0, INT_MAX);
 
 		if (tp->urg_seq == tp->copied_seq &&
@@ -2487,7 +2487,10 @@ void tcp_close(struct sock *sk, long timeout)
 	}
 
 	if (sk->sk_state == TCP_CLOSE) {
-		struct request_sock *req = tcp_sk(sk)->fastopen_rsk;
+		struct request_sock *req;
+
+		req = rcu_dereference_protected(tcp_sk(sk)->fastopen_rsk,
+						lockdep_sock_is_held(sk));
 		/* We could get here with a non-NULL req if the socket is
 		 * aborted (e.g., closed with unread data) before 3WHS
 		 * finishes.
@@ -3831,8 +3834,10 @@ EXPORT_SYMBOL(tcp_md5_hash_key);
 
 void tcp_done(struct sock *sk)
 {
-	struct request_sock *req = tcp_sk(sk)->fastopen_rsk;
+	struct request_sock *req;
 
+	req = rcu_dereference_protected(tcp_sk(sk)->fastopen_rsk,
+					lockdep_sock_is_held(sk));
 	if (sk->sk_state == TCP_SYN_SENT || sk->sk_state == TCP_SYN_RECV)
 		TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
 
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 3fd451271a7034aab65f02f2bc331254b49f2153..a915ade0c81803a3b190e8c0513220b4e67c35e4 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -253,7 +253,7 @@ static struct sock *tcp_fastopen_create_child(struct sock *sk,
 	 */
 	tp = tcp_sk(child);
 
-	tp->fastopen_rsk = req;
+	rcu_assign_pointer(tp->fastopen_rsk, req);
 	tcp_rsk(req)->tfo_listener = true;
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3578357abe30e92f818e5b9acf3317be1d997af5..5f9b102c3b55c5a40bceb945d0f5d288f682824c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2666,7 +2666,7 @@ static void tcp_process_loss(struct sock *sk, int flag, int num_dupack,
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool recovered = !before(tp->snd_una, tp->high_seq);
 
-	if ((flag & FLAG_SND_UNA_ADVANCED || tp->fastopen_rsk) &&
+	if ((flag & FLAG_SND_UNA_ADVANCED || rcu_access_pointer(tp->fastopen_rsk)) &&
 	    tcp_try_undo_loss(sk, false))
 		return;
 
@@ -2990,7 +2990,7 @@ void tcp_rearm_rto(struct sock *sk)
 	/* If the retrans timer is currently being used by Fast Open
 	 * for SYN-ACK retrans purpose, stay put.
 	 */
-	if (tp->fastopen_rsk)
+	if (rcu_access_pointer(tp->fastopen_rsk))
 		return;
 
 	if (!tp->packets_out) {
@@ -6087,6 +6087,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 
 static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
 {
+	struct request_sock *req;
+
 	tcp_try_undo_loss(sk, false);
 
 	/* Reset rtx states to prevent spurious retransmits_timed_out() */
@@ -6096,7 +6098,9 @@ static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
 	/* Once we leave TCP_SYN_RECV or TCP_FIN_WAIT_1,
 	 * we no longer need req so release it.
 	 */
-	reqsk_fastopen_remove(sk, tcp_sk(sk)->fastopen_rsk, false);
+	req = rcu_dereference_protected(tcp_sk(sk)->fastopen_rsk,
+					lockdep_sock_is_held(sk));
+	reqsk_fastopen_remove(sk, req, false);
 
 	/* Re-arm the timer because data may have been sent out.
 	 * This is similar to the regular data transmission case
@@ -6171,7 +6175,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	tcp_mstamp_refresh(tp);
 	tp->rx_opt.saw_tstamp = 0;
-	req = tp->fastopen_rsk;
+	req = rcu_dereference_protected(tp->fastopen_rsk,
+					lockdep_sock_is_held(sk));
 	if (req) {
 		bool req_stolen;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 492bf6a6b0237a677aae5d7ef365a5fc7356e238..ffa366099eb29145c37341ca00976844cd1185dc 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -478,7 +478,7 @@ int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 	icsk = inet_csk(sk);
 	tp = tcp_sk(sk);
 	/* XXX (TFO) - tp->snd_una should be ISN (tcp_create_openreq_child() */
-	fastopen = tp->fastopen_rsk;
+	fastopen = rcu_dereference(tp->fastopen_rsk);
 	snd_una = fastopen ? tcp_rsk(fastopen)->snt_isn : tp->snd_una;
 	if (sk->sk_state != TCP_LISTEN &&
 	    !between(seq, snd_una, tp->snd_nxt)) {
@@ -2121,7 +2121,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
 	if (inet_csk(sk)->icsk_bind_hash)
 		inet_put_port(sk);
 
-	BUG_ON(tp->fastopen_rsk);
+	BUG_ON(rcu_access_pointer(tp->fastopen_rsk));
 
 	/* If socket is aborted during connect operation */
 	tcp_free_fastopen_req(tp);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index bb140a5db8c066e57f1018fd47bccd4628def642..5401dbd39c8fd34d147e0202a410dfc7cefafc26 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -541,7 +541,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->rx_opt.mss_clamp = req->mss;
 	tcp_ecn_openreq_child(newtp, req);
 	newtp->fastopen_req = NULL;
-	newtp->fastopen_rsk = NULL;
+	RCU_INIT_POINTER(newtp->fastopen_rsk, NULL);
 
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_PASSIVEOPENS);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fec6d67bfd146dc78f0f25173fd71b8b8cc752fe..84ae4d1449ea7eb9da2c536363b88807f35a4283 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2482,7 +2482,7 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
 	/* Don't do any loss probe on a Fast Open connection before 3WHS
 	 * finishes.
 	 */
-	if (tp->fastopen_rsk)
+	if (rcu_access_pointer(tp->fastopen_rsk))
 		return false;
 
 	early_retrans = sock_net(sk)->ipv4.sysctl_tcp_early_retrans;
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 05be564414e9b4aad64321e381fc0afa10980190..dd5a6317a8018a45ad609f832ced6df2937ad453 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -386,15 +386,13 @@ abort:		tcp_write_err(sk);
  *	Timer for Fast Open socket to retransmit SYNACK. Note that the
  *	sk here is the child socket, not the parent (listener) socket.
  */
-static void tcp_fastopen_synack_timer(struct sock *sk)
+static void tcp_fastopen_synack_timer(struct sock *sk, struct request_sock *req)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	int max_retries = icsk->icsk_syn_retries ? :
 	    sock_net(sk)->ipv4.sysctl_tcp_synack_retries + 1; /* add one more retry for fastopen */
 	struct tcp_sock *tp = tcp_sk(sk);
-	struct request_sock *req;
 
-	req = tcp_sk(sk)->fastopen_rsk;
 	req->rsk_ops->syn_ack_timeout(req);
 
 	if (req->num_timeout >= max_retries) {
@@ -435,11 +433,14 @@ void tcp_retransmit_timer(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct request_sock *req;
 
-	if (tp->fastopen_rsk) {
+	req = rcu_dereference_protected(tp->fastopen_rsk,
+					lockdep_sock_is_held(sk));
+	if (req) {
 		WARN_ON_ONCE(sk->sk_state != TCP_SYN_RECV &&
 			     sk->sk_state != TCP_FIN_WAIT1);
-		tcp_fastopen_synack_timer(sk);
+		tcp_fastopen_synack_timer(sk, req);
 		/* Before we receive ACK to our SYN-ACK don't retransmit
 		 * anything else (e.g., data or FIN segments).
 		 */
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e3d9f4559c99f252eba448845cce434bc53f3fd8..45a95e032bdfe8ffb05309bed8a967ee08690293 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -406,7 +406,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	tp = tcp_sk(sk);
 	/* XXX (TFO) - tp->snd_una should be ISN (tcp_create_openreq_child() */
-	fastopen = tp->fastopen_rsk;
+	fastopen = rcu_dereference(tp->fastopen_rsk);
 	snd_una = fastopen ? tcp_rsk(fastopen)->snt_isn : tp->snd_una;
 	if (sk->sk_state != TCP_LISTEN &&
 	    !between(seq, snd_una, tp->snd_nxt)) {
-- 
2.23.0.700.g56cf767bdb-goog

