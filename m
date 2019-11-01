Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CA3EBC22
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 03:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfKAC7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 22:59:17 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33677 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726803AbfKAC7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 22:59:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 7C9314A893;
        Fri,  1 Nov 2019 13:59:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1572577148; bh=/2uPi
        wUxwMZTtvwUv90VrzlypiAsMCSzNzIRhjbqlDE=; b=YZh9609xUhllNmywi3J41
        ugcAeOYAognp11ObLPKN3ayxZtYXAa8k3tPf3lXNyICWsnDMa2p+w2zIavEaCQ1C
        p6nv6RnZeOv79CMfOjyoW11+ha8oXK/ujgMkmUtVlLvC3gcsIv67gwRlVnrWZSc1
        e+K/1YtEfOHgP8Tq1N4gH0=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vBYaczHVjCJc; Fri,  1 Nov 2019 13:59:08 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 9F8954A86E;
        Fri,  1 Nov 2019 13:59:07 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 3C5694A893;
        Fri,  1 Nov 2019 13:59:06 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next] tipc: improve message bundling algorithm
Date:   Fri,  1 Nov 2019 09:58:57 +0700
Message-Id: <20191101025857.27895-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As mentioned in commit e95584a889e1 ("tipc: fix unlimited bundling of
small messages"), the current message bundling algorithm is inefficient
that can generate bundles of only one payload message, that causes
unnecessary overheads for both the sender and receiver.

This commit re-designs the 'tipc_msg_make_bundle()' function (now named
as 'tipc_msg_try_bundle()'), so that when a message comes at the first
place, we will just check & keep a reference to it if the message is
suitable for bundling. The message buffer will be put into the link
backlog queue and processed as normal. Later on, when another one comes
we will make a bundle with the first message if possible and so on...
This way, a bundle if really needed will always consist of at least two
payload messages. Otherwise, we let the first buffer go its way without
any need of bundling, so reduce the overheads to zero.

Moreover, since now we have both the messages in hand, we can even
optimize the 'tipc_msg_bundle()' function, make bundle of a very large
(size ~ MSS) and small messages which is not with the current algorithm
e.g. [1400-byte message] + [10-byte message] (MTU = 1500).

Acked-by: Ying Xue <ying.xue@windreiver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/link.c |  59 +++++++++++-----------
 net/tipc/msg.c  | 153 +++++++++++++++++++++++++++++---------------------------
 net/tipc/msg.h  |   5 +-
 3 files changed, 113 insertions(+), 104 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 7d7a66178607..038861bad72b 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -940,16 +940,17 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		   struct sk_buff_head *xmitq)
 {
 	struct tipc_msg *hdr = buf_msg(skb_peek(list));
-	unsigned int maxwin = l->window;
-	int imp = msg_importance(hdr);
-	unsigned int mtu = l->mtu;
+	struct sk_buff_head *backlogq = &l->backlogq;
+	struct sk_buff_head *transmq = &l->transmq;
+	struct sk_buff *skb, *_skb;
+	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
 	u16 ack = l->rcv_nxt - 1;
 	u16 seqno = l->snd_nxt;
-	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
-	struct sk_buff_head *transmq = &l->transmq;
-	struct sk_buff_head *backlogq = &l->backlogq;
-	struct sk_buff *skb, *_skb, **tskb;
 	int pkt_cnt = skb_queue_len(list);
+	int imp = msg_importance(hdr);
+	unsigned int maxwin = l->window;
+	unsigned int mtu = l->mtu;
+	bool new_bundle;
 	int rc = 0;
 
 	if (unlikely(msg_size(hdr) > mtu)) {
@@ -975,20 +976,18 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 	}
 
 	/* Prepare each packet for sending, and add to relevant queue: */
-	while (skb_queue_len(list)) {
-		skb = skb_peek(list);
-		hdr = buf_msg(skb);
-		msg_set_seqno(hdr, seqno);
-		msg_set_ack(hdr, ack);
-		msg_set_bcast_ack(hdr, bc_ack);
-
+	while ((skb = __skb_dequeue(list))) {
 		if (likely(skb_queue_len(transmq) < maxwin)) {
+			hdr = buf_msg(skb);
+			msg_set_seqno(hdr, seqno);
+			msg_set_ack(hdr, ack);
+			msg_set_bcast_ack(hdr, bc_ack);
 			_skb = skb_clone(skb, GFP_ATOMIC);
 			if (!_skb) {
+				kfree_skb(skb);
 				__skb_queue_purge(list);
 				return -ENOBUFS;
 			}
-			__skb_dequeue(list);
 			__skb_queue_tail(transmq, skb);
 			/* next retransmit attempt */
 			if (link_is_bc_sndlink(l))
@@ -1000,22 +999,26 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 			seqno++;
 			continue;
 		}
-		tskb = &l->backlog[imp].target_bskb;
-		if (tipc_msg_bundle(*tskb, hdr, mtu)) {
-			kfree_skb(__skb_dequeue(list));
-			l->stats.sent_bundled++;
-			continue;
-		}
-		if (tipc_msg_make_bundle(tskb, hdr, mtu, l->addr)) {
-			kfree_skb(__skb_dequeue(list));
-			__skb_queue_tail(backlogq, *tskb);
-			l->backlog[imp].len++;
-			l->stats.sent_bundled++;
-			l->stats.sent_bundles++;
+		if (tipc_msg_try_bundle(l->backlog[imp].target_bskb, &skb,
+					mtu - INT_H_SIZE, l->addr,
+					&new_bundle)) {
+			if (skb) {
+				/* Keep a ref. to the skb for next try */
+				l->backlog[imp].target_bskb = skb;
+				l->backlog[imp].len++;
+				__skb_queue_tail(backlogq, skb);
+			} else {
+				if (new_bundle) {
+					l->stats.sent_bundles++;
+					l->stats.sent_bundled++;
+				}
+				l->stats.sent_bundled++;
+			}
 			continue;
 		}
 		l->backlog[imp].target_bskb = NULL;
-		l->backlog[imp].len += skb_queue_len(list);
+		l->backlog[imp].len += (1 + skb_queue_len(list));
+		__skb_queue_tail(backlogq, skb);
 		skb_queue_splice_tail_init(list, backlogq);
 	}
 	l->snd_nxt = seqno;
diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 973795a1a968..acb7be592fb1 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -472,48 +472,98 @@ int tipc_msg_build(struct tipc_msg *mhdr, struct msghdr *m, int offset,
 }
 
 /**
- * tipc_msg_bundle(): Append contents of a buffer to tail of an existing one
- * @skb: the buffer to append to ("bundle")
- * @msg:  message to be appended
- * @mtu:  max allowable size for the bundle buffer
- * Consumes buffer if successful
- * Returns true if bundling could be performed, otherwise false
+ * tipc_msg_bundle - Append contents of a buffer to tail of an existing one
+ * @bskb: the bundle buffer to append to
+ * @msg: message to be appended
+ * @max: max allowable size for the bundle buffer
+ *
+ * Returns "true" if bundling has been performed, otherwise "false"
  */
-bool tipc_msg_bundle(struct sk_buff *skb, struct tipc_msg *msg, u32 mtu)
+static bool tipc_msg_bundle(struct sk_buff *bskb, struct tipc_msg *msg,
+			    u32 max)
 {
-	struct tipc_msg *bmsg;
-	unsigned int bsz;
-	unsigned int msz = msg_size(msg);
-	u32 start, pad;
-	u32 max = mtu - INT_H_SIZE;
+	struct tipc_msg *bmsg = buf_msg(bskb);
+	u32 msz, bsz, offset, pad;
 
-	if (likely(msg_user(msg) == MSG_FRAGMENTER))
-		return false;
-	if (!skb)
-		return false;
-	bmsg = buf_msg(skb);
+	msz = msg_size(msg);
 	bsz = msg_size(bmsg);
-	start = align(bsz);
-	pad = start - bsz;
+	offset = align(bsz);
+	pad = offset - bsz;
 
-	if (unlikely(msg_user(msg) == TUNNEL_PROTOCOL))
+	if (unlikely(skb_tailroom(bskb) < (pad + msz)))
 		return false;
-	if (unlikely(msg_user(msg) == BCAST_PROTOCOL))
+	if (unlikely(max < (offset + msz)))
 		return false;
-	if (unlikely(msg_user(bmsg) != MSG_BUNDLER))
+
+	skb_put(bskb, pad + msz);
+	skb_copy_to_linear_data_offset(bskb, offset, msg, msz);
+	msg_set_size(bmsg, offset + msz);
+	msg_set_msgcnt(bmsg, msg_msgcnt(bmsg) + 1);
+	return true;
+}
+
+/**
+ * tipc_msg_try_bundle - Try to bundle a new message to the last one
+ * @tskb: the last/target message to which the new one will be appended
+ * @skb: the new message skb pointer
+ * @mss: max message size (header inclusive)
+ * @dnode: destination node for the message
+ * @new_bundle: if this call made a new bundle or not
+ *
+ * Return: "true" if the new message skb is potential for bundling this time or
+ * later, in the case a bundling has been done this time, the skb is consumed
+ * (the skb pointer = NULL).
+ * Otherwise, "false" if the skb cannot be bundled at all.
+ */
+bool tipc_msg_try_bundle(struct sk_buff *tskb, struct sk_buff **skb, u32 mss,
+			 u32 dnode, bool *new_bundle)
+{
+	struct tipc_msg *msg, *inner, *outer;
+	u32 tsz;
+
+	/* First, check if the new buffer is suitable for bundling */
+	msg = buf_msg(*skb);
+	if (msg_user(msg) == MSG_FRAGMENTER)
 		return false;
-	if (unlikely(skb_tailroom(skb) < (pad + msz)))
+	if (msg_user(msg) == TUNNEL_PROTOCOL)
 		return false;
-	if (unlikely(max < (start + msz)))
+	if (msg_user(msg) == BCAST_PROTOCOL)
 		return false;
-	if ((msg_importance(msg) < TIPC_SYSTEM_IMPORTANCE) &&
-	    (msg_importance(bmsg) == TIPC_SYSTEM_IMPORTANCE))
+	if (mss <= INT_H_SIZE + msg_size(msg))
 		return false;
 
-	skb_put(skb, pad + msz);
-	skb_copy_to_linear_data_offset(skb, start, msg, msz);
-	msg_set_size(bmsg, start + msz);
-	msg_set_msgcnt(bmsg, msg_msgcnt(bmsg) + 1);
+	/* Ok, but the last/target buffer can be empty? */
+	if (unlikely(!tskb))
+		return true;
+
+	/* Is it a bundle already? Try to bundle the new message to it */
+	if (msg_user(buf_msg(tskb)) == MSG_BUNDLER) {
+		*new_bundle = false;
+		goto bundle;
+	}
+
+	/* Make a new bundle of the two messages if possible */
+	tsz = msg_size(buf_msg(tskb));
+	if (unlikely(mss < align(INT_H_SIZE + tsz) + msg_size(msg)))
+		return true;
+	if (unlikely(pskb_expand_head(tskb, INT_H_SIZE, mss - tsz - INT_H_SIZE,
+				      GFP_ATOMIC)))
+		return true;
+	inner = buf_msg(tskb);
+	skb_push(tskb, INT_H_SIZE);
+	outer = buf_msg(tskb);
+	tipc_msg_init(msg_prevnode(inner), outer, MSG_BUNDLER, 0, INT_H_SIZE,
+		      dnode);
+	msg_set_importance(outer, msg_importance(inner));
+	msg_set_size(outer, INT_H_SIZE + tsz);
+	msg_set_msgcnt(outer, 1);
+	*new_bundle = true;
+
+bundle:
+	if (likely(tipc_msg_bundle(tskb, msg, mss))) {
+		consume_skb(*skb);
+		*skb = NULL;
+	}
 	return true;
 }
 
@@ -563,49 +613,6 @@ bool tipc_msg_extract(struct sk_buff *skb, struct sk_buff **iskb, int *pos)
 }
 
 /**
- * tipc_msg_make_bundle(): Create bundle buf and append message to its tail
- * @list: the buffer chain, where head is the buffer to replace/append
- * @skb: buffer to be created, appended to and returned in case of success
- * @msg: message to be appended
- * @mtu: max allowable size for the bundle buffer, inclusive header
- * @dnode: destination node for message. (Not always present in header)
- * Returns true if success, otherwise false
- */
-bool tipc_msg_make_bundle(struct sk_buff **skb,  struct tipc_msg *msg,
-			  u32 mtu, u32 dnode)
-{
-	struct sk_buff *_skb;
-	struct tipc_msg *bmsg;
-	u32 msz = msg_size(msg);
-	u32 max = mtu - INT_H_SIZE;
-
-	if (msg_user(msg) == MSG_FRAGMENTER)
-		return false;
-	if (msg_user(msg) == TUNNEL_PROTOCOL)
-		return false;
-	if (msg_user(msg) == BCAST_PROTOCOL)
-		return false;
-	if (msz > (max / 2))
-		return false;
-
-	_skb = tipc_buf_acquire(max, GFP_ATOMIC);
-	if (!_skb)
-		return false;
-
-	skb_trim(_skb, INT_H_SIZE);
-	bmsg = buf_msg(_skb);
-	tipc_msg_init(msg_prevnode(msg), bmsg, MSG_BUNDLER, 0,
-		      INT_H_SIZE, dnode);
-	msg_set_importance(bmsg, msg_importance(msg));
-	msg_set_seqno(bmsg, msg_seqno(msg));
-	msg_set_ack(bmsg, msg_ack(msg));
-	msg_set_bcast_ack(bmsg, msg_bcast_ack(msg));
-	tipc_msg_bundle(_skb, msg, mtu);
-	*skb = _skb;
-	return true;
-}
-
-/**
  * tipc_msg_reverse(): swap source and destination addresses and add error code
  * @own_node: originating node id for reversed message
  * @skb:  buffer containing message to be reversed; will be consumed
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 0435dda4b90c..14697e6c995e 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -1081,9 +1081,8 @@ struct sk_buff *tipc_msg_create(uint user, uint type, uint hdr_sz,
 				uint data_sz, u32 dnode, u32 onode,
 				u32 dport, u32 oport, int errcode);
 int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf);
-bool tipc_msg_bundle(struct sk_buff *skb, struct tipc_msg *msg, u32 mtu);
-bool tipc_msg_make_bundle(struct sk_buff **skb, struct tipc_msg *msg,
-			  u32 mtu, u32 dnode);
+bool tipc_msg_try_bundle(struct sk_buff *tskb, struct sk_buff **skb, u32 mss,
+			 u32 dnode, bool *new_bundle);
 bool tipc_msg_extract(struct sk_buff *skb, struct sk_buff **iskb, int *pos);
 int tipc_msg_fragment(struct sk_buff *skb, const struct tipc_msg *hdr,
 		      int pktmax, struct sk_buff_head *frags);
-- 
2.13.7

