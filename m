Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB11730622
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 03:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfEaBSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 21:18:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34411 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfEaBSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 21:18:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id c14so2666160pfi.1
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 18:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8FbJXWm7IwNwmHEAYW2wS/GK5+Jrpw3917WQc7Xc8o0=;
        b=KUV8E1vjIxI4xbCkx96493AfVDnh3FIvDgdBaO0Y9QSxHAxJnMtLzIE+5uDUPEIvfb
         Azp5QMda5p5MWjM9WSMpLN1vphUiHA9bsfxFcu6GnJjYnqctOWFxkiMSDyfoP8PJeAdn
         bLoYdSuLicoyPE4Fp/BeLtO8xdUKR+H3OiUQVhc8KWfx6Mrcrb+UKadD7dCcmntWbxPo
         bYdiqgMASjoK+ysKsOEg+dKJa9+mYlUEZ1Hvt2wTvnSSzxadHZ04FHXIEHhoE5F+uxTd
         K+JbxOWM4LYWOAMBn18Qe0BXcr+//b+H2A17a9pJJZ5j2yCoITRDel0Wjuk+f8QCDxQF
         USGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8FbJXWm7IwNwmHEAYW2wS/GK5+Jrpw3917WQc7Xc8o0=;
        b=K56Dljgy2k1OHutmFPEeZbzsmj5MGAR+MiJc8fJxelIX1Ve6itLcyAFQJIKQLXUfsa
         GxHwRPYCMpUSpXU/92PxeLQdV5I+G+zhNpc7AIlyRiqUc7CgJMJgzfh7AiXAdUSjkpfX
         LznZCFtzTHnyiaMCoJupja0ld1NLXe0Pb9DxZjMq0ije/IT7TjIzZFqkHR31XYAcDeOJ
         gSrCJzYltXvEcWmsdnQvk3KPC2jCnHB67AFdIGi3/w67cBDT1aYAQaIx7LuEHssYUorf
         iAJfIGY2L7CiUQ5allzuQkapPQDVnUGJITIGZu2MGzje//49UXTXk9S0SBWI+y8OTnP6
         WNkA==
X-Gm-Message-State: APjAAAVjMpVx2PBtayf97QsULI3pS8BpZMUcEbl11U2QHXsy4DjwipgP
        SPn4xP7MUozcUXXk3YvQFbRicg==
X-Google-Smtp-Source: APXvYqxfIidRP+aT2xTzXM31gLcNoPwt9qFnLcvWG2vjWtkI2FLuVrXK56Bz+ldq271X84tT15Lp2g==
X-Received: by 2002:a63:1854:: with SMTP id 20mr6173820pgy.366.1559265479240;
        Thu, 30 May 2019 18:17:59 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id j20sm1819042pff.183.2019.05.30.18.17.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 18:17:58 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 2/5] net: qrtr: Implement outgoing flow control
Date:   Thu, 30 May 2019 18:17:50 -0700
Message-Id: <20190531011753.11840-3-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190531011753.11840-1-bjorn.andersson@linaro.org>
References: <20190531011753.11840-1-bjorn.andersson@linaro.org>
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

Changes since v1:
- Tidy up the x-mas tree
- Don't dereference NULL "flow" if kzalloc fails
- Ensure that the next message picks up the confirm_rx flag if a flagged
  message failed to be transmitted by the underlaying transport

 net/qrtr/qrtr.c | 186 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 179 insertions(+), 7 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 89fb846cc244..38cc052b7a31 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -16,6 +16,7 @@
 #include <linux/qrtr.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/numa.h>
+#include <linux/wait.h>
 
 #include <net/sock.h>
 
@@ -121,6 +122,9 @@ static DEFINE_MUTEX(qrtr_port_lock);
  * @ep: endpoint
  * @ref: reference count for node
  * @nid: node id
+ * @qrtr_tx_flow: tree with tx counts per flow
+ * @resume_tx: waiters for a resume tx from the remote
+ * @qrtr_tx_lock: lock for qrtr_tx_flow
  * @rx_queue: receive queue
  * @work: scheduled work struct for recv work
  * @item: list item for broadcast list
@@ -131,11 +135,28 @@ struct qrtr_node {
 	struct kref ref;
 	unsigned int nid;
 
+	struct radix_tree_root qrtr_tx_flow;
+	struct wait_queue_head resume_tx;
+	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
+
 	struct sk_buff_head rx_queue;
 	struct work_struct work;
 	struct list_head item;
 };
 
