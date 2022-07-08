Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D5456AFA2
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbiGHBDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236611AbiGHBD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:03:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3822DC6
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 18:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC5A0617A2
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82CEC341CF;
        Fri,  8 Jul 2022 01:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242207;
        bh=Zxtj02zPPRL4w3GSEdBaVvS3xwzF3Me9a7gqR4vGkoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLNNsBK1YHVmEKewTDBzUVGNrdamq5uxmjoBlEUZ2DU3dFFq6JgRpTpgJbJ6b3kT5
         4G+1PeSetzBkAfvF/0CriPgfLeOsUBcJX0GvpP+tbEVdvCCC59tXmjoFMkH27bewWC
         Um/QZuT3llFfSgAD9FHSyl9ReHIFEciwN2xFpxHRhfIsrTjyebeqtd9QHXirf3WKqc
         exVqMEz3TYIJM7tMwAxjzfiYAJAkakQVIv6M8AOwf8xOqiyE1GzKNYf8qTONbR+Soz
         rHjBlYEqSg4fTkGqON2cA0Wm637wfc8o/YGRPdjWWV1RnLGzC+uDOmbNMPI1wmnVWp
         fTprWg6kUgy5Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/6] tls: rx: wrap decrypt params in a struct
Date:   Thu,  7 Jul 2022 18:03:11 -0700
Message-Id: <20220708010314.1451462-4-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708010314.1451462-1-kuba@kernel.org>
References: <20220708010314.1451462-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The max size of iv + aad + tail is 22B. That's smaller
than a single sg entry (32B). Don't bother with the
memory packing, just create a struct which holds the
max size of those members.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 60 ++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 4f6761dd8d86..5534962963c2 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -50,6 +50,13 @@ struct tls_decrypt_arg {
 	u8 tail;
 };
 
