Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B691660312E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJRQ5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 12:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiJRQ5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 12:57:02 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5EBC821A;
        Tue, 18 Oct 2022 09:57:00 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 0F6B81884965;
        Tue, 18 Oct 2022 16:56:58 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id EBBFB25001FA;
        Tue, 18 Oct 2022 16:56:57 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id E04E89EC0007; Tue, 18 Oct 2022 16:56:57 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 12B1D9EC000A;
        Tue, 18 Oct 2022 16:56:57 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v8 net-next 05/12] net: dsa: propagate the locked flag down through the DSA layer
Date:   Tue, 18 Oct 2022 18:56:12 +0200
Message-Id: <20221018165619.134535-6-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018165619.134535-1-netdev@kapio-technology.com>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
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

Add a new u16 for fdb flags to propagate through the DSA layer towards the
fdb add and del functions of the drivers.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 include/net/dsa.h  |  2 ++
 net/dsa/dsa_priv.h |  6 ++++--
 net/dsa/port.c     | 10 ++++++----
 net/dsa/slave.c    | 10 ++++++++--
 net/dsa/switch.c   | 16 ++++++++--------
 5 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ee369670e20e..e4b641b20713 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -821,6 +821,8 @@ static inline bool dsa_port_tree_same(const struct dsa_port *a,
 	return a->ds->dst == b->ds->dst;
 }
 
+#define DSA_FDB_FLAG_LOCKED		(1 << 0)
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6e65c7ffd6f3..c943e8934063 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -65,6 +65,7 @@ struct dsa_notifier_fdb_info {
 	const struct dsa_port *dp;
 	const unsigned char *addr;
 	u16 vid;
+	u16 fdb_flags;
 	struct dsa_db db;
 };
 
@@ -131,6 +132,7 @@ struct dsa_switchdev_event_work {
 	 */
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
+	u16 fdb_flags;
 	bool host_addr;
 };
 
@@ -241,9 +243,9 @@ int dsa_port_vlan_msti(struct dsa_port *dp,
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
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 208168276995..ff4f66f14d39 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -304,7 +304,7 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
+				   BR_BCAST_FLOOD;
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	int flag, err;
 
@@ -328,7 +328,7 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
 {
 	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB;
 	int flag, err;
 
 	for_each_set_bit(flag, &mask, 32) {
@@ -956,12 +956,13 @@ int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu)
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
@@ -979,12 +980,13 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
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
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1a59918d3b30..65f0c578ef44 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -3246,6 +3246,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		container_of(work, struct dsa_switchdev_event_work, work);
 	const unsigned char *addr = switchdev_work->addr;
 	struct net_device *dev = switchdev_work->dev;
+	u16 fdb_flags = switchdev_work->fdb_flags;
 	u16 vid = switchdev_work->vid;
 	struct dsa_switch *ds;
 	struct dsa_port *dp;
@@ -3261,7 +3262,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		else if (dp->lag)
 			err = dsa_port_lag_fdb_add(dp, addr, vid);
 		else
-			err = dsa_port_fdb_add(dp, addr, vid);
+			err = dsa_port_fdb_add(dp, addr, vid, fdb_flags);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
@@ -3277,7 +3278,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		else if (dp->lag)
 			err = dsa_port_lag_fdb_del(dp, addr, vid);
 		else
-			err = dsa_port_fdb_del(dp, addr, vid);
+			err = dsa_port_fdb_del(dp, addr, vid, fdb_flags);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to delete %pM vid %d from fdb: %d\n",
@@ -3315,6 +3316,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
+	u16 fdb_flags = 0;
 
 	if (ctx && ctx != dp)
 		return 0;
@@ -3361,6 +3363,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 		   orig_dev->name, fdb_info->addr, fdb_info->vid,
 		   host_addr ? " as host address" : "");
 
+	if (fdb_info->locked)
+		fdb_flags |= DSA_FDB_FLAG_LOCKED;
+
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
@@ -3369,6 +3374,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
 	switchdev_work->vid = fdb_info->vid;
 	switchdev_work->host_addr = host_addr;
+	switchdev_work->fdb_flags = fdb_flags;
 
 	dsa_schedule_work(&switchdev_work->work);
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index ce56acdba203..dd355556892e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -234,7 +234,7 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 }
 
 static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			       u16 vid, struct dsa_db db)
+			       u16 vid, u16 fdb_flags, struct dsa_db db)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -278,7 +278,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 }
 
 static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			       u16 vid, struct dsa_db db)
+			       u16 vid, u16 fdb_flags, struct dsa_db db)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -404,8 +404,8 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 								info->vid,
 								info->db);
 			} else {
-				err = dsa_port_do_fdb_add(dp, info->addr,
-							  info->vid, info->db);
+				err = dsa_port_do_fdb_add(dp, info->addr, info->vid,
+							  info->fdb_flags, info->db);
 			}
 			if (err)
 				break;
@@ -432,8 +432,8 @@ static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 								info->vid,
 								info->db);
 			} else {
-				err = dsa_port_do_fdb_del(dp, info->addr,
-							  info->vid, info->db);
+				err = dsa_port_do_fdb_del(dp, info->addr, info->vid,
+							  info->fdb_flags, info->db);
 			}
 			if (err)
 				break;
@@ -452,7 +452,7 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->db);
+	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->fdb_flags, info->db);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
@@ -464,7 +464,7 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_del(dp, info->addr, info->vid, info->db);
+	return dsa_port_do_fdb_del(dp, info->addr, info->vid, info->fdb_flags, info->db);
 }
 
 static int dsa_switch_lag_fdb_add(struct dsa_switch *ds,
-- 
2.34.1

