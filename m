Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDF859C96F
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiHVT7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238252AbiHVT7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7264D4E0
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B690FB818BD
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EFBC43470;
        Mon, 22 Aug 2022 19:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198369;
        bh=KvQFETxeTC4D1AnRiYRykumiyZT5k7XVAd6QqjXSoUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncOS3VKPJG4CmeMJ0jsIMeoJoX0E+3I8Zoc/SQn8L3YdpRPUovosHyIOPLGELxmM/
         KxpPkGr8DUGYiey7F5E6/f3a+QURkFyxqk3iftR4Y6DdLrJ31Y9sbpEjPvY7VnmONh
         C8Zzh5AtQ2s/BAlaV/zkvJ6RzhDfeTA8l8rwjz1/XkScOgk2AscDf93bSLpLklgdbT
         +DDfajMKeni0AQH1Y+FCD4ZuNl4SSY4LmBwd83t9WYNCuWnP6rlr8wwRa7ZeHDWB8P
         Ng4/j9Jprlnigp5ZnTpruB8J2rljFDvKq+/M3YC+ojTr1sy3YkUKUZuf0E88C39LkR
         shux98wa7nSqQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 01/13] net/mlx5e: Properly disable vlan strip on non-UL reps
Date:   Mon, 22 Aug 2022 12:59:05 -0700
Message-Id: <20220822195917.216025-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822195917.216025-1-saeed@kernel.org>
References: <20220822195917.216025-1-saeed@kernel.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

When querying mlx5 non-uplink representors capabilities with ethtool
rx-vlan-offload is marked as "off [fixed]". However, it is actually always
enabled because mlx5e_params->vlan_strip_disable is 0 by default when
initializing struct mlx5e_params instance. Fix the issue by explicitly
setting the vlan_strip_disable to 'true' for non-uplink representors.

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0c66774a1720..759f7d3c2cfd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -662,6 +662,8 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 
 	params->mqprio.num_tc       = 1;
 	params->tunneled_offload_en = false;
+	if (rep->vport != MLX5_VPORT_UPLINK)
+		params->vlan_strip_disable = true;
 
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 }
-- 
2.37.1

