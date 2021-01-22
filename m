Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC03300053
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbhAVKb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:31:27 -0500
Received: from mail.wangsu.com ([123.103.51.227]:38352 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727676AbhAVK3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 05:29:31 -0500
Received: from 137.localdomain (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id 4zNnewCHj6+vqApg5ZgBAA--.387S2;
        Fri, 22 Jan 2021 18:28:00 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, ncardwell@google.com, ycheng@google.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN
Date:   Fri, 22 Jan 2021 18:27:22 +0800
Message-Id: <1611311242-6675-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: 4zNnewCHj6+vqApg5ZgBAA--.387S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4kKrW5Aw4rWr48tF18Xwb_yoWrXr1xpF
        sakwsrGr4kGFWUCF1vyFWkXw1qgws5AFy3ur4UWrySyr1DKF1IgFWkKF45tF43KF40kF4a
        yr109rWrJF18A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyG1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4lYx0Ec7CjxVAajcxG14v26r1j
        6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI
        8I648v4I1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_
        Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
        AvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU04lk3UUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CA_STATE is in DISORDER, the TLP timer is not set when receiving
an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
change from DISORDER to OPEN. If the sender is app-limited, it can only
wait for the RTO timer to expire and retransmit.

The reason for this is that the TLP timer is set before CA_STATE changes
in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
until after tcp_fastretrans_alert() returns and remove the
FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.

This commit has two additional benefits:
1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
avoid spurious RTO caused by RTO timer early expires.
2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
timer is set.

Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
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

