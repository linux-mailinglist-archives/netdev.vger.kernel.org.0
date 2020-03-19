Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C21C18ACC9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 07:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgCSGc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 02:32:57 -0400
Received: from mail.wangsu.com ([123.103.51.227]:55198 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726063AbgCSGc5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 02:32:57 -0400
Received: from 137.localdomain (unknown [218.107.205.216])
        by app2 (Coremail) with SMTP id 4zNnewCnrxcNEnNeD5MUAA--.301S2;
        Thu, 19 Mar 2020 14:32:46 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, davem@davemloft.net, ncardwell@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH RFC net-next] tcp: make cwnd-limited not affected by tcp internal pacing
Date:   Thu, 19 Mar 2020 14:32:29 +0800
Message-Id: <1584599549-6793-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: 4zNnewCnrxcNEnNeD5MUAA--.301S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZryDGr47WFyftrW7Kw15Arb_yoW5Wr43pF
        WFkw40qw1kXry3Crn7Ar1rZF1UurZYkFyUW3y5Z34qy39rXw1Y9F47Kr4F9Fy7GF4fXw43
        Xr4j934rCryDZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyG1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4lYx0Ec7CjxVAajcxG14v26r1j
        6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI
        8I648v4I1lc2xSY4AK67AK6r47MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_
        Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
        xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VU8J3ktUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current cwnd-limited is set when cwnd is fully used
(inflight >= cwnd), which allows the congestion algorithm
to accurately determine whether cwnd needs to be added.

However, there may be a problem when using tcp internal pacing:
In congestion avoidance phase, when a burst of packets are
acked by a stretched ACK or a burst of ACKs, this makes a large
reduction in inflight in a short time. At this time, the sender
sends data according to the pacing rate cannot fill CWND and
cwnd-limited is not set. The worst case is that cwnd-limited
is set only after the last packet in a window is sent. This causes
the congestion algorithm to be too conservative to increase CWND.

The idea is that once cwnd-limited is set, it maintains a window period.
In this period, it is considered that the CWND is limited. This makes
the congestion algorithm unaffected by tcp internal pacing.

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 include/linux/tcp.h   |  2 +-
 net/ipv4/tcp_output.c | 14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 3dc9640..3b3329f 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -286,7 +286,7 @@ struct tcp_sock {
 	u32	packets_out;	/* Packets which are "in flight"	*/
 	u32	retrans_out;	/* Retransmitted packets out		*/
 	u32	max_packets_out;  /* max packets_out in last window */
-	u32	max_packets_seq;  /* right edge of max_packets_out flight */
+	u32	cwnd_limited_seq; /* snd_nxt at cwnd limited */
 
 	u16	urg_data;	/* Saved octet of OOB data and control flags */
 	u8	ecn_flags;	/* ECN status bits.			*/
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 306e25d..31dd6dc 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1705,14 +1705,16 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 	const struct tcp_congestion_ops *ca_ops = inet_csk(sk)->icsk_ca_ops;
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	/* Track the maximum number of outstanding packets in each
-	 * window, and remember whether we were cwnd-limited then.
+	/* Remember whether we were cwnd-limited in last window,
+	 * and track the maximum number of outstanding packets in each window.
 	 */
-	if (!before(tp->snd_una, tp->max_packets_seq) ||
-	    tp->packets_out > tp->max_packets_out) {
-		tp->max_packets_out = tp->packets_out;
-		tp->max_packets_seq = tp->snd_nxt;
+	if (is_cwnd_limited ||
+	    !before(tp->snd_una, tp->cwnd_limited_seq)) {
 		tp->is_cwnd_limited = is_cwnd_limited;
+		tp->cwnd_limited_seq = tp->snd_nxt;
+		tp->max_packets_out = tp->packets_out;
+	} else if (tp->packets_out > tp->max_packets_out) {
+		tp->max_packets_out = tp->packets_out;
 	}
 
 	if (tcp_is_cwnd_limited(sk)) {
-- 
1.8.3.1

