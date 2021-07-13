Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F43D3C7858
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 22:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhGMVBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 17:01:13 -0400
Received: from relay.sw.ru ([185.231.240.75]:56780 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235974AbhGMVBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 17:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=LBHkRwPVEMlYau3k6VzHYQbsTeF/OcLEn5fTEBQXyLU=; b=HzdCc7DN85KT+fuvRTX
        5V2AmQ9oI3KakPGeJ2qFfGVX+/+/Sl1fRJj6goIS75dY8Z3s95kjY9E6djDMDv3Wbg5Je+C/wr/Tx
        U1RqYbu/r+U7sGW+fkduQvGptFvAj4LjWCW0VUvnKQQHCIgQUcHknliY0Kivzhywx5b6Wh3eFrY=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m3PTu-003sZz-VM; Tue, 13 Jul 2021 23:58:18 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v2 4/7] ipv4: use skb_expand_head in ip_finish_output2
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <55c9e2ae-b060-baa2-460c-90eb3e9ded5c@virtuozzo.com>
 <cover.1626206993.git.vvs@virtuozzo.com>
Message-ID: <9a21bf71-d224-a953-0648-47da136cb33b@virtuozzo.com>
Date:   Tue, 13 Jul 2021 23:58:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1626206993.git.vvs@virtuozzo.com>
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
index c3efc7d..5b2f6ea 100644
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

