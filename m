Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9114F2EB8F5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 05:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbhAFEaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 23:30:39 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:24042 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbhAFEaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 23:30:39 -0500
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 1064TfXd022094;
        Tue, 5 Jan 2021 20:29:47 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net 1/7] chtls: Fix hardware tid leak
Date:   Wed,  6 Jan 2021 09:59:06 +0530
Message-Id: <20210106042912.23512-2-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
In-Reply-To: <20210106042912.23512-1-ayush.sawal@chelsio.com>
References: <20210106042912.23512-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

send_abort_rpl() is not calculating cpl_abort_req_rss offset and
ends up sending wrong TID with abort_rpl WR causng tid leaks.
Replaced send_abort_rpl() with chtls_send_abort_rpl() as it is
redundant.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 .../chelsio/inline_crypto/chtls/chtls_cm.c    | 39 ++-----------------
 1 file changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index a0e0d8a83681..561b5f2273af 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1997,39 +1997,6 @@ static void t4_defer_reply(struct sk_buff *skb, struct chtls_dev *cdev,
 	spin_unlock_bh(&cdev->deferq.lock);
 }
 
-static void send_abort_rpl(struct sock *sk, struct sk_buff *skb,
-			   struct chtls_dev *cdev, int status, int queue)
-{
-	struct cpl_abort_req_rss *req = cplhdr(skb);
-	struct sk_buff *reply_skb;
-	struct chtls_sock *csk;
-
-	csk = rcu_dereference_sk_user_data(sk);
-
-	reply_skb = alloc_skb(sizeof(struct cpl_abort_rpl),
-			      GFP_KERNEL);
-
-	if (!reply_skb) {
-		req->status = (queue << 1);
-		t4_defer_reply(skb, cdev, send_defer_abort_rpl);
-		return;
-	}
-
-	set_abort_rpl_wr(reply_skb, GET_TID(req), status);
-	kfree_skb(skb);
-
-	set_wr_txq(reply_skb, CPL_PRIORITY_DATA, queue);
-	if (csk_conn_inline(csk)) {
-		struct l2t_entry *e = csk->l2t_entry;
-
-		if (e && sk->sk_state != TCP_SYN_RECV) {
-			cxgb4_l2t_send(csk->egress_dev, reply_skb, e);
-			return;
-		}
-	}
-	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
-}
-
 static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 				 struct chtls_dev *cdev,
 				 int status, int queue)
@@ -2079,8 +2046,8 @@ static void bl_abort_syn_rcv(struct sock *lsk, struct sk_buff *skb)
 
 	skb->sk	= NULL;
 	do_abort_syn_rcv(child, lsk);
-	send_abort_rpl(child, skb, BLOG_SKB_CB(skb)->cdev,
-		       CPL_ABORT_NO_RST, queue);
+	chtls_send_abort_rpl(child, skb, BLOG_SKB_CB(skb)->cdev,
+			     CPL_ABORT_NO_RST, queue);
 }
 
 static int abort_syn_rcv(struct sock *sk, struct sk_buff *skb)
@@ -2111,7 +2078,7 @@ static int abort_syn_rcv(struct sock *sk, struct sk_buff *skb)
 		int queue = csk->txq_idx;
 
 		do_abort_syn_rcv(sk, psk);
-		send_abort_rpl(sk, skb, cdev, CPL_ABORT_NO_RST, queue);
+		chtls_send_abort_rpl(sk, skb, cdev, CPL_ABORT_NO_RST, queue);
 	} else {
 		skb->sk = sk;
 		BLOG_SKB_CB(skb)->backlog_rcv = bl_abort_syn_rcv;
-- 
2.28.0.rc1.6.gae46588

