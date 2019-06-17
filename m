Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1500479A4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 07:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfFQFP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 01:15:57 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:55924 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725280AbfFQFP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 01:15:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id E6226E4F89;
        Mon, 17 Jun 2019 15:15:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1560748550; bh=/+i7n
        BBZCB0X4FPUG8yNW/nePa2NKgJT97q7+ZxinmQ=; b=MwGxDEyzCrSnNhOa+JEJw
        RxlcFP91WeJwshH+0tiI1h5ZtrZZKvHANfM5E95d0psssRjTzjXgdRUh3dl8MB57
        2e8tmSAsyKXRN615EcY7+D5WuuxY5udPkA9dsueb+IhdlBkVUTpPLsVHA/QG2lHv
        iDVLEvNxCdll6Eg1dPc3EM=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kW_a0olO7aNV; Mon, 17 Jun 2019 15:15:50 +1000 (AEST)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id BACC5E4F8A;
        Mon, 17 Jun 2019 15:15:50 +1000 (AEST)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id CF5E9E4F89;
        Mon, 17 Jun 2019 15:15:48 +1000 (AEST)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next] tipc: include retrans failure detection for unicast
Date:   Mon, 17 Jun 2019 12:15:42 +0700
Message-Id: <20190617051542.4133-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In patch series, commit 9195948fbf34 ("tipc: improve TIPC throughput by
Gap ACK blocks"), as for simplicity, the repeated retransmit failures'
detection in the function - "tipc_link_retrans()" was kept there for
broadcast retransmissions only.

This commit now reapplies this feature for link unicast retransmissions
that has been done via the function - "tipc_link_advance_transmq()".

Also, the "tipc_link_retrans()" is renamed to "tipc_link_bc_retrans()"
as it is used only for broadcast.

Acked-by: Jon Maloy <jon.maloy@ericsson.se>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/link.c | 106 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 70 insertions(+), 36 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index f5cd986e1e50..d5ed509e0660 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -249,9 +249,9 @@ static void tipc_link_build_bc_init_msg(struct tipc_link *l,
 					struct sk_buff_head *xmitq);
 static bool tipc_link_release_pkts(struct tipc_link *l, u16 to);
 static u16 tipc_build_gap_ack_blks(struct tipc_link *l, void *data);
-static void tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
-				      struct tipc_gap_ack_blks *ga,
-				      struct sk_buff_head *xmitq);
+static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
+				     struct tipc_gap_ack_blks *ga,
+				     struct sk_buff_head *xmitq);
 
 /*
  *  Simple non-static link routines (i.e. referenced outside this file)
@@ -1044,32 +1044,69 @@ static void tipc_link_advance_backlog(struct tipc_link *l,
 	l->snd_nxt = seqno;
 }
 
-static void link_retransmit_failure(struct tipc_link *l, struct sk_buff *skb)
+/**
+ * link_retransmit_failure() - Detect repeated retransmit failures
+ * @l: tipc link sender
+ * @r: tipc link receiver (= l in case of unicast)
+ * @from: seqno of the 1st packet in retransmit request
+ * @rc: returned code
+ *
+ * Return: true if the repeated retransmit failures happens, otherwise
+ * false
+ */
+static bool link_retransmit_failure(struct tipc_link *l, struct tipc_link *r,
+				    u16 from, int *rc)
 {
-	struct tipc_msg *hdr = buf_msg(skb);
+	struct sk_buff *skb = skb_peek(&l->transmq);
+	struct tipc_msg *hdr;
+
+	if (!skb)
+		return false;
+	hdr = buf_msg(skb);
+
+	/* Detect repeated retransmit failures on same packet */
+	if (r->prev_from != from) {
+		r->prev_from = from;
+		r->stale_limit = jiffies + msecs_to_jiffies(r->tolerance);
+		r->stale_cnt = 0;
+	} else if (++r->stale_cnt > 99 && time_after(jiffies, r->stale_limit)) {
+		pr_warn("Retransmission failure on link <%s>\n", l->name);
+		link_print(l, "State of link ");
+		pr_info("Failed msg: usr %u, typ %u, len %u, err %u\n",
+			msg_user(hdr), msg_type(hdr), msg_size(hdr),
+			msg_errcode(hdr));
+		pr_info("sqno %u, prev: %x, src: %x\n",
+			msg_seqno(hdr), msg_prevnode(hdr), msg_orignode(hdr));
+
+		trace_tipc_list_dump(&l->transmq, true, "retrans failure!");
+		trace_tipc_link_dump(l, TIPC_DUMP_NONE, "retrans failure!");
+		trace_tipc_link_dump(r, TIPC_DUMP_NONE, "retrans failure!");
+
+		if (link_is_bc_sndlink(l))
+			*rc = TIPC_LINK_DOWN_EVT;
+
+		*rc = tipc_link_fsm_evt(l, LINK_FAILURE_EVT);
+		return true;
+	}
 
-	pr_warn("Retransmission failure on link <%s>\n", l->name);
-	link_print(l, "State of link ");
-	pr_info("Failed msg: usr %u, typ %u, len %u, err %u\n",
-		msg_user(hdr), msg_type(hdr), msg_size(hdr), msg_errcode(hdr));
-	pr_info("sqno %u, prev: %x, src: %x\n",
-		msg_seqno(hdr), msg_prevnode(hdr), msg_orignode(hdr));
+	return false;
 }
 
