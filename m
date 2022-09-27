Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F7C5ECEB0
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiI0UhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiI0Ugm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352C87F0BF
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8CFE61BA0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2001FC433D6;
        Tue, 27 Sep 2022 20:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311000;
        bh=FOYAyEpadhz1GYVqW8Xuy3TnlzZoykbNsZR1D8+pH1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IoKmg0hgWFQsnh1wfLfiQcABuk8/70SK4UT78DGh/77vxF0jVn2AtB87N0IjeGEdE
         uRcNEbOkC6LEiGIaeXDZ+RHKTOgFYk6jtWF55CC5sQY5Gntd+XOneDeyiopz6znGEC
         GQC6iMloV1DIJVrBq6gYgJPReYNJI5hLYCf2tQoIDf+ncFRj8+uhQ0us8ZMxlBxl/U
         JUqgjH9U9NzCduyQAe2Of6oQsDlkHSpbsYVgNY1z51GpVyU4yy4GjHSflL55TwTLbx
         1DVKLjD+eAJLkbGHCU+eNCa8HJKUFSEPykgkZr0OebZoYLK1hYqUOFFLsMzi5m4OG8
         F+NUs2dmcC1FA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 02/16] net/mlx5e: Convert mlx5e_get_max_sq_wqebbs to u8
Date:   Tue, 27 Sep 2022 13:35:57 -0700
Message-Id: <20220927203611.244301-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The return value of mlx5e_get_max_sq_wqebbs is clamped down to
MLX5_SEND_WQE_MAX_WQEBBS = 16, which fits into u8. This commit changes
the return type of this function to u8 for stricter type safety.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 648a178e8db8..05126c6ae13d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -227,10 +227,12 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
  * bytes units. Driver hardens the limitation to 1KB (16
  * WQEBBs), unless firmware capability is stricter.
  */
-static inline u16 mlx5e_get_max_sq_wqebbs(struct mlx5_core_dev *mdev)
+static inline u8 mlx5e_get_max_sq_wqebbs(struct mlx5_core_dev *mdev)
 {
-	return min_t(u16, MLX5_SEND_WQE_MAX_WQEBBS,
-		     MLX5_CAP_GEN(mdev, max_wqe_sz_sq) / MLX5_SEND_WQE_BB);
+	BUILD_BUG_ON(MLX5_SEND_WQE_MAX_WQEBBS > U8_MAX);
+
+	return (u8)min_t(u16, MLX5_SEND_WQE_MAX_WQEBBS,
+			 MLX5_CAP_GEN(mdev, max_wqe_sz_sq) / MLX5_SEND_WQE_BB);
 }
 
 static inline u8 mlx5e_get_sw_max_sq_mpw_wqebbs(u8 max_sq_wqebbs)
-- 
2.37.3

