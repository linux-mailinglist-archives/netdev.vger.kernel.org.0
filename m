Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B772366DE77
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbjAQNPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbjAQNPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:15:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6990F367F4;
        Tue, 17 Jan 2023 05:15:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E68BB61376;
        Tue, 17 Jan 2023 13:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03E1C433D2;
        Tue, 17 Jan 2023 13:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673961304;
        bh=2+NmVEcQa5bnhwLKzO22URIPMlVqVTfeTvuEk8//NW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nP10jLkQ4WoFy8E/OHd2Maek82H1hYM4cJuJy35UJ6gi3qZ9Bhaa4Y0K/VSacFxql
         FRFbVD1J/yg+HFinGgjZLylz8pMZ9ukUj6pblmKeONmtmyNppJARz26Y7Q4ZRcH4A3
         tUFxVLaMMgfaV4HHKzRbqDbb0NC+NJysVA5h8DqitY6a0aayw9jKx9nCLVdu0OkfDW
         q8sGDSU7B4X/D+0Lhjildvn2M9X+Pq4+uNx7g/U8w5bUyz+8ilUQGGFWiHQbbNI4j6
         8d5tj6UI+VrXUaI4iEnE4wKAq38TRMF9+kR8iXi3TlwWdNfC32TRSRHkqdXf/zaN6N
         X0M6biTO99cdw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v2 3/4] net/mlx5e: Use query_special_contexts for mkeys
Date:   Tue, 17 Jan 2023 15:14:51 +0200
Message-Id: <fff70d94258233effb0e34f3d62cb08a692f5af5.1673960981.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673960981.git.leon@kernel.org>
References: <cover.1673960981.git.leon@kernel.org>
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

Use query_sepcial_contexts in order to get the correct value of
terminate_scatter_list_mkey, as FW will change it for certain
configurations.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index db4e66c38395..de7ab0911b30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -661,6 +661,26 @@ static void mlx5e_rq_free_shampo(struct mlx5e_rq *rq)
 	mlx5e_rq_shampo_hd_free(rq);
 }
 
+static __be32 mlx5e_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
+	int res;
+
+	if (!MLX5_CAP_GEN(dev, terminate_scatter_list_mkey))
+		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
+
+	MLX5_SET(query_special_contexts_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
+	res = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
+	if (res)
+		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
+
+	res = MLX5_GET(query_special_contexts_out, out,
+		       terminate_scatter_list_mkey);
+	return cpu_to_be32(res);
+}
+
 static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
 			  struct mlx5e_rq_param *rqp,
@@ -825,8 +845,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			/* check if num_frags is not a pow of two */
 			if (rq->wqe.info.num_frags < (1 << rq->wqe.info.log_num_frags)) {
 				wqe->data[f].byte_count = 0;
-				wqe->data[f].lkey =
-					MLX5_TERMINATE_SCATTER_LIST_LKEY;
+				wqe->data[f].lkey = mlx5e_get_terminate_scatter_list_mkey(mdev);
 				wqe->data[f].addr = 0;
 			}
 		}
-- 
2.39.0

