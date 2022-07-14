Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017035741EB
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiGNDdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiGNDdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:33:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B736325EA0
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9869261E2D
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC6CC341C0;
        Thu, 14 Jul 2022 03:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657769601;
        bh=Uz8CEFsc3ynPqGQWwN5Lhdya4vcXIBhzYxWrKP0vZMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpNbMywNbQdl8WggeLFGLpnK0HJuqvBURr6sWYPYaKWH1ytmeQUFiwY8PfAg4TzE/
         lPUKTSVdr6HJ61bfEPjziP4dtINivImqkAUHaWicIb+EEB/YsBkgTd0LihypbFuF9x
         q3+5qlUpxInrI9eQUd74yBG08K08/1rynRo82dr1nPwhv3HY5Ie23yb3kZA6RQbm4B
         k0hbKcVmFOABYpoKR2Y7UiMvr+4I+LA2xNitPvl6839hlVV2T1wFyBRT8nQz3uhmjN
         mM0V1RFtFHhZpOD1n4Ws/v8d+MpmGtyvC6GLFvRD4ythuaH/kSJJ+GkPai8dnOduIG
         SYq9vjYxTfvHg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/11] tls: rx: async: hold onto the input skb
Date:   Wed, 13 Jul 2022 20:33:08 -0700
Message-Id: <20220714033310.1273288-10-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220714033310.1273288-1-kuba@kernel.org>
References: <20220714033310.1273288-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Async crypto currently benefits from the fact that we decrypt
in place. When we allow input and output to be different skbs
we will have to hang onto the input while we move to the next
record. Clone the inputs and keep them on a list.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/tls.h  |  1 +
 net/tls/Makefile   |  2 +-
 net/tls/tls.h      |  3 +++
 net/tls/tls_strp.c | 17 +++++++++++++++++
 net/tls/tls_sw.c   | 26 +++++++++++++++++---------
 5 files changed, 39 insertions(+), 10 deletions(-)
 create mode 100644 net/tls/tls_strp.c

diff --git a/include/net/tls.h b/include/net/tls.h
index e8935cfe0cd6..181c496b01b8 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -123,6 +123,7 @@ struct tls_sw_context_rx {
 	atomic_t decrypt_pending;
 	/* protect crypto_wait with decrypt_pending*/
 	spinlock_t decrypt_compl_lock;
+	struct sk_buff_head async_hold;
 	struct wait_queue_head wq;
 };
 
diff --git a/net/tls/Makefile b/net/tls/Makefile
index f1ffbfe8968d..e41c800489ac 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -7,7 +7,7 @@ CFLAGS_trace.o := -I$(src)
 
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := tls_main.o tls_sw.o tls_proc.o trace.o
+tls-y := tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
 
 tls-$(CONFIG_TLS_TOE) += tls_toe.o
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/tls.h b/net/tls/tls.h
index 9fa6827cde38..6373308f6ff3 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -124,6 +124,9 @@ int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_offload_context_tx *offload_ctx,
 			 struct tls_crypto_info *crypto_info);
 
+int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
+		      struct sk_buff_head *dst);
+
 static inline struct tls_msg *tls_msg(struct sk_buff *skb)
 {
 	struct sk_skb_cb *scb = (struct sk_skb_cb *)skb->cb;
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
new file mode 100644
index 000000000000..9ccab79a6e1e
--- /dev/null
+++ b/net/tls/tls_strp.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/skbuff.h>
+
+#include "tls.h"
+
+int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
+		      struct sk_buff_head *dst)
+{
+	struct sk_buff *clone;
+
+	clone = skb_clone(skb, sk->sk_allocation);
+	if (!clone)
+		return -ENOMEM;
+	__skb_queue_tail(dst, clone);
+	return 0;
+}
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 09fe2cfff51a..f767501e178d 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1535,8 +1535,13 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 		goto exit_free_pages;
 
 	darg->skb = tls_strp_msg(ctx);
-	if (darg->async)
-		return 0;
+
+	if (unlikely(darg->async)) {
+		err = tls_strp_msg_hold(sk, skb, &ctx->async_hold);
+		if (err)
+			__skb_queue_tail(&ctx->async_hold, darg->skb);
+		return err;
+	}
 
 	if (prot->tail_size)
 		darg->tail = dctx->tail;
@@ -1998,14 +2003,16 @@ int tls_sw_recvmsg(struct sock *sk,
 		reinit_completion(&ctx->async_wait.completion);
 		pending = atomic_read(&ctx->decrypt_pending);
 		spin_unlock_bh(&ctx->decrypt_compl_lock);
-		if (pending) {
+		ret = 0;
+		if (pending)
 			ret = crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
-			if (ret) {
-				if (err >= 0 || err == -EINPROGRESS)
-					err = ret;
-				decrypted = 0;
-				goto end;
-			}
+		__skb_queue_purge(&ctx->async_hold);
+
+		if (ret) {
+			if (err >= 0 || err == -EINPROGRESS)
+				err = ret;
+			decrypted = 0;
+			goto end;
 		}
 
 		/* Drain records from the rx_list & copy if required */
@@ -2440,6 +2447,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		crypto_info = &ctx->crypto_recv.info;
 		cctx = &ctx->rx;
 		skb_queue_head_init(&sw_ctx_rx->rx_list);
+		skb_queue_head_init(&sw_ctx_rx->async_hold);
 		aead = &sw_ctx_rx->aead_recv;
 	}
 
-- 
2.36.1

