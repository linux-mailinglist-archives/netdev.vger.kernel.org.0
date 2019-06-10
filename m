Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67843B262
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 11:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389105AbfFJJoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 05:44:38 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40142 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387977AbfFJJoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 05:44:38 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1haGqv-0001lH-Bq; Mon, 10 Jun 2019 11:44:33 +0200
Date:   Mon, 10 Jun 2019 11:44:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
Message-ID: <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> nft add rule bridge firewall rule-100-ingress ip protocol icmp drop

nft --debug=netlink add rule bridge firewall rule-100-ingress ip protocol icmp drop
bridge firewall rule-100-ingress
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ immediate reg 0 drop ]

so problem is that nft inserts a dependency on the ethernet protocol
type (0x800).

But when vlan is involved, that will fail to compare.

It would also fail for qinq etc.

Because of vlan tag offload, the rule about will probably already work
just fine when nft userspace is patched to insert the dependency based
on 'meta protocol'.  Can you see if this patch works?

Subject: Change bridge l3 dependency to meta protocol

This examines skb->protocol instead of ethernet header type, which
might be different when vlan is involved.

nft payload expression will re-insert the vlan tag so ether type
will not be ETH_P_IP.

---
 src/meta.c    |  6 +++++-
 src/payload.c | 20 ++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/src/meta.c b/src/meta.c
index 583e790ff47d..1e8964eb48c4 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -539,7 +539,11 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 		proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR, &expr->location, desc);
 		break;
 	case NFT_META_PROTOCOL:
-		if (h->base < PROTO_BASE_NETWORK_HDR && ctx->family != NFPROTO_NETDEV)
+		if (h->base != PROTO_BASE_LL_HDR)
+			return;
+
+		if (ctx->family != NFPROTO_NETDEV &&
+		    ctx->family != NFPROTO_BRIDGE)
 			return;
 
 		desc = proto_find_upper(h->desc, ntohs(mpz_get_uint16(right->value)));
diff --git a/src/payload.c b/src/payload.c
index 6a8118ece890..c99bb2f69977 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -18,6 +18,7 @@
 #include <net/if_arp.h>
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
+#include <linux/if_ether.h>
 
 #include <rule.h>
 #include <expression.h>
@@ -307,6 +308,19 @@ payload_gen_special_dependency(struct eval_ctx *ctx, const struct expr *expr)
 	return NULL;
 }
 
+static const struct proto_desc proto_metaeth = {
+	.name		= "ethmeta",
+	.base		= PROTO_BASE_LL_HDR,
+	.protocols	= {
+		PROTO_LINK(__constant_htons(ETH_P_IP),	 &proto_ip),
+		PROTO_LINK(__constant_htons(ETH_P_ARP),	 &proto_arp),
+		PROTO_LINK(__constant_htons(ETH_P_IPV6), &proto_ip6),
+	},
+	.templates	= {
+		[0]	= PROTO_META_TEMPLATE("protocol", &ethertype_type, NFT_META_PROTOCOL, 16),
+	},
+};
+
 /**
  * payload_gen_dependency - generate match expression on payload dependency
  *
@@ -369,6 +383,12 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  "no %s protocol specified",
 				  proto_base_names[expr->payload.base - 1]);
 
+	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
+		if (expr->payload.desc == &proto_ip ||
+		    expr->payload.desc == &proto_ip6)
+			desc = &proto_metaeth;
+	}
+
 	return payload_add_dependency(ctx, desc, expr->payload.desc, expr, res);
 }
 
-- 
2.21.0

