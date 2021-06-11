Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A2E3A4069
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhFKKw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhFKKwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:52:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FABC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 03:50:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lrek6-0007hy-Hj; Fri, 11 Jun 2021 12:50:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 1/5] xfrm: ipv6: add xfrm6_hdr_offset helper
Date:   Fri, 11 Jun 2021 12:50:10 +0200
Message-Id: <20210611105014.4675-2-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105014.4675-1-fw@strlen.de>
References: <20210611105014.4675-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves the ->hdr_offset indirect call to a new helper.

A followup patch can then modify the new function to replace
the indirect call by direct calls to the required hdr_offset helper.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.31.1

