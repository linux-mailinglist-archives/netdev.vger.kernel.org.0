Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04BE5A8887
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiHaVwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHaVwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:52:42 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C145E8329
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 14:52:41 -0700 (PDT)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1661982759; bh=Vv+JXTmHy4VSMzc2fGJhs5sYpqebPw2Cc6M8GmwvIPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvXQVEIYEZLot0elKULNjZi+9CMg0iiIAeAaBjg5M9RAuVszQM4huRyEgqSnJHIxj
         PHZFhiFD8PmTjdX8Hz8Ba+pJNwf4B6QDgOwohHt/DPx6DtOFwd7Z9gHdoI6KdLetGJ
         3QaWijTcXL8bJfrxrecWA7+TFyyVyy/lwU2LBrJJz85HYcMd/KeY4ZQ/e7sr9ZeAnT
         uwDVlPF/I3vuzMpnHpqQ5VsUwtnSSr2xhwaz24sGHRirgCO4rcOwuNc7ZYVIPHvl7o
         T9jXCM8gZAiGQpQ7p+RDRrbQRm5oRyYw2mPja+mHtKyeD4NKMrpTqhzclx4+DvRgfM
         6mfW+/ZJZAxHw==
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        zdi-disclosures@trendmicro.com, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net v2] sch_sfb: Don't assume the skb is still around after enqueueing to child
Date:   Wed, 31 Aug 2022 23:52:18 +0200
Message-Id: <20220831215219.499563-1-toke@toke.dk>
In-Reply-To: <20220831092103.442868-1-toke@toke.dk>
References: <20220831092103.442868-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sch_sfb enqueue() routine assumes the skb is still alive after it has
been enqueued into a child qdisc, using the data in the skb cb field in the
increment_qlen() routine after enqueue. However, the skb may in fact have
been freed, causing a use-after-free in this case. In particular, this
happens if sch_cake is used as a child of sfb, and the GSO splitting mode
of CAKE is enabled (in which case the skb will be split into segments and
the original skb freed).

Fix this by copying the sfb cb data to the stack before enqueueing the skb,
and using this stack copy in increment_qlen() instead of the skb pointer
itself.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-18231
Fixes: e13e02a3c68d ("net_sched: SFB flow scheduler")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
v2:
- Instead of changing sch_cake to return NET_XMIT_SUCCESS | __NET_XMIT_STOLEN
  when freeing the skb, change sfb to not assume the skb is still alive after
  enqueue (which no other callers of qdisc_enqueue() do). This has the benefit
  of not breaking the usage of sch_cake as a child of sch_htb, which is a
  deployment seen in real-world use.

 net/sched/sch_sfb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 3d061a13d7ed..0d761f454ae8 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -135,15 +135,15 @@ static void increment_one_qlen(u32 sfbhash, u32 slot, struct sfb_sched_data *q)
 	}
 }
 
-static void increment_qlen(const struct sk_buff *skb, struct sfb_sched_data *q)
+static void increment_qlen(const struct sfb_skb_cb *cb, struct sfb_sched_data *q)
 {
 	u32 sfbhash;
 
-	sfbhash = sfb_hash(skb, 0);
+	sfbhash = cb->hashes[0];
 	if (sfbhash)
 		increment_one_qlen(sfbhash, 0, q);
 
-	sfbhash = sfb_hash(skb, 1);
+	sfbhash = cb->hashes[1];
 	if (sfbhash)
 		increment_one_qlen(sfbhash, 1, q);
 }
@@ -283,6 +283,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct sfb_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *child = q->qdisc;
 	struct tcf_proto *fl;
+	struct sfb_skb_cb cb;
 	int i;
 	u32 p_min = ~0;
 	u32 minqlen = ~0;
@@ -399,11 +400,12 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 enqueue:
+	memcpy(&cb, sfb_skb_cb(skb), sizeof(cb));
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
 		qdisc_qstats_backlog_inc(sch, skb);
 		sch->q.qlen++;
-		increment_qlen(skb, q);
+		increment_qlen(&cb, q);
 	} else if (net_xmit_drop_count(ret)) {
 		q->stats.childdrop++;
 		qdisc_qstats_drop(sch);
-- 
2.37.2

