Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E37330D271
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhBCER6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhBCERj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:17:39 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF04C0613ED;
        Tue,  2 Feb 2021 20:16:58 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id d1so22108716otl.13;
        Tue, 02 Feb 2021 20:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CfV1Fm31xMUSASHcYoqG39qAmbNZS+l3nJ5YNxvPQIA=;
        b=TSkNM8uNe8ESvviJRGqbIRHnF9Gvv+ayrvhUa74TKINc/yUpCFOTxQo2to5vopHZs6
         bvUFUnL1o0FoZNYnJQTJXm+2jecwlQjqClz8dfmI/zC0/QfH8O4ZjoyxNxzx61F0Zpzf
         VwcmAtHFXNTUmtutVqKgSzEsef16923zdlDAyQY9f2Hs65Qojq0Wdk7FFNaQY0Mwe/hg
         0m9Qse9jdBKzozgg7Zaf3933O6FwhDHBiFffwp8+QBxZCfwaOA8C1Bfkw4k//ARAxj04
         iR7RxezJJC15PUXV26uJZTC80RihHNME/7XXeZxb84rAOPnTh1cCsdzwUqVHTLq7Rq6A
         H6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CfV1Fm31xMUSASHcYoqG39qAmbNZS+l3nJ5YNxvPQIA=;
        b=eMuMG6K3VtG+dgcciL2TYH5ewgMWyXPedoN66tb8AB15Ca1F7Ie0WMCVOrKsoSahOQ
         iAW0MdM5RDLz7sphqJr4hF/INKZFtQ1SBPhbTN09oto5SHKq1c498oFQq4YcM6L5Kxh3
         a8fMR6lJCC6Ss6H6+hcUldYhuJh8OFzrkci0hnS4Gj36wY7UFVRe5F1lybq3B1Nw39mg
         c/9nxvyB0xH1D8FmzHT5ULAVXKFit1q6Vz//sKNHxp5If9r4SOgbPkJNZXG3FVujB88n
         ikb2qNXqz3+BQQMyIuw6kssmsSgYMKced2anYYh6cDyXNMGYV3i6UwH8/CMULDJFQZaY
         7Gyg==
X-Gm-Message-State: AOAM530XyBvKLhhy+i9SAOykZjWAPsIymK5+j/4ZRkIz/9PsXnGzFM5V
        MuVHgn0GszMDYBF6Q2Ji+1EUGxkPZzXEwQ==
X-Google-Smtp-Source: ABdhPJzr2aYtgsW3vl3Cv4zEu+1IQjrzP5LXAMUHl1WS+FkUv0yJRmbGXlNbgPAWHq38zFEXTcIjkA==
X-Received: by 2002:a9d:19aa:: with SMTP id k39mr770506otk.28.1612325818120;
        Tue, 02 Feb 2021 20:16:58 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:16:57 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 03/19] skmsg: use skb ext instead of TCP_SKB_CB
Date:   Tue,  2 Feb 2021 20:16:20 -0800
Message-Id: <20210203041636.38555-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
won't work for any other non-TCP protocols. We can move them to
skb ext instead of playing with skb cb, which is harder to make
correct.

Of course, except ->data_end, which is used by
sk_skb_convert_ctx_access() to adjust compile-time constant offset.
Fortunately, we can reuse the anonymous union where the field
'tcp_tsorted_anchor' is and save/restore the overwritten part
before/after a brief use.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h |  4 ++++
 include/linux/skmsg.h  | 45 ++++++++++++++++++++++++++++++++++++++++++
 include/net/tcp.h      | 25 -----------------------
 net/Kconfig            |  1 +
 net/core/filter.c      |  3 +--
 net/core/skbuff.c      |  7 +++++++
 net/core/skmsg.c       | 44 ++++++++++++++++++++++++++++-------------
 net/core/sock_map.c    | 12 +++++------
 8 files changed, 94 insertions(+), 47 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 46f901adf1a8..12a28268233a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -755,6 +755,7 @@ struct sk_buff {
 			void		(*destructor)(struct sk_buff *skb);
 		};
 		struct list_head	tcp_tsorted_anchor;
