Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE658E323
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 05:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfHODYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 23:24:25 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:37556 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727742AbfHODYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 23:24:24 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id C579E48B0E;
        Thu, 15 Aug 2019 13:24:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1565839458; bh=8cvFm
        84/ezNCAilIO1tC2R2KKF5/UuGnsA6N+Q5RlIg=; b=MXS1BT+f1vjDthyVkFhX2
        QFcE/SMNGs/l2GSc2A0tMMbsLVoXjkLVi1DsX41mD3wwifwWDP/dn4QQEdkfiFWu
        05uaQGVL39CSG7lYRWzbmz0pO00aFYxlyZk+s97ld9xAzjNq3k6bGyEGeGygY/ov
        zCDSyjJnlYHpNtm0A0++zs=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id B9QhWUaj6h7O; Thu, 15 Aug 2019 13:24:18 +1000 (AEST)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 32F0B48B20;
        Thu, 15 Aug 2019 13:24:17 +1000 (AEST)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 8D37D48B0E;
        Thu, 15 Aug 2019 13:24:15 +1000 (AEST)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: fix false detection of retransmit failures
Date:   Thu, 15 Aug 2019 10:24:08 +0700
Message-Id: <20190815032408.7287-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit eliminates the use of the link 'stale_limit' & 'prev_from'
(besides the already removed - 'stale_cnt') variables in the detection
of repeated retransmit failures as there is no proper way to initialize
them to avoid a false detection, i.e. it is not really a retransmission
failure but due to a garbage values in the variables.

Instead, a jiffies variable will be added to individual skbs (like the
way we restrict the skb retransmissions) in order to mark the first skb
retransmit time. Later on, at the next retransmissions, the timestamp
will be checked to see if the skb in the link transmq is "too stale",
that is, the link tolerance time has passed, so that a link reset will
be ordered. Note, just checking on the first skb in the queue is fine
enough since it must be the oldest one.
A counter is also added to keep track the actual skb retransmissions'
number for later checking when the failure happens.

The downside of this approach is that the skb->cb[] buffer is about to
be exhausted, however it is always able to allocate another memory area
and keep a reference to it when needed.

