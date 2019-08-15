Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F3D8EE82
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733088AbfHOOnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:43:00 -0400
Received: from sesbmg22.ericsson.net ([193.180.251.48]:62886 "EHLO
        sesbmg22.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729838AbfHOOm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=ericsson.com; s=mailgw201801; c=relaxed/relaxed;
        q=dns/txt; i=@ericsson.com; t=1565880175; x=1568472175;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=w/fCRtwfLG13C00NiWEktzL8MnokYUe/yMnEbsiUmWU=;
        b=U655l7SD5FP1DNueW4+3nUKNakhOQ/fCVXPoio+VPDSz2eLH5lh99YXS85/fLtgD
        EIgRahUZkR208rCLcv+W64wuP3p51kzTwky9jc4cN7QS/1mV11DzVAP/CBkvS1T6
        5f7Y45lkAqNE4jPayg0lDBBN04L0YYEKqVi0+NlvCyI=;
X-AuditID: c1b4fb30-b65059e000001814-84-5d556f6feb87
Received: from ESESBMB501.ericsson.se (Unknown_Domain [153.88.183.114])
        by sesbmg22.ericsson.net (Symantec Mail Security) with SMTP id 62.26.06164.F6F655D5; Thu, 15 Aug 2019 16:42:55 +0200 (CEST)
Received: from ESESBMR501.ericsson.se (153.88.183.129) by
 ESESBMB501.ericsson.se (153.88.183.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 15 Aug 2019 16:42:50 +0200
Received: from ESESBMB504.ericsson.se (153.88.183.171) by
 ESESBMR501.ericsson.se (153.88.183.129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 15 Aug 2019 16:42:50 +0200
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.187) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Thu, 15 Aug 2019 16:42:50 +0200
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <tung.q.nguyen@dektech.com.au>, <hoang.h.le@dektech.com.au>,
        <jon.maloy@ericsson.com>, <lxin@redhat.com>, <shuali@redhat.com>,
        <ying.xue@windriver.com>, <edumazet@google.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next v2 1/1] tipc: clean up skb list lock handling on send path
Date:   Thu, 15 Aug 2019 16:42:50 +0200
Message-ID: <1565880170-19548-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsUyM2J7kW5+fmisQd8Efos551tYLJ4ee8Ru
        8fbVLHaL5VfesFgcWyBmMXXdSmaLLeezLK60n2W3eHz9OrMDp8eWlTeZPN5dYfNYsKnUY/eC
        z0we7/ddZfP4vEnOY/2WrUwB7FFcNimpOZllqUX6dglcGZe/TmMsuBpYcX1XVgNjv3MXIyeH
        hICJxNlHjxm7GLk4hASOMkpM3LoIyvnGKNH7vIkdznnQ0MMM4VxglPj5Yx0bSD+bgIbEy2kd
        jCC2iICxxKuVnUwgRcwCDxkl/r+7yQSSEBbwlZg/+R9YEYuAqsTeox/AmnkF3CSarj1mgzhE
        TuL88Z/MEHFBiZMzn7CA2MwCmhKt23+zQ9jyEs1bZ4PVCAkoS8z9MI1pAqPALCQts5C0zELS
        soCReRWjaHFqcVJuupGRXmpRZnJxcX6eXl5qySZGYCwc3PLbYAfjy+eOhxgFOBiVeHjfbhGP
        FWJNLCuuzD3EKMHBrCTCK3lOJFaINyWxsiq1KD++qDQntfgQozQHi5I473rvfzFCAumJJanZ
        qakFqUUwWSYOTqkGxvYTEx8053zWWK220Xbunb05VyVTPybO6Lubt/u/8JuYHdG+J7LXm9XX
        P7jQuUf5lsqyVe/u829ROSgtXjrlxLwlTs6rW+IntT79GvuyUf1fSH9B0rwf2plxwZa3fK7u
        l7WcduLFjtytLDwVT1VOPvO58j44QsH0nh9P8LG1a85b32p7x3DoF7sSS3FGoqEWc1FxIgAs
        gvSAgQIAAA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The policy for handling the skb list locks on the send and receive paths
is simple.

- On the send path we never need to grab the lock on the 'xmitq' list
  when the destination is an exernal node.

- On the receive path we always need to grab the lock on the 'inputq'
  list, irrespective of source node.

However, when transmitting node local messages those will eventually
end up on the receive path of a local socket, meaning that the argument
'xmitq' in tipc_node_xmit() will become the 'ínputq' argument in  the
function tipc_sk_rcv(). This has been handled by always initializing
the spinlock of the 'xmitq' list at message creation, just in case it
may end up on the receive path later, and despite knowing that the lock
in most cases never will be used.

This approach is inaccurate and confusing, and has also concealed the
fact that the stated 'no lock grabbing' policy for the send path is
violated in some cases.

We now clean up this by never initializing the lock at message creation,
instead doing this at the moment we find that the message actually will
enter the receive path. At the same time we fix the four locations
where we incorrectly access the spinlock on the send/error path.

This patch also reverts commit d12cffe9329f ("tipc: ensure head->lock
is initialised") which has now become redundant.

CC: Eric Dumazet <edumazet@google.com>
Reported-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

---
v2: removed more unnecessary lock initializations after feedback
    from Xin Long.
---
 net/tipc/bcast.c      | 10 +++++-----
 net/tipc/group.c      |  4 ++--
 net/tipc/link.c       | 14 +++++++-------
 net/tipc/name_distr.c |  2 +-
 net/tipc/node.c       |  7 ++++---
 net/tipc/socket.c     | 14 +++++++-------
 6 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 34f3e56..6ef1abd 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -185,7 +185,7 @@ static void tipc_bcbase_xmit(struct net *net, struct sk_buff_head *xmitq)
 	}
 
 	/* We have to transmit across all bearers */
-	skb_queue_head_init(&_xmitq);
+	__skb_queue_head_init(&_xmitq);
 	for (bearer_id = 0; bearer_id < MAX_BEARERS; bearer_id++) {
 		if (!bb->dests[bearer_id])
 			continue;
@@ -256,7 +256,7 @@ static int tipc_bcast_xmit(struct net *net, struct sk_buff_head *pkts,
 	struct sk_buff_head xmitq;
 	int rc = 0;
 
-	skb_queue_head_init(&xmitq);
+	__skb_queue_head_init(&xmitq);
 	tipc_bcast_lock(net);
 	if (tipc_link_bc_peers(l))
 		rc = tipc_link_xmit(l, pkts, &xmitq);
@@ -286,7 +286,7 @@ static int tipc_rcast_xmit(struct net *net, struct sk_buff_head *pkts,
 	u32 dnode, selector;
 
 	selector = msg_link_selector(buf_msg(skb_peek(pkts)));
-	skb_queue_head_init(&_pkts);
+	__skb_queue_head_init(&_pkts);
 
 	list_for_each_entry_safe(dst, tmp, &dests->list, list) {
 		dnode = dst->node;
@@ -344,7 +344,7 @@ static int tipc_mcast_send_sync(struct net *net, struct sk_buff *skb,
 	msg_set_size(_hdr, MCAST_H_SIZE);
 	msg_set_is_rcast(_hdr, !msg_is_rcast(hdr));
 
-	skb_queue_head_init(&tmpq);
+	__skb_queue_head_init(&tmpq);
 	__skb_queue_tail(&tmpq, _skb);
 	if (method->rcast)
 		tipc_bcast_xmit(net, &tmpq, cong_link_cnt);
@@ -378,7 +378,7 @@ int tipc_mcast_xmit(struct net *net, struct sk_buff_head *pkts,
 	int rc = 0;
 
 	skb_queue_head_init(&inputq);
-	skb_queue_head_init(&localq);
+	__skb_queue_head_init(&localq);
 
 	/* Clone packets before they are consumed by next call */
 	if (dests->local && !tipc_msg_reassemble(pkts, &localq)) {
diff --git a/net/tipc/group.c b/net/tipc/group.c
index 5f98d38..89257e2 100644
--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -199,7 +199,7 @@ void tipc_group_join(struct net *net, struct tipc_group *grp, int *sk_rcvbuf)
 	struct tipc_member *m, *tmp;
 	struct sk_buff_head xmitq;
 
-	skb_queue_head_init(&xmitq);
+	__skb_queue_head_init(&xmitq);
 	rbtree_postorder_for_each_entry_safe(m, tmp, tree, tree_node) {
 		tipc_group_proto_xmit(grp, m, GRP_JOIN_MSG, &xmitq);
 		tipc_group_update_member(m, 0);
@@ -435,7 +435,7 @@ bool tipc_group_cong(struct tipc_group *grp, u32 dnode, u32 dport,
 		return true;
 	if (state == MBR_PENDING && adv == ADV_IDLE)
 		return true;
-	skb_queue_head_init(&xmitq);
+	__skb_queue_head_init(&xmitq);
 	tipc_group_proto_xmit(grp, m, GRP_ADV_MSG, &xmitq);
 	tipc_node_distr_xmit(grp->net, &xmitq);
 	return true;
diff --git a/net/tipc/link.c b/net/tipc/link.c
index dd3155b..289e848 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -959,7 +959,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		pr_warn("Too large msg, purging xmit list %d %d %d %d %d!\n",
 			skb_queue_len(list), msg_user(hdr),
 			msg_type(hdr), msg_size(hdr), mtu);
-		skb_queue_purge(list);
+		__skb_queue_purge(list);
 		return -EMSGSIZE;
 	}
 
@@ -988,7 +988,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		if (likely(skb_queue_len(transmq) < maxwin)) {
 			_skb = skb_clone(skb, GFP_ATOMIC);
 			if (!_skb) {
-				skb_queue_purge(list);
+				__skb_queue_purge(list);
 				return -ENOBUFS;
 			}
 			__skb_dequeue(list);
@@ -1668,7 +1668,7 @@ void tipc_link_create_dummy_tnl_msg(struct tipc_link *l,
 	struct sk_buff *skb;
 	u32 dnode = l->addr;
 
-	skb_queue_head_init(&tnlq);
+	__skb_queue_head_init(&tnlq);
 	skb = tipc_msg_create(TUNNEL_PROTOCOL, FAILOVER_MSG,
 			      INT_H_SIZE, BASIC_H_SIZE,
 			      dnode, onode, 0, 0, 0);
@@ -1708,9 +1708,9 @@ void tipc_link_tnl_prepare(struct tipc_link *l, struct tipc_link *tnl,
 	if (!tnl)
 		return;
 
-	skb_queue_head_init(&tnlq);
-	skb_queue_head_init(&tmpxq);
-	skb_queue_head_init(&frags);
+	__skb_queue_head_init(&tnlq);
+	__skb_queue_head_init(&tmpxq);
+	__skb_queue_head_init(&frags);
 
 	/* At least one packet required for safe algorithm => add dummy */
 	skb = tipc_msg_create(TIPC_LOW_IMPORTANCE, TIPC_DIRECT_MSG,
@@ -1720,7 +1720,7 @@ void tipc_link_tnl_prepare(struct tipc_link *l, struct tipc_link *tnl,
 		pr_warn("%sunable to create tunnel packet\n", link_co_err);
 		return;
 	}
-	skb_queue_tail(&tnlq, skb);
+	__skb_queue_tail(&tnlq, skb);
 	tipc_link_xmit(l, &tnlq, &tmpxq);
 	__skb_queue_purge(&tmpxq);
 
diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 44abc8e..61219f0 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -190,7 +190,7 @@ void tipc_named_node_up(struct net *net, u32 dnode)
 	struct name_table *nt = tipc_name_table(net);
 	struct sk_buff_head head;
 
-	skb_queue_head_init(&head);
+	__skb_queue_head_init(&head);
 
 	read_lock_bh(&nt->cluster_scope_lock);
 	named_distribute(net, &head, dnode, &nt->cluster_scope);
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 1bdcf0f..c8f6177 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1444,13 +1444,14 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 
 	if (in_own_node(net, dnode)) {
 		tipc_loopback_trace(net, list);
+		spin_lock_init(&list->lock);
 		tipc_sk_rcv(net, list);
 		return 0;
 	}
 
 	n = tipc_node_find(net, dnode);
 	if (unlikely(!n)) {
-		skb_queue_purge(list);
+		__skb_queue_purge(list);
 		return -EHOSTUNREACH;
 	}
 
@@ -1459,7 +1460,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 	if (unlikely(bearer_id == INVALID_BEARER_ID)) {
 		tipc_node_read_unlock(n);
 		tipc_node_put(n);
-		skb_queue_purge(list);
+		__skb_queue_purge(list);
 		return -EHOSTUNREACH;
 	}
 
@@ -1491,7 +1492,7 @@ int tipc_node_xmit_skb(struct net *net, struct sk_buff *skb, u32 dnode,
 {
 	struct sk_buff_head head;
 
-	skb_queue_head_init(&head);
+	__skb_queue_head_init(&head);
 	__skb_queue_tail(&head, skb);
 	tipc_node_xmit(net, &head, dnode, selector);
 	return 0;
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 83ae41d..3b9f8cc 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -809,7 +809,7 @@ static int tipc_sendmcast(struct  socket *sock, struct tipc_name_seq *seq,
 	msg_set_nameupper(hdr, seq->upper);
 
 	/* Build message as chain of buffers */
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 	rc = tipc_msg_build(hdr, msg, 0, dlen, mtu, &pkts);
 
 	/* Send message if build was successful */
@@ -853,7 +853,7 @@ static int tipc_send_group_msg(struct net *net, struct tipc_sock *tsk,
 	msg_set_grp_bc_seqno(hdr, bc_snd_nxt);
 
 	/* Build message as chain of buffers */
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 	mtu = tipc_node_get_mtu(net, dnode, tsk->portid);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
@@ -1058,7 +1058,7 @@ static int tipc_send_group_bcast(struct socket *sock, struct msghdr *m,
 	msg_set_grp_bc_ack_req(hdr, ack);
 
 	/* Build message as chain of buffers */
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;
@@ -1387,7 +1387,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	if (unlikely(rc))
 		return rc;
 
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 	mtu = tipc_node_get_mtu(net, dnode, tsk->portid);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
@@ -1445,7 +1445,7 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 	int send, sent = 0;
 	int rc = 0;
 
-	skb_queue_head_init(&pkts);
+	__skb_queue_head_init(&pkts);
 
 	if (unlikely(dlen > INT_MAX))
 		return -EMSGSIZE;
@@ -1805,7 +1805,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 
 	/* Send group flow control advertisement when applicable */
 	if (tsk->group && msg_in_group(hdr) && !grp_evt) {
-		skb_queue_head_init(&xmitq);
+		__skb_queue_head_init(&xmitq);
 		tipc_group_update_rcv_win(tsk->group, tsk_blocks(hlen + dlen),
 					  msg_orignode(hdr), msg_origport(hdr),
 					  &xmitq);
@@ -2674,7 +2674,7 @@ static void tipc_sk_timeout(struct timer_list *t)
 	struct sk_buff_head list;
 	int rc = 0;
 
-	skb_queue_head_init(&list);
+	__skb_queue_head_init(&list);
 	bh_lock_sock(sk);
 
 	/* Try again later if socket is busy */
-- 
2.1.4

