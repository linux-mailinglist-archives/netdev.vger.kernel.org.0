Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E089E3A406B
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhFKKwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhFKKwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:52:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DEAC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 03:50:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lrekE-0007ic-Qt; Fri, 11 Jun 2021 12:50:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 3/5] xfrm: ipv6: move mip6_rthdr_offset into xfrm core
Date:   Fri, 11 Jun 2021 12:50:12 +0200
Message-Id: <20210611105014.4675-4-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105014.4675-1-fw@strlen.de>
References: <20210611105014.4675-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Place the call into the xfrm core.  After this all remaining users
set the hdr_offset function pointer to the same function which opens
the possiblity to remove the indirection.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.31.1

