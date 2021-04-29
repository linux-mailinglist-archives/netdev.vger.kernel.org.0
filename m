Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C266C36ED4F
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 17:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240676AbhD2PZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 11:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhD2PZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 11:25:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3BDC06138B
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 08:24:33 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 20so30985227pll.7
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 08:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uel3olZUGWUGB7fGgn2CRgNjmcZtFUxP2kJFlFiro0w=;
        b=DdDWwfHFS/D9jSNOpapmxEHhve5KRk4QNp1nyc/nHaEkZUUKCbX9D61Y9gIE4nXQT1
         ynJ1Y4aoDInSFBH0m4i0BL68GHfP2YGrfHXx5HA+z2W2O+phw/VsG8sgtjnlRiGN0Pc5
         pYvXsiJYlnFMVsU8V8NtX91NMSH3qayVx+isz2xtG+/Fp7clmNv93m6dg7GDffyXpnbI
         oHDY3KJCbPWTY5JWkub0o499Ju5yIlLws89BTxZvAXDhZQOBL1uehEtBEUVzUSHTatJy
         WXZTMUvGr+eVtKUC5QAohId4xKHOJm3N1jhwanYS0oiSikLDiJCB7yawSStuoODBO0HZ
         j8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uel3olZUGWUGB7fGgn2CRgNjmcZtFUxP2kJFlFiro0w=;
        b=IcNT+60bJGnt8yQLAYejZRLOpXOXZGtmY6U6Sg6Jy4jj5/NbIGx5XEoK8LDCPJdT7D
         X3U+cvkNbouynWeP55At6dAJ6WXw1hGfo8z0PSdyOILjIeHjvS/5qCJtG94A0nTiFaYb
         XNg4k7zxM/QEiSLp4+2P0q6MxSEcs66dxVVw5N9xiPjx5hENLtnvAHTtV77IVdUfYknZ
         JJlQ2nbX7RNaQPnNXwiZXEr0EF+vrqjczFInBK+/FemyTMTFPDt4zKSS4wujTZOI7Ssz
         jIynLxACEBK6pr6+y0ei1ySG6yLxwIOGl1ChLK7eLjBHSKl0faOrBFMjurzuQaqmC5AX
         UYFA==
X-Gm-Message-State: AOAM531U+mSy6JzzyXFhmiVF9kzRMTaYoinpL8aw3uI8h8E6rLm+ifvk
        BeUrgi8+2wKnDrrOX1w7Q+OeelrnS+bV6u6S
X-Google-Smtp-Source: ABdhPJwEwRPCRqbzBJRrWrmVg6gaZUVQQfxIGDfuDqUjM0M4pW4rrCkq2at3JealwpmZMKf1GZrvvw==
X-Received: by 2002:a17:90b:1e10:: with SMTP id pg16mr9921527pjb.30.1619709872979;
        Thu, 29 Apr 2021 08:24:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o127sm3035967pfd.147.2021.04.29.08.24.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Apr 2021 08:24:32 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, lyl2019@mail.ustc.edu.cn,
        tung.q.nguyen@dektech.com.au
Subject: [PATCHv2 net] tipc: fix a race in tipc_sk_mcast_rcv
Date:   Thu, 29 Apr 2021 23:24:24 +0800
Message-Id: <6cfd091a3067fed37b4361f3b083e2abcbb8763c.1619709864.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit cb1b728096f5 ("tipc: eliminate race condition at multicast
reception"), when processing the multicast reception, the packets are
firstly moved from be->inputq1 to be->arrvq in tipc_node_broadcast(),
then it processes be->arrvq in tipc_sk_mcast_rcv().

In tipc_sk_mcast_rcv(), it gets the 1st skb by skb_peek(), then handles
this skb without any lock. It means meanwhile another thread could also
call tipc_sk_mcast_rcv() and process be->arrvq and pick up the same skb,
then free it. A double free issue will be caused as Li Shuang reported:

  [] kernel BUG at mm/slub.c:305!
  []  kfree+0x3a7/0x3d0
  []  kfree_skb+0x32/0xa0
  []  skb_release_data+0xb4/0x170
  []  kfree_skb+0x32/0xa0
  []  skb_release_data+0xb4/0x170
  []  kfree_skb+0x32/0xa0
  []  tipc_sk_mcast_rcv+0x1fa/0x380 [tipc]
  []  tipc_rcv+0x411/0x1120 [tipc]
  []  tipc_udp_recv+0xc6/0x1e0 [tipc]
  []  udp_queue_rcv_one_skb+0x1a9/0x500
  []  udp_unicast_rcv_skb.isra.66+0x75/0x90
  []  __udp4_lib_rcv+0x537/0xc40
  []  ip_protocol_deliver_rcu+0xdf/0x1d0
  []  ip_local_deliver_finish+0x4a/0x50
  []  ip_local_deliver+0x6b/0xe0
  []  ip_rcv+0x27b/0x36a
  []  __netif_receive_skb_core+0xb47/0xc40
  []  process_backlog+0xae/0x160

Commit 6bf24dc0cc0c ("net:tipc: Fix a double free in tipc_sk_mcast_rcv")
tried to fix this double free by not releasing the skbs in be->arrvq,
which would definitely cause the skbs' leak.

The problem is we shouldn't process the skbs in be->arrvq without any
lock to protect the code from peeking to dequeuing them. The fix here
is to use a temp skb list instead of be->arrvq to make it "per thread
safe". While at it, remove the no-longer-used be->arrvq.

v1->v2:
  - remove the no-longer-used tipc_skb_peek() and some comments from
    tipc_sk_mcast_rcv() as Tung noticed.

Fixes: cb1b728096f5 ("tipc: eliminate race condition at multicast reception")
Fixes: 6bf24dc0cc0c ("net:tipc: Fix a double free in tipc_sk_mcast_rcv")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/msg.h    | 17 -----------------
 net/tipc/node.c   |  9 ++++-----
 net/tipc/socket.c | 17 +++--------------
 3 files changed, 7 insertions(+), 36 deletions(-)

diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 5d64596..7914358 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -1213,23 +1213,6 @@ static inline int buf_roundup_len(struct sk_buff *skb)
 	return (skb->len / 1024 + 1) * 1024;
 }
 
