Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE424C207A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245193AbiBXANI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245177AbiBXAMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28755F4F7
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74AEBB82290
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED67C340F1;
        Thu, 24 Feb 2022 00:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661541;
        bh=GbgUYw0DQ6LPVgl013/4MQTvKvBIo5lc7tUJAISsTi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=revRvJiM42li69jbmrgCLdxB9lmFkUZcALwz4IrGz7CdsGpvxRoFQs2xG4g5+OdmH
         Yq38juYh1tZ21cijn5Kt/yRYBzbX7jq7D66zoaNzzQq9XbqINeOBi9t0ap+xDwrad/
         CHpF9yNWLXilDCG47oqeX0okufl3/LWYUJscgEmSUteh/vDgm6eNmWNnZVvKTOM1sk
         3OkzjX310dt1YWu/VY9AXROE9w5OFcPhzFbrJYvgcWwZn71voXCXSTay1gHuFgMgwd
         oMAfqJ4oO9BuMHS7EweAUqiMWZvfPupA8lXSH/Hx0Gz97vfhTBDBH6NArJR3itO1h4
         7ycVVtlX6TpRA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 07/19] net/mlx5: Fix wrong limitation of metadata match on ecpf
Date:   Wed, 23 Feb 2022 16:11:11 -0800
Message-Id: <20220224001123.365265-8-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
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

From: Ariel Levkovich <lariel@nvidia.com>

Match metadata support check returns false for ecpf device.
However, this support does exist for ecpf and therefore this
limitation should be removed to allow feature such as stacked
devices and internal port offloaded to be supported.

Fixes: 92ab1eb392c6 ("net/mlx5: E-Switch, Enable vport metadata matching if firmware supports it")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9a7b25692505..cfcd72bad9af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2838,10 +2838,6 @@ bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 	if (!MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
 		return false;
 
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev) ||
-	    mlx5_ecpf_vport_exists(esw->dev))
-		return false;
-
 	return true;
 }
 
-- 
2.35.1

