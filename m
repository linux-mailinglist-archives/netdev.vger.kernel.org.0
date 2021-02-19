Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5714832020C
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 01:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBSX7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 18:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBSX71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 18:59:27 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03386C06178C;
        Fri, 19 Feb 2021 15:58:47 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id v193so7687493oie.8;
        Fri, 19 Feb 2021 15:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gZxRzmATGkrPpYiGxL52mxfgMW0SHjgvSF1BoeB4Dmw=;
        b=R0k9HxSZXToN3FEasqxSnJs7PF3ehF3+GRSkIAZAwUm2PSOFL2UAdG2gBebExcRiCX
         jBj/jesHLVdvDgxlpJKStjTVB48ZupIxV/rxiSHm7JJOy4AhfdAIDFtnVKC7SOemBY0l
         vhgx5LABLFh85jaYf+tl2rcJ7mWMyTV8BLmyjv4NCKEsWXCd9RqPeH2f+R4kd/sP88kx
         BAs4uo24eaLlLGWem9Lorsjk7V2AabhjjmzNui9k+F73JQzd3/scLJSMoRJXIc6auSf+
         z49l10bPpiCP+xWYMpWJlC+rtnL8aOPOnwI/Wrw6anmOMfuKf0OLBsYvfN24G8VjS+ho
         XMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gZxRzmATGkrPpYiGxL52mxfgMW0SHjgvSF1BoeB4Dmw=;
        b=kePdyYkJrhLr0kX1jCB8MthtBwDQpG+kIUEfrheRLpkltLQG08mJRWV9ekpe1V/Qdl
         SE1XCGDezx1YfueFcmE9JlBgg0aYky3jnrvJQwPFrb9APJML11FR+NHdt0zKVFFiyWHy
         oE3ZrAFO9b7yeOs/MgHJwRBXoA/L5Oxd28ZDidE/W/UdCtikERmocciOluBdcLPLbhtD
         oePUw6dSqLawixURz+rlPSVrmOZFoAK5GuxZxxmaqmZaxCAnnT8IwdZNC8omkGwB3D7L
         TS9XQ/ikROxAeZJ9mEJrsFzbF6LSYaaw87zwCcqQIlq3ivQZMtCz0KJJSAPp14LvznOC
         ycBQ==
X-Gm-Message-State: AOAM533POZ7AQA3NBh8d/IlcpDOdK53FpgdYK2XCFpLeKZSW7wEE7k01
        bPFRFBDWciIP7yYIgwU25Mumo3a/w+UGXg==
X-Google-Smtp-Source: ABdhPJyFWQt27W0/PggZ5HCEngdFlrwBGTuBDGXw05WZn0TCi20TlMteuIsZK2IzXJ+M+Rt/rEIEbg==
X-Received: by 2002:aca:f388:: with SMTP id r130mr8766556oih.55.1613779126259;
        Fri, 19 Feb 2021 15:58:46 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id h11sm2064186ooj.36.2021.02.19.15.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 15:58:45 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v5 4/8] skmsg: move sk_redir from TCP_SKB_CB to skb
Date:   Fri, 19 Feb 2021 15:58:32 -0800
Message-Id: <20210219235836.100416-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
References: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
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
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h |  3 +++
 include/linux/skmsg.h  | 35 +++++++++++++++++++++++++++++++++++
 include/net/tcp.h      | 19 -------------------
 net/core/skmsg.c       | 32 ++++++++++++++++++++------------
 net/core/sock_map.c    |  8 ++------
 5 files changed, 60 insertions(+), 37 deletions(-)

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
index e3bb712af257..fc234d507fd7 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -459,4 +459,39 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 		return false;
 	return !!psock->saved_data_ready;
 }
+
+#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
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
+	sk_redir &= ~0x1UL;
+	return (struct sock *)sk_redir;
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
index 2d8bbb3fd87c..05b5af09ff42 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -494,6 +494,8 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 			       u32 off, u32 len, bool ingress)
 {
+	skb_bpf_redirect_clear(skb);
+
 	if (!ingress) {
 		if (!sock_writeable(psock->sk))
 			return -EAGAIN;
@@ -525,7 +527,7 @@ static void sk_psock_backlog(struct work_struct *work)
 		len = skb->len;
 		off = 0;
 start:
-		ingress = tcp_skb_bpf_ingress(skb);
+		ingress = skb_bpf_ingress(skb);
 		do {
 			ret = -EIO;
 			if (likely(psock->sk->sk_socket))
@@ -631,7 +633,12 @@ void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 
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
 
@@ -752,7 +759,7 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
 
-	sk_other = tcp_skb_bpf_redirect_fetch(skb);
+	sk_other = skb_bpf_redirect_fetch(skb);
 	/* This error is a buggy BPF program, it returned a redirect
 	 * return code, but then didn't set a redirect interface.
 	 */
@@ -802,9 +809,10 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
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
@@ -816,7 +824,6 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static void sk_psock_verdict_apply(struct sk_psock *psock,
 				   struct sk_buff *skb, int verdict)
 {
-	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
 	int err = -EIO;
 
@@ -828,8 +835,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 			goto out_free;
 		}
 
-		tcp = TCP_SKB_CB(skb);
-		tcp->bpf.flags |= BPF_F_INGRESS;
+		skb_bpf_set_ingress(skb);
 
 		/* If the queue is empty then we can submit directly
 		 * into the msg queue. If its not empty we have to
@@ -890,9 +896,10 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
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
@@ -1005,9 +1012,10 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
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

