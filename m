Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B17B5A27B5
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344263AbiHZMWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343859AbiHZMWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:22:34 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BA8DF0BA;
        Fri, 26 Aug 2022 05:20:52 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 1C668188D8A4;
        Fri, 26 Aug 2022 12:20:20 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 08D7E25032B7;
        Fri, 26 Aug 2022 12:20:20 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id D34489EC005C; Fri, 26 Aug 2022 11:45:59 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from wse-c0127.beijerelectronics.com (unknown [208.127.141.28])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 93D6E9EC0008;
        Fri, 26 Aug 2022 11:45:56 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v5 net-next 2/6] net: switchdev: add support for offloading of fdb locked flag
Date:   Fri, 26 Aug 2022 13:45:34 +0200
Message-Id: <20220826114538.705433-3-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826114538.705433-1-netdev@kapio-technology.com>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used for MacAuth/MAB feature in the offloaded case.
Send the fdb locked flag down through the switchdev and DSA layers.

Also add support for drivers to set additional flags on bridge
FDB entries including the new 'blackhole' flag.

And add support for offloading of the MAB/MacAuth feature flag.

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
---
 include/net/switchdev.h   |  3 +++
 net/bridge/br.c           |  5 ++++-
 net/bridge/br_fdb.c       | 14 ++++++++++++--
 net/bridge/br_private.h   |  3 ++-
 net/bridge/br_switchdev.c |  5 +++--
 net/dsa/dsa_priv.h        |  4 +++-
 net/dsa/port.c            |  7 ++++---
 net/dsa/slave.c           |  4 +++-
 net/dsa/switch.c          |  6 +++---
 9 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 7dcdc97c0bc3..437945179373 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -247,7 +247,10 @@ struct switchdev_notifier_fdb_info {
 	const unsigned char *addr;
 	u16 vid;
 	u8 added_by_user:1,
+	   sticky:1,
 	   is_local:1,
+	   locked:1,
+	   blackhole:1,
 	   offloaded:1;
 };
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 96e91d69a9a8..3671c0a12b7d 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,7 +166,10 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid, false);
+						fdb_info->vid, false,
+						fdb_info->locked,
+						fdb_info->blackhole,
+						fdb_info->sticky);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 1962d9594a48..30126af9c42f 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1147,7 +1147,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 					   "FDB entry towards bridge must be permanent");
 			return -EINVAL;
 		}
-		err = br_fdb_external_learn_add(br, p, addr, vid, true);
+		err = br_fdb_external_learn_add(br, p, addr, vid, true, false, false, false);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1383,7 +1383,8 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify)
+			      bool swdev_notify, bool locked,
+			      bool blackhole, bool sticky)
 {
 	struct net_bridge_fdb_entry *fdb;
 	bool modified = false;
@@ -1403,6 +1404,15 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (!p)
 			flags |= BIT(BR_FDB_LOCAL);
 
+		if (locked)
+			flags |= BIT(BR_FDB_ENTRY_LOCKED);
+
+		if (blackhole)
+			flags |= BIT(BR_FDB_BLACKHOLE);
+
+		if (sticky)
+			flags |= BIT(BR_FDB_STICKY);
+
 		fdb = fdb_create(br, p, addr, vid, flags);
 		if (!fdb) {
 			err = -ENOMEM;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 048e4afbc5a0..2836fec2dafb 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -812,7 +812,8 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify);
+			      bool swdev_notify, bool locked,
+			      bool blackhole, bool sticky);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify);
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 8f3d76c751dd..9aaefbc07e02 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -71,8 +71,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 }
 
 /* Flags that can be offloaded to hardware */
-#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
-				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED | \
+#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
+				  BR_PORT_LOCKED | BR_PORT_MAB | \
 				  BR_HAIRPIN_MODE | BR_ISOLATED | BR_MULTICAST_TO_UNICAST)
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
@@ -136,6 +136,7 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
 	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
 	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item->locked = test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags);
 	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
 	item->info.ctx = ctx;
 }
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 614fbba8fe39..b05685418b20 100644
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
index 7afc35db0c29..3399cc1f7be0 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -303,7 +303,7 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB;
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	int flag, err;
 
@@ -327,7 +327,7 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
 {
 	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB;
 	int flag, err;
 
 	for_each_set_bit(flag, &mask, 32) {
@@ -954,12 +954,13 @@ int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu)
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
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 345106b1ed78..a6486d7d9c7c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2908,6 +2908,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		container_of(work, struct dsa_switchdev_event_work, work);
 	const unsigned char *addr = switchdev_work->addr;
 	struct net_device *dev = switchdev_work->dev;
+	bool is_locked = switchdev_work->is_locked;
 	u16 vid = switchdev_work->vid;
 	struct dsa_switch *ds;
 	struct dsa_port *dp;
@@ -2923,7 +2924,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		else if (dp->lag)
 			err = dsa_port_lag_fdb_add(dp, addr, vid);
 		else
-			err = dsa_port_fdb_add(dp, addr, vid);
+			err = dsa_port_fdb_add(dp, addr, vid, is_locked);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
@@ -3031,6 +3032,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
 	switchdev_work->vid = fdb_info->vid;
 	switchdev_work->host_addr = host_addr;
+	switchdev_work->is_locked = fdb_info->locked;
 
 	dsa_schedule_work(&switchdev_work->work);
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4dfd68cf61c5..f29604f25c67 100644
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
@@ -399,7 +399,7 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->dp)) {
 			err = dsa_port_do_fdb_add(dp, info->addr, info->vid,
-						  info->db);
+						  false, info->db);
 			if (err)
 				break;
 		}
@@ -438,7 +438,7 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->db);
+	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->is_locked, info->db);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
-- 
2.30.2

