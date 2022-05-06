Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A5F51D8BB
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392337AbiEFNWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiEFNW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:22:29 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66E96353E
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 06:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0ZdVHpBLMXBBi5kN6NCuYIbVnlJofHUSZX0Ml4JUdL4=; b=XFfESnuFWt0hVxBddAdabd/7eA
        Ayh3qj14a5Xajpk+X10CWISPK2EjLZLzfpzKbkfF501BvWcBF3KtQVNYGuCm+Z03pXIanXNzpon9X
        m7VVSIV+FrKpbz/yrHO5IZmAt9fFrEP3kG3xYYNMoRHRhGGxQf1SbFLdkiAW7j47Jvsg=;
Received: from p200300daa70ef2004175abbac4c8f9c2.dip0.t-ipconnect.de ([2003:da:a70e:f200:4175:abba:c4c8:f9c2] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nmxr2-0005Kx-Sr; Fri, 06 May 2022 15:18:45 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH 2/4] netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices
Date:   Fri,  6 May 2022 15:18:39 +0200
Message-Id: <20220506131841.3177-2-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506131841.3177-1-nbd@nbd.name>
References: <20220506131841.3177-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dst entry does not contain a valid hardware address, so skip the lookup
in order to avoid running into errors here.
The proper hardware address is filled in from nft_dev_path_info

Signed-off-by: Felix Fietkau <nbd@nbd.name>
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
2.35.1

