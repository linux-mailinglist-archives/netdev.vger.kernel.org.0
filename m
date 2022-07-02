Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2FF564264
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbiGBTKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiGBTKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:10:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4B90DF53;
        Sat,  2 Jul 2022 12:10:36 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/2] netfilter: nft_set_pipapo: release elements in clone from abort path
Date:   Sat,  2 Jul 2022 21:10:28 +0200
Message-Id: <20220702191029.238563-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220702191029.238563-1-pablo@netfilter.org>
References: <20220702191029.238563-1-pablo@netfilter.org>
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

New elements that reside in the clone are not released in case that the
transaction is aborted.

[16302.231754] ------------[ cut here ]------------
[16302.231756] WARNING: CPU: 0 PID: 100509 at net/netfilter/nf_tables_api.c:1864 nf_tables_chain_destroy+0x26/0x127 [nf_tables]
[...]
[16302.231882] CPU: 0 PID: 100509 Comm: nft Tainted: G        W         5.19.0-rc3+ #155
[...]
[16302.231887] RIP: 0010:nf_tables_chain_destroy+0x26/0x127 [nf_tables]
[16302.231899] Code: f3 fe ff ff 41 55 41 54 55 53 48 8b 6f 10 48 89 fb 48 c7 c7 82 96 d9 a0 8b 55 50 48 8b 75 58 e8 de f5 92 e0 83 7d 50 00 74 09 <0f> 0b 5b 5d 41 5c 41 5d c3 4c 8b 65 00 48 8b 7d 08 49 39 fc 74 05
[...]
[16302.231917] Call Trace:
[16302.231919]  <TASK>
[16302.231921]  __nf_tables_abort.cold+0x23/0x28 [nf_tables]
[16302.231934]  nf_tables_abort+0x30/0x50 [nf_tables]
[16302.231946]  nfnetlink_rcv_batch+0x41a/0x840 [nfnetlink]
[16302.231952]  ? __nla_validate_parse+0x48/0x190
[16302.231959]  nfnetlink_rcv+0x110/0x129 [nfnetlink]
[16302.231963]  netlink_unicast+0x211/0x340
[16302.231969]  netlink_sendmsg+0x21e/0x460

Add nft_set_pipapo_match_destroy() helper function to release the
elements in the lookup tables.

Stefano Brivio says: "We additionally look for elements pointers in the
cloned matching data if priv->dirty is set, because that means that
cloned data might point to additional elements we did not commit to the
working copy yet (such as the abort path case, but perhaps not limited
to it)."

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 48 +++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 2c8051d8cca6..4f9299b9dcdd 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2124,6 +2124,32 @@ static int nft_pipapo_init(const struct nft_set *set,
 	return err;
 }
 
+/**
+ * nft_set_pipapo_match_destroy() - Destroy elements from key mapping array
+ * @set:	nftables API set representation
+ * @m:		matching data pointing to key mapping array
+ */
+static void nft_set_pipapo_match_destroy(const struct nft_set *set,
+					 struct nft_pipapo_match *m)
+{
+	struct nft_pipapo_field *f;
+	int i, r;
+
+	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
+		;
+
+	for (r = 0; r < f->rules; r++) {
+		struct nft_pipapo_elem *e;
+
+		if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
+			continue;
+
+		e = f->mt[r].e;
+
+		nft_set_elem_destroy(set, e, true);
+	}
+}
+
 /**
  * nft_pipapo_destroy() - Free private data for set and all committed elements
  * @set:	nftables API set representation
@@ -2132,26 +2158,13 @@ static void nft_pipapo_destroy(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
-	struct nft_pipapo_field *f;
-	int i, r, cpu;
+	int cpu;
 
 	m = rcu_dereference_protected(priv->match, true);
 	if (m) {
 		rcu_barrier();
 
-		for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
-			;
-
-		for (r = 0; r < f->rules; r++) {
-			struct nft_pipapo_elem *e;
-
-			if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
-				continue;
-
-			e = f->mt[r].e;
-
-			nft_set_elem_destroy(set, e, true);
-		}
+		nft_set_pipapo_match_destroy(set, m);
 
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(m->scratch_aligned);
@@ -2165,6 +2178,11 @@ static void nft_pipapo_destroy(const struct nft_set *set)
 	}
 
 	if (priv->clone) {
+		m = priv->clone;
+
+		if (priv->dirty)
+			nft_set_pipapo_match_destroy(set, m);
+
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(priv->clone->scratch_aligned);
 #endif
-- 
2.30.2

