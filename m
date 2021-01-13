Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA7B2F46C4
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 09:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbhAMIoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 03:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbhAMIog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 03:44:36 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC61BC0617A2
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:45 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id m13so1596310ljo.11
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=3hQoWGXwl9ouPepPRNu7SzxfWUk7k2Gpp6kvQZc18OQ=;
        b=pXnli98zhZhse1aNXCoo0DW3KdLSL8mDzGSS67ZPSjwkkWhB2LTruYbkBSqHRsjz7T
         1vcRfto3SKUwE9rX2vnsGCbz40zAwX/iWEY5fGhQ3iUpcfilNgPrB2u8rlLBEPtqlx2v
         0FJbrg3eQFOEAbzjQ0yb00l64piE30uWmHhlVgBBLACqlEOXX3giFmo0BM5z2g03SKJj
         +ya0dFCksv5UPi/RCY9rqrgg8wLBKv+0I90HUCFQ/jNBItk7u+OCozZNS9/wyA8yRWdH
         pNvTyj6ixEejbQ/x473a4bvMl2GsPFKBodOgPeHXTWNbxIMpogoGmrQ0imkOipbg/Vc3
         wt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=3hQoWGXwl9ouPepPRNu7SzxfWUk7k2Gpp6kvQZc18OQ=;
        b=Zy9gxfOQZSfzw7GW7polkPVb3g5kjPfenLVeIkts3euOqBIy0/g+WqujFqbrvDHl5U
         ic863ni3QnnpW21y8zw/HcBL+wv/xagTwj8jRkPuazAeJOYuW31WvgBOa2+FeDBukKx/
         ytQ8ixEujlkG/L3mKP8W9ipsuqdGw3yJm6Wg4w1NGTKrz51x+tqZy7+StO2GkjEmEh9K
         oP3jIq4GvyRAmNu4HpvaVptl1QzXHCijB4tcdlNokoVw1O9cr5Af3SOkfACsVKcC2YXv
         mM9dUTRJOanfttWQCzyL0Tu+lcmV5mQr5Uoq+/ki66C6N2DRJLnHEAdX+8dR9I1X9MJB
         3PKQ==
X-Gm-Message-State: AOAM5311P6u2ig3X4XgysVr5C0SsBVKCI9FiTvWtWTQgVs5nuLidpSQ2
        1U66+pxlLajrQ/Euz36115+D2Q==
X-Google-Smtp-Source: ABdhPJwX3TMarOfJuBRCJHKXKSggXcoyzp98ClrwYR9EFpjuRcnycVDfwTFjtBqNLmqGB+w41K11FA==
X-Received: by 2002:a2e:8844:: with SMTP id z4mr471876ljj.412.1610527424220;
        Wed, 13 Jan 2021 00:43:44 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u14sm137027lfk.108.2021.01.13.00.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 00:43:43 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v5 net-next 3/5] net: dsa: Link aggregation support
Date:   Wed, 13 Jan 2021 09:42:53 +0100
Message-Id: <20210113084255.22675-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210113084255.22675-1-tobias@waldekranz.com>
References: <20210113084255.22675-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Monitor the following events and notify the driver when:

- A DSA port joins/leaves a LAG.
- A LAG, made up of DSA ports, joins/leaves a bridge.
- A DSA port in a LAG is enabled/disabled (enabled meaning
  "distributing" in 802.3ad LACP terms).

When a LAG joins a bridge, the DSA subsystem will treat that as each
individual port joining the bridge. The driver may look at the port's
LAG device pointer to see if it is associated with any LAG, if that is
required. This is analogue to how switchdev events are replicated out
to all lower devices when reaching e.g. a LAG.

Drivers can optionally request that DSA maintain a linear mapping from
a LAG ID to the corresponding netdev by setting ds->num_lag_ids to the
desired size.

In the event that the hardware is not capable of offloading a
particular LAG for any reason (the typical case being use of exotic
modes like broadcast), DSA will take a hands-off approach, allowing
the LAG to be formed as a pure software construct. This is reported
back through the extended ACK, but is otherwise transparent to the
user.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
---

