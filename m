Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE6C6A215A
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjBXSTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjBXSTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:19:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600506C52E
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:19:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EDEE2CE2449
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B31BC4339C;
        Fri, 24 Feb 2023 18:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677262758;
        bh=56++HTzMS4jC4ybpRl9aiJ4N0pX9ybBwq7NsZjwFY8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5Xfe/HO1fCotlyV797ntIb7ll3LSUXG9+ktU+rHuW/2WskS+gLe898I8IU7NBycd
         GNJaAmzgETq36WGw1//+2l7ZC4wMX9JMxX1urAnK+XVB8h06m1KNylG26iKqrRRXHo
         Id5CSCOvZlgelkwx2CiNRbC7EWxDDj2Xd+Ej3JdsYsC8EiJ+bq8gvPWWDqdT0Urv3g
         qwCUyx5pR0vwPsAhvOnRj6SmZpgChQ1+XzE2uLfUoYu2WvUTsQ70KOc+pSWcCYJjg1
         4AV03giESnnZlgAtx76daJkyY4nishb9jq7XatDbVmjw3b6egBN7xl/8lQQaxjvk/U
         RvP3dS5sACFcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net V2 6/7] net/mlx5e: Verify flow_source cap before using it
Date:   Fri, 24 Feb 2023 10:19:03 -0800
Message-Id: <20230224181904.671473-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230224181904.671473-1-saeed@kernel.org>
References: <20230224181904.671473-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

When adding send to vport rule verify flow_source matching is
supported by checking the flow_source cap.

Fixes: d04442540372 ("net/mlx5: E-Switch, set flow source for send to uplink rule")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 2a98375a0abf..d766a64b1823 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -869,7 +869,8 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
-	if (rep->vport == MLX5_VPORT_UPLINK)
+	if (MLX5_CAP_ESW_FLOWTABLE(on_esw->dev, flow_source) &&
+	    rep->vport == MLX5_VPORT_UPLINK)
 		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
 
 	flow_rule = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(on_esw),
-- 
2.39.1

