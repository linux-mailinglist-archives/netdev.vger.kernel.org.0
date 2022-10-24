Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7EA60B55C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiJXSWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiJXSVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:21:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54374297F31
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F18C614DE
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F43C433C1;
        Mon, 24 Oct 2022 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666630830;
        bh=KYKuArPRPezhrsnq3FKdgkwpe2SLnUERWpSClufnIX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWjz/xrj5J6cw1BqMOz3LlsaGgozLTq24Qzbg1xLZaV2Qs3xn4qToMUjFLOrbstM+
         GTWhkUj/cq5e02andcdVwe+hqpb9wsdiUI3rSjr+xM5e8YO067zsQtE4xmR05j0bLK
         dTOATQbgDxbkFEVqf9PpEd9HEqwbMaE7qZ/v1rDYim49p/tkeQ3rVGR7Ir0a4T6v+z
         l9SQCtnqxGcIDa4MbsyGSIrA/G/NOrxs/HuX+ZoF3TgtozfCSXEuVYJ1YvHF6A7/kA
         AyIBOfMZ+7fLVsoRKUOc2Qt+mXllIOqmyZ7AbNCi4dO3sYckvlQ9fscToPk09OWhgH
         /zg7UJTg8UOGQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v1 4/6] net/mlx5e: Delete always true DMA check
Date:   Mon, 24 Oct 2022 19:59:57 +0300
Message-Id: <273db342a271c5b658af0684d9de6e67c7f89dc2.1666630548.git.leonro@nvidia.com>
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

DMA address always exists for MACsec ASO object.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c    | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 4831a3e9556c..f1e77ebd8630 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1304,11 +1304,10 @@ static void macsec_aso_build_wqe_ctrl_seg(struct mlx5e_macsec_aso *macsec_aso,
 					  struct mlx5_aso_ctrl_param *param)
 {
 	memset(aso_ctrl, 0, sizeof(*aso_ctrl));
-	if (macsec_aso->umr->dma_addr) {
-		aso_ctrl->va_l  = cpu_to_be32(macsec_aso->umr->dma_addr | ASO_CTRL_READ_EN);
-		aso_ctrl->va_h  = cpu_to_be32((u64)macsec_aso->umr->dma_addr >> 32);
-		aso_ctrl->l_key = cpu_to_be32(macsec_aso->umr->mkey);
-	}
+	aso_ctrl->va_l =
+		cpu_to_be32(macsec_aso->umr->dma_addr | ASO_CTRL_READ_EN);
+	aso_ctrl->va_h = cpu_to_be32((u64)macsec_aso->umr->dma_addr >> 32);
+	aso_ctrl->l_key = cpu_to_be32(macsec_aso->umr->mkey);
 
 	if (!param)
 		return;
-- 
2.37.3

