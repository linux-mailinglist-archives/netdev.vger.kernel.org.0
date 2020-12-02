Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E1C2CB864
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388109AbgLBJPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388100AbgLBJPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:15:16 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B6C0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 01:14:29 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id u19so3173608lfr.7
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 01:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=HzMGqJ0egXnZ+DFU12smlJdRjedS29qpZWTbBLoc8GQ=;
        b=Tv2Q/x7eDEH3QW/dMig2B1OxLQZy+SWktXNNZhbwmrqAKTWqTZb1hbH9Kpoj5WtAiU
         BzhvZO0X6vWDbLnXqxA3cktdCSda5ac/pN5VdISWvqLWpuMcUqBz3Qw13/KlWeOyWza8
         qdPH0BbTDfu8pzXqqaw2/v/TZxk2yAC0mey0jTXsrZT/aK8rVIyuXYuj/rE/tp1/qjr2
         Zjcge2wRZIDIWBjOy3J2LIcATGlrpqLHbBU5M78tSSlaxo9mkSK/dnU9yIe0mLiDWlqh
         eVdrCX/rBy77lftPaUM1JwafLkLE3mZq2a8tFQ8ZPgxdKGIoAL6hG1Cz+FivlMQpUg1O
         bgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=HzMGqJ0egXnZ+DFU12smlJdRjedS29qpZWTbBLoc8GQ=;
        b=gDlX3/BJQbq0fjQD1Zm9HeoqoVPXGgomPRljnDI7Ai2X0pBumSzxJCVS9jVTkagrxd
         hhgbvxK5xQZpDj7q2VBOoNoDPFJNsnrnyxzFlaj1vU0OM+NSeocRhA+536+nOSAp+MsD
         V44o7shKmaoTSRWIujElxm45UQZyFJ/kM4fiqRBcGWZvAfpFbVRckf9w3maYV4Nz/05g
         w7eBZw/wqVrctrYYlA4l/CCseEKv0KUj8H96VxO/Y6mNVxpy4JKRSzwTdx0u4mCnlIoN
         T0FkdVhUz29hBSnThiULI7Wej5ACVMS+Rm3UY0dFFC2+928tE8BkBldB220xJ6FFYH1P
         DunA==
X-Gm-Message-State: AOAM533TaKQKkggvuVLejR7Wg9wkE0HPqXaqmDYvYvPxNPQoMXMvyRVT
        NFiIZpG+ZVBRsNb/46ZZvvGJFA==
X-Google-Smtp-Source: ABdhPJwbv/AFYWmzjWfTPkIXc7Nw0z8O1fzcq9KHBV7Vw1qQo9jj60EgmI5GTbGt4LWZAc+/mR1cKA==
X-Received: by 2002:ac2:5ede:: with SMTP id d30mr787781lfq.78.1606900467990;
        Wed, 02 Dec 2020 01:14:27 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v1sm295970lfg.252.2020.12.02.01.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 01:14:27 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Date:   Wed,  2 Dec 2020 10:13:54 +0100
Message-Id: <20201202091356.24075-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201202091356.24075-1-tobias@waldekranz.com>
References: <20201202091356.24075-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Monitor the following events and notify the driver when:

- A DSA port joins/leaves a LAG.
- A LAG, made up of DSA ports, joins/leaves a bridge.
- A DSA port in a LAG is enabled/disabled (enabled meaning
  "distributing" in 802.3ad LACP terms).

Each LAG interface to which a DSA port is attached is represented by a
`struct dsa_lag` which is globally reachable from the switch tree and
from each associated port.

