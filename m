Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6B85741ED
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiGNDd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiGNDdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07F325EA4
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 305DC61E37
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B93AC341C6;
        Thu, 14 Jul 2022 03:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657769600;
        bh=pR2KTl9ie+2LEzCqhnKT0ExATd+priDnzLx9lk0GQeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMZUCr5kGjuGU3+bBBLmGEglnA41whpD05Dn11dQ2Rxh+bfcJfuOZdiK5D/NpHVJA
         KsmLGrUMT4jELVii/y7X5t3CLehZ/HcA3Jr1jILRWf7hvRJjuI30QWvNOtiqnfLuDq
         rIZN0GCRF2Tt0e+/UMsy/qZ/YQonimx4FxsSds1frFcuBJ49YOP2eGkRSbszZ1dP3v
         JGKrpqAZpz7yVd6JJiHpHc4ZJaELPxCfcuTojT1Jq/tyZ6NQ5JRy4qi85uaGOXOFHr
         XTJpunmhdgy3PdLKTSHbFnn8yosp0ooVWgKupDTjVQznjG2qVq3qylk+9RODjdOcCf
         bKln70kNLrSjQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/11] tls: rx: read the input skb from ctx->recv_pkt
Date:   Wed, 13 Jul 2022 20:33:05 -0700
Message-Id: <20220714033310.1273288-7-kuba@kernel.org>
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

Callers always pass ctx->recv_pkt into decrypt_skb_update(),
and it propagates it to its callees. This may give someone
the false impression that those functions can accept any valid
skb containing a TLS record. That's not the case, the record
sequence number is read from the context, and they can only
take the next record coming out of the strp.

Let the functions get the skb from the context instead of
passing it in. This will also make it cleaner to return
a different skb than ctx->recv_pkt as the decrypted one
later on.

Since we're touching the definition of decrypt_skb_update()
use this as an opportunity to rename it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls.h        | 14 ++++++++------
 net/tls/tls_device.c | 25 ++++++++++++++++---------
 net/tls/tls_sw.c     | 37 ++++++++++++++++++-------------------
 3 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 8005ee25157d..9fa6827cde38 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -118,8 +118,7 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx);
 
 int tls_process_cmsg(struct sock *sk, struct msghdr *msg,
 		     unsigned char *record_type);
-int decrypt_skb(struct sock *sk, struct sk_buff *skb,
-		struct scatterlist *sgout);
+int decrypt_skb(struct sock *sk, struct scatterlist *sgout);
 
 int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_offload_context_tx *offload_ctx,
@@ -132,6 +131,11 @@ static inline struct tls_msg *tls_msg(struct sk_buff *skb)
 	return &scb->tls;
 }
 
+static inline struct sk_buff *tls_strp_msg(struct tls_sw_context_rx *ctx)
+{
+	return ctx->recv_pkt;
+}
+
 #ifdef CONFIG_TLS_DEVICE
 void tls_device_init(void);
 void tls_device_cleanup(void);
@@ -140,8 +144,7 @@ void tls_device_free_resources_tx(struct sock *sk);
 int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
 void tls_device_offload_cleanup_rx(struct sock *sk);
 void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq);
-int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
-			 struct sk_buff *skb, struct strp_msg *rxm);
+int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx);
 #else
 static inline void tls_device_init(void) {}
 static inline void tls_device_cleanup(void) {}
@@ -165,8 +168,7 @@ static inline void
 tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq) {}
 
 static inline int
-tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
-		     struct sk_buff *skb, struct strp_msg *rxm)
+tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
 {
 	return 0;
 }
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 227b92a3064a..d2ab86cdca64 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -889,14 +889,19 @@ static void tls_device_core_ctrl_rx_resync(struct tls_context *tls_ctx,
 	}
 }
 
-static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
+static int
+tls_device_reencrypt(struct sock *sk, struct tls_sw_context_rx *sw_ctx)
 {
-	struct strp_msg *rxm = strp_msg(skb);
-	int err = 0, offset = rxm->offset, copy, nsg, data_len, pos;
-	struct sk_buff *skb_iter, *unused;
+	int err = 0, offset, copy, nsg, data_len, pos;
+	struct sk_buff *skb, *skb_iter, *unused;
 	struct scatterlist sg[1];
+	struct strp_msg *rxm;
 	char *orig_buf, *buf;
 
+	skb = tls_strp_msg(sw_ctx);
+	rxm = strp_msg(skb);
+	offset = rxm->offset;
+
 	orig_buf = kmalloc(rxm->full_len + TLS_HEADER_SIZE +
 			   TLS_CIPHER_AES_GCM_128_IV_SIZE, sk->sk_allocation);
 	if (!orig_buf)
@@ -919,7 +924,7 @@ static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
 		goto free_buf;
 
 	/* We are interested only in the decrypted data not the auth */
-	err = decrypt_skb(sk, skb, sg);
+	err = decrypt_skb(sk, sg);
 	if (err != -EBADMSG)
 		goto free_buf;
 	else
@@ -974,10 +979,12 @@ static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
 	return err;
 }
 
