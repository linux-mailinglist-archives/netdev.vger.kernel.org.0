Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B9AF0921
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387479AbfKEWMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:12:24 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:47728 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfKEWMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:12:24 -0500
Received: by mail-pf1-f202.google.com with SMTP id w16so6071858pfq.14
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JMnJA3N4RtEau52ssc0bshQBnbnMvhNoRnzVTjsTYoE=;
        b=oEJO0/pjL6nukc6s5mO1YRxmc8xm/Bd3JUg60H/FVxokHBsC70MbNNaqChYiRrl6Yd
         AkXHUZE38VQesukZwt7EnhoJJ9eFCNZAlzd0UiOGA9oTSrN4hgA3537L6JuB61t9GX6P
         iFlfdF81A8M7+NnAKt9iQdGzLE0y0X0EpwYN8hVVvastSRSx3M+xTIudgMGLRqxpssRy
         I2yb7+sQ7kxVT0WRqNFs9Hb7kuI9Iez7BSkhlCi4txr3wgp0FrBGQSC32kKC2Ae2zm7Y
         odS7xtp0A+/EGdlcNK7riX5tUFewXDSS9946u9zFA/JzdApTYrUa1yMj+gUnS4y1j01p
         hkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JMnJA3N4RtEau52ssc0bshQBnbnMvhNoRnzVTjsTYoE=;
        b=RTs/QMdMsPmOOzd5umwru+SWekCS/0uoOI4jhaC2iMgjDl9ia7zHn791PH0D/u2sV6
         xqbaEAmKmFD/euMdJbzCfnu9Y5KrUHNZFm4uQ1tQhgiHIxs2F7MM1Yi80JjqETW1XPob
         RSQ/XPVmqLL8GKATvmiRi9pUc3+EvxC3oEBy1rIS16P2dQ1fgNtJvt9ioHC9Rp+XsLNF
         sa1d/9DuxQAmLuruNWP0MPGFQwN+6UYoqs9deHMa7PFdg6Z2Td9cqmtRPZOFokbONpi2
         A9U/NpbiTmQEIHUH2m1eiJ9FKBBI2T2Pqi36wLYGJTHpUW8YLaZ1Xr+ose2qD70BfpAI
         n8PA==
X-Gm-Message-State: APjAAAXpXmXGRD8BUp3bjEQgZgfTDMHQnZ4vGNgToIL9PvgRhNPWCpsN
        zyg3pIJaQp0htMLhjJs/aOErVbdMI67AFA==
X-Google-Smtp-Source: APXvYqxrBHrA1sNsDzwVTxMSAgLMQNpOepAqz7C//jx3Z30qeq1t5w2jFjRkeROhH23fozj9Kc5EvlJq5bPT1Q==
X-Received: by 2002:a63:151:: with SMTP id 78mr36031523pgb.95.1572991943378;
 Tue, 05 Nov 2019 14:12:23 -0800 (PST)
Date:   Tue,  5 Nov 2019 14:11:54 -0800
In-Reply-To: <20191105221154.232754-1-edumazet@google.com>
Message-Id: <20191105221154.232754-7-edumazet@google.com>
Mime-Version: 1.0
References: <20191105221154.232754-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 6/6] net: annotate lockless accesses to sk->sk_max_ack_backlog
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

sk->sk_max_ack_backlog can be read without any lock being held
at least in TCP/DCCP cases.

