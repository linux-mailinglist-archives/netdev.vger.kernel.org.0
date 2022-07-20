Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A72E57C0A1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiGTXI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiGTXIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8768E6759C;
        Wed, 20 Jul 2022 16:08:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 17/18] netfilter: flowtable: prefer refcount_inc
Date:   Thu, 21 Jul 2022 01:07:53 +0200
Message-Id: <20220720230754.209053-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720230754.209053-1-pablo@netfilter.org>
References: <20220720230754.209053-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

With refcount_inc_not_zero, we'd also need a smp_rmb or similar,
followed by a test of the CONFIRMED bit.

However, the ct pointer is taken from skb->_nfct, its refcount must
not be 0 (else, we'd already have a use-after-free bug).

Use refcount_inc() instead to clarify the ct refcount is expected to
be at least 1.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 51c2b1570838..765ac779bfc8 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -53,14 +53,14 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 {
 	struct flow_offload *flow;
 
-	if (unlikely(nf_ct_is_dying(ct) ||
-	    !refcount_inc_not_zero(&ct->ct_general.use)))
+	if (unlikely(nf_ct_is_dying(ct)))
 		return NULL;
 
 	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
 	if (!flow)
-		goto err_ct_refcnt;
+		return NULL;
 
+	refcount_inc(&ct->ct_general.use);
 	flow->ct = ct;
 
 	flow_offload_fill_dir(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
@@ -72,11 +72,6 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 		__set_bit(NF_FLOW_DNAT, &flow->flags);
 
 	return flow;
-
-err_ct_refcnt:
-	nf_ct_put(ct);
-
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(flow_offload_alloc);
 
-- 
2.30.2

