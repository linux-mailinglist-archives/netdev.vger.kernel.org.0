Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91F03230FE
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhBWSu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhBWSub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:50:31 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4076C06178B;
        Tue, 23 Feb 2021 10:49:50 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id w69so8966873oif.1;
        Tue, 23 Feb 2021 10:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XpL2WS4PVoIvSFIggqiz+U9aBMv9AGLu5gn8rcXb8mk=;
        b=GgpXDFvA6T2uhBpHFY977D5lez03bufJNJOKvkxfMoq51goUgx9yw/v/ssdAjf7upw
         ITvHhmf8fE6/oxeLjY6yiSG9MQ7D3HoURO11CRGLyrpVF4+fIQrNTGjD96LnQ/W2G8hj
         0FgWQYlqmYH3kZrgW/ENSCFNXxTTFdLscrp/Ao263fzgfonwK1nOuwsMoqwOZw3uw57Q
         qYZrHL5OaSSXkrfZQK10ab5aWSdLp6O3X8m1UkjzaMaHBU4ps0BKxGHseR6RNpIWYl/u
         Cw9p5KkgvH037J3+qXUJHPaDlsp1jX/+cYt146kKZGJk8I2s7lRRxcQFWt0Qqu46uNBg
         Ilkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XpL2WS4PVoIvSFIggqiz+U9aBMv9AGLu5gn8rcXb8mk=;
        b=mcU5Mw8rOlSv3GsB4VczxfNVDcHH+eR8+l0o++hPTFGukS8xkoc4/LopucIMsbWFFN
         eeIXp6q9Aa5jpcCXZAHXAauVtTodTdATKfdSgXvaQSVFfELAsdhbwdwO5HFpnaKOLhLN
         y9ytUcayXS3gJiZMzlNXYmMBQhT6MMq6tc0+ECxE+qp7U9zZpTXDNXS8xsMTkRMI4e3R
         klTKiG760Jx+seGZBbYmNLBYFt/ajVzd/YqkztoYMvjpLuAJLikKfB3+6mdEVmDsimpw
         yMfNZG1D3AM13+BCEhSjkkI8XihIO+9ZTFn7YnjplVF0t4RDENQXsHiEBWEx1to8MDRU
         poxw==
X-Gm-Message-State: AOAM533PRf3akkrF36Pu8LQLLa8HR6ifSWoyVNaO/FeKf0obM94JMaA9
        Cs7KVV1sx5w1beF5eqURLTcHt2kOqeyQBA==
X-Google-Smtp-Source: ABdhPJzkJaJnc5yPtRB9vgk8J4FuF1qLcKAFhFtLzYqIC2QJA8WWy+aPdr6rig/kEtwJSkt5brwyFA==
X-Received: by 2002:aca:484a:: with SMTP id v71mr136905oia.84.1614106190029;
        Tue, 23 Feb 2021 10:49:50 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4543:ab2:3bf6:ce41])
        by smtp.gmail.com with ESMTPSA id p12sm4387094oon.12.2021.02.23.10.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:49:49 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v7 4/9] skmsg: move sk_redir from TCP_SKB_CB to skb
Date:   Tue, 23 Feb 2021 10:49:29 -0800
Message-Id: <20210223184934.6054-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
does not work for any other non-TCP protocols. We can move them to
skb ext, but it introduces a memory allocation on fast path.

Fortunately, we only need to a word-size to store all the information,
because the flags actually only contains 1 bit so can be just packed
into the lowest bit of the "pointer", which is stored as unsigned
long.

Inside struct sk_buff, '_skb_refdst' can be reused because skb dst is
no longer needed after ->sk_data_ready() so we can just drop it.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h |  3 +++
 include/linux/skmsg.h  | 38 ++++++++++++++++++++++++++++++++++++++
 include/net/tcp.h      | 19 -------------------
 net/core/skmsg.c       | 31 +++++++++++++++++++------------
 net/core/sock_map.c    |  8 ++------
 5 files changed, 62 insertions(+), 37 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6d0a33d1c0db..bd84f799c952 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -755,6 +755,9 @@ struct sk_buff {
 			void		(*destructor)(struct sk_buff *skb);
 		};
 		struct list_head	tcp_tsorted_anchor;
+#ifdef CONFIG_NET_SOCK_MSG
+		unsigned long		_sk_redir;
+#endif
 	};
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 22e26f82de33..e0de45527bb6 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -455,4 +455,42 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 		return false;
 	return !!psock->saved_data_ready;
 }
+
+#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
+
+/* We only have one bit so far. */
+#define BPF_F_PTR_MASK ~(BPF_F_INGRESS)
+
+static inline bool skb_bpf_ingress(const struct sk_buff *skb)
+{
+	unsigned long sk_redir = skb->_sk_redir;
+
+	return sk_redir & BPF_F_INGRESS;
+}
+
+static inline void skb_bpf_set_ingress(struct sk_buff *skb)
+{
+	skb->_sk_redir |= BPF_F_INGRESS;
+}
+
+static inline void skb_bpf_set_redir(struct sk_buff *skb, struct sock *sk_redir,
+				     bool ingress)
+{
+	skb->_sk_redir = (unsigned long)sk_redir;
+	if (ingress)
+		skb->_sk_redir |= BPF_F_INGRESS;
+}
+
+static inline struct sock *skb_bpf_redirect_fetch(const struct sk_buff *skb)
+{
+	unsigned long sk_redir = skb->_sk_redir;
+
+	return (struct sock *)(sk_redir & BPF_F_PTR_MASK);
+}
+
+static inline void skb_bpf_redirect_clear(struct sk_buff *skb)
+{
+	skb->_sk_redir = 0;
+}
+#endif /* CONFIG_NET_SOCK_MSG */
 #endif /* _LINUX_SKMSG_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 947ef5da6867..075de26f449d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -883,30 +883,11 @@ struct tcp_skb_cb {
 			struct inet6_skb_parm	h6;
 #endif
 		} header;	/* For incoming skbs */
