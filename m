Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58921A1D49
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 10:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgDHIRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 04:17:33 -0400
Received: from m177134.mail.qiye.163.com ([123.58.177.134]:43385 "EHLO
        m177134.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgDHIRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 04:17:33 -0400
Received: from ubuntu.localdomain (unknown [58.251.74.227])
        by m17618.mail.qiye.163.com (Hmail) with ESMTPA id 0E0564E23AD;
        Wed,  8 Apr 2020 16:17:20 +0800 (CST)
From:   Wang Wenhu <wenhu.wang@vivo.com>
To:     akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicholas Mc Guire <hofrat@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Wang Wenhu <wenhu.wang@vivo.com>
Subject: [PATCH] net: qrtr: support qrtr service and lookup route
Date:   Wed,  8 Apr 2020 01:16:54 -0700
Message-Id: <20200408081657.5876-1-wenhu.wang@vivo.com>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUlXWQgYFAkeWUFZTVVPQ05LS0tKSEhOSk9PWVdZKFlBSE
        83V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NCo6EAw*Fzg6GhAjNS08HAEQ
        EylPCxdVSlVKTkNNSEhIQ09JTEhPVTMWGhIXVQweFRMOVQwaFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJTkpVTE9VSUlMWVdZCAFZQU1DTk83Bg++
X-HM-Tid: 0a7158dd749d9376kuws0e0564e23ad
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
 net/qrtr/qrtr.c |  3 ++-
 net/qrtr/qsr.c  | 47 +++++++++++++++++++++++------------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 38f25d3c1c39..267f7d6c746f 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -158,7 +158,8 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 static struct qrtr_sock *qrtr_port_lookup(int port);
 static void qrtr_port_put(struct qrtr_sock *ipc);
 
-unsigned int get_qrtr_local_nid(void) {
+unsigned int get_qrtr_local_nid(void)
+{
 	return qrtr_local_nid;
 }
 
diff --git a/net/qrtr/qsr.c b/net/qrtr/qsr.c
index 3dd43d4e301f..27fcb51a624a 100644
--- a/net/qrtr/qsr.c
+++ b/net/qrtr/qsr.c
@@ -91,10 +91,7 @@ struct qsr {
 
 struct qsr_ops {
 	int (*new_server)(struct qsr_info *svc);
-
-	int (*new_lookup)(struct qsr_info *svc,
-				u32 node,
-				u32 port);
+	int (*new_lookup)(struct qsr_info *svc, u32 node, u32 port);
 };
 
 static int qsr_major;
@@ -112,7 +109,7 @@ static int qsr_new_server(struct qsr_info *new)
 
 	list_for_each_entry(lookup, &qsr->lookups, list) {
 		if (lookup->service == new->service &&
-				lookup->instance == new->instance) {
+			lookup->instance == new->instance) {
 			ret = ops->new_lookup(new,
 							lookup->client.node,
 							lookup->client.port);
@@ -127,9 +124,7 @@ static int qsr_new_server(struct qsr_info *new)
 	return 0;
 }
 
-static int qsr_new_lookup(struct qsr_info *svc,
-				u32 node,
-				u32 port)
+static int qsr_new_lookup(struct qsr_info *svc, u32 node, u32 port)
 {
 	struct qrtr_ctrl_pkt pkt;
 	struct sockaddr_qrtr sq;
@@ -180,7 +175,7 @@ static void qsr_recv_new_server(u32 service,
 	list_for_each_entry(temp, &qsr->services, list) {
 		if (temp->service == service && temp->instance == instance) {
 			pr_err("Error server exists, service:0x%x instance:0x%x",
-							service, instance);
+				   service, instance);
 			return;
 		}
 	}
@@ -230,9 +225,9 @@ static void qsr_recv_new_lookup(u32 service,
 
 	list_for_each_entry(temp, &qsr->lookups, list) {
 		if (temp->service == service &&
-				temp->instance == instance &&
-				temp->client.node == node &&
-				temp->client.port == port) {
+			temp->instance == instance &&
+			temp->client.node == node &&
+			temp->client.port == port) {
 			pr_err("Error lookup exists, service:0x%x instance:0x%x node:%d port:%d",
 						service, instance, node, port);
 			return;
@@ -299,28 +294,28 @@ static void qsr_recv_ctrl_pkt(struct sockaddr_qrtr *sq,
 	switch (le32_to_cpu(pkt->cmd)) {
 	case QRTR_TYPE_NEW_SERVER:
 		qsr_recv_new_server(le32_to_cpu(pkt->server.service),
-				    le32_to_cpu(pkt->server.instance),
+					le32_to_cpu(pkt->server.instance),
 				    le32_to_cpu(pkt->server.node),
 				    le32_to_cpu(pkt->server.port));
 		break;
 
 	case QRTR_TYPE_NEW_LOOKUP:
 		qsr_recv_new_lookup(le32_to_cpu(pkt->server.service),
-				    le32_to_cpu(pkt->server.instance),
-				    sq->sq_node,
-				    sq->sq_port);
+					le32_to_cpu(pkt->server.instance),
+					sq->sq_node,
+					sq->sq_port);
 		break;
 
 	case QRTR_TYPE_DEL_SERVER:
 		qsr_recv_del_server(le32_to_cpu(pkt->server.service),
-				    le32_to_cpu(pkt->server.instance));
+					le32_to_cpu(pkt->server.instance));
 		break;
 
 	case QRTR_TYPE_DEL_LOOKUP:
 		qsr_recv_del_lookup(le32_to_cpu(pkt->server.service),
-				    le32_to_cpu(pkt->server.instance),
-				    sq->sq_node,
-				    sq->sq_port);
+					le32_to_cpu(pkt->server.instance),
+					sq->sq_node,
+					sq->sq_port);
 		break;
 	}
 }
@@ -386,8 +381,10 @@ static ssize_t lookups_show(struct device *dev,
 	mutex_lock(&qsr->qsr_lock);
 	list_for_each_entry(lookup, &qsr->lookups, list) {
 		ret += sprintf(buf, "service:0x%04x instance:0x%04x   node:%04d port:%04d\n",
-				lookup->service, lookup->instance,
-				lookup->server.node, lookup->server.port);
+					lookup->service,
+					lookup->instance,
+					lookup->server.node,
+					lookup->server.port);
 	}
 	mutex_unlock(&qsr->qsr_lock);
 
@@ -404,8 +401,10 @@ static ssize_t services_show(struct device *dev,
 	mutex_lock(&qsr->qsr_lock);
 	list_for_each_entry(svc, &qsr->services, list) {
 		ret += sprintf(buf, "service:0x%04x instance:0x%04x  node:%04d port:%04d\n",
-				svc->service, svc->instance,
-				svc->server.node, svc->server.port);
+					svc->service,
+					svc->instance,
+					svc->server.node,
+					svc->server.port);
 	}
 	mutex_unlock(&qsr->qsr_lock);
 
-- 
2.17.1

