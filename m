Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AB52B9571
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgKSOpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgKSOpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 09:45:50 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3F9C0613D4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:45:48 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id o24so6488230ljj.6
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=wrWg6WEqWPxfcfq+3jgD3TOZNOTM3XShv/sFTJxQUIM=;
        b=HtA6MyD+7s7DlCBH3NUQnh8N24WQVOb8sEhLNH0Bw46ak35dKxsFro7rKuvlklei6/
         LVtC8X05qcp9m7fVtA3NFTgXcXyDYEddRbV+dcuz/1gUpipukpY2Iw5pRl6GY8rJtMaZ
         HOBn00zYDbfnq08gXPH6hrTlrWih9RXp2oJA43BGQVAWwSS9qpJudaQ1YaiSh4me5soE
         xeH9zsSC3xMZHvlfGAbvFONiSgwpA1E7hmrozh3IgrFGBhetV0xsq6P+ehXKFMiiPdk+
         +vbKIjFlKONdSWNRX/2J96jbqWzmyjATUlF/GHw3IMCV4Ow+dtoPhJuP8vWqc49713OZ
         xong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=wrWg6WEqWPxfcfq+3jgD3TOZNOTM3XShv/sFTJxQUIM=;
        b=LBcKA2nbb9jQZvCFxJJgSeZqIb+0VBYDxd/C5/Ah3eFxe0vCBXD8MG3e3sECje8nsz
         OyZ7m1DMtfMFI7y5xip2XhAHuHA6Xq6muvVGnO2NA6CueQN91rQLJJbiiM9G14Foi30q
         TF5TkxNMGmBLym0bIQcj31ALa73zHzVyYMafF6LuwJctCy9PnMhfenQPMFxNp7+zAvBO
         X53ywWzjxo5zGy47Quzvm54CSHveRERwZntiKyC0f3XJVKfJg84k3xHVkSIaMWvfRHm9
         cRxqOe5N+XWh49TCYa/Pz7WOx+aD5m+Ipy4W97LDqvupXmL6LH+gVIPlA76pelz0HetK
         1jtQ==
X-Gm-Message-State: AOAM5333wi73JnDS8g9zmDXX9LVCD15Q03n9wSYpT5fyuKNfFNIxwYtl
        RhK7B6l1p4qqtEarRIYr7TI5XQ==
X-Google-Smtp-Source: ABdhPJyY7nShPtg1XBjJdLR8imu6uCKAz2zmEn4m+0U7xFGjxieJz3529/0eWGvTw67cnAPeaN0e6Q==
X-Received: by 2002:a2e:b701:: with SMTP id j1mr6495232ljo.242.1605797146522;
        Thu, 19 Nov 2020 06:45:46 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 123sm3993483lfe.161.2020.11.19.06.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 06:45:45 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: dsa: Link aggregation support
Date:   Thu, 19 Nov 2020 15:45:06 +0100
Message-Id: <20201119144508.29468-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119144508.29468-1-tobias@waldekranz.com>
References: <20201119144508.29468-1-tobias@waldekranz.com>
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
 include/net/dsa.h  |  66 +++++++++++++++++++++
 net/dsa/dsa2.c     |   3 +
 net/dsa/dsa_priv.h |  31 ++++++++++
 net/dsa/port.c     | 143 +++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    |  55 +++++++++++++++--
 net/dsa/switch.c   |  49 ++++++++++++++++
 6 files changed, 341 insertions(+), 6 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..3fd8f041ddbe 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -147,6 +147,9 @@ struct dsa_switch_tree {
 	/* List of switch ports */
 	struct list_head ports;
 
+	/* List of configured LAGs */
+	struct list_head lags;
+
 	/* List of DSA links composing the routing table */
 	struct list_head rtable;
 };