When a LAG joins a bridge, the DSA subsystem will treat that as each
individual port joining the bridge. The driver may look at the port's
LAG pointer to see if it is associated with any LAG, if that is
required. This is analogue to how switchdev events are replicated out
to all lower devices when reaching e.g. a LAG.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/dsa.h  |  97 +++++++++++++++++++++++++++++++++
 net/dsa/dsa2.c     |  51 ++++++++++++++++++
 net/dsa/dsa_priv.h |  31 +++++++++++
 net/dsa/port.c     | 132 +++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    |  83 +++++++++++++++++++++++++---
 net/dsa/switch.c   |  49 +++++++++++++++++
 6 files changed, 437 insertions(+), 6 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..aaa350b78c55 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -7,6 +7,7 @@
 #ifndef __LINUX_NET_DSA_H
 #define __LINUX_NET_DSA_H
 
+#include <linux/bitmap.h>
 #include <linux/if.h>
 #include <linux/if_ether.h>
 #include <linux/list.h>
@@ -71,6 +72,7 @@ enum dsa_tag_protocol {
 
 struct packet_type;
 struct dsa_switch;
+struct dsa_lag;
 
 struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
@@ -149,6 +151,13 @@ struct dsa_switch_tree {
 
 	/* List of DSA links composing the routing table */
 	struct list_head rtable;
+
+	/* Link aggregates */
+	struct {
+		struct dsa_lag *pool;
+		unsigned long *busy;
+		unsigned int num;
+	} lags;
 };
 
 /* TC matchall action types */
@@ -180,6 +189,69 @@ struct dsa_mall_tc_entry {
 	};
 };
 
+struct dsa_lag {
+	struct net_device *dev;
+	int id;
+
+	struct list_head ports;
+
+	/* For multichip systems, we must ensure that each hash bucket
+	 * is only enabled on a single egress port throughout the
+	 * whole tree, lest we send duplicates. Therefore we must
+	 * maintain a global list of active tx ports, so that each
+	 * switch can figure out which buckets to enable on which
+	 * ports.
+	 */
+	struct list_head tx_ports;
+	int num_tx;
+
+	refcount_t refcount;
+};
+
+#define dsa_lag_foreach(_id, _dst) \
+	for_each_set_bit(_id, (_dst)->lags.busy, (_dst)->lags.num)
+
+static inline bool dsa_lag_offloading(struct dsa_switch_tree *dst)
+{
+	return dst->lags.num > 0;
+}
+
+static inline bool dsa_lag_available(struct dsa_switch_tree *dst)
+{
+	return !bitmap_full(dst->lags.busy, dst->lags.num);
+}
+
+static inline struct dsa_lag *dsa_lag_by_id(struct dsa_switch_tree *dst, int id)
+{
+	if (!test_bit(id, dst->lags.busy))
+		return NULL;
+
+	return &dst->lags.pool[id];
+}
+
+static inline struct net_device *dsa_lag_dev_by_id(struct dsa_switch_tree *dst,
+						   int id)
+{
+	struct dsa_lag *lag = dsa_lag_by_id(dst, id);
+
+	return lag ? READ_ONCE(lag->dev) : NULL;
+}
+
+static inline struct dsa_lag *dsa_lag_by_dev(struct dsa_switch_tree *dst,
+					     struct net_device *dev)
+{
+	struct dsa_lag *lag;
+	int id;
+
+	dsa_lag_foreach(id, dst) {
+		lag = dsa_lag_by_id(dst, id);
+
+		if (lag->dev == dev)
+			return lag;
+	}
+
+	return NULL;
+}
 
 struct dsa_port {
 	/* A CPU port is physically connected to a master device.
@@ -220,6 +292,9 @@ struct dsa_port {
 	bool			devlink_port_setup;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
+	struct dsa_lag		*lag;
+	struct list_head	lag_list;
+	struct list_head	lag_tx_list;
 
 	struct list_head list;
 
@@ -335,6 +410,11 @@ struct dsa_switch {
 	 */
 	bool			mtu_enforcement_ingress;
 
+	/* The maximum number of LAGs that can be configured. A value of zero
+	 * is used to indicate that LAG offloading is not supported.
+	 */
+	unsigned int		num_lags;
+
 	size_t num_ports;
 };
 
