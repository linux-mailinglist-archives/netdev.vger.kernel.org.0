Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82EE4C2014
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244997AbiBWXki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244991AbiBWXkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F095B3EA;
        Wed, 23 Feb 2022 15:39:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7461ECE1CEE;
        Wed, 23 Feb 2022 23:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EFAC340F4;
        Wed, 23 Feb 2022 23:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659581;
        bh=x9UKmK3BgZIxNfogmE7vYver6vDTrTChZ2LUN6NFRl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwzvnJe3RoWT2SmcMRttkpsvSGDJq2+kwDZkHHA3fnGigJDw0CN5/B6G1WBHMgXiu
         qSZTOEtWVkSJmYLDyHtAHhpbmTrNMSERITPlEZpHG/ov6ajV6myLGeTsHuvmBTdAxs
         bv83jWzGEGQWHrMrS3rCgbAfvZ9M/37vCZWd6v02DlW9VDBRMZRfYw/vtURKRD3tFF
         MmN//YQHi4rpds86aNzlJ2bwiRwnC4lNhdrnCg6Kj2X9VZSHY+7p3lsHH/dz1Qcb4v
         qB8ojQhuDivXjzmHXrQWL2iwFqE5XYdmCar13a8d2Q/WgmrQcBZOihp2tN7sZjMwuW
         mHk0avta87qtQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 07/17] net/mlx5: Lag, don't use magic numbers for ports
Date:   Wed, 23 Feb 2022 15:39:20 -0800
Message-Id: <20220223233930.319301-8-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
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

From: Mark Bloch <mbloch@nvidia.com>

Instead of using 1 & 2 as the ports numbers use an enum value.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 0758a98a08d1..05e8cbece095 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -40,6 +40,11 @@
 #include "lag.h"
 #include "mp.h"
 
+enum {
+	MLX5_LAG_EGRESS_PORT_1 = 1,
+	MLX5_LAG_EGRESS_PORT_2,
+};
+
 /* General purpose, use for short periods of time.
  * Beware of lock dependencies (preferably, no locks should be acquired
  * under it).
@@ -193,15 +198,15 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 	p2en = tracker->netdev_state[MLX5_LAG_P2].tx_enabled &&
 	       tracker->netdev_state[MLX5_LAG_P2].link_up;
 
-	*port1 = 1;
-	*port2 = 2;
+	*port1 = MLX5_LAG_EGRESS_PORT_1;
+	*port2 = MLX5_LAG_EGRESS_PORT_2;
 	if ((!p1en && !p2en) || (p1en && p2en))
 		return;
 
 	if (p1en)
-		*port2 = 1;
+		*port2 = MLX5_LAG_EGRESS_PORT_1;
 	else
-		*port1 = 2;
+		*port1 = MLX5_LAG_EGRESS_PORT_2;
 }
 
 static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 v2p_port1, u8 v2p_port2)
-- 
2.35.1

