Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E99552DB6
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347800AbiFUI4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346241AbiFUI4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:56:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA8EA26ACB;
        Tue, 21 Jun 2022 01:56:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 4/5] netfilter: nf_dup_netdev: do not push mac header a second time
Date:   Tue, 21 Jun 2022 10:56:17 +0200
Message-Id: <20220621085618.3975-5-pablo@netfilter.org>
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

Eric reports skb_under_panic when using dup/fwd via bond+egress hook.
Before pushing mac header, we should make sure that we're called from
ingress to put back what was pulled earlier.

In egress case, the MAC header is already there; we should leave skb
alone.

While at it be more careful here: skb might have been altered and
headroom reduced, so add a skb_cow() before so that headroom is
increased if necessary.

nf_do_netdev_egress() assumes skb ownership (it normally ends with
a call to dev_queue_xmit), so we must free the packet on error.

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Reported-by: Eric Garver <eric@garver.life>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_dup_netdev.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 7873bd1389c3..13b7f6a66086 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,10 +13,16 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
-static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
+static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
+				enum nf_dev_hooks hook)
 {
-	if (skb_mac_header_was_set(skb))
+	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
+		if (skb_cow_head(skb, skb->mac_len)) {
+			kfree_skb(skb);
+			return;
+		}
 		skb_push(skb, skb->mac_len);
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
@@ -33,7 +39,7 @@ void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 		return;
 	}
 
-	nf_do_netdev_egress(pkt->skb, dev);
+	nf_do_netdev_egress(pkt->skb, dev, nft_hook(pkt));
 }
 EXPORT_SYMBOL_GPL(nf_fwd_netdev_egress);
 
@@ -48,7 +54,7 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 
 	skb = skb_clone(pkt->skb, GFP_ATOMIC);
 	if (skb)
-		nf_do_netdev_egress(skb, dev);
+		nf_do_netdev_egress(skb, dev, nft_hook(pkt));
 }
 EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
 
-- 
2.30.2

