Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F87952C5B0
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiERVle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 17:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241186AbiERVj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 17:39:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ABA6246DBA;
        Wed, 18 May 2022 14:38:47 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 2/7] netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices
Date:   Wed, 18 May 2022 23:38:36 +0200
Message-Id: <20220518213841.359653-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518213841.359653-1-pablo@netfilter.org>
References: <20220518213841.359653-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

The dst entry does not contain a valid hardware address, so skip the lookup
in order to avoid running into errors here.
The proper hardware address is filled in from nft_dev_path_info

Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 900d48c810a1..d88de26aad75 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -36,6 +36,15 @@ static void nft_default_forward_path(struct nf_flow_route *route,
 	route->tuple[dir].xmit_type	= nft_xmit_type(dst_cache);
 }
 
+static bool nft_is_valid_ether_device(const struct net_device *dev)
+{
+	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
+	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
+		return false;
+
+	return true;
+}
+
 static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 				     const struct dst_entry *dst_cache,
 				     const struct nf_conn *ct,
@@ -47,6 +56,9 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 	struct neighbour *n;
 	u8 nud_state;
 
+	if (!nft_is_valid_ether_device(dev))
+		goto out;
+
 	n = dst_neigh_lookup(dst_cache, daddr);
 	if (!n)
 		return -1;
@@ -60,6 +72,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 	if (!(nud_state & NUD_VALID))
 		return -1;
 
+out:
 	return dev_fill_forward_path(dev, ha, stack);
 }
 
@@ -78,15 +91,6 @@ struct nft_forward_info {
 	enum flow_offload_xmit_type xmit_type;
 };
 
-static bool nft_is_valid_ether_device(const struct net_device *dev)
-{
-	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
-	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
-		return false;
-
-	return true;
-}
-
 static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			      struct nft_forward_info *info,
 			      unsigned char *ha, struct nf_flowtable *flowtable)
-- 
2.30.2

