Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA5368E313
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 22:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBGVlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 16:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjBGVlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 16:41:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB6B298F8
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 13:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CDC4B819B4
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 21:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CBAC433EF;
        Tue,  7 Feb 2023 21:41:14 +0000 (UTC)
Subject: [PATCH v3 1/2] net/handshake: Create a NETLINK service for handling
 handshake requests
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        bcodding@redhat.com, kolga@netapp.com, jmeneghi@redhat.com
Date:   Tue, 07 Feb 2023 16:41:13 -0500
Message-ID: <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
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
we add a netlink service akin to NETLINK_ROUTE that can:

a. Notify a user space daemon that a handshake is needed.

b. Once notified, the daemon calls the kernel back via this
   netlink service to get the handshake parameters, including an
   open socket on which to establish the session.

The notification service uses a multicast group. Each handshake
protocol (eg, TLSv1.3, PSP, etc) adopts its own group number so that
the user space daemons for performing the handshakes are completely
independent of one another. The kernel can then tell via
netlink_has_listeners() whether a user space daemon is active and
can handle a handshake request for the desired security layer
protocol.

A new netlink operation, ACCEPT, acts like accept(2) in that it
instantiates a file descriptor in the user space daemon's fd table.
If this operation is successful, the reply carries the fd number,
which can be treated as an open and ready file descriptor.

While user space is performing the handshake, the kernel keeps its
muddy paws off the open socket. The act of closing the user space
file descriptor alerts the kernel that the open socket is safe to
use again. When the user daemon completes a handshake, the kernel is
responsible for checking that a valid transport layer security
session has been established.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/net/handshake.h            |   37 ++++
 include/net/net_namespace.h        |    1 
 include/net/sock.h                 |    1 
 include/uapi/linux/handshake.h     |   65 +++++++
 include/uapi/linux/netlink.h       |    1 
 net/Makefile                       |    1 
 net/handshake/Makefile             |   11 +
 net/handshake/netlink.c            |  320 ++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/netlink.h |    1 
 9 files changed, 438 insertions(+)
 create mode 100644 include/net/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/netlink.c

diff --git a/include/net/handshake.h b/include/net/handshake.h
new file mode 100644
index 000000000000..a439d823e828
--- /dev/null
+++ b/include/net/handshake.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * NETLINK_HANDSHAKE service.
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
+	struct list_head	hi_list;
+
+	struct socket		*hi_sock;
+	int			hi_fd;
+	int			hi_mcgrp;
+	int			hi_protocol;
+
+	struct sk_buff		*(*hi_accept)(struct handshake_info *hsi,
+					      struct sk_buff *skb,
+					      struct nlmsghdr *nlh);
+	void			(*hi_done)(struct handshake_info *hsi,
+					   struct sk_buff *skb,
+					   struct nlmsghdr *nlh,
+					   struct nlattr *args);
+};
+
+extern int handshake_request(struct handshake_info *hsi, gfp_t flags);
+
+#endif /* _NET_HANDSHAKE_H */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 8c3587d5c308..88fd0442249c 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -105,6 +105,7 @@ struct net {
 	struct sock		*genl_sock;
 
 	struct uevent_sock	*uevent_sock;		/* uevent socket */
+	struct sock		*hs_sock;		/* handshake requests */
 
 	struct hlist_head 	*dev_name_head;
 	struct hlist_head	*dev_index_head;
