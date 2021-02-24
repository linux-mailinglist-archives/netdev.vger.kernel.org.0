Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0381323B68
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhBXLoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhBXLoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:44:44 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4FEC061786
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:03 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id lr13so2504178ejb.8
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=39AoPWg2e/Xohh7EIpTv1jo8INkgLVqn1Wa/Oa/tSow=;
        b=pXE8InlNhHCx3LBMvzn/lV06dq7hx4zLaEi0a0eaObTqSGqR50HYNBV793PUJkOIjC
         ApoUpuoS/TYB2FSBH96TcYXjd1Zfjk/aaLf5b5eqOBS/sTsgWd2SurL5qEu842L8p3JE
         kLlOLkwilzoBpPFzERXtoeC5mVYvfMTwIiMg8LjRTXCY2WZyakboTt/M8JaSIMMR3Lki
         KUI9iOVCesivHXQN759Inr1dIMRzD57mh0ICdG1rowr9QbDlQ232OQxUCNFANJXzsVVZ
         NgLs2SmiiiDkEdCSBT9ag/DVDqzEOTqcFBf3MY6PMD6wnIOIhFGmxmtCwZT9K8tGjsMm
         nnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39AoPWg2e/Xohh7EIpTv1jo8INkgLVqn1Wa/Oa/tSow=;
        b=Nb7Z9+ymuPjb/6WW3VLg0iJpK3JCgXLNCP5tJYQYZDFswyzEIAJi9bk33ipFtfvcNI
         8kPEgiEfVuw6wIaaew7Ch2KExyZ6UAhac0aIgG4AWQWNhv0/D0CoRWyzHEzfEtHEcRyc
         IxXNnkBDdci2+Vx0Y1VFx/sOF4N9kS7Ps/PKRxDLscdAw3xaKM8Y85waBLpLGo0gIDcu
         iCGAoXvL0ZFL0z/SAGFZbTmCObd6zzoeTCMmZTyWH/FdPkbmCt8IEEPKRr7ZKEevHhu3
         zmLOQVJr6feQ1hs2n4pE5h0QiBm1lFX73zumnay5jqKgGq3SLALg5EU0GNMZh/VsTfiS
         v21Q==
X-Gm-Message-State: AOAM5317jVsqcxqKATBG0kW7j58is8UL7eyxRMERypkG0Tm3csYSG7Qr
        o/8GpPJoX15B1Z/WgVR78XQVTeDnuI4=
X-Google-Smtp-Source: ABdhPJxgncgBke+MptxEyuC8mQhnWktq4E9Mr8K1v6heyqU44xwy6OwQIc5PqZqr3RkaqOqUB1VpDg==
X-Received: by 2002:a17:906:758:: with SMTP id z24mr29726775ejb.406.1614167042165;
        Wed, 24 Feb 2021 03:44:02 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:01 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 01/17] net: dsa: reference count the host mdb addresses
Date:   Wed, 24 Feb 2021 13:43:34 +0200
Message-Id: <20210224114350.2791260-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently any DSA switch that is strict when implementing the mdb
operations prints these benign errors after the addresses expire, with
at least 2 ports bridged:

[  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)

The reason has to do with this piece of code:

	netdev_for_each_lower_dev(dev, lower_dev, iter)
		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);

called from:

br_multicast_group_expired
-> br_multicast_host_leave
   -> br_mdb_notify
      -> br_mdb_switchdev_host

Basically, the bridge code is correct. It tells each switchdev port that
the host can leave that multicast group. But in the case of DSA, all
user ports are connected to the host through the same pipe. So, because
DSA blindly translates a host MDB to a normal MDB on the CPU port, this
means that when all user ports leave a multicast group, DSA tries to
remove it N times from the CPU port.

We should be reference-counting these addresses. Otherwise, the first
port on which the MDB expires will cause an entry removal from the CPU
port, which will break the host MDB for the remaining ports.