+		void			*data_end;
 	};
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
@@ -4166,6 +4167,9 @@ enum skb_ext_id {
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
index 56d641df3b0c..e212b0d1ba35 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -438,4 +438,49 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 		return false;
 	return psock->bpf_running;
 }
+
+struct skb_bpf_ext {
+	__u32 flags;
+	struct sock *sk_redir;
+};
+
+static inline void bpf_compute_data_end_sk_skb(struct sk_buff *skb)
+{
+	skb->data_end = skb->data + skb_headlen(skb);
+}
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
index be66571ad122..f7591768525d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -882,36 +882,11 @@ struct tcp_skb_cb {
 			struct inet6_skb_parm	h6;
 #endif
 		} header;	/* For incoming skbs */
-		struct {
-			__u32 flags;
-			struct sock *sk_redir;
-			void *data_end;
-		} bpf;
 	};
 };
 
 #define TCP_SKB_CB(__skb)	((struct tcp_skb_cb *)&((__skb)->cb[0]))
 
-static inline void bpf_compute_data_end_sk_skb(struct sk_buff *skb)
-{
-	TCP_SKB_CB(skb)->bpf.data_end = skb->data + skb_headlen(skb);
-}
-
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
index 0cc0805a8127..1e45bcaa23f1 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -422,6 +422,7 @@ config SOCK_VALIDATE_XMIT
 
 config NET_SOCK_MSG
 	bool
+	select SKB_EXTENSIONS
 	default n
 	help
 	  The NET_SOCK_MSG provides a framework for plain sockets (e.g. TCP) or
diff --git a/net/core/filter.c b/net/core/filter.c
index e15d4741719a..c1a19a663630 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9532,8 +9532,7 @@ static u32 sk_skb_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct __sk_buff, data_end):
 		off  = si->off;
 		off -= offsetof(struct __sk_buff, data_end);
-		off += offsetof(struct sk_buff, cb);
-		off += offsetof(struct tcp_skb_cb, bpf.data_end);
+		off += offsetof(struct sk_buff, data_end);
 		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg,
 				      si->src_reg, off);
 		break;
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
index f72fcb03d25c..2b5b8f05187a 100644
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
@@ -746,8 +747,13 @@ EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 			    struct sk_buff *skb)
 {
-	bpf_compute_data_end_sk_skb(skb);
-	return bpf_prog_run_pin_on_cpu(prog, skb);
+	int ret;
+
+	tcp_skb_tsorted_save(skb) {
+		bpf_compute_data_end_sk_skb(skb);
+		ret = bpf_prog_run_pin_on_cpu(prog, skb);
+	} tcp_skb_tsorted_restore(skb);
+	return ret;
 }
 
 static void sk_psock_skb_redirect(struct sk_buff *skb)
@@ -755,7 +761,7 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
 
-	sk_other = tcp_skb_bpf_redirect_fetch(skb);
+	sk_other = skb_bpf_ext_redirect_fetch(skb);
 	/* This error is a buggy BPF program, it returned a redirect
 	 * return code, but then didn't set a redirect interface.
 	 */
@@ -797,6 +803,9 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 	struct bpf_prog *prog;
 	int ret = __SK_PASS;
 
+	if (!skb_ext_add(skb, SKB_EXT_BPF))
+		return __SK_DROP;
+
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
@@ -805,9 +814,9 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
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
@@ -819,7 +828,6 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static void sk_psock_verdict_apply(struct sk_psock *psock,
 				   struct sk_buff *skb, int verdict)
 {
-	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
 	int err = -EIO;
 
@@ -831,9 +839,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 			goto out_free;
 		}
 
-		tcp = TCP_SKB_CB(skb);
-		tcp->bpf.flags |= BPF_F_INGRESS;
-
+		skb_bpf_ext_set_ingress(skb);
 		/* If the queue is empty then we can submit directly
 		 * into the msg queue. If its not empty we have to
 		 * queue work otherwise we may get OOO data. Otherwise,
@@ -873,11 +879,15 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
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
@@ -949,11 +959,17 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
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
index 37ff8e13e4cc..7b70fa290836 100644
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

