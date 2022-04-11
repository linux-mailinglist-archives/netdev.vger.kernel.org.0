Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98524FC4F5
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348607AbiDKTVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239422AbiDKTVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079941032
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE0A7B817AA
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11361C385AD;
        Mon, 11 Apr 2022 19:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704765;
        bh=nGi86dvS5R6WbsSIZ+8qOgBax1ZWljLoh4qFmgYilDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahunTlUxdVEaDCJ8r979YNmvxgVwf3svseFmRWedGwc6rugh8ZS+tcs1B0iGn5U1w
         5w6cMlakEZn1lKJHCvREEbiWtMDB7yXg0sVuIko+rKiL3RRjwtWD6DyFdFqX4zf+4j
         Wmi6oP92jpI2Iu2SNy7FZKFiMNI08Wg54rwBWoxtlEuR1L9n4hzzNQf/zPqZr9yby/
         iUTN0Wts6w6jweuvpd2DUWYFSiwn7DbkMgLKmPiwUkB12k2rjMSlmyM4XMxrITQb/Y
         jUxTHTbklI1aGR50Sx2a1HBy41fezJaxwBNG1Adj6FyRL07DdGMrsBC9INqiEQl+AB
         rAEwsbweWn/7g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/10] tls: rx: use async as an in-out argument
Date:   Mon, 11 Apr 2022 12:19:15 -0700
Message-Id: <20220411191917.1240155-9-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220411191917.1240155-1-kuba@kernel.org>
References: <20220411191917.1240155-1-kuba@kernel.org>
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

Propagating EINPROGRESS thru multiple layers of functions is
error prone. Use darg->async as an in/out argument, like we
use darg->zc today. On input it tells the code if async is
allowed, on output if it took place.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index b5d1393aa8d4..6b906b0cb2fd 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -227,7 +227,7 @@ static int tls_do_decryption(struct sock *sk,
 			     char *iv_recv,
 			     size_t data_len,
 			     struct aead_request *aead_req,
-			     bool async)
+			     struct tls_decrypt_arg *darg)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -240,7 +240,7 @@ static int tls_do_decryption(struct sock *sk,
 			       data_len + prot->tag_size,
 			       (u8 *)iv_recv);
 
-	if (async) {
+	if (darg->async) {
 		/* Using skb->sk to push sk through to crypto async callback
 		 * handler. This allows propagating errors up to the socket
 		 * if needed. It _must_ be cleared in the async handler
@@ -260,11 +260,13 @@ static int tls_do_decryption(struct sock *sk,
 
 	ret = crypto_aead_decrypt(aead_req);
 	if (ret == -EINPROGRESS) {
-		if (async)
-			return ret;
+		if (darg->async)
+			return 0;
 
 		ret = crypto_wait_req(ret, &ctx->async_wait);
 	}
+	darg->async = false;
+
 	if (ret == -EBADMSG)
 		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 
@@ -1536,9 +1538,9 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, skb, sgin, sgout, iv,
-				data_len, aead_req, darg->async);
-	if (err == -EINPROGRESS)
-		return err;
+				data_len, aead_req, darg);
+	if (darg->async)
+		return 0;
 
 	/* Release the pages in case iov was mapped to pages */
 	for (; pages > 0; pages--)
@@ -1575,11 +1577,10 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	}
 
 	err = decrypt_internal(sk, skb, dest, NULL, darg);
-	if (err < 0) {
-		if (err == -EINPROGRESS)
-			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
+	if (err < 0)
 		return err;
-	}
+	if (darg->async)
+		goto decrypt_next;
 
 decrypt_done:
 	pad = padding_length(prot, skb);
@@ -1589,8 +1590,9 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	rxm->full_len -= pad;
 	rxm->offset += prot->prepend_size;
 	rxm->full_len -= prot->overhead_size;
-	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 	tlm->decrypted = 1;
+decrypt_next:
+	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 
 	return 0;
 }
@@ -1799,13 +1801,12 @@ int tls_sw_recvmsg(struct sock *sk,
 			darg.async = false;
 
 		err = decrypt_skb_update(sk, skb, &msg->msg_iter, &darg);
-		if (err < 0 && err != -EINPROGRESS) {
+		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
 		}
 
-		if (err == -EINPROGRESS)
-			async = true;
+		async |= darg.async;
 
 		/* If the type of records being processed is not known yet,
 		 * set it to record type just dequeued. If it is already known,
-- 
2.34.1

