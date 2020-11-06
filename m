Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A2F2A9ABE
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgKFR1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgKFR1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 12:27:11 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0527C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 09:27:10 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id w1so2130467wrm.4
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 09:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D/092xNhzoeqWVzgOt31RyKE4UUHqVbbhKniatrDYRo=;
        b=zl24+w2P6aoxshLsh+1QU1x0CzQVDdjoH9oEaZ/ehcxJLK3hgvzHf61Swag23oCQ4k
         D9zvWGX2dMvIpQk1UiK28WQth1hiCyysURF0v7ooOu5IUCy03BGPmvpDrfECte1lW0JQ
         iplLJzx83969nmuJjVwz9aOlAeIkDVuGGR1wNP+6sBuBRzqJTYNoSLAU/FA9VcMwY0F3
         k8lfy+5g3yXe9Wm7pRl0c9nQm81u4u99pIPAlMbCGMBxpRWjqJVQ5IsK0kc3xOPU0vLY
         B2oxihUKnLGlKUad+E/ZiWX6BX14MDpxna7M2J0T0ayzCFPxURODf2BKMS/2vdIY6eSD
         Vy+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D/092xNhzoeqWVzgOt31RyKE4UUHqVbbhKniatrDYRo=;
        b=EHh2fyQ+KqFEHN9AsTZHS1iJR9Plf3FTWo1yq2mAq7L5qd+PpJ+gkPicpFjBDp6ndL
         dpKbrkA/Q4ctI+lTn2uzxqBRDqIDfhbWjdGWSYt2ZIvru6rI33fjsGcYSewEv4seHFwC
         UDJRPluqhiYkDU47G4AU2VvOuIWUYuO+ZXw+m/ZyYTb3QDOlIup9jqsto8313Uvl+Oh2
         6I9/JE3XfbXoaIXNgUSqUO6aebnMYRsVn17cDnah54K9D5kzqqENEknLdjabMnQpwbdj
         nUHFY3Di96OVzrfE1M7OGGJ43PMO8e4rYB97fznp9rTcdZjcJ3ASwAOByUJvFadUr8Ld
         3UYQ==
X-Gm-Message-State: AOAM5305rDVwGBkupRaZClHWimEakJo4e6X2raA413bk3ZxpPFbdVi57
        tkg1pIa2n8otB21O+zCF4pSDSJTSI88AjI/QcNM=
X-Google-Smtp-Source: ABdhPJybSZfNQq/peuFFiZn7JwhQWfiYkoV9Kvsc+iVZgTt19vTbPq8ueDldvi0ON9fg5VrwiHtePQ==
X-Received: by 2002:adf:e388:: with SMTP id e8mr3829229wrm.65.1604683629693;
        Fri, 06 Nov 2020 09:27:09 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id z191sm3183266wme.30.2020.11.06.09.27.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 09:27:09 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        cjhuang@codeaurora.org, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 3/5] net: qrtr: Allow non-immediate node routing
Date:   Fri,  6 Nov 2020 18:33:28 +0100
Message-Id: <1604684010-24090-4-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
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
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 net/qrtr/qrtr.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index e09154b..1d12408 100644
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
 
@@ -493,6 +494,13 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	qrtr_node_assign(node, cb->src_node);
 
+	if (cb->type == QRTR_TYPE_NEW_SERVER) {
+		/* Remote node endpoint can bridge other distant nodes */
+		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
+
+		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
+	}
+
 	if (cb->type == QRTR_TYPE_RESUME_TX) {
 		qrtr_tx_resume(node, skb);
 	} else {
-- 
2.7.4

