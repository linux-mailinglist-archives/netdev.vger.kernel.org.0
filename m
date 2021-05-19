Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56E238948B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 19:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355582AbhESRTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 13:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242519AbhESRTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 13:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB96611BF;
        Wed, 19 May 2021 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621444712;
        bh=7WjsEPGoZSWVF4YbuqWyKb/tvPko4f2xvq8XMuoDxx4=;
        h=From:To:Cc:Subject:Date:From;
        b=bUaWx/8E8FAnRNBmcn6yqtTN7OKq4mn5RtBMSPFC+19j9FkQSoMY3RTWdzJtZ81R0
         6O0iPj3XyOvbMeTm7wMy7rqQsRTlgihKGco+qqCtHYrxOpWud/7MQrPbU+xzIsWpXt
         fiCXNSGKmHzXJ92DyZouyl78ZvuNlRMlZm96+QjhoUc+iK2kx2jepNcsL8nw0dtwYE
         sk153wlAmP1hK1TaL+vTqbVVI/wA9QkpDLKe3waAxWdcnoIh0RxsRZTdl3o+VkMBx5
         uBkt9A76ZLbB+BzuDDTq39k5Um4QNaC1M6Gu45W7gwYPN51A6F0DyPuFQZSxDhfzfE
         ALYRz6gX/lrBw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@nvidia.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] mlx5: count all link events
Date:   Wed, 19 May 2021 10:18:25 -0700
Message-Id: <20210519171825.600110-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5 devices were observed generating MLX5_PORT_CHANGE_SUBTYPE_ACTIVE
events without an intervening MLX5_PORT_CHANGE_SUBTYPE_DOWN. This
breaks link flap detection based on Linux carrier state transition
count as netif_carrier_on() does nothing if carrier is already on.
Make sure we count such events.

netif_carrier_event() increments the counters and fires the linkwatch
events. The latter is not necessary for the use case but seems like
the right thing to do.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c  |  6 +++++-
 include/linux/netdevice.h                      |  2 +-
 net/sched/sch_generic.c                        | 18 ++++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bca832cdc4cb..5a67ebc0c96c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -91,12 +91,16 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 port_state;
+	bool up;
 
 	port_state = mlx5_query_vport_state(mdev,
 					    MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT,
 					    0);
 
-	if (port_state == VPORT_STATE_UP) {
+	up = port_state == VPORT_STATE_UP;
+	if (up == netif_carrier_ok(priv->netdev))
+		netif_carrier_event(priv->netdev);
+	if (up) {
 		netdev_info(priv->netdev, "Link up\n");
 		netif_carrier_on(priv->netdev);
 	} else {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..be1dcceda5e4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4187,8 +4187,8 @@ unsigned long dev_trans_start(struct net_device *dev);
 void __netdev_watchdog_up(struct net_device *dev);
 
 void netif_carrier_on(struct net_device *dev);
-
 void netif_carrier_off(struct net_device *dev);
+void netif_carrier_event(struct net_device *dev);
 
 /**
  *	netif_dormant_on - mark device as dormant.
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 44991ea726fc..3090ae32307b 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -515,6 +515,24 @@ void netif_carrier_off(struct net_device *dev)
 }
 EXPORT_SYMBOL(netif_carrier_off);
 
+/**
+ *	netif_carrier_event - report carrier state event
+ *	@dev: network device
+ *
+ * Device has detected a carrier event but the carrier state wasn't changed.
+ * Use in drivers when querying carrier state asynchronously, to avoid missing
+ * events (link flaps) if link recovers before it's queried.
+ */
+void netif_carrier_event(struct net_device *dev)
+{
+	if (dev->reg_state == NETREG_UNINITIALIZED)
+		return;
+	atomic_inc(&dev->carrier_up_count);
+	atomic_inc(&dev->carrier_down_count);
+	linkwatch_fire_event(dev);
+}
+EXPORT_SYMBOL_GPL(netif_carrier_event);
+
 /* "NOOP" scheduler: the best scheduler, recommended for all interfaces
    under all circumstances. It is difficult to invent anything faster or
    cheaper.
-- 
2.31.1

