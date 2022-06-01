Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F55953A2B0
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 12:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352093AbiFAKex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 06:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352091AbiFAKer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 06:34:47 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A6A7C167
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 03:34:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2DBDE205F0;
        Wed,  1 Jun 2022 12:34:44 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K0R4YWTxypnt; Wed,  1 Jun 2022 12:34:42 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B38A120184;
        Wed,  1 Jun 2022 12:34:42 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id AE9B980004A;
        Wed,  1 Jun 2022 12:34:42 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 1 Jun 2022 12:34:42 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 1 Jun
 2022 12:34:42 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 131C83182E45; Wed,  1 Jun 2022 12:34:42 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/2] xfrm: do not set IPv4 DF flag when encapsulating IPv6 frames <= 1280 bytes.
Date:   Wed, 1 Jun 2022 12:33:49 +0200
Message-ID: <20220601103349.2297361-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601103349.2297361-1-steffen.klassert@secunet.com>
References: <20220601103349.2297361-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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

From: Maciej Żenczykowski <maze@google.com>

One may want to have DF set on large packets to support discovering
path mtu and limiting the size of generated packets (hence not
setting the XFRM_STATE_NOPMTUDISC tunnel flag), while still
supporting networks that are incapable of carrying even minimal
sized IPv6 frames (post encapsulation).

Having IPv4 Don't Frag bit set on encapsulated IPv6 frames that
are not larger than the minimum IPv6 mtu of 1280 isn't useful,
because the resulting ICMP Fragmentation Required error isn't
actionable (even assuming you receive it) because IPv6 will not
drop it's path mtu below 1280 anyway.  While the IPv4 stack
could prefrag the packets post encap, this requires the ICMP
error to be successfully delivered and causes a loss of the
original IPv6 frame (thus requiring a retransmit and latency
hit).  Luckily with IPv4 if we simply don't set the DF flag,
we'll just make further fragmenting the packets some other
router's problems.

We'll still learn the correct IPv4 path mtu through encapsulation
of larger IPv6 frames.

I'm still not convinced this patch is entirely sufficient to make
everything happy... but I don't see how it could possibly
make things worse.

See also recent:
  4ff2980b6bd2 'xfrm: fix tunnel model fragmentation behavior'
and friends

Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Lina Wang <lina.wang@mediatek.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Maciej Zenczykowski <maze@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index d4935b3b9983..555ab35cd119 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -273,6 +273,7 @@ static int xfrm4_beet_encap_add(struct xfrm_state *x, struct sk_buff *skb)
  */
 static int xfrm4_tunnel_encap_add(struct xfrm_state *x, struct sk_buff *skb)
 {
+	bool small_ipv6 = (skb->protocol == htons(ETH_P_IPV6)) && (skb->len <= IPV6_MIN_MTU);
 	struct dst_entry *dst = skb_dst(skb);
 	struct iphdr *top_iph;
 	int flags;
@@ -303,7 +304,7 @@ static int xfrm4_tunnel_encap_add(struct xfrm_state *x, struct sk_buff *skb)
 	if (flags & XFRM_STATE_NOECN)
 		IP_ECN_clear(top_iph);
 
-	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) ?
+	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) || small_ipv6 ?
 		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
 
 	top_iph->ttl = ip4_dst_hoplimit(xfrm_dst_child(dst));
-- 
2.25.1

