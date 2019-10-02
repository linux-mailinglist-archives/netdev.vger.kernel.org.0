Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1EA6C879B
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 13:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfJBLzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 07:55:44 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33438 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725953AbfJBLzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 07:55:44 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2019 07:55:42 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 4A8D249F52;
        Wed,  2 Oct 2019 21:49:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1570016995; bh=Zy/jw
        VqqF8uAruTADODJxStVAgbgPzDW5Cn8ul8+gIk=; b=kteW+RGw0j3SxMJioDxGu
        +BmYPch65ijNyo4JBfLng1bfn7lFYJfEHqD85ZMN3ndxYCyHFHXyBCBBAtmphrov
        Yenxrg3hY+Ge7XeNNjsr2GXtnOdQUPnz3caZvfi50CtRXHshrSf0PCUEMP8sc4CP
        jtrwFvqadYMl5p93stG+/M=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qImlf3d0cayi; Wed,  2 Oct 2019 21:49:55 +1000 (AEST)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id B25AE49F53;
        Wed,  2 Oct 2019 21:49:54 +1000 (AEST)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id A8BCF49F52;
        Wed,  2 Oct 2019 21:49:51 +1000 (AEST)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: fix unlimited bundling of small messages
Date:   Wed,  2 Oct 2019 18:49:43 +0700
Message-Id: <20191002114943.19889-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have identified a problem with the "oversubscription" policy in the
link transmission code.

When small messages are transmitted, and the sending link has reached
the transmit window limit, those messages will be bundled and put into
the link backlog queue. However, bundles of data messages are counted
at the 'CRITICAL' level, so that the counter for that level, instead of
the counter for the real, bundled message's level is the one being
increased.
Subsequent, to-be-bundled data messages at non-CRITICAL levels continue
to be tested against the unchanged counter for their own level, while
contributing to an unrestrained increase at the CRITICAL backlog level.

This leaves a gap in congestion control algorithm for small messages
that can result in starvation for other users or a "real" CRITICAL
user. Even that eventually can lead to buffer exhaustion & link reset.

We fix this by keeping a 'target_bskb' buffer pointer at each levels,
then when bundling, we only bundle messages at the same importance
level only. This way, we know exactly how many slots a certain level
have occupied in the queue, so can manage level congestion accurately.

By bundling messages at the same level, we even have more benefits. Let
consider this:
- One socket sends 64-byte messages at the 'CRITICAL' level;
- Another sends 4096-byte messages at the 'LOW' level;

When a 64-byte message comes and is bundled the first time, we put the
overhead of message bundle to it (+ 40-byte header, data copy, etc.)
for later use, but the next message can be a 4096-byte one that cannot
be bundled to the previous one. This means the last bundle carries only
one payload message which is totally inefficient, as for the receiver
also! Later on, another 64-byte message comes, now we make a new bundle
and the same story repeats...

With the new bundling algorithm, this will not happen, the 64-byte
messages will be bundled together even when the 4096-byte message(s)
comes in between. However, if the 4096-byte messages are sent at the
same level i.e. 'CRITICAL', the bundling algorithm will again cause the
same overhead.

Also, the same will happen even with only one socket sending small
messages at a rate close to the link transmit's one, so that, when one
message is bundled, it's transmitted shortly. Then, another message
comes, a new bundle is created and so on...

We will solve this issue radically by another patch.

