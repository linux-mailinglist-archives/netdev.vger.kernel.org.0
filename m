Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B581C6E2C55
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjDNWKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjDNWJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9E2468B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D6BB64A96
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D23C433EF;
        Fri, 14 Apr 2023 22:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510191;
        bh=6xs1KLFr4dAfNKWpV3sav6lkjfjyFewO5xeVRB0xKsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ8NNRm/4i/S8bDay4LS5BkxjKT57nTwwnWhCETkuvPiGZvtK0MWYQIQafXepJha7
         nROgG7I04zJGuxT19oKbeCtpZmR/vMObvMWYcKaFFou2sW2b+lHY1+PiH0Rn1PDC71
         EnAOmI2uytKAPJx9Y5lM6Y6kqrIHEKZv0cZVImyYNn///4S/tzyrTb3DIcGPeF16rn
         aiD+zEkKqJFhypyEkD8f96PRC8kXANIZYSEZ+I2mCs+IPSEe0AJMYeM43eiRj1mRP1
         8b/kVq5ZWp9d4pSVWln+dgpauEJzQlFzv2woS5Yjalm6cme6UVZrrw7y/3bqSRXXlq
         YghluB5/BBl9w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 12/15] net/mlx5: DR, Support decap L3 action using pattern / arg mechanism
Date:   Fri, 14 Apr 2023 15:09:36 -0700
Message-Id: <20230414220939.136865-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Use the new accelerated action for decap L3 on RX side:
use the mechanism of pattern and argument same as in
modify-header action.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 21 +++++--------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 98e3d4f572eb..8f8f0a0b38fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1428,23 +1428,12 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 			return ret;
 		}
 
-		action->rewrite->chunk = mlx5dr_icm_alloc_chunk(dmn->action_icm_pool,
-								DR_CHUNK_SIZE_8);
-		if (!action->rewrite->chunk) {
-			mlx5dr_dbg(dmn, "Failed allocating modify header chunk\n");
-			return -ENOMEM;
-		}
-
-		action->rewrite->data = (void *)hw_actions;
-		action->rewrite->index = (mlx5dr_icm_pool_get_chunk_icm_addr
-					  (action->rewrite->chunk) -
-					 dmn->info.caps.hdr_modify_icm_addr) /
-					 DR_ACTION_CACHE_LINE_SIZE;
+		action->rewrite->data = hw_actions;
+		action->rewrite->dmn = dmn;
 
-		ret = mlx5dr_send_postsend_action(dmn, action);
+		ret = mlx5dr_ste_alloc_modify_hdr(action);
 		if (ret) {
-			mlx5dr_dbg(dmn, "Writing decap l3 actions to ICM failed\n");
-			mlx5dr_icm_free_chunk(action->rewrite->chunk);
+			mlx5dr_dbg(dmn, "Failed preparing reformat data\n");
 			return ret;
 		}
 		return 0;
@@ -2161,7 +2150,7 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 		refcount_dec(&action->reformat->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_TNL_L3_TO_L2:
-		mlx5dr_icm_free_chunk(action->rewrite->chunk);
+		mlx5dr_ste_free_modify_hdr(action);
 		refcount_dec(&action->rewrite->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_L2_TO_TNL_L2:
-- 
2.39.2

