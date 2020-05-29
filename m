Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1041E7B4E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgE2LKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:10:46 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39890 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgE2LKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:10:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4961C205E3;
        Fri, 29 May 2020 13:10:42 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ML8TdA8GJQ3U; Fri, 29 May 2020 13:10:41 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3F84B20519;
        Fri, 29 May 2020 13:10:41 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:10:41 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:10:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3FF11318073E;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 12/15] esp6: calculate transport_header correctly when sel.family != AF_INET6
Date:   Fri, 29 May 2020 13:04:05 +0200
Message-ID: <20200529110408.6349-13-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

In esp6_init_state() for beet mode when x->sel.family != AF_INET6:

  x->props.header_len = sizeof(struct ip_esp_hdr) +
     crypto_aead_ivsize(aead) + IPV4_BEET_PHMAXLEN +
     (sizeof(struct ipv6hdr) - sizeof(struct iphdr))

In xfrm6_beet_gso_segment() skb->transport_header is supposed to move
to the end of the ph header for IPPROTO_BEETPH, so if x->sel.family !=
AF_INET6 and it's IPPROTO_BEETPH, it should do:

   skb->transport_header -=
      (sizeof(struct ipv6hdr) - sizeof(struct iphdr));
   skb->transport_header += ph->hdrlen * 8;

And IPV4_BEET_PHMAXLEN is only reserved for PH header, so if
x->sel.family != AF_INET6 and it's not IPPROTO_BEETPH, it should do:

   skb->transport_header -=
      (sizeof(struct ipv6hdr) - sizeof(struct iphdr));
   skb->transport_header -= IPV4_BEET_PHMAXLEN;

Thanks Sabrina for looking deep into this issue.

Fixes: 7f9e40eb18a9 ("esp6: add gso_segment for esp6 beet mode")
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/esp6_offload.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 9c03460b2760..ab0eea336c70 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -175,24 +175,27 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 
 	skb->transport_header += x->props.header_len;
 
-	if (proto == IPPROTO_BEETPH) {
-		struct ip_beet_phdr *ph = (struct ip_beet_phdr *)skb->data;
+	if (x->sel.family != AF_INET6) {
+		skb->transport_header -=
+			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
 
-		skb->transport_header += ph->hdrlen * 8;
-		proto = ph->nexthdr;
-	}
+		if (proto == IPPROTO_BEETPH) {
+			struct ip_beet_phdr *ph =
+				(struct ip_beet_phdr *)skb->data;
+
+			skb->transport_header += ph->hdrlen * 8;
+			proto = ph->nexthdr;
+		} else {
+			skb->transport_header -= IPV4_BEET_PHMAXLEN;
+		}
 
-	if (x->sel.family == AF_INET6) {
+		if (proto == IPPROTO_TCP)
+			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
+	} else {
 		__be16 frag;
 
 		skb->transport_header +=
 			ipv6_skip_exthdr(skb, 0, &proto, &frag);
-	} else {
-		skb->transport_header -=
-			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
-
-		if (proto == IPPROTO_TCP)
-			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
 	}
 
 	__skb_pull(skb, skb_transport_offset(skb));
-- 
2.17.1

