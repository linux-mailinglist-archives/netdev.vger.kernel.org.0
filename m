Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2515A30625
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 03:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfEaBSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 21:18:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37509 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfEaBSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 21:18:03 -0400
Received: by mail-pf1-f195.google.com with SMTP id a23so5087858pff.4
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 18:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4uHEAa5GeZzr2h0opAabsUuB1kTv1SagFVuFPuo6Vy4=;
        b=migBA7G0X8TRyWt+AlogD9HOesTE9MlGY/VHdPuOv2b4R05pmowj823gTs5tiG2Pov
         sSM2x9XvzPtsJczvx912e+oBwNoeY01DDuG3j1RTintQIw2Z9zKUXgRya/xSQ3WAfMA/
         mz9V6ymLT0qqERhwb6SQDuwBuWSZmUFu23sOd+OfIGIM2E1HKn1jxxJoUSIEytKr0Sm4
         6rKrQhG8WyFbNg6SsnzSfWvGTpgn4kRZRqxjg9Cz+Si6LvJBNtliij/XI3FjAmHk9+xs
         q6SB7k1FJaoPMpQ7Xk71ak8xHKrI/uWpJv3i6+MtXEV5OABRTwdwkHziRE60+tfrSbzA
         xdOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4uHEAa5GeZzr2h0opAabsUuB1kTv1SagFVuFPuo6Vy4=;
        b=W50+oV+37zoDaRq661UG7rKFEMn0+r0La2ZqK/jO4IJtrv3BrGy6Q/OEDat+owowvU
         iZ5Wr0IpVT5s3LSzvTPKuI8oTfyca7MEObEtSlLh03fGLQbGTwDHU2hGyYvNsyMqubVn
         lUE4h3MmPYiZQuQbVdfR86bAW23+f+uN8m6Cxvkv17TTU41m2Ck+hSMJO2kwKuUTK6tw
         YMNMKLnQlyP5TZGof1rKa6JAfYH8NyNfPmjPvrDWzMne0cXmwv+ZaD7YFcTR29534hcD
         w/2oP64F4+0XVJYoBkCUb5hjO2L75jenHQKNdOssF5Vfk3NNT4sXOsTc+B0054Ek36de
         7sLw==
X-Gm-Message-State: APjAAAXdOi8KmUAqLPB0YFjC1j1DlOJOkmU5haPvrz0aaBa5p6jyjduQ
        v8ZZG4i8lQuELBHAY62msN3oxw==
X-Google-Smtp-Source: APXvYqyzIj6Pm1KfV/B4BT/7El4cJiSWB3kByoiUQxMfNJ3vK96ay9Q4JTPnEheGYvM+SrTLPr/mRg==
X-Received: by 2002:a63:ea42:: with SMTP id l2mr5875093pgk.19.1559265482268;
        Thu, 30 May 2019 18:18:02 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id j20sm1819042pff.183.2019.05.30.18.18.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 18:18:01 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 5/5] net: qrtr: Remove receive worker
Date:   Thu, 30 May 2019 18:17:53 -0700
Message-Id: <20190531011753.11840-6-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190531011753.11840-1-bjorn.andersson@linaro.org>
References: <20190531011753.11840-1-bjorn.andersson@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than enqueuing messages and scheduling a worker to deliver them
to the individual sockets we can now, thanks to the previous work, move
this directly into the endpoint callback.

This saves us a context switch per incoming message and removes the
possibility of an opportunistic suspend to happen between the message is
coming from the endpoint until it ends up in the socket's receive
buffer.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v1:
- None

 net/qrtr/qrtr.c | 54 ++++++++++++++++---------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 7f048b9e02fb..782a3e8c5f93 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -165,6 +165,8 @@ static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 			      int type, struct sockaddr_qrtr *from,
 			      struct sockaddr_qrtr *to);
+static struct qrtr_sock *qrtr_port_lookup(int port);
+static void qrtr_port_put(struct qrtr_sock *ipc);
 
 /* Release node resources and free the node.
  *
@@ -429,6 +431,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	struct qrtr_node *node = ep->node;
 	const struct qrtr_hdr_v1 *v1;
 	const struct qrtr_hdr_v2 *v2;
+	struct qrtr_sock *ipc;
 	struct sk_buff *skb;
 	struct qrtr_cb *cb;
 	unsigned int size;
@@ -493,8 +496,20 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	skb_put_data(skb, data + hdrlen, size);
 
-	skb_queue_tail(&node->rx_queue, skb);
-	schedule_work(&node->work);
+	qrtr_node_assign(node, cb->src_node);
+
+	if (cb->type == QRTR_TYPE_RESUME_TX) {
+		qrtr_tx_resume(node, skb);
+	} else {
+		ipc = qrtr_port_lookup(cb->dst_port);
+		if (!ipc)
+			goto err;
+
+		if (sock_queue_rcv_skb(&ipc->sk, skb))
+			goto err;
+
+		qrtr_port_put(ipc);
+	}
 
 	return 0;
 
@@ -529,40 +544,6 @@ static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt)
 	return skb;
 }
 
-static struct qrtr_sock *qrtr_port_lookup(int port);
-static void qrtr_port_put(struct qrtr_sock *ipc);
-
-/* Handle and route a received packet.
- *
- * This will auto-reply with resume-tx packet as necessary.
- */
-static void qrtr_node_rx_work(struct work_struct *work)
-{
-	struct qrtr_node *node = container_of(work, struct qrtr_node, work);
-	struct sk_buff *skb;
-
-	while ((skb = skb_dequeue(&node->rx_queue)) != NULL) {
-		struct qrtr_sock *ipc;
-		struct qrtr_cb *cb = (struct qrtr_cb *)skb->cb;
-
-		qrtr_node_assign(node, cb->src_node);
-
-		if (cb->type == QRTR_TYPE_RESUME_TX) {
-			qrtr_tx_resume(node, skb);
-		} else {
-			ipc = qrtr_port_lookup(cb->dst_port);
-			if (!ipc) {
-				kfree_skb(skb);
-			} else {
-				if (sock_queue_rcv_skb(&ipc->sk, skb))
-					kfree_skb(skb);
-
-				qrtr_port_put(ipc);
-			}
-		}
-	}
-}
-
 /**
  * qrtr_endpoint_register() - register a new endpoint
  * @ep: endpoint to register
@@ -582,7 +563,6 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	if (!node)
 		return -ENOMEM;
 
-	INIT_WORK(&node->work, qrtr_node_rx_work);
 	kref_init(&node->ref);
 	mutex_init(&node->ep_lock);
 	skb_queue_head_init(&node->rx_queue);
-- 
2.18.0

