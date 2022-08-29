Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153825A45A5
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiH2JCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiH2JCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:02:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D475A2E5;
        Mon, 29 Aug 2022 02:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53C49B80DB2;
        Mon, 29 Aug 2022 09:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F31C433D6;
        Mon, 29 Aug 2022 09:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661763763;
        bh=SISLwQwAfFl63GeAIKOLuaRtfad0UF1rvZTb7/MS7z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9J2HMTGxzf6emQhsn/ttaJaqYYiZaO+J229UZzUbrrOhYt/N3KCFkOPsWIP3FhDH
         +4PHdH+naDKVraLm0QmpXRPKnzSOGo9zdl91kutN77VJin49yPYN6PgoQ5ELt/5oxy
         1wYGLX+CFT2u4Fy/tjYNCaL60V/b2rauk9zs+HrsOk6inclScmj/8ome1TFv0vg7Re
         Pic4alRsVwRLVE5w4xIfLjN3lLx7Da6UFJlE02GVUiSlA2DuLNRivlhUbohmTorwHQ
         Dz00X/PFqv4Sahxs8LwzBsOq2yk7gQAEowNn/g0bxIZ9Mw4Qy31JrB69unxmRXFFNv
         J0CqTyUJlAhBA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        linux-rdma@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: [PATCH rdma-rc 3/3] RDMA/mlx5: Fix UMR cleanup on error flow of driver init
Date:   Mon, 29 Aug 2022 12:02:29 +0300
Message-Id: <4cfa61386cf202e9ce330e8d228ce3b25a36326e.1661763459.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661763459.git.leonro@nvidia.com>
References: <cover.1661763459.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

The cited commit removed from the cleanup flow of umr the checks
if the resources were created. This could lead to null-ptr-deref
in case that we had failure in mlx5_ib_stage_ib_reg_init stage.

Fix it by adding new state to the umr that can say if the resources
were created or not and check it in the umr cleanup flow before
destroying the resources.

Fixes: 04876c12c19e ("RDMA/mlx5: Move init and cleanup of UMR to umr.c")
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 +
 drivers/infiniband/hw/mlx5/umr.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2e2ad3918385..e66bf72f1f04 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -708,6 +708,7 @@ struct mlx5_ib_umr_context {
 };
 
 enum {
+	MLX5_UMR_STATE_UNINIT,
 	MLX5_UMR_STATE_ACTIVE,
 	MLX5_UMR_STATE_RECOVER,
 	MLX5_UMR_STATE_ERR,
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index e00b94d1b1ea..d5105b5c9979 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -177,6 +177,7 @@ int mlx5r_umr_resource_init(struct mlx5_ib_dev *dev)
 
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
 	mutex_init(&dev->umrc.lock);
+	dev->umrc.state = MLX5_UMR_STATE_ACTIVE;
 
 	return 0;
 
@@ -191,6 +192,8 @@ int mlx5r_umr_resource_init(struct mlx5_ib_dev *dev)
 
 void mlx5r_umr_resource_cleanup(struct mlx5_ib_dev *dev)
 {
+	if (dev->umrc.state == MLX5_UMR_STATE_UNINIT)
+		return;
 	ib_destroy_qp(dev->umrc.qp);
 	ib_free_cq(dev->umrc.cq);
 	ib_dealloc_pd(dev->umrc.pd);
-- 
2.37.2

