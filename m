Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 703EC107E22
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 12:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKWLID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 06:08:03 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43561 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfKWLIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 06:08:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id y23so10239633ljh.10
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 03:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k55NQUdMEwIrYPzB9SzVO0yDWBY1eyw3xIISS0Xx5a0=;
        b=oGWJOcmvsQJRTxnMUu9BeNzPAy98Z4o9mq5qBfJceWwR7Bbhv72FjtVAjKyaNUnZNd
         9ZEJ8Hq5rpb0ULBtXruZbcsXvLpkqU7WAt2J8ieKrlPG8pMqTnxVVTlJPrPXz0Rj0PlA
         dbFMuN/ZYn1qZ5F3FmbWIe8a+kRMZiERUxuXs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k55NQUdMEwIrYPzB9SzVO0yDWBY1eyw3xIISS0Xx5a0=;
        b=cDkANtBJnyd8xOgEnHGBYeW4N9bb1sBCvxMOtTdybmfV8c70Ks3je8ZVPK3ihbLKtX
         AC9V0/SFtoDxQdx5FWghw28P8GVgogbqE7zVr+gQrBU9mKVolFFMntyH/qEV6INGnwjU
         8GXNQfd1zqkkdEUY1KOrFqOCgLEyPo+++OJ2zLGS/9YVb8QfurV9EX8+vj/KWmGF7649
         OpNBrsjvSPy7Jcen0I/URUq65x2lnyOWy4Jc8QRlWmcwvNPMShf/wEv/OW6nBiZhXDHA
         6DA1BM2IQy3BOYrcCNyCuqaRD7LSuZbcUFHvYFoKi0Q8dmTJ3/L88Xqm4ZiNtDJo3uWZ
         KzkA==
X-Gm-Message-State: APjAAAU+DIaQEkqGFd2Y3K0qpV3Cqj47KxUjeK+N/fasIg26756MFJWR
        AQsiflCjX9SwAVhhAdEoFfi6sg==
X-Google-Smtp-Source: APXvYqyZGEHGkJ325APRbCVeTsl7niNGre8LuzsptgQhn3qKUpkbWgi1Ux58AfHJXD7s4htnU49X0g==
X-Received: by 2002:a2e:8e27:: with SMTP id r7mr15898684ljk.101.1574507279333;
        Sat, 23 Nov 2019 03:07:59 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e7sm610085lja.5.2019.11.23.03.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 03:07:58 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit psock or its ops on copy
Date:   Sat, 23 Nov 2019 12:07:47 +0100
Message-Id: <20191123110751.6729-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191123110751.6729-1-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sockets cloned from the listening sockets that belongs to a SOCKMAP must
not inherit the psock state. Otherwise child sockets unintentionally share
the SOCKMAP entry with the listening socket, which would lead to
use-after-free bugs.

Restore the child socket psock state and its callbacks at the earliest
possible moment, that is right after the child socket gets created. This
ensures that neither children that get accept()'ed, nor those that are left
in accept queue and will get orphaned, don't inadvertently inherit parent's
psock.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/skmsg.h | 17 +++++++++--
 net/ipv4/tcp_bpf.c    | 66 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 6cb077b646a5..b5ade8dac69d 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -98,6 +98,7 @@ struct sk_psock {
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
 	struct proto			*sk_proto;
+	const struct inet_connection_sock_af_ops *icsk_af_ops;
 	struct sk_psock_work_state	work_state;
 	struct work_struct		work;
 	union {
@@ -345,23 +346,30 @@ static inline void sk_psock_cork_free(struct sk_psock *psock)
 
 static inline void sk_psock_update_proto(struct sock *sk,
 					 struct sk_psock *psock,
-					 struct proto *ops)
+					 struct proto *ops,
+					 struct inet_connection_sock_af_ops *af_ops)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
 	psock->saved_unhash = sk->sk_prot->unhash;
 	psock->saved_close = sk->sk_prot->close;
 	psock->saved_write_space = sk->sk_write_space;
 
 	psock->sk_proto = sk->sk_prot;
 	sk->sk_prot = ops;
+
+	psock->icsk_af_ops = icsk->icsk_af_ops;
+	icsk->icsk_af_ops = af_ops;
 }
 
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
 	sk->sk_write_space = psock->saved_write_space;
 
 	if (psock->sk_proto) {
-		struct inet_connection_sock *icsk = inet_csk(sk);
 		bool has_ulp = !!icsk->icsk_ulp_data;
 
 		if (has_ulp)
@@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 			sk->sk_prot = psock->sk_proto;
 		psock->sk_proto = NULL;
 	}
+
+	if (psock->icsk_af_ops) {
+		icsk->icsk_af_ops = psock->icsk_af_ops;
+		psock->icsk_af_ops = NULL;
+	}
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 8a56e09cfb0e..dc709949c8e5 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -10,6 +10,8 @@
 #include <net/inet_common.h>
 #include <net/tls.h>
 
