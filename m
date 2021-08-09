Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B40B3E4C73
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbhHISy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbhHISyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 14:54:21 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A851C061798
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 11:54:01 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a5so1823131plh.5
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 11:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4+vb4UQI5XhwkQ1xvPoLu56obdJI+5TluGytOgxzYRs=;
        b=wm8dVH1pjbR2mPtDMUazv2NPL9FasOaWeOJgsQov4Q+o0TprMCjXJ1YgwC0pgOuvTg
         KQkCqm4B1GxlDtrvIy8YEhBHPtuMWG4t0ZX34R5j/M9ht22J8XvOPop0ddTujQ+M60EB
         CtYKzA1cfsMRZO6UmJ9VTFRT8WyfMyRVROgQOakCZyP6f8Emh9P2rSZhjT7xgBzigMfv
         BQ1OZKIYhmdl8sQXbv4NF4JsWv4vyfN5/ZjKcZ6+sXsNWQFWoXa+ccHt4SNwvYU9JWPd
         U1z9sEq/wM4InIJ1Pb0aFwYQPixxId/Ievinb7rfAC2ZWsRepCg/oPzlBpf64Mhi3Qde
         7l1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4+vb4UQI5XhwkQ1xvPoLu56obdJI+5TluGytOgxzYRs=;
        b=Ds7wnCpEgVgXWtbzpTQI3QWc8BdiIMyootjuj5w1+7zk1aHBZzX3E6zv+19bg/OgmT
         ORinDceOQNIqLpmr4ZUEBOXfSRcAEWHVEN1H7tdESd2pZ7laely/bXZc6oel65XKcszt
         HZPeuPcFrCbleaDhiLcGNen4qYz6y2zi+/aCX/BV4/gSHK4A+uNZrkgDUFVJYaD5amiy
         koXj2wi/fV6kuQXK+qkqheJTtF9PCNsGyVHDAx1bIOPea8d4x9dxWSv7RGVAfTNoTrgH
         IaivEr/bWdyf5CKKwQFu9qiv6l9eYeSRqCHcHq4GoHd9LamkMDhq/1CJPs19UEWXwhqK
         QVig==
X-Gm-Message-State: AOAM53037Le2MPgTbeuCV37XoNo0/htyLKzCXXkM4eZFpootZqp3Vg/e
        SoIe/dIGPIGwK+GVTpEY2ZEDFxiH1R3anLBQ
X-Google-Smtp-Source: ABdhPJyPq/qLmO16VtLmixUW8k8DHZflqK2OgkaSuyBNzbwopyKBBYicD4d75ajejPeLYRRaUMXpSQ==
X-Received: by 2002:a17:90a:a883:: with SMTP id h3mr27389616pjq.226.1628535240433;
        Mon, 09 Aug 2021 11:54:00 -0700 (PDT)
Received: from localhost.localdomain ([12.33.129.114])
        by smtp.gmail.com with ESMTPSA id b28sm21255364pff.155.2021.08.09.11.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 11:54:00 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, brakmo@fb.com,
        ycheng@google.com, eric.dumazet@gmail.com, a.e.azimov@gmail.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH net-next 1/3] txhash: Make rethinking txhash behavior configurable via sysctl
Date:   Mon,  9 Aug 2021 11:53:12 -0700
Message-Id: <20210809185314.38187-2-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809185314.38187-1-tom@herbertland.com>
References: <20210809185314.38187-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a per ns sysctl that controls the txhash rethink behavior,
sk_rethink_txhash. This sysctl value is a mask rethink modes that are:
rethink at negative advice, rethink at SYN RTO, and rethink at non-SYN
RTO. A value of zero disables hash rethink. The default mask is set
to rethink with all three modes (retains current default behavior)
---
 include/net/netns/core.h    |  2 ++
 include/net/sock.h          | 26 +++++++++++++++++---------
 include/uapi/linux/socket.h | 13 +++++++++++++
 net/core/net_namespace.c    |  6 ++++++
 net/core/sysctl_net_core.c  |  7 +++++++
 net/ipv4/tcp_input.c        |  2 +-
 net/ipv4/tcp_timer.c        |  5 ++++-
 7 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/include/net/netns/core.h b/include/net/netns/core.h
index 36c2d998a43c..503f43bfc1d3 100644
--- a/include/net/netns/core.h
+++ b/include/net/netns/core.h
@@ -11,6 +11,8 @@ struct netns_core {
 
 	int	sysctl_somaxconn;
 
+	unsigend int sysctl_txrehash_mode;
+
 #ifdef CONFIG_PROC_FS
 	int __percpu *sock_inuse;
 	struct prot_inuse __percpu *prot_inuse;
diff --git a/include/net/sock.h b/include/net/sock.h
index 6e761451c927..6ef5314e8eed 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -577,6 +577,12 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
 			   __tmp | SK_USER_DATA_NOCOPY);		\
 })
 
