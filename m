Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7726C3C79
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCUVLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjCUVLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:11:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF035580C0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 14:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2144B81A37
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 21:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80E5C433D2;
        Tue, 21 Mar 2023 21:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679433098;
        bh=hdyQe9x7dF+xrU8LmN7+GAcqHMHdWV3iQayBwLQk93A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRPfPrTW2nwI0q66YHR6JWt1jF8jBnm/Q3EUuSI8tok6TVPET9zRX7Fl3C7jtvwKK
         plKCSOfnlZC09rmvZeGCVVzSL/vDPzOquRzJzi6xlUAdEyB19phhgxuBj7aplNMFMs
         hYwzFKOdMxF4aptXIVNcf3iJtzc10UnHttU7t0UThM3XZrhyohPbB7kVTerx/iaiLj
         AL5JOtObpbeX3qEOVKgkSY/Pgj3wpvvE1anb4TndjQ85fiDQxzKRojLssuj8IZ9/Fb
         jrMd8XBokYV+Tba7NOFa+dtorlSI39kxVEdaLTtUQ3581PZf2uO3K29hQtrsTF6XQQ
         UafKJRve9z1iw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gavin Li <gavinl@nvidia.com>,
        Gavi Teitz <gavi@nvidia.com>
Subject: [net 2/7] net/mlx5e: Block entering switchdev mode with ns inconsistency
Date:   Tue, 21 Mar 2023 14:11:30 -0700
Message-Id: <20230321211135.47711-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321211135.47711-1-saeed@kernel.org>
References: <20230321211135.47711-1-saeed@kernel.org>
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

From: Gavin Li <gavinl@nvidia.com>

Upon entering switchdev mode, VF/SF representors are spawned in the
devlink instance's net namespace, whereas the PF net device transforms
into the uplink representor, remaining in the net namespace the PF net
device was in. Therefore, if a PF net device's namespace is different from
its parent devlink net namespace, entering switchdev mode can create an
illegal situation where all representors sharing the same core device
are NOT in the same net namespace.

To avoid this issue, block entering switchdev mode for devices whose child
netdev net namespace has diverged from the parent devlink's.

Fixes: 7768d1971de6 ("net/mlx5: E-Switch, Add control for encapsulation")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 22075943bb58..25a8076a77bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3405,6 +3405,18 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
+static bool esw_offloads_devlink_ns_eq_netdev_ns(struct devlink *devlink)
+{
+	struct net *devl_net, *netdev_net;
+	struct mlx5_eswitch *esw;
+
+	esw = mlx5_devlink_eswitch_get(devlink);
+	netdev_net = dev_net(esw->dev->mlx5e_res.uplink_netdev);
+	devl_net = devlink_net(devlink);
+
+	return net_eq(devl_net, netdev_net);
+}
+
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
@@ -3419,6 +3431,13 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
+	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV &&
+	    !esw_offloads_devlink_ns_eq_netdev_ns(devlink)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't change E-Switch mode to switchdev when netdev net namespace has diverged from the devlink's.");
+		return -EPERM;
+	}
+
 	mlx5_lag_disable_change(esw->dev);
 	err = mlx5_esw_try_lock(esw);
 	if (err < 0) {
-- 
2.39.2

