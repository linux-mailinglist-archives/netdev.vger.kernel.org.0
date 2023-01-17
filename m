Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326B466E7F8
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 21:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjAQUw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 15:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbjAQUtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 15:49:23 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5199886EE3;
        Tue, 17 Jan 2023 11:25:06 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id AE21A18835E0;
        Tue, 17 Jan 2023 18:59:13 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 9A4A1250007B;
        Tue, 17 Jan 2023 18:59:13 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 889F29EC000B; Tue, 17 Jan 2023 18:59:13 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id E4C7591201E3;
        Tue, 17 Jan 2023 18:59:12 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com (maintainer:MICROCHIP KSZ SERIES ETHERNET
        SWITCH DRIVER), Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-renesas-soc@vger.kernel.org (open list:RENESAS RZ/N1 A5PSW SWITCH
        DRIVER),
        bridge@lists.linux-foundation.org (moderated list:ETHERNET BRIDGE)
Subject: [RFC PATCH net-next 2/5] net: dsa: propagate flags down towards drivers
Date:   Tue, 17 Jan 2023 19:57:11 +0100
Message-Id: <20230117185714.3058453-3-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117185714.3058453-1-netdev@kapio-technology.com>
References: <20230117185714.3058453-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dynamic FDB flag needs to be propagated through the DSA layer to be
added to drivers.
Use a u16 for fdb flags for future use, so that other flags can also be
sent the same way without having to change function interfaces.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 include/net/dsa.h |  2 ++
 net/dsa/port.c    | 28 ++++++++++++++++------------
 net/dsa/port.h    |  8 ++++----
 net/dsa/slave.c   | 17 +++++++++++++----
 net/dsa/switch.c  | 18 ++++++++++++------
 net/dsa/switch.h  |  1 +
 6 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 96086289aa9b..f697d56e52d5 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -818,6 +818,8 @@ static inline bool dsa_port_tree_same(const struct dsa_port *a,
 	return a->ds->dst == b->ds->dst;
 }
 
+#define DSA_FDB_FLAG_DYNAMIC		BIT(0)
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 67ad1adec2a2..65b8c4470d59 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -976,12 +976,13 @@ int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu)
 }
 
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid)
+		     u16 vid, u16 fdb_flags)
 {
 	struct dsa_notifier_fdb_info info = {
 		.dp = dp,
 		.addr = addr,
 		.vid = vid,
+		.fdb_flags = fdb_flags,
 		.db = {
 			.type = DSA_DB_BRIDGE,
 			.bridge = *dp->bridge,
@@ -999,12 +1000,13 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 }
 
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid)
+		     u16 vid, u16 fdb_flags)
 {
 	struct dsa_notifier_fdb_info info = {
 		.dp = dp,
 		.addr = addr,
 		.vid = vid,
+		.fdb_flags = fdb_flags,
 		.db = {
 			.type = DSA_DB_BRIDGE,
 			.bridge = *dp->bridge,
@@ -1019,12 +1021,13 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 
 static int dsa_port_host_fdb_add(struct dsa_port *dp,
 				 const unsigned char *addr, u16 vid,
-				 struct dsa_db db)
+				 u16 fdb_flags, struct dsa_db db)
 {
 	struct dsa_notifier_fdb_info info = {
 		.dp = dp,
 		.addr = addr,
 		.vid = vid,
+		.fdb_flags = fdb_flags,
 		.db = db,
 	};
 
@@ -1042,11 +1045,11 @@ int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
 		.dp = dp,
 	};
 
-	return dsa_port_host_fdb_add(dp, addr, vid, db);
+	return dsa_port_host_fdb_add(dp, addr, vid, 0, db);
 }
 
-int dsa_port_bridge_host_fdb_add(struct dsa_port *dp,
-				 const unsigned char *addr, u16 vid)
+int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+				 u16 vid, u16 fdb_flags)
 {
 	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
@@ -1065,17 +1068,18 @@ int dsa_port_bridge_host_fdb_add(struct dsa_port *dp,
 			return err;
 	}
 
-	return dsa_port_host_fdb_add(dp, addr, vid, db);
+	return dsa_port_host_fdb_add(dp, addr, vid, fdb_flags, db);
 }
 
 static int dsa_port_host_fdb_del(struct dsa_port *dp,
 				 const unsigned char *addr, u16 vid,
-				 struct dsa_db db)
+				 u16 fdb_flags, struct dsa_db db)
 {
 	struct dsa_notifier_fdb_info info = {
 		.dp = dp,
 		.addr = addr,
 		.vid = vid,
+		.fdb_flags = fdb_flags,
 		.db = db,
 	};
 
@@ -1093,11 +1097,11 @@ int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
 		.dp = dp,
 	};
 
-	return dsa_port_host_fdb_del(dp, addr, vid, db);
+	return dsa_port_host_fdb_del(dp, addr, vid, 0, db);
 }
 
-int dsa_port_bridge_host_fdb_del(struct dsa_port *dp,
-				 const unsigned char *addr, u16 vid)
+int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+				 u16 vid, u16 fdb_flags)
 {
 	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
@@ -1112,7 +1116,7 @@ int dsa_port_bridge_host_fdb_del(struct dsa_port *dp,
 			return err;
 	}
 
-	return dsa_port_host_fdb_del(dp, addr, vid, db);
+	return dsa_port_host_fdb_del(dp, addr, vid, fdb_flags, db);
 }
 
 int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/port.h b/net/dsa/port.h
