Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4863B58B6
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhF1FsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:48:17 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:40928 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbhF1Fr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:47:57 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 04718800057;
        Mon, 28 Jun 2021 07:45:30 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:45:29 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:45:29 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8707931803FC; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 07/17] xfrm: ipv6: move mip6_destopt_offset into xfrm core
Date:   Mon, 28 Jun 2021 07:45:12 +0200
Message-ID: <20210628054522.1718786-8-steffen.klassert@secunet.com>
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

This helper is relatively small, just move this to the xfrm core
and call it directly.

Next patch does the same for the ROUTING type.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/mip6.c        | 49 ------------------------------------
 net/xfrm/xfrm_output.c | 57 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 49 deletions(-)

diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index bc560e1664aa..fba3b56a7dd2 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -247,54 +247,6 @@ static int mip6_destopt_reject(struct xfrm_state *x, struct sk_buff *skb,
 	return err;
 }
 
-static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
-			       u8 **nexthdr)
-{
-	u16 offset = sizeof(struct ipv6hdr);
-	struct ipv6_opt_hdr *exthdr =
-				   (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
-	const unsigned char *nh = skb_network_header(skb);
-	unsigned int packet_len = skb_tail_pointer(skb) -
-		skb_network_header(skb);
-	int found_rhdr = 0;
-
-	*nexthdr = &ipv6_hdr(skb)->nexthdr;
-
-	while (offset + 1 <= packet_len) {
-
-		switch (**nexthdr) {
-		case NEXTHDR_HOP:
-			break;
-		case NEXTHDR_ROUTING:
-			found_rhdr = 1;
-			break;
-		case NEXTHDR_DEST:
-			/*
-			 * HAO MUST NOT appear more than once.
-			 * XXX: It is better to try to find by the end of
-			 * XXX: packet if HAO exists.
-			 */
-			if (ipv6_find_tlv(skb, offset, IPV6_TLV_HAO) >= 0) {
-				net_dbg_ratelimited("mip6: hao exists already, override\n");
-				return offset;
-			}
-
-			if (found_rhdr)
-				return offset;
-
-			break;
-		default:
-			return offset;
-		}
-
-		offset += ipv6_optlen(exthdr);
-		*nexthdr = &exthdr->nexthdr;
-		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
-	}
-
-	return offset;
-}
-
 static int mip6_destopt_init_state(struct xfrm_state *x)
 {
 	if (x->id.spi) {
@@ -332,7 +284,6 @@ static const struct xfrm_type mip6_destopt_type = {
 	.input		= mip6_destopt_input,
 	.output		= mip6_destopt_output,
 	.reject		= mip6_destopt_reject,
-	.hdr_offset	= mip6_destopt_offset,
 };
 
 static int mip6_rthdr_input(struct xfrm_state *x, struct sk_buff *skb)
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 6b44b6e738f7..29959054a535 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -77,8 +77,65 @@ static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
+			       u8 **nexthdr)
+{
+	u16 offset = sizeof(struct ipv6hdr);
+	struct ipv6_opt_hdr *exthdr =
+				   (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
+	const unsigned char *nh = skb_network_header(skb);
+	unsigned int packet_len = skb_tail_pointer(skb) -
+		skb_network_header(skb);
+	int found_rhdr = 0;
+
+	*nexthdr = &ipv6_hdr(skb)->nexthdr;
+
+	while (offset + 1 <= packet_len) {
+		switch (**nexthdr) {
+		case NEXTHDR_HOP:
+			break;
+		case NEXTHDR_ROUTING:
+			found_rhdr = 1;
+			break;
+		case NEXTHDR_DEST:
+			/* HAO MUST NOT appear more than once.
+			 * XXX: It is better to try to find by the end of
+			 * XXX: packet if HAO exists.
+			 */
+			if (ipv6_find_tlv(skb, offset, IPV6_TLV_HAO) >= 0) {
+				net_dbg_ratelimited("mip6: hao exists already, override\n");
+				return offset;
+			}
+
+			if (found_rhdr)
+				return offset;
+
+			break;
+		default:
+			return offset;
+		}
+
+		offset += ipv6_optlen(exthdr);
+		*nexthdr = &exthdr->nexthdr;
+		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
+	}
+
+	return offset;
+}
+#endif
+
 static int xfrm6_hdr_offset(struct xfrm_state *x, struct sk_buff *skb, u8 **prevhdr)
 {
+	switch (x->type->proto) {
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+	case IPPROTO_DSTOPTS:
+		return mip6_destopt_offset(x, skb, prevhdr);
+#endif
+	default:
+		break;
+	}
+
 	return x->type->hdr_offset(x, skb, prevhdr);
 }
 
-- 
2.25.1

