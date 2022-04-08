Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF4E4F8EB0
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbiDHDko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiDHDkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FB992D38
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 35852CE29E4
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BBCC385AC;
        Fri,  8 Apr 2022 03:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389107;
        bh=AyoLy4e7ryu0N89Rs59jQrRQ083A48+mg8mpOoFFtMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGS0Ttr2a0TDqk/hiYg7U1vLkk5OO0GJSgBltRcteFTq5UwRq3L6+lLUbSdGg/hIG
         enwuq3VnNn4p9gRpXqjztROgqH/eXIDQ7yj9HPlsFkiSOnn8ZFQJRFxPQFiGcvY5FU
         iKLlMa12XvpGgVN7BeUbBiUzJpwy47rU9OEekumrj2PHctZiMm2uWzhGSKZzBq1Xx7
         bwv8EJPfIDcsDzEU8huxtWipHZGTBIelrO7migTKsFtqYNPBomlMo5Yb29JyWbUK85
         CJpglID369GB+YnHhOb4/qC8pj/2tL8i5YIlg8m6LDJFO4/v3KVH2eH3Zyo5EntJgf
         ESYjiDvkjNprg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/10] tls: rx: don't store the record type in socket context
Date:   Thu,  7 Apr 2022 20:38:16 -0700
Message-Id: <20220408033823.965896-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408033823.965896-1-kuba@kernel.org>
References: <20220408033823.965896-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Original TLS implementation was handling one record at a time.
It stashed the type of the record inside tls context (per socket
structure) for convenience. When async crypto support was added
[1] the author had to use skb->cb to store the type per-message.

The use of skb->cb overlaps with strparser, however, so a hybrid
approach was taken where type is stored in context while parsing
(since we parse a message at a time) but once parsed its copied
to skb->cb.

Recently a workaround for sockmaps [2] exposed the previously
private struct _strp_msg and started a trend of adding user
fields directly in strparser's header. This is cleaner than
storing information about an skb in the context.

This change is not strictly necessary, but IMHO the ownership
of the context field is confusing. Information naturally
belongs to the skb.

[1] commit 94524d8fc965 ("net/tls: Add support for async decryption of tls records")
[2] commit b2c4618162ec ("bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg")

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/strparser.h |  3 +++
 include/net/tls.h       | 10 +++-------
 net/tls/tls_sw.c        | 38 +++++++++++++++++---------------------
 3 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index 732b7097d78e..c271543076cf 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -70,6 +70,9 @@ struct sk_skb_cb {
 	 * when dst_reg == src_reg.
 	 */
 	u64 temp_reg;
+	struct tls_msg {
+		u8 control;
+	} tls;
 };
 
 static inline struct strp_msg *strp_msg(struct sk_buff *skb)
diff --git a/include/net/tls.h b/include/net/tls.h
index b6968a5b5538..c3717cd1f1cd 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -117,11 +117,6 @@ struct tls_rec {
 	u8 aead_req_ctx[];
 };
 
-struct tls_msg {
-	struct strp_msg rxm;
-	u8 control;
-};
-
 struct tx_work {
 	struct delayed_work work;
 	struct sock *sk;
@@ -152,7 +147,6 @@ struct tls_sw_context_rx {
 	void (*saved_data_ready)(struct sock *sk);
 
 	struct sk_buff *recv_pkt;
-	u8 control;
 	u8 async_capable:1;
 	u8 decrypted:1;
 	atomic_t decrypt_pending;
@@ -411,7 +405,9 @@ void tls_free_partial_record(struct sock *sk, struct tls_context *ctx);
 
 static inline struct tls_msg *tls_msg(struct sk_buff *skb)
 {
-	return (struct tls_msg *)strp_msg(skb);
+	struct sk_skb_cb *scb = (struct sk_skb_cb *)skb->cb;
+
+	return &scb->tls;
 }
 
 static inline bool tls_is_partially_sent_record(struct tls_context *ctx)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 555269ad7db2..222f8cad1e8c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -128,10 +128,10 @@ static int skb_nsg(struct sk_buff *skb, int offset, int len)
         return __skb_nsg(skb, offset, len, 0);
 }
 
-static int padding_length(struct tls_sw_context_rx *ctx,
-			  struct tls_prot_info *prot, struct sk_buff *skb)
+static int padding_length(struct tls_prot_info *prot, struct sk_buff *skb)
 {
 	struct strp_msg *rxm = strp_msg(skb);
+	struct tls_msg *tlm = tls_msg(skb);
 	int sub = 0;
 
 	/* Determine zero-padding length */
@@ -153,7 +153,7 @@ static int padding_length(struct tls_sw_context_rx *ctx,
 			sub++;
 			back++;
 		}
-		ctx->control = content_type;
+		tlm->control = content_type;
 	}
 	return sub;
 }
