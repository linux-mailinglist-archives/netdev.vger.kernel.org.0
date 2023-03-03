Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81756A9F94
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjCCSvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjCCSvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:51:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DFB17152
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 10:51:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2707B819B8
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 18:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEB3C433D2;
        Fri,  3 Mar 2023 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677869499;
        bh=mV5KmV+nr9dk2WwInFWUZLYKKGSS9q7e/GT/xpGVYZc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mCQ8QJ0a/ZwQmLev6X58LUqxkTL6+MkTKX9Op+vJ2dJjDEICkoxdsY7kpSpKLm0xe
         yKs7xEY8quPjfuLjaKKyKCIQ0dM/XBKAwvh1CxRpHTrv7mCB94/6atmU7kbrQZZc8M
         zJMnBVqlXJ9uOLvv7/kEFqMgZa4IuKJLRBEDIimY0sCma6p812/sCxKNkO61vnssg7
         70U5K85BL+w9B3Kw56KvIVt3magGzd4zsZMtGcMrGR9w6T+/1Mw/KxQsP4LCUYl/pZ
         /HJiRGdzNmLqOF0HDdWKLCVO0g5L3vBBaNS0M0rRaxJV0UicwxsA+XuSoxE8AtquZo
         +BXs5cRWf0AXA==
Subject: [PATCH v6 2/2] net/tls: Add kernel APIs for requesting a TLSv1.3
 handshake
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Fri, 03 Mar 2023 13:51:38 -0500
Message-ID: <167786949822.7199.14892713296931249747.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

To enable kernel consumers of TLS to request a TLS handshake, add
support to net/tls/ to request a handshake upcall.

This patch also acts as a template for adding handshake upcall
support to other kernel transport layer security providers.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 Documentation/netlink/specs/handshake.yaml |    4 
 Documentation/networking/index.rst         |    1 
 Documentation/networking/tls-handshake.rst |  219 ++++++++++++++++
 include/net/tls.h                          |   29 ++
 include/uapi/linux/handshake.h             |    2 
 net/handshake/netlink.c                    |    1 
 net/tls/Makefile                           |    2 
 net/tls/tls_handshake.c                    |  391 ++++++++++++++++++++++++++++
 8 files changed, 647 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/tls-handshake.rst
 create mode 100644 net/tls/tls_handshake.c

diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/netlink/specs/handshake.yaml
index 8367f50fb745..49c3bd9ca6a9 100644
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
@@ -135,3 +135,5 @@ mcast-groups:
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
index 000000000000..0580e4d1b67c
--- /dev/null
+++ b/Documentation/networking/tls-handshake.rst
@@ -0,0 +1,219 @@
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
+over TCP. TLS provides end-to-end data integrity and confidentiality in
+addition to peer authentication.
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
+Linux kernel. To provide a handshake service, a handshake agent
+(typically in user space) is started in each network namespace where a
+kernel consumer might require a TLS handshake. Handshake agents listen
+for events sent from the kernel that indicate a handshake request is
+waiting.
+
+An open socket is passed to a handshake agent via a netlink operation,
+which creates a socket descriptor in the agent's file descriptor table.
+If the handshake completes successfully, the handshake agent promotes
+the socket to use the TLS ULP and sets the session information using the
+SOL_TLS socket options. The handshake agent returns the socket to the
+kernel via a second netlink operation.
+
+
+Kernel Handshake API
+====================
+
+A kernel TLS consumer initiates a client-side TLS handshake on an open
+socket by invoking one of the tls_client_hello() functions. First, it
+fills in a structure that contains the parameters of the request:
+
+.. code-block:: c
+
+struct tls_handshake_args {
+	struct socket		*ta_sock;
+	tls_done_func_t		ta_done;
+	void			*ta_data;
+	unsigned int		ta_timeout_ms;
+        key_serial_t            ta_keyring;
+	key_serial_t		ta_my_peerid;
+	key_serial_t		ta_my_privkey;
+};
+
+The @ta_sock field references an open and connected socket. The consumer
+must hold a reference on the socket to prevent it from being destroyed
+while the handshake is in progress. The consumer must also have
+instantiated a struct file in sock->file.
+
+
+@ta_done contains a callback function that is invoked when the handshake
+has completed. Further explanation of this function is in the "Handshake
+Completion" sesction below.
+
+The consumer can fill in the @ta_timeout_ms field to force the servicing
+handshake agent to exit after a number of milliseconds. This enables the
+socket to be fully closed once both the kernel and the handshake agent
+have closed their endpoints.
+
+Authentication material such as x.509 certificates, private certificate
+keys, and pre-shared keys are provided to the handshake agent in keys
+that are instantiated by the consumer before making the handshake
+request. The consumer can provide a private keyring that is linked into
+the handshake agent's process keyring in the @ta_keyring field to prevent
+access of those keys by other subsystems.
+
+The use of the @ta_my_peerid and @ta_my_privkey fields depends on which
+authentication mode is requested. For example to start an x.509-
+authenticated TLS session:
+
+.. code-block:: c
+
+  ret = tls_client_hello_x509(args, gfp_flags);
+
+The function returns zero when the handshake request is under way. A
+zero return guarantees the callback function @ta_done will be invoked
+for this socket. The function returns a negative errno if the handshake
+could not be started. A negative errno guarantees the callback function
+@ta_done will not be invoked on this socket.
+
+The handshake argument structure is filled in as above. The consumer
+fills in the @ta_my_peerid field with the serial number of a key that
+contains an x.509 certificate. The consumer fills in the @ta_my_privkey
+field with the serial number of a key that contains the private key for
+that certificate.
+
+
+To initiate a client-side TLS handshake with a pre-shared key, use:
+
+.. code-block:: c
+
+  ret = tls_client_hello_psk(args, gfp_flags);
+
+In this case, the consumer fills in the @ta_my_peerid field with the
+serial number of a key that contains a pre-shared key to be used for the
+handshake. The other fields are filled in as above.
+
+
+To initiate an anonymous client-side TLS handshake use:
+
+.. code-block:: c
+
+  ret = tls_client_hello_anon(args, gfp_flags);
+
+The handshake agent presents no peer identity information to the remote
+during this type of handshake. Only server authentication (ie the client
+verifies the server's identity) is performed during the handshake. Thus
+the established session uses encryption only.
+
+
+Consumers that are in-kernel servers use:
+
+.. code-block:: c
+
+  ret = tls_server_hello_x509(args, gfp_flags);
+
+or
+
+.. code-block:: c
+
+  ret = tls_server_hello_psk(args, gfp_flags);
+
+The argument structure is filled in as above.
+
+
+If the consumer needs to cancel the handshake request, say, due to a ^C
+or other exigent event, the consumer can invoke:
+
+.. code-block:: c
+
+  bool tls_handshake_cancel(sock);
+
+This function returns true if the handshake request associated with
+@sock has been canceled. The consumer's handshake completion callback
+will not be invoked. If this function returns false, then the consumer's
+completion callback has already been invoked.
+
+
+Handshake Completion
+====================
+
+When the handshake agent has completed processing, it notifies the
+kernel that the socket may be used by the consumer again. At this point,
+the consumer's handshake completion callback, provided in the @ta_done
+field in the tls_handshake_args structure, is invoked.
+
+The synopsis of this function is:
+
+.. code-block:: c
+
+typedef void	(*tls_done_func_t)(void *data, int status,
+				   key_serial_t peerid);
+
+The consumer provides a cookie in the @ta_data field of the
+tls_handshake_args structure that is returned in the @data parameter of
+this callback. The consumer uses the cookie to match the callback to the
+thread waiting for the handshake to complete.
+
+The success status of the handshake is returned via the @status
+parameter:
+
++-----------+----------------------------------------------+
+|  errno    |  meaning                                     |
++===========+==============================================+
+|  0        |  TLS session established successfully        |
++-----------+----------------------------------------------+
+|  EACCESS  |  Remote peer rejected the handshake or       |
+|           |  authentication failed                       |
++-----------+----------------------------------------------+
+|  ENOMEM   |  Temporary resource allocation failure       |
++-----------+----------------------------------------------+
+|  EINVAL   |  Consumer provided an invalid argument       |
++-----------+----------------------------------------------+
+|  ENOKEY   |  Missing authentication material             |
++-----------+----------------------------------------------+
+|  EIO      |  An unexpected fault occurred                |
++-----------+----------------------------------------------+
+
+The @peerid parameter contains the serial number of a key containing the
+remote peer's identity or the value TLS_NO_PEERID if the session is not
+authenticated.
+
+A best practice is to close and destroy the socket immediately if the
+handshake failed.
+
+
+Other considerations
+--------------------
+
+While a handshake is under way, the kernel consumer must alter the
+socket's sk_data_ready callback function to ignore all incoming data.
+Once the handshake completion callback function has been invoked, normal
+receive operation can be resumed.
+
+Once a TLS session is established, the consumer must provide a buffer
+for and then examine the control message (CMSG) that is part of every
+subsequent sock_recvmsg(). Each control message indicates whether the
+received message data is TLS record data or session metadata.
+
+See tls.rst for details on how a kTLS consumer recognizes incoming
+(decrypted) application data, alerts, and handshake packets once the
+socket has been promoted to use the TLS ULP.
diff --git a/include/net/tls.h b/include/net/tls.h
index 154949c7b0c8..c8a964a62ded 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -512,4 +512,33 @@ static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
 	return tls_get_ctx(sk)->rx_conf == TLS_HW;
 }
 #endif
