Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F5167D0D3
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjAZQCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjAZQC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:02:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E85A65348
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:02:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5453618BF
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9850C433D2;
        Thu, 26 Jan 2023 16:02:23 +0000 (UTC)
Subject: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com, bcodding@redhat.com,
        jlayton@redhat.com
Date:   Thu, 26 Jan 2023 11:02:22 -0500
Message-ID: <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In-kernel TLS consumers need a way to perform a TLS handshake. In
the absence of a TLS handshake implementation in the kernel itself,
a mechanism to perform the handshake in user space, using an
existing TLS handshake library, is necessary.

I've designed a way to pass a connected kernel socket endpoint to
user space using the traditional listen/accept mechanism. accept(2)
gives us a well-worn building block that can materialize a connected
socket endpoint as a file descriptor in a specific user space
process. Like any open socket descriptor, the accepted FD can then
be passed to a library such as GnuTLS to perform a TLS handshake.

The socket sharing mechanism is built into the kernel for now since
it is a small utility to be used by several transport layer security
mechanisms.

This prototype is net-namespace aware.

NB: The kernel has no mechanism to attest that the listening user
space agent is trustworthy.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/net/handshake.h          |   31 +
 include/net/sock.h               |    2 
 include/trace/events/handshake.h |  328 +++++++++++++++
 include/uapi/linux/handshake.h   |   49 ++
 net/Makefile                     |    1 
 net/handshake/Makefile           |    7 
 net/handshake/af_handshake.c     |  838 ++++++++++++++++++++++++++++++++++++++
 net/handshake/handshake.h        |   33 +
 net/handshake/netlink.c          |  169 ++++++++
 net/handshake/trace.c            |   20 +
 10 files changed, 1478 insertions(+)
 create mode 100644 include/net/handshake.h
 create mode 100644 include/trace/events/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/af_handshake.c
 create mode 100644 net/handshake/handshake.h
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/handshake/trace.c

diff --git a/include/net/handshake.h b/include/net/handshake.h
new file mode 100644
index 000000000000..b3fa1d006dcc
--- /dev/null
+++ b/include/net/handshake.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * PF_HANDSHAKE protocol family socket handler.
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2023, Oracle and/or its affiliates.
+ */
+
+/*
+ * Data structures and functions that are visible only within the
+ * kernel are declared here.
+ */
+
+#ifndef _NET_HANDSHAKE_H
+#define _NET_HANDSHAKE_H
+
+struct handshake_info {
+	void			(*hi_done)(struct handshake_info *hsi);
+	int			(*hi_fd_parms_reply)(struct sk_buff *msg,
+						     struct handshake_info *hsi);
+	void			*hi_data;
+	struct socket_wq	*hi_saved_wq;
+	struct socket		*hi_saved_socket;
+	kuid_t			hi_saved_uid;
+};
+
+extern int handshake_enqueue_sock(struct socket *sock,
+				  struct handshake_info *hsi);
+
+#endif /* _NET_HANDSHAKE_H */
diff --git a/include/net/sock.h b/include/net/sock.h
index e0517ecc6531..5ed2d809a149 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -349,6 +349,7 @@ struct sk_filter;
   *	@sk_txtime_unused: unused txtime flags
   *	@ns_tracker: tracker for netns reference
   *	@sk_bind2_node: bind node in the bhash2 table
