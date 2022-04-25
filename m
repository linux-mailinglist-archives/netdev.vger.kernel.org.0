Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E7750DC3F
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbiDYJT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241610AbiDYJTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:19:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F6EC220EA;
        Mon, 25 Apr 2022 02:16:38 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/4] netfilter: Update ip6_route_me_harder to consider L3 domain
Date:   Mon, 25 Apr 2022 11:16:31 +0200
Message-Id: <20220425091631.109320-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425091631.109320-1-pablo@netfilter.org>
References: <20220425091631.109320-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

The commit referenced below fixed packet re-routing if Netfilter mangles
a routing key property of a packet and the packet is routed in a VRF L3
domain. The fix, however, addressed IPv4 re-routing, only.

This commit applies the same behavior for IPv6. While at it, untangle
the nested ternary operator to make the code more readable.

Fixes: 6d8b49c3a3a3 ("netfilter: Update ip_route_me_harder to consider L3 domain")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Willi <martin@strongswan.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 1da332450d98..8ce60ab89015 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -24,14 +24,13 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct sock *sk = sk_to_full_sk(sk_partial);
+	struct net_device *dev = skb_dst(skb)->dev;
 	struct flow_keys flkeys;
 	unsigned int hh_len;
 	struct dst_entry *dst;
 	int strict = (ipv6_addr_type(&iph->daddr) &
 		      (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL));
 	struct flowi6 fl6 = {
-		.flowi6_oif = sk && sk->sk_bound_dev_if ? sk->sk_bound_dev_if :
-			strict ? skb_dst(skb)->dev->ifindex : 0,
 		.flowi6_mark = skb->mark,
 		.flowi6_uid = sock_net_uid(net, sk),
 		.daddr = iph->daddr,
@@ -39,6 +38,13 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 	};
 	int err;
 
+	if (sk && sk->sk_bound_dev_if)
+		fl6.flowi6_oif = sk->sk_bound_dev_if;
+	else if (strict)
+		fl6.flowi6_oif = dev->ifindex;
+	else
+		fl6.flowi6_oif = l3mdev_master_ifindex(dev);
+
 	fib6_rules_early_flow_dissect(net, skb, &fl6, &flkeys);
 	dst = ip6_route_output(net, sk, &fl6);
 	err = dst->error;
-- 
2.30.2

