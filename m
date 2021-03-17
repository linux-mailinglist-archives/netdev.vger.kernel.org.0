Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A252D33E695
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCQCHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229958AbhCQCGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EYQmKu8p6izJN2OOwyi35V5Hp6GuzOO6FkzeNBu8Q6Q=;
        b=EXLaPgApVBiI80E9An/YwUOuqARlIskHDGwKubHgXZfONA4uzMDt4xWTL4+VZLkTpz3wzl
        m2Fjl0KO8FHquCjaKapnel+XSE8vakjBbCroMUZ3Fix0QjKLot16egzwtePpSnriScDwEZ
        ptIk3lCvg0ZCni+HeNHDT5AyRsphgNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-PPy4wSqlOQy6B0NUI6lKmQ-1; Tue, 16 Mar 2021 22:06:39 -0400
X-MC-Unique: PPy4wSqlOQy6B0NUI6lKmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC6CB81431C;
        Wed, 17 Mar 2021 02:06:37 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEB585C1A1;
        Wed, 17 Mar 2021 02:06:36 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 07/16] tipc: rename binding table lookup functions
Date:   Tue, 16 Mar 2021 22:06:14 -0400
Message-Id: <20210317020623.1258298-8-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

The binding table provides four different lookup functions, which
purpose is not obvious neither by their names nor by the (lack of)
descriptions.

We now give these functions names that better match their purposes,
and improve the comments that describe what they are doing.

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/msg.c        |  4 ++--
 net/tipc/name_table.c | 51 ++++++++++++++++++++++++++++---------------
 net/tipc/name_table.h | 19 +++++++++-------
 net/tipc/socket.c     | 19 ++++++++--------
 4 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index e9263280a2d4..25afb5949892 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -723,8 +723,8 @@ bool tipc_msg_lookup_dest(struct net *net, struct sk_buff *skb, int *err)
 	if (msg_reroute_cnt(msg))
 		return false;
 	dnode = tipc_scope2node(net, msg_lookup_scope(msg));
-	dport = tipc_nametbl_translate(net, msg_nametype(msg),
-				       msg_nameinst(msg), &dnode);
+	dport = tipc_nametbl_lookup_anycast(net, msg_nametype(msg),
+					    msg_nameinst(msg), &dnode);
 	if (!dport)
 		return false;
 	msg_incr_reroute_cnt(msg);
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 5676b8d4f08f..22616a943e70 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -544,24 +544,26 @@ struct publication *tipc_nametbl_remove_publ(struct net *net,
 }
 
 /**
- * tipc_nametbl_translate - perform service instance to socket translation
+ * tipc_nametbl_lookup_anycast - perform service instance to socket translation
  * @net: network namespace
  * @type: message type
  * @instance: message instance
  * @dnode: the search domain used during translation
  *
+ * On entry, 'dnode' is the search domain used during the lookup
+ *
  * On exit:
- * - if translation is deferred to another node, leave 'dnode' unchanged and
- * return 0
- * - if translation is attempted and succeeds, set 'dnode' to the publishing
- * node and return the published (non-zero) port number
- * - if translation is attempted and fails, set 'dnode' to 0 and return 0
+ * - if lookup is deferred to another node, leave 'dnode' unchanged and return 0
+ * - if lookup is attempted and succeeds, set 'dnode' to the publishing node and
+ *   return the published (non-zero) port number
+ * - if lookup is attempted and fails, set 'dnode' to 0 and return 0
  *
  * Note that for legacy users (node configured with Z.C.N address format) the
  * 'closest-first' lookup algorithm must be maintained, i.e., if dnode is 0
  * we must look in the local binding list first
  */
-u32 tipc_nametbl_translate(struct net *net, u32 type, u32 instance, u32 *dnode)
+u32 tipc_nametbl_lookup_anycast(struct net *net, u32 type,
+				u32 instance, u32 *dnode)
 {
 	struct tipc_net *tn = tipc_net(net);
 	bool legacy = tn->legacy_addr_format;
@@ -617,9 +619,15 @@ u32 tipc_nametbl_translate(struct net *net, u32 type, u32 instance, u32 *dnode)
 	return port;
 }
 
