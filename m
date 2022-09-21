Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD16A5BF7E0
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiIUHiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiIUHis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:38:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9E683F38;
        Wed, 21 Sep 2022 00:38:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oauJg-0005Qh-AM; Wed, 21 Sep 2022 09:38:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 2/5] netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()
Date:   Wed, 21 Sep 2022 09:38:22 +0200
Message-Id: <20220921073825.4658-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921073825.4658-1-fw@strlen.de>
References: <20220921073825.4658-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

syzbot is reporting underflow of nft_counters_enabled counter at
nf_tables_addchain() [1], for commit 43eb8949cfdffa76 ("netfilter:
nf_tables: do not leave chain stats enabled on error") missed that
nf_tables_chain_destroy() after nft_basechain_init() in the error path of
nf_tables_addchain() decrements the counter because nft_basechain_init()
makes nft_is_base_chain() return true by setting NFT_CHAIN_BASE flag.

Increment the counter immediately after returning from
nft_basechain_init().

Link:  https://syzkaller.appspot.com/bug?extid=b5d82a651b71cd8a75ab [1]
Reported-by: syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>
Fixes: 43eb8949cfdffa76 ("netfilter: nf_tables: do not leave chain stats enabled on error")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 816052089b33..e062754dc6cc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2197,7 +2197,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
-	struct nft_stats __percpu *stats = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_base_chain *basechain;
 	struct net *net = ctx->net;
@@ -2212,6 +2211,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		return -EOVERFLOW;
 
 	if (nla[NFTA_CHAIN_HOOK]) {
+		struct nft_stats __percpu *stats = NULL;
 		struct nft_chain_hook hook;
 
 		if (flags & NFT_CHAIN_BINDING)
@@ -2245,6 +2245,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			kfree(basechain);
 			return err;
 		}
+		if (stats)
+			static_branch_inc(&nft_counters_enabled);
 	} else {
 		if (flags & NFT_CHAIN_BASE)
 			return -EINVAL;
@@ -2319,9 +2321,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err_unregister_hook;
 	}
 
-	if (stats)
-		static_branch_inc(&nft_counters_enabled);
-
 	table->use++;
 
 	return 0;
-- 
2.35.1

