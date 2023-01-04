Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5973065CE11
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbjADILs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjADILn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:11:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555C4193C5;
        Wed,  4 Jan 2023 00:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9749615C1;
        Wed,  4 Jan 2023 08:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCABCC433D2;
        Wed,  4 Jan 2023 08:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672819900;
        bh=4dFaZ4hdpweZVJu6/KjvBVncGBOP+tfZf9gg4dg48/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCKwA0JsoJAcuzsTxDhCzY1iDDU3v7VUeBar+5wbMlC9e4YQsDVx5PE6D0S+UtI1R
         vz5VVQEYm0pZuOpFNMyNvyRWSy3qNiyJe2ODpd2oKkAWks9NFkfDJTD8dfy7xXIKgP
         GHh8qp5nl4j4MMpmigNKX75uU6zbLIexG7ecoQcaLbFXoy9LUWkNK57K1rxxIoBSPs
         xiruSnPN90Gm+xWnGQ3YBrhTo3Oc68rQ9B+SlargdAAIO9UA6sL832eHNmHplSUzsR
         BkoKNQtTr/KEYkZ+cDUVVXDoAawvT/mfPB+/YuCe/0gzsAVJJWMLldQk1XQftNQlwp
         fC3xMDUm2bXVA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 3/4] net/mlx5: Use query_special_contexts for mkeys
Date:   Wed,  4 Jan 2023 10:11:24 +0200
Message-Id: <849b3e708a147a3e2fc94277b805f5cc388f16ab.1672819469.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672819469.git.leonro@nvidia.com>
References: <cover.1672819469.git.leonro@nvidia.com>
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

