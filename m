Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235D932069
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfFASYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:38 -0400
Received: from mail.us.es ([193.147.175.20]:40054 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfFASYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB767B60F5
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF9EADA70A
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F1B02FF158; Sat,  1 Jun 2019 20:23:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EEFFFF144;
        Sat,  1 Jun 2019 20:23:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DB3214265A32;
        Sat,  1 Jun 2019 20:23:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/15] netfilter: nf_tables: free base chain counters from worker
Date:   Sat,  1 Jun 2019 20:23:31 +0200
Message-Id: <20190601182340.2662-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need to use synchronize_rcu() here, just swap the two pointers
and have the release occur from work queue after commit has completed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 28241e82fd15..2fed78b19abe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1449,25 +1449,18 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 	return newstats;
 }
 
-static void nft_chain_stats_replace(struct net *net,
-				    struct nft_base_chain *chain,
-				    struct nft_stats __percpu *newstats)
+static void nft_chain_stats_replace(struct nft_trans *trans)
 {
-	struct nft_stats __percpu *oldstats;
+	struct nft_base_chain *chain = nft_base_chain(trans->ctx.chain);
 
-	if (newstats == NULL)
+	if (!nft_trans_chain_stats(trans))
 		return;
 
-	if (rcu_access_pointer(chain->stats)) {
-		oldstats = rcu_dereference_protected(chain->stats,
-					lockdep_commit_lock_is_held(net));
-		rcu_assign_pointer(chain->stats, newstats);
-		synchronize_rcu();
-		free_percpu(oldstats);
-	} else {
-		rcu_assign_pointer(chain->stats, newstats);
+	rcu_swap_protected(chain->stats, nft_trans_chain_stats(trans),
+			   lockdep_commit_lock_is_held(trans->ctx.net));
+
+	if (!nft_trans_chain_stats(trans))
 		static_branch_inc(&nft_counters_enabled);
-	}
 }
 
 static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
@@ -6360,9 +6353,9 @@ static void nft_chain_commit_update(struct nft_trans *trans)
 	if (!nft_is_base_chain(trans->ctx.chain))
 		return;
 
+	nft_chain_stats_replace(trans);
+
 	basechain = nft_base_chain(trans->ctx.chain);
-	nft_chain_stats_replace(trans->ctx.net, basechain,
-				nft_trans_chain_stats(trans));
 
 	switch (nft_trans_chain_policy(trans)) {
 	case NF_DROP:
@@ -6379,6 +6372,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
+		free_percpu(nft_trans_chain_stats(trans));
 		kfree(nft_trans_chain_name(trans));
 		break;
 	case NFT_MSG_DELCHAIN:
-- 
2.11.0

