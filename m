Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714B46742E4
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjASTdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjASTdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:33:35 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC4653B37
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:33:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E5534204B4;
        Thu, 19 Jan 2023 20:33:25 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MIzH5lNWePLb; Thu, 19 Jan 2023 20:33:25 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 558C420460;
        Thu, 19 Jan 2023 20:33:25 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 449C880004A;
        Thu, 19 Jan 2023 20:33:25 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 19 Jan 2023 20:33:25 +0100
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 20:33:24 +0100
Date:   Thu, 19 Jan 2023 20:33:11 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH 1/3] xfrm: Use the XFRM_GRO to indicate a GRO call on input.
Message-ID: <6dfd03c5fa0afb99f255f4a35772df19e33880db.1674156645.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

This is needed to support GRO for ESP in UDP encapsulation.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/ipv4/esp4_offload.c |  2 +-
 net/ipv6/esp6_offload.c |  2 +-
 net/xfrm/xfrm_input.c   | 75 +++++++++++++++++++++++------------------
 3 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 3969fa805679..77bb01032667 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -76,7 +76,7 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 
 	/* We don't need to handle errors from xfrm_input, it does all
 	 * the error handling and frees the resources on error. */
-	xfrm_input(skb, IPPROTO_ESP, spi, -2);
+	xfrm_input(skb, IPPROTO_ESP, spi, 0);
 
 	return ERR_PTR(-EINPROGRESS);
 out_reset:
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 75c02992c520..ee5f5abdb503 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -103,7 +103,7 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 
 	/* We don't need to handle errors from xfrm_input, it does all
 	 * the error handling and frees the resources on error. */
-	xfrm_input(skb, IPPROTO_ESP, spi, -2);
+	xfrm_input(skb, IPPROTO_ESP, spi, 0);
 
 	return ERR_PTR(-EINPROGRESS);
 out_reset:
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index c06e54a10540..ffd62ad58207 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -458,6 +458,35 @@ static int xfrm_inner_mode_input(struct xfrm_state *x,
 	return -EOPNOTSUPP;
 }
 
+static int xfrm_input_check_offload(struct net *net, struct sk_buff *skb,
+				    struct xfrm_state *x,
+				    struct xfrm_offload *xo)
+{
+	if (!(xo->status & CRYPTO_SUCCESS)) {
+		if (xo->status &
+		    (CRYPTO_TRANSPORT_AH_AUTH_FAILED |
+		     CRYPTO_TRANSPORT_ESP_AUTH_FAILED |
+		     CRYPTO_TUNNEL_AH_AUTH_FAILED |
+		     CRYPTO_TUNNEL_ESP_AUTH_FAILED)) {
+			xfrm_audit_state_icvfail(x, skb,
+						 x->type->proto);
+			x->stats.integrity_failed++;
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR);
+			return -EINVAL;
+		}
+
+		if (xo->status & CRYPTO_INVALID_PROTOCOL) {
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR);
+			return -EINVAL;
+		}
+
+		XFRM_INC_STATS(net, LINUX_MIB_XFRMINBUFFERERROR);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 {
 	const struct xfrm_state_afinfo *afinfo;
@@ -477,7 +506,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp;
 
-	if (encap_type < 0) {
+	if (encap_type < 0 || (xo && xo->flags & XFRM_GRO)) {
 		x = xfrm_input_state(skb);
 
 		if (unlikely(x->km.state != XFRM_STATE_VALID)) {
@@ -495,46 +524,26 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		family = x->outer_mode.family;
 
 		/* An encap_type of -1 indicates async resumption. */
-		if (encap_type == -1) {
+		if (encap_type  < 0) {
 			async = 1;
 			seq = XFRM_SKB_CB(skb)->seq.input.low;
 			goto resume;
-		}
+		} else {
+			/* GRO call */
+			seq = XFRM_SPI_SKB_CB(skb)->seq;
 
-		/* encap_type < -1 indicates a GRO call. */
-		encap_type = 0;
-		seq = XFRM_SPI_SKB_CB(skb)->seq;
-
-		if (xo && (xo->flags & CRYPTO_DONE)) {
-			crypto_done = true;
-			family = XFRM_SPI_SKB_CB(skb)->family;
-
-			if (!(xo->status & CRYPTO_SUCCESS)) {
-				if (xo->status &
-				    (CRYPTO_TRANSPORT_AH_AUTH_FAILED |
-				     CRYPTO_TRANSPORT_ESP_AUTH_FAILED |
-				     CRYPTO_TUNNEL_AH_AUTH_FAILED |
-				     CRYPTO_TUNNEL_ESP_AUTH_FAILED)) {
-
-					xfrm_audit_state_icvfail(x, skb,
-								 x->type->proto);
-					x->stats.integrity_failed++;
-					XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR);
+			if (xo && (xo->flags & CRYPTO_DONE)) {
+				crypto_done = true;
+				family = XFRM_SPI_SKB_CB(skb)->family;
+
+				err = xfrm_input_check_offload(net, skb, x, xo);
+				if (err)
 					goto drop;
-				}
 
-				if (xo->status & CRYPTO_INVALID_PROTOCOL) {
-					XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR);
+				if (xfrm_parse_spi(skb, nexthdr, &spi, &seq)) {
+					XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 					goto drop;
 				}
-
-				XFRM_INC_STATS(net, LINUX_MIB_XFRMINBUFFERERROR);
-				goto drop;
-			}
-
-			if (xfrm_parse_spi(skb, nexthdr, &spi, &seq)) {
-				XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
-				goto drop;
 			}
 		}
 
-- 
2.30.2

