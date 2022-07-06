Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FD45695CB
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiGFXYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiGFXYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569C92C11B
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9D4ACE21AA
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BFCC341CA;
        Wed,  6 Jul 2022 23:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149875;
        bh=//dW2Tsbx547zXud6FZi/GUtI5+bbS6vQJ3ZpI9MvSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQvBe/q0aad9ntJ8yiDfYTIxMdKdipq6/UslrGU27OKokEh4LY7kOPR4nUcB0ZBk+
         XHSEtm3+iDv2AMA/4b2taqHiTnog08Ji1xjm0gKad4LDGYAckJWXCbgcZ1hkFa2+JU
         pSRzVjY2A2wni++kEi/jBRwjqQ26wxJskr7S9bfSACIhLFXQgY+oyKcXb4E2WI7d6M
         S1IGBP+tx/jOYrHow6f8+ipqfQLuwbJV4R3hISdx5UA47s8fUxfPaFMxwZSbbeVAiO
         FH9rbJ1EhEjNwfEN1359ULjUhJ4oY7+gCeMVAgcEwseZ84Qq+NMMsO/5CUCke8JBOM
         idh+DZkBX5Nqw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 10/15] net/tls: Perform immediate device ctx cleanup when possible
Date:   Wed,  6 Jul 2022 16:24:16 -0700
Message-Id: <20220706232421.41269-11-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706232421.41269-1-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

TLS context destructor can be run in atomic context. Cleanup operations
for device-offloaded contexts could require access and interaction with
the device callbacks, which might sleep. Hence, the cleanup of such
contexts must be deferred and completed inside an async work.

For all others, this is not necessary, as cleanup is atomic. Invoke
cleanup immediately for them, avoiding queueuing redundant gc work.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 net/tls/tls_device.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index ec6f4b699a2b..2c004ce46887 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -95,16 +95,24 @@ static void tls_device_gc_task(struct work_struct *work)
 static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 {
 	unsigned long flags;
+	bool async_cleanup;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
-	list_move_tail(&ctx->list, &tls_device_gc_list);
-
-	/* schedule_work inside the spinlock
-	 * to make sure tls_device_down waits for that work.
-	 */
-	schedule_work(&tls_device_gc_work);
+	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
+	if (async_cleanup) {
+		list_move_tail(&ctx->list, &tls_device_gc_list);
 
+		/* schedule_work inside the spinlock
+		 * to make sure tls_device_down waits for that work.
+		 */
+		schedule_work(&tls_device_gc_work);
+	} else {
+		list_del(&ctx->list);
+	}
 	spin_unlock_irqrestore(&tls_device_lock, flags);
+
+	if (!async_cleanup)
+		tls_device_free_ctx(ctx);
 }
 
 /* We assume that the socket is already connected */
-- 
2.36.1

