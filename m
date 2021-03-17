Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD9B33E696
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCQCHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhCQCGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5H+6ymfe8qHaeakbFwhakaXXieqyprNEPUzXCLsU8vY=;
        b=Y+A3NDCaTNsoOufzA/fwB9f8U+so4wQHGmiUTSc0E1faBHBSSMbXwD8d3ZLVKHtUykVu66
        IF0Lffq5QSnPkjqoUlzfnyayNB+0Vqu6QrPMW55AgeCyY6BHHf8SA3Q3nFgUo6Mm9IyxLl
        84G7WA7JxxITBEBqm81NJgGldaMRnVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-S_qsLoCcOcqN6whVAUUalA-1; Tue, 16 Mar 2021 22:06:42 -0400
X-MC-Unique: S_qsLoCcOcqN6whVAUUalA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB315100C618;
        Wed, 17 Mar 2021 02:06:40 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B08295C1A1;
        Wed, 17 Mar 2021 02:06:39 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 09/16] tipc: simplify signature of tipc_namtbl_lookup_mcast_sockets()
Date:   Tue, 16 Mar 2021 22:06:16 -0400
Message-Id: <20210317020623.1258298-10-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We reduce the signature of this function according to the same
principle as the preceding commits.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_table.c | 10 +++++-----
 net/tipc/name_table.h |  5 ++---
 net/tipc/socket.c     | 22 +++++++++++-----------
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 20beb04b2db0..ad021d8c02e7 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -668,21 +668,21 @@ bool tipc_nametbl_lookup_group(struct net *net, u32 type, u32 instance,
  * Used on nodes which have received a multicast/broadcast message
  * Returns a list of local sockets
  */
-void tipc_nametbl_lookup_mcast_sockets(struct net *net, u32 type, u32 lower,
-				       u32 upper, u32 scope, bool exact,
-				       struct list_head *dports)
+void tipc_nametbl_lookup_mcast_sockets(struct net *net, struct tipc_uaddr *ua,
+				       bool exact, struct list_head *dports)
 {
 	struct service_range *sr;
 	struct tipc_service *sc;
 	struct publication *p;
+	u32 scope = ua->scope;
 
 	rcu_read_lock();
-	sc = tipc_service_find(net, type);
+	sc = tipc_service_find(net, ua->sr.type);
 	if (!sc)
 		goto exit;
 
 	spin_lock_bh(&sc->lock);
-	service_range_foreach_match(sr, sc, lower, upper) {
+	service_range_foreach_match(sr, sc, ua->sr.lower, ua->sr.upper) {
 		list_for_each_entry(p, &sr->local_publ, local_publ) {
 			if (p->scope == scope || (!exact && p->scope < scope))
 				tipc_dest_push(dports, 0, p->sk.ref);
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index 9896205a5d66..26aa6acb4512 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -112,9 +112,8 @@ struct name_table {
 int tipc_nl_name_table_dump(struct sk_buff *skb, struct netlink_callback *cb);
 bool tipc_nametbl_lookup_anycast(struct net *net, struct tipc_uaddr *ua,
 				 struct tipc_socket_addr *sk);
-void tipc_nametbl_lookup_mcast_sockets(struct net *net, u32 type, u32 lower,
-				       u32 upper, u32 scope, bool exact,
-				   struct list_head *dports);
+void tipc_nametbl_lookup_mcast_sockets(struct net *net, struct tipc_uaddr *ua,
+				       bool exact, struct list_head *dports);
 void tipc_nametbl_lookup_mcast_nodes(struct net *net, u32 type, u32 lower,
 				     u32 upper, struct tipc_nlist *nodes);
 bool tipc_nametbl_lookup_group(struct net *net, u32 type, u32 instance,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 26e1ca6e4766..b952128537e1 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1205,17 +1205,18 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 		       struct sk_buff_head *inputq)
 {
 	u32 self = tipc_own_addr(net);
-	u32 type, lower, upper, scope;
 	struct sk_buff *skb, *_skb;
 	u32 portid, onode;
 	struct sk_buff_head tmpq;
 	struct list_head dports;
 	struct tipc_msg *hdr;
+	struct tipc_uaddr ua;
 	int user, mtyp, hlen;
 	bool exact;
 
 	__skb_queue_head_init(&tmpq);
 	INIT_LIST_HEAD(&dports);
+	ua.addrtype = TIPC_SERVICE_RANGE;
 
 	skb = tipc_skb_peek(arrvq, &inputq->lock);
 	for (; skb; skb = tipc_skb_peek(arrvq, &inputq->lock)) {
@@ -1224,7 +1225,7 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 		mtyp = msg_type(hdr);
 		hlen = skb_headroom(skb) + msg_hdr_sz(hdr);
 		onode = msg_orignode(hdr);
-		type = msg_nametype(hdr);
+		ua.sr.type = msg_nametype(hdr);
 
 		if (mtyp == TIPC_GRP_UCAST_MSG || user == GROUP_PROTOCOL) {
 			spin_lock_bh(&inputq->lock);
@@ -1239,24 +1240,23 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 
 		/* Group messages require exact scope match */
 		if (msg_in_group(hdr)) {
-			lower = 0;
-			upper = ~0;
-			scope = msg_lookup_scope(hdr);
+			ua.sr.lower = 0;
+			ua.sr.upper = ~0;
+			ua.scope = msg_lookup_scope(hdr);
 			exact = true;
 		} else {
 			/* TIPC_NODE_SCOPE means "any scope" in this context */
 			if (onode == self)
-				scope = TIPC_NODE_SCOPE;
+				ua.scope = TIPC_NODE_SCOPE;
 			else
-				scope = TIPC_CLUSTER_SCOPE;
+				ua.scope = TIPC_CLUSTER_SCOPE;
 			exact = false;
-			lower = msg_namelower(hdr);
-			upper = msg_nameupper(hdr);
+			ua.sr.lower = msg_namelower(hdr);
+			ua.sr.upper = msg_nameupper(hdr);
 		}
 
 		/* Create destination port list: */
-		tipc_nametbl_lookup_mcast_sockets(net, type, lower, upper,
-						  scope, exact, &dports);
+		tipc_nametbl_lookup_mcast_sockets(net, &ua, exact, &dports);
 
 		/* Clone message per destination */
 		while (tipc_dest_pop(&dports, NULL, &portid)) {
-- 
2.29.2

