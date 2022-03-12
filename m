Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000C44D713A
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 23:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiCLWEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 17:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiCLWEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 17:04:31 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18DA0D0059;
        Sat, 12 Mar 2022 14:03:24 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 36F4462FF8;
        Sat, 12 Mar 2022 23:01:14 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/3] Revert "netfilter: conntrack: tag conntracks picked up in local out hook"
Date:   Sat, 12 Mar 2022 23:03:14 +0100
Message-Id: <20220312220315.64531-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220312220315.64531-1-pablo@netfilter.org>
References: <20220312220315.64531-1-pablo@netfilter.org>
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

This was a prerequisite for the ill-fated
"netfilter: nat: force port remap to prevent shadowing well-known ports".

As this has been reverted, this change can be backed out too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h | 1 -
 net/netfilter/nf_conntrack_core.c    | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 8731d5bcb47d..b08b70989d2c 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -97,7 +97,6 @@ struct nf_conn {
 	unsigned long status;
 
 	u16		cpu;
-	u16		local_origin:1;
 	possible_net_t ct_net;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d6aa5b47031e..bf1e17c678f1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1748,9 +1748,6 @@ resolve_normal_ct(struct nf_conn *tmpl,
 			return 0;
 		if (IS_ERR(h))
 			return PTR_ERR(h);
-
-		ct = nf_ct_tuplehash_to_ctrack(h);
-		ct->local_origin = state->hook == NF_INET_LOCAL_OUT;
 	}
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
-- 
2.30.2