There is more. In expectation of future support for multiple CPUs, the
addresses filtered towards the host should be kept in a list per CPU
port. And cross-chip setups with multiple CPU ports can be really
unconventional, nobody says that the switches must be cascaded. Consider
just this example:

               +-------------------------+
               |        Host system      |
               |                         |
               |  eth0             eth1  |
               +-------------------------+
          CPU port |                 | CPU port
             +-----------+     +-----------+
             |           | DSA |           |
             |           |-----|           |
             |           | link|           |
             +-----------+     +-----------+
               |  |  |  |       |  |  |  |
               sw0pN user       sw1pN user
                 ports            ports

It is clear that the host addresses of sw0 should not interfere with the
host addresses of sw1, and one switch should not even respond to the
notifiers emitted for the other's host addresses.

An entirely different thing can be said about the typical cross-chip
setup that DSA works with today:

               +-----------------+
               |   Host system   |
               |                 |
               |       eth0      |
               +-----------------+
                     CPU | port
                   +-----------+
            sw0pN -|           |
             user -|           |
            ports -|           |
                  -|           |
                   +-----------+
                     DSA | link
                   +-----------+
            sw1pN -|           |
             user -|           |
            ports -|           |
                  -|           |
                   +-----------+

where a host MDB entry installed on a user port of sw1pN should be
installed both on its upstream DSA link as well as on the CPU port
(but not on the downstream DSA link of sw0pN).

Basically this calls for the introduction of a separate notifier for
host addresses, which matches on all upstream ports of the targeted user
port (be they CPU ports or DSA links). This means we can simplify the
normal MDB notifiers to be identical to the FDB notifiers now.

Note that for switches which don't implement .port_mdb_add and
.port_mdb_del, we don't even attempt to keep the address lists, only to
fail at install time.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 34 ++++++++++++++++++
 net/dsa/dsa2.c     | 24 +++++++++++--
 net/dsa/dsa_priv.h |  6 ++++
 net/dsa/port.c     | 24 +++++++++++++
 net/dsa/slave.c    | 89 +++++++++++++++++++++++++++++++++++++++++-----
 net/dsa/switch.c   | 73 +++++++++++++++++++++++++++++--------
 6 files changed, 226 insertions(+), 24 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 83a933e563fe..31381bfcf35c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -290,6 +290,11 @@ struct dsa_port {
 	 */
 	const struct dsa_netdevice_ops *netdev_ops;
 
+	/* List of MAC addresses that must be extracted from the fabric
+	 * through this CPU port. Valid only for DSA_PORT_TYPE_CPU.
+	 */
+	struct list_head	host_mdb;
+
 	bool setup;
 };
 
@@ -304,6 +309,13 @@ struct dsa_link {
 	struct list_head list;
 };
 
+struct dsa_host_addr {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	refcount_t refcount;
+	struct list_head list;
+};
+
 struct dsa_switch {
 	bool setup;
 
@@ -481,6 +493,28 @@ static inline unsigned int dsa_upstream_port(struct dsa_switch *ds, int port)
 	return dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
 }
 
+static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
+{
+	if (dsa_is_unused_port(ds, port))
+		return false;
+
+	return port == dsa_upstream_port(ds, port);
+}
+
+/* Return true if @upstream_ds is an upstream switch of @downstream_ds. */
+static inline bool dsa_switch_is_upstream_of(struct dsa_switch *upstream_ds,
+					     struct dsa_switch *downstream_ds)
+{
+	int routing_port;
+
+	if (upstream_ds == downstream_ds)
+		return true;
+
+	routing_port = dsa_routing_port(downstream_ds, upstream_ds->index);
+
+	return dsa_is_upstream_port(downstream_ds, routing_port);
+}
+
 static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 {
 	const struct dsa_switch *ds = dp->ds;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 4d4956ed303b..d64f1287625d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -326,6 +326,11 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 	return NULL;
 }
 
+static void dsa_setup_cpu_port(struct dsa_port *cpu_dp)
+{
+	INIT_LIST_HEAD(&cpu_dp->host_mdb);
+}
+
 static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *cpu_dp, *dp;
@@ -336,6 +341,8 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 		return -EINVAL;
 	}
 
+	dsa_setup_cpu_port(cpu_dp);
+
 	/* Assign the default CPU port to all ports of the fabric */
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
@@ -344,13 +351,26 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 	return 0;
 }
 
