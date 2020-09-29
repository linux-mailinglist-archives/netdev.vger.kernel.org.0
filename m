Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6927BF54
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgI2I0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:26:17 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:44501 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725765AbgI2I0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:26:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B9B5F5807B0;
        Tue, 29 Sep 2020 04:17:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 04:17:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=OIKmcZ5LNfqhw/nfAI/AkZFEFe9XwCF1p5EfdRtLRzw=; b=jq6rrm9H
        4fbL08guWXsrFz1RAb/b3vP/lStCxcxJBpu49Bnr/2z2VyUXBIfb83eJVX8igFRT
        3S2f4TTrGpxsIPs4itcr7Bb2KC57SVoQoFxEK0BG69l3D0aV3J4GIx3/DkNw4Go5
        x2Fc6wM/Xk26pWD+aRPJIrWHesSAi7qkNGJMYaKr6yjcBJRnRMepsCs61tEA6ErV
        usVi8DSQ/ZmtC50XhWxcXctVxNDPVWhlu2JJmILsw+51xNJAsikezvNX8kObo/Fa
        3CcTAxW2nrzWBSIj+hh+IFObNXmbyAhfG/AdkImill5s9qc8QI7hY01owFZDRqBW
        LoLRkjtFIS90Mg==
X-ME-Sender: <xms:fe1yX2fXHsJ_uJBYWSFQrcJBOuGq3-FkkhqLA61KIndPWf-Fd3xGJA>
    <xme:fe1yXwNdkomzwb7a5NFv9qMiwhX0tUr8TKsGlU-rjgoCl3nFWyzumWgAKCc12I7iz
    idg0nUeVPricpI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeeuvdekudehvdehfeffudekgedvffdvfe
    ekkeeugffgjeejgeeifefhffelueeiffenucffohhmrghinhepfhgvughorhgrhhhoshht
    vggurdhorhhgnecukfhppeekgedrvddvledrfeejrddugeeknecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdr
    ohhrgh
X-ME-Proxy: <xmx:fe1yX3ikBmPOsHemNGMZpAywyjG3mSkgPOX7ZSqfaoueAl4yRvZ9sw>
    <xmx:fe1yXz9DGxUHPua2c2VNsVGqja9iiyCU2vDUpgkoTVomA96mI92C9A>
    <xmx:fe1yXysAXlcdvJpuchtlFrm47zVkVXmSXgIMgIBhWZxCcyLnkmp7LQ>
    <xmx:fe1yX_8tqUpchov03eDmArd7Ke58DQ0syqYIy6mqORVDA9RNoVkaiw>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id A7D57328005A;
        Tue, 29 Sep 2020 04:16:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, roopa@nvidia.com, aroulin@nvidia.com,
        ayal@nvidia.com, masahiroy@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/7] drop_monitor: Convert to using devlink tracepoint
Date:   Tue, 29 Sep 2020 11:15:52 +0300
Message-Id: <20200929081556.1634838-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929081556.1634838-1-idosch@idosch.org>
References: <20200929081556.1634838-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Convert drop monitor to use the recently introduced
'devlink_trap_report' tracepoint instead of having devlink call into
drop monitor.

This is both consistent with software originated drops ('kfree_skb'
tracepoint) and also allows drop monitor to be built as a module and
still report hardware originated drops.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 MAINTAINERS                |  1 -
 include/net/drop_monitor.h | 36 ------------------------
 net/Kconfig                |  1 -
 net/core/devlink.c         | 24 ----------------
 net/core/drop_monitor.c    | 56 +++++++++++++++++++++++++++-----------
 5 files changed, 40 insertions(+), 78 deletions(-)
 delete mode 100644 include/net/drop_monitor.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 42c69d2eeece..c1e946606dce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12065,7 +12065,6 @@ M:	Neil Horman <nhorman@tuxdriver.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 W:	https://fedorahosted.org/dropwatch/
