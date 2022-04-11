Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA29E4FC4F3
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349423AbiDKTVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241468AbiDKTVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813C21085
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1643E6152A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900D7C385A9;
        Mon, 11 Apr 2022 19:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704764;
        bh=88rB3DQPPXzzXug0nxXDzYaB9f9l79Hw7jIj9/FhDqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOFmIcdu9Iq9DAhvpSIas/39iIuElKTPGFRXHiENtSndC1QT1h8Fqoc0aQgNkaN6S
         UuZVgD1TZfZcUDpcOzroaVWd25okwD815G9zra4sQvNOT8fel471CjgjUc9N1cjKHv
         F0JF8jZ6wNEdWX028/+M8TfcOfr/VL6hyRIRtb47jJgmBNUMcwlCSrVAQXnOWdPvQp
         lYQflcnGCZa8VFyxEIzADHgzqBAYw+7jyQ0N86y7uEfR+nAXb0BRTdbXMZtjBGAkA1
         9Mhl0hGKhiVnHhe0KgLScnVbqyHTWdx24fexD4O/GIbfWNd/+Zof7HQUoZLjqLxEB9
         7uM1FKwh8Coxg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/10] tls: rx: return the already-copied data on crypto error
Date:   Mon, 11 Apr 2022 12:19:14 -0700
Message-Id: <20220411191917.1240155-8-kuba@kernel.org>
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

async crypto handler will report the socket error no need
to report it again. We can, however, let the data we already
copied be reported to user space but we need to make sure
the error will be reported next time around.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index bba69706aea9..b5d1393aa8d4 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1747,6 +1747,11 @@ int tls_sw_recvmsg(struct sock *sk,
 	lock_sock(sk);
 	bpf_strp_enabled = sk_psock_strp_enabled(psock);
 
+	/* If crypto failed the connection is broken */
+	err = ctx->async_wait.err;
+	if (err)
+		goto end;
+
 	/* Process pending decrypted records. It must be non-zero-copy */
 	err = process_rx_list(ctx, msg, &control, 0, len, false, is_peek);
 	if (err < 0)
@@ -1877,7 +1882,7 @@ int tls_sw_recvmsg(struct sock *sk,
 
 recv_end:
 	if (async) {
-		int pending;
+		int ret, pending;
 
 		/* Wait for all previously submitted records to be decrypted */
 		spin_lock_bh(&ctx->decrypt_compl_lock);
@@ -1885,11 +1890,10 @@ int tls_sw_recvmsg(struct sock *sk,
 		pending = atomic_read(&ctx->decrypt_pending);
 		spin_unlock_bh(&ctx->decrypt_compl_lock);
 		if (pending) {
-			err = crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
-			if (err) {
-				/* one of async decrypt failed */
-				tls_err_abort(sk, err);
-				copied = 0;
+			ret = crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
+			if (ret) {
+				if (err >= 0 || err == -EINPROGRESS)
+					err = ret;
 				decrypted = 0;
 				goto end;
 			}
-- 
2.34.1

