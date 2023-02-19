Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBDA69BF53
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBSJJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 04:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjBSJJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:09:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2301164D
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 01:09:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3532760B99
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 09:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F40EC433D2;
        Sun, 19 Feb 2023 09:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676797755;
        bh=lC++uI91e0aV/wBy1FIC2dCBJellUsk+eQB1T5vRwzg=;
        h=From:To:Cc:Subject:Date:From;
        b=PUK/KVvA+S7R06Yeq+1GJqv2brRFHdYlr+8KZDGpU8G93dBQTfL0g2QgdJVFw0nlt
         Xe+uqCsgOzms08Sb90XfyuCBsM9TmAjkTpgfNxLvDvOqyM/kQ2fICKKC4PRubU9xFW
         Q9iy19NO88li/NFFHIML1i/F20v228FUncK5J1rDCka2wr4yUGds9HnVfrlZzhNpwl
         N6tWRZ2kTVsV2WQUcrMvORVMy7ahJzR+j7ZngTdXRGcx66jV96c13e8PmwEnxWjcvv
         NkmhUN6HIwOsjTCG979aLE3aV42lkRcPg1gaLzRQRVd14ITnbb4qEuY8gsqsQg/tS8
         FVYK8pjPkcPQQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next] net/mlx5e: Align IPsec ASO result memory to be as required by hardware
Date:   Sun, 19 Feb 2023 11:09:10 +0200
Message-Id: <de0302c572b90c9224a72868d4e0d657b6313c4b.1676797613.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
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

Hardware requires an alignment to 64 bytes to return ASO data. Missing
this alignment caused to unpredictable results while ASO events were
generated.

Fixes: 8518d05b8f9a ("net/mlx5e: Create Advanced Steering Operation object for IPsec")
Reported-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index ddd7be05f18f..12f044330639 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -129,7 +129,7 @@ struct mlx5e_ipsec_work {
 };
 
 struct mlx5e_ipsec_aso {
-	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
+	u8 __aligned(64) ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 	dma_addr_t dma_addr;
 	struct mlx5_aso *aso;
 	/* Protect ASO WQ access, as it is global to whole IPsec */
-- 
2.39.2

