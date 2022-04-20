Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A1507EEE
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358990AbiDTCjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358983AbiDTCi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:38:59 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 891B8237D7
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:36:09 -0700 (PDT)
Received: from 102.localdomain (unknown [117.28.111.162])
        by app1 (Coremail) with SMTP id xjNnewBHTwt3cV9inKEAAA--.45S2;
        Wed, 20 Apr 2022 10:35:37 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net v3] tcp: ensure to use the most recently sent skb when filling the rate sample
Date:   Wed, 20 Apr 2022 10:34:41 +0800
Message-Id: <1650422081-22153-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: xjNnewBHTwt3cV9inKEAAA--.45S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF1DAw1rAFWUtF1rAF4Utwb_yoW5KFy8pF
        Wvkr9xWr1kJrWrtrn7t3ykJw1F9ws5Gr1fWFWDuw1YywsxG34xWF1vqryUtay5WFZ2vFWf
        tw1qgF1Uu3WDWaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r4UMxAIw28IcxkI7VAKI48J
        MxAIw28IcVCjz48v1sIEY20_Xr1UJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
        GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
        6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
        UHWlkUUUUU=
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
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

Fixes: b9f64820fb22 ("tcp: track data delivery rate for a TCP connection")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
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

