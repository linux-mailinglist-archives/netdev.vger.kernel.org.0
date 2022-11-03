Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1B6176F6
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiKCG4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiKCG4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:56:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9341098
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 23:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D8CEB82682
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 06:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAF5C433D7;
        Thu,  3 Nov 2022 06:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667458565;
        bh=Lo8jrs1lmJ3QoGyxf8HZxETLFlIIBGD29oWUrjTRWf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYb/CPTDTkLBE6d98WfRibm3u+qsp8f8rVUHN3xiEBB9wReE+lhN/Y1j5XHVVwMB1
         WYGa8dwTGoeEePTQEs3J+Qc/iuNDK+4NHr+TlWwyIrFMPXNt9pI33aYBy2mQD+uOKs
         5nk1h+Z9ywDrO3zKOXwN42ukjmNJAFzruo4nbfy2oYGmwukxI7xLn3RY4BDUGn96m4
         A4Ys1rWPd7jEQ4VDTjbb0hiYtkGGVg9HfAx6zP8K0ubIiOrZHqff3P1L34N8o/B4ZC
         pCuVVEC5WcMBPQmzyDx5zKnnU16uHHGxtt8MJt+MSWPwvub78Kkeufg6FAO1o9rw+L
         Jk7c0D4IEsfDg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net 01/11] net/mlx5: Bridge, verify LAG state when adding bond to bridge
Date:   Wed,  2 Nov 2022 23:55:37 -0700
Message-Id: <20221103065547.181550-2-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221103065547.181550-1-saeed@kernel.org>
References: <20221103065547.181550-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Mlx5 LAG is initialized asynchronously on a workqueue which means that for
a brief moment after setting mlx5 UL representors as lower devices of a
bond netdevice the LAG itself is not fully initialized in the driver. When
adding such bond device to a bridge mlx5 bridge code will not consider it
as offload-capable, skip creating necessary bookkeeping and fail any
further bridge offload-related commands with it (setting VLANs, offloading
FDBs, etc.). In order to make the error explicit during bridge
initialization stage implement the code that detects such condition during
NETDEV_PRECHANGEUPPER event and returns an error.

Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 39ef2a2561a3..8099a21e674c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -164,6 +164,36 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	return err;
 }
 
+static int
+mlx5_esw_bridge_changeupper_validate_netdev(void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct net_device *upper = info->upper_dev;
+	struct net_device *lower;
+	struct list_head *iter;
+
+	if (!netif_is_bridge_master(upper) || !netif_is_lag_master(dev))
+		return 0;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		struct mlx5_core_dev *mdev;
+		struct mlx5e_priv *priv;
+
+		if (!mlx5e_eswitch_rep(lower))
+			continue;
+
+		priv = netdev_priv(lower);
+		mdev = priv->mdev;
+		if (!mlx5_lag_is_active(mdev))
+			return -EAGAIN;
+		if (!mlx5_lag_is_shared_fdb(mdev))
+			return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 						unsigned long event, void *ptr)
 {
@@ -171,6 +201,7 @@ static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
+		err = mlx5_esw_bridge_changeupper_validate_netdev(ptr);
 		break;
 
 	case NETDEV_CHANGEUPPER:
-- 
2.38.1

