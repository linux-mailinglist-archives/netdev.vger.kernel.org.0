Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA2B6E0EC6
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjDMNfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjDMNes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:34:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0ACB458;
        Thu, 13 Apr 2023 06:32:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pmx4H-00017T-Bu; Thu, 13 Apr 2023 15:32:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next v2 4/6] netfilter: disallow bpf hook attachment at same priority
Date:   Thu, 13 Apr 2023 15:32:26 +0200
Message-Id: <20230413133228.20790-5-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413133228.20790-1-fw@strlen.de>
References: <20230413133228.20790-1-fw@strlen.de>
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

This is just to avoid ordering issues between multiple bpf programs,
this could be removed later in case it turns out to be too cautious.

bpf prog could still be shared with non-bpf hook, otherwise we'd have to
make conntrack hook registration fail just because a bpf program has
same priority.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 358220b58521..f0783e42108b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -119,6 +119,18 @@ nf_hook_entries_grow(const struct nf_hook_entries *old,
 		for (i = 0; i < old_entries; i++) {
 			if (orig_ops[i] != &dummy_ops)
 				alloc_entries++;
+
+			/* Restrict BPF hook type to force a unique priority, not
+			 * shared at attach time.
+			 *
+			 * This is mainly to avoid ordering issues between two
+			 * different bpf programs, this doesn't prevent a normal
+			 * hook at same priority as a bpf one (we don't want to
+			 * prevent defrag, conntrack, iptables etc from attaching).
+			 */
+			if (reg->priority == orig_ops[i]->priority &&
+			    reg->hook_ops_type == NF_HOOK_OP_BPF)
+				return ERR_PTR(-EBUSY);
 		}
 	}
 
-- 
2.39.2

