Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A15963736F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiKXILk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiKXIL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:11:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C656BE0CA2
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:11:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 890CAB82702
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302DCC433C1;
        Thu, 24 Nov 2022 08:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277466;
        bh=FPY03y/IbCPbe3qw2bwxhOOBhlXpr3yMAUGIsZ2sKmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LU30bts9pfsA7YGU5Tq2r9mhVC1gSuhk2GQXkWvtKMOuRCbJMmB1aAdBBqgEeFe7l
         YN2HWT7jZPpFoQpTJ7OX6VzI8DCukN3ADaF+hNj3+1CZn+asXLBa86KGhpiCvTKBI1
         Qf1l6nkak1pDRrV6VmxRbBXuVS3mfyk9AQA8OB/NzG050dUs1x9ttAMXIXOCHn/YNi
         skmO8l/IZ4HRCzFQVZdls+6a0ZNRaP3attwDTii9TKmDuFW+41OMXiILc9dpz+fMy4
         pC72tXBHUdFM9tDCSh/A4PjHyys275SC7h+g3kRQmlCTXgN9W4Ifbr7Bs3N+il7yAN
         3aMhIVW/bXzMg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [net 13/15] net/mlx5e: MACsec, remove replay window size limitation in offload path
Date:   Thu, 24 Nov 2022 00:10:38 -0800
Message-Id: <20221124081040.171790-14-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124081040.171790-1-saeed@kernel.org>
References: <20221124081040.171790-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Currently offload path limits replay window size to 32/64/128/256 bits,
such a limitation should not exist since software allows it.
Remove such limitation.

Fixes: eb43846b43c3 ("net/mlx5e: Support MACsec offload replay window")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c         | 16 ----------------
 include/linux/mlx5/mlx5_ifc.h                    |  7 -------
 2 files changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index c19581f1f733..72f8be65fa90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -229,22 +229,6 @@ static int macsec_set_replay_protection(struct mlx5_macsec_obj_attrs *attrs, voi
 	if (!attrs->replay_protect)
 		return 0;
 
-	switch (attrs->replay_window) {
-	case 256:
-		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_256BIT;
-		break;
-	case 128:
-		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_128BIT;
-		break;
-	case 64:
-		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_64BIT;
-		break;
-	case 32:
-		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_32BIT;
-		break;
-	default:
-		return -EINVAL;
-	}
 	MLX5_SET(macsec_aso, aso_ctx, window_size, window_sz);
 	MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_REPLAY_PROTECTION);
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5a4e914e2a6f..981fc7dfa408 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11611,13 +11611,6 @@ enum {
 	MLX5_MACSEC_ASO_REPLAY_PROTECTION = 0x1,
 };
 
-enum {
-	MLX5_MACSEC_ASO_REPLAY_WIN_32BIT  = 0x0,
-	MLX5_MACSEC_ASO_REPLAY_WIN_64BIT  = 0x1,
-	MLX5_MACSEC_ASO_REPLAY_WIN_128BIT = 0x2,
-	MLX5_MACSEC_ASO_REPLAY_WIN_256BIT = 0x3,
-};
-
 #define MLX5_MACSEC_ASO_INC_SN  0x2
 #define MLX5_MACSEC_ASO_REG_C_4_5 0x2
 
-- 
2.38.1

