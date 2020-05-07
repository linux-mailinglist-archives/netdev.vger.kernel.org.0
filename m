Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562341C8099
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 05:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgEGDlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 23:41:08 -0400
Received: from mail-m963.mail.126.com ([123.126.96.3]:37218 "EHLO
        mail-m963.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgEGDlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 23:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=oXZy2
        qPDwMc2OAsmTbubWtRskMXsxkTGWjO3gj8lkyo=; b=fn6hwESJPCDvj2eqR6+y0
        /6ohw+gwD3sKiw5h0XOJ1QWK8C8Q6ZgPSmysEOuUzd+HaLtUeH90lvOmraRSsVH2
        c96W40tlkcBJ5To+CXwzYIQY7lVqJOU6MImB7TifzW7gKho+ElffIt/TUBw3yynt
        Z/c4Ibp+GRRTLv8URO3Utk=
Received: from toolchain (unknown [222.128.180.40])
        by smtp8 (Coremail) with SMTP id NORpCgD3pguue7Ne+dzwCw--.233S2;
        Thu, 07 May 2020 11:08:31 +0800 (CST)
Date:   Thu, 7 May 2020 11:08:30 +0800
From:   zhang kai <zhangkaiheb@126.com>
To:     ycheng@google.com, edumazet@google.com, ncardwell@google.com,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH] tcp: tcp_mark_head_lost is only valid for sack-tcp
Message-ID: <20200507030830.GA8611@toolchain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-CM-TRANSID: NORpCgD3pguue7Ne+dzwCw--.233S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxur18ZrW8XFWDZrWDuFyDZFb_yoW5Gr45pa
        nxKF97KF4UJrySkw1IyFW8XF1rKFs5C345Z3y5X3say3Z8Cr4SgF9Iq3WSyFy5KFWSvrWf
        Zr1kWr45WF1UZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jvyxiUUUUU=
X-Originating-IP: [222.128.180.40]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbiIQ8d-lpD-MInpQAAso
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

so tcp_is_sack/reno checks are removed from tcp_mark_head_lost.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/ipv4/tcp_input.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b996dc106..c306becf6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2183,8 +2183,7 @@ static bool tcp_time_to_recover(struct sock *sk, int flag)
 }
 
 /* Detect loss in event "A" above by marking head of queue up as lost.
- * For non-SACK(Reno) senders, the first "packets" number of segments
- * are considered lost. For RFC3517 SACK, a segment is considered lost if it
+ * For RFC3517 SACK, a segment is considered lost if it
  * has at least tp->reordering SACKed seqments above it; "packets" refers to
  * the maximum SACKed segments to pass before reaching this limit.
  */
@@ -2192,10 +2191,9 @@ static void tcp_mark_head_lost(struct sock *sk, int packets, int mark_head)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
-	int cnt, oldcnt, lost;
-	unsigned int mss;
+	int cnt;
 	/* Use SACK to deduce losses of new sequences sent during recovery */
-	const u32 loss_high = tcp_is_sack(tp) ?  tp->snd_nxt : tp->high_seq;
+	const u32 loss_high = tp->snd_nxt;
 
 	WARN_ON(packets > tp->packets_out);
 	skb = tp->lost_skb_hint;
@@ -2218,26 +2216,11 @@ static void tcp_mark_head_lost(struct sock *sk, int packets, int mark_head)
 		if (after(TCP_SKB_CB(skb)->end_seq, loss_high))
 			break;
 
-		oldcnt = cnt;
-		if (tcp_is_reno(tp) ||
-		    (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED))
+		if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED)
 			cnt += tcp_skb_pcount(skb);
 
-		if (cnt > packets) {
-			if (tcp_is_sack(tp) ||
-			    (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED) ||
-			    (oldcnt >= packets))
-				break;
-
-			mss = tcp_skb_mss(skb);
-			/* If needed, chop off the prefix to mark as lost. */
-			lost = (packets - oldcnt) * mss;
-			if (lost < skb->len &&
-			    tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb,
-					 lost, mss, GFP_ATOMIC) < 0)
-				break;
-			cnt = packets;
-		}
+		if (cnt > packets)
+			break;
 
 		tcp_skb_mark_lost(tp, skb);
 
@@ -2849,8 +2832,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 			if (tcp_try_undo_partial(sk, prior_snd_una))
 				return;
 			/* Partial ACK arrived. Force fast retransmit. */
-			do_lost = tcp_is_reno(tp) ||
-				  tcp_force_fast_retransmit(sk);
+			do_lost = tcp_force_fast_retransmit(sk);
 		}
 		if (tcp_try_undo_dsack(sk)) {
 			tcp_try_keep_open(sk);
-- 
2.17.1

