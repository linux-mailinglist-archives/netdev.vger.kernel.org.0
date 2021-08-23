Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7683F4633
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 09:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbhHWH5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 03:57:38 -0400
Received: from relay.sw.ru ([185.231.240.75]:43240 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235374AbhHWH5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 03:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=gYEdybKbXhCvejIGuZRQDqqEgCGQEYZNt6q+lPijJXQ=; b=zSOldxa2ZHsHtkYYtQS
        B+p6VObdAf88ETGmdJEyC1AxeKrwmAYpomCtNgYo2EVh8ggpWW+GCQe3J/R/He2rlu4M8iWpsoFgj
        ZBsfPkHgccH9Pa5IvTdRIIS5ZSRPP7fsJNKBH8GW1KysE1zu80UfFjDWQLVCrqo/340m41wmot8=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mI4p8-008YUo-4J; Mon, 23 Aug 2021 10:56:50 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET-NEXT] ipv6: skb_expand_head() adjust skb->truesize
 incorrectly
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>
References: <6858f130-e6b4-1ba7-ed6f-58c00152be69@virtuozzo.com>
Message-ID: <ef4458d9-c4d7-f419-00f2-0f1cea5140ce@virtuozzo.com>
Date:   Mon, 23 Aug 2021 10:56:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6858f130-e6b4-1ba7-ed6f-58c00152be69@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Paasch reports [1] about incorrect skb->truesize
after skb_expand_head() call in ip6_xmit.
This happen because skb_set_owner_w() for newly clone skb is called
too early, before pskb_expand_head() where truesize is adjusted for
(!skb-sk) case.

[1] https://lkml.org/lkml/2021/8/20/1082

Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/core/skbuff.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f931176..508d5c4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1803,6 +1803,8 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
 
 struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
 {
+	struct sk_buff *oskb = skb;
+	struct sk_buff *nskb = NULL;
 	int delta = headroom - skb_headroom(skb);
 
 	if (WARN_ONCE(delta <= 0,
@@ -1811,21 +1813,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
 
 	/* pskb_expand_head() might crash, if skb is shared */
 	if (skb_shared(skb)) {
-		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
-
-		if (likely(nskb)) {
-			if (skb->sk)
-				skb_set_owner_w(nskb, skb->sk);
-			consume_skb(skb);
-		} else {
-			kfree_skb(skb);
-		}
+		nskb = skb_clone(skb, GFP_ATOMIC);
 		skb = nskb;
 	}
 	if (skb &&
-	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
-		kfree_skb(skb);
+	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
 		skb = NULL;
+
+	if (!skb) {
+		kfree_skb(oskb);
+		if (nskb)
+			kfree_skb(nskb);
+	} else if (nskb) {
+		if (oskb->sk)
+			skb_set_owner_w(nskb, oskb->sk);
+		consume_skb(oskb);
 	}
 	return skb;
 }
-- 
1.8.3.1

