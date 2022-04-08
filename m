Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977FD4F9CC3
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbiDHSdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238736AbiDHSdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEA0ED93C
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8847662245
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C62C385AB;
        Fri,  8 Apr 2022 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442700;
        bh=PItljJ5O6J2JDa3jRJyD+KptA20PkU5y0EbtUr9wfWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZspNq28ggWlcd/SvX6RnS3c9NgCbC/71i4PUkbYTOR/RYEfDGp/D1sKUJxkg8iHr5
         x2Z133cJ+SKHWrXiahwlOKt9fXYgVoU9e8pFgogb3SckcLvNFLIWnUgHXV+YH7dfT3
         AJbCewsLQWMQSkkkzf2V8E8D+x9hJ6P6P2GdNQxOTzjsvcDV4kunKJFsJ5BsO/kigv
         sNBGxm0BJm+M2h4clAOrBxaU5V6pAV9eHQSHr2s4pjuKcp1KbchzSaHyBIlxldWIcj
         L7wQBM4k0YkFP8A0nmFg5JUxGES41ceZf5yTMeYuEMQVBuDoFiMQqDS67B90Ydhxc4
         c5Y+cOrJqQnkw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/11] tls: rx: wrap decryption arguments in a structure
Date:   Fri,  8 Apr 2022 11:31:26 -0700
Message-Id: <20220408183134.1054551-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408183134.1054551-1-kuba@kernel.org>
References: <20220408183134.1054551-1-kuba@kernel.org>
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

We pass zc as a pointer to bool a few functions down as an in/out
argument. This is error prone since C will happily evalue a pointer
as a boolean (IOW forgetting *zc and writing zc leads to loss of
developer time..). Wrap the arguments into a structure.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 49 ++++++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c321c5f85fbe..ecf9a3832798 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -44,6 +44,11 @@
 #include <net/strparser.h>
 #include <net/tls.h>
 
+struct tls_decrypt_arg {
+	bool zc;
+	bool async;
+};
+
 noinline void tls_err_abort(struct sock *sk, int err)
 {
 	WARN_ON_ONCE(err >= 0);
@@ -1412,7 +1417,7 @@ static int tls_setup_from_iter(struct iov_iter *from,
 static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			    struct iov_iter *out_iov,
 			    struct scatterlist *out_sg,
-			    bool *zc, bool async)
+			    struct tls_decrypt_arg *darg)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1429,7 +1434,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			     prot->tail_size;
 	int iv_offset = 0;
 
-	if (*zc && (out_iov || out_sg)) {
+	if (darg->zc && (out_iov || out_sg)) {
 		if (out_iov)
 			n_sgout = 1 +
 				iov_iter_npages_cap(out_iov, INT_MAX, data_len);
@@ -1439,7 +1444,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 				 rxm->full_len - prot->prepend_size);
 	} else {
 		n_sgout = 0;
-		*zc = false;
+		darg->zc = false;
 		n_sgin = skb_cow_data(skb, 0, &unused);
 	}
 
@@ -1535,12 +1540,12 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 fallback_to_reg_recv:
 		sgout = sgin;
 		pages = 0;
-		*zc = false;
+		darg->zc = false;
 	}
 
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, skb, sgin, sgout, iv,
-				data_len, aead_req, async);
+				data_len, aead_req, darg->async);
 	if (err == -EINPROGRESS)
 		return err;
 
@@ -1553,7 +1558,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 }
 
 static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
-			      struct iov_iter *dest, bool *zc, bool async)
+			      struct iov_iter *dest,
+			      struct tls_decrypt_arg *darg)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -1562,7 +1568,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	int pad, err;
 
 	if (tlm->decrypted) {
-		*zc = false;
+		darg->zc = false;
 		return 0;
 	}
 
@@ -1572,12 +1578,12 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 			return err;
 		if (err > 0) {
 			tlm->decrypted = 1;
-			*zc = false;
+			darg->zc = false;
 			goto decrypt_done;
 		}
 	}
 
-	err = decrypt_internal(sk, skb, dest, NULL, zc, async);
+	err = decrypt_internal(sk, skb, dest, NULL, darg);
 	if (err < 0) {
 		if (err == -EINPROGRESS)
 			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
@@ -1603,9 +1609,9 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 int decrypt_skb(struct sock *sk, struct sk_buff *skb,
 		struct scatterlist *sgout)
 {
-	bool zc = true;
+	struct tls_decrypt_arg darg = { .zc = true, };
 
-	return decrypt_internal(sk, skb, NULL, sgout, &zc, false);
+	return decrypt_internal(sk, skb, NULL, sgout, &darg);
 }
 
 static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
@@ -1794,11 +1800,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	decrypted = 0;
 	num_async = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
+		struct tls_decrypt_arg darg = {};
 		bool retain_skb = false;
 		int to_decrypt, chunk;
-		bool zc = false;
-		bool async_capable;
-		bool async = false;
+		bool async;
 
 		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
 		if (!skb) {
@@ -1824,16 +1829,15 @@ int tls_sw_recvmsg(struct sock *sk,
 		    tlm->control == TLS_RECORD_TYPE_DATA &&
 		    prot->version != TLS_1_3_VERSION &&
 		    !bpf_strp_enabled)
-			zc = true;
+			darg.zc = true;
 
 		/* Do not use async mode if record is non-data */
 		if (tlm->control == TLS_RECORD_TYPE_DATA && !bpf_strp_enabled)
-			async_capable = ctx->async_capable;
+			darg.async = ctx->async_capable;
 		else
-			async_capable = false;
+			darg.async = false;
 
-		err = decrypt_skb_update(sk, skb, &msg->msg_iter,
-					 &zc, async_capable);
+		err = decrypt_skb_update(sk, skb, &msg->msg_iter, &darg);
 		if (err < 0 && err != -EINPROGRESS) {
 			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
@@ -1879,7 +1883,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		/* TLS 1.3 may have updated the length by more than overhead */
 		chunk = rxm->full_len;
 
-		if (!zc) {
+		if (!darg.zc) {
 			if (bpf_strp_enabled) {
 				err = sk_psock_tls_strp_read(psock, skb);
 				if (err != __SK_PASS) {
@@ -1996,7 +2000,6 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	int err = 0;
 	long timeo;
 	int chunk;
-	bool zc = false;
 
 	lock_sock(sk);
 
@@ -2006,12 +2009,14 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (from_queue) {
 		skb = __skb_dequeue(&ctx->rx_list);
 	} else {
+		struct tls_decrypt_arg darg = {};
+
 		skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo,
 				    &err);
 		if (!skb)
 			goto splice_read_end;
 
-		err = decrypt_skb_update(sk, skb, NULL, &zc, false);
+		err = decrypt_skb_update(sk, skb, NULL, &darg);
 		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
-- 
2.34.1

