Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC521496FA
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 18:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgAYRel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 12:34:41 -0500
Received: from correo.us.es ([193.147.175.20]:35482 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbgAYRe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 12:34:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 561F412C1F3
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 18:34:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4851CDA710
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 18:34:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3DF3BDA707; Sat, 25 Jan 2020 18:34:25 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E026DA710;
        Sat, 25 Jan 2020 18:34:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 25 Jan 2020 18:34:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1865A42EE38E;
        Sat, 25 Jan 2020 18:34:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/7] netfilter: nf_tables: add __nft_chain_type_get()
Date:   Sat, 25 Jan 2020 18:34:13 +0100
Message-Id: <20200125173415.191571-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200125173415.191571-1-pablo@netfilter.org>
References: <20200125173415.191571-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new helper function validates that unknown family and chain type
coming from userspace do not trigger an out-of-bound array access. Bail
out in case __nft_chain_type_get() returns NULL from
nft_chain_parse_hook().

Fixes: 9370761c56b6 ("netfilter: nf_tables: convert built-in tables/chains to chain types")
Reported-by: syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 65f51a2e9c2a..4aa01c1253b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -553,14 +553,27 @@ static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 static const struct nft_chain_type *chain_type[NFPROTO_NUMPROTO][NFT_CHAIN_T_MAX];
 
 static const struct nft_chain_type *
+__nft_chain_type_get(u8 family, enum nft_chain_types type)
+{
+	if (family >= NFPROTO_NUMPROTO ||
+	    type >= NFT_CHAIN_T_MAX)
+		return NULL;
+
+	return chain_type[family][type];
+}
+
+static const struct nft_chain_type *
 __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
 {
+	const struct nft_chain_type *type;
 	int i;
 
 	for (i = 0; i < NFT_CHAIN_T_MAX; i++) {
-		if (chain_type[family][i] != NULL &&
-		    !nla_strcmp(nla, chain_type[family][i]->name))
-			return chain_type[family][i];
+		type = __nft_chain_type_get(family, i);
+		if (!type)
+			continue;
+		if (!nla_strcmp(nla, type->name))
+			return type;
 	}
 	return NULL;
 }
@@ -1162,11 +1175,8 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 
 void nft_register_chain_type(const struct nft_chain_type *ctype)
 {
-	if (WARN_ON(ctype->family >= NFPROTO_NUMPROTO))
-		return;
-
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	if (WARN_ON(chain_type[ctype->family][ctype->type] != NULL)) {
+	if (WARN_ON(__nft_chain_type_get(ctype->family, ctype->type))) {
 		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		return;
 	}
@@ -1768,7 +1778,10 @@ static int nft_chain_parse_hook(struct net *net,
 	hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
 	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
-	type = chain_type[family][NFT_CHAIN_T_DEFAULT];
+	type = __nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
+	if (!type)
+		return -EOPNOTSUPP;
+
 	if (nla[NFTA_CHAIN_TYPE]) {
 		type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
 						   family, autoload);
-- 
2.11.0

