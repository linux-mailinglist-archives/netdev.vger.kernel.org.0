Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3141A1F30
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 12:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgDHKtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 06:49:41 -0400
Received: from m17618.mail.qiye.163.com ([59.111.176.18]:58928 "EHLO
        m17618.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgDHKtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 06:49:41 -0400
Received: from ubuntu.localdomain (unknown [58.251.74.226])
        by m17618.mail.qiye.163.com (Hmail) with ESMTPA id 7A5684E25AF;
        Wed,  8 Apr 2020 18:49:22 +0800 (CST)
From:   Wang Wenhu <wenhu.wang@vivo.com>
To:     akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wang Wenhu <wenhu.wang@vivo.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Nicholas Mc Guire <hofrat@osadl.org>,
        Allison Randal <allison@lohutok.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Carl Huang <cjhuang@codeaurora.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel@vivo.com
Subject: [PATCH RESEND] net: qrtr: support qrtr service and lookup route
Date:   Wed,  8 Apr 2020 03:46:35 -0700
Message-Id: <20200408104833.6880-1-wenhu.wang@vivo.com>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZTlVDQ0pLS0tLT0pCTUpNTFlXWShZQU
        hPN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oj46Iyo*Ezg0FhczKTEoAh8h
        HysaCy5VSlVKTkNNSE9JQk1OQ0pDVTMWGhIXVQweFRMOVQwaFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJTkpVTE9VSUlNWVdZCAFZQUpCTExCNwY+
X-HM-Tid: 0a715968a7cb9376kuws7a5684e25af
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QSR implements maintenance of qrtr services and lookups. It would
be helpful for developers to work with QRTR without the none-opensource
user-space implementation part of IPC Router.

As we know, the extremely important point of IPC Router is the support
of services form different nodes. But QRTR was pushed into mainline
without route process support of services, and the router port process
is implemented in user-space as none-opensource codes, which is an
great unconvenience for developers.

QSR also implements a interface via chardev and a set of sysfs class
files for the communication and debugging in user-space. We can get
service and lookup entries conveniently via sysfs file in /sys/class/qsr/.
Currently add-server, del-server, add-lookup and del-lookup control
packatets are processed and enhancements could be taken easily upon
currently implementation.

Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
---
Changelog:
 This is a resent, but the first normal version of QSR support.
 The former one sent out earlier contains only the patch of coding
 style modification of qsr.c.
 
 Please do not be confused and take this patch as the NORMAL commit of QSR.
---
 net/qrtr/Kconfig  |   8 +
 net/qrtr/Makefile |   2 +
 net/qrtr/qrtr.c   |   5 +
 net/qrtr/qrtr.h   |   2 +
 net/qrtr/qsr.c    | 622 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 639 insertions(+)
 create mode 100644 net/qrtr/qsr.c

diff --git a/net/qrtr/Kconfig b/net/qrtr/Kconfig
index 63f89cc6e82c..d2ce8fb57278 100644
--- a/net/qrtr/Kconfig
+++ b/net/qrtr/Kconfig
@@ -29,4 +29,12 @@ config QRTR_TUN
 	  implement endpoints of QRTR, for purpose of tunneling data to other
 	  hosts or testing purposes.
 
+config QSR
+	tristate "QRTR Service Router"
+	help
+	  Say Y here to enable the kernel QRTR Service Router module.
+	  QSR support route processes of QRTR services and lookups. It would be
+	  helpful when develop with QRTR without user-space implementation of
+	  IPC Router support.
+
 endif # QRTR
diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
index 1c6d6c120fb7..3882beaead29 100644
--- a/net/qrtr/Makefile
+++ b/net/qrtr/Makefile
@@ -5,3 +5,5 @@ obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
 qrtr-smd-y	:= smd.o
 obj-$(CONFIG_QRTR_TUN) += qrtr-tun.o
 qrtr-tun-y	:= tun.o
+obj-$(CONFIG_QSR) += qrtr-svc-router.o
+qrtr-svc-router-y	:= qsr.o
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 5a8e42ad1504..267f7d6c746f 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -158,6 +158,11 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 static struct qrtr_sock *qrtr_port_lookup(int port);
 static void qrtr_port_put(struct qrtr_sock *ipc);
 
+unsigned int get_qrtr_local_nid(void)
+{
+	return qrtr_local_nid;
+}
+
 /* Release node resources and free the node.
  *
  * Do not call directly, use qrtr_node_release.  To be used with
diff --git a/net/qrtr/qrtr.h b/net/qrtr/qrtr.h
index b81e6953c04b..872d98fd36c6 100644
--- a/net/qrtr/qrtr.h
+++ b/net/qrtr/qrtr.h
@@ -29,4 +29,6 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep);
 
 int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len);
 
+unsigned int get_qrtr_local_nid(void);
+
 #endif
diff --git a/net/qrtr/qsr.c b/net/qrtr/qsr.c
new file mode 100644
index 000000000000..906f5903ebad
--- /dev/null
+++ b/net/qrtr/qsr.c
@@ -0,0 +1,622 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2020 Vivo Communication Technology Co. Ltd.
+ * Copyright (C) 2020 Wang Wenhu <wenhu.wang@vivo.com>
+ *
+ * The QRTR Service Route module aims at providing maintenance
+ * and route processes for qrtr service and lookup requests in
+ * kernel. Also, it provides sysfs class interface to expose
+ * the status of qrtr services and lookups. More could be done
+ * through the character device /dev/qsr in user-space.
+ *
+ * Currently, only server add, server delete, lookup add and
+ * lookup delete requests are processed.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/string.h>
+#include <linux/kobject.h>
+#include <linux/cdev.h>
+#include <linux/qrtr.h>
+#include <net/sock.h>
+
+#include "qrtr.h"
+
+#define QSR_NAME	"qsr"
+
+/**
+ * struct qsr_info - qrtr service route request information
+ * @service:	service identity
+ * @instance:	service instance
+ * @server:		server address
+ * @client:		client address
+ * @node:		qrtr node of server or client
+ * @port:		qrtr port of server or client
+ *
+ * When a control packet of new server request is received, the server
+ * field should be reference for the server node address. For the opposite
+ * situation, the client field should be referenced within a lookup request.
+ */
+struct qsr_info {
+	__le32 service;
+	__le32 instance;
+
+	union {
+		struct {
+			__le32 node;
+			__le32 port;
+		} server;
+
+		struct {
+			__le32 node;
+			__le32 port;
+		} client;
+	};
+
+	struct list_head list;
+};
+
+/**
+ * struct qsr - qrtr service route device structure
+ * @dev:		character device for user-space communication
+ * @sk:			socket to process messages
+ * @sq:			socket address to be binded
+ * @ops:		callbacks of different control package types
+ * @qsr_lock:	data buffer lock
+ * @recv_buf:	receive buffer
+ * @recv_buf_size:	receive buffer size
+ * @wq:			workqueue for message process worker
+ * @work:		work route to process queued messages
+ * @lookups:	pending lookup requests
+ * @services:	servers list to provide different kind of services
+ */
+struct qsr {
+	struct device			dev;
+	struct socket			*sk;
+	struct sockaddr_qrtr	sq;
+	struct qsr_ops			*ops;
+
+	struct mutex			qsr_lock;
+	void					*recv_buf;
+	size_t					recv_buf_size;
+
+	struct workqueue_struct	*wq;
+	struct work_struct		work;
+
+	struct list_head		lookups;
+	struct list_head		services;
+};
+
+struct qsr_ops {
+	int (*new_server)(struct qsr_info *svc);
+	int (*new_lookup)(struct qsr_info *svc, u32 node, u32 port);
+};
+
+static int qsr_major;
+static struct cdev *qsr_cdev;
+static struct qsr *qsr;
+
+static int qsr_new_server(struct qsr_info *new)
+{
+	struct qsr_info *lookup;
+	struct qsr_ops *ops = qsr->ops;
+	int ret;
+
+	if (!ops->new_lookup)
+		return 0;
+
+	list_for_each_entry(lookup, &qsr->lookups, list) {
+		if (lookup->service == new->service &&
+		    lookup->instance == new->instance) {
+			ret = ops->new_lookup(new,
+							lookup->client.node,
+							lookup->client.port);
+			if (ret < 0)
+				pr_err("Error to notice client of new server, %d\n", ret);
+			else
+				list_del(&lookup->list);
+			return 0;
+		}
+	}
+
+	return 0;
+}
+
+static int qsr_new_lookup(struct qsr_info *svc, u32 node, u32 port)
+{
+	struct qrtr_ctrl_pkt pkt;
+	struct sockaddr_qrtr sq;
+	struct msghdr msg = { };
+	struct kvec iv = { &pkt, sizeof(pkt) };
+	int ret = 0;
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.cmd = cpu_to_le32(QRTR_TYPE_NEW_SERVER);
+	pkt.server.service = cpu_to_le32(svc->service);
+	pkt.server.instance = cpu_to_le32(svc->instance);
+	pkt.server.node = cpu_to_le32(svc->server.node);
+	pkt.server.port = cpu_to_le32(svc->server.port);
+
+	sq.sq_family = AF_QIPCRTR;
+	sq.sq_node = node;
+	sq.sq_port = port;
+
+	msg.msg_name = &sq;
+	msg.msg_namelen = sizeof(sq);
+
+	mutex_lock(&qsr->qsr_lock);
+	if (qsr->sk) {
+		ret = kernel_sendmsg(qsr->sk, &msg, &iv, 1, sizeof(pkt));
+		if (ret < 0)
+			pr_err("Error to send server info to client, %d\n", ret);
+	}
+	mutex_unlock(&qsr->qsr_lock);
+
+	return ret;
+}
+
+static void qsr_recv_new_server(u32 service,
+				u32 instance,
+				u32 node,
+				u32 port)
+{
+	struct qsr_ops *ops = qsr->ops;
+	struct qsr_info *svc, *temp;
+	int ret;
+
+	if (!ops->new_server)
+		return;
+
+	if (!node && !port)
+		return;
+
+	list_for_each_entry(temp, &qsr->services, list) {
+		if (temp->service == service && temp->instance == instance) {
+			pr_err("Error server exists, service:0x%x instance:0x%x",
+			       service, instance);
+			return;
+		}
+	}
+
+	svc = kzalloc(sizeof(*svc), GFP_KERNEL);
+	if (!svc)
+		return;
+
+	svc->service = service;
+	svc->instance = instance;
+	svc->server.node = node;
+	svc->server.port = port;
+
+	ret = ops->new_server(svc);
+	if (ret < 0)
+		kfree(svc);
+	else
+		list_add(&svc->list, &qsr->services);
+}
+
+static void qsr_recv_del_server(u32 service, u32 instance)
+{
+	struct qsr_info *svc;
+
+	list_for_each_entry(svc, &qsr->lookups, list) {
+		if (svc->service == service && svc->instance == instance) {
+			list_del(&svc->list);
+			return;
+		}
+	}
+}
+
+static void qsr_recv_new_lookup(u32 service,
+				u32 instance,
+				u32 node,
+				u32 port)
+{
+	struct qsr_ops *ops = qsr->ops;
+	struct qsr_info *svc, *temp;
+	int ret;
+
+	if (!ops->new_lookup)
+		return;
+
+	if (!node && !port)
+		return;
+
+	list_for_each_entry(temp, &qsr->lookups, list) {
+		if (temp->service == service &&
+		    temp->instance == instance &&
+		    temp->client.node == node &&
+		    temp->client.port == port) {
+			pr_err("Error lookup exists, service:0x%x instance:0x%x node:%d port:%d",
+			       service, instance, node, port);
+			return;
+		}
+	}
+
+	list_for_each_entry(svc, &qsr->services, list) {
+		if (svc->service == service && svc->instance == instance) {
+			ret = ops->new_lookup(svc, node, port);
+			if (ret < 0)
+				pr_err("Error to send server info to client, %d", ret);
+			return;
+		}
+	}
+
+	/* Server does not exist.
+	 * Record the lookup information and add it to the pending list.
+	 */
+
+	svc = kzalloc(sizeof(*svc), GFP_KERNEL);
+	if (!svc)
+		return;
+
+	svc->service = service;
+	svc->instance = instance;
+	svc->client.node = node;
+	svc->client.port = port;
+
+	list_add(&svc->list, &qsr->lookups);
+}
+
+static void qsr_recv_del_lookup(u32 service,
+				u32 instance,
+				u32 node,
+				u32 port)
+{
+	struct qsr_info *lookup;
+
+	if (!node && !port)
+		return;
+
+	list_for_each_entry(lookup, &qsr->lookups, list) {
+		if (lookup->service == service &&
+		    lookup->instance == instance &&
+		    lookup->client.node == node &&
+		    lookup->client.port == port) {
+			list_del(&lookup->list);
+			return;
+		}
+	}
+}
+
+static void qsr_recv_ctrl_pkt(struct sockaddr_qrtr *sq,
+			      const void *buf,
+			      size_t len)
+{
+	const struct qrtr_ctrl_pkt *pkt = buf;
+
+	if (len < sizeof(struct qrtr_ctrl_pkt)) {
+		pr_debug("ignoring short control packet\n");
+		return;
+	}
+
+	switch (le32_to_cpu(pkt->cmd)) {
+	case QRTR_TYPE_NEW_SERVER:
+		qsr_recv_new_server(le32_to_cpu(pkt->server.service),
+				    le32_to_cpu(pkt->server.instance),
+				    le32_to_cpu(pkt->server.node),
+				    le32_to_cpu(pkt->server.port));
+		break;
+
+	case QRTR_TYPE_NEW_LOOKUP:
+		qsr_recv_new_lookup(le32_to_cpu(pkt->server.service),
+				    le32_to_cpu(pkt->server.instance),
+				    sq->sq_node,
+				    sq->sq_port);
+		break;
+
+	case QRTR_TYPE_DEL_SERVER:
+		qsr_recv_del_server(le32_to_cpu(pkt->server.service),
+				    le32_to_cpu(pkt->server.instance));
+		break;
+
+	case QRTR_TYPE_DEL_LOOKUP:
+		qsr_recv_del_lookup(le32_to_cpu(pkt->server.service),
+				    le32_to_cpu(pkt->server.instance),
+				    sq->sq_node,
+				    sq->sq_port);
+		break;
+	}
+}
+
+static void qsr_recv_work(struct work_struct *work)
+{
+	struct sockaddr_qrtr sq;
+	struct msghdr msg = { .msg_name = &sq, .msg_namelen = sizeof(sq) };
+	struct kvec iv;
+	ssize_t msglen;
+
+	for (;;) {
+		iv.iov_base = qsr->recv_buf;
+		iv.iov_len = qsr->recv_buf_size;
+
+		mutex_lock(&qsr->qsr_lock);
+		if (qsr->sk)
+			msglen = kernel_recvmsg(qsr->sk, &msg, &iv, 1,
+						iv.iov_len, MSG_DONTWAIT);
+		else
+			msglen = -EPIPE;
+		mutex_unlock(&qsr->qsr_lock);
+
+		if (msglen == -EAGAIN)
+			break;
+
+		if (msglen < 0) {
+			pr_err("qmi recvmsg failed: %zd\n", msglen);
+			break;
+		}
+
+		qsr_recv_ctrl_pkt(&sq, qsr->recv_buf, msglen);
+	}
+}
+
+static void qsr_data_ready(struct sock *sk)
+{
+	read_lock_bh(&sk->sk_callback_lock);
+	queue_work(qsr->wq, &qsr->work);
+	read_unlock_bh(&sk->sk_callback_lock);
+}
+
+static ssize_t name_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	int ret;
+
+	mutex_lock(&qsr->qsr_lock);
+	ret = sprintf(buf, "%s\n", QSR_NAME);
+	mutex_unlock(&qsr->qsr_lock);
+
+	return ret;
+}
+static DEVICE_ATTR_RO(name);
+
+static ssize_t lookups_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct qsr_info *lookup;
+	int ret = 0;
+
+	mutex_lock(&qsr->qsr_lock);
+	list_for_each_entry(lookup, &qsr->lookups, list) {
+		ret += sprintf(buf, "service:0x%04x instance:0x%04x node:%04d port:%04d\n",
+					lookup->service,
+					lookup->instance,
+					lookup->server.node,
+					lookup->server.port);
+	}
+	mutex_unlock(&qsr->qsr_lock);
+
+	return ret;
+}
+static DEVICE_ATTR_RO(lookups);
+
+static ssize_t services_show(struct device *dev,
+			     struct device_attribute *attr,
+				 char *buf)
+{
+	struct qsr_info *svc;
+	int ret = 0;
+
+	mutex_lock(&qsr->qsr_lock);
+	list_for_each_entry(svc, &qsr->services, list) {
+		ret += sprintf(buf, "service:0x%04x instance:0x%04x node:%04d port:%04d\n",
+					svc->service,
+					svc->instance,
+					svc->server.node,
+					svc->server.port);
+	}
+	mutex_unlock(&qsr->qsr_lock);
+
+	return ret;
+}
+static DEVICE_ATTR_RO(services);
+
+static struct attribute *qsr_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_lookups.attr,
+	&dev_attr_services.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(qsr);
+
+/* Interface class infrastructure. */
+static struct class qsr_class = {
+	.name = QSR_NAME,
+	.dev_groups = qsr_groups,
+};
+
+static int qsr_dev_create(void)
+{
+	int ret = -ENOMEM;
+
+	qsr = kzalloc(sizeof(*qsr), GFP_KERNEL);
+	if (!qsr)
+		goto out;
+
+	INIT_LIST_HEAD(&qsr->lookups);
+	INIT_LIST_HEAD(&qsr->services);
+
+	INIT_WORK(&qsr->work, qsr_recv_work);
+
+	qsr->recv_buf_size = sizeof(struct qrtr_ctrl_pkt);
+	qsr->recv_buf = kzalloc(qsr->recv_buf_size, GFP_KERNEL);
+	if (!qsr->recv_buf)
+		goto out_qsr_free;
+
+	qsr->wq = alloc_workqueue("qsr_wq", WQ_UNBOUND, 1);
+	if (!qsr->wq)
+		goto out_recv_buf_free;
+
+	device_initialize(&qsr->dev);
+	qsr->dev.devt = MKDEV(qsr_major, 0);
+	qsr->dev.class = &qsr_class;
+	dev_set_drvdata(&qsr->dev, qsr);
+
+	ret = dev_set_name(&qsr->dev, QSR_NAME);
+	if (ret) {
+		pr_err("device name %s set failed, %d", QSR_NAME, ret);
+		goto out_recv_buf_free;
+	}
+
+	mutex_init(&qsr->qsr_lock);
+
+	ret = device_add(&qsr->dev);
+	if (ret)
+		goto out_wq_destroy;
+
+	return ret;
+
+out_wq_destroy:
+	destroy_workqueue(qsr->wq);
+out_recv_buf_free:
+	kfree(qsr->recv_buf);
+out_qsr_free:
+	kfree(qsr);
+out:
+	return ret;
+}
+
+struct qsr_ops qsr_handle_ops = {
+	.new_server = qsr_new_server,
+	.new_lookup = qsr_new_lookup,
+};
+
+static struct socket *qsr_sock_create(void)
+{
+	struct socket *sock;
+	struct sockaddr addr;
+	int ret;
+
+	ret = sock_create_kern(&init_net, AF_QIPCRTR, SOCK_DGRAM,
+			       PF_QIPCRTR, &sock);
+
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	qsr->sq.sq_family = AF_QIPCRTR;
+	qsr->sq.sq_node = get_qrtr_local_nid();
+	qsr->sq.sq_port = QRTR_PORT_CTRL;
+	qsr->ops = &qsr_handle_ops;
+
+	if (sock->ops->bind) {
+		memcpy(&addr, &qsr->sq, sizeof(qsr->sq));
+		ret = sock->ops->bind(sock, &addr, sizeof(addr));
+		if (ret) {
+			pr_err("Failed to bind socket address node:0x%x port:0x%x.\n",
+			       qsr->sq.sq_node, qsr->sq.sq_port);
+			goto err_bind;
+		}
+		pr_debug("qsr router port binded successfully.\n");
+	}
+
+	sock->sk->sk_user_data = qsr;
+	sock->sk->sk_data_ready = qsr_data_ready;
+	sock->sk->sk_error_report = qsr_data_ready;
+	sock->sk->sk_sndtimeo = HZ * 10;
+
+	return sock;
+
+err_bind:
+	sock_release(sock);
+	return NULL;
+}
+
+static int qsr_release(void)
+{
+	sock_release(qsr->sk);
+
+	kfree(qsr->recv_buf);
+
+	destroy_workqueue(qsr->wq);
+
+	kfree(qsr);
+
+	return 0;
+}
+
+static const struct file_operations qsr_fops = {
+	.owner = THIS_MODULE,
+};
+
+static int __init qsr_init(void)
+{
+	int ret;
+	static const char name[] = QSR_NAME;
+	struct cdev *cdev = NULL;
+	dev_t rtdev;
+
+	/* 1. Allocate character device region. */
+	ret = alloc_chrdev_region(&rtdev, 0, 1, name);
+	if (ret) {
+		pr_err("failed to alloc chardev region\n");
+		goto out;
+	}
+
+	/* 2. Allocate, initiate and add cdev. */
+	ret = -ENOMEM;
+	cdev = cdev_alloc();
+	if (!cdev) {
+		pr_err("failed to alloc cdev\n");
+		goto out_unregister;
+	}
+
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &qsr_fops;
+	kobject_set_name(&cdev->kobj, "%s", name);
+
+	ret = cdev_add(cdev, rtdev, 1);
+	if (ret)
+		goto out_put;
+
+	qsr_major = MAJOR(rtdev);
+	qsr_cdev = cdev;
+
+	/* 3. Register class. */
+	ret = class_register(&qsr_class);
+	if (ret) {
+		pr_err("class_register failed for qrtr route\n");
+		goto out_cdev_del;
+	}
+
+	/* 4. Create a qsr device. */
+	if (qsr_dev_create())
+		goto out_unregister_class;
+
+	/* 5. Create a qrtr socket and bind it to Router port. */
+	qsr->sk = qsr_sock_create();
+	if (!qsr->sk)
+		goto out_qsr_dev_del;
+
+	return 0;
+
+out_qsr_dev_del:
+	kfree(qsr);
+out_unregister_class:
+	class_unregister(&qsr_class);
+out_cdev_del:
+	cdev_del(qsr_cdev);
+out_put:
+	kobject_put(&cdev->kobj);
+out_unregister:
+	unregister_chrdev_region(rtdev, 1);
+out:
+	return ret;
+}
+subsys_initcall(qsr_init);
+
+static void __exit qsr_exit(void)
+{
+	qsr_release();
+	unregister_chrdev_region(MKDEV(qsr_major, 0), 1);
+	cdev_del(qsr_cdev);
+	class_unregister(&qsr_class);
+}
+module_exit(qsr_exit);
+
+MODULE_AUTHOR("Wang Wenhu");
+MODULE_ALIAS("QRTR:" QSR_NAME);
+MODULE_DESCRIPTION("Qualcomm IPC Router Service Route Support");
+MODULE_LICENSE("GPL v2");
-- 
2.17.1