-int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
-			 struct sk_buff *skb, struct strp_msg *rxm)
+int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
 {
 	struct tls_offload_context_rx *ctx = tls_offload_ctx_rx(tls_ctx);
+	struct tls_sw_context_rx *sw_ctx = tls_sw_ctx_rx(tls_ctx);
+	struct sk_buff *skb = tls_strp_msg(sw_ctx);
+	struct strp_msg *rxm = strp_msg(skb);
 	int is_decrypted = skb->decrypted;
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
@@ -1000,7 +1007,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 		 * likely have initial fragments decrypted, and final ones not
 		 * decrypted. We need to reencrypt that single SKB.
 		 */
-		return tls_device_reencrypt(sk, skb);
+		return tls_device_reencrypt(sk, sw_ctx);
 	}
 
 	/* Return immediately if the record is either entirely plaintext or
@@ -1017,7 +1024,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 	}
 
 	ctx->resync_nh_reset = 1;
-	return tls_device_reencrypt(sk, skb);
+	return tls_device_reencrypt(sk, sw_ctx);
 }
 
 static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 5ef78e75c463..6205ad1a84c7 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1421,8 +1421,7 @@ static int tls_setup_from_iter(struct iov_iter *from,
  * NULL, then the decryption happens inside skb buffers itself, i.e.
  * zero-copy gets disabled and 'darg->zc' is updated.
  */
-static int tls_decrypt_sg(struct sock *sk, struct sk_buff *skb,
-			  struct iov_iter *out_iov,
+static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 			  struct scatterlist *out_sg,
 			  struct tls_decrypt_arg *darg)
 {
@@ -1430,6 +1429,7 @@ static int tls_decrypt_sg(struct sock *sk, struct sk_buff *skb,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	int n_sgin, n_sgout, aead_size, err, pages = 0;
+	struct sk_buff *skb = tls_strp_msg(ctx);
 	struct strp_msg *rxm = strp_msg(skb);
 	struct tls_msg *tlm = tls_msg(skb);
 	struct aead_request *aead_req;
@@ -1567,14 +1567,14 @@ static int tls_decrypt_sg(struct sock *sk, struct sk_buff *skb,
 
 static int
 tls_decrypt_device(struct sock *sk, struct tls_context *tls_ctx,
-		   struct sk_buff *skb, struct tls_decrypt_arg *darg)
+		   struct tls_decrypt_arg *darg)
 {
 	int err;
 
 	if (tls_ctx->rx_conf != TLS_HW)
 		return 0;
 
-	err = tls_device_decrypted(sk, tls_ctx, skb, strp_msg(skb));
+	err = tls_device_decrypted(sk, tls_ctx);
 	if (err <= 0)
 		return err;
 
@@ -1583,22 +1583,22 @@ tls_decrypt_device(struct sock *sk, struct tls_context *tls_ctx,
 	return 1;
 }
 
-static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
-			      struct iov_iter *dest,
-			      struct tls_decrypt_arg *darg)
+static int tls_rx_one_record(struct sock *sk, struct iov_iter *dest,
+			     struct tls_decrypt_arg *darg)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
-	struct strp_msg *rxm = strp_msg(skb);
+	struct strp_msg *rxm;
 	int pad, err;
 
-	err = tls_decrypt_device(sk, tls_ctx, skb, darg);
+	err = tls_decrypt_device(sk, tls_ctx, darg);
 	if (err < 0)
 		return err;
 	if (err)
 		goto decrypt_done;
 
-	err = tls_decrypt_sg(sk, skb, dest, NULL, darg);
+	err = tls_decrypt_sg(sk, dest, NULL, darg);
 	if (err < 0) {
 		if (err == -EBADMSG)
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
@@ -1613,14 +1613,15 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		if (!darg->tail)
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXNOPADVIOL);
 		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTRETRY);
-		return decrypt_skb_update(sk, skb, dest, darg);
+		return tls_rx_one_record(sk, dest, darg);
 	}
 
 decrypt_done:
-	pad = tls_padding_length(prot, skb, darg);
+	pad = tls_padding_length(prot, ctx->recv_pkt, darg);
 	if (pad < 0)
 		return pad;
 
+	rxm = strp_msg(ctx->recv_pkt);
 	rxm->full_len -= pad;
 	rxm->offset += prot->prepend_size;
 	rxm->full_len -= prot->overhead_size;
@@ -1630,12 +1631,11 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	return 0;
 }
 
-int decrypt_skb(struct sock *sk, struct sk_buff *skb,
-		struct scatterlist *sgout)
+int decrypt_skb(struct sock *sk, struct scatterlist *sgout)
 {
 	struct tls_decrypt_arg darg = { .zc = true, };
 
-	return tls_decrypt_sg(sk, skb, NULL, sgout, &darg);
+	return tls_decrypt_sg(sk, NULL, sgout, &darg);
 }
 
 static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
@@ -1905,7 +1905,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			darg.async = false;
 
-		err = decrypt_skb_update(sk, skb, &msg->msg_iter, &darg);
+		err = tls_rx_one_record(sk, &msg->msg_iter, &darg);
 		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
@@ -2058,14 +2058,13 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		if (err <= 0)
 			goto splice_read_end;
 
-		skb = ctx->recv_pkt;
-
-		err = decrypt_skb_update(sk, skb, NULL, &darg);
+		err = tls_rx_one_record(sk, NULL, &darg);
 		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
 		}
 
+		skb = ctx->recv_pkt;
 		tls_rx_rec_done(ctx);
 	}
 
-- 
2.36.1

