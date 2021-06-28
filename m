Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B5F3B58B7
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhF1FsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:48:18 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:40936 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbhF1Fr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:47:57 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 4C83F800058;
        Mon, 28 Jun 2021 07:45:30 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:45:30 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:45:29 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 82A5731803DE; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 06/17] xfrm: ipv6: add xfrm6_hdr_offset helper
Date:   Mon, 28 Jun 2021 07:45:11 +0200
Message-ID: <20210628054522.1718786-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This moves the ->hdr_offset indirect call to a new helper.

A followup patch can then modify the new function to replace
the indirect call by direct calls to the required hdr_offset helper.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_output.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e4cb0ff4dcf4..6b44b6e738f7 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -77,6 +77,11 @@ static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
+static int xfrm6_hdr_offset(struct xfrm_state *x, struct sk_buff *skb, u8 **prevhdr)
+{
+	return x->type->hdr_offset(x, skb, prevhdr);
+}
+
 /* Add encapsulation header.
  *
  * The IP header and mutable extension headers will be moved forward to make
@@ -92,7 +97,7 @@ static int xfrm6_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 	iph = ipv6_hdr(skb);
 	skb_set_inner_transport_header(skb, skb_transport_offset(skb));
 
-	hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
+	hdr_len = xfrm6_hdr_offset(x, skb, &prevhdr);
 	if (hdr_len < 0)
 		return hdr_len;
 	skb_set_mac_header(skb,
@@ -122,7 +127,7 @@ static int xfrm6_ro_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	iph = ipv6_hdr(skb);
 
-	hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
+	hdr_len = xfrm6_hdr_offset(x, skb, &prevhdr);
 	if (hdr_len < 0)
 		return hdr_len;
 	skb_set_mac_header(skb,
-- 
2.25.1