+struct tls_decrypt_ctx {
+	u8 iv[MAX_IV_SIZE];
+	u8 aad[TLS_MAX_AAD_SIZE];
+	u8 tail;
+	struct scatterlist sg[];
+};
+
 noinline void tls_err_abort(struct sock *sk, int err)
 {
 	WARN_ON_ONCE(err >= 0);
@@ -1417,17 +1424,18 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
+	int n_sgin, n_sgout, aead_size, err, pages = 0;
 	struct strp_msg *rxm = strp_msg(skb);
 	struct tls_msg *tlm = tls_msg(skb);
-	int n_sgin, n_sgout, nsg, mem_size, aead_size, err, pages = 0;
-	u8 *aad, *iv, *tail, *mem = NULL;
 	struct aead_request *aead_req;
 	struct sk_buff *unused;
 	struct scatterlist *sgin = NULL;
 	struct scatterlist *sgout = NULL;
 	const int data_len = rxm->full_len - prot->overhead_size;
 	int tail_pages = !!prot->tail_size;
+	struct tls_decrypt_ctx *dctx;
 	int iv_offset = 0;
+	u8 *mem;
 
 	if (darg->zc && (out_iov || out_sg)) {
 		if (out_iov)
@@ -1449,38 +1457,30 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	/* Increment to accommodate AAD */
 	n_sgin = n_sgin + 1;
 
-	nsg = n_sgin + n_sgout;
-
-	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
-	mem_size = aead_size + (nsg * sizeof(struct scatterlist));
-	mem_size = mem_size + TLS_MAX_AAD_SIZE;
-	mem_size = mem_size + MAX_IV_SIZE;
-	mem_size = mem_size + prot->tail_size;
-
 	/* Allocate a single block of memory which contains
-	 * aead_req || sgin[] || sgout[] || aad || iv || tail.
-	 * This order achieves correct alignment for aead_req, sgin, sgout.
+	 *   aead_req || tls_decrypt_ctx.
+	 * Both structs are variable length.
 	 */
-	mem = kmalloc(mem_size, sk->sk_allocation);
+	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
+	mem = kmalloc(aead_size + struct_size(dctx, sg, n_sgin + n_sgout),
+		      sk->sk_allocation);
 	if (!mem)
 		return -ENOMEM;
 
 	/* Segment the allocated memory */
 	aead_req = (struct aead_request *)mem;
-	sgin = (struct scatterlist *)(mem + aead_size);
-	sgout = sgin + n_sgin;
-	aad = (u8 *)(sgout + n_sgout);
-	iv = aad + TLS_MAX_AAD_SIZE;
-	tail = iv + MAX_IV_SIZE;
+	dctx = (struct tls_decrypt_ctx *)(mem + aead_size);
+	sgin = &dctx->sg[0];
+	sgout = &dctx->sg[n_sgin];
 
 	/* For CCM based ciphers, first byte of nonce+iv is a constant */
 	switch (prot->cipher_type) {
 	case TLS_CIPHER_AES_CCM_128:
-		iv[0] = TLS_AES_CCM_IV_B0_BYTE;
+		dctx->iv[0] = TLS_AES_CCM_IV_B0_BYTE;
 		iv_offset = 1;
 		break;
 	case TLS_CIPHER_SM4_CCM:
-		iv[0] = TLS_SM4_CCM_IV_B0_BYTE;
+		dctx->iv[0] = TLS_SM4_CCM_IV_B0_BYTE;
 		iv_offset = 1;
 		break;
 	}
@@ -1488,28 +1488,28 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	/* Prepare IV */
 	if (prot->version == TLS_1_3_VERSION ||
 	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305) {
-		memcpy(iv + iv_offset, tls_ctx->rx.iv,
+		memcpy(&dctx->iv[iv_offset], tls_ctx->rx.iv,
 		       prot->iv_size + prot->salt_size);
 	} else {
 		err = skb_copy_bits(skb, rxm->offset + TLS_HEADER_SIZE,
-				    iv + iv_offset + prot->salt_size,
+				    &dctx->iv[iv_offset] + prot->salt_size,
 				    prot->iv_size);
 		if (err < 0) {
 			kfree(mem);
 			return err;
 		}
-		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
+		memcpy(&dctx->iv[iv_offset], tls_ctx->rx.iv, prot->salt_size);
 	}
-	xor_iv_with_seq(prot, iv + iv_offset, tls_ctx->rx.rec_seq);
+	xor_iv_with_seq(prot, &dctx->iv[iv_offset], tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
-	tls_make_aad(aad, rxm->full_len - prot->overhead_size +
+	tls_make_aad(dctx->aad, rxm->full_len - prot->overhead_size +
 		     prot->tail_size,
 		     tls_ctx->rx.rec_seq, tlm->control, prot);
 
 	/* Prepare sgin */
 	sg_init_table(sgin, n_sgin);
-	sg_set_buf(&sgin[0], aad, prot->aad_size);
+	sg_set_buf(&sgin[0], dctx->aad, prot->aad_size);
 	err = skb_to_sgvec(skb, &sgin[1],
 			   rxm->offset + prot->prepend_size,
 			   rxm->full_len - prot->prepend_size);
@@ -1521,7 +1521,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	if (n_sgout) {
 		if (out_iov) {
 			sg_init_table(sgout, n_sgout);
-			sg_set_buf(&sgout[0], aad, prot->aad_size);
+			sg_set_buf(&sgout[0], dctx->aad, prot->aad_size);
 
 			err = tls_setup_from_iter(out_iov, data_len,
 						  &pages, &sgout[1],
@@ -1531,7 +1531,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 
 			if (prot->tail_size) {
 				sg_unmark_end(&sgout[pages]);
-				sg_set_buf(&sgout[pages + 1], tail,
+				sg_set_buf(&sgout[pages + 1], &dctx->tail,
 					   prot->tail_size);
 				sg_mark_end(&sgout[pages + 1]);
 			}
@@ -1548,13 +1548,13 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	}
 
 	/* Prepare and submit AEAD request */
-	err = tls_do_decryption(sk, skb, sgin, sgout, iv,
+	err = tls_do_decryption(sk, skb, sgin, sgout, dctx->iv,
 				data_len + prot->tail_size, aead_req, darg);
 	if (darg->async)
 		return 0;
 
 	if (prot->tail_size)
-		darg->tail = *tail;
+		darg->tail = dctx->tail;
 
 	/* Release the pages in case iov was mapped to pages */
 	for (; pages > 0; pages--)
-- 
2.36.1

