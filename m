Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7E25265B3
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiEMPMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbiEMPMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:12:31 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF66A522DF
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:12:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5A01520685;
        Fri, 13 May 2022 17:12:27 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xE6k092WcUOL; Fri, 13 May 2022 17:12:26 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C527620683;
        Fri, 13 May 2022 17:12:26 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id B9F9780004A;
        Fri, 13 May 2022 17:12:26 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 17:12:26 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 17:12:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 287E3318042F; Fri, 13 May 2022 17:12:26 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/8] xfrm: free not used XFRM_ESP_NO_TRAILER flag
Date:   Fri, 13 May 2022 17:12:11 +0200
Message-ID: <20220513151218.4010119-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220513151218.4010119-1-steffen.klassert@secunet.com>
References: <20220513151218.4010119-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

After removal of Innova IPsec support from mlx5 driver, the last user
of this XFRM_ESP_NO_TRAILER was gone too. This means that we can safely
remove it as no other hardware is capable (or need) to remove ESP trailer.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h | 2 +-
 net/ipv4/esp4.c    | 6 ------
 net/ipv6/esp6.c    | 6 ------
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6fb899ff5afc..b41278abeeaa 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1006,7 +1006,7 @@ struct xfrm_offload {
 #define	CRYPTO_FALLBACK		8
 #define	XFRM_GSO_SEGMENT	16
 #define	XFRM_GRO		32
-#define	XFRM_ESP_NO_TRAILER	64
+/* 64 is free */
 #define	XFRM_DEV_RESUME		128
 #define	XFRM_XMIT		256
 
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index d747166bb291..b21238df3301 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -705,7 +705,6 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 static inline int esp_remove_trailer(struct sk_buff *skb)
 {
 	struct xfrm_state *x = xfrm_input_state(skb);
-	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct crypto_aead *aead = x->data;
 	int alen, hlen, elen;
 	int padlen, trimlen;
@@ -717,11 +716,6 @@ static inline int esp_remove_trailer(struct sk_buff *skb)
 	hlen = sizeof(struct ip_esp_hdr) + crypto_aead_ivsize(aead);
 	elen = skb->len - hlen;
 
-	if (xo && (xo->flags & XFRM_ESP_NO_TRAILER)) {
-		ret = xo->proto;
-		goto out;
-	}
-
 	if (skb_copy_bits(skb, skb->len - alen - 2, nexthdr, 2))
 		BUG();
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index f2120e92caf1..36e1d0f8dd06 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -741,7 +741,6 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 static inline int esp_remove_trailer(struct sk_buff *skb)
 {
 	struct xfrm_state *x = xfrm_input_state(skb);
-	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct crypto_aead *aead = x->data;
 	int alen, hlen, elen;
 	int padlen, trimlen;
@@ -753,11 +752,6 @@ static inline int esp_remove_trailer(struct sk_buff *skb)
 	hlen = sizeof(struct ip_esp_hdr) + crypto_aead_ivsize(aead);
 	elen = skb->len - hlen;
 
-	if (xo && (xo->flags & XFRM_ESP_NO_TRAILER)) {
-		ret = xo->proto;
-		goto out;
-	}
-
 	ret = skb_copy_bits(skb, skb->len - alen - 2, nexthdr, 2);
 	BUG_ON(ret);
 
-- 
2.25.1

