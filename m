Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4683BEFF5
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfD3Fax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:30:53 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46858 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbfD3Fav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:30:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6053F2026F;
        Tue, 30 Apr 2019 07:30:49 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QRs7NL7_j2o9; Tue, 30 Apr 2019 07:30:48 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D41AB20276;
        Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 07:30:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 10B24318060B;
 Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 09/12] esp4: add length check for UDP encapsulation
Date:   Tue, 30 Apr 2019 07:30:27 +0200
Message-ID: <20190430053030.27009-10-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430053030.27009-1-steffen.klassert@secunet.com>
References: <20190430053030.27009-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 2A00F79F-89F9-42C5-BB0B-1EF0CD7F269F
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

esp_output_udp_encap can produce a length that doesn't fit in the 16
bits of a UDP header's length field. In that case, we'll send a
fragmented packet whose length is larger than IP_MAX_MTU (resulting in
"Oversized IP packet" warnings on receive) and with a bogus UDP
length.

To prevent this, add a length check to esp_output_udp_encap and return
 -EMSGSIZE on failure.

This seems to be older than git history.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 10e809b296ec..fb065a8937ea 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -226,7 +226,7 @@ static void esp_output_fill_trailer(u8 *tail, int tfclen, int plen, __u8 proto)
 	tail[plen - 1] = proto;
 }
 
-static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
+static int esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	int encap_type;
 	struct udphdr *uh;
@@ -234,6 +234,7 @@ static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, stru
 	__be16 sport, dport;
 	struct xfrm_encap_tmpl *encap = x->encap;
 	struct ip_esp_hdr *esph = esp->esph;
+	unsigned int len;
 
 	spin_lock_bh(&x->lock);
 	sport = encap->encap_sport;
@@ -241,11 +242,14 @@ static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, stru
 	encap_type = encap->encap_type;
 	spin_unlock_bh(&x->lock);
 
+	len = skb->len + esp->tailen - skb_transport_offset(skb);
+	if (len + sizeof(struct iphdr) >= IP_MAX_MTU)
+		return -EMSGSIZE;
+
 	uh = (struct udphdr *)esph;
 	uh->source = sport;
 	uh->dest = dport;
-	uh->len = htons(skb->len + esp->tailen
-		  - skb_transport_offset(skb));
+	uh->len = htons(len);
 	uh->check = 0;
 
 	switch (encap_type) {
@@ -262,6 +266,8 @@ static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, stru
 
 	*skb_mac_header(skb) = IPPROTO_UDP;
 	esp->esph = esph;
+
+	return 0;
 }
 
 int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
@@ -275,8 +281,12 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	int tailen = esp->tailen;
 
 	/* this is non-NULL only with UDP Encapsulation */
-	if (x->encap)
-		esp_output_udp_encap(x, skb, esp);
+	if (x->encap) {
+		int err = esp_output_udp_encap(x, skb, esp);
+
+		if (err < 0)
+			return err;
+	}
 
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
-- 
2.17.1

