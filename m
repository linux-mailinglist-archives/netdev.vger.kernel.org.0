Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BEF12B359
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 09:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfL0IyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 03:54:08 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:57461 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbfL0IyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 03:54:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Tm1RnsY_1577436843;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0Tm1RnsY_1577436843)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 27 Dec 2019 16:54:04 +0800
From:   Cambda Zhu <cambda@linux.alibaba.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Yuchung Cheng <ycheng@google.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
Subject: [PATCH] tcp: Fix highest_sack and highest_sack_seq
Date:   Fri, 27 Dec 2019 16:52:37 +0800
Message-Id: <20191227085237.7295-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From commit 50895b9de1d3 ("tcp: highest_sack fix"), the logic about
setting tp->highest_sack to the head of the send queue was removed.
Of course the logic is error prone, but it is logical. Before we
remove the pointer to the highest sack skb and use the seq instead,
we need to set tp->highest_sack to NULL when there is no skb after
the last sack, and then replace NULL with the real skb when new skb
inserted into the rtx queue, because the NULL means the highest sack
seq is tp->snd_nxt. If tp->highest_sack is NULL and new data sent,
the next ACK with sack option will increase tp->reordering unexpectedly.

This patch sets tp->highest_sack to the tail of the rtx queue if
it's NULL and new data is sent. The patch keeps the rule that the
highest_sack can only be maintained by sack processing, except for
this only case.

Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
---
 net/ipv4/tcp_output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 1f7735ca8f22..58c92a7d671c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -72,6 +72,9 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
 	__skb_unlink(skb, &sk->sk_write_queue);
 	tcp_rbtree_insert(&sk->tcp_rtx_queue, skb);
 
+	if (tp->highest_sack == NULL)
+		tp->highest_sack = skb;
+
 	tp->packets_out += tcp_skb_pcount(skb);
 	if (!prior_packets || icsk->icsk_pending == ICSK_TIME_LOSS_PROBE)
 		tcp_rearm_rto(sk);
-- 
2.16.5

