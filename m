Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3C469846D
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBOTXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjBOTXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:23:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809D93E085
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:23:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04BFA61BD5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 19:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6772C433D2;
        Wed, 15 Feb 2023 19:23:15 +0000 (UTC)
Subject: [PATCH v4 1/2] net/handshake: Create a NETLINK service for handling
 handshake requests
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, chuck.lever@oracle.com, hare@suse.com,
        dhowells@redhat.com, bcodding@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com
Date:   Wed, 15 Feb 2023 14:23:14 -0500
Message-ID: <167648899461.5586.1581702417186195077.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167648817566.5586.11847329328944648217.stgit@91.116.238.104.host.secureserver.net>
References: <167648817566.5586.11847329328944648217.stgit@91.116.238.104.host.secureserver.net>
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
protocol (eg, TLSv1.3, PSP, etc) adopts its own group number so that
the user space daemons for performing handshakes are completely
independent of one another. The kernel can then tell via
netlink_has_listeners() whether a user space daemon is active and
can handle a handshake request for the desired security layer
protocol.

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
 include/net/handshake.h        |   46 +++++
 include/net/net_namespace.h    |    5 +
 include/net/sock.h             |    1 
 include/uapi/linux/handshake.h |   56 ++++++
 net/Makefile                   |    1 
 net/handshake/Makefile         |   11 +
 net/handshake/handshake.h      |   43 +++++
 net/handshake/netlink.c        |  370 ++++++++++++++++++++++++++++++++++++++++
 net/handshake/request.c        |  160 +++++++++++++++++
 9 files changed, 693 insertions(+)
 create mode 100644 include/net/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/handshake.h
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/handshake/request.c

diff --git a/include/net/handshake.h b/include/net/handshake.h
new file mode 100644
index 000000000000..ca401c08c541
--- /dev/null
+++ b/include/net/handshake.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Generic HANDSHAKE service.
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
+struct handshake_req;
+
+/*
+ * Invariants for all handshake requests for one transport layer
+ * security protocol
+ */
+struct handshake_proto {
+	int			hp_protocol;
+	int			hp_mcgrp;
+	size_t			hp_privsize;
+
+	int			(*hp_accept)(struct handshake_req *req,
+					     struct genl_info *gi, int fd);
+	void			(*hp_done)(struct handshake_req *req,
+					   int status, struct nlattr *args);
+	void			(*hp_destroy)(struct handshake_req *req);
+};
+
+extern struct handshake_req *
+handshake_req_alloc(struct socket *sock, const struct handshake_proto *proto,
+		    gfp_t flags);
+extern void *handshake_req_private(struct handshake_req *req);
+extern int handshake_req_submit(struct handshake_req *req, gfp_t flags);
+extern void handshake_req_cancel(struct socket *sock);
+
+extern struct nlmsghdr *handshake_genl_put(struct sk_buff *msg,
+					   struct genl_info *gi);
+
+#endif /* _NET_HANDSHAKE_H */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 8c3587d5c308..a66309789560 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -186,6 +186,11 @@ struct net {
 #if IS_ENABLED(CONFIG_SMC)
 	struct netns_smc	smc;
 #endif
+
+	/* transport layer security handshake requests */
+	spinlock_t		hs_lock;
+	struct list_head	hs_requests;
+	int			hs_pending;
 } __randomize_layout;
 
 #include <linux/seq_file_net.h>
