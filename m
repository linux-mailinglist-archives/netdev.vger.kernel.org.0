Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AF942A52F
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbhJLNRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236669AbhJLNRh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:17:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 866DF610E5;
        Tue, 12 Oct 2021 13:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634044536;
        bh=ShXewwk9XmtEBV+Jg/SLujaUg6Q60SlaOQ6ZIztVLnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuurzaPpWooAzEqkYT/aFhItBVm6pvxGTar5SyHEdYlBhvN1DwOx0oc2k+i05U/wC
         sKVPF1JDDacnwY5IaU6+PoZ7mHPrCJoGrg9WBxsbteXjbkDLql7pY9sO9tdo4eLoeZ
         yeK3f9uH+0zWL0cLLiiHp+gBDciKcspaVjkxIN7QEFvPi3nEOihgZwOFhvaeZ9/D8X
         pZjMHRe74UGbXFZFBHxd/nCJ4lBa1QIWTEkmOscVudIaWVVjEnms7Is/UohVuoD0ZF
         o9RIiLj5BzZMUUzWUx9dnuaoqpxBNn+5K1g0jVKUnr40o0M9VJvXj0vsBDDQNHPrpR
         M0eCTE1/pnwjA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v4 1/6] devlink: Reduce struct devlink exposure
Date:   Tue, 12 Oct 2021 16:15:21 +0300
Message-Id: <7e75e60ba8b3ea90e7838832149e154056f47f8b.1634044267.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634044267.git.leonro@nvidia.com>
References: <cover.1634044267.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The declaration of struct devlink in general header provokes the
situation where internal fields can be accidentally used by the driver
authors. In order to reduce such possible situations, let's reduce the
namespace exposure of struct devlink.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h |  2 +-
 include/net/devlink.h                       | 54 ++--------------
 include/trace/events/devlink.h              | 72 ++++++++++-----------
 net/core/devlink.c                          | 57 ++++++++++++++++
 4 files changed, 98 insertions(+), 87 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
