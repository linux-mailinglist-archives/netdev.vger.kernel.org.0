Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90D46D50E7
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbjDCSqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjDCSqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDC710E9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4153E627A4
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 18:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1730EC433D2;
        Mon,  3 Apr 2023 18:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680547563;
        bh=U3F6HFL7xTOZlbW+SkacmdolUEUGnselb/dEz7SFt24=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=T4EFEY+NeJS8FsutF8ddk64bwTRXtB9SXPrnOFEDtIQAaYKVUeFdsPRUvzNqMjN72
         iqQ11BHUfbIjy4x/7gQpoQ+zsG5mJCuImLKOZ0q6VZqFn021PEdOghZkTDkwd2XpjD
         MMMoUsojfKYOy2MFwrWiay4AtzZYetGp9c4lQAHscOOOI9GNmisKWogYP6cjX8VN6H
         OxM6x2M0V0Yozg0v+boiY0E/FCuCU/XtgNtDUG7xpwBvVjk1SF3ZFOONXW0c75oydc
         8639FbIZLSONJpc0A8PZMnyXgrkiMU8SXCgAkOGSocGsGTLe8fot+Bf8eCUybhwT/8
         QfGrvql4nS4zA==
Subject: [PATCH v8 1/4] net/handshake: Create a NETLINK service for handling
 handshake requests
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        borisp@nvidia.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Mon, 03 Apr 2023 14:46:02 -0400
Message-ID: <168054756211.2138.1880630504843421368.stgit@klimt.1015granger.net>
In-Reply-To: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

When a kernel consumer needs a transport layer security session, it
first needs a handshake to negotiate and establish a session. This
negotiation can be done in user space via one of the several
existing library implementations, or it can be done in the kernel.

No in-kernel handshake implementations yet exist. In their absence,
we add a netlink service that can:

a. Notify a user space daemon that a handshake is needed.

b. Once notified, the daemon calls the kernel back via this
   netlink service to get the handshake parameters, including an
   open socket on which to establish the session.

c. Once the handshake is complete, the daemon reports the
   session status and other information via a second netlink
   operation. This operation marks that it is safe for the
   kernel to use the open socket and the security session
   established there.

The notification service uses a multicast group. Each handshake
mechanism (eg, tlshd) adopts its own group number so that the
handshake services are completely independent of one another. The
kernel can then tell via netlink_has_listeners() whether a handshake
service is active and prepared to handle a handshake request.

A new netlink operation, ACCEPT, acts like accept(2) in that it
instantiates a file descriptor in the user space daemon's fd table.
If this operation is successful, the reply carries the fd number,
which can be treated as an open and ready file descriptor.

While user space is performing the handshake, the kernel keeps its
muddy paws off the open socket. A second new netlink operation,
DONE, indicates that the user space daemon is finished with the
socket and it is safe for the kernel to use again. The operation
also indicates whether a session was established successfully.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 Documentation/netlink/specs/handshake.yaml |  122 ++++++++++
 MAINTAINERS                                |    9 +
 include/trace/events/handshake.h           |  159 +++++++++++++
 include/uapi/linux/handshake.h             |   71 ++++++
 net/Kconfig                                |    5 
 net/Makefile                               |    1 
 net/handshake/Makefile                     |   11 +
 net/handshake/genl.c                       |   57 +++++
 net/handshake/genl.h                       |   23 ++
 net/handshake/handshake.h                  |   81 +++++++
 net/handshake/netlink.c                    |  308 +++++++++++++++++++++++++
 net/handshake/request.c                    |  344 ++++++++++++++++++++++++++++
 net/handshake/trace.c                      |   20 ++
 13 files changed, 1211 insertions(+)
 create mode 100644 Documentation/netlink/specs/handshake.yaml
 create mode 100644 include/trace/events/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/genl.c
 create mode 100644 net/handshake/genl.h
 create mode 100644 net/handshake/handshake.h
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/handshake/request.c
 create mode 100644 net/handshake/trace.c

diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/netlink/specs/handshake.yaml
new file mode 100644
index 000000000000..0333d92b1438
--- /dev/null
+++ b/Documentation/netlink/specs/handshake.yaml
@@ -0,0 +1,122 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+#
+# Author: Chuck Lever <chuck.lever@oracle.com>
+#
+# Copyright (c) 2023, Oracle and/or its affiliates.
+#
+
+name: handshake
+
+protocol: genetlink
+
+doc: Netlink protocol to request a transport layer security handshake.
+
+definitions:
+  -
+    type: enum
+    name: handler-class
+    value-start: 0
+    entries: [ none, max ]
+  -
+    type: enum
+    name: msg-type
+    value-start: 0
+    entries: [ unspec, clienthello, serverhello ]
+  -
+    type: enum
+    name: auth
+    value-start: 0
+    entries: [ unspec, unauth, psk, x509 ]
+
+attribute-sets:
+  -
+    name: x509
+    attributes:
+      -
+        name: cert
+        type: u32
+      -
+        name: privkey
+        type: u32
+  -
+    name: accept
+    attributes:
+      -
+        name: sockfd
+        type: u32
+      -
+        name: handler-class
+        type: u32
+        enum: handler-class
+      -
+        name: message-type
+        type: u32
+        enum: msg-type
+      -
+        name: timeout
+        type: u32
+      -
+        name: auth-mode
+        type: u32
+        enum: auth
+      -
+        name: peer-identity
+        type: u32
+        multi-attr: true
+      -
+        name: certificate
+        type: nest
+        nested-attributes: x509
+        multi-attr: true
+  -
+    name: done
+    attributes:
+      -
+        name: status
+        type: u32
+      -
+        name: sockfd
+        type: u32
+      -
+        name: remote-auth
+        type: u32
+        multi-attr: true
+
+operations:
+  list:
+    -
+      name: ready
+      doc: Notify handlers that a new handshake request is waiting
+      notify: accept
+    -
+      name: accept
+      doc: Handler retrieves next queued handshake request
+      attribute-set: accept
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - handler-class
+        reply:
+          attributes:
+            - sockfd
+            - message-type
+            - timeout
+            - auth-mode
+            - peer-identity
+            - certificate
+    -
+      name: done
+      doc: Handler reports handshake completion
+      attribute-set: done
+      do:
+        request:
+          attributes:
+            - status
+            - sockfd
+            - remote-auth
+
+mcast-groups:
+  list:
+    -
+      name: none
diff --git a/MAINTAINERS b/MAINTAINERS
index 7812f0e251ad..d78d67ac7f89 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8940,6 +8940,15 @@ Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
 F:	drivers/media/usb/hackrf/
 
