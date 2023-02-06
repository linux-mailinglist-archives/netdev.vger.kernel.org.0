Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB95A68BBB3
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjBFLeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjBFLdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:33:44 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EED13536;
        Mon,  6 Feb 2023 03:33:41 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOydh-007zhJ-B3; Mon, 06 Feb 2023 18:22:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:21 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:21 +0800
Subject: [PATCH 5/17] net: ipv4: Add scaffolding to change completion function signature
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
Message-Id: <E1pOydh-007zhJ-B3@formenos.hmeau.com>
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

 net/ipv4/ah4.c  |    8 ++++----
 net/ipv4/esp4.c |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index ee4e578c7f20..1fc0231eb1ee 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -117,11 +117,11 @@ static int ip_clear_mutable_options(const struct iphdr *iph, __be32 *daddr)
 	return 0;
 }
 
-static void ah_output_done(struct crypto_async_request *base, int err)
+static void ah_output_done(crypto_completion_data_t *data, int err)
 {
 	u8 *icv;
 	struct iphdr *iph;
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
 	struct ah_data *ahp = x->data;
 	struct iphdr *top_iph = ip_hdr(skb);
@@ -262,12 +262,12 @@ static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
 	return err;
 }
 
-static void ah_input_done(struct crypto_async_request *base, int err)
+static void ah_input_done(crypto_completion_data_t *data, int err)
 {
 	u8 *auth_data;
 	u8 *icv;
 	struct iphdr *work_iph;
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct xfrm_state *x = xfrm_input_state(skb);
 	struct ah_data *ahp = x->data;
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 52c8047efedb..8abe07c1ff28 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -244,9 +244,9 @@ static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
 }
 #endif
 
-static void esp_output_done(struct crypto_async_request *base, int err)
+static void esp_output_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	void *tmp;
 	struct xfrm_state *x;
@@ -332,12 +332,12 @@ static struct ip_esp_hdr *esp_output_set_extra(struct sk_buff *skb,
 	return esph;
 }
 
-static void esp_output_done_esn(struct crypto_async_request *base, int err)
+static void esp_output_done_esn(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 
 	esp_output_restore_header(skb);
-	esp_output_done(base, err);
+	esp_output_done(data, err);
 }
 
 static struct ip_esp_hdr *esp_output_udp_encap(struct sk_buff *skb,
@@ -830,9 +830,9 @@ int esp_input_done2(struct sk_buff *skb, int err)
 }
 EXPORT_SYMBOL_GPL(esp_input_done2);
 
-static void esp_input_done(struct crypto_async_request *base, int err)
+static void esp_input_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 
 	xfrm_input_resume(skb, esp_input_done2(skb, err));
 }
@@ -860,12 +860,12 @@ static void esp_input_set_header(struct sk_buff *skb, __be32 *seqhi)
 	}
 }
 
-static void esp_input_done_esn(struct crypto_async_request *base, int err)
+static void esp_input_done_esn(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 
 	esp_input_restore_header(skb);
-	esp_input_done(base, err);
+	esp_input_done(data, err);
 }
 
 /*
