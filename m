Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B4D56A6E6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 17:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbiGGP3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 11:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbiGGP3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 11:29:51 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC6A17587;
        Thu,  7 Jul 2022 08:29:50 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 89E241886E72;
        Thu,  7 Jul 2022 15:29:48 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 81DF625032B7;
        Thu,  7 Jul 2022 15:29:48 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 7AAD2A1E00B8; Thu,  7 Jul 2022 15:29:48 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from wse-c0127.vestervang (unknown [208.127.141.28])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 1179E9120FED;
        Thu,  7 Jul 2022 15:29:47 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v4 net-next 2/6] net: switchdev: add support for offloading of fdb locked flag
Date:   Thu,  7 Jul 2022 17:29:26 +0200
Message-Id: <20220707152930.1789437-3-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220707152930.1789437-1-netdev@kapio-technology.com>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used for Mac-auth/MAB feature in the offloaded case.
Send flag through switchdev to driver.

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
---
 include/net/dsa.h         | 6 ++++++
 include/net/switchdev.h   | 1 +
 net/bridge/br.c           | 3 ++-
 net/bridge/br_fdb.c       | 7 +++++--
 net/bridge/br_private.h   | 2 +-
 net/bridge/br_switchdev.c | 1 +
 net/dsa/dsa_priv.h        | 4 +++-
 net/dsa/port.c            | 7 ++++++-
 net/dsa/slave.c           | 4 +++-
 net/dsa/switch.c          | 6 +++---
 10 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 14f07275852b..a5a843b2d67d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -330,6 +330,12 @@ struct dsa_port {
 	/* List of VLANs that CPU and DSA ports are members of. */
 	struct mutex		vlans_lock;
 	struct list_head	vlans;
+
+	/* List and maintenance of locked ATU entries */
+	struct mutex		locked_entries_list_lock;
+	struct list_head	atu_locked_entries_list;
+	atomic_t		atu_locked_entry_cnt;
+	struct delayed_work	atu_work;
 };
 
 /* TODO: ideally DSA ports would have a single dp->link_dp member,
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index aa0171d5786d..9f83c835ee62 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -245,6 +245,7 @@ struct switchdev_notifier_fdb_info {
 	u16 vid;
 	u8 added_by_user:1,
 	   is_local:1,
+	   is_locked:1,
 	   offloaded:1;
 };
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 96e91d69a9a8..fe0a4741fcda 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid, false);
+						fdb_info->vid, false,
+						fdb_info->is_locked);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index ee9064a536ae..32ebb18050b9 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1136,7 +1136,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 					   "FDB entry towards bridge must be permanent");
 			return -EINVAL;
 		}
-		err = br_fdb_external_learn_add(br, p, addr, vid, true);
+		err = br_fdb_external_learn_add(br, p, addr, vid, true, false);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1366,7 +1366,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify)
+			      bool swdev_notify, bool locked)
 {
 	struct net_bridge_fdb_entry *fdb;
 	bool modified = false;
@@ -1386,6 +1386,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (!p)
 			flags |= BIT(BR_FDB_LOCAL);
 
+		if (locked)
+			flags |= BIT(BR_FDB_ENTRY_LOCKED);
+
 		fdb = fdb_create(br, p, addr, vid, flags);
 		if (!fdb) {
 			err = -ENOMEM;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 47a3598d25c8..9082451b4d40 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -811,7 +811,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify);
+			      bool swdev_notify, bool locked);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify);
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 8f3d76c751dd..85e566b856e1 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -136,6 +136,7 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
 	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
 	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item->is_locked = test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags);
 	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
 	item->info.ctx = ctx;
 }
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..42f47a94b0f0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -65,6 +65,7 @@ struct dsa_notifier_fdb_info {
 	const struct dsa_port *dp;
 	const unsigned char *addr;
 	u16 vid;
+	bool is_locked;
 	struct dsa_db db;
 };
 
@@ -131,6 +132,7 @@ struct dsa_switchdev_event_work {
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	bool host_addr;
+	bool is_locked;
 };
 
 enum dsa_standalone_event {
@@ -232,7 +234,7 @@ int dsa_port_vlan_msti(struct dsa_port *dp,
 		       const struct switchdev_vlan_msti *msti);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid);
+		     u16 vid, bool is_locked);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3738f2d40a0b..8bdac9aabe5d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -35,6 +35,7 @@ static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp, u16 vid)
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	struct switchdev_notifier_fdb_info info = {
 		.vid = vid,
+		.is_locked = false,
 	};
 
 	/* When the port becomes standalone it has already left the bridge.
@@ -950,12 +951,13 @@ int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu)
 }
 
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid)
+		     u16 vid, bool is_locked)
 {
 	struct dsa_notifier_fdb_info info = {
 		.dp = dp,
 		.addr = addr,
 		.vid = vid,
+		.is_locked = is_locked,
 		.db = {
 			.type = DSA_DB_BRIDGE,
 			.bridge = *dp->bridge,
@@ -979,6 +981,7 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		.dp = dp,
 		.addr = addr,
 		.vid = vid,
+		.is_locked = false,
 		.db = {
 			.type = DSA_DB_BRIDGE,
 			.bridge = *dp->bridge,
@@ -999,6 +1002,7 @@ static int dsa_port_host_fdb_add(struct dsa_port *dp,
 		.dp = dp,
 		.addr = addr,
 		.vid = vid,
+		.is_locked = false,
 		.db = db,
 	};
 
@@ -1050,6 +1054,7 @@ static int dsa_port_host_fdb_del(struct dsa_port *dp,
 		.dp = dp,
 		.addr = addr,
 		.vid = vid,
+		.is_locked = false,
 		.db = db,
 	};
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 801a5d445833..905b15e4eab9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2784,6 +2784,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		container_of(work, struct dsa_switchdev_event_work, work);
 	const unsigned char *addr = switchdev_work->addr;
 	struct net_device *dev = switchdev_work->dev;
+	bool is_locked = switchdev_work->is_locked;
 	u16 vid = switchdev_work->vid;
 	struct dsa_switch *ds;
 	struct dsa_port *dp;
@@ -2799,7 +2800,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		else if (dp->lag)
 			err = dsa_port_lag_fdb_add(dp, addr, vid);
 		else
-			err = dsa_port_fdb_add(dp, addr, vid);
+			err = dsa_port_fdb_add(dp, addr, vid, is_locked);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
@@ -2907,6 +2908,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
 	switchdev_work->vid = fdb_info->vid;
 	switchdev_work->host_addr = host_addr;
+	switchdev_work->is_locked = fdb_info->is_locked;
 
 	dsa_schedule_work(&switchdev_work->work);
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 2b56218fc57c..32b1e7ac6373 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -234,7 +234,7 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 }
 
 static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			       u16 vid, struct dsa_db db)
+			       u16 vid, bool is_locked, struct dsa_db db)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -398,7 +398,7 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->dp)) {
 			err = dsa_port_do_fdb_add(dp, info->addr, info->vid,
-						  info->db);
+						  false, info->db);
 			if (err)
 				break;
 		}
@@ -437,7 +437,7 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->db);
+	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->is_locked, info->db);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
-- 
2.30.2

