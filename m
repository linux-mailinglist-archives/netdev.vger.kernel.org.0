Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A4C69846E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBOTXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBOTXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:23:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4099C3E628
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4468B8238A
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 19:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B260FC433EF;
        Wed, 15 Feb 2023 19:23:22 +0000 (UTC)
Subject: [PATCH v4 2/2] net/tls: Add kernel APIs for requesting a TLSv1.3
 handshake
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, chuck.lever@oracle.com, hare@suse.com,
        dhowells@redhat.com, bcodding@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com
Date:   Wed, 15 Feb 2023 14:23:21 -0500
Message-ID: <167648900159.5586.16453341470397436865.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167648817566.5586.11847329328944648217.stgit@91.116.238.104.host.secureserver.net>
References: <167648817566.5586.11847329328944648217.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To enable kernel consumers of TLS to request a TLS handshake, add
support to net/tls/ to send a handshake upcall. This patch also
acts as a template for adding handshake upcall support to other
transport layer security mechanisms.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 Documentation/networking/index.rst         |    1 
 Documentation/networking/tls-handshake.rst |  146 +++++++++++
 include/net/tls.h                          |   23 ++
 include/uapi/linux/handshake.h             |   44 +++
 net/handshake/netlink.c                    |    3 
 net/tls/Makefile                           |    2 
 net/tls/tls_handshake.c                    |  388 ++++++++++++++++++++++++++++
 7 files changed, 606 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/tls-handshake.rst
 create mode 100644 net/tls/tls_handshake.c

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 16a153bcc5fe..93ffa0ceac8f 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -36,6 +36,7 @@ Contents:
    scaling
    tls
    tls-offload
+   tls-handshake
    nfc
    6lowpan
    6pack
diff --git a/Documentation/networking/tls-handshake.rst b/Documentation/networking/tls-handshake.rst
new file mode 100644
index 000000000000..f09fc6c09580
--- /dev/null
+++ b/Documentation/networking/tls-handshake.rst
@@ -0,0 +1,146 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================
+In-Kernel TLS Handshake
+=======================
+
+Overview
+========
+
+Transport Layer Security (TLS) is a Upper Layer Protocol (ULP) that runs
+over TCP. TLS provides end-to-end data integrity and confidentiality,
+in addition to peer authentication.
+
+The kernel's kTLS implementation handles the TLS record subprotocol, but
+does not handle the TLS handshake subprotocol which is used to establish
+a TLS session. Kernel consumers can use the API described here to
+request TLS session establishment.
+
+There are several possible ways to provide a handshake service in the
+kernel. The API described here is designed to hide the details of those
+implementations so that in-kernel TLS consumers do not need to be
+aware of how the handshake gets done.
+
+
+User handshake agent
+====================
+
+As of this writing, there is no TLS handshake implementation in the
+Linux kernel. Thus, with the current implementation, a user agent is
+started in each network namespace where a kernel consumer might require
+a TLS handshake. This agent listens for events sent from the kernel
+that request a handshake on an open and connected TCP socket.
+
+The open socket is passed to user space via a netlink operation, which
+creates a socket descriptor in the agent's file descriptor table. If the
+handshake completes successfully, the user agent promotes the socket to
+use the TLS ULP and sets the session information using the SOL_TLS socket
+options. The user agent returns the socket to the kernel via a second
+netlink operation.
+
+
+Kernel Handshake API
+====================
+
+A kernel TLS consumer initiates a client-side TLS handshake on an open
+socket by invoking one of the tls_client_hello() functions. For example:
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
+The @sock argument is an open and connected socket. The caller must hold
+a reference on the socket to prevent it from being destroyed while the
+handshake is in progress.
+
+@done_func and @cookie are a callback function that is invoked when the
+handshake has completed. The success status of the handshake is returned
+via the @status parameter of the callback function. A good practice is
+to close and destroy the socket immediately if the handshake has failed.
+
+@priorities is a GnuTLS priorities string that controls the handshake.
+The special value TLS_DEFAULT_PRIORITIES causes the handshake to
+operate using default TLS priorities. However, the caller can use the
+string to (for example) adjust the handshake to use a restricted set
+of ciphers (say, if the kernel consumer wishes to mandate only a
+limited set of ciphers).
+
+@cert is the serial number of a key that contains a DER format x.509
+certificate that the handshake agent presents to the remote as the local
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
+The handshake agent presents no peer identity information to the
+remote during the handshake. Only server authentication is performed
+during the handshake. Thus the established session uses encryption
+only.
+
+
+Consumers that are in-kernel servers use:
+
+.. code-block:: c
+
+  ret = tls_server_hello(sock, done_func, cookie, priorities);
+
+The parameters for this operation are as above.
+
+
+Lastly, if the consumer needs to cancel the handshake request, say,
+due to a ^C or other exigent event, the handshake core provides
+this API:
+
+.. code-block:: c
+
+  handshake_cancel(sock);
+
+
+Other considerations
+--------------------
+
+While a handshake is under way, the kernel consumer must alter the
+socket's sk_data_ready callback function to ignore all incoming data.
+Once the handshake completion callback function has been invoked,
+normal receive operation can be resumed.
+
+Once a TLS session is established, the consumer must provide a buffer
+for and then examine the control message (CMSG) that is part of every
+subsequent sock_recvmsg(). Each control message indicates whether the
+received message data is TLS record data or session metadata.
+
+See tls.rst for details on how a kTLS consumer recognizes incoming
+(decrypted) application data, alerts, and handshake packets once the
+socket has been promoted to use the TLS ULP.
+
diff --git a/include/net/tls.h b/include/net/tls.h
index 154949c7b0c8..fe9986c3bced 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -512,4 +512,27 @@ static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
 	return tls_get_ctx(sk)->rx_conf == TLS_HW;
 }
 #endif
