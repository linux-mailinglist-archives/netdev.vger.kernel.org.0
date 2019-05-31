Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA733062F
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 03:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfEaBS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 21:18:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45598 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfEaBR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 21:17:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id w34so3001564pga.12
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 18:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lQChNdDCdNXbbkNhmVNEtdud6LkQIlqNuY3CF0Rb0Z0=;
        b=W3OeWcHl7rImj19BvH3xjv9qop1HI7j9YSy/j6zBzACzYwC6JaihSDcOsdsg5sFn/1
         kdsGeVuhdWNMYluF+P8YSYUYX9/i1CEcgDGVqYYPcSSDBRfJiE/2h62TSjbMFtd82U0Z
         SIKPMzzqe8bndsaw2VK+ZYXmtHy5IvQesbsfsmOxYkmUkJOlDJewCP7RHmY9pmsY2FGt
         TVJ/lFwAVsrabskBcHFZ+uF1fPEmUP9STg//wLbMy/KirP3tySf1frZh116kwGCJ4IdL
         Hu3REat1yy8eVz6GroR+tHAaJPZeMvRby+lsWwnub/eogjUb15zvq0orpri6pW434s3k
         r3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lQChNdDCdNXbbkNhmVNEtdud6LkQIlqNuY3CF0Rb0Z0=;
        b=g7CEgVI9G4gHCk3M7XXgR4ay12gvNDl5TgvQ1IgpvoycbMrVVe6YXkh+GISRrNboHk
         fVGuSj6BSz5QufLxuNa1h6dSlbJSBeDS0YTXCaYQ+hI6nBDbdquQqD+LEnfxixUL5dzo
         m29BpIY0Mdevgy1hmiuF+gA8jiKxth1oO1azmhkOm7GM1eBCe8wjJIsZhTAmZLkAf9HR
         tTzFEyQtLTMFhm2VEdqIMTreJEwdtVP/LhEytVknQXUm5JnRAoy9WxzuYMf+loLu8W03
         OqXW4OO30vmSgW645/+SEdTnTFPqHkjcrPV2RoQpAYKyBMV8in7qOOtfY2/faDNapdWR
         iuqQ==
X-Gm-Message-State: APjAAAXVd25FB1fYJAgkXxGQSeKDQCj0MREqVUWsomFA/fArD2VFUsga
        PXuD+rGOITwrRFmgfSJmxhoH4Q==
X-Google-Smtp-Source: APXvYqzunQra5LgQCA8g1OHgFa7uRo2HZkTrdQP/BcC99jMhZ+m3X0yBJsx5r1av3Q9zYsJzbOxypw==
X-Received: by 2002:a65:64d5:: with SMTP id t21mr6466607pgv.310.1559265478172;
        Thu, 30 May 2019 18:17:58 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id j20sm1819042pff.183.2019.05.30.18.17.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 18:17:57 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 1/5] net: qrtr: Move resume-tx transmission to recvmsg
Date:   Thu, 30 May 2019 18:17:49 -0700
Message-Id: <20190531011753.11840-2-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190531011753.11840-1-bjorn.andersson@linaro.org>
References: <20190531011753.11840-1-bjorn.andersson@linaro.org>
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

Changes since v1:
- Renamed qrtr_send_resume_tx()

 net/qrtr/qrtr.c | 60 +++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 05fa058bee59..89fb846cc244 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -369,22 +369,11 @@ static void qrtr_port_put(struct qrtr_sock *ipc);
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
 
@@ -397,20 +386,6 @@ static void qrtr_node_rx_work(struct work_struct *work)
 
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
 
@@ -823,6 +798,34 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
@@ -845,6 +848,7 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 		release_sock(sk);
 		return rc;
 	}
+	cb = (struct qrtr_cb *)skb->cb;
 
 	copied = skb->len;
 	if (copied > size) {
@@ -858,7 +862,6 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 	rc = copied;
 
 	if (addr) {
-		cb = (struct qrtr_cb *)skb->cb;
 		addr->sq_family = AF_QIPCRTR;
 		addr->sq_node = cb->src_node;
 		addr->sq_port = cb->src_port;
@@ -866,6 +869,9 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 out:
+	if (cb->confirm_rx)
+		qrtr_send_resume_tx(cb);
+
 	skb_free_datagram(sk, skb);
 	release_sock(sk);
 
-- 
2.18.0