I tried in vain to win checkpatch's approval of the foreach macros, no
matter how many parentheses I added. Looking at existing macros, this
style seems to be widely accepted. Is this a known issue?

 include/net/dsa.h  | 60 ++++++++++++++++++++++++++++++
 net/dsa/dsa2.c     | 93 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h | 36 ++++++++++++++++++
 net/dsa/port.c     | 79 +++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    | 70 ++++++++++++++++++++++++++++++----
 net/dsa/switch.c   | 50 +++++++++++++++++++++++++
 6 files changed, 381 insertions(+), 7 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index c3485ba6c312..06e3784ec55c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -149,8 +149,41 @@ struct dsa_switch_tree {
 
 	/* List of DSA links composing the routing table */
 	struct list_head rtable;
+
+	/* Maps offloaded LAG netdevs to a zero-based linear ID for
+	 * drivers that need it.
+	 */
+	struct net_device **lags;
+	unsigned int lags_len;
 };
 
+#define dsa_lags_foreach_id(_id, _dst)				\
+	for ((_id) = 0; (_id) < (_dst)->lags_len; (_id)++)	\
+		if ((_dst)->lags[(_id)])
+
+#define dsa_lag_foreach_port(_dp, _dst, _lag)			\
+	list_for_each_entry((_dp), &(_dst)->ports, list)	\
+		if ((_dp)->lag_dev == (_lag))
+
+static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
+					     unsigned int id)
+{
+	return dst->lags[id];
+}
+
+static inline int dsa_lag_id(struct dsa_switch_tree *dst,
+			     struct net_device *lag)
+{
+	unsigned int id;
+
+	dsa_lags_foreach_id(id, dst) {
+		if (dsa_lag_dev(dst, id) == lag)
+			return id;
+	}
+
+	return -ENODEV;
+}
+
 /* TC matchall action types */
 enum dsa_port_mall_action_type {
 	DSA_PORT_MALL_MIRROR,
@@ -220,6 +253,8 @@ struct dsa_port {
 	bool			devlink_port_setup;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
+	struct net_device	*lag_dev;
+	bool			lag_tx_enabled;
 
 	struct list_head list;
 
@@ -340,6 +375,14 @@ struct dsa_switch {
 	 */
 	bool			mtu_enforcement_ingress;
 
+	/* Drivers that benefit from having an ID associated with each
+	 * offloaded LAG should set this to the maximum number of
+	 * supported IDs. DSA will then maintain a mapping of _at
+	 * least_ these many IDs, accessible to drivers via
+	 * dsa_lag_id().
+	 */
+	unsigned int		num_lag_ids;
+
 	size_t num_ports;
 };
 
@@ -626,6 +669,13 @@ struct dsa_switch_ops {
 	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int tree_index,
 					  int sw_index, int port,
 					  struct net_device *br);
+	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
+					int port);
+	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
+				      int port, struct net_device *lag,
+				      struct netdev_lag_upper_info *info);
+	int	(*crosschip_lag_leave)(struct dsa_switch *ds, int sw_index,
+				       int port, struct net_device *lag);
 
 	/*
 	 * PTP functionality
@@ -657,6 +707,16 @@ struct dsa_switch_ops {
 	int	(*port_change_mtu)(struct dsa_switch *ds, int port,
 				   int new_mtu);
 	int	(*port_max_mtu)(struct dsa_switch *ds, int port);
+
+	/*
+	 * LAG integration
+	 */
+	int	(*port_lag_change)(struct dsa_switch *ds, int port);
+	int	(*port_lag_join)(struct dsa_switch *ds, int port,
+				 struct net_device *lag,
+				 struct netdev_lag_upper_info *info);
+	int	(*port_lag_leave)(struct dsa_switch *ds, int port,
+				  struct net_device *lag);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 01f21b0b379a..fd343466df27 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -21,6 +21,65 @@
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
+/**
+ * dsa_lag_map() - Map LAG netdev to a linear LAG ID
+ * @dst: Tree in which to record the mapping.
+ * @lag: Netdev that is to be mapped to an ID.
+ *
+ * dsa_lag_id/dsa_lag_dev can then be used to translate between the
+ * two spaces. The size of the mapping space is determined by the
+ * driver by setting ds->num_lag_ids. It is perfectly legal to leave
+ * it unset if it is not needed, in which case these functions become
+ * no-ops.
+ */
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
+{
+	unsigned int id;
+
+	if (dsa_lag_id(dst, lag) >= 0)
+		/* Already mapped */
+		return;
+
+	for (id = 0; id < dst->lags_len; id++) {
+		if (!dsa_lag_dev(dst, id)) {
+			dst->lags[id] = lag;
+			return;
+		}
+	}
+
+	/* No IDs left, which is OK. Some drivers do not need it. The
+	 * ones that do, e.g. mv88e6xxx, will discover that dsa_lag_id
+	 * returns an error for this device when joining the LAG. The
+	 * driver can then return -EOPNOTSUPP back to DSA, which will
+	 * fall back to a software LAG.
+	 */
+}
+
+/**
+ * dsa_lag_unmap() - Remove a LAG ID mapping
+ * @dst: Tree in which the mapping is recorded.
+ * @lag: Netdev that was mapped.
+ *
+ * As there may be multiple users of the mapping, it is only removed
+ * if there are no other references to it.
+ */
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
+{
+	struct dsa_port *dp;
+	unsigned int id;
+
+	dsa_lag_foreach_port(dp, dst, lag)
+		/* There are remaining users of this mapping */
+		return;
+
+	dsa_lags_foreach_id(id, dst) {
+		if (dsa_lag_dev(dst, id) == lag) {
+			dst->lags[id] = NULL;
+			break;
+		}
+	}
+}
+
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index)
 {
 	struct dsa_switch_tree *dst;
@@ -578,6 +637,32 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 			dsa_master_teardown(dp->master);
 }
 
