Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A93D5B1080
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiIGXhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiIGXhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3209AB1B0;
        Wed,  7 Sep 2022 16:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E90F261B0B;
        Wed,  7 Sep 2022 23:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8124C433D7;
        Wed,  7 Sep 2022 23:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593834;
        bh=31f/+Pxmp+jwfUGcUc1AUkGHv0K36aQdL2EuWTaPh4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kofRHSrVSMlqJpKP//tqdmDD3zPYaO6nCN6+syRn3lOMPnfBbxcw2cTElYmdHwMZ2
         hKyz5FhK0idlgb9ATJqBZ9Y32GW2yqeaFF9Jj+tymA+JvpdTEJQX4S2zA+kA722SoX
         GGs+Asfvw54CIYavxjUp7GAojBG+eCShJcpG+SvCvUlmU6BUSTCDNss2bUEZBXCCJN
         D+wOE7mePYefLL1t8hFwnyvk+g5bC4I+RLVk1YhF1gTsKYcqadT2+QA78RAqP2ghne
         YbRcEMFrTywLJiG1gOKXlvA2JU+x9DS7reE9AlsjCzD5/g2w0LMk7LAikUqscRWgfa
         FtCFLcLa2FsEg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        "Liu, Changcheng" <jerrliu@nvidia.com>, Liu@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 06/14] net/mlx5: Lag, enable hash mode by default for all NICs
Date:   Wed,  7 Sep 2022 16:36:28 -0700
Message-Id: <20220907233636.388475-7-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907233636.388475-1-saeed@kernel.org>
References: <20220907233636.388475-1-saeed@kernel.org>
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

From: "Liu, Changcheng" <jerrliu@nvidia.com>

The firmware supports adding a steering rule to catch egress traffic
of the QPs/TISs which are set port affinity explicitly in hash mode.
Enable that mode for NICS with 2 ports as well.

Signed-off-by: Liu, Changcheng <jerrliu@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c   | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index d4d4d1d1e8c7..97c4a525226b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -484,21 +484,22 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 		mlx5_lag_drop_rule_setup(ldev, tracker);
 }
 
-#define MLX5_LAG_ROCE_HASH_PORTS_SUPPORTED 4
 static int mlx5_lag_set_port_sel_mode_roce(struct mlx5_lag *ldev,
 					   unsigned long *flags)
 {
-	struct lag_func *dev0 = &ldev->pf[MLX5_LAG_P1];
+	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 
-	if (ldev->ports == MLX5_LAG_ROCE_HASH_PORTS_SUPPORTED) {
-		/* Four ports are support only in hash mode */
-		if (!MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table))
-			return -EINVAL;
-		set_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, flags);
+	if (!MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table)) {
 		if (ldev->ports > 2)
-			ldev->buckets = MLX5_LAG_MAX_HASH_BUCKETS;
+			return -EINVAL;
+		return 0;
 	}
 
+	if (ldev->ports > 2)
+		ldev->buckets = MLX5_LAG_MAX_HASH_BUCKETS;
+
+	set_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, flags);
+
 	return 0;
 }
 
-- 
2.37.2

