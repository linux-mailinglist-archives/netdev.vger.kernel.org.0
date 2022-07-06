Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575B7568D5D
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiGFPin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbiGFPhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:37:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788C52AE17;
        Wed,  6 Jul 2022 08:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 144AAB81D98;
        Wed,  6 Jul 2022 15:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B37C341C8;
        Wed,  6 Jul 2022 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121636;
        bh=Yn/jMuAgDhaAo8EvuAzql3ECAH8cMmvlm8r3h/A/msY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dF17ee2iAPMSeq2S+to1TeFTSue8EJfvKgIzX0P+8q9rmuvgmZWBwKcTPPLybPH/B
         FS7/KwpPM/65juPRpsgP40sBHkBU3J+4vf1fTwXYvWCtdmajqsB9gOQoLghQ1buKqn
         Rjt/rRoE5xv+20/GI8wlm1CbT8BBCpJO6jPCElIqQeuHlRMvGfaFHZA/yO2HBnQw3M
         z8KaQW0rNnjuL++gs0hjnjbMidKDVeASkP54arDKYGYNliriw0PLSbQVMUEFpn5tBk
         7+Nk1iV9PBq2UPLCDk+ZKTj7SIEST9yP+ZnwreqQsPMlzk0RB7MvmtU9Zif1KyHBaM
         FH72xCKU3fHjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Radim Hrazdil <rhrazdil@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        roopa@nvidia.com, razor@blackwall.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/8] netfilter: br_netfilter: do not skip all hooks with 0 priority
Date:   Wed,  6 Jul 2022 11:33:45 -0400
Message-Id: <20220706153351.1598805-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153351.1598805-1-sashal@kernel.org>
References: <20220706153351.1598805-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c2577862eeb0be94f151f2f1fff662b028061b00 ]

When br_netfilter module is loaded, skbs may be diverted to the
ipv4/ipv6 hooks, just like as if we were routing.

Unfortunately, bridge filter hooks with priority 0 may be skipped
in this case.

Example:
1. an nftables bridge ruleset is loaded, with a prerouting
   hook that has priority 0.
2. interface is added to the bridge.
3. no tcp packet is ever seen by the bridge prerouting hook.
4. flush the ruleset
5. load the bridge ruleset again.
6. tcp packets are processed as expected.

After 1) the only registered hook is the bridge prerouting hook, but its
not called yet because the bridge hasn't been brought up yet.

After 2), hook order is:
   0 br_nf_pre_routing // br_netfilter internal hook
   0 chain bridge f prerouting // nftables bridge ruleset

The packet is diverted to br_nf_pre_routing.
If call-iptables is off, the nftables bridge ruleset is called as expected.

But if its enabled, br_nf_hook_thresh() will skip it because it assumes
that all 0-priority hooks had been called previously in bridge context.

To avoid this, check for the br_nf_pre_routing hook itself, we need to
resume directly after it, even if this hook has a priority of 0.

Unfortunately, this still results in different packet flow.
With this fix, the eval order after in 3) is:
1. br_nf_pre_routing
2. ip(6)tables (if enabled)
3. nftables bridge

but after 5 its the much saner:
1. nftables bridge
2. br_nf_pre_routing
3. ip(6)tables (if enabled)

Unfortunately I don't see a solution here:
It would be possible to move br_nf_pre_routing to a higher priority
so that it will be called later in the pipeline, but this also impacts
ebtables evaluation order, and would still result in this very ordering
problem for all nftables-bridge hooks with the same priority as the
br_nf_pre_routing one.

Searching back through the git history I don't think this has
ever behaved in any other way, hence, no fixes-tag.

Reported-by: Radim Hrazdil <rhrazdil@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 7e50bd9f3611..ee7a03ff89f3 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -998,9 +998,24 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 		return okfn(net, sk, skb);
 
 	ops = nf_hook_entries_get_hook_ops(e);
-	for (i = 0; i < e->num_hook_entries &&
-	      ops[i]->priority <= NF_BR_PRI_BRNF; i++)
-		;
+	for (i = 0; i < e->num_hook_entries; i++) {
+		/* These hooks have already been called */
+		if (ops[i]->priority < NF_BR_PRI_BRNF)
+			continue;
+
+		/* These hooks have not been called yet, run them. */
+		if (ops[i]->priority > NF_BR_PRI_BRNF)
+			break;
+
+		/* take a closer look at NF_BR_PRI_BRNF. */
+		if (ops[i]->hook == br_nf_pre_routing) {
+			/* This hook diverted the skb to this function,
+			 * hooks after this have not been run yet.
+			 */
+			i++;
+			break;
+		}
+	}
 
 	nf_hook_state_init(&state, hook, NFPROTO_BRIDGE, indev, outdev,
 			   sk, net, okfn);
-- 
2.35.1