+static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
+{
+	unsigned int len = 0;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->num_lag_ids > len)
+			len = dp->ds->num_lag_ids;
+	}
+
+	if (!len)
+		return 0;
+
+	dst->lags = kcalloc(len, sizeof(*dst->lags), GFP_KERNEL);
+	if (!dst->lags)
+		return -ENOMEM;
+
+	dst->lags_len = len;
+	return 0;
+}
+
+static void dsa_tree_teardown_lags(struct dsa_switch_tree *dst)
+{
+	kfree(dst->lags);
+}
+
 static int dsa_tree_setup(struct dsa_switch_tree *dst)
 {
 	bool complete;
@@ -605,12 +690,18 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
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
@@ -626,6 +717,8 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 	if (!dst->setup)
 		return;
 
+	dsa_tree_teardown_lags(dst);
+
 	dsa_tree_teardown_master(dst);
 
 	dsa_tree_teardown_switches(dst);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 89143cc049db..2ce46bb87703 100644
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
@@ -55,6 +58,15 @@ struct dsa_notifier_mdb_info {
 	int port;
 };
 
+/* DSA_NOTIFIER_LAG_* */
+struct dsa_notifier_lag_info {
+	struct net_device *lag;
+	int sw_index;
+	int port;
+
+	struct netdev_lag_upper_info *info;
+};
+
 /* DSA_NOTIFIER_VLAN_* */
 struct dsa_notifier_vlan_info {
 	const struct switchdev_obj_port_vlan *vlan;
@@ -134,6 +146,11 @@ void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
+int dsa_port_lag_change(struct dsa_port *dp,
+			struct netdev_lag_lower_state_info *linfo);
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
+		      struct netdev_lag_upper_info *uinfo);
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
@@ -159,6 +176,22 @@ int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
+static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
+					    struct net_device *dev)
+{
+	/* Switchdev offloading can be configured on: */
+
+	if (dev == dp->slave)
+		/* DSA ports directly connected to a bridge. */
+		return true;
+
+	if (dp->lag_dev == dev)
+		/* DSA ports connected to a bridge via a LAG */
+		return true;
+
+	return false;
+}
+
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
@@ -248,6 +281,9 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
 /* dsa2.c */
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
+
 extern struct list_head dsa_tree_list;
 
 #endif
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e59bf66c4c0d..f5b0f72ee7cd 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -191,6 +191,85 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 }
 
+int dsa_port_lag_change(struct dsa_port *dp,
+			struct netdev_lag_lower_state_info *linfo)
+{
+	struct dsa_notifier_lag_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+	};
+	bool tx_enabled;
+
+	if (!dp->lag_dev)
+		return 0;
+
+	/* On statically configured aggregates (e.g. loadbalance
+	 * without LACP) ports will always be tx_enabled, even if the
+	 * link is down. Thus we require both link_up and tx_enabled
+	 * in order to include it in the tx set.
+	 */
+	tx_enabled = linfo->link_up && linfo->tx_enabled;
+
+	if (tx_enabled == dp->lag_tx_enabled)
+		return 0;
+
+	dp->lag_tx_enabled = tx_enabled;
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
+}
+
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
+		      struct netdev_lag_upper_info *uinfo)
+{
+	struct dsa_notifier_lag_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.lag = lag,
+		.info = uinfo,
+	};
+	int err;
+
+	dsa_lag_map(dp->ds->dst, lag);
+	dp->lag_dev = lag;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
+	if (err) {
+		dp->lag_dev = NULL;
+		dsa_lag_unmap(dp->ds->dst, lag);
+	}
+
+	return err;
+}
+
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
+{
+	struct dsa_notifier_lag_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.lag = lag,
+	};
+	int err;
+
+	if (!dp->lag_dev)
+		return;
+
+	/* Port might have been part of a LAG that in turn was
+	 * attached to a bridge.
+	 */
+	if (dp->bridge_dev)
+		dsa_port_bridge_leave(dp, dp->bridge_dev);
+
+	dp->lag_tx_enabled = false;
+	dp->lag_dev = NULL;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
+	if (err)
+		pr_err("DSA: failed to notify DSA_NOTIFIER_LAG_LEAVE: %d\n",
+		       err);
+
+	dsa_lag_unmap(dp->ds->dst, lag);
+}
+
 /* Must be called under rcu_read_lock() */
 static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 					      bool vlan_filtering)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e53c8ca6eb66..c5c81cba8259 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -273,7 +273,7 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
