Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6894F9CC2
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbiDHSds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiDHSdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76746ED939
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BB366223E
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FCFC385A5;
        Fri,  8 Apr 2022 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442699;
        bh=WJ/rIGtQ+y1dO7Fb9uyBmcF5B36sG2/Rv7rl7DkYTRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPlJRoNZJI+/FEfL/NOfZu/ngC6X4j3szwo9yKBanvbZce015FFe2/wzKm9Fo75xr
         Yxgst7TeMyHXKM9imEtjLvqQ8whGN2sqkp/1eFI/obCCK4/6UUPES31OYbo8bFbGem
         wccibOdio5g9H3jD85A64reWp8cjJj2fxuKgTrJxfvQT14K9aKCOYt0LBFmj2+2Nx2
         594sLHT3ND2YRlelFINc4MSct9R8PwYNiGX5sxP+Y3kz2DLYCNKP+VqnmE3TcOrh8N
         sFr+tFyZT63VDQNjaeUKX9N9pCa7yElkMBz1RZb5G6AagjBoPYVV+ip08X08utVXA5
         nuvgpEdq4mkPA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/11] tls: rx: don't report text length from the bowels of decrypt
Date:   Fri,  8 Apr 2022 11:31:25 -0700
Message-Id: <20220408183134.1054551-3-kuba@kernel.org>
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

We plumb pointer to chunk all the way to the decryption method.
It's set to the length of the text when decrypt_skb_update()
returns.

I think the code is written this way because original TLS
implementation passed &chunk to zerocopy_from_iter() and this
was carried forward as the code gotten more complex, without
any refactoring.

The fix for peek() introduced a new variable - to_decrypt
which for all practical purposes is what chunk is going to
get set to. Spare ourselves the pointer passing, use to_decrypt.

Use this opportunity to clean things up a little further.

Note that chunk / to_decrypt was mostly needed for the async
path, since the sync path would access rxm->full_len (decryption
transforms full_len from record size to text size). Use the
right source of truth more explicitly.

We have three cases:
 - async - it's TLS 1.2 only, so chunk == to_decrypt, but we
           need the min() because to_decrypt is a whole record
	   and we don't want to underflow len. Note that we can't
	   handle partial record by falling back to sync as it
	   would introduce reordering against records in flight.
 - zc - again, TLS 1.2 only for now, so chunk == to_decrypt,
        we don't do zc if len < to_decrypt, no need to check again.
 - normal - it already handles chunk > len, we can factor out the
            assignment to rxm->full_len and share it with zc.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 86f77f8b825e..c321c5f85fbe 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1412,7 +1412,7 @@ static int tls_setup_from_iter(struct iov_iter *from,
 static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			    struct iov_iter *out_iov,
 			    struct scatterlist *out_sg,
-			    int *chunk, bool *zc, bool async)
+			    bool *zc, bool async)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1526,7 +1526,6 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 						  (n_sgout - 1));
 			if (err < 0)
 				goto fallback_to_reg_recv;
-			*chunk = data_len;
 		} else if (out_sg) {
 			memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
 		} else {
@@ -1536,7 +1535,6 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 fallback_to_reg_recv:
 		sgout = sgin;
 		pages = 0;
-		*chunk = data_len;
 		*zc = false;
 	}
 
@@ -1555,8 +1553,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 }
 
 static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
-			      struct iov_iter *dest, int *chunk, bool *zc,
-			      bool async)
+			      struct iov_iter *dest, bool *zc, bool async)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -1580,7 +1577,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 
-	err = decrypt_internal(sk, skb, dest, NULL, chunk, zc, async);
+	err = decrypt_internal(sk, skb, dest, NULL, zc, async);
 	if (err < 0) {
 		if (err == -EINPROGRESS)
 			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
@@ -1607,9 +1604,8 @@ int decrypt_skb(struct sock *sk, struct sk_buff *skb,
 		struct scatterlist *sgout)
 {
 	bool zc = true;
-	int chunk;
 
-	return decrypt_internal(sk, skb, NULL, sgout, &chunk, &zc, false);
+	return decrypt_internal(sk, skb, NULL, sgout, &zc, false);
 }
 
 static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
@@ -1799,9 +1795,8 @@ int tls_sw_recvmsg(struct sock *sk,
 	num_async = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		bool retain_skb = false;
+		int to_decrypt, chunk;
 		bool zc = false;
-		int to_decrypt;
-		int chunk = 0;
 		bool async_capable;
 		bool async = false;
 
@@ -1838,7 +1833,7 @@ int tls_sw_recvmsg(struct sock *sk,
 			async_capable = false;
 
 		err = decrypt_skb_update(sk, skb, &msg->msg_iter,
-					 &chunk, &zc, async_capable);
+					 &zc, async_capable);
 		if (err < 0 && err != -EINPROGRESS) {
 			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
@@ -1876,8 +1871,13 @@ int tls_sw_recvmsg(struct sock *sk,
 			}
 		}
 
-		if (async)
+		if (async) {
+			/* TLS 1.2-only, to_decrypt must be text length */
+			chunk = min_t(int, to_decrypt, len);
 			goto pick_next_record;
+		}
+		/* TLS 1.3 may have updated the length by more than overhead */
+		chunk = rxm->full_len;
 
 		if (!zc) {
 			if (bpf_strp_enabled) {
@@ -1893,11 +1893,9 @@ int tls_sw_recvmsg(struct sock *sk,
 				}
 			}
 
-			if (rxm->full_len > len) {
+			if (chunk > len) {
 				retain_skb = true;
 				chunk = len;
-			} else {
-				chunk = rxm->full_len;
 			}
 
 			err = skb_copy_datagram_msg(skb, rxm->offset,
@@ -1912,9 +1910,6 @@ int tls_sw_recvmsg(struct sock *sk,
 		}
 
 pick_next_record:
-		if (chunk > len)
-			chunk = len;
-
 		decrypted += chunk;
 		len -= chunk;
 
@@ -2016,7 +2011,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		if (!skb)
 			goto splice_read_end;
 
-		err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
+		err = decrypt_skb_update(sk, skb, NULL, &zc, false);
 		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
-- 
2.34.1

