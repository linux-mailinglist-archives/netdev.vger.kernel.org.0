Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4175B5A4A
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiILMlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiILMlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:41:09 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F07F17AB8
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:41:04 -0700 (PDT)
Received: from fsav411.sakura.ne.jp (fsav411.sakura.ne.jp [133.242.250.110])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28CCf1gA036892;
        Mon, 12 Sep 2022 21:41:01 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav411.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp);
 Mon, 12 Sep 2022 21:41:00 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28CCf0oc036889
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 12 Sep 2022 21:41:00 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <8c86a1bb-9c43-b02e-cf93-e098b158ee8c@I-love.SAKURA.ne.jp>
Date:   Mon, 12 Sep 2022 21:41:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: [PATCH] netfilter: nf_tables: fix nft_counters_enabled underflow at
 nf_tables_addchain()
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <000000000000a9172705e7ffef2e@google.com>
Cc:     syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <000000000000a9172705e7ffef2e@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.18.4

