Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7AA31AE35
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 22:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhBMVph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 16:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhBMVpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 16:45:13 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB694C061788;
        Sat, 13 Feb 2021 13:44:32 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id h6so3780449oie.5;
        Sat, 13 Feb 2021 13:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pvykklPQYLPOPzThGdtfOEceQHItKhFMHmwnsPvxO0A=;
        b=iocdiLHm3S283QwziFQdnCRvpoaAeZPwd2GbKuvfFCDYBVclFalWLbITGvQl75sHcd
         aE+LwwxegfZ61skvwuizzLO71Vo3GI/pSHNE1gUiJR/8qcjJNV2xQ834YN61L5p2vZhz
         b3UwUoQg5wuTscpf0Fd9Ht1PUY4hgTw59ycSH9j7aSjr/Cc0YpwEkoOZhpjql0b/DQlc
         fJbN4fs/KIpp9oFkuTcP6RUJMHcxo83C1yLq+KyydopjlmAH98tvqurL3ppcRUjd9uk0
         A72cWmNGNjhry9nsWI510sE9JD9+eZv1Iq3IuCnNt38wjl7VeUUGXpy1kcT4ZJZi6pKg
         613A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pvykklPQYLPOPzThGdtfOEceQHItKhFMHmwnsPvxO0A=;
        b=g6W/hXhF6Zu7sOBayW7r0/roOrEdpCApGQgjQZO0flgYuRDtb1I+3ESJ0kui6DnGQv
         20FvEl5dDpzIElpMAfPOmz4jRe88+SG5k9J3txDIc/wlEa+RiIDgJWDI04G9q1i+lT+2
         MZ4w4S+M/EwMzNckonkTR3sWNFka+lq2UsABk2MdO97huLXyHA2I4TpmF2DBnzonFJGU
         EIMhw4QX9lC7rD7Vmp/1vaomUlAu3IHPuhaOydUKpeGx9KwVhJpdun97Mobd5fp0wp+f
         58yi4xSMjU6A+at/Vy+ncXcka0OTty2OzXIGxfBSELcuDVlUKUSTLHK5lH6eUOW/I1Bl
         4DtA==
X-Gm-Message-State: AOAM532iroyGUJf//PNeCKfZEn96sndl86srSA1ue8Q+IFijxYwk7v7u
        prHkhLEFav6E9WdXmzFEXFhmC545magX1g==
X-Google-Smtp-Source: ABdhPJx9n9vsfPFK6ValJG4bgfu/MxjmwC6lrLZUMesiXu5rTObVTIZHNSC8cjdwDerafUSMa1ZlwA==
X-Received: by 2002:aca:5dd7:: with SMTP id r206mr3924161oib.133.1613252672010;
        Sat, 13 Feb 2021 13:44:32 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:108:c15a:7f7a:df71])
        by smtp.gmail.com with ESMTPSA id c17sm2509674otp.58.2021.02.13.13.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 13:44:31 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
Date:   Sat, 13 Feb 2021 13:44:20 -0800
Message-Id: <20210213214421.226357-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
does not work for any other non-TCP protocols. We can move them to
skb ext instead of playing with skb cb, which is harder to make
correct.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h |  3 +++
 include/linux/skmsg.h  | 40 ++++++++++++++++++++++++++++++++++++++++
 include/net/tcp.h      | 19 -------------------
 net/Kconfig            |  1 +
 net/core/skbuff.c      |  7 +++++++
 net/core/skmsg.c       | 35 +++++++++++++++++++++++------------
 net/core/sock_map.c    | 12 ++++++------
 7 files changed, 80 insertions(+), 37 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 46f901adf1a8..2d4ffe77ef47 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4166,6 +4166,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 	SKB_EXT_MPTCP,
+#endif
+#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
+	SKB_EXT_BPF,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index e3bb712af257..d5c711ef6d4b 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -459,4 +459,44 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 		return false;
 	return !!psock->saved_data_ready;
 }
+
+struct skb_bpf_ext {
+	__u32 flags;
+	struct sock *sk_redir;
+};
+
+#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
+static inline
+bool skb_bpf_ext_ingress(const struct sk_buff *skb)
+{
+	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
+
+	return ext->flags & BPF_F_INGRESS;
+}
+
+static inline
+void skb_bpf_ext_set_ingress(const struct sk_buff *skb)
+{
+	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
+
+	ext->flags |= BPF_F_INGRESS;
+}
+
+static inline
+struct sock *skb_bpf_ext_redirect_fetch(struct sk_buff *skb)
+{
+	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
+
+	return ext->sk_redir;
+}
+
+static inline
+void skb_bpf_ext_redirect_clear(struct sk_buff *skb)
+{
+	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
+
+	ext->flags = 0;
+	ext->sk_redir = NULL;
+}
+#endif /* CONFIG_NET_SOCK_MSG */
 #endif /* _LINUX_SKMSG_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 697712178eff..e35881f837b2 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -882,30 +882,11 @@ struct tcp_skb_cb {
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
diff --git a/net/Kconfig b/net/Kconfig
index a4f60d0c630f..9b4dd1ad2188 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -419,6 +419,7 @@ config SOCK_VALIDATE_XMIT
 
 config NET_SOCK_MSG
 	bool
