Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637EB218ECB
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgGHRqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:46:44 -0400
Received: from correo.us.es ([193.147.175.20]:34750 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgGHRq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:46:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4FEBB3066AA
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 415A4DA722
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 362A8DA797; Wed,  8 Jul 2020 19:46:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07901DA78F;
        Wed,  8 Jul 2020 19:46:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 19:46:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CCDD04265A2F;
        Wed,  8 Jul 2020 19:46:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 10/12] netfilter: nf_tables: add nft_chain_add()
Date:   Wed,  8 Jul 2020 19:46:07 +0200
Message-Id: <20200708174609.1343-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708174609.1343-1-pablo@netfilter.org>
References: <20200708174609.1343-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a helper function to add the chain to the hashtable and
the chain list.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b7582a1c8dce..a7cb9c07802b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1914,6 +1914,20 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 	return 0;
 }
 
+static int nft_chain_add(struct nft_table *table, struct nft_chain *chain)
+{
+	int err;
+
+	err = rhltable_insert_key(&table->chains_ht, chain->name,
+				  &chain->rhlhead, nft_chain_ht_params);
+	if (err)
+		return err;
+
+	list_add_tail_rcu(&chain->list, &table->chains);
+
+	return 0;
+}
+
 static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      u8 policy, u32 flags)
 {
@@ -1991,16 +2005,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	if (err < 0)
 		goto err1;
 
-	err = rhltable_insert_key(&table->chains_ht, chain->name,
-				  &chain->rhlhead, nft_chain_ht_params);
-	if (err)
-		goto err2;
-
 	trans = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		rhltable_remove(&table->chains_ht, &chain->rhlhead,
-				nft_chain_ht_params);
 		goto err2;
 	}
 
@@ -2008,8 +2015,13 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	if (nft_is_base_chain(chain))
 		nft_trans_chain_policy(trans) = policy;
 
+	err = nft_chain_add(table, chain);
+	if (err < 0) {
+		nft_trans_destroy(trans);
+		goto err2;
+	}
+
 	table->use++;
-	list_add_tail_rcu(&chain->list, &table->chains);
 
 	return 0;
 err2:
-- 
2.20.1

