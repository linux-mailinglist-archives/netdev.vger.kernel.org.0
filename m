Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48EF394CA8
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 17:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhE2PPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 11:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229810AbhE2PPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 11:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622301252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8DDGm7PDRIpInoDZZr9/oqqsyfR8BECLm8JTNeAuo00=;
        b=cWZH0Ees1PkwJhNwrhyHtWYR+cjTFPYTaw/hfwJW5eQs/jAdMOsPdVHtqDk6WIKK4xEuxU
        c/WTiVsDILOfc/TfRbo8MVYJCFwGtf99El0OepWbTYl2XWsKeBwszfN/cpnFS6iONiWf/k
        TI6OrLK+J4xy+cb/7UqjLI7FqkElYTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399--yqIIoHPNJWorvgFd7dT5A-1; Sat, 29 May 2021 11:14:08 -0400
X-MC-Unique: -yqIIoHPNJWorvgFd7dT5A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFC8E501E0;
        Sat, 29 May 2021 15:14:06 +0000 (UTC)
Received: from ymir.virt.lab.eng.bos.redhat.com (virtlab420.virt.lab.eng.bos.redhat.com [10.19.152.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF1081A881;
        Sat, 29 May 2021 15:14:05 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 3/3] tipc: simplify handling of lookup scope during multicast message reception
Date:   Sat, 29 May 2021 11:14:00 -0400
Message-Id: <20210529151400.781539-4-jmaloy@redhat.com>
In-Reply-To: <20210529151400.781539-1-jmaloy@redhat.com>
References: <20210529151400.781539-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We introduce a new macro TIPC_ANY_SCOPE to make the handling of the
lookup scope value more comprehensible during multicast reception.

The (unchanged) rules go as follows:

1) Multicast messages sent from own node are delivered to all matching
   sockets on the own node, irrespective of their binding scope.

2) Multicast messages sent from other nodes arrive here because they
   have found TIPC_CLUSTER_SCOPE bindings emanating from this node.
   Those messages should be delivered to exactly those sockets, but not
   to local sockets bound with TIPC_NODE_SCOPE, since the latter
   obviously were not meant to be visible for those senders.

3) Group multicast/broadcast messages are delivered to the sockets with
   a binding scope matching exactly the lookup scope indicated in the
   message header, and nobody else.

