Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F1F521526
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241728AbiEJM0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241672AbiEJMZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:25:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBAF9972E6;
        Tue, 10 May 2022 05:21:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/17] netfilter: remove nf_ct_unconfirmed_destroy helper
Date:   Tue, 10 May 2022 14:21:38 +0200
Message-Id: <20220510122150.92533-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220510122150.92533-1-pablo@netfilter.org>
References: <20220510122150.92533-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

This helper tags connections not yet in the conntrack table as
dying.  These nf_conn entries will be dropped instead when the
core attempts to insert them from the input or postrouting
'confirm' hook.

After the previous change, the entries get unlinked from the
list earlier, so that by the time the actual exit hook runs,
new connections no longer have a timeout policy assigned.

Its enough to walk the hashtable instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h |  3 ---
 net/netfilter/nf_conntrack_core.c    | 14 --------------
 net/netfilter/nfnetlink_cttimeout.c  |  4 +++-
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 28672a944499..f60212244b13 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -237,9 +237,6 @@ static inline bool nf_ct_kill(struct nf_conn *ct)
 	return nf_ct_delete(ct, 0, 0);
 }
 
-/* Set all unconfirmed conntrack as dying */
-void nf_ct_unconfirmed_destroy(struct net *);
-
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9010b6e5a072..b3cc318ceb45 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2431,20 +2431,6 @@ __nf_ct_unconfirmed_destroy(struct net *net)
 	}
 }
 
-void nf_ct_unconfirmed_destroy(struct net *net)
-{
-	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-
-	might_sleep();
-
-	if (atomic_read(&cnet->count) > 0) {
-		__nf_ct_unconfirmed_destroy(net);
-		nf_queue_nf_hook_drop(net);
-		synchronize_net();
-	}
-}
-EXPORT_SYMBOL_GPL(nf_ct_unconfirmed_destroy);
-
 void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
 			       void *data, u32 portid, int report)
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 83fa15c4193c..f366b8187915 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -608,7 +608,9 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
 	struct ctnl_timeout *cur, *tmp;
 
-	nf_ct_unconfirmed_destroy(net);
+	if (list_empty(&pernet->nfct_timeout_freelist))
+		return;
+
 	nf_ct_untimeout(net, NULL);
 
 	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_freelist, head) {
-- 
2.30.2

