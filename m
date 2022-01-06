Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52014486CCD
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244654AbiAFVvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:51:54 -0500
Received: from mail.netfilter.org ([217.70.188.207]:36178 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244596AbiAFVvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 16:51:53 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 961156428F;
        Thu,  6 Jan 2022 22:49:04 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/4] netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone
Date:   Thu,  6 Jan 2022 22:51:39 +0100
Message-Id: <20220106215139.170824-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220106215139.170824-1-pablo@netfilter.org>
References: <20220106215139.170824-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This is needed in case a new transaction is made that doesn't insert any
new elements into an already existing set.

Else, after second 'nft -f ruleset.txt', lookups in such a set will fail
because ->lookup() encounters raw_cpu_ptr(m->scratch) == NULL.

For the initial rule load, insertion of elements takes care of the
allocation, but for rule reloads this isn't guaranteed: we might not
have additions to the set.

Fixes: 3c4287f62044a90e ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: etkaar <lists.netfilter.org@prvy.eu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index dce866d93fee..2c8051d8cca6 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1290,6 +1290,11 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	if (!new->scratch_aligned)
 		goto out_scratch;
 #endif
+	for_each_possible_cpu(i)
+		*per_cpu_ptr(new->scratch, i) = NULL;
+
+	if (pipapo_realloc_scratch(new, old->bsize_max))
+		goto out_scratch_realloc;
 
 	rcu_head_init(&new->rcu);
 
@@ -1334,6 +1339,9 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		kvfree(dst->lt);
 		dst--;
 	}
+out_scratch_realloc:
+	for_each_possible_cpu(i)
+		kfree(*per_cpu_ptr(new->scratch, i));
 #ifdef NFT_PIPAPO_ALIGN
 	free_percpu(new->scratch_aligned);
 #endif
-- 
2.30.2

