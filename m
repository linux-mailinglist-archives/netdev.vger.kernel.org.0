Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E3965867D
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiL1Tnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiL1Tno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8808D10B4D
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39638B818F7
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FA1C433F2;
        Wed, 28 Dec 2022 19:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256620;
        bh=wBuVPp2Xd4pyUvmotfOyamXD8JnK9Og3cK65lbox7dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzBMAUUBEXyLpd8NmZm6uJNThcF3P+TMIvykWKkmfEkhuzpeuCCEv5zteKiJQwFJV
         Ffwo27t4ChHMPBVPS3rc0R0VtKlvEMlztbSWiSrP5heH9XeMtdUZKS1dq9qHpovW6W
         aRg8gF2e7pMwTOSYsbonR7HAvadEXoUJn/PgLFoQ+Jcg45E+X+FgU4CTG5A1K6ypxd
         UDiQddObISFvQYsMhrK55GXcz71YINpOOb0jOsZj3d8oJ0Kl+skZ2QvdBgTWFoJWSt
         bwAuLq2MV+1ysFHgu92NIvtWe/1UaW/ZuHrP3sjKl2816XGm3UB289YtOdC2I8cw/E
         tPHZSMTP8/Jqg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net 02/12] net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path
Date:   Wed, 28 Dec 2022 11:43:21 -0800
Message-Id: <20221228194331.70419-3-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
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

From: Jiri Pirko <jiri@nvidia.com>

There are two cleanup calls missing in mlx5_init_once() error path.
Add them making the error path flow to be the same as
mlx5_cleanup_once().

Fixes: 52ec462eca9b ("net/mlx5: Add reserved-gids support")
Fixes: 7c39afb394c7 ("net/mlx5: PTP code migration to driver core section")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 7f5db13e3550..ec5652f31dda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1050,6 +1050,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 err_tables_cleanup:
 	mlx5_geneve_destroy(dev->geneve);
 	mlx5_vxlan_destroy(dev->vxlan);
+	mlx5_cleanup_clock(dev);
+	mlx5_cleanup_reserved_gids(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 	mlx5_fw_reset_cleanup(dev);
 err_events_cleanup:
-- 
2.38.1