+extern const struct inet_connection_sock_af_ops ipv4_specific;
+
 static bool tcp_bpf_stream_read(const struct sock *sk)
 {
 	struct sk_psock *psock;
@@ -535,6 +537,10 @@ static void tcp_bpf_remove(struct sock *sk, struct sk_psock *psock)
 {
 	struct sk_psock_link *link;
 
+	/* Did a child socket inadvertently inherit parent's psock? */
+	if (WARN_ON(sk != psock->sk))
+		return;
+
 	while ((link = sk_psock_link_pop(psock))) {
 		sk_psock_unlink(sk, link);
 		sk_psock_free_link(link);
@@ -582,6 +588,45 @@ static void tcp_bpf_close(struct sock *sk, long timeout)
 	saved_close(sk, timeout);
 }
 
+static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
+					  struct sk_buff *skb,
+					  struct request_sock *req,
+					  struct dst_entry *dst,
+					  struct request_sock *req_unhash,
+					  bool *own_req)
+{
+	const struct inet_connection_sock_af_ops *ops;
+	void (*write_space)(struct sock *sk);
+	struct sk_psock *psock;
+	struct proto *proto;
+	struct sock *child;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (likely(psock)) {
+		proto = psock->sk_proto;
+		write_space = psock->saved_write_space;
+		ops = psock->icsk_af_ops;
+	} else {
+		ops = inet_csk(sk)->icsk_af_ops;
+	}
+	rcu_read_unlock();
+
+	child = ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
+
+	/* Child must not inherit psock or its ops. */
+	if (child && psock) {
+		rcu_assign_sk_user_data(child, NULL);
+		child->sk_prot = proto;
+		child->sk_write_space = write_space;
+
+		/* v4-mapped sockets don't inherit parent ops. Don't restore. */
+		if (inet_csk(child)->icsk_af_ops == inet_csk(sk)->icsk_af_ops)
+			inet_csk(child)->icsk_af_ops = ops;
+	}
+	return child;
+}
+
 enum {
 	TCP_BPF_IPV4,
 	TCP_BPF_IPV6,
@@ -597,6 +642,7 @@ enum {
 static struct proto *tcpv6_prot_saved __read_mostly;
 static DEFINE_SPINLOCK(tcpv6_prot_lock);
 static struct proto tcp_bpf_prots[TCP_BPF_NUM_PROTS][TCP_BPF_NUM_CFGS];
+static struct inet_connection_sock_af_ops tcp_bpf_af_ops[TCP_BPF_NUM_PROTS];
 
 static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 				   struct proto *base)
@@ -612,13 +658,23 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 	prot[TCP_BPF_TX].sendpage		= tcp_bpf_sendpage;
 }
 
-static void tcp_bpf_check_v6_needs_rebuild(struct sock *sk, struct proto *ops)
+static void tcp_bpf_rebuild_af_ops(struct inet_connection_sock_af_ops *ops,
+				   const struct inet_connection_sock_af_ops *base)
+{
+	*ops = *base;
+	ops->syn_recv_sock = tcp_bpf_syn_recv_sock;
+}
+
+static void tcp_bpf_check_v6_needs_rebuild(struct sock *sk, struct proto *ops,
+					   const struct inet_connection_sock_af_ops *af_ops)
 {
 	if (sk->sk_family == AF_INET6 &&
 	    unlikely(ops != smp_load_acquire(&tcpv6_prot_saved))) {
 		spin_lock_bh(&tcpv6_prot_lock);
 		if (likely(ops != tcpv6_prot_saved)) {
 			tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV6], ops);
+			tcp_bpf_rebuild_af_ops(&tcp_bpf_af_ops[TCP_BPF_IPV6],
+					       af_ops);
 			smp_store_release(&tcpv6_prot_saved, ops);
 		}
 		spin_unlock_bh(&tcpv6_prot_lock);
@@ -628,6 +684,8 @@ static void tcp_bpf_check_v6_needs_rebuild(struct sock *sk, struct proto *ops)
 static int __init tcp_bpf_v4_build_proto(void)
 {
 	tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV4], &tcp_prot);
+	tcp_bpf_rebuild_af_ops(&tcp_bpf_af_ops[TCP_BPF_IPV4], &ipv4_specific);
+
 	return 0;
 }
 core_initcall(tcp_bpf_v4_build_proto);
@@ -637,7 +695,8 @@ static void tcp_bpf_update_sk_prot(struct sock *sk, struct sk_psock *psock)
 	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
 
-	sk_psock_update_proto(sk, psock, &tcp_bpf_prots[family][config]);
+	sk_psock_update_proto(sk, psock, &tcp_bpf_prots[family][config],
+			      &tcp_bpf_af_ops[family]);
 }
 
 static void tcp_bpf_reinit_sk_prot(struct sock *sk, struct sk_psock *psock)
@@ -677,6 +736,7 @@ void tcp_bpf_reinit(struct sock *sk)
 
 int tcp_bpf_init(struct sock *sk)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct proto *ops = READ_ONCE(sk->sk_prot);
 	struct sk_psock *psock;
 
@@ -689,7 +749,7 @@ int tcp_bpf_init(struct sock *sk)
 		rcu_read_unlock();
 		return -EINVAL;
 	}
-	tcp_bpf_check_v6_needs_rebuild(sk, ops);
+	tcp_bpf_check_v6_needs_rebuild(sk, ops, icsk->icsk_af_ops);
 	tcp_bpf_update_sk_prot(sk, psock);
 	rcu_read_unlock();
 	return 0;
-- 
2.20.1

