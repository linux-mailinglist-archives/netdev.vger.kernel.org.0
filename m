Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27210F0920
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387468AbfKEWMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:12:20 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:50388 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfKEWMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:12:20 -0500
Received: by mail-pf1-f202.google.com with SMTP id e13so10637102pff.17
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NEfkqij4dWS0saI85Xl3b8QbPrN/yb01cBZ/t3LVeq8=;
        b=pvk+hN7LmFKbCP2K2yX2ihv/yRlUJ2RfprBvwHTyn4N9YGPuP6w9Y6uhDayssykhXR
         WVIJ9znfc8FvZdHQ7qyJ4QDRl5Np6HoSufWhRxg16HX3TrIrYCWaR1/v1N6JdFkSceXo
         Nbjp6TeTFjV5FIvDLGrqab6TLjrW3Q9uH2bNvia6l3dv9SfU39uspZPMa6l1kY8KAk8V
         DVKD2Jh+HijUXq/wFjZ/kqCZgKk3ZHE5q/Ywmuvmfumsg4kKHlLGhJqO3ZooMBTj09Ms
         yyQ/V0awTFPJCV/K/O8nWveHZrzJvRR8BrS1rzh2Kf1pHizcBrHbu9yJFIfydEZHNHz/
         DaLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NEfkqij4dWS0saI85Xl3b8QbPrN/yb01cBZ/t3LVeq8=;
        b=BA5NXWiPVIMHFUcDmYigbM6XSLqg2cbLs/SNr6jCKmnM1/rR19SjFs71ofiBnfw9sd
         1TWg3ZNKtRqNaemMlM+yirwGYV44RTfPX+vi+jS5NKL/yKHg+kbZM/6tKNSsN9Jh18sQ
         3EuWBAsnERNCeANbHpZmI4HJxgeKIQuLvrRU39/CmDIa8aJ3yKHVmpvnxYbB2lCOmcZX
         LqGd6FBz5nkBhWANG/aN60XNcIzY3OClcWYbgUGsJnIYRIn61lQ5z6Q88V/wl/CmrhSR
         O3zT8cNG0YYYfz6ryrH3z/AMPniqZTlNAdLrtglBNCoZaMt5VKirWsGlL0de8QsrtpI9
         I9sQ==
X-Gm-Message-State: APjAAAWXlbuJnXLe/8XT401KzGAPboiOWVXB9HcjpELvt8NS7eARgpFC
        vmxeDbx/uo2jrlocXUPbqj6yyDTCR2Esaw==
X-Google-Smtp-Source: APXvYqzQ//EgQZ7XKeEuDj8OtzkojnObeRvcdEWuu4K9eSFRjK3p+pTKM0DWPt4ieBFlUx3FhrZ8S7vE01KsEQ==
X-Received: by 2002:a63:1812:: with SMTP id y18mr35553123pgl.302.1572991938955;
 Tue, 05 Nov 2019 14:12:18 -0800 (PST)
Date:   Tue,  5 Nov 2019 14:11:53 -0800
In-Reply-To: <20191105221154.232754-1-edumazet@google.com>
Message-Id: <20191105221154.232754-6-edumazet@google.com>
Mime-Version: 1.0
References: <20191105221154.232754-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 5/6] net: annotate lockless accesses to sk->sk_ack_backlog
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

