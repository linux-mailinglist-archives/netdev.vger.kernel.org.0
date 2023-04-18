Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5D16E6775
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjDROvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjDROu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:50:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F7713C02;
        Tue, 18 Apr 2023 07:50:56 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 5/5] netfilter: nf_tables: tighten netlink attribute requirements for catch-all elements
Date:   Tue, 18 Apr 2023 16:50:48 +0200
Message-Id: <20230418145048.67270-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230418145048.67270-1-pablo@netfilter.org>
References: <20230418145048.67270-1-pablo@netfilter.org>
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

If NFT_SET_ELEM_CATCHALL is set on, then userspace provides no set element
key. Otherwise, bail out with -EINVAL.

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 98043e83af71..e48ab8dfb541 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6108,7 +6108,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
+	if (((flags & NFT_SET_ELEM_CATCHALL) && nla[NFTA_SET_ELEM_KEY]) ||
+	    (!(flags & NFT_SET_ELEM_CATCHALL) && !nla[NFTA_SET_ELEM_KEY]))
 		return -EINVAL;
 
 	if (flags != 0) {
-- 
2.30.2

