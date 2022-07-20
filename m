Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D58357C086
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiGTXIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiGTXII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 945091D0DA;
        Wed, 20 Jul 2022 16:08:05 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 10/18] netfilter: x_tables: use correct integer types
Date:   Thu, 21 Jul 2022 01:07:46 +0200
Message-Id: <20220720230754.209053-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720230754.209053-1-pablo@netfilter.org>
References: <20220720230754.209053-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Sparse complains because __be32 and u32 are mixed without
conversions.  Use the correct types, no code changes.

Furthermore, xt_DSCP generates a bit truncation warning:
"cast truncates bits from constant value (ffffff03 becomes 3)"

The truncation is fine (and wanted). Add a private definition and use that
instead.

objdiff shows no changes.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_DSCP.c      | 8 ++++----
 net/netfilter/xt_TCPMSS.c    | 4 ++--
 net/netfilter/xt_connlimit.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index eababc354ff1..cfa44515ab72 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -24,6 +24,8 @@ MODULE_ALIAS("ip6t_DSCP");
 MODULE_ALIAS("ipt_TOS");
 MODULE_ALIAS("ip6t_TOS");
 
+#define XT_DSCP_ECN_MASK	3u
+
 static unsigned int
 dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -34,8 +36,7 @@ dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 
-		ipv4_change_dsfield(ip_hdr(skb),
-				    (__force __u8)(~XT_DSCP_MASK),
+		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
 				    dinfo->dscp << XT_DSCP_SHIFT);
 
 	}
@@ -52,8 +53,7 @@ dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
 			return NF_DROP;
 
-		ipv6_change_dsfield(ipv6_hdr(skb),
-				    (__force __u8)(~XT_DSCP_MASK),
+		ipv6_change_dsfield(ipv6_hdr(skb), XT_DSCP_ECN_MASK,
 				    dinfo->dscp << XT_DSCP_SHIFT);
 	}
 	return XT_CONTINUE;
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 122db9fbb9f4..116a885adb3c 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -239,8 +239,8 @@ tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		oldlen = ipv6h->payload_len;
 		newlen = htons(ntohs(oldlen) + ret);
 		if (skb->ip_summed == CHECKSUM_COMPLETE)
-			skb->csum = csum_add(csum_sub(skb->csum, oldlen),
-					     newlen);
+			skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)oldlen),
+					     (__force __wsum)newlen);
 		ipv6h->payload_len = newlen;
 	}
 	return XT_CONTINUE;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 46fcac75f726..5d04ef80a61d 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -62,10 +62,10 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		key[4] = zone->id;
 	} else {
 		const struct iphdr *iph = ip_hdr(skb);
-		key[0] = (info->flags & XT_CONNLIMIT_DADDR) ?
-			  iph->daddr : iph->saddr;
 
-		key[0] &= info->mask.ip;
+		key[0] = (info->flags & XT_CONNLIMIT_DADDR) ?
+			 (__force __u32)iph->daddr : (__force __u32)iph->saddr;
+		key[0] &= (__force __u32)info->mask.ip;
 		key[1] = zone->id;
 	}
 
-- 
2.30.2

