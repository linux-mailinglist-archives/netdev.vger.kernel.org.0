Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9932359E8
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 20:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgHBScM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 14:32:12 -0400
Received: from correo.us.es ([193.147.175.20]:45734 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgHBScL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 14:32:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF820E4B85
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 20:32:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E19C4DA789
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 20:32:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D7678DA792; Sun,  2 Aug 2020 20:32:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CF73DA789;
        Sun,  2 Aug 2020 20:32:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 02 Aug 2020 20:32:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 794964265A2F;
        Sun,  2 Aug 2020 20:32:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 7/7] netfilter: nf_tables: report EEXIST on overlaps
Date:   Sun,  2 Aug 2020 20:31:48 +0200
Message-Id: <20200802183149.2808-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200802183149.2808-1-pablo@netfilter.org>
References: <20200802183149.2808-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace EBUSY by EEXIST in the following cases:

- If the user adds a chain with a different configuration such as different
  type, hook and priority.

- If the user adds a non-base chain that clashes with an existing basechain.

- If the user adds a { key : value } mapping element and the key exists
  but the value differs.

- If the device already belongs to an existing flowtable.

User describe that this error reporting is confusing:

- https://bugzilla.netfilter.org/show_bug.cgi?id=1176
- https://bugzilla.netfilter.org/show_bug.cgi?id=1413

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fac552b0179f..6571789989bc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2097,7 +2097,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 	if (nla[NFTA_CHAIN_HOOK]) {
 		if (!nft_is_base_chain(chain))
-			return -EBUSY;
+			return -EEXIST;
 
 		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
 					   false);
@@ -2107,21 +2107,21 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		basechain = nft_base_chain(chain);
 		if (basechain->type != hook.type) {
 			nft_chain_release_hook(&hook);
-			return -EBUSY;
+			return -EEXIST;
 		}
 
 		if (ctx->family == NFPROTO_NETDEV) {
 			if (!nft_hook_list_equal(&basechain->hook_list,
 						 &hook.list)) {
 				nft_chain_release_hook(&hook);
-				return -EBUSY;
+				return -EEXIST;
 			}
 		} else {
 			ops = &basechain->ops;
 			if (ops->hooknum != hook.num ||
 			    ops->priority != hook.priority) {
 				nft_chain_release_hook(&hook);
-				return -EBUSY;
+				return -EEXIST;
 			}
 		}
 		nft_chain_release_hook(&hook);
@@ -5262,10 +5262,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
 			    nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) ||
 			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
-			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF)) {
-				err = -EBUSY;
+			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF))
 				goto err_element_clash;
-			}
 			if ((nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
 			     memcmp(nft_set_ext_data(ext),
@@ -5273,7 +5271,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
 			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
-				err = -EBUSY;
+				goto err_element_clash;
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err = 0;
 		} else if (err == -ENOTEMPTY) {
@@ -6423,7 +6421,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			list_for_each_entry(hook2, &ft->hook_list, list) {
 				if (hook->ops.dev == hook2->ops.dev &&
 				    hook->ops.pf == hook2->ops.pf) {
-					err = -EBUSY;
+					err = -EEXIST;
 					goto err_unregister_net_hooks;
 				}
 			}
-- 
2.20.1

