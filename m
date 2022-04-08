Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5514F9CC4
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbiDHSdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238738AbiDHSdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D50EED93F
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5FED62231
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23201C385A3;
        Fri,  8 Apr 2022 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442700;
        bh=Z20xB1hmsC6D7whhVRe+Oc8SSRjU3aG8zbaywexPsUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pq3MZgl0wtR6KuryEvFMcy1Cto8a630CSYLfXHJIYfwBiLUJkVU1fU8qMclD1aXas
         2RecmsVHPahhKNE70PgDayI7+LWxTB8zSU6MwXUNeeLI3t/z5DodwUS+T0zNSnTmeE
         B63P87ciE6YjbaqpRH8ufzqDsdzh/c7WUBSOetxRd48Xvcd649Pla/sjCiHWn5ffDk
         ybWYjwabXJOoLkzXG0sBTiA6SWydmo13cVezJkEijUc/xzsJVPTYpEpvvlioRK2GhO
         +Tcq+g9aaJPiFvb36WlZuUGZJKz8amZpVnw/eQjQC9sdSuB+ZmvD8F2lOKQG9kjE9K
         eokvjI6or4V/Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/11] tls: rx: simplify async wait
Date:   Fri,  8 Apr 2022 11:31:27 -0700
Message-Id: <20220408183134.1054551-5-kuba@kernel.org>
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

Since we are protected from async completions by decrypt_compl_lock
we can drop the async_notify and reinit the completion before we
start waiting.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/tls.h |  1 -
 net/tls/tls_sw.c  | 14 ++------------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index a01c264e5f15..6fe78361c8c8 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -152,7 +152,6 @@ struct tls_sw_context_rx {
 	atomic_t decrypt_pending;
 	/* protect crypto_wait with decrypt_pending*/
 	spinlock_t decrypt_compl_lock;
-	bool async_notify;
 };
 
 struct tls_record_info {
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index ecf9a3832798..003f7c178cde 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -173,7 +173,6 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 	struct scatterlist *sg;
 	struct sk_buff *skb;
 	unsigned int pages;
-	int pending;
 
 	skb = (struct sk_buff *)req->data;
 	tls_ctx = tls_get_ctx(skb->sk);
@@ -221,9 +220,7 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 	kfree(aead_req);
 
 	spin_lock_bh(&ctx->decrypt_compl_lock);
-	pending = atomic_dec_return(&ctx->decrypt_pending);
-
-	if (!pending && ctx->async_notify)
+	if (!atomic_dec_return(&ctx->decrypt_pending))
 		complete(&ctx->async_wait.completion);
 	spin_unlock_bh(&ctx->decrypt_compl_lock);
 }
@@ -1940,7 +1937,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	if (num_async) {
 		/* Wait for all previously submitted records to be decrypted */
 		spin_lock_bh(&ctx->decrypt_compl_lock);
-		ctx->async_notify = true;
+		reinit_completion(&ctx->async_wait.completion);
 		pending = atomic_read(&ctx->decrypt_pending);
 		spin_unlock_bh(&ctx->decrypt_compl_lock);
 		if (pending) {
@@ -1952,15 +1949,8 @@ int tls_sw_recvmsg(struct sock *sk,
 				decrypted = 0;
 				goto end;
 			}
-		} else {
-			reinit_completion(&ctx->async_wait.completion);
 		}
 
-		/* There can be no concurrent accesses, since we have no
-		 * pending decrypt operations
-		 */
-		WRITE_ONCE(ctx->async_notify, false);
-
 		/* Drain records from the rx_list & copy if required */
 		if (is_peek || is_kvec)
 			err = process_rx_list(ctx, msg, &control, &cmsg, copied,
-- 
2.34.1

