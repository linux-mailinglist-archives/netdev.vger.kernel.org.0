Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407C14C0B73
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbiBWFKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbiBWFKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:10:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8A3652DE;
        Tue, 22 Feb 2022 21:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA64160C16;
        Wed, 23 Feb 2022 05:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7C1C36AE2;
        Wed, 23 Feb 2022 05:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593014;
        bh=x9UKmK3BgZIxNfogmE7vYver6vDTrTChZ2LUN6NFRl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBCLJeYeM8jjqnB7f+P6f2xOni5nzA+anQAGa6nQQuEsW1EDoWwyhqgXbhFY9pg24
         R2HOZkOs34jMV5Ol04hqKCJrWWRPZFTt1JVCAPgloJAC6b37vkgWj4WKC5jWGzjBhc
         fNTYlIr0KTH/JtpSUSBf3md+2BefKmmdcXHdI2CctVrUssHkOq1w+/96RBr7gkfz/6
         hRvf2qPkvVFXfxohua71zPrCrYgJm0E1robw1iUaNGkTG9YNhus/YCtgVECSl9FX3T
         utBIOe6HXFHd87gYfD2/AVLC0FLR3+9ZWKbkqxh0V8ksJQFS/K5FMasI8oydrPtiVy
         9nffzYXJ5W/2g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [mlx5-next 07/17] net/mlx5: Lag, don't use magic numbers for ports
Date:   Tue, 22 Feb 2022 21:09:22 -0800
Message-Id: <20220223050932.244668-8-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223050932.244668-1-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
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

