Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50C21E7B29
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgE2LEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:04:23 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39500 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgE2LER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:04:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 91B9C205CD;
        Fri, 29 May 2020 13:04:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id S0dM8rboJsx5; Fri, 29 May 2020 13:04:15 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 356E020068;
        Fri, 29 May 2020 13:04:14 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:04:13 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:04:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2A86D31803C0;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 07/15] esp6: support ipv6 nexthdrs process for beet gso segment
Date:   Fri, 29 May 2020 13:04:00 +0200
Message-ID: <20200529110408.6349-8-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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
    | IP6 hdr| ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

Before doing gso segment in xfrm6_beet_gso_segment(), it should
skip all nexthdrs and get the real transport proto, and set
transport_header properly.

This patch is to fix it by simply calling ipv6_skip_exthdr()
in xfrm6_beet_gso_segment().

v1->v2:
  - remove skb_transport_offset(), as it will always return 0
    in xfrm6_beet_gso_segment(), thank Sabrina's check.

Fixes: 7f9e40eb18a9 ("esp6: add gso_segment for esp6 beet mode")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/esp6_offload.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index b92372b104ba..9c03460b2760 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -171,7 +171,7 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	const struct net_offload *ops;
-	int proto = xo->proto;
+	u8 proto = xo->proto;
 
 	skb->transport_header += x->props.header_len;
 
@@ -182,7 +182,12 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 		proto = ph->nexthdr;
 	}
 
-	if (x->sel.family != AF_INET6) {
+	if (x->sel.family == AF_INET6) {
+		__be16 frag;
+
+		skb->transport_header +=
+			ipv6_skip_exthdr(skb, 0, &proto, &frag);
+	} else {
 		skb->transport_header -=
 			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
 
-- 
2.17.1

