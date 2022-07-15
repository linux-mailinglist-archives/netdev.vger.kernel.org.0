Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D042C575AE2
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiGOFXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiGOFWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:22:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E81796B0
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C051B82A82
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F84DC341C6;
        Fri, 15 Jul 2022 05:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657862565;
        bh=+0eGBYHz3XmsMTZwfo82NB8MTZIXH/4ULyT9hwp4m4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtttImsDBvBDcwtr6/XtT/mgSqHtbxX52LQLFuMxyyWx5AdwLKZpnBW+FZkSiPYsI
         GT4qLKd5oaGH9Ulf1mEKg+HNjiQ+we/N1izHbaCrAGPBiLfcxan4/yJas5+iBW4xfk
         /vvYs+2dbee4PK5ZR0iJkqzVrz3Fnn9lfVvCRCtVa7M51hx26J9RXeNWfIRkYkt6OM
         6Tr1TXj+bDh6G/0dVC2f2jWYxnCE8IsSWsdmFdg1m5ZsN+IG/IVU45U4HI3yLgnhQA
         rZrGVHjUIgiTHw0Ofl2BRmafuXb7qBRCNL4uTjN+efPERJDnZ6uTZa7LrZxcmkJVVv
         1cDu6Dzm34T9A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 05/11] tls: rx: factor out device darg update
Date:   Thu, 14 Jul 2022 22:22:29 -0700
Message-Id: <20220715052235.1452170-6-kuba@kernel.org>
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

