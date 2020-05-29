Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6BE1E7B24
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgE2LES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:04:18 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39456 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgE2LEP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:04:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7CD092051F;
        Fri, 29 May 2020 13:04:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RG8kjXSffNcn; Fri, 29 May 2020 13:04:13 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1275920068;
        Fri, 29 May 2020 13:04:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:04:12 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:04:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 19EA131802A2;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 03/15] esp6: get the right proto for transport mode in esp6_gso_encap
Date:   Fri, 29 May 2020 13:03:56 +0200
Message-ID: <20200529110408.6349-4-steffen.klassert@secunet.com>
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

For transport mode, when ipv6 nexthdr is set, the packet format might
be like:

    ----------------------------------------------------
    |        | dest |     |     |      |  ESP    | ESP |
    | IP6 hdr| opts.| ESP | TCP | Data | Trailer | ICV |
    ----------------------------------------------------

What it wants to get for x-proto in esp6_gso_encap() is the proto that
will be set in ESP nexthdr. So it should skip all ipv6 nexthdrs and
get the real transport protocol. Othersize, the wrong proto number
will be set into ESP nexthdr.

This patch is to skip all ipv6 nexthdrs by calling ipv6_skip_exthdr()
in esp6_gso_encap().

Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/esp6_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 8eab2c869d61..b82850886574 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -123,9 +123,16 @@ static void esp6_gso_encap(struct xfrm_state *x, struct sk_buff *skb)
 	struct ip_esp_hdr *esph;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct xfrm_offload *xo = xfrm_offload(skb);
-	int proto = iph->nexthdr;
+	u8 proto = iph->nexthdr;
 
 	skb_push(skb, -skb_network_offset(skb));
+
+	if (x->outer_mode.encap == XFRM_MODE_TRANSPORT) {
+		__be16 frag;
+
+		ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto, &frag);
+	}
+
 	esph = ip_esp_hdr(skb);
 	*skb_mac_header(skb) = IPPROTO_ESP;
 
-- 
2.17.1

