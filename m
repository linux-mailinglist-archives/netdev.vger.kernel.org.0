Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBAB52C254
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 20:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbiERSaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241422AbiERSae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:30:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41322268A2;
        Wed, 18 May 2022 11:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E836188A;
        Wed, 18 May 2022 18:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE951C34100;
        Wed, 18 May 2022 18:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652898631;
        bh=QoG7IaVCnM3Dd14OvQDZrEZ69vO2NwP3iRox95LMaV4=;
        h=From:To:Cc:Subject:Date:From;
        b=iIbm72hrJaZkK0ywbpe/4kIU2z3KRyycpen6SeVXgwX6P93Jt8qaTXdi9iC3BpIOs
         XEGKdkC1R40iSigNmD1lKIezTa8WEqFbYH5Y1yHM0Hrrur0LqRCYGArMTdBUPQrHKG
         D399g6vDsjE1sA1p6neZ8eOYDSHvm4z//UqIKQzs5eUVyJpFETvMv8ZNh5iVoZMtLl
         47iTXMEPTCtG1JE74UXHeH3foDQq4haJDwp2vAr8aYAei27mCH/aRV3JYVulK+0vyq
         yK+BZ7NnMBU1yDWJN7iOmNha3HMnPePesc0E4gzZjZOc6A9ZHm4G50x87dpcio6jnD
         YMNT8+XhD73Qw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, saeedm@nvidia.com,
        leon@kernel.org, elic@nvidia.com, mbloch@nvidia.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: fix multiple definitions of mlx5_lag_mpesw_init / mlx5_lag_mpesw_cleanup
Date:   Wed, 18 May 2022 11:30:22 -0700
Message-Id: <20220518183022.2034373-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

static inline is needed in the header.

Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: saeedm@nvidia.com
CC: leon@kernel.org
CC: elic@nvidia.com
CC: mbloch@nvidia.com
CC: linux-rdma@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index d39a02280e29..be4abcb8fcd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -19,8 +19,8 @@ bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev);
 void mlx5_lag_mpesw_init(struct mlx5_lag *ldev);
 void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev);
 #else
-void mlx5_lag_mpesw_init(struct mlx5_lag *ldev) {}
-void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev) {}
+static inline void mlx5_lag_mpesw_init(struct mlx5_lag *ldev) {}
+static inline void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev) {}
 #endif
 
 #endif /* __MLX5_LAG_MPESW_H__ */
-- 
2.34.3

