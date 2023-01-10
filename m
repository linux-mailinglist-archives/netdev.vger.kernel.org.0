Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B407A66391E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjAJGMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjAJGMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:12:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8301343DAA
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2C1AB81113
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5CDC433D2;
        Tue, 10 Jan 2023 06:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331110;
        bh=h8XP2Q4Dksv5lMCjLah3hQhiyd8VKWAJpWFks4s5YxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYydGBsawtudm9v0CmEX6rC4KQx4cNZHPhqhbXtnkbDoTRUNgNvXaTLsCPiD0W5c5
         4LSSeH9dBwr9uTHAl4m9lmzZkSgq7SCNNMuJ9EsriTkDxQktfkl57TJFo7+DZqs9lK
         tv79HqkGQLxabMczigTzC5V/4JjOGqDDRwV6iMPFviHVzP3Cw7dlUn3+zYE+trsfA8
         x6Vy1mHebTo6QuVQmBLSOCQ7XeGSilb8zcHAk/JZQtSYfNZcl4IJItPZkTN+dJZbM5
         o8PitKY71N2uC6MzeXRjYFLtQJeQMw/bcROc92Kwm9wDPl1FVVbw2zyRsxvWQtQ6Tr
         31xGTuGpewlig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: [net 14/16] net/mlx5: E-switch, Coverity: overlapping copy
Date:   Mon,  9 Jan 2023 22:11:21 -0800
Message-Id: <20230110061123.338427-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

From: Shay Drory <shayd@nvidia.com>

When a capability is set via port function caps callbacks, a memcpy() is
performed in which the source and the target are the same address, e.g.:
the copy is redundant. Hence, Remove it.
Discovered by Coverity.

Fixes: 7db98396ef45 ("net/mlx5: E-Switch, Implement devlink port function cmds to control RoCE")
Fixes: e5b9642a33be ("net/mlx5: E-Switch, Implement devlink port function cmds to control migratable")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 75b77dd2392b..c981fa77f439 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4143,8 +4143,6 @@ int mlx5_devlink_port_fn_migratable_set(struct devlink_port *port, bool enable,
 	}
 
 	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
-	memcpy(hca_caps, MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability),
-	       MLX5_UN_SZ_BYTES(hca_cap_union));
 	MLX5_SET(cmd_hca_cap_2, hca_caps, migratable, 1);
 
 	err = mlx5_vport_set_other_func_cap(esw->dev, hca_caps, vport->vport,
@@ -4236,8 +4234,6 @@ int mlx5_devlink_port_fn_roce_set(struct devlink_port *port, bool enable,
 	}
 
 	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
-	memcpy(hca_caps, MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability),
-	       MLX5_UN_SZ_BYTES(hca_cap_union));
 	MLX5_SET(cmd_hca_cap, hca_caps, roce, enable);
 
 	err = mlx5_vport_set_other_func_cap(esw->dev, hca_caps, vport_num,
-- 
2.39.0

