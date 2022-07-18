Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96716578B33
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbiGRTs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiGRTs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:48:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE19F31DCB
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 12:48:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59F3BB81745
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 19:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6D0C341CB;
        Mon, 18 Jul 2022 19:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658173703;
        bh=8TmRMLFlHvRLZ7D2mVJsCX6LA47V2CJDBA3e4h6VgjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkfHJl+xQiGCTMxpPmhPzyygSZO+w9z0EtcWMxls2xcPSyYV19jFNtQ2JuQuRhInN
         QKlcYzeqSV72Sf9LNcJb9bsIcRKITQyMKaYnyU3kT39tFEF7Xmi/JQ3TH3DQCttljw
         Tfe7iUUmkiC4SbhXPMl0wajwl47yMji6WqhB1mUNPv5a3nyvJ2ZFrtfzPBax+bLENR
         DD0KY6o/aeUc6u0BBfN54/OdBA0cgAzRzI9jNjd79fGG0HrYFzD2O7upI2fpmNMufP
         zwa3fr5D5fOyeQJrjShXWLBVd/foL9H26VsiVHqdnldnDUaZprFc+4ZQ2TZR06lz6D
         pXyHVFJarM1PQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/7] tls: rx: factor SW handling out of tls_rx_one_record()
Date:   Mon, 18 Jul 2022 12:48:06 -0700
Message-Id: <20220718194811.1728061-3-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220718194811.1728061-1-kuba@kernel.org>
References: <20220718194811.1728061-1-kuba@kernel.org>
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

