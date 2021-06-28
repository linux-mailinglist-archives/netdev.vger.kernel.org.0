Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442C93B58B8
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhF1FsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:48:20 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:35554 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhF1Fr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:47:57 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 6B5D0800058;
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
        id 8B8AE3180426; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 08/17] xfrm: ipv6: move mip6_rthdr_offset into xfrm core
Date:   Mon, 28 Jun 2021 07:45:13 +0200
Message-ID: <20210628054522.1718786-9-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Place the call into the xfrm core.  After this all remaining users
set the hdr_offset function pointer to the same function which opens
the possiblity to remove the indirection.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/mip6.c        | 48 -----------------------------------------
 net/xfrm/xfrm_output.c | 49 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index fba3b56a7dd2..aeb35d26e474 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -333,53 +333,6 @@ static int mip6_rthdr_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
-static int mip6_rthdr_offset(struct xfrm_state *x, struct sk_buff *skb,
-			     u8 **nexthdr)
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
-			if (offset + 3 <= packet_len) {
-				struct ipv6_rt_hdr *rt;
-				rt = (struct ipv6_rt_hdr *)(nh + offset);
-				if (rt->type != 0)
-					return offset;
-			}
-			found_rhdr = 1;
-			break;
-		case NEXTHDR_DEST:
-			if (ipv6_find_tlv(skb, offset, IPV6_TLV_HAO) >= 0)
-				return offset;
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
 static int mip6_rthdr_init_state(struct xfrm_state *x)
 {
 	if (x->id.spi) {
@@ -413,7 +366,6 @@ static const struct xfrm_type mip6_rthdr_type = {
 	.destructor	= mip6_rthdr_destroy,
 	.input		= mip6_rthdr_input,
 	.output		= mip6_rthdr_output,
-	.hdr_offset	= mip6_rthdr_offset,
 };
 
 static int __init mip6_init(void)
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 29959054a535..1734339b6dd0 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -123,6 +123,53 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
 
 	return offset;
 }
+
+static int mip6_rthdr_offset(struct xfrm_state *x, struct sk_buff *skb,
+			     u8 **nexthdr)
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
+			if (offset + 3 <= packet_len) {
+				struct ipv6_rt_hdr *rt;
+
+				rt = (struct ipv6_rt_hdr *)(nh + offset);
+				if (rt->type != 0)
+					return offset;
+			}
+			found_rhdr = 1;
+			break;
+		case NEXTHDR_DEST:
+			if (ipv6_find_tlv(skb, offset, IPV6_TLV_HAO) >= 0)
+				return offset;
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
 #endif
 
 static int xfrm6_hdr_offset(struct xfrm_state *x, struct sk_buff *skb, u8 **prevhdr)
@@ -131,6 +178,8 @@ static int xfrm6_hdr_offset(struct xfrm_state *x, struct sk_buff *skb, u8 **prev
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 	case IPPROTO_DSTOPTS:
 		return mip6_destopt_offset(x, skb, prevhdr);
+	case IPPROTO_ROUTING:
+		return mip6_rthdr_offset(x, skb, prevhdr);
 #endif
 	default:
 		break;
-- 
2.25.1

