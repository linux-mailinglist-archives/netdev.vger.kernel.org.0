Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C95D330017
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 11:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhCGKWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 05:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhCGKWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 05:22:13 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29524C06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 02:22:12 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id e19so14001598ejt.3
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 02:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B836QTivQ5bqE7lTgEwqxcK4IlJPWw3KL833x6YNJYg=;
        b=fDSMHF19200AzWV9YfGYSUH1isUZM3G1mbnib/q8sy0y5TsmzAszQ5c2YD0niZ7TMR
         1zKEK770yyrrAMCVrZcaVP4bzJxEQeq5ML7f7yfPSajvyzJkVXXBmn/+3zrdTyLR60pW
         oYKLxWRYZGOuFJrdmkxBbxpQ0twT1gg2CSkn1RT+3+9yp8TeNszQIdV/wm+y+2SMss6j
         Ra22MusSRtnuTWbuEMpHaMMRSKIzNnVuyycG/fU4uzCrpXMuIG5vWpqYoHNQu7buTqpj
         m0oy6y6VVCp8uynkstDW2ByloM2oBmQvlsIPtJpwuK/wQpQ8VIVyoG+WXecgLWLPF6H8
         wnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B836QTivQ5bqE7lTgEwqxcK4IlJPWw3KL833x6YNJYg=;
        b=VcKJXUqw+S4KzclqRU+xXjFVagc1U3l9jfJdDvnVpIDQUMaljzK2TruHUEN9QqwodQ
         OOfiBUf/RgYvZDd/6WnXedvn/eNDTQWRwxr4s+WKT4UJIMZqo+uyeNfPUx2pyM3/dAHn
         9JUZw5ppOVULhACJOoG/bLdtGFV7ugj7lkNOaLoT1qETJ22MJoeu2fN0meZAcfL9/vBC
         fS1N78cT4YduJ4AghsqfSU6aKt2JCvB0LKOS6mz+oiXaDJQCXuEd/3DMqY4KEIpXBAnW
         ax8uJrxgQrSttuqFsFu6tgtWOM6kvOskDO22A91zEJ5ihpcaqiR6WihhKVRPODThbDIV
         MCHw==
X-Gm-Message-State: AOAM531hegmIPRkcxuh5VLT7eGNi/N2IzS3x4oTgEypxo4hvffCEFBTI
        lEmC0xgbccVVpjkrlMzXCGo=
X-Google-Smtp-Source: ABdhPJzeNjAYyyN7U7/HNE9WCbkdaq8x6hH0gA9GsxGfSnVMiwfGRHcib7EM8xr96MNEDpibps8bgQ==
X-Received: by 2002:a17:906:b6c8:: with SMTP id ec8mr10436637ejb.223.1615112530735;
        Sun, 07 Mar 2021 02:22:10 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id u1sm4722984edv.90.2021.03.07.02.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 02:22:10 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net] net: dsa: fix switchdev objects on bridge master mistakenly being applied on ports
Date:   Sun,  7 Mar 2021 12:21:56 +0200
Message-Id: <20210307102156.2282877-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Tobias reports that after the blamed patch, VLAN objects being added to
a bridge device are being added to all slave ports instead (swp2, swp3).

ip link add br0 type bridge vlan_filtering 1
ip link set swp2 master br0
ip link set swp3 master br0
bridge vlan add dev br0 vid 100 self

This is because the fix was too broad: we made dsa_port_offloads_netdev
say "yes, I offload the br0 bridge" for all slave ports, but we didn't
add the checks whether the switchdev object was in fact meant for the
physical port or for the bridge itself. So we are reacting on events in
a way in which we shouldn't.

The reason why the fix was too broad is because the question itself,
"does this DSA port offload this netdev", was too broad in the first
place. The solution is to disambiguate the question and separate it into
two different functions, one to be called for each switchdev attribute /
object that has an orig_dev == net_bridge (dsa_port_offloads_bridge),
and the other for orig_dev == net_bridge_port (*_offloads_bridge_port).

