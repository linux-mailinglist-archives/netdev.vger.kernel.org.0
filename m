Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107775741E8
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiGNDda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiGNDdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:33:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A5E25EA7
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14E3761E28
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249CBC341CD;
        Thu, 14 Jul 2022 03:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657769600;
        bh=Q7qhf6HLe6IvzvFmtRuSS/427z0Ba5AY9s2LHiX7bKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsFb9zbUUqVWsBWagXlFat6LMGz5xzoZcD73vEEiPggdVPHbYP5WkeXLgIxK/LFFZ
         JEpnRs1R5/pEVKMpRJZ5GsycuYTS6rWIlW1VN9vkqDCwJkllWZKxnCepEQwW40M7YT
         OHMNuVIuVZ9JQ2AavWTQll+hr2IXgPRN2GqpcEg54ijPQbIadVnNIy/Lcd8WoMH4rE
         fqS1ZbGpt180gixVL9NWx0+SxaY7XIvv1ep/ATO9dVLx7IlHhgqpfdVo0rqIy3VVv7
         C4keo9Ud6Ir/OtTmjFYMLk0OM2+5ROV3zfnY7aQERwkx95/rJDjlwdKSNqyGSB6VxQ
         hRbkvpioPPPoA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/11] tls: rx: return the decrypted skb via darg
Date:   Wed, 13 Jul 2022 20:33:06 -0700
Message-Id: <20220714033310.1273288-8-kuba@kernel.org>
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

Instead of using ctx->recv_pkt after decryption read the skb
from darg.skb. This moves the decision of what the "output skb"
is to the decrypt handlers. For now after decrypt handler returns
successfully ctx->recv_pkt is simply moved to darg.skb, but it
will change soon.

Note that tls_decrypt_sg() cannot clear the ctx->recv_pkt
because it gets called to re-encrypt (i.e. by the device offload).
So we need an awkward temporary if() in tls_rx_one_record().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 49 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 6205ad1a84c7..6a9875456f84 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -47,9 +47,13 @@
 #include "tls.h"
 
 struct tls_decrypt_arg {
+	struct_group(inargs,
 	bool zc;
 	bool async;
 	u8 tail;
+	);
+
+	struct sk_buff *skb;
 };
 
 struct tls_decrypt_ctx {
@@ -1412,6 +1416,7 @@ static int tls_setup_from_iter(struct iov_iter *from,
  * -------------------------------------------------------------------
  *    zc | Zero-copy decrypt allowed | Zero-copy performed
  * async | Async decrypt allowed     | Async crypto used / in progress
+ *   skb |            *              | Output skb
  */
 
 /* This function decrypts the input skb into either out_iov or in out_sg
@@ -1551,12 +1556,17 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, skb, sgin, sgout, dctx->iv,
 				data_len + prot->tail_size, aead_req, darg);
+	if (err)
+		goto exit_free_pages;
+
+	darg->skb = tls_strp_msg(ctx);
 	if (darg->async)
 		return 0;
 
 	if (prot->tail_size)
 		darg->tail = dctx->tail;
 
+exit_free_pages:
 	/* Release the pages in case iov was mapped to pages */
 	for (; pages > 0; pages--)
 		put_page(sg_page(&sgout[pages]));
@@ -1569,6 +1579,7 @@ static int
 tls_decrypt_device(struct sock *sk, struct tls_context *tls_ctx,
 		   struct tls_decrypt_arg *darg)
 {
+	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	int err;
 
 	if (tls_ctx->rx_conf != TLS_HW)
@@ -1580,6 +1591,8 @@ tls_decrypt_device(struct sock *sk, struct tls_context *tls_ctx,
 
 	darg->zc = false;
 	darg->async = false;
+	darg->skb = tls_strp_msg(ctx);
+	ctx->recv_pkt = NULL;
 	return 1;
 }
 
@@ -1604,8 +1617,11 @@ static int tls_rx_one_record(struct sock *sk, struct iov_iter *dest,
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 		return err;
 	}
-	if (darg->async)
+	if (darg->async) {
+		if (darg->skb == ctx->recv_pkt)
+			ctx->recv_pkt = NULL;
 		goto decrypt_next;
+	}
 	/* If opportunistic TLS 1.3 ZC failed retry without ZC */
 	if (unlikely(darg->zc && prot->version == TLS_1_3_VERSION &&
 		     darg->tail != TLS_RECORD_TYPE_DATA)) {
@@ -1616,12 +1632,17 @@ static int tls_rx_one_record(struct sock *sk, struct iov_iter *dest,
 		return tls_rx_one_record(sk, dest, darg);
 	}
 
+	if (darg->skb == ctx->recv_pkt)
+		ctx->recv_pkt = NULL;
+
 decrypt_done:
-	pad = tls_padding_length(prot, ctx->recv_pkt, darg);
-	if (pad < 0)
+	pad = tls_padding_length(prot, darg->skb, darg);
+	if (pad < 0) {
+		consume_skb(darg->skb);
 		return pad;
+	}
 
-	rxm = strp_msg(ctx->recv_pkt);
+	rxm = strp_msg(darg->skb);
 	rxm->full_len -= pad;
 	rxm->offset += prot->prepend_size;
 	rxm->full_len -= prot->overhead_size;
@@ -1663,6 +1684,7 @@ static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
 
 static void tls_rx_rec_done(struct tls_sw_context_rx *ctx)
 {
+	consume_skb(ctx->recv_pkt);
 	ctx->recv_pkt = NULL;
 	__strp_unpause(&ctx->strp);
 }
@@ -1872,7 +1894,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		ctx->zc_capable;
 	decrypted = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
-		struct tls_decrypt_arg darg = {};
+		struct tls_decrypt_arg darg;
 		int to_decrypt, chunk;
 
 		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT, timeo);
@@ -1889,9 +1911,10 @@ int tls_sw_recvmsg(struct sock *sk,
 			goto recv_end;
 		}
 
-		skb = ctx->recv_pkt;
-		rxm = strp_msg(skb);
-		tlm = tls_msg(skb);
+		memset(&darg.inargs, 0, sizeof(darg.inargs));
+
+		rxm = strp_msg(ctx->recv_pkt);
+		tlm = tls_msg(ctx->recv_pkt);
 
 		to_decrypt = rxm->full_len - prot->overhead_size;
 
@@ -1911,6 +1934,10 @@ int tls_sw_recvmsg(struct sock *sk,
 			goto recv_end;
 		}
 
+		skb = darg.skb;
+		rxm = strp_msg(skb);
+		tlm = tls_msg(skb);
+
 		async |= darg.async;
 
 		/* If the type of records being processed is not known yet,
@@ -2051,21 +2078,23 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (!skb_queue_empty(&ctx->rx_list)) {
 		skb = __skb_dequeue(&ctx->rx_list);
 	} else {
-		struct tls_decrypt_arg darg = {};
+		struct tls_decrypt_arg darg;
 
 		err = tls_rx_rec_wait(sk, NULL, flags & SPLICE_F_NONBLOCK,
 				      timeo);
 		if (err <= 0)
 			goto splice_read_end;
 
+		memset(&darg.inargs, 0, sizeof(darg.inargs));
+
 		err = tls_rx_one_record(sk, NULL, &darg);
 		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
 		}
 
-		skb = ctx->recv_pkt;
 		tls_rx_rec_done(ctx);
+		skb = darg.skb;
 	}
 
 	rxm = strp_msg(skb);
-- 
2.36.1

