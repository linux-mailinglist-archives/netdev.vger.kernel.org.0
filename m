Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C59C162BA3
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgBRRKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:10:30 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37666 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgBRRK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:10:29 -0500
Received: by mail-wm1-f66.google.com with SMTP id a6so3763512wme.2
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YXqExacnZggF0X1fJkO+qE+caqN11IX81szwOsrBoUk=;
        b=Jv34iG7zPrJHaVmneYCeTKZ5N7lY/enz1JJ2id6lmkdqXxNBZCjAEF/lnj5bJYST1g
         PH6tMxneQgHqk9Rkd5yqhF/ZwHuQtuGwxnFShDRfHC9Seoc/dGCmfpvmFGLMqfEY3sNn
         DCUHOtc6Ldzzcy2rt4V1FEt/hUFqvBOFsQbZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YXqExacnZggF0X1fJkO+qE+caqN11IX81szwOsrBoUk=;
        b=BatiClnnPR/eR0TA0Wq/vVsX8t2s5WMLvgOaA/6hS9akdYF1bE6SLAus7ZadsrM7mi
         4RqklsVIQl8xxbjiOk1n8InSONm91XFVbljgINrkByVy7K/FuVRhKa3kVuWs2JSWvXxy
         dgLcTK18zEqzhC6v/4sZpupcQmFsHZAwMRAWPCtTc4BE8vjXSQ2gn9ITFjf5rybpzPTR
         8ls9MmP/DV11Y6IfAMKXstfSyKXFknGY4Z3hkwRr3q0ygQ+bKL0SBOB2wCRMQHYF0KmR
         lkvcwDXxUn2+4ku6q/gdRhSqMqSSoh25YiRcf7QbmnMszs71KncSKCMljys7waZttBWt
         QgDw==
X-Gm-Message-State: APjAAAUtHkLn3K0V49cbLTHAGDkE+H5C1FGVjFFUIi8VOoRwUkkcyx9N
        NPKfo4aXg7wQuV/N1C6ppxhkIw==
X-Google-Smtp-Source: APXvYqyEq1mXfxF9j+2MN2wYzWw28ntx7J6Yf5s6qC0ztv5+yXNQoyiyq9DnrPQ6nJmhdQIc+4rv1A==
X-Received: by 2002:a1c:6588:: with SMTP id z130mr4136675wmb.0.1582045827429;
        Tue, 18 Feb 2020 09:10:27 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id z19sm3927370wmi.43.2020.02.18.09.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:10:26 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v7 01/11] net, sk_msg: Annotate lockless access to sk_prot on clone
Date:   Tue, 18 Feb 2020 17:10:13 +0000
Message-Id: <20200218171023.844439-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218171023.844439-1-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
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

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/skmsg.h | 3 ++-
 net/core/sock.c       | 8 +++++---
 net/ipv4/tcp_bpf.c    | 4 +++-
 net/ipv4/tcp_ulp.c    | 3 ++-
 net/tls/tls_main.c    | 3 ++-
 5 files changed, 14 insertions(+), 7 deletions(-)

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
index a4c8fac781ff..bf1173b93eda 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1572,13 +1572,14 @@ static inline void sock_lock_init(struct sock *sk)
  */
 static void sock_copy(struct sock *nsk, const struct sock *osk)
 {
+	const struct proto *prot = READ_ONCE(osk->sk_prot);
 #ifdef CONFIG_SECURITY_NETWORK
 	void *sptr = nsk->sk_security;
 #endif
 	memcpy(nsk, osk, offsetof(struct sock, sk_dontcopy_begin));
 
 	memcpy(&nsk->sk_dontcopy_end, &osk->sk_dontcopy_end,
-	       osk->sk_prot->obj_size - offsetof(struct sock, sk_dontcopy_end));
+	       prot->obj_size - offsetof(struct sock, sk_dontcopy_end));
 
 #ifdef CONFIG_SECURITY_NETWORK
 	nsk->sk_security = sptr;
@@ -1792,16 +1793,17 @@ static void sk_init_common(struct sock *sk)
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
index 94774c0e5ff3..82225bcc1117 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -742,7 +742,8 @@ static void tls_update(struct sock *sk, struct proto *p,
 		ctx->sk_write_space = write_space;
 		ctx->sk_proto = p;
 	} else {
-		sk->sk_prot = p;
+		/* Pairs with lockless read in sk_clone_lock(). */
+		WRITE_ONCE(sk->sk_prot, p);
 		sk->sk_write_space = write_space;
 	}
 }
-- 
2.24.1

