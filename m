Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080CE6E746D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 09:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjDSHxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 03:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjDSHxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 03:53:49 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B30A5F8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 00:53:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0EE11206D0;
        Wed, 19 Apr 2023 09:53:07 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MYkoXe2xJesP; Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 539AF2084C;
        Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 4E72380004A;
        Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 09:53:05 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 19 Apr
 2023 09:53:04 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D70363182E94; Wed, 19 Apr 2023 09:53:04 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/2] xfrm: Remove inner/outer modes from output path
Date:   Wed, 19 Apr 2023 09:53:00 +0200
Message-ID: <20230419075300.452227-3-steffen.klassert@secunet.com>
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

Just like the input-side, removing this from the output code
makes it possible to use transport-mode SAs underneath an
inter-family tunnel mode SA.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_output.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

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
2.34.1