+  *	@sk_handshake_data: private data for xprt layer security handshake
   */
 struct sock {
 	/*
@@ -515,6 +516,7 @@ struct sock {
 
 	struct socket		*sk_socket;
 	void			*sk_user_data;
+	void			*sk_handshake_data;
 #ifdef CONFIG_SECURITY
 	void			*sk_security;
 #endif
diff --git a/include/trace/events/handshake.h b/include/trace/events/handshake.h
new file mode 100644
index 000000000000..ae3fd3a1ebe9
--- /dev/null
+++ b/include/trace/events/handshake.h
@@ -0,0 +1,328 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2022, 2023 Oracle.  All rights reserved.
+ *
+ * Trace point definitions for the "handshake" trace subsystem.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM handshake
+
+#if !defined(_TRACE_HANDSHAKE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_HANDSHAKE_H
+
+#include <asm/unaligned.h>
+#include <linux/types.h>
+#include <net/tcp_states.h>
+
+#include <linux/tracepoint.h>
+
+#define show_address_family(family)				\
+	__print_symbolic(family,				\
+		{ AF_INET,		"AF_INET" },		\
+		{ AF_INET6,		"AF_INET6" },		\
+		{ AF_HANDSHAKE,		"AF_HANDSHAKE" })
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
+DECLARE_EVENT_CLASS(handshake_listener_class,
+	TP_PROTO(const struct socket *sock),
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
+		__entry->family = handshake_sk((struct sock *)sk)->hs_bind_family;
+	),
+	TP_printk("listener=%p sk=%p(%d) family=%s",
+		__entry->sock, __entry->sk,
+		__entry->refcount, show_address_family(__entry->family)
+	)
+);
+
+#define DEFINE_HANDSHAKE_LISTENER_EVENT(name)			\
+	DEFINE_EVENT(handshake_listener_class, name,		\
+		TP_PROTO(const struct socket *sock),		\
+		TP_ARGS(sock))
+
+DEFINE_HANDSHAKE_LISTENER_EVENT(handshake_bind);
+DEFINE_HANDSHAKE_LISTENER_EVENT(handshake_accept);
+DEFINE_HANDSHAKE_LISTENER_EVENT(handshake_listen);
+DEFINE_HANDSHAKE_LISTENER_EVENT(handshake_pf_create);
+
+TRACE_EVENT(handshake_newsock,
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
+	TP_printk("newsock=%p newsk=%p(%d) family=%s",
+		__entry->newsock, __entry->newsk,
+		__entry->refcount, show_address_family(__entry->family)
+	)
+);
+
+DECLARE_EVENT_CLASS(handshake_proto_op_class,
+	TP_PROTO(const struct socket *sock),
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
+	TP_printk("sock=%p sk=%p(%d) family=%s state=%s",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_address_family(__entry->family),
+		show_tcp_state(__entry->state)
+	)
+);
+
+#define DEFINE_HANDSHAKE_PROTO_OP_EVENT(name)			\
+	DEFINE_EVENT(handshake_proto_op_class, name,		\
+		TP_PROTO(const struct socket *sock),		\
+		TP_ARGS(sock))
+
+DEFINE_HANDSHAKE_PROTO_OP_EVENT(handshake_release);
+DEFINE_HANDSHAKE_PROTO_OP_EVENT(handshake_getname);
+DEFINE_HANDSHAKE_PROTO_OP_EVENT(handshake_shutdown);
+DEFINE_HANDSHAKE_PROTO_OP_EVENT(handshake_setsockopt);
+DEFINE_HANDSHAKE_PROTO_OP_EVENT(handshake_getsockopt);
+
+TRACE_EVENT(handshake_sendmsg_start,
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
+	TP_printk("sock=%p sk=%p(%d) family=%s state=%s size=%zu op=%pS",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_address_family(__entry->family),
+		show_tcp_state(__entry->state),
+		__entry->size, __entry->op
+	)
+);
+
+TRACE_EVENT(handshake_recvmsg_start,
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
+	TP_printk("sock=%p sk=%p(%d) family=%s state=%s size=%zu op=%pS",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_address_family(__entry->family),
+		show_tcp_state(__entry->state),
+		__entry->size, __entry->op
+	)
+);
+
+DECLARE_EVENT_CLASS(handshake_opmsg_result_class,
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
+	TP_printk("sock=%p sk=%p(%d) family=%s state=%s result=%d",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_address_family(__entry->family),
+		show_tcp_state(__entry->state),
+		__entry->result
+	)
+);
+
+#define DEFINE_HANDSHAKE_OPMSG_RESULT_EVENT(name)		\
+	DEFINE_EVENT(handshake_opmsg_result_class, name,		\
+		TP_PROTO(					\
+			const struct socket *sock,		\
+			int result				\
+		),						\
+		TP_ARGS(sock, result))
+
+DEFINE_HANDSHAKE_OPMSG_RESULT_EVENT(handshake_sendmsg_result);
+DEFINE_HANDSHAKE_OPMSG_RESULT_EVENT(handshake_recvmsg_result);
+
+TRACE_EVENT(handshake_poll,
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
+		__entry->mask = (__force unsigned long)mask;
+	),
+	TP_printk("sock=%p sk=%p(%d) mask=%s",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_poll_event_mask(__entry->mask)
+	)
+);
+
+TRACE_EVENT(handshake_poll_listener,
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
+		__entry->mask = (__force unsigned long)mask;
+	),
+	TP_printk("sock=%p sk=%p(%d) mask=%s",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_poll_event_mask(__entry->mask)
+	)
+);
+
+#endif /* _TRACE_HANDSHAKE_H */
+
+#include <trace/define_trace.h>
diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
new file mode 100644
index 000000000000..72facc352c71
--- /dev/null
+++ b/include/uapi/linux/handshake.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Generic netlink service for handshakes
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2023, Oracle and/or its affiliates.
+ */
+
+/*
+ * Data structures and functions that are visible to user space are
+ * declared here. This file constitutes an API contract between the
+ * Linux kernel and user space.
+ */
+
+#ifndef _UAPI_LINUX_HANDSHAKE_H
+#define _UAPI_LINUX_HANDSHAKE_H
+
+enum handshake_protocol {
+	HANDSHAKE_PROTO_UNSPEC = 0,
+};
+
+#define HANDSHAKE_GENL_NAME	"HANDSHAKE_GENL"
+#define HANDSHAKE_GENL_VERSION	0x01
+
+enum handshake_genl_attrs {
+	HANDSHAKE_GENL_ATTR_UNSPEC = 0,
+	HANDSHAKE_GENL_ATTR_SOCKFD,
+	HANDSHAKE_GENL_ATTR_STATUS,
+	HANDSHAKE_GENL_ATTR_PROTOCOL,
+	__HANDSHAKE_GENL_ATTR_MAX
+};
+#define HANDSHAKE_GENL_ATTR_MAX	(__HANDSHAKE_GENL_ATTR_MAX - 1)
+
+enum handshake_genl_cmds {
+	HANDSHAKE_GENL_CMD_UNSPEC = 0,
+	HANDSHAKE_GENL_CMD_GET_FD_PARAMETERS,
+	__HANDSHAKE_GENL_CMD_MAX
+};
+#define HANDSHAKE_GENL_CMD_MAX	(__HANDSHAKE_GENL_CMD_MAX - 1)
+
+enum handshake_genl_status {
+	HANDSHAKE_GENL_STATUS_OK = 0,
+	HANDSHAKE_GENL_STATUS_INVAL,
+	HANDSHAKE_GENL_STATUS_SOCKNOTFOUND,
+	HANDSHAKE_GENL_STATUS_SOCKNOTVALID,
+};
+
+#endif /* _UAPI_LINUX_HANDSHAKE_H */
diff --git a/net/Makefile b/net/Makefile
index 6a62e5b27378..c1bb53f00486 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
 obj-$(CONFIG_MPTCP)		+= mptcp/
 obj-$(CONFIG_MCTP)		+= mctp/
+obj-y				+= handshake/
diff --git a/net/handshake/Makefile b/net/handshake/Makefile
new file mode 100644
index 000000000000..847e0ab2b99e
--- /dev/null
+++ b/net/handshake/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the HANDSHAKE subsystem.
+#
+
+obj-y += handshake.o
+handshake-y := af_handshake.o netlink.o trace.o
diff --git a/net/handshake/af_handshake.c b/net/handshake/af_handshake.c
new file mode 100644
index 000000000000..3ba3daeb82d3
--- /dev/null
+++ b/net/handshake/af_handshake.c
@@ -0,0 +1,838 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * PF_HANDSHAKE protocol family socket handler.
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2021-2023 Oracle and/or its affiliates.
+ *
+ * When the kernel needs to invoke a user space service on an open
+ * socket descriptor, it can use this mechanism to make the socket
+ * endpoint available to a user space program.
+ *
+ * The user space program listens on an AF_HANDSHAKE socket. When
+ * the listener is made ready, an accept(2) call materializes
+ * the desired socket endpoint in the listening process's file
+ * descriptor table.
+ *
+ * The listener closes that endpoint when it is finished with it
+ * (or when it exits). The kernel knows that at that point it is
+ * safe to use the socket again.
+ */
+
+/*
+ * Socket reference counting
+ *  A: listener socket initial reference
+ *  B: listener socket on the global listener list
+ *  C: listener socket while a ready AF_INET(6) socket is enqueued
+ *  D: listener socket while its accept queue is drained
+ *
+ *  I: ready AF_INET(6) socket waiting on a listener's accept queue
+ *  J: ready AF_INET(6) socket with a consumer waiting for a completion callback
+ */
+
+#include <linux/types.h>
+#include <linux/socket.h>
+#include <linux/in.h>
+#include <linux/kernel.h>
+#include <linux/poll.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/inet.h>
+
+#include <net/ip.h>
+#include <net/ipv6.h>
+#include <net/tcp.h>
+#include <net/protocol.h>
+#include <net/sock.h>
+#include <net/genetlink.h>
+#include <net/inet_common.h>
+#include <net/net_namespace.h>
+#include <net/handshake.h>
+
+#include "handshake.h"
+
+#include <trace/events/handshake.h>
+
+static DEFINE_RWLOCK(handshake_listener_lock);
+static HLIST_HEAD(handshake_listeners);
+
+static void handshake_register_listener(struct sock *sk)
+{
+	write_lock_bh(&handshake_listener_lock);
+	sk_add_node(sk, &handshake_listeners);	/* Ref: B */
+	write_unlock_bh(&handshake_listener_lock);
+}
+
+static void handshake_unregister_listener(struct sock *sk)
+{
+	write_lock_bh(&handshake_listener_lock);
+	sk_del_node_init(sk);			/* Ref: B */
+	write_unlock_bh(&handshake_listener_lock);
+}
+
+/**
+ * handshake_find_listener - find listener that matches an incoming connection
+ * @net: net namespace to match
+ * @family: address family to match
+ *
+ * Return values:
+ *   On success, address of a listening AF_HANDSHAKE socket
+ *   %NULL: No matching listener found
+ */
+static struct sock *handshake_find_listener(struct net *net, unsigned short family)
+{
+	struct sock *listener;
+
+	read_lock(&handshake_listener_lock);
+
+	sk_for_each(listener, &handshake_listeners) {
+		if (sock_net(listener) != net)
+			continue;
+		if (handshake_sk(listener)->hs_bind_family != AF_UNSPEC &&
+		    handshake_sk(listener)->hs_bind_family != family)
+			continue;
+
+		sock_hold(listener);	/* Ref: C */
+		goto out;
+	}
+	listener = NULL;
+
+out:
+	read_unlock(&handshake_listener_lock);
+	return listener;
+}
+
+/**
+ * handshake_accept_enqueue - add a socket to a listener's accept_q
+ * @listener: listening socket
+ * @sk: socket to enqueue on @listener
+ *
+ * Return values:
+ *   On success, returns 0
+ *   %-ENOMEM: Memory for skbs has been exhausted
+ */
+static int handshake_accept_enqueue(struct sock *listener, struct sock *sk)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(0, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	sock_hold(sk);	/* Ref: I */
+	skb->sk = sk;
+	skb_queue_tail(&listener->sk_receive_queue, skb);
+	sk_acceptq_added(listener);
+	listener->sk_data_ready(listener);
+	return 0;
+}
+
+/**
+ * handshake_accept_dequeue - remove a socket from a listener's accept_q
+ * @listener: listener socket to check
+ *
+ * Caller must guarantee that @listener won't disappear.
+ *
+ * Return values:
+ *   On success, return a TCP socket waiting for TLS service
+ *   %NULL: No sockets on the accept queue
+ */
+static struct sock *handshake_accept_dequeue(struct sock *listener)
+{
+	struct sk_buff *skb;
+	struct sock *sk;
+
+	skb = skb_dequeue(&listener->sk_receive_queue);
+	if (!skb)
+		return NULL;
+	sk_acceptq_removed(listener);
+	sock_put(listener);	/* Ref: C */
+
+	sk = skb->sk;
+	skb->sk = NULL;
+	kfree_skb(skb);
+	sock_put(sk);	/* Ref: I */
+	return sk;
+}
+
+static void handshake_sock_save(struct sock *sk, struct handshake_info *hsi)
+{
+	sock_hold(sk);	/* Ref: J */
+
+	write_lock_bh(&sk->sk_callback_lock);
+	hsi->hi_saved_wq = sk->sk_wq_raw;
+	hsi->hi_saved_socket = sk->sk_socket;
+	hsi->hi_saved_uid = sk->sk_uid;
+	sk->sk_handshake_data = hsi;
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
+static void handshake_sock_clear(struct sock *sk)
+{
+	write_lock_bh(&sk->sk_callback_lock);
+	sk->sk_handshake_data = NULL;
+	write_unlock_bh(&sk->sk_callback_lock);
+	sock_put(sk);	/* Ref: J (err) */
+}
+
+static void handshake_sock_restore_locked(struct sock *sk)
+{
+	struct handshake_info *hsi = sk->sk_handshake_data;
+
+	sk->sk_wq_raw = hsi->hi_saved_wq;
+	sk->sk_socket = hsi->hi_saved_socket;
+	sk->sk_uid = hsi->hi_saved_uid;
+	sk->sk_handshake_data = NULL;
+}
+
+static const struct proto_ops *handshake_saved_ops(struct sock *sk)
+{
+	const struct proto_ops *ops = NULL;
+	struct handshake_info *hsi;
+
+	read_lock_bh(&sk->sk_callback_lock);
+	hsi = sk->sk_handshake_data;
+	if (hsi)
+		ops = hsi->hi_saved_socket->ops;
+	read_unlock_bh(&sk->sk_callback_lock);
+	return ops;
+}
+
+/**
+ * handshake_done - call the registered "done" callback for @sk.
+ * @sk: socket that was requesting a handshake
+ *
+ * Return values:
+ *   %true:  Handshake callback was called
+ *   %false: No handshake callback was set, no-op
+ */
+static bool handshake_done(struct sock *sk)
+{
+	struct handshake_info *hsi;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	hsi = sk->sk_handshake_data;
+	if (hsi) {
+		handshake_sock_restore_locked(sk);
+		hsi->hi_done(hsi);
+	}
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	if (hsi) {
+		sock_put(sk);	/* Ref: J */
+		return true;
+	}
+	return false;
+}
+
+/**
+ * handshake_accept_drain - clean up children queued for accept
+ * @listener: listener socket to drain
+ *
+ */
+static void handshake_accept_drain(struct sock *listener)
+{
+	struct sock *sk;
+
+	while ((sk = handshake_accept_dequeue(listener)))
+		handshake_done(sk);
+}
+
+/**
+ * handshake_release - free an AF_HANDSHAKE socket
+ * @sock: socket to release
+ *
+ * Return values:
+ *   %0: success
+ */
+static int handshake_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct handshake_sock *ssk = handshake_sk(sk);
+	int ret = 0;
+
+	if (!sk)
+		return ret;
+
+	trace_handshake_release(sock);
+
+	switch (sk->sk_family) {
+	case AF_HANDSHAKE:
+		sock_hold(sk);	/* Ref: D */
+		sock_orphan(sk);
+		lock_sock(sk);
+
+		handshake_unregister_listener(sk);
+		handshake_accept_drain(sk);
+
+		sk->sk_state = TCP_CLOSE;
+		sk->sk_shutdown |= SEND_SHUTDOWN;
+		sk->sk_state_change(sk);
+
+		ssk->hs_bind_family = AF_UNSPEC;
+		sock->sk = NULL;
+		release_sock(sk);
+		sock_put(sk);	/* Ref: D */
+
+		sock_put(sk);	/* Ref: A */
+		break;
+	case AF_INET:
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+#endif
+		if (!handshake_done(sk)) {
+			const struct proto_ops *ops;
+
+			ops = handshake_saved_ops(sk);
+			if (ops)
+				ret = ops->release(sock);
+		}
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * handshake_bind - bind a name to an AF_HANDSHAKE socket
+ * @sock: socket to be bound
+ * @uaddr: address to bind to
+ * @addrlen: length in bytes of @uaddr
+ *
+ * Binding an AF_HANDSHAKE socket defines the family of addresses that
+ * are able to be accept(2)'d. So, AF_INET for ipv4, AF_INET6 for
+ * ipv6.
+ *
+ * Return values:
+ *   %0: binding was successful.
+ *   %-EPERM: Caller not privileged
+ *   %-EINVAL: Family of @sock or @uaddr not supported
+ */
+static int handshake_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
+{
+	struct sock *listener, *sk = sock->sk;
+	struct handshake_sock *ssk = handshake_sk(sk);
+
+	if (!capable(CAP_NET_BIND_SERVICE))
+		return -EPERM;
+
+	switch (uaddr->sa_family) {
+	case AF_INET:
+		if (addrlen != sizeof(struct sockaddr_in))
+			return -EINVAL;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		if (addrlen != sizeof(struct sockaddr_in6))
+			return -EINVAL;
+		break;
+#endif
+	default:
+		return -EAFNOSUPPORT;
+	}
+
+	listener = handshake_find_listener(sock_net(sk), uaddr->sa_family);
+	if (listener) {
+		sock_put(listener);	/* Ref: C */
+		return -EADDRINUSE;
+	}
+
+	ssk->hs_bind_family = uaddr->sa_family;
+	trace_handshake_bind(sock);
+	return 0;
+}
+
+/**
+ * handshake_accept - return a connection waiting for a TLS handshake
+ * @listener: listener socket which connection requests arrive on
+ * @newsock: socket to move incoming connection to
+ * @flags: SOCK_NONBLOCK and/or SOCK_CLOEXEC
+ * @kern: "boolean": 1 for kernel-internal sockets
+ *
+ * Return values:
+ *   %0: @newsock has been initialized.
+ *   %-EPERM: caller is not privileged
+ */
+static int handshake_accept(struct socket *listener, struct socket *newsock, int flags,
+			  bool kern)
+{
+	struct sock *sk = listener->sk, *newsk;
+	DECLARE_WAITQUEUE(wait, current);
+	long timeo;
+	int rc;
+
+	trace_handshake_accept(listener);
+
+	rc = -EPERM;
+	if (!capable(CAP_NET_BIND_SERVICE))
+		goto out;
+
+	lock_sock(sk);
+
+	if (sk->sk_state != TCP_LISTEN) {
+		rc = -EBADF;
+		goto out_release;
+	}
+
+	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+
+	rc = 0;
+	add_wait_queue_exclusive(sk_sleep(sk), &wait);
+	while (!(newsk = handshake_accept_dequeue(sk))) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!timeo) {
+			rc = -EAGAIN;
+			break;
+		}
+		release_sock(sk);
+
+		timeo = schedule_timeout(timeo);
+
+		lock_sock(sk);
+		if (sk->sk_state != TCP_LISTEN) {
+			rc = -EBADF;
+			break;
+		}
+		if (signal_pending(current)) {
+			rc = sock_intr_errno(timeo);
+			break;
+		}
+	}
+	set_current_state(TASK_RUNNING);
+	remove_wait_queue(sk_sleep(sk), &wait);
+	if (rc) {
+		handshake_done(sk);
+		goto out_release;
+	}
+
+	sock_graft(newsk, newsock);
+	trace_handshake_newsock(newsock, newsk);
+
+out_release:
+	release_sock(sk);
+out:
+	return rc;
+}
+
+/**
+ * handshake_getname - retrieve src/dst address information from an AF_HANDSHAKE socket
+ * @sock: socket to query
+ * @uaddr: buffer to fill in
+ * @peer: value indicates which address to retrieve
+ *
+ * Return values:
+ *   On success, a positive length of the address in @uaddr
+ *   On error, a negative errno
+ */
+static int handshake_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
+{
+	struct sock *sk = sock->sk;
+	const struct proto_ops *ops;
+
+	trace_handshake_getname(sock);
+
+	switch (sk->sk_family) {
+	case AF_INET:
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+#endif
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ops = handshake_saved_ops(sk);
+	if (!ops)
+		return -EBADFD;
+	return ops->getname(sock, uaddr, peer);
+}
+
+/**
+ * handshake_poll - check for data ready on an AF_HANDSHAKE socket
+ * @file: file to check for work
+ * @sock: socket associated with @file
+ * @wait: poll table
+ *
+ * Return values:
+ *    A mask of flags indicating what type of I/O is ready
+ */
+static __poll_t handshake_poll(struct file *file, struct socket *sock,
+			     poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	__poll_t mask;
+
+	sock_poll_wait(file, sock, wait);
+
+	mask = 0;
+
+	if (sk->sk_state == TCP_LISTEN) {
+		if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
+			mask |= EPOLLIN | EPOLLRDNORM;
+		if (sk_is_readable(sk))
+			mask |= EPOLLIN | EPOLLRDNORM;
+		trace_handshake_poll_listener(sock, mask);
+		return mask;
+	}
+
+	if (sk->sk_shutdown == SHUTDOWN_MASK || sk->sk_state == TCP_CLOSE)
+		mask |= EPOLLHUP;
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
+
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
+		mask |= EPOLLIN | EPOLLRDNORM;
+	if (sk_is_readable(sk))
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	smp_rmb();
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
+		mask |= EPOLLERR;
+
+	trace_handshake_poll(sock, mask);
+	return mask;
+}
+
+/**
+ * handshake_listen - move an AF_HANDSHAKE socket into a listening state
+ * @sock: socket to transition to listening state
+ * @backlog: size of backlog queue
+ *
+ * Return values:
+ *   %0: @sock is now in a listening state
+ *   %-EPERM: caller is not privileged
+ *   %-EOPNOTSUPP: @sock is not of a type that supports the listen() operation
+ */
+static int handshake_listen(struct socket *sock, int backlog)
+{
+	struct sock *sk = sock->sk;
+	unsigned char old_state;
+	int rc;
+
+	if (!capable(CAP_NET_BIND_SERVICE))
+		return -EPERM;
+
+	lock_sock(sk);
+
+	rc = -EOPNOTSUPP;
+	if (sock->state != SS_UNCONNECTED || sock->type != SOCK_STREAM)
+		goto out;
+	old_state = sk->sk_state;
+	if (!((1 << old_state) & (TCPF_CLOSE | TCPF_LISTEN)))
+		goto out;
+
+	sk->sk_max_ack_backlog = backlog;
+	sk->sk_state = TCP_LISTEN;
+	handshake_register_listener(sk);
+
+	trace_handshake_listen(sock);
+	rc = 0;
+
+out:
+	release_sock(sk);
+	return rc;
+}
+
+/**
+ * handshake_shutdown - Shutdown an AF_HANDSHAKE socket
+ * @sock: socket to shut down
+ * @how: mask
+ *
+ * Return values:
+ *   %0: Success
+ *   %-EINVAL: @sock is not of a type that supports a shutdown
+ */
+static int handshake_shutdown(struct socket *sock, int how)
+{
+	struct sock *sk = sock->sk;
+
+	trace_handshake_shutdown(sock);
+
+	switch (sk->sk_family) {
+	case AF_INET:
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+#endif
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return inet_shutdown(sock, how);
+}
+
+/**
+ * handshake_setsockopt - Set a socket option on an AF_HANDSHAKE socket
+ * @sock: socket to act upon
+ * @level: which network layer to act upon
+ * @optname: which option to set
+ * @optval: new value to set
+ * @optlen: the size of the new value, in bytes
+ *
+ * Return values:
+ *   %0: Success
+ *   %-ENOPROTOOPT: The option is unknown at the level indicated.
+ */
+static int handshake_setsockopt(struct socket *sock, int level, int optname,
+			      sockptr_t optval, unsigned int optlen)
+{
+	struct sock *sk = sock->sk;
+
+	trace_handshake_setsockopt(sock);
+
+	switch (sk->sk_family) {
+	case AF_INET:
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+#endif
+		break;
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	return sock_common_setsockopt(sock, level, optname, optval, optlen);
+}
+
+/**
+ * handshake_getsockopt - Retrieve a socket option from an AF_HANDSHAKE socket
+ * @sock: socket to act upon
+ * @level: which network layer to act upon
+ * @optname: which option to retrieve
+ * @optval: a buffer into which to receive the option's value
+ * @optlen: the size of the receive buffer, in bytes
+ *
+ * Return values:
+ *   %0: Success
+ *   %-ENOPROTOOPT: The option is unknown at the level indicated.
+ *   %-EINVAL: Invalid argument
+ *   %-EFAULT: Output memory not write-able
+ *   %-EBUSY: Option value not available
+ */
+static int handshake_getsockopt(struct socket *sock, int level, int optname,
+			      char __user *optval, int __user *optlen)
+{
+	struct sock *sk = sock->sk;
+
+	trace_handshake_getsockopt(sock);
+
+	switch (sk->sk_family) {
+	case AF_INET:
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+#endif
+		break;
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	return sock_common_getsockopt(sock, level, optname, optval, optlen);
+}
+
+/**
+ * handshake_sendmsg - Send a message on an AF_HANDSHAKE socket
+ * @sock: socket to send on
+ * @msg: message to send
+ * @size: size of message, in bytes
+ *
+ * Return values:
+ *   %0: Success
+ *   %-EOPNOTSUPP: Address family does not support this operation
+ */
+static int handshake_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+{
+	struct sock *sk = sock->sk;
+	int ret;
+
+	trace_handshake_sendmsg_start(sock, size);
+
+	switch (sk->sk_family) {
+	case AF_INET:
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+#endif
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (unlikely(inet_send_prepare(sk))) {
+		ret = -EAGAIN;
+		goto out;
+	}
+	ret = sk->sk_prot->sendmsg(sk, msg, size);
+
+out:
+	trace_handshake_sendmsg_result(sock, ret);
+	return ret;
+}
+
+/**
+ * handshake_recvmsg - Receive a message from an AF_HANDSHAKE socket
+ * @sock: socket to receive from
+ * @msg: buffer into which to receive
+ * @size: size of buffer, in bytes
+ * @flags: control settings
+ *
+ * Return values:
+ *   %0: Success
+ *   %-EOPNOTSUPP: Address family does not support this operation
+ */
+static int handshake_recvmsg(struct socket *sock, struct msghdr *msg,
+			   size_t size, int flags)
+{
+	struct sock *sk = sock->sk;
+	int ret;
+
+	trace_handshake_recvmsg_start(sock, size);
+
+	switch (sk->sk_family) {
+	case AF_INET:
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+#endif
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (likely(!(flags & MSG_ERRQUEUE)))
+		sock_rps_record_flow(sk);
+	ret = sock_common_recvmsg(sock, msg, size, flags);
+
+out:
+	trace_handshake_recvmsg_result(sock, ret);
+	return ret;
+}
+
+static const struct proto_ops handshake_proto_ops = {
+	.family		= PF_HANDSHAKE,
+	.owner		= THIS_MODULE,
+
+	.release	= handshake_release,
+	.bind		= handshake_bind,
+	.connect	= sock_no_connect,
+	.socketpair	= sock_no_socketpair,
+	.accept		= handshake_accept,
+	.getname	= handshake_getname,
+	.poll		= handshake_poll,
+	.ioctl		= sock_no_ioctl,
+	.gettstamp	= sock_gettstamp,
+	.listen		= handshake_listen,
+	.shutdown	= handshake_shutdown,
+	.setsockopt	= handshake_setsockopt,
+	.getsockopt	= handshake_getsockopt,
+	.sendmsg	= handshake_sendmsg,
+	.recvmsg	= handshake_recvmsg,
+	.mmap		= sock_no_mmap,
+	.sendpage	= sock_no_sendpage,
+};
+
+static struct proto handshake_prot = {
+	.name			= "HANDSHAKE",
+	.owner			= THIS_MODULE,
+	.obj_size		= sizeof(struct handshake_sock),
+};
+
+/**
+ * handshake_pf_create - create an AF_HANDSHAKE socket
+ * @net: network namespace to own the new socket
+ * @sock: socket to initialize
+ * @protocol: IP protocol number (ignored)
+ * @kern: "boolean": 1 for kernel-internal sockets
+ *
+ * Return values:
+ *   %0: @sock was initialized, and module ref count incremented.
+ *   Negative errno values indicate initialization failed.
+ */
+static int handshake_pf_create(struct net *net, struct socket *sock, int protocol,
+			     int kern)
+{
+	struct sock *sk;
+	int rc;
+
+	sock->state = SS_UNCONNECTED;
+	sock->ops = &handshake_proto_ops;
+
+	/* Ref: A */
+	sk = sk_alloc(net, PF_HANDSHAKE, GFP_KERNEL, &handshake_prot, kern);
+	if (!sk)
+		return -ENOMEM;
+
+	sock_init_data(sock, sk);
+	if (sk->sk_prot->init) {
+		rc = sk->sk_prot->init(sk);
+		if (rc)
+			goto err_sk_put;
+	}
+
+	handshake_sk(sk)->hs_bind_family = AF_UNSPEC;
+	trace_handshake_pf_create(sock);
+	return 0;
+
+err_sk_put:
+	sock_orphan(sk);
+	sk_free(sk);	/* Ref: A (err) */
+	return rc;
+}
+
+/**
+ * handshake_enqueue_sock - Queue a socket to be shared with user space
+ * @sock: a connected socket to share with user space
+ * @hsi: info packet tracking this request
+ *
+ * Return values:
+ *   %0: Successfully queued
+ *   %-ENOENT: No listener is available to handle this request
+ *   %-ENOMEM: Memory allocation failed
+ */
+int handshake_enqueue_sock(struct socket *sock, struct handshake_info *hsi)
+{
+	struct sock *listener, *sk = sock->sk;
+	int rc;
+
+	listener = handshake_find_listener(sock_net(sk), sk->sk_family);
+	if (!listener)
+		return -ENOENT;
+
+	handshake_sock_save(sk, hsi);
+	rc = handshake_accept_enqueue(listener, sk);
+	if (rc) {
+		handshake_sock_clear(sk);
+		sock_put(listener);	/* Ref: C (err) */
+	}
+	return rc;
+}
+EXPORT_SYMBOL(handshake_enqueue_sock);
+
+static const struct net_proto_family handshake_pf_ops = {
+	.family = PF_HANDSHAKE,
+	.create = handshake_pf_create,
+	.owner	= THIS_MODULE,
+};
+
+static int __init handshake_register(void)
+{
+	int rc;
+
+	rc = handshake_genetlink_init();
+	if (rc)
+		return rc;
+
+	sock_register(&handshake_pf_ops);
+	return 0;
+}
+
+static void __exit handshake_unregister(void)
+{
+	sock_unregister(PF_HANDSHAKE);
+	handshake_genetlink_exit();
+}
+
+
+module_init(handshake_register);
+module_exit(handshake_unregister);
diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
new file mode 100644
index 000000000000..62a6c85c5a17
--- /dev/null
+++ b/net/handshake/handshake.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * PF_HANDSHAKE protocol family socket handler.
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2023, Oracle and/or its affiliates.
+ */
+
+/*
+ * Data structures and functions that are internal to handshake/
+ * are declared here.
+ */
+
+#ifndef _HANDSHAKE_H
+#define _HANDSHAKE_H
+
+struct handshake_sock {
+	/* struct sock must remain the first field */
+	struct sock	hs_sk;
+
+	int		hs_bind_family;
+};
+
+static inline struct handshake_sock *handshake_sk(struct sock *sk)
+{
+	return container_of(sk, struct handshake_sock, hs_sk);
+}
+
+extern int __init handshake_genetlink_init(void);
+extern void handshake_genetlink_exit(void);
+
+#endif /* _HANDSHAKE_H */
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
new file mode 100644
index 000000000000..1d209473f106
--- /dev/null
+++ b/net/handshake/netlink.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * HANDSHAKE generic netlink service
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2023, Oracle and/or its affiliates.
+ */
+
+#include <linux/types.h>
+#include <linux/socket.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/inet.h>
+
+#include <net/sock.h>
+#include <net/genetlink.h>
+#include <net/handshake.h>
+
+#include <uapi/linux/handshake.h>
+#include "handshake.h"
+
+static struct genl_family __ro_after_init handshake_genl_family;
+
+static int handshake_genl_op_unsupp(struct sk_buff *skb, struct genl_info *gi)
+{
+	pr_err("Unknown netlink command (%d) ignored\n", gi->genlhdr->cmd);
+	return -EINVAL;
+}
+
+static int handshake_genl_error_reply(struct genl_info *gi,
+				      enum handshake_genl_status status)
+{
+	struct genlmsghdr *hdr;
+	struct sk_buff *msg;
+	int ret;
+
+	ret = -ENOMEM;
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		goto out;
+	hdr = genlmsg_put_reply(msg, gi, &handshake_genl_family, 0,
+				gi->genlhdr->cmd);
+	if (!hdr)
+		goto out_free;
+
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_STATUS, status);
+	if (ret < 0)
+		goto out_cancel;
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, gi);
+
+out_cancel:
+	genlmsg_cancel(msg, hdr);
+out_free:
+	nlmsg_free(msg);
+out:
+	return ret;
+}
+
+static int handshake_genl_reply(struct genl_info *gi, struct handshake_info *hsi)
+{
+	struct genlmsghdr *hdr;
+	struct sk_buff *msg;
+	int ret;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		goto out;
+	hdr = genlmsg_put_reply(msg, gi, &handshake_genl_family, 0,
+				gi->genlhdr->cmd);
+	if (!hdr)
+		goto out_free;
+
+	ret = hsi->hi_fd_parms_reply(msg, hsi);
+	if (ret < 0)
+		goto out_cancel;
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, gi);
+
+out_cancel:
+	genlmsg_cancel(msg, hdr);
+out_free:
+	nlmsg_free(msg);
+out:
+	return ret;
+}
+
+static int handshake_genl_op_get_fd_parms(struct sk_buff *skb, struct genl_info *gi)
+{
+	struct handshake_info *hsi;
+	struct socket *sock;
+	struct sock *sk;
+	int ret;
+
+	if (!gi->attrs[HANDSHAKE_GENL_ATTR_SOCKFD])
+		return handshake_genl_error_reply(gi, HANDSHAKE_GENL_STATUS_INVAL);
+
+	ret = 0;
+	sock = sockfd_lookup(nla_get_u32(gi->attrs[HANDSHAKE_GENL_ATTR_SOCKFD]),
+			     &ret);
+	if (ret)
+		return handshake_genl_error_reply(gi, HANDSHAKE_GENL_STATUS_SOCKNOTFOUND);
+
+	sk = sock->sk;
+	write_lock_bh(&sk->sk_callback_lock);
+	hsi = sk->sk_handshake_data;
+	if (!hsi) {
+		write_unlock_bh(&sk->sk_callback_lock);
+		sockfd_put(sock);
+		return handshake_genl_error_reply(gi, HANDSHAKE_GENL_STATUS_SOCKNOTVALID);
+	}
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	ret = handshake_genl_reply(gi, hsi);
+
+	sockfd_put(sock);
+	return ret;
+}
+
+static const struct nla_policy
+handshake_genl_policy[HANDSHAKE_GENL_ATTR_MAX + 1] = {
+	[HANDSHAKE_GENL_ATTR_SOCKFD] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_STATUS] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_PROTOCOL] = {
+		.type = NLA_U32
+	},
+};
+
+static const struct genl_ops handshake_genl_ops[] = {
+	{
+		.cmd	= HANDSHAKE_GENL_CMD_UNSPEC,
+		.doit	= handshake_genl_op_unsupp,
+	},
+	{
+		.cmd	= HANDSHAKE_GENL_CMD_GET_FD_PARAMETERS,
+		.doit	= handshake_genl_op_get_fd_parms,
+	},
+};
+
+static struct genl_family __ro_after_init handshake_genl_family = {
+	.hdrsize	= 0,
+	.name		= HANDSHAKE_GENL_NAME,
+	.version	= HANDSHAKE_GENL_VERSION,
+	.maxattr	= HANDSHAKE_GENL_ATTR_MAX,
+	.netnsok	= true,
+	.n_ops		= ARRAY_SIZE(handshake_genl_ops),
+	.resv_start_op	= HANDSHAKE_GENL_CMD_MAX,
+	.policy		= handshake_genl_policy,
+	.ops		= handshake_genl_ops,
+	.module		= THIS_MODULE,
+};
+
+int __init handshake_genetlink_init(void)
+{
+	return genl_register_family(&handshake_genl_family);
+}
+
+void handshake_genetlink_exit(void)
+{
+	genl_unregister_family(&handshake_genl_family);
+}
diff --git a/net/handshake/trace.c b/net/handshake/trace.c
new file mode 100644
index 000000000000..5968848da0c1
--- /dev/null
+++ b/net/handshake/trace.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * PF_HANDSHAKE protocol family trace points
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2023 Oracle and/or its affiliates.
+ */
+
+#include <linux/net.h>
+#include <net/sock.h>
+
+#include "handshake.h"
+
+#ifndef __CHECKER__
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/handshake.h>
+
+#endif