diff --git a/include/net/sock.h b/include/net/sock.h
index e0517ecc6531..e16e63ff61f2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -515,6 +515,7 @@ struct sock {
 
 	struct socket		*sk_socket;
 	void			*sk_user_data;
+	void			*sk_handshake_req;
 #ifdef CONFIG_SECURITY
 	void			*sk_security;
 #endif
diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
new file mode 100644
index 000000000000..9544edeb181f
--- /dev/null
+++ b/include/uapi/linux/handshake.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * GENL HANDSHAKE service.
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
+#define HANDSHAKE_GENL_NAME	"handshake"
+#define HANDSHAKE_GENL_VERSION	0x01
+
+enum handshake_genl_mcgrps {
+	HANDSHAKE_GENL_MCGRP_NONE = 0,
+};
+
+#define HANDSHAKE_GENL_MCGRP_NONE_NAME	"none"
+
+enum handshake_genl_cmds {
+	HANDSHAKE_GENL_CMD_UNSPEC = 0,
+	HANDSHAKE_GENL_CMD_READY,
+	HANDSHAKE_GENL_CMD_ACCEPT,
+	HANDSHAKE_GENL_CMD_DONE,
+
+	__HANDSHAKE_GENL_CMD_MAX
+};
+#define HANDSHAKE_GENL_CMD_MAX	(__HANDSHAKE_GENL_CMD_MAX - 1)
+
+enum handshake_genl_attrs {
+	HANDSHAKE_GENL_ATTR_UNSPEC = 0,
+	HANDSHAKE_GENL_ATTR_MSG_STATUS,
+	HANDSHAKE_GENL_ATTR_SESS_STATUS,
+	HANDSHAKE_GENL_ATTR_SOCKFD,
+	HANDSHAKE_GENL_ATTR_PROTOCOL,
+
+	HANDSHAKE_GENL_ATTR_ACCEPT,
+	HANDSHAKE_GENL_ATTR_DONE,
+
+	__HANDSHAKE_GENL_ATTR_MAX
+};
+#define HANDSHAKE_GENL_ATTR_MAX	(__HANDSHAKE_GENL_ATTR_MAX - 1)
+
+enum handshake_genl_protocol {
+	HANDSHAKE_GENL_PROTO_UNSPEC = 0,
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
index 000000000000..824e08c626af
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
+handshake-y := netlink.o request.o
diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
new file mode 100644
index 000000000000..1cbcfc632a24
--- /dev/null
+++ b/net/handshake/handshake.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Generic netlink handshake service
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2023, Oracle and/or its affiliates.
+ */
+
+/*
+ * Data structures and functions that are visible only within the
+ * handshake module are declared here.
+ */
+
+#ifndef _INTERNAL_HANDSHAKE_H
+#define _INTERNAL_HANDSHAKE_H
+
+/*
+ * One handshake request
+ */
+struct handshake_req {
+	refcount_t			hr_ref;
+	struct list_head		hr_list;
+	unsigned long			hr_flags;
+	const struct handshake_proto	*hr_proto;
+	struct socket			*hr_sock;
+	int				hr_fd;
+};
+
+#define HANDSHAKE_F_COMPLETED	BIT(0)
+
+int handshake_genl_notify(struct net *net, struct handshake_req *req,
+			  gfp_t flags);
+void handshake_complete(struct handshake_req *req, int status,
+			struct nlattr *args);
+
+struct handshake_req *handshake_req_get(struct handshake_req *req);
+void handshake_req_put(struct handshake_req *req);
+
+void add_pending_locked(struct net *net, struct handshake_req *req);
+bool handshake_remove_pending(struct net *net, struct handshake_req *req);
+
+#endif /* _INTERNAL_HANDSHAKE_H */
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
new file mode 100644
index 000000000000..8d0bf11396a7
--- /dev/null
+++ b/net/handshake/netlink.c
@@ -0,0 +1,370 @@
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
+void add_pending_locked(struct net *net, struct handshake_req *req)
+{
+	net->hs_pending++;
+	list_add_tail(&req->hr_list, &net->hs_requests);
+}
+
+static void remove_pending_locked(struct net *net, struct handshake_req *req)
+{
+	net->hs_pending--;
+	list_del_init(&req->hr_list);
+}
+
+/*
+ * Returns true if this req was on the pending list.
+ */
+bool handshake_remove_pending(struct net *net, struct handshake_req *req)
+{
+	struct sock *sk = req->hr_sock->sk;
+	bool ret;
+
+	ret = false;
+
+	spin_lock(&net->hs_lock);
+	if (!list_empty(&req->hr_list)) {
+		remove_pending_locked(net, req);
+		ret = true;
+	}
+	sk->sk_handshake_req = NULL;
+	spin_unlock(&net->hs_lock);
+
+	return ret;
+}
+
+void handshake_complete(struct handshake_req *req, int status,
+			struct nlattr *args)
+{
+	if (!test_and_set_bit(HANDSHAKE_F_COMPLETED, &req->hr_flags)) {
+		req->hr_proto->hp_done(req, status, args);
+		req->hr_sock->sk->sk_handshake_req = NULL;
+	}
+	handshake_req_put(req);
+}
+
+int handshake_genl_notify(struct net *net, struct handshake_req *req,
+			  gfp_t flags)
+{
+	struct sk_buff *skb;
+	void *hdr;
+
+	if (!genl_has_listeners(&handshake_genl_family, net,
+				req->hr_proto->hp_mcgrp))
+		return -ESRCH;
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(skb, 0, 0, &handshake_genl_family, 0,
+			  HANDSHAKE_GENL_CMD_READY);
+	if (!hdr) {
+		nlmsg_free(skb);
+		return -EMSGSIZE;
+	}
+
+	genlmsg_end(skb, hdr);
+	return genlmsg_multicast(&handshake_genl_family, skb, 0,
+				 req->hr_proto->hp_mcgrp, flags);
+}
+
+static int handshake_accept(struct handshake_req *req)
+{
+	struct socket *sock = req->hr_sock;
+	int flags = O_CLOEXEC;
+	struct file *file;
+	int fd;
+
+	fd = get_unused_fd_flags(flags);
+	if (fd < 0)
+		return fd;
+	file = sock_alloc_file(sock, flags, sock->sk->sk_prot_creator->name);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		return PTR_ERR(file);
+	}
+
+	req->hr_fd = fd;
+	fd_install(fd, file);
+	return 0;
+}
+
+static const struct nla_policy
+handshake_genl_policy[HANDSHAKE_GENL_ATTR_MAX + 1] = {
+	[HANDSHAKE_GENL_ATTR_MSG_STATUS] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_SESS_STATUS] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_SOCKFD] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_PROTOCOL] = {
+		.type = NLA_U32
+	},
+
+	[HANDSHAKE_GENL_ATTR_ACCEPT] = {
+		.type = NLA_NESTED,
+	},
+	[HANDSHAKE_GENL_ATTR_DONE] = {
+		.type = NLA_NESTED,
+	},
+};
+
+/**
+ * handshake_genl_put - Create a generic netlink message header
+ * @msg: buffer in which to create the header
+ * @gi: generic netlink message context
+ *
+ * Returns a ready-to-use header, or NULL.
+ */
+struct nlmsghdr *handshake_genl_put(struct sk_buff *msg, struct genl_info *gi)
+{
+	return genlmsg_put(msg, gi->snd_portid, gi->snd_seq,
+			   &handshake_genl_family, 0, gi->genlhdr->cmd);
+}
+EXPORT_SYMBOL(handshake_genl_put);
+
+static int handshake_genl_status_reply(struct sk_buff *skb,
+				       struct genl_info *gi, int status)
+{
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
+		goto out_free;
+
+	ret = -EMSGSIZE;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_MSG_STATUS, status);
+	if (ret < 0)
+		goto out_free;
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, gi);
+
+out_free:
+	genlmsg_cancel(msg, hdr);
+out:
+	return ret;
+}
+
+static int handshake_genl_cmd_accept(struct sk_buff *skb, struct genl_info *gi)
+{
+	struct nlattr *tb[HANDSHAKE_GENL_ATTR_MAX + 1];
+	struct net *net = sock_net(skb->sk);
+	struct handshake_req *pos, *req;
+	int err;
+
+	err = genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
+			    HANDSHAKE_GENL_ATTR_MAX, handshake_genl_policy,
+			    NULL);
+	if (err) {
+		pr_err_ratelimited("%s: genlmsg_parse() returned %d\n",
+				   __func__, err);
+		return err;
+	}
+
+	if (!tb[HANDSHAKE_GENL_ATTR_PROTOCOL])
+		return handshake_genl_status_reply(skb, gi, -EINVAL);
+
+	req = NULL;
+	spin_lock(&net->hs_lock);
+	list_for_each_entry(pos, &net->hs_requests, hr_list) {
+		if (pos->hr_proto->hp_protocol !=
+		    nla_get_u32(tb[HANDSHAKE_GENL_ATTR_PROTOCOL]))
+			continue;
+		remove_pending_locked(net, pos);
+		req = handshake_req_get(pos);
+		break;
+	}
+	spin_unlock(&net->hs_lock);
+	if (!req)
+		return handshake_genl_status_reply(skb, gi, -EAGAIN);
+
+	err = handshake_accept(req);
+	if (err < 0) {
+		handshake_complete(req, -EIO, NULL);
+		handshake_req_put(req);
+		return handshake_genl_status_reply(skb, gi, err);
+	}
+	err = req->hr_proto->hp_accept(req, gi, req->hr_fd);
+	if (err) {
+		put_unused_fd(req->hr_fd);
+		handshake_complete(req, -EIO, NULL);
+		handshake_req_put(req);
+		return err;
+	}
+	return 0;
+}
+
+/*
+ * This function is careful to not close the socket. It merely removes
+ * it from the file descriptor table so that it is no longer visible
+ * to the calling process.
+ */
+static int handshake_genl_cmd_done(struct sk_buff *skb, struct genl_info *gi)
+{
+	struct nlattr *tb[HANDSHAKE_GENL_ATTR_MAX + 1];
+	struct handshake_req *req;
+	struct socket *sock;
+	int fd, status, err;
+
+	err = genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
+			    HANDSHAKE_GENL_ATTR_MAX, handshake_genl_policy,
+			    NULL);
+	if (err) {
+		pr_err_ratelimited("%s: genlmsg_parse() returned %d\n",
+				   __func__, err);
+		return err;
+	}
+
+	if (!tb[HANDSHAKE_GENL_ATTR_SOCKFD])
+		return handshake_genl_status_reply(skb, gi, -EINVAL);
+	err = 0;
+	fd = nla_get_u32(tb[HANDSHAKE_GENL_ATTR_SOCKFD]);
+	sock = sockfd_lookup(fd, &err);
+	if (err)
+		return handshake_genl_status_reply(skb, gi, -EBADF);
+
+	req = sock->sk->sk_handshake_req;
+	if (req->hr_fd != fd)	/* sanity */
+		return handshake_genl_status_reply(skb, gi, -EBADF);
+
+	status = -EIO;
+	if (tb[HANDSHAKE_GENL_ATTR_SESS_STATUS])
+		status = nla_get_u32(tb[HANDSHAKE_GENL_ATTR_SESS_STATUS]);
+
+	put_unused_fd(req->hr_fd);
+	handshake_complete(req, status, tb[HANDSHAKE_GENL_ATTR_DONE]);
+	handshake_req_put(req);
+	return 0;
+}
+
+static const struct genl_ops handshake_genl_ops[] = {
+	{
+		.cmd		= HANDSHAKE_GENL_CMD_ACCEPT,
+		.doit		= handshake_genl_cmd_accept,
+		.flags		= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd		= HANDSHAKE_GENL_CMD_DONE,
+		.doit		= handshake_genl_cmd_done,
+		.flags		= GENL_ADMIN_PERM,
+	},
+};
+
+static const struct genl_multicast_group handshake_genl_mcgrps[] = {
+	[HANDSHAKE_GENL_MCGRP_NONE] = {
+		.name		= HANDSHAKE_GENL_MCGRP_NONE_NAME,
+	},
+};
+
+static struct genl_family __ro_after_init handshake_genl_family = {
+	.hdrsize		= 0,
+	.name			= HANDSHAKE_GENL_NAME,
+	.version		= HANDSHAKE_GENL_VERSION,
+	.maxattr		= HANDSHAKE_GENL_ATTR_MAX,
+	.netnsok		= true,
+	.n_mcgrps		= ARRAY_SIZE(handshake_genl_mcgrps),
+	.n_ops			= ARRAY_SIZE(handshake_genl_ops),
+	.resv_start_op		= HANDSHAKE_GENL_CMD_MAX,
+	.policy			= handshake_genl_policy,
+	.ops			= handshake_genl_ops,
+	.mcgrps			= handshake_genl_mcgrps,
+	.module			= THIS_MODULE,
+};
+
+static int __net_init handshake_net_init(struct net *net)
+{
+	spin_lock_init(&net->hs_lock);
+	INIT_LIST_HEAD(&net->hs_requests);
+	net->hs_pending	= 0;
+	return 0;
+}
+
+static void __net_exit handshake_net_exit(struct net *net)
+{
+	struct handshake_req *req;
+	LIST_HEAD(requests);
+
+	/*
+	 * XXX: This drains the net's pending list, but does
+	 *	nothing about requests that have been accepted
+	 *	and are in progress.
+	 */
+	spin_lock(&net->hs_lock);
+	list_splice_init(&requests, &net->hs_requests);
+	spin_unlock(&net->hs_lock);
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
+static struct pernet_operations handshake_genl_net_ops = {
+	.init		= handshake_net_init,
+	.exit		= handshake_net_exit,
+};
+
+static int __init handshake_init(void)
+{
+	int ret;
+
+	ret = genl_register_family(&handshake_genl_family);
+	if (ret)
+		return ret;
+
+	ret = register_pernet_subsys(&handshake_genl_net_ops);
+	if (ret)
+		genl_unregister_family(&handshake_genl_family);
+
+	return ret;
+}
+
+static void __exit handshake_exit(void)
+{
+	unregister_pernet_subsys(&handshake_genl_net_ops);
+	genl_unregister_family(&handshake_genl_family);
+}
+
+module_init(handshake_init);
+module_exit(handshake_exit);
diff --git a/net/handshake/request.c b/net/handshake/request.c
new file mode 100644
index 000000000000..bf56703ea1f5
--- /dev/null
+++ b/net/handshake/request.c
@@ -0,0 +1,160 @@
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
+
+#include <net/sock.h>
+#include <net/genetlink.h>
+#include <net/handshake.h>
+
+#include <uapi/linux/handshake.h>
+#include "handshake.h"
+
+/*
+ * This limit is to prevent slow remotes from causing denial of service.
+ * A ulimit-style tunable might be used instead.
+ */
+#define HANDSHAKE_PENDING_MAX (10)
+
+struct handshake_req *handshake_req_get(struct handshake_req *req)
+{
+	return likely(refcount_inc_not_zero(&req->hr_ref)) ? req : NULL;
+}
+
+static void handshake_req_destroy(struct handshake_req *req)
+{
+	__sock_put(req->hr_sock->sk);
+	req->hr_proto->hp_destroy(req);
+	kfree(req);
+}
+
+void handshake_req_put(struct handshake_req *req)
+{
+	if (refcount_dec_and_test(&req->hr_ref))
+		handshake_req_destroy(req);
+}
+
+/**
+ * handshake_req_alloc - consumer API to allocate a request
+ * @sock: open socket on which to perform a handshake
+ * @proto: security protocol
+ * @flags: memory allocation flags
+ *
+ * Returns an initialized handshake_req or NULL.
+ */
+struct handshake_req *handshake_req_alloc(struct socket *sock,
+					  const struct handshake_proto *proto,
+					  gfp_t flags)
+{
+	struct handshake_req *req;
+
+	req = kzalloc(sizeof(*req) + proto->hp_privsize, flags);
+	if (!req)
+		return NULL;
+
+	sock_hold(sock->sk);
+
+	refcount_set(&req->hr_ref, 1);
+	INIT_LIST_HEAD(&req->hr_list);
+	req->hr_sock = sock;
+	req->hr_proto = proto;
+	return req;
+}
+EXPORT_SYMBOL(handshake_req_alloc);
+
+/**
+ * handshake_req_private - consumer API to return per-handshake private data
+ * @req: handshake arguments
+ *
+ */
+void *handshake_req_private(struct handshake_req *req)
+{
+	return (void *)(req + 1);
+}
+EXPORT_SYMBOL(handshake_req_private);
+
+/**
+ * handshake_req_submit - consumer API to submit a handshake request
+ * @req: handshake arguments
+ * @flags: memory allocation flags
+ *
+ * Return values:
+ *   %0: Request queued
+ *   %-EBUSY: A handshake is already under way for this socket
+ *   %-ESRCH: No handshake agent is available
+ *   %-EAGAIN: Too many pending handshake requests
+ *   %-ENOMEM: Failed to allocate memory
+ *   %-EMSGSIZE: Failed to construct notification message
+ *
+ * A zero return value from handshake_request() means that
+ * exactly one subsequent completion callback is guaranteed.
+ *
+ * A negative return value from handshake_request() means that
+ * no completion callback will be done and that @req is
+ * destroyed.
+ */
+int handshake_req_submit(struct handshake_req *req, gfp_t flags)
+{
+	struct sock *sk = req->hr_sock->sk;
+	struct net *net = sock_net(sk);
+	int ret;
+
+	ret = -EAGAIN;
+	if (READ_ONCE(net->hs_pending) >= HANDSHAKE_PENDING_MAX)
+		goto out_err;
+
+	ret = -EBUSY;
+	spin_lock(&net->hs_lock);
+	if (sk->sk_handshake_req || !list_empty(&req->hr_list)) {
+		spin_unlock(&net->hs_lock);
+		goto out_err;
+	}
+
+	add_pending_locked(net, req);
+	sk->sk_handshake_req = req;
+	spin_unlock(&net->hs_lock);
+
+	ret = handshake_genl_notify(net, req, flags);
+	if (ret)
+		if (handshake_remove_pending(net, req))
+			goto out_err;
+
+	return 0;
+
+out_err:
+	handshake_req_put(req);
+	return ret;
+}
+EXPORT_SYMBOL(handshake_req_submit);
+
+/**
+ * handshake_req_cancel - consumer API to cancel an in-progress handshake
+ * @sock: socket on which there is an ongoing handshake
+ *
+ * The consumer must discard @sock immediately when this function
+ * returns.
+ */
+void handshake_req_cancel(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct handshake_req *req = sk->sk_handshake_req;
+
+	if (!req)
+		return;
+
+	handshake_remove_pending(sock_net(sk), req);
+	handshake_complete(req, -ERESTARTSYS, NULL);
+}
+EXPORT_SYMBOL(handshake_req_cancel);


