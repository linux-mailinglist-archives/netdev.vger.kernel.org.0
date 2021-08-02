Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122D63DD254
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhHBIwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:52:50 -0400
Received: from relay.sw.ru ([185.231.240.75]:44424 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232957AbhHBIwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=sXg1Or+2lOcrRt7ic/1h1+pUwOLj+a6iNjQ53YYsw6E=; b=S0XSJNvTM8Wgd0U2S1B
        q4VlMuxmw+DQfRDStFvymYxbm/ASaLepEJZjjxb57NS4tVNf/ELTinRykF0OBsxbFiHIQbXxrof//
        Y7bndVcyS47kYc2XdRQSKTS/yKffrP/pxBmkjUksaMtc0id2KJnZLaH8cBIlcS7YIZ7rqmr8NMU=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mATgZ-0060O8-P8; Mon, 02 Aug 2021 11:52:35 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v3 4/7] ipv4: use skb_expand_head in ip_finish_output2
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <15eba3b2-80e2-5547-8ad9-167d810ad7e3@virtuozzo.com>
 <cover.1627891754.git.vvs@virtuozzo.com>
Message-ID: <eb5f05a0-fb79-f848-cde3-5c36b25ff949@virtuozzo.com>
Date:   Mon, 2 Aug 2021 11:52:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1627891754.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike skb_realloc_headroom, new helper skb_expand_head
does not allocate a new skb if possible.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv4/ip_output.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8d8a8da..c6b755e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -198,19 +198,10 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 	} else if (rt->rt_type == RTN_BROADCAST)
 		IP_UPD_PO_STATS(net, IPSTATS_MIB_OUTBCAST, skb->len);
 
-	/* Be paranoid, rather than too clever. */
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
-		struct sk_buff *skb2;
-
-		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
-		if (!skb2) {
-			kfree_skb(skb);
+		skb = skb_expand_head(skb, hh_len);
+		if (!skb)
 			return -ENOMEM;
-		}
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-		consume_skb(skb);
-		skb = skb2;
 	}
 
 	if (lwtunnel_xmit_redirect(dst->lwtstate)) {
-- 
1.8.3.1

