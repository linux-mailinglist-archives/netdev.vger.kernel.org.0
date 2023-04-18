Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2026E6774
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjDROvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjDROu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:50:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4CF67ABF;
        Tue, 18 Apr 2023 07:50:54 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/5] netfilter: nf_tables: fix ifdef to also consider nf_tables=m
Date:   Tue, 18 Apr 2023 16:50:46 +0200
Message-Id: <20230418145048.67270-4-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

nftables can be built as a module, so fix the preprocessor conditional
accordingly.

Fixes: 478b360a47b7 ("netfilter: nf_tables: fix nf_trace always-on with XT_TRACE=n")
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/skbuff.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1ec3530c8191..dbcaac8b6966 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4713,7 +4713,7 @@ static inline void nf_reset_ct(struct sk_buff *skb)
 
 static inline void nf_reset_trace(struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	skb->nf_trace = 0;
 #endif
 }
@@ -4733,7 +4733,7 @@ static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src,
 	dst->_nfct = src->_nfct;
 	nf_conntrack_get(skb_nfct(src));
 #endif
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	if (copy)
 		dst->nf_trace = src->nf_trace;
 #endif
-- 
2.30.2

