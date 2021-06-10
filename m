Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE283A2B15
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhFJMJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhFJMI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 08:08:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13332C0617A6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 05:07:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lrJSd-0000Xz-JT; Thu, 10 Jun 2021 14:06:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 5/5] xfrm: merge dstopt and routing hdroff functions
Date:   Thu, 10 Jun 2021 14:06:29 +0200
Message-Id: <20210610120629.23088-6-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610120629.23088-1-fw@strlen.de>
References: <20210610120629.23088-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both functions are very similar, so merge them into one.
The nexthdr is passed as argument to break the loop in the
ROUTING case, this is the only header type where slightly different
rules apply.

While at it, the merged function is realigned with
ip6_find_1stfragopt().  That function received bug fixes for
an infinite loop, but neither dstopt nor rh parsing functions
(copy-pasted from ip6_find_1stfragopt) were changed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_output.c | 75 +++++++++++-------------------------------
 1 file changed, 19 insertions(+), 56 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 10842d5cf6e1..9ad97cb16549 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -78,24 +78,29 @@ static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 }
 
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
-static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
-			       u8 **nexthdr)
+static int mip6_rthdr_offset(struct sk_buff *skb, u8 **nexthdr, int type)
 {
-	u16 offset = sizeof(struct ipv6hdr);
-	struct ipv6_opt_hdr *exthdr =
-				   (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
-	const unsigned char *nh = skb_network_header(skb);
+	unsigned int offset = sizeof(struct ipv6hdr);
 	unsigned int packet_len = skb_tail_pointer(skb) -
 		skb_network_header(skb);
 	int found_rhdr = 0;
 
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
@@ -116,56 +121,15 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
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
 
 	return offset;
@@ -177,9 +141,8 @@ static int xfrm6_hdr_offset(struct xfrm_state *x, struct sk_buff *skb, u8 **prev
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
2.31.1

