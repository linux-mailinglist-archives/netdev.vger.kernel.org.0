Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF54D9755
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346348AbiCOJQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiCOJQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:16:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4039249CAB;
        Tue, 15 Mar 2022 02:15:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9110F6300F;
        Tue, 15 Mar 2022 10:13:00 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 1/6] Revert "netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY"
Date:   Tue, 15 Mar 2022 10:15:08 +0100
Message-Id: <20220315091513.66544-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315091513.66544-1-pablo@netfilter.org>
References: <20220315091513.66544-1-pablo@netfilter.org>
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

This reverts commit 5bed9f3f63f8f9d2b1758c24640cbf77b5377511.

Gal Presman says:
 this patch broke geneve tunnels, or possibly all udp tunnels?
 A simple test that creates two geneve tunnels and runs tcp iperf fails
 and results in checksum errors (TcpInCsumErrors).

Original commit wanted to fix nf_reject with zero checksum,
so it appears better to change nf reject infra instead.

Fixes: 5bed9f3f63f8f ("netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY")
Reported-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_udp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 12f793d8fe0c..3b516cffc779 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -63,10 +63,8 @@ static bool udp_error(struct sk_buff *skb,
 	}
 
 	/* Packet with no checksum */
-	if (!hdr->check) {
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	if (!hdr->check)
 		return false;
-	}
 
 	/* Checksum invalid? Ignore.
 	 * We skip checking packets on the outgoing path
-- 
2.30.2