@@ -624,6 +704,13 @@ struct dsa_switch_ops {
 	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int tree_index,
 					  int sw_index, int port,
 					  struct net_device *br);
+	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
+					int port, struct net_device *lag_dev,
+					struct netdev_lag_lower_state_info *info);
+	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
+				      int port, struct net_device *lag_dev);
+	void	(*crosschip_lag_leave)(struct dsa_switch *ds, int sw_index,
+				       int port, struct net_device *lag_dev);
 
 	/*
 	 * PTP functionality
@@ -655,6 +742,16 @@ struct dsa_switch_ops {
 	int	(*port_change_mtu)(struct dsa_switch *ds, int port,
 				   int new_mtu);
 	int	(*port_max_mtu)(struct dsa_switch *ds, int port);
+
+	/*
+	 * LAG integration
+	 */
+	int	(*port_lag_change)(struct dsa_switch *ds, int port,
+				   struct netdev_lag_lower_state_info *info);
+	int	(*port_lag_join)(struct dsa_switch *ds, int port,
+				 struct net_device *lag_dev);
+	void	(*port_lag_leave)(struct dsa_switch *ds, int port,
+				  struct net_device *lag_dev);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 183003e45762..786277a21955 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -578,6 +578,47 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 			dsa_master_teardown(dp->master);
 }
 
+static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+	unsigned int num;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		num = dp->ds->num_lags;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		num = min(num, dp->ds->num_lags);
+
+	if (num == 0)
+		return 0;
+
+	dst->lags.pool = kcalloc(num, sizeof(*dst->lags.pool), GFP_KERNEL);
+	if (!dst->lags.pool)
+		goto err;
+
+	dst->lags.busy = bitmap_zalloc(num, GFP_KERNEL);
+	if (!dst->lags.busy)
+		goto err_free_pool;
+
+	dst->lags.num = num;
+	return 0;
+
+err_free_pool:
+	kfree(dst->lags.pool);
+err:
+	return -ENOMEM;
+}
+
+static void dsa_tree_teardown_lags(struct dsa_switch_tree *dst)
+{
+	if (dst->lags.num == 0)
+		return;
+
+	kfree(dst->lags.busy);
+	kfree(dst->lags.pool);
+	dst->lags.num = 0;
+}
+
 static int dsa_tree_setup(struct dsa_switch_tree *dst)
 {
 	bool complete;
@@ -605,12 +646,18 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (err)
 		goto teardown_switches;
 
+	err = dsa_tree_setup_lags(dst);
+	if (err)
+		goto teardown_master;
+
 	dst->setup = true;
 
 	pr_info("DSA: tree %d setup\n", dst->index);
 
 	return 0;
 
+teardown_master:
+	dsa_tree_teardown_master(dst);
 teardown_switches:
 	dsa_tree_teardown_switches(dst);
 teardown_default_cpu:
@@ -626,6 +673,8 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 	if (!dst->setup)
 		return;
 
+	dsa_tree_teardown_lags(dst);
+
 	dsa_tree_teardown_master(dst);
 
 	dsa_tree_teardown_switches(dst);
@@ -659,6 +708,8 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 	dp->index = index;
 
 	INIT_LIST_HEAD(&dp->list);
+	INIT_LIST_HEAD(&dp->lag_list);
+	INIT_LIST_HEAD(&dp->lag_tx_list);
 	list_add_tail(&dp->list, &dst->ports);
 
 	return dp;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c96aae9062c..77e07a0cff29 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -20,6 +20,9 @@ enum {
 	DSA_NOTIFIER_BRIDGE_LEAVE,
 	DSA_NOTIFIER_FDB_ADD,
 	DSA_NOTIFIER_FDB_DEL,
+	DSA_NOTIFIER_LAG_CHANGE,
+	DSA_NOTIFIER_LAG_JOIN,
+	DSA_NOTIFIER_LAG_LEAVE,
 	DSA_NOTIFIER_MDB_ADD,
 	DSA_NOTIFIER_MDB_DEL,
 	DSA_NOTIFIER_VLAN_ADD,
@@ -57,6 +60,14 @@ struct dsa_notifier_mdb_info {
 	int port;
 };
 
+/* DSA_NOTIFIER_LAG_* */
+struct dsa_notifier_lag_info {
+	struct netdev_lag_lower_state_info *info;
+	struct net_device *lag;
+	int sw_index;
+	int port;
+};
+
 /* DSA_NOTIFIER_VLAN_* */
 struct dsa_notifier_vlan_info {
 	const struct switchdev_obj_port_vlan *vlan;
@@ -135,6 +146,10 @@ void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
+int dsa_port_lag_change(struct dsa_port *dp,
+			struct netdev_lag_lower_state_info *linfo);
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev);
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct switchdev_trans *trans);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
@@ -167,6 +182,22 @@ int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
+static inline bool dsa_port_can_offload(struct dsa_port *dp,
+					struct net_device *dev)
+{
+	/* Switchdev offloading can be configured on: */
+
+	if (dev == dp->slave)
+		/* DSA ports directly connected to a bridge. */
+		return true;
+
+	if (dp->lag && dev == rtnl_dereference(dp->lag->dev))
+		/* DSA ports connected to a bridge via a LAG */
+		return true;
+
+	return false;
+}
+
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 73569c9af3cc..5a06890db918 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -193,6 +193,138 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 }
 