-	if (attr->orig_dev != dev)
+	if (!dsa_port_offloads_netdev(dp, attr->orig_dev))
 		return -EOPNOTSUPP;
 
 	switch (attr->id) {
@@ -333,7 +333,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct switchdev_obj_port_vlan vlan;
 	int err;
 
-	if (obj->orig_dev != dev)
+	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
 		return -EOPNOTSUPP;
 
 	if (dsa_port_skip_vlan_configuration(dp))
@@ -378,7 +378,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (obj->orig_dev != dev)
+		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
@@ -407,7 +407,7 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct switchdev_obj_port_vlan *vlan;
 	int err;
 
-	if (obj->orig_dev != dev)
+	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
 		return -EOPNOTSUPP;
 
 	if (dsa_port_skip_vlan_configuration(dp))
@@ -435,7 +435,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (obj->orig_dev != dev)
+		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
@@ -1907,6 +1907,46 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			dsa_port_bridge_leave(dp, info->upper_dev);
 			err = NOTIFY_OK;
 		}
+	} else if (netif_is_lag_master(info->upper_dev)) {
+		if (info->linking) {
+			err = dsa_port_lag_join(dp, info->upper_dev,
+						info->upper_info);
+			if (err == -EOPNOTSUPP) {
+				NL_SET_ERR_MSG_MOD(info->info.extack,
+						   "Offloading not supported");
+				err = 0;
+			}
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
+		if (!dp->lag_dev)
+			/* Software LAG */
+			continue;
+
+		err = dsa_slave_changeupper(lower, info);
+		if (notifier_to_errno(err))
+			break;
 	}
 
 	return err;
@@ -2004,10 +2044,26 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
index 21d2f842d068..cc0b25f3adea 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -166,6 +166,47 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	return ds->ops->port_fdb_del(ds, port, info->addr, info->vid);
 }
 
+static int dsa_switch_lag_change(struct dsa_switch *ds,
+				 struct dsa_notifier_lag_info *info)
+{
+	if (ds->index == info->sw_index && ds->ops->port_lag_change)
+		return ds->ops->port_lag_change(ds, info->port);
+
+	if (ds->index != info->sw_index && ds->ops->crosschip_lag_change)
+		return ds->ops->crosschip_lag_change(ds, info->sw_index,
+						     info->port);
+
+	return 0;
+}
+
+static int dsa_switch_lag_join(struct dsa_switch *ds,
+			       struct dsa_notifier_lag_info *info)
+{
+	if (ds->index == info->sw_index && ds->ops->port_lag_join)
+		return ds->ops->port_lag_join(ds, info->port, info->lag,
+					      info->info);
+
+	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
+		return ds->ops->crosschip_lag_join(ds, info->sw_index,
+						   info->port, info->lag,
+						   info->info);
+
+	return 0;
+}
+
+static int dsa_switch_lag_leave(struct dsa_switch *ds,
+				struct dsa_notifier_lag_info *info)
+{
+	if (ds->index == info->sw_index && ds->ops->port_lag_leave)
+		return ds->ops->port_lag_leave(ds, info->port, info->lag);
+
+	if (ds->index != info->sw_index && ds->ops->crosschip_lag_leave)
+		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
+						    info->port, info->lag);
+
+	return 0;
+}
+
 static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
 				 struct dsa_notifier_mdb_info *info)
 {
@@ -278,6 +319,15 @@ static int dsa_switch_event(struct notifier_block *nb,
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