index 9c218660d223..0a4f487e3c05 100644
--- a/net/dsa/port.h
+++ b/net/dsa/port.h
@@ -47,17 +47,17 @@ int dsa_port_vlan_msti(struct dsa_port *dp,
 		       const struct switchdev_vlan_msti *msti);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid);
+		     u16 vid, u16 fdb_flags);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid);
+		     u16 vid, u16 fdb_flags);
 int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
 				     const unsigned char *addr, u16 vid);
 int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
 				     const unsigned char *addr, u16 vid);
 int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-				 u16 vid);
+				 u16 vid, u16 fdb_flags);
 int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-				 u16 vid);
+				 u16 vid, u16 fdb_flags);
 int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 			 u16 vid);
 int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index aab79c355224..b6381baa1ff3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -39,6 +39,7 @@ struct dsa_switchdev_event_work {
 	 */
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
+	u16 fdb_flags;
 	bool host_addr;
 };
 
@@ -3295,6 +3296,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		container_of(work, struct dsa_switchdev_event_work, work);
 	const unsigned char *addr = switchdev_work->addr;
 	struct net_device *dev = switchdev_work->dev;
+	u16 fdb_flags = switchdev_work->fdb_flags;
 	u16 vid = switchdev_work->vid;
 	struct dsa_switch *ds;
 	struct dsa_port *dp;
@@ -3306,11 +3308,12 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (switchdev_work->host_addr)
-			err = dsa_port_bridge_host_fdb_add(dp, addr, vid);
+			err = dsa_port_bridge_host_fdb_add(dp, addr,
+							   vid, fdb_flags);
 		else if (dp->lag)
 			err = dsa_port_lag_fdb_add(dp, addr, vid);
 		else
-			err = dsa_port_fdb_add(dp, addr, vid);
+			err = dsa_port_fdb_add(dp, addr, vid, fdb_flags);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
@@ -3322,11 +3325,12 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		if (switchdev_work->host_addr)
-			err = dsa_port_bridge_host_fdb_del(dp, addr, vid);
+			err = dsa_port_bridge_host_fdb_del(dp, addr,
+							   vid, fdb_flags);
 		else if (dp->lag)
 			err = dsa_port_lag_fdb_del(dp, addr, vid);
 		else
-			err = dsa_port_fdb_del(dp, addr, vid);
+			err = dsa_port_fdb_del(dp, addr, vid, fdb_flags);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to delete %pM vid %d from fdb: %d\n",
@@ -3364,6 +3368,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
+	u16 fdb_flags = 0;
 
 	if (ctx && ctx != dp)
 		return 0;
@@ -3410,6 +3415,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 		   orig_dev->name, fdb_info->addr, fdb_info->vid,
 		   host_addr ? " as host address" : "");
 
+	if (fdb_info->is_dyn)
+		fdb_flags |= DSA_FDB_FLAG_DYNAMIC;
+
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
@@ -3418,6 +3426,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
 	switchdev_work->vid = fdb_info->vid;
 	switchdev_work->host_addr = host_addr;
+	switchdev_work->fdb_flags = fdb_flags;
 
 	dsa_schedule_work(&switchdev_work->work);
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index d5bc4bb7310d..9b0d6ce0f7da 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -239,7 +239,7 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 }
 
 static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			       u16 vid, struct dsa_db db)
+			       u16 vid, u16 fdb_flags, struct dsa_db db)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -283,7 +283,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 }
 
 static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			       u16 vid, struct dsa_db db)
+			       u16 vid, u16 fdb_flags, struct dsa_db db)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -410,7 +410,9 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 								info->db);
 			} else {
 				err = dsa_port_do_fdb_add(dp, info->addr,
-							  info->vid, info->db);
+							  info->vid,
+							  info->fdb_flags,
+							  info->db);
 			}
 			if (err)
 				break;
@@ -438,7 +440,9 @@ static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 								info->db);
 			} else {
 				err = dsa_port_do_fdb_del(dp, info->addr,
-							  info->vid, info->db);
+							  info->vid,
+							  info->fdb_flags,
+							  info->db);
 			}
 			if (err)
 				break;
@@ -457,7 +461,8 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->db);
+	return dsa_port_do_fdb_add(dp, info->addr, info->vid,
+				   info->fdb_flags, info->db);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
@@ -469,7 +474,8 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_del(dp, info->addr, info->vid, info->db);
+	return dsa_port_do_fdb_del(dp, info->addr, info->vid,
+				   info->fdb_flags, info->db);
 }
 
 static int dsa_switch_lag_fdb_add(struct dsa_switch *ds,
diff --git a/net/dsa/switch.h b/net/dsa/switch.h
index 15e67b95eb6e..824ad7950785 100644
--- a/net/dsa/switch.h
+++ b/net/dsa/switch.h
@@ -55,6 +55,7 @@ struct dsa_notifier_fdb_info {
 	const struct dsa_port *dp;
 	const unsigned char *addr;
 	u16 vid;
+	u16 fdb_flags;
 	struct dsa_db db;
 };
 
-- 
2.34.1