+static inline
+struct net *sock_net(const struct sock *sk)
+{
+	return read_pnet(&sk->sk_net);
+}
+
 /*
  * SK_CAN_REUSE and SK_NO_REUSE on a socket mean that the socket is OK
  * or not whether his port will be reused by someone else. SK_FORCE_REUSE
@@ -1940,12 +1946,20 @@ static inline void sk_set_txhash(struct sock *sk)
 	WRITE_ONCE(sk->sk_txhash, net_tx_rndhash());
 }
 
-static inline bool sk_rethink_txhash(struct sock *sk)
+static inline bool sk_rethink_txhash(struct sock *sk, unsigned int level)
 {
-	if (sk->sk_txhash) {
+	unsigned int rehash_mode;
+
+	if (!sk->sk_txhash)
+		return false;
+
+	rehash_mode = READ_ONCE(sock_net(sk)->core.sysctl_txrehash_mode);
+
+	if (level & rehash_mode) {
 		sk_set_txhash(sk);
 		return true;
 	}
+
 	return false;
 }
 
@@ -1986,7 +2000,7 @@ static inline void __dst_negative_advice(struct sock *sk)
 
 static inline void dst_negative_advice(struct sock *sk)
 {
-	sk_rethink_txhash(sk);
+	sk_rethink_txhash(sk, SOCK_TXREHASH_MODE_NEG_ADVICE);
 	__dst_negative_advice(sk);
 }
 
@@ -2591,12 +2605,6 @@ static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 
-static inline
-struct net *sock_net(const struct sock *sk)
-{
-	return read_pnet(&sk->sk_net);
-}
-
 static inline
 void sock_net_set(struct sock *sk, struct net *net)
 {
diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index eb0a9a5b6e71..2c2cef795a9b 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -31,4 +31,17 @@ struct __kernel_sockaddr_storage {
 
 #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
 
+#define SOCK_TXREHASH_MODE_DISABLE	0
+
+/* Flag bits for individual rehash function modes */
+#define SOCK_TXREHASH_MODE_NEG_ADVICE	0x1
+#define SOCK_TXREHASH_MODE_SYN_RTO	0x2
+#define SOCK_TXREHASH_MODE_RTO		0x4
+
+#define SOCK_TXREHASH_MODE_DEFAULT	-1U
+
+#define SOCK_TXREHASH_MODE_MASK	(SOCK_TXREHASH_MODE_NEG_ADVICE |	\
+				 SOCK_TXREHASH_MODE_SYN_RTO |		\
+				 SOCK_TXREHASH_MODE_RTO)
+
 #endif /* _UAPI_LINUX_SOCKET_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9b5a767eddd5..03d3767e6728 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -366,6 +366,12 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 static int __net_init net_defaults_init_net(struct net *net)
 {
 	net->core.sysctl_somaxconn = SOMAXCONN;
+
+	/* Default rethink mode is aggrssive (i.e. rethink on first RTO) */
+	net->core.sysctl_txrehash_mode = SOCK_TXREHASH_MODE_NEG_ADVICE |
+					 SOCK_TXREHASH_MODE_SYN_RTO |
+					 SOCK_TXREHASH_MODE_RTO;
+
 	return 0;
 }
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index c8496c1142c9..7e828a892bf5 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -592,6 +592,13 @@ static struct ctl_table netns_core_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.proc_handler	= proc_dointvec_minmax
 	},
+	{
+		.procname	= "txrehash_mode",
+		.data		= &init_net.core.sysctl_txrehash_mode,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3f7bd7ae7d7a..08eeb2523393 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4442,7 +4442,7 @@ static void tcp_rcv_spurious_retrans(struct sock *sk, const struct sk_buff *skb)
 	 * DSACK state and change the txhash to re-route speculatively.
 	 */
 	if (TCP_SKB_CB(skb)->seq == tcp_sk(sk)->duplicate_sack[0].start_seq &&
-	    sk_rethink_txhash(sk))
+	    sk_rethink_txhash(sk, SOCK_TXREHASH_MODE_RTO))
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPDUPLICATEDATAREHASH);
 }
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 20cf4a98c69d..53ae43ab5ebe 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -234,6 +234,7 @@ static int tcp_write_timeout(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	bool expired = false, do_reset;
+	unsigned int rehash_mode;
 	int retry_until;
 
 	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
@@ -241,6 +242,7 @@ static int tcp_write_timeout(struct sock *sk)
 			__dst_negative_advice(sk);
 		retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
 		expired = icsk->icsk_retransmits >= retry_until;
+		rehash_mode = SOCK_TXREHASH_MODE_SYN_RTO;
 	} else {
 		if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1, 0)) {
 			/* Black hole detection */
@@ -260,6 +262,7 @@ static int tcp_write_timeout(struct sock *sk)
 			if (tcp_out_of_resources(sk, do_reset))
 				return 1;
 		}
+		rehash_mode = SOCK_TXREHASH_MODE_RTO;
 	}
 	if (!expired)
 		expired = retransmits_timed_out(sk, retry_until,
@@ -277,7 +280,7 @@ static int tcp_write_timeout(struct sock *sk)
 		return 1;
 	}
 
-	if (sk_rethink_txhash(sk)) {
+	if (sk_rethink_txhash(sk, rehash_mode)) {
 		tp->timeout_rehash++;
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPTIMEOUTREHASH);
 	}
-- 
2.25.1

