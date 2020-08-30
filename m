Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889C0256EA9
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgH3Okd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 10:40:33 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:17526 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727069AbgH3Ojq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 10:39:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598798386; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=PSFObMXbhORUF5AdMyNhKvu4kdYQ+ZI6KvZNhNgbpdY=; b=apChj2LeKSxHxUD125/nQ7H62blzjGQ06ouXsxU8NoyR2uJKBdFrLoa6ZmYZ1nfhMEGqO2re
 Jc0TKaPbMeESmTG5Of4mSp38tdrA3wsv4oluV3IwQ+bPj9S4aM6PyiJHiFC7CufRVrVwdyb0
 5Xp1PRWFFCZuwvkYen7CD9OkHvk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f4bb9f912acec35e2847a7d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 30 Aug 2020 14:38:49
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9C275C433CB; Sun, 30 Aug 2020 14:38:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from deesin-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: deesin)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 34CB5C433CA;
        Sun, 30 Aug 2020 14:38:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 34CB5C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=deesin@codeaurora.org
From:   Deepak Kumar Singh <deesin@codeaurora.org>
To:     bjorn.andersson@linaro.org, clew@codeaurora.org
Cc:     mathieu.poirier@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Necip Fazil Yildiran <necip@google.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH V1 2/4] net: qrtr: Add socket mode optimization
Date:   Sun, 30 Aug 2020 20:08:10 +0530
Message-Id: <1598798292-5971-3-git-send-email-deesin@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598798292-5971-1-git-send-email-deesin@codeaurora.org>
References: <1598798292-5971-1-git-send-email-deesin@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Lew <clew@codeaurora.org>

A remote endpoint should not need to know when a client socket is freed
if the socket never established commnication with the endpoint. Add a
mode to keep track of which endpoints a socket communicates with.

There are three modes a socket can be in:
        INIT   - Socket has not sent anything or only local messages,
                 only send client close to local services.

        SINGLE - Socket has sent messages to a single ept, send event
                 to this single ept.

        MULTI  - Socket has sent messages to multiple epts, broadcast
                 release of this socket.

Server state changes should be broadcast throughout the system. Change
the ipc state of a port when it sends a NEW SERVER control packet. This
ensures the DEL CLIENT control packet is propagated correctly for
servers.
---
 net/qrtr/qrtr.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 13 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index d9858a1..4496b75 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -21,6 +21,10 @@
 #define QRTR_MIN_EPH_SOCKET 0x4000
 #define QRTR_MAX_EPH_SOCKET 0x7fff
 
+/* qrtr socket states */
+#define QRTR_STATE_MULTI	-2
+#define QRTR_STATE_INIT		-1
+
 /**
  * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
  * @version: protocol version
@@ -87,6 +91,8 @@ struct qrtr_sock {
 	struct sock sk;
 	struct sockaddr_qrtr us;
 	struct sockaddr_qrtr peer;
+
+	int state;
 };
 
 static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
@@ -653,29 +659,59 @@ static void qrtr_port_put(struct qrtr_sock *ipc)
 	sock_put(&ipc->sk);
 }
 
-/* Remove port assignment. */
-static void qrtr_port_remove(struct qrtr_sock *ipc)
+static void qrtr_send_del_client(struct qrtr_sock *ipc)
 {
 	struct qrtr_ctrl_pkt *pkt;
-	struct sk_buff *skb;
-	int port = ipc->us.sq_port;
 	struct sockaddr_qrtr to;
+	struct qrtr_node *node;
+	struct sk_buff *skbn;
+	struct sk_buff *skb;
+	int type = QRTR_TYPE_DEL_CLIENT;
+
+	skb = qrtr_alloc_ctrl_packet(&pkt);
+	if (!skb)
+		return;
 
 	to.sq_family = AF_QIPCRTR;
 	to.sq_node = QRTR_NODE_BCAST;
 	to.sq_port = QRTR_PORT_CTRL;
 
-	skb = qrtr_alloc_ctrl_packet(&pkt);
-	if (skb) {
-		pkt->cmd = cpu_to_le32(QRTR_TYPE_DEL_CLIENT);
-		pkt->client.node = cpu_to_le32(ipc->us.sq_node);
-		pkt->client.port = cpu_to_le32(ipc->us.sq_port);
+	pkt->cmd = cpu_to_le32(QRTR_TYPE_DEL_CLIENT);
+	pkt->client.node = cpu_to_le32(ipc->us.sq_node);
+	pkt->client.port = cpu_to_le32(ipc->us.sq_port);
+
+	skb_set_owner_w(skb, &ipc->sk);
 
-		skb_set_owner_w(skb, &ipc->sk);
-		qrtr_bcast_enqueue(NULL, skb, QRTR_TYPE_DEL_CLIENT, &ipc->us,
-				   &to);
+	if (ipc->state == QRTR_STATE_MULTI) {
+		qrtr_bcast_enqueue(NULL, skb, type, &ipc->us, &to);
+		return;
+	}
+
+	if (ipc->state > QRTR_STATE_INIT) {
+		node = qrtr_node_lookup(ipc->state);
+		if (!node)
+			goto exit;
+
+		skbn = skb_clone(skb, GFP_KERNEL);
+		if (!skbn) {
+			qrtr_node_release(node);
+			goto exit;
+		}
+
+		skb_set_owner_w(skbn, &ipc->sk);
+		qrtr_node_enqueue(node, skbn, type, &ipc->us, &to);
+		qrtr_node_release(node);
 	}
+exit:
+	qrtr_local_enqueue(NULL, skb, type, &ipc->us, &to);
+}
 
+/* Remove port assignment. */
+static void qrtr_port_remove(struct qrtr_sock *ipc)
+{
+	int port = ipc->us.sq_port;
+
+	qrtr_send_del_client(ipc);
 	if (port == QRTR_PORT_CTRL)
 		port = 0;
 
@@ -941,6 +977,11 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			return -ECONNRESET;
 		}
 		enqueue_fn = qrtr_node_enqueue;
+
+		if (ipc->state > QRTR_STATE_INIT && ipc->state != node->nid)
+			ipc->state = QRTR_STATE_MULTI;
+		else if (ipc->state == QRTR_STATE_INIT)
+			ipc->state = node->nid;
 	}
 
 	plen = (len + 3) & ~3;
@@ -957,7 +998,8 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out_node;
 	}
 
-	if (ipc->us.sq_port == QRTR_PORT_CTRL) {
+	if (ipc->us.sq_port == QRTR_PORT_CTRL ||
+	    addr->sq_port == QRTR_PORT_CTRL) {
 		if (len < 4) {
 			rc = -EINVAL;
 			kfree_skb(skb);
@@ -969,6 +1011,9 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	}
 
 	type = le32_to_cpu(qrtr_type);
+	if (addr->sq_port == QRTR_PORT_CTRL && type == QRTR_TYPE_NEW_SERVER)
+		ipc->state = QRTR_STATE_MULTI;
+
 	rc = enqueue_fn(node, skb, type, &ipc->us, addr);
 	if (rc >= 0)
 		rc = len;
@@ -1256,6 +1301,7 @@ static int qrtr_create(struct net *net, struct socket *sock,
 	ipc->us.sq_family = AF_QIPCRTR;
 	ipc->us.sq_node = qrtr_local_nid;
 	ipc->us.sq_port = 0;
+	ipc->state = QRTR_STATE_INIT;
 
 	return 0;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

