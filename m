Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CEE532ABF
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbiEXM7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiEXM7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:59:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B5E27FF6;
        Tue, 24 May 2022 05:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF5461553;
        Tue, 24 May 2022 12:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3163C385AA;
        Tue, 24 May 2022 12:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653397173;
        bh=dF6WsElvdz8NKRuBFZaAFyPpO2/jerO09WgcjNmWjOw=;
        h=From:To:Cc:Subject:Date:From;
        b=jUZ8b66lhzpvxDQJ70Bdknu+PkgJ00vy/iXoJBRoUBW2mGef0Xb0Ff4w0uY/dDzdc
         bHFA785lFpQSLGvBBKHB2IQTcJ4t05MbG4et01SXmJdl3b0/9TarpkAK1GOoEgFJek
         SjqW0h6vqD4RSf9NvWCmGVTYbPvxdtVyRUbpQW5ZQg6YcHtH4n+c0WGypSzsjAfKoz
         JCHnlGVdjMoZ02eTBsYNMbbySko1bqsILyPniY52eIUmVgtdIQeG0Lr34XQJqpJd3V
         OYbZuCglualkNWxkgET5emtE7qVKNZOSgMDHHSfmbxgbhpHEuvva093gDoJCGaJysU
         m0Tvjunln0yQg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <markb@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net] net/mlx5: Don't use already freed action pointer
Date:   Tue, 24 May 2022 15:59:27 +0300
Message-Id: <7fe70bbb120422cc71e6b018531954d58ea2e61e.1653397057.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The call to mlx5dr_action_destroy() releases "action" memory. That
pointer is set to miss_action later and generates the following smatch
error:

 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c:53 set_miss_action()
 warn: 'action' was already freed.

Make sure that the pointer is always valid by setting NULL after destroy.

Fixes: 6a48faeeca10 ("net/mlx5: Add direct rule fs_cmd implementation")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 728f81882589..6a9abba92df6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -44,11 +44,10 @@ static int set_miss_action(struct mlx5_flow_root_namespace *ns,
 	err = mlx5dr_table_set_miss_action(ft->fs_dr_table.dr_table, action);
 	if (err && action) {
 		err = mlx5dr_action_destroy(action);
-		if (err) {
-			action = NULL;
-			mlx5_core_err(ns->dev, "Failed to destroy action (%d)\n",
-				      err);
-		}
+		if (err)
+			mlx5_core_err(ns->dev,
+				      "Failed to destroy action (%d)\n", err);
+		action = NULL;
 	}
 	ft->fs_dr_table.miss_action = action;
 	if (old_miss_action) {
-- 
2.36.1