sk->sk_ack_backlog can be read without any lock being held.
We need to use READ_ONCE()/WRITE_ONCE() to avoid load/store tearing
and/or potential KCSAN warnings.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h  | 6 +++---
 net/ipv4/tcp.c      | 2 +-
 net/ipv4/tcp_diag.c | 2 +-
 net/ipv4/tcp_ipv4.c | 2 +-
 net/ipv6/tcp_ipv6.c | 2 +-
 net/sched/em_meta.c | 2 +-
 net/sctp/diag.c     | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index f2f853439b6576925e39f6db010964762e39ccf2..a126784aa7d9b6f59c8937c8c94d5bd7843988a4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -859,17 +859,17 @@ static inline gfp_t sk_gfp_mask(const struct sock *sk, gfp_t gfp_mask)
 
 static inline void sk_acceptq_removed(struct sock *sk)
 {
-	sk->sk_ack_backlog--;
+	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog - 1);
 }
 
 static inline void sk_acceptq_added(struct sock *sk)
 {
-	sk->sk_ack_backlog++;
+	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog + 1);
 }
 
 static inline bool sk_acceptq_is_full(const struct sock *sk)
 {
-	return sk->sk_ack_backlog > sk->sk_max_ack_backlog;
+	return READ_ONCE(sk->sk_ack_backlog) > sk->sk_max_ack_backlog;
 }
 
 /*
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1dd25189d83f2c7404336f8378be23c4beaa7ed7..68375f7ffdce1fbbb4cf443660703c98b61fd9e3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3225,7 +3225,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 		 * tcpi_unacked -> Number of children ready for accept()
 		 * tcpi_sacked  -> max backlog
 		 */
-		info->tcpi_unacked = sk->sk_ack_backlog;
+		info->tcpi_unacked = READ_ONCE(sk->sk_ack_backlog);
 		info->tcpi_sacked = sk->sk_max_ack_backlog;
 		return;
 	}
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index 549506162ddeca22f6dd87dfe1c5c13cea6e2b69..edfbab54c46f4cac1b0a7960718d0b6308978957 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -21,7 +21,7 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	struct tcp_info *info = _info;
 
 	if (inet_sk_state_load(sk) == TCP_LISTEN) {
-		r->idiag_rqueue = sk->sk_ack_backlog;
+		r->idiag_rqueue = READ_ONCE(sk->sk_ack_backlog);
 		r->idiag_wqueue = sk->sk_max_ack_backlog;
 	} else if (sk->sk_type == SOCK_STREAM) {
 		const struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 899e100a68e6ab8fcf7b2c4d2a9d179745a782b5..92282f98dc82290bfaf53acc050182e4cc3be1eb 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2451,7 +2451,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 
 	state = inet_sk_state_load(sk);
 	if (state == TCP_LISTEN)
-		rx_queue = sk->sk_ack_backlog;
+		rx_queue = READ_ONCE(sk->sk_ack_backlog);
 	else
 		/* Because we don't lock the socket,
 		 * we might find a transient negative value.
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4804b6dc5e6519a457e631bc1438a14f85477567..81f51335e326fad57d3e0e1ce23926b276e95e92 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1891,7 +1891,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 
 	state = inet_sk_state_load(sp);
 	if (state == TCP_LISTEN)
-		rx_queue = sp->sk_ack_backlog;
+		rx_queue = READ_ONCE(sp->sk_ack_backlog);
 	else
 		/* Because we don't lock the socket,
 		 * we might find a transient negative value.
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index 3177dcb173161629a801278db38fabeb6fcdbdd9..ebb6e2430861d23a42431e4143f229395d9321c5 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -521,7 +521,7 @@ META_COLLECTOR(int_sk_ack_bl)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_ack_backlog;
+	dst->value = READ_ONCE(sk->sk_ack_backlog);
 }
 
 META_COLLECTOR(int_sk_max_ack_bl)
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 0851166b917597b08becf9bf9d5873287b375828..f873f15407de4e7d9a246d41e07602f33da8064d 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -425,7 +425,7 @@ static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 		r->idiag_rqueue = atomic_read(&infox->asoc->rmem_alloc);
 		r->idiag_wqueue = infox->asoc->sndbuf_used;
 	} else {
-		r->idiag_rqueue = sk->sk_ack_backlog;
+		r->idiag_rqueue = READ_ONCE(sk->sk_ack_backlog);
 		r->idiag_wqueue = sk->sk_max_ack_backlog;
 	}
 	if (infox->sctpinfo)
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

