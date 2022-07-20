Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC3F57C099
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiGTXIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiGTXIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54F0665561;
        Wed, 20 Jul 2022 16:08:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 13/18] netfilter: nf_tables: use correct integer types
Date:   Thu, 21 Jul 2022 01:07:49 +0200
Message-Id: <20220720230754.209053-14-pablo@netfilter.org>
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

Sparse tool complains about mixing of different endianess
types, so use the correct ones.

Add type casts where needed.

objdiff shows no changes except in nft_tunnel (type is changed).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_cmp.c    |  6 +++---
 net/netfilter/nft_ct.c     |  4 ++--
 net/netfilter/nft_exthdr.c | 10 +++++-----
 net/netfilter/nft_tunnel.c |  3 ++-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 6528f76ca29e..bec22584395f 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -125,13 +125,13 @@ static void nft_payload_n2h(union nft_cmp_offload_data *data,
 {
 	switch (len) {
 	case 2:
-		data->val16 = ntohs(*((u16 *)val));
+		data->val16 = ntohs(*((__be16 *)val));
 		break;
 	case 4:
-		data->val32 = ntohl(*((u32 *)val));
+		data->val32 = ntohl(*((__be32 *)val));
 		break;
 	case 8:
-		data->val64 = be64_to_cpu(*((u64 *)val));
+		data->val64 = be64_to_cpu(*((__be64 *)val));
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d8e1614918a1..b04995c3e17f 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -204,12 +204,12 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	case NFT_CT_SRC_IP:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
 			goto err;
-		*dest = tuple->src.u3.ip;
+		*dest = (__force __u32)tuple->src.u3.ip;
 		return;
 	case NFT_CT_DST_IP:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
 			goto err;
-		*dest = tuple->dst.u3.ip;
+		*dest = (__force __u32)tuple->dst.u3.ip;
 		return;
 	case NFT_CT_SRC_IP6:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV6)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 22c3e05b52db..a67ea9c3ae57 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -266,7 +266,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 		switch (priv->len) {
 		case 2:
-			old.v16 = get_unaligned((u16 *)(opt + offset));
+			old.v16 = (__force __be16)get_unaligned((u16 *)(opt + offset));
 			new.v16 = (__force __be16)nft_reg_load16(
 				&regs->data[priv->sreg]);
 
@@ -281,18 +281,18 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 			if (old.v16 == new.v16)
 				return;
 
-			put_unaligned(new.v16, (u16*)(opt + offset));
+			put_unaligned(new.v16, (__be16*)(opt + offset));
 			inet_proto_csum_replace2(&tcph->check, pkt->skb,
 						 old.v16, new.v16, false);
 			break;
 		case 4:
-			new.v32 = regs->data[priv->sreg];
-			old.v32 = get_unaligned((u32 *)(opt + offset));
+			new.v32 = nft_reg_load_be32(&regs->data[priv->sreg]);
+			old.v32 = (__force __be32)get_unaligned((u32 *)(opt + offset));
 
 			if (old.v32 == new.v32)
 				return;
 
-			put_unaligned(new.v32, (u32*)(opt + offset));
+			put_unaligned(new.v32, (__be32*)(opt + offset));
 			inet_proto_csum_replace4(&tcph->check, pkt->skb,
 						 old.v32, new.v32, false);
 			break;
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index d0f9b1d51b0e..5edaaded706d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -383,8 +383,9 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 				    struct ip_tunnel_info *info,
 				    struct nft_tunnel_opts *opts)
 {
-	int err, rem, type = 0;
 	struct nlattr *nla;
+	__be16 type = 0;
+	int err, rem;
 
 	err = nla_validate_nested_deprecated(attr, NFTA_TUNNEL_KEY_OPTS_MAX,
 					     nft_tunnel_opts_policy, NULL);
-- 
2.30.2

