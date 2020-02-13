Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995C915BB4B
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgBMJOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:14:49 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39215 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729526AbgBMJOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 04:14:48 -0500
Received: by mail-pj1-f68.google.com with SMTP id e9so2137889pjr.4
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 01:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bozQoY8nkaFSIsD6xlBz45dkKkURf6wmZHy/SBIuguM=;
        b=Kt/mCZ5SiRp81tNszK9S8CohqWBMyxqlYG/jKSb8PhMvp674b6UVyXA+RPNuPdlPXv
         y54gZRKv6RNooxbsY7Pzox5Ywwribw/i+IymYvM1eBkFwIms2xnKuG6WYBQQsS2j7S7U
         Z4wBM4ALmi41piKyI3cUswNyc17fH/NsvgIcpLN62r4ue2lhyl/u+PHBBhF8DtqvkmVV
         zepFFJv33eHcLSUCirrn1OXkxSnwo8VeyOQixECiEPxvg6VTC0y4fBoMtd+nsLUz0+MN
         uorDzyJLywmsHZJKWwaW99ygtWP833NfrffRrwJ7qCW16HKAAWFxSEa/heLAEkBI1Pws
         cOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bozQoY8nkaFSIsD6xlBz45dkKkURf6wmZHy/SBIuguM=;
        b=IKh9fCFFJ9dmn/fY5mCgjOnC+IhXqg6uo81VAXvxzfHv8y07OIp9xQTH30LaZDNubT
         ddovfNjDp8u1WXSJsyoSc+hRd1kbxGzjp1mrMDBh8444N2n5WA6zysyYcV65v9z6n65D
         WeM4iH8XEb13bUu9LbXhUM9H/ICymPdRzt3qQrP6Y66WUVQhXOf91WpLsEDSLHsatYYx
         rfv0HM5DXeddmH8IkHQQvjNQ68EMm4w1Vr2oP5CYrli4IkmROxyVqvZY2XS+UhEgY+Jf
         FPLrRVcEtORPpSt0gj/BotHckEJHKOSjzrn6dRTrjMqsTC/NrLv6Ehgql0HjRw17gCwb
         UN+Q==
X-Gm-Message-State: APjAAAU7/DSiusigc7Ev+waYUqSgjAiLSsB48tb/c+cJtfb7O1zMj3Yj
        OexqWhyq2FZq2lxaY/2zsHLw
X-Google-Smtp-Source: APXvYqxNwUNwR5RO4Ur4R33W2ZZLNm8L1elvaXpuXy5BACXu++JnWl8U11xhgB+ZRjXLnuOKBzcYSg==
X-Received: by 2002:a17:902:ba8b:: with SMTP id k11mr12434684pls.208.1581585287564;
        Thu, 13 Feb 2020 01:14:47 -0800 (PST)
Received: from localhost.localdomain ([103.59.133.81])
        by smtp.googlemail.com with ESMTPSA id s206sm2294391pfs.100.2020.02.13.01.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 01:14:47 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 1/2] net: qrtr: Migrate nameservice to kernel from userspace
Date:   Thu, 13 Feb 2020 14:44:26 +0530
Message-Id: <20200213091427.13435-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
References: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QRTR nameservice has been maintained in userspace for some time. This
commit migrates it to Linux kernel. This change is required in order to
eliminate the need of starting a userspace daemon for making the WiFi
functional for ath11k based devices.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 net/qrtr/Makefile |   2 +-
 net/qrtr/ns.c     | 730 ++++++++++++++++++++++++++++++++++++++++++++++
 net/qrtr/qrtr.c   |  48 +--
 net/qrtr/qrtr.h   |   4 +
 4 files changed, 745 insertions(+), 39 deletions(-)
 create mode 100644 net/qrtr/ns.c

diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
index 1c6d6c120fb7..32d4e923925d 100644
--- a/net/qrtr/Makefile
+++ b/net/qrtr/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_QRTR) := qrtr.o
+obj-$(CONFIG_QRTR) := qrtr.o ns.o
 
 obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
 qrtr-smd-y	:= smd.o
diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
new file mode 100644
index 000000000000..7916b55364c1
--- /dev/null
+++ b/net/qrtr/ns.c
@@ -0,0 +1,730 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright (c) 2015, Sony Mobile Communications Inc.
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2020, Linaro Ltd.
+ */
+
+#include <linux/module.h>
+#include <linux/qrtr.h>
+#include <linux/workqueue.h>
+#include <net/sock.h>
+
+#include "qrtr.h"
+
+static RADIX_TREE(nodes, GFP_KERNEL);
+
+static struct {
+	struct socket *sock;
+	struct sockaddr_qrtr bcast_sq;
+	struct list_head lookups;
+	struct workqueue_struct *workqueue;
+	struct work_struct work;
+	int local_node;
+} qrtr_ns;
+
+static const char * const qrtr_ctrl_pkt_strings[] = {
+	[QRTR_TYPE_HELLO]	= "hello",
+	[QRTR_TYPE_BYE]		= "bye",
+	[QRTR_TYPE_NEW_SERVER]	= "new-server",
+	[QRTR_TYPE_DEL_SERVER]	= "del-server",
+	[QRTR_TYPE_DEL_CLIENT]	= "del-client",
+	[QRTR_TYPE_RESUME_TX]	= "resume-tx",
+	[QRTR_TYPE_EXIT]	= "exit",
+	[QRTR_TYPE_PING]	= "ping",
+	[QRTR_TYPE_NEW_LOOKUP]	= "new-lookup",
+	[QRTR_TYPE_DEL_LOOKUP]	= "del-lookup",
+};
+
+struct qrtr_server_filter {
+	unsigned int service;
+	unsigned int instance;
+	unsigned int ifilter;
+};
+
+struct qrtr_lookup {
+	unsigned int service;
+	unsigned int instance;
+
+	struct sockaddr_qrtr sq;
+	struct list_head li;
+};
+
+struct qrtr_server {
+	unsigned int service;
+	unsigned int instance;
+
+	unsigned int node;
+	unsigned int port;
+
+	struct list_head qli;
+};
+
+struct qrtr_node {
+	unsigned int id;
+	struct radix_tree_root servers;
+};
+
+static struct qrtr_node *node_get(unsigned int node_id)
+{
+	struct qrtr_node *node;
+
+	node = radix_tree_lookup(&nodes, node_id);
+	if (node)
+		return node;
+
+	/* If node didn't exist, allocate and insert it to the tree */
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+
+	node->id = node_id;
+
+	radix_tree_insert(&nodes, node_id, node);
+
+	return node;
+}
+
+static int server_match(const struct qrtr_server *srv,
+			const struct qrtr_server_filter *f)
+{
+	unsigned int ifilter = f->ifilter;
+
+	if (f->service != 0 && srv->service != f->service)
+		return 0;
+	if (!ifilter && f->instance)
+		ifilter = ~0;
+
+	return (srv->instance & ifilter) == f->instance;
+}
+
+static int service_announce_new(struct sockaddr_qrtr *dest,
+				struct qrtr_server *srv)
+{
+	struct qrtr_ctrl_pkt pkt;
+	struct msghdr msg = { };
+	struct kvec iv = { &pkt, sizeof(pkt) };
+
+	trace_printk("advertising new server [%d:%x]@[%d:%d]\n",
+		     srv->service, srv->instance, srv->node, srv->port);
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.cmd = cpu_to_le32(QRTR_TYPE_NEW_SERVER);
+	pkt.server.service = cpu_to_le32(srv->service);
+	pkt.server.instance = cpu_to_le32(srv->instance);
+	pkt.server.node = cpu_to_le32(srv->node);
+	pkt.server.port = cpu_to_le32(srv->port);
+
+	msg.msg_name = (struct sockaddr *)dest;
+	msg.msg_namelen = sizeof(*dest);
+
+	return kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+}
+
+static int service_announce_del(struct sockaddr_qrtr *dest,
+				struct qrtr_server *srv)
+{
+	struct qrtr_ctrl_pkt pkt;
+	struct msghdr msg = { };
+	struct kvec iv = { &pkt, sizeof(pkt) };
+	int ret;
+
+	trace_printk("advertising removal of server [%d:%x]@[%d:%d]\n",
+		     srv->service, srv->instance, srv->node, srv->port);
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.cmd = cpu_to_le32(QRTR_TYPE_DEL_SERVER);
+	pkt.server.service = cpu_to_le32(srv->service);
+	pkt.server.instance = cpu_to_le32(srv->instance);
+	pkt.server.node = cpu_to_le32(srv->node);
+	pkt.server.port = cpu_to_le32(srv->port);
+
+	msg.msg_name = (struct sockaddr *)dest;
+	msg.msg_namelen = sizeof(*dest);
+
+	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+	if (ret < 0)
+		pr_err("failed to announce del serivce\n");
+
+	return ret;
+}
+
+static void lookup_notify(struct sockaddr_qrtr *to, struct qrtr_server *srv,
+			  bool new)
+{
+	struct qrtr_ctrl_pkt pkt;
+	struct msghdr msg = { };
+	struct kvec iv = { &pkt, sizeof(pkt) };
+	int ret;
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.cmd = new ? cpu_to_le32(QRTR_TYPE_NEW_SERVER) :
+			cpu_to_le32(QRTR_TYPE_DEL_SERVER);
+	if (srv) {
+		pkt.server.service = cpu_to_le32(srv->service);
+		pkt.server.instance = cpu_to_le32(srv->instance);
+		pkt.server.node = cpu_to_le32(srv->node);
+		pkt.server.port = cpu_to_le32(srv->port);
+	}
+
+	msg.msg_name = (struct sockaddr *)to;
+	msg.msg_namelen = sizeof(*to);
+
+	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+	if (ret < 0)
+		pr_err("failed to send lookup notification\n");
+}
+
+static int announce_servers(struct sockaddr_qrtr *sq)
+{
+	struct qrtr_server *srv;
+	void __rcu **slot;
+	struct radix_tree_iter iter;
+	struct qrtr_node *node;
+	int ret;
+
+	node = node_get(qrtr_ns.local_node);
+	if (!node)
+		return 0;
+
+	/* Announce the list of servers registered in this node */
+	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
+		srv = radix_tree_deref_slot(slot);
+
+		ret = service_announce_new(sq, srv);
+		if (ret < 0) {
+			pr_err("failed to announce new service\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct qrtr_server *server_add(unsigned int service,
+				      unsigned int instance,
+				      unsigned int node_id,
+				      unsigned int port)
+{
+	struct qrtr_server *srv;
+	struct qrtr_server *old;
+	struct qrtr_node *node;
+
+	if (!service || !port)
+		return NULL;
+
+	srv = kzalloc(sizeof(*srv), GFP_KERNEL);
+	if (!srv)
+		return ERR_PTR(-ENOMEM);
+
+	srv->service = service;
+	srv->instance = instance;
+	srv->node = node_id;
+	srv->port = port;
+
+	node = node_get(node_id);
+	if (!node)
+		goto err;
+
+	/* Delete the old server on the same port */
+	old = radix_tree_lookup(&node->servers, port);
+	if (old) {
+		radix_tree_delete(&node->servers, port);
+		kfree(old);
+	}
+
+	radix_tree_insert(&node->servers, port, srv);
+
+	trace_printk("add server [%d:%x]@[%d:%d]\n", srv->service,
+		     srv->instance, srv->node, srv->port);
+
+	return srv;
+
+err:
+	kfree(srv);
+	return NULL;
+}
+
+static int server_del(struct qrtr_node *node, unsigned int port)
+{
+	struct qrtr_lookup *lookup;
+	struct list_head *li;
+	struct qrtr_server *srv;
+
+	srv = radix_tree_lookup(&node->servers, port);
+	if (!srv)
+		return -ENOENT;
+
+	radix_tree_delete(&node->servers, port);
+
+	/* Broadcast the removal of local servers */
+	if (srv->node == qrtr_ns.local_node)
+		service_announce_del(&qrtr_ns.bcast_sq, srv);
+
+	/* Announce the service's disappearance to observers */
+	list_for_each(li, &qrtr_ns.lookups) {
+		lookup = container_of(li, struct qrtr_lookup, li);
+		if (lookup->service && lookup->service != srv->service)
+			continue;
+		if (lookup->instance && lookup->instance != srv->instance)
+			continue;
+
+		lookup_notify(&lookup->sq, srv, false);
+	}
+
+	kfree(srv);
+
+	return 0;
+}
+
+/* Announce the list of servers registered on the local node */
+static int ctrl_cmd_hello(struct sockaddr_qrtr *sq)
+{
+	return announce_servers(sq);
+}
+
+static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
+{
+	struct qrtr_ctrl_pkt pkt;
+	struct kvec iv = { &pkt, sizeof(pkt) };
+	struct msghdr msg = { };
+	struct sockaddr_qrtr sq;
+	struct qrtr_node *local_node;
+	struct qrtr_server *srv;
+	struct qrtr_node *node;
+	void __rcu **slot;
+	struct radix_tree_iter iter;
+	int ret;
+
+	node = node_get(from->sq_node);
+	if (!node)
+		return 0;
+
+	/* Advertise removal of this client to all servers of remote node */
+	radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
+		srv = radix_tree_deref_slot(slot);
+		server_del(node, srv->port);
+	}
+
+	/* Advertise the removal of this client to all local servers */
+	local_node = node_get(qrtr_ns.local_node);
+	if (!local_node)
+		return 0;
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.cmd = cpu_to_le32(QRTR_TYPE_BYE);
+	pkt.client.node = cpu_to_le32(from->sq_node);
+
+	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
+		srv = radix_tree_deref_slot(slot);
+
+		sq.sq_family = AF_QIPCRTR;
+		sq.sq_node = srv->node;
+		sq.sq_port = srv->port;
+
+		msg.msg_name = (struct sockaddr *)&sq;
+		msg.msg_namelen = sizeof(sq);
+
+		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+		if (ret < 0) {
+			pr_err("failed to send bye cmd\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
+			       unsigned int node_id, unsigned int port)
+{
+	struct qrtr_ctrl_pkt pkt;
+	struct kvec iv = { &pkt, sizeof(pkt) };
+	struct msghdr msg = { };
+	struct sockaddr_qrtr sq;
+	struct qrtr_node *local_node;
+	struct list_head *tmp;
+	struct qrtr_lookup *lookup;
+	struct list_head *li;
+	struct qrtr_server *srv;
+	struct qrtr_node *node;
+	void __rcu **slot;
+	struct radix_tree_iter iter;
+	int ret;
+
+	/* Don't accept spoofed messages */
+	if (from->sq_node != node_id)
+		return -EINVAL;
+
+	/* Local DEL_CLIENT messages comes from the port being closed */
+	if (from->sq_node == qrtr_ns.local_node && from->sq_port != port)
+		return -EINVAL;
+
+	/* Remove any lookups by this client */
+	list_for_each_safe(li, tmp, &qrtr_ns.lookups) {
+		lookup = container_of(li, struct qrtr_lookup, li);
+		if (lookup->sq.sq_node != node_id)
+			continue;
+		if (lookup->sq.sq_port != port)
+			continue;
+
+		list_del(&lookup->li);
+		kfree(lookup);
+	}
+
+	/* Remove the server belonging to this port */
+	node = node_get(node_id);
+	if (node)
+		server_del(node, port);
+
+	/* Advertise the removal of this client to all local servers */
+	local_node = node_get(qrtr_ns.local_node);
+	if (!local_node)
+		return 0;
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.cmd = cpu_to_le32(QRTR_TYPE_DEL_CLIENT);
+	pkt.client.node = cpu_to_le32(node_id);
+	pkt.client.port = cpu_to_le32(port);
+
+	radix_tree_for_each_slot(slot, &local_node->servers, &iter, 0) {
+		srv = radix_tree_deref_slot(slot);
+
+		sq.sq_family = AF_QIPCRTR;
+		sq.sq_node = srv->node;
+		sq.sq_port = srv->port;
+
+		msg.msg_name = (struct sockaddr *)&sq;
+		msg.msg_namelen = sizeof(sq);
+
+		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+		if (ret < 0) {
+			pr_err("failed to send del client cmd\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
+			       unsigned int service, unsigned int instance,
+			       unsigned int node_id, unsigned int port)
+{
+	struct qrtr_lookup *lookup;
+	struct list_head *li;
+	struct qrtr_server *srv;
+	int ret = 0;
+
+	/* Ignore specified node and port for local servers */
+	if (from->sq_node == qrtr_ns.local_node) {
+		node_id = from->sq_node;
+		port = from->sq_port;
+	}
+
+	/* Don't accept spoofed messages */
+	if (from->sq_node != node_id)
+		return -EINVAL;
+
+	srv = server_add(service, instance, node_id, port);
+	if (!srv)
+		return -EINVAL;
+
+	if (srv->node == qrtr_ns.local_node) {
+		ret = service_announce_new(&qrtr_ns.bcast_sq, srv);
+		if (ret < 0) {
+			pr_err("failed to announce new service\n");
+			return ret;
+		}
+	}
+
+	/* Notify any potential lookups about the new server */
+	list_for_each(li, &qrtr_ns.lookups) {
+		lookup = container_of(li, struct qrtr_lookup, li);
+		if (lookup->service && lookup->service != service)
+			continue;
+		if (lookup->instance && lookup->instance != instance)
+			continue;
+
+		lookup_notify(&lookup->sq, srv, true);
+	}
+
+	return ret;
+}
+
+static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
+			       unsigned int service, unsigned int instance,
+			       unsigned int node_id, unsigned int port)
+{
+	struct qrtr_node *node;
+
+	/* Ignore specified node and port for local servers */
+	if (from->sq_node == qrtr_ns.local_node) {
+		node_id = from->sq_node;
+		port = from->sq_port;
+	}
+
+	/* Don't accept spoofed messages */
+	if (from->sq_node != node_id)
+		return -EINVAL;
+
+	/* Local servers may only unregister themselves */
+	if (from->sq_node == qrtr_ns.local_node && from->sq_port != port)
+		return -EINVAL;
+
+	node = node_get(node_id);
+	if (!node)
+		return -ENOENT;
+
+	return server_del(node, port);
+}
+
+static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
+			       unsigned int service, unsigned int instance)
+{
+	struct qrtr_server_filter filter;
+	struct qrtr_lookup *lookup;
+	struct qrtr_node *node;
+	void __rcu **node_slot;
+	void __rcu **srv_slot;
+	struct radix_tree_iter node_iter;
+	struct radix_tree_iter srv_iter;
+
+	/* Accept only local observers */
+	if (from->sq_node != qrtr_ns.local_node)
+		return -EINVAL;
+
+	lookup = kzalloc(sizeof(*lookup), GFP_KERNEL);
+	if (!lookup)
+		return -ENOMEM;
+
+	lookup->sq = *from;
+	lookup->service = service;
+	lookup->instance = instance;
+	list_add_tail(&lookup->li, &qrtr_ns.lookups);
+
+	memset(&filter, 0, sizeof(filter));
+	filter.service = service;
+	filter.instance = instance;
+
+	radix_tree_for_each_slot(node_slot, &nodes, &node_iter, 0) {
+		node = radix_tree_deref_slot(node_slot);
+
+		radix_tree_for_each_slot(srv_slot, &node->servers,
+					 &srv_iter, 0) {
+			struct qrtr_server *srv;
+
+			srv = radix_tree_deref_slot(srv_slot);
+			if (!server_match(srv, &filter))
+				continue;
+
+			lookup_notify(from, srv, true);
+		}
+	}
+
+	/* Empty notification, to indicate end of listing */
+	lookup_notify(from, NULL, true);
+
+	return 0;
+}
+
+static void ctrl_cmd_del_lookup(struct sockaddr_qrtr *from,
+				unsigned int service, unsigned int instance)
+{
+	struct qrtr_lookup *lookup;
+	struct list_head *tmp;
+	struct list_head *li;
+
+	list_for_each_safe(li, tmp, &qrtr_ns.lookups) {
+		lookup = container_of(li, struct qrtr_lookup, li);
+		if (lookup->sq.sq_node != from->sq_node)
+			continue;
+		if (lookup->sq.sq_port != from->sq_port)
+			continue;
+		if (lookup->service != service)
+			continue;
+		if (lookup->instance && lookup->instance != instance)
+			continue;
+
+		list_del(&lookup->li);
+		kfree(lookup);
+	}
+}
+
+static int say_hello(void)
+{
+	struct qrtr_ctrl_pkt pkt;
+	struct kvec iv = { &pkt, sizeof(pkt) };
+	struct msghdr msg = { };
+	int ret;
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.cmd = cpu_to_le32(QRTR_TYPE_HELLO);
+
+	msg.msg_name = (struct sockaddr *)&qrtr_ns.bcast_sq;
+	msg.msg_namelen = sizeof(qrtr_ns.bcast_sq);
+
+	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+	if (ret < 0)
+		pr_err("failed to send hello msg\n");
+
+	return ret;
+}
+
+static void qrtr_ns_worker(struct work_struct *work)
+{
+	const struct qrtr_ctrl_pkt *pkt;
+	struct kvec iv;
+	struct sockaddr_qrtr sq;
+	struct msghdr msg = { &sq, sizeof(sq) };
+	ssize_t msglen;
+	unsigned int cmd;
+	void *recv_buf;
+	size_t recv_buf_size = 4096;
+	int ret;
+
+	recv_buf = kzalloc(recv_buf_size, GFP_KERNEL);
+	if (!recv_buf)
+		return;
+
+	for (;;) {
+		iv.iov_base = recv_buf;
+		iv.iov_len = recv_buf_size;
+
+		msglen = kernel_recvmsg(qrtr_ns.sock, &msg, &iv, 1,
+					iv.iov_len, MSG_DONTWAIT);
+
+		if (msglen == -EAGAIN)
+			break;
+
+		if (msglen < 0) {
+			pr_err("error receiving packet: %zd\n", msglen);
+			break;
+		}
+
+		pkt = recv_buf;
+		cmd = le32_to_cpu(pkt->cmd);
+		if (cmd < ARRAY_SIZE(qrtr_ctrl_pkt_strings) &&
+		    qrtr_ctrl_pkt_strings[cmd])
+			trace_printk("%s from %d:%d\n",
+				     qrtr_ctrl_pkt_strings[cmd], sq.sq_node,
+				     sq.sq_port);
+
+		ret = 0;
+		switch (cmd) {
+		case QRTR_TYPE_HELLO:
+			ret = ctrl_cmd_hello(&sq);
+			break;
+		case QRTR_TYPE_BYE:
+			ret = ctrl_cmd_bye(&sq);
+			break;
+		case QRTR_TYPE_DEL_CLIENT:
+			ret = ctrl_cmd_del_client(&sq,
+					le32_to_cpu(pkt->client.node),
+					le32_to_cpu(pkt->client.port));
+			break;
+		case QRTR_TYPE_NEW_SERVER:
+			ret = ctrl_cmd_new_server(&sq,
+					le32_to_cpu(pkt->server.service),
+					le32_to_cpu(pkt->server.instance),
+					le32_to_cpu(pkt->server.node),
+					le32_to_cpu(pkt->server.port));
+			break;
+		case QRTR_TYPE_DEL_SERVER:
+			ret = ctrl_cmd_del_server(&sq,
+					 le32_to_cpu(pkt->server.service),
+					 le32_to_cpu(pkt->server.instance),
+					 le32_to_cpu(pkt->server.node),
+					 le32_to_cpu(pkt->server.port));
+			break;
+		case QRTR_TYPE_EXIT:
+		case QRTR_TYPE_PING:
+		case QRTR_TYPE_RESUME_TX:
+			break;
+		case QRTR_TYPE_NEW_LOOKUP:
+			ret = ctrl_cmd_new_lookup(&sq,
+					 le32_to_cpu(pkt->server.service),
+					 le32_to_cpu(pkt->server.instance));
+			break;
+		case QRTR_TYPE_DEL_LOOKUP:
+			ctrl_cmd_del_lookup(&sq,
+				    le32_to_cpu(pkt->server.service),
+				    le32_to_cpu(pkt->server.instance));
+			break;
+		}
+
+		if (ret < 0)
+			pr_err("failed while handling packet from %d:%d",
+			       sq.sq_node, sq.sq_port);
+	}
+
+	kfree(recv_buf);
+}
+
+static void qrtr_ns_data_ready(struct sock *sk)
+{
+	queue_work(qrtr_ns.workqueue, &qrtr_ns.work);
+}
+
+void qrtr_ns_init(struct work_struct *work)
+{
+	struct sockaddr_qrtr sq;
+	int ret;
+
+	INIT_LIST_HEAD(&qrtr_ns.lookups);
+	INIT_WORK(&qrtr_ns.work, qrtr_ns_worker);
+
+	ret = sock_create_kern(&init_net, AF_QIPCRTR, SOCK_DGRAM,
+			       PF_QIPCRTR, &qrtr_ns.sock);
+	if (ret < 0)
+		return;
+
+	ret = kernel_getsockname(qrtr_ns.sock, (struct sockaddr *)&sq);
+	if (ret < 0) {
+		pr_err("failed to get socket name\n");
+		goto err_sock;
+	}
+
+	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns_data_ready;
+
+	sq.sq_port = QRTR_PORT_CTRL;
+	qrtr_ns.local_node = sq.sq_node;
+
+	ret = kernel_bind(qrtr_ns.sock, (struct sockaddr *)&sq, sizeof(sq));
+	if (ret < 0) {
+		pr_err("failed to bind to socket\n");
+		goto err_sock;
+	}
+
+	qrtr_ns.bcast_sq.sq_family = AF_QIPCRTR;
+	qrtr_ns.bcast_sq.sq_node = QRTR_NODE_BCAST;
+	qrtr_ns.bcast_sq.sq_port = QRTR_PORT_CTRL;
+
+	qrtr_ns.workqueue = alloc_workqueue("qrtr_ns_handler", WQ_UNBOUND, 1);
+	if (!qrtr_ns.workqueue)
+		goto err_sock;
+
+	ret = say_hello();
+	if (ret < 0)
+		goto err_wq;
+
+	return;
+
+err_wq:
+	destroy_workqueue(qrtr_ns.workqueue);
+err_sock:
+	sock_release(qrtr_ns.sock);
+}
+EXPORT_SYMBOL_GPL(qrtr_ns_init);
+
+void qrtr_ns_remove(void)
+{
+	cancel_work_sync(&qrtr_ns.work);
+	destroy_workqueue(qrtr_ns.workqueue);
+	sock_release(qrtr_ns.sock);
+}
+EXPORT_SYMBOL_GPL(qrtr_ns_remove);
+
+MODULE_AUTHOR("Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>");
+MODULE_DESCRIPTION("Qualcomm IPC Router Nameservice");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 3d24d45be5f4..e97d20640de3 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -8,6 +8,7 @@
 #include <linux/qrtr.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/numa.h>
+#include <linux/workqueue.h>
 
 #include <net/sock.h>
 
@@ -107,6 +108,8 @@ static DEFINE_MUTEX(qrtr_node_lock);
 static DEFINE_IDR(qrtr_ports);
 static DEFINE_MUTEX(qrtr_port_lock);
 
+static struct delayed_work qrtr_ns_work;
+
 /**
  * struct qrtr_node - endpoint node
  * @ep_lock: lock for endpoint management and callbacks
@@ -1066,38 +1069,6 @@ static int qrtr_create(struct net *net, struct socket *sock,
 	return 0;
 }
 
-static const struct nla_policy qrtr_policy[IFA_MAX + 1] = {
-	[IFA_LOCAL] = { .type = NLA_U32 },
-};
-
-static int qrtr_addr_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
-			  struct netlink_ext_ack *extack)
-{
-	struct nlattr *tb[IFA_MAX + 1];
-	struct ifaddrmsg *ifm;
-	int rc;
-
-	if (!netlink_capable(skb, CAP_NET_ADMIN))
-		return -EPERM;
-
-	if (!netlink_capable(skb, CAP_SYS_ADMIN))
-		return -EPERM;
-
-	ASSERT_RTNL();
-
-	rc = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
-				    qrtr_policy, extack);
-	if (rc < 0)
-		return rc;
-
-	ifm = nlmsg_data(nlh);
-	if (!tb[IFA_LOCAL])
-		return -EINVAL;
-
-	qrtr_local_nid = nla_get_u32(tb[IFA_LOCAL]);
-	return 0;
-}
-
 static const struct net_proto_family qrtr_family = {
 	.owner	= THIS_MODULE,
 	.family	= AF_QIPCRTR,
@@ -1118,11 +1089,11 @@ static int __init qrtr_proto_init(void)
 		return rc;
 	}
 
-	rc = rtnl_register_module(THIS_MODULE, PF_QIPCRTR, RTM_NEWADDR, qrtr_addr_doit, NULL, 0);
-	if (rc) {
-		sock_unregister(qrtr_family.family);
-		proto_unregister(&qrtr_proto);
-	}
+	/* FIXME: Currently, this 2s delay is required to catch the NEW_SERVER
+	 * messages from routers. But the fix could be somewhere else.
+	 */
+	INIT_DELAYED_WORK(&qrtr_ns_work, qrtr_ns_init);
+	schedule_delayed_work(&qrtr_ns_work, msecs_to_jiffies(2000));
 
 	return rc;
 }
@@ -1130,7 +1101,8 @@ postcore_initcall(qrtr_proto_init);
 
 static void __exit qrtr_proto_fini(void)
 {
-	rtnl_unregister(PF_QIPCRTR, RTM_NEWADDR);
+	cancel_delayed_work_sync(&qrtr_ns_work);
+	qrtr_ns_remove();
 	sock_unregister(qrtr_family.family);
 	proto_unregister(&qrtr_proto);
 }
diff --git a/net/qrtr/qrtr.h b/net/qrtr/qrtr.h
index b81e6953c04b..53a237a28971 100644
--- a/net/qrtr/qrtr.h
+++ b/net/qrtr/qrtr.h
@@ -29,4 +29,8 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep);
 
 int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len);
 
+void qrtr_ns_init(struct work_struct *work);
+
+void qrtr_ns_remove(void);
+
 #endif
-- 
2.17.1