@@ -187,7 +187,7 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 		struct strp_msg *rxm = strp_msg(skb);
 		int pad;
 
-		pad = padding_length(ctx, prot, skb);
+		pad = padding_length(prot, skb);
 		if (pad < 0) {
 			ctx->async_wait.err = pad;
 			tls_err_abort(skb->sk, pad);
@@ -1421,6 +1421,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm = strp_msg(skb);
+	struct tls_msg *tlm = tls_msg(skb);
 	int n_sgin, n_sgout, nsg, mem_size, aead_size, err, pages = 0;
 	struct aead_request *aead_req;
 	struct sk_buff *unused;
@@ -1505,7 +1506,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	/* Prepare AAD */
 	tls_make_aad(aad, rxm->full_len - prot->overhead_size +
 		     prot->tail_size,
-		     tls_ctx->rx.rec_seq, ctx->control, prot);
+		     tls_ctx->rx.rec_seq, tlm->control, prot);
 
 	/* Prepare sgin */
 	sg_init_table(sgin, n_sgin);
@@ -1590,7 +1591,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 			*zc = false;
 		}
 
-		pad = padding_length(ctx, prot, skb);
+		pad = padding_length(prot, skb);
 		if (pad < 0)
 			return pad;
 
@@ -1822,26 +1823,21 @@ int tls_sw_recvmsg(struct sock *sk,
 				}
 			}
 			goto recv_end;
-		} else {
-			tlm = tls_msg(skb);
-			if (prot->version == TLS_1_3_VERSION)
-				tlm->control = 0;
-			else
-				tlm->control = ctx->control;
 		}
 
 		rxm = strp_msg(skb);
+		tlm = tls_msg(skb);
 
 		to_decrypt = rxm->full_len - prot->overhead_size;
 
 		if (to_decrypt <= len && !is_kvec && !is_peek &&
-		    ctx->control == TLS_RECORD_TYPE_DATA &&
+		    tlm->control == TLS_RECORD_TYPE_DATA &&
 		    prot->version != TLS_1_3_VERSION &&
 		    !bpf_strp_enabled)
 			zc = true;
 
 		/* Do not use async mode if record is non-data */
-		if (ctx->control == TLS_RECORD_TYPE_DATA && !bpf_strp_enabled)
+		if (tlm->control == TLS_RECORD_TYPE_DATA && !bpf_strp_enabled)
 			async_capable = ctx->async_capable;
 		else
 			async_capable = false;
@@ -1856,8 +1852,6 @@ int tls_sw_recvmsg(struct sock *sk,
 		if (err == -EINPROGRESS) {
 			async = true;
 			num_async++;
-		} else if (prot->version == TLS_1_3_VERSION) {
-			tlm->control = ctx->control;
 		}
 
 		/* If the type of records being processed is not known yet,
@@ -2005,6 +1999,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct strp_msg *rxm = NULL;
 	struct sock *sk = sock->sk;
+	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
 	bool from_queue;
@@ -2033,14 +2028,15 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		}
 	}
 
+	rxm = strp_msg(skb);
+	tlm = tls_msg(skb);
+
 	/* splice does not support reading control messages */
-	if (ctx->control != TLS_RECORD_TYPE_DATA) {
+	if (tlm->control != TLS_RECORD_TYPE_DATA) {
 		err = -EINVAL;
 		goto splice_read_end;
 	}
 
-	rxm = strp_msg(skb);
-
 	chunk = min_t(unsigned int, rxm->full_len, len);
 	copied = skb_splice_bits(skb, sk, rxm->offset, pipe, chunk, flags);
 	if (copied < 0)
@@ -2084,10 +2080,10 @@ bool tls_sw_sock_is_readable(struct sock *sk)
 static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
-	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	char header[TLS_HEADER_SIZE + MAX_IV_SIZE];
 	struct strp_msg *rxm = strp_msg(skb);
+	struct tls_msg *tlm = tls_msg(skb);
 	size_t cipher_overhead;
 	size_t data_len = 0;
 	int ret;
@@ -2108,7 +2104,7 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 	if (ret < 0)
 		goto read_failure;
 
-	ctx->control = header[0];
+	tlm->control = header[0];
 
 	data_len = ((header[4] & 0xFF) | (header[3] << 8));
 
-- 
2.34.1

