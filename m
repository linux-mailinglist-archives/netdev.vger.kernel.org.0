Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4B230628
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 03:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfEaBSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 21:18:02 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46344 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfEaBSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 21:18:01 -0400
Received: by mail-pg1-f195.google.com with SMTP id v9so3003238pgr.13
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 18:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nJd7utTcuGxgb7dSskEJaX31zJV6idHmDZghQAynF00=;
        b=rpNJZzSFFR4m29xwb8hL+xkPQjt4v6fVSgGkpZ9XLILWEKeq7LM2xJBRqR/eTb5NPT
         Of6ouPRIvtLYZ91J6JnyiusETp3+jCcH+d7LVDQimJoL1vjJbjAdpGxE6qrNK37B2993
         wEPuJ+rm28+EsoVLvKnH4LIRoX3tIz2sUiZDIbyY4MJcIOBhu4RzlMxg8Duw7YLylUi8
         hLT51GqFTzsrJa9Xy8TCIsIfJ5hxXn2U9DrE/Ua2PtbyY8aJ1C8FcxdTLsqcDByfbOqS
         G0F3luFh8bBLZAJznqO/9NhXtrLh81JxOq4Lvy6ZYSrKNyLv8dmqMZFd21qVaYSfGSfr
         yDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nJd7utTcuGxgb7dSskEJaX31zJV6idHmDZghQAynF00=;
        b=Z+cPuF44Z+ugN5Zjt6Wf5ZtpUrkREUZks5HqBmxyuKkghHflqhMimK/HSqNE4M2r70
         JV+cc86rjVGbNPJxns+K44m2AW1h4qh/4mTt29V00ouey31d9zlAQhp5kzMNjS7uYjzQ
         MiEpFKzJLyS9+RM3SmkVSo5mpzt1PAmLwatTvkT51zfJrgg3+dOGkpshYy7lLcT35oO3
         vVGVGxLrpuBEChYH2WJG+7WBeP3/pYd6j6nAesfBpR1oYUYsjhcswM8liYWi66cVCTma
         ZEfqlPlePGq2p1UzyIDHalKgrw+qe8SbEcsn0Yui7HIbI+7PekO6+HNF4ks5ewnOLYCY
         jBzg==
X-Gm-Message-State: APjAAAX0jyO+xIneyQaa96XAS2F5O5OL7Kc4j4wY5H9rb7/VfdDbe8UH
        WD4gAnn5OCU4M9+vVZ+31PPUnA==
X-Google-Smtp-Source: APXvYqxVBMtdrQdkk0ctbvAUwN9rPykb3uniLF5dDitJQtq0DLC0S8NsZ7qcg5jpaLqjqOzBgsHm0A==
X-Received: by 2002:a65:4c84:: with SMTP id m4mr6405725pgt.382.1559265480353;
        Thu, 30 May 2019 18:18:00 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id j20sm1819042pff.183.2019.05.30.18.17.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 18:17:59 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 3/5] net: qrtr: Migrate node lookup tree to spinlock
Date:   Thu, 30 May 2019 18:17:51 -0700
Message-Id: <20190531011753.11840-4-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190531011753.11840-1-bjorn.andersson@linaro.org>
References: <20190531011753.11840-1-bjorn.andersson@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move operations on the qrtr_nodes radix tree under a separate spinlock
and make the qrtr_nodes tree GFP_ATOMIC, to allow operation from atomic
context in a subsequent patch.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v1:
- None

 net/qrtr/qrtr.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 38cc052b7a31..fdee32b979fe 100644
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
@@ -173,10 +175,13 @@ static void __qrtr_node_release(struct kref *kref)
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
@@ -383,11 +388,12 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
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
@@ -399,13 +405,15 @@ static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
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

