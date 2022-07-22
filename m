Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2814157EA72
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 01:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbiGVXut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 19:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236462AbiGVXuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 19:50:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BEABB5D2
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 16:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB363622B3
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 23:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF8AC341D2;
        Fri, 22 Jul 2022 23:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658533844;
        bh=qEocviZeFPupUlYzuVkxW6gAR3MwHldiA7rAgi14hyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3OHeKo5b78nEG9+SXlOUN56GJ9YswJiIeYNzbukg06AM+9QzNJa22Ya7WJ6s99Xw
         leYFR8ZgMj+DODeFBMTc+cKdQGJFG1Hcjb4xwGlgj8k1YUjoO9GC4KIrd3vnU/XMiV
         oF7nabetLEccUGIM/iRcC/OWmYC0E42KHmHLZVyAV8krpAvgMd5TgITZXZUBq2kIve
         eFvkXE9iowjl9OkUluU51MCo2BQljJ6Xmr3GrGf+4Dr6KzRZGcYe8uCLl3+CSk0ydU
         xKZ2LHEyM1mz2dc5r3XoFgM4raA0K/A9Uxp5a8wG2gZqZ9shLuiFqJlgTTAFMiqrWI
         WjlAxw+i7P18A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 4/7] tls: rx: device: keep the zero copy status with offload
Date:   Fri, 22 Jul 2022 16:50:30 -0700
Message-Id: <20220722235033.2594446-5-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722235033.2594446-1-kuba@kernel.org>
References: <20220722235033.2594446-1-kuba@kernel.org>
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

The non-zero-copy path assumes a full skb with decrypted contents.
This means the device offload would have to CoW the data. Try
to keep the zero-copy status instead, copy the data to user space.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
---
 net/tls/tls.h      |  1 +
 net/tls/tls_strp.c |  9 +++++++++
 net/tls/tls_sw.c   | 30 +++++++++++++++++++++++++-----
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 24bec1c5f1e8..78c5d699bf75 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -127,6 +127,7 @@ int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_offload_context_tx *offload_ctx,
 			 struct tls_crypto_info *crypto_info);
 
+struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx);
 int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
 		      struct sk_buff_head *dst);
 
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 9ccab79a6e1e..40b177366121 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -4,6 +4,15 @@
 
 #include "tls.h"
 
+struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx)
+{
+	struct sk_buff *skb;
+
+	skb = ctx->recv_pkt;
+	ctx->recv_pkt = NULL;
+	return skb;
+}
+
 int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
 		      struct sk_buff_head *dst)
 {
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fe38b49a2607..bd4486819e64 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1631,8 +1631,8 @@ tls_decrypt_sw(struct sock *sk, struct tls_context *tls_ctx,
 }
 
 static int
-tls_decrypt_device(struct sock *sk, struct tls_context *tls_ctx,
-		   struct tls_decrypt_arg *darg)
+tls_decrypt_device(struct sock *sk, struct msghdr *msg,
+		   struct tls_context *tls_ctx, struct tls_decrypt_arg *darg)
 {
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -1650,13 +1650,33 @@ tls_decrypt_device(struct sock *sk, struct tls_context *tls_ctx,
 	if (pad < 0)
 		return pad;
 
-	darg->zc = false;
 	darg->async = false;
 	darg->skb = tls_strp_msg(ctx);
-	ctx->recv_pkt = NULL;
+	/* ->zc downgrade check, in case TLS 1.3 gets here */
+	darg->zc &= !(prot->version == TLS_1_3_VERSION &&
+		      tls_msg(darg->skb)->control != TLS_RECORD_TYPE_DATA);
 
 	rxm = strp_msg(darg->skb);
 	rxm->full_len -= pad;
+
+	if (!darg->zc) {
+		/* Non-ZC case needs a real skb */
+		darg->skb = tls_strp_msg_detach(ctx);
+		if (!darg->skb)
+			return -ENOMEM;
+	} else {
+		unsigned int off, len;
+
+		/* In ZC case nobody cares about the output skb.
+		 * Just copy the data here. Note the skb is not fully trimmed.
+		 */
+		off = rxm->offset + prot->prepend_size;
+		len = rxm->full_len - prot->overhead_size;
+
+		err = skb_copy_datagram_msg(darg->skb, off, msg, len);
+		if (err)
+			return err;
+	}
 	return 1;
 }
 
@@ -1668,7 +1688,7 @@ static int tls_rx_one_record(struct sock *sk, struct msghdr *msg,
 	struct strp_msg *rxm;
 	int err;
 
-	err = tls_decrypt_device(sk, tls_ctx, darg);
+	err = tls_decrypt_device(sk, msg, tls_ctx, darg);
 	if (!err)
 		err = tls_decrypt_sw(sk, tls_ctx, msg, darg);
 	if (err < 0)
-- 
2.37.1

