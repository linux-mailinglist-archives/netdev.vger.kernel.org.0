Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D1713A3BB
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 10:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgANJYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 04:24:38 -0500
Received: from mail.wangsu.com ([123.103.51.227]:54216 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725820AbgANJYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 04:24:37 -0500
Received: from 137.localdomain (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id 4zNnewDXIjS8iB1ea_sEAA--.5S2;
        Tue, 14 Jan 2020 17:24:13 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH] tcp: fix marked lost packets not being retransmitted
Date:   Tue, 14 Jan 2020 17:23:40 +0800
Message-Id: <1578993820-2114-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: 4zNnewDXIjS8iB1ea_sEAA--.5S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF18WF43uF4UtryfKF17KFg_yoW5Wr17pa
        n5KwnrJFZ8Gr1Fkw1DKrWUXryUtFs3A343J39Yyr9Iya15Gr17uF45K3y3KFy3GFZ5Jay0
        qFW0yw13Ka4DCFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyG1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4lOx8S6xCaFVCjc4AY6r1j6r4U
        M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
        kIc2xKxwCY02Avz4vE14v_GFWl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8
        GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26c
        xKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU0F_M3UUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the packet pointed to by retransmit_skb_hint is unlinked by ACK,
retransmit_skb_hint will be set to NULL in tcp_clean_rtx_queue().
If packet loss is detected at this time, retransmit_skb_hint will be set
to point to the current packet loss in tcp_verify_retransmit_hint(),
then the packets that were previously marked lost but not retransmitted
due to the restriction of cwnd will be skipped and cannot be
retransmitted.

To fix this, when retransmit_skb_hint is NULL, retransmit_skb_hint can
be reset only after all marked lost packets are retransmitted
(retrans_out >= lost_out), otherwise we need to traverse from
tcp_rtx_queue_head in tcp_xmit_retransmit_queue().

Packetdrill to demonstrate:

// Disable RACK and set max_reordering to keep things simple
    0 `sysctl -q net.ipv4.tcp_recovery=0`
   +0 `sysctl -q net.ipv4.tcp_max_reordering=3`

// Establish a connection
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

  +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <...>
 +.01 < . 1:1(0) ack 1 win 257
   +0 accept(3, ..., ...) = 4

// Send 8 data segments
   +0 write(4, ..., 8000) = 8000
   +0 > P. 1:8001(8000) ack 1

// Enter recovery and 1:3001 is marked lost
 +.01 < . 1:1(0) ack 1 win 257 <sack 3001:4001,nop,nop>
   +0 < . 1:1(0) ack 1 win 257 <sack 5001:6001 3001:4001,nop,nop>
   +0 < . 1:1(0) ack 1 win 257 <sack 5001:7001 3001:4001,nop,nop>

// Retransmit 1:1001, now retransmit_skb_hint points to 1001:2001
   +0 > . 1:1001(1000) ack 1

// 1001:2001 was ACKed causing retransmit_skb_hint to be set to NULL
 +.01 < . 1:1(0) ack 2001 win 257 <sack 5001:8001 3001:4001,nop,nop>
// Now retransmit_skb_hint points to 4001:5001 which is now marked lost

// BUG: 2001:3001 was not retransmitted
   +0 > . 2001:3001(1000) ack 1

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_input.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0238b55..5347ab2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -915,9 +915,10 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
 /* This must be called before lost_out is incremented */
 static void tcp_verify_retransmit_hint(struct tcp_sock *tp, struct sk_buff *skb)
 {
-	if (!tp->retransmit_skb_hint ||
-	    before(TCP_SKB_CB(skb)->seq,
-		   TCP_SKB_CB(tp->retransmit_skb_hint)->seq))
+	if ((!tp->retransmit_skb_hint && tp->retrans_out >= tp->lost_out) ||
+	    (tp->retransmit_skb_hint &&
+	     before(TCP_SKB_CB(skb)->seq,
+		    TCP_SKB_CB(tp->retransmit_skb_hint)->seq)))
 		tp->retransmit_skb_hint = skb;
 }
 
-- 
1.8.3.1

