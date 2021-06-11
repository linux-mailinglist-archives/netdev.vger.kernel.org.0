Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1123A406A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhFKKwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhFKKwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:52:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B08C0617AF
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 03:50:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lrekA-0007iF-Lr; Fri, 11 Jun 2021 12:50:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 2/5] xfrm: ipv6: move mip6_destopt_offset into xfrm core
Date:   Fri, 11 Jun 2021 12:50:11 +0200
Message-Id: <20210611105014.4675-3-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105014.4675-1-fw@strlen.de>
References: <20210611105014.4675-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper is relatively small, just move this to the xfrm core
and call it directly.

Next patch does the same for the ROUTING type.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.31.1

