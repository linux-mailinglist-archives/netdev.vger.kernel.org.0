Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C76131F76
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 06:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgAGFr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 00:47:59 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44848 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbgAGFr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 00:47:58 -0500
Received: by mail-pf1-f195.google.com with SMTP id 195so27174850pfw.11
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 21:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dp7a/ozyZfwB+kP9dnZlOFXZoCwRQSjpD5T5pIZB/8Q=;
        b=yG5p0DxGkRBjp/72mUW+KHkkmfaqAG3dRkQk/K8otpNmmxqbbHXTuqI3PI88MWL98a
         aH57NWaxfTAQLfjE05VRrzeS/XqFqlyvsOfBB6Q/zs0WEM2VqFWCQ/m7bx7OOp4TT2Wn
         9Ju9v4nCwRJsqeEY4Rz4eg8o6Vznol5Hn+pF/f0r6UNZyolE2ioBWiP90HgXTDuDpG9n
         raS1ofswapv74TCZDwb3CQ46mUNg71E4OGWxNAqmgZReQc48uSIbGb8xM3fqfd7Hdc3Q
         8k66w1JR8ImNTIdnzSmEQf3kILOH0JDy9Mlq3swvZj2VJnDZhZnhXFavf2aQYP86YYCB
         tPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dp7a/ozyZfwB+kP9dnZlOFXZoCwRQSjpD5T5pIZB/8Q=;
        b=Y2ZzrVTSOgnRww6qAiXKYyCyvbQxqn0tzP+VP4JHOkdvC5B1Pv1gtHaO2Lja3yfgo9
         7pd1CAzdSnQyFOQmxl20CXqymuO5uO8C1+gaD90pzslumMKlrqvCyx97zUXD5TGXnpCO
         CIjZO2UtdZQ1Lo8/dOAzmzb73C2UePo2eRnNQWTD5AS5EDy9FK8ILj5wAdI1CuaNA3ss
         yP7ZN/Ym3I6wotdKb7peTXFYp8eLd5XvNc8L30KQ5BAuff+/Hfbi42x6jQXIrgSMRfF3
         /Jnvlt5RA2EOpRsnM8/Z4EEUxP3OzrHkRZYXOCmuxHIyOOHj8U2f84dwhrGcJtz0r43B
         YSnA==
X-Gm-Message-State: APjAAAWd7LDh0fmYn/Ld7be4r0VpEDB+OgNluOEdLs4wGUCXW6c9magg
        9q155NcBwbxH6fhgi5m6fwVTbw==
X-Google-Smtp-Source: APXvYqxL6g+CoprISrZRW8EQIhr/95irjbEu71b+reVIWVK02C3ShkAlq/3bL3LoeYxiH57cIRzzMw==
X-Received: by 2002:a63:e17:: with SMTP id d23mr115992276pgl.173.1578376077643;
        Mon, 06 Jan 2020 21:47:57 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id k21sm67129177pfa.63.2020.01.06.21.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 21:47:57 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v3 1/5] net: qrtr: Move resume-tx transmission to recvmsg
Date:   Mon,  6 Jan 2020 21:47:09 -0800
Message-Id: <20200107054713.3909260-2-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200107054713.3909260-1-bjorn.andersson@linaro.org>
References: <20200107054713.3909260-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The confirm-rx bit is used to implement a per port flow control, in
order to make sure that no messages are dropped due to resource
exhaustion. Move the resume-tx transmission to recvmsg to only confirm
messages as they are consumed by the application.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v2:
- None

 net/qrtr/qrtr.c | 60 +++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 88f98f27ad88..6c56a8ce83ef 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -362,22 +362,11 @@ static void qrtr_port_put(struct qrtr_sock *ipc);
 static void qrtr_node_rx_work(struct work_struct *work)
 {
 	struct qrtr_node *node = container_of(work, struct qrtr_node, work);
-	struct qrtr_ctrl_pkt *pkt;
-	struct sockaddr_qrtr dst;
-	struct sockaddr_qrtr src;
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&node->rx_queue)) != NULL) {
 		struct qrtr_sock *ipc;
-		struct qrtr_cb *cb;
-		int confirm;
-
-		cb = (struct qrtr_cb *)skb->cb;
-		src.sq_node = cb->src_node;
-		src.sq_port = cb->src_port;
-		dst.sq_node = cb->dst_node;
-		dst.sq_port = cb->dst_port;
-		confirm = !!cb->confirm_rx;
+		struct qrtr_cb *cb = (struct qrtr_cb *)skb->cb;
 
 		qrtr_node_assign(node, cb->src_node);
 
@@ -390,20 +379,6 @@ static void qrtr_node_rx_work(struct work_struct *work)
 
 			qrtr_port_put(ipc);
 		}
-
-		if (confirm) {
-			skb = qrtr_alloc_ctrl_packet(&pkt);
-			if (!skb)
-				break;
-
-			pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
-			pkt->client.node = cpu_to_le32(dst.sq_node);
-			pkt->client.port = cpu_to_le32(dst.sq_port);
-
-			if (qrtr_node_enqueue(node, skb, QRTR_TYPE_RESUME_TX,
-					      &dst, &src))
-				break;
-		}
 	}
 }
 
@@ -816,6 +791,34 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return rc;
 }
 
+static int qrtr_send_resume_tx(struct qrtr_cb *cb)
+{
+	struct sockaddr_qrtr remote = { AF_QIPCRTR, cb->src_node, cb->src_port };
+	struct sockaddr_qrtr local = { AF_QIPCRTR, cb->dst_node, cb->dst_port };
+	struct qrtr_ctrl_pkt *pkt;
+	struct qrtr_node *node;
+	struct sk_buff *skb;
+	int ret;
+
+	node = qrtr_node_lookup(remote.sq_node);
+	if (!node)
+		return -EINVAL;
+
+	skb = qrtr_alloc_ctrl_packet(&pkt);
+	if (!skb)
+		return -ENOMEM;
+
+	pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
+	pkt->client.node = cpu_to_le32(cb->dst_node);
+	pkt->client.port = cpu_to_le32(cb->dst_port);
+
+	ret = qrtr_node_enqueue(node, skb, QRTR_TYPE_RESUME_TX, &local, &remote);
+
+	qrtr_node_release(node);
+
+	return ret;
+}
+
 static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 			size_t size, int flags)
 {
@@ -838,6 +841,7 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 		release_sock(sk);
 		return rc;
 	}
+	cb = (struct qrtr_cb *)skb->cb;
 
 	copied = skb->len;
 	if (copied > size) {
@@ -851,7 +855,6 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 	rc = copied;
 
 	if (addr) {
-		cb = (struct qrtr_cb *)skb->cb;
 		addr->sq_family = AF_QIPCRTR;
 		addr->sq_node = cb->src_node;
 		addr->sq_port = cb->src_port;
@@ -859,6 +862,9 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 out:
+	if (cb->confirm_rx)
+		qrtr_send_resume_tx(cb);
+
 	skb_free_datagram(sk, skb);
 	release_sock(sk);
 
-- 
2.24.0

