Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4985596C5F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbfHTWdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36990 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730989AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jtqCiEbanFInF83J8ev7Qbc96Uvdbncl6Tv3mptEEHo=; b=aeuAFeFNkkOdSt5F8FRG/5K7Tr
        SalRc0ljZ3YllMwwUr38T34W6hOvlM0lh8+iXK5XQKNswXMMWpazGd/c9xwOtkXMhuEXZ7mxKpsOR
        vgGjpcrYvhS1JeC4b4iXkYASCax5h17PtOtQrbV5dnwdxfts2B2bwvIjgxYcriqp4TBuPp1w86sdG
        sBWWL4wPH4DZWiy8mE48bDQSqU7r3XKoABlcHS/eo2CLUcEDKg9/UPAzXUxFO4Ey+XJDtJNHmEyx1
        Yt8Wrm4PSt64fRNVtCb/BPpeeytySCWptk2nMqK2PIwI/j9E3TQ3ICsneBbnfr+Pk2Bqv7q20L2oi
        S+tTKetw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005r3-GF; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 16/38] qrtr: Convert qrtr_nodes to XArray
Date:   Tue, 20 Aug 2019 15:32:37 -0700
Message-Id: <20190820223259.22348-17-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Moved the kref protection under the xa_lock too.  It's a little
disconcerting to not be checking the error code from xa_store(),
but the original code doesn't return an errno from qrtr_node_assign()
and that would be a larger change to the driver than I'm conmfortable
making.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/qrtr/qrtr.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 6c8b0f6d28f9..e02fa6be76d2 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -97,10 +97,10 @@ static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
 static unsigned int qrtr_local_nid = NUMA_NO_NODE;
 
 /* for node ids */
-static RADIX_TREE(qrtr_nodes, GFP_KERNEL);
+static DEFINE_XARRAY(qrtr_nodes);
 /* broadcast list */
 static LIST_HEAD(qrtr_all_nodes);
-/* lock for qrtr_nodes, qrtr_all_nodes and node reference */
+/* lock for qrtr_all_nodes */
 static DEFINE_MUTEX(qrtr_node_lock);
 
 /* local port allocation management */
@@ -138,15 +138,18 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 /* Release node resources and free the node.
  *
  * Do not call directly, use qrtr_node_release.  To be used with
- * kref_put_mutex.  As such, the node mutex is expected to be locked on call.
+ * kref_put_lock.  As such, the xa_lock is expected to be held on call.
  */
 static void __qrtr_node_release(struct kref *kref)
+		__releases(qrtr_nodes.xa_lock)
 {
 	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
 
 	if (node->nid != QRTR_EP_NID_AUTO)
-		radix_tree_delete(&qrtr_nodes, node->nid);
+		__xa_erase(&qrtr_nodes, node->nid);
+	xa_unlock(&qrtr_nodes);
 
+	mutex_lock(&qrtr_node_lock);
 	list_del(&node->item);
 	mutex_unlock(&qrtr_node_lock);
 
@@ -167,7 +170,7 @@ static void qrtr_node_release(struct qrtr_node *node)
 {
 	if (!node)
 		return;
-	kref_put_mutex(&node->ref, __qrtr_node_release, &qrtr_node_lock);
+	kref_put_lock(&node->ref, __qrtr_node_release, &qrtr_nodes.xa_lock);
 }
 
 /* Pass an outgoing packet socket buffer to the endpoint driver. */
@@ -215,10 +218,10 @@ static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
 {
 	struct qrtr_node *node;
 
-	mutex_lock(&qrtr_node_lock);
-	node = radix_tree_lookup(&qrtr_nodes, nid);
+	xa_lock(&qrtr_nodes);
+	node = xa_load(&qrtr_nodes, nid);
 	node = qrtr_node_acquire(node);
-	mutex_unlock(&qrtr_node_lock);
+	xa_unlock(&qrtr_nodes);
 
 	return node;
 }
@@ -233,10 +236,8 @@ static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
 	if (node->nid != QRTR_EP_NID_AUTO || nid == QRTR_EP_NID_AUTO)
 		return;
 
-	mutex_lock(&qrtr_node_lock);
-	radix_tree_insert(&qrtr_nodes, nid, node);
 	node->nid = nid;
-	mutex_unlock(&qrtr_node_lock);
+	xa_store(&qrtr_nodes, nid, node, GFP_KERNEL);
 }
 
 /**
-- 
2.23.0.rc1