@@ -180,6 +183,49 @@ struct dsa_mall_tc_entry {
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
+	struct kref refcount;
+	struct list_head list;
+};
+
+static inline struct dsa_lag *dsa_lag_by_dev(struct dsa_switch_tree *dst,
+					     struct net_device *dev)
+{
+	struct dsa_lag *lag;
+
+	list_for_each_entry(lag, &dst->lags, list)
+		if (lag->dev == dev)
+			return lag;
+
+	return NULL;
+}
+
+static inline struct net_device *dsa_lag_dev_by_id(struct dsa_switch_tree *dst,
+						   int id)
+{
+	struct dsa_lag *lag;
+
+	list_for_each_entry_rcu(lag, &dst->lags, list)
+		if (lag->id == id)
+			return lag->dev;
+
+	return NULL;
+}
 
 struct dsa_port {
 	/* A CPU port is physically connected to a master device.
@@ -220,6 +266,9 @@ struct dsa_port {
 	bool			devlink_port_setup;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
+	struct dsa_lag		*lag;
+	struct list_head	lag_list;
+	struct list_head	lag_tx_list;
 
 	struct list_head list;
 
@@ -624,6 +673,13 @@ struct dsa_switch_ops {
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
@@ -655,6 +711,16 @@ struct dsa_switch_ops {
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
index 183003e45762..708d5a34e150 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -66,6 +66,7 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 	INIT_LIST_HEAD(&dst->rtable);
 
 	INIT_LIST_HEAD(&dst->ports);
+	INIT_LIST_HEAD(&dst->lags);
 
 	INIT_LIST_HEAD(&dst->list);
 	list_add_tail(&dst->list, &dsa_tree_list);
@@ -659,6 +660,8 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 	dp->index = index;
 
 	INIT_LIST_HEAD(&dp->list);
+	INIT_LIST_HEAD(&dp->lag_list);
+	INIT_LIST_HEAD(&dp->lag_tx_list);
 	list_add_tail(&dp->list, &dst->ports);
 
 	return dp;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c96aae9062c..214051f3ced0 100644
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
+	if (dp->lag && dev == dp->lag->dev)
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
index 73569c9af3cc..4bb8a69d7ec2 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -193,6 +193,149 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 }
 
+static struct dsa_lag *dsa_lag_get(struct dsa_switch_tree *dst,
+				   struct net_device *dev)
+{
+	unsigned long busy = 0;
+	struct dsa_lag *lag;
+	int id;
+
+	list_for_each_entry(lag, &dst->lags, list) {
+		set_bit(lag->id, &busy);
+
+		if (lag->dev == dev) {
+			kref_get(&lag->refcount);
+			return lag;
+		}
+	}
+
+	id = find_first_zero_bit(&busy, BITS_PER_LONG);
+	if (id >= BITS_PER_LONG)
+		return ERR_PTR(-ENOSPC);
+
+	lag = kzalloc(sizeof(*lag), GFP_KERNEL);
+	if (!lag)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&lag->refcount);
+	lag->id = id;
+	lag->dev = dev;
+	INIT_LIST_HEAD(&lag->ports);
+	INIT_LIST_HEAD(&lag->tx_ports);
+
+	INIT_LIST_HEAD(&lag->list);
+	list_add_tail_rcu(&lag->list, &dst->lags);
+	return lag;
+}
+
+static void dsa_lag_release(struct kref *refcount)
+{
+	struct dsa_lag *lag = container_of(refcount, struct dsa_lag, refcount);
+
+	list_del_rcu(&lag->list);
+	synchronize_rcu();
+	kfree(lag);
+}
+
+static void dsa_lag_put(struct dsa_lag *lag)
+{
+	kref_put(&lag->refcount, dsa_lag_release);
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
+	if (IS_ERR(lag))
+		return PTR_ERR(lag);
+
+	dp->lag = lag;
+	list_add_tail(&dp->lag_list, &lag->ports);
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
+	if (err) {
+		dp->lag = NULL;
+		list_del_init(&dp->lag_list);
+		dsa_lag_put(lag);
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
+	dsa_lag_put(dp->lag);
+
+	dp->lag = NULL;
+}
+
 /* Must be called under rcu_read_lock() */
 static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 					      bool vlan_filtering)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ff2266d2b998..ca61349886a4 100644
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
@@ -1941,6 +1941,33 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			dsa_port_bridge_leave(dp, info->upper_dev);
 			err = NOTIFY_OK;
 		}
+	} else if (netif_is_lag_master(info->upper_dev)) {
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
+static int dsa_slave_lag_changeupper(struct net_device *dev,
+				     struct netdev_notifier_changeupper_info *info)
+{
+	struct net_device *lower;
+	struct list_head *iter;
+	int err = NOTIFY_DONE;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		if (!dsa_slave_dev_check(lower))
+			continue;
+
+		err = dsa_slave_changeupper(lower, info);
+		if (notifier_to_errno(err))
+			break;
 	}
 
 	return err;
@@ -2038,10 +2065,26 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
 
-		return dsa_slave_changeupper(dev, ptr);
+		dp = dsa_slave_to_port(dev);
+
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