-		struct {
-			__u32 flags;
-			struct sock *sk_redir;
-		} bpf;
 	};
 };
 
 #define TCP_SKB_CB(__skb)	((struct tcp_skb_cb *)&((__skb)->cb[0]))
 
-static inline bool tcp_skb_bpf_ingress(const struct sk_buff *skb)
-{
-	return TCP_SKB_CB(skb)->bpf.flags & BPF_F_INGRESS;
-}
-
-static inline struct sock *tcp_skb_bpf_redirect_fetch(struct sk_buff *skb)
-{
-	return TCP_SKB_CB(skb)->bpf.sk_redir;
-}
-
-static inline void tcp_skb_bpf_redirect_clear(struct sk_buff *skb)
-{
-	TCP_SKB_CB(skb)->bpf.sk_redir = NULL;
-}
-
 extern const struct inet_connection_sock_af_ops ipv4_specific;
 
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 8822001ab3dc..409258367bea 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -525,7 +525,8 @@ static void sk_psock_backlog(struct work_struct *work)
 		len = skb->len;
 		off = 0;
 start:
-		ingress = tcp_skb_bpf_ingress(skb);
+		ingress = skb_bpf_ingress(skb);
+		skb_bpf_redirect_clear(skb);
 		do {
 			ret = -EIO;
 			if (likely(psock->sk->sk_socket))
@@ -631,7 +632,12 @@ void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 
 static void sk_psock_zap_ingress(struct sk_psock *psock)
 {
-	__skb_queue_purge(&psock->ingress_skb);
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(&psock->ingress_skb)) != NULL) {
+		skb_bpf_redirect_clear(skb);
+		kfree_skb(skb);
+	}
 	__sk_psock_purge_ingress_msg(psock);
 }
 
@@ -754,7 +760,7 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
 
-	sk_other = tcp_skb_bpf_redirect_fetch(skb);
+	sk_other = skb_bpf_redirect_fetch(skb);
 	/* This error is a buggy BPF program, it returned a redirect
 	 * return code, but then didn't set a redirect interface.
 	 */
@@ -804,9 +810,10 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		 * TLS context.
 		 */
 		skb->sk = psock->sk;
-		tcp_skb_bpf_redirect_clear(skb);
+		skb_dst_drop(skb);
+		skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
-		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
 	sk_psock_tls_verdict_apply(skb, psock->sk, ret);
@@ -818,7 +825,6 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static void sk_psock_verdict_apply(struct sk_psock *psock,
 				   struct sk_buff *skb, int verdict)
 {
-	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
 	int err = -EIO;
 
@@ -830,8 +836,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 			goto out_free;
 		}
 
-		tcp = TCP_SKB_CB(skb);
-		tcp->bpf.flags |= BPF_F_INGRESS;
+		skb_bpf_set_ingress(skb);
 
 		/* If the queue is empty then we can submit directly
 		 * into the msg queue. If its not empty we have to
@@ -892,9 +897,10 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		tcp_skb_bpf_redirect_clear(skb);
+		skb_dst_drop(skb);
+		skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
-		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:
@@ -1011,9 +1017,10 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		tcp_skb_bpf_redirect_clear(skb);
+		skb_dst_drop(skb);
+		skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
-		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 1a28a5c2c61e..dbfcd7006338 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -657,7 +657,6 @@ const struct bpf_func_proto bpf_sock_map_update_proto = {
 BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
 	   struct bpf_map *, map, u32, key, u64, flags)
 {
-	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
 	struct sock *sk;
 
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
@@ -667,8 +666,7 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
 
-	tcb->bpf.flags = flags;
-	tcb->bpf.sk_redir = sk;
+	skb_bpf_set_redir(skb, sk, flags & BPF_F_INGRESS);
 	return SK_PASS;
 }
 
@@ -1250,7 +1248,6 @@ const struct bpf_func_proto bpf_sock_hash_update_proto = {
 BPF_CALL_4(bpf_sk_redirect_hash, struct sk_buff *, skb,
 	   struct bpf_map *, map, void *, key, u64, flags)
 {
-	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
 	struct sock *sk;
 
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
@@ -1260,8 +1257,7 @@ BPF_CALL_4(bpf_sk_redirect_hash, struct sk_buff *, skb,
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
 
-	tcb->bpf.flags = flags;
-	tcb->bpf.sk_redir = sk;
+	skb_bpf_set_redir(skb, sk, flags & BPF_F_INGRESS);
 	return SK_PASS;
 }
 
-- 
2.25.1

