Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF48D8D6B6
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfHNOzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:55:54 -0400
Received: from sesbmg23.ericsson.net ([193.180.251.37]:63255 "EHLO
        sesbmg23.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfHNOzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:55:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=ericsson.com; s=mailgw201801; c=relaxed/relaxed;
        q=dns/txt; i=@ericsson.com; t=1565794549; x=1568386549;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tE4jXGoolxxZG68iO4b5Ylcl6BlZL/b752Of/CzDD9A=;
        b=RdDan8qM/1yIzFpAu8WD1z98sYELbVV4Ij6wKEGE5qxdO3YL13JAWg55k/rIzyyO
        IKj7gUoYeqcfNiro4zNiixVMzC6l8RT2V12oYfQHSPxCqTSoAhsgOpZmblY+R/PA
        a38YqqHW1EvVIpFZen+kW28s+9KuNEb40e6obD7v4OA=;
X-AuditID: c1b4fb25-399ff700000029f0-b9-5d5420f5ab11
Received: from ESESSMB502.ericsson.se (Unknown_Domain [153.88.183.120])
        by sesbmg23.ericsson.net (Symantec Mail Security) with SMTP id 48.DC.10736.5F0245D5; Wed, 14 Aug 2019 16:55:49 +0200 (CEST)
Received: from ESESBMR503.ericsson.se (153.88.183.135) by
 ESESSMB502.ericsson.se (153.88.183.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 14 Aug 2019 16:55:49 +0200
Received: from ESESBMB502.ericsson.se (153.88.183.169) by
 ESESBMR503.ericsson.se (153.88.183.135) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 14 Aug 2019 16:55:49 +0200
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.185) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 14 Aug 2019 16:55:48 +0200
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <tung.q.nguyen@dektech.com.au>, <hoang.h.le@dektech.com.au>,
        <jon.maloy@ericsson.com>, <lxin@redhat.com>, <shuali@redhat.com>,
        <ying.xue@windriver.com>, <edumazet@google.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next  1/1] tipc: clean up skb list lock handling on send path
Date:   Wed, 14 Aug 2019 16:55:48 +0200
Message-ID: <1565794548-15425-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsUyM2J7he5XhZBYg0fT1SzmnG9hsXh67BG7
        xdtXs9gtll95w2JxbIGYxdR1K5kttpzPsrjSfpbd4vH168wOnB5bVt5k8nh3hc1jwaZSj90L
        PjN5vN93lc3j8yY5j/VbtjIFsEdx2aSk5mSWpRbp2yVwZWw8tJy1YKVjxZLrF1kbGA+bdjFy
        ckgImEjMXvyRqYuRi0NI4CijxKxfC9ghnG+MEu+enmaBc5qbHzBDOBcYJXaeX88I0s8moCHx
        cloHmC0iYCzxamUn2CxmgYeMEv/f3WQCSQgLeEt8vfgXrIhFQFXi0eGvLCA2r4CbxKl/W1kg
        DpGTOH/8JzNEXFDi5MwnYHFmAU2J1u2/2SFseYnmrbPBaoQElCXmfpjGNIFRYBaSlllIWmYh
        aVnAyLyKUbQ4tTgpN93IWC+1KDO5uDg/Ty8vtWQTIzAaDm75rbqD8fIbx0OMAhyMSjy8a7aK
        xwqxJpYVV+YeYpTgYFYS4ZU8JxIrxJuSWFmVWpQfX1Sak1p8iFGag0VJnHe9978YIYH0xJLU
        7NTUgtQimCwTB6dUA2NadsjpIPUTxaqsrVb154yXVE5WmZZwmi/sxS2b0pVJW8O9hdZdfL4u
        Pmn61XVLPNN40o8d+CKzyTP48zG/+mXxq5+Uhs/jSznpxHzp0rwJqorbtHu0PGOvKhcv219Y
        EHqEt137cZfw3ksFetespH375AzEztx8ULNG9KoV5xOnmQf5AyqXJyixFGckGmoxFxUnAgA+
        LVU5ggIAAA==
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
 net/tipc/bcast.c      | 10 +++++-----
 net/tipc/link.c       |  4 ++--
 net/tipc/name_distr.c |  2 +-
 net/tipc/node.c       |  7 ++++---
 net/tipc/socket.c     | 14 +++++++-------
 5 files changed, 19 insertions(+), 18 deletions(-)

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
diff --git a/net/tipc/link.c b/net/tipc/link.c
index dd3155b..ba057a9 100644
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

