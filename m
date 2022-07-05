Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79739567AFE
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 01:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiGEX7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 19:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiGEX7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 19:59:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97917183AD;
        Tue,  5 Jul 2022 16:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 342486118E;
        Tue,  5 Jul 2022 23:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FA9C341CF;
        Tue,  5 Jul 2022 23:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657065575;
        bh=cTuHNLc5fK3KcNl9rOmWLQDD1dWqsZGLCN6FTHcI7vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYCStQXdGNQ1qdnwIBcIcUNMZXxV1kR34NMWKcvGKpMHfTGF2D4sH9beaNhrGldGB
         wohR6RqGGttv1Pcyscyucbv3UuGDme0e+4HbitO/4gjrGbFTfaeqOGp2Xj0eBDh+La
         87XLw611UtJuqHEkMHyl9on6TgOoDSr67WW6ttobnENz6Q1DPbT6O+KPvmJRdweKCV
         3mSZvXo0rLsC2LfHMObniK8F/jYNvBevaFVqE/bVljDillW+l5KyQJc6bpyXluqJXh
         q8absIhDexqspDhGt+Uu94+01gBFoOb9lJe+e1Yq3GM+l4gOjYI2AE8+WWJIQP4g5k
         /s8UW4Kb/aXBg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        john.fastabend@gmail.com, borisp@nvidia.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        maximmi@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/5] tls: rx: support optimistic decrypt to user buffer with TLS 1.3
Date:   Tue,  5 Jul 2022 16:59:23 -0700
Message-Id: <20220705235926.1035407-3-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705235926.1035407-1-kuba@kernel.org>
References: <20220705235926.1035407-1-kuba@kernel.org>
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

We currently don't support decrypt to user buffer with TLS 1.3
because we don't know the record type and how much padding
record contains before decryption. In practice data records
are by far most common and padding gets used rarely so
we can assume data record, no padding, and if we find out
that wasn't the case - retry the crypto in place (decrypt
to skb).

To safeguard from user overwriting content type and padding
before we can check it attach a 1B sg entry where last byte
of the record will land.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 7fcb54e43a08..2bac57684429 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -47,6 +47,7 @@
 struct tls_decrypt_arg {
 	bool zc;
 	bool async;
+	u8 tail;
 };
 
 noinline void tls_err_abort(struct sock *sk, int err)
@@ -133,7 +134,8 @@ static int skb_nsg(struct sk_buff *skb, int offset, int len)
         return __skb_nsg(skb, offset, len, 0);
 }
 
-static int padding_length(struct tls_prot_info *prot, struct sk_buff *skb)
+static int tls_padding_length(struct tls_prot_info *prot, struct sk_buff *skb,
+			      struct tls_decrypt_arg *darg)
 {
 	struct strp_msg *rxm = strp_msg(skb);
 	struct tls_msg *tlm = tls_msg(skb);
@@ -142,7 +144,7 @@ static int padding_length(struct tls_prot_info *prot, struct sk_buff *skb)
 	/* Determine zero-padding length */
 	if (prot->version == TLS_1_3_VERSION) {
 		int offset = rxm->full_len - TLS_TAG_SIZE - 1;
-		char content_type = 0;
+		char content_type = darg->zc ? darg->tail : 0;
 		int err;
 
 		while (content_type == 0) {
@@ -1418,17 +1420,18 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	struct strp_msg *rxm = strp_msg(skb);
 	struct tls_msg *tlm = tls_msg(skb);
 	int n_sgin, n_sgout, nsg, mem_size, aead_size, err, pages = 0;
+	u8 *aad, *iv, *tail, *mem = NULL;
 	struct aead_request *aead_req;
 	struct sk_buff *unused;
-	u8 *aad, *iv, *mem = NULL;
 	struct scatterlist *sgin = NULL;
 	struct scatterlist *sgout = NULL;
 	const int data_len = rxm->full_len - prot->overhead_size;
+	int tail_pages = !!prot->tail_size;
 	int iv_offset = 0;
 
 	if (darg->zc && (out_iov || out_sg)) {
 		if (out_iov)
-			n_sgout = 1 +
+			n_sgout = 1 + tail_pages +
 				iov_iter_npages_cap(out_iov, INT_MAX, data_len);
 		else
 			n_sgout = sg_nents(out_sg);
@@ -1452,9 +1455,10 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	mem_size = aead_size + (nsg * sizeof(struct scatterlist));
 	mem_size = mem_size + prot->aad_size;
 	mem_size = mem_size + MAX_IV_SIZE;
+	mem_size = mem_size + prot->tail_size;
 
 	/* Allocate a single block of memory which contains
-	 * aead_req || sgin[] || sgout[] || aad || iv.
+	 * aead_req || sgin[] || sgout[] || aad || iv || tail.
 	 * This order achieves correct alignment for aead_req, sgin, sgout.
 	 */
 	mem = kmalloc(mem_size, sk->sk_allocation);
@@ -1467,6 +1471,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	sgout = sgin + n_sgin;
 	aad = (u8 *)(sgout + n_sgout);
 	iv = aad + prot->aad_size;
+	tail = iv + MAX_IV_SIZE;
 
 	/* For CCM based ciphers, first byte of nonce+iv is a constant */
 	switch (prot->cipher_type) {
@@ -1518,12 +1523,18 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			sg_init_table(sgout, n_sgout);
 			sg_set_buf(&sgout[0], aad, prot->aad_size);
 
-			err = tls_setup_from_iter(out_iov,
-						  data_len + prot->tail_size,
+			err = tls_setup_from_iter(out_iov, data_len,
 						  &pages, &sgout[1],
-						  (n_sgout - 1));
+						  (n_sgout - 1 - tail_pages));
 			if (err < 0)
 				goto fallback_to_reg_recv;
+
+			if (prot->tail_size) {
+				sg_unmark_end(&sgout[pages]);
+				sg_set_buf(&sgout[pages + 1], tail,
+					   prot->tail_size);
+				sg_mark_end(&sgout[pages + 1]);
+			}
 		} else if (out_sg) {
 			memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
 		} else {
@@ -1542,6 +1553,9 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	if (darg->async)
 		return 0;
 
+	if (prot->tail_size)
+		darg->tail = *tail;
+
 	/* Release the pages in case iov was mapped to pages */
 	for (; pages > 0; pages--)
 		put_page(sg_page(&sgout[pages]));
@@ -1583,9 +1597,15 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		return err;
 	if (darg->async)
 		goto decrypt_next;
+	/* If opportunistic TLS 1.3 ZC failed retry without ZC */
+	if (unlikely(darg->zc && prot->version == TLS_1_3_VERSION &&
+		     darg->tail != TLS_RECORD_TYPE_DATA)) {
+		darg->zc = false;
+		return decrypt_skb_update(sk, skb, dest, darg);
+	}
 
 decrypt_done:
-	pad = padding_length(prot, skb);
+	pad = tls_padding_length(prot, skb, darg);
 	if (pad < 0)
 		return pad;
 
-- 
2.36.1

