Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA16505CD4
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346486AbiDRQyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346481AbiDRQws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:52:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7C82B26B;
        Mon, 18 Apr 2022 09:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A76C7B8100E;
        Mon, 18 Apr 2022 16:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A2DC385A1;
        Mon, 18 Apr 2022 16:49:58 +0000 (UTC)
Subject: [PATCH RFC 5/5] net/tls: Add observability for AF_TLSH sockets
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:49:57 -0400
Message-ID: <165030059773.5073.6168640435213548957.stgit@oracle-102.nfsv4.dev>
In-Reply-To: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/tls/af_tlsh.c |   50 +++++++
 net/tls/trace.c   |    3 
 net/tls/trace.h   |  355 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 402 insertions(+), 6 deletions(-)

diff --git a/net/tls/af_tlsh.c b/net/tls/af_tlsh.c
index 4d1c1de3a474..31eae3e0d54c 100644
--- a/net/tls/af_tlsh.c
+++ b/net/tls/af_tlsh.c
@@ -239,8 +239,10 @@ static bool tlsh_handshake_done(struct sock *sk)
 		tlsh_sock_restore_locked(sk);
 
 		if (tlsh_crypto_info_initialized(sk)) {
+			trace_tlsh_handshake_ok(sk);
 			done(data, 0);
 		} else {
+			trace_tlsh_handshake_failed(sk);
 			done(data, -EACCES);
 		}
 	}
@@ -282,6 +284,8 @@ static int tlsh_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	trace_tlsh_release(sock);
+
 	switch (sk->sk_family) {
 	case AF_INET:
 		if (!tlsh_handshake_done(sk))
@@ -364,6 +368,7 @@ static int tlsh_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 	}
 
 	tsk->th_bind_family = uaddr->sa_family;
+	trace_tlsh_bind(sock);
 	return 0;
 }
 
