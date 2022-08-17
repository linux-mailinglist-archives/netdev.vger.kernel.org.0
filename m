Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFD9597090
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbiHQOCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239897AbiHQOCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:02:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F257E333;
        Wed, 17 Aug 2022 07:01:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oOJc3-0008Rk-TC; Wed, 17 Aug 2022 16:01:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 12/17] netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags
Date:   Wed, 17 Aug 2022 16:00:10 +0200
Message-Id: <20220817140015.25843-13-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817140015.25843-1-fw@strlen.de>
References: <20220817140015.25843-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

If the NFT_SET_CONCAT|NFT_SET_INTERVAL flags are set on, then the
netlink attribute NFTA_SET_ELEM_KEY_END must be specified. Otherwise,
NFTA_SET_ELEM_KEY_END should not be present.

For catch-all element, NFTA_SET_ELEM_KEY_END should not be present.
The NFT_SET_ELEM_INTERVAL_END is never used with this set flags
combination.

Fixes: 7b225d0b5c6d ("netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bcfe8120e014..1d14d694f654 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5844,6 +5844,24 @@ static void nft_setelem_remove(const struct net *net,
 		set->ops->remove(net, set, elem);
 }
 
+static bool nft_setelem_valid_key_end(const struct nft_set *set,
+				      struct nlattr **nla, u32 flags)
+{
+	if ((set->flags & (NFT_SET_CONCAT | NFT_SET_INTERVAL)) ==
+			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
+		if (flags & NFT_SET_ELEM_INTERVAL_END)
+			return false;
+		if (!nla[NFTA_SET_ELEM_KEY_END] &&
+		    !(flags & NFT_SET_ELEM_CATCHALL))
+			return false;
+	} else {
+		if (nla[NFTA_SET_ELEM_KEY_END])
+			return false;
+	}
+
+	return true;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -5903,6 +5921,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return -EINVAL;
 	}
 
+	if (!nft_setelem_valid_key_end(set, nla, flags))
+		return -EINVAL;
+
 	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
 	     (nla[NFTA_SET_ELEM_DATA] ||
 	      nla[NFTA_SET_ELEM_OBJREF] ||
@@ -6333,6 +6354,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 
+	if (!nft_setelem_valid_key_end(set, nla, flags))
+		return -EINVAL;
+
 	nft_set_ext_prepare(&tmpl);
 
 	if (flags != 0) {
-- 
2.35.1

