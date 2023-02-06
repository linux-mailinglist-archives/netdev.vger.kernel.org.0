Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714C468BBBB
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjBFLeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBFLdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:33:44 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DD81449B;
        Mon,  6 Feb 2023 03:33:39 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOydj-007zhY-EX; Mon, 06 Feb 2023 18:22:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:23 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:23 +0800
Subject: [PATCH 6/17] net: ipv6: Add scaffolding to change completion function signature
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
Message-Id: <E1pOydj-007zhY-EX@formenos.hmeau.com>
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

 net/ipv6/ah6.c  |    8 ++++----
 net/ipv6/esp6.c |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 5228d2716289..e43735578a76 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -281,12 +281,12 @@ static int ipv6_clear_mutable_options(struct ipv6hdr *iph, int len, int dir)
 	return 0;
 }
 
-static void ah6_output_done(struct crypto_async_request *base, int err)
+static void ah6_output_done(crypto_completion_data_t *data, int err)
 {
 	int extlen;
 	u8 *iph_base;
 	u8 *icv;
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
 	struct ah_data *ahp = x->data;
 	struct ipv6hdr *top_iph = ipv6_hdr(skb);
@@ -451,12 +451,12 @@ static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)
 	return err;
 }
 
-static void ah6_input_done(struct crypto_async_request *base, int err)
+static void ah6_input_done(crypto_completion_data_t *data, int err)
 {
 	u8 *auth_data;
 	u8 *icv;
 	u8 *work_iph;
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct xfrm_state *x = xfrm_input_state(skb);
 	struct ah_data *ahp = x->data;
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 14ed868680c6..b9ee81c7dfcf 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -278,9 +278,9 @@ static void esp_output_encap_csum(struct sk_buff *skb)
 	}
 }
 
-static void esp_output_done(struct crypto_async_request *base, int err)
+static void esp_output_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	void *tmp;
 	struct xfrm_state *x;
@@ -368,12 +368,12 @@ static struct ip_esp_hdr *esp_output_set_esn(struct sk_buff *skb,
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
 
 static struct ip_esp_hdr *esp6_output_udp_encap(struct sk_buff *skb,
@@ -879,9 +879,9 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 }
 EXPORT_SYMBOL_GPL(esp6_input_done2);
 
-static void esp_input_done(struct crypto_async_request *base, int err)
+static void esp_input_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 
 	xfrm_input_resume(skb, esp6_input_done2(skb, err));
 }
@@ -909,12 +909,12 @@ static void esp_input_set_header(struct sk_buff *skb, __be32 *seqhi)
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
 
 static int esp6_input(struct xfrm_state *x, struct sk_buff *skb)
