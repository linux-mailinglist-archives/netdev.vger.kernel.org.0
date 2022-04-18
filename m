Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C20505CBF
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346445AbiDRQxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346479AbiDRQws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:52:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1E126573;
        Mon, 18 Apr 2022 09:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1232A612E6;
        Mon, 18 Apr 2022 16:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F89C385A1;
        Mon, 18 Apr 2022 16:49:51 +0000 (UTC)
Subject: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:49:50 -0400
Message-ID: <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
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

In-kernel TLS consumers need a way to perform a TLS handshake. In
the absence of a handshake implementation in the kernel itself, a
mechanism to perform the handshake in user space, using an existing
TLS handshake library, is necessary.

I've designed a way to pass a connected kernel socket endpoint to
user space using the traditional listen/accept mechanism. accept(2)
gives us a well-understood way to materialize a socket endpoint as a
normal file descriptor in a specific user space process. Like any
open socket descriptor, the accepted FD can then be passed to a
library such as openSSL to perform a TLS handshake.

This prototype currently handles only initiating client-side TLS
handshakes. Server-side handshakes and key renegotiation are left
to do.

Security Considerations
~~~~~~~~ ~~~~~~~~~~~~~~

This prototype is net-namespace aware.

The kernel has no mechanism to attest that the listening user space
agent is trustworthy.

Currently the prototype does not handle multiple listeners that
overlap -- multiple listeners in the same net namespace that have
overlapping bind addresses.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 .../networking/tls-in-kernel-handshake.rst         |  103 ++
 include/linux/socket.h                             |    1 
 include/net/sock.h                                 |    3 
 include/net/tls.h                                  |   15 
 include/net/tlsh.h                                 |   22 
 include/uapi/linux/tls.h                           |   16 
 net/core/sock.c                                    |    2 
 net/tls/Makefile                                   |    2 
 net/tls/af_tlsh.c                                  | 1040 ++++++++++++++++++++
 net/tls/tls_main.c                                 |   10 
 10 files changed, 1213 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/tls-in-kernel-handshake.rst
 create mode 100644 include/net/tlsh.h
 create mode 100644 net/tls/af_tlsh.c

