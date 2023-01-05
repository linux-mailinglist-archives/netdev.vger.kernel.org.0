Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7D165E9CC
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbjAELYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjAELYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:24:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEB550066;
        Thu,  5 Jan 2023 03:24:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8977CB81A9A;
        Thu,  5 Jan 2023 11:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E05C433F0;
        Thu,  5 Jan 2023 11:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672917842;
        bh=4dFaZ4hdpweZVJu6/KjvBVncGBOP+tfZf9gg4dg48/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJicMpmE3tSGZ7Kn/wcaCaAE7kg5+/9VlSuYz56504PP09H1j+nbiXH7QbgD+zGNC
         KkqhyAghIwW2wU7Z00mKL5YZmUW/Hhgx+kSWhZg6xgJB0EhMyH/Owyg7wSY5RXOxll
         IKVr77rK0xTeASmu4+wQkuZihZymnYHBw9EEdarMCSDfPOnI3lNcPDFL7iN0gEAU5m
         71IMD66KOIz1CsjMuWesM9eGYvlnt+4Ja6geyOUisvpkMmMFhioNNVrDnVLBjnQIo6
         F67bF2+0nr3TD1bpyJF0JEHZUXqDp8KSVcFR9dapHdgXsTFHtvlS47zSJcAZrarue/
         AxfCkNBNdRpeg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v1 3/4] net/mlx5: Use query_special_contexts for mkeys
Date:   Thu,  5 Jan 2023 13:23:47 +0200
Message-Id: <849b3e708a147a3e2fc94277b805f5cc388f16ab.1672917578.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672917578.git.leonro@nvidia.com>
References: <cover.1672917578.git.leonro@nvidia.com>
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

From: Or Har-Toov <ohartoov@nvidia.com>

Using query_sepcial_contexts in order to get the correct value of
terminate_scatter_list_mkey, as FW will change it in some configurations.
This is done one time when the device is loading and the value is being
saved in the device context.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 27 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c76f15505a76..33d7a7095988 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -826,7 +826,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			if (rq->wqe.info.num_frags < (1 << rq->wqe.info.log_num_frags)) {
 				wqe->data[f].byte_count = 0;
 				wqe->data[f].lkey =
-					MLX5_TERMINATE_SCATTER_LIST_LKEY;
+					mdev->terminate_scatter_list_mkey;
 				wqe->data[f].addr = 0;
 			}
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 7f5db13e3550..d39d758744a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1221,6 +1221,28 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 	return 0;
 }
 
+static int mlx5_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
+	int err;
+
+	MLX5_SET(query_special_contexts_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
+	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
+	if (err)
+		return err;
+
+	if (MLX5_CAP_GEN(dev, terminate_scatter_list_mkey)) {
+		dev->terminate_scatter_list_mkey =
+			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
+					     terminate_scatter_list_mkey));
+		return 0;
+	}
+	dev->terminate_scatter_list_mkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
+	return 0;
+}
+
 static int mlx5_load(struct mlx5_core_dev *dev)
 {
 	int err;
@@ -1235,6 +1257,11 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	mlx5_events_start(dev);
 	mlx5_pagealloc_start(dev);
 
+	err = mlx5_get_terminate_scatter_list_mkey(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to query special contexts\n");
+		goto err_irq_table;
+	}
 	err = mlx5_irq_table_create(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to alloc IRQs\n");
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d476255c9a3f..5f2c4038d638 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -801,6 +801,7 @@ struct mlx5_core_dev {
 	struct mlx5_rsc_dump    *rsc_dump;
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
+	__be32			terminate_scatter_list_mkey;
 };
 
 struct mlx5_db {
-- 
2.38.1

