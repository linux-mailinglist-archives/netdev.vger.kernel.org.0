Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A20C13D5A7
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 09:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgAPIG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 03:06:58 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33146 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729619AbgAPIG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 03:06:58 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1is0B5-0003Mm-CC; Thu, 16 Jan 2020 09:06:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        syzbot+0e63ae76d117ae1c3a01@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: remove WARN and add NLA_STRING upper limits
Date:   Thu, 16 Jan 2020 09:06:50 +0100
Message-Id: <20200116080650.4798-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <000000000000b9fc96059c36db9e@google.com>
References: <000000000000b9fc96059c36db9e@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This WARN can trigger because some of the names fed to the module
autoload function can be of arbitrary length.

Remove the WARN and add limits for all NLA_STRING attributes.

Reported-by: syzbot+0e63ae76d117ae1c3a01@syzkaller.appspotmail.com
Fixes: 452238e8d5ffd8 ("netfilter: nf_tables: add and use helper for module autoload")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 43f05b3acd60..5a1a6632e3a6 100644
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
@@ -585,7 +587,7 @@ static void nft_request_module(struct net *net, const char *fmt, ...)
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
-	if (WARN(ret >= MODULE_NAME_LEN, "truncated: '%s' (len %d)", module_name, ret))
+	if (ret >= MODULE_NAME_LEN)
 		return;
 
 	mutex_unlock(&net->nft.commit_mutex);
@@ -1241,7 +1243,8 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
-	[NFTA_CHAIN_TYPE]	= { .type = NLA_STRING },
+	[NFTA_CHAIN_TYPE]	= { .type = NLA_STRING,
+				    .len = NFT_MODULE_AUTOLOAD_LIMIT },
 	[NFTA_CHAIN_COUNTERS]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_FLAGS]	= { .type = NLA_U32 },
 };
@@ -2355,7 +2358,8 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 }
 
 static const struct nla_policy nft_expr_policy[NFTA_EXPR_MAX + 1] = {
-	[NFTA_EXPR_NAME]	= { .type = NLA_STRING },
+	[NFTA_EXPR_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_MODULE_AUTOLOAD_LIMIT },
 	[NFTA_EXPR_DATA]	= { .type = NLA_NESTED },
 };
 
@@ -4198,7 +4202,8 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 	[NFTA_SET_ELEM_USERDATA]	= { .type = NLA_BINARY,
 					    .len = NFT_USERDATA_MAXLEN },
 	[NFTA_SET_ELEM_EXPR]		= { .type = NLA_NESTED },
-	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING },
+	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING,
+					    .len = NFT_OBJ_MAXNAMELEN - 1 },
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
-- 
2.24.1

