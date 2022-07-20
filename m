Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422B557C09A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiGTXIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiGTXIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0D4262A72;
        Wed, 20 Jul 2022 16:08:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 12/18] netfilter: nf_tables: add and use BE register load-store helpers
Date:   Thu, 21 Jul 2022 01:07:48 +0200
Message-Id: <20220720230754.209053-13-pablo@netfilter.org>
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

Same as the existing ones, no conversions. This is just for sparse sake
only so that we no longer mix be16/u16 and be32/u32 types.

Alternative is to add __force __beX in various places, but this
seems nicer.

objdiff shows no changes.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      | 15 +++++++++++++++
 net/bridge/netfilter/nft_meta_bridge.c |  2 +-
 net/netfilter/nft_tproxy.c             |  6 +++---
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5c4e5a96a984..dd6ad0b67d7d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -157,11 +157,26 @@ static inline void nft_reg_store16(u32 *dreg, u16 val)
 	*(u16 *)dreg = val;
 }
 
+static inline void nft_reg_store_be16(u32 *dreg, __be16 val)
+{
+	nft_reg_store16(dreg, (__force __u16)val);
+}
+
 static inline u16 nft_reg_load16(const u32 *sreg)
 {
 	return *(u16 *)sreg;
 }
 
+static inline __be16 nft_reg_load_be16(const u32 *sreg)
+{
+	return (__force __be16)nft_reg_load16(sreg);
+}
+
+static inline __be32 nft_reg_load_be32(const u32 *sreg)
+{
+	return *(__force __be32 *)sreg;
+}
+
 static inline void nft_reg_store64(u32 *dreg, u64 val)
 {
 	put_unaligned(val, (u64 *)dreg);
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 8c3eaba87ad2..c3ecd77e25cb 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -53,7 +53,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 			goto err;
 
 		br_vlan_get_proto(br_dev, &p_proto);
-		nft_reg_store16(dest, htons(p_proto));
+		nft_reg_store_be16(dest, htons(p_proto));
 		return;
 	}
 	default:
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 801f013971df..68b2eed742df 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -52,11 +52,11 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 				   skb->dev, NF_TPROXY_LOOKUP_ESTABLISHED);
 
 	if (priv->sreg_addr)
-		taddr = regs->data[priv->sreg_addr];
+		taddr = nft_reg_load_be32(&regs->data[priv->sreg_addr]);
 	taddr = nf_tproxy_laddr4(skb, taddr, iph->daddr);
 
 	if (priv->sreg_port)
-		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
+		tport = nft_reg_load_be16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
@@ -124,7 +124,7 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	taddr = *nf_tproxy_laddr6(skb, &taddr, &iph->daddr);
 
 	if (priv->sreg_port)
-		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
+		tport = nft_reg_load_be16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
-- 
2.30.2

