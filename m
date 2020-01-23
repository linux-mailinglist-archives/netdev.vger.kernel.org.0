Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF994146D70
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgAWPzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:55:41 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44496 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgAWPzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:55:40 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so3622142wrm.11
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 07:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GcvhsL+VpEJFHJ1f37fO6HxodnClhAyICem3KeipO9g=;
        b=WVEfHv9/nrsjJiDhk2cR3CKIUaomVmuAR7mzmRWSbcA3zV5nRio1h/SZqJM6On0AR/
         JyE2HdXzR+OHxwxxDWyr3DMXOGUoOecv4rlAHjTM9ogLR2p1gOCmxg/qbk4+J0NgD4uE
         l/unVk8sF6/Y2QMEyTYqWqXEmBQiqPnJYbi2I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GcvhsL+VpEJFHJ1f37fO6HxodnClhAyICem3KeipO9g=;
        b=MyQ+Tjea/v9ysA2aHYoc2sR2NGrsRKr6cNLEPxjx8a0SWzDnCJZMXBlJjMQ+uMysYg
         Iwqi/pmE50NqMPyYJ8uKyorXBwIKD3k9d87LY9cm46QVtzEqTLy6X5S7AymVuyRTPCUT
         8uLnRzB71w2p98cphZa9ihivhukBLnY5AqowvZ/JB1nJ4rKTY2y2p8iRHVYPuyeiCD7R
         MPPpRWfXgpQbNThJRPX+JQmukWd1T1Jdp32yuHu2m4mONjDOYfulmSqUrHgpzydPmpAt
         Ta/fw9ftRTcuHT2jsTz1pwyO2oWTLs4kY1DVCTKfPFmO2CGpIH32jfNy3NjfWiT9F4Bz
         Ig4Q==
X-Gm-Message-State: APjAAAXULPuA+/kEBjdanpaE6sL4eP8J0WLpmikjq9thyFT3FGyu6V0c
        g+DiDC7I9lgoJX8dJOpd6Uaf+g==
X-Google-Smtp-Source: APXvYqynBdBrOnDxCn0a6swINDVdgYOfN7uGP2C7J05zUIxYIXs0Q6fYJoNH8dobD/p3ZxUmPQwK2Q==
X-Received: by 2002:adf:f789:: with SMTP id q9mr19369644wrp.103.1579794938318;
        Thu, 23 Jan 2020 07:55:38 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id a132sm3189409wme.3.2020.01.23.07.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 07:55:37 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 02/12] net, sk_msg: Annotate lockless access to sk_prot on clone
Date:   Thu, 23 Jan 2020 16:55:24 +0100
Message-Id: <20200123155534.114313-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123155534.114313-1-jakub@cloudflare.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
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
index 41ea1258d15e..55c834a5c25e 100644
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
index e38705165ac9..4f25aba44ead 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -648,8 +648,10 @@ static void tcp_bpf_reinit_sk_prot(struct sock *sk, struct sk_psock *psock)
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
index 12ab5db2b71c..acd1ea0a66f7 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -104,7 +104,8 @@ void tcp_update_ulp(struct sock *sk, struct proto *proto)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	if (!icsk->icsk_ulp_ops) {
-		sk->sk_prot = proto;
+		/* Pairs with lockless read in sk_clone_lock() */
+		WRITE_ONCE(sk->sk_prot, proto);
 		return;
 	}
 
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index dac24c7aa7d4..f0748e951dea 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -740,7 +740,8 @@ static void tls_update(struct sock *sk, struct proto *p)
 	if (likely(ctx))
 		ctx->sk_proto = p;
 	else
-		sk->sk_prot = p;
+		/* Pairs with lockless read in sk_clone_lock() */
+		WRITE_ONCE(sk->sk_prot, p);
 }
 
 static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
-- 
2.24.1