+static struct dsa_lag *dsa_lag_get(struct dsa_switch_tree *dst,
+				   struct net_device *dev)
+{
+	struct dsa_lag *lag;
+	int id;
+
+	lag = dsa_lag_by_dev(dst, dev);
+	if (lag) {
+		refcount_inc(&lag->refcount);
+		return lag;
+	}
+
+	id = find_first_zero_bit(dst->lags.busy, dst->lags.num);
+	if (id >= dst->lags.num) {
+		WARN(1, "No LAGs available");
+		return NULL;
+	}
+
+	lag = &dst->lags.pool[id];
+	lag->dev = dev;
+	lag->id = id;
+	INIT_LIST_HEAD(&lag->ports);
+	INIT_LIST_HEAD(&lag->tx_ports);
+	refcount_set(&lag->refcount, 1);
+	set_bit(id, dst->lags.busy);
+	return lag;
+}
+
+static void dsa_lag_put(struct dsa_switch_tree *dst, struct dsa_lag *lag)
+{
+	if (!refcount_dec_and_test(&lag->refcount))
+		return;
+
+	clear_bit(lag->id, dst->lags.busy);
+	WRITE_ONCE(lag->dev, NULL);
+	memset(lag, 0, sizeof(*lag));
+}
+
+int dsa_port_lag_change(struct dsa_port *dp,
+			struct netdev_lag_lower_state_info *linfo)
+{
+	struct dsa_notifier_lag_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.info = linfo,
+	};
+	bool old, new;
+
+	if (!dp->lag)
+		return 0;
+
+	info.lag = dp->lag->dev;
+
+	/* If this port is on the tx list, it is already enabled. */
+	old = !list_empty(&dp->lag_tx_list);
+
+	/* On statically configured aggregates (e.g. loadbalance
+	 * without LACP) ports will always be tx_enabled, even if the
+	 * link is down. Thus we require both link_up and tx_enabled
+	 * in order to include it in the tx set.
+	 */
+	new = linfo->link_up && linfo->tx_enabled;
+
+	if (new == old)
+		return 0;
+
+	if (new) {
+		dp->lag->num_tx++;
+		list_add_tail(&dp->lag_tx_list, &dp->lag->tx_ports);
+	} else {
+		list_del_init(&dp->lag_tx_list);
+		dp->lag->num_tx--;
+	}
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
+}
+
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev)
+{
+	struct dsa_notifier_lag_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.lag = lag_dev,
+	};
+	struct dsa_lag *lag;
+	int err;
+
+	lag = dsa_lag_get(dp->ds->dst, lag_dev);
+	if (!lag)
+		return -ENODEV;
+
+	dp->lag = lag;
+	list_add_tail(&dp->lag_list, &lag->ports);
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
+	if (err) {
+		dp->lag = NULL;
+		list_del_init(&dp->lag_list);
+		dsa_lag_put(dp->ds->dst, lag);
+	}
+
+	return err;
+}
+
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
+{
+	struct dsa_notifier_lag_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.lag = lag_dev,
+	};
+	int err;
+
+	/* Port might have been part of a LAG that in turn was
+	 * attached to a bridge.
+	 */
+	if (dp->bridge_dev)
+		dsa_port_bridge_leave(dp, dp->bridge_dev);
+
+	list_del_init(&dp->lag_list);
+	list_del_init(&dp->lag_tx_list);
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
+	if (err)
+		pr_err("DSA: failed to notify DSA_NOTIFIER_LAG_LEAVE: %d\n",
+		       err);
+
+	dsa_lag_put(dp->ds->dst, dp->lag);
+
+	dp->lag = NULL;
+}
+
 /* Must be called under rcu_read_lock() */
 static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 					      bool vlan_filtering)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 7efc753e4d9d..6d7878cc7f3d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -334,7 +334,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct switchdev_obj_port_vlan vlan;
 	int vid, err;
 
