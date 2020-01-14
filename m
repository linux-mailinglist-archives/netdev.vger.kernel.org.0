Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0007B13A263
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgANH6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:58:23 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33511 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729117AbgANH5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:57:55 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay11so4923425plb.0
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BmDxezDl+bcc/vn8zCZPk3UWw3V1frore6GMVRf+Cyc=;
        b=H7d0Hhqz9zgKRKrClKNStNh28kydx/yi69xtXYE4f8bzWa6C97ISTLHXuC8Oc2/3VC
         2buEzPgiJTVDxb/0lub4YFXIlBpISYMccEI9pkEUEKk7T7E+sg8WRVf0Qsr+rtmszGQ7
         T4pDqI4o4ReZxAlM5IMfE/7HQZ+xnMR54+KGRN13P1qzSuqphL50/llQ95YEAAIqoCJZ
         7ajzitI58HE6xTvxdIv/a0uh6x79IzBx82stQOAAUTpOEZM9uoZEJMsZnmyY8Z28nDUO
         XzPlZViKukN8iqvzypC2LYvYnFj2mDKFS+kiwMhib5fR61FgVy70knCIb5B5iTmCrKe7
         5S/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BmDxezDl+bcc/vn8zCZPk3UWw3V1frore6GMVRf+Cyc=;
        b=hR4bxyZ2wFxj1ud2sXeCZlRlblQQq6I8B5Wx7CiPbm7gjFd7PcKkxxB9o2a5KDt8DP
         fn5W07q/s/HRJSXcbiiaRfrffqht1d12iVfPOqqSOkOkWnYIlEIW08VhL6o0uHZwv+ah
         par91WSQ5wLbxM6su7kfwseNHTFNG4DAh7xEuBE2f8Aw7/uieuWH+OsM8bRh/SBArE8D
         NQhwNuze24KHkyS5oPi9xs22OIclm2/RShQ8oU9GNunDAjokNp24SOyEZwXS7S7fVvHs
         BF+HJ11pTmalbMiVoybGGDqd29sTXM/d3QFvjt51alqnBhcGnelMSzKplX5+VHhMrgCS
         h+/A==
X-Gm-Message-State: APjAAAVjUK3Frm5EAlEsZClJiNKEHqeDEMJSTtwZKxeWTk092BJLMifV
        A0dj42LOxnmWhHIF5faSYPrHeg==
X-Google-Smtp-Source: APXvYqxhMbw+qhAsaVya8gB/e5hUV42dts+kebeNCEbhDAl2ja9ytSGIuS07lbCFG1rxR3A+nymWdA==
X-Received: by 2002:a17:90a:3aaf:: with SMTP id b44mr28094131pjc.9.1578988674635;
        Mon, 13 Jan 2020 23:57:54 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id q63sm17349352pfb.149.2020.01.13.23.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 23:57:53 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 2/5] net: qrtr: Implement outgoing flow control
Date:   Mon, 13 Jan 2020 23:57:00 -0800
Message-Id: <20200114075703.2145718-3-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200114075703.2145718-1-bjorn.andersson@linaro.org>
References: <20200114075703.2145718-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to prevent overconsumption of resources on the remote side QRTR
implements a flow control mechanism.

The mechanism works by the sender keeping track of the number of
outstanding unconfirmed messages that has been transmitted to a
particular node/port pair.

Upon count reaching a low watermark (L) the confirm_rx bit is set in the
outgoing message and when the count reaching a high watermark (H)
transmission will be blocked upon the reception of a resume_tx message
from the remote, that resets the counter to 0.

This guarantees that there will be at most 2H - L messages in flight.
Values chosen for L and H are 5 and 10 respectively.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v3:
- Fix the xmas tree
- Wrap radix_tree_lookup() in rcu_read_lock()
- Initialize qrtr_tx_lock

 net/qrtr/qrtr.c | 194 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 187 insertions(+), 7 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 6c56a8ce83ef..304d536c7353 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -8,6 +8,7 @@
 #include <linux/qrtr.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/numa.h>
+#include <linux/wait.h>
 
 #include <net/sock.h>
 
@@ -113,6 +114,8 @@ static DEFINE_MUTEX(qrtr_port_lock);
  * @ep: endpoint
  * @ref: reference count for node
  * @nid: node id
+ * @qrtr_tx_flow: tree of qrtr_tx_flow, keyed by node << 32 | port
+ * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
  * @rx_queue: receive queue
  * @work: scheduled work struct for recv work
  * @item: list item for broadcast list
@@ -123,11 +126,29 @@ struct qrtr_node {
 	struct kref ref;
 	unsigned int nid;
 
+	struct radix_tree_root qrtr_tx_flow;
+	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
+
 	struct sk_buff_head rx_queue;
 	struct work_struct work;
 	struct list_head item;
 };
 