+static void dsa_teardown_cpu_port(struct dsa_port *cpu_dp)
+{
+	struct dsa_host_addr *a, *tmp;
+
+	list_for_each_entry_safe(a, tmp, &cpu_dp->host_mdb, list) {
+		list_del(&a->list);
+		kfree(a);
+	}
+}
+
 static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp)) {
+			dsa_teardown_cpu_port(dp->cpu_dp);
 			dp->cpu_dp = NULL;
+		}
+	}
 }
 
 static int dsa_port_setup(struct dsa_port *dp)
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2eeaa42f2e08..c730d40b81b9 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -27,6 +27,8 @@ enum {
 	DSA_NOTIFIER_LAG_LEAVE,
 	DSA_NOTIFIER_MDB_ADD,
 	DSA_NOTIFIER_MDB_DEL,
+	DSA_NOTIFIER_HOST_MDB_ADD,
+	DSA_NOTIFIER_HOST_MDB_DEL,
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
@@ -203,6 +205,10 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_host_mdb_add(const struct dsa_port *dp,
+			  const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_host_mdb_del(const struct dsa_port *dp,
+			  const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 			      struct switchdev_brport_flags flags,
 			      struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c9c6d7ab3f47..df9ba9b67675 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -538,6 +538,30 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
 }
 
+int dsa_port_host_mdb_add(const struct dsa_port *dp,
+			  const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_notifier_mdb_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.mdb = mdb,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
+}
+
+int dsa_port_host_mdb_del(const struct dsa_port *dp,
+			  const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_notifier_mdb_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.mdb = mdb,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
+}
+
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan,
 		      struct netlink_ext_ack *extack)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 491e3761b5f4..14a51503efe0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -23,6 +23,85 @@
 
 #include "dsa_priv.h"
 
+static struct dsa_host_addr *dsa_host_addr_find(struct list_head *addr_list,
+						const unsigned char *addr,
+						u16 vid)
+{
+	struct dsa_host_addr *a;
+
+	list_for_each_entry(a, addr_list, list)
+		if (ether_addr_equal(a->addr, addr) && a->vid == vid)
+			return a;
+
+	return NULL;
+}
+
+/* DSA can directly translate this to a normal MDB add, but on the CPU port.
+ * But because multiple user ports can join the same multicast group and the
+ * bridge will emit a notification for each port, we need to add/delete the
+ * entry towards the host only once, so we reference count it.
+ */
+static int dsa_host_mdb_add(struct dsa_port *dp,
+			    const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_host_addr *a;
+	int err;
+
+	if (!dp->ds->ops->port_mdb_add || !dp->ds->ops->port_mdb_del)
+		return -EOPNOTSUPP;
+
+	a = dsa_host_addr_find(&cpu_dp->host_mdb, mdb->addr, mdb->vid);
+	if (a) {
+		refcount_inc(&a->refcount);
+		return 0;
+	}
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a)
+		return -ENOMEM;
+
+	err = dsa_port_host_mdb_add(dp, mdb);
+	if (err) {
+		kfree(a);
+		return err;
+	}
+
+	ether_addr_copy(a->addr, mdb->addr);
+	a->vid = mdb->vid;
+	refcount_set(&a->refcount, 1);
+	list_add_tail(&a->list, &cpu_dp->host_mdb);
+
+	return 0;
+}
+
+static int dsa_host_mdb_del(struct dsa_port *dp,
+			    const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_host_addr *a;
+	int err;
+
+	if (!dp->ds->ops->port_mdb_add || !dp->ds->ops->port_mdb_del)
+		return -EOPNOTSUPP;
+
+	a = dsa_host_addr_find(&cpu_dp->host_mdb, mdb->addr, mdb->vid);
+	if (!a)
+		return -ENOENT;
+
+	if (!refcount_dec_and_test(&a->refcount))
+		return 0;
+
+	err = dsa_port_host_mdb_del(dp, mdb);
+	if (err)
+		return err;
+
+	list_del(&a->list);
+	kfree(a);
+
+	return 0;
+}
+
 /* slave mii_bus handling ***************************************************/
 static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
 {
@@ -396,10 +475,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		/* DSA can directly translate this to a normal MDB add,
-		 * but on the CPU port.
-		 */
-		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
+		err = dsa_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = dsa_slave_vlan_add(dev, obj, extack);
@@ -464,10 +540,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		/* DSA can directly translate this to a normal MDB add,
-		 * but on the CPU port.
-		 */
-		err = dsa_port_mdb_del(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
+		err = dsa_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = dsa_slave_vlan_del(dev, obj);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4b5da89dc27a..94996e213469 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -148,6 +148,25 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	return 0;
 }
 
+/* Matches for all upstream-facing ports (the CPU port and all upstream-facing
+ * DSA links) that sit between the port that emitted the notification and the
+ * DSA master.
+ */
+static bool dsa_switch_host_address_match(struct dsa_switch *ds, int port,
+					  int info_sw_index, int info_port)
+{
+	struct dsa_switch *downstream_ds;
+
+	downstream_ds = dsa_switch_find(ds->dst->index, info_sw_index);
+	if (WARN_ON(!downstream_ds))
+		return false;
+
+	if (dsa_switch_is_upstream_of(ds, downstream_ds))
+		return dsa_is_upstream_port(ds, port);
+
+	return false;
+}
+
 static int dsa_switch_fdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
@@ -229,20 +248,30 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 	return 0;
 }
 
