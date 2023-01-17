Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B1C66E8B8
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjAQVrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjAQVpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:45:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA05241CF
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:08:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C5A561518
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 20:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E563C433EF;
        Tue, 17 Jan 2023 20:08:10 +0000 (UTC)
Subject: [PATCH RFC 2/3] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com
Date:   Tue, 17 Jan 2023 15:08:09 -0500
Message-ID: <167398608926.5631.13511197621584108600.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167398534919.5631.3008767788631058826.stgit@91.116.238.104.host.secureserver.net>
References: <167398534919.5631.3008767788631058826.stgit@91.116.238.104.host.secureserver.net>
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
 Documentation/networking/index.rst                 |    1 
 .../networking/tls-in-kernel-handshake.rst         |  123 ++
 include/net/sock.h                                 |    3 
 include/net/tls.h                                  |   12 
 include/net/tlsh.h                                 |   25 
 include/uapi/linux/tls.h                           |   43 +
 net/core/sock.c                                    |    2 
 net/tls/Makefile                                   |    2 
 net/tls/af_tlsh.c                                  | 1266 ++++++++++++++++++++
 net/tls/tls.h                                      |   15 
 net/tls/tls_main.c                                 |   19 
 net/tls/trace.c                                    |    3 
 net/tls/trace.h                                    |  341 +++++
 13 files changed, 1853 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/tls-in-kernel-handshake.rst
 create mode 100644 include/net/tlsh.h
 create mode 100644 net/tls/af_tlsh.c

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 16a153bcc5fe..28016d5fc0ca 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -108,6 +108,7 @@ Contents:
    team
    timestamping
    tipc
+   tls-in-kernel-handshake
    tproxy
    tuntap
    udplite
diff --git a/Documentation/networking/tls-in-kernel-handshake.rst b/Documentation/networking/tls-in-kernel-handshake.rst
new file mode 100644
index 000000000000..81473184c822
--- /dev/null
+++ b/Documentation/networking/tls-in-kernel-handshake.rst
@@ -0,0 +1,123 @@
+.. SPDX-License-Identifier: GPL-2.0
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
+User handshake agent
+====================
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
+                              cert, privkey);
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
+@cert is the serial number of a key that contains a DER format x.509
+certificate that the user agent presents to the remote as the local
+peer's identity.
+
+@privkey is the serial number of a key that contains a DER-format
+private key associated with the x.509 certificate.
+
+
+To initiate a client-side TLS handshake with a pre-shared key, use:
+
+.. code-block:: c
+
+  ret = tls_client_hello_psk(sock, done_func, cookie, priorities,
+                             peerid);
+
+@peerid is the serial number of a key that contains the pre-shared
+key to be used for the handshake.
+
+The other parameters are as above.
+
+
+To initiate an anonymous client-side TLS handshake use:
+
+.. code-block:: c
+
+  ret = tls_client_hello_anon(sock, done_func, cookie, priorities);
+
+The parameters are as above.
+
+The user agent presents no peer identity information to the remote
+during the handshake. Only server authentication is performed
+during the handshake. Thus the established session uses encryption
+only.
+
+
+Other considerations
+--------------------
+
+While the handshake is under way, the kernel consumer must alter the
+socket's sk_data_ready callback function to ignore all incoming data.
+Once the handshake completion callback function has been invoked,
+normal receive operation can be resumed.
+
+The consumer must provide a buffer for and then examine the control
+message (CMSG) that is part of every subsequent sock_recvmsg(). Each
+control message indicates whether the received message data is TLS
+record data or session metadata.
+
+See tls.rst for details on how a kTLS consumer recognizes incoming
+(decrypted) application data, alerts, and handshake packets once the
+socket has been promoted to use the TLS ULP.
+
diff --git a/include/net/sock.h b/include/net/sock.h
index e0517ecc6531..375eac53a09e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -349,6 +349,7 @@ struct sk_filter;
   *	@sk_txtime_unused: unused txtime flags
   *	@ns_tracker: tracker for netns reference
   *	@sk_bind2_node: bind node in the bhash2 table
