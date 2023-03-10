Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66136B3AF2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjCJJlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjCJJlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:41:09 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5122EDF27C
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:40:38 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paZEm-002Vr7-Dg; Fri, 10 Mar 2023 17:40:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Mar 2023 17:40:32 +0800
Date:   Fri, 10 Mar 2023 17:40:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
Subject: [PATCH] xfrm: Remove inner/outer modes from output path
Message-ID: <ZAr7EHeGkqVUr+z5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The inner/outer modes were added to abstract out common code that
were once duplicated between IPv4 and IPv6.  As time went on the
abstractions have been removed and we are now left with empty
shells that only contain duplicate information.  These can be
removed one-by-one as the same information is already present
elsewhere in the xfrm_state object.

Just like the input-side, removing this from the output code
makes it possible to use transport-mode SAs underneath an
inter-family tunnel mode SA.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index ff114d68cc43..369e5de8558f 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -412,7 +412,7 @@ static int xfrm4_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 	IPCB(skb)->flags |= IPSKB_XFRM_TUNNEL_SIZE;
 	skb->protocol = htons(ETH_P_IP);
 
-	switch (x->outer_mode.encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
 		return xfrm4_beet_encap_add(x, skb);
 	case XFRM_MODE_TUNNEL:
@@ -435,7 +435,7 @@ static int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 	skb->ignore_df = 1;
 	skb->protocol = htons(ETH_P_IPV6);
 
-	switch (x->outer_mode.encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
 		return xfrm6_beet_encap_add(x, skb);
 	case XFRM_MODE_TUNNEL:
@@ -451,22 +451,22 @@ static int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 
 static int xfrm_outer_mode_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-	switch (x->outer_mode.encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
 	case XFRM_MODE_TUNNEL:
-		if (x->outer_mode.family == AF_INET)
+		if (x->props.family == AF_INET)
 			return xfrm4_prepare_output(x, skb);
-		if (x->outer_mode.family == AF_INET6)
+		if (x->props.family == AF_INET6)
 			return xfrm6_prepare_output(x, skb);
 		break;
 	case XFRM_MODE_TRANSPORT:
-		if (x->outer_mode.family == AF_INET)
+		if (x->props.family == AF_INET)
 			return xfrm4_transport_output(x, skb);
-		if (x->outer_mode.family == AF_INET6)
+		if (x->props.family == AF_INET6)
 			return xfrm6_transport_output(x, skb);
 		break;
 	case XFRM_MODE_ROUTEOPTIMIZATION:
-		if (x->outer_mode.family == AF_INET6)
+		if (x->props.family == AF_INET6)
 			return xfrm6_ro_output(x, skb);
 		WARN_ON_ONCE(1);
 		break;
@@ -875,21 +875,10 @@ static int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 
 static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-	const struct xfrm_mode *inner_mode;
-
-	if (x->sel.family == AF_UNSPEC)
-		inner_mode = xfrm_ip2inner_mode(x,
-				xfrm_af2proto(skb_dst(skb)->ops->family));
-	else
-		inner_mode = &x->inner_mode;
-
-	if (inner_mode == NULL)
-		return -EAFNOSUPPORT;
-
-	switch (inner_mode->family) {
-	case AF_INET:
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
 		return xfrm4_extract_output(x, skb);
-	case AF_INET6:
+	case htons(ETH_P_IPV6):
 		return xfrm6_extract_output(x, skb);
 	}
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
