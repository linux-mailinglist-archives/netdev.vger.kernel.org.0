Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B1F552DB1
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347666AbiFUI4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346557AbiFUI42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:56:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97CDA26551;
        Tue, 21 Jun 2022 01:56:27 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/5] netfilter: use get_random_u32 instead of prandom
Date:   Tue, 21 Jun 2022 10:56:14 +0200
Message-Id: <20220621085618.3975-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220621085618.3975-1-pablo@netfilter.org>
References: <20220621085618.3975-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

bh might occur while updating per-cpu rnd_state from user context,
ie. local_out path.

BUG: using smp_processor_id() in preemptible [00000000] code: nginx/2725
caller is nft_ng_random_eval+0x24/0x54 [nft_numgen]
Call Trace:
 check_preemption_disabled+0xde/0xe0
 nft_ng_random_eval+0x24/0x54 [nft_numgen]

Use the random driver instead, this also avoids need for local prandom
state. Moreover, prandom now uses the random driver since d4150779e60f
("random32: use real rng for non-deterministic randomness").

Based on earlier patch from Pablo Neira.

Fixes: 6b2faee0ca91 ("netfilter: nft_meta: place prandom handling in a helper")
Fixes: 978d8f9055c3 ("netfilter: nft_numgen: add map lookups for numgen random operations")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c   | 13 ++-----------
 net/netfilter/nft_numgen.c | 12 +++---------
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ac4859241e17..55d2d49c3425 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -14,6 +14,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/random.h>
 #include <linux/smp.h>
 #include <linux/static_key.h>
 #include <net/dst.h>
@@ -32,8 +33,6 @@
 #define NFT_META_SECS_PER_DAY		86400
 #define NFT_META_DAYS_PER_WEEK		7
 
-static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
-
 static u8 nft_meta_weekday(void)
 {
 	time64_t secs = ktime_get_real_seconds();
@@ -271,13 +270,6 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 	return true;
 }
 
-static noinline u32 nft_prandom_u32(void)
-{
-	struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
-
-	return prandom_u32_state(state);
-}
-
 #ifdef CONFIG_IP_ROUTE_CLASSID
 static noinline bool
 nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
@@ -389,7 +381,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		break;
 #endif
 	case NFT_META_PRANDOM:
-		*dest = nft_prandom_u32();
+		*dest = get_random_u32();
 		break;
 #ifdef CONFIG_XFRM
 	case NFT_META_SECPATH:
@@ -518,7 +510,6 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 	case NFT_META_PRANDOM:
-		prandom_init_once(&nft_prandom_state);
 		len = sizeof(u32);
 		break;
 #ifdef CONFIG_XFRM
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 81b40c663d86..45d3dc9e96f2 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -9,12 +9,11 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/random.h>
 #include <linux/static_key.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 
-static DEFINE_PER_CPU(struct rnd_state, nft_numgen_prandom_state);
-
 struct nft_ng_inc {
 	u8			dreg;
 	u32			modulus;
@@ -135,12 +134,9 @@ struct nft_ng_random {
 	u32			offset;
 };
 
-static u32 nft_ng_random_gen(struct nft_ng_random *priv)
+static u32 nft_ng_random_gen(const struct nft_ng_random *priv)
 {
-	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
-
-	return reciprocal_scale(prandom_u32_state(state), priv->modulus) +
-	       priv->offset;
+	return reciprocal_scale(get_random_u32(), priv->modulus) + priv->offset;
 }
 
 static void nft_ng_random_eval(const struct nft_expr *expr,
@@ -168,8 +164,6 @@ static int nft_ng_random_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	prandom_init_once(&nft_numgen_prandom_state);
-
 	return nft_parse_register_store(ctx, tb[NFTA_NG_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, sizeof(u32));
 }
-- 
2.30.2

