Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFB863CE9B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbiK3FNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiK3FMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A557614B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616FB619FF
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6A8C433D7;
        Wed, 30 Nov 2022 05:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785131;
        bh=UPv3jEz/GpFGWHAcr+PkdIYOdbpiI3rUM1ZMCGsNiCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzpeKX9EmiSciD9pC7eFsbSlkbToEBDyjoqUOaXjxIhrPWGWn6o7fZkeDPk9igah3
         sKBqRy9QlozsY81zOc5GmDdyi2f2lppise7plYb5hSq08oEsDPLyQQEpJzc/tLvRpW
         DS9V+Dv/8p40DYPHQk3Rln0+9V3Vy9CPpiXlVy6HVDa2fMhBU1U7NSpbRcY6RXQj7v
         r0DmCq7GsyDh+Aho25kJdkko99qi98w1celAWbclJRpuMNelOxxlX2xHWpuDWmHmLK
         U99UrYJioNJHeP124awIUneXzr32go9i7fzFyB3FwwfEDXMIYUe8zPoC5n7HE0zJ8+
         3RHW/ZpjF+nxA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Remove redundant check
Date:   Tue, 29 Nov 2022 21:11:49 -0800
Message-Id: <20221130051152.479480-13-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

If ASO failed in creation, it won't be called to destroy either.
The kernel coding pattern is to make sure that callers are calling
to destroy only for valid objects.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index c971ff04dd04..0f9e4f01c85a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -334,9 +334,6 @@ struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn)
 
 void mlx5_aso_destroy(struct mlx5_aso *aso)
 {
-	if (IS_ERR_OR_NULL(aso))
-		return;
-
 	mlx5_aso_destroy_sq(aso);
 	mlx5_aso_destroy_cq(&aso->cq);
 	kfree(aso);
-- 
2.38.1

