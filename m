Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A15829AA09
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421082AbgJ0KwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:52:07 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37185 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420753AbgJ0Kv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:51:58 -0400
Received: by mail-lj1-f196.google.com with SMTP id i2so1220512ljg.4
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 03:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=iioK82PuDEBQIVEj9P0ZQPZSQbrL/cWPfxpNShM+T20=;
        b=t9sgrdnE/7ubC0o4h0u8NOGT5qhopYD9ZKibHyHCpX6+d0+FczwyakR8C/khJSOqai
         ErxhtsRAcL9Yh8nSEM8/B02aC9F8kBCau+CUgmR0oRyXF7TPBgFEB37JAlvj0m0Rj/CS
         39Y8mtqGBPkU4h04wibrQFZLBnfPC3N1/7apkElt/lQkQNwXuwPfI4rAaQYeMrfKR3b1
         tMIVjwA3i3RSvjdMXfrEw+rZ014uJoAHZJLdANVdX+3gqmVclkkfD5DKbmtP5wsq8xjC
         nPEhmbH+MVqinE2xBoCFDyMDsoEnCjMdKfDOZ5jKMLK5sVVjg265bPF53+aIN/4NjIIa
         KMjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=iioK82PuDEBQIVEj9P0ZQPZSQbrL/cWPfxpNShM+T20=;
        b=l/E5ebRemZAiLq/y9TnjKUBl0IiPFxFdGiSPeZY/Z+L21LWPxtZeFPfWYnj1ZHhFKu
         TjRARHIL3wQCv1zM7dNhEF4K1mMgk02dtB+9EFDESQiMjWKH/Afltg6n9aDQfWozZtpz
         CGJ/yqsQ5iF5tGmnzwX8YZgf/Y6heybB/X3/gqyq+O5S+jb1NIS29Nk0z3CEXU24LumK
         vluwSmdjh9Aad2pSivLzLY4d+3YZSripJXhQLvXILSxFpE/QIQjEwdUgqNZqyLEWqi/i
         JiLq9icOT+euaeRr9mcVOqC1w1v3N4gLsDKwh10ch0k3kxa+yO7FN7BlyMesM6kPG9TM
         AMhw==
X-Gm-Message-State: AOAM530+GEmuwDFeM1EznVktSk1thL3SCaNiSAwRtF5p64zGGtrx153y
        3D8v8S/2B4iXaic7ljIb8jItVw==
X-Google-Smtp-Source: ABdhPJySay09iz4mS3zrwFyCTgcEwfQvDYoEIRU5SYr3ewsH35wTQaQH2CzAFbbe/XI3wCDBHxwa5g==
X-Received: by 2002:a2e:3e1a:: with SMTP id l26mr875601lja.63.1603795914864;
        Tue, 27 Oct 2020 03:51:54 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s19sm134385lfb.224.2020.10.27.03.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 03:51:54 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [RFC PATCH 2/4] net: dsa: link aggregation support
Date:   Tue, 27 Oct 2020 11:51:15 +0100
Message-Id: <20201027105117.23052-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
References: <20201027105117.23052-1-tobias@waldekranz.com>
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
 include/net/dsa.h  |  68 +++++++++++++++++++++
 net/dsa/dsa2.c     |   3 +
 net/dsa/dsa_priv.h |  16 +++++
 net/dsa/port.c     | 146 +++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    |  53 ++++++++++++++--
 net/dsa/switch.c   |  64 ++++++++++++++++++++
 6 files changed, 346 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 35429a140dfa..58d73eafe891 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -145,6 +145,9 @@ struct dsa_switch_tree {
 	/* List of switch ports */
 	struct list_head ports;
 
+	/* List of configured LAGs */
+	struct list_head lags;
+
 	/* List of DSA links composing the routing table */
 	struct list_head rtable;
 };
