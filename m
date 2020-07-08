Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67240218EBD
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgGHRqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:46:24 -0400
Received: from correo.us.es ([193.147.175.20]:34720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgGHRqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:46:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C8BE33066A8
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B34EADA796
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A8673DA78F; Wed,  8 Jul 2020 19:46:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B959DA72F;
        Wed,  8 Jul 2020 19:46:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 19:46:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4CDE34265A2F;
        Wed,  8 Jul 2020 19:46:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 01/12] netfilter: introduce support for reject at prerouting stage
Date:   Wed,  8 Jul 2020 19:45:58 +0200
Message-Id: <20200708174609.1343-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708174609.1343-1-pablo@netfilter.org>
References: <20200708174609.1343-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

REJECT statement can be only used in INPUT, FORWARD and OUTPUT
chains. This patch adds support of REJECT, both icmp and tcp
reset, at PREROUTING stage.

The need for this patch comes from the requirement of some
forwarding devices to reject traffic before the natting and
routing decisions.

The main use case is to be able to send a graceful termination
to legitimate clients that, under any circumstances, the NATed
endpoints are not available. This option allows clients to
decide either to perform a reconnection or manage the error in
their side, instead of just dropping the connection and let
them die due to timeout.

It is supported ipv4, ipv6 and inet families for nft
infrastructure.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 21 +++++++++++++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 26 ++++++++++++++++++++++++++
 net/netfilter/nft_reject.c          |  3 ++-
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 2361fdac2c43..9dcfa4e461b6 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -96,6 +96,21 @@ void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *oldskb,
 }
 EXPORT_SYMBOL_GPL(nf_reject_ip_tcphdr_put);
 
+static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
+{
+	struct dst_entry *dst = NULL;
+	struct flowi fl;
+
+	memset(&fl, 0, sizeof(struct flowi));
+	fl.u.ip4.daddr = ip_hdr(skb_in)->saddr;
+	nf_ip_route(dev_net(skb_in->dev), &dst, &fl, false);
+	if (!dst)
+		return -1;
+
+	skb_dst_set(skb_in, dst);
+	return 0;
+}
+
 /* Send RST reply */
 void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 {
@@ -109,6 +124,9 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	if (!oth)
 		return;
 
+	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(oldskb))
+		return;
+
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		return;
 
@@ -175,6 +193,9 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
+	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(skb_in))
+		return;
+
 	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 		return;
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5fae66f66671..4aef6baaa55e 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -126,6 +126,21 @@ void nf_reject_ip6_tcphdr_put(struct sk_buff *nskb,
 }
 EXPORT_SYMBOL_GPL(nf_reject_ip6_tcphdr_put);
 
+static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
+{
+	struct dst_entry *dst = NULL;
+	struct flowi fl;
+
+	memset(&fl, 0, sizeof(struct flowi));
+	fl.u.ip6.daddr = ipv6_hdr(skb_in)->saddr;
+	nf_ip6_route(dev_net(skb_in->dev), &dst, &fl, false);
+	if (!dst)
+		return -1;
+
+	skb_dst_set(skb_in, dst);
+	return 0;
+}
+
 void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 {
 	struct net_device *br_indev __maybe_unused;
@@ -154,6 +169,14 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 	fl6.daddr = oip6h->saddr;
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
+
+	if (hook == NF_INET_PRE_ROUTING) {
+		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
+		if (!dst)
+			return;
+		skb_dst_set(oldskb, dst);
+	}
+
 	fl6.flowi6_oif = l3mdev_master_ifindex(skb_dst(oldskb)->dev);
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, oldskb->mark);
 	security_skb_classify_flow(oldskb, flowi6_to_flowi(&fl6));
@@ -245,6 +268,9 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	if (hooknum == NF_INET_PRE_ROUTING && nf_reject6_fill_skb_dst(skb_in))
+		return;
+
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
 }
 EXPORT_SYMBOL_GPL(nf_send_unreach6);
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 86eafbb0fdd0..61fb7e8afbf0 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -30,7 +30,8 @@ int nft_reject_validate(const struct nft_ctx *ctx,
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_LOCAL_IN) |
 					(1 << NF_INET_FORWARD) |
-					(1 << NF_INET_LOCAL_OUT));
+					(1 << NF_INET_LOCAL_OUT) |
+					(1 << NF_INET_PRE_ROUTING));
 }
 EXPORT_SYMBOL_GPL(nft_reject_validate);
 
-- 
2.20.1

