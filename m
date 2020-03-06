Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3690617C52C
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgCFSPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:15:30 -0500
Received: from correo.us.es ([193.147.175.20]:40766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgCFSPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5FD0215AEB7
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F939DA736
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 451E7DA39F; Fri,  6 Mar 2020 19:15:06 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 67484DA736;
        Fri,  6 Mar 2020 19:15:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:15:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 439304301DE0;
        Fri,  6 Mar 2020 19:15:04 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/11] netfilter: nf_tables: fix infinite loop when expr is not available
Date:   Fri,  6 Mar 2020 19:15:12 +0100
Message-Id: <20200306181513.656594-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200306181513.656594-1-pablo@netfilter.org>
References: <20200306181513.656594-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nft will loop forever if the kernel doesn't support an expression:

1. nft_expr_type_get() appends the family specific name to the module list.
2. -EAGAIN is returned to nfnetlink, nfnetlink calls abort path.
3. abort path sets ->done to true and calls request_module for the
   expression.
4. nfnetlink replays the batch, we end up in nft_expr_type_get() again.
5. nft_expr_type_get attempts to append family-specific name. This
   one already exists on the list, so we continue
6. nft_expr_type_get adds the generic expression name to the module
   list. -EAGAIN is returned, nfnetlink calls abort path.
7. abort path encounters the family-specific expression which
   has 'done' set, so it gets removed.
8. abort path requests the generic expression name, sets done to true.
9. batch is replayed.

If the expression could not be loaded, then we will end up back at 1),
because the family-specific name got removed and the cycle starts again.

Note that userspace can SIGKILL the nft process to stop the cycle, but
the desired behaviour is to return an error after the generic expr name
fails to load the expression.

Fixes: eb014de4fd418 ("netfilter: nf_tables: autoload modules from the abort path")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f9e60981bd36..38c680f28f15 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7388,13 +7388,8 @@ static void nf_tables_module_autoload(struct net *net)
 	list_splice_init(&net->nft.module_list, &module_list);
 	mutex_unlock(&net->nft.commit_mutex);
 	list_for_each_entry_safe(req, next, &module_list, list) {
-		if (req->done) {
-			list_del(&req->list);
-			kfree(req);
-		} else {
-			request_module("%s", req->module);
-			req->done = true;
-		}
+		request_module("%s", req->module);
+		req->done = true;
 	}
 	mutex_lock(&net->nft.commit_mutex);
 	list_splice(&module_list, &net->nft.module_list);
@@ -8177,6 +8172,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
+	WARN_ON_ONCE(!list_empty(&net->nft.module_list));
 }
 
 static struct pernet_operations nf_tables_net_ops = {
-- 
2.11.0

