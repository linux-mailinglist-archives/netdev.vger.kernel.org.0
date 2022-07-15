Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B59575AE3
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiGOFW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiGOFWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4CE796A2
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C87DF62270
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B39C3411E;
        Fri, 15 Jul 2022 05:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657862567;
        bh=/6+j9lctc9xCnm4U33xN+etCtEwtQtLD9X7ObhC+yoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LT8OiIsP8OE9btbLdiOGm+t145CoxgHo7YxPMs5PWgFaPZItdL5bxCzQcpd8Mb+dh
         J/lz6LuNqgIdImxi1cuvW8NqKy+t/wek6KMJ6Otixnv+A1FlyZ6UwCqKk87gFqWuy8
         JUgWlBDRSx4sNV1se9mkc9k8RMZV+opIEQI+YaUcFP8b1RSVuoY551Ub01sBYrcnvj
         KPAXNC6q/xj1vQBqdtGZbrmrt89BPFP4HSufF7vXdlVBZ3jv6mPi3v1/GsGvGCoQcL
         QXyqm8Ul3AEnlMECsOgOyOnH3GuQ6StVGvnS59jsnKRxkX6TP92LAm0YRThUDiWLwV
         K5gxVadSgbjXw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 08/11] tls: rx: async: adjust record geometry immediately
Date:   Thu, 14 Jul 2022 22:22:32 -0700
Message-Id: <20220715052235.1452170-9-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220715052235.1452170-1-kuba@kernel.org>
References: <20220715052235.1452170-1-kuba@kernel.org>
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

Async crypto TLS Rx currently waits for crypto to be done
in order to strip the TLS header and tailer. Simplify
the code by moving the pointers immediately, since only
TLS 1.2 is supported here there is no message padding.

This simplifies the decryption into a new skb in the next
patch as we don't have to worry about input vs output
skb in the decrypt_done() handler any more.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 49 ++++++++++--------------------------------------
 1 file changed, 10 insertions(+), 39 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 6a9875456f84..09fe2cfff51a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -184,39 +184,22 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 	struct scatterlist *sgin = aead_req->src;
 	struct tls_sw_context_rx *ctx;
 	struct tls_context *tls_ctx;
-	struct tls_prot_info *prot;
 	struct scatterlist *sg;
-	struct sk_buff *skb;
 	unsigned int pages;
+	struct sock *sk;
 
-	skb = (struct sk_buff *)req->data;
-	tls_ctx = tls_get_ctx(skb->sk);
+	sk = (struct sock *)req->data;
+	tls_ctx = tls_get_ctx(sk);
 	ctx = tls_sw_ctx_rx(tls_ctx);
-	prot = &tls_ctx->prot_info;
 
 	/* Propagate if there was an err */
 	if (err) {
 		if (err == -EBADMSG)
-			TLS_INC_STATS(sock_net(skb->sk),
-				      LINUX_MIB_TLSDECRYPTERROR);
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 		ctx->async_wait.err = err;
-		tls_err_abort(skb->sk, err);
-	} else {
-		struct strp_msg *rxm = strp_msg(skb);
-
-		/* No TLS 1.3 support with async crypto */
-		WARN_ON(prot->tail_size);
-
-		rxm->offset += prot->prepend_size;
-		rxm->full_len -= prot->overhead_size;
+		tls_err_abort(sk, err);
 	}
 
-	/* After using skb->sk to propagate sk through crypto async callback
-	 * we need to NULL it again.
-	 */
-	skb->sk = NULL;
-
-
 	/* Free the destination pages if skb was not decrypted inplace */
 	if (sgout != sgin) {
 		/* Skip the first S/G entry as it points to AAD */
@@ -236,7 +219,6 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 }
 
 static int tls_do_decryption(struct sock *sk,
-			     struct sk_buff *skb,
 			     struct scatterlist *sgin,
 			     struct scatterlist *sgout,
 			     char *iv_recv,
@@ -256,16 +238,9 @@ static int tls_do_decryption(struct sock *sk,
 			       (u8 *)iv_recv);
 
 	if (darg->async) {
-		/* Using skb->sk to push sk through to crypto async callback
-		 * handler. This allows propagating errors up to the socket
-		 * if needed. It _must_ be cleared in the async handler
-		 * before consume_skb is called. We _know_ skb->sk is NULL
-		 * because it is a clone from strparser.
-		 */
-		skb->sk = sk;
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  tls_decrypt_done, skb);
+					  tls_decrypt_done, sk);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
 		aead_request_set_callback(aead_req,
@@ -1554,7 +1529,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	}
 
 	/* Prepare and submit AEAD request */
-	err = tls_do_decryption(sk, skb, sgin, sgout, dctx->iv,
+	err = tls_do_decryption(sk, sgin, sgout, dctx->iv,
 				data_len + prot->tail_size, aead_req, darg);
 	if (err)
 		goto exit_free_pages;
@@ -1617,11 +1592,8 @@ static int tls_rx_one_record(struct sock *sk, struct iov_iter *dest,
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 		return err;
 	}
-	if (darg->async) {
-		if (darg->skb == ctx->recv_pkt)
-			ctx->recv_pkt = NULL;
-		goto decrypt_next;
-	}
+	if (darg->async)
+		goto decrypt_done;
 	/* If opportunistic TLS 1.3 ZC failed retry without ZC */
 	if (unlikely(darg->zc && prot->version == TLS_1_3_VERSION &&
 		     darg->tail != TLS_RECORD_TYPE_DATA)) {
@@ -1632,10 +1604,10 @@ static int tls_rx_one_record(struct sock *sk, struct iov_iter *dest,
 		return tls_rx_one_record(sk, dest, darg);
 	}
 
+decrypt_done:
 	if (darg->skb == ctx->recv_pkt)
 		ctx->recv_pkt = NULL;
 
-decrypt_done:
 	pad = tls_padding_length(prot, darg->skb, darg);
 	if (pad < 0) {
 		consume_skb(darg->skb);
@@ -1646,7 +1618,6 @@ static int tls_rx_one_record(struct sock *sk, struct iov_iter *dest,
 	rxm->full_len -= pad;
 	rxm->offset += prot->prepend_size;
 	rxm->full_len -= prot->overhead_size;
-decrypt_next:
 	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 
 	return 0;
-- 
2.36.1