-/* tipc_skb_peek(): peek and reserve first buffer in list
- * @list: list to be peeked in
- * Returns pointer to first buffer in list, if any
- */
-static inline struct sk_buff *tipc_skb_peek(struct sk_buff_head *list,
-					    spinlock_t *lock)
-{
-	struct sk_buff *skb;
-
-	spin_lock_bh(lock);
-	skb = skb_peek(list);
-	if (skb)
-		skb_get(skb);
-	spin_unlock_bh(lock);
-	return skb;
-}
-
 /* tipc_skb_peek_port(): find a destination port, ignoring all destinations
  *                       up to and including 'filter'.
  * Note: ignoring previously tried destinations minimizes the risk of
diff --git a/net/tipc/node.c b/net/tipc/node.c
index e0ee832..0c636fb 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -72,7 +72,6 @@ struct tipc_link_entry {
 struct tipc_bclink_entry {
 	struct tipc_link *link;
 	struct sk_buff_head inputq1;
-	struct sk_buff_head arrvq;
 	struct sk_buff_head inputq2;
 	struct sk_buff_head namedq;
 	u16 named_rcv_nxt;
@@ -552,7 +551,6 @@ struct tipc_node *tipc_node_create(struct net *net, u32 addr, u8 *peer_id,
 	INIT_LIST_HEAD(&n->conn_sks);
 	skb_queue_head_init(&n->bc_entry.namedq);
 	skb_queue_head_init(&n->bc_entry.inputq1);
-	__skb_queue_head_init(&n->bc_entry.arrvq);
 	skb_queue_head_init(&n->bc_entry.inputq2);
 	for (i = 0; i < MAX_BEARERS; i++)
 		spin_lock_init(&n->links[i].lock);
@@ -1803,14 +1801,15 @@ void tipc_node_broadcast(struct net *net, struct sk_buff *skb, int rc_dests)
 static void tipc_node_mcast_rcv(struct tipc_node *n)
 {
 	struct tipc_bclink_entry *be = &n->bc_entry;
+	struct sk_buff_head tmpq;
 
-	/* 'arrvq' is under inputq2's lock protection */
+	__skb_queue_head_init(&tmpq);
 	spin_lock_bh(&be->inputq2.lock);
 	spin_lock_bh(&be->inputq1.lock);
-	skb_queue_splice_tail_init(&be->inputq1, &be->arrvq);
+	skb_queue_splice_tail_init(&be->inputq1, &tmpq);
 	spin_unlock_bh(&be->inputq1.lock);
 	spin_unlock_bh(&be->inputq2.lock);
-	tipc_sk_mcast_rcv(n->net, &be->arrvq, &be->inputq2);
+	tipc_sk_mcast_rcv(n->net, &tmpq, &be->inputq2);
 }
 
 static void tipc_node_bc_sync_rcv(struct tipc_node *n, struct tipc_msg *hdr,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 022999e..cfd30fa 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1210,8 +1210,7 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 	__skb_queue_head_init(&tmpq);
 	INIT_LIST_HEAD(&dports);
 
-	skb = tipc_skb_peek(arrvq, &inputq->lock);
-	for (; skb; skb = tipc_skb_peek(arrvq, &inputq->lock)) {
+	while ((skb = __skb_dequeue(arrvq)) != NULL) {
 		hdr = buf_msg(skb);
 		user = msg_user(hdr);
 		mtyp = msg_type(hdr);
@@ -1220,13 +1219,7 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 		type = msg_nametype(hdr);
 
 		if (mtyp == TIPC_GRP_UCAST_MSG || user == GROUP_PROTOCOL) {
-			spin_lock_bh(&inputq->lock);
-			if (skb_peek(arrvq) == skb) {
-				__skb_dequeue(arrvq);
-				__skb_queue_tail(inputq, skb);
-			}
-			kfree_skb(skb);
-			spin_unlock_bh(&inputq->lock);
+			skb_queue_tail(inputq, skb);
 			continue;
 		}
 
@@ -1261,12 +1254,8 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 			}
 			pr_warn("Failed to clone mcast rcv buffer\n");
 		}
-		/* Append to inputq if not already done by other thread */
 		spin_lock_bh(&inputq->lock);
-		if (skb_peek(arrvq) == skb) {
-			skb_queue_splice_tail_init(&tmpq, inputq);
-			__skb_dequeue(arrvq);
-		}
+		skb_queue_splice_tail_init(&tmpq, inputq);
 		spin_unlock_bh(&inputq->lock);
 		__skb_queue_purge(&tmpq);
 		kfree_skb(skb);
-- 
2.1.0

