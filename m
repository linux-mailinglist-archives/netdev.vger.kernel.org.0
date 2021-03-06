Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB45E32FA83
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 13:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhCFMM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 07:12:56 -0500
Received: from correo.us.es ([193.147.175.20]:46414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhCFMMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 07:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 10C4CF2591
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 13:12:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02259DA78D
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 13:12:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EB2C3DA78A; Sat,  6 Mar 2021 13:12:34 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB8D9DA789;
        Sat,  6 Mar 2021 13:12:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Mar 2021 13:12:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 9205742DC6E3;
        Sat,  6 Mar 2021 13:12:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 9/9] netfilter: nftables: bogus check for netlink portID with table owner
Date:   Sat,  6 Mar 2021 13:12:23 +0100
Message-Id: <20210306121223.28711-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210306121223.28711-1-pablo@netfilter.org>
References: <20210306121223.28711-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing branch checks for 0 != table->nlpid which always evaluates
true for tables that have an owner.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 796ce86ef7eb..224c8e537cb3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9083,13 +9083,12 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 	nf_tables_table_destroy(&ctx);
 }
 
-static void __nft_release_tables(struct net *net, u32 nlpid)
+static void __nft_release_tables(struct net *net)
 {
 	struct nft_table *table, *nt;
 
 	list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
-		if (nft_table_has_owner(table) &&
-		    nlpid != table->nlpid)
+		if (nft_table_has_owner(table))
 			continue;
 
 		__nft_release_table(net, table);
@@ -9155,7 +9154,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
-	__nft_release_tables(net, 0);
+	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
 	WARN_ON_ONCE(!list_empty(&net->nft.module_list));
-- 
2.20.1

