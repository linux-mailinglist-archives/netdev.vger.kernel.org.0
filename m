Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780BC4F9CC9
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238756AbiDHSeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238751AbiDHSds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:33:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4F1ED939
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A55CC62245
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF4AC385A6;
        Fri,  8 Apr 2022 18:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442702;
        bh=Eug1iV3vH8lBdrXyE9dzkd8xYrWajqALIbQRlvSUX80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdryXEP1hlhb6Q6iunFLnzYVD1QYVyONe+Fku/C7MkFy5gCWpzQbO9N/2V/DPtxRm
         KKuufdxkot+ckuHKNrEsUFxj+GoygFFgl9WK59EYsIW+K88nKqvbk8GlhPDZ56LThe
         aL+EMQgn902Ke8PMoGkc3C+zVdyMME0FZuOgK0T/kGgn1IwNAY8p4Z16LIJFhRKSMH
         Vw2vaebyPlKir3Qe0PT+OFYG5AXSq5giMBIIhTYgEuioes/6ZPFm7EkK4+JJGyYMnB
         OHjYmryPdxcb1T3WZvi5hDgmHhZpBEQN64gquhdMPBVpgMS9OkCKVpfHH8vKzf1tg0
         a6mUNyW894mlg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/11] tls: rx: don't track the async count
Date:   Fri,  8 Apr 2022 11:31:30 -0700
Message-Id: <20220408183134.1054551-8-kuba@kernel.org>
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

We track both if the last record was handled by async crypto
and how many records were async. This is not necessary. We
implicitly assume once crypto goes async it will stay that
way, otherwise we'd reorder records. So just track if we're
in async mode, the exact number of records is not necessary.

This change also forces us into "async" mode more consistently
in case crypto ever decided to interleave async and sync.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 6f17f599a6d4..183e5ec292a8 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1751,13 +1751,13 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct sk_psock *psock;
-	int num_async, pending;
 	unsigned char control = 0;
 	ssize_t decrypted = 0;
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
+	bool async = false;
 	int target, err = 0;
 	long timeo;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
@@ -1789,12 +1789,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	decrypted = 0;
-	num_async = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		struct tls_decrypt_arg darg = {};
 		bool retain_skb = false;
 		int to_decrypt, chunk;
-		bool async;
 
 		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
 		if (!skb) {
@@ -1834,10 +1832,8 @@ int tls_sw_recvmsg(struct sock *sk,
 			goto recv_end;
 		}
 
-		if (err == -EINPROGRESS) {
+		if (err == -EINPROGRESS)
 			async = true;
-			num_async++;
-		}
 
 		/* If the type of records being processed is not known yet,
 		 * set it to record type just dequeued. If it is already known,
@@ -1911,7 +1907,9 @@ int tls_sw_recvmsg(struct sock *sk,
 	}
 
 recv_end:
-	if (num_async) {
+	if (async) {
+		int pending;
+
 		/* Wait for all previously submitted records to be decrypted */
 		spin_lock_bh(&ctx->decrypt_compl_lock);
 		reinit_completion(&ctx->async_wait.completion);
-- 
2.34.1

