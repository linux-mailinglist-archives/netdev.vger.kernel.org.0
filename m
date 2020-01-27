Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA94A14A49A
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgA0NLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:11:08 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45624 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgA0NLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:11:04 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so6128164lfa.12
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C/PWUyZ8WRMMuhUFK+j0t9124ZJpx3NI0SI5nXhQtCo=;
        b=okc0XUK3sMFMydVNVuT1L7mCOk1kyNQ14brv9lJ7iT3gU04xvS8o5XzypRnWlHtmPA
         +vxTEbYSsxQD5Si0dvgST1U3oNsu0nOtmJJ+ufoaAzofDjpv9c7TVkzqtNvfVjqCHP38
         60B+k4a8N0fKL6IvXRH9UzoDXoXMg6L8nNGtw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C/PWUyZ8WRMMuhUFK+j0t9124ZJpx3NI0SI5nXhQtCo=;
        b=FTnS6j3R7PyEUiiWrFSo4pI/D7KJA1t1ypniOSRLuzj/mrHMNRuafnmI6mOzO5jCXA
         APeuWcUN7hoRtH1Rbj7K5V7pcTE5deDQVSOPc5YX5eVFgIHKVcouuX9gN08alhAJwGKH
         hoc0L/v5v0qE+UBQv3wuM0uwcTCShB5aiA+NdBxZFgbVvgo8Y2718Kqzi1jR1bN6+FUq
         fjTPwEcf3RUsZasQZJHG6X5h2ihTG7FInLJMdEpZyA3jv5ZZf+Ck/KNrfbeQ+pYGWfUK
         xaGlCzwg5L0/99WjMRFvE/JZxEqnEvHjTAkAszqWI/xOy3Al4s5oirY8S1SnrJMh/3NA
         iLjw==
X-Gm-Message-State: APjAAAWps8OHeYOlIze0YUiekJaRpiBQW9PFDJ6rlEeFF3TBP9/GkNdp
        JmspodBKGz+a39+kf7YgvdhiSw==
X-Google-Smtp-Source: APXvYqz3hFjkb2z7Nu8jPiRud8QnvXBM77zXm9xaMdm7YFOjjXqK1kefkPFveQnMqpZPSnzUXpGyYA==
X-Received: by 2002:a19:4f46:: with SMTP id a6mr8039588lfk.143.1580130661940;
        Mon, 27 Jan 2020 05:11:01 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id k24sm10154017ljj.27.2020.01.27.05.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:11:01 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v6 02/12] net, sk_msg: Annotate lockless access to sk_prot on clone
Date:   Mon, 27 Jan 2020 14:10:47 +0100
Message-Id: <20200127131057.150941-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127131057.150941-1-jakub@cloudflare.com>
References: <20200127131057.150941-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_msg and ULP frameworks override protocol callbacks pointer in
sk->sk_prot, while tcp accesses it locklessly when cloning the listening
socket, that is with neither sk_lock nor sk_callback_lock held.

Once we enable use of listening sockets with sockmap (and hence sk_msg),
there will be shared access to sk->sk_prot if socket is getting cloned
while being inserted/deleted to/from the sockmap from another CPU:

Read side:

tcp_v4_rcv
  sk = __inet_lookup_skb(...)
  tcp_check_req(sk)
    inet_csk(sk)->icsk_af_ops->syn_recv_sock
      tcp_v4_syn_recv_sock
        tcp_create_openreq_child
          inet_csk_clone_lock
            sk_clone_lock
              READ_ONCE(sk->sk_prot)

Write side:

sock_map_ops->map_update_elem
  sock_map_update_elem
    sock_map_update_common
      sock_map_link_no_progs
        tcp_bpf_init
          tcp_bpf_update_sk_prot
            sk_psock_update_proto
              WRITE_ONCE(sk->sk_prot, ops)

sock_map_ops->map_delete_elem
  sock_map_delete_elem
    __sock_map_delete
     sock_map_unref
       sk_psock_put
         sk_psock_drop
           sk_psock_restore_proto
             tcp_update_ulp
               WRITE_ONCE(sk->sk_prot, proto)

Mark the shared access with READ_ONCE/WRITE_ONCE annotations.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/skmsg.h | 3 ++-
 net/core/sock.c       | 5 +++--
 net/ipv4/tcp_bpf.c    | 4 +++-
 net/ipv4/tcp_ulp.c    | 3 ++-
 net/tls/tls_main.c    | 3 ++-
 5 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 6311838e7df8..8647937998f3 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -352,7 +352,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
 	psock->saved_write_space = sk->sk_write_space;
 
 	psock->sk_proto = sk->sk_prot;
-	sk->sk_prot = ops;
+	/* Pairs with lockless read in sk_clone_lock() */
+	WRITE_ONCE(sk->sk_prot, ops);
 }
 
 static inline void sk_psock_restore_proto(struct sock *sk,
diff --git a/net/core/sock.c b/net/core/sock.c
index a4c8fac781ff..3953bb23f4d0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1792,16 +1792,17 @@ static void sk_init_common(struct sock *sk)
  */
 struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 {
+	struct proto *prot = READ_ONCE(sk->sk_prot);
 	struct sock *newsk;
 	bool is_charged = true;
 
-	newsk = sk_prot_alloc(sk->sk_prot, priority, sk->sk_family);
+	newsk = sk_prot_alloc(prot, priority, sk->sk_family);
 	if (newsk != NULL) {
 		struct sk_filter *filter;
 
 		sock_copy(newsk, sk);
 
-		newsk->sk_prot_creator = sk->sk_prot;
+		newsk->sk_prot_creator = prot;
 
 		/* SANITY */
 		if (likely(newsk->sk_net_refcnt))
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 8a01428f80c1..dd183b050642 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -645,8 +645,10 @@ static void tcp_bpf_reinit_sk_prot(struct sock *sk, struct sk_psock *psock)
 	/* Reinit occurs when program types change e.g. TCP_BPF_TX is removed
 	 * or added requiring sk_prot hook updates. We keep original saved
 	 * hooks in this case.
+	 *
+	 * Pairs with lockless read in sk_clone_lock().
 	 */
-	sk->sk_prot = &tcp_bpf_prots[family][config];
+	WRITE_ONCE(sk->sk_prot, &tcp_bpf_prots[family][config]);
 }
 
 static int tcp_bpf_assert_proto_ops(struct proto *ops)
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 38d3ad141161..6c43fa189195 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -106,7 +106,8 @@ void tcp_update_ulp(struct sock *sk, struct proto *proto,
 
 	if (!icsk->icsk_ulp_ops) {
 		sk->sk_write_space = write_space;
-		sk->sk_prot = proto;
+		/* Pairs with lockless read in sk_clone_lock() */
+		WRITE_ONCE(sk->sk_prot, proto);
 		return;
 	}
 
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 94774c0e5ff3..b19a54f4cdcc 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -742,7 +742,8 @@ static void tls_update(struct sock *sk, struct proto *p,
 		ctx->sk_write_space = write_space;
 		ctx->sk_proto = p;
 	} else {
-		sk->sk_prot = p;
+		/* Pairs with lockless read in sk_clone_lock() */
+		WRITE_ONCE(sk->sk_prot, p);
 		sk->sk_write_space = write_space;
 	}
 }
-- 
2.24.1

