Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1AF39AB9F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFCUNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhFCUNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34F6B613B4;
        Thu,  3 Jun 2021 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751120;
        bh=zZkuiZRZx9Wxgz9ZV4hbAm+til9lU8a6A5+laT0LCVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzGPhGDN4m/OXDolJJglHYee0WDNAxEBqKoKU91js1JIKD0oEscqBSgLJxfh+TEJ8
         HtGATmv0sTNNrHfkP4SkEhVt+CVNjdmREwG/Mc/pYZeiHuc5hYdNV/fgnYIVeCblpu
         N+MVYgO5V6hmb7lqgK1tImRhDI1GaPd+JBOzoLg5L4UNoxNnxOcBuGG5XREa5ZuAte
         k2KWuiIXSJPK4mH6uPVWczx0QNeNm/3OXGqG/zwByGBHk/uwsQNZMZ53BVDJIGkI9f
         XQd/Zgp+N7ToGTzFwtYUGXzUCj3oOX/a316xmL0inWPph1Hibi5aB+ijAFEp656S0P
         ERPwq7oqZTVQA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/10] mlx5: count all link events
Date:   Thu,  3 Jun 2021 13:11:46 -0700
Message-Id: <20210603201155.109184-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

mlx5 devices were observed generating MLX5_PORT_CHANGE_SUBTYPE_ACTIVE
events without an intervening MLX5_PORT_CHANGE_SUBTYPE_DOWN. This
breaks link flap detection based on Linux carrier state transition
count as netif_carrier_on() does nothing if carrier is already on.
Make sure we count such events.

netif_carrier_event() increments the counters and fires the linkwatch
events. The latter is not necessary for the use case but seems like
the right thing to do.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c  |  6 +++++-
 include/linux/netdevice.h                      |  2 +-
 net/sched/sch_generic.c                        | 18 ++++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ad0f69480b9c..e36d0c6a08db 100644
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
index fc8b56bcabf3..e9c0afc8becc 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -540,6 +540,24 @@ void netif_carrier_off(struct net_device *dev)
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