-F:	include/net/drop_monitor.h
 F:	include/uapi/linux/net_dropmon.h
 F:	net/core/drop_monitor.c
 
diff --git a/include/net/drop_monitor.h b/include/net/drop_monitor.h
deleted file mode 100644
index 3f5b6ddb3179..000000000000
--- a/include/net/drop_monitor.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-
-#ifndef _NET_DROP_MONITOR_H_
-#define _NET_DROP_MONITOR_H_
-
-#include <linux/ktime.h>
-#include <linux/netdevice.h>
-#include <linux/skbuff.h>
-#include <net/flow_offload.h>
-
-/**
- * struct net_dm_hw_metadata - Hardware-supplied packet metadata.
- * @trap_group_name: Hardware trap group name.
- * @trap_name: Hardware trap name.
- * @input_dev: Input netdevice.
- * @fa_cookie: Flow action user cookie.
- */
-struct net_dm_hw_metadata {
-	const char *trap_group_name;
-	const char *trap_name;
-	struct net_device *input_dev;
-	const struct flow_action_cookie *fa_cookie;
-};
-
-#if IS_REACHABLE(CONFIG_NET_DROP_MONITOR)
-void net_dm_hw_report(struct sk_buff *skb,
-		      const struct net_dm_hw_metadata *hw_metadata);
-#else
-static inline void
-net_dm_hw_report(struct sk_buff *skb,
-		 const struct net_dm_hw_metadata *hw_metadata)
-{
-}
-#endif
-
-#endif /* _NET_DROP_MONITOR_H_ */
diff --git a/net/Kconfig b/net/Kconfig
index 3831206977a1..d6567162c1cf 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -434,7 +434,6 @@ config NET_SOCK_MSG
 config NET_DEVLINK
 	bool
 	default n
-	imply NET_DROP_MONITOR
 
 config PAGE_POOL
 	bool
diff --git a/net/core/devlink.c b/net/core/devlink.c
index c0f300507c37..2ea9fdc0df2d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -27,7 +27,6 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/devlink.h>
-#include <net/drop_monitor.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/devlink.h>
 
@@ -9261,24 +9260,6 @@ devlink_trap_stats_update(struct devlink_stats __percpu *trap_stats,
 	u64_stats_update_end(&stats->syncp);
 }
 
