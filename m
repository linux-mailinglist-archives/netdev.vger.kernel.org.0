Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE30913A25F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgANH5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:57:55 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38442 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgANH5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:57:53 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so6198817pfc.5
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Px4G0+J+cRapXW5QpczEFWv3zS6gD7SLN1HuC+fZi3c=;
        b=pdUjFjV0LD/LgGKAxgvkoSltMrFIKqyzCbpjTWbRu6o0CtVu7FT0LLs9WL0NIK/TJA
         b3L/feFnoWjzMym/dGmzj/S7r8Py7Jg+I+pFDp4YjeHPzPESZ5kPcq9czEh9Y5pmrHNO
         qodrA41O2sWKy5vefORIyYBMesZekvVHGF7kw76NLwaRnkEjUKUxJgTMN+2jVug9qgz3
         NQhWV1EfisvgISh6YuynLM/VZ7WaJGnWax06CCf3UIFFEI54KGfhvkw7TKCz1U7H8gxP
         A/pM0GFCwOzzNneNSEvW2e3yogFBGbmlZljaaNSYys2aXS1PCc+Slpy4YD0UIMRUciEc
         W9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Px4G0+J+cRapXW5QpczEFWv3zS6gD7SLN1HuC+fZi3c=;
        b=Z1CUGajNHzKe5Liwr5U/SXTRqMgnT/wxjq0C2MkwykhK291Hlhsgmn6jR32eGLZ5cE
         naoCr9O1K6sNE3jEY5Vv760YtvLnszqPKq5ld7tf32tBO6FiH32alnZzxb91QNmUAIkA
         WoMuiDLUrE6EiVyhSQRn51Fhq/dnKK0AmHgXxZKTrzIbTM4n7M9HOy5JPACdTaevPyQY
         W3PQqZDN2HlZVpF1fDEg2tfJwi6vZ9ApE+yAdPLTCDS6obF4QlStKVcBi/f+O/kzPiNZ
         8H+Q9efitCO0ufr0WK4tO0t9anxi5M1SXoUBuIdi2mGO/ywTHVbNHiwqO4r5YK4a17kq
         UF6g==
X-Gm-Message-State: APjAAAUx30p1n023aNzbAA3DTFqLW8cJ9DIN6Mtf70OJlGV609gZWNhc
        FoRFJ15AXNrM24fgXguVgoRsbCt4V54=
X-Google-Smtp-Source: APXvYqzFnrDpXcxKDZkH0vJ11Mu/bGatj5joJUYZafTV4dTQTzqRsXeanCTjo2s7F4Dyxop5Eyai7w==
X-Received: by 2002:a63:da4d:: with SMTP id l13mr26725803pgj.106.1578988673197;
        Mon, 13 Jan 2020 23:57:53 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id q63sm17349352pfb.149.2020.01.13.23.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 23:57:52 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 1/5] net: qrtr: Move resume-tx transmission to recvmsg
Date:   Mon, 13 Jan 2020 23:56:59 -0800
Message-Id: <20200114075703.2145718-2-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200114075703.2145718-1-bjorn.andersson@linaro.org>
References: <20200114075703.2145718-1-bjorn.andersson@linaro.org>
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

Changes since v3:
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

