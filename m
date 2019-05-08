Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C5B170C9
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 08:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfEHGHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 02:07:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45550 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfEHGGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 02:06:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id e24so9919244pfi.12
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 23:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e6SrybXQBzQ/pQVF99s2mcphn7kgLGBW4wNCs7GR8pQ=;
        b=mnVP4QJsmIS3xsrRwE0Oyy7T8OIVzjRrDafg0KhMdBVUdYpXBLZFy/TupNd2N9NMNz
         upHa/EiNFZmErX+Yaguhkr2Zsv6wf/vhmy8UdCqaFWsxWwOBYNi8X2+jl73r3epkoSwW
         NmSV4DMbfMJdcHEQTZ6uY3r1yvbHtke4jQCuIUOPuNbuQ58ER0LvNSrt5V5CCFKD1sFO
         4+qa0O10hUQE40dCmaUltBFdNbSY7UFDkQrBBsYKbE79TfMNGG4IHk58ctqN2NlYU7mv
         DG4XmEY0Phvyr33d1YGONqxxMhYCWhUUyXtK15WMdv5lVujEiVZoiLW/h1oIskrGs+K5
         sKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e6SrybXQBzQ/pQVF99s2mcphn7kgLGBW4wNCs7GR8pQ=;
        b=BTkrF3AnlePK5oHgnU/iZzNPufNz2hdpCnhf+qr4qZEAKUs1UvnO2baOlTOH/w//eB
         tg9AnEMQQZ5g+6HNkCSrRZ+4oQQggLZ8ZSuM8bywe6E1QEIHn3qurHNzKvpyapBP20VJ
         GmthDuZRyYFKupm0KPYG+e3PqXiXi9uOtNPZ0XA6kGYuxGFpvuAELYiHxLVr8bivKC9X
         /6ZaCpD68jakqaKMxn+8qr/zGKjefnyNPQJDSC5mf4PFtYTeZ25YI7YoZlByjDOZu2Ma
         PU62fvFf8SNbVR6vUDp5nK3laXCp0oSXNVIwssXJGHFQ0BhesZuk4+koLDaEYqKLEzEN
         9XGg==
X-Gm-Message-State: APjAAAWkHW6iFmNbSveLyMfZRDMWbP4qTVEx47DsH+EsNEuxiLEFjjvL
        C/IcVfJ52+A/T1QEYaDO20ZpcuVpZxU=
X-Google-Smtp-Source: APXvYqwcd8zFhelXCKCeSqerrTRgP5It6oqkZKul7ruPSYq62FjqrS/O+n2ebYObU29G1takZo5ipA==
X-Received: by 2002:a62:e101:: with SMTP id q1mr46510709pfh.160.1557295608349;
        Tue, 07 May 2019 23:06:48 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id t5sm2756130pgn.80.2019.05.07.23.06.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 23:06:47 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/5] net: qrtr: Move resume-tx transmission to recvmsg
Date:   Tue,  7 May 2019 23:06:39 -0700
Message-Id: <20190508060643.30936-2-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190508060643.30936-1-bjorn.andersson@linaro.org>
References: <20190508060643.30936-1-bjorn.andersson@linaro.org>
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
 net/qrtr/qrtr.c | 60 +++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index dd0e97f4f6c0..07a35362fba2 100644
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
 
@@ -822,6 +797,34 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return rc;
 }
 
+static int qrtr_resume_tx(struct qrtr_cb *cb)
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
@@ -844,6 +847,7 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 		release_sock(sk);
 		return rc;
 	}
+	cb = (struct qrtr_cb *)skb->cb;
 
 	copied = skb->len;
 	if (copied > size) {
@@ -857,7 +861,6 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 	rc = copied;
 
 	if (addr) {
-		cb = (struct qrtr_cb *)skb->cb;
 		addr->sq_family = AF_QIPCRTR;
 		addr->sq_node = cb->src_node;
 		addr->sq_port = cb->src_port;
@@ -865,6 +868,9 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 out:
+	if (cb->confirm_rx)
+		qrtr_resume_tx(cb);
+
 	skb_free_datagram(sk, skb);
 	release_sock(sk);
 
-- 
2.18.0

