Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834666268D4
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiKLKWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiKLKWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A577B2792B
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4444960B92
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7E7C433C1;
        Sat, 12 Nov 2022 10:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248524;
        bh=Sbdt3f/SbFcoaWvGMAgowJVd1OOmnaG991HES+VRCtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlJ2Jz/QmD4y4yLxbnQ0UFZ4JAP4zUECYC4z6SHbOkbffhhUtTnDo1+srq9Uy8iqk
         m6gSXMiOMRelEvMwetQ+VVD+2HXYQP+WJLzM/EnAr13flEDPwCLcuwhuwodBpjSSL/
         r6iTe7fvEkrwyVGNM1Bn63KeDcZKI7NXD8L11gfhcRhsXmw/3iNKEVqktELWZ4LZuo
         /PcnObRn6/ax7Sj6DWxXqADI31XqxReYyM1mo5VOXrvOeVTc41GpNmOcySdaqetUz9
         ZqjXQNgKrh8LmDdqBLiJ3CzcKgZ2yVs3Dq5dEuNnd6EsPBQzqZ2cBQTucua5vfItTs
         qqzAQ3XHwx1Ng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: kTLS, Remove unnecessary per-callback completion
Date:   Sat, 12 Nov 2022 02:21:44 -0800
Message-Id: <20221112102147.496378-13-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Waiting on a completion object for each callback before cleaning up their
async contexts is not necessary, as this is already implied in the
mlx5_cmd_cleanup_async_ctx() API.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index f8d9708feb7c..fcaa26847c8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -127,7 +127,6 @@ struct mlx5e_async_ctx {
 	struct mlx5_async_work context;
 	struct mlx5_async_ctx async_ctx;
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
-	struct completion complete;
 	int err;
 	union {
 		u32 out_create[MLX5_ST_SZ_DW(create_tis_out)];
@@ -148,7 +147,6 @@ static struct mlx5e_async_ctx *mlx5e_bulk_async_init(struct mlx5_core_dev *mdev,
 		struct mlx5e_async_ctx *async = &bulk_async[i];
 
 		mlx5_cmd_init_async_ctx(mdev, &async->async_ctx);
-		init_completion(&async->complete);
 	}
 
 	return bulk_async;
@@ -175,12 +173,10 @@ static void create_tis_callback(int status, struct mlx5_async_work *context)
 	if (status) {
 		async->err = status;
 		priv_tx->create_err = 1;
-		goto out;
+		return;
 	}
 
 	priv_tx->tisn = MLX5_GET(create_tis_out, async->out_create, tisn);
-out:
-	complete(&async->complete);
 }
 
 static void destroy_tis_callback(int status, struct mlx5_async_work *context)
@@ -189,7 +185,6 @@ static void destroy_tis_callback(int status, struct mlx5_async_work *context)
 		container_of(context, struct mlx5e_async_ctx, context);
 	struct mlx5e_ktls_offload_context_tx *priv_tx = async->priv_tx;
 
-	complete(&async->complete);
 	kfree(priv_tx);
 }
 
@@ -231,7 +226,6 @@ static void mlx5e_tls_priv_tx_cleanup(struct mlx5e_ktls_offload_context_tx *priv
 				      struct mlx5e_async_ctx *async)
 {
 	if (priv_tx->create_err) {
-		complete(&async->complete);
 		kfree(priv_tx);
 		return;
 	}
@@ -259,11 +253,6 @@ static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
 		i++;
 	}
 
-	for (i = 0; i < size; i++) {
-		struct mlx5e_async_ctx *async = &bulk_async[i];
-
-		wait_for_completion(&async->complete);
-	}
 	mlx5e_bulk_async_cleanup(bulk_async, size);
 }
 
@@ -310,7 +299,6 @@ static void create_work(struct work_struct *work)
 	for (j = 0; j < i; j++) {
 		struct mlx5e_async_ctx *async = &bulk_async[j];
 
-		wait_for_completion(&async->complete);
 		if (!err && async->err)
 			err = async->err;
 	}
-- 
2.38.1