+  *	@sk_tlsh_priv: private data for TLS handshake upcall
   */
 struct sock {
 	/*
@@ -539,6 +540,8 @@ struct sock {
 	struct rcu_head		sk_rcu;
 	netns_tracker		ns_tracker;
 	struct hlist_node	sk_bind2_node;
+
+	void			*sk_tlsh_priv;
 };
 
 enum sk_pacing {
diff --git a/include/net/tls.h b/include/net/tls.h
index 154949c7b0c8..39e959977e0b 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -61,6 +61,18 @@ struct tls_cipher_size_desc {
 
 extern const struct tls_cipher_size_desc tls_cipher_size_desc[];
 
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
 
diff --git a/include/net/tlsh.h b/include/net/tlsh.h
new file mode 100644
index 000000000000..4fc44d53747c
--- /dev/null
+++ b/include/net/tlsh.h
@@ -0,0 +1,25 @@
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
+				 key_serial_t cert, key_serial_t privkey);
+extern int tls_client_hello_anon(struct socket *sock,
+				 void (*done)(void *data, int status),
+				 void *data, const char *priorities);
+
+#endif /* _TLS_HANDSHAKE_H */
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index b66a800389cc..d3be25f825f9 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -42,6 +42,49 @@
 #define TLS_TX_ZEROCOPY_RO	3	/* TX zerocopy (only sendfile now) */
 #define TLS_RX_EXPECT_NO_PAD	4	/* Attempt opportunistic zero-copy */
 
+#define TLSH_DEFAULT_PRIORITIES		(NULL)
+#define TLSH_NO_PEERID			(0)
+#define TLSH_NO_CERT			(0)
+#define TLSH_NO_KEY			(0)
+
+/* TLSH handshake types */
+enum tlsh_hs_type {
+	TLSH_TYPE_CLIENTHELLO_X509,
+	TLSH_TYPE_CLIENTHELLO_PSK,
+	TLSH_TYPE_CLIENTHELLO_ANON,
+};
+
+/* Generic netlink service for handshakes */
+#define HANDSHAKE_GENL_NAME	"HANDSHAKE_GENL"
+#define HANDSHAKE_GENL_VERSION	0x01
+
+enum handshake_genl_attrs {
+	HANDSHAKE_GENL_ATTR_UNSPEC = 0,
+	HANDSHAKE_GENL_ATTR_SOCKFD,
+	HANDSHAKE_GENL_ATTR_STATUS,
+	HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE,
+	HANDSHAKE_GENL_ATTR_PRIORITIES,
+	HANDSHAKE_GENL_ATTR_X509_CERT_SERIAL,
+	HANDSHAKE_GENL_ATTR_X509_PRIVKEY_SERIAL,
+	HANDSHAKE_GENL_ATTR_PSK_SERIAL,
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
 /* Supported versions */
 #define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
 #define TLS_VERSION_MAJOR(ver)	(((ver) >> 8) & 0xFF)
diff --git a/net/core/sock.c b/net/core/sock.c
index 8a8ac154d243..20ff02df9d0b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3430,6 +3430,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_incoming_cpu = -1;
 	sk->sk_txrehash = SOCK_TXREHASH_DEFAULT;
 
+	sk->sk_tlsh_priv = NULL;
+
 	sk_rx_queue_clear(sk);
 	/*
 	 * Before updating sk_refcnt, we must commit prior changes to memory
diff --git a/net/tls/Makefile b/net/tls/Makefile
index e41c800489ac..05fbff53ae09 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -7,7 +7,7 @@ CFLAGS_trace.o := -I$(src)
 
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
+tls-y := af_tlsh.o tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
 
 tls-$(CONFIG_TLS_TOE) += tls_toe.o
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/af_tlsh.c b/net/tls/af_tlsh.c
new file mode 100644
index 000000000000..bf203835e107
--- /dev/null
+++ b/net/tls/af_tlsh.c
@@ -0,0 +1,1266 @@
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
+#include <net/genetlink.h>
+#include <net/tls.h>
+#include <net/tlsh.h>
+
+#include "tls.h"
+#include "trace.h"
+
+struct tlsh_sock_info {
+	enum tlsh_hs_type	tsi_handshake_type;
+
+	void			(*tsi_handshake_done)(void *data, int status);
+	void			*tsi_handshake_data;
+	char			*tsi_tls_priorities;
+	key_serial_t		tsi_peerid;
+	key_serial_t		tsi_certificate;
+	key_serial_t		tsi_privkey;
+
+	struct socket_wq	*tsi_saved_wq;
+	struct socket		*tsi_saved_socket;
+	kuid_t			tsi_saved_uid;
+};
+
+static void tlsh_sock_info_destroy(struct tlsh_sock_info *info)
+{
+	kfree_sensitive(info->tsi_tls_priorities);
+	kfree_sensitive(info);
+}
+
+static struct socket *tlsh_saved_sock(struct sock *sk)
+{
+	struct tlsh_sock_info *info = sk->sk_tlsh_priv;
+
+	return info->tsi_saved_socket;
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
+	return ctx &&
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
+			trace_tlsh_handshake_ok(sk);
+			done(data, 0);
+		} else {
+			trace_tlsh_handshake_failed(sk);
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
+	trace_tlsh_release(sock);
+
+	switch (sk->sk_family) {
+	case AF_TLSH:
+		break;
+	case AF_INET:
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+#endif
+		if (!tlsh_handshake_done(sk))
+			return tlsh_saved_sock(sk)->ops->release(sock);
+		return 0;
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
+	trace_tlsh_bind(sock);
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
+	trace_tlsh_accept(listener);
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
+	trace_tlsh_newsock(newsock, newsk);
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
+	trace_tlsh_getname(sock);
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
+	return tlsh_saved_sock(sk)->ops->getname(sock, uaddr, peer);
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
+		trace_tlsh_poll_listener(sock, mask);
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
+	trace_tlsh_poll(sock, mask);
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
+	trace_tlsh_listen(sock);
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
+	trace_tlsh_shutdown(sock);
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
+	trace_tlsh_setsockopt(sock);
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
+
+	trace_tlsh_getsockopt(sock);
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
+	return sock_common_getsockopt(sock, level, optname, optval, optlen);
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
+	int ret;
+
+	trace_tlsh_sendmsg_start(sock, size);
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		break;
+#endif
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
+	trace_tlsh_sendmsg_result(sock, ret);
+	return ret;
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
+	int ret;
+
+	trace_tlsh_recvmsg_start(sock, size);
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		break;
+#endif
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
+	trace_tlsh_recvmsg_result(sock, ret);
+	return ret;
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
+	trace_tlsh_pf_create(sock);
+	return 0;
+
+err_sk_put:
+	sock_orphan(sk);
+	sk_free(sk);	/* Ref: A (err) */
+	return rc;
+}
+
+/**
+ * tlsh_client_hello_anon -  Anonymous ClientHello for AF_TLSH
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ *
+ */
+int tlsh_client_hello_anon(struct socket *sock,
+			   void (*done)(void *data, int status), void *data,
+			   const char *priorities)
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
+	info->tsi_peerid = TLSH_NO_PEERID;
+	info->tsi_certificate = TLSH_NO_CERT;
+	info->tsi_privkey = TLSH_NO_KEY;
+	info->tsi_handshake_type = TLSH_TYPE_CLIENTHELLO_ANON;
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
+
+/**
+ * tlsh_client_hello_x509 - x.509-based ClientHello for AF_TLSH
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ * @cert: serial number of key containing client's x.509 certificate
+ * @privkey: serial number of key containing client's private key
+ *
+ */
+int tlsh_client_hello_x509(struct socket *sock,
+			   void (*done)(void *data, int status), void *data,
+			   const char *priorities, key_serial_t cert,
+			   key_serial_t privkey)
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
+	info->tsi_peerid = TLSH_NO_PEERID;
+	info->tsi_certificate = cert;
+	info->tsi_privkey = privkey;
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
+
+/**
+ * tlsh_client_hello_psk - PSK-based ClientHello for AF_TLSH
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ * @peerid: serial number of key containing TLS identity
+ *
+ */
+int tlsh_client_hello_psk(struct socket *sock,
+			  void (*done)(void *data, int status), void *data,
+			  const char *priorities, key_serial_t peerid)
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
+	info->tsi_certificate = TLSH_NO_CERT;
+	info->tsi_privkey = TLSH_NO_KEY;
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
+
+static struct genl_family __ro_after_init handshake_genl_family;
+
+static int handshake_genl_op_unsupp(struct sk_buff *skb, struct genl_info *gi)
+{
+	pr_err("Unknown netlink command (%d) ignored\n", gi->genlhdr->cmd);
+	return -EINVAL;
+}
+
+struct handshake_genl_reply {
+	int	hstype;
+	char	*priorities;
+	int	certificate;
+	int	private_key;
+	int	peerid;
+};
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
+static int handshake_genl_ch_x509_reply(struct genl_info *gi,
+					struct handshake_genl_reply *reply)
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
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE,
+			  TLSH_TYPE_CLIENTHELLO_X509);
+	if (ret < 0)
+		goto out_cancel;
+	if (reply->priorities) {
+		ret = nla_put(msg, HANDSHAKE_GENL_ATTR_PRIORITIES,
+			      strlen(reply->priorities), reply->priorities);
+		if (ret < 0)
+			goto out_cancel;
+	}
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_X509_CERT_SERIAL,
+			  reply->certificate);
+	if (ret < 0)
+		goto out_cancel;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_X509_PRIVKEY_SERIAL,
+			  reply->private_key);
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
+static int handshake_genl_ch_psk_reply(struct genl_info *gi,
+				       struct handshake_genl_reply *reply)
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
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE,
+			  TLSH_TYPE_CLIENTHELLO_PSK);
+	if (ret < 0)
+		goto out_cancel;
+	if (reply->priorities) {
+		ret = nla_put(msg, HANDSHAKE_GENL_ATTR_PRIORITIES,
+			      strlen(reply->priorities), reply->priorities);
+		if (ret < 0)
+			goto out_cancel;
+	}
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_PSK_SERIAL, reply->peerid);
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
+static int handshake_genl_ch_anon_reply(struct genl_info *gi,
+					struct handshake_genl_reply *reply)
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
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE,
+			  TLSH_TYPE_CLIENTHELLO_ANON);
+	if (ret < 0)
+		goto out_cancel;
+	if (reply->priorities) {
+		ret = nla_put(msg, HANDSHAKE_GENL_ATTR_PRIORITIES,
+			      strlen(reply->priorities), reply->priorities);
+		if (ret < 0)
+			goto out_cancel;
+	}
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
+/*
+ * Return the handshake parameters that were requested for the SOCKFD.
+ */
+static int handshake_genl_op_get_fd_parms(struct sk_buff *skb, struct genl_info *gi)
+{
+	struct handshake_genl_reply reply = {
+		.priorities	= NULL,
+	};
+	struct tlsh_sock_info *tsi;
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
+	tsi = sk->sk_tlsh_priv;
+	if (!tsi) {
+		write_unlock_bh(&sk->sk_callback_lock);
+		sockfd_put(sock);
+		return handshake_genl_error_reply(gi, HANDSHAKE_GENL_STATUS_SOCKNOTVALID);
+	}
+	reply.hstype = tsi->tsi_handshake_type;
+	reply.priorities = tsi->tsi_tls_priorities;
+	reply.certificate = tsi->tsi_certificate;
+	reply.private_key = tsi->tsi_privkey;
+	reply.peerid = tsi->tsi_peerid;
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	/* Consumer's requested handshake type determines returned parameters. */
+	switch (reply.hstype) {
+	case TLSH_TYPE_CLIENTHELLO_X509:
+		ret = handshake_genl_ch_x509_reply(gi, &reply);
+		break;
+	case TLSH_TYPE_CLIENTHELLO_PSK:
+		ret = handshake_genl_ch_psk_reply(gi, &reply);
+		break;
+	case TLSH_TYPE_CLIENTHELLO_ANON:
+		ret = handshake_genl_ch_anon_reply(gi, &reply);
+		break;
+	default:
+		ret = handshake_genl_error_reply(gi, HANDSHAKE_GENL_STATUS_INVAL);
+	}
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
+	[HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_PRIORITIES] = {
+		.type = NLA_STRING
+	},
+	[HANDSHAKE_GENL_ATTR_X509_CERT_SERIAL] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_X509_PRIVKEY_SERIAL] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_PSK_SERIAL] = {
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
+int __init tlsh_genetlink_init(void)
+{
+	return genl_register_family(&handshake_genl_family);
+}
+
+void tlsh_genetlink_exit(void)
+{
+	genl_unregister_family(&handshake_genl_family);
+}
diff --git a/net/tls/tls.h b/net/tls/tls.h
index 0e840a0c3437..99fa4d2f9347 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -83,6 +83,21 @@ struct tls_context *tls_ctx_create(struct sock *sk);
 void tls_ctx_free(struct sock *sk, struct tls_context *ctx);
 void update_sk_prot(struct sock *sk, struct tls_context *ctx);
 
+int tlsh_genetlink_init(void);
+void tlsh_genetlink_exit(void);
+int tlsh_pf_create(struct net *net, struct socket *sock, int protocol,
+		   int kern);
+int tlsh_client_hello_anon(struct socket *sock,
+			   void (*done)(void *data, int status), void *data,
+			   const char *priorities);
+int tlsh_client_hello_x509(struct socket *sock,
+			   void (*done)(void *data, int status), void *data,
+			   const char *priorities, key_serial_t cert,
+			   key_serial_t privkey);
+int tlsh_client_hello_psk(struct socket *sock,
+			  void (*done)(void *data, int status), void *data,
+			  const char *priorities, key_serial_t peerid);
+
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 int tls_sk_query(struct sock *sk, int optname, char __user *optval,
 		 int __user *optlen);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 3735cb00905d..14d20b0ffa98 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -51,6 +51,7 @@ MODULE_AUTHOR("Mellanox Technologies");
 MODULE_DESCRIPTION("Transport Layer Security Support");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS_TCP_ULP("tls");
+MODULE_ALIAS_NETPROTO(PF_TLSH);
 
 enum {
 	TLSV4,
@@ -1216,14 +1217,24 @@ static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
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
 
-	err = register_pernet_subsys(&tls_proc_ops);
+	err = tlsh_genetlink_init();
 	if (err)
 		return err;
 
+	err = register_pernet_subsys(&tls_proc_ops);
+	if (err)
+		goto err_genetlink;
+
 	err = tls_strp_dev_init();
 	if (err)
 		goto err_pernet;
@@ -1234,20 +1245,26 @@ static int __init tls_register(void)
 
 	tcp_register_ulp(&tcp_tls_ulp_ops);
 
+	sock_register(&tlsh_pf_ops);
+
 	return 0;
 err_strp:
 	tls_strp_dev_exit();
 err_pernet:
 	unregister_pernet_subsys(&tls_proc_ops);
+err_genetlink:
+	tlsh_genetlink_exit();
 	return err;
 }
 
 static void __exit tls_unregister(void)
 {
+	sock_unregister(PF_TLSH);
 	tcp_unregister_ulp(&tcp_tls_ulp_ops);
 	tls_strp_dev_exit();
 	tls_device_cleanup();
 	unregister_pernet_subsys(&tls_proc_ops);
+	tlsh_genetlink_exit();
 }
 
 module_init(tls_register);
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
index 9ba5f600ea43..391ec226b7ac 100644
--- a/net/tls/trace.h
+++ b/net/tls/trace.h
@@ -12,6 +12,55 @@
 
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
 TRACE_EVENT(tls_device_offload_set,
 
 	TP_PROTO(struct sock *sk, int dir, u32 tcp_seq, u8 *rec_no, int ret),
@@ -192,6 +241,298 @@ TRACE_EVENT(tls_device_tx_resync_send,
 	)
 );
 
+DECLARE_EVENT_CLASS(tlsh_listener_class,
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
+		__entry->family = tlsh_sk((struct sock *)sk)->th_bind_family;
+	),
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
+	TP_printk("sock=%p sk=%p(%d) mask=%s",
+		__entry->sock, __entry->sk, __entry->refcount,
+		show_poll_event_mask(__entry->mask)
+	)
+);
+
+DECLARE_EVENT_CLASS(tlsh_handshake_done_class,
+	TP_PROTO(const struct sock *sk),
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


