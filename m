Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330D06A2249
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjBXTTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjBXTTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:19:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CA22D65
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:19:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED310B81D06
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 19:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211B8C433EF;
        Fri, 24 Feb 2023 19:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677266367;
        bh=GhbOXcU/L7arymS2c7ZanTKoK/X5WJ24AmVtBf5n0GU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GBUWo/sSoNSzrgJEMsYg0GaZcM/u+pzDly6avWq2CBBdWN2TqvsDxCim9it/eyldy
         LME/rJMAA74Uf4TSg6PHJeBQyBcTJma5xT01whC8Cv66n7quWlFLRNCstgPdSfUf4E
         Mfz/GxtpNytFYlTH1/XgXvjR6YexoyGKtO4V2bN83Qc+/PSE8eNRGMnWl/5+Qywdp7
         LbONQ2J3Kr/Kp2Pzr+/yFe9zqRjgrZTcu0n2QcROxO966TJMuI1l4L0gRQFp1ZePb9
         AtSfcZzDuo2Wm7rQgfmewip/LkyvWFLzGFEfr4eZ6pBzBSQzvhm9y6ltYvODBwIJKx
         Uk8Ejx6okn3+A==
Subject: [PATCH v5 2/2] net/tls: Add kernel APIs for requesting a TLSv1.3
 handshake
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev
Date:   Fri, 24 Feb 2023 14:19:26 -0500
Message-ID: <167726636603.5428.10993498628206909067.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

To enable kernel consumers of TLS to request a TLS handshake, add
support to net/tls/ to send a handshake upcall. This patch also
acts as a template for adding handshake upcall support to other
transport layer security mechanisms.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 Documentation/netlink/specs/handshake.yaml |    4 
 Documentation/networking/index.rst         |    1 
 Documentation/networking/tls-handshake.rst |  146 ++++++++++
 include/net/tls.h                          |   27 ++
 include/uapi/linux/handshake.h             |    2 
 net/handshake/netlink.c                    |    1 
 net/tls/Makefile                           |    2 
 net/tls/tls_handshake.c                    |  423 ++++++++++++++++++++++++++++
 8 files changed, 604 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/tls-handshake.rst
 create mode 100644 net/tls/tls_handshake.c

diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/netlink/specs/handshake.yaml
index 683a8f2df0a7..c2f6bfff2326 100644
--- a/Documentation/netlink/specs/handshake.yaml
+++ b/Documentation/netlink/specs/handshake.yaml
@@ -21,7 +21,7 @@ definitions:
     name: handler-class
     enum-name:
     value-start: 0
-    entries: [ none ]
+    entries: [ none, tlshd ]
   -
     type: enum
     name: msg-type
@@ -132,3 +132,5 @@ mcast-groups:
   list:
     -
       name: none
+    -
+      name: tlshd
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4ddcae33c336..189517f4ea96 100644
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
index 154949c7b0c8..505b23992ef0 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -512,4 +512,31 @@ static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
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
+int tls_server_hello_x509(struct socket *sock, tls_done_func_t done,
+			  void *data, const char *priorities);
+int tls_server_hello_psk(struct socket *sock, tls_done_func_t done,
+			 void *data, const char *priorities);
+
+int tls_handshake_cancel(struct socket *sock);
+
 #endif /* _TLS_OFFLOAD_H */
diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
index 09fd7c37cba4..dad8227939a1 100644
--- a/include/uapi/linux/handshake.h
+++ b/include/uapi/linux/handshake.h
@@ -11,6 +11,7 @@
 
 enum {
 	HANDSHAKE_HANDLER_CLASS_NONE,
+	HANDSHAKE_HANDLER_CLASS_TLSHD,
 };
 
 enum {
@@ -59,5 +60,6 @@ enum {
 };
 
 #define HANDSHAKE_MCGRP_NONE	"none"
+#define HANDSHAKE_MCGRP_TLSHD	"tlshd"
 
 #endif /* _UAPI_LINUX_HANDSHAKE_H */
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 581e382236cf..88775f784305 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -255,6 +255,7 @@ static const struct genl_split_ops handshake_nl_ops[] = {
 
 static const struct genl_multicast_group handshake_nl_mcgrps[] = {
 	[HANDSHAKE_HANDLER_CLASS_NONE] = { .name = HANDSHAKE_MCGRP_NONE, },
+	[HANDSHAKE_HANDLER_CLASS_TLSHD] = { .name = HANDSHAKE_MCGRP_TLSHD, },
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
index 000000000000..74d32a9ca857
--- /dev/null
+++ b/net/tls/tls_handshake.c
@@ -0,0 +1,423 @@
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
+/**
+ * tls_handshake_done - callback to handle a CMD_DONE request
+ * @req: socket on which the handshake was performed
+ * @status: session status code
+ * @tb: other results of session establishment
+ *
+ * Eventually this will return information about the established
+ * session: whether it is authenticated, and if so, who the remote
+ * is.
+ */
+static void tls_handshake_done(struct handshake_req *req, int status,
+			       struct nlattr **tb)
+{
+	struct tls_handshake_req *treq = handshake_req_private(req);
+	key_serial_t peerid = TLS_NO_PEERID;
+
+	if (tb[HANDSHAKE_A_DONE_REMOTE_PEERID])
+		peerid = nla_get_u32(tb[HANDSHAKE_A_DONE_REMOTE_PEERID]);
+
+	treq->th_consumer_done(treq->th_consumer_data, status, peerid);
+}
+
+static int tls_handshake_put_accept_resp(struct sk_buff *msg,
+					 struct tls_handshake_req *treq)
+{
+	int ret;
+
+	ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MESSAGE_TYPE, treq->th_type);
+	if (ret < 0)
+		goto out;
+	ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_AUTH, treq->th_auth_type);
+	if (ret < 0)
+		goto out;
+	switch (treq->th_auth_type) {
+	case HANDSHAKE_AUTH_X509:
+		if (treq->th_certificate != TLS_NO_CERT) {
+			ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MY_PEERID,
+					  treq->th_certificate);
+			if (ret < 0)
+				goto out;
+		}
+		if (treq->th_privkey != TLS_NO_PRIVKEY) {
+			ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MY_PRIVKEY,
+					  treq->th_privkey);
+			if (ret < 0)
+				goto out;
+		}
+		break;
+	case HANDSHAKE_AUTH_PSK:
+		if (treq->th_peerid != TLS_NO_PEERID) {
+			ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MY_PEERID,
+					  treq->th_peerid);
+			if (ret < 0)
+				goto out;
+		}
+		break;
+	}
+
+	ret = nla_put_string(msg, HANDSHAKE_A_ACCEPT_GNUTLS_PRIORITIES,
+			     treq->th_priorities);
+	if (ret < 0)
+		goto out;
+
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
+	ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_SOCKFD, fd);
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
+	.hp_handler_class	= HANDSHAKE_HANDLER_CLASS_TLSHD,
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
+	treq->th_type = HANDSHAKE_MSG_TYPE_CLIENTHELLO;
+	treq->th_auth_type = HANDSHAKE_AUTH_UNAUTH;
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
+	treq->th_type = HANDSHAKE_MSG_TYPE_CLIENTHELLO;
+	treq->th_auth_type = HANDSHAKE_AUTH_X509;
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
+	treq->th_type = HANDSHAKE_MSG_TYPE_CLIENTHELLO;
+	treq->th_auth_type = HANDSHAKE_AUTH_PSK;
+	treq->th_peerid = peerid;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_client_hello_psk);
+
+/**
+ * tls_server_hello_x509 - request a server TLS handshake on a socket
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
+int tls_server_hello_x509(struct socket *sock, tls_done_func_t done,
+			  void *data, const char *priorities)
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
+	treq->th_type = HANDSHAKE_MSG_TYPE_SERVERHELLO;
+	treq->th_auth_type = HANDSHAKE_AUTH_X509;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_server_hello_x509);
+
+/**
+ * tls_server_hello_psk - request a server TLS handshake on a socket
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
+int tls_server_hello_psk(struct socket *sock, tls_done_func_t done,
+			 void *data, const char *priorities)
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
+	treq->th_type = HANDSHAKE_MSG_TYPE_SERVERHELLO;
+	treq->th_auth_type = HANDSHAKE_AUTH_PSK;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_server_hello_psk);
+
+/**
+ * tls_handshake_cancel - cancel a pending handshake
+ * @sock: socket on which there is an ongoing handshake
+ *
+ * Request cancellation races with request completion. To determine
+ * who won, callers examine the return value from this function.
+ *
+ * Return values:
+ *   %0 - Uncompleted handshake request was canceled
+ *   %-EBUSY - Handshake request already completed
+ */
+int tls_handshake_cancel(struct socket *sock)
+{
+	return handshake_req_cancel(sock);
+}
+EXPORT_SYMBOL(tls_handshake_cancel);