In the case of VLAN objects on the bridge interface, this solves the
problem because we know that VLAN objects are per bridge port and not
per bridge. And when orig_dev is equal to the net_bridge, we offload it
as a bridge, but not as a bridge port; that's how we are able to skip
reacting on those events. Note that this is compatible with future plans
to have explicit offloading of VLAN objects on the bridge interface as a
bridge port (in DSA, this signifies that we should add that VLAN towards
the CPU port).

Fixes: 99b8202b179f ("net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored")
Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
This is the logical v2 of Tobias' patches from here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210306002455.1582593-1-tobias@waldekranz.com/

 net/dsa/dsa_priv.h | 25 +++++++++++---------
 net/dsa/slave.c    | 59 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 57 insertions(+), 27 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2eeaa42f2e08..9d4b0e9b1aa1 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -230,8 +230,8 @@ int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
-static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
-					    struct net_device *dev)
+static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
+						 struct net_device *dev)
 {
 	/* Switchdev offloading can be configured on: */
 
@@ -241,12 +241,6 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
 		 */
 		return true;
 
-	if (dp->bridge_dev == dev)
-		/* DSA ports connected to a bridge, and event was emitted
-		 * for the bridge.
-		 */
-		return true;
-
 	if (dp->lag_dev == dev)
 		/* DSA ports connected to a bridge via a LAG */
 		return true;
@@ -254,14 +248,23 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
 	return false;
 }
 
+static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
+					    struct net_device *bridge_dev)
+{
+	/* DSA ports connected to a bridge, and event was emitted
+	 * for the bridge.
+	 */
+	return dp->bridge_dev == bridge_dev;
+}
+
 /* Returns true if any port of this tree offloads the given net_device */
-static inline bool dsa_tree_offloads_netdev(struct dsa_switch_tree *dst,
-					    struct net_device *dev)
+static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
+						 struct net_device *dev)
 {
 	struct dsa_port *dp;
 
 	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_netdev(dp, dev))
+		if (dsa_port_offloads_bridge_port(dp, dev))
 			return true;
 
 	return false;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 491e3761b5f4..992fcab4b552 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -278,28 +278,43 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
-	if (!dsa_port_offloads_netdev(dp, attr->orig_dev))
-		return -EOPNOTSUPP;
-
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_set_state(dp, attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering,
 					      extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_pre_bridge_flags(dp, attr->u.brport_flags,
 						extack);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
+		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
 		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, extack);
 		break;
 	default:
@@ -341,9 +356,6 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct switchdev_obj_port_vlan vlan;
 	int err;
 
-	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-		return -EOPNOTSUPP;
-
 	if (dsa_port_skip_vlan_configuration(dp)) {
 		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
 		return 0;
@@ -391,27 +403,36 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+
 		/* DSA can directly translate this to a normal MDB add,
 		 * but on the CPU port.
 		 */
 		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+
 		err = dsa_slave_vlan_add(dev, obj, extack);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mrp_add(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mrp_add_ring_role(dp,
 						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
 		break;
@@ -431,9 +452,6 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct switchdev_obj_port_vlan *vlan;
 	int err;
 
-	if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
-		return -EOPNOTSUPP;
-
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
@@ -459,27 +477,36 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+
 		/* DSA can directly translate this to a normal MDB add,
 		 * but on the CPU port.
 		 */
 		err = dsa_port_mdb_del(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+
 		err = dsa_slave_vlan_del(dev, obj);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mrp_del(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
-		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
+
 		err = dsa_port_mrp_del_ring_role(dp,
 						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
 		break;
@@ -2298,7 +2325,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			 * other ports bridged with the LAG should be able to
 			 * autonomously forward towards it.
 			 */
-			if (dsa_tree_offloads_netdev(dp->ds->dst, dev))
+			if (dsa_tree_offloads_bridge_port(dp->ds->dst, dev))
 				return NOTIFY_DONE;
 		}
 
-- 
2.25.1

