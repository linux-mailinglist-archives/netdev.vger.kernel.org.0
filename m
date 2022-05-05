Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF4C51BCC3
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349651AbiEEKKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239007AbiEEKKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:10:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4243B10DC
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E854CB82C17
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1365C385A4;
        Thu,  5 May 2022 10:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651745217;
        bh=q1WEVxyuEoXl7drz0f3Y3iN+PquzoHa/Jr2viDW2oyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMx6MAn646g7dMaIDod2V+f1lup8nC0vrqbW8pS0PO/JLEVphczlDv/mdN8PUCaos
         A2mZBawndb780DBXGORMEYbp8NCRPepuNiuudtdgYc8qTopWCzqSJrj3H8+C3tS+x/
         JOFC+HLFYjFqXYAdibD8/ZNiQTgDWRjN2zp/V/pzsBD8hNQEWzI+7JKsFaqKRogwBH
         0qn3FaKqV4GFYxkxeB1V4aODx/maNPp7VvtuAs9ToQSnjZasCs/nlAJE76BWYWtrw6
         d8qJSBI8NnzUyyAl3PH+mp3EAWFKsYD7oAurWsW44n+2E1aUmL25sBvSeF9EkPoPdg
         dKaAVKXIu7Xdg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH ipsec-next 1/8] xfrm: free not used XFRM_ESP_NO_TRAILER flag
Date:   Thu,  5 May 2022 13:06:38 +0300
Message-Id: <a8b37f45df031108d6b191916570a1005d645d38.1651743750.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651743750.git.leonro@nvidia.com>
References: <cover.1651743750.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
2.35.1