+/**
+ * struct qrtr_tx_flow - tx flow control
+ * @pending: number of waiting senders
+ * @tx_failed: indicates that a message with confirm_rx flag was lost
+ */
+struct qrtr_tx_flow {
+	atomic_t pending;
+	int tx_failed;
+};
+
+#define QRTR_TX_FLOW_HIGH	10
+#define QRTR_TX_FLOW_LOW	5
+
 static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 			      int type, struct sockaddr_qrtr *from,
 			      struct sockaddr_qrtr *to);
@@ -150,7 +171,9 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
  */
 static void __qrtr_node_release(struct kref *kref)
 {
+	struct radix_tree_iter iter;
 	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
+	void __rcu **slot;
 
 	if (node->nid != QRTR_EP_NID_AUTO)
 		radix_tree_delete(&qrtr_nodes, node->nid);
@@ -158,6 +181,12 @@ static void __qrtr_node_release(struct kref *kref)
 	list_del(&node->item);
 	mutex_unlock(&qrtr_node_lock);
 
+	/* Free tx flow counters */
+	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
+		radix_tree_iter_delete(&node->qrtr_tx_flow, &iter, slot);
+		kfree(*slot);
+	}
+
 	skb_queue_purge(&node->rx_queue);
 	kfree(node);
 }
@@ -178,6 +207,126 @@ static void qrtr_node_release(struct qrtr_node *node)
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
+	if (flow)
+		atomic_set(&flow->pending, 0);
+
+	wake_up_interruptible_all(&node->resume_tx);
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
+		if (flow)
+			radix_tree_insert(&node->qrtr_tx_flow, key, flow);
+	}
+	mutex_unlock(&node->qrtr_tx_lock);
+
+	/* Set confirm_rx if we where unable to find and allocate a flow */
+	if (!flow)
+		return 1;
+
+	for (;;) {
+		ret = wait_event_interruptible(node->resume_tx,
+					       atomic_read(&flow->pending) < QRTR_TX_FLOW_HIGH ||
+					       !node->ep ||
+					       READ_ONCE(flow->tx_failed));
+		if (ret)
+			return ret;
+
+		if (!node->ep)
+			return -EPIPE;
+
+		mutex_lock(&node->qrtr_tx_lock);
+		if (READ_ONCE(flow->tx_failed)) {
+			WRITE_ONCE(flow->tx_failed, 0);
+			confirm_rx = 1;
+			mutex_unlock(&node->qrtr_tx_lock);
+			break;
+		}
+
+		if (atomic_read(&flow->pending) < QRTR_TX_FLOW_HIGH) {
+			confirm_rx = atomic_inc_return(&flow->pending) == QRTR_TX_FLOW_LOW;
+			mutex_unlock(&node->qrtr_tx_lock);
+			break;
+		}
+		mutex_unlock(&node->qrtr_tx_lock);
+	}
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
+	mutex_lock(&node->qrtr_tx_lock);
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	if (flow)
+		WRITE_ONCE(flow->tx_failed, 1);
+	mutex_unlock(&node->qrtr_tx_lock);
+}
+
 /* Pass an outgoing packet socket buffer to the endpoint driver. */
 static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 			     int type, struct sockaddr_qrtr *from,
@@ -186,6 +335,13 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
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
@@ -201,7 +357,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	}
 
 	hdr->size = cpu_to_le32(len);
-	hdr->confirm_rx = 0;
+	hdr->confirm_rx = !!confirm_rx;
 
 	skb_put_padto(skb, ALIGN(len, 4));
 
@@ -212,6 +368,11 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 		kfree_skb(skb);
 	mutex_unlock(&node->ep_lock);
 
+	/* Need to ensure that a subsequent message carries the otherwise lost
+	 * confirm_rx flag if we dropped this one */
+	if (rc && confirm_rx)
+		qrtr_tx_flow_failed(node, to->sq_node, to->sq_port);
+
 	return rc;
 }
 
@@ -318,7 +479,8 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	if (len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
-	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA)
+	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
+	    cb->type != QRTR_TYPE_RESUME_TX)
 		goto err;
 
 	skb_put_data(skb, data + hdrlen, size);
@@ -377,14 +539,18 @@ static void qrtr_node_rx_work(struct work_struct *work)
 
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
@@ -415,6 +581,9 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	node->nid = QRTR_EP_NID_AUTO;
 	node->ep = ep;
 
+	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
+	init_waitqueue_head(&node->resume_tx);
+
 	qrtr_node_assign(node, nid);
 
 	mutex_lock(&qrtr_node_lock);
@@ -449,6 +618,9 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 		qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
 	}
 
+	/* Wake up any transmitters waiting for resume-tx from the node */
+	wake_up_interruptible_all(&node->resume_tx);
+
 	qrtr_node_release(node);
 	ep->node = NULL;
 }
-- 
2.18.0

