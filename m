Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C533526C80
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 23:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384767AbiEMVoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 17:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384731AbiEMVnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 17:43:49 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC93B2EA1B;
        Fri, 13 May 2022 14:43:48 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 10/17] netfilter: conntrack: avoid unconditional local_bh_disable
Date:   Fri, 13 May 2022 23:43:22 +0200
Message-Id: <20220513214329.1136459-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220513214329.1136459-1-pablo@netfilter.org>
References: <20220513214329.1136459-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Now that the conntrack entry isn't placed on the pcpu list anymore the
bh only needs to be disabled in the 'expectation present' case.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index de1547a2830e..22492f7eb819 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1736,10 +1736,9 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 				 ecache ? ecache->expmask : 0,
 			     GFP_ATOMIC);
 
-	local_bh_disable();
 	cnet = nf_ct_pernet(net);
 	if (cnet->expect_count) {
-		spin_lock(&nf_conntrack_expect_lock);
+		spin_lock_bh(&nf_conntrack_expect_lock);
 		exp = nf_ct_find_expectation(net, zone, tuple);
 		if (exp) {
 			pr_debug("expectation arrives ct=%p exp=%p\n",
@@ -1762,7 +1761,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 #endif
 			NF_CT_STAT_INC(net, expect_new);
 		}
-		spin_unlock(&nf_conntrack_expect_lock);
+		spin_unlock_bh(&nf_conntrack_expect_lock);
 	}
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
@@ -1770,8 +1769,6 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
 	refcount_set(&ct->ct_general.use, 1);
 
-	local_bh_enable();
-
 	if (exp) {
 		if (exp->expectfn)
 			exp->expectfn(ct, exp);
-- 
2.30.2

