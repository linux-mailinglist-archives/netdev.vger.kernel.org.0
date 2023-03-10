Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8CB6B3A69
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjCJJ2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjCJJ2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:28:14 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B86049D2
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:26:12 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paZ0n-002VQx-KW; Fri, 10 Mar 2023 17:26:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Mar 2023 17:26:05 +0800
Date:   Fri, 10 Mar 2023 17:26:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     steffen.klassert@secunet.com, netdev@vger.kernel.org
Cc:     David George <David.George@sophos.com>
Subject: [PATCH] xfrm: Remove inner/outer modes from input path
Message-ID: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
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

Removing them from the input path actually allows certain valid
combinations that are currently disallowed.  In particular, when
a transport mode SA sits beneath a tunnel mode SA that changes
address families, at present the transport mode SA cannot have
AF_UNSPEC as its selector because it will be erroneously be treated
as inter-family itself even though it simply sits beneath one.

This is a serious problem because you can't set the selector to
non-AF_UNSPEC either as that will cause the selector match to
fail as we always match selectors to the inner-most traffic.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 436d29640ac2..39fb91ff23d9 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -231,9 +231,6 @@ static int xfrm4_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err = -EINVAL;
 
-	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPIP)
-		goto out;
-
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto out;
 
@@ -269,8 +266,6 @@ static int xfrm6_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err = -EINVAL;
 
-	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPV6)
-		goto out;
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto out;
 
@@ -331,22 +326,26 @@ static int xfrm6_remove_beet_encap(struct xfrm_state *x, struct sk_buff *skb)
  */
 static int
 xfrm_inner_mode_encap_remove(struct xfrm_state *x,
-			     const struct xfrm_mode *inner_mode,
 			     struct sk_buff *skb)
 {
-	switch (inner_mode->encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
-		if (inner_mode->family == AF_INET)
+		switch (XFRM_MODE_SKB_CB(skb)->protocol) {
+		case IPPROTO_IPIP:
+		case IPPROTO_BEETPH:
 			return xfrm4_remove_beet_encap(x, skb);
-		if (inner_mode->family == AF_INET6)
+		case IPPROTO_IPV6:
 			return xfrm6_remove_beet_encap(x, skb);
+		}
 		break;
 	case XFRM_MODE_TUNNEL:
-		if (inner_mode->family == AF_INET)
+		switch (XFRM_MODE_SKB_CB(skb)->protocol) {
+		case IPPROTO_IPIP:
 			return xfrm4_remove_tunnel_encap(x, skb);
-		if (inner_mode->family == AF_INET6)
+		case IPPROTO_IPV6:
 			return xfrm6_remove_tunnel_encap(x, skb);
 		break;
+		}
 	}
 
 	WARN_ON_ONCE(1);
@@ -355,9 +354,7 @@ xfrm_inner_mode_encap_remove(struct xfrm_state *x,
 
 static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 {
-	const struct xfrm_mode *inner_mode = &x->inner_mode;
-
-	switch (x->outer_mode.family) {
+	switch (x->props.family) {
 	case AF_INET:
 		xfrm4_extract_header(skb);
 		break;
@@ -369,17 +366,12 @@ static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 		return -EAFNOSUPPORT;
 	}
 
-	if (x->sel.family == AF_UNSPEC) {
-		inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
-		if (!inner_mode)
-			return -EAFNOSUPPORT;
-	}
-
-	switch (inner_mode->family) {
-	case AF_INET:
+	switch (XFRM_MODE_SKB_CB(skb)->protocol) {
+	case IPPROTO_IPIP:
+	case IPPROTO_BEETPH:
 		skb->protocol = htons(ETH_P_IP);
 		break;
-	case AF_INET6:
+	case IPPROTO_IPV6:
 		skb->protocol = htons(ETH_P_IPV6);
 		break;
 	default:
@@ -387,7 +379,7 @@ static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 		break;
 	}
 
-	return xfrm_inner_mode_encap_remove(x, inner_mode, skb);
+	return xfrm_inner_mode_encap_remove(x, skb);
 }
 
 /* Remove encapsulation header.
@@ -433,17 +425,16 @@ static int xfrm6_transport_input(struct xfrm_state *x, struct sk_buff *skb)
 }
 
 static int xfrm_inner_mode_input(struct xfrm_state *x,
-				 const struct xfrm_mode *inner_mode,
 				 struct sk_buff *skb)
 {
-	switch (inner_mode->encap) {
+	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
 	case XFRM_MODE_TUNNEL:
 		return xfrm_prepare_input(x, skb);
 	case XFRM_MODE_TRANSPORT:
-		if (inner_mode->family == AF_INET)
+		if (x->props.family == AF_INET)
 			return xfrm4_transport_input(x, skb);
-		if (inner_mode->family == AF_INET6)
+		if (x->props.family == AF_INET6)
 			return xfrm6_transport_input(x, skb);
 		break;
 	case XFRM_MODE_ROUTEOPTIMIZATION:
@@ -461,7 +452,6 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 {
 	const struct xfrm_state_afinfo *afinfo;
 	struct net *net = dev_net(skb->dev);
-	const struct xfrm_mode *inner_mode;
 	int err;
 	__be32 seq;
 	__be32 seq_hi;
@@ -491,7 +481,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop;
 		}
 
-		family = x->outer_mode.family;
+		family = x->props.family;
 
 		/* An encap_type of -1 indicates async resumption. */
 		if (encap_type == -1) {
@@ -676,17 +666,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		XFRM_MODE_SKB_CB(skb)->protocol = nexthdr;
 
-		inner_mode = &x->inner_mode;
-
-		if (x->sel.family == AF_UNSPEC) {
-			inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
-			if (inner_mode == NULL) {
-				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
-				goto drop;
-			}
-		}
-
-		if (xfrm_inner_mode_input(x, inner_mode, skb)) {
+		if (xfrm_inner_mode_input(x, skb)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
 			goto drop;
 		}
@@ -701,7 +681,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		 * transport mode so the outer address is identical.
 		 */
 		daddr = &x->id.daddr;
-		family = x->outer_mode.family;
+		family = x->props.family;
 
 		err = xfrm_parse_spi(skb, nexthdr, &spi, &seq);
 		if (err < 0) {
@@ -732,7 +712,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		err = -EAFNOSUPPORT;
 		rcu_read_lock();
-		afinfo = xfrm_state_afinfo_get_rcu(x->inner_mode.family);
+		afinfo = xfrm_state_afinfo_get_rcu(x->props.family);
 		if (likely(afinfo))
 			err = afinfo->transport_finish(skb, xfrm_gro || async);
 		rcu_read_unlock();
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