index 7654841a05c2..e6475ea77cd1 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
@@ -19,7 +19,7 @@ struct mlxfw_dev {
 static inline
 struct device *mlxfw_dev_dev(struct mlxfw_dev *mlxfw_dev)
 {
-	return mlxfw_dev->devlink->dev;
+	return devlink_to_dev(mlxfw_dev->devlink);
 }
 
 #define MLXFW_PRFX "mlxfw: "
diff --git a/include/net/devlink.h b/include/net/devlink.h
index a7852a257bf6..ae03eb1c6cc9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -21,45 +21,7 @@
 #include <linux/xarray.h>
 #include <linux/firmware.h>
 
-#define DEVLINK_RELOAD_STATS_ARRAY_SIZE \
-	(__DEVLINK_RELOAD_LIMIT_MAX * __DEVLINK_RELOAD_ACTION_MAX)
-
-struct devlink_dev_stats {
-	u32 reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
-	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
-};
-
-struct devlink_ops;
-
-struct devlink {
-	u32 index;
-	struct list_head port_list;
-	struct list_head rate_list;
-	struct list_head sb_list;
-	struct list_head dpipe_table_list;
-	struct list_head resource_list;
-	struct list_head param_list;
-	struct list_head region_list;
-	struct list_head reporter_list;
-	struct mutex reporters_lock; /* protects reporter_list */
-	struct devlink_dpipe_headers *dpipe_headers;
-	struct list_head trap_list;
-	struct list_head trap_group_list;
-	struct list_head trap_policer_list;
-	const struct devlink_ops *ops;
-	struct xarray snapshot_ids;
-	struct devlink_dev_stats stats;
-	struct device *dev;
-	possible_net_t _net;
-	struct mutex lock; /* Serializes access to devlink instance specific objects such as
-			    * port, sb, dpipe, resource, params, region, traps and more.
-			    */
-	u8 reload_failed:1,
-	   reload_enabled:1;
-	refcount_t refcount;
-	struct completion comp;
-	char priv[0] __aligned(NETDEV_ALIGN);
-};
+struct devlink;
 
 struct devlink_port_phys_attrs {
 	u32 port_number; /* Same value as "split group".
@@ -1520,17 +1482,9 @@ struct devlink_ops {
 				    struct netlink_ext_ack *extack);
 };
 
-static inline void *devlink_priv(struct devlink *devlink)
-{
-	BUG_ON(!devlink);
-	return &devlink->priv;
-}
-
-static inline struct devlink *priv_to_devlink(void *priv)
-{
-	BUG_ON(!priv);
-	return container_of(priv, struct devlink, priv);
-}
+void *devlink_priv(struct devlink *devlink);
+struct devlink *priv_to_devlink(void *priv);
+struct device *devlink_to_dev(const struct devlink *devlink);
 
 static inline struct devlink_port *
 netdev_to_devlink_port(struct net_device *dev)
diff --git a/include/trace/events/devlink.h b/include/trace/events/devlink.h
index 44d8e2981065..2814f188d98c 100644
--- a/include/trace/events/devlink.h
+++ b/include/trace/events/devlink.h
@@ -21,9 +21,9 @@ TRACE_EVENT(devlink_hwmsg,
 	TP_ARGS(devlink, incoming, type, buf, len),
 
 	TP_STRUCT__entry(
-		__string(bus_name, devlink->dev->bus->name)
-		__string(dev_name, dev_name(devlink->dev))
-		__string(driver_name, devlink->dev->driver->name)
+		__string(bus_name, devlink_to_dev(devlink)->bus->name)
+		__string(dev_name, dev_name(devlink_to_dev(devlink)))
+		__string(driver_name, devlink_to_dev(devlink)->driver->name)
 		__field(bool, incoming)
 		__field(unsigned long, type)
 		__dynamic_array(u8, buf, len)
@@ -31,9 +31,9 @@ TRACE_EVENT(devlink_hwmsg,
 	),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink->dev->bus->name);
-		__assign_str(dev_name, dev_name(devlink->dev));
-		__assign_str(driver_name, devlink->dev->driver->name);
+		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
+		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
+		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
 		__entry->incoming = incoming;
 		__entry->type = type;
 		memcpy(__get_dynamic_array(buf), buf, len);
@@ -55,17 +55,17 @@ TRACE_EVENT(devlink_hwerr,
 	TP_ARGS(devlink, err, msg),
 
 	TP_STRUCT__entry(
-		__string(bus_name, devlink->dev->bus->name)
-		__string(dev_name, dev_name(devlink->dev))
-		__string(driver_name, devlink->dev->driver->name)
+		__string(bus_name, devlink_to_dev(devlink)->bus->name)
+		__string(dev_name, dev_name(devlink_to_dev(devlink)))
+		__string(driver_name, devlink_to_dev(devlink)->driver->name)
 		__field(int, err)
 		__string(msg, msg)
 		),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink->dev->bus->name);
-		__assign_str(dev_name, dev_name(devlink->dev));
-		__assign_str(driver_name, devlink->dev->driver->name);
+		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
+		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
+		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
 		__entry->err = err;
 		__assign_str(msg, msg);
 		),
@@ -85,17 +85,17 @@ TRACE_EVENT(devlink_health_report,
 	TP_ARGS(devlink, reporter_name, msg),
 
 	TP_STRUCT__entry(
-		__string(bus_name, devlink->dev->bus->name)
-		__string(dev_name, dev_name(devlink->dev))
-		__string(driver_name, devlink->dev->driver->name)
+		__string(bus_name, devlink_to_dev(devlink)->bus->name)
+		__string(dev_name, dev_name(devlink_to_dev(devlink)))
+		__string(driver_name, devlink_to_dev(devlink)->driver->name)
 		__string(reporter_name, msg)
 		__string(msg, msg)
 	),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink->dev->bus->name);
-		__assign_str(dev_name, dev_name(devlink->dev));
-		__assign_str(driver_name, devlink->dev->driver->name);
+		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
+		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
+		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
 		__assign_str(reporter_name, reporter_name);
 		__assign_str(msg, msg);
 	),
@@ -116,18 +116,18 @@ TRACE_EVENT(devlink_health_recover_aborted,
 	TP_ARGS(devlink, reporter_name, health_state, time_since_last_recover),
 
 	TP_STRUCT__entry(
-		__string(bus_name, devlink->dev->bus->name)
-		__string(dev_name, dev_name(devlink->dev))
-		__string(driver_name, devlink->dev->driver->name)
+		__string(bus_name, devlink_to_dev(devlink)->bus->name)
+		__string(dev_name, dev_name(devlink_to_dev(devlink)))
+		__string(driver_name, devlink_to_dev(devlink)->driver->name)
 		__string(reporter_name, reporter_name)
 		__field(bool, health_state)
 		__field(u64, time_since_last_recover)
 	),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink->dev->bus->name);
-		__assign_str(dev_name, dev_name(devlink->dev));
-		__assign_str(driver_name, devlink->dev->driver->name);
+		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
+		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
+		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
 		__assign_str(reporter_name, reporter_name);
 		__entry->health_state = health_state;
 		__entry->time_since_last_recover = time_since_last_recover;
@@ -150,17 +150,17 @@ TRACE_EVENT(devlink_health_reporter_state_update,
 	TP_ARGS(devlink, reporter_name, new_state),
 
 	TP_STRUCT__entry(
-		__string(bus_name, devlink->dev->bus->name)
-		__string(dev_name, dev_name(devlink->dev))
-		__string(driver_name, devlink->dev->driver->name)
+		__string(bus_name, devlink_to_dev(devlink)->bus->name)
+		__string(dev_name, dev_name(devlink_to_dev(devlink)))
+		__string(driver_name, devlink_to_dev(devlink)->driver->name)
 		__string(reporter_name, reporter_name)
 		__field(u8, new_state)
 	),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink->dev->bus->name);
-		__assign_str(dev_name, dev_name(devlink->dev));
-		__assign_str(driver_name, devlink->dev->driver->name);
+		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
+		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
+		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
 		__assign_str(reporter_name, reporter_name);
 		__entry->new_state = new_state;
 	),
@@ -181,9 +181,9 @@ TRACE_EVENT(devlink_trap_report,
 	TP_ARGS(devlink, skb, metadata),
 
 	TP_STRUCT__entry(
-		__string(bus_name, devlink->dev->bus->name)
-		__string(dev_name, dev_name(devlink->dev))
-		__string(driver_name, devlink->dev->driver->name)
+		__string(bus_name, devlink_to_dev(devlink)->bus->name)
+		__string(dev_name, dev_name(devlink_to_dev(devlink)))
+		__string(driver_name, devlink_to_dev(devlink)->driver->name)
 		__string(trap_name, metadata->trap_name)
 		__string(trap_group_name, metadata->trap_group_name)
 		__dynamic_array(char, input_dev_name, IFNAMSIZ)
@@ -192,9 +192,9 @@ TRACE_EVENT(devlink_trap_report,
 	TP_fast_assign(
 		struct net_device *input_dev = metadata->input_dev;
 
-		__assign_str(bus_name, devlink->dev->bus->name);
-		__assign_str(dev_name, dev_name(devlink->dev));
-		__assign_str(driver_name, devlink->dev->driver->name);
+		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
+		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
+		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
 		__assign_str(trap_name, metadata->trap_name);
 		__assign_str(trap_group_name, metadata->trap_group_name);
 		__assign_str(input_dev_name,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4917112406a0..87d1766ebdbf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -30,6 +30,63 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/devlink.h>
 
+#define DEVLINK_RELOAD_STATS_ARRAY_SIZE \
+	(__DEVLINK_RELOAD_LIMIT_MAX * __DEVLINK_RELOAD_ACTION_MAX)
+
+struct devlink_dev_stats {
+	u32 reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
+	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
+};
+
+struct devlink {
+	u32 index;
+	struct list_head port_list;
+	struct list_head rate_list;
+	struct list_head sb_list;
+	struct list_head dpipe_table_list;
+	struct list_head resource_list;
+	struct list_head param_list;
+	struct list_head region_list;
+	struct list_head reporter_list;
+	struct mutex reporters_lock; /* protects reporter_list */
+	struct devlink_dpipe_headers *dpipe_headers;
+	struct list_head trap_list;
+	struct list_head trap_group_list;
+	struct list_head trap_policer_list;
+	const struct devlink_ops *ops;
+	struct xarray snapshot_ids;
+	struct devlink_dev_stats stats;
+	struct device *dev;
+	possible_net_t _net;
+	/* Serializes access to devlink instance specific objects such as
+	 * port, sb, dpipe, resource, params, region, traps and more.
+	 */
+	struct mutex lock;
+	u8 reload_failed:1,
+	   reload_enabled:1;
+	refcount_t refcount;
+	struct completion comp;
+	char priv[0] __aligned(NETDEV_ALIGN);
+};
+
+void *devlink_priv(struct devlink *devlink)
+{
+	return &devlink->priv;
+}
+EXPORT_SYMBOL_GPL(devlink_priv);
+
+struct devlink *priv_to_devlink(void *priv)
+{
+	return container_of(priv, struct devlink, priv);
+}
+EXPORT_SYMBOL_GPL(priv_to_devlink);
+
+struct device *devlink_to_dev(const struct devlink *devlink)
+{
+	return devlink->dev;
+}
+EXPORT_SYMBOL_GPL(devlink_to_dev);
+
 static struct devlink_dpipe_field devlink_dpipe_fields_ethernet[] = {
 	{
 		.name = "destination mac",
-- 
2.31.1

