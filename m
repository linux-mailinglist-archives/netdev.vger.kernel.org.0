Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2DE6EB554
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbjDUXCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbjDUXCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:02:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 323031FCF;
        Fri, 21 Apr 2023 16:02:21 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 07/20] netfilter: nf_tables: remove unneeded conditional
Date:   Sat, 22 Apr 2023 01:01:58 +0200
Message-Id: <20230421230211.214635-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421230211.214635-1-pablo@netfilter.org>
References: <20230421230211.214635-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

This helper is inlined, so keep it as small as possible.

If the static key is true, there is only a very small chance
that info->trace is false:

1. tracing was enabled at this very moment, the static key was
   updated to active right after nft_do_table was called.

2. tracing was disabled at this very moment.
   trace->info is already false, the static key is about to
   be patched to false soon.

In both cases, no event will be sent because info->trace
is false (checked in noinline slowpath). info->nf_trace is irrelevant.

The nf_trace update is redunant in this case, but this will only
happen for short duration, when static key flips.

       text  data   bss   dec   hex filename
old:   2980   192    32  3204   c84 nf_tables_core.o
new:   2964   192    32  3188   c74i nf_tables_core.o

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 89c05b64c2a2..bed855638050 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -67,10 +67,8 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 static inline void nft_trace_copy_nftrace(const struct nft_pktinfo *pkt,
 					  struct nft_traceinfo *info)
 {
-	if (static_branch_unlikely(&nft_trace_enabled)) {
-		if (info->trace)
-			info->nf_trace = pkt->skb->nf_trace;
-	}
+	if (static_branch_unlikely(&nft_trace_enabled))
+		info->nf_trace = pkt->skb->nf_trace;
 }
 
 static void nft_bitwise_fast_eval(const struct nft_expr *expr,
-- 
2.30.2

