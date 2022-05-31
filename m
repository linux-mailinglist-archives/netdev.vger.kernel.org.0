Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5866B539848
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245211AbiEaUzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243676AbiEaUzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:55:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474F69CF71
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7432B816BF
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F834C3411D;
        Tue, 31 May 2022 20:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654030504;
        bh=GjJNQU//wx0PbaEfMI0ICViHZB7MPwpvObHnp9yMb8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLC/81VaPmRr2bxCs295X8V2rhPABX21tr3XQXawBbXI2RrAxumXZ7dFvWFxBj3+N
         +sfQuACPPpnIGW0hdx3PIkgEVFfG9ygs3QIoMqWCuYcMb36c2rxk3XkmgS8h66vbJe
         V2QH4RtbVb8IOKQetyzgQP3qgBvRVjc49/ZZ/rMGdh/OLJugt8VQceFc567wOOrvO2
         3Co9kbb9GUAUvj19aOGWP5br4VhuU7lDZrugJdaEYlKcemjmBxzlM9qCHgvT13LJSF
         wuoiGX1ol72SejFUQBjtkcJj+QkSp4suQvYJv8LTcBvhc9eY+ZhM/dtilAlCq4iYm4
         z86DETB38A+Tg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/7] net/mlx5: Don't use already freed action pointer
Date:   Tue, 31 May 2022 13:54:41 -0700
Message-Id: <20220531205447.99236-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531205447.99236-1-saeed@kernel.org>
References: <20220531205447.99236-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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

