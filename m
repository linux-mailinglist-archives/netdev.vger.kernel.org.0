Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5121853F191
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 23:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbiFFVVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 17:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbiFFVVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 17:21:06 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72A99C5D94;
        Mon,  6 Jun 2022 14:21:03 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 4/7] netfilter: nf_tables: always initialize flowtable hook list in transaction
Date:   Mon,  6 Jun 2022 23:20:52 +0200
Message-Id: <20220606212055.98300-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220606212055.98300-1-pablo@netfilter.org>
References: <20220606212055.98300-1-pablo@netfilter.org>
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

The hook list is used if nft_trans_flowtable_update(trans) == true. However,
initialize this list for other cases for safety reasons.

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 30588349f96c..2faa77cd2fe2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -544,6 +544,7 @@ static int nft_trans_flowtable_add(struct nft_ctx *ctx, int msg_type,
 	if (msg_type == NFT_MSG_NEWFLOWTABLE)
 		nft_activate_next(ctx->net, flowtable);
 
+	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
-- 
2.30.2