-	if (obj->orig_dev != dev)
+	if (!dsa_port_can_offload(dp, obj->orig_dev))
 		return -EOPNOTSUPP;
 
 	if (dsa_port_skip_vlan_configuration(dp))
@@ -391,7 +391,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (obj->orig_dev != dev)
+		if (!dsa_port_can_offload(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj), trans);
 		break;
@@ -421,7 +421,7 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct switchdev_obj_port_vlan *vlan;
 	int vid, err;
 
-	if (obj->orig_dev != dev)
+	if (!dsa_port_can_offload(dp, obj->orig_dev))
 		return -EOPNOTSUPP;
 
 	if (dsa_port_skip_vlan_configuration(dp))
@@ -450,7 +450,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (obj->orig_dev != dev)
+		if (!dsa_port_can_offload(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
@@ -1941,6 +1941,40 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			dsa_port_bridge_leave(dp, info->upper_dev);
 			err = NOTIFY_OK;
 		}
+	} else if (netif_is_lag_master(info->upper_dev) &&
+		   dsa_lag_offloading(dp->ds->dst)) {
+		if (info->linking) {
+			err = dsa_port_lag_join(dp, info->upper_dev);
+			err = notifier_from_errno(err);
+		} else {
+			dsa_port_lag_leave(dp, info->upper_dev);
+			err = NOTIFY_OK;
+		}
+	}
+
+	return err;
+}
+
+static int
+dsa_slave_lag_changeupper(struct net_device *dev,
+			  struct netdev_notifier_changeupper_info *info)
+{
+	struct net_device *lower;
+	struct list_head *iter;
+	int err = NOTIFY_DONE;
+	struct dsa_port *dp;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		if (!dsa_slave_dev_check(lower))
+			continue;
+
+		dp = dsa_slave_to_port(lower);
+		if (!dsa_lag_offloading(dp->ds->dst))
+			break;
+
+		err = dsa_slave_changeupper(lower, info);
+		if (notifier_to_errno(err))
+			break;
 	}
 
 	return err;
