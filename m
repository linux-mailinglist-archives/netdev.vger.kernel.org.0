Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02DC5035A9
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 11:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiDPJXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 05:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiDPJXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 05:23:12 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 291363F31E
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 02:20:39 -0700 (PDT)
Received: from 102.localdomain (unknown [58.23.249.10])
        by app1 (Coremail) with SMTP id xjNnewA36DErilpi+B0VAA--.37S4;
        Sat, 16 Apr 2022 17:20:18 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net-next v2 2/2] tcp: use tcp_skb_sent_after() instead in RACK
Date:   Sat, 16 Apr 2022 17:19:09 +0800
Message-Id: <1650100749-10072-3-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1650100749-10072-1-git-send-email-yangpc@wangsu.com>
References: <1650100749-10072-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: xjNnewA36DErilpi+B0VAA--.37S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW7Gry8KF4xGFWDKr1xZrb_yoW8XF1Dpa
        n7CrykWr1DGrWYkFnakFs8Xr13Xr4Fyr4jgrsruwn7ZwsxKw1xGr1vqF1Fy3yUGa92v3W3
        KrykJayrXFnru37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

This patch doesn't change any functionality.

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_recovery.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index fd113f6..48f30e7 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -2,11 +2,6 @@
 #include <linux/tcp.h>
 #include <net/tcp.h>
 
-static bool tcp_rack_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
-{
-	return t1 > t2 || (t1 == t2 && after(seq1, seq2));
-}
-
 static u32 tcp_rack_reo_wnd(const struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -77,9 +72,9 @@ static void tcp_rack_detect_loss(struct sock *sk, u32 *reo_timeout)
 		    !(scb->sacked & TCPCB_SACKED_RETRANS))
 			continue;
 
-		if (!tcp_rack_sent_after(tp->rack.mstamp,
-					 tcp_skb_timestamp_us(skb),
-					 tp->rack.end_seq, scb->end_seq))
+		if (!tcp_skb_sent_after(tp->rack.mstamp,
+					tcp_skb_timestamp_us(skb),
+					tp->rack.end_seq, scb->end_seq))
 			break;
 
 		/* A packet is lost if it has not been s/acked beyond
@@ -140,8 +135,8 @@ void tcp_rack_advance(struct tcp_sock *tp, u8 sacked, u32 end_seq,
 	}
 	tp->rack.advanced = 1;
 	tp->rack.rtt_us = rtt_us;
-	if (tcp_rack_sent_after(xmit_time, tp->rack.mstamp,
-				end_seq, tp->rack.end_seq)) {
+	if (tcp_skb_sent_after(xmit_time, tp->rack.mstamp,
+			       end_seq, tp->rack.end_seq)) {
 		tp->rack.mstamp = xmit_time;
 		tp->rack.end_seq = end_seq;
 	}
-- 
1.8.3.1

