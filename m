Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7017B3A2B0F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhFJMIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhFJMIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 08:08:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D148C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 05:06:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lrJSM-0000Wz-Tq; Thu, 10 Jun 2021 14:06:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 1/5] xfrm: ipv6: add xfrm6_hdr_offset helper
Date:   Thu, 10 Jun 2021 14:06:25 +0200
Message-Id: <20210610120629.23088-2-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610120629.23088-1-fw@strlen.de>
References: <20210610120629.23088-1-fw@strlen.de>
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

