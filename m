Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD896268CE
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbiKLKWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiKLKWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1A721824
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1DDCB8074C
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A87C433C1;
        Sat, 12 Nov 2022 10:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248518;
        bh=nbCB8adIoNrb2incCsAIYS/P3S5xG8mjX1LoPTnmpO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIzX8UBCjGahnXW2jvM9BFa7GHDgVy+kA/iHC/9SbCMM4l28JgLdz3pvhQldnl6dl
         SKalB3p59wEE55STZtPTlyVFrSi5lawSY8rUZOBTPvErfRLT81utcU+YRECokNgfie
         MDDw7m49gc2mAWGeoavbZXeisQQRpor5H2HfQJbn48Pla+K//GIi83SiTcdInr3+Z+
         9oHWAti6TlerUdSQKLAoKtGlY44ltnBCe4lOS/KHWClOADor325393/9rdAJNYwA1T
         nxDpIpCYp64JN3jK+dl3ttEOSKeizbuUpEe1l+OmWtbHsria5PxptNrH7zIeSjGceS
         dF8x2RcgejUSg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Use clamp operation instead of open coding it
Date:   Sat, 12 Nov 2022 02:21:38 -0800
Message-Id: <20221112102147.496378-7-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
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

From: Gal Pressman <gal@nvidia.com>

Replace the min/max operations with a single clamp.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 5a6aa61ec82a..3782f0097292 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1060,12 +1060,9 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 		 hash_hairpin_info(peer_id, match_prio));
 	mutex_unlock(&tc->hairpin_tbl_lock);
 
-	params.log_data_size = 16;
-	params.log_data_size = min_t(u8, params.log_data_size,
-				     MLX5_CAP_GEN(priv->mdev, log_max_hairpin_wq_data_sz));
-	params.log_data_size = max_t(u8, params.log_data_size,
-				     MLX5_CAP_GEN(priv->mdev, log_min_hairpin_wq_data_sz));
-
+	params.log_data_size = clamp_t(u8, 16,
+				       MLX5_CAP_GEN(priv->mdev, log_min_hairpin_wq_data_sz),
+				       MLX5_CAP_GEN(priv->mdev, log_max_hairpin_wq_data_sz));
 	params.log_num_packets = params.log_data_size -
 				 MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(priv->mdev);
 	params.log_num_packets = min_t(u8, params.log_num_packets,
-- 
2.38.1

