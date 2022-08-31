Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7DF5A7A29
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 11:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiHaJZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 05:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiHaJZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 05:25:13 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B436D2873B
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 02:25:09 -0700 (PDT)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1661937906; bh=I5/fq6vkP/nepW0u+VYbKDlqsot2GVFRmkHvf7btu28=;
        h=From:To:Cc:Subject:Date:From;
        b=n2aBdsTs+5FWQ8G3lzlSO1bc5x/hFjd8HViZvk3u1nY2F6rkvPi7sne3sl2NVuNSZ
         gTXvw2CVzopPKf2KcP5HS706dwlQoZ3zxcrzuw108rPCxY23iFdEnKJ7ntcyqH7vMt
         MNftI5lYo435N2jsMJC51ycDoRXjlUTS4K+hye6vWFrUFZ/jCRAKH26HhBdDHwoutF
         abmw269CNlLMTAqmFoxiiRI7y0hl6i0ZRq7UDtutBlSyrwT0YC9WiWy4Lt4R6MVq6d
         J3j56QiL+7K5g3x9jRHDGvjcX2rRGJOrP9UPZPxT/OlzqNDZL6xFK03eimDLzezg4X
         eB+q6k/Bkf3eA==
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cake@lists.bufferbloat.net,
        netdev@vger.kernel.org
Subject: [PATCH net] sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
Date:   Wed, 31 Aug 2022 11:21:03 +0200
Message-Id: <20220831092103.442868-1-toke@toke.dk>
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

When the GSO splitting feature of sch_cake is enabled, GSO superpackets
will be broken up and the resulting segments enqueued in place of the
original skb. In this case, CAKE calls consume_skb() on the original skb,
but still returns NET_XMIT_SUCCESS. This can confuse parent qdiscs into
assuming the original skb still exists, when it really has been freed. Fix
this by adding the __NET_XMIT_STOLEN flag to the return value in this case.

Fixes: 0c850344d388 ("sch_cake: Conditionally split GSO segments")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/sched/sch_cake.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index a43a58a73d09..a04928082e4a 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1713,6 +1713,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 	idx--;
 	flow = &b->flows[idx];
+	ret = NET_XMIT_SUCCESS;
 
 	/* ensure shaper state isn't stale */
 	if (!b->tin_backlog) {
@@ -1771,6 +1772,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		qdisc_tree_reduce_backlog(sch, 1-numsegs, len-slen);
 		consume_skb(skb);
+		ret |= __NET_XMIT_STOLEN;
 	} else {
 		/* not splitting */
 		cobalt_set_enqueue_time(skb, now);
@@ -1904,7 +1906,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		}
 		b->drop_overlimit += dropped;
 	}
-	return NET_XMIT_SUCCESS;
+	return ret;
 }
 
 static struct sk_buff *cake_dequeue_one(struct Qdisc *sch)
-- 
2.37.2