-static void
-devlink_trap_report_metadata_fill(struct net_dm_hw_metadata *hw_metadata,
-				  const struct devlink_trap_item *trap_item,
-				  struct devlink_port *in_devlink_port,
-				  const struct flow_action_cookie *fa_cookie)
-{
-	struct devlink_trap_group_item *group_item = trap_item->group_item;
-
-	hw_metadata->trap_group_name = group_item->group->name;
-	hw_metadata->trap_name = trap_item->trap->name;
-	hw_metadata->fa_cookie = fa_cookie;
-
-	spin_lock(&in_devlink_port->type_lock);
-	if (in_devlink_port->type == DEVLINK_PORT_TYPE_ETH)
-		hw_metadata->input_dev = in_devlink_port->type_dev;
-	spin_unlock(&in_devlink_port->type_lock);
-}
-
 static void
 devlink_trap_report_metadata_set(struct devlink_trap_metadata *metadata,
 				 const struct devlink_trap_item *trap_item,
@@ -9309,7 +9290,6 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 
 {
 	struct devlink_trap_item *trap_item = trap_ctx;
-	struct net_dm_hw_metadata hw_metadata = {};
 
 	devlink_trap_stats_update(trap_item->stats, skb->len);
 	devlink_trap_stats_update(trap_item->group_item->stats, skb->len);
@@ -9321,10 +9301,6 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 	if (trap_item->trap->type == DEVLINK_TRAP_TYPE_CONTROL)
 		return;
 
-	devlink_trap_report_metadata_fill(&hw_metadata, trap_item,
-					  in_devlink_port, fa_cookie);
-	net_dm_hw_report(skb, &hw_metadata);
-
 	if (trace_devlink_trap_report_enabled()) {
 		struct devlink_trap_metadata metadata = {};
 
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 03aba582c0b9..c14278fd6405 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -26,7 +26,6 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <net/drop_monitor.h>
 #include <net/genetlink.h>
 #include <net/netevent.h>
 #include <net/flow_offload.h>
@@ -34,6 +33,7 @@
 
 #include <trace/events/skb.h>
 #include <trace/events/napi.h>
+#include <trace/events/devlink.h>
 
 #include <asm/unaligned.h>
 
@@ -108,6 +108,13 @@ static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
 static u32 net_dm_trunc_len;
 static u32 net_dm_queue_len = 1000;
 
+struct net_dm_hw_metadata {
+	const char *trap_group_name;
+	const char *trap_name;
+	struct net_device *input_dev;
+	const struct flow_action_cookie *fa_cookie;
+};
+
 struct net_dm_alert_ops {
 	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
 				void *location);
@@ -1129,25 +1136,32 @@ static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
 	[NET_DM_ALERT_MODE_PACKET]	= &net_dm_alert_packet_ops,
 };
 
-void net_dm_hw_report(struct sk_buff *skb,
-		      const struct net_dm_hw_metadata *hw_metadata)
+#if IS_ENABLED(CONFIG_NET_DEVLINK)
+static int net_dm_hw_probe_register(const struct net_dm_alert_ops *ops)
 {
-	rcu_read_lock();
-
-	if (!monitor_hw)
-		goto out;
+	return register_trace_devlink_trap_report(ops->hw_trap_probe, NULL);
+}
 
-	net_dm_alert_ops_arr[net_dm_alert_mode]->hw_probe(skb, hw_metadata);
+static void net_dm_hw_probe_unregister(const struct net_dm_alert_ops *ops)
+{
+	unregister_trace_devlink_trap_report(ops->hw_trap_probe, NULL);
+	tracepoint_synchronize_unregister();
+}
+#else
+static int net_dm_hw_probe_register(const struct net_dm_alert_ops *ops)
+{
+	return -EOPNOTSUPP;
+}
 
-out:
-	rcu_read_unlock();
+static void net_dm_hw_probe_unregister(const struct net_dm_alert_ops *ops)
+{
 }
-EXPORT_SYMBOL_GPL(net_dm_hw_report);
+#endif
 
 static int net_dm_hw_monitor_start(struct netlink_ext_ack *extack)
 {
 	const struct net_dm_alert_ops *ops;
-	int cpu;
+	int cpu, rc;
 
 	if (monitor_hw) {
 		NL_SET_ERR_MSG_MOD(extack, "Hardware monitoring already enabled");
@@ -1171,13 +1185,24 @@ static int net_dm_hw_monitor_start(struct netlink_ext_ack *extack)
 		kfree(hw_entries);
 	}
 
+	rc = net_dm_hw_probe_register(ops);
+	if (rc) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to connect probe to devlink_trap_probe() tracepoint");
+		goto err_module_put;
+	}
+
 	monitor_hw = true;
 
 	return 0;
+
+err_module_put:
+	module_put(THIS_MODULE);
+	return rc;
 }
 
 static void net_dm_hw_monitor_stop(struct netlink_ext_ack *extack)
 {
+	const struct net_dm_alert_ops *ops;
 	int cpu;
 
 	if (!monitor_hw) {
@@ -1185,12 +1210,11 @@ static void net_dm_hw_monitor_stop(struct netlink_ext_ack *extack)
 		return;
 	}
 
+	ops = net_dm_alert_ops_arr[net_dm_alert_mode];
+
 	monitor_hw = false;
 
-	/* After this call returns we are guaranteed that no CPU is processing
-	 * any hardware drops.
-	 */
-	synchronize_rcu();
+	net_dm_hw_probe_unregister(ops);
 
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
-- 
2.26.2

