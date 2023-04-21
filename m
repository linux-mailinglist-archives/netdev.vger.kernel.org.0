Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461676EB5F1
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbjDUXu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbjDUXug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:50:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4F732682;
        Fri, 21 Apr 2023 16:50:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 16/19] netfilter: nf_tables: rename function to destroy hook list
Date:   Sat, 22 Apr 2023 01:50:18 +0200
Message-Id: <20230421235021.216950-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421235021.216950-1-pablo@netfilter.org>
References: <20230421235021.216950-1-pablo@netfilter.org>
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

Rename nft_flowtable_hooks_destroy() by nft_hooks_destroy() to prepare
for netdev chain device updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3f95fb24a0bc..77975b4b0fdc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7771,7 +7771,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return err;
 }
 
-static void nft_flowtable_hooks_destroy(struct list_head *hook_list)
+static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
 
@@ -7952,7 +7952,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 					       &flowtable->hook_list,
 					       flowtable);
 	if (err < 0) {
-		nft_flowtable_hooks_destroy(&flowtable->hook_list);
+		nft_hooks_destroy(&flowtable->hook_list);
 		goto err4;
 	}
 
@@ -8789,7 +8789,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELFLOWTABLE:
 	case NFT_MSG_DESTROYFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
@@ -9440,7 +9440,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_NEWFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
-- 
2.30.2

