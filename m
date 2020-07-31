Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C7B233FE2
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbgGaHS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:18:28 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49922 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731629AbgGaHSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 47C59205ED;
        Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9QC-DjW00YrK; Fri, 31 Jul 2020 09:18:09 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 86694205E3;
        Fri, 31 Jul 2020 09:18:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:18:09 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:18:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 55714318464B;
 Fri, 31 Jul 2020 09:18:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 02/10] xfrm: esp6: fix encapsulation header offset computation
Date:   Fri, 31 Jul 2020 09:17:56 +0200
Message-ID: <20200731071804.29557-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731071804.29557-1-steffen.klassert@secunet.com>
References: <20200731071804.29557-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

In commit 0146dca70b87, I incorrectly adapted the code that computes
the location of the UDP or TCP encapsulation header from IPv4 to
IPv6. In esp6_input_done2, skb->transport_header points to the ESP
header, so by adding skb_network_header_len, uh and th will point to
the ESP header, not the encapsulation header that's in front of it.

Since the TCP header's size can change with options, we have to start
from the IPv6 header and walk past possible extensions.

Fixes: 0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")
Fixes: 26333c37fc28 ("xfrm: add IPv6 support for espintcp")
Reported-by: Tobias Brunner <tobias@strongswan.org>
Tested-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/esp6.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index c43592771126..55ae70be91b3 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -805,10 +805,16 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 
 	if (x->encap) {
 		const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+		int offset = skb_network_offset(skb) + sizeof(*ip6h);
 		struct xfrm_encap_tmpl *encap = x->encap;
-		struct udphdr *uh = (void *)(skb_network_header(skb) + hdr_len);
-		struct tcphdr *th = (void *)(skb_network_header(skb) + hdr_len);
-		__be16 source;
+		u8 nexthdr = ip6h->nexthdr;
+		__be16 frag_off, source;
+		struct udphdr *uh;
+		struct tcphdr *th;
+
+		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
+		uh = (void *)(skb->data + offset);
+		th = (void *)(skb->data + offset);
 
 		switch (x->encap->encap_type) {
 		case TCP_ENCAP_ESPINTCP:
-- 
2.17.1

