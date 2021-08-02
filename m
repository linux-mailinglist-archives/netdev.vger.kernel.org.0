Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4513D3DD252
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhHBIwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:52:47 -0400
Received: from relay.sw.ru ([185.231.240.75]:44406 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232977AbhHBIwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=1UovdOxZifIF7TcwgsWVfVFcW1UxG7phFACNfC2QUDI=; b=Gi92/276B1VC2l1p/en
        xxQDuHPO0wjGgDuwK+VaLzrBaEBXfjc8Fe2amjiuOr/o6jQ2CVFefPNz+Aj0uywh9ccmj1DgiE1a0
        EE1S+p/jl07viaPuC4zkoLFsenCA+yGfLCPtwhSg96CcpVO1+0HLd+NJHHuQFSdPlwXC/U+pvKk=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mATgU-0060Ns-0J; Mon, 02 Aug 2021 11:52:30 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v3 3/7] ipv6: use skb_expand_head in ip6_xmit
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <15eba3b2-80e2-5547-8ad9-167d810ad7e3@virtuozzo.com>
 <cover.1627891754.git.vvs@virtuozzo.com>
Message-ID: <74effa89-ae5f-299f-c8d4-543ed1560730@virtuozzo.com>
Date:   Mon, 2 Aug 2021 11:52:29 +0300
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

Additionally this patch replaces commonly used dereferencing with variables.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv6/ip6_output.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 7d2ec25..f91d13a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -249,6 +249,8 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	const struct ipv6_pinfo *np = inet6_sk(sk);
 	struct in6_addr *first_hop = &fl6->daddr;
 	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev = dst->dev;
+	struct inet6_dev *idev = ip6_dst_idev(dst);
 	unsigned int head_room;
 	struct ipv6hdr *hdr;
 	u8  proto = fl6->flowi6_proto;
@@ -256,22 +258,16 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	int hlimit = -1;
 	u32 mtu;
 
-	head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dst->dev);
+	head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dev);
 	if (opt)
 		head_room += opt->opt_nflen + opt->opt_flen;
 
-	if (unlikely(skb_headroom(skb) < head_room)) {
-		struct sk_buff *skb2 = skb_realloc_headroom(skb, head_room);
-		if (!skb2) {
-			IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
-				      IPSTATS_MIB_OUTDISCARDS);
-			kfree_skb(skb);
+	if (unlikely(head_room > skb_headroom(skb))) {
+		skb = skb_expand_head(skb, head_room);
+		if (!skb) {
+			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 			return -ENOBUFS;
 		}
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-		consume_skb(skb);
-		skb = skb2;
 	}
 
 	if (opt) {
@@ -313,8 +309,7 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 
 	mtu = dst_mtu(dst);
 	if ((skb->len <= mtu) || skb->ignore_df || skb_is_gso(skb)) {
-		IP6_UPD_PO_STATS(net, ip6_dst_idev(skb_dst(skb)),
-			      IPSTATS_MIB_OUT, skb->len);
+		IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
 
 		/* if egress device is enslaved to an L3 master device pass the
 		 * skb to its handler for processing
@@ -327,17 +322,17 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
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

