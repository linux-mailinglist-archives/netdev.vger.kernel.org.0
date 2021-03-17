Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925B833E698
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCQCHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230016AbhCQCGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqrcfk9zZES8PBgpdPt7ZEqaGujJm+7vPyI4WX4+b4s=;
        b=Z+TttvbDN7pfb4qw5vuA8Bamva5iknotosUIZUhLa5egVyuv2/J7M2TEz+b8Tw/sFHX+Nn
        jxVLUgGALOg7+p91p2ad6xvV3ThVhhuhnympQBmXRNEniYCgjYmpTyDQ/OA6G4otsC/lV2
        ugZtgYwfs3yjfEHtMkkHZOsykxkU6Xw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-JxXqvXCnNbOT_e-PuWxdvA-1; Tue, 16 Mar 2021 22:06:45 -0400
X-MC-Unique: JxXqvXCnNbOT_e-PuWxdvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97D62100C619;
        Wed, 17 Mar 2021 02:06:43 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 659445C1A1;
        Wed, 17 Mar 2021 02:06:42 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 11/16] tipc: simplify signature of tipc_nametbl_lookup_group()
Date:   Tue, 16 Mar 2021 22:06:18 -0400
Message-Id: <20210317020623.1258298-12-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We reduce the signature of tipc_nametbl_lookup_group() by using a
struct tipc_uaddr pointer. This entails a couple of minor changes in the
functions tipc_send_group_mcast/anycast/unicast/bcast() in socket.c

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_table.c | 14 +++++++-------
 net/tipc/name_table.h |  7 +++----
 net/tipc/socket.c     | 42 +++++++++++++++++-------------------------
 3 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 33b79a5da8c9..1ce65cbce672 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -621,31 +621,31 @@ bool tipc_nametbl_lookup_anycast(struct net *net,
  * destination socket/node pairs matching the given address.
  * The requester may or may not want to exclude himself from the list.
  */
-bool tipc_nametbl_lookup_group(struct net *net, u32 type, u32 instance,
-			       u32 scope, struct list_head *dsts,
-			       int *dstcnt, u32 exclude,
-			       bool mcast)
+bool tipc_nametbl_lookup_group(struct net *net, struct tipc_uaddr *ua,
+			       struct list_head *dsts, int *dstcnt,
+			       u32 exclude, bool mcast)
 {
 	u32 self = tipc_own_addr(net);
+	u32 inst = ua->sa.instance;
 	struct service_range *sr;
 	struct tipc_service *sc;
 	struct publication *p;
 
 	*dstcnt = 0;
 	rcu_read_lock();
-	sc = tipc_service_find(net, type);
+	sc = tipc_service_find(net, ua->sa.type);
 	if (unlikely(!sc))
 		goto exit;
 
 	spin_lock_bh(&sc->lock);
 
 	/* Todo: a full search i.e. service_range_foreach_match() instead? */
-	sr = service_range_match_first(sc->ranges.rb_node, instance, instance);
+	sr = service_range_match_first(sc->ranges.rb_node, inst, inst);
 	if (!sr)
 		goto no_match;
 
 	list_for_each_entry(p, &sr->all_publ, all_publ) {
-		if (p->scope != scope)
+		if (p->scope != ua->scope)
 			continue;
 		if (p->sk.ref == exclude && p->sk.node == self)
 			continue;
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index c5aa45abbdc3..b20b694c1284 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -116,10 +116,9 @@ void tipc_nametbl_lookup_mcast_sockets(struct net *net, struct tipc_uaddr *ua,
 				       bool exact, struct list_head *dports);
 void tipc_nametbl_lookup_mcast_nodes(struct net *net, struct tipc_uaddr *ua,
 				     struct tipc_nlist *nodes);
-bool tipc_nametbl_lookup_group(struct net *net, u32 type, u32 instance,
-			       u32 domain, struct list_head *dsts,
-			       int *dstcnt, u32 exclude,
-			       bool all);
+bool tipc_nametbl_lookup_group(struct net *net, struct tipc_uaddr *ua,
+			       struct list_head *dsts, int *dstcnt,
+			       u32 exclude, bool mcast);
 void tipc_nametbl_build_group(struct net *net, struct tipc_group *grp,
 			      u32 type, u32 domain);
 struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 83d7c9c25c63..a7f86f22c03a 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -958,7 +958,7 @@ static int tipc_send_group_unicast(struct socket *sock, struct msghdr *m,
 				   int dlen, long timeout)
 {
 	struct sock *sk = sock->sk;
-	DECLARE_SOCKADDR(struct sockaddr_tipc *, dest, m->msg_name);
+	struct tipc_uaddr *ua = (struct tipc_uaddr *)m->msg_name;
 	int blks = tsk_blocks(GROUP_H_SIZE + dlen);
 	struct tipc_sock *tsk = tipc_sk(sk);
 	struct net *net = sock_net(sk);
@@ -966,8 +966,8 @@ static int tipc_send_group_unicast(struct socket *sock, struct msghdr *m,
 	u32 node, port;
 	int rc;
 
-	node = dest->addr.id.node;
-	port = dest->addr.id.ref;
+	node = ua->sk.node;
+	port = ua->sk.ref;
 	if (!port && !node)
 		return -EHOSTUNREACH;
 
@@ -1001,7 +1001,7 @@ static int tipc_send_group_unicast(struct socket *sock, struct msghdr *m,
 static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
 				   int dlen, long timeout)
 {
-	DECLARE_SOCKADDR(struct sockaddr_tipc *, dest, m->msg_name);
+	struct tipc_uaddr *ua = (struct tipc_uaddr *)m->msg_name;
 	struct sock *sk = sock->sk;
 	struct tipc_sock *tsk = tipc_sk(sk);
 	struct list_head *cong_links = &tsk->cong_links;
@@ -1012,16 +1012,13 @@ static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
 	struct net *net = sock_net(sk);
 	u32 node, port, exclude;
 	struct list_head dsts;
-	u32 type, inst, scope;
 	int lookups = 0;
 	int dstcnt, rc;
 	bool cong;
 
 	INIT_LIST_HEAD(&dsts);
-
-	type = msg_nametype(hdr);
-	inst = dest->addr.name.name.instance;
-	scope = msg_lookup_scope(hdr);
+	ua->sa.type = msg_nametype(hdr);
+	ua->scope = msg_lookup_scope(hdr);
 
 	while (++lookups < 4) {
 		exclude = tipc_group_exclude(tsk->group);
@@ -1030,9 +1027,8 @@ static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
 
 		/* Look for a non-congested destination member, if any */
 		while (1) {
-			if (!tipc_nametbl_lookup_group(net, type, inst, scope,
-						       &dsts, &dstcnt, exclude,
-						       false))
+			if (!tipc_nametbl_lookup_group(net, ua, &dsts, &dstcnt,
+						       exclude, false))
 				return -EHOSTUNREACH;
 			tipc_dest_pop(&dsts, &node, &port);
 			cong = tipc_group_cong(tsk->group, node, port, blks,
@@ -1087,7 +1083,7 @@ static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
 static int tipc_send_group_bcast(struct socket *sock, struct msghdr *m,
 				 int dlen, long timeout)
 {
-	DECLARE_SOCKADDR(struct sockaddr_tipc *, dest, m->msg_name);
+	struct tipc_uaddr *ua = (struct tipc_uaddr *)m->msg_name;
 	struct sock *sk = sock->sk;
 	struct net *net = sock_net(sk);
 	struct tipc_sock *tsk = tipc_sk(sk);
@@ -1112,9 +1108,9 @@ static int tipc_send_group_bcast(struct socket *sock, struct msghdr *m,
 		return -EHOSTUNREACH;
 
 	/* Complete message header */
-	if (dest) {
+	if (ua) {
 		msg_set_type(hdr, TIPC_GRP_MCAST_MSG);
-		msg_set_nameinst(hdr, dest->addr.name.name.instance);
+		msg_set_nameinst(hdr, ua->sa.instance);
 	} else {
 		msg_set_type(hdr, TIPC_GRP_BCAST_MSG);
 		msg_set_nameinst(hdr, 0);
@@ -1161,29 +1157,25 @@ static int tipc_send_group_bcast(struct socket *sock, struct msghdr *m,
 static int tipc_send_group_mcast(struct socket *sock, struct msghdr *m,
 				 int dlen, long timeout)
 {
+	struct tipc_uaddr *ua = (struct tipc_uaddr *)m->msg_name;
 	struct sock *sk = sock->sk;
-	DECLARE_SOCKADDR(struct sockaddr_tipc *, dest, m->msg_name);
 	struct tipc_sock *tsk = tipc_sk(sk);
 	struct tipc_group *grp = tsk->group;
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct net *net = sock_net(sk);
-	u32 type, inst, scope, exclude;
 	struct list_head dsts;
-	u32 dstcnt;
+	u32 dstcnt, exclude;
 
 	INIT_LIST_HEAD(&dsts);
-
-	type = msg_nametype(hdr);
-	inst = dest->addr.name.name.instance;
-	scope = msg_lookup_scope(hdr);
+	ua->sa.type = msg_nametype(hdr);
+	ua->scope = msg_lookup_scope(hdr);
 	exclude = tipc_group_exclude(grp);
 
-	if (!tipc_nametbl_lookup_group(net, type, inst, scope, &dsts,
-				       &dstcnt, exclude, true))
+	if (!tipc_nametbl_lookup_group(net, ua, &dsts, &dstcnt, exclude, true))
 		return -EHOSTUNREACH;
 
 	if (dstcnt == 1) {
-		tipc_dest_pop(&dsts, &dest->addr.id.node, &dest->addr.id.ref);
+		tipc_dest_pop(&dsts, &ua->sk.node, &ua->sk.ref);
 		return tipc_send_group_unicast(sock, m, dlen, timeout);
 	}
 
-- 
2.29.2

