Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1FD552DBD
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348072AbiFUI4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348086AbiFUI4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:56:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 868C426109;
        Tue, 21 Jun 2022 01:56:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 5/5] netfilter: nf_dup_netdev: add and use recursion counter
Date:   Tue, 21 Jun 2022 10:56:18 +0200
Message-Id: <20220621085618.3975-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220621085618.3975-1-pablo@netfilter.org>
References: <20220621085618.3975-1-pablo@netfilter.org>
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

Now that the egress function can be called from egress hook, we need
to avoid recursive calls into the nf_tables traverser, else crash.

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_dup_netdev.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 13b7f6a66086..a8e2425e43b0 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,20 +13,31 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
+#define NF_RECURSION_LIMIT	2
+
+static DEFINE_PER_CPU(u8, nf_dup_skb_recursion);
+
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
+	if (__this_cpu_read(nf_dup_skb_recursion) > NF_RECURSION_LIMIT)
+		goto err;
+
 	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
-		if (skb_cow_head(skb, skb->mac_len)) {
-			kfree_skb(skb);
-			return;
-		}
+		if (skb_cow_head(skb, skb->mac_len))
+			goto err;
+
 		skb_push(skb, skb->mac_len);
 	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
+	__this_cpu_inc(nf_dup_skb_recursion);
 	dev_queue_xmit(skb);
+	__this_cpu_dec(nf_dup_skb_recursion);
+	return;
+err:
+	kfree_skb(skb);
 }
 
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif)
-- 
2.30.2

