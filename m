Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7243B143E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhFWG5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 02:57:23 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:33344 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhFWG5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 02:57:13 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 8093B800056;
        Wed, 23 Jun 2021 08:54:53 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 08:54:53 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 23 Jun
 2021 08:54:52 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5661A31801F6; Wed, 23 Jun 2021 08:54:52 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/6] xfrm: xfrm_state_mtu should return at least 1280 for ipv6
Date:   Wed, 23 Jun 2021 08:54:44 +0200
Message-ID: <20210623065449.2143405-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210623065449.2143405-1-steffen.klassert@secunet.com>
References: <20210623065449.2143405-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Jianwen reported that IPv6 Interoperability tests are failing in an
IPsec case where one of the links between the IPsec peers has an MTU
of 1280. The peer generates a packet larger than this MTU, the router
replies with a "Packet too big" message indicating an MTU of 1280.
When the peer tries to send another large packet, xfrm_state_mtu
returns 1280 - ipsec_overhead, which causes ip6_setup_cork to fail
with EINVAL.

We can fix this by forcing xfrm_state_mtu to return IPV6_MIN_MTU when
IPv6 is used. After going through IPsec, the packet will then be
fragmented to obey the actual network's PMTU, just before leaving the
host.

Currently, TFC padding is capped to PMTU - overhead to avoid
fragementation: after padding and encapsulation, we still fit within
the PMTU. That behavior is preserved in this patch.

Fixes: 91657eafb64b ("xfrm: take net hdr len into account for esp payload size calculation")
Reported-by: Jianwen Ji <jiji@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h    |  1 +
 net/ipv4/esp4.c       |  2 +-
 net/ipv6/esp6.c       |  2 +-
 net/xfrm/xfrm_state.c | 14 ++++++++++++--
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c58a6d4eb610..6232a5f048bd 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1546,6 +1546,7 @@ void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
+u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 4b834bbf95e0..ed9857b2875d 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -673,7 +673,7 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 727d791ed5e6..9d1327b36bd3 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -708,7 +708,7 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 4496f7efa220..c25586156c6a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2518,7 +2518,7 @@ void xfrm_state_delete_tunnel(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(xfrm_state_delete_tunnel);
 
-u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
+u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
 {
 	const struct xfrm_type *type = READ_ONCE(x->type);
 	struct crypto_aead *aead;
@@ -2549,7 +2549,17 @@ u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
 		 net_adj) & ~(blksize - 1)) + net_adj - 2;
 }
-EXPORT_SYMBOL_GPL(xfrm_state_mtu);
+EXPORT_SYMBOL_GPL(__xfrm_state_mtu);
+
+u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
+{
+	mtu = __xfrm_state_mtu(x, mtu);
+
+	if (x->props.family == AF_INET6 && mtu < IPV6_MIN_MTU)
+		return IPV6_MIN_MTU;
+
+	return mtu;
+}
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {
-- 
2.25.1

