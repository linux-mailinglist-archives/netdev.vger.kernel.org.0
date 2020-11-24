Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE73A2C2B36
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389699AbgKXPZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:25:16 -0500
Received: from novek.ru ([213.148.174.62]:47208 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389692AbgKXPZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:25:16 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 787DE5030C0;
        Tue, 24 Nov 2020 18:25:27 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 787DE5030C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606231530; bh=edei20iVuxZFuJ600w5BAUkLPX3Rrk0b8tH5lH1ocxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iK8VJ5j14rUth26MoECB+vz52i2E4J4mALmk3dpaHKsUDJ2x/6TQbczDaEMTgoSar
         rD5eGevPwUsG8CvDboJEpWb+THBvPqfuoywwbaG7KDlgLfYkgGaocisIx/N5f1gUMc
         dVVV1LYq6uAuJHSNbIwCEZxAFfgFnutcs4L0h8j8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [net-next v2 1/5] net/tls: make inline helpers protocol-aware
Date:   Tue, 24 Nov 2020 18:24:46 +0300
Message-Id: <1606231490-653-2-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
References: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inline functions defined in tls.h have a lot of AES-specific
constants. Remove these constants and change argument to struct
tls_prot_info to have an access to cipher type in later patches

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 include/net/tls.h             | 26 ++++++++++++--------------
 net/tls/tls_device.c          |  2 +-
 net/tls/tls_device_fallback.c | 13 +++++++------
 net/tls/tls_sw.c              | 12 +++++-------
 4 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index cf14730..d04ce73 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -502,31 +502,30 @@ static inline void tls_advance_record_sn(struct sock *sk,
 		tls_err_abort(sk, EBADMSG);
 
 	if (prot->version != TLS_1_3_VERSION)
-		tls_bigint_increment(ctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
+		tls_bigint_increment(ctx->iv + prot->salt_size,
 				     prot->iv_size);
 }
 
 static inline void tls_fill_prepend(struct tls_context *ctx,
 			     char *buf,
 			     size_t plaintext_len,
-			     unsigned char record_type,
-			     int version)
+			     unsigned char record_type)
 {
 	struct tls_prot_info *prot = &ctx->prot_info;
 	size_t pkt_len, iv_size = prot->iv_size;
 
 	pkt_len = plaintext_len + prot->tag_size;
-	if (version != TLS_1_3_VERSION) {
+	if (prot->version != TLS_1_3_VERSION) {
 		pkt_len += iv_size;
 
 		memcpy(buf + TLS_NONCE_OFFSET,
-		       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE, iv_size);
+		       ctx->tx.iv + prot->salt_size, iv_size);
 	}
 
 	/* we cover nonce explicit here as well, so buf should be of
 	 * size KTLS_DTLS_HEADER_SIZE + KTLS_DTLS_NONCE_EXPLICIT_SIZE
 	 */
-	buf[0] = version == TLS_1_3_VERSION ?
+	buf[0] = prot->version == TLS_1_3_VERSION ?
 		   TLS_RECORD_TYPE_DATA : record_type;
 	/* Note that VERSION must be TLS_1_2 for both TLS1.2 and TLS1.3 */
 	buf[1] = TLS_1_2_VERSION_MINOR;
@@ -539,18 +538,17 @@ static inline void tls_fill_prepend(struct tls_context *ctx,
 static inline void tls_make_aad(char *buf,
 				size_t size,
 				char *record_sequence,
-				int record_sequence_size,
 				unsigned char record_type,
-				int version)
+				struct tls_prot_info *prot)
 {
-	if (version != TLS_1_3_VERSION) {
-		memcpy(buf, record_sequence, record_sequence_size);
+	if (prot->version != TLS_1_3_VERSION) {
+		memcpy(buf, record_sequence, prot->rec_seq_size);
 		buf += 8;
 	} else {
-		size += TLS_CIPHER_AES_GCM_128_TAG_SIZE;
+		size += prot->tag_size;
 	}
 
-	buf[0] = version == TLS_1_3_VERSION ?
+	buf[0] = prot->version == TLS_1_3_VERSION ?
 		  TLS_RECORD_TYPE_DATA : record_type;
 	buf[1] = TLS_1_2_VERSION_MAJOR;
 	buf[2] = TLS_1_2_VERSION_MINOR;
@@ -558,11 +556,11 @@ static inline void tls_make_aad(char *buf,
 	buf[4] = size & 0xFF;
 }
 
-static inline void xor_iv_with_seq(int version, char *iv, char *seq)
+static inline void xor_iv_with_seq(struct tls_prot_info *prot, char *iv, char *seq)
 {
 	int i;
 
-	if (version == TLS_1_3_VERSION) {
+	if (prot->version == TLS_1_3_VERSION) {
 		for (i = 0; i < 8; i++)
 			iv[i + 4] ^= seq[i];
 	}
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 54d3e16..6f93ad5 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -327,7 +327,7 @@ static int tls_device_record_close(struct sock *sk,
 	/* fill prepend */
 	tls_fill_prepend(ctx, skb_frag_address(&record->frags[0]),
 			 record->len - prot->overhead_size,
-			 record_type, prot->version);
+			 record_type);
 	return ret;
 }
 
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 2889533..d946817 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -49,7 +49,8 @@ static int tls_enc_record(struct aead_request *aead_req,
 			  struct crypto_aead *aead, char *aad,
 			  char *iv, __be64 rcd_sn,
 			  struct scatter_walk *in,
-			  struct scatter_walk *out, int *in_len)
+			  struct scatter_walk *out, int *in_len,
+			  struct tls_prot_info *prot)
 {
 	unsigned char buf[TLS_HEADER_SIZE + TLS_CIPHER_AES_GCM_128_IV_SIZE];
 	struct scatterlist sg_in[3];
@@ -73,8 +74,7 @@ static int tls_enc_record(struct aead_request *aead_req,
 	len -= TLS_CIPHER_AES_GCM_128_IV_SIZE;
 
 	tls_make_aad(aad, len - TLS_CIPHER_AES_GCM_128_TAG_SIZE,
-		(char *)&rcd_sn, sizeof(rcd_sn), buf[0],
-		TLS_1_2_VERSION);
+		(char *)&rcd_sn, buf[0], prot);
 
 	memcpy(iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE, buf + TLS_HEADER_SIZE,
 	       TLS_CIPHER_AES_GCM_128_IV_SIZE);
@@ -140,7 +140,7 @@ static struct aead_request *tls_alloc_aead_request(struct crypto_aead *aead,
 static int tls_enc_records(struct aead_request *aead_req,
 			   struct crypto_aead *aead, struct scatterlist *sg_in,
 			   struct scatterlist *sg_out, char *aad, char *iv,
-			   u64 rcd_sn, int len)
+			   u64 rcd_sn, int len, struct tls_prot_info *prot)
 {
 	struct scatter_walk out, in;
 	int rc;
@@ -150,7 +150,7 @@ static int tls_enc_records(struct aead_request *aead_req,
 
 	do {
 		rc = tls_enc_record(aead_req, aead, aad, iv,
-				    cpu_to_be64(rcd_sn), &in, &out, &len);
+				    cpu_to_be64(rcd_sn), &in, &out, &len, prot);
 		rcd_sn++;
 
 	} while (rc == 0 && len);
@@ -348,7 +348,8 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
 		    payload_len, sync_size, dummy_buf);
 
 	if (tls_enc_records(aead_req, ctx->aead_send, sg_in, sg_out, aad, iv,
-			    rcd_sn, sync_size + payload_len) < 0)
+			    rcd_sn, sync_size + payload_len,
+			    &tls_ctx->prot_info) < 0)
 		goto free_nskb;
 
 	complete_skb(nskb, skb, tcp_payload_offset);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2fe9e2c..6bc757a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -505,7 +505,7 @@ static int tls_do_encryption(struct sock *sk,
 	memcpy(&rec->iv_data[iv_offset], tls_ctx->tx.iv,
 	       prot->iv_size + prot->salt_size);
 
-	xor_iv_with_seq(prot->version, rec->iv_data, tls_ctx->tx.rec_seq);
+	xor_iv_with_seq(prot, rec->iv_data, tls_ctx->tx.rec_seq);
 
 	sge->offset += prot->prepend_size;
 	sge->length -= prot->prepend_size;
@@ -748,14 +748,13 @@ static int tls_push_record(struct sock *sk, int flags,
 	sg_chain(rec->sg_aead_out, 2, &msg_en->sg.data[i]);
 
 	tls_make_aad(rec->aad_space, msg_pl->sg.size + prot->tail_size,
-		     tls_ctx->tx.rec_seq, prot->rec_seq_size,
-		     record_type, prot->version);
+		     tls_ctx->tx.rec_seq, record_type, prot);
 
 	tls_fill_prepend(tls_ctx,
 			 page_address(sg_page(&msg_en->sg.data[i])) +
 			 msg_en->sg.data[i].offset,
 			 msg_pl->sg.size + prot->tail_size,
-			 record_type, prot->version);
+			 record_type);
 
 	tls_ctx->pending_open_record_frags = false;
 
@@ -1471,13 +1470,12 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
-	xor_iv_with_seq(prot->version, iv, tls_ctx->rx.rec_seq);
+	xor_iv_with_seq(prot, iv, tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
 	tls_make_aad(aad, rxm->full_len - prot->overhead_size +
 		     prot->tail_size,
-		     tls_ctx->rx.rec_seq, prot->rec_seq_size,
-		     ctx->control, prot->version);
+		     tls_ctx->rx.rec_seq, ctx->control, prot);
 
 	/* Prepare sgin */
 	sg_init_table(sgin, n_sgin);
-- 
1.8.3.1

