Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5222671D25
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjARNJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjARNJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:09:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6468159556;
        Wed, 18 Jan 2023 04:32:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pI7cY-00075W-ST; Wed, 18 Jan 2023 13:32:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 6/9] netfilter: nf_tables: add static key to skip retpoline workarounds
Date:   Wed, 18 Jan 2023 13:32:05 +0100
Message-Id: <20230118123208.17167-7-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20230118123208.17167-1-fw@strlen.de>
References: <20230118123208.17167-1-fw@strlen.de>
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

If CONFIG_RETPOLINE is enabled nf_tables avoids indirect calls for
builtin expressions.

On newer cpus indirect calls do not go through the retpoline thunk
anymore, even for RETPOLINE=y builds.

Just like with the new tc retpoline wrappers:
Add a static key to skip the if / else if cascade if the cpu
does not require retpolines.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_core.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 709a736c301c..0f26d002d8b3 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -21,6 +21,26 @@
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/nft_meta.h>
 
+#if defined(CONFIG_RETPOLINE) && defined(CONFIG_X86)
+
+static struct static_key_false nf_tables_skip_direct_calls;
+
+static bool nf_skip_indirect_calls(void)
+{
+	return static_branch_likely(&nf_tables_skip_direct_calls);
+}
+
+static void __init nf_skip_indirect_calls_enable(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RETPOLINE))
+		static_branch_enable(&nf_tables_skip_direct_calls);
+}
+#else
+static inline bool nf_skip_indirect_calls(void) { return false; }
+
+static inline void nf_skip_indirect_calls_enable(void) { }
+#endif
+
 static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 					const struct nft_chain *chain,
 					enum nft_trace_types type)
@@ -193,7 +213,12 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
 			       struct nft_pktinfo *pkt)
 {
 #ifdef CONFIG_RETPOLINE
-	unsigned long e = (unsigned long)expr->ops->eval;
+	unsigned long e;
+
+	if (nf_skip_indirect_calls())
+		goto indirect_call;
+
+	e = (unsigned long)expr->ops->eval;
 #define X(e, fun) \
 	do { if ((e) == (unsigned long)(fun)) \
 		return fun(expr, regs, pkt); } while (0)
@@ -210,6 +235,7 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
 	X(e, nft_rt_get_eval);
 	X(e, nft_bitwise_eval);
 #undef  X
+indirect_call:
 #endif /* CONFIG_RETPOLINE */
 	expr->ops->eval(expr, regs, pkt);
 }
@@ -369,6 +395,8 @@ int __init nf_tables_core_module_init(void)
 			goto err;
 	}
 
+	nf_skip_indirect_calls_enable();
+
 	return 0;
 
 err:
-- 
2.38.2

