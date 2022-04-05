Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203364F35B8
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbiDEKyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357277AbiDEK0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 06:26:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89286377EC;
        Tue,  5 Apr 2022 03:09:57 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7E91663041;
        Tue,  5 Apr 2022 12:06:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/2] netfilter: nf_tables: memcg accounting for dynamically allocated objects
Date:   Tue,  5 Apr 2022 12:09:23 +0200
Message-Id: <20220405100923.7231-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220405100923.7231-1-pablo@netfilter.org>
References: <20220405100923.7231-1-pablo@netfilter.org>
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

From: Vasily Averin <vasily.averin@linux.dev>

nft_*.c files whose NFT_EXPR_STATEFUL flag is set on need to
use __GFP_ACCOUNT flag for objects that are dynamically
allocated from the packet path.

Such objects are allocated inside nft_expr_ops->init() callbacks
executed in task context while processing netlink messages.

In addition, this patch adds accounting to nft_set_elem_expr_clone()
used for the same purposes.

Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 net/netfilter/nft_connlimit.c | 2 +-
 net/netfilter/nft_counter.c   | 2 +-
 net/netfilter/nft_last.c      | 2 +-
 net/netfilter/nft_limit.c     | 2 +-
 net/netfilter/nft_quota.c     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5ddfdb2adaf1..128ee3b300d6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5526,7 +5526,7 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 	int err, i, k;
 
 	for (i = 0; i < set->num_exprs; i++) {
-		expr = kzalloc(set->exprs[i]->ops->size, GFP_KERNEL);
+		expr = kzalloc(set->exprs[i]->ops->size, GFP_KERNEL_ACCOUNT);
 		if (!expr)
 			goto err_expr;
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 9de1462e4ac4..d657f999a11b 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -77,7 +77,7 @@ static int nft_connlimit_do_init(const struct nft_ctx *ctx,
 			invert = true;
 	}
 
-	priv->list = kmalloc(sizeof(*priv->list), GFP_KERNEL);
+	priv->list = kmalloc(sizeof(*priv->list), GFP_KERNEL_ACCOUNT);
 	if (!priv->list)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index da9083605a61..f4d3573e8782 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -62,7 +62,7 @@ static int nft_counter_do_init(const struct nlattr * const tb[],
 	struct nft_counter __percpu *cpu_stats;
 	struct nft_counter *this_cpu;
 
-	cpu_stats = alloc_percpu(struct nft_counter);
+	cpu_stats = alloc_percpu_gfp(struct nft_counter, GFP_KERNEL_ACCOUNT);
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 43d0d4aadb1f..bb15a55dad5c 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -30,7 +30,7 @@ static int nft_last_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	u64 last_jiffies;
 	int err;
 
-	last = kzalloc(sizeof(*last), GFP_KERNEL);
+	last = kzalloc(sizeof(*last), GFP_KERNEL_ACCOUNT);
 	if (!last)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index d4a6cf3cd697..04ea8b9bf202 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -90,7 +90,7 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 				 priv->rate);
 	}
 
-	priv->limit = kmalloc(sizeof(*priv->limit), GFP_KERNEL);
+	priv->limit = kmalloc(sizeof(*priv->limit), GFP_KERNEL_ACCOUNT);
 	if (!priv->limit)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index d7db57ed3bc1..e6b0df68feea 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -90,7 +90,7 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 			return -EOPNOTSUPP;
 	}
 
-	priv->consumed = kmalloc(sizeof(*priv->consumed), GFP_KERNEL);
+	priv->consumed = kmalloc(sizeof(*priv->consumed), GFP_KERNEL_ACCOUNT);
 	if (!priv->consumed)
 		return -ENOMEM;
 
-- 
2.30.2

