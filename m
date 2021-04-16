Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F797361D4D
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 12:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbhDPJ2n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 05:28:43 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:44069 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239117AbhDPJ2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 05:28:42 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-JGipqu4cP2i6wnOlFnbQ2Q-1; Fri, 16 Apr 2021 05:28:15 -0400
X-MC-Unique: JGipqu4cP2i6wnOlFnbQ2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E22B71008065;
        Fri, 16 Apr 2021 09:28:13 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA52619727;
        Fri, 16 Apr 2021 09:28:12 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>,
        Jianwen Ji <jiji@redhat.com>
Subject: [PATCH ipsec] xfrm: xfrm_state_mtu should return at least 1280 for ipv6
Date:   Fri, 16 Apr 2021 11:27:59 +0200
Message-Id: <62a73daeec236ed1346a89042050fe4b2fd06226.1618394317.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.31.1

