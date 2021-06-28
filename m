Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0C43B58B5
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhF1FsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:48:10 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:35546 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbhF1Fr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:47:57 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 2A695800057;
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
        id 946C63180454; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 10/17] xfrm: merge dstopt and routing hdroff functions
Date:   Mon, 28 Jun 2021 07:45:15 +0200
Message-ID: <20210628054522.1718786-11-steffen.klassert@secunet.com>
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

Both functions are very similar, so merge them into one.

The nexthdr is passed as argument to break the loop in the
ROUTING case, this is the only header type where slightly different
rules apply.

While at it, the merged function is realigned with
ip6_find_1stfragopt().  That function received bug fixes for an infinite
loop, but neither dstopt nor rh parsing functions (copy-pasted from
ip6_find_1stfragopt) were changed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_output.c | 80 ++++++++++++------------------------------
 1 file changed, 22 insertions(+), 58 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 10842d5cf6e1..e14fca1fb003 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -78,24 +78,30 @@ static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 }
 
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
-static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
-			       u8 **nexthdr)
+static int mip6_rthdr_offset(struct sk_buff *skb, u8 **nexthdr, int type)
 {
-	u16 offset = sizeof(struct ipv6hdr);
-	struct ipv6_opt_hdr *exthdr =
-				   (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
 	const unsigned char *nh = skb_network_header(skb);
-	unsigned int packet_len = skb_tail_pointer(skb) -
-		skb_network_header(skb);
+	unsigned int offset = sizeof(struct ipv6hdr);
+	unsigned int packet_len;
 	int found_rhdr = 0;
 
+	packet_len = skb_tail_pointer(skb) - nh;
 	*nexthdr = &ipv6_hdr(skb)->nexthdr;
 
-	while (offset + 1 <= packet_len) {
+	while (offset <= packet_len) {
+		struct ipv6_opt_hdr *exthdr;
+
 		switch (**nexthdr) {
 		case NEXTHDR_HOP:
 			break;
 		case NEXTHDR_ROUTING:
+			if (type == IPPROTO_ROUTING && offset + 3 <= packet_len) {
+				struct ipv6_rt_hdr *rt;
+
+				rt = (struct ipv6_rt_hdr *)(nh + offset);
+				if (rt->type != 0)
+					return offset;
+			}
 			found_rhdr = 1;
 			break;
 		case NEXTHDR_DEST:
@@ -116,59 +122,18 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
 			return offset;
 		}
 
-		offset += ipv6_optlen(exthdr);
-		*nexthdr = &exthdr->nexthdr;
-		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
-	}
-
-	return offset;
-}
-
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
-		switch (**nexthdr) {
-		case NEXTHDR_HOP:
-			break;
-		case NEXTHDR_ROUTING:
-			if (offset + 3 <= packet_len) {
-				struct ipv6_rt_hdr *rt;
-
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
+		if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
+			return -EINVAL;
 
+		exthdr = (struct ipv6_opt_hdr *)(skb_network_header(skb) +
+						 offset);
 		offset += ipv6_optlen(exthdr);
+		if (offset > IPV6_MAXPLEN)
+			return -EINVAL;
 		*nexthdr = &exthdr->nexthdr;
-		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 	}
 
-	return offset;
+	return -EINVAL;
 }
 #endif
 
@@ -177,9 +142,8 @@ static int xfrm6_hdr_offset(struct xfrm_state *x, struct sk_buff *skb, u8 **prev
 	switch (x->type->proto) {
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 	case IPPROTO_DSTOPTS:
-		return mip6_destopt_offset(x, skb, prevhdr);
 	case IPPROTO_ROUTING:
-		return mip6_rthdr_offset(x, skb, prevhdr);
+		return mip6_rthdr_offset(skb, prevhdr, x->type->proto);
 #endif
 	default:
 		break;
-- 
2.25.1

