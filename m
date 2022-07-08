Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD3256AF85
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbiGHBDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbiGHBDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:03:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCF860E9
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 18:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 043F4B824C2
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7669DC341CE;
        Fri,  8 Jul 2022 01:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242206;
        bh=8P6p5mOxWTzm6p+3Kb1wHVswI5QRJMiKj2fWaHxJ/HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHGzhDxVd4QhlFW4loqz3rgD51/NbrLWUClKW1sXcoriABy8YkjcHo4ycc/H9cFyl
         WdKDVxigIw5nWkxL4YI7k/KEaxmsPP/W4fPA96Vdh/FKqfAA4esU55qXAKKT1bFpEH
         ad251VAhkYMC5veE/22CrJLd2uptXe6KKVAcm/fY+mmRGJRvhr9r4XyoWKm0HvaoZE
         6QgGSQGXj0V3MIJOm84kPvdqolPh7e93Mw90Z1eCryKpWjjZgkRBJae6qxx/eWEUUy
         E0Gizu+9m+nL1FBkhlp9mCwYYhrhY9Uw3VKn/YN3wzxcKosOZgTa7+PnCgOUSlVsDe
         fVXfay43GP12g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/6] tls: rx: always allocate max possible aad size for decrypt
Date:   Thu,  7 Jul 2022 18:03:10 -0700
Message-Id: <20220708010314.1451462-3-kuba@kernel.org>
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

AAD size is either 5 or 13. Really no point complicating
the code for the 8B of difference. This will also let us
turn the chunked up buffer into a sane struct.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/tls.h |  1 +
 net/tls/tls_sw.c  | 19 ++++++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 4fc16ca5f469..9394c0459fe8 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -66,6 +66,7 @@
 #define MAX_IV_SIZE			16
 #define TLS_TAG_SIZE			16
 #define TLS_MAX_REC_SEQ_SIZE		8
+#define TLS_MAX_AAD_SIZE		TLS_AAD_SPACE_SIZE
 
 /* For CCM mode, the full 16-bytes of IV is made of '4' fields of given sizes.
  *
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 79043bc3da39..4f6761dd8d86 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1453,7 +1453,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 
 	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
 	mem_size = aead_size + (nsg * sizeof(struct scatterlist));
-	mem_size = mem_size + prot->aad_size;
+	mem_size = mem_size + TLS_MAX_AAD_SIZE;
 	mem_size = mem_size + MAX_IV_SIZE;
 	mem_size = mem_size + prot->tail_size;
 
@@ -1470,7 +1470,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	sgin = (struct scatterlist *)(mem + aead_size);
 	sgout = sgin + n_sgin;
 	aad = (u8 *)(sgout + n_sgout);
-	iv = aad + prot->aad_size;
+	iv = aad + TLS_MAX_AAD_SIZE;
 	tail = iv + MAX_IV_SIZE;
 
 	/* For CCM based ciphers, first byte of nonce+iv is a constant */
@@ -2474,13 +2474,6 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		goto free_priv;
 	}
 
-	/* Sanity-check the sizes for stack allocations. */
-	if (iv_size > MAX_IV_SIZE || nonce_size > MAX_IV_SIZE ||
-	    rec_seq_size > TLS_MAX_REC_SEQ_SIZE || tag_size != TLS_TAG_SIZE) {
-		rc = -EINVAL;
-		goto free_priv;
-	}
-
 	if (crypto_info->version == TLS_1_3_VERSION) {
 		nonce_size = 0;
 		prot->aad_size = TLS_HEADER_SIZE;
@@ -2490,6 +2483,14 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		prot->tail_size = 0;
 	}
 
+	/* Sanity-check the sizes for stack allocations. */
+	if (iv_size > MAX_IV_SIZE || nonce_size > MAX_IV_SIZE ||
+	    rec_seq_size > TLS_MAX_REC_SEQ_SIZE || tag_size != TLS_TAG_SIZE ||
+	    prot->aad_size > TLS_MAX_AAD_SIZE) {
+		rc = -EINVAL;
+		goto free_priv;
+	}
+
 	prot->version = crypto_info->version;
 	prot->cipher_type = crypto_info->cipher_type;
 	prot->prepend_size = TLS_HEADER_SIZE + nonce_size;
-- 
2.36.1

