Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BA86C3C73
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCUVLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCUVLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:11:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C6F580C8
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 14:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D89361DDF
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 21:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42FEC433EF;
        Tue, 21 Mar 2023 21:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679433100;
        bh=/MAKJVBeHEGyIp3pL4cofO3nKzxeTszy26JPUDZpeP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4AlsKaY9qls/KvbI5fOcyyG4k7F0mKCGlHixOWHa1ywfvnXmrXQFr2VvYMBI5acN
         RGuzb1F+qcQ+/Osv0ekAbj1uV0Xu55bxpR09aH6p9f2DG9He9xTcdow+fCUs1OacEI
         Sv08+Omo7MJn3B3qaQkXAXshT+jk/CxY09ll8e3KpiBxRplgAtUL8ppLQ11vLr7zYw
         FCPvP4eJEEBLIWyTPthIvpy9I9GBI43Yt/soOhnFGqBbAAhT/sgLxzgYVXLIof8kpe
         oYDN6qhGtsXZp+F0MEoIz++nmNGBMa814/+MtPMbMu8N7jR3f+J3Vaa76Nq5Mw7aWY
         g4hTTjAfsiwTw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [net 5/7] net/mlx5e: Overcome slow response for first macsec ASO WQE
Date:   Tue, 21 Mar 2023 14:11:33 -0700
Message-Id: <20230321211135.47711-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321211135.47711-1-saeed@kernel.org>
References: <20230321211135.47711-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

First ASO WQE poll causes a cache miss in hardware hence the resut is
delayed. It causes to the situation where such WQE is polled earlier
than it is needed.

Add logic to retry ASO CQ polling operation.

Fixes: 739cfa34518e ("net/mlx5: Make ASO poll CQ usable in atomic context") 
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c    | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 8af53178e40d..33b3620ea45c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1412,6 +1412,7 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	struct mlx5e_macsec_aso *aso;
 	struct mlx5_aso_wqe *aso_wqe;
 	struct mlx5_aso *maso;
+	unsigned long expires;
 	int err;
 
 	aso = &macsec->aso;
@@ -1425,7 +1426,13 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	macsec_aso_build_wqe_ctrl_seg(aso, &aso_wqe->aso_ctrl, NULL);
 
 	mlx5_aso_post_wqe(maso, false, &aso_wqe->ctrl);
-	err = mlx5_aso_poll_cq(maso, false);
+	expires = jiffies + msecs_to_jiffies(10);
+	do {
+		err = mlx5_aso_poll_cq(maso, false);
+		if (err)
+			usleep_range(2, 10);
+	} while (err && time_is_after_jiffies(expires));
+
 	if (err)
 		goto err_out;
 
-- 
2.39.2

