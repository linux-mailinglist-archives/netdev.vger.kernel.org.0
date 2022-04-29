Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6265146CE
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 12:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357494AbiD2Khm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 06:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357489AbiD2Khl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 06:37:41 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 847B8B36AF
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 03:34:19 -0700 (PDT)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app1 (Coremail) with SMTP id SiJltAD3_xMIv2tiJ7cCAA--.204S2;
        Fri, 29 Apr 2022 18:33:44 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net-next] tcp: use tcp_skb_sent_after() instead in RACK
Date:   Fri, 29 Apr 2022 18:32:56 +0800
Message-Id: <1651228376-10737-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: SiJltAD3_xMIv2tiJ7cCAA--.204S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW7Gry8KF4xGFWDKr1xZrb_yoW8Xw1xpa
        n7CrykWr1DGrWFkFnayFs8Xr1UXr4Fyr4UWr47uwn7ZwsrKw1xGr1vqF1FyrWUJa92v3W3
        GrykJay5XFnrC37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyK1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l
        84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I
        8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAv7VCY1x0262k0Y48FwI0_
        Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zV
        CS5cI20VAGYxC7MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
        6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
        Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
        6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
        AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUcdWFUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch doesn't change any functionality.

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Cc: Neal Cardwell <ncardwell@google.com>
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

