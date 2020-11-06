Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DD82A9AC0
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgKFR1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbgKFR1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 12:27:15 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F11C0613D2
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 09:27:13 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id p19so1388015wmg.0
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 09:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ROEzAe/sLPA5fA0hNij4++X8IvwRuse1DwhhV1dL1IA=;
        b=Aj9sCfruDoiES8GbsFf3IAZxh1VNH05bnur/n1+XPUrNn7HQK4qP8Sq8oQq5hDua1G
         9HyNdX6AuIZEZ4EzQP0uxFqiq59l3y5T/8KpPB3fZhEmXYwHfKWs7pamBs2o59tlAsHY
         sCApK67aOF98E7qqDgR8ucKnO1SwTR0mzDaT8KZ3L12sNYCEHItK0L1ZCi/7WN2f5Xqw
         BFYi/gGp+BV61KKIjwwCrMM6XS058VT3zvweyjCZbU5U+vqnBOA67OOddsNMkAykQfnj
         DCrMQy0hCKOTY5hh7174HdzpkjP7FWmKZMnULjtyn9XJsPbhOVG0RJ1yxanR6XmfD3uO
         sVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ROEzAe/sLPA5fA0hNij4++X8IvwRuse1DwhhV1dL1IA=;
        b=djq1d2VCe5H4FGLW28tfLNEm7P4f1bxLH7p+0DV3gTwFPjXM2kD7k9uz1put3eddet
         AP1i5hCeFzAnKUJL2zVn6IlWqHYK2llEyehUVzKxoar+ONCAk8uJ162/289aDsH9/eDI
         OrZ1FecJr7aU6Awfk1bPABu7wiy1FeH2SxeJwaPN55W6yOhxfrAI0how21dp6Xk9fmSp
         BOtgFmE+feO8T2UxMK/O5mp5r1D5i/pGCTRa0c5IB0ZzyaZCRCzR50XKwA8J/LVZy8Gl
         iDI7/n9T8VpBGcO8tytWN+ViTsI+H3+m22ei6QIJRDUwefbCHUiiJw9bZi0XUVa9fmgb
         nmJQ==
X-Gm-Message-State: AOAM531Foo9ys42eYGycDnIi3XfoAOrRrkTik2zoBcYCijc6LNHuWiOa
        wec+b5kZXOSWCTkO4PF4vN/X0w==
X-Google-Smtp-Source: ABdhPJyDC+UZ5Nlacfev+Q3d/oZMMhstGinpyoARABXXvPNQwh4KBrDxmIQw7eC7MEf4wjpxDaM65w==
X-Received: by 2002:a1c:ba0b:: with SMTP id k11mr642838wmf.37.1604683632161;
        Fri, 06 Nov 2020 09:27:12 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id z191sm3183266wme.30.2020.11.06.09.27.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 09:27:11 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        cjhuang@codeaurora.org, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 5/5] net: qrtr: Release distant nodes along the bridge node
Date:   Fri,  6 Nov 2020 18:33:30 +0100
Message-Id: <1604684010-24090-6-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Distant QRTR nodes can be accessed via an other node that acts as
a bridge. When the a QRTR endpoint associated to a bridge node is
released, all the linked distant nodes should also be released.

This patch fixes endpoint release by:
- Submitting QRTR BYE message locally on behalf of all the nodes
accessible through the endpoint.
- Removing all the routable node IDs from radix tree pointing to
the released node endpoint.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 net/qrtr/qrtr.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index a05d01e..e361de5 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -171,8 +171,13 @@ static void __qrtr_node_release(struct kref *kref)
 	void __rcu **slot;
 
 	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	if (node->nid != QRTR_EP_NID_AUTO)
-		radix_tree_delete(&qrtr_nodes, node->nid);
+	/* If the node is a bridge for other nodes, there are possibly
+	 * multiple entries pointing to our released node, delete them all.
+	 */
+	radix_tree_for_each_slot(slot, &qrtr_nodes, &iter, 0) {
+		if (*slot == node)
+			radix_tree_iter_delete(&qrtr_nodes, &iter, slot);
+	}
 	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
 
 	list_del(&node->item);
@@ -601,6 +606,7 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	struct qrtr_ctrl_pkt *pkt;
 	struct qrtr_tx_flow *flow;
 	struct sk_buff *skb;
+	unsigned long flags;
 	void __rcu **slot;
 
 	mutex_lock(&node->ep_lock);
@@ -608,11 +614,18 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	mutex_unlock(&node->ep_lock);
 
 	/* Notify the local controller about the event */
-	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
-	if (skb) {
-		pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
-		qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	radix_tree_for_each_slot(slot, &qrtr_nodes, &iter, 0) {
+		if (*slot != node)
+			continue;
+		src.sq_node = iter.index;
+		skb = qrtr_alloc_ctrl_packet(&pkt, GFP_ATOMIC);
+		if (skb) {
+			pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
+			qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
+		}
 	}
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
 
 	/* Wake up any transmitters waiting for resume-tx from the node */
 	mutex_lock(&node->qrtr_tx_lock);
-- 
2.7.4

