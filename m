Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B635768E50E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjBHAhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjBHAh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71283F2AE
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6149B61476
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6022C4339B;
        Wed,  8 Feb 2023 00:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816645;
        bh=OluGq8Bp9zF7/VX2LYSQpzMDxBvXfjEGPRUNTJdGZ4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4LEJP/Oie/eSKDbf9XwSO+Pu2VLAJTIoifPCZ28paTsu/sp7zLB1xwfcUgQc5oD1
         dyjrJMoW2HkvQtpwROCovlrbjcaxNcuJBpziMmgA77GJVNwnJKeBU2Orh19yE8ZS7h
         JmjHBs/kkQiEn0+2s9RJYkd8BakcDiLXMoj5R4zHzTL5sDViuC5t3DsVzpFshhypH3
         MZqyr0FCOYo5QuAeMY6A9JdCx0pjndbLGp9mwB6zYDh4STEwYw9W4kmeSoAPWgOwjp
         Owcu0TvJEkSS1yDMBZKjGx3y1wX6XPEivUcPugLx2WDD6I1gNXXFXtWHrSdoTT8K+j
         hS8vS8Ocr1Naw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [net-next 08/15] net/mlx5e: Remove incorrect debugfs_create_dir NULL check in TLS
Date:   Tue,  7 Feb 2023 16:37:05 -0800
Message-Id: <20230208003712.68386-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Remove the NULL check on debugfs_create_dir() return value as the
function returns an ERR pointer on failure, not NULL.
The check is not replaced with a IS_ERR_OR_NULL() as
debugfs_create_file(), and debugfs functions in general don't need error
checking.

Fixes: 0fedee1ae9ef ("net/mlx5e: kTLS, Add debugfs")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index e80b43b7aac9..60b3e08a1028 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -899,8 +899,6 @@ static void mlx5e_tls_tx_debugfs_init(struct mlx5e_tls *tls,
 		return;
 
 	tls->debugfs.dfs_tx = debugfs_create_dir("tx", dfs_root);
-	if (!tls->debugfs.dfs_tx)
-		return;
 
 	debugfs_create_size_t("pool_size", 0400, tls->debugfs.dfs_tx,
 			      &tls->tx_pool->size);
-- 
2.39.1