-/* tipc_link_retrans() - retransmit one or more packets
+/* tipc_link_bc_retrans() - retransmit zero or more packets
  * @l: the link to transmit on
  * @r: the receiving link ordering the retransmit. Same as l if unicast
  * @from: retransmit from (inclusive) this sequence number
  * @to: retransmit to (inclusive) this sequence number
  * xmitq: queue for accumulating the retransmitted packets
  */
-static int tipc_link_retrans(struct tipc_link *l, struct tipc_link *r,
-			     u16 from, u16 to, struct sk_buff_head *xmitq)
+static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
+				u16 from, u16 to, struct sk_buff_head *xmitq)
 {
 	struct sk_buff *_skb, *skb = skb_peek(&l->transmq);
 	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
 	u16 ack = l->rcv_nxt - 1;
 	struct tipc_msg *hdr;
+	int rc = 0;
 
 	if (!skb)
 		return 0;
@@ -1077,20 +1114,9 @@ static int tipc_link_retrans(struct tipc_link *l, struct tipc_link *r,
 		return 0;
 
 	trace_tipc_link_retrans(r, from, to, &l->transmq);
-	/* Detect repeated retransmit failures on same packet */
-	if (r->prev_from != from) {
-		r->prev_from = from;
-		r->stale_limit = jiffies + msecs_to_jiffies(r->tolerance);
-		r->stale_cnt = 0;
-	} else if (++r->stale_cnt > 99 && time_after(jiffies, r->stale_limit)) {
-		link_retransmit_failure(l, skb);
-		trace_tipc_list_dump(&l->transmq, true, "retrans failure!");
-		trace_tipc_link_dump(l, TIPC_DUMP_NONE, "retrans failure!");
-		trace_tipc_link_dump(r, TIPC_DUMP_NONE, "retrans failure!");
-		if (link_is_bc_sndlink(l))
-			return TIPC_LINK_DOWN_EVT;
-		return tipc_link_fsm_evt(l, LINK_FAILURE_EVT);
-	}
+
+	if (link_retransmit_failure(l, r, from, &rc))
+		return rc;
 
 	skb_queue_walk(&l->transmq, skb) {
 		hdr = buf_msg(skb);
@@ -1324,17 +1350,23 @@ static u16 tipc_build_gap_ack_blks(struct tipc_link *l, void *data)
  * @gap: # of gap packets
  * @ga: buffer pointer to Gap ACK blocks from peer
  * @xmitq: queue for accumulating the retransmitted packets if any
+ *
+ * In case of a repeated retransmit failures, the call will return shortly
+ * with a returned code (e.g. TIPC_LINK_DOWN_EVT)
  */
-static void tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
-				      struct tipc_gap_ack_blks *ga,
-				      struct sk_buff_head *xmitq)
+static int tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
+				     struct tipc_gap_ack_blks *ga,
+				     struct sk_buff_head *xmitq)
 {
 	struct sk_buff *skb, *_skb, *tmp;
 	struct tipc_msg *hdr;
 	u16 bc_ack = l->bc_rcvlink->rcv_nxt - 1;
 	u16 ack = l->rcv_nxt - 1;
-	u16 seqno;
-	u16 n = 0;
+	u16 seqno, n = 0;
+	int rc = 0;
+
+	if (gap && link_retransmit_failure(l, l, acked + 1, &rc))
+		return rc;
 
 	skb_queue_walk_safe(&l->transmq, skb, tmp) {
 		seqno = buf_seqno(skb);
@@ -1369,6 +1401,8 @@ static void tipc_link_advance_transmq(struct tipc_link *l, u16 acked, u16 gap,
 			goto next_gap_ack;
 		}
 	}
+
+	return 0;
 }
 
 /* tipc_link_build_state_msg: prepare link state message for transmission
@@ -1919,7 +1953,7 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 			tipc_link_build_proto_msg(l, STATE_MSG, 0, reply,
 						  rcvgap, 0, 0, xmitq);
 
-		tipc_link_advance_transmq(l, ack, gap, ga, xmitq);
+		rc |= tipc_link_advance_transmq(l, ack, gap, ga, xmitq);
 
 		/* If NACK, retransmit will now start at right position */
 		if (gap)
@@ -2036,7 +2070,7 @@ int tipc_link_bc_sync_rcv(struct tipc_link *l, struct tipc_msg *hdr,
 	if (more(peers_snd_nxt, l->rcv_nxt + l->window))
 		return rc;
 
-	rc = tipc_link_retrans(snd_l, l, from, to, xmitq);
+	rc = tipc_link_bc_retrans(snd_l, l, from, to, xmitq);
 
 	l->snd_nxt = peers_snd_nxt;
 	if (link_bc_rcv_gap(l))
@@ -2132,7 +2166,7 @@ int tipc_link_bc_nack_rcv(struct tipc_link *l, struct sk_buff *skb,
 
 	if (dnode == tipc_own_addr(l->net)) {
 		tipc_link_bc_ack_rcv(l, acked, xmitq);
-		rc = tipc_link_retrans(l->bc_sndlink, l, from, to, xmitq);
+		rc = tipc_link_bc_retrans(l->bc_sndlink, l, from, to, xmitq);
 		l->stats.recv_nacks++;
 		return rc;
 	}
-- 
2.13.7

