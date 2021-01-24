Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F94E3019A2
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 06:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbhAXFNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 00:13:21 -0500
Received: from mail.wangsu.com ([123.103.51.227]:35773 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726206AbhAXFNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 00:13:16 -0500
Received: from 137.localdomain (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id 4zNnewAn1tWKAQ1gAiYAAA--.59S2;
        Sun, 24 Jan 2021 13:11:39 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, ncardwell@google.com, ycheng@google.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH v2 net] tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN
Date:   Sun, 24 Jan 2021 13:07:14 +0800
Message-Id: <1611464834-23030-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: 4zNnewAn1tWKAQ1gAiYAAA--.59S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF18KrWDWr45XrWUtw43ZFb_yoWrXw45pF
        sIkr4DGrs5GFWUGF1vyFWkX34qgws5CFy3ur4UWrySyr1DK3WI9FykKFWYqF43KFW0kFW3
        tr109rWrJF15A37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyK1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l
        84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I
        8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAv7VCY1x0262k0Y48FwI0_
        Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc
        8vx2IErcIFxwCY02Avz4vE14v_GrWl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv
        8VW8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUxdgAUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon receiving a cumulative ACK that changes the congestion state from
Disorder to Open, the TLP timer is not set. If the sender is app-limited,
it can only wait for the RTO timer to expire and retransmit.

The reason for this is that the TLP timer is set before the congestion
state changes in tcp_ack(), so we delay the time point of calling
tcp_set_xmit_timer() until after tcp_fastretrans_alert() returns and
remove the FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer
is set.

This commit has two additional benefits:
1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
avoid spurious RTO caused by RTO timer early expires.
2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
timer is set.

Link: https://lore.kernel.org/netdev/1611311242-6675-1-git-send-email-yangpc@wangsu.com
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Eric Dumazet <edumazet@google.com>
---
v2:
 - modify the commit message according to Yuchung's suggestion

 include/net/tcp.h       |  2 +-
 net/ipv4/tcp_input.c    | 10 ++++++----
 net/ipv4/tcp_recovery.c |  5 +++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 78d13c8..67f7e52 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2060,7 +2060,7 @@ static inline __u32 cookie_init_sequence(const struct tcp_request_sock_ops *ops,
 void tcp_newreno_mark_lost(struct sock *sk, bool snd_una_advanced);
 extern s32 tcp_rack_skb_timeout(struct tcp_sock *tp, struct sk_buff *skb,
 				u32 reo_wnd);
-extern void tcp_rack_mark_lost(struct sock *sk);
+extern bool tcp_rack_mark_lost(struct sock *sk);
 extern void tcp_rack_advance(struct tcp_sock *tp, u8 sacked, u32 end_seq,
 			     u64 xmit_time);
 extern void tcp_rack_reo_timeout(struct sock *sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c7e16b0..d0a9588 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2859,7 +2859,8 @@ static void tcp_identify_packet_loss(struct sock *sk, int *ack_flag)
 	} else if (tcp_is_rack(sk)) {
 		u32 prior_retrans = tp->retrans_out;
 
-		tcp_rack_mark_lost(sk);
+		if (tcp_rack_mark_lost(sk))
+			*ack_flag &= ~FLAG_SET_XMIT_TIMER;
 		if (prior_retrans > tp->retrans_out)
 			*ack_flag |= FLAG_LOST_RETRANS;
 	}
@@ -3815,9 +3816,6 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 
 	if (tp->tlp_high_seq)
 		tcp_process_tlp_ack(sk, ack, flag);
-	/* If needed, reset TLP/RTO timer; RACK may later override this. */
-	if (flag & FLAG_SET_XMIT_TIMER)
-		tcp_set_xmit_timer(sk);
 
 	if (tcp_ack_is_dubious(sk, flag)) {
 		if (!(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP))) {
@@ -3830,6 +3828,10 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 				      &rexmit);
 	}
 
+	/* If needed, reset TLP/RTO timer when RACK doesn't set. */
+	if (flag & FLAG_SET_XMIT_TIMER)
+		tcp_set_xmit_timer(sk);
+
 	if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP))
 		sk_dst_confirm(sk);
 
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 177307a..6f1b4ac 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -96,13 +96,13 @@ static void tcp_rack_detect_loss(struct sock *sk, u32 *reo_timeout)
 	}
 }
 
-void tcp_rack_mark_lost(struct sock *sk)
+bool tcp_rack_mark_lost(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 timeout;
 
 	if (!tp->rack.advanced)
-		return;
+		return false;
 
 	/* Reset the advanced flag to avoid unnecessary queue scanning */
 	tp->rack.advanced = 0;
@@ -112,6 +112,7 @@ void tcp_rack_mark_lost(struct sock *sk)
 		inet_csk_reset_xmit_timer(sk, ICSK_TIME_REO_TIMEOUT,
 					  timeout, inet_csk(sk)->icsk_rto);
 	}
+	return !!timeout;
 }
 
 /* Record the most recently (re)sent time among the (s)acked packets
-- 
1.8.3.1

