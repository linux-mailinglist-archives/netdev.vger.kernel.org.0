Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A1F131F84
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 06:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgAGFsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 00:48:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44850 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbgAGFr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 00:47:59 -0500
Received: by mail-pf1-f196.google.com with SMTP id 195so27174871pfw.11
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 21:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q8WRI+qUQZlGszEtK3jeWsUzFsQlStZutV7Edw49HRw=;
        b=snWGlbZzbm52Mz1lT/882bGPX6l7KVbWuYotQZm7zWhmk/Gw2qxF+2bJW+axtnEMuH
         t5500qOs7GjrNNDOJW4TVUdR3Q5NvSgAqLDzseB/Y3d2+n/YlBJeNwgyzNmVImaGq1BY
         FdXSTiUg1MqKthlFjCjw4O1yAFX4zRokNTFgasiWDA+Cm7egIzDsopXWdULk31L/h8AW
         rvdUZ6qBIp/L01vPs8dZC4kYaX4q0ptCPunWAYew7Hge+EDlHxRZUQzq/c/euzwmQu+M
         E4ZApkK6Ez8t0OXwRe3tuEEfGlill0laOCEftYsRgZeqm3/CmLYG0TTIgR7831eR34O0
         2qAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q8WRI+qUQZlGszEtK3jeWsUzFsQlStZutV7Edw49HRw=;
        b=S+pczBmZQskvOJAtX5qolT8ZatjIU9SsB5n7omjDuWZLAOUDQP/9nWRCI9p6vnqK+Y
         FaoQY1WTYtJN94gz6AK3E9K9E64i3V6JO+Phxn5WfkwO/Y84DTq2A2BwueM2m9jnRwZ2
         6LanLCkyRM4ToEfqiGxVoeW1KKkwTG/HKGsEMNPBsU7VtR758/n04DS8rqi/f90Oo4ZJ
         mUJktmjew79wMukFrI071MSV8eoUYldMc3Y6DdJwCfhpTOKsPz9/EUUxX8OV180SG+yH
         mQtcDNBBQMGeiA/2s9/bGCgvnGSGGafsG4G1aCvj2XsqtMdQIHNI0TEtsrDIMEy8A3Iu
         5Tew==
X-Gm-Message-State: APjAAAW64rzeQEXocYrCpGzlP3Y2JrxnayC2/rf7CeQynaTgSLCKbJPW
        1zMkqOA56RILugSq06XUDLxrsQ==
X-Google-Smtp-Source: APXvYqz6RS6rAhVvClehoCBs5c52r1sjw5fT2BTjjcHyVPvCNiUzmZ2fMS8GuyINaDDz6gJiPEM3tA==
X-Received: by 2002:aa7:9092:: with SMTP id i18mr81869493pfa.238.1578376078978;
        Mon, 06 Jan 2020 21:47:58 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id k21sm67129177pfa.63.2020.01.06.21.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 21:47:58 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v3 2/5] net: qrtr: Implement outgoing flow control
Date:   Mon,  6 Jan 2020 21:47:10 -0800
Message-Id: <20200107054713.3909260-3-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200107054713.3909260-1-bjorn.andersson@linaro.org>
References: <20200107054713.3909260-1-bjorn.andersson@linaro.org>
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

Changes since v2:
- Replaced atomic "pending" with in and the use of a spin_lockon &resume_tx.lock
- Move wait queue into qrtr_tx_flow struct to only wake up the sleepers that
  are actually affected by the notification
- Take spinlock around the check in qrtr_tx_wait(), so that we don't need to
  spin around the wait_event to prevent > H clients continuing

 net/qrtr/qrtr.c | 189 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 182 insertions(+), 7 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 6c56a8ce83ef..a6da5fa2a9b5 100644
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
@@ -142,7 +163,9 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
  */
 static void __qrtr_node_release(struct kref *kref)
 {
+	struct radix_tree_iter iter;
 	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
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
 
@@ -171,6 +200,122 @@ static void qrtr_node_release(struct qrtr_node *node)
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
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
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
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
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
@@ -179,6 +324,13 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
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
@@ -194,7 +346,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	}
 
 	hdr->size = cpu_to_le32(len);
-	hdr->confirm_rx = 0;
+	hdr->confirm_rx = !!confirm_rx;
 
 	skb_put_padto(skb, ALIGN(len, 4));
 
@@ -205,6 +357,11 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 		kfree_skb(skb);
 	mutex_unlock(&node->ep_lock);
 
+	/* Need to ensure that a subsequent message carries the otherwise lost
+	 * confirm_rx flag if we dropped this one */
+	if (rc && confirm_rx)
+		qrtr_tx_flow_failed(node, to->sq_node, to->sq_port);
+
 	return rc;
 }
 
@@ -311,7 +468,8 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	if (len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
-	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA)
+	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
+	    cb->type != QRTR_TYPE_RESUME_TX)
 		goto err;
 
 	skb_put_data(skb, data + hdrlen, size);
@@ -370,14 +528,18 @@ static void qrtr_node_rx_work(struct work_struct *work)
 
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
@@ -408,6 +570,8 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	node->nid = QRTR_EP_NID_AUTO;
 	node->ep = ep;
 
+	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
+
 	qrtr_node_assign(node, nid);
 
 	mutex_lock(&qrtr_node_lock);
@@ -428,8 +592,11 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
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
@@ -442,6 +609,14 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
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