+/**
+ * struct qrtr_tx_flow - tx flow control
+ * @resume_tx: waiters for a resume tx from the remote
+ * @pending: number of waiting senders
+ * @tx_failed: indicates that a message with confirm_rx flag was lost
+ */
+struct qrtr_tx_flow {
+	struct wait_queue_head resume_tx;
+	int pending;
+	int tx_failed;
+};
+
+#define QRTR_TX_FLOW_HIGH	10
+#define QRTR_TX_FLOW_LOW	5
+
 static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 			      int type, struct sockaddr_qrtr *from,
 			      struct sockaddr_qrtr *to);
@@ -143,6 +164,8 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 static void __qrtr_node_release(struct kref *kref)
 {
 	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
+	struct radix_tree_iter iter;
+	void __rcu **slot;
 
 	if (node->nid != QRTR_EP_NID_AUTO)
 		radix_tree_delete(&qrtr_nodes, node->nid);
@@ -152,6 +175,12 @@ static void __qrtr_node_release(struct kref *kref)
 
 	cancel_work_sync(&node->work);
 	skb_queue_purge(&node->rx_queue);
+
+	/* Free tx flow counters */
+	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
+		radix_tree_iter_delete(&node->qrtr_tx_flow, &iter, slot);
+		kfree(*slot);
+	}
 	kfree(node);
 }
 
@@ -171,6 +200,126 @@ static void qrtr_node_release(struct qrtr_node *node)
 	kref_put_mutex(&node->ref, __qrtr_node_release, &qrtr_node_lock);
 }
 
+/**
+ * qrtr_tx_resume() - reset flow control counter
+ * @node:	qrtr_node that the QRTR_TYPE_RESUME_TX packet arrived on
+ * @skb:	resume_tx packet
+ */
+static void qrtr_tx_resume(struct qrtr_node *node, struct sk_buff *skb)
+{
+	struct qrtr_ctrl_pkt *pkt = (struct qrtr_ctrl_pkt *)skb->data;
+	u64 remote_node = le32_to_cpu(pkt->client.node);
+	u32 remote_port = le32_to_cpu(pkt->client.port);
+	struct qrtr_tx_flow *flow;
+	unsigned long key;
+
+	key = remote_node << 32 | remote_port;
+
+	rcu_read_lock();
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	rcu_read_unlock();
+	if (flow) {
+		spin_lock(&flow->resume_tx.lock);
+		flow->pending = 0;
+		spin_unlock(&flow->resume_tx.lock);
+		wake_up_interruptible_all(&flow->resume_tx);
+	}
+
+	consume_skb(skb);
+}
+
+/**
+ * qrtr_tx_wait() - flow control for outgoing packets
+ * @node:	qrtr_node that the packet is to be send to
+ * @dest_node:	node id of the destination
+ * @dest_port:	port number of the destination
+ * @type:	type of message
+ *
+ * The flow control scheme is based around the low and high "watermarks". When
+ * the low watermark is passed the confirm_rx flag is set on the outgoing
+ * message, which will trigger the remote to send a control message of the type
+ * QRTR_TYPE_RESUME_TX to reset the counter. If the high watermark is hit
+ * further transmision should be paused.
+ *
+ * Return: 1 if confirm_rx should be set, 0 otherwise or errno failure
+ */
+static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
+			int type)
+{
+	unsigned long key = (u64)dest_node << 32 | dest_port;
+	struct qrtr_tx_flow *flow;
+	int confirm_rx = 0;
+	int ret;
+
+	/* Never set confirm_rx on non-data packets */
+	if (type != QRTR_TYPE_DATA)
+		return 0;
+
+	mutex_lock(&node->qrtr_tx_lock);
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	if (!flow) {
+		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
+		if (flow) {
+			init_waitqueue_head(&flow->resume_tx);
+			radix_tree_insert(&node->qrtr_tx_flow, key, flow);
+		}
+	}
+	mutex_unlock(&node->qrtr_tx_lock);
+
+	/* Set confirm_rx if we where unable to find and allocate a flow */
+	if (!flow)
+		return 1;
+
+	spin_lock_irq(&flow->resume_tx.lock);
+	ret = wait_event_interruptible_locked_irq(flow->resume_tx,
+						  flow->pending < QRTR_TX_FLOW_HIGH ||
+						  flow->tx_failed ||
+						  !node->ep);
+	if (ret < 0) {
+		confirm_rx = ret;
+	} else if (!node->ep) {
+		confirm_rx = -EPIPE;
+	} else if (flow->tx_failed) {
+		flow->tx_failed = 0;
+		confirm_rx = 1;
+	} else {
+		flow->pending++;
+		confirm_rx = flow->pending == QRTR_TX_FLOW_LOW;
+	}
+	spin_unlock_irq(&flow->resume_tx.lock);
+
+	return confirm_rx;
+}
+
+/**
+ * qrtr_tx_flow_failed() - flag that tx of confirm_rx flagged messages failed
+ * @node:	qrtr_node that the packet is to be send to
+ * @dest_node:	node id of the destination
+ * @dest_port:	port number of the destination
+ *
+ * Signal that the transmission of a message with confirm_rx flag failed. The
+ * flow's "pending" counter will keep incrementing towards QRTR_TX_FLOW_HIGH,
+ * at which point transmission would stall forever waiting for the resume TX
+ * message associated with the dropped confirm_rx message.
+ * Work around this by marking the flow as having a failed transmission and
+ * cause the next transmission attempt to be sent with the confirm_rx.
+ */
+static void qrtr_tx_flow_failed(struct qrtr_node *node, int dest_node,
+				int dest_port)
+{
+	unsigned long key = (u64)dest_node << 32 | dest_port;
+	struct qrtr_tx_flow *flow;
+
+	rcu_read_lock();
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	rcu_read_unlock();
+	if (flow) {
+		spin_lock_irq(&flow->resume_tx.lock);
+		flow->tx_failed = 1;
+		spin_unlock_irq(&flow->resume_tx.lock);
+	}
+}
+
 /* Pass an outgoing packet socket buffer to the endpoint driver. */
 static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 			     int type, struct sockaddr_qrtr *from,