+HANDSHAKE UPCALL FOR TRANSPORT LAYER SECURITY
+M:	Chuck Lever <chuck.lever@oracle.com>
+L:	kernel-tls-handshake@lists.linux.dev
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/netlink/specs/handshake.yaml
+F:	include/trace/events/handshake.h
+F:	net/handshake/
+
 HANTRO VPU CODEC DRIVER
 M:	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
 M:	Philipp Zabel <p.zabel@pengutronix.de>
diff --git a/include/trace/events/handshake.h b/include/trace/events/handshake.h
new file mode 100644
index 000000000000..97f0f160393b
--- /dev/null
+++ b/include/trace/events/handshake.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM handshake
+
+#if !defined(_TRACE_HANDSHAKE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_HANDSHAKE_H
+
+#include <linux/net.h>
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(handshake_event_class,
+	TP_PROTO(
+		const struct net *net,
+		const struct handshake_req *req,
+		const struct sock *sk
+	),
+	TP_ARGS(net, req, sk),
+	TP_STRUCT__entry(
+		__field(const void *, req)
+		__field(const void *, sk)
+		__field(unsigned int, netns_ino)
+	),
+	TP_fast_assign(
+		__entry->req = req;
+		__entry->sk = sk;
+		__entry->netns_ino = net->ns.inum;
+	),
+	TP_printk("req=%p sk=%p",
+		__entry->req, __entry->sk
+	)
+);
+#define DEFINE_HANDSHAKE_EVENT(name)				\
+	DEFINE_EVENT(handshake_event_class, name,		\
+		TP_PROTO(					\
+			const struct net *net,			\
+			const struct handshake_req *req,	\
+			const struct sock *sk			\
+		),						\
+		TP_ARGS(net, req, sk))
+
+DECLARE_EVENT_CLASS(handshake_fd_class,
+	TP_PROTO(
+		const struct net *net,
+		const struct handshake_req *req,
+		const struct sock *sk,
+		int fd
+	),
+	TP_ARGS(net, req, sk, fd),
+	TP_STRUCT__entry(
+		__field(const void *, req)
+		__field(const void *, sk)
+		__field(int, fd)
+		__field(unsigned int, netns_ino)
+	),
+	TP_fast_assign(
+		__entry->req = req;
+		__entry->sk = req->hr_sk;
+		__entry->fd = fd;
+		__entry->netns_ino = net->ns.inum;
+	),
+	TP_printk("req=%p sk=%p fd=%d",
+		__entry->req, __entry->sk, __entry->fd
+	)
+);
+#define DEFINE_HANDSHAKE_FD_EVENT(name)				\
+	DEFINE_EVENT(handshake_fd_class, name,			\
+		TP_PROTO(					\
+			const struct net *net,			\
+			const struct handshake_req *req,	\
+			const struct sock *sk,			\
+			int fd					\
+		),						\
+		TP_ARGS(net, req, sk, fd))
+
+DECLARE_EVENT_CLASS(handshake_error_class,
+	TP_PROTO(
+		const struct net *net,
+		const struct handshake_req *req,
+		const struct sock *sk,
+		int err
+	),
+	TP_ARGS(net, req, sk, err),
+	TP_STRUCT__entry(
+		__field(const void *, req)
+		__field(const void *, sk)
+		__field(int, err)
+		__field(unsigned int, netns_ino)
+	),
+	TP_fast_assign(
+		__entry->req = req;
+		__entry->sk = sk;
+		__entry->err = err;
+		__entry->netns_ino = net->ns.inum;
+	),
+	TP_printk("req=%p sk=%p err=%d",
+		__entry->req, __entry->sk, __entry->err
+	)
+);
+#define DEFINE_HANDSHAKE_ERROR(name)				\
+	DEFINE_EVENT(handshake_error_class, name,		\
+		TP_PROTO(					\
+			const struct net *net,			\
+			const struct handshake_req *req,	\
+			const struct sock *sk,			\
+			int err					\
+		),						\
+		TP_ARGS(net, req, sk, err))
+
+
+/**
+ ** Request lifetime events
+ **/
+
+DEFINE_HANDSHAKE_EVENT(handshake_submit);
+DEFINE_HANDSHAKE_ERROR(handshake_submit_err);
+DEFINE_HANDSHAKE_EVENT(handshake_cancel);
+DEFINE_HANDSHAKE_EVENT(handshake_cancel_none);
+DEFINE_HANDSHAKE_EVENT(handshake_cancel_busy);
+DEFINE_HANDSHAKE_EVENT(handshake_destruct);
+
+
+TRACE_EVENT(handshake_complete,
+	TP_PROTO(
+		const struct net *net,
+		const struct handshake_req *req,
+		const struct sock *sk,
+		int status
+	),
+	TP_ARGS(net, req, sk, status),
+	TP_STRUCT__entry(
+		__field(const void *, req)
+		__field(const void *, sk)
+		__field(int, status)
+		__field(unsigned int, netns_ino)
+	),
+	TP_fast_assign(
+		__entry->req = req;
+		__entry->sk = sk;
+		__entry->status = status;
+		__entry->netns_ino = net->ns.inum;
+	),
+	TP_printk("req=%p sk=%p status=%d",
+		__entry->req, __entry->sk, __entry->status
+	)
+);
+
+/**
+ ** Netlink events
+ **/
+
+DEFINE_HANDSHAKE_ERROR(handshake_notify_err);
+DEFINE_HANDSHAKE_FD_EVENT(handshake_cmd_accept);
+DEFINE_HANDSHAKE_ERROR(handshake_cmd_accept_err);
+DEFINE_HANDSHAKE_FD_EVENT(handshake_cmd_done);
+DEFINE_HANDSHAKE_ERROR(handshake_cmd_done_err);
+
+#endif /* _TRACE_HANDSHAKE_H */
+
+#include <trace/define_trace.h>
diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
new file mode 100644
index 000000000000..7f66ff489b87
--- /dev/null
+++ b/include/uapi/linux/handshake.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/handshake.yaml */
+/* YNL-GEN uapi header */
+
+#ifndef _UAPI_LINUX_HANDSHAKE_H
+#define _UAPI_LINUX_HANDSHAKE_H
+
+#define HANDSHAKE_FAMILY_NAME		"handshake"
+#define HANDSHAKE_FAMILY_VERSION	1
+
+enum handshake_handler_class {
+	HANDSHAKE_HANDLER_CLASS_NONE,
+	HANDSHAKE_HANDLER_CLASS_MAX,
+};
+
+enum handshake_msg_type {
+	HANDSHAKE_MSG_TYPE_UNSPEC,
+	HANDSHAKE_MSG_TYPE_CLIENTHELLO,
+	HANDSHAKE_MSG_TYPE_SERVERHELLO,
+};
+
+enum handshake_auth {
+	HANDSHAKE_AUTH_UNSPEC,
+	HANDSHAKE_AUTH_UNAUTH,
+	HANDSHAKE_AUTH_PSK,
+	HANDSHAKE_AUTH_X509,
+};
+
+enum {
+	HANDSHAKE_A_X509_CERT = 1,
+	HANDSHAKE_A_X509_PRIVKEY,
+
+	__HANDSHAKE_A_X509_MAX,
+	HANDSHAKE_A_X509_MAX = (__HANDSHAKE_A_X509_MAX - 1)
+};
+
+enum {
+	HANDSHAKE_A_ACCEPT_SOCKFD = 1,
+	HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
+	HANDSHAKE_A_ACCEPT_MESSAGE_TYPE,
+	HANDSHAKE_A_ACCEPT_TIMEOUT,
+	HANDSHAKE_A_ACCEPT_AUTH_MODE,
+	HANDSHAKE_A_ACCEPT_PEER_IDENTITY,
+	HANDSHAKE_A_ACCEPT_CERTIFICATE,
+
+	__HANDSHAKE_A_ACCEPT_MAX,
+	HANDSHAKE_A_ACCEPT_MAX = (__HANDSHAKE_A_ACCEPT_MAX - 1)
+};
+
+enum {
+	HANDSHAKE_A_DONE_STATUS = 1,
+	HANDSHAKE_A_DONE_SOCKFD,
+	HANDSHAKE_A_DONE_REMOTE_AUTH,
+
+	__HANDSHAKE_A_DONE_MAX,
+	HANDSHAKE_A_DONE_MAX = (__HANDSHAKE_A_DONE_MAX - 1)
+};
+
+enum {
+	HANDSHAKE_CMD_READY = 1,
+	HANDSHAKE_CMD_ACCEPT,
+	HANDSHAKE_CMD_DONE,
+
+	__HANDSHAKE_CMD_MAX,
+	HANDSHAKE_CMD_MAX = (__HANDSHAKE_CMD_MAX - 1)
+};
+
+#define HANDSHAKE_MCGRP_NONE	"none"
+
+#endif /* _UAPI_LINUX_HANDSHAKE_H */
diff --git a/net/Kconfig b/net/Kconfig
index f806722bccf4..4b800706cc76 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -68,6 +68,11 @@ source "net/iucv/Kconfig"
 source "net/smc/Kconfig"
 source "net/xdp/Kconfig"
 
