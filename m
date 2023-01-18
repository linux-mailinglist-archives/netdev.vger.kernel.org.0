Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D19672721
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjARSgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjARSgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F6059571
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C4CCB81EA5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25317C433EF;
        Wed, 18 Jan 2023 18:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066974;
        bh=eUYC4XXjLDnv2N/PqVknPGx3CSOfbtgVMV5fbCpXQ/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBRAIHS9enTB39bJi0OAOBkNYvI9m0mqcFfBsugQ9CCm0HtTFpD1o54tLdhkz/U1S
         eqIY4RZ2drumhPGH7te0OHk0TxgHaHFDpsDV/csrp5BEb9+PrXKE2XYhNBghcRpx1V
         HC4v8o8Kcn8mA1EnYdUaJQxxYPjudzMPUEsEmwluCEK2cT8rHuH5gSJkqvGwfUFrKE
         E5H9nCWuNKaLlTwyGUojS7dTqxUfpCIlaju0WOjt7Jb/30Q49bXMnYqacPIacHV4EK
         3CYaMiDjcyoF70t7VsUrO1h/2MMhWXiXJbVx8k2PPl8PLWCR710YcXV5/GYYdtwzjA
         ksWno3SSGfrUA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Add warning when log WQE size is smaller than log stride size
Date:   Wed, 18 Jan 2023 10:35:54 -0800
Message-Id: <20230118183602.124323-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
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

From: Adham Faris <afaris@nvidia.com>

Add warning macro in the function mlx5e_mpwqe_get_log_num_strides()
when log WQE size is smaller than log stride size. Theoretically this
should not happen.

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index a17b768b81f1..53d2979e9457 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -411,9 +411,14 @@ u8 mlx5e_mpwqe_get_log_num_strides(struct mlx5_core_dev *mdev,
 {
 	enum mlx5e_mpwrq_umr_mode umr_mode = mlx5e_mpwrq_umr_mode(mdev, xsk);
 	u8 page_shift = mlx5e_mpwrq_page_shift(mdev, xsk);
-
-	return mlx5e_mpwrq_log_wqe_sz(mdev, page_shift, umr_mode) -
-		mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
+	u8 log_wqe_size, log_stride_size;
+
+	log_wqe_size = mlx5e_mpwrq_log_wqe_sz(mdev, page_shift, umr_mode);
+	log_stride_size = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
+	WARN(log_wqe_size < log_stride_size,
+	     "Log WQE size %u < log stride size %u (page shift %u, umr mode %d, xsk on? %d)\n",
+	     log_wqe_size, log_stride_size, page_shift, umr_mode, !!xsk);
+	return log_wqe_size - log_stride_size;
 }
 
 u8 mlx5e_mpwqe_get_min_wqe_bulk(unsigned int wq_sz)
-- 
2.39.0