Fixes: 77cf8edbc0e7 ("tipc: simplify stale link failure criteria")
Reported-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/link.c | 92 ++++++++++++++++++++++++++++++++-------------------------
 net/tipc/msg.h  |  8 +++--
 2 files changed, 57 insertions(+), 43 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index dd3155b14654..01d76bf16e9d 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -106,8 +106,6 @@ struct tipc_stats {
  * @transmitq: queue for sent, non-acked messages
  * @backlogq: queue for messages waiting to be sent
  * @snt_nxt: next sequence number to use for outbound messages
- * @prev_from: sequence number of most previous retransmission request
- * @stale_limit: time when repeated identical retransmits must force link reset
  * @ackers: # of peers that needs to ack each packet before it can be released
  * @acked: # last packet acked by a certain peer. Used for broadcast.
  * @rcv_nxt: next sequence number to expect for inbound messages
@@ -164,9 +162,7 @@ struct tipc_link {
 		u16 limit;
 	} backlog[5];
 	u16 snd_nxt;
-	u16 prev_from;
 	u16 window;
-	unsigned long stale_limit;
 
 	/* Reception */
 	u16 rcv_nxt;
@@ -1063,47 +1059,53 @@ static void tipc_link_advance_backlog(struct tipc_link *l,
  * link_retransmit_failure() - Detect repeated retransmit failures
  * @l: tipc link sender
  * @r: tipc link receiver (= l in case of unicast)
- * @from: seqno of the 1st packet in retransmit request
  * @rc: returned code
  *
  * Return: true if the repeated retransmit failures happens, otherwise
  * false
  */
 static bool link_retransmit_failure(struct tipc_link *l, struct tipc_link *r,
-				    u16 from, int *rc)
+				    int *rc)
 {
 	struct sk_buff *skb = skb_peek(&l->transmq);
 	struct tipc_msg *hdr;
 
 	if (!skb)
 		return false;
-	hdr = buf_msg(skb);
 
-	/* Detect repeated retransmit failures on same packet */
-	if (r->prev_from != from) {
-		r->prev_from = from;
-		r->stale_limit = jiffies + msecs_to_jiffies(r->tolerance);
-	} else if (time_after(jiffies, r->stale_limit)) {
-		pr_warn("Retransmission failure on link <%s>\n", l->name);
-		link_print(l, "State of link ");
-		pr_info("Failed msg: usr %u, typ %u, len %u, err %u\n",
-			msg_user(hdr), msg_type(hdr), msg_size(hdr),
-			msg_errcode(hdr));
-		pr_info("sqno %u, prev: %x, src: %x\n",
-			msg_seqno(hdr), msg_prevnode(hdr), msg_orignode(hdr));
-
-		trace_tipc_list_dump(&l->transmq, true, "retrans failure!");
-		trace_tipc_link_dump(l, TIPC_DUMP_NONE, "retrans failure!");
-		trace_tipc_link_dump(r, TIPC_DUMP_NONE, "retrans failure!");
+	if (!TIPC_SKB_CB(skb)->retr_cnt)
+		return false;
 
-		if (link_is_bc_sndlink(l))
-			*rc = TIPC_LINK_DOWN_EVT;
+	if (!time_after(jiffies, TIPC_SKB_CB(skb)->retr_stamp +
+			msecs_to_jiffies(r->tolerance)))
+		return false;
+
+	hdr = buf_msg(skb);
+	if (link_is_bc_sndlink(l) && !less(r->acked, msg_seqno(hdr)))
+		return false;
 
+	pr_warn("Retransmission failure on link <%s>\n", l->name);
+	link_print(l, "State of link ");
+	pr_info("Failed msg: usr %u, typ %u, len %u, err %u\n",
+		msg_user(hdr), msg_type(hdr), msg_size(hdr), msg_errcode(hdr));
+	pr_info("sqno %u, prev: %x, dest: %x\n",
+		msg_seqno(hdr), msg_prevnode(hdr), msg_destnode(hdr));
+	pr_info("retr_stamp %d, retr_cnt %d\n",
+		jiffies_to_msecs(TIPC_SKB_CB(skb)->retr_stamp),
+		TIPC_SKB_CB(skb)->retr_cnt);
+
+	trace_tipc_list_dump(&l->transmq, true, "retrans failure!");
+	trace_tipc_link_dump(l, TIPC_DUMP_NONE, "retrans failure!");
+	trace_tipc_link_dump(r, TIPC_DUMP_NONE, "retrans failure!");
+
+	if (link_is_bc_sndlink(l)) {
+		r->state = LINK_RESET;
+		*rc = TIPC_LINK_DOWN_EVT;
+	} else {
 		*rc = tipc_link_fsm_evt(l, LINK_FAILURE_EVT);
-		return true;
 	}
 
-	return false;
+	return true;
 }
 
 /* tipc_link_bc_retrans() - retransmit zero or more packets
@@ -1129,7 +1131,7 @@ static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
 
 	trace_tipc_link_retrans(r, from, to, &l->transmq);
 
-	if (link_retransmit_failure(l, r, from, &rc))
+	if (link_retransmit_failure(l, r, &rc))
 		return rc;
 
 	skb_queue_walk(&l->transmq, skb) {
@@ -1138,11 +1140,10 @@ static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
 			continue;
 		if (more(msg_seqno(hdr), to))
 			break;
-		if (link_is_bc_sndlink(l)) {
-			if (time_before(jiffies, TIPC_SKB_CB(skb)->nxt_retr))
-				continue;
-			TIPC_SKB_CB(skb)->nxt_retr = TIPC_BC_RETR_LIM;
-		}
+
+		if (time_before(jiffies, TIPC_SKB_CB(skb)->nxt_retr))
+			continue;
+		TIPC_SKB_CB(skb)->nxt_retr = TIPC_BC_RETR_LIM;
 		_skb = __pskb_copy(skb, LL_MAX_HEADER + MIN_H_SIZE, GFP_ATOMIC);
 		if (!_skb)
 			return 0;
@@ -1152,6 +1153,10 @@ static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
 		_skb->priority = TC_PRIO_CONTROL;
 		__skb_queue_tail(xmitq, _skb);
 		l->stats.retransmitted++;
+
+		/* Increase actual retrans counter & mark first time */
+		if (!TIPC_SKB_CB(skb)->retr_cnt++)
+			TIPC_SKB_CB(skb)->retr_stamp = jiffies;
 	}
 	return 0;
 }
