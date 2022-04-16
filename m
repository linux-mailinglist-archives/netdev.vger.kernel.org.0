Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6665035A3
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 11:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiDPJXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 05:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiDPJXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 05:23:11 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 80A0212A92
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 02:20:28 -0700 (PDT)
Received: from 102.localdomain (unknown [58.23.249.10])
        by app1 (Coremail) with SMTP id xjNnewA36DErilpi+B0VAA--.37S3;
        Sat, 16 Apr 2022 17:20:05 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net-next v2 1/2] tcp: ensure to use the most recently sent skb when filling the rate sample
Date:   Sat, 16 Apr 2022 17:19:08 +0800
Message-Id: <1650100749-10072-2-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1650100749-10072-1-git-send-email-yangpc@wangsu.com>
References: <1650100749-10072-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: xjNnewA36DErilpi+B0VAA--.37S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF1DAw1rAFWUKr1kJr45Awb_yoW5tFyxpF
        Wvkr9xWr1kJrWrtrn7tw4kJw1F9ws5Gr1fWFWDuw1YywsxG34xWF1ktryUtay5WFZ2yFWf
        tw1qgF1Uu3WDWFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvF1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r10
        6r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8uwCF04k20xvY0x0EwIxG
        rwCF04k20xvE74AGY7Cv6cx26ryUJr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r12
        6r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
        xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
        fUOOzVUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an ACK (s)acks multiple skbs, we favor the information
from the most recently sent skb by choosing the skb with
the highest prior_delivered count. But in the interval
between receiving ACKs, we send multiple skbs with the same
prior_delivered, because the tp->delivered only changes
when we receive an ACK.

We used RACK's solution, copying tcp_rack_sent_after() as
tcp_skb_sent_after() helper to determine "which packet was
sent last?". Later, we will use tcp_skb_sent_after() instead
in RACK.

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 include/net/tcp.h   |  6 ++++++
 net/ipv4/tcp_rate.c | 11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6d50a66..fcd69fc 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1042,6 +1042,7 @@ struct rate_sample {
 	int  losses;		/* number of packets marked lost upon ACK */
 	u32  acked_sacked;	/* number of packets newly (S)ACKed upon ACK */
 	u32  prior_in_flight;	/* in flight before this ACK */
+	u32  last_end_seq;	/* end_seq of most recently ACKed packet */
 	bool is_app_limited;	/* is sample from packet with bubble in pipe? */
 	bool is_retrans;	/* is sample from retransmission? */
 	bool is_ack_delayed;	/* is this (likely) a delayed ACK? */
@@ -1158,6 +1159,11 @@ void tcp_rate_gen(struct sock *sk, u32 delivered, u32 lost,
 		  bool is_sack_reneg, struct rate_sample *rs);
 void tcp_rate_check_app_limited(struct sock *sk);
 
+static inline bool tcp_skb_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
+{
+	return t1 > t2 || (t1 == t2 && after(seq1, seq2));
+}
+
 /* These functions determine how the current flow behaves in respect of SACK
  * handling. SACK is negotiated with the peer, and therefore it can vary
  * between different flows.
diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
index 617b818..a8f6d9d 100644
--- a/net/ipv4/tcp_rate.c
+++ b/net/ipv4/tcp_rate.c
@@ -74,27 +74,32 @@ void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb)
  *
  * If an ACK (s)acks multiple skbs (e.g., stretched-acks), this function is
  * called multiple times. We favor the information from the most recently
- * sent skb, i.e., the skb with the highest prior_delivered count.
+ * sent skb, i.e., the skb with the most recently sent time and the highest
+ * sequence.
  */
 void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
 			    struct rate_sample *rs)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_skb_cb *scb = TCP_SKB_CB(skb);
+	u64 tx_tstamp;
 
 	if (!scb->tx.delivered_mstamp)
 		return;
 
+	tx_tstamp = tcp_skb_timestamp_us(skb);
 	if (!rs->prior_delivered ||
-	    after(scb->tx.delivered, rs->prior_delivered)) {
+	    tcp_skb_sent_after(tx_tstamp, tp->first_tx_mstamp,
+			       scb->end_seq, rs->last_end_seq)) {
 		rs->prior_delivered_ce  = scb->tx.delivered_ce;
 		rs->prior_delivered  = scb->tx.delivered;
 		rs->prior_mstamp     = scb->tx.delivered_mstamp;
 		rs->is_app_limited   = scb->tx.is_app_limited;
 		rs->is_retrans	     = scb->sacked & TCPCB_RETRANS;
+		rs->last_end_seq     = scb->end_seq;
 
 		/* Record send time of most recently ACKed packet: */
-		tp->first_tx_mstamp  = tcp_skb_timestamp_us(skb);
+		tp->first_tx_mstamp  = tx_tstamp;
 		/* Find the duration of the "send phase" of this window: */
 		rs->interval_us = tcp_stamp_us_delta(tp->first_tx_mstamp,
 						     scb->tx.first_tx_mstamp);
-- 
1.8.3.1