Fixes: 365ad353c256 ("tipc: reduce risk of user starvation during link congestion")
Reported-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/link.c | 29 ++++++++++++++++++-----------
 net/tipc/msg.c  |  5 +----
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 6cc75ffd9e2c..999eab592de8 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -160,6 +160,7 @@ struct tipc_link {
 	struct {
 		u16 len;
 		u16 limit;
+		struct sk_buff *target_bskb;
 	} backlog[5];
 	u16 snd_nxt;
 	u16 window;
@@ -880,6 +881,7 @@ static void link_prepare_wakeup(struct tipc_link *l)
 void tipc_link_reset(struct tipc_link *l)
 {
 	struct sk_buff_head list;
+	u32 imp;
 
 	__skb_queue_head_init(&list);
 
@@ -901,11 +903,10 @@ void tipc_link_reset(struct tipc_link *l)
 	__skb_queue_purge(&l->deferdq);
 	__skb_queue_purge(&l->backlogq);
 	__skb_queue_purge(&l->failover_deferdq);
-	l->backlog[TIPC_LOW_IMPORTANCE].len = 0;
-	l->backlog[TIPC_MEDIUM_IMPORTANCE].len = 0;
-	l->backlog[TIPC_HIGH_IMPORTANCE].len = 0;
-	l->backlog[TIPC_CRITICAL_IMPORTANCE].len = 0;
-	l->backlog[TIPC_SYSTEM_IMPORTANCE].len = 0;
+	for (imp = 0; imp <= TIPC_SYSTEM_IMPORTANCE; imp++) {
+		l->backlog[imp].len = 0;
+		l->backlog[imp].target_bskb = NULL;
+	}
 	kfree_skb(l->reasm_buf);
 	kfree_skb(l->reasm_tnlmsg);
 	kfree_skb(l->failover_reasm_skb);
@@ -947,7 +948,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
 	struct sk_buff_head *transmq = &l->transmq;
 	struct sk_buff_head *backlogq = &l->backlogq;
-	struct sk_buff *skb, *_skb, *bskb;
+	struct sk_buff *skb, *_skb, **tskb;
 	int pkt_cnt = skb_queue_len(list);
 	int rc = 0;
 
@@ -999,19 +1000,21 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 			seqno++;
 			continue;
 		}
-		if (tipc_msg_bundle(skb_peek_tail(backlogq), hdr, mtu)) {
+		tskb = &l->backlog[imp].target_bskb;
+		if (tipc_msg_bundle(*tskb, hdr, mtu)) {
 			kfree_skb(__skb_dequeue(list));
 			l->stats.sent_bundled++;
 			continue;
 		}
-		if (tipc_msg_make_bundle(&bskb, hdr, mtu, l->addr)) {
+		if (tipc_msg_make_bundle(tskb, hdr, mtu, l->addr)) {
 			kfree_skb(__skb_dequeue(list));
-			__skb_queue_tail(backlogq, bskb);
-			l->backlog[msg_importance(buf_msg(bskb))].len++;
+			__skb_queue_tail(backlogq, *tskb);
+			l->backlog[imp].len++;
 			l->stats.sent_bundled++;
 			l->stats.sent_bundles++;
 			continue;
 		}
+		l->backlog[imp].target_bskb = NULL;
 		l->backlog[imp].len += skb_queue_len(list);
 		skb_queue_splice_tail_init(list, backlogq);
 	}
@@ -1027,6 +1030,7 @@ static void tipc_link_advance_backlog(struct tipc_link *l,
 	u16 seqno = l->snd_nxt;
 	u16 ack = l->rcv_nxt - 1;
 	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
+	u32 imp;
 
 	while (skb_queue_len(&l->transmq) < l->window) {
 		skb = skb_peek(&l->backlogq);
@@ -1037,7 +1041,10 @@ static void tipc_link_advance_backlog(struct tipc_link *l,
 			break;
 		__skb_dequeue(&l->backlogq);
 		hdr = buf_msg(skb);
-		l->backlog[msg_importance(hdr)].len--;
+		imp = msg_importance(hdr);
+		l->backlog[imp].len--;
+		if (unlikely(skb == l->backlog[imp].target_bskb))
+			l->backlog[imp].target_bskb = NULL;
 		__skb_queue_tail(&l->transmq, skb);
 		/* next retransmit attempt */
 		if (link_is_bc_sndlink(l))
diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index e6d49cdc61b4..922d262e153f 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -543,10 +543,7 @@ bool tipc_msg_make_bundle(struct sk_buff **skb,  struct tipc_msg *msg,
 	bmsg = buf_msg(_skb);
 	tipc_msg_init(msg_prevnode(msg), bmsg, MSG_BUNDLER, 0,
 		      INT_H_SIZE, dnode);
-	if (msg_isdata(msg))
-		msg_set_importance(bmsg, TIPC_CRITICAL_IMPORTANCE);
-	else
-		msg_set_importance(bmsg, TIPC_SYSTEM_IMPORTANCE);
+	msg_set_importance(bmsg, msg_importance(msg));
 	msg_set_seqno(bmsg, msg_seqno(msg));
 	msg_set_ack(bmsg, msg_ack(msg));
 	msg_set_bcast_ack(bmsg, msg_bcast_ack(msg));
-- 
2.13.7