diff --git a/Documentation/networking/tls-in-kernel-handshake.rst b/Documentation/networking/tls-in-kernel-handshake.rst
new file mode 100644
index 000000000000..73ed6928f4b2
--- /dev/null
+++ b/Documentation/networking/tls-in-kernel-handshake.rst
@@ -0,0 +1,103 @@
+.. _kernel_tls:
+
+=======================
+In-Kernel TLS Handshake
+=======================
+
+Overview
+========
+
+Transport Layer Security (TLS) is a Upper Layer Protocol (ULP) that runs over
+TCP. TLS provides end-to-end data integrity and confidentiality.
+
+kTLS handles the TLS record subprotocol, but does not handle the TLS handshake
+subprotocol, used to establish a TLS session. In user space, a TLS library
+performs the handshake on a socket which is converted to kTLS operation. In
+the kernel it is much the same. The TLS handshake is done in user space by a
+library TLS implementation.
+
+
+User agent
+==========
+
+With the current implementation, a user agent is started in each network
+namespace where a kernel consumer might require a TLS handshake. This agent
+listens on an AF_TLSH socket for requests from the kernel to perform a
+handshake on an open and connected TCP socket.
+
+The open socket is passed to user space via accept(), which creates a file
+descriptor. If the handshake completes successfully, the user agent promotes
+the socket to use the TLS ULP and sets the session information using the
+SOL_TLS socket options. The user agent returns the socket to the kernel by
+closing the accepted file descriptor.
+
+
+Kernel Handshake API
+====================
+
+A kernel consumer initiates a client-side TLS handshake on an open
+socket by invoking one of the tls_client_hello() functions. For
+example:
+
+.. code-block:: c
+
+  ret = tls_client_hello_x509(sock, done_func, cookie, priorities,
+                              peerid, cert);
+
+The function returns zero when the handshake request is under way. A
+zero return guarantees the callback function @done_func will be invoked
+for this socket.
+
+The function returns a negative errno if the handshake could not be
+started. A negative errno guarantees the callback function @done_func
+will not be invoked on this socket.
+
+The @sock argument is an open and connected IPPROTO_TCP socket. The
+caller must hold a reference on the socket to prevent it from being
+destroyed while the handshake is in progress.
+
+@done_func and @cookie are a callback function that is invoked when the
+handshake has completed (either successfully or not). The success status
+of the handshake is returned via the @status parameter of the callback
+function. A good practice is to close and destroy the socket immediately
+if the handshake has failed.
+
+@priorities is a GnuTLS priorities string that controls the handshake.
+The special value TLSH_DEFAULT_PRIORITIES causes the handshake to
+operate using user space configured default TLS priorities. However,
+the caller can use the string to (for example) adjust the handshake to
+use a restricted set of ciphers (say, if the kernel is in FIPS mode or
+the kernel consumer wants to mandate only a limited set of ciphers).
+
+@peerid is the serial number of a key on the XXXYYYZZZ keyring that
+contains a private key.
+
+@cert is the serial number of a key on the XXXYYYYZZZ keyring that
+contains a {PEM,DER} format x.509 certificate that the user agent
+presents to the server as the local peer's identity.
+
+To initiate a client-side TLS handshake with a pre-shared key, use:
+
+.. code-block:: c
+
+  ret = tls_client_hello_psk(sock, done_func, cookie, priorities,
+                             peerid);
+
+@peerid is the serial number of a key on the XXXYYYZZZ keyring that
+contains the pre-shared key.
+
+The other parameters are as above.
+
+
+Other considerations
+--------------------
+
+While the handshake is under way, the kernel consumer must alter the
+socket's sk_data_ready callback function to ignore incoming data.
+Once the callback function has been invoked, normal receive operation
+can be resumed.
+
+See tls.rst for details on how a kTLS consumer recognizes incoming
+(decrypted) application data, alerts, and handshake packets once the
+socket has been promoted to use the TLS ULP.
+
diff --git a/include/linux/socket.h b/include/linux/socket.h
index fc28c68e6b5f..69acb5668d34 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -369,6 +369,7 @@ struct ucred {
 #define SOL_MPTCP	284
 #define SOL_MCTP	285
 #define SOL_SMC		286
+#define SOL_TLSH	287
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/net/sock.h b/include/net/sock.h
index d2a513169527..d5a5d5fd6682 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -353,6 +353,7 @@ struct sk_filter;
   *	@sk_txtime_report_errors: set report errors mode for SO_TXTIME
   *	@sk_txtime_unused: unused txtime flags
   *	@ns_tracker: tracker for netns reference
+  *	@sk_tlsh_priv: private data for TLS handshake upcall
   */
 struct sock {
 	/*
@@ -544,6 +545,8 @@ struct sock {
 #endif
 	struct rcu_head		sk_rcu;
 	netns_tracker		ns_tracker;
+
+	void			*sk_tlsh_priv;
 };
 
 enum sk_pacing {
diff --git a/include/net/tls.h b/include/net/tls.h
index b6968a5b5538..6b1bf46daa34 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -51,6 +51,18 @@
 #include <uapi/linux/tls.h>
 
 
+struct tlsh_sock {
+	/* struct sock must remain the first field */
+	struct sock	th_sk;
+
+	int		th_bind_family;
+};
+
+static inline struct tlsh_sock *tlsh_sk(struct sock *sk)
+{
+	return (struct tlsh_sock *)sk;
+}
+
 /* Maximum data size carried in a TLS record */
 #define TLS_MAX_PAYLOAD_SIZE		((size_t)1 << 14)
 
@@ -356,6 +368,9 @@ struct tls_context *tls_ctx_create(struct sock *sk);
 void tls_ctx_free(struct sock *sk, struct tls_context *ctx);
 void update_sk_prot(struct sock *sk, struct tls_context *ctx);
 
+int tlsh_pf_create(struct net *net, struct socket *sock, int protocol,
+		   int kern);
+
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 int tls_sk_query(struct sock *sk, int optname, char __user *optval,
 		int __user *optlen);
diff --git a/include/net/tlsh.h b/include/net/tlsh.h
new file mode 100644
index 000000000000..8725fd83df60
--- /dev/null
+++ b/include/net/tlsh.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * PF_TLSH protocol family socket handler.
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2021, Oracle and/or its affiliates.
+ */
+
+#ifndef _TLS_HANDSHAKE_H
+#define _TLS_HANDSHAKE_H
+
+extern int tls_client_hello_psk(struct socket *sock,
+				void (*done)(void *data, int status),
+				void *data, const char *priorities,
+				key_serial_t peerid);
+extern int tls_client_hello_x509(struct socket *sock,
+				 void (*done)(void *data, int status),
+				 void *data, const char *priorities,
+				 key_serial_t peerid, key_serial_t cert);
+
+#endif /* _TLS_HANDSHAKE_H */
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index 5f38be0ec0f3..d0ffbb6ea0e4 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -40,6 +40,22 @@
 #define TLS_TX			1	/* Set transmit parameters */
 #define TLS_RX			2	/* Set receive parameters */
 
+/* TLSH socket options */
+#define TLSH_PRIORITIES		1	/* Retrieve TLS priorities string */
+#define TLSH_PEERID		2	/* Retrieve peer identity */
+#define TLSH_HANDSHAKE_TYPE	3	/* Retrieve handshake type */
+#define TLSH_X509_CERTIFICATE	4	/* Retrieve x.509 certificate */
+
+#define TLSH_DEFAULT_PRIORITIES		(NULL)
+#define TLSH_NO_PEERID			(0)
+#define TLSH_NO_CERT			(0)
+
+/* TLSH handshake types */
+enum tlsh_hs_type {
+	TLSH_TYPE_CLIENTHELLO_X509,
+	TLSH_TYPE_CLIENTHELLO_PSK,
+};
+
 /* Supported versions */
 #define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
 #define TLS_VERSION_MAJOR(ver)	(((ver) >> 8) & 0xFF)
diff --git a/net/core/sock.c b/net/core/sock.c
index 81bc14b67468..d9f700e5ea1a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3295,6 +3295,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_incoming_cpu = -1;
 	sk->sk_txrehash = SOCK_TXREHASH_DEFAULT;
 
+	sk->sk_tlsh_priv = NULL;
+
 	sk_rx_queue_clear(sk);
 	/*
 	 * Before updating sk_refcnt, we must commit prior changes to memory
diff --git a/net/tls/Makefile b/net/tls/Makefile
index f1ffbfe8968d..d159a03b94f3 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -7,7 +7,7 @@ CFLAGS_trace.o := -I$(src)
 
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := tls_main.o tls_sw.o tls_proc.o trace.o
+tls-y := af_tlsh.o tls_main.o tls_sw.o tls_proc.o trace.o
 
 tls-$(CONFIG_TLS_TOE) += tls_toe.o
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/af_tlsh.c b/net/tls/af_tlsh.c
new file mode 100644
index 000000000000..4d1c1de3a474
--- /dev/null
+++ b/net/tls/af_tlsh.c
@@ -0,0 +1,1040 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * PF_TLSH protocol family socket handler.
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2021, Oracle and/or its affiliates.
+ *
+ * When a kernel TLS consumer wants to establish a TLS session, it
+ * makes an AF_TLSH Listener ready. When user space accepts on that
+ * listener, the kernel fabricates a user space socket endpoint on
+ * which a user space TLS library can perform the TLS handshake.
+ *
+ * Closing the user space descriptor signals to the kernel that the
+ * library handshake process is complete. If the library has managed
+ * to initialize the socket's TLS crypto_info, the kernel marks the
+ * handshake as a success.
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
+#include <net/inet_common.h>
+#include <net/net_namespace.h>
+#include <net/tls.h>
+#include <net/tlsh.h>
+
+#include "trace.h"
+
+
+struct tlsh_sock_info {
+	enum tlsh_hs_type	tsi_handshake_type;
+
+	void			(*tsi_handshake_done)(void *data, int status);
+	void			*tsi_handshake_data;
+	char			*tsi_tls_priorities;
+	key_serial_t		tsi_peerid;
+	key_serial_t		tsi_certificate;
+
+	struct socket_wq	*tsi_saved_wq;
+	struct socket		*tsi_saved_socket;
+	kuid_t			tsi_saved_uid;
+};
+
+static void tlsh_sock_info_destroy(struct tlsh_sock_info *info)
+{
+	kfree(info->tsi_tls_priorities);
+	kfree(info);
+}
+
+static DEFINE_RWLOCK(tlsh_listener_lock);
+static HLIST_HEAD(tlsh_listeners);
+
+static void tlsh_register_listener(struct sock *sk)
+{
+	write_lock_bh(&tlsh_listener_lock);
+	sk_add_node(sk, &tlsh_listeners);	/* Ref: B */
+	write_unlock_bh(&tlsh_listener_lock);
+}
+
+static void tlsh_unregister_listener(struct sock *sk)
+{
+	write_lock_bh(&tlsh_listener_lock);
+	sk_del_node_init(sk);			/* Ref: B */
+	write_unlock_bh(&tlsh_listener_lock);
+}
+
+/**
+ * tlsh_find_listener - find listener that matches an incoming connection
+ * @net: net namespace to match
+ * @family: address family to match
+ *
+ * Return values:
+ *   On success, address of a listening AF_TLSH socket
+ *   %NULL: No matching listener found
+ */
+static struct sock *tlsh_find_listener(struct net *net, unsigned short family)
+{
+	struct sock *listener;
+
+	read_lock(&tlsh_listener_lock);
+
+	sk_for_each(listener, &tlsh_listeners) {
+		if (sock_net(listener) != net)
+			continue;
+		if (tlsh_sk(listener)->th_bind_family != AF_UNSPEC &&
+		    tlsh_sk(listener)->th_bind_family != family)
+			continue;
+
+		sock_hold(listener);	/* Ref: C */
+		goto out;
+	}
+	listener = NULL;
+
+out:
+	read_unlock(&tlsh_listener_lock);
+	return listener;
+}
+
+/**
+ * tlsh_accept_enqueue - add a socket to a listener's accept_q
+ * @listener: listening socket
+ * @sk: socket to enqueue on @listener
+ *
+ * Return values:
+ *   On success, returns 0
+ *   %-ENOMEM: Memory for skbs has been exhausted
+ */
+static int tlsh_accept_enqueue(struct sock *listener, struct sock *sk)
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
+ * tlsh_accept_dequeue - remove a socket from a listener's accept_q
+ * @listener: listener socket to check
+ *
+ * Caller guarantees that @listener won't disappear.
+ *
+ * Return values:
+ *   On success, return a TCP socket waiting for TLS service
+ *   %NULL: No sockets on the accept queue
+ */
+static struct sock *tlsh_accept_dequeue(struct sock *listener)
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
+static void tlsh_sock_save(struct sock *sk,
+			   struct tlsh_sock_info *info)
+{
+	sock_hold(sk);	/* Ref: J */
+
+	write_lock_bh(&sk->sk_callback_lock);
+	info->tsi_saved_wq = sk->sk_wq_raw;
+	info->tsi_saved_socket = sk->sk_socket;
+	info->tsi_saved_uid = sk->sk_uid;
+	sk->sk_tlsh_priv = info;
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
+static void tlsh_sock_clear(struct sock *sk)
+{
+	struct tlsh_sock_info *info = sk->sk_tlsh_priv;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	sk->sk_tlsh_priv = NULL;
+	write_unlock_bh(&sk->sk_callback_lock);
+	tlsh_sock_info_destroy(info);
+	sock_put(sk);	/* Ref: J (err) */
+}
+
+static void tlsh_sock_restore_locked(struct sock *sk)
+{
+	struct tlsh_sock_info *info = sk->sk_tlsh_priv;
+
+	sk->sk_wq_raw = info->tsi_saved_wq;
+	sk->sk_socket = info->tsi_saved_socket;
+	sk->sk_uid = info->tsi_saved_uid;
+	sk->sk_tlsh_priv = NULL;
+}
+
+static bool tlsh_crypto_info_initialized(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+
+	return ctx != NULL &&
+		TLS_CRYPTO_INFO_READY(&ctx->crypto_send.info) &&
+		TLS_CRYPTO_INFO_READY(&ctx->crypto_recv.info);
+}
+
+/**
+ * tlsh_handshake_done - call the registered "done" callback for @sk.
+ * @sk: socket that was requesting a handshake
+ *
+ * Return values:
+ *   %true:  Handshake callback was called
+ *   %false: No handshake callback was set, no-op
+ */
+static bool tlsh_handshake_done(struct sock *sk)
+{
+	struct tlsh_sock_info *info;
+	void (*done)(void *data, int status);
+	void *data;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	info = sk->sk_tlsh_priv;
+	if (info) {
+		done = info->tsi_handshake_done;
+		data = info->tsi_handshake_data;
+
+		tlsh_sock_restore_locked(sk);
+
+		if (tlsh_crypto_info_initialized(sk)) {
+			done(data, 0);
+		} else {
+			done(data, -EACCES);
+		}
+	}
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	if (info) {
+		tlsh_sock_info_destroy(info);
+		sock_put(sk);	/* Ref: J */
+		return true;
+	}
+	return false;
+}
+
+/**
+ * tlsh_accept_drain - clean up children queued for accept
+ * @listener: listener socket to drain
+ *
+ */
+static void tlsh_accept_drain(struct sock *listener)
+{
+	struct sock *sk;
+
+	while ((sk = tlsh_accept_dequeue(listener)))
+		tlsh_handshake_done(sk);
+}
+
+/**
+ * tlsh_release - free an AF_TLSH socket
+ * @sock: socket to release
+ *
+ * Return values:
+ *   %0: success
+ */
+static int tlsh_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct tlsh_sock *tsk = tlsh_sk(sk);
+
+	if (!sk)
+		return 0;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		if (!tlsh_handshake_done(sk))
+			return inet_release(sock);
+		return 0;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		if (!tlsh_handshake_done(sk))
+			return inet6_release(sock);
+		return 0;
+#endif
+	case AF_TLSH:
+		break;
+	default:
+		return 0;
+	}
+
+	sock_hold(sk);	/* Ref: D */
+	sock_orphan(sk);
+	lock_sock(sk);
+
+	tlsh_unregister_listener(sk);
+	tlsh_accept_drain(sk);
+
+	sk->sk_state = TCP_CLOSE;
+	sk->sk_shutdown |= SEND_SHUTDOWN;
+	sk->sk_state_change(sk);
+
+	tsk->th_bind_family = AF_UNSPEC;
+	sock->sk = NULL;
+	release_sock(sk);
+	sock_put(sk);	/* Ref: D */
+
+	sock_put(sk);	/* Ref: A */
+	return 0;
+}
+
+/**
+ * tlsh_bind - bind a name to an AF_TLSH socket
+ * @sock: socket to be bound
+ * @uaddr: address to bind to
+ * @addrlen: length in bytes of @uaddr
+ *
+ * Binding an AF_TLSH socket defines the family of addresses that
+ * are able to be accept(2)'d. So, AF_INET for ipv4, AF_INET6 for
+ * ipv6.
+ *
+ * Return values:
+ *   %0: binding was successful.
+ *   %-EPERM: Caller not privileged
+ *   %-EINVAL: Family of @sock or @uaddr not supported
+ */
+static int tlsh_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
+{
+	struct sock *listener, *sk = sock->sk;
+	struct tlsh_sock *tsk = tlsh_sk(sk);
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
+	listener = tlsh_find_listener(sock_net(sk), uaddr->sa_family);
+	if (listener) {
+		sock_put(listener);	/* Ref: C */
+		return -EADDRINUSE;
+	}
+
+	tsk->th_bind_family = uaddr->sa_family;
+	return 0;
+}
+
+/**
+ * tlsh_accept - return a connection waiting for a TLS handshake
+ * @listener: listener socket which connection requests arrive on
+ * @newsock: socket to move incoming connection to
+ * @flags: SOCK_NONBLOCK and/or SOCK_CLOEXEC
+ * @kern: "boolean": 1 for kernel-internal sockets
+ *
+ * Return values:
+ *   %0: @newsock has been initialized.
+ *   %-EPERM: caller is not privileged
+ */
+static int tlsh_accept(struct socket *listener, struct socket *newsock, int flags,
+		       bool kern)
+{
+	struct sock *sk = listener->sk, *newsk;
+	DECLARE_WAITQUEUE(wait, current);
+	long timeo;
+	int rc;
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
+	while (!(newsk = tlsh_accept_dequeue(sk))) {
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
+		tlsh_handshake_done(sk);
+		goto out_release;
+	}
+
+	sock_graft(newsk, newsock);
+
+out_release:
+	release_sock(sk);
+out:
+	return rc;
+}
+
+/**
+ * tlsh_getname - retrieve src/dst address information from an AF_TLSH socket
+ * @sock: socket to query
+ * @uaddr: buffer to fill in
+ * @peer: value indicates which address to retrieve
+ *
+ * Return values:
+ *   On success, a positive length of the address in @uaddr
+ *   On error, a negative errno
+ */
+static int tlsh_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
+{
+	struct sock *sk = sock->sk;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		return inet_getname(sock, uaddr, peer);
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		return inet6_getname(sock, uaddr, peer);
+#endif
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+/**
+ * tlsh_poll - check for data ready on an AF_TLSH socket
+ * @file: file to check for work
+ * @sock: socket associated with @file
+ * @wait: poll table
+ *
+ * Return values:
+ *    A mask of flags indicating what type of I/O is ready
+ */
+static __poll_t tlsh_poll(struct file *file, struct socket *sock,
+			  poll_table *wait)
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
+	return mask;
+}
+
+/**
+ * tlsh_listen - move an AF_TLSH socket into a listening state
+ * @sock: socket to transition to listening state
+ * @backlog: size of backlog queue
+ *
+ * Return values:
+ *   %0: @sock is now in a listening state
+ *   %-EPERM: caller is not privileged
+ *   %-EOPNOTSUPP: @sock is not of a type that supports the listen() operation
+ */
+static int tlsh_listen(struct socket *sock, int backlog)
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
+	tlsh_register_listener(sk);
+
+	rc = 0;
+
+out:
+	release_sock(sk);
+	return rc;
+}
+
+/**
+ * tlsh_shutdown - Shutdown an AF_TLSH socket
+ * @sock: socket to shut down
+ * @how: mask
+ *
+ * Return values:
+ *   %0: Success
+ *   %-EINVAL: @sock is not of a type that supports a shutdown
+ */
+static int tlsh_shutdown(struct socket *sock, int how)
+{
+	struct sock *sk = sock->sk;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		break;
+#endif
+	default:
+		return -EINVAL;
+	}
+
+	return inet_shutdown(sock, how);
+}
+
+/**
+ * tlsh_setsockopt - Set a socket option on an AF_TLSH socket
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
+static int tlsh_setsockopt(struct socket *sock, int level, int optname,
+			   sockptr_t optval, unsigned int optlen)
+{
+	struct sock *sk = sock->sk;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		break;
+#endif
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	return sock_common_setsockopt(sock, level, optname, optval, optlen);
+}
+
+static int tlsh_getsockopt_priorities(struct sock *sk, char __user *optval,
+				      int __user *optlen)
+{
+	struct tlsh_sock_info *info;
+	int outlen, len, ret;
+	const char *val;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+	if (!optval)
+		return -EINVAL;
+
+	ret = 0;
+
+	sock_hold(sk);
+	write_lock_bh(&sk->sk_callback_lock);
+
+	info = sk->sk_tlsh_priv;
+	if (info) {
+		val = info->tsi_tls_priorities;
+	} else {
+		write_unlock_bh(&sk->sk_callback_lock);
+		ret = -EBUSY;
+		goto out_put;
+	}
+
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	if (val) {
+		outlen = strlen(val);
+		if (len < outlen)
+			ret = -EINVAL;
+		else if (copy_to_user(optval, val, outlen))
+			ret = -EFAULT;
+	} else {
+		outlen = 0;
+	}
+
+
+	if (put_user(outlen, optlen))
+		ret = -EFAULT;
+
+out_put:
+	sock_put(sk);
+	return ret;
+}
+
+static int tlsh_getsockopt_peerid(struct sock *sk, char __user *optval,
+				  int __user *optlen)
+{
+	struct tlsh_sock_info *info;
+	int len, val;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+	if (!optval || (len < sizeof(key_serial_t)))
+		return -EINVAL;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	info = sk->sk_tlsh_priv;
+	if (info) {
+		val = info->tsi_peerid;
+	} else {
+		write_unlock_bh(&sk->sk_callback_lock);
+		return -EBUSY;
+	}
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, &val, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int tlsh_getsockopt_type(struct sock *sk, char __user *optval,
+				int __user *optlen)
+{
+	struct tlsh_sock_info *info;
+	int len, val;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+	if (!optval || (len < sizeof(key_serial_t)))
+		return -EINVAL;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	info = sk->sk_tlsh_priv;
+	if (info) {
+		val = info->tsi_handshake_type;
+	} else {
+		write_unlock_bh(&sk->sk_callback_lock);
+		return -EBUSY;
+	}
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, &val, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int tlsh_getsockopt_cert(struct sock *sk, char __user *optval,
+				int __user *optlen)
+{
+	struct tlsh_sock_info *info;
+	int len, val;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+	if (!optval || (len < sizeof(key_serial_t)))
+		return -EINVAL;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	info = sk->sk_tlsh_priv;
+	if (info) {
+		val = info->tsi_certificate;
+	} else {
+		write_unlock_bh(&sk->sk_callback_lock);
+		return -EBUSY;
+	}
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, &val, len))
+		return -EFAULT;
+	return 0;
+}
+
+/**
+ * tlsh_getsockopt - Retrieve a socket option from an AF_TLSH socket
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
+static int tlsh_getsockopt(struct socket *sock, int level, int optname,
+			   char __user *optval, int __user *optlen)
+{
+	struct sock *sk = sock->sk;
+	int ret;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		break;
+#endif
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	if (level != SOL_TLSH)
+		return sock_common_getsockopt(sock, level, optname, optval, optlen);
+
+	switch (optname) {
+	case TLSH_PRIORITIES:
+		ret = tlsh_getsockopt_priorities(sk, optval, optlen);
+		break;
+	case TLSH_PEERID:
+		ret = tlsh_getsockopt_peerid(sk, optval, optlen);
+		break;
+	case TLSH_HANDSHAKE_TYPE:
+		ret = tlsh_getsockopt_type(sk, optval, optlen);
+		break;
+	case TLSH_X509_CERTIFICATE:
+		ret = tlsh_getsockopt_cert(sk, optval, optlen);
+		break;
+	default:
+		ret = -ENOPROTOOPT;
+	}
+
+	return ret;
+}
+
+/**
+ * tlsh_sendmsg - Send a message on an AF_TLSH socket
+ * @sock: socket to send on
+ * @msg: message to send
+ * @size: size of message, in bytes
+ *
+ * Return values:
+ *   %0: Success
+ *   %-EOPNOTSUPP: Address family does not support this operation
+ */
+static int tlsh_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+{
+	struct sock *sk = sock->sk;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		break;
+#endif
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (unlikely(inet_send_prepare(sk)))
+		return -EAGAIN;
+	return sk->sk_prot->sendmsg(sk, msg, size);
+}
+
+/**
+ * tlsh_recvmsg - Receive a message from an AF_TLSH socket
+ * @sock: socket to receive from
+ * @msg: buffer into which to receive
+ * @size: size of buffer, in bytes
+ * @flags: control settings
+ *
+ * Return values:
+ *   %0: Success
+ *   %-EOPNOTSUPP: Address family does not support this operation
+ */
+static int tlsh_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
+			int flags)
+{
+	struct sock *sk = sock->sk;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		break;
+#endif
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (likely(!(flags & MSG_ERRQUEUE)))
+		sock_rps_record_flow(sk);
+	return sock_common_recvmsg(sock, msg, size, flags);
+}
+
+static const struct proto_ops tlsh_proto_ops = {
+	.family		= PF_TLSH,
+	.owner		= THIS_MODULE,
+
+	.release	= tlsh_release,
+	.bind		= tlsh_bind,
+	.connect	= sock_no_connect,
+	.socketpair	= sock_no_socketpair,
+	.accept		= tlsh_accept,
+	.getname	= tlsh_getname,
+	.poll		= tlsh_poll,
+	.ioctl		= sock_no_ioctl,
+	.gettstamp	= sock_gettstamp,
+	.listen		= tlsh_listen,
+	.shutdown	= tlsh_shutdown,
+	.setsockopt	= tlsh_setsockopt,
+	.getsockopt	= tlsh_getsockopt,
+	.sendmsg	= tlsh_sendmsg,
+	.recvmsg	= tlsh_recvmsg,
+	.mmap		= sock_no_mmap,
+	.sendpage	= sock_no_sendpage,
+};
+
+static struct proto tlsh_prot = {
+	.name			= "TLSH",
+	.owner			= THIS_MODULE,
+	.obj_size		= sizeof(struct tlsh_sock),
+};
+
+/**
+ * tlsh_pf_create - create an AF_TLSH socket
+ * @net: network namespace to own the new socket
+ * @sock: socket to initialize
+ * @protocol: IP protocol number (ignored)
+ * @kern: "boolean": 1 for kernel-internal sockets
+ *
+ * Return values:
+ *   %0: @sock was initialized, and module ref count incremented.
+ *   Negative errno values indicate initialization failed.
+ */
+int tlsh_pf_create(struct net *net, struct socket *sock, int protocol, int kern)
+{
+	struct sock *sk;
+	int rc;
+
+	if (protocol != IPPROTO_TCP)
+		return -EPROTONOSUPPORT;
+
+	/* only stream sockets are supported */
+	if (sock->type != SOCK_STREAM)
+		return -ESOCKTNOSUPPORT;
+
+	sock->state = SS_UNCONNECTED;
+	sock->ops = &tlsh_proto_ops;
+
+	/* Ref: A */
+	sk = sk_alloc(net, PF_TLSH, GFP_KERNEL, &tlsh_prot, kern);
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
+	tlsh_sk(sk)->th_bind_family = AF_UNSPEC;
+	return 0;
+
+err_sk_put:
+	sock_orphan(sk);
+	sk_free(sk);	/* Ref: A (err) */
+	return rc;
+}
+
+/**
+ * tls_client_hello_x509 - request an x.509-based TLS handshake on a socket
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ * @peerid: serial number of key containing private key
+ * @cert: serial number of key containing client's x.509 certificate
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ENOENT: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_x509(struct socket *sock, void (*done)(void *data, int status),
+			  void *data, const char *priorities, key_serial_t peerid,
+			  key_serial_t cert)
+{
+	struct sock *listener, *sk = sock->sk;
+	struct tlsh_sock_info *info;
+	int rc;
+
+	listener = tlsh_find_listener(sock_net(sk), sk->sk_family);
+	if (!listener)
+		return -ENOENT;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		sock_put(listener);	/* Ref: C (err) */
+		return -ENOMEM;
+	}
+
+	info->tsi_handshake_done = done;
+	info->tsi_handshake_data = data;
+	if (priorities && strlen(priorities)) {
+		info->tsi_tls_priorities = kstrdup(priorities, GFP_KERNEL);
+		if (!info->tsi_tls_priorities) {
+			tlsh_sock_info_destroy(info);
+			sock_put(listener);	/* Ref: C (err) */
+			return -ENOMEM;
+		}
+	}
+	info->tsi_peerid = peerid;
+	info->tsi_certificate = cert;
+	info->tsi_handshake_type = TLSH_TYPE_CLIENTHELLO_X509;
+	tlsh_sock_save(sk, info);
+
+	rc = tlsh_accept_enqueue(listener, sk);
+	if (rc) {
+		tlsh_sock_clear(sk);
+		sock_put(listener);	/* Ref: C (err) */
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tls_client_hello_x509);
+
+/**
+ * tls_client_hello_psk - request a PSK-based TLS handshake on a socket
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ * @peerid: serial number of key containing TLS identity
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ENOENT: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_psk(struct socket *sock, void (*done)(void *data, int status),
+			 void *data, const char *priorities, key_serial_t peerid)
+{
+	struct sock *listener, *sk = sock->sk;
+	struct tlsh_sock_info *info;
+	int rc;
+
+	listener = tlsh_find_listener(sock_net(sk), sk->sk_family);
+	if (!listener)
+		return -ENOENT;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		sock_put(listener);	/* Ref: C (err) */
+		return -ENOMEM;
+	}
+
+	info->tsi_handshake_done = done;
+	info->tsi_handshake_data = data;
+	if (priorities && strlen(priorities)) {
+		info->tsi_tls_priorities = kstrdup(priorities, GFP_KERNEL);
+		if (!info->tsi_tls_priorities) {
+			tlsh_sock_info_destroy(info);
+			sock_put(listener);	/* Ref: C (err) */
+			return -ENOMEM;
+		}
+	}
+	info->tsi_peerid = peerid;
+	info->tsi_handshake_type = TLSH_TYPE_CLIENTHELLO_PSK;
+	tlsh_sock_save(sk, info);
+
+	rc = tlsh_accept_enqueue(listener, sk);
+	if (rc) {
+		tlsh_sock_clear(sk);
+		sock_put(listener);	/* Ref: C (err) */
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tls_client_hello_psk);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7eca4d9a83c4..c5e0a7b3aa2e 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -49,6 +49,7 @@ MODULE_AUTHOR("Mellanox Technologies");
 MODULE_DESCRIPTION("Transport Layer Security Support");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS_TCP_ULP("tls");
+MODULE_ALIAS_NETPROTO(PF_TLSH);
 
 enum {
 	TLSV4,
@@ -982,6 +983,12 @@ static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.get_info_size		= tls_get_info_size,
 };
 
+static const struct net_proto_family tlsh_pf_ops = {
+	.family = PF_TLSH,
+	.create = tlsh_pf_create,
+	.owner	= THIS_MODULE,
+};
+
 static int __init tls_register(void)
 {
 	int err;
@@ -993,11 +1000,14 @@ static int __init tls_register(void)
 	tls_device_init();
 	tcp_register_ulp(&tcp_tls_ulp_ops);
 
+	sock_register(&tlsh_pf_ops);
+
 	return 0;
 }
 
 static void __exit tls_unregister(void)
 {
+	sock_unregister(PF_TLSH);
 	tcp_unregister_ulp(&tcp_tls_ulp_ops);
 	tls_device_cleanup();
 	unregister_pernet_subsys(&tls_proc_ops);


