Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EB23E2AFB
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 14:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243371AbhHFMxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 08:53:24 -0400
Received: from relay.sw.ru ([185.231.240.75]:41218 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237819AbhHFMxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 08:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=egBPXyBYmGMlQBMUmRxl2nc+0PbWoNUPh+wMswC6yd4=; b=AuK5kyS3mA76tNw1Fct
        ZqfO1tGW+lcwp2ncETtRW4TbOyO2yZst7jE4/LBrZptROaBA6fiUKHH5ih3316PPWBI+xm9Q+4aUn
        qUAjsXjZO6OeTPq/h45BQXP94noSvi+13ud0UxsJ5Eebvtsr0vO/fjyKpZBLSr3/gg6Fyk8P27c=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mBzLR-006co5-Af; Fri, 06 Aug 2021 15:53:01 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET] vrf: fix null pointer dereference in vrf_finish_output()
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>
References: <20210806.111412.1329682129695306949.davem@davemloft.net>
Message-ID: <5ba67c28-1056-e24d-cad3-4b7aaac01111@virtuozzo.com>
Date:   Fri, 6 Aug 2021 15:53:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806.111412.1329682129695306949.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After 14ee70ca89e6 ("vrf: use skb_expand_head in vrf_finish_output")
skb->dev  is accessed after skb free.
Let's replace skb->dev by dev = skb_dst(skb)->dev:
vrf_finish_output() is only called from vrf_output(),
it set skb->dev to skb_dst(skb)->dev and calls POSTROUTING netfilter
hooks, where output device should not be changed.

Fixes: 14ee70ca89e6 ("vrf: use skb_expand_head in vrf_finish_output")
Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 drivers/net/vrf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 726adf0..168d4ef 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -864,7 +864,7 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
-			skb->dev->stats.tx_errors++;
+			dev->stats.tx_errors++;
 			return -ENOMEM;
 		}
 	}
@@ -883,7 +883,7 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	}
 
 	rcu_read_unlock_bh();
-	vrf_tx_error(skb->dev, skb);
+	vrf_tx_error(dev, skb);
 	return -EINVAL;
 }
 
-- 
1.8.3.1