+
+enum {
+	TLS_NO_KEYRING = 0,
+	TLS_NO_PEERID = 0,
+	TLS_NO_CERT = 0,
+	TLS_NO_PRIVKEY = 0,
+};
+
+typedef void	(*tls_done_func_t)(void *data, int status,
+				   key_serial_t peerid);
+
+struct tls_handshake_args {
+	struct socket		*ta_sock;
+	tls_done_func_t		ta_done;
+	void			*ta_data;
+	unsigned int		ta_timeout_ms;
+	key_serial_t		ta_keyring;
+	key_serial_t		ta_my_peerid;
+	key_serial_t		ta_my_privkey;
+};
+
+int tls_client_hello_anon(const struct tls_handshake_args *args, gfp_t flags);
+int tls_client_hello_x509(const struct tls_handshake_args *args, gfp_t flags);
+int tls_client_hello_psk(const struct tls_handshake_args *args, gfp_t flags);
+int tls_server_hello_x509(const struct tls_handshake_args *args, gfp_t flags);
+int tls_server_hello_psk(const struct tls_handshake_args *args, gfp_t flags);
+
+bool tls_handshake_cancel(struct socket *sock);
+
 #endif /* _TLS_OFFLOAD_H */
diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
index 6e0c608a6b91..fe888abb4be8 100644
--- a/include/uapi/linux/handshake.h
+++ b/include/uapi/linux/handshake.h
@@ -11,6 +11,7 @@
 
 enum {
 	HANDSHAKE_HANDLER_CLASS_NONE,
+	HANDSHAKE_HANDLER_CLASS_TLSHD,
 };
 
 enum {
@@ -67,5 +68,6 @@ enum {
 };
 
 #define HANDSHAKE_MCGRP_NONE	"none"
+#define HANDSHAKE_MCGRP_TLSHD	"tlshd"
 
 #endif /* _UAPI_LINUX_HANDSHAKE_H */
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 6f3a7852742b..454063bdd645 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -260,6 +260,7 @@ static const struct genl_split_ops handshake_nl_ops[] = {
 
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
index 000000000000..a7ac923b0d6b
--- /dev/null
+++ b/net/tls/tls_handshake.c
@@ -0,0 +1,391 @@
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
+#include <linux/key.h>
+
+#include <net/sock.h>
+#include <net/tls.h>
+#include <net/genetlink.h>
+#include <net/handshake.h>
+
+#include <uapi/linux/keyctl.h>
+#include <uapi/linux/handshake.h>
+
+struct tls_handshake_req {
+	void			(*th_consumer_done)(void *data, int status,
+						    key_serial_t peerid);
+	void			*th_consumer_data;
+
+	int			th_type;
+	unsigned int		th_timeout_ms;
+	int			th_auth_mode;
+	key_serial_t		th_keyring;
+	key_serial_t		th_peerid;
+	key_serial_t		th_certificate;
+	key_serial_t		th_privkey;
+};
+
+static struct tls_handshake_req *
+tls_handshake_req_init(struct handshake_req *req,
+		       const struct tls_handshake_args *args)
+{
+	struct tls_handshake_req *treq = handshake_req_private(req);
+
+	treq->th_timeout_ms = args->ta_timeout_ms;
+	treq->th_consumer_done = args->ta_done;
+	treq->th_consumer_data = args->ta_data;
+	treq->th_keyring = args->ta_keyring;
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
+}
+
+/**
+ * tls_handshake_done - callback to handle a CMD_DONE request
+ * @req: socket on which the handshake was performed
+ * @status: session status code
+ * @tb: other results of session establishment
+ *
+ */
+static void tls_handshake_done(struct handshake_req *req,
+			       unsigned int status, struct nlattr **tb)
+{
+	struct tls_handshake_req *treq = handshake_req_private(req);
+	key_serial_t peerid = TLS_NO_PEERID;
+
+	if (tb && tb[HANDSHAKE_A_DONE_REMOTE_AUTH])
+		peerid = nla_get_u32(tb[HANDSHAKE_A_DONE_REMOTE_AUTH]);
+
+	treq->th_consumer_done(treq->th_consumer_data, -status, peerid);
+}
+
+#if IS_ENABLED(CONFIG_KEYS)
+static int tls_handshake_private_keyring(struct tls_handshake_req *treq)
+{
+	key_ref_t process_keyring_ref, keyring_ref;
+	int ret;
+
+	if (treq->th_keyring == TLS_NO_KEYRING)
+		return 0;
+
+	process_keyring_ref = lookup_user_key(KEY_SPEC_PROCESS_KEYRING,
+					      KEY_LOOKUP_CREATE,
+					      KEY_NEED_WRITE);
+	if (IS_ERR(process_keyring_ref)) {
+		ret = PTR_ERR(process_keyring_ref);
+		goto out;
+	}
+
+	keyring_ref = lookup_user_key(treq->th_keyring, KEY_LOOKUP_CREATE,
+				      KEY_NEED_LINK);
+	if (IS_ERR(keyring_ref)) {
+		ret = PTR_ERR(keyring_ref);
+		goto out_put_key;
+	}
+
+	ret = key_link(key_ref_to_ptr(process_keyring_ref),
+		       key_ref_to_ptr(keyring_ref));
+
+	key_ref_put(keyring_ref);
+out_put_key:
+	key_ref_put(process_keyring_ref);
+out:
+	return ret;
+}
+#else
+static int tls_handshake_private_keyring(struct tls_handshake_req *treq)
+{
+	return 0;
+}
+#endif
+
+static int tls_handshake_put_peer_identity(struct sk_buff *msg,
+					   struct tls_handshake_req *treq)
+{
+	if (treq->th_peerid == TLS_NO_PEERID)
+		return 0;
+
+	if (nla_put_u32(msg, HANDSHAKE_A_ACCEPT_PEER_IDENTITY,
+			treq->th_peerid) < 0)
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int tls_handshake_put_certificate(struct sk_buff *msg,
+					 struct tls_handshake_req *treq)
+{
+	struct nlattr *entry_attr;
+
+	if (treq->th_certificate == TLS_NO_CERT &&
+	    treq->th_privkey == TLS_NO_PRIVKEY)
+		return 0;
+
+	entry_attr = nla_nest_start(msg, HANDSHAKE_A_ACCEPT_CERTIFICATE);
+	if (!entry_attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(msg, HANDSHAKE_A_X509_CERT,
+			treq->th_certificate) < 0)
+		goto out_cancel;
+	if (nla_put_u32(msg, HANDSHAKE_A_X509_PRIVKEY,
+			treq->th_privkey) < 0)
+		goto out_cancel;
+
+	nla_nest_end(msg, entry_attr);
+	return 0;
+
+out_cancel:
+	nla_nest_cancel(msg, entry_attr);
+	return -EMSGSIZE;
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
+	ret = tls_handshake_private_keyring(treq);
+	if (ret < 0)
+		goto out;
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
+	ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MESSAGE_TYPE, treq->th_type);
+	if (ret < 0)
+		goto out_cancel;
+	if (treq->th_timeout_ms) {
+		ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_TIMEOUT, treq->th_timeout_ms);
+		if (ret < 0)
+			goto out_cancel;
+	}
+
+	ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_AUTH_MODE,
+			  treq->th_auth_mode);
+	if (ret < 0)
+		goto out_cancel;
+	switch (treq->th_auth_mode) {
+	case HANDSHAKE_AUTH_PSK:
+		ret = tls_handshake_put_peer_identity(msg, treq);
+		if (ret < 0)
+			goto out_cancel;
+		break;
+	case HANDSHAKE_AUTH_X509:
+		ret = tls_handshake_put_certificate(msg, treq);
+		if (ret < 0)
+			goto out_cancel;
+		break;
+	}
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
+ * @args: socket and handshake parameters for this request
+ * @flags: memory allocation control flags
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ESRCH: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_anon(const struct tls_handshake_args *args, gfp_t flags)
+{
+	struct tls_handshake_req *treq;
+	struct handshake_req *req;
+
+	req = handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags);
+	if (!req)
+		return -ENOMEM;
+	treq = tls_handshake_req_init(req, args);
+	treq->th_type = HANDSHAKE_MSG_TYPE_CLIENTHELLO;
+	treq->th_auth_mode = HANDSHAKE_AUTH_UNAUTH;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_client_hello_anon);
+
+/**
+ * tls_client_hello_x509 - request an x.509-based TLS handshake on a socket
+ * @args: socket and handshake parameters for this request
+ * @flags: memory allocation control flags
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ESRCH: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_x509(const struct tls_handshake_args *args, gfp_t flags)
+{
+	struct tls_handshake_req *treq;
+	struct handshake_req *req;
+
+	req = handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags);
+	if (!req)
+		return -ENOMEM;
+	treq = tls_handshake_req_init(req, args);
+	treq->th_type = HANDSHAKE_MSG_TYPE_CLIENTHELLO;
+	treq->th_auth_mode = HANDSHAKE_AUTH_X509;
+	treq->th_certificate = args->ta_my_peerid;
+	treq->th_privkey = args->ta_my_privkey;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_client_hello_x509);
+
+/**
+ * tls_client_hello_psk - request a PSK-based TLS handshake on a socket
+ * @args: socket and handshake parameters for this request
+ * @flags: memory allocation control flags
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ESRCH: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_psk(const struct tls_handshake_args *args, gfp_t flags)
+{
+	struct tls_handshake_req *treq;
+	struct handshake_req *req;
+
+	req = handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags);
+	if (!req)
+		return -ENOMEM;
+	treq = tls_handshake_req_init(req, args);
+	treq->th_type = HANDSHAKE_MSG_TYPE_CLIENTHELLO;
+	treq->th_auth_mode = HANDSHAKE_AUTH_PSK;
+	treq->th_peerid = args->ta_my_peerid;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_client_hello_psk);
+
+/**
+ * tls_server_hello_x509 - request a server TLS handshake on a socket
+ * @args: socket and handshake parameters for this request
+ * @flags: memory allocation control flags
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ESRCH: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_server_hello_x509(const struct tls_handshake_args *args, gfp_t flags)
+{
+	struct tls_handshake_req *treq;
+	struct handshake_req *req;
+
+	req = handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags);
+	if (!req)
+		return -ENOMEM;
+	treq = tls_handshake_req_init(req, args);
+	treq->th_type = HANDSHAKE_MSG_TYPE_SERVERHELLO;
+	treq->th_auth_mode = HANDSHAKE_AUTH_X509;
+	treq->th_certificate = args->ta_my_peerid;
+	treq->th_privkey = args->ta_my_privkey;
+
+	return handshake_req_submit(req, flags);
+}
+EXPORT_SYMBOL(tls_server_hello_x509);
+
+/**
+ * tls_server_hello_psk - request a server TLS handshake on a socket
+ * @args: socket and handshake parameters for this request
+ * @flags: memory allocation control flags
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ESRCH: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_server_hello_psk(const struct tls_handshake_args *args, gfp_t flags)
+{
+	struct tls_handshake_req *treq;
+	struct handshake_req *req;
+
+	req = handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags);
+	if (!req)
+		return -ENOMEM;
+	treq = tls_handshake_req_init(req, args);
+	treq->th_type = HANDSHAKE_MSG_TYPE_SERVERHELLO;
+	treq->th_auth_mode = HANDSHAKE_AUTH_PSK;
+	treq->th_peerid = args->ta_my_peerid;
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
+ *   %true - Uncompleted handshake request was canceled or not found
+ *   %false - Handshake request already completed
+ */
+bool tls_handshake_cancel(struct socket *sock)
+{
+	return handshake_req_cancel(sock);
+}
+EXPORT_SYMBOL(tls_handshake_cancel);


