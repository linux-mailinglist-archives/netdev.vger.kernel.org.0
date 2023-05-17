Return-Path: <netdev+bounces-3344-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9968706851
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F7521C20F55
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D5F18B15;
	Wed, 17 May 2023 12:38:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A957118AF7
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:38:23 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5D71FC4;
	Wed, 17 May 2023 05:38:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1pzGQ1-0004UA-2m; Wed, 17 May 2023 14:38:13 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>
Subject: [PATCH net 3/3] netfilter: nft_set_rbtree: fix null deref on element insertion
Date: Wed, 17 May 2023 14:37:56 +0200
Message-Id: <20230517123756.7353-4-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230517123756.7353-1-fw@strlen.de>
References: <20230517123756.7353-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is no guarantee that rb_prev() will not return NULL in nft_rbtree_gc_elem():

general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
 nft_add_set_elem+0x14b0/0x2990
  nf_tables_newsetelem+0x528/0xb30

Furthermore, there is a possible use-after-free while iterating,
'node' can be free'd so we need to cache the next value to use.

Fixes: c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 19ea4d3c3553..2f114aa10f1a 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -221,7 +221,7 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
-	struct nft_rbtree_elem *rbe_prev;
+	struct nft_rbtree_elem *rbe_prev = NULL;
 	struct nft_set_gc_batch *gcb;
 
 	gcb = nft_set_gc_batch_check(set, NULL, GFP_ATOMIC);
@@ -229,17 +229,21 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
 		return -ENOMEM;
 
 	/* search for expired end interval coming before this element. */
-	do {
+	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
 		if (nft_rbtree_interval_end(rbe_prev))
 			break;
 
 		prev = rb_prev(prev);
-	} while (prev != NULL);
+	}
+
+	if (rbe_prev) {
+		rb_erase(&rbe_prev->node, &priv->root);
+		atomic_dec(&set->nelems);
+	}
 
-	rb_erase(&rbe_prev->node, &priv->root);
 	rb_erase(&rbe->node, &priv->root);
-	atomic_sub(2, &set->nelems);
+	atomic_dec(&set->nelems);
 
 	nft_set_gc_batch_add(gcb, rbe);
 	nft_set_gc_batch_complete(gcb);
@@ -268,7 +272,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_set_ext **ext)
 {
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
-	struct rb_node *node, *parent, **p, *first = NULL;
+	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	int d, err;
@@ -307,7 +311,9 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 * Values stored in the tree are in reversed order, starting from
 	 * highest to lowest value.
 	 */
-	for (node = first; node != NULL; node = rb_next(node)) {
+	for (node = first; node != NULL; node = next) {
+		next = rb_next(node);
+
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 
 		if (!nft_set_elem_active(&rbe->ext, genmask))
-- 
2.39.3


