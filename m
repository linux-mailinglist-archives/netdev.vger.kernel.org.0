Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD45EED1C
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 07:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiI2FOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 01:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiI2FOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 01:14:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC9211D601
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 22:14:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6C06F201CA;
        Thu, 29 Sep 2022 07:14:02 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2KlLp5yGKG1q; Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 862772049B;
        Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 76EDF80004A;
        Thu, 29 Sep 2022 07:14:01 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 07:14:01 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 29 Sep
 2022 07:14:00 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AE71A31829F2; Thu, 29 Sep 2022 07:14:00 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/3] esp: choose the correct inner protocol for GSO on inter address family tunnels
Date:   Thu, 29 Sep 2022 07:13:55 +0200
Message-ID: <20220929051357.3497325-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929051357.3497325-1-steffen.klassert@secunet.com>
References: <20220929051357.3497325-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Commit 23c7f8d7989e ("net: Fix esp GSO on inter address family
tunnels.") is incomplete. It passes to skb_eth_gso_segment the
protocol for the outer IP version, instead of the inner IP version, so
we end up calling inet_gso_segment on an inner IPv6 packet and
ipv6_gso_segment on an inner IPv4 packet and the packets are dropped.

This patch completes the fix by selecting the correct protocol based
on the inner mode's family.

Fixes: c35fe4106b92 ("xfrm: Add mode handlers for IPsec on layer 2")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 5 ++++-
 net/ipv6/esp6_offload.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 935026f4c807..170152772d33 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -110,7 +110,10 @@ static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	return skb_eth_gso_segment(skb, features, htons(ETH_P_IP));
+	__be16 type = x->inner_mode.family == AF_INET6 ? htons(ETH_P_IPV6)
+						       : htons(ETH_P_IP);
+
+	return skb_eth_gso_segment(skb, features, type);
 }
 
 static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 3a293838a91d..79d43548279c 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -145,7 +145,10 @@ static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	return skb_eth_gso_segment(skb, features, htons(ETH_P_IPV6));
+	__be16 type = x->inner_mode.family == AF_INET ? htons(ETH_P_IP)
+						      : htons(ETH_P_IPV6);
+
+	return skb_eth_gso_segment(skb, features, type);
 }
 
 static struct sk_buff *xfrm6_transport_gso_segment(struct xfrm_state *x,
-- 
2.25.1

