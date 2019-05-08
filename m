Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244E3170C7
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 08:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfEHGHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 02:07:13 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46319 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728631AbfEHGGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 02:06:51 -0400
Received: by mail-pl1-f196.google.com with SMTP id bi2so9379465plb.13
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 23:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5IgbbTEWxx9612vWZb+A6P+LPisYaMkTp+oYoBjVljQ=;
        b=L/bxrM+JHPq69ydLVroJHc6ezcUZtRdVhf8h5c+uTnt5DKqt1RUtVh2oS3D7/r5B1H
         KFjM/EMJ6gZqR6GRjMPALRLwQc5h9sCopFUYQj2XRNFTvy/tHj17VkppsfdskI8iBq/C
         i2AQmfR0Rzrmzsy89Hwwf7wbo2TpP9hHNyA9qzzxhnFAYeV1ouBVauOx40r/6+IPTt2A
         LJMMBerTq6n4+jaAmbXexhvnKYmVU660ABRSAUngUJE5/rC8cpU7TZP0zLDNFPXHoDEX
         +nT4FJF9HEls18UXmV60PR/kQDqAUNkmKPkOVG6RFCO1IovVSjRfTyIHXQVZbCROmuPR
         63WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5IgbbTEWxx9612vWZb+A6P+LPisYaMkTp+oYoBjVljQ=;
        b=Iw5wH916xPik4NIviMOnNrNFQW0pR0rY6kA7X1bJDZXQs9rMrpoFq4Il7re6ByOsTJ
         uDiEYkuWOQ6k2hdM0Hkr7Yejz9sMXMqToMWQirGQhT71552z7jbbLDcU42WCE2q9HqjC
         mUQp+Xx8F3z7iYqFRxPCcP2NQDHI+VhIhrFpVn0d6mv4hqiP4ZhUMWmSEHYD7VGyccXe
         2cdKW7i8ma5xZKpeyV2UakGe6kqUL3SC2leQZwL30aAsTOt7RQhow8RE+2K8EtdBG6gW
         suUFHjYjdUvZ4CkE3PnxpjTz+Ny+g/3Vvuk2LNP1PC7tThEqVHY1JSe+ZVgfLUUpHJgC
         Tg4A==
X-Gm-Message-State: APjAAAW7qYb0Ph84Rh7Z2j4W/25y1w0l8igVtZOToRKkgNcE3saX/C88
        VyykaSwp/8Wglu9gxwW/5a6yZw==
X-Google-Smtp-Source: APXvYqzirKWJWRFKigN/+Jt0kptk8S4fO8R/Xem8kaKS4wCakNCSQ7AknQt7apF4ilmyLh3Md8GR3w==
X-Received: by 2002:a17:902:8ec6:: with SMTP id x6mr43914309plo.123.1557295610614;
        Tue, 07 May 2019 23:06:50 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id t5sm2756130pgn.80.2019.05.07.23.06.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 23:06:49 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 3/5] net: qrtr: Migrate node lookup tree to spinlock
Date:   Tue,  7 May 2019 23:06:41 -0700
Message-Id: <20190508060643.30936-4-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190508060643.30936-1-bjorn.andersson@linaro.org>
References: <20190508060643.30936-1-bjorn.andersson@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move operations on the qrtr_nodes radix tree under a separate spinlock
and make the qrtr_nodes tree GFP_ATOMIC, to allow operation from atomic
context in a subsequent patch.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 net/qrtr/qrtr.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 62abd622618d..9075751028a2 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -16,6 +16,7 @@
 #include <linux/qrtr.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/numa.h>
+#include <linux/spinlock.h>
 #include <linux/wait.h>
 
 #include <net/sock.h>
@@ -106,10 +107,11 @@ static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
 static unsigned int qrtr_local_nid = NUMA_NO_NODE;
 
 /* for node ids */
-static RADIX_TREE(qrtr_nodes, GFP_KERNEL);
+static RADIX_TREE(qrtr_nodes, GFP_ATOMIC);
+static DEFINE_SPINLOCK(qrtr_nodes_lock);
 /* broadcast list */
 static LIST_HEAD(qrtr_all_nodes);
-/* lock for qrtr_nodes, qrtr_all_nodes and node reference */
+/* lock for qrtr_all_nodes and node reference */
 static DEFINE_MUTEX(qrtr_node_lock);
 
 /* local port allocation management */
@@ -171,10 +173,13 @@ static void __qrtr_node_release(struct kref *kref)
 {
 	struct radix_tree_iter iter;
 	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
+	unsigned long flags;
 	void __rcu **slot;
 
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
 	if (node->nid != QRTR_EP_NID_AUTO)
 		radix_tree_delete(&qrtr_nodes, node->nid);
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
 
 	list_del(&node->item);
 	mutex_unlock(&qrtr_node_lock);
@@ -340,11 +345,12 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
 {
 	struct qrtr_node *node;
+	unsigned long flags;
 
-	mutex_lock(&qrtr_node_lock);
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
 	node = radix_tree_lookup(&qrtr_nodes, nid);
 	node = qrtr_node_acquire(node);
-	mutex_unlock(&qrtr_node_lock);
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
 
 	return node;
 }
@@ -356,13 +362,15 @@ static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
  */
 static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
 {
+	unsigned long flags;
+
 	if (node->nid != QRTR_EP_NID_AUTO || nid == QRTR_EP_NID_AUTO)
 		return;
 
-	mutex_lock(&qrtr_node_lock);
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
 	radix_tree_insert(&qrtr_nodes, nid, node);
 	node->nid = nid;
-	mutex_unlock(&qrtr_node_lock);
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
 }
 
 /**
-- 
2.18.0