@@ -1393,12 +1398,10 @@ static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 	struct tipc_msg *hdr;
 	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
 	u16 ack = l->rcv_nxt - 1;
+	bool passed = false;
 	u16 seqno, n = 0;
 	int rc = 0;
 
-	if (gap && link_retransmit_failure(l, l, acked + 1, &rc))
-		return rc;
-
 	skb_queue_walk_safe(&l->transmq, skb, tmp) {
 		seqno = buf_seqno(skb);
 
@@ -1408,12 +1411,17 @@ static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 			__skb_unlink(skb, &l->transmq);
 			kfree_skb(skb);
 		} else if (less_eq(seqno, acked + gap)) {
-			/* retransmit skb */
+			/* First, check if repeated retrans failures occurs? */
+			if (!passed && link_retransmit_failure(l, l, &rc))
+				return rc;
+			passed = true;
+
+			/* retransmit skb if unrestricted*/
 			if (time_before(jiffies, TIPC_SKB_CB(skb)->nxt_retr))
 				continue;
 			TIPC_SKB_CB(skb)->nxt_retr = TIPC_UC_RETR_TIME;
-
-			_skb = __pskb_copy(skb, MIN_H_SIZE, GFP_ATOMIC);
+			_skb = __pskb_copy(skb, LL_MAX_HEADER + MIN_H_SIZE,
+					   GFP_ATOMIC);
 			if (!_skb)
 				continue;
 			hdr = buf_msg(_skb);
@@ -1422,6 +1430,10 @@ static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 			_skb->priority = TC_PRIO_CONTROL;
 			__skb_queue_tail(xmitq, _skb);
 			l->stats.retransmitted++;
+
+			/* Increase actual retrans counter & mark first time */
+			if (!TIPC_SKB_CB(skb)->retr_cnt++)
+				TIPC_SKB_CB(skb)->retr_stamp = jiffies;
 		} else {
 			/* retry with Gap ACK blocks if any */
 			if (!ga || n >= ga->gack_cnt)
@@ -2681,7 +2693,7 @@ int tipc_link_dump(struct tipc_link *l, u16 dqueues, char *buf)
 	i += scnprintf(buf + i, sz - i, " %x", l->peer_caps);
 	i += scnprintf(buf + i, sz - i, " %u", l->silent_intv_cnt);
 	i += scnprintf(buf + i, sz - i, " %u", l->rst_cnt);
-	i += scnprintf(buf + i, sz - i, " %u", l->prev_from);
+	i += scnprintf(buf + i, sz - i, " %u", 0);
 	i += scnprintf(buf + i, sz - i, " %u", 0);
 	i += scnprintf(buf + i, sz - i, " %u", l->acked);
 
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 1c8c8dd32a4e..0daa6f04ca81 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -102,13 +102,15 @@ struct plist;
 #define TIPC_MEDIA_INFO_OFFSET	5
 
 struct tipc_skb_cb {
-	u32 bytes_read;
-	u32 orig_member;
 	struct sk_buff *tail;
 	unsigned long nxt_retr;
-	bool validated;
+	unsigned long retr_stamp;
+	u32 bytes_read;
+	u32 orig_member;
 	u16 chain_imp;
 	u16 ackers;
+	u16 retr_cnt;
+	bool validated;
 };
 
 #define TIPC_SKB_CB(__skb) ((struct tipc_skb_cb *)&((__skb)->cb[0]))
-- 
2.13.7

