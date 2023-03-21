Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82246C3C74
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjCUVLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCUVLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:11:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F0157D35
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 14:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 729B6B81A3E
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 21:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B154C433A0;
        Tue, 21 Mar 2023 21:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679433100;
        bh=p/p33At2klrA/IcrqTwWIbz3rg4gn0S5yPOQjgFIlJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uxc5zicvjNKHFmz7K0bdEYLdEK642ejTvGTDbR0ugqEmzCvYxVaGHx6fJQdxiQkBQ
         HyQQwrMpiMWfW6JDtTk9xAEMU27gDbkniZjwHeyH4nh31IgJ8evXeXS/3Rjrq/zhOv
         YmVirSfRvqIsf45n2ZSsS6PXXcqOBb15EVFByXEh/pUvV5hmUfTdvjmejlT3/J2cpH
         aqvvd/f/EIV0bMOWBt7uvn4u/LR79b1UZ2G3tRb6hnRovk5hOKodshgyCsLGBcX91h
         0BC+ocXbBwjw3tTa/O67DaOq00RNisvoFQjk/pXUUY4p3QealKWi4+fFUx1QfterJE
         0Ak0nuqeTTXiQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Roy Novich <royno@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net 4/7] net/mlx5e: Initialize link speed to zero
Date:   Tue, 21 Mar 2023 14:11:32 -0700
Message-Id: <20230321211135.47711-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321211135.47711-1-saeed@kernel.org>
References: <20230321211135.47711-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roy Novich <royno@nvidia.com>

mlx5e_port_max_linkspeed does not guarantee value assignment for speed.
Avoid cases where link_speed might be used uninitialized. In case
mlx5e_port_max_linkspeed fails, a default link speed of 50000 will be
used for the calculations.

Fixes: 3f6d08d196b2 ("net/mlx5e: Add RSS support for hairpin")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6bfed633343a..87a2850b32d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1103,8 +1103,8 @@ static void
 mlx5e_hairpin_params_init(struct mlx5e_hairpin_params *hairpin_params,
 			  struct mlx5_core_dev *mdev)
 {
+	u32 link_speed = 0;
 	u64 link_speed64;
-	u32 link_speed;
 
 	hairpin_params->mdev = mdev;
 	/* set hairpin pair per each 50Gbs share of the link */
-- 
2.39.2