We need to use READ_ONCE()/WRITE_ONCE() to avoid load/store tearing
and/or potential KCSAN warnings.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h              | 2 +-
 net/dccp/proto.c                | 2 +-
 net/ipv4/af_inet.c              | 2 +-
 net/ipv4/inet_connection_sock.c | 2 +-
 net/ipv4/tcp.c                  | 2 +-
 net/ipv4/tcp_diag.c             | 2 +-
 net/sched/em_meta.c             | 2 +-
 net/sctp/diag.c                 | 2 +-
 net/sctp/socket.c               | 4 ++--
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index a126784aa7d9b6f59c8937c8c94d5bd7843988a4..d4d3ef5ba0490366e1e25884a5edf54186c940d8 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -869,7 +869,7 @@ static inline void sk_acceptq_added(struct sock *sk)
 
 static inline bool sk_acceptq_is_full(const struct sock *sk)
 {
-	return READ_ONCE(sk->sk_ack_backlog) > sk->sk_max_ack_backlog;
+	return READ_ONCE(sk->sk_ack_backlog) > READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 /*
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 5bad08dc431611d5387c8d3c1858ee2c43cb9b68..a52e8ba1ced046b178fa069b1e0d690c537c6bc0 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -944,7 +944,7 @@ int inet_dccp_listen(struct socket *sock, int backlog)
 	if (!((1 << old_state) & (DCCPF_CLOSED | DCCPF_LISTEN)))
 		goto out;
 
-	sk->sk_max_ack_backlog = backlog;
+	WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
 	/* Really, if the socket is already in listen state
 	 * we can only allow the backlog to be adjusted.
 	 */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 70f92aaca4110b3ecd691949203f28978597e9c9..53de8e00990e276448df1c60e47620be3b58f517 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -208,7 +208,7 @@ int inet_listen(struct socket *sock, int backlog)
 	if (!((1 << old_state) & (TCPF_CLOSE | TCPF_LISTEN)))
 		goto out;
 
-	sk->sk_max_ack_backlog = backlog;
+	WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
 	/* Really, if the socket is already in listen state
 	 * we can only allow the backlog to be adjusted.
 	 */
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index eb30fc1770def741950215f59a4e3ab0f91c6293..e4c6e8b4049063f5239a5e99a185016ad3bb5790 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -716,7 +716,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 	 * ones are about to clog our table.
 	 */
 	qlen = reqsk_queue_len(queue);
-	if ((qlen << 1) > max(8U, sk_listener->sk_max_ack_backlog)) {
+	if ((qlen << 1) > max(8U, READ_ONCE(sk_listener->sk_max_ack_backlog))) {
 		int young = reqsk_queue_len_young(queue) << 1;
 
 		while (thresh > 2) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 68375f7ffdce1fbbb4cf443660703c98b61fd9e3..fb1666440e1064a9ab2f2993b23fdb744e82f5c5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3226,7 +3226,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 		 * tcpi_sacked  -> max backlog
 		 */
 		info->tcpi_unacked = READ_ONCE(sk->sk_ack_backlog);
-		info->tcpi_sacked = sk->sk_max_ack_backlog;
+		info->tcpi_sacked = READ_ONCE(sk->sk_max_ack_backlog);
 		return;
 	}
 
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index edfbab54c46f4cac1b0a7960718d0b6308978957..0d08f9e2d8d0322fcdd3a465a3a9712b36605954 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -22,7 +22,7 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 
 	if (inet_sk_state_load(sk) == TCP_LISTEN) {
 		r->idiag_rqueue = READ_ONCE(sk->sk_ack_backlog);
-		r->idiag_wqueue = sk->sk_max_ack_backlog;
+		r->idiag_wqueue = READ_ONCE(sk->sk_max_ack_backlog);
 	} else if (sk->sk_type == SOCK_STREAM) {
 		const struct tcp_sock *tp = tcp_sk(sk);
 
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index ebb6e2430861d23a42431e4143f229395d9321c5..d99966a55c84fa0f5142ed72faeceb9baab86f5e 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -532,7 +532,7 @@ META_COLLECTOR(int_sk_max_ack_bl)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_max_ack_backlog;
+	dst->value = READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 META_COLLECTOR(int_sk_prio)
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index f873f15407de4e7d9a246d41e07602f33da8064d..8a15146faaebdcb869233a08318e4fb5a1e1129b 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -426,7 +426,7 @@ static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 		r->idiag_wqueue = infox->asoc->sndbuf_used;
 	} else {
 		r->idiag_rqueue = READ_ONCE(sk->sk_ack_backlog);
-		r->idiag_wqueue = sk->sk_max_ack_backlog;
+		r->idiag_wqueue = READ_ONCE(sk->sk_max_ack_backlog);
 	}
 	if (infox->sctpinfo)
 		sctp_get_sctp_info(sk, infox->asoc, infox->sctpinfo);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ffd3262b7a41eac2e3d825c3f0665066f376ea3c..53abb97e0061c14fd4a9c3090a4a5cbe0af9c5a9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8376,7 +8376,7 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 		}
 	}
 
-	sk->sk_max_ack_backlog = backlog;
+	WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
 	return sctp_hash_endpoint(ep);
 }
 
@@ -8430,7 +8430,7 @@ int sctp_inet_listen(struct socket *sock, int backlog)
 
 	/* If we are already listening, just update the backlog */
 	if (sctp_sstate(sk, LISTENING))
-		sk->sk_max_ack_backlog = backlog;
+		WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
 	else {
 		err = sctp_listen_start(sk, backlog);
 		if (err)
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

