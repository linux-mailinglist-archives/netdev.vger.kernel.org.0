Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CEB6C1ED4
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjCTSA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjCTSAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:00:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B965246
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64C9BB8105D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009E7C433EF;
        Mon, 20 Mar 2023 17:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334718;
        bh=37GxE1TJetOX1d1Su89sfzF3/vwczVRU0d2mrMHouSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOMHNHxjIXrAK9ap2sh163CbpokLqNlM1p4XxeJB0QRK6yDEGqGZy/xh2W87AkApg
         vBDTuM2Omrgrc21TeWu1dkI+fyTCbnsf2mq+6mxHizsAh9iqb4tgHiOi8tNodDTsgS
         1TvrE8UVGDKqDZtOJV41r9coKN8bNhJGk8U80VU8g6DvlLMRrLCVdqx98XkelIuyrd
         9kw4uNAZtRKyGWw//uHTQvyojto28K4tduy8Dd4wX32oA905IXS8Jl3nrxFFO0gWDw
         C4SRHQ6FAYfYsKGNiS1JRLRxm3m6mx0GTxn+C8kJJCt41u7pk2ar4qDmkhIwePS+Qn
         kTbmjPE2SZ4rA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [net-next 12/14] net/mlx5: Refactor calculation of required completion vectors
Date:   Mon, 20 Mar 2023 10:51:42 -0700
Message-Id: <20230320175144.153187-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320175144.153187-1-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Move the calculation to a separate function. We will add more
functionality to it in a follow up patch.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 28 +++++++++++++-------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 888ccfcbcce6..66696c935cc5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1113,26 +1113,34 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 #define MLX5_MAX_ASYNC_EQS 3
 #endif
 
-int mlx5_eq_table_create(struct mlx5_core_dev *dev)
+static int get_num_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
-	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
+	int max_dev_eqs;
+	int max_eqs_sf;
+	int num_eqs;
+
+	max_dev_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
 		      MLX5_CAP_GEN(dev, max_num_eqs) :
 		      1 << MLX5_CAP_GEN(dev, log_max_eq);
-	int max_eqs_sf;
-	int err;
 
-	eq_table->num_comp_eqs =
-		min_t(int,
-		      mlx5_irq_table_get_num_comp(eq_table->irq_table),
-		      num_eqs - MLX5_MAX_ASYNC_EQS);
+	num_eqs = min_t(int, mlx5_irq_table_get_num_comp(eq_table->irq_table),
+			max_dev_eqs - MLX5_MAX_ASYNC_EQS);
 	if (mlx5_core_is_sf(dev)) {
 		max_eqs_sf = min_t(int, MLX5_COMP_EQS_PER_SF,
 				   mlx5_irq_table_get_sfs_vec(eq_table->irq_table));
-		eq_table->num_comp_eqs = min_t(int, eq_table->num_comp_eqs,
-					       max_eqs_sf);
+		num_eqs = min_t(int, num_eqs, max_eqs_sf);
 	}
 
+	return num_eqs;
+}
+
+int mlx5_eq_table_create(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
+	int err;
+
+	eq_table->num_comp_eqs = get_num_eqs(dev);
 	err = create_async_eqs(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to create async EQs\n");
-- 
2.39.2

