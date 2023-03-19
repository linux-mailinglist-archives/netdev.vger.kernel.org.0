Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AA66C01E5
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 14:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjCSNAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 09:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjCSNAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 09:00:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298821F903;
        Sun, 19 Mar 2023 06:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B6FDB80B92;
        Sun, 19 Mar 2023 12:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5017FC433EF;
        Sun, 19 Mar 2023 12:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679230789;
        bh=NpdR/c+XS1nAlwTk2Z9WvH6MAHJDRRHN4AvWpg/CeHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vlk5w1DB38Ru0G+yMFDzmhGPjPFEoqwzI79WHkEBBz2/usSA4oyWAyao18eK+FIop
         mws1EnyKk4noxEinnX2i5MZvYI0gB/3Ih6uMrgtI5fMF78nSVhP89JYEZBlbAkI0j1
         uLvjSemrVHiv0D/iNeWQwLlR4yTBbzx5s7FFXIkrGir9RzP5dyojj8bfdxY+tlq8dF
         eOCyITVpbBCU6cu5khHxOdysrg7M5c6sIOltXkWBTzyDKjSbQlTON8MEJ/yPgFhCYf
         MPnIhsGAqUFJ9/uV/cfW+U0dHT7NqpMd7u8KyYhercJUdGEpbCu1tl/TDgGZqaGufS
         /OtMsovlQhtsg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 2/3] RDMA/mlx5: Disable out-of-order in integrity enabled QPs
Date:   Sun, 19 Mar 2023 14:59:31 +0200
Message-Id: <362de42cdc7a541afa5b1fd0ec6ae706061764a2.1679230449.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1679230449.git.leon@kernel.org>
References: <cover.1679230449.git.leon@kernel.org>
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

Set retry_mode to GO_BACK_N when qp is created with INTEGRITY_EN flag
because out-of-order is not supported when doing HW offload of signature
operations.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f04adc18e63b..d32b644885b3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -60,6 +60,10 @@ enum raw_qp_set_mask_map {
 	MLX5_RAW_QP_RATE_LIMIT			= 1UL << 1,
 };
 
+enum {
+	MLX5_QP_RM_GO_BACK_N			= 0x1,
+};
+
 struct mlx5_modify_raw_qp_param {
 	u16 operation;
 
@@ -2521,6 +2525,10 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (qp->flags & IB_QP_CREATE_IPOIB_UD_LSO)
 		MLX5_SET(qpc, qpc, ulp_stateless_offload_mode, 1);
 
+	if (qp->flags & IB_QP_CREATE_INTEGRITY_EN &&
+	    MLX5_CAP_GEN(mdev, go_back_n))
+		MLX5_SET(qpc, qpc, retry_mode, MLX5_QP_RM_GO_BACK_N);
+
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 	kvfree(in);
 	if (err)
-- 
2.39.2

