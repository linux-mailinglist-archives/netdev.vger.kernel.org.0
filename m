Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BF013F9E9
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731148AbgAPTvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:51:00 -0500
Received: from correo.us.es ([193.147.175.20]:56052 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730919AbgAPTu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 14:50:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 97337807E4
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86E80DA717
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 863E3DA714; Thu, 16 Jan 2020 20:50:54 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A8D2DA709;
        Thu, 16 Jan 2020 20:50:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 20:50:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 59EEC42EF9E1;
        Thu, 16 Jan 2020 20:50:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 6/9] netfilter: nf_tables: remove WARN and add NLA_STRING upper limits
Date:   Thu, 16 Jan 2020 20:50:41 +0100
Message-Id: <20200116195044.326614-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200116195044.326614-1-pablo@netfilter.org>
References: <20200116195044.326614-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This WARN can trigger because some of the names fed to the module
autoload function can be of arbitrary length.

Remove the WARN and add limits for all NLA_STRING attributes.

Reported-by: syzbot+0e63ae76d117ae1c3a01@syzkaller.appspotmail.com
Fixes: 452238e8d5ffd8 ("netfilter: nf_tables: add and use helper for module autoload")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 168765d1d1c2..b3692458d428 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -22,6 +22,8 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
+#define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
+
 static LIST_HEAD(nf_tables_expressions);
 static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
@@ -583,7 +585,7 @@ static void nft_request_module(struct net *net, const char *fmt, ...)
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
-	if (WARN(ret >= MODULE_NAME_LEN, "truncated: '%s' (len %d)", module_name, ret))
+	if (ret >= MODULE_NAME_LEN)
 		return;
 
 	mutex_unlock(&net->nft.commit_mutex);
@@ -1242,7 +1244,8 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
-	[NFTA_CHAIN_TYPE]	= { .type = NLA_STRING },
+	[NFTA_CHAIN_TYPE]	= { .type = NLA_STRING,
+				    .len = NFT_MODULE_AUTOLOAD_LIMIT },
 	[NFTA_CHAIN_COUNTERS]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_FLAGS]	= { .type = NLA_U32 },
 };
@@ -2356,7 +2359,8 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 }
 
 static const struct nla_policy nft_expr_policy[NFTA_EXPR_MAX + 1] = {
-	[NFTA_EXPR_NAME]	= { .type = NLA_STRING },
+	[NFTA_EXPR_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_MODULE_AUTOLOAD_LIMIT },
 	[NFTA_EXPR_DATA]	= { .type = NLA_NESTED },
 };
 
@@ -4199,7 +4203,8 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 	[NFTA_SET_ELEM_USERDATA]	= { .type = NLA_BINARY,
 					    .len = NFT_USERDATA_MAXLEN },
 	[NFTA_SET_ELEM_EXPR]		= { .type = NLA_NESTED },
-	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING },
+	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING,
+					    .len = NFT_OBJ_MAXNAMELEN - 1 },
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
-- 
2.11.0

