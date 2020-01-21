Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F1C1437C6
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 08:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgAUHjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 02:39:11 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36788 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728843AbgAUHjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 02:39:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C1EA120561;
        Tue, 21 Jan 2020 08:39:07 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oaRfJ7w1oCkg; Tue, 21 Jan 2020 08:39:07 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E8AB620571;
        Tue, 21 Jan 2020 08:39:03 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 08:39:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 507CB31802FD;
 Tue, 21 Jan 2020 08:39:03 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/6] esp4: split esp_output_udp_encap and introduce esp_output_encap
Date:   Tue, 21 Jan 2020 08:38:57 +0100
Message-ID: <20200121073858.31120-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121073858.31120-1-steffen.klassert@secunet.com>
References: <20200121073858.31120-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.17.1

