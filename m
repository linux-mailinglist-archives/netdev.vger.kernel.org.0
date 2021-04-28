Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171D036DFA2
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 21:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbhD1Tcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 15:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240333AbhD1TcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 15:32:18 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701C3C061573
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 12:30:39 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h20so33432310plr.4
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 12:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=J1YZT4URIM4ahp55LiV7knAYAZevNptIKIXkoBkBuYo=;
        b=jLtamaowxc7fB7cN2Z426KZ4nyoJLJxZC7kSpd3ckKbnENartUfG5BSTiA0mGSkDeF
         fm3NIBmD4p70ST2BMsbEnuV+8L6guexcSJjQtrB82ODZdHh+x2ufp0Yu/Q4WQzw1gNY6
         rSnlV/htSAVkyKfEM4bwiH+PHyr37V9+gDTj/ROojG6O0LBmmzoAwUmghej/2Rq2B2Lq
         fEaLFVq19uVpRqwVgtIAY2BGiTje3uhBpbclAnFeVRCdYFFKagHywwHjid2LLr2yk/D+
         YhLS+9/9k/ltyY+DSzOXQygXO3TLkwTtlgan9SJbicm9DaDa6CYiBvPmOwxCB3269nzY
         KC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=J1YZT4URIM4ahp55LiV7knAYAZevNptIKIXkoBkBuYo=;
        b=YlUrPmMI3dWqjby+A0GKYsQbhQqtkSgL9nPZ3xPNRaUpkd0q0vyrXDyPtwgSDXjlgj
         P/KBJtZmPMQQtqbq4X2aXyKGtSyoayeZsFk8sCqKvt3Z8PHHpNWpDblKiCEvBdttExIY
         tuXgGZIJAHSjqk2aPInj+dbXTgoATXSW6zNxh617YUJLpJi0FlJbFCNQydgl4CFnOLiR
         xPh/xBf+jilbyV9Jj18zkK5DvUWAMIfJkSez7w1d1DGiW+ytgvyERNpaOJ+kvCkfyFLN
         wBJms/MRFSxrxWGpWLSTtck7Q1TFLpbhn8wKvAQKg2AUKdc+MlV7SAMdv0j/DxblqYTt
         ws2Q==
X-Gm-Message-State: AOAM533e9AyPP3R58yPziQEGac/TKMcCh5N+3BBCSwV0gk3q4ntWnyKu
        LthbcqDlihb4eosT+HsXcDgqZ/HN1DO8gA==
X-Google-Smtp-Source: ABdhPJwGNgMQrkTX/6XT1Ktj5ovjSd5LqhbHZdb7xWpa+u67ebeSK2pQq7wMpPoM8Nwmx6mILCzTMg==
X-Received: by 2002:a17:902:d884:b029:ec:9fcd:2311 with SMTP id b4-20020a170902d884b02900ec9fcd2311mr31208019plz.80.1619638238518;
        Wed, 28 Apr 2021 12:30:38 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e5sm273836pjv.22.2021.04.28.12.30.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Apr 2021 12:30:37 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, lyl2019@mail.ustc.edu.cn
Subject: [PATCH net] tipc: fix a race in tipc_sk_mcast_rcv
Date:   Thu, 29 Apr 2021 03:30:30 +0800
Message-Id: <25c57c05b6f5cc81fd49b8f060ebf0961ea8af68.1619638230.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit cb1b728096f5 ("tipc: eliminate race condition at multicast
reception"), when processing the multicast reception, the packets are
firstly moved from be->inputq1 to be->arrvq in tipc_node_broadcast(),
then process be->arrvq in tipc_sk_mcast_rcv().

In tipc_sk_mcast_rcv(), it gets the 1st skb by skb_peek(), then process
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

Fixes: cb1b728096f5 ("tipc: eliminate race condition at multicast reception")
Fixes: 6bf24dc0cc0c ("net:tipc: Fix a double free in tipc_sk_mcast_rcv")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/node.c   |  9 ++++-----
 net/tipc/socket.c | 16 +++-------------
 2 files changed, 7 insertions(+), 18 deletions(-)

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
index 022999e..2870798 100644
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
 
@@ -1263,10 +1256,7 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 		}
 		/* Append to inputq if not already done by other thread */
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

