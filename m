Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874FB3637BA
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbhDRVFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:05:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34980 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbhDRVE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BFC9C63E92;
        Sun, 18 Apr 2021 23:03:59 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 12/14] netfilter: Dissect flow after packet mangling
Date:   Sun, 18 Apr 2021 23:04:13 +0200
Message-Id: <20210418210415.4719-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Netfilter tries to reroute mangled packets as a different route might
need to be used following the mangling. When this happens, netfilter
does not populate the IP protocol, the source port and the destination
port in the flow key. Therefore, FIB rules that match on these fields
are ignored and packets can be misrouted.

Solve this by dissecting the outer flow and populating the flow key
before rerouting the packet. Note that flow dissection only happens when
FIB rules that match on these fields are installed, so in the common
case there should not be a penalty.

Reported-by: Michal Soltys <msoltyspl@yandex.pl>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter.c | 2 ++
 net/ipv6/netfilter.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 7c841037c533..aff707988e23 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -25,6 +25,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	__be32 saddr = iph->saddr;
 	__u8 flags;
 	struct net_device *dev = skb_dst(skb)->dev;
+	struct flow_keys flkeys;
 	unsigned int hh_len;
 
 	sk = sk_to_full_sk(sk);
@@ -48,6 +49,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 		fl4.flowi4_oif = l3mdev_master_ifindex(dev);
 	fl4.flowi4_mark = skb->mark;
 	fl4.flowi4_flags = flags;
+	fib4_rules_early_flow_dissect(net, skb, &fl4, &flkeys);
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index ab9a279dd6d4..6ab710b5a1a8 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -24,6 +24,7 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct sock *sk = sk_to_full_sk(sk_partial);
+	struct flow_keys flkeys;
 	unsigned int hh_len;
 	struct dst_entry *dst;
 	int strict = (ipv6_addr_type(&iph->daddr) &
@@ -38,6 +39,7 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 	};
 	int err;
 
+	fib6_rules_early_flow_dissect(net, skb, &fl6, &flkeys);
 	dst = ip6_route_output(net, sk, &fl6);
 	err = dst->error;
 	if (err) {
-- 
2.30.2