+
+#define TLS_DEFAULT_PRIORITIES		(NULL)
+
+enum {
+	TLS_NO_PEERID = 0,
+	TLS_NO_CERT = 0,
+	TLS_NO_PRIVKEY = 0,
+};
+
+typedef void	(*tls_done_func_t)(void *data, int status,
+				   key_serial_t peerid);
+
+int tls_client_hello_anon(struct socket *sock, tls_done_func_t done,
+			  void *data, const char *priorities);
+int tls_client_hello_x509(struct socket *sock, tls_done_func_t done,
+			  void *data, const char *priorities,
+			  key_serial_t cert, key_serial_t privkey);
+int tls_client_hello_psk(struct socket *sock, tls_done_func_t done,
+			 void *data, const char *priorities,
+			 key_serial_t peerid);
+int tls_server_hello(struct socket *sock, tls_done_func_t done,
+		     void *data, const char *priorities);
+
 #endif /* _TLS_OFFLOAD_H */
diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
index 9544edeb181f..33c417cadfcb 100644
--- a/include/uapi/linux/handshake.h
+++ b/include/uapi/linux/handshake.h
@@ -21,9 +21,11 @@
 
 enum handshake_genl_mcgrps {
 	HANDSHAKE_GENL_MCGRP_NONE = 0,
+	HANDSHAKE_GENL_MCGRP_TLS,
 };
 
 #define HANDSHAKE_GENL_MCGRP_NONE_NAME	"none"
