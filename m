Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDCB5741E9
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiGNDd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiGNDdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F1525E90
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1322E61E2D
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2663DC341D0;
        Thu, 14 Jul 2022 03:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657769599;
        bh=+0eGBYHz3XmsMTZwfo82NB8MTZIXH/4ULyT9hwp4m4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/Y1vLLYG2lj4Alg33ToqZhaUQTuE6whC91U26TV9jHQ/Uxz9G+BuxKN3O9IljRPX
         weKcXimn+QlivEVUM4StgEEXfbJf7jGjHBLZTOlNmxlyboCaYI5qASURgUKi5HY+ip
         fwG8CKmL0m3suB9PCu/lSEOzxCwSQMuTOktRj7lfUIos+bJLu7BX2ceeOFNq1eGXiE
         xJ5pDafjoJ4hesZHAAQiAsdaUvkSwuvdpF4nYnS5rWg1k2Q1ve7Qo2zx+hyfQ0gtwQ
         65fml9ZtZs0l5blDWOO+4KxXErs4/NeWSq/bMQpOGHtno0uODLSB9DvCJBObPRczwg
         JGwHHk3c6srrA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/11] tls: rx: factor out device darg update
Date:   Wed, 13 Jul 2022 20:33:04 -0700
Message-Id: <20220714033310.1273288-6-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220714033310.1273288-1-kuba@kernel.org>
References: <20220714033310.1273288-1-kuba@kernel.org>
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

I already forgot to transform darg from input to output
semantics once on the NIC inline crypto fastpath. To
avoid this happening again create a device equivalent
of decrypt_internal(). A function responsible for decryption
and transforming darg.

While at it rename decrypt_internal() to a hopefully slightly
more meaningful name.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 60 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 19 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 49cfaa8119c6..5ef78e75c463 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1404,18 +1404,27 @@ static int tls_setup_from_iter(struct iov_iter *from,
 	return rc;
 }
 
+/* Decrypt handlers
+ *
+ * tls_decrypt_sg() and tls_decrypt_device() are decrypt handlers.
+ * They must transform the darg in/out argument are as follows:
+ *       |          Input            |         Output
+ * -------------------------------------------------------------------
+ *    zc | Zero-copy decrypt allowed | Zero-copy performed
+ * async | Async decrypt allowed     | Async crypto used / in progress
+ */
+
 /* This function decrypts the input skb into either out_iov or in out_sg
- * or in skb buffers itself. The input parameter 'zc' indicates if
+ * or in skb buffers itself. The input parameter 'darg->zc' indicates if
  * zero-copy mode needs to be tried or not. With zero-copy mode, either
  * out_iov or out_sg must be non-NULL. In case both out_iov and out_sg are
  * NULL, then the decryption happens inside skb buffers itself, i.e.
- * zero-copy gets disabled and 'zc' is updated.
+ * zero-copy gets disabled and 'darg->zc' is updated.
  */
-
-static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
-			    struct iov_iter *out_iov,
-			    struct scatterlist *out_sg,
-			    struct tls_decrypt_arg *darg)
+static int tls_decrypt_sg(struct sock *sk, struct sk_buff *skb,
+			  struct iov_iter *out_iov,
+			  struct scatterlist *out_sg,
+			  struct tls_decrypt_arg *darg)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1556,6 +1565,24 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	return err;
 }
 
+static int
+tls_decrypt_device(struct sock *sk, struct tls_context *tls_ctx,
+		   struct sk_buff *skb, struct tls_decrypt_arg *darg)
+{
+	int err;
+
+	if (tls_ctx->rx_conf != TLS_HW)
+		return 0;
+
+	err = tls_device_decrypted(sk, tls_ctx, skb, strp_msg(skb));
+	if (err <= 0)
+		return err;
+
+	darg->zc = false;
+	darg->async = false;
+	return 1;
+}
+
 static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 			      struct iov_iter *dest,
 			      struct tls_decrypt_arg *darg)
@@ -1565,18 +1592,13 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	struct strp_msg *rxm = strp_msg(skb);
 	int pad, err;
 
-	if (tls_ctx->rx_conf == TLS_HW) {
-		err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
-		if (err < 0)
-			return err;
-		if (err > 0) {
-			darg->zc = false;
-			darg->async = false;
-			goto decrypt_done;
-		}
-	}
+	err = tls_decrypt_device(sk, tls_ctx, skb, darg);
+	if (err < 0)
+		return err;
+	if (err)
+		goto decrypt_done;
 
-	err = decrypt_internal(sk, skb, dest, NULL, darg);
+	err = tls_decrypt_sg(sk, skb, dest, NULL, darg);
 	if (err < 0) {
 		if (err == -EBADMSG)
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
@@ -1613,7 +1635,7 @@ int decrypt_skb(struct sock *sk, struct sk_buff *skb,
 {
 	struct tls_decrypt_arg darg = { .zc = true, };
 
-	return decrypt_internal(sk, skb, NULL, sgout, &darg);
+	return tls_decrypt_sg(sk, skb, NULL, sgout, &darg);
 }
 
 static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
-- 
2.36.1

