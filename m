Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBD36D8D35
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbjDFCDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbjDFCDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C1B8A7F
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D64962BFB
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F68C433D2;
        Thu,  6 Apr 2023 02:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746576;
        bh=IPE8ccTgd5oliwHYM0qiaw47kwOluzWnX/FtmOa1fCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsAEBnRwOO7jCGqZRgKKGsyFl7Iay1pCY5FEwA9KUXjqvvCRo1X3gA6BRNV1EGVmW
         wW6JKPHHPv4I3Dobvxzx9RaPd3LLKWU8Tyu1eOSbjrYwWxfUHks5DANTIX6ua3QU6s
         yyrP1Zsv05gqJYSoMbHCBfs3Mlk1K8W9k4cbaCcc1GA32AZn3zF2XxQdpjOWaqynjL
         e+CfLfG+0PDp9AgGCFkhEa10zIzEj8JI90megGWN+/MiQQkbl76+dfTRQWJjaFsxes
         NYiQ1vGhknNSmT3U7r5LnTAhJjt72+Hfb/QIaG0a/SfrsiuTJjz1LpnXahnKCvfjdK
         CCr4oqlnDiw4w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Fix RQ SW state layout in RQ devlink health diagnostics
Date:   Wed,  5 Apr 2023 19:02:31 -0700
Message-Id: <20230406020232.83844-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adham Faris <afaris@nvidia.com>

Remove nesting level before RQ's SW state title and before RQ's SW
state capabilities line.

Preceding the RQ's SW state with a nameless nesting, wraps the inner SW
state map/dictionary with a nameless dictionary which is prohibited in
JSON file format.

Removing preceding SW state nest by removing function call
devlink_fmsg_obj_nest_start() and devlink_fmsg_obj_nest_end().

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index a047a2a4ddac..e8eea9ffd5eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -259,10 +259,6 @@ static int mlx5e_health_rq_put_sw_state(struct devlink_fmsg *fmsg, struct mlx5e_
 
 	BUILD_BUG_ON_MSG(ARRAY_SIZE(rq_sw_state_type_name) != MLX5E_NUM_RQ_STATES,
 			 "rq_sw_state_type_name string array must be consistent with MLX5E_RQ_STATE_* enum in en.h");
-	err = devlink_fmsg_obj_nest_start(fmsg);
-	if (err)
-		return err;
-
 	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SW State");
 	if (err)
 		return err;
@@ -274,11 +270,7 @@ static int mlx5e_health_rq_put_sw_state(struct devlink_fmsg *fmsg, struct mlx5e_
 			return err;
 	}
 
-	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return devlink_fmsg_obj_nest_end(fmsg);
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
 static int
-- 
2.39.2

