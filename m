Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE964FDB98
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245215AbiDLKFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384051AbiDLIjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 04:39:01 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Apr 2022 01:04:28 PDT
Received: from mail.strongswan.org (sitav-80046.hsr.ch [152.96.80.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C201208C;
        Tue, 12 Apr 2022 01:04:27 -0700 (PDT)
Received: from think.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id D1830404C0;
        Tue, 12 Apr 2022 09:46:45 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf] netfilter: Update ip6_route_me_harder to consider L3 domain
Date:   Tue, 12 Apr 2022 09:46:39 +0200
Message-Id: <20220412074639.1963131-1-martin@strongswan.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit referenced below fixed packet re-routing if Netfilter mangles
a routing key property of a packet and the packet is routed in a VRF L3
domain. The fix, however, addressed IPv4 re-routing, only.

This commit applies the same behavior for IPv6. While at it, untangle
the nested ternary operator to make the code more readable.

Fixes: 6d8b49c3a3a3 ("netfilter: Update ip_route_me_harder to consider L3 domain")
Signed-off-by: Martin Willi <martin@strongswan.org>
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
2.25.1

