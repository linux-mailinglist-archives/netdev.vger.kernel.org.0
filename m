Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FC16716A2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjARIxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjARIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:52:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6117C9CBB5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 354C0616FD
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E60CC433EF;
        Wed, 18 Jan 2023 08:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029077;
        bh=wnRvOBT4Pzl4T2d6s9fHMgisL5cs8t0g6zjlugBR6G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nH3WI9Dt14KTgokVLO0DV9RaYcVu0pWRkhkLBRIv5MrE/oDowhlk5wI7W8p5lb2iu
         E3riPGaqDkcnWCekqgdxFC8POr/dI839ppkPYbJxXBm5yu/CzvtJtiohLgKphyCrVh
         C5c7qNqL9L6Si1JdwWwLqgKKpdtkEu71FAgeYe0kPY90S/HYg/wjkbbffVEvNOWGoV
         PBs7o5oRx8+en4AD7usu11QawLvVCarEsrPLutoA0v4tz1boaMX8xtTuaX/HiQtp03
         56zPZojOPWRtfYJu6TP6dR5lA+9ix09DCg6dav3mJcdFJPk/FgYc00m9unbygY6dax
         B2jWfLJfyp7AA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net 08/10] net/mlx5e: Protect global IPsec ASO
Date:   Wed, 18 Jan 2023 00:04:12 -0800
Message-Id: <20230118080414.77902-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118080414.77902-1-saeed@kernel.org>
References: <20230118080414.77902-1-saeed@kernel.org>
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

ASO operations are global to whole IPsec as they share one DMA address
for all operations. As such all WQE operations need to be protected with
lock. In this case, it must be spinlock to allow mlx5e_ipsec_aso_query()
operate in atomic context.

Fixes: 1ed78fc03307 ("net/mlx5e: Update IPsec soft and hard limits")
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h   | 2 ++
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c   | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 160f8883b93e..8bed9c361075 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -122,6 +122,8 @@ struct mlx5e_ipsec_aso {
 	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 	dma_addr_t dma_addr;
 	struct mlx5_aso *aso;
+	/* Protect ASO WQ access, as it is global to whole IPsec */
+	spinlock_t lock;
 };
 
 struct mlx5e_ipsec {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index aafbd7b244ee..2461462b7b99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -396,6 +396,7 @@ int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec)
 		goto err_aso_create;
 	}
 
+	spin_lock_init(&aso->lock);
 	ipsec->nb.notifier_call = mlx5e_ipsec_event;
 	mlx5_notifier_register(mdev, &ipsec->nb);
 
@@ -454,10 +455,12 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 	struct mlx5e_hw_objs *res;
 	struct mlx5_aso_wqe *wqe;
 	u8 ds_cnt;
+	int ret;
 
 	lockdep_assert_held(&sa_entry->x->lock);
 	res = &mdev->mlx5e_res.hw_objs;
 
+	spin_lock_bh(&aso->lock);
 	memset(aso->ctx, 0, sizeof(aso->ctx));
 	wqe = mlx5_aso_get_wqe(aso->aso);
 	ds_cnt = DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS);
@@ -472,7 +475,9 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 	mlx5e_ipsec_aso_copy(ctrl, data);
 
 	mlx5_aso_post_wqe(aso->aso, false, &wqe->ctrl);
-	return mlx5_aso_poll_cq(aso->aso, false);
+	ret = mlx5_aso_poll_cq(aso->aso, false);
+	spin_unlock_bh(&aso->lock);
+	return ret;
 }
 
 void mlx5e_ipsec_aso_update_curlft(struct mlx5e_ipsec_sa_entry *sa_entry,
-- 
2.39.0