+#define HANDSHAKE_GENL_MCGRP_TLS_NAME	"tls"
 
 enum handshake_genl_cmds {
 	HANDSHAKE_GENL_CMD_UNSPEC = 0,
@@ -49,8 +51,50 @@ enum handshake_genl_attrs {
 };
 #define HANDSHAKE_GENL_ATTR_MAX	(__HANDSHAKE_GENL_ATTR_MAX - 1)
 
+
+/*
+ * Items specific to TLSv1.3 handshakes
+ */
+
+enum handshake_tls_accept_attrs {
+	HANDSHAKE_GENL_ATTR_TLS_ACCEPT_UNSPEC = 0,
+	HANDSHAKE_GENL_ATTR_TLS_TYPE,
+	HANDSHAKE_GENL_ATTR_TLS_AUTH,
+	HANDSHAKE_GENL_ATTR_TLS_PRIORITIES,
+	HANDSHAKE_GENL_ATTR_TLS_X509_CERT,
+	HANDSHAKE_GENL_ATTR_TLS_X509_PRIVKEY,
+	HANDSHAKE_GENL_ATTR_TLS_PSK,
+
+	__HANDSHAKE_GENL_ATTR_TLS_ACCEPT_MAX
+};
+#define HANDSHAKE_GENL_ATTR_TLS_ACCEPT_MAX \
+	(__HANDSHAKE_GENL_ATTR_TLS_ACCEPT_MAX - 1)
+
+enum handshake_tls_done_attrs {
+	HANDSHAKE_GENL_ATTR_TLS_DONE_UNSPEC = 0,
+	HANDSHAKE_GENL_ATTR_TLS_REMOTE_PEERID,
+
+	__HANDSHAKE_GENL_ATTR_TLS_DONE_MAX
+};
+#define HANDSHAKE_GENL_ATTR_TLS_DONE_MAX \
+	(__HANDSHAKE_GENL_ATTR_TLS_DONE_MAX - 1)
+
 enum handshake_genl_protocol {
 	HANDSHAKE_GENL_PROTO_UNSPEC = 0,
+	HANDSHAKE_GENL_PROTO_TLS,
+};
+
+enum handshake_genl_tls_type {
+	HANDSHAKE_GENL_TLS_TYPE_UNSPEC = 0,
+	HANDSHAKE_GENL_TLS_TYPE_CLIENTHELLO,
+	HANDSHAKE_GENL_TLS_TYPE_SERVERHELLO,
+};
+
+enum handshake_genl_tls_auth {
+	HANDSHAKE_GENL_TLS_AUTH_UNSPEC = 0,
+	HANDSHAKE_GENL_TLS_AUTH_UNAUTH,
+	HANDSHAKE_GENL_TLS_AUTH_X509,
+	HANDSHAKE_GENL_TLS_AUTH_PSK,
 };
 
 #endif /* _UAPI_LINUX_HANDSHAKE_H */
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 8d0bf11396a7..16023ddc3d49 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -288,6 +288,9 @@ static const struct genl_multicast_group handshake_genl_mcgrps[] = {
 	[HANDSHAKE_GENL_MCGRP_NONE] = {
 		.name		= HANDSHAKE_GENL_MCGRP_NONE_NAME,
 	},
+	[HANDSHAKE_GENL_MCGRP_TLS] = {
+		.name		= HANDSHAKE_GENL_MCGRP_TLS_NAME,
+	},
 };
 
 static struct genl_family __ro_after_init handshake_genl_family = {
diff --git a/net/tls/Makefile b/net/tls/Makefile
index e41c800489ac..7e56b57f14f6 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -7,7 +7,7 @@ CFLAGS_trace.o := -I$(src)
 
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
+tls-y := tls_handshake.o tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
 
 tls-$(CONFIG_TLS_TOE) += tls_toe.o
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/tls_handshake.c b/net/tls/tls_handshake.c
new file mode 100644
index 000000000000..007308727395
--- /dev/null
+++ b/net/tls/tls_handshake.c
@@ -0,0 +1,388 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Establish a TLS session for a kernel socket consumer
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2021-2023, Oracle and/or its affiliates.
+ */
+
+#include <linux/types.h>
+#include <linux/socket.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <net/sock.h>
+#include <net/tls.h>
+#include <net/genetlink.h>
+#include <net/handshake.h>
+
+#include <uapi/linux/handshake.h>
+
+/*
+ * TLS priorities string passed to the GnuTLS library.
+ *
+ * Specifically for kernel TLS consumers: enable only TLS v1.3 and the
+ * ciphers that are supported by kTLS.
+ *
+ * Currently this list is generated by hand from the supported ciphers
+ * found in include/uapi/linux/tls.h.
+ */
+#define KTLS_DEFAULT_PRIORITIES \
+	"SECURE256:+SECURE128:-COMP-ALL" \
+	":-VERS-ALL:+VERS-TLS1.3:%NO_TICKETS" \
+	":-CIPHER-ALL:+CHACHA20-POLY1305:+AES-256-GCM:+AES-128-GCM:+AES-128-CCM"
+
+struct tls_handshake_req {
+	void			(*th_consumer_done)(void *data, int status,
+						    key_serial_t peerid);
+	void			*th_consumer_data;
+
+	const char		*th_priorities;
+	int			th_type;
+	int			th_auth_type;
+	key_serial_t		th_peerid;
+	key_serial_t		th_certificate;
+	key_serial_t		th_privkey;
+
+};
+
+static const char *tls_handshake_dup_priorities(const char *priorities,
+						gfp_t flags)
+{
+	const char *tp;
+
+	if (priorities != TLS_DEFAULT_PRIORITIES && strlen(priorities))
+		tp = priorities;
+	else
+		tp = KTLS_DEFAULT_PRIORITIES;
+	return kstrdup(tp, flags);
+}
+
+static struct tls_handshake_req *
+tls_handshake_req_init(struct handshake_req *req, tls_done_func_t done,
+		       void *data, const char *priorities)
+{
+	struct tls_handshake_req *treq = handshake_req_private(req);
+
+	treq->th_consumer_done = done;
+	treq->th_consumer_data = data;
+	treq->th_priorities = priorities;
+	treq->th_peerid = TLS_NO_PEERID;
+	treq->th_certificate = TLS_NO_CERT;
+	treq->th_privkey = TLS_NO_PRIVKEY;
+	return treq;
+}
+
+/**
+ * tls_handshake_destroy - callback to release a handshake request
+ * @req: handshake parameters to release
+ *
+ */
+static void tls_handshake_destroy(struct handshake_req *req)
+{
+	struct tls_handshake_req *treq = handshake_req_private(req);
+
+	kfree(treq->th_priorities);
+}
+
+static const struct nla_policy
+handshake_tls_done_policy[HANDSHAKE_GENL_ATTR_TLS_DONE_MAX + 1] = {
+	[HANDSHAKE_GENL_ATTR_TLS_REMOTE_PEERID] = {
+		.type = NLA_U32
+	},
+};
+
+/**
+ * tls_handshake_done - callback to handle a CMD_DONE request
+ * @req: socket on which the handshake was performed
+ * @status: session status code
+ * @args: nested attribute for CMD_DONE
+ *
+ * Eventually this will return information about the established
+ * session: whether it is authenticated, and if so, who the remote
+ * is.
+ */
+static void tls_handshake_done(struct handshake_req *req, int status,
+			       struct nlattr *args)
+{
+	struct tls_handshake_req *treq = handshake_req_private(req);
+	struct nlattr *tb[HANDSHAKE_GENL_ATTR_TLS_DONE_MAX + 1];
+	key_serial_t peerid;
+	int err;
+
+	peerid = TLS_NO_PEERID;
+	if (args) {
+		err = nla_parse_nested(tb, HANDSHAKE_GENL_ATTR_TLS_DONE_MAX,
+				       args, handshake_tls_done_policy, NULL);
+		if (err || !tb[HANDSHAKE_GENL_ATTR_TLS_REMOTE_PEERID])
+			goto out;
+		peerid = nla_get_u32(tb[HANDSHAKE_GENL_ATTR_TLS_REMOTE_PEERID]);
+	}
+
+out:
+	treq->th_consumer_done(treq->th_consumer_data, status, peerid);
+}
+
+static int tls_handshake_put_accept_resp(struct sk_buff *msg,
+					 struct tls_handshake_req *treq)
+{
+	struct nlattr *entry_attr;
+	int ret;
+
+	ret = -EMSGSIZE;
+	entry_attr = nla_nest_start(msg, HANDSHAKE_GENL_ATTR_ACCEPT);
+	if (!entry_attr)
+		goto out;
+
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_TLS_TYPE,
+			  HANDSHAKE_GENL_TLS_TYPE_CLIENTHELLO);
+	if (ret < 0)
+		goto out;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_TLS_AUTH,
+			  treq->th_auth_type);
+	if (ret < 0)
+		goto out;
+	if (treq->th_certificate != TLS_NO_CERT) {
+		ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_TLS_X509_CERT,
+				  treq->th_certificate);
+		if (ret < 0)
+			goto out;
+	}
+	if (treq->th_privkey != TLS_NO_PRIVKEY) {
+		ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_TLS_X509_PRIVKEY,
+				  treq->th_privkey);
+		if (ret < 0)
+			goto out;
+	}
+	if (treq->th_peerid != TLS_NO_PEERID) {
+		ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_TLS_PSK,
+				  treq->th_peerid);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = nla_put_string(msg, HANDSHAKE_GENL_ATTR_TLS_PRIORITIES,
+			     treq->th_priorities);
+	if (ret < 0)
+		goto out;
+
+	nla_nest_end(msg, entry_attr);
+	ret = 0;
+
+out:
+	return ret;
+}
+
+/**
+ * tls_handshake_accept - callback to construct a CMD_ACCEPT response
+ * @req: handshake parameters to return
+ * @gi: generic netlink message context
+ * @fd: file descriptor to be returned
+ *
+ * Returns zero on success, or a negative errno on failure.
+ */
+static int tls_handshake_accept(struct handshake_req *req,
+				struct genl_info *gi, int fd)
+{
+	struct tls_handshake_req *treq = handshake_req_private(req);
+	struct nlmsghdr *hdr;
+	struct sk_buff *msg;
+	int ret;
+
+	ret = -ENOMEM;
+	msg = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		goto out;
+	hdr = handshake_genl_put(msg, gi);
+	if (!hdr)
+		goto out_cancel;
+
+	ret = -EMSGSIZE;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_SOCKFD, fd);
+	if (ret < 0)
+		goto out_cancel;
+
+	ret = tls_handshake_put_accept_resp(msg, treq);
+	if (ret < 0)
+		goto out_cancel;
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, gi);
+
+out_cancel:
+	genlmsg_cancel(msg, hdr);
+out:
+	return ret;
+}
+
+static const struct handshake_proto tls_handshake_proto = {
+	.hp_protocol		= HANDSHAKE_GENL_PROTO_TLS,
+	.hp_mcgrp		= HANDSHAKE_GENL_MCGRP_TLS,
+	.hp_privsize		= sizeof(struct tls_handshake_req),
+
+	.hp_accept		= tls_handshake_accept,
+	.hp_done		= tls_handshake_done,
+	.hp_destroy		= tls_handshake_destroy,
+};
+
+/**
+ * tls_client_hello_anon - request an anonymous TLS handshake on a socket
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string, or NULL
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ENOENT: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_anon(struct socket *sock, tls_done_func_t done,
+			  void *data, const char *priorities)
+{
+	struct tls_handshake_req *treq;
+	struct handshake_req *req;
+	gfp_t flags = GFP_NOWAIT;
+	const char *tp;
+
+	tp = tls_handshake_dup_priorities(priorities, flags);
+	if (!tp)
+		return -ENOMEM;
+
+	req = handshake_req_alloc(sock, &tls_handshake_proto, flags);
+	if (!req) {
+		kfree(tp);
+		return -ENOMEM;
+	}
+
+	treq = tls_handshake_req_init(req, done, data, tp);
+	treq->th_type = HANDSHAKE_GENL_TLS_TYPE_CLIENTHELLO;
+	treq->th_auth_type = HANDSHAKE_GENL_TLS_AUTH_UNAUTH;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_client_hello_anon);
+
+/**
+ * tls_client_hello_x509 - request an x.509-based TLS handshake on a socket
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ * @cert: serial number of key containing client's x.509 certificate
+ * @privkey: serial number of key containing client's private key
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ENOENT: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_x509(struct socket *sock, tls_done_func_t done,
+			  void *data, const char *priorities,
+			  key_serial_t cert, key_serial_t privkey)
+{
+	struct tls_handshake_req *treq;
+	struct handshake_req *req;
+	gfp_t flags = GFP_NOWAIT;
+	const char *tp;
+
+	tp = tls_handshake_dup_priorities(priorities, flags);
+	if (!tp)
+		return -ENOMEM;
+
+	req = handshake_req_alloc(sock, &tls_handshake_proto, flags);
+	if (!req) {
+		kfree(tp);
+		return -ENOMEM;
+	}
+
+	treq = tls_handshake_req_init(req, done, data, tp);
+	treq->th_type = HANDSHAKE_GENL_TLS_TYPE_CLIENTHELLO;
+	treq->th_auth_type = HANDSHAKE_GENL_TLS_AUTH_X509;
+	treq->th_certificate = cert;
+	treq->th_privkey = privkey;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_client_hello_x509);
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
+int tls_client_hello_psk(struct socket *sock, tls_done_func_t done,
+			 void *data, const char *priorities,
+			 key_serial_t peerid)
+{
+	struct tls_handshake_req *treq;
+	struct handshake_req *req;
+	gfp_t flags = GFP_NOWAIT;
+	const char *tp;
+
+	tp = tls_handshake_dup_priorities(priorities, flags);
+	if (!tp)
+		return -ENOMEM;
+
+	req = handshake_req_alloc(sock, &tls_handshake_proto, flags);
+	if (!req) {
+		kfree(tp);
+		return -ENOMEM;
+	}
+
+	treq = tls_handshake_req_init(req, done, data, tp);
+	treq->th_type = HANDSHAKE_GENL_TLS_TYPE_CLIENTHELLO;
+	treq->th_auth_type = HANDSHAKE_GENL_TLS_AUTH_PSK;
+	treq->th_peerid = peerid;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_client_hello_psk);
+
+/**
+ * tls_server_hello - request a server TLS handshake on a socket
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ENOENT: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_server_hello(struct socket *sock, tls_done_func_t done,
+		     void *data, const char *priorities)
+{
+	struct tls_handshake_req *treq;
+	struct handshake_req *req;
+	gfp_t flags = GFP_KERNEL;
+	const char *tp;
+
+	tp = tls_handshake_dup_priorities(priorities, flags);
+	if (!tp)
+		return -ENOMEM;
+
+	req = handshake_req_alloc(sock, &tls_handshake_proto, flags);
+	if (!req) {
+		kfree(tp);
+		return -ENOMEM;
+	}
+
+	treq = tls_handshake_req_init(req, done, data, tp);
+	treq->th_type = HANDSHAKE_GENL_TLS_TYPE_SERVERHELLO;
+	treq->th_auth_type = HANDSHAKE_GENL_TLS_AUTH_UNSPEC;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_server_hello);


