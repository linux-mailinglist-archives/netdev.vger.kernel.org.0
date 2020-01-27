Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22D314A434
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgA0Mzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:55:44 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32848 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0Mzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:55:42 -0500
Received: by mail-lj1-f195.google.com with SMTP id y6so10585113lji.0
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 04:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k8Veto/cVx1lv+6TZNHNh2Eg0c6VFkl5haTHGkEvtg4=;
        b=Tl6WJQyQSU84GXJ3ZQ1V+bk3HiFHfSwT6dAPjrboh4DAxlEYnELd0WPBcB+/yXe6om
         DOKqpyxpILLZtHgdRJs0ZlbkLZhB+xYaBO6rpJQkoQ/Ksceq0L6EqUZ7YpkfUv42e5Kb
         /qGwlw5hyhoh5aCfb/UO63P4g8K4R/iVQpoic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k8Veto/cVx1lv+6TZNHNh2Eg0c6VFkl5haTHGkEvtg4=;
        b=e4gh9xNX9SPsjw8/ztzf9vpJ++1H5f5eQe1IP2/PlvsnxE9dSzXCAGweoB9HuL6sz5
         LsYxGhuCQK1Vo3Ui25uxWHIAPV9rVrm1oPawbeNdTTMDgC1ikfSWuobeAxaNU3nMELGo
         kRcoYN4H1mvNvOnjSO0ZQw7EuRv45xMRNtFoShqMYyf43G8Gu6Ac4aOoBMqxLJxeB6eR
         W8T4FUm2B6bInMD67iLKFIoM6tpjzdoE4LQFWQdwykBFXIQWafZazYywIEqOTyRDsJ2U
         fZ1CnPZVkL+Rmu4rD8ZhcvnSEXNiQEwHlDfKYCzcwKv/3e6BEqnFfj0BFnxAoNfVE99j
         3X0A==
X-Gm-Message-State: APjAAAXqHyyK8/I83g3pmZjux3UgaAKinJL6NPkE161gz1ekZFcyQTVg
        Eq569pXB2Cv2aFO+lAYI9kxVxg==
X-Google-Smtp-Source: APXvYqzp+OsNoancH/uTQzUtcvR8GV4xjrf/gfxwVjpdg0R7z0TPshKp0AkGYf4YQcG9/KPKEg+Y5Q==
X-Received: by 2002:a05:651c:1032:: with SMTP id w18mr9912997ljm.61.1580129739447;
        Mon, 27 Jan 2020 04:55:39 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j7sm1865368lfh.25.2020.01.27.04.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 04:55:38 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v5 02/12] net, sk_msg: Annotate lockless access to sk_prot on clone
Date:   Mon, 27 Jan 2020 13:55:24 +0100
Message-Id: <20200127125534.137492-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127125534.137492-1-jakub@cloudflare.com>
References: <20200127125534.137492-1-jakub@cloudflare.com>
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
index d90ef61712a1..112765bd146d 100644
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

