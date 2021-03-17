Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4682433E697
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhCQCHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230015AbhCQCGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RllE8lONOGejlV9wz5S9QJgNIoQKRC9E+zQDC4G/Iec=;
        b=P/z0quOmGSYAcWe0Q36fxnoVBBK8ds1kDZE6b1iDHDU3/GS4GZvd1CedKU7N3HiZPvk2v8
        4RdYPj64QrK8wZEWYcg0RcJkP00tEJOwnEOlsI6rjnoL3NW0oUGvLPNumqPqR8XYI9gBj+
        JkY24A6+x39urymXwUQlZiD6ncml+K0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-yM_XNVOrOluev3bqnnw1VQ-1; Tue, 16 Mar 2021 22:06:44 -0400
X-MC-Unique: yM_XNVOrOluev3bqnnw1VQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AE1E80006E;
        Wed, 17 Mar 2021 02:06:42 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FA6B5C1A1;
        Wed, 17 Mar 2021 02:06:40 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 10/16] tipc: simplify signature of tipc_nametbl_lookup_mcast_nodes()
Date:   Tue, 16 Mar 2021 22:06:17 -0400
Message-Id: <20210317020623.1258298-11-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We follow up the preceding commits by reducing the signature of
the function tipc_nametbl_lookup_mcast_nodes().

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_table.c |  8 ++++----
 net/tipc/name_table.h |  4 ++--
 net/tipc/socket.c     | 18 ++++++++----------
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index ad021d8c02e7..33b79a5da8c9 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -698,20 +698,20 @@ void tipc_nametbl_lookup_mcast_sockets(struct net *net, struct tipc_uaddr *ua,
  * Used on nodes which are sending out a multicast/broadcast message
  * Returns a list of nodes, including own node if applicable
  */
-void tipc_nametbl_lookup_mcast_nodes(struct net *net, u32 type, u32 lower,
-				     u32 upper, struct tipc_nlist *nodes)
+void tipc_nametbl_lookup_mcast_nodes(struct net *net, struct tipc_uaddr *ua,
+				     struct tipc_nlist *nodes)
 {
 	struct service_range *sr;
 	struct tipc_service *sc;
 	struct publication *p;
 
 	rcu_read_lock();
-	sc = tipc_service_find(net, type);
+	sc = tipc_service_find(net, ua->sr.type);
 	if (!sc)
 		goto exit;
 
 	spin_lock_bh(&sc->lock);
-	service_range_foreach_match(sr, sc, lower, upper) {
+	service_range_foreach_match(sr, sc, ua->sr.lower, ua->sr.upper) {
 		list_for_each_entry(p, &sr->all_publ, all_publ) {
 			tipc_nlist_add(nodes, p->sk.node);
 		}
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index 26aa6acb4512..c5aa45abbdc3 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -114,8 +114,8 @@ bool tipc_nametbl_lookup_anycast(struct net *net, struct tipc_uaddr *ua,
 				 struct tipc_socket_addr *sk);
 void tipc_nametbl_lookup_mcast_sockets(struct net *net, struct tipc_uaddr *ua,
 				       bool exact, struct list_head *dports);
-void tipc_nametbl_lookup_mcast_nodes(struct net *net, u32 type, u32 lower,
-				     u32 upper, struct tipc_nlist *nodes);
+void tipc_nametbl_lookup_mcast_nodes(struct net *net, struct tipc_uaddr *ua,
+				     struct tipc_nlist *nodes);
 bool tipc_nametbl_lookup_group(struct net *net, u32 type, u32 instance,
 			       u32 domain, struct list_head *dsts,
 			       int *dstcnt, u32 exclude,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index b952128537e1..83d7c9c25c63 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -832,7 +832,7 @@ static __poll_t tipc_poll(struct file *file, struct socket *sock,
 /**
  * tipc_sendmcast - send multicast message
  * @sock: socket structure
- * @seq: destination address
+ * @ua: destination address struct
  * @msg: message to send
  * @dlen: length of data to send
  * @timeout: timeout to wait for wakeup
@@ -840,7 +840,7 @@ static __poll_t tipc_poll(struct file *file, struct socket *sock,
  * Called from function tipc_sendmsg(), which has done all sanity checks
  * Return: the number of bytes sent on success, or errno
  */
-static int tipc_sendmcast(struct  socket *sock, struct tipc_service_range *seq,
+static int tipc_sendmcast(struct  socket *sock, struct tipc_uaddr *ua,
 			  struct msghdr *msg, size_t dlen, long timeout)
 {
 	struct sock *sk = sock->sk;
@@ -848,7 +848,6 @@ static int tipc_sendmcast(struct  socket *sock, struct tipc_service_range *seq,
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct net *net = sock_net(sk);
 	int mtu = tipc_bcast_get_mtu(net);
-	struct tipc_mc_method *method = &tsk->mc_method;
 	struct sk_buff_head pkts;
 	struct tipc_nlist dsts;
 	int rc;
@@ -863,8 +862,7 @@ static int tipc_sendmcast(struct  socket *sock, struct tipc_service_range *seq,
 
 	/* Lookup destination nodes */
 	tipc_nlist_init(&dsts, tipc_own_addr(net));
-	tipc_nametbl_lookup_mcast_nodes(net, seq->type, seq->lower,
-					seq->upper, &dsts);
+	tipc_nametbl_lookup_mcast_nodes(net, ua, &dsts);
 	if (!dsts.local && !dsts.remote)
 		return -EHOSTUNREACH;
 
@@ -874,9 +872,9 @@ static int tipc_sendmcast(struct  socket *sock, struct tipc_service_range *seq,
 	msg_set_lookup_scope(hdr, TIPC_CLUSTER_SCOPE);
 	msg_set_destport(hdr, 0);
 	msg_set_destnode(hdr, 0);
-	msg_set_nametype(hdr, seq->type);
-	msg_set_namelower(hdr, seq->lower);
-	msg_set_nameupper(hdr, seq->upper);
+	msg_set_nametype(hdr, ua->sr.type);
+	msg_set_namelower(hdr, ua->sr.lower);
+	msg_set_nameupper(hdr, ua->sr.upper);
 
 	/* Build message as chain of buffers */
 	__skb_queue_head_init(&pkts);
@@ -886,7 +884,7 @@ static int tipc_sendmcast(struct  socket *sock, struct tipc_service_range *seq,
 	if (unlikely(rc == dlen)) {
 		trace_tipc_sk_sendmcast(sk, skb_peek(&pkts),
 					TIPC_DUMP_SK_SNDQ, " ");
-		rc = tipc_mcast_xmit(net, &pkts, method, &dsts,
+		rc = tipc_mcast_xmit(net, &pkts, &tsk->mc_method, &dsts,
 				     &tsk->cong_link_cnt);
 	}
 
@@ -1479,7 +1477,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 
 	/* Determine destination */
 	if (atype == TIPC_SERVICE_RANGE) {
-		return tipc_sendmcast(sock, &ua->sr, m, dlen, timeout);
+		return tipc_sendmcast(sock, ua, m, dlen, timeout);
 	} else if (atype == TIPC_SERVICE_ADDR) {
 		skaddr.node = ua->lookup_node;
 		ua->scope = tipc_node2scope(skaddr.node);
-- 
2.29.2

