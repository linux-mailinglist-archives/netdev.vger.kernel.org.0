Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631B559C975
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbiHVUAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238569AbiHVT7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB4A4D837
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E11D261268
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399FEC433C1;
        Mon, 22 Aug 2022 19:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198379;
        bh=YmL9XWm36n9j8YPo256TbgX5aye1LDvUNZmxb1IVCUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhQ+CqSH7CHcuj3VQ6n6VmaXsJ5lHImjycfO8PN2HJCDt5wlxz0bhKtknmDA6XlSt
         5run2aZ46OGrrgYUH5arbfyMMjg/YcdMfj2OQ5n9NdQl2ANPvtcxMdZk8AMysvxdY/
         0UNAq4pJDO4tENbwOeZzy5RQKhLh7cXB+Bem/C1OBgHOoqWV3btgtD3g9tP7jMK5zm
         HvLglfTBFyfLKaVLYFEZMfZhWTchgolxqq+SjAtK6fxd46Obne5oijNwwf7cbHQc1f
         dN8V8JQuPnhGD2Bp0xwIbdIZs/kXjw29bHWy94SGXJcoWBC3VMx33+ipYPkOn7izU1
         KMrrk9AX92RGg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net 11/13] net/mlx5e: kTLS, Use _safe() iterator in mlx5e_tls_priv_tx_list_cleanup()
Date:   Mon, 22 Aug 2022 12:59:15 -0700
Message-Id: <20220822195917.216025-12-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822195917.216025-1-saeed@kernel.org>
References: <20220822195917.216025-1-saeed@kernel.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

Use the list_for_each_entry_safe() macro to prevent dereferencing "obj"
after it has been freed.

Fixes: c4dfe704f53f ("net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX connections")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 0aef69527226..3a1f76eac542 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -246,7 +246,7 @@ static void mlx5e_tls_priv_tx_cleanup(struct mlx5e_ktls_offload_context_tx *priv
 static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
 					   struct list_head *list, int size)
 {
-	struct mlx5e_ktls_offload_context_tx *obj;
+	struct mlx5e_ktls_offload_context_tx *obj, *n;
 	struct mlx5e_async_ctx *bulk_async;
 	int i;
 
@@ -255,7 +255,7 @@ static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
 		return;
 
 	i = 0;
-	list_for_each_entry(obj, list, list_node) {
+	list_for_each_entry_safe(obj, n, list, list_node) {
 		mlx5e_tls_priv_tx_cleanup(obj, &bulk_async[i]);
 		i++;
 	}
-- 
2.37.1