+config NET_HANDSHAKE
+	bool
+	depends on SUNRPC || NVME_TARGET_TCP || NVME_TCP
+	default y
+
 config INET
 	bool "TCP/IP networking"
 	help
diff --git a/net/Makefile b/net/Makefile
index 0914bea9c335..bfee380efb46 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -79,3 +79,4 @@ obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
 obj-$(CONFIG_MPTCP)		+= mptcp/
 obj-$(CONFIG_MCTP)		+= mctp/
+obj-$(CONFIG_NET_HANDSHAKE)	+= handshake/
diff --git a/net/handshake/Makefile b/net/handshake/Makefile
new file mode 100644
index 000000000000..d38736de45da
--- /dev/null
+++ b/net/handshake/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Generic HANDSHAKE service
+#
+# Author: Chuck Lever <chuck.lever@oracle.com>
+#
+# Copyright (c) 2023, Oracle and/or its affiliates.
+#
+
+obj-y += handshake.o
+handshake-y := genl.o netlink.o request.o trace.o
diff --git a/net/handshake/genl.c b/net/handshake/genl.c
new file mode 100644
index 000000000000..652f37d19bd6
--- /dev/null
+++ b/net/handshake/genl.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/handshake.yaml */
+/* YNL-GEN kernel source */
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include "genl.h"
+
+#include <linux/handshake.h>
+
+/* HANDSHAKE_CMD_ACCEPT - do */
+static const struct nla_policy handshake_accept_nl_policy[HANDSHAKE_A_ACCEPT_HANDLER_CLASS + 1] = {
+	[HANDSHAKE_A_ACCEPT_HANDLER_CLASS] = NLA_POLICY_MAX(NLA_U32, 1),
+};
+
+/* HANDSHAKE_CMD_DONE - do */
+static const struct nla_policy handshake_done_nl_policy[HANDSHAKE_A_DONE_REMOTE_AUTH + 1] = {
+	[HANDSHAKE_A_DONE_STATUS] = { .type = NLA_U32, },
+	[HANDSHAKE_A_DONE_SOCKFD] = { .type = NLA_U32, },
+	[HANDSHAKE_A_DONE_REMOTE_AUTH] = { .type = NLA_U32, },
+};
+
+/* Ops table for handshake */
+static const struct genl_split_ops handshake_nl_ops[] = {
+	{
+		.cmd		= HANDSHAKE_CMD_ACCEPT,
+		.doit		= handshake_nl_accept_doit,
+		.policy		= handshake_accept_nl_policy,
+		.maxattr	= HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= HANDSHAKE_CMD_DONE,
+		.doit		= handshake_nl_done_doit,
+		.policy		= handshake_done_nl_policy,
+		.maxattr	= HANDSHAKE_A_DONE_REMOTE_AUTH,
+		.flags		= GENL_CMD_CAP_DO,
+	},
+};
+
+static const struct genl_multicast_group handshake_nl_mcgrps[] = {
+	[HANDSHAKE_NLGRP_NONE] = { "none", },
+};
+
+struct genl_family handshake_nl_family __ro_after_init = {
+	.name		= HANDSHAKE_FAMILY_NAME,
+	.version	= HANDSHAKE_FAMILY_VERSION,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.module		= THIS_MODULE,
+	.split_ops	= handshake_nl_ops,
+	.n_split_ops	= ARRAY_SIZE(handshake_nl_ops),
+	.mcgrps		= handshake_nl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(handshake_nl_mcgrps),
+};
diff --git a/net/handshake/genl.h b/net/handshake/genl.h
new file mode 100644
index 000000000000..a1eb7ccccc7f
--- /dev/null
+++ b/net/handshake/genl.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/handshake.yaml */
+/* YNL-GEN kernel header */
+
+#ifndef _LINUX_HANDSHAKE_GEN_H
+#define _LINUX_HANDSHAKE_GEN_H
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include <linux/handshake.h>
+
+int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info);
+int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info);
+
+enum {
+	HANDSHAKE_NLGRP_NONE,
+};
+
+extern struct genl_family handshake_nl_family;
+
+#endif /* _LINUX_HANDSHAKE_GEN_H */
diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
new file mode 100644
index 000000000000..8d4ede30e0df
--- /dev/null
+++ b/net/handshake/handshake.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Generic netlink handshake service
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2023, Oracle and/or its affiliates.
+ */
+
+#ifndef _INTERNAL_HANDSHAKE_H
+#define _INTERNAL_HANDSHAKE_H
+
+/* Per-net namespace context */
+struct handshake_net {
+	spinlock_t		hn_lock;	/* protects next 3 fields */
+	int			hn_pending;
+	int			hn_pending_max;
+	struct list_head	hn_requests;
+
+	unsigned long		hn_flags;
+};
+
+enum hn_flags_bits {
+	HANDSHAKE_F_NET_DRAINING,
+};
+
+struct handshake_proto;
+
+/* One handshake request */
+struct handshake_req {
+	struct list_head		hr_list;
+	struct rhash_head		hr_rhash;
+	unsigned long			hr_flags;
+	const struct handshake_proto	*hr_proto;
+	struct sock			*hr_sk;
+	void				(*hr_odestruct)(struct sock *sk);
+
+	/* Always the last field */
+	char				hr_priv[];
+};
+
+enum hr_flags_bits {
+	HANDSHAKE_F_REQ_COMPLETED,
+};
+
+/* Invariants for all handshake requests for one transport layer
+ * security protocol
+ */
+struct handshake_proto {
+	int			hp_handler_class;
+	size_t			hp_privsize;
+
+	int			(*hp_accept)(struct handshake_req *req,
+					     struct genl_info *info, int fd);
+	void			(*hp_done)(struct handshake_req *req,
+					   unsigned int status,
+					   struct genl_info *info);
+	void			(*hp_destroy)(struct handshake_req *req);
+};
+
+/* netlink.c */
+int handshake_genl_notify(struct net *net, int handler_class, gfp_t flags);
+struct nlmsghdr *handshake_genl_put(struct sk_buff *msg,
+				    struct genl_info *info);
+struct handshake_net *handshake_pernet(struct net *net);
+
+/* request.c */
+struct handshake_req *handshake_req_alloc(const struct handshake_proto *proto,
+					  gfp_t flags);
+int handshake_req_hash_init(void);
+void handshake_req_hash_destroy(void);
+void *handshake_req_private(struct handshake_req *req);
+struct handshake_req *handshake_req_hash_lookup(struct sock *sk);
+struct handshake_req *handshake_req_next(struct handshake_net *hn, int class);
+int handshake_req_submit(struct socket *sock, struct handshake_req *req,
+			 gfp_t flags);
+void handshake_complete(struct handshake_req *req, unsigned int status,
+			struct genl_info *info);
+bool handshake_req_cancel(struct socket *sock);
+
+#endif /* _INTERNAL_HANDSHAKE_H */
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
new file mode 100644
index 000000000000..0997fd4c6e0b
--- /dev/null
+++ b/net/handshake/netlink.c
@@ -0,0 +1,308 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Generic netlink handshake service
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
+#include <linux/mm.h>
+
+#include <net/sock.h>
+#include <net/genetlink.h>
+#include <net/netns/generic.h>
+
+#include <uapi/linux/handshake.h>
+#include "handshake.h"
+#include "genl.h"
+
+#include <trace/events/handshake.h>
+
+/**
+ * handshake_genl_notify - Notify handlers that a request is waiting
+ * @net: target network namespace
+ * @handler_class: target handler
+ * @flags: memory allocation control flags
+ *
+ * Returns zero on success or a negative errno if notification failed.
+ */
+int handshake_genl_notify(struct net *net, int handler_class, gfp_t flags)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (!genl_has_listeners(&handshake_nl_family, net, handler_class))
+		return -ESRCH;
+
+	msg = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &handshake_nl_family, 0,
+			  HANDSHAKE_CMD_READY);
+	if (!hdr)
+		goto out_free;
+
+	if (nla_put_u32(msg, HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
+			handler_class) < 0) {
+		genlmsg_cancel(msg, hdr);
+		goto out_free;
+	}
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_multicast_netns(&handshake_nl_family, net, msg,
+				       0, handler_class, flags);
+
+out_free:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
+}
+
+/**
+ * handshake_genl_put - Create a generic netlink message header
+ * @msg: buffer in which to create the header
+ * @info: generic netlink message context
+ *
+ * Returns a ready-to-use header, or NULL.
+ */
+struct nlmsghdr *handshake_genl_put(struct sk_buff *msg,
+				    struct genl_info *info)
+{
+	return genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			   &handshake_nl_family, 0, info->genlhdr->cmd);
+}
+EXPORT_SYMBOL(handshake_genl_put);
+
+/*
+ * dup() a kernel socket for use as a user space file descriptor
+ * in the current process. The kernel socket must have an
+ * instatiated struct file.
+ *
+ * Implicit argument: "current()"
+ */
+static int handshake_dup(struct socket *sock)
+{
+	struct file *file;
+	int newfd;
+
+	if (!sock->file)
+		return -EBADF;
+
+	file = get_file(sock->file);
+	newfd = get_unused_fd_flags(O_CLOEXEC);
+	if (newfd < 0) {
+		fput(file);
+		return newfd;
+	}
+
+	fd_install(newfd, file);
+	return newfd;
+}
+
+int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net *net = sock_net(skb->sk);
+	struct handshake_net *hn = handshake_pernet(net);
+	struct handshake_req *req = NULL;
+	struct socket *sock;
+	int class, fd, err;
+
+	err = -EOPNOTSUPP;
+	if (!hn)
+		goto out_status;
+
+	err = -EINVAL;
+	if (GENL_REQ_ATTR_CHECK(info, HANDSHAKE_A_ACCEPT_HANDLER_CLASS))
+		goto out_status;
+	class = nla_get_u32(info->attrs[HANDSHAKE_A_ACCEPT_HANDLER_CLASS]);
+
+	err = -EAGAIN;
+	req = handshake_req_next(hn, class);
+	if (!req)
+		goto out_status;
+
+	sock = req->hr_sk->sk_socket;
+	fd = handshake_dup(sock);
+	if (fd < 0) {
+		err = fd;
+		goto out_complete;
+	}
+	err = req->hr_proto->hp_accept(req, info, fd);
+	if (err)
+		goto out_complete;
+
+	trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
+	return 0;
+
+out_complete:
+	handshake_complete(req, -EIO, NULL);
+	fput(sock->file);
+out_status:
+	trace_handshake_cmd_accept_err(net, req, NULL, err);
+	return err;
+}
+
+int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net *net = sock_net(skb->sk);
+	struct socket *sock = NULL;
+	struct handshake_req *req;
+	int fd, status, err;
+
+	if (GENL_REQ_ATTR_CHECK(info, HANDSHAKE_A_DONE_SOCKFD))
+		return -EINVAL;
+	fd = nla_get_u32(info->attrs[HANDSHAKE_A_DONE_SOCKFD]);
+
+	err = 0;
+	sock = sockfd_lookup(fd, &err);
+	if (err) {
+		err = -EBADF;
+		goto out_status;
+	}
+
+	req = handshake_req_hash_lookup(sock->sk);
+	if (!req) {
+		err = -EBUSY;
+		goto out_status;
+	}
+
+	trace_handshake_cmd_done(net, req, sock->sk, fd);
+
+	status = -EIO;
+	if (info->attrs[HANDSHAKE_A_DONE_STATUS])
+		status = nla_get_u32(info->attrs[HANDSHAKE_A_DONE_STATUS]);
+
+	handshake_complete(req, status, info);
+	fput(sock->file);
+	return 0;
+
+out_status:
+	trace_handshake_cmd_done_err(net, req, sock->sk, err);
+	return err;
+}
+
+static unsigned int handshake_net_id;
+
+static int __net_init handshake_net_init(struct net *net)
+{
+	struct handshake_net *hn = net_generic(net, handshake_net_id);
+	unsigned long tmp;
+	struct sysinfo si;
+
+	/*
+	 * Arbitrary limit to prevent handshakes that do not make
+	 * progress from clogging up the system.
+	 */
+	si_meminfo(&si);
+	tmp = si.totalram / (25 * si.mem_unit);
+	hn->hn_pending_max = clamp(tmp, 3UL, 25UL);
+
+	spin_lock_init(&hn->hn_lock);
+	hn->hn_pending = 0;
+	hn->hn_flags = 0;
+	INIT_LIST_HEAD(&hn->hn_requests);
+	return 0;
+}
+
+static void __net_exit handshake_net_exit(struct net *net)
+{
+	struct handshake_net *hn = net_generic(net, handshake_net_id);
+	struct handshake_req *req;
+	LIST_HEAD(requests);
+
+	/*
+	 * Drain the net's pending list. Requests that have been
+	 * accepted and are in progress will be destroyed when
+	 * the socket is closed.
+	 */
+	spin_lock(&hn->hn_lock);
+	set_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags);
+	list_splice_init(&requests, &hn->hn_requests);
+	spin_unlock(&hn->hn_lock);
+
+	while (!list_empty(&requests)) {
+		req = list_first_entry(&requests, struct handshake_req, hr_list);
+		list_del(&req->hr_list);
+
+		/*
+		 * Requests on this list have not yet been
+		 * accepted, so they do not have an fd to put.
+		 */
+
+		handshake_complete(req, -ETIMEDOUT, NULL);
+	}
+}
+
+static struct pernet_operations __net_initdata handshake_genl_net_ops = {
+	.init		= handshake_net_init,
+	.exit		= handshake_net_exit,
+	.id		= &handshake_net_id,
+	.size		= sizeof(struct handshake_net),
+};
+
+/**
+ * handshake_pernet - Get the handshake private per-net structure
+ * @net: network namespace
+ *
+ * Returns a pointer to the net's private per-net structure for the
+ * handshake module, or NULL if handshake_init() failed.
+ */
+struct handshake_net *handshake_pernet(struct net *net)
+{
+	return handshake_net_id ?
+		net_generic(net, handshake_net_id) : NULL;
+}
+
+static int __init handshake_init(void)
+{
+	int ret;
+
+	ret = handshake_req_hash_init();
+	if (ret) {
+		pr_warn("handshake: hash initialization failed (%d)\n", ret);
+		return ret;
+	}
+
+	ret = genl_register_family(&handshake_nl_family);
+	if (ret) {
+		pr_warn("handshake: netlink registration failed (%d)\n", ret);
+		handshake_req_hash_destroy();
+		return ret;
+	}
+
+	/*
+	 * ORDER: register_pernet_subsys must be done last.
+	 *
+	 *	If initialization does not make it past pernet_subsys
+	 *	registration, then handshake_net_id will remain 0. That
+	 *	shunts the handshake consumer API to return ENOTSUPP
+	 *	to prevent it from dereferencing something that hasn't
+	 *	been allocated.
+	 */
+	ret = register_pernet_subsys(&handshake_genl_net_ops);
+	if (ret) {
+		pr_warn("handshake: pernet registration failed (%d)\n", ret);
+		genl_unregister_family(&handshake_nl_family);
+		handshake_req_hash_destroy();
+	}
+
+	return ret;
+}
+
+static void __exit handshake_exit(void)
+{
+	unregister_pernet_subsys(&handshake_genl_net_ops);
+	handshake_net_id = 0;
+
+	handshake_req_hash_destroy();
+	genl_unregister_family(&handshake_nl_family);
+}
+
+module_init(handshake_init);
+module_exit(handshake_exit);
diff --git a/net/handshake/request.c b/net/handshake/request.c
new file mode 100644
index 000000000000..0ef18a38c047
--- /dev/null
+++ b/net/handshake/request.c
@@ -0,0 +1,344 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Handshake request lifetime events
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
+#include <linux/fdtable.h>
+#include <linux/rhashtable.h>
+
+#include <net/sock.h>
+#include <net/genetlink.h>
+#include <net/netns/generic.h>
+
+#include <uapi/linux/handshake.h>
+#include "handshake.h"
+
+#include <trace/events/handshake.h>
+
+/*
+ * We need both a handshake_req -> sock mapping, and a sock ->
+ * handshake_req mapping. Both are one-to-one.
+ *
+ * To avoid adding another pointer field to struct sock, net/handshake
+ * maintains a hash table, indexed by the memory address of @sock, to
+ * find the struct handshake_req outstanding for that socket. The
+ * reverse direction uses a simple pointer field in the handshake_req
+ * struct.
+ */
+
+static struct rhashtable handshake_rhashtbl ____cacheline_aligned_in_smp;
+
+static const struct rhashtable_params handshake_rhash_params = {
+	.key_len		= sizeof_field(struct handshake_req, hr_sk),
+	.key_offset		= offsetof(struct handshake_req, hr_sk),
+	.head_offset		= offsetof(struct handshake_req, hr_rhash),
+	.automatic_shrinking	= true,
+};
+
+int handshake_req_hash_init(void)
+{
+	return rhashtable_init(&handshake_rhashtbl, &handshake_rhash_params);
+}
+
+void handshake_req_hash_destroy(void)
+{
+	rhashtable_destroy(&handshake_rhashtbl);
+}
+
+struct handshake_req *handshake_req_hash_lookup(struct sock *sk)
+{
+	return rhashtable_lookup_fast(&handshake_rhashtbl, &sk,
+				      handshake_rhash_params);
+}
+
+static bool handshake_req_hash_add(struct handshake_req *req)
+{
+	int ret;
+
+	ret = rhashtable_lookup_insert_fast(&handshake_rhashtbl,
+					    &req->hr_rhash,
+					    handshake_rhash_params);
+	return ret == 0;
+}
+
+static void handshake_req_destroy(struct handshake_req *req)
+{
+	if (req->hr_proto->hp_destroy)
+		req->hr_proto->hp_destroy(req);
+	rhashtable_remove_fast(&handshake_rhashtbl, &req->hr_rhash,
+			       handshake_rhash_params);
+	kfree(req);
+}
+
+static void handshake_sk_destruct(struct sock *sk)
+{
+	void (*sk_destruct)(struct sock *sk);
+	struct handshake_req *req;
+
+	req = handshake_req_hash_lookup(sk);
+	if (!req)
+		return;
+
+	trace_handshake_destruct(sock_net(sk), req, sk);
+	sk_destruct = req->hr_odestruct;
+	handshake_req_destroy(req);
+	if (sk_destruct)
+		sk_destruct(sk);
+}
+
+/**
+ * handshake_req_alloc - Allocate a handshake request
+ * @proto: security protocol
+ * @flags: memory allocation flags
+ *
+ * Returns an initialized handshake_req or NULL.
+ */
+struct handshake_req *handshake_req_alloc(const struct handshake_proto *proto,
+					  gfp_t flags)
+{
+	struct handshake_req *req;
+
+	if (!proto)
+		return NULL;
+	if (proto->hp_handler_class <= HANDSHAKE_HANDLER_CLASS_NONE)
+		return NULL;
+	if (proto->hp_handler_class >= HANDSHAKE_HANDLER_CLASS_MAX)
+		return NULL;
+	if (!proto->hp_accept || !proto->hp_done)
+		return NULL;
+
+	req = kzalloc(struct_size(req, hr_priv, proto->hp_privsize), flags);
+	if (!req)
+		return NULL;
+
+	INIT_LIST_HEAD(&req->hr_list);
+	req->hr_proto = proto;
+	return req;
+}
+EXPORT_SYMBOL(handshake_req_alloc);
+
+/**
+ * handshake_req_private - Get per-handshake private data
+ * @req: handshake arguments
+ *
+ */
+void *handshake_req_private(struct handshake_req *req)
+{
+	return (void *)&req->hr_priv;
+}
+EXPORT_SYMBOL(handshake_req_private);
+
+static bool __add_pending_locked(struct handshake_net *hn,
+				 struct handshake_req *req)
+{
+	if (WARN_ON_ONCE(!list_empty(&req->hr_list)))
+		return false;
+	hn->hn_pending++;
+	list_add_tail(&req->hr_list, &hn->hn_requests);
+	return true;
+}
+
+static void __remove_pending_locked(struct handshake_net *hn,
+				    struct handshake_req *req)
+{
+	hn->hn_pending--;
+	list_del_init(&req->hr_list);
+}
+
+/*
+ * Returns %true if the request was found on @net's pending list,
+ * otherwise %false.
+ *
+ * If @req was on a pending list, it has not yet been accepted.
+ */
+static bool remove_pending(struct handshake_net *hn, struct handshake_req *req)
+{
+	bool ret = false;
+
+	spin_lock(&hn->hn_lock);
+	if (!list_empty(&req->hr_list)) {
+		__remove_pending_locked(hn, req);
+		ret = true;
+	}
+	spin_unlock(&hn->hn_lock);
+
+	return ret;
+}
+
+struct handshake_req *handshake_req_next(struct handshake_net *hn, int class)
+{
+	struct handshake_req *req, *pos;
+
+	req = NULL;
+	spin_lock(&hn->hn_lock);
+	list_for_each_entry(pos, &hn->hn_requests, hr_list) {
+		if (pos->hr_proto->hp_handler_class != class)
+			continue;
+		__remove_pending_locked(hn, pos);
+		req = pos;
+		break;
+	}
+	spin_unlock(&hn->hn_lock);
+
+	return req;
+}
+
+/**
+ * handshake_req_submit - Submit a handshake request
+ * @sock: open socket on which to perform the handshake
+ * @req: handshake arguments
+ * @flags: memory allocation flags
+ *
+ * Return values:
+ *   %0: Request queued
+ *   %-EINVAL: Invalid argument
+ *   %-EBUSY: A handshake is already under way for this socket
+ *   %-ESRCH: No handshake agent is available
+ *   %-EAGAIN: Too many pending handshake requests
+ *   %-ENOMEM: Failed to allocate memory
+ *   %-EMSGSIZE: Failed to construct notification message
+ *   %-EOPNOTSUPP: Handshake module not initialized
+ *
+ * A zero return value from handshake_req_submit() means that
+ * exactly one subsequent completion callback is guaranteed.
+ *
+ * A negative return value from handshake_req_submit() means that
+ * no completion callback will be done and that @req has been
+ * destroyed.
+ */
+int handshake_req_submit(struct socket *sock, struct handshake_req *req,
+			 gfp_t flags)
+{
+	struct handshake_net *hn;
+	struct net *net;
+	int ret;
+
+	if (!sock || !req || !sock->file) {
+		kfree(req);
+		return -EINVAL;
+	}
+
+	req->hr_sk = sock->sk;
+	if (!req->hr_sk) {
+		kfree(req);
+		return -EINVAL;
+	}
+	req->hr_odestruct = req->hr_sk->sk_destruct;
+	req->hr_sk->sk_destruct = handshake_sk_destruct;
+
+	ret = -EOPNOTSUPP;
+	net = sock_net(req->hr_sk);
+	hn = handshake_pernet(net);
+	if (!hn)
+		goto out_err;
+
+	ret = -EAGAIN;
+	if (READ_ONCE(hn->hn_pending) >= hn->hn_pending_max)
+		goto out_err;
+
+	spin_lock(&hn->hn_lock);
+	ret = -EOPNOTSUPP;
+	if (test_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags))
+		goto out_unlock;
+	ret = -EBUSY;
+	if (!handshake_req_hash_add(req))
+		goto out_unlock;
+	if (!__add_pending_locked(hn, req))
+		goto out_unlock;
+	spin_unlock(&hn->hn_lock);
+
+	ret = handshake_genl_notify(net, req->hr_proto->hp_handler_class,
+				    flags);
+	if (ret) {
+		trace_handshake_notify_err(net, req, req->hr_sk, ret);
+		if (remove_pending(hn, req))
+			goto out_err;
+	}
+
+	/* Prevent socket release while a handshake request is pending */
+	sock_hold(req->hr_sk);
+
+	trace_handshake_submit(net, req, req->hr_sk);
+	return 0;
+
+out_unlock:
+	spin_unlock(&hn->hn_lock);
+out_err:
+	trace_handshake_submit_err(net, req, req->hr_sk, ret);
+	handshake_req_destroy(req);
+	return ret;
+}
+EXPORT_SYMBOL(handshake_req_submit);
+
+void handshake_complete(struct handshake_req *req, unsigned int status,
+			struct genl_info *info)
+{
+	struct sock *sk = req->hr_sk;
+	struct net *net = sock_net(sk);
+
+	if (!test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
+		trace_handshake_complete(net, req, sk, status);
+		req->hr_proto->hp_done(req, status, info);
+
+		/* Handshake request is no longer pending */
+		sock_put(sk);
+	}
+}
+
+/**
+ * handshake_req_cancel - Cancel an in-progress handshake
+ * @sock: socket on which there is an ongoing handshake
+ *
+ * Request cancellation races with request completion. To determine
+ * who won, callers examine the return value from this function.
+ *
+ * Return values:
+ *   %true - Uncompleted handshake request was canceled or not found
+ *   %false - Handshake request already completed
+ */
+bool handshake_req_cancel(struct socket *sock)
+{
+	struct handshake_req *req;
+	struct handshake_net *hn;
+	struct sock *sk;
+	struct net *net;
+
+	sk = sock->sk;
+	net = sock_net(sk);
+	req = handshake_req_hash_lookup(sk);
+	if (!req) {
+		trace_handshake_cancel_none(net, req, sk);
+		return true;
+	}
+
+	hn = handshake_pernet(net);
+	if (hn && remove_pending(hn, req)) {
+		/* Request hadn't been accepted */
+		trace_handshake_cancel(net, req, sk);
+		sock_put(sk);
+		return true;
+	}
+	if (test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
+		/* Request already completed */
+		trace_handshake_cancel_busy(net, req, sk);
+		return false;
+	}
+
+	trace_handshake_cancel(net, req, sk);
+
+	/* Handshake request is no longer pending */
+	sock_put(sk);
+
+	return true;
+}
+EXPORT_SYMBOL(handshake_req_cancel);
diff --git a/net/handshake/trace.c b/net/handshake/trace.c
new file mode 100644
index 000000000000..1c4d8e27e17a
--- /dev/null
+++ b/net/handshake/trace.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Trace points for transport security layer handshakes.
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2023, Oracle and/or its affiliates.
+ */
+
+#include <linux/types.h>
+
+#include <net/sock.h>
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include "handshake.h"
+
+#define CREATE_TRACE_POINTS
+
+#include <trace/events/handshake.h>


