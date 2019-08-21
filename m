Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9369986CB
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbfHUVqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:46:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52898 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730973AbfHUVqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 17:46:08 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D922300413C;
        Wed, 21 Aug 2019 21:46:08 +0000 (UTC)
Received: from hog.localdomain, (ovpn-204-30.brq.redhat.com [10.40.204.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAD3D3D8E;
        Wed, 21 Aug 2019 21:46:06 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 6/7] esp4: split esp_output_udp_encap and introduce esp_output_encap
Date:   Wed, 21 Aug 2019 23:46:24 +0200
Message-Id: <aa63a2a892e5c1e6513a2a5be59a9d7abc7529a2.1566395202.git.sd@queasysnail.net>
In-Reply-To: <cover.1566395202.git.sd@queasysnail.net>
References: <cover.1566395202.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 21 Aug 2019 21:46:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv4/esp4.c | 57 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index c5d826642229..033c61d27148 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -225,45 +225,62 @@ static void esp_output_fill_trailer(u8 *tail, int tfclen, int plen, __u8 proto)
 	tail[plen - 1] = proto;
 }
 
-static int esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
+static struct ip_esp_hdr *esp_output_udp_encap(struct sk_buff *skb,
+					       int encap_type,
+					       struct esp_info *esp,
+					       __be16 sport,
+					       __be16 dport)
 {
-	int encap_type;
 	struct udphdr *uh;
 	__be32 *udpdata32;
-	__be16 sport, dport;
-	struct xfrm_encap_tmpl *encap = x->encap;
-	struct ip_esp_hdr *esph = esp->esph;
 	unsigned int len;
 
-	spin_lock_bh(&x->lock);
-	sport = encap->encap_sport;
-	dport = encap->encap_dport;
-	encap_type = encap->encap_type;
-	spin_unlock_bh(&x->lock);
-
 	len = skb->len + esp->tailen - skb_transport_offset(skb);
 	if (len + sizeof(struct iphdr) >= IP_MAX_MTU)
-		return -EMSGSIZE;
+		return ERR_PTR(-EMSGSIZE);
 
-	uh = (struct udphdr *)esph;
+	uh = (struct udphdr *)esp->esph;
 	uh->source = sport;
 	uh->dest = dport;
 	uh->len = htons(len);
 	uh->check = 0;
 
+	*skb_mac_header(skb) = IPPROTO_UDP;
+
+	if (encap_type == UDP_ENCAP_ESPINUDP_NON_IKE) {
+		udpdata32 = (__be32 *)(uh + 1);
+		udpdata32[0] = udpdata32[1] = 0;
+		return (struct ip_esp_hdr *)(udpdata32 + 2);
+	}
+
+	return (struct ip_esp_hdr *)(uh + 1);
+}
+
+static int esp_output_encap(struct xfrm_state *x, struct sk_buff *skb,
+			    struct esp_info *esp)
+{
+	struct xfrm_encap_tmpl *encap = x->encap;
+	struct ip_esp_hdr *esph;
+	__be16 sport, dport;
+	int encap_type;
+
+	spin_lock_bh(&x->lock);
+	sport = encap->encap_sport;
+	dport = encap->encap_dport;
+	encap_type = encap->encap_type;
+	spin_unlock_bh(&x->lock);
+
 	switch (encap_type) {
 	default:
 	case UDP_ENCAP_ESPINUDP:
-		esph = (struct ip_esp_hdr *)(uh + 1);
-		break;
 	case UDP_ENCAP_ESPINUDP_NON_IKE:
-		udpdata32 = (__be32 *)(uh + 1);
-		udpdata32[0] = udpdata32[1] = 0;
-		esph = (struct ip_esp_hdr *)(udpdata32 + 2);
+		esph = esp_output_udp_encap(skb, encap_type, esp, sport, dport);
 		break;
 	}
 
-	*skb_mac_header(skb) = IPPROTO_UDP;
+	if (IS_ERR(esph))
+		return PTR_ERR(esph);
+
 	esp->esph = esph;
 
 	return 0;
@@ -281,7 +298,7 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 
 	/* this is non-NULL only with UDP Encapsulation */
 	if (x->encap) {
-		int err = esp_output_udp_encap(x, skb, esp);
+		int err = esp_output_encap(x, skb, esp);
 
 		if (err < 0)
 			return err;
-- 
2.22.0

