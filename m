Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D4468BBBA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjBFLeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjBFLdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:33:44 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71C114211;
        Mon,  6 Feb 2023 03:33:39 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOydl-007zhn-Io; Mon, 06 Feb 2023 18:22:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:25 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:25 +0800
Subject: [PATCH 7/17] tipc: Add scaffolding to change completion function signature
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Message-Id: <E1pOydl-007zhn-Io@formenos.hmeau.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds temporary scaffolding so that the Crypto API
completion function can take a void * instead of crypto_async_request.
Once affected users have been converted this can be removed.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/tipc/crypto.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index d67440de011e..ab356e7a3870 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -267,10 +267,10 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 			     struct tipc_bearer *b,
 			     struct tipc_media_addr *dst,
 			     struct tipc_node *__dnode);
-static void tipc_aead_encrypt_done(struct crypto_async_request *base, int err);
+static void tipc_aead_encrypt_done(crypto_completion_data_t *data, int err);
 static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 			     struct sk_buff *skb, struct tipc_bearer *b);
-static void tipc_aead_decrypt_done(struct crypto_async_request *base, int err);
+static void tipc_aead_decrypt_done(crypto_completion_data_t *data, int err);
 static inline int tipc_ehdr_size(struct tipc_ehdr *ehdr);
 static int tipc_ehdr_build(struct net *net, struct tipc_aead *aead,
 			   u8 tx_key, struct sk_buff *skb,
@@ -830,9 +830,9 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 	return rc;
 }
 
-static void tipc_aead_encrypt_done(struct crypto_async_request *base, int err)
+static void tipc_aead_encrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct tipc_crypto_tx_ctx *tx_ctx = TIPC_SKB_CB(skb)->crypto_ctx;
 	struct tipc_bearer *b = tx_ctx->bearer;
 	struct tipc_aead *aead = tx_ctx->aead;
@@ -954,9 +954,9 @@ static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 	return rc;
 }
 
-static void tipc_aead_decrypt_done(struct crypto_async_request *base, int err)
+static void tipc_aead_decrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct tipc_crypto_rx_ctx *rx_ctx = TIPC_SKB_CB(skb)->crypto_ctx;
 	struct tipc_bearer *b = rx_ctx->bearer;
 	struct tipc_aead *aead = rx_ctx->aead;
