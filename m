Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FEF3A3181
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhFJQ5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:57:06 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34640 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhFJQ5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:57:03 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 93BEE64240;
        Thu, 10 Jun 2021 18:53:51 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/3] netfilter: nft_fib_ipv6: skip ipv6 packets from any to link-local
Date:   Thu, 10 Jun 2021 18:54:58 +0200
Message-Id: <20210610165458.23071-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210610165458.23071-1-pablo@netfilter.org>
References: <20210610165458.23071-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The ip6tables rpfilter match has an extra check to skip packets with
"::" source address.

Extend this to ipv6 fib expression.  Else ipv6 duplicate address detection
packets will fail rpf route check -- lookup returns -ENETUNREACH.

While at it, extend the prerouting check to also cover the ingress hook.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1543
Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nft_fib_ipv6.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index e204163c7036..92f3235fa287 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -135,6 +135,17 @@ void nft_fib6_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 }
 EXPORT_SYMBOL_GPL(nft_fib6_eval_type);
 
+static bool nft_fib_v6_skip_icmpv6(const struct sk_buff *skb, u8 next, const struct ipv6hdr *iph)
+{
+	if (likely(next != IPPROTO_ICMPV6))
+		return false;
+
+	if (ipv6_addr_type(&iph->saddr) != IPV6_ADDR_ANY)
+		return false;
+
+	return ipv6_addr_type(&iph->daddr) & IPV6_ADDR_LINKLOCAL;
+}
+
 void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt)
 {
@@ -163,10 +174,13 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
 
-	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
-	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, nft_in(pkt));
-		return;
+	if (nft_hook(pkt) == NF_INET_PRE_ROUTING ||
+	    nft_hook(pkt) == NF_INET_INGRESS) {
+		if (nft_fib_is_loopback(pkt->skb, nft_in(pkt)) ||
+		    nft_fib_v6_skip_icmpv6(pkt->skb, pkt->tprot, iph)) {
+			nft_fib_store_result(dest, priv, nft_in(pkt));
+			return;
+		}
 	}
 
 	*dest = 0;
-- 
2.20.1