@@ -179,6 +328,13 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	struct qrtr_hdr_v1 *hdr;
 	size_t len = skb->len;
 	int rc = -ENODEV;
+	int confirm_rx;
+
+	confirm_rx = qrtr_tx_wait(node, to->sq_node, to->sq_port, type);
+	if (confirm_rx < 0) {
+		kfree_skb(skb);
+		return confirm_rx;
+	}
 
 	hdr = skb_push(skb, sizeof(*hdr));
 	hdr->version = cpu_to_le32(QRTR_PROTO_VER_1);
@@ -194,7 +350,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	}
 
 	hdr->size = cpu_to_le32(len);
-	hdr->confirm_rx = 0;
+	hdr->confirm_rx = !!confirm_rx;
 
 	skb_put_padto(skb, ALIGN(len, 4));
 
@@ -205,6 +361,11 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 		kfree_skb(skb);
 	mutex_unlock(&node->ep_lock);
 
+	/* Need to ensure that a subsequent message carries the otherwise lost
+	 * confirm_rx flag if we dropped this one */
+	if (rc && confirm_rx)
+		qrtr_tx_flow_failed(node, to->sq_node, to->sq_port);
+
 	return rc;
 }
 
@@ -311,7 +472,8 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	if (len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
-	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA)
+	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
+	    cb->type != QRTR_TYPE_RESUME_TX)
 		goto err;
 
 	skb_put_data(skb, data + hdrlen, size);
@@ -370,14 +532,18 @@ static void qrtr_node_rx_work(struct work_struct *work)
 
 		qrtr_node_assign(node, cb->src_node);
 
-		ipc = qrtr_port_lookup(cb->dst_port);
-		if (!ipc) {
-			kfree_skb(skb);
+		if (cb->type == QRTR_TYPE_RESUME_TX) {
+			qrtr_tx_resume(node, skb);
 		} else {
-			if (sock_queue_rcv_skb(&ipc->sk, skb))
+			ipc = qrtr_port_lookup(cb->dst_port);
+			if (!ipc) {
 				kfree_skb(skb);
+			} else {
+				if (sock_queue_rcv_skb(&ipc->sk, skb))
+					kfree_skb(skb);
 
-			qrtr_port_put(ipc);
+				qrtr_port_put(ipc);
+			}
 		}
 	}
 }
@@ -408,6 +574,9 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	node->nid = QRTR_EP_NID_AUTO;
 	node->ep = ep;
 
+	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
+	mutex_init(&node->qrtr_tx_lock);
+
 	qrtr_node_assign(node, nid);
 
 	mutex_lock(&qrtr_node_lock);
@@ -428,8 +597,11 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	struct qrtr_node *node = ep->node;
 	struct sockaddr_qrtr src = {AF_QIPCRTR, node->nid, QRTR_PORT_CTRL};
 	struct sockaddr_qrtr dst = {AF_QIPCRTR, qrtr_local_nid, QRTR_PORT_CTRL};
+	struct radix_tree_iter iter;
 	struct qrtr_ctrl_pkt *pkt;
+	struct qrtr_tx_flow *flow;
 	struct sk_buff *skb;
+	void __rcu **slot;
 
 	mutex_lock(&node->ep_lock);
 	node->ep = NULL;
@@ -442,6 +614,14 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 		qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
 	}
 
+	/* Wake up any transmitters waiting for resume-tx from the node */
+	mutex_lock(&node->qrtr_tx_lock);
+	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
+		flow = *slot;
+		wake_up_interruptible_all(&flow->resume_tx);
+	}
+	mutex_unlock(&node->qrtr_tx_lock);
+
 	qrtr_node_release(node);
 	ep->node = NULL;
 }
-- 
2.24.0

