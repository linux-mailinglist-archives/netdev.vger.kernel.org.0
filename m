Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408C060B559
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiJXSVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiJXSVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:21:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E3BD03BD
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5A0FB81597
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5618C433D7;
        Mon, 24 Oct 2022 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666630822;
        bh=5f/vo3lD4aj6GUVNDP2M0RaiddL1sztGtnfA3jea7TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLYZbpPWD0n/+8JkcguWKs4jQ87a1hivxosKQF+qUuFa83AeLzzPxb6lWIOxeTR23
         t9X5Rkov7rRMQXQK7OoUNl3ZShj0LDDyVb5/bgpfieXu47swKMMsn0qe7H1JmKOML+
         PukK5xDf7Yx0NladGB7sM/CmCEP++FE9mGIx0VTxlcsjPYaaeb3uXmbpF7roftH16H
         9Z3/7rMF1y/hv1Hn6EXZ3jAYZa9b5rqH7ONBDuX8DycsFlg6GTUvNOb19DAoGeF1N7
         BkGaMwIIWh371/uoFZDhROTrUSaVnkao+PorYM5JwSQ6R+CBm4F5uRPiMkjsIdq0qF
         p95hifgaCiGlA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v1 5/6] net/mlx5: Remove redundant check
Date:   Mon, 24 Oct 2022 19:59:58 +0300
Message-Id: <cbfa5552ff8be3888ca197277042eaecefc125ea.1666630548.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666630548.git.leonro@nvidia.com>
References: <cover.1666630548.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index 88655d5746d6..87605f142a20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -327,9 +327,6 @@ struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn)
 
 void mlx5_aso_destroy(struct mlx5_aso *aso)
 {
-	if (IS_ERR_OR_NULL(aso))
-		return;
-
 	mlx5_aso_destroy_sq(aso);
 	mlx5_aso_destroy_cq(&aso->cq);
 	kfree(aso);
-- 
2.37.3

