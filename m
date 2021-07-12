Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE66B3C5D3A
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhGLN3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:29:42 -0400
Received: from relay.sw.ru ([185.231.240.75]:49592 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234001AbhGLN3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 09:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=DUn5Ltz9M+u4OlQ6WAeu3tFX8fPI2rXr7aGAM2BNPgQ=; b=hZnhvFGJa3LxCWol/5d
        iOEGMhf88d3jbssLA7IYhVQa9+C0Ju8Hp21lCepei2tX54/FJM+4BYajb9NZdryTIt1imRWl8nvwx
        i/e78jj1xU6QzOKlKWchHfsoJJPYseZYrAsJbD+TIzJ55ykB9ldDYMPBeu3P554DPvf/bocG3+o=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m2vxT-003iCS-Ao; Mon, 12 Jul 2021 16:26:51 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET 2/7] ipv6: use pskb_realloc_headroom in ip6_finish_output2
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
 <cover.1626093470.git.vvs@virtuozzo.com>
Message-ID: <3aedce31-27c1-f654-e88e-cd98f51e900b@virtuozzo.com>
Date:   Mon, 12 Jul 2021 16:26:50 +0300
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

Additionally this patch replaces commonly used dereferencing with variables.
---
NB: this patch depends on
"ipv6: allocate enough headroom in ip6_finish_output2()"
https://lkml.org/lkml/2021/7/12/732

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv6/ip6_output.c | 50 ++++++++++++++++----------------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0efcb9b..2054da3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -60,46 +60,30 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
+	struct inet6_dev *idev = ip6_dst_idev(dst);
 	unsigned int hh_len = LL_RESERVED_SPACE(dev);
-	int delta = hh_len - skb_headroom(skb);
-	const struct in6_addr *nexthop;
+	const struct in6_addr *daddr, *nexthop;
+	struct ipv6hdr *hdr;
 	struct neighbour *neigh;
 	int ret;
 
 	/* Be paranoid, rather than too clever. */
-	if (unlikely(delta > 0) && dev->header_ops) {
-		/* pskb_expand_head() might crash, if skb is shared */
-		if (skb_shared(skb)) {
-			struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
+	if (unlikely(hh_len > skb_headroom(skb)) && dev->header_ops) {
+		skb = pskb_realloc_headroom(skb, hh_len);
 
-			if (likely(nskb)) {
-				if (skb->sk)
-					skb_set_owner_w(skb, skb->sk);
-				consume_skb(skb);
-			} else {
-				kfree_skb(skb);
-			}
-			skb = nskb;
-		}
-		if (skb &&
-		    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
-			kfree_skb(skb);
-			skb = NULL;
-		}
 		if (!skb) {
-			IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTDISCARDS);
+			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 			return -ENOMEM;
 		}
 	}
 
-	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
-		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
-
+	hdr = ipv6_hdr(skb);
+	daddr = &hdr->daddr;
+	if (ipv6_addr_is_multicast(daddr)) {
 		if (!(dev->flags & IFF_LOOPBACK) && sk_mc_loop(sk) &&
 		    ((mroute6_is_socket(net, skb) &&
 		     !(IP6CB(skb)->flags & IP6SKB_FORWARDED)) ||
-		     ipv6_chk_mcast_addr(dev, &ipv6_hdr(skb)->daddr,
-					 &ipv6_hdr(skb)->saddr))) {
+		     ipv6_chk_mcast_addr(dev, daddr, &hdr->saddr))) {
 			struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
 
 			/* Do not check for IFF_ALLMULTI; multicast routing
@@ -110,7 +94,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 					net, sk, newskb, NULL, newskb->dev,
 					dev_loopback_xmit);
 
-			if (ipv6_hdr(skb)->hop_limit == 0) {
+			if (hdr->hop_limit == 0) {
 				IP6_INC_STATS(net, idev,
 					      IPSTATS_MIB_OUTDISCARDS);
 				kfree_skb(skb);
@@ -119,9 +103,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 		}
 
 		IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUTMCAST, skb->len);
-
-		if (IPV6_ADDR_MC_SCOPE(&ipv6_hdr(skb)->daddr) <=
-		    IPV6_ADDR_SCOPE_NODELOCAL &&
+		if (IPV6_ADDR_MC_SCOPE(daddr) <= IPV6_ADDR_SCOPE_NODELOCAL &&
 		    !(dev->flags & IFF_LOOPBACK)) {
 			kfree_skb(skb);
 			return 0;
@@ -136,10 +118,10 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	}
 
 	rcu_read_lock_bh();
-	nexthop = rt6_nexthop((struct rt6_info *)dst, &ipv6_hdr(skb)->daddr);
-	neigh = __ipv6_neigh_lookup_noref(dst->dev, nexthop);
+	nexthop = rt6_nexthop((struct rt6_info *)dst, daddr);
+	neigh = __ipv6_neigh_lookup_noref(dev, nexthop);
 	if (unlikely(!neigh))
-		neigh = __neigh_create(&nd_tbl, nexthop, dst->dev, false);
+		neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
 	if (!IS_ERR(neigh)) {
 		sock_confirm_neigh(skb, neigh);
 		ret = neigh_output(neigh, skb, false);
@@ -148,7 +130,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	}
 	rcu_read_unlock_bh();
 
-	IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
+	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
 	kfree_skb(skb);
 	return -EINVAL;
 }
-- 
1.8.3.1

