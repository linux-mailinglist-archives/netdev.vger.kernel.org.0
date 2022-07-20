Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A2857C09D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiGTXI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiGTXIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1790568727;
        Wed, 20 Jul 2022 16:08:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 18/18] netfilter: xt_TPROXY: remove pr_debug invocations
Date:   Thu, 21 Jul 2022 01:07:54 +0200
Message-Id: <20220720230754.209053-19-pablo@netfilter.org>
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

From: Justin Stitt <justinstitt@google.com>

pr_debug calls are no longer needed in this file.

Pablo suggested "a patch to remove these pr_debug calls". This patch has
some other beneficial collateral as it also silences multiple Clang
-Wformat warnings that were present in the pr_debug calls.

diff from v1 -> v2:
* converted if statement one-liner style
* x == NULL is now !x

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TPROXY.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 459d0696c91a..e4bea1d346cf 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -74,18 +74,10 @@ tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~mark_mask) ^ mark_value;
-
-		pr_debug("redirecting: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
-			 iph->protocol, &iph->daddr, ntohs(hp->dest),
-			 &laddr, ntohs(lport), skb->mark);
-
 		nf_tproxy_assign_sock(skb, sk);
 		return NF_ACCEPT;
 	}
 
-	pr_debug("no socket, dropping: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
-		 iph->protocol, &iph->saddr, ntohs(hp->source),
-		 &iph->daddr, ntohs(hp->dest), skb->mark);
 	return NF_DROP;
 }
 
@@ -122,16 +114,12 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	int tproto;
 
 	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
-	if (tproto < 0) {
-		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
+	if (tproto < 0)
 		return NF_DROP;
-	}
 
 	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
-	if (hp == NULL) {
-		pr_debug("unable to grab transport header contents in IPv6 packet, dropping\n");
+	if (!hp)
 		return NF_DROP;
-	}
 
 	/* check if there's an ongoing connection on the packet
 	 * addresses, this happens if the redirect already happened
@@ -168,19 +156,10 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
-
-		pr_debug("redirecting: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
-			 tproto, &iph->saddr, ntohs(hp->source),
-			 laddr, ntohs(lport), skb->mark);
-
 		nf_tproxy_assign_sock(skb, sk);
 		return NF_ACCEPT;
 	}
 
-	pr_debug("no socket, dropping: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
-		 tproto, &iph->saddr, ntohs(hp->source),
-		 &iph->daddr, ntohs(hp->dest), skb->mark);
-
 	return NF_DROP;
 }
 
-- 
2.30.2

