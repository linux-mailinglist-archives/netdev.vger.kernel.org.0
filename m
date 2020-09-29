Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4BA27CF18
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgI2N1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbgI2N1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:27:21 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9455BC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 06:27:20 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z1so5422749wrt.3
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 06:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XQKW1SgLV6iUzlfipBeMXYyMr41Phx/Woh2hFRAp76k=;
        b=chEqQnrb6EAVZHpMBobYR3ReqM3LWfJVpYGaFAytCytXYp9uWYZlkCwoFTLZK6XICo
         /Kda8bzfYD5JS1E8os4D8m25bPiwDIAscGKCkVhNC4RObdiojUgnvwd4edOHJlgY8+vM
         KcodbkOlskY9r90NM3WepW0nDroROuJVn8osd/gpoCQ5R5hsDn/RVMGsoDT2qqsEUV/F
         HD2JoKxNJO5wPqHqGxfgeDZVJfTyI+RCQWgnOCIMsf1908OgIML3PsidRpiT+pT95t4H
         8ZF5Ly9vNzQHtxO/bkSGiNgXLGwgiS9Q9bPX5fAKaFOv0kal5HJKVC9v1fi3+cKQWqnE
         RiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XQKW1SgLV6iUzlfipBeMXYyMr41Phx/Woh2hFRAp76k=;
        b=M3ZiM1hUThbqxuSNrdCuJGO1iW6m/mY0HJwKHsc9DZ+MY7Vn/0pir0uwfqWmkYb934
         E03cucvnjq/twycZDcNYZKJylAQ5j+Eqza5ER5jClbnRaVGv7jaJFQn1+1AIVXhQ2E+c
         IurMc6HZ3kxk3acjmBOW6hZz8dQqauyl6KnkAuUvRfX+ShOEkPMMbvbC3Pq5EY/1mJxe
         GdNKSy/6Qy59ha5EaWqweDyNd1kiNSsxkfB6TG2mFAtjkQ4D+ncAdSWfbrIrKyKeFpL7
         8oCY+axe4bbLtzuWqG27rw6BUzSyEEJ4w//AWAI6nUzgz9BPVTzi/XOi7A6pxuU+KZup
         xmNw==
X-Gm-Message-State: AOAM531eeiDORUcpxqBYlgPqrQo1dLGWaq03NdUjHr2IMTvfWayfj/SU
        HUHysLijj0HnVoYKQEvKW9TwdQ==
X-Google-Smtp-Source: ABdhPJx49rDGDmyJnU9dKFUPcqShZOlO69OxWWxMt1WDgd6xyHCH/+WcDNIJlm+EXszlCWr6wJcwUA==
X-Received: by 2002:a5d:6551:: with SMTP id z17mr4380913wrv.200.1601386039244;
        Tue, 29 Sep 2020 06:27:19 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:490:8730:d9ed:65b4:1d51:1846])
        by smtp.gmail.com with ESMTPSA id q20sm5409907wmj.5.2020.09.29.06.27.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:27:18 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     bjorn.andersson@linaro.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, clew@codeaurora.org,
        manivannan.sadhasivam@linaro.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH 2/2] net: qrtr: Allow non-immediate node routing
Date:   Tue, 29 Sep 2020 15:33:17 +0200
Message-Id: <1601386397-21067-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601386397-21067-1-git-send-email-loic.poulain@linaro.org>
References: <1601386397-21067-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to reach non-immediate remote node services that are
accessed through an intermediate node, the route to the remote
node needs to be saved.

E.g for a [node1 <=> node2 <=> node3] network
- node2 forwards node3 service to node1
- node1 must save node2 as route for reaching node3

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 net/qrtr/qrtr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index e09154b..bd9bcea 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -400,12 +400,13 @@ static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
 {
 	unsigned long flags;
 
-	if (node->nid != QRTR_EP_NID_AUTO || nid == QRTR_EP_NID_AUTO)
+	if (nid == QRTR_EP_NID_AUTO)
 		return;
 
 	spin_lock_irqsave(&qrtr_nodes_lock, flags);
 	radix_tree_insert(&qrtr_nodes, nid, node);
-	node->nid = nid;
+	if (node->nid == QRTR_EP_NID_AUTO)
+		node->nid = nid;
 	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
 }
 
@@ -493,6 +494,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	qrtr_node_assign(node, cb->src_node);
 
+	if (cb->type == QRTR_TYPE_NEW_SERVER) {
+		/* Remote node endpoint can bridge other distant nodes */
+		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
+		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
+	}
+
 	if (cb->type == QRTR_TYPE_RESUME_TX) {
 		qrtr_tx_resume(node, skb);
 	} else {
-- 
2.7.4

