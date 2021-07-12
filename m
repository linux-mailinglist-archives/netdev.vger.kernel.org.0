Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D802B3C5D3F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhGLNaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:30:00 -0400
Received: from relay.sw.ru ([185.231.240.75]:49654 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234399AbhGLN35 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 09:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=lZ+9CCmiNtNI8Lw2KaDwH+6ZCwSCCnwhkFiS9Ee0aP4=; b=s8WhckFoxyMIJDstg15
        3UnYlexK1/0fpZ8AuzencEybnC2cqhelleacHmH180V/UVOgVL0YKUbgkGfzTlSDF+uBz8IFbl4ZB
        FT0es8BeLt4U0y/HRezQiNj6VW/rzqttkX/dBddJyXrFYYppjQ8fNOrIU7MfpyAXKCyuVnNhfZQ=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m2vxg-003iDS-B8; Mon, 12 Jul 2021 16:27:04 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET 4/7] ipv4: use pskb_realloc_headroom in ip_finish_output2
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
 <cover.1626093470.git.vvs@virtuozzo.com>
Message-ID: <f5ce9d4c-3a38-40ea-1e7f-b62a721a20c5@virtuozzo.com>
Date:   Mon, 12 Jul 2021 16:27:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1626093470.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike skb_realloc_headroom, new helper pskb_realloc_headroom
does not allocate a new skb if possible.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv4/ip_output.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c3efc7d..0f66483 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -198,19 +198,11 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 	} else if (rt->rt_type == RTN_BROADCAST)
 		IP_UPD_PO_STATS(net, IPSTATS_MIB_OUTBCAST, skb->len);
 
-	/* Be paranoid, rather than too clever. */
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
-		struct sk_buff *skb2;
+		skb = pskb_realloc_headroom(skb, hh_len);
 
-		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
-		if (!skb2) {
-			kfree_skb(skb);
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

