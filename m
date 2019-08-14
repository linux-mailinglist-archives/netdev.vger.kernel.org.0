Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED838CF53
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfHNJY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:24:56 -0400
Received: from correo.us.es ([193.147.175.20]:42598 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbfHNJYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 05:24:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33972C40EA
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 11:24:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21B6C1150DF
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 11:24:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 173061150DD; Wed, 14 Aug 2019 11:24:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A2D0DA704;
        Wed, 14 Aug 2019 11:24:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 11:24:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B43BC4265A2F;
        Wed, 14 Aug 2019 11:24:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/7] netfilter: nf_flow_table: fix offload for flows that are subject to xfrm
Date:   Wed, 14 Aug 2019 11:24:35 +0200
Message-Id: <20190814092440.20087-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190814092440.20087-1-pablo@netfilter.org>
References: <20190814092440.20087-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This makes the previously added 'encap test' pass.
Because its possible that the xfrm dst entry becomes stale while such
a flow is offloaded, we need to call dst_check() -- the notifier that
handles this for non-tunneled traffic isn't sufficient, because SA or
or policies might have changed.

If dst becomes stale the flow offload entry will be tagged for teardown
and packets will be passed to 'classic' forwarding path.

Removing the entry right away is problematic, as this would
introduce a race condition with the gc worker.

In case flow is long-lived, it could eventually be offloaded again
once the gc worker removes the entry from the flow table.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 43 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index cdfc33517e85..d68c801dd614 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -214,6 +214,25 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
+static int nf_flow_offload_dst_check(struct dst_entry *dst)
+{
+	if (unlikely(dst_xfrm(dst)))
+		return dst_check(dst, 0) ? 0 : -1;
+
+	return 0;
+}
+
+static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
+				      const struct nf_hook_state *state,
+				      struct dst_entry *dst)
+{
+	skb_orphan(skb);
+	skb_dst_set_noref(skb, dst);
+	skb->tstamp = 0;
+	dst_output(state->net, state->sk, skb);
+	return NF_STOLEN;
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -254,6 +273,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip_hdr(skb)->protocol, skb, thoff))
 		return NF_ACCEPT;
 
+	if (nf_flow_offload_dst_check(&rt->dst)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
@@ -261,6 +285,13 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	iph = ip_hdr(skb);
 	ip_decrease_ttl(iph);
 
+	if (unlikely(dst_xfrm(&rt->dst))) {
+		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
+		IPCB(skb)->iif = skb->dev->ifindex;
+		IPCB(skb)->flags = IPSKB_FORWARDED;
+		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+	}
+
 	skb->dev = outdev;
 	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
 	skb_dst_set_noref(skb, &rt->dst);
@@ -467,6 +498,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				sizeof(*ip6h)))
 		return NF_ACCEPT;
 
+	if (nf_flow_offload_dst_check(&rt->dst)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
@@ -477,6 +513,13 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	ip6h = ipv6_hdr(skb);
 	ip6h->hop_limit--;
 
+	if (unlikely(dst_xfrm(&rt->dst))) {
+		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
+		IP6CB(skb)->iif = skb->dev->ifindex;
+		IP6CB(skb)->flags = IP6SKB_FORWARDED;
+		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+	}
+
 	skb->dev = outdev;
 	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
 	skb_dst_set_noref(skb, &rt->dst);
-- 
2.11.0


