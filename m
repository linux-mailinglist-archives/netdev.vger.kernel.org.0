Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FAA41FAD2
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 12:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhJBKK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 06:10:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45080 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbhJBKKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 06:10:25 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7F3F263EE7;
        Sat,  2 Oct 2021 12:07:12 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/4] netfilter: nf_tables: reverse order in rule replacement expansion
Date:   Sat,  2 Oct 2021 12:08:32 +0200
Message-Id: <20211002100833.21411-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002100833.21411-1-pablo@netfilter.org>
References: <20211002100833.21411-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Deactivate old rule first, then append the new rule, so rule replacement
notification via netlink first reports the deletion of the old rule with
handle X in first place, then it adds the new rule (reusing the handle X
of the replaced old rule).

Note that the abort path releases the transaction that has been created
by nft_delrule() on error.

Fixes: ca08987885a1 ("netfilter: nf_tables: deactivate expressions in rule replecement routine")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 085783b14075..c8acd26c7201 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3419,17 +3419,15 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
+		err = nft_delrule(&ctx, old_rule);
+		if (err < 0)
+			goto err_destroy_flow_rule;
+
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
 		if (trans == NULL) {
 			err = -ENOMEM;
 			goto err_destroy_flow_rule;
 		}
-		err = nft_delrule(&ctx, old_rule);
-		if (err < 0) {
-			nft_trans_destroy(trans);
-			goto err_destroy_flow_rule;
-		}
-
 		list_add_tail_rcu(&rule->list, &old_rule->list);
 	} else {
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
-- 
2.30.2