@@ -178,6 +181,48 @@ struct dsa_mall_tc_entry {
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
+	 * whole tree. We must maintain a global list of active tx
+	 * ports, so that each switch can figure out which buckets to
+	 * enable on which ports.
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
@@ -218,6 +263,9 @@ struct dsa_port {
 	bool			devlink_port_setup;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
+	struct dsa_lag		*lag;
+	struct list_head	lag_list;
+	struct list_head	lag_tx_list;
 
 	struct list_head list;
 
@@ -616,6 +664,16 @@ struct dsa_switch_ops {
 	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int tree_index,
 					  int sw_index, int port,
 					  struct net_device *br);
+	int	(*crosschip_lag_change)(struct dsa_switch *ds, int tree_index,
+					int sw_index, int port,
+					struct net_device *lag_dev,
+					struct netdev_lag_lower_state_info *info);
+	int	(*crosschip_lag_join)(struct dsa_switch *ds, int tree_index,
+				      int sw_index, int port,
+				      struct net_device *lag_dev);
+	void	(*crosschip_lag_leave)(struct dsa_switch *ds, int tree_index,
+				       int sw_index, int port,
+				       struct net_device *lag_dev);
 
 	/*
 	 * PTP functionality
@@ -647,6 +705,16 @@ struct dsa_switch_ops {
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
index 12998bf04e55..341feee3eae5 100644
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
@@ -57,6 +60,15 @@ struct dsa_notifier_mdb_info {
 	int port;
 };
 
+/* DSA_NOTIFIER_LAG_* */
+struct dsa_notifier_lag_info {
+	struct netdev_lag_lower_state_info *info;
+	struct net_device *lag;
+	int tree_index;
+	int sw_index;
+	int port;
+};
+
 /* DSA_NOTIFIER_VLAN_* */
 struct dsa_notifier_vlan_info {
 	const struct switchdev_obj_port_vlan *vlan;
@@ -137,6 +149,10 @@ void dsa_port_disable_rt(struct dsa_port *dp);
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
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 73569c9af3cc..e87fc4765497 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -193,6 +193,152 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 }
 
+static struct dsa_lag *dsa_lag_get(struct dsa_switch_tree *dst,
+				   struct net_device *dev)
+{
+	struct dsa_lag *lag;
+	unsigned long busy = 0;
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
+		.tree_index = dp->ds->dst->index,
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
+	return dsa_broadcast(DSA_NOTIFIER_LAG_CHANGE, &info);
+}
+
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev)
+{
+	struct dsa_notifier_lag_info info = {
+		.tree_index = dp->ds->dst->index,
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
+	err = dsa_broadcast(DSA_NOTIFIER_LAG_JOIN, &info);
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
+		.tree_index = dp->ds->dst->index,
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
+	err = dsa_broadcast(DSA_NOTIFIER_LAG_LEAVE, &info);
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
index 3bc5ca40c9fb..e5e4f3d096c0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -334,7 +334,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct switchdev_obj_port_vlan vlan;
 	int vid, err;
 
-	if (obj->orig_dev != dev)
+	if (!(obj->orig_dev == dev ||
+	      (dp->lag && obj->orig_dev == dp->lag->dev)))
 		return -EOPNOTSUPP;
 
 	if (dsa_port_skip_vlan_configuration(dp))
@@ -421,7 +422,8 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct switchdev_obj_port_vlan *vlan;
 	int vid, err;
 
-	if (obj->orig_dev != dev)
+	if (!(obj->orig_dev == dev ||
+	      (dp->lag && obj->orig_dev == dp->lag->dev)))
 		return -EOPNOTSUPP;
 
 	if (dsa_port_skip_vlan_configuration(dp))
@@ -1911,6 +1913,33 @@ static int dsa_slave_changeupper(struct net_device *dev,
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
@@ -1996,10 +2025,26 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
index 3fb362b6874e..fbf437434e27 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -178,6 +178,61 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	return ds->ops->port_fdb_del(ds, port, info->addr, info->vid);
 }
 
+static int dsa_switch_lag_change(struct dsa_switch *ds,
+				 struct dsa_notifier_lag_info *info)
+{
+	struct dsa_switch_tree *dst = ds->dst;
+
+	if (dst->index == info->tree_index && ds->index == info->sw_index &&
+	    ds->ops->port_lag_change)
+		return ds->ops->port_lag_change(ds, info->port, info->info);
+
+	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
+	    ds->ops->crosschip_lag_change)
+		return ds->ops->crosschip_lag_change(ds, info->tree_index,
+						     info->sw_index,
+						     info->port, info->lag,
+						     info->info);
+
+	return 0;
+}
+
+static int dsa_switch_lag_join(struct dsa_switch *ds,
+			       struct dsa_notifier_lag_info *info)
+{
+	struct dsa_switch_tree *dst = ds->dst;
+
+	if (dst->index == info->tree_index && ds->index == info->sw_index &&
+	    ds->ops->port_lag_join)
+		return ds->ops->port_lag_join(ds, info->port, info->lag);
+
+	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
+	    ds->ops->crosschip_lag_join)
+		return ds->ops->crosschip_lag_join(ds, info->tree_index,
+						   info->sw_index,
+						   info->port, info->lag);
+
+	return 0;
+}
+
+static int dsa_switch_lag_leave(struct dsa_switch *ds,
+				struct dsa_notifier_lag_info *info)
+{
+	struct dsa_switch_tree *dst = ds->dst;
+
+	if (dst->index == info->tree_index && ds->index == info->sw_index &&
+	    ds->ops->port_lag_leave)
+		ds->ops->port_lag_leave(ds, info->port, info->lag);
+
+	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
+	    ds->ops->crosschip_lag_leave)
+		ds->ops->crosschip_lag_leave(ds, info->tree_index,
+					     info->sw_index,
+					     info->port, info->lag);
+
+	return 0;
+}
+
 static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
 				 struct dsa_notifier_mdb_info *info)
 {
@@ -325,6 +380,15 @@ static int dsa_switch_event(struct notifier_block *nb,
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

