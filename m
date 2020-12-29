Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE282E719C
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 16:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgL2PKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 10:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgL2PKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 10:10:20 -0500
X-Greylist: delayed 684 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Dec 2020 07:09:40 PST
Received: from vale.hankala.org (vale.hankala.org [IPv6:2a02:2770:3:0:21a:4aff:fefb:f65c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4FCC0613D6
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 07:09:39 -0800 (PST)
Received: by vale.hankala.org (OpenSMTPD) with ESMTPS id 4d8bcb7e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 29 Dec 2020 14:58:08 +0000 (UTC)
Date:   Tue, 29 Dec 2020 14:58:06 +0000
From:   Visa Hankala <visa@hankala.org>
To:     Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] xfrm: Fix wraparound in xfrm_policy_addr_delta()
Message-ID: <20201229145009.cGOUak0JdKIIgGAv@hankala.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use three-way comparison for address elements to avoid integer
wraparound in the result of xfrm_policy_addr_delta().

This ensures that the search trees are built and traversed correctly
when the difference between compared address elements is larger
than INT_MAX.

Fixes: 9cf545ebd591d ("xfrm: policy: store inexact policies in a tree ordered by destination address")
Signed-off-by: Visa Hankala <visa@hankala.org>

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d622c2548d22..d74902f11dde 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -793,15 +793,20 @@ static int xfrm_policy_addr_delta(const xfrm_address_t *a,
 				  const xfrm_address_t *b,
 				  u8 prefixlen, u16 family)
 {
+	u32 ma, mb, mask;
 	unsigned int pdw, pbi;
 	int delta = 0;
 
 	switch (family) {
 	case AF_INET:
-		if (sizeof(long) == 4 && prefixlen == 0)
-			return ntohl(a->a4) - ntohl(b->a4);
-		return (ntohl(a->a4) & ((~0UL << (32 - prefixlen)))) -
-		       (ntohl(b->a4) & ((~0UL << (32 - prefixlen))));
+		mask = ~0U << (32 - prefixlen);
+		ma = ntohl(a->a4) & mask;
+		mb = ntohl(b->a4) & mask;
+		if (ma < mb)
+			delta = -1;
+		else if (ma > mb)
+			delta = 1;
+		break;
 	case AF_INET6:
 		pdw = prefixlen >> 5;
 		pbi = prefixlen & 0x1f;
@@ -812,10 +817,13 @@ static int xfrm_policy_addr_delta(const xfrm_address_t *a,
 				return delta;
 		}
 		if (pbi) {
-			u32 mask = ~0u << (32 - pbi);
-
-			delta = (ntohl(a->a6[pdw]) & mask) -
-				(ntohl(b->a6[pdw]) & mask);
+			mask = ~0U << (32 - pbi);
+			ma = ntohl(a->a6[pdw]) & mask;
+			mb = ntohl(b->a6[pdw]) & mask;
+			if (ma < mb)
+				delta = -1;
+			else if (ma > mb)
+				delta = 1;
 		}
 		break;
 	default:
asd
