Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA853637361
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiKXILH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiKXIK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:10:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F010D33AD
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:10:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CCF2B826A8
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA71C433B5;
        Thu, 24 Nov 2022 08:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277455;
        bh=seKAZu9UxjNwWT8mUtYWSuzi/4ZZbwxv6buA2Utm9HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+V9ZpBDpC+plV15/V4KBi6nChVjobu3zCIdbNYP2pa9mzKC2fFlHk19XjvJi+xEW
         5ALLBzCnAvbS+VOcEP5R98wmE7s4ka5aGNgQevDD0qReXFRUHg6wGkxnea1ahw0Wr+
         I5iorGlI0x7tYzv7kkW52vHbpLEonf4OA6OE8G36dvYbGitMCUi71GytBLyuZiewsP
         Pprjb7PG9Yyek5Eep9SOgYNzSgpBov63U0t1SFRkvxlp6+ji1WRuAaWlYqBbdDXa2L
         0ITZxo7XrYi7Dj56Z1x2T925GGR1OFLi4DHr5ZI63rLOCvvAdr2C/zjqRaqE7CBN3F
         5fT3921Ru2how==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [net 03/15] net/mlx5: E-switch, Fix duplicate lag creation
Date:   Thu, 24 Nov 2022 00:10:28 -0800
Message-Id: <20221124081040.171790-4-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124081040.171790-1-saeed@kernel.org>
References: <20221124081040.171790-1-saeed@kernel.org>
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

From: Chris Mi <cmi@nvidia.com>

If creating bond first and then enabling sriov in switchdev mode,
will hit the following syndrome:

mlx5_core 0000:08:00.0: mlx5_cmd_out_err:778:(pid 25543): CREATE_LAG(0x840) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x7d49cb), err(-22)

The reason is because the offending patch removes eswitch mode
none. In vf lag, the checking of eswitch mode none is replaced
by checking if sriov is enabled. But when driver enables sriov,
it triggers the bond workqueue task first and then setting sriov
number in pci_enable_sriov(). So the check fails.

Fix it by checking if sriov is enabled using eswitch internal
counter that is set before triggering the bond workqueue task.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index f68dc2d0dbe6..3029bc1c0dd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -736,6 +736,14 @@ void mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
 					      struct mlx5_eswitch *slave_esw);
 int mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw);
 
+static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
+{
+	if (mlx5_esw_allowed(esw))
+		return esw->esw_funcs.num_vfs;
+
+	return 0;
+}
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index be1307a63e6d..4070dc1d17cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -701,8 +701,9 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 
 #ifdef CONFIG_MLX5_ESWITCH
 	dev = ldev->pf[MLX5_LAG_P1].dev;
-	if ((mlx5_sriov_is_enabled(dev)) && !is_mdev_switchdev_mode(dev))
-		return false;
+	for (i = 0; i  < ldev->ports; i++)
+		if (mlx5_eswitch_num_vfs(dev->priv.eswitch) && !is_mdev_switchdev_mode(dev))
+			return false;
 
 	mode = mlx5_eswitch_mode(dev);
 	for (i = 0; i < ldev->ports; i++)
-- 
2.38.1

