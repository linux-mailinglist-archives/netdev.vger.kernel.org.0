Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A628E5695D0
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbiGFXYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbiGFXYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D662C113
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CB2361E9E
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9356C3411C;
        Wed,  6 Jul 2022 23:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149875;
        bh=4AAU36CubZAGcRm/LT0dM+Uoi3eMQAu59IJe6r75Cys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdM3ypSU+X1E7WvOrZqVtUwdB5Zb+W9QI4owSxP1x3soNFVtpaRfpABu6PuVkfMqa
         O168bSisDfkz3OUdwb0KhTa19Nw2BeOZrzTFIH0/D/c3XIz/RyPL6j7fxeNuKuEPqI
         xOWjDCo//jLwO//pQr4dzDCqz70h0mykr7wHIPorHdUB1+bGUB/1oGfXzUDQw1Pcpu
         F451HOkkoiemMzoA4udUL2ykBlpiLJ246LvyA95Hye8oxBUtz72bp9g8N/ccrP85yx
         lcmXj/y13dqsOIii8sQ1dIB9lkU8H9lXEdlLxYulF5vLdxCXsIVSqPIKRQDmGptBxM
         w3J5wv8tqmB4A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 11/15] net/tls: Multi-threaded calls to TX tls_dev_del
Date:   Wed,  6 Jul 2022 16:24:17 -0700
Message-Id: <20220706232421.41269-12-saeed@kernel.org>
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

Multiple TLS device-offloaded contexts can be added in parallel via
concurrent calls to .tls_dev_add, while calls to .tls_dev_del are
sequential in tls_device_gc_task.

This is not a sustainable behavior. This creates a rate gap between add
and del operations (addition rate outperforms the deletion rate).  When
running for enough time, the TLS device resources could get exhausted,
failing to offload new connections.

Replace the single-threaded garbage collector work with a per-context
alternative, so they can be handled on several cores in parallel.

Tested with mlx5 device:
Before: 22141 add/sec,   103 del/sec
After:  11684 add/sec, 11684 del/sec

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/net/tls.h    |  6 +++++
 net/tls/tls_device.c | 56 ++++++++++++++------------------------------
 2 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 4fc16ca5f469..c4be74635502 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -163,6 +163,11 @@ struct tls_record_info {
 	skb_frag_t frags[MAX_SKB_FRAGS];
 };
 
+struct destruct_work {
+	struct work_struct work;
+	struct tls_context *ctx;
+};
+
 struct tls_offload_context_tx {
 	struct crypto_aead *aead_send;
 	spinlock_t lock;	/* protects records list */
@@ -174,6 +179,7 @@ struct tls_offload_context_tx {
 
 	struct scatterlist sg_tx_data[MAX_SKB_FRAGS];
 	void (*sk_destruct)(struct sock *sk);
+	struct destruct_work destruct_work;
 	u8 driver_state[] __aligned(8);
 	/* The TLS layer reserves room for driver specific state
 	 * Currently the belief is that there is not enough
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 2c004ce46887..87401852e565 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -45,10 +45,6 @@
  */
 static DECLARE_RWSEM(device_offload_lock);
 
-static void tls_device_gc_task(struct work_struct *work);
-
-static DECLARE_WORK(tls_device_gc_work, tls_device_gc_task);
-static LIST_HEAD(tls_device_gc_list);
 static LIST_HEAD(tls_device_list);
 static LIST_HEAD(tls_device_down_list);
 static DEFINE_SPINLOCK(tls_device_lock);
@@ -67,29 +63,17 @@ static void tls_device_free_ctx(struct tls_context *ctx)
 	tls_ctx_free(NULL, ctx);
 }
 
-static void tls_device_gc_task(struct work_struct *work)
+static void tls_device_tx_del_task(struct work_struct *work)
 {
-	struct tls_context *ctx, *tmp;
-	unsigned long flags;
-	LIST_HEAD(gc_list);
-
-	spin_lock_irqsave(&tls_device_lock, flags);
-	list_splice_init(&tls_device_gc_list, &gc_list);
-	spin_unlock_irqrestore(&tls_device_lock, flags);
+	struct destruct_work *destruct_work =
+		container_of(work, struct destruct_work, work);
+	struct tls_context *ctx = destruct_work->ctx;
+	struct net_device *netdev = ctx->netdev;
 
-	list_for_each_entry_safe(ctx, tmp, &gc_list, list) {
-		struct net_device *netdev = ctx->netdev;
-
-		if (netdev && ctx->tx_conf == TLS_HW) {
-			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
-							TLS_OFFLOAD_CTX_DIR_TX);
-			dev_put(netdev);
-			ctx->netdev = NULL;
-		}
-
-		list_del(&ctx->list);
-		tls_device_free_ctx(ctx);
-	}
+	netdev->tlsdev_ops->tls_dev_del(netdev, ctx, TLS_OFFLOAD_CTX_DIR_TX);
+	dev_put(netdev);
+	ctx->netdev = NULL;
+	tls_device_free_ctx(ctx);
 }
 
 static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
@@ -98,21 +82,17 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	bool async_cleanup;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
+	list_del(&ctx->list); /* Remove from tls_device_list / tls_device_down_list */
+	spin_unlock_irqrestore(&tls_device_lock, flags);
+
 	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
 	if (async_cleanup) {
-		list_move_tail(&ctx->list, &tls_device_gc_list);
+		struct tls_offload_context_tx *offload_ctx = tls_offload_ctx_tx(ctx);
 
-		/* schedule_work inside the spinlock
-		 * to make sure tls_device_down waits for that work.
-		 */
-		schedule_work(&tls_device_gc_work);
+		schedule_work(&offload_ctx->destruct_work.work);
 	} else {
-		list_del(&ctx->list);
-	}
-	spin_unlock_irqrestore(&tls_device_lock, flags);
-
-	if (!async_cleanup)
 		tls_device_free_ctx(ctx);
+	}
 }
 
 /* We assume that the socket is already connected */
@@ -1149,6 +1129,9 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	start_marker_record->len = 0;
 	start_marker_record->num_frags = 0;
 
+	INIT_WORK(&offload_ctx->destruct_work.work, tls_device_tx_del_task);
+	offload_ctx->destruct_work.ctx = ctx;
+
 	INIT_LIST_HEAD(&offload_ctx->records_list);
 	list_add_tail(&start_marker_record->list, &offload_ctx->records_list);
 	spin_lock_init(&offload_ctx->lock);
@@ -1388,8 +1371,6 @@ static int tls_device_down(struct net_device *netdev)
 
 	up_write(&device_offload_lock);
 
-	flush_work(&tls_device_gc_work);
-
 	return NOTIFY_DONE;
 }
 
@@ -1435,6 +1416,5 @@ void __init tls_device_init(void)
 void __exit tls_device_cleanup(void)
 {
 	unregister_netdevice_notifier(&tls_dev_notifier);
-	flush_work(&tls_device_gc_work);
 	clean_acked_data_flush();
 }
-- 
2.36.1