Reviewed-by: Xin Long <lucien.xin@gmail.com>
Tested-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/name_table.c |  6 +++---
 net/tipc/name_table.h |  4 +++-
 net/tipc/socket.c     | 26 ++++++++++----------------
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index fecab516bf41..01396dd1c899 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -673,12 +673,12 @@ bool tipc_nametbl_lookup_group(struct net *net, struct tipc_uaddr *ua,
  * Returns a list of local sockets
  */
 void tipc_nametbl_lookup_mcast_sockets(struct net *net, struct tipc_uaddr *ua,
-				       bool exact, struct list_head *dports)
+				       struct list_head *dports)
 {
 	struct service_range *sr;
 	struct tipc_service *sc;
 	struct publication *p;
-	u32 scope = ua->scope;
+	u8 scope = ua->scope;
 
 	rcu_read_lock();
 	sc = tipc_service_find(net, ua);
@@ -688,7 +688,7 @@ void tipc_nametbl_lookup_mcast_sockets(struct net *net, struct tipc_uaddr *ua,
 	spin_lock_bh(&sc->lock);
 	service_range_foreach_match(sr, sc, ua->sr.lower, ua->sr.upper) {
 		list_for_each_entry(p, &sr->local_publ, local_publ) {
-			if (p->scope == scope || (!exact && p->scope < scope))
+			if (scope == p->scope || scope == TIPC_ANY_SCOPE)
 				tipc_dest_push(dports, 0, p->sk.ref);
 		}
 	}
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index c7c9a3ddd420..148b0f640959 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -51,6 +51,8 @@ struct tipc_uaddr;
 #define TIPC_PUBL_SCOPE_NUM	(TIPC_NODE_SCOPE + 1)
 #define TIPC_NAMETBL_SIZE	1024	/* must be a power of 2 */
 
+#define TIPC_ANY_SCOPE 255
+
 /**
  * struct publication - info about a published service address or range
  * @sr: service range represented by this publication
@@ -113,7 +115,7 @@ int tipc_nl_name_table_dump(struct sk_buff *skb, struct netlink_callback *cb);
 bool tipc_nametbl_lookup_anycast(struct net *net, struct tipc_uaddr *ua,
 				 struct tipc_socket_addr *sk);
 void tipc_nametbl_lookup_mcast_sockets(struct net *net, struct tipc_uaddr *ua,
-				       bool exact, struct list_head *dports);
+				       struct list_head *dports);
 void tipc_nametbl_lookup_mcast_nodes(struct net *net, struct tipc_uaddr *ua,
 				     struct tipc_nlist *nodes);
 bool tipc_nametbl_lookup_group(struct net *net, struct tipc_uaddr *ua,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index c635fd27fb38..575a0238deb2 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1200,12 +1200,12 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 	struct tipc_msg *hdr;
 	struct tipc_uaddr ua;
 	int user, mtyp, hlen;
-	bool exact;
 
 	__skb_queue_head_init(&tmpq);
 	INIT_LIST_HEAD(&dports);
 	ua.addrtype = TIPC_SERVICE_RANGE;
 
+	/* tipc_skb_peek() increments the head skb's reference counter */
 	skb = tipc_skb_peek(arrvq, &inputq->lock);
 	for (; skb; skb = tipc_skb_peek(arrvq, &inputq->lock)) {
 		hdr = buf_msg(skb);
@@ -1214,6 +1214,12 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 		hlen = skb_headroom(skb) + msg_hdr_sz(hdr);
 		onode = msg_orignode(hdr);
 		ua.sr.type = msg_nametype(hdr);
+		ua.sr.lower = msg_namelower(hdr);
+		ua.sr.upper = msg_nameupper(hdr);
+		if (onode == self)
+			ua.scope = TIPC_ANY_SCOPE;
+		else
+			ua.scope = TIPC_CLUSTER_SCOPE;
 
 		if (mtyp == TIPC_GRP_UCAST_MSG || user == GROUP_PROTOCOL) {
 			spin_lock_bh(&inputq->lock);
@@ -1231,20 +1237,10 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 			ua.sr.lower = 0;
 			ua.sr.upper = ~0;
 			ua.scope = msg_lookup_scope(hdr);
-			exact = true;
-		} else {
-			/* TIPC_NODE_SCOPE means "any scope" in this context */
-			if (onode == self)
-				ua.scope = TIPC_NODE_SCOPE;
-			else
-				ua.scope = TIPC_CLUSTER_SCOPE;
-			exact = false;
-			ua.sr.lower = msg_namelower(hdr);
-			ua.sr.upper = msg_nameupper(hdr);
 		}
 
 		/* Create destination port list: */
-		tipc_nametbl_lookup_mcast_sockets(net, &ua, exact, &dports);
+		tipc_nametbl_lookup_mcast_sockets(net, &ua, &dports);
 
 		/* Clone message per destination */
 		while (tipc_dest_pop(&dports, NULL, &portid)) {
@@ -1256,13 +1252,11 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 			}
 			pr_warn("Failed to clone mcast rcv buffer\n");
 		}
-		/* Append to inputq if not already done by other thread */
+		/* Append clones to inputq only if skb is still head of arrvq */
 		spin_lock_bh(&inputq->lock);
 		if (skb_peek(arrvq) == skb) {
 			skb_queue_splice_tail_init(&tmpq, inputq);
-			/* Decrease the skb's refcnt as increasing in the
-			 * function tipc_skb_peek
-			 */
+			/* Decrement the skb's refcnt */
 			kfree_skb(__skb_dequeue(arrvq));
 		}
 		spin_unlock_bh(&inputq->lock);
-- 
2.31.1

