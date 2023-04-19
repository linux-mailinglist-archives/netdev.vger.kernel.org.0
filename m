Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43FC6E746C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 09:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjDSHxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 03:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjDSHxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 03:53:49 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982EAA5F0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 00:53:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E1A5B2008D;
        Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xPp-vSeZyh8Z; Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2D485206D0;
        Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 2847180004A;
        Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 09:53:05 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 19 Apr
 2023 09:53:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CACA43182C36; Wed, 19 Apr 2023 09:53:04 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/2] xfrm: Remove inner/outer modes from input path
Date:   Wed, 19 Apr 2023 09:52:59 +0200
Message-ID: <20230419075300.452227-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230419075300.452227-1-steffen.klassert@secunet.com>
References: <20230419075300.452227-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_input.c | 66 +++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 43 deletions(-)

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
2.34.1

