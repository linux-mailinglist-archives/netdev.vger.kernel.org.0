Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F531E7B2B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgE2LE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:04:27 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39494 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgE2LEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:04:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 21B5720539;
        Fri, 29 May 2020 13:04:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YCOIDQTFmzM4; Fri, 29 May 2020 13:04:14 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 03E8B205B5;
        Fri, 29 May 2020 13:04:14 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:04:13 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:04:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2EB4631804B1;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 08/15] esp4: support ipv6 nexthdrs process for beet gso segment
Date:   Fri, 29 May 2020 13:04:01 +0200
Message-ID: <20200529110408.6349-9-steffen.klassert@secunet.com>
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

For beet mode, when it's ipv6 inner address with nexthdrs set,
the packet format might be:

    ----------------------------------------------------
    | outer  |     | dest |     |      |  ESP    | ESP |
    | IP hdr | ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

Before doing gso segment in xfrm4_beet_gso_segment(), the same
thing is needed as it does in xfrm6_beet_gso_segment() in last
patch 'esp6: support ipv6 nexthdrs process for beet gso segment'.

v1->v2:
  - remove skb_transport_offset(), as it will always return 0
    in xfrm6_beet_gso_segment(), thank Sabrina's check.

Fixes: 384a46ea7bdc ("esp4: add gso_segment for esp4 beet mode")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 231edcb84c08..9b1d451edae0 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -137,7 +137,7 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	const struct net_offload *ops;
-	int proto = xo->proto;
+	u8 proto = xo->proto;
 
 	skb->transport_header += x->props.header_len;
 
@@ -146,10 +146,15 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 
 		skb->transport_header += ph->hdrlen * 8;
 		proto = ph->nexthdr;
-	} else if (x->sel.family != AF_INET6) {
+	} else if (x->sel.family == AF_INET6) {
+		__be16 frag;
+
+		skb->transport_header +=
+			ipv6_skip_exthdr(skb, 0, &proto, &frag);
+		if (proto == IPPROTO_TCP)
+			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
+	} else {
 		skb->transport_header -= IPV4_BEET_PHMAXLEN;
-	} else if (proto == IPPROTO_TCP) {
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
 	}
 
 	__skb_pull(skb, skb_transport_offset(skb));
-- 
2.17.1

