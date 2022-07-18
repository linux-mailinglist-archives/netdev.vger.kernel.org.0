Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B92578B34
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbiGRTs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRTsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:48:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384983191E
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 12:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9445B81681
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 19:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821A0C341CE;
        Mon, 18 Jul 2022 19:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658173700;
        bh=yF/2GA78XUXZpp8a9d+/2l90QgGJ2kA+huonoYJIdQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bS80XscZ6uMepBhfFZx/4shfApoQo4y8IDGhkO3ZWiQar9V6gid+Ix/qMs9TT6zSd
         YkrGwC7RG8sPIM51bOpOeNz9QLdTboTAL5m3s8B3bXMajV6Iq3UCwRTvrAK7L4NXFE
         hAt2deIvnSwrO3WIrW/ARnekxo22LVvymyOb+7lpFHPGpKuwUw2Crj35wNjBIJ7gVu
         9m12WEJdE8t6niWTmzzNiZIlubc1IHMg5oPiFXN2Mi+TIBfLUUjCsDmWKSAVKwICbz
         pdktcWGDuBILqCoae2GUqoCfUmb0NQ6Exyfpmv7WlbHTrU6DsHwZgUWciqFOhudjgC
         OL3CUy+IFH2SQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/7] tls: rx: wrap recv_pkt accesses in helpers
Date:   Mon, 18 Jul 2022 12:48:05 -0700
Message-Id: <20220718194811.1728061-2-kuba@kernel.org>
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
index 859ea02022c0..566717ef5a27 100644
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
@@ -1898,7 +1899,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	zc_capable = !bpf_strp_enabled && !is_kvec && !is_peek &&
 		ctx->zc_capable;
 	decrypted = 0;
-	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
+	while (len && (decrypted + copied < target || tls_strp_msg_ready(ctx))) {
 		struct tls_decrypt_arg darg;
 		int to_decrypt, chunk;
 
@@ -2149,7 +2150,7 @@ bool tls_sw_sock_is_readable(struct sock *sk)
 		ingress_empty = list_empty(&psock->ingress_msg);
 	rcu_read_unlock();
 
-	return !ingress_empty || ctx->recv_pkt ||
+	return !ingress_empty || tls_strp_msg_ready(ctx) ||
 		!skb_queue_empty(&ctx->rx_list);
 }
 
-- 
2.36.1

