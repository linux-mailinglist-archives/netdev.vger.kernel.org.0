Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05134671D29
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjARNKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjARNJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:09:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60D15A360;
        Wed, 18 Jan 2023 04:33:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pI7ch-00076A-59; Wed, 18 Jan 2023 13:32:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 8/9] netfilter: nf_tables: avoid retpoline overhead for some ct expression calls
Date:   Wed, 18 Jan 2023 13:32:07 +0100
Message-Id: <20230118123208.17167-9-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20230118123208.17167-1-fw@strlen.de>
References: <20230118123208.17167-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nft_ct expression cannot be made builtin to nf_tables without also
forcing the conntrack itself to be builtin.

However, this can be avoided by splitting retrieval of a few
selector keys that only need to access the nf_conn structure,
i.e. no function calls to nf_conntrack code.

Many rulesets start with something like
"ct status established,related accept"

With this change, this no longer requires an indirect call, which
gives about 1.8% more throughput with a simple conntrack-enabled
forwarding test (retpoline thunk used).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h | 12 ++++++
 net/netfilter/Makefile                 |  6 +++
 net/netfilter/nf_tables_core.c         |  3 ++
 net/netfilter/nft_ct.c                 | 39 ++++++++++++------
 net/netfilter/nft_ct_fast.c            | 56 ++++++++++++++++++++++++++
 5 files changed, 104 insertions(+), 12 deletions(-)
 create mode 100644 net/netfilter/nft_ct_fast.c

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index bedef373ec21..780a5f6ad4a6 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -61,6 +61,16 @@ struct nft_immediate_expr {
 extern const struct nft_expr_ops nft_cmp_fast_ops;
 extern const struct nft_expr_ops nft_cmp16_fast_ops;
 
+struct nft_ct {
+	enum nft_ct_keys	key:8;
+	enum ip_conntrack_dir	dir:8;
+	u8			len;
+	union {
+		u8		dreg;
+		u8		sreg;
+	};
+};
+
 struct nft_payload {
 	enum nft_payload_bases	base:8;
 	u8			offset;
@@ -140,6 +150,8 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
 void nft_counter_eval(const struct nft_expr *expr, struct nft_regs *regs,
                       const struct nft_pktinfo *pkt);
+void nft_ct_get_fast_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs, const struct nft_pktinfo *pkt);
 
 enum {
 	NFT_PAYLOAD_CTX_INNER_TUN	= (1 << 0),
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3754eb06fb41..ba2a6b5e93d9 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -98,6 +98,12 @@ nf_tables-objs += nft_set_pipapo_avx2.o
 endif
 endif
 
+ifdef CONFIG_NFT_CT
+ifdef CONFIG_RETPOLINE
+nf_tables-objs += nft_ct_fast.o
+endif
+endif
+
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_CONNLIMIT)	+= nft_connlimit.o
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index d9992906199f..6ecd0ba2e546 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -228,6 +228,9 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
 	X(e, nft_counter_eval);
 	X(e, nft_meta_get_eval);
 	X(e, nft_lookup_eval);
+#if IS_ENABLED(CONFIG_NFT_CT)
+	X(e, nft_ct_get_fast_eval);
+#endif
 	X(e, nft_range_eval);
 	X(e, nft_immediate_eval);
 	X(e, nft_byteorder_eval);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index c68e2151defe..b9c84499438b 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -12,7 +12,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
@@ -23,16 +23,6 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
-struct nft_ct {
-	enum nft_ct_keys	key:8;
-	enum ip_conntrack_dir	dir:8;
-	u8			len;
-	union {
-		u8		dreg;
-		u8		sreg;
-	};
-};
-
 struct nft_ct_helper_obj  {
 	struct nf_conntrack_helper *helper4;
 	struct nf_conntrack_helper *helper6;
@@ -759,6 +749,18 @@ static bool nft_ct_set_reduce(struct nft_regs_track *track,
 	return false;
 }
 
+#ifdef CONFIG_RETPOLINE
+static const struct nft_expr_ops nft_ct_get_fast_ops = {
+	.type		= &nft_ct_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
+	.eval		= nft_ct_get_fast_eval,
+	.init		= nft_ct_get_init,
+	.destroy	= nft_ct_get_destroy,
+	.dump		= nft_ct_get_dump,
+	.reduce		= nft_ct_set_reduce,
+};
+#endif
+
 static const struct nft_expr_ops nft_ct_set_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
@@ -791,8 +793,21 @@ nft_ct_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_CT_DREG] && tb[NFTA_CT_SREG])
 		return ERR_PTR(-EINVAL);
 
-	if (tb[NFTA_CT_DREG])
+	if (tb[NFTA_CT_DREG]) {
+#ifdef CONFIG_RETPOLINE
+		u32 k = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
+
+		switch (k) {
+		case NFT_CT_STATE:
+		case NFT_CT_DIRECTION:
+		case NFT_CT_STATUS:
+		case NFT_CT_MARK:
+		case NFT_CT_SECMARK:
+			return &nft_ct_get_fast_ops;
+		}
+#endif
 		return &nft_ct_get_ops;
+	}
 
 	if (tb[NFTA_CT_SREG]) {
 #ifdef CONFIG_NF_CONNTRACK_ZONES
diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
new file mode 100644
index 000000000000..89983b0613fa
--- /dev/null
+++ b/net/netfilter/nft_ct_fast.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#if IS_ENABLED(CONFIG_NFT_CT)
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_conntrack.h>
+
+void nft_ct_get_fast_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs,
+			  const struct nft_pktinfo *pkt)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+	u32 *dest = &regs->data[priv->dreg];
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+	unsigned int state;
+
+	ct = nf_ct_get(pkt->skb, &ctinfo);
+	if (!ct) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	switch (priv->key) {
+	case NFT_CT_STATE:
+		if (ct)
+			state = NF_CT_STATE_BIT(ctinfo);
+		else if (ctinfo == IP_CT_UNTRACKED)
+			state = NF_CT_STATE_UNTRACKED_BIT;
+		else
+			state = NF_CT_STATE_INVALID_BIT;
+		*dest = state;
+		return;
+	case NFT_CT_DIRECTION:
+		nft_reg_store8(dest, CTINFO2DIR(ctinfo));
+		return;
+	case NFT_CT_STATUS:
+		*dest = ct->status;
+		return;
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	case NFT_CT_MARK:
+		*dest = ct->mark;
+		return;
+#endif
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	case NFT_CT_SECMARK:
+		*dest = ct->secmark;
+		return;
+#endif
+	default:
+		WARN_ON_ONCE(1);
+		regs->verdict.code = NFT_BREAK;
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(nft_ct_get_fast_eval);
+#endif
-- 
2.38.2