-bool tipc_nametbl_lookup(struct net *net, u32 type, u32 instance, u32 scope,
-			 struct list_head *dsts, int *dstcnt, u32 exclude,
-			 bool all)
+/* tipc_nametbl_lookup_group(): lookup destinaton(s) in a communication group
+ * Returns a list of one (== group anycast) or more (== group multicast)
+ * destination socket/node pairs matching the given address.
+ * The requester may or may not want to exclude himself from the list.
+ */
+bool tipc_nametbl_lookup_group(struct net *net, u32 type, u32 instance,
+			       u32 scope, struct list_head *dsts,
+			       int *dstcnt, u32 exclude,
+			       bool mcast)
 {
 	u32 self = tipc_own_addr(net);
 	struct service_range *sr;
@@ -646,7 +654,7 @@ bool tipc_nametbl_lookup(struct net *net, u32 type, u32 instance, u32 scope,
 			continue;
 		tipc_dest_push(dsts, p->sk.node, p->sk.ref);
 		(*dstcnt)++;
-		if (all)
+		if (mcast)
 			continue;
 		list_move_tail(&p->all_publ, &sr->all_publ);
 		break;
@@ -658,8 +666,14 @@ bool tipc_nametbl_lookup(struct net *net, u32 type, u32 instance, u32 scope,
 	return !list_empty(dsts);
 }
 
-void tipc_nametbl_mc_lookup(struct net *net, u32 type, u32 lower, u32 upper,
-			    u32 scope, bool exact, struct list_head *dports)
+/* tipc_nametbl_lookup_mcast_sockets(): look up node local destinaton sockets
+ *                                      matching the given address
+ * Used on nodes which have received a multicast/broadcast message
+ * Returns a list of local sockets
+ */
+void tipc_nametbl_lookup_mcast_sockets(struct net *net, u32 type, u32 lower,
+				       u32 upper, u32 scope, bool exact,
+				       struct list_head *dports)
 {
 	struct service_range *sr;
 	struct tipc_service *sc;
@@ -682,12 +696,13 @@ void tipc_nametbl_mc_lookup(struct net *net, u32 type, u32 lower, u32 upper,
 	rcu_read_unlock();
 }
 
-/* tipc_nametbl_lookup_dst_nodes - find broadcast destination nodes
- * - Creates list of nodes that overlap the given multicast address
- * - Determines if any node local destinations overlap
+/* tipc_nametbl_lookup_mcast_nodes(): look up all destination nodes matching
+ *                                    the given address. Used in sending node.
+ * Used on nodes which are sending out a multicast/broadcast message
+ * Returns a list of nodes, including own node if applicable
  */
-void tipc_nametbl_lookup_dst_nodes(struct net *net, u32 type, u32 lower,
-				   u32 upper, struct tipc_nlist *nodes)
+void tipc_nametbl_lookup_mcast_nodes(struct net *net, u32 type, u32 lower,
+				     u32 upper, struct tipc_nlist *nodes)
 {
 	struct service_range *sr;
 	struct tipc_service *sc;
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index 5a7c83d22ef9..07a297f22135 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -111,16 +111,19 @@ struct name_table {
 
 int tipc_nl_name_table_dump(struct sk_buff *skb, struct netlink_callback *cb);
 
-u32 tipc_nametbl_translate(struct net *net, u32 type, u32 instance, u32 *node);
-void tipc_nametbl_mc_lookup(struct net *net, u32 type, u32 lower, u32 upper,
-			    u32 scope, bool exact, struct list_head *dports);
+u32 tipc_nametbl_lookup_anycast(struct net *net, u32 type, u32 instance,
+				u32 *node);
+void tipc_nametbl_lookup_mcast_sockets(struct net *net, u32 type, u32 lower,
+				       u32 upper, u32 scope, bool exact,
+				   struct list_head *dports);
+void tipc_nametbl_lookup_mcast_nodes(struct net *net, u32 type, u32 lower,
+				     u32 upper, struct tipc_nlist *nodes);
+bool tipc_nametbl_lookup_group(struct net *net, u32 type, u32 instance,
+			       u32 domain, struct list_head *dsts,
+			       int *dstcnt, u32 exclude,
+			       bool all);
 void tipc_nametbl_build_group(struct net *net, struct tipc_group *grp,
 			      u32 type, u32 domain);
-void tipc_nametbl_lookup_dst_nodes(struct net *net, u32 type, u32 lower,
-				   u32 upper, struct tipc_nlist *nodes);
-bool tipc_nametbl_lookup(struct net *net, u32 type, u32 instance, u32 domain,
-			 struct list_head *dsts, int *dstcnt, u32 exclude,
-			 bool all);
 struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
 					 struct tipc_socket_addr *sk, u32 key);
 void tipc_nametbl_withdraw(struct net *net, struct tipc_uaddr *ua,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 7f5722d3b3d0..b80c82d3ab87 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -863,8 +863,8 @@ static int tipc_sendmcast(struct  socket *sock, struct tipc_service_range *seq,
 
 	/* Lookup destination nodes */
 	tipc_nlist_init(&dsts, tipc_own_addr(net));
-	tipc_nametbl_lookup_dst_nodes(net, seq->type, seq->lower,
-				      seq->upper, &dsts);
+	tipc_nametbl_lookup_mcast_nodes(net, seq->type, seq->lower,
+					seq->upper, &dsts);
 	if (!dsts.local && !dsts.remote)
 		return -EHOSTUNREACH;
 
@@ -1032,8 +1032,9 @@ static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
 
 		/* Look for a non-congested destination member, if any */
 		while (1) {
-			if (!tipc_nametbl_lookup(net, type, inst, scope, &dsts,
-						 &dstcnt, exclude, false))
+			if (!tipc_nametbl_lookup_group(net, type, inst, scope,
+						       &dsts, &dstcnt, exclude,
+						       false))
 				return -EHOSTUNREACH;
 			tipc_dest_pop(&dsts, &node, &port);
 			cong = tipc_group_cong(tsk->group, node, port, blks,
@@ -1179,8 +1180,8 @@ static int tipc_send_group_mcast(struct socket *sock, struct msghdr *m,
 	scope = msg_lookup_scope(hdr);
 	exclude = tipc_group_exclude(grp);
 
-	if (!tipc_nametbl_lookup(net, type, inst, scope, &dsts,
-				 &dstcnt, exclude, true))
+	if (!tipc_nametbl_lookup_group(net, type, inst, scope, &dsts,
+				       &dstcnt, exclude, true))
 		return -EHOSTUNREACH;
 
 	if (dstcnt == 1) {
@@ -1254,8 +1255,8 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 		}
 
 		/* Create destination port list: */
-		tipc_nametbl_mc_lookup(net, type, lower, upper,
-				       scope, exact, &dports);
+		tipc_nametbl_lookup_mcast_sockets(net, type, lower, upper,
+						  scope, exact, &dports);
 
 		/* Clone message per destination */
 		while (tipc_dest_pop(&dports, NULL, &portid)) {
@@ -1485,7 +1486,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 		type = dest->addr.name.name.type;
 		inst = dest->addr.name.name.instance;
 		dnode = dest->addr.name.domain;
-		dport = tipc_nametbl_translate(net, type, inst, &dnode);
+		dport = tipc_nametbl_lookup_anycast(net, type, inst, &dnode);
 		if (unlikely(!dport && !dnode))
 			return -EHOSTUNREACH;
 	} else if (dest->addrtype == TIPC_SOCKET_ADDR) {
-- 
2.29.2

