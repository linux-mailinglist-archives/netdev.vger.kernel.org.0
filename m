Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DBB57EA6D
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 01:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiGVXuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 19:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiGVXuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 19:50:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F88BB5D2
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 16:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3A6862258
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 23:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6978C341C7;
        Fri, 22 Jul 2022 23:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658533843;
        bh=oVIrSFAbU0b/UHOp/aGubr92ilH5Hbl72lykrQoXlMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcvlYuoWqL240X9zFLWCWwmoarqyLdtki3fqqIfkxtqFr1MP+XguhmAq+9BTxvC0c
         lpGu3hZs1083DVKIl3/oD5L3B1N3e/XmW7nf9cUWEAsKCN8A4CzN49YboWo9TO3xbw
         bIQ+VflVlslKF/zCB4H5LExoPFcVpX7ETFGkE7RbOR8tL2oe0NCtTqc7z/ySLix3hr
         7V4bUY4r8tFWk9il0F2fOPyt/RROJO3M4S9a6VPU4envNcGivfDEPy9l2q09n8SLv3
         RaJBb2NsW1R27BPgFizDnuUkKzq7Z99+brUBriP3q0lavlPu2lKZLilgmc0vnqfXrW
         eCRP1RBLCmDRA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 1/7] tls: rx: wrap recv_pkt accesses in helpers
Date:   Fri, 22 Jul 2022 16:50:27 -0700
Message-Id: <20220722235033.2594446-2-kuba@kernel.org>
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

To allow for the logic to change later wrap accesses
which interrogate the input skb in helper functions.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
---
 net/tls/tls.h    |  5 +++++
 net/tls/tls_sw.c | 11 ++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 3740740504e3..24bec1c5f1e8 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -142,6 +142,11 @@ static inline struct sk_buff *tls_strp_msg(struct tls_sw_context_rx *ctx)
 	return ctx->recv_pkt;
 }
 
+static inline bool tls_strp_msg_ready(struct tls_sw_context_rx *ctx)
+{
+	return ctx->recv_pkt;
+}
+
 #ifdef CONFIG_TLS_DEVICE
 int tls_device_init(void);
 void tls_device_cleanup(void);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index ed5e6f1df9c7..cb99fc11997b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1289,7 +1289,7 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
-	while (!ctx->recv_pkt) {
+	while (!tls_strp_msg_ready(ctx)) {
 		if (!sk_psock_queue_empty(psock))
 			return 0;
 
@@ -1298,7 +1298,7 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 
 		if (!skb_queue_empty(&sk->sk_receive_queue)) {
 			__strp_unpause(&ctx->strp);
-			if (ctx->recv_pkt)
+			if (tls_strp_msg_ready(ctx))
 				break;
 		}
 
@@ -1314,7 +1314,8 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 		add_wait_queue(sk_sleep(sk), &wait);
 		sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 		sk_wait_event(sk, &timeo,
-			      ctx->recv_pkt || !sk_psock_queue_empty(psock),
+			      tls_strp_msg_ready(ctx) ||
+			      !sk_psock_queue_empty(psock),
 			      &wait);
 		sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 		remove_wait_queue(sk_sleep(sk), &wait);
@@ -1907,7 +1908,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	zc_capable = !bpf_strp_enabled && !is_kvec && !is_peek &&
 		ctx->zc_capable;
 	decrypted = 0;
-	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
+	while (len && (decrypted + copied < target || tls_strp_msg_ready(ctx))) {
 		struct tls_decrypt_arg darg;
 		int to_decrypt, chunk;
 
@@ -2158,7 +2159,7 @@ bool tls_sw_sock_is_readable(struct sock *sk)
 		ingress_empty = list_empty(&psock->ingress_msg);
 	rcu_read_unlock();
 
-	return !ingress_empty || ctx->recv_pkt ||
+	return !ingress_empty || tls_strp_msg_ready(ctx) ||
 		!skb_queue_empty(&ctx->rx_list);
 }
 
-- 
2.37.1

