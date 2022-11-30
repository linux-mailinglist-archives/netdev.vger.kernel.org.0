Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15C563CE99
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbiK3FMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbiK3FMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC2E769C8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D2DC6154A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7755C433D7;
        Wed, 30 Nov 2022 05:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785129;
        bh=bA/H6yg00w3XCf3lRidc0U9sEr9eEuUY7+jA2vAo9zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ny0wsisUNr9FkwDARxsbiBRYh5kK7hGyKJyCOgRYHJo+BuTUK3N5I/Sk8p91Uq0wf
         GkEb/9TWhheUuHlJaLTVDdjnnxDR4FZBdyUooIe5tATz2KIfDUpEw3eQuXPJxPG5M5
         pg3tU+fgqPrPDqhUvzOiYsrVRuG/3euaPMQYE4JAC1BYDe2+HArGnzFvASn9opJTu5
         bK5r6afjMD67Zrv/w65dL1OacX0DpDgkAWMhLVUr/iGGpz6poVvCcD7PqPXZs7ZF9P
         VKYBYB3h1AmQJAT75Gq11D//Ovmd4V3GudyelM7qKD5DR3Gm8Mpkss/QAAaTgDJ0Xv
         m2OWkP13UbWzA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: Don't access directly DMA device pointer
Date:   Tue, 29 Nov 2022 21:11:47 -0800
Message-Id: <20221130051152.479480-11-saeed@kernel.org>
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

Use specialized helper to fetch DMA device pointer.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index f900709639f6..7d5a27f7423f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -186,7 +186,7 @@ static int mlx5e_macsec_aso_reg_mr(struct mlx5_core_dev *mdev, struct mlx5e_macs
 		return err;
 	}
 
-	dma_device = &mdev->pdev->dev;
+	dma_device = mlx5_core_dma_dev(mdev);
 	dma_addr = dma_map_single(dma_device, umr->ctx, sizeof(umr->ctx), DMA_BIDIRECTIONAL);
 	err = dma_mapping_error(dma_device, dma_addr);
 	if (err) {
-- 
2.38.1

