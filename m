Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042EB13A942
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 13:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgANM3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 07:29:32 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:16812 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgANM3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 07:29:31 -0500
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 00ECTEfg031366;
        Tue, 14 Jan 2020 04:29:24 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH 1/3] Crypto/chtls: Corrected function call context
Date:   Tue, 14 Jan 2020 17:58:47 +0530
Message-Id: <20200114122849.133085-2-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114122849.133085-1-vinay.yadav@chelsio.com>
References: <20200114122849.133085-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

corrected function call context and moved t4_defer_reply
to apropriate location.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 30 ++++++++++++-------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index dffa2aa855fd..d4674589e1aa 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1829,6 +1829,20 @@ static void send_defer_abort_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+/*
+ * Add an skb to the deferred skb queue for processing from process context.
+ */
+static void t4_defer_reply(struct sk_buff *skb, struct chtls_dev *cdev,
+			   defer_handler_t handler)
+{
+	DEFERRED_SKB_CB(skb)->handler = handler;
+	spin_lock_bh(&cdev->deferq.lock);
+	__skb_queue_tail(&cdev->deferq, skb);
+	if (skb_queue_len(&cdev->deferq) == 1)
+		schedule_work(&cdev->deferq_task);
+	spin_unlock_bh(&cdev->deferq.lock);
+}
+
 static void send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 			   struct chtls_dev *cdev, int status, int queue)
 {
@@ -1843,7 +1857,7 @@ static void send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 
 	if (!reply_skb) {
 		req->status = (queue << 1);
-		send_defer_abort_rpl(cdev, skb);
+		t4_defer_reply(skb, cdev, send_defer_abort_rpl);
 		return;
 	}
 
@@ -1862,20 +1876,6 @@ static void send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
 }
 
-/*
- * Add an skb to the deferred skb queue for processing from process context.
- */
-static void t4_defer_reply(struct sk_buff *skb, struct chtls_dev *cdev,
-			   defer_handler_t handler)
-{
-	DEFERRED_SKB_CB(skb)->handler = handler;
-	spin_lock_bh(&cdev->deferq.lock);
-	__skb_queue_tail(&cdev->deferq, skb);
-	if (skb_queue_len(&cdev->deferq) == 1)
-		schedule_work(&cdev->deferq_task);
-	spin_unlock_bh(&cdev->deferq.lock);
-}
-
 static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 				 struct chtls_dev *cdev,
 				 int status, int queue)
-- 
2.24.1