@@ -2009,6 +2043,23 @@ dsa_slave_check_8021q_upper(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int dsa_slave_check_lag_upper(struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch_tree *dst = dp->ds->dst;
+
+	if (!dsa_lag_offloading(dst))
+		return NOTIFY_DONE;
+
+	if (dsa_lag_by_dev(dst, dev))
+		return NOTIFY_OK;
+
+	if (!dsa_lag_available(dst))
+		return notifier_from_errno(-EBUSY);
+
+	return NOTIFY_OK;
+}
+
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
@@ -2035,13 +2086,33 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 
 		if (is_vlan_dev(info->upper_dev))
 			return dsa_slave_check_8021q_upper(dev, ptr);
+
+		if (netif_is_lag_master(info->upper_dev))
+			return dsa_slave_check_lag_upper(dev);
+
 		break;
 	}
 	case NETDEV_CHANGEUPPER:
+		if (dsa_slave_dev_check(dev))
+			return dsa_slave_changeupper(dev, ptr);
+
+		if (netif_is_lag_master(dev))
+			return dsa_slave_lag_changeupper(dev, ptr);
+
+		break;
+	case NETDEV_CHANGELOWERSTATE: {
+		struct netdev_notifier_changelowerstate_info *info = ptr;
+		struct dsa_port *dp;
+		int err;
+
 		if (!dsa_slave_dev_check(dev))
-			return NOTIFY_DONE;
+			break;
+
+		dp = dsa_slave_to_port(dev);
 
-		return dsa_slave_changeupper(dev, ptr);
+		err = dsa_port_lag_change(dp, info->lower_state_info);
+		return notifier_from_errno(err);
+	}
 	}
 
 	return NOTIFY_DONE;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 3fb362b6874e..3e518df7cd1f 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -178,6 +178,46 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	return ds->ops->port_fdb_del(ds, port, info->addr, info->vid);
 }
 
+static int dsa_switch_lag_change(struct dsa_switch *ds,
+				 struct dsa_notifier_lag_info *info)
+{
+	if (ds->index == info->sw_index && ds->ops->port_lag_change)
+		return ds->ops->port_lag_change(ds, info->port, info->info);
+
+	if (ds->index != info->sw_index && ds->ops->crosschip_lag_change)
+		return ds->ops->crosschip_lag_change(ds, info->sw_index,
+						     info->port, info->lag,
+						     info->info);
+
+	return 0;
+}
+
+static int dsa_switch_lag_join(struct dsa_switch *ds,
+			       struct dsa_notifier_lag_info *info)
+{
+	if (ds->index == info->sw_index && ds->ops->port_lag_join)
+		return ds->ops->port_lag_join(ds, info->port, info->lag);
+
+	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
+		return ds->ops->crosschip_lag_join(ds, info->sw_index,
+						   info->port, info->lag);
+
+	return 0;
+}
+
+static int dsa_switch_lag_leave(struct dsa_switch *ds,
+				struct dsa_notifier_lag_info *info)
+{
+	if (ds->index == info->sw_index && ds->ops->port_lag_leave)
+		ds->ops->port_lag_leave(ds, info->port, info->lag);
+
+	if (ds->index != info->sw_index && ds->ops->crosschip_lag_leave)
+		ds->ops->crosschip_lag_leave(ds, info->sw_index,
+					     info->port, info->lag);
+
+	return 0;
+}
+
 static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
 				 struct dsa_notifier_mdb_info *info)
 {
@@ -325,6 +365,15 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_FDB_DEL:
 		err = dsa_switch_fdb_del(ds, info);
 		break;
+	case DSA_NOTIFIER_LAG_CHANGE:
+		err = dsa_switch_lag_change(ds, info);
+		break;
+	case DSA_NOTIFIER_LAG_JOIN:
+		err = dsa_switch_lag_join(ds, info);
+		break;
+	case DSA_NOTIFIER_LAG_LEAVE:
+		err = dsa_switch_lag_leave(ds, info);
+		break;
 	case DSA_NOTIFIER_MDB_ADD:
 		err = dsa_switch_mdb_add(ds, info);
 		break;
-- 
2.17.1

