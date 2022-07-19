Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E810957AA48
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbiGSXLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240580AbiGSXLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:11:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F08F61DB1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 16:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2B4AB81DAE
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 23:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA7CC341CA;
        Tue, 19 Jul 2022 23:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658272298;
        bh=8TmRMLFlHvRLZ7D2mVJsCX6LA47V2CJDBA3e4h6VgjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3r04ps+hdQ9M72Tnf2uJVfvRlQ0WvhlEbUwlwODd0xq0nEwMzvuQvH+Aj70tY0Em
         ngUnKZ63GXvt8w+NHlkhUnCCIP75H8q8SruGnxeb7PfIcq5YSip8MyvCkzY8nFHfI/
         Bo36A/2RclLHiWlX0qf9DnwdejOY/KIx6Equ4YuZA243kruJ/0E4VfzABt+mBu8vP7
         Qh+/q49HcA/09OyliGsvDqmOzMRklbiV0h1pqyP8hC1/HIBQH0mq1lS+hQdi64P8CB
         wgXBEHDZBAegd4tRWWIZeVvxnIJScTc7JYATduHvqsDSXdGCuexlA45P6h/WBEN/BM
         gJhxGnFy5HWbw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/7] tls: rx: factor SW handling out of tls_rx_one_record()
Date:   Tue, 19 Jul 2022 16:11:24 -0700
Message-Id: <20220719231129.1870776-3-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719231129.1870776-1-kuba@kernel.org>
References: <20220719231129.1870776-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After recent changes the SW side of tls_rx_one_record() can
be nicely encapsulated in its own function. Move the pad handling
as well. This will be useful for ->zc handling in tls_decrypt_device().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
---
 net/tls/tls_sw.c | 93 +++++++++++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 36 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 566717ef5a27..0d4fc685b508 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1409,7 +1409,7 @@ tls_alloc_clrtxt_skb(struct sock *sk, struct sk_buff *skb,
 
 /* Decrypt handlers
  *
- * tls_decrypt_sg() and tls_decrypt_device() are decrypt handlers.
+ * tls_decrypt_sw() and tls_decrypt_device() are decrypt handlers.
  * They must transform the darg in/out argument are as follows:
  *       |          Input            |         Output
  * -------------------------------------------------------------------
@@ -1589,49 +1589,22 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 }
 
 static int
-tls_decrypt_device(struct sock *sk, struct tls_context *tls_ctx,
-		   struct tls_decrypt_arg *darg)
-{
-	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
-	int err;
-
-	if (tls_ctx->rx_conf != TLS_HW)
-		return 0;
-
-	err = tls_device_decrypted(sk, tls_ctx);
-	if (err <= 0)
-		return err;
-
-	darg->zc = false;
-	darg->async = false;
-	darg->skb = tls_strp_msg(ctx);
-	ctx->recv_pkt = NULL;
-	return 1;
-}
-
-static int tls_rx_one_record(struct sock *sk, struct iov_iter *dest,
-			     struct tls_decrypt_arg *darg)
+tls_decrypt_sw(struct sock *sk, struct tls_context *tls_ctx,
+	       struct msghdr *msg, struct tls_decrypt_arg *darg)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm;
 	int pad, err;
 
-	err = tls_decrypt_device(sk, tls_ctx, darg);
-	if (err < 0)
-		return err;
-	if (err)
-		goto decrypt_done;
-
-	err = tls_decrypt_sg(sk, dest, NULL, darg);
+	err = tls_decrypt_sg(sk, &msg->msg_iter, NULL, darg);
 	if (err < 0) {
 		if (err == -EBADMSG)
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 		return err;
 	}
-	if (darg->async)
-		goto decrypt_done;
+	/* keep going even for ->async, the code below is TLS 1.3 */
+
 	/* If opportunistic TLS 1.3 ZC failed retry without ZC */
 	if (unlikely(darg->zc && prot->version == TLS_1_3_VERSION &&
 		     darg->tail != TLS_RECORD_TYPE_DATA)) {
@@ -1639,10 +1612,9 @@ static int tls_rx_one_record(struct sock *sk, struct iov_iter *dest,
 		if (!darg->tail)
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXNOPADVIOL);
 		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTRETRY);
-		return tls_rx_one_record(sk, dest, darg);
+		return tls_decrypt_sw(sk, tls_ctx, msg, darg);
 	}
 
-decrypt_done:
 	if (darg->skb == ctx->recv_pkt)
 		ctx->recv_pkt = NULL;
 
@@ -1654,6 +1626,55 @@ static int tls_rx_one_record(struct sock *sk, struct iov_iter *dest,
 
 	rxm = strp_msg(darg->skb);
 	rxm->full_len -= pad;
+
+	return 0;
+}
+
+static int
+tls_decrypt_device(struct sock *sk, struct tls_context *tls_ctx,
+		   struct tls_decrypt_arg *darg)
+{
+	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
+	struct tls_prot_info *prot = &tls_ctx->prot_info;
+	struct strp_msg *rxm;
+	int pad, err;
+
+	if (tls_ctx->rx_conf != TLS_HW)
+		return 0;
+
+	err = tls_device_decrypted(sk, tls_ctx);
+	if (err <= 0)
+		return err;
+
+	pad = tls_padding_length(prot, tls_strp_msg(ctx), darg);
+	if (pad < 0)
+		return pad;
+
+	darg->zc = false;
+	darg->async = false;
+	darg->skb = tls_strp_msg(ctx);
+	ctx->recv_pkt = NULL;
+
+	rxm = strp_msg(darg->skb);
+	rxm->full_len -= pad;
+	return 1;
+}
+
+static int tls_rx_one_record(struct sock *sk, struct msghdr *msg,
+			     struct tls_decrypt_arg *darg)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_prot_info *prot = &tls_ctx->prot_info;
+	struct strp_msg *rxm;
+	int err;
+
+	err = tls_decrypt_device(sk, tls_ctx, darg);
+	if (!err)
+		err = tls_decrypt_sw(sk, tls_ctx, msg, darg);
+	if (err < 0)
+		return err;
+
+	rxm = strp_msg(darg->skb);
 	rxm->offset += prot->prepend_size;
 	rxm->full_len -= prot->overhead_size;
 	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
@@ -1934,7 +1955,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			darg.async = false;
 
-		err = tls_rx_one_record(sk, &msg->msg_iter, &darg);
+		err = tls_rx_one_record(sk, msg, &darg);
 		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
-- 
2.36.1