@@ -386,6 +391,8 @@ static int tlsh_accept(struct socket *listener, struct socket *newsock, int flag
 	long timeo;
 	int rc;
 
+	trace_tlsh_accept(listener);
+
 	rc = -EPERM;
 	if (!capable(CAP_NET_BIND_SERVICE))
 		goto out;
@@ -429,6 +436,7 @@ static int tlsh_accept(struct socket *listener, struct socket *newsock, int flag
 	}
 
 	sock_graft(newsk, newsock);
+	trace_tlsh_newsock(newsock, newsk);
 
 out_release:
 	release_sock(sk);
@@ -450,6 +458,8 @@ static int tlsh_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 {
 	struct sock *sk = sock->sk;
 
+	trace_tlsh_getname(sock);
+
 	switch (sk->sk_family) {
 	case AF_INET:
 		return inet_getname(sock, uaddr, peer);
@@ -486,6 +496,7 @@ static __poll_t tlsh_poll(struct file *file, struct socket *sock,
 			mask |= EPOLLIN | EPOLLRDNORM;
 		if (sk_is_readable(sk))
 			mask |= EPOLLIN | EPOLLRDNORM;
+		trace_tlsh_poll_listener(sock, mask);
 		return mask;
 	}
 
@@ -504,6 +515,7 @@ static __poll_t tlsh_poll(struct file *file, struct socket *sock,
 	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR;
 
+	trace_tlsh_poll(sock, mask);
 	return mask;
 }
 
@@ -539,6 +551,7 @@ static int tlsh_listen(struct socket *sock, int backlog)
 	sk->sk_state = TCP_LISTEN;
 	tlsh_register_listener(sk);
 
+	trace_tlsh_listen(sock);
 	rc = 0;
 
 out:
@@ -559,6 +572,8 @@ static int tlsh_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
 
+	trace_tlsh_shutdown(sock);
+
 	switch (sk->sk_family) {
 	case AF_INET:
 		break;
@@ -590,6 +605,8 @@ static int tlsh_setsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 
+	trace_tlsh_setsockopt(sock);
+
 	switch (sk->sk_family) {
 	case AF_INET:
 		break;
@@ -756,6 +773,8 @@ static int tlsh_getsockopt(struct socket *sock, int level, int optname,
 	struct sock *sk = sock->sk;
 	int ret;
 
+	trace_tlsh_getsockopt(sock);
+
 	switch (sk->sk_family) {
 	case AF_INET:
 		break;
@@ -803,6 +822,9 @@ static int tlsh_getsockopt(struct socket *sock, int level, int optname,
 static int tlsh_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
+	int ret;
+
+	trace_tlsh_sendmsg_start(sock, size);
 
 	switch (sk->sk_family) {
 	case AF_INET:
@@ -812,12 +834,19 @@ static int tlsh_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		break;
 #endif
 	default:
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (unlikely(inet_send_prepare(sk))) {
+		ret = -EAGAIN;
+		goto out;
 	}
+	ret = sk->sk_prot->sendmsg(sk, msg, size);
 
-	if (unlikely(inet_send_prepare(sk)))
-		return -EAGAIN;
-	return sk->sk_prot->sendmsg(sk, msg, size);
+out:
+	trace_tlsh_sendmsg_result(sock, ret);
+	return ret;
 }
 
 /**
@@ -835,6 +864,9 @@ static int tlsh_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags)
 {
 	struct sock *sk = sock->sk;
+	int ret;
+
+	trace_tlsh_recvmsg_start(sock, size);
 
 	switch (sk->sk_family) {
 	case AF_INET:
@@ -844,12 +876,17 @@ static int tlsh_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		break;
 #endif
 	default:
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	if (likely(!(flags & MSG_ERRQUEUE)))
 		sock_rps_record_flow(sk);
-	return sock_common_recvmsg(sock, msg, size, flags);
+	ret = sock_common_recvmsg(sock, msg, size, flags);
+
+out:
+	trace_tlsh_recvmsg_result(sock, ret);
+	return ret;
 }
 
 static const struct proto_ops tlsh_proto_ops = {
@@ -920,6 +957,7 @@ int tlsh_pf_create(struct net *net, struct socket *sock, int protocol, int kern)
 	}
 
 	tlsh_sk(sk)->th_bind_family = AF_UNSPEC;
+	trace_tlsh_pf_create(sock);
 	return 0;
 
 err_sk_put:
diff --git a/net/tls/trace.c b/net/tls/trace.c
index e374913cf9c9..3747ca2ede67 100644
--- a/net/tls/trace.c
+++ b/net/tls/trace.c
@@ -2,6 +2,9 @@
 /* Copyright (C) 2019 Netronome Systems, Inc. */
 
 #include <linux/module.h>
+#include <linux/net.h>
+#include <net/sock.h>
+#include <net/tls.h>
 
 #ifndef __CHECKER__
 #define CREATE_TRACE_POINTS
diff --git a/net/tls/trace.h b/net/tls/trace.h
index 9ba5f600ea43..9302d992edad 100644
--- a/net/tls/trace.h
+++ b/net/tls/trace.h
@@ -12,6 +12,56 @@
 
 struct sock;
 
+#define show_af_family(family)					\
+	__print_symbolic(family,				\
+		{ AF_INET,		"AF_INET" },		\
+		{ AF_INET6,		"AF_INET6" },		\
+		{ AF_TLSH,		"AF_TLSH" })
+
+TRACE_DEFINE_ENUM(TCP_ESTABLISHED);
+TRACE_DEFINE_ENUM(TCP_SYN_SENT);
+TRACE_DEFINE_ENUM(TCP_SYN_RECV);
+TRACE_DEFINE_ENUM(TCP_FIN_WAIT1);
+TRACE_DEFINE_ENUM(TCP_FIN_WAIT2);
+TRACE_DEFINE_ENUM(TCP_TIME_WAIT);
+TRACE_DEFINE_ENUM(TCP_CLOSE);
+TRACE_DEFINE_ENUM(TCP_CLOSE_WAIT);
+TRACE_DEFINE_ENUM(TCP_LAST_ACK);
+TRACE_DEFINE_ENUM(TCP_LISTEN);
+TRACE_DEFINE_ENUM(TCP_CLOSING);
+TRACE_DEFINE_ENUM(TCP_NEW_SYN_RECV);
+
+#define show_tcp_state(state)					\
+	__print_symbolic(state,					\
+		{ TCP_ESTABLISHED,	"ESTABLISHED" },	\
+		{ TCP_SYN_SENT,		"SYN_SENT" },		\
+		{ TCP_SYN_RECV,		"SYN_RECV" },		\
+		{ TCP_FIN_WAIT1,	"FIN_WAIT1" },		\
+		{ TCP_FIN_WAIT2,	"FIN_WAIT2" },		\
+		{ TCP_TIME_WAIT,	"TIME_WAIT" },		\
+		{ TCP_CLOSE,		"CLOSE" },		\
+		{ TCP_CLOSE_WAIT,	"CLOSE_WAIT" },		\
+		{ TCP_LAST_ACK,		"LAST_ACK" },		\
+		{ TCP_LISTEN,		"LISTEN" },		\
+		{ TCP_CLOSING,		"CLOSING" },		\
+		{ TCP_NEW_SYN_RECV,	"NEW_SYN_RECV" })
+
+#define show_poll_event_mask(mask)				\
+	__print_flags(mask, "|",				\
+		{ EPOLLIN,		"IN" },			\
+		{ EPOLLPRI,		"PRI" },		\
+		{ EPOLLOUT,		"OUT" },		\
+		{ EPOLLERR,		"ERR" },		\
+		{ EPOLLHUP,		"HUP" },		\
+		{ EPOLLNVAL,		"NVAL" },		\
+		{ EPOLLRDNORM,		"RDNORM" },		\
+		{ EPOLLRDBAND,		"RDBAND" },		\
+		{ EPOLLWRNORM,		"WRNORM" },		\
+		{ EPOLLWRBAND,		"WRBAND" },		\
+		{ EPOLLMSG,		"MSG" },		\
+		{ EPOLLRDHUP,		"RDHUP" })
+
+
 TRACE_EVENT(tls_device_offload_set,
 
 	TP_PROTO(struct sock *sk, int dir, u32 tcp_seq, u8 *rec_no, int ret),
@@ -192,6 +242,311 @@ TRACE_EVENT(tls_device_tx_resync_send,
 	)
 );
 
+DECLARE_EVENT_CLASS(tlsh_listener_class,
+	TP_PROTO(
+		const struct socket *sock
+	),
+	TP_ARGS(sock),
+	TP_STRUCT__entry(
+		__field(const struct socket *, sock)
+		__field(const struct sock *, sk)
+		__field(int, refcount)
+		__field(unsigned long, family)
+	),
+	TP_fast_assign(
+		const struct sock *sk = sock->sk;
+
+		__entry->sock = sock;
+		__entry->sk = sk;
+		__entry->refcount = refcount_read(&sk->sk_refcnt);
+		__entry->family = tlsh_sk((struct sock *)sk)->th_bind_family;
+	),
+
+	TP_printk("listener=%p sk=%p(%d) family=%s",
+		__entry->sock, __entry->sk,
+		__entry->refcount, show_af_family(__entry->family)
+	)
+);
+
+#define DEFINE_TLSH_LISTENER_EVENT(name)			\
+	DEFINE_EVENT(tlsh_listener_class, name,			\
+		TP_PROTO(					\
+			const struct socket *sock		\
+		),						\
+		TP_ARGS(sock))
+
+DEFINE_TLSH_LISTENER_EVENT(tlsh_bind);
+DEFINE_TLSH_LISTENER_EVENT(tlsh_accept);
+DEFINE_TLSH_LISTENER_EVENT(tlsh_listen);
+DEFINE_TLSH_LISTENER_EVENT(tlsh_pf_create);
+
+TRACE_EVENT(tlsh_newsock,
+	TP_PROTO(
+		const struct socket *newsock,
+		const struct sock *newsk
+	),
+	TP_ARGS(newsock, newsk),
+	TP_STRUCT__entry(
+		__field(const struct socket *, newsock)
+		__field(const struct sock *, newsk)
+		__field(int, refcount)
+		__field(unsigned long, family)
+	),
+	TP_fast_assign(
+		__entry->newsock = newsock;
+		__entry->newsk = newsk;
+		__entry->refcount = refcount_read(&newsk->sk_refcnt);
+		__entry->family = newsk->sk_family;
+	),
+
+	TP_printk("newsock=%p newsk=%p(%d) family=%s",
+		__entry->newsock, __entry->newsk,
+		__entry->refcount, show_af_family(__entry->family)
+	)
+);
+
+DECLARE_EVENT_CLASS(tlsh_proto_op_class,
+	TP_PROTO(
+		const struct socket *sock
+	),
+	TP_ARGS(sock),
+	TP_STRUCT__entry(
+		__field(const struct socket *, sock)
+		__field(const struct sock *, sk)
+		__field(int, refcount)
+		__field(unsigned long, family)
+		__field(unsigned long, state)
+	),
+	TP_fast_assign(
+		const struct sock *sk = sock->sk;
+
+		__entry->sock = sock;
+		__entry->sk = sk;
+		__entry->refcount = refcount_read(&sk->sk_refcnt);
+		__entry->family = sk->sk_family;
+		__entry->state = sk->sk_state;
+	),
+
+	TP_printk("sock=%p sk=%p(%d) family=%s state=%s",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_af_family(__entry->family),
+		show_tcp_state(__entry->state)
+	)
+);
+
+#define DEFINE_TLSH_PROTO_OP_EVENT(name)			\
+	DEFINE_EVENT(tlsh_proto_op_class, name,			\
+		TP_PROTO(					\
+			const struct socket *sock		\
+		),						\
+		TP_ARGS(sock))
+
+DEFINE_TLSH_PROTO_OP_EVENT(tlsh_release);
+DEFINE_TLSH_PROTO_OP_EVENT(tlsh_getname);
+DEFINE_TLSH_PROTO_OP_EVENT(tlsh_shutdown);
+DEFINE_TLSH_PROTO_OP_EVENT(tlsh_setsockopt);
+DEFINE_TLSH_PROTO_OP_EVENT(tlsh_getsockopt);
+
+TRACE_EVENT(tlsh_sendmsg_start,
+	TP_PROTO(
+		const struct socket *sock,
+		size_t size
+	),
+	TP_ARGS(sock, size),
+	TP_STRUCT__entry(
+		__field(const struct socket *, sock)
+		__field(const struct sock *, sk)
+		__field(int, refcount)
+		__field(unsigned long, family)
+		__field(unsigned long, state)
+		__field(const void *, op)
+		__field(size_t, size)
+	),
+	TP_fast_assign(
+		const struct sock *sk = sock->sk;
+
+		__entry->sock = sock;
+		__entry->sk = sk;
+		__entry->refcount = refcount_read(&sk->sk_refcnt);
+		__entry->family = sk->sk_family;
+		__entry->state = sk->sk_state;
+		__entry->op = sk->sk_prot->sendmsg;
+		__entry->size = size;
+	),
+
+	TP_printk("sock=%p sk=%p(%d) family=%s state=%s size=%zu op=%pS",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_af_family(__entry->family),
+		show_tcp_state(__entry->state),
+		__entry->size, __entry->op
+	)
+);
+
+TRACE_EVENT(tlsh_recvmsg_start,
+	TP_PROTO(
+		const struct socket *sock,
+		size_t size
+	),
+	TP_ARGS(sock, size),
+	TP_STRUCT__entry(
+		__field(const struct socket *, sock)
+		__field(const struct sock *, sk)
+		__field(int, refcount)
+		__field(unsigned long, family)
+		__field(unsigned long, state)
+		__field(const void *, op)
+		__field(size_t, size)
+	),
+	TP_fast_assign(
+		const struct sock *sk = sock->sk;
+
+		__entry->sock = sock;
+		__entry->sk = sk;
+		__entry->refcount = refcount_read(&sk->sk_refcnt);
+		__entry->family = sk->sk_family;
+		__entry->state = sk->sk_state;
+		__entry->op = sk->sk_prot->recvmsg;
+		__entry->size = size;
+	),
+
+	TP_printk("sock=%p sk=%p(%d) family=%s state=%s size=%zu op=%pS",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_af_family(__entry->family),
+		show_tcp_state(__entry->state),
+		__entry->size, __entry->op
+	)
+);
+
+DECLARE_EVENT_CLASS(tlsh_opmsg_result_class,
+	TP_PROTO(
+		const struct socket *sock,
+		int result
+	),
+	TP_ARGS(sock, result),
+	TP_STRUCT__entry(
+		__field(const struct socket *, sock)
+		__field(const struct sock *, sk)
+		__field(int, refcount)
+		__field(unsigned long, family)
+		__field(unsigned long, state)
+		__field(int, result)
+	),
+	TP_fast_assign(
+		const struct sock *sk = sock->sk;
+
+		__entry->sock = sock;
+		__entry->sk = sk;
+		__entry->refcount = refcount_read(&sk->sk_refcnt);
+		__entry->family = sk->sk_family;
+		__entry->state = sk->sk_state;
+		__entry->result = result;
+	),
+
+	TP_printk("sock=%p sk=%p(%d) family=%s state=%s result=%d",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_af_family(__entry->family),
+		show_tcp_state(__entry->state),
+		__entry->result
+	)
+);
+
+#define DEFINE_TLSH_OPMSG_RESULT_EVENT(name)			\
+	DEFINE_EVENT(tlsh_opmsg_result_class, name,		\
+		TP_PROTO(					\
+			const struct socket *sock,		\
+			int result				\
+		),						\
+		TP_ARGS(sock, result))
+
+DEFINE_TLSH_OPMSG_RESULT_EVENT(tlsh_sendmsg_result);
+DEFINE_TLSH_OPMSG_RESULT_EVENT(tlsh_recvmsg_result);
+
+TRACE_EVENT(tlsh_poll,
+	TP_PROTO(
+		const struct socket *sock,
+		__poll_t mask
+	),
+	TP_ARGS(sock, mask),
+	TP_STRUCT__entry(
+		__field(const struct socket *, sock)
+		__field(const struct sock *, sk)
+		__field(int, refcount)
+		__field(unsigned long, mask)
+	),
+	TP_fast_assign(
+		const struct sock *sk = sock->sk;
+
+		__entry->sock = sock;
+		__entry->sk = sk;
+		__entry->refcount = refcount_read(&sk->sk_refcnt);
+		__entry->mask = mask;
+	),
+
+	TP_printk("sock=%p sk=%p(%d) mask=%s",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_poll_event_mask(__entry->mask)
+	)
+);
+
+TRACE_EVENT(tlsh_poll_listener,
+	TP_PROTO(
+		const struct socket *sock,
+		__poll_t mask
+	),
+	TP_ARGS(sock, mask),
+	TP_STRUCT__entry(
+		__field(const struct socket *, sock)
+		__field(const struct sock *, sk)
+		__field(int, refcount)
+		__field(unsigned long, mask)
+	),
+	TP_fast_assign(
+		const struct sock *sk = sock->sk;
+
+		__entry->sock = sock;
+		__entry->sk = sk;
+		__entry->refcount = refcount_read(&sk->sk_refcnt);
+		__entry->mask = mask;
+	),
+
+	TP_printk("sock=%p sk=%p(%d) mask=%s",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_poll_event_mask(__entry->mask)
+	)
+);
+
+DECLARE_EVENT_CLASS(tlsh_handshake_done_class,
+	TP_PROTO(
+		const struct sock *sk
+	),
+	TP_ARGS(sk),
+	TP_STRUCT__entry(
+		__field(const struct sock *, sk)
+		__field(int, refcount)
+		__field(unsigned long, family)
+	),
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->refcount = refcount_read(&sk->sk_refcnt);
+		__entry->family = sk->sk_family;
+	),
+
+	TP_printk("sk=%p(%d) family=%s",
+		__entry->sk, __entry->refcount,
+		show_af_family(__entry->family)
+	)
+);
+
+#define DEFINE_TLSH_HANDSHAKE_DONE_EVENT(name)			\
+	DEFINE_EVENT(tlsh_handshake_done_class, name,		\
+		TP_PROTO(					\
+			const struct sock *sk			\
+		),						\
+		TP_ARGS(sk))
+
+DEFINE_TLSH_HANDSHAKE_DONE_EVENT(tlsh_handshake_ok);
+DEFINE_TLSH_HANDSHAKE_DONE_EVENT(tlsh_handshake_failed);
+
 #endif /* _TLS_TRACE_H_ */
 
 #undef TRACE_INCLUDE_PATH


