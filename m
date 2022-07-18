Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1BE578B31
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiGRTsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRTs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB76313B8
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 12:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E6C961734
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 19:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2CDC341CB;
        Mon, 18 Jul 2022 19:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658173707;
        bh=WoAfCEzRBLEK3oYq7LV/+wVRkXy/KeWMPDCMf3BpCkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpaVxTzTdBqFjbUHvBgFwMf4nZjdyd1o7sMBy+obWSGLYoqASiZczVwhXnVK4PwaB
         UI8d0hG/Znltw3mL6eUDr2+AOXC8w1lGRSpB4KSWpXRWZioRESTdrqe6/OkMFRsVv6
         xK1lDtenC7gKqj1ZL5TU20UtjS6KIzQkSlY+pIv0PKm6z2B/osCttkclwO++aEUMVr
         Smv4G0n5pcelGkghB0mBVgIOZnlLnu8vFlaN4ozbbLLKUVxxDc9A0I7g1W4Wds7DFd
         CjBxsjqRcSZmOjyFgQUvuZV0utL+wP6+dkmib3/TisZaW2hGTO7pfClCKiLxBVhCrc
         vtbjQ09aY3CdQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/7] tls: rx: device: keep the zero copy status with offload
Date:   Mon, 18 Jul 2022 12:48:08 -0700
Message-Id: <20220718194811.1728061-5-kuba@kernel.org>
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
index 7345b41ded9d..02894a2d1f31 100644
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
2.36.1

