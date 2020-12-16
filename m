Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F9E2DC3AC
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgLPQCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPQCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:02:33 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8325C06138C
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:52 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id m12so49653709lfo.7
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=RdTBGN1HmJqT2N2ONm2SGCRNv+qzYAuN0umK6dR2mB0=;
        b=nGMmx1zR0reURpxHh6KyHPx+EZ5uVquG2Q1fvcBthOZP+AKdk27J8aL48loGktGW7H
         /cENHtEPTPQ4csa9mTmcv1jwlZ5F/6YJLS4AXYT2A5292d+3jHQXELaMmN3/7/19JyOF
         icBvrlaBw2TeD1ILDrIUz/dteLbQOd03Or+E7UqvjolG9/F+BQH3eWNytv1UpJwiP0vQ
         Td30Y67ZUzYHAXUGgs9696ZZOs7G22Yig8MvJIygBcRPfnIycHQqospL7B+qjOuDNX8R
         9bXoUCS/IROumY6KaaTm6Cd5gHxEzcZVJ8vVlBnfba7t91QdfPHiBqaBw9OlKv6bbGrH
         ChIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=RdTBGN1HmJqT2N2ONm2SGCRNv+qzYAuN0umK6dR2mB0=;
        b=O3QCxKOVybZSm7dtfco6KfbkQ7GaEF+br/Tm1e+v8m1hbw7boNYFiEtyILE7vuX1Ho
         QI/b2WqNMvQHjvA7yXSBR/56WK5ntRI2F9mcQ0y3fDccoBuYVAnuapA+bml4pHPr5Mww
         fSkEB6jYVgDTSAH9ETQLEfIAMUlATcndZi1ZTv5gc/JBDzRMIM0fyFA03RL+hC9WtVe2
         6dVYoitYhGlYflAUEZDFi7cBWKZKIH79T9w1nB1xDx/g5aD/73pQ/2daivC18Am8aWHO
         zVqog/NMb2PAxo0gETx1H3jDpANwl8aJZFlB7L6Ht3UH3I34W3BLi4nl4nQV/NlHwXcS
         eV7A==
X-Gm-Message-State: AOAM532/zzNYK+XMzNfhxX0BjhrQjst8sy/y23tPXsZQzzNH4FGsSqjv
        u2k1G1J53svnRXKnlE2ku44OWg==
X-Google-Smtp-Source: ABdhPJyRL7U/ch895z9t3732SMvNEh/WoIG9WJeUQxM+hmDzaqsWBNptLMHKKMRFfBgSC/qNFwrUOg==
X-Received: by 2002:a19:c001:: with SMTP id q1mr12166486lff.55.1608134509990;
        Wed, 16 Dec 2020 08:01:49 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id e25sm275877lfc.40.2020.12.16.08.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:01:49 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 3/5] net: dsa: Link aggregation support
Date:   Wed, 16 Dec 2020 17:00:54 +0100
Message-Id: <20201216160056.27526-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216160056.27526-1-tobias@waldekranz.com>
References: <20201216160056.27526-1-tobias@waldekranz.com>
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
---

I tried in vain to win checkpatch's approval of the foreach macros, no
matter how many parentheses I added. Looking at existing macros, this
style seems to be widely accepted. Is this a known issue?

 include/net/dsa.h  | 60 +++++++++++++++++++++++++++++++++++
 net/dsa/dsa2.c     | 74 +++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h | 36 +++++++++++++++++++++
 net/dsa/port.c     | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    | 70 ++++++++++++++++++++++++++++++++++++----
 net/dsa/switch.c   | 50 +++++++++++++++++++++++++++++
 6 files changed, 362 insertions(+), 7 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..9092c711a37c 100644
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
+		if ((_dst)->lags[_id])
+
+#define dsa_lag_foreach_port(_dp, _dst, _lag)	       \
+	list_for_each_entry(_dp, &(_dst)->ports, list) \
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
 
@@ -335,6 +370,14 @@ struct dsa_switch {
 	 */
 	bool			mtu_enforcement_ingress;
 
+	/* Drivers that benefit from having an ID associated with each
+	 * offloaded LAG should set this to the maximum number of
+	 * supported IDs. DSA will then maintain a mapping of _at
+	 * least_ these many IDs, accessible to drivers via
+	 * dsa_tree_lag_id().
+	 */
+	unsigned int		num_lag_ids;
+
 	size_t num_ports;
 };
 
@@ -624,6 +667,13 @@ struct dsa_switch_ops {
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
@@ -655,6 +705,16 @@ struct dsa_switch_ops {
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
index 183003e45762..deee4c0ecb31 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -21,6 +21,46 @@
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
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
+	 * ones that do, e.g. mv88e6xxx, will discover that
+	 * dsa_tree_lag_id returns an error for this device when
+	 * joining the LAG. The driver can then return -EOPNOTSUPP
+	 * back to DSA, which will fall back to a software LAG.
+	 */
+}
+
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
@@ -578,6 +618,32 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
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
@@ -605,12 +671,18 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
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
@@ -626,6 +698,8 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 	if (!dst->setup)
 		return;
 
+	dsa_tree_teardown_lags(dst);
+
 	dsa_tree_teardown_master(dst);
 
 	dsa_tree_teardown_switches(dst);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c96aae9062c..792557b59062 100644
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
@@ -135,6 +147,11 @@ void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
+int dsa_port_lag_change(struct dsa_port *dp,
+			struct netdev_lag_lower_state_info *linfo);
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
+		      struct netdev_lag_upper_info *uinfo);
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct switchdev_trans *trans);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
@@ -167,6 +184,22 @@ int dsa_port_link_register_of(struct dsa_port *dp);
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
@@ -257,6 +290,9 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
 /* dsa2.c */
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
+
 extern struct list_head dsa_tree_list;
 
 #endif
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 73569c9af3cc..121e5044dbe7 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -193,6 +193,85 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
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
index faae8dcc0849..f1197d1f1e90 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -274,7 +274,7 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
-	if (attr->orig_dev != dev)
+	if (!dsa_port_offloads_netdev(dp, attr->orig_dev))
 		return -EOPNOTSUPP;
 
 	switch (attr->id) {
@@ -337,7 +337,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct switchdev_obj_port_vlan vlan;
 	int vid, err;
 
-	if (obj->orig_dev != dev)
+	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
 		return -EOPNOTSUPP;
 
 	if (dsa_port_skip_vlan_configuration(dp))
@@ -394,7 +394,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (obj->orig_dev != dev)
+		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj), trans);
 		break;
@@ -424,7 +424,7 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct switchdev_obj_port_vlan *vlan;
 	int vid, err;
 
-	if (obj->orig_dev != dev)
+	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
 		return -EOPNOTSUPP;
 
 	if (dsa_port_skip_vlan_configuration(dp))
@@ -453,7 +453,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (obj->orig_dev != dev)
+		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
@@ -1944,6 +1944,46 @@ static int dsa_slave_changeupper(struct net_device *dev,
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
@@ -2041,10 +2081,26 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
index 3fb362b6874e..5cacf1caf068 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -178,6 +178,47 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
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
@@ -325,6 +366,15 @@ static int dsa_switch_event(struct notifier_block *nb,
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