-static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
-				 struct dsa_notifier_mdb_info *info)
+static int dsa_switch_mdb_add(struct dsa_switch *ds,
+			      struct dsa_notifier_mdb_info *info)
 {
-	if (ds->index == info->sw_index && port == info->port)
-		return true;
+	int port = dsa_towards_port(ds, info->sw_index, info->port);
 
-	if (dsa_is_dsa_port(ds, port))
-		return true;
+	if (!ds->ops->port_mdb_add)
+		return -EOPNOTSUPP;
 
-	return false;
+	return ds->ops->port_mdb_add(ds, port, info->mdb);
 }
 
-static int dsa_switch_mdb_add(struct dsa_switch *ds,
+static int dsa_switch_mdb_del(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
+{
+	int port = dsa_towards_port(ds, info->sw_index, info->port);
+
+	if (!ds->ops->port_mdb_del)
+		return -EOPNOTSUPP;
+
+	return ds->ops->port_mdb_del(ds, port, info->mdb);
+}
+
+static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
+				   struct dsa_notifier_mdb_info *info)
 {
 	int err = 0;
 	int port;
@@ -251,7 +280,8 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 		return -EOPNOTSUPP;
 
 	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_mdb_match(ds, port, info)) {
+		if (dsa_switch_host_address_match(ds, port, info->sw_index,
+						  info->port)) {
 			err = ds->ops->port_mdb_add(ds, port, info->mdb);
 			if (err)
 				break;
@@ -261,16 +291,25 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 	return err;
 }
 
-static int dsa_switch_mdb_del(struct dsa_switch *ds,
-			      struct dsa_notifier_mdb_info *info)
+static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
+				   struct dsa_notifier_mdb_info *info)
 {
+	int err = 0;
+	int port;
+
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
-	if (ds->index == info->sw_index)
-		return ds->ops->port_mdb_del(ds, info->port, info->mdb);
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_host_address_match(ds, port, info->sw_index,
+						  info->port)) {
+			err = ds->ops->port_mdb_del(ds, info->port, info->mdb);
+			if (err)
+				break;
+		}
+	}
 
-	return 0;
+	return err;
 }
 
 static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
@@ -508,6 +547,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_MDB_DEL:
 		err = dsa_switch_mdb_del(ds, info);
 		break;
+	case DSA_NOTIFIER_HOST_MDB_ADD:
+		err = dsa_switch_host_mdb_add(ds, info);
+		break;
+	case DSA_NOTIFIER_HOST_MDB_DEL:
+		err = dsa_switch_host_mdb_del(ds, info);
+		break;
 	case DSA_NOTIFIER_VLAN_ADD:
 		err = dsa_switch_vlan_add(ds, info);
 		break;
-- 
2.25.1

