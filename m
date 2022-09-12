Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6505B5BBA
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 15:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiILN7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 09:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiILN7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 09:59:06 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E341C138;
        Mon, 12 Sep 2022 06:59:04 -0700 (PDT)
Received: from fsav413.sakura.ne.jp (fsav413.sakura.ne.jp [133.242.250.112])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28CDwqFU054023;
        Mon, 12 Sep 2022 22:58:52 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav413.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp);
 Mon, 12 Sep 2022 22:58:52 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28CDwqwU054019
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 12 Sep 2022 22:58:52 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <41e415f2-3ca4-8e8a-a4b5-5044e7043131@I-love.SAKURA.ne.jp>
Date:   Mon, 12 Sep 2022 22:58:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] netfilter: nf_tables: fix percpu memory leak at
 nf_tables_addchain()
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

It seems to me that percpu memory for chain stats started leaking since
commit 3bc158f8d0330f0a ("netfilter: nf_tables: map basechain priority to
hardware priority") when nft_chain_offload_priority() returned an error.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 3bc158f8d0330f0a ("netfilter: nf_tables: map basechain priority to hardware priority")
---
The "netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()" made
me wonder where free_percpu() is called when nft_basechain_init() returned an error. But I
don't know whether this patch is correct. Please check carefully.

 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e062754dc6cc..63c70141b3e5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2243,6 +2243,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (err < 0) {
 			nft_chain_release_hook(&hook);
 			kfree(basechain);
+			free_percpu(stats);
 			return err;
 		}
 		if (stats)
-- 
2.18.4
