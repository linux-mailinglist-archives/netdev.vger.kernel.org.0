Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2794C3F41
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 08:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbiBYHsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 02:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238244AbiBYHsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 02:48:14 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8231AA4BD
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 23:47:41 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C70D820534;
        Fri, 25 Feb 2022 08:47:38 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nA9H5EBAMSUp; Fri, 25 Feb 2022 08:47:37 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B053E20538;
        Fri, 25 Feb 2022 08:47:37 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id A98B680004A;
        Fri, 25 Feb 2022 08:47:37 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Fri, 25 Feb 2022 08:47:37 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 25 Feb
 2022 08:47:36 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B1AFF3182F54; Fri, 25 Feb 2022 08:47:36 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/6] Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"
Date:   Fri, 25 Feb 2022 08:47:31 +0100
Message-ID: <20220225074733.118664-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225074733.118664-1-steffen.klassert@secunet.com>
References: <20220225074733.118664-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

This reverts commit b515d2637276a3810d6595e10ab02c13bfd0b63a.

Commit b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm: xfrm_state_mtu
should return at least 1280 for ipv6") in v5.14 breaks the TCP MSS
calculation in ipsec transport mode, resulting complete stalls of TCP
connections. This happens when the (P)MTU is 1280 or slighly larger.

The desired formula for the MSS is:
MSS = (MTU - ESP_overhead) - IP header - TCP header

However, the above commit clamps the (MTU - ESP_overhead) to a
minimum of 1280, turning the formula into
MSS = max(MTU - ESP overhead, 1280) -  IP header - TCP header

With the (P)MTU near 1280, the calculated MSS is too large and the
resulting TCP packets never make it to the destination because they
are over the actual PMTU.

The above commit also causes suboptimal double fragmentation in
xfrm tunnel mode, as described in
https://lore.kernel.org/netdev/20210429202529.codhwpc7w6kbudug@dwarf.suse.cz/

The original problem the above commit was trying to fix is now fixed
by commit 6596a0229541270fb8d38d989f91b78838e5e9da ("xfrm: fix MTU
regression").

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h    |  1 -
 net/ipv4/esp4.c       |  2 +-
 net/ipv6/esp6.c       |  2 +-
 net/xfrm/xfrm_state.c | 14 ++------------
 4 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 743dd1da506e..76aa6f11a540 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1568,7 +1568,6 @@ void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 851f542928a3..e1b1d080e908 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -671,7 +671,7 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 8bb2c407b46b..7591160edce1 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -707,7 +707,7 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 1ba6fbfe8cdb..b749935152ba 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2579,7 +2579,7 @@ void xfrm_state_delete_tunnel(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(xfrm_state_delete_tunnel);
 
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
+u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 {
 	const struct xfrm_type *type = READ_ONCE(x->type);
 	struct crypto_aead *aead;
@@ -2610,17 +2610,7 @@ u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
 	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
 		 net_adj) & ~(blksize - 1)) + net_adj - 2;
 }
-EXPORT_SYMBOL_GPL(__xfrm_state_mtu);
-
-u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
-{
-	mtu = __xfrm_state_mtu(x, mtu);
-
-	if (x->props.family == AF_INET6 && mtu < IPV6_MIN_MTU)
-		return IPV6_MIN_MTU;
-
-	return mtu;
-}
+EXPORT_SYMBOL_GPL(xfrm_state_mtu);
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {
-- 
2.25.1

