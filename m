Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4BD67271B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjARSgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjARSgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ED956880
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3FEF6199C
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA0BC433D2;
        Wed, 18 Jan 2023 18:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066969;
        bh=MRcHZCfiDuYQ8YB3khMafB1SR5hogkRI5CI5VgK7sYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnsPb9xV0Pi6Vm8TrwOi55SdobSgt12Or/xK91t12uM1sLmEKfr6QpsdGHPsOwelL
         bUx21q8tNNQkWQPm6Hs6xGabiV+8TDxeZg3kEZ5vJw8jeqflOxNsOQIpS5RKDiMTWO
         EJCRCYcBBpmVvmdDjfVUzN0dUMRPy/cgjSZ3/WXRi37JmMBfumzT+0kvxkycXCday7
         Xx2MSdCoGM9w2bFfeDGnGAt43aBgLyA5KhzRmJR7WUSKKzfmgZ1L20/Uz6Ncl4xC3i
         KE2DlLWJAP/OsKyuN7mbD8xYG+pltdhH12eUPryKFoSLtOpc+x5STGzVA9XQpD/8tL
         MLPqcVMiHX8qw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Suppress error logging on UCTX creation
Date:   Wed, 18 Jan 2023 10:35:49 -0800
Message-Id: <20230118183602.124323-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

Suppress error logging that can be triggered by userspace upon DEVX UCTX
creation.

The reason that it's not suppressed today with the uid check to suppress
DEVX is that MLX5_CMD_OP_CREATE_UCTX command still doesn't have a uid as
it comes to create it..

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index c3c8a7148723..382d02f6619c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -813,7 +813,8 @@ static void cmd_status_print(struct mlx5_core_dev *dev, void *in, void *out)
 	op_mod = MLX5_GET(mbox_in, in, op_mod);
 	uid    = MLX5_GET(mbox_in, in, uid);
 
-	if (!uid && opcode != MLX5_CMD_OP_DESTROY_MKEY)
+	if (!uid && opcode != MLX5_CMD_OP_DESTROY_MKEY &&
+	    opcode != MLX5_CMD_OP_CREATE_UCTX)
 		mlx5_cmd_out_err(dev, opcode, op_mod, out);
 }
 
-- 
2.39.0