diff --git a/include/net/sock.h b/include/net/sock.h
index e0517ecc6531..de0510306e28 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -515,6 +515,7 @@ struct sock {
 
 	struct socket		*sk_socket;
 	void			*sk_user_data;
+	void			*sk_handshake_info;
 #ifdef CONFIG_SECURITY
 	void			*sk_security;
 #endif
diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
new file mode 100644
index 000000000000..39cab687eece
--- /dev/null
+++ b/include/uapi/linux/handshake.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * NETLINK_HANDSHAKE service.
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
+/* Multicast Netlink socket groups */
+enum handshake_nlgrps {
+	HANDSHAKE_NLGRP_NONE = 0,
+	__HANDSHAKE_NLGRP_MAX
+};
+#define HSNLGRP_MAX	(__HANDSHAKE_NLGRP_MAX - 1)
+
+enum handshake_nl_msgs {
+	HANDSHAKE_NL_MSG_BASE = NLMSG_MIN_TYPE,
+	HANDSHAKE_NL_MSG_READY,
+	HANDSHAKE_NL_MSG_ACCEPT,
+	HANDSHAKE_NL_MSG_DONE,
+	__HANDSHAKE_NL_MSG_MAX
+};
+#define HANDSHAKE_NL_MSG_MAX	(__HANDSHAKE_NL_MSG_MAX - 1)
+
+enum handshake_nl_attrs {
+	HANDSHAKE_NL_ATTR_UNSPEC = 0,
+	HANDSHAKE_NL_ATTR_MSG_STATUS,
+	HANDSHAKE_NL_ATTR_SOCKFD,
+	HANDSHAKE_NL_ATTR_PROTOCOL,
+	HANDSHAKE_NL_ATTR_ACCEPT_RESP,
+	HANDSHAKE_NL_ATTR_DONE_ARGS,
+
+	__HANDSHAKE_NL_ATTR_MAX
+};
+#define HANDSHAKE_NL_ATTR_MAX	(__HANDSHAKE_NL_ATTR_MAX - 1)
+
+enum handshake_nl_status {
+	HANDSHAKE_NL_STATUS_OK = 0,
+	HANDSHAKE_NL_STATUS_INVAL,
+	HANDSHAKE_NL_STATUS_BADF,
+	HANDSHAKE_NL_STATUS_NOTREADY,
+	HANDSHAKE_NL_STATUS_SYSTEMFAULT,
+};
+
+enum handshake_nl_protocol {
+	HANDSHAKE_NL_PROTO_UNSPEC = 0,
+};
+
+enum handshake_nl_tls_session_status {
+	HANDSHAKE_NL_TLS_SESS_STATUS_OK = 0,	/* session established */
+	HANDSHAKE_NL_TLS_SESS_STATUS_FAULT,	/* failure to launch */
+	HANDSHAKE_NL_TLS_SESS_STATUS_REJECTED,	/* remote hates us */
+};
+
+#endif /* _UAPI_LINUX_HANDSHAKE_H */
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index e2ae82e3f9f7..a29b2db5fa8a 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -29,6 +29,7 @@
 #define NETLINK_RDMA		20
 #define NETLINK_CRYPTO		21	/* Crypto layer */
 #define NETLINK_SMC		22	/* SMC monitoring */
+#define NETLINK_HANDSHAKE	23	/* transport layer sec handshake requests */
 
 #define NETLINK_INET_DIAG	NETLINK_SOCK_DIAG
 
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
index 000000000000..b27400c01427
--- /dev/null
+++ b/net/handshake/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the NETLINK_HANDSHAKE service
+#
+# Author: Chuck Lever <chuck.lever@oracle.com>
+#
+# Copyright (c) 2023, Oracle and/or its affiliates.
+#
+
+obj-y += handshake.o
+handshake-y := netlink.o
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
new file mode 100644
index 000000000000..49e05fa34df3
--- /dev/null
+++ b/net/handshake/netlink.c
@@ -0,0 +1,320 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * NETLINK_HANDSHAKE service
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
+#include <net/netlink.h>
+#include <net/handshake.h>
+
+#include <uapi/linux/handshake.h>
+
+static DEFINE_SPINLOCK(handshake_lock);
+static LIST_HEAD(handshake_pending);
+
+/*
+ * Send a "ready" notification to the multicast group for this
+ * security handshake type, in the same net namespace as @hi_sock.
+ */
+static int handshake_notify(struct handshake_info *hsi, gfp_t flags)
+{
+	struct net *net = sock_net(hsi->hi_sock->sk);
+	struct sock *nls = net->hs_sock;
+	struct sk_buff *msg;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (!netlink_has_listeners(nls, hsi->hi_mcgrp))
+		return -ESRCH;
+
+	err = -ENOMEM;
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, flags);
+	if (!msg)
+		goto out_err;
+	nlh = nlmsg_put(msg, 0, 0, HANDSHAKE_NL_MSG_READY, 0, 0);
+	if (!nlh)
+		goto out_err;
+	nlmsg_end(msg, nlh);
+
+	return nlmsg_notify(nls, msg, 0, hsi->hi_mcgrp, nlmsg_report(nlh),
+			    flags);
+
+out_err:
+	nlmsg_free(msg);
+	return err;
+}
+
+/**
+ * handshake_request - consumer API to request a handshake
+ * @hsi: socket and callback information
+ * @flags: memory allocation flags
+ *
+ * Return values:
+ *   %0: Request queued
+ *   %-ESRCH: No user space HANDSHAKE listeners
+ *   %-ENOMEM: Memory allocation failed
+ */
+int handshake_request(struct handshake_info *hsi, gfp_t flags)
+{
+	int ret;
+
+	spin_lock(&handshake_lock);
+	list_add(&hsi->hi_list, &handshake_pending);
+	hsi->hi_sock->sk->sk_handshake_info = NULL;
+	spin_unlock(&handshake_lock);
+
+	/* XXX: racy */
+	ret = handshake_notify(hsi, flags);
+	if (ret) {
+		spin_lock(&handshake_lock);
+		if (!list_empty(&hsi->hi_list))
+			list_del_init(&hsi->hi_list);
+		spin_unlock(&handshake_lock);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(handshake_request);
+
+static int handshake_accept(struct socket *sock)
+{
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
+	fd_install(fd, file);
+	return fd;
+}
+
+static const struct nla_policy
+handshake_nl_attr_policy[HANDSHAKE_NL_ATTR_MAX + 1] = {
+	[HANDSHAKE_NL_ATTR_MSG_STATUS] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_NL_ATTR_SOCKFD] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_NL_ATTR_PROTOCOL] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_NL_ATTR_ACCEPT_RESP] = {
+		.type = NLA_NESTED,
+	},
+	[HANDSHAKE_NL_ATTR_DONE_ARGS] = {
+		.type = NLA_NESTED,
+	},
+};
+
+static int handshake_nl_msg_unsupp(struct sk_buff *skb, struct nlmsghdr *nlh,
+				   struct nlattr **tb)
+{
+	pr_err("Handshake: Unknown command (%d) was ignored\n", nlh->nlmsg_type);
+	return -EINVAL;
+}
+
+static int handshake_nl_status_reply(struct sk_buff *skb, struct nlmsghdr *nlh,
+				     enum handshake_nl_status status)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlmsghdr *hdr;
+	struct sk_buff *msg;
+	int ret;
+
+	ret = -ENOMEM;
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		goto out;
+	hdr = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			nlh->nlmsg_type, 0, 0);
+	if (!hdr)
+		goto out_free;
+
+	ret = -EMSGSIZE;
+	ret = nla_put_u32(msg, HANDSHAKE_NL_ATTR_MSG_STATUS, status);
+	if (ret < 0)
+		goto out_free;
+
+	nlmsg_end(msg, hdr);
+	return nlmsg_unicast(net->hs_sock, msg, NETLINK_CB(skb).portid);
+
+out_free:
+	nlmsg_free(msg);
+out:
+	return ret;
+}
+
+static int handshake_nl_msg_accept(struct sk_buff *skb, struct nlmsghdr *nlh,
+				   struct nlattr **tb)
+{
+	struct net *net = sock_net(skb->sk);
+	struct handshake_info *pos, *hsi;
+	struct sk_buff *msg;
+	int protocol;
+
+	if (!tb[HANDSHAKE_NL_ATTR_PROTOCOL])
+		return handshake_nl_status_reply(skb, nlh,
+						 HANDSHAKE_NL_STATUS_INVAL);
+	protocol = nla_get_u32(tb[HANDSHAKE_NL_ATTR_PROTOCOL]);
+
+	hsi = NULL;
+	spin_lock(&handshake_lock);
+	list_for_each_entry(pos, &handshake_pending, hi_list) {
+		if (sock_net(pos->hi_sock->sk) != net)
+			continue;
+		if (pos->hi_protocol != protocol)
+			continue;
+
+		list_del_init(&pos->hi_list);
+		hsi = pos;
+		break;
+	}
+	spin_unlock(&handshake_lock);
+	if (!hsi)
+		return handshake_nl_status_reply(skb, nlh,
+						 HANDSHAKE_NL_STATUS_NOTREADY);
+
+	hsi->hi_fd = handshake_accept(hsi->hi_sock);
+	if (hsi->hi_fd < 0)
+		return handshake_nl_status_reply(skb, nlh,
+						 HANDSHAKE_NL_STATUS_SYSTEMFAULT);
+
+	msg = hsi->hi_accept(hsi, skb, nlh);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
+
+	hsi->hi_sock->sk->sk_handshake_info = hsi;
+	return nlmsg_unicast(net->hs_sock, msg, NETLINK_CB(skb).portid);
+}
+
+/*
+ * This function is careful to not close the socket. It merely removes
+ * it from the file descriptor table so that it is no longer visible
+ * to the calling process.
+ */
+static int handshake_nl_msg_done(struct sk_buff *skb, struct nlmsghdr *nlh,
+				 struct nlattr **tb)
+{
+	struct handshake_info *hsi;
+	struct socket *sock;
+	int fd, err;
+
+	if (!tb[HANDSHAKE_NL_ATTR_SOCKFD])
+		return handshake_nl_status_reply(skb, nlh,
+						 HANDSHAKE_NL_STATUS_INVAL);
+
+	err = 0;
+	fd = nla_get_u32(tb[HANDSHAKE_NL_ATTR_SOCKFD]);
+	sock = sockfd_lookup(fd, &err);
+	if (err)
+		return handshake_nl_status_reply(skb, nlh,
+						 HANDSHAKE_NL_STATUS_BADF);
+
+	put_unused_fd(fd);
+
+	hsi = sock->sk->sk_handshake_info;
+	if (hsi) {
+		hsi->hi_done(hsi, skb, nlh, tb[HANDSHAKE_NL_ATTR_DONE_ARGS]);
+		sock->sk->sk_handshake_info = NULL;
+	}
+	return 0;
+}
+
+static const struct handshake_link {
+	int (*doit)(struct sk_buff *skb, struct nlmsghdr *nlh,
+		    struct nlattr **tb);
+} handshake_dispatch[] = {
+	[HANDSHAKE_NL_MSG_ACCEPT - HANDSHAKE_NL_MSG_BASE] = {
+		.doit	= handshake_nl_msg_accept,
+	},
+	[HANDSHAKE_NL_MSG_DONE - HANDSHAKE_NL_MSG_BASE] = {
+		.doit	= handshake_nl_msg_done,
+	},
+};
+
+static int handshake_nl_rcv_skb(struct sk_buff *skb, struct nlmsghdr *nlh,
+				struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[HANDSHAKE_NL_ATTR_MAX + 1];
+	const struct handshake_link *link;
+	int err;
+
+	if (!netlink_net_capable(skb, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (nlh->nlmsg_type > HANDSHAKE_NL_MSG_MAX)
+		return handshake_nl_msg_unsupp(skb, nlh, tb);
+	link = &handshake_dispatch[nlh->nlmsg_type - HANDSHAKE_NL_MSG_BASE];
+	if (!link->doit)
+		return handshake_nl_msg_unsupp(skb, nlh, tb);
+
+	err = nlmsg_parse(nlh, 0, tb, HANDSHAKE_NL_ATTR_MAX,
+			  handshake_nl_attr_policy, extack);
+	if (err < 0)
+		return err;
+
+	return link->doit(skb, nlh, tb);
+}
+
+static void handshake_nl_rcv(struct sk_buff *skb)
+{
+	static DEFINE_MUTEX(handshake_mutex);
+
+	mutex_lock(&handshake_mutex);
+	netlink_rcv_skb(skb, &handshake_nl_rcv_skb);
+	mutex_unlock(&handshake_mutex);
+}
+
+static int __net_init handshake_nl_net_init(struct net *net)
+{
+	struct netlink_kernel_cfg cfg = {
+		.groups		= HSNLGRP_MAX,
+		.input		= handshake_nl_rcv,
+	};
+
+	net->hs_sock = netlink_kernel_create(net, NETLINK_HANDSHAKE, &cfg);
+	return net->hs_sock == NULL ? -ENOMEM : 0;
+}
+
+static void __net_exit handshake_nl_net_exit(struct net *net)
+{
+	netlink_kernel_release(net->hs_sock);
+	net->hs_sock = NULL;
+}
+
+static struct pernet_operations handshake_nl_net_ops = {
+	.init		= handshake_nl_net_init,
+	.exit		= handshake_nl_net_exit,
+};
+
+static int __init handshake_nl_init(void)
+{
+	return register_pernet_subsys(&handshake_nl_net_ops);
+}
+
+static void __exit handshake_nl_exit(void)
+{
+	unregister_pernet_subsys(&handshake_nl_net_ops);
+}
+
+module_init(handshake_nl_init);
+module_exit(handshake_nl_exit);
diff --git a/tools/include/uapi/linux/netlink.h b/tools/include/uapi/linux/netlink.h
index 0a4d73317759..a269d356f358 100644
--- a/tools/include/uapi/linux/netlink.h
+++ b/tools/include/uapi/linux/netlink.h
@@ -29,6 +29,7 @@
 #define NETLINK_RDMA		20
 #define NETLINK_CRYPTO		21	/* Crypto layer */
 #define NETLINK_SMC		22	/* SMC monitoring */
+#define NETLINK_HANDSHAKE	23	/* transport layer sec handshake requests */
 
 #define NETLINK_INET_DIAG	NETLINK_SOCK_DIAG
 