+	select SKB_EXTENSIONS
 	default n
 	help
 	  The NET_SOCK_MSG provides a framework for plain sockets (e.g. TCP) or
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 145503d3f06b..7695a2b65832 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -60,6 +60,7 @@
 #include <linux/prefetch.h>
 #include <linux/if_vlan.h>
 #include <linux/mpls.h>
+#include <linux/skmsg.h>
 
 #include <net/protocol.h>
 #include <net/dst.h>
@@ -4259,6 +4260,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MPTCP)
 	[SKB_EXT_MPTCP] = SKB_EXT_CHUNKSIZEOF(struct mptcp_ext),
 #endif
+#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
+	[SKB_EXT_BPF] = SKB_EXT_CHUNKSIZEOF(struct skb_bpf_ext),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4275,6 +4279,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 		skb_ext_type_len[SKB_EXT_MPTCP] +
+#endif
+#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
+		skb_ext_type_len[SKB_EXT_BPF] +
 #endif
 		0;
 }
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d8bbb3fd87c..9404dbf5d57b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -525,7 +525,8 @@ static void sk_psock_backlog(struct work_struct *work)
 		len = skb->len;
 		off = 0;
 start:
-		ingress = tcp_skb_bpf_ingress(skb);
+		ingress = skb_bpf_ext_ingress(skb);
+		skb_ext_del(skb, SKB_EXT_BPF);
 		do {
 			ret = -EIO;
 			if (likely(psock->sk->sk_socket))
@@ -752,7 +753,7 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
 
-	sk_other = tcp_skb_bpf_redirect_fetch(skb);
+	sk_other = skb_bpf_ext_redirect_fetch(skb);
 	/* This error is a buggy BPF program, it returned a redirect
 	 * return code, but then didn't set a redirect interface.
 	 */
@@ -794,6 +795,9 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 	struct bpf_prog *prog;
 	int ret = __SK_PASS;
 
+	if (!skb_ext_add(skb, SKB_EXT_BPF))
+		return __SK_DROP;
+
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
@@ -802,9 +806,9 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		 * TLS context.
 		 */
 		skb->sk = psock->sk;
-		tcp_skb_bpf_redirect_clear(skb);
+		skb_bpf_ext_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
-		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		ret = sk_psock_map_verd(ret, skb_bpf_ext_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
 	sk_psock_tls_verdict_apply(skb, psock->sk, ret);
@@ -816,7 +820,6 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static void sk_psock_verdict_apply(struct sk_psock *psock,
 				   struct sk_buff *skb, int verdict)
 {
-	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
 	int err = -EIO;
 
@@ -828,9 +831,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 			goto out_free;
 		}
 
-		tcp = TCP_SKB_CB(skb);
-		tcp->bpf.flags |= BPF_F_INGRESS;
-
+		skb_bpf_ext_set_ingress(skb);
 		/* If the queue is empty then we can submit directly
 		 * into the msg queue. If its not empty we have to
 		 * queue work otherwise we may get OOO data. Otherwise,
@@ -888,11 +889,15 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		goto out;
 	}
 	skb_set_owner_r(skb, sk);
+	if (!skb_ext_add(skb, SKB_EXT_BPF)) {
+		kfree_skb(skb);
+		goto out;
+	}
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		tcp_skb_bpf_redirect_clear(skb);
+		skb_bpf_ext_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
-		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		ret = sk_psock_map_verd(ret, skb_bpf_ext_redirect_fetch(skb));
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:
@@ -1003,11 +1008,17 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		goto out;
 	}
 	skb_set_owner_r(skb, sk);
+	if (!skb_ext_add(skb, SKB_EXT_BPF)) {
+		len = 0;
+		kfree_skb(skb);
+		goto out;
+	}
+
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		tcp_skb_bpf_redirect_clear(skb);
+		skb_bpf_ext_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
-		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		ret = sk_psock_map_verd(ret, skb_bpf_ext_redirect_fetch(skb));
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 1a28a5c2c61e..e9f2a17fb665 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -657,7 +657,7 @@ const struct bpf_func_proto bpf_sock_map_update_proto = {
 BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
 	   struct bpf_map *, map, u32, key, u64, flags)
 {
-	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
+	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
 	struct sock *sk;
 
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
@@ -667,8 +667,8 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
 
-	tcb->bpf.flags = flags;
-	tcb->bpf.sk_redir = sk;
+	ext->flags = flags;
+	ext->sk_redir = sk;
 	return SK_PASS;
 }
 
@@ -1250,7 +1250,7 @@ const struct bpf_func_proto bpf_sock_hash_update_proto = {
 BPF_CALL_4(bpf_sk_redirect_hash, struct sk_buff *, skb,
 	   struct bpf_map *, map, void *, key, u64, flags)
 {
-	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
+	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
 	struct sock *sk;
 
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
@@ -1260,8 +1260,8 @@ BPF_CALL_4(bpf_sk_redirect_hash, struct sk_buff *, skb,
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
 
-	tcb->bpf.flags = flags;
-	tcb->bpf.sk_redir = sk;
+	ext->flags = flags;
+	ext->sk_redir = sk;
 	return SK_PASS;
 }
 
-- 
2.25.1

