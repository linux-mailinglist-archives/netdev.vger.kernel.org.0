Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F644F8E01
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbiDHDkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbiDHDkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87952FABD7
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4D70CE29EC
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D796C385A4;
        Fri,  8 Apr 2022 03:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389108;
        bh=iVq1V4v+EpvA0Q/HJrrB9SfWC4PacrL0ZUdzAc2kdIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wq+z7AcyIEf6M5lUgPwHr6whrbMfXRxzGMFbaOj2dYsZ25wguLVAbGJ7kS1E0bmTs
         4yTS+xqrwIhrUNJNvsgWsXyQP7AwdFCA8Ab8PTkTqKrwTC5lykf248mGZLIQvSTkhw
         Fj0kizBHEK4DuJlfbj0K24gYl4ExSY/zRKNWuOxJl159MpmUIhuRAsbXaMTskrOJ3J
         qZd/PcLrzDN4T5Y6HCM1XIAiIzgUJ8YanXoGWVyOtX2jEsJmfZQM0Stn76GjDcSAFT
         P1sOSSL5fsXvRyhT4Kzs9/NqwkaNJWYtG3gGw+u7zQTEJ6dutqNXlanYeglozKmG1d
         BRjphO/qfjGaQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/10] tls: rx: don't store the decryption status in socket context
Date:   Thu,  7 Apr 2022 20:38:17 -0700
Message-Id: <20220408033823.965896-5-kuba@kernel.org>
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

Similar justification to previous change, the information
about decryption status belongs in the skb.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/strparser.h |  1 +
 include/net/tls.h       |  1 -
 net/tls/tls_device.c    |  3 ++-
 net/tls/tls_sw.c        | 10 ++++++----
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index c271543076cf..a191486eb1e4 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -72,6 +72,7 @@ struct sk_skb_cb {
 	u64 temp_reg;
 	struct tls_msg {
 		u8 control;
+		u8 decrypted;
 	} tls;
 };
 
diff --git a/include/net/tls.h b/include/net/tls.h
index c3717cd1f1cd..f040edc97c50 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -148,7 +148,6 @@ struct tls_sw_context_rx {
 
 	struct sk_buff *recv_pkt;
 	u8 async_capable:1;
-	u8 decrypted:1;
 	atomic_t decrypt_pending;
 	/* protect crypto_wait with decrypt_pending*/
 	spinlock_t decrypt_compl_lock;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 12f7b56771d9..78d979e0f298 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -948,6 +948,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 			 struct sk_buff *skb, struct strp_msg *rxm)
 {
 	struct tls_offload_context_rx *ctx = tls_offload_ctx_rx(tls_ctx);
+	struct tls_msg *tlm = tls_msg(skb);
 	int is_decrypted = skb->decrypted;
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
@@ -962,7 +963,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 				   tls_ctx->rx.rec_seq, rxm->full_len,
 				   is_encrypted, is_decrypted);
 
-	ctx->sw.decrypted |= is_decrypted;
+	tlm->decrypted |= is_decrypted;
 
 	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {
 		if (likely(is_encrypted || is_decrypted))
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 222f8cad1e8c..167bd133b7f8 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1565,9 +1565,10 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm = strp_msg(skb);
+	struct tls_msg *tlm = tls_msg(skb);
 	int pad, err = 0;
 
-	if (!ctx->decrypted) {
+	if (!tlm->decrypted) {
 		if (tls_ctx->rx_conf == TLS_HW) {
 			err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
 			if (err < 0)
@@ -1575,7 +1576,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		}
 
 		/* Still not decrypted after tls_device */
-		if (!ctx->decrypted) {
+		if (!tlm->decrypted) {
 			err = decrypt_internal(sk, skb, dest, NULL, chunk, zc,
 					       async);
 			if (err < 0) {
@@ -1599,7 +1600,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		rxm->offset += prot->prepend_size;
 		rxm->full_len -= prot->overhead_size;
 		tls_advance_record_sn(sk, prot, &tls_ctx->rx);
-		ctx->decrypted = 1;
+		tlm->decrypted = 1;
 		ctx->saved_data_ready(sk);
 	} else {
 		*zc = false;
@@ -2144,8 +2145,9 @@ static void tls_queue(struct strparser *strp, struct sk_buff *skb)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
+	struct tls_msg *tlm = tls_msg(skb);
 
-	ctx->decrypted = 0;
+	tlm->decrypted = 0;
 
 	ctx->recv_pkt = skb;
 	strp_pause(strp);
-- 
2.34.1

