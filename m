Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EFD3C2135
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhGIJIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:08:41 -0400
Received: from relay.sw.ru ([185.231.240.75]:59616 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhGIJIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 05:08:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=5IC5mFOPOS1MYS+1HKMaliBZpQ6ReLTErUGh1yA0hKY=; b=roQp0qK+YgXRwKYEp+z
        l7PwAFEYtz3WeqRY/IrJU9/diaoq1Zk1Q/Lr6u65L9ig0A6WNH9Cy7ph0BILAb32936Q1aTxNpKWS
        ntd4oP1wwx+DzQKy3pMA1EbRCU2wyY4hLLvY8nOp47BL1d7goP+cprx+hFxEmevg9pTf02a+Q0o=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m1mSK-003Pm1-Qs; Fri, 09 Jul 2021 12:05:56 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH IPV6 v2 4/4] ipv6: ip6_xmit refactoring
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
 <cover.1625818825.git.vvs@virtuozzo.com>
Message-ID: <a3120d9c-e6c6-13d0-31ce-6f9a9d8f57a6@virtuozzo.com>
Date:   Fri, 9 Jul 2021 12:05:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1625818825.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commonly used dereferences was replaced by variables.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv6/ip6_output.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 9ae3baa..5e33429 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -273,6 +273,8 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	const struct ipv6_pinfo *np = inet6_sk(sk);
 	struct in6_addr *first_hop = &fl6->daddr;
 	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev = dst->dev;
+	struct inet6_dev *idev = ip6_dst_idev(dst);
 	unsigned int head_room;
 	struct ipv6hdr *hdr;
 	u8  proto = fl6->flowi6_proto;
@@ -280,7 +282,7 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	int delta, hlimit = -1;
 	u32 mtu;
 
-	head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dst->dev);
+	head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dev);
 	if (opt)
 		head_room += opt->opt_nflen + opt->opt_flen;
 
@@ -288,8 +290,7 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	if (unlikely(delta > 0)) {
 		skb = skb_expand_head(skb, delta);
 		if (!skb) {
-			IP6_INC_STATS(net, ip6_dst_idev(dst),
-				      IPSTATS_MIB_OUTDISCARDS);
+			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 			return -ENOBUFS;
 		}
 	}
@@ -333,8 +334,7 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 
 	mtu = dst_mtu(dst);
 	if ((skb->len <= mtu) || skb->ignore_df || skb_is_gso(skb)) {
-		IP6_UPD_PO_STATS(net, ip6_dst_idev(skb_dst(skb)),
-			      IPSTATS_MIB_OUT, skb->len);
+		IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
 
 		/* if egress device is enslaved to an L3 master device pass the
 		 * skb to its handler for processing
@@ -347,17 +347,17 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 		 * we promote our socket to non const
 		 */
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT,
-			       net, (struct sock *)sk, skb, NULL, dst->dev,
+			       net, (struct sock *)sk, skb, NULL, dev,
 			       dst_output);
 	}
 
-	skb->dev = dst->dev;
+	skb->dev = dev;
 	/* ipv6_local_error() does not require socket lock,
 	 * we promote our socket to non const
 	 */
 	ipv6_local_error((struct sock *)sk, EMSGSIZE, fl6, mtu);
 
-	IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_FRAGFAILS);
+	IP6_INC_STATS(net, idev, IPSTATS_MIB_FRAGFAILS);
 	kfree_skb(skb);
 	return -EMSGSIZE;
 }
-- 
1.8.3.1

