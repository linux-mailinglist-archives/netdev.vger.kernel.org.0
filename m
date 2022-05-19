Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E758652DFB8
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 00:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiESWCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 18:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiESWCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 18:02:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1B20E15D5;
        Thu, 19 May 2022 15:02:14 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 01/11] netfilter: Use l3mdev flow key when re-routing mangled packets
Date:   Fri, 20 May 2022 00:01:56 +0200
Message-Id: <20220519220206.722153-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220519220206.722153-1-pablo@netfilter.org>
References: <20220519220206.722153-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

Commit 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif
reset for port devices") introduces a flow key specific for layer 3
domains, such as a VRF master device. This allows for explicit VRF domain
selection instead of abusing the oif flow key.

Update ip[6]_route_me_harder() to make use of that new key when re-routing
mangled packets within VRFs instead of setting the flow oif, making it
consistent with other users.

Signed-off-by: Martin Willi <martin@strongswan.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter.c | 3 +--
 net/ipv6/netfilter.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index aff707988e23..bd135165482a 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -45,8 +45,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	fl4.saddr = saddr;
 	fl4.flowi4_tos = RT_TOS(iph->tos);
 	fl4.flowi4_oif = sk ? sk->sk_bound_dev_if : 0;
-	if (!fl4.flowi4_oif)
-		fl4.flowi4_oif = l3mdev_master_ifindex(dev);
+	fl4.flowi4_l3mdev = l3mdev_master_ifindex(dev);
 	fl4.flowi4_mark = skb->mark;
 	fl4.flowi4_flags = flags;
 	fib4_rules_early_flow_dissect(net, skb, &fl4, &flkeys);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 8ce60ab89015..857713d7a38a 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -31,6 +31,7 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 	int strict = (ipv6_addr_type(&iph->daddr) &
 		      (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL));
 	struct flowi6 fl6 = {
+		.flowi6_l3mdev = l3mdev_master_ifindex(dev),
 		.flowi6_mark = skb->mark,
 		.flowi6_uid = sock_net_uid(net, sk),
 		.daddr = iph->daddr,
@@ -42,8 +43,6 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 		fl6.flowi6_oif = sk->sk_bound_dev_if;
 	else if (strict)
 		fl6.flowi6_oif = dev->ifindex;
-	else
-		fl6.flowi6_oif = l3mdev_master_ifindex(dev);
 
 	fib6_rules_early_flow_dissect(net, skb, &fl6, &flkeys);
 	dst = ip6_route_output(net, sk, &fl6);
-- 
2.30.2

