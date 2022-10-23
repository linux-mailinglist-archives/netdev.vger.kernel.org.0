Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17DE609522
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 19:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJWRXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 13:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiJWRXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 13:23:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0B36EF22
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 10:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B57A7B80BA4
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 17:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67E1C433D6;
        Sun, 23 Oct 2022 17:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666545801;
        bh=5f/vo3lD4aj6GUVNDP2M0RaiddL1sztGtnfA3jea7TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZGTSW5uXd2qXIBaUCmQwRAiv7ppYlmWJ6GbU9Pqat/X91BFp1JSDgK87jR5r3PVi
         0wtk66BMFYniyKH3wU/fsIOghyGHyN5EwGg4iGbCaD6pEFr0cCwpZSx7kYgpmW2+b4
         8J8ClKv7IEblkL1oauTObabZwV52VLn8hzKCq7h+hOaBJZtancAEY9qgx0fo4goJft
         qRNtfRO4/B0T6p9NymlhN2JfPfNnZRFBczfKj9kSs6hiBvUYyJyAX/Wz8rY4NBfEqx
         vx5g3Ta14Fm2/nxbOYHfyEUTlMHXiddnmbaYeL+pfnvo6R4c8DhCK0Z/49kLn4VK5m
         EdaFlsWEyPmdA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 5/6] net/mlx5: Remove redundant check
Date:   Sun, 23 Oct 2022 20:22:57 +0300
Message-Id: <01b2995cbd049e1cef2b2ba32c25488c51f28b1e.1666545480.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666545480.git.leonro@nvidia.com>
References: <cover.1666545480.git.leonro@nvidia.com>
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

