Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD5F5A0396
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240886AbiHXWEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240862AbiHXWEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:04:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8EF576975;
        Wed, 24 Aug 2022 15:04:02 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 14/14] netfilter: nf_defrag_ipv6: allow nf_conntrack_frag6_high_thresh increases
Date:   Thu, 25 Aug 2022 00:03:30 +0200
Message-Id: <20220824220330.64283-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824220330.64283-1-pablo@netfilter.org>
References: <20220824220330.64283-1-pablo@netfilter.org>
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

From: Eric Dumazet <edumazet@google.com>

Currently, net.netfilter.nf_conntrack_frag6_high_thresh can only be lowered.

I found this issue while investigating a probable kernel issue
causing flakes in tools/testing/selftests/net/ip_defrag.sh

In particular, these sysctl changes were ignored:
	ip netns exec "${NETNS}" sysctl -w net.netfilter.nf_conntrack_frag6_high_thresh=9000000 >/dev/null 2>&1
	ip netns exec "${NETNS}" sysctl -w net.netfilter.nf_conntrack_frag6_low_thresh=7000000  >/dev/null 2>&1

This change is inline with commit 836196239298 ("net/ipfrag: let ip[6]frag_high_thresh
in ns be higher than in init_net")

Fixes: 8db3d41569bb ("netfilter: nf_defrag_ipv6: use net_generic infra")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 7dd3629dd19e..38db0064d661 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -86,7 +86,6 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 	table[1].extra2	= &nf_frag->fqdir->high_thresh;
 	table[2].data	= &nf_frag->fqdir->high_thresh;
 	table[2].extra1	= &nf_frag->fqdir->low_thresh;
-	table[2].extra2	= &nf_frag->fqdir->high_thresh;
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
 	if (hdr == NULL)
-- 
2.30.2

