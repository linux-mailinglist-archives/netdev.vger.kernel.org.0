Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3380E60B6CE
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiJXTLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiJXTKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:10:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A33B170B52
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DD9CB81612
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F359C433C1;
        Mon, 24 Oct 2022 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666630813;
        bh=oTQX8U0CkCI1jZO7NeZVpll2bILxaj0l8QSH7FuhFX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e09kOQL3DYOYrESJY7M3LSDJxH+J3rkdy2jjjcxpUE2znCQPj+lDGsRDKg8FI+/tX
         COb9GzxRP3N0QALwKK5Sw8E9WD4pHxGTkwcuy1VW03FYgjFE6LcXTrOW13esRYp/T3
         h2+Tl/OvkJWXRRYB9ZcBSt9F1+Yku6JtG2Z1p4dLwhUbup6zpvoWfDuGo+c01EZNOu
         qiXaeuhDGTJ9MXyHOZVt/Bo/1ixqL+RfA6SZBlzZUD5cnHLOkp6Gn251gB49gAZgXq
         hFSO60zXATLFU9+myLGtDRcAk1tGhJAFF97T2cOK4lXyAjHn1u8jmr3VFr58OSlNVz
         S3vmDerdvepNw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v1 3/6] net/mlx5e: Don't access directly DMA device pointer
Date:   Mon, 24 Oct 2022 19:59:56 +0300
Message-Id: <071cded0707097f130a1f241d29effd3f8681f52.1666630548.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666630548.git.leonro@nvidia.com>
References: <cover.1666630548.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Use specialized helper to fetch DMA device pointer.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 41970067917b..4831a3e9556c 100644
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
2.37.3

