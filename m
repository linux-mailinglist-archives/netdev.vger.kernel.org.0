Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B89C24DD34
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgHURLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgHUQRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 12:17:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C69122CBB;
        Fri, 21 Aug 2020 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026614;
        bh=SHQsGLhTINATRUXZjr9wWKY8XwhSvsPPfJfThLF74Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mh8pUq8vbejcqj9i3DxPouzohjRUAwrp7iokH1S9fRxaeKqoFZIL7NTOBIAclVvbC
         NXTXe5HYggDYUEEI6SHLgfR/qm6Qn4lWx6amG1FK70sXsy37x6aE8+86vctGL97ONm
         gh3oCOeu9GnEX7+1RvXSAYqTSTgxwC23eNPIurdQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 55/61] netfilter: nf_tables: report EEXIST on overlaps
Date:   Fri, 21 Aug 2020 12:15:39 -0400
Message-Id: <20200821161545.347622-55-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 77a92189ecfd061616ad531d386639aab7baaad9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e1d678af8749b..4d6ed763e5dd4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2035,7 +2035,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 	if (nla[NFTA_CHAIN_HOOK]) {
 		if (!nft_is_base_chain(chain))
-			return -EBUSY;
+			return -EEXIST;
 
 		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
 					   false);
@@ -2045,21 +2045,21 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
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
@@ -5144,10 +5144,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -5155,7 +5153,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
 			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
-				err = -EBUSY;
+				goto err_element_clash;
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err = 0;
 		} else if (err == -ENOTEMPTY) {
@@ -6264,7 +6262,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			list_for_each_entry(hook2, &ft->hook_list, list) {
 				if (hook->ops.dev == hook2->ops.dev &&
 				    hook->ops.pf == hook2->ops.pf) {
-					err = -EBUSY;
+					err = -EEXIST;
 					goto err_unregister_net_hooks;
 				}
 			}
-- 
2.25.1

