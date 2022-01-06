Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D563F486232
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbiAFJgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:36:20 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38808 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237453AbiAFJgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:36:19 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EB5332063F;
        Thu,  6 Jan 2022 10:36:17 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ugj7e-7DIday; Thu,  6 Jan 2022 10:36:14 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DC6BF2065C;
        Thu,  6 Jan 2022 10:36:12 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id D707480004A;
        Thu,  6 Jan 2022 10:36:12 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:36:12 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:36:12 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 223373183042; Thu,  6 Jan 2022 10:36:09 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 6/6] net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path
Date:   Thu, 6 Jan 2022 10:36:06 +0100
Message-ID: <20220106093606.3046771-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106093606.3046771-1-steffen.klassert@secunet.com>
References: <20220106093606.3046771-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

The inner_ipproto saves the inner IP protocol of the plain
text packet. This allows vendor's IPsec feature making offload
decision at skb's features_check and configuring hardware at
ndo_start_xmit, current code implenetation did not handle the
case where IPsec is used in tunnel mode.

Fix by handling the case when IPsec is used in tunnel mode by
reading the protocol of the plain text packet IP protocol.

Fixes: fa4535238fb5 ("net/xfrm: Add inner_ipproto into sec_path")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_output.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 229544bc70c2..4dc4a7bbe51c 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -647,10 +647,12 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
  * This requires hardware to know the inner packet type to calculate
  * the inner header checksum. Save inner ip protocol here to avoid
  * traversing the packet in the vendor's xmit code.
- * If the encap type is IPIP, just save skb->inner_ipproto. Otherwise,
- * get the ip protocol from the IP header.
+ * For IPsec tunnel mode save the ip protocol from the IP header of the
+ * plain text packet. Otherwise If the encap type is IPIP, just save
+ * skb->inner_ipproto in any other case get the ip protocol from the IP
+ * header.
  */
-static void xfrm_get_inner_ipproto(struct sk_buff *skb)
+static void xfrm_get_inner_ipproto(struct sk_buff *skb, struct xfrm_state *x)
 {
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	const struct ethhdr *eth;
@@ -658,6 +660,25 @@ static void xfrm_get_inner_ipproto(struct sk_buff *skb)
 	if (!xo)
 		return;
 
+	if (x->outer_mode.encap == XFRM_MODE_TUNNEL) {
+		switch (x->outer_mode.family) {
+		case AF_INET:
+			xo->inner_ipproto = ip_hdr(skb)->protocol;
+			break;
+		case AF_INET6:
+			xo->inner_ipproto = ipv6_hdr(skb)->nexthdr;
+			break;
+		default:
+			break;
+		}
+
+		return;
+	}
+
+	/* non-Tunnel Mode */
+	if (!skb->encapsulation)
+		return;
+
 	if (skb->inner_protocol_type == ENCAP_TYPE_IPPROTO) {
 		xo->inner_ipproto = skb->inner_ipproto;
 		return;
@@ -712,8 +733,7 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		sp->xvec[sp->len++] = x;
 		xfrm_state_hold(x);
 
-		if (skb->encapsulation)
-			xfrm_get_inner_ipproto(skb);
+		xfrm_get_inner_ipproto(skb, x);
 		skb->encapsulation = 1;
 
 		if (skb_is_gso(skb)) {
-- 
2.25.1

