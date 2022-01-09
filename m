Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E10488D47
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237485AbiAIXSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:18:38 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42124 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237460AbiAIXRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:06 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 37FD864692;
        Mon, 10 Jan 2022 00:14:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 27/32] netfilter: nf_tables: add register tracking infrastructure
Date:   Mon, 10 Jan 2022 00:16:35 +0100
Message-Id: <20220109231640.104123-28-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds new infrastructure to skip redundant selector store
operations on the same register to achieve a performance boost from
the packet path.

This is particularly noticeable in pure linear rulesets but it also
helps in rulesets which are already heaving relying in maps to avoid
ruleset linear inspection.

The idea is to keep data of the most recurrent store operations on
register to reuse them with cmp and lookup expressions.

This infrastructure allows for dynamic ruleset updates since the ruleset
blob reduction happens from the kernel.

Userspace still needs to be updated to maximize register utilization to
cooperate to improve register data reuse / reduce number of store on
register operations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 12 ++++++++++++
 net/netfilter/nf_tables_api.c     | 11 +++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 515e5db97e01..1c37ce61daea 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -122,6 +122,16 @@ struct nft_regs {
 	};
 };
 
+struct nft_regs_track {
+	struct {
+		const struct nft_expr		*selector;
+		const struct nft_expr		*bitwise;
+	} regs[NFT_REG32_NUM];
+
+	const struct nft_expr			*cur;
+	const struct nft_expr			*last;
+};
+
 /* Store/load an u8, u16 or u64 integer to/from the u32 data register.
  *
  * Note, when using concatenations, register allocation happens at 32-bit
@@ -886,6 +896,8 @@ struct nft_expr_ops {
 	int				(*validate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr,
 						    const struct nft_data **data);
+	bool				(*reduce)(struct nft_regs_track *track,
+						  const struct nft_expr *expr);
 	bool				(*gc)(struct net *net,
 					      const struct nft_expr *expr);
 	int				(*offload)(struct nft_offload_ctx *ctx,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2317429ea35e..83ce82212cbb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8259,6 +8259,7 @@ EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
 	const struct nft_expr *expr, *last;
+	struct nft_regs_track track = {};
 	unsigned int size, data_size;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
@@ -8298,7 +8299,17 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 		if (WARN_ON_ONCE(data > data_boundary))
 			return -ENOMEM;
 
+		size = 0;
+		track.last = last;
 		nft_rule_for_each_expr(expr, last, rule) {
+			track.cur = expr;
+
+			if (expr->ops->reduce &&
+			    expr->ops->reduce(&track, expr)) {
+				expr = track.cur;
+				continue;
+			}
+
 			if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
 				return -ENOMEM;
 
-- 
2.30.2

