Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F083333E0D0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCPVuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhCPVuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 17:50:05 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2EAC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 14:50:04 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m22so64721259lfg.5
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 14:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=mzhOrx54IVYTSUzNS+s9g1e6DoWaCfAAgXnjWGKQbFs=;
        b=FKnCzj5mEYTcxgan933p6A6eldexfacQlWASbWamTrb5spDIIXZi0pKsb5R9/jByQL
         ROmDspw+ez61U59FFXJ/7vvxo+i9NNmdmJdieTeCFzE8OnI+0GX27l3W64Jf2AY1s9Jm
         ZaQxg79TrMVa2fV19A66ZfmS2MTqtN1xwDqjFTEy0tmZkEh3Vz6jPvvNsbPq0WPnmuRq
         ydOLCPCL9uSycs6evC7qKBGB+KiGiY298YMmZupiEpJFztcR9Bx7aegmKUFbDOxfCkN4
         manB8te8AMRXYoEJn7Ki/cg5zDbB7rKqakQAEXq3ZOommYRrIhcX2Bt6pngdxGpPqqez
         H/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=mzhOrx54IVYTSUzNS+s9g1e6DoWaCfAAgXnjWGKQbFs=;
        b=Jcd8TyXORvy6cit+5Z8mkLxH3qRiX7mfbejMS0KvI7WAs2myQF0zwiGCCrNXyJMcFC
         ASWY9g5MTj8HyhwxTLz38UfYXShIPLLtZPDki2pIiDm/JNk+SyfaQmu/sua4XAs4+IJu
         1UFecXlCvFHEjkp2+Ulj9GVaSuX2X24NG0JsKF8VG2pBtB/90FwI2aAIWaf7osWNMNzU
         6jkDYzQHpeAVXC181PoI/iQ1ZEGO7n4whfFsWNFgtk6dsnj7jN4hA0KI8QvFn+cYilSC
         yNAojdfwZVxkitWn62VqQ0jcUgWBHH/3grGroQtiAzFQyJb6FsRzv54sCdegQCMS+BeQ
         alvg==
X-Gm-Message-State: AOAM530/SwBNcYUc6SWda2Xvk12kC3Km9QzkVgePXErTXCFaQpK2DaOY
        OW/vzoDcWBDwEtB7WV327iro7g==
X-Google-Smtp-Source: ABdhPJwSu7HxtVWk3cmlP7/YZJIjfv3gJg0BUxoXnbE0ZeOKvYbUJFSvS+2jhunfccPpcwYmc48YIw==
X-Received: by 2002:a05:6512:34c9:: with SMTP id w9mr436117lfr.267.1615931402037;
        Tue, 16 Mar 2021 14:50:02 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 203sm3262769ljf.41.2021.03.16.14.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 14:50:01 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 net] net: dsa: Centralize validation of VLAN configuration
Date:   Tue, 16 Mar 2021 22:49:52 +0100
Message-Id: <20210316214952.3444946-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are four kinds of events that have an impact on VLAN
configuration of DSA ports:

- Adding VLAN uppers
  (ip link add dev swp0.1 link swp0 type vlan id 1)

- Bridging VLAN uppers
  (ip link set dev swp0.1 master br0)

- Adding bridge VLANs
  (bridge vlan add dev swp0 vid 1)

- Changes to a bridge's VLAN filtering setting
  (ip link set dev br0 type bridge vlan_filtering 1)

For all of these events, we want to ensure that some invariants are
upheld for offloaded ports belonging to our tree:

- For hardware where VLAN filtering is a global setting, either all
  bridges must use VLAN filtering, or no bridge can.

- For all filtering bridges, no VID may be configured on more than one
  VLAN upper. An example of a violation of this would be:

  .100  br0  .100
     \  / \  /
     swp0 swp1

  $ ip link add dev br0 type bridge vlan_filtering 1
  $ ip link add dev swp0.100 link swp0 type vlan id 100
  $ ip link set dev swp0 master br0
  $ ip link add dev swp1.100 link swp0 type vlan id 100
  $ ip link set dev swp1 master br0

- For all filtering bridges, no upper VLAN may share a bridge with
  another offloaded port. An example of a violation of this would be:

       br0
      /  |
     /   |
  .100   |
    |    |
   swp0 swp1

  $ ip link add dev br0 type bridge vlan_filtering 1
  $ ip link add dev swp0.100 link swp0 type vlan id 100
  $ ip link set dev swp0.100 master br0
  $ ip link set dev swp1 master br0

- For all filtering bridges, no VID that exists in the bridge may be
  used by a VLAN upper. An example of a violation of this would be:

      br0
     (100)
       |
  .100 |
     \ |
     swp0

  $ ip link add dev br0 type bridge vlan_filtering 1
  $ ip link add dev swp0.100 link swp0 type vlan id 100
  $ ip link set dev swp0 master br0
  $ bridge vlan add dev swp0 vid 100

Move the validation of these invariants to a central function, and use
it from all sites where these events are handled. This way, we ensure
that all invariants are always checked, avoiding certain configs being
allowed or disallowed depending on the order in which commands are
given.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

v2 primarily fixes an issue where VLAN uppers added on top of a bridge
would be interpreted by DSA as if it was added to a port. Make sure
that only VLAN uppers on ports we offload are considered.

There are a few open issues that may result in a v3, but I wanted to
get this out so that people can test it properly.

v1 -> v2:
  - Do not react to VLAN uppers unless they are on a port we offload.
  - Fix uninitialized variable (kernel test robot)
  - Spelling, some variable naming (Vladimir)

 net/dsa/dsa2.c     | 179 +++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h |  29 ++++++++
 net/dsa/port.c     | 100 ++++++++++---------------
 net/dsa/slave.c    | 106 +++++++++------------------
 4 files changed, 279 insertions(+), 135 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 4d4956ed303b..e7ae840d58f6 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -21,6 +21,185 @@
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
+static bool dsa_bridge_filtering_is_coherent(struct dsa_switch_tree *dst, bool filter,
+					     struct netlink_ext_ack *extack)
+{
+	bool is_global = false;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->vlan_filtering_is_global) {
+			is_global = true;
+			break;
+		}
+	}
+
+	if (!is_global)
+		return true;
+
+	/* For cases where enabling/disabling VLAN awareness is global
+	 * to the switch, we need to handle the case where multiple
+	 * bridges span different ports of the same switch device and
+	 * one of them has a different setting than what is being
+	 * requested.
+	 */
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (!dp->bridge_dev)
+			continue;
+
+		if (br_vlan_enabled(dp->bridge_dev) != filter) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "VLAN filtering is not consistent across all bridges");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static bool dsa_8021q_uppers_are_coherent(struct dsa_switch_tree *dst,
+					  struct net_device *br,
+					  bool seen_vlan_upper,
+					  unsigned long *upper_vids,
+					  struct netlink_ext_ack *extack)
+{
+	struct list_head *lower_iter, *upper_iter;
+	struct net_device *lower, *upper;
+	struct dsa_slave_priv *priv;
+	bool seen_offloaded = false;
+	u16 vid;
+
+	netdev_for_each_lower_dev(br, lower, lower_iter) {
+		priv = dsa_slave_dev_lower_find(lower);
+		if (!priv || priv->dp->ds->dst != dst)
+			/* Ignore ports that are not related to us in
+			 * any way.
+			 */
+			continue;
+
+		if (is_vlan_dev(lower)) {
+			seen_vlan_upper = true;
+			continue;
+		}
+
+		if (dsa_port_offloads_bridge(priv->dp, br) &&
+		    dsa_port_offloads_bridge_port(priv->dp, lower))
+			seen_offloaded = true;
+		else
+			/* Non-offloaded uppers can do whatever they
+			 * want.
+			 */
+			continue;
+
+		netdev_for_each_upper_dev_rcu(lower, upper, upper_iter) {
+			if (!is_vlan_dev(upper))
+				continue;
+
+			vid = vlan_dev_vlan_id(upper);
+			if (!test_bit(vid, upper_vids)) {
+				set_bit(vid, upper_vids);
+				continue;
+			}
+
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Multiple VLAN interfaces cannot use the same VID");
+			return false;
+		}
+	}
+
+	if (seen_offloaded && seen_vlan_upper) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "VLAN interfaces cannot share bridge with offloaded port");
+		return false;
+	}
+
+	return true;
+}
+
+static bool dsa_bridge_vlans_are_coherent(struct net_device *br,
+					  u16 new_vid,
+					  const unsigned long *upper_vids,
+					  struct netlink_ext_ack *extack)
+{
+	u16 vid;
+
+	if (new_vid && test_bit(new_vid, upper_vids))
+		goto err;
+
+	for_each_set_bit(vid, upper_vids, VLAN_N_VID) {
+		struct bridge_vlan_info br_info;
+
+		if (br_vlan_get_info(br, vid, &br_info))
+			/* Error means that the VID does not exist,
+			 * which is what we want to ensure.
+			 */
+			continue;
+
+		goto err;
+	}
+
+	return true;
+
+err:
+	NL_SET_ERR_MSG_MOD(extack, "No bridge VID may be used on a related VLAN interface");
+	return false;
+}
+
+/**
+ * dsa_bridge_is_coherent - Verify that DSA tree accepts a bridge config.
+ * @dst: Tree to verify against.
+ * @br: Bridge netdev to verify.
+ * @mod: Description of the modification to introduce.
+ * @extack: Netlink extended ack for error reporting.
+ *
+ * Verify that the VLAN config of @br, its offloaded ports belonging
+ * to @dst and their VLAN uppers, can be correctly offloaded after
+ * introducing the change described by @mod. If this is not the case,
+ * an error is reported via @extack.
+ *
+ * Return: true if the config can be offloaded, false otherwise.
+ */
+bool dsa_bridge_is_coherent(struct dsa_switch_tree *dst, struct net_device *br,
+			    struct dsa_bridge_mod *mod,
+			    struct netlink_ext_ack *extack)
+{
+	unsigned long *upper_vids;
+	bool filter;
+
+	if (mod->filter)
+		filter = *mod->filter;
+	else
+		filter = br && br_vlan_enabled(br);
+
+	if (!dsa_bridge_filtering_is_coherent(dst, filter, extack))
+		goto err;
+
+	if (!filter)
+		return true;
+
+	upper_vids = bitmap_zalloc(VLAN_N_VID, GFP_KERNEL);
+	if (WARN_ON_ONCE(!upper_vids))
+		goto err;
+
+	if (mod->upper_vid)
+		set_bit(mod->upper_vid, upper_vids);
+
+	if (!dsa_8021q_uppers_are_coherent(dst, br, mod->bridge_upper,
+					   upper_vids, extack))
+		goto err_free;
+
+	if (!dsa_bridge_vlans_are_coherent(br, mod->br_vid, upper_vids, extack))
+		goto err_free;
+
+	kfree(upper_vids);
+	return true;
+
+err_free:
+	kfree(upper_vids);
+err:
+	return false;
+}
+
 /**
  * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
  * @dst: collection of struct dsa_switch devices to notify.
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9d4b0e9b1aa1..f8d43b7518d0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -188,6 +188,13 @@ int dsa_port_lag_change(struct dsa_port *dp,
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo);
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
+bool dsa_port_can_stack_vlan_upper(struct dsa_port *dp, u16 vid,
+				   struct netlink_ext_ack *extack);
+bool dsa_port_can_bridge_vlan_upper(struct dsa_port *dp,
+				    struct net_device *upper_br,
+				    struct netlink_ext_ack *extack);
+bool dsa_port_can_add_bridge_vlan(struct dsa_port *dp, u16 vid,
+				  struct netlink_ext_ack *extack);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
@@ -271,6 +278,7 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
 }
 
 /* slave.c */
+struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev);
 extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
@@ -361,6 +369,27 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
 /* dsa2.c */
+
+/**
+ * struct dsa_bridge_mod - Modification of bridge related config
+ * @filter: If non-NULL, the new state of VLAN filtering.
+ * @br_vid: If non-zero, this VID will be added to the bridge.
+ * @upper_vid: If non-zero, a VLAN upper using this VID will be added to
+ *             a bridge port.
+ * @bridge_upper: If true, a VLAN upper will be added to the bridge.
+ *
+ * Describes a bridge related modification that is about to be applied.
+ */
+struct dsa_bridge_mod {
+	bool *filter;
+	u16   br_vid;
+	u16   upper_vid;
+	bool  bridge_upper;
+};
+
+bool dsa_bridge_is_coherent(struct dsa_switch_tree *dst, struct net_device *br,
+			    struct dsa_bridge_mod *mod,
+			    struct netlink_ext_ack *extack);
 void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c9c6d7ab3f47..76c79d2d80a2 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -292,72 +292,48 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 	dsa_lag_unmap(dp->ds->dst, lag);
 }
 
-/* Must be called under rcu_read_lock() */
-static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
-					      bool vlan_filtering,
-					      struct netlink_ext_ack *extack)
+bool dsa_port_can_stack_vlan_upper(struct dsa_port *dp, u16 vid,
+				   struct netlink_ext_ack *extack)
 {
-	struct dsa_switch *ds = dp->ds;
-	int err, i;
+	struct dsa_bridge_mod mod = {
+		.upper_vid = vid,
+	};
 
-	/* VLAN awareness was off, so the question is "can we turn it on".
-	 * We may have had 8021q uppers, those need to go. Make sure we don't
-	 * enter an inconsistent state: deny changing the VLAN awareness state
-	 * as long as we have 8021q uppers.
-	 */
-	if (vlan_filtering && dsa_is_user_port(ds, dp->index)) {
-		struct net_device *upper_dev, *slave = dp->slave;
-		struct net_device *br = dp->bridge_dev;
-		struct list_head *iter;
-
-		netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
-			struct bridge_vlan_info br_info;
-			u16 vid;
-
-			if (!is_vlan_dev(upper_dev))
-				continue;
-
-			vid = vlan_dev_vlan_id(upper_dev);
-
-			/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-			 * device, respectively the VID is not found, returning
-			 * 0 means success, which is a failure for us here.
-			 */
-			err = br_vlan_get_info(br, vid, &br_info);
-			if (err == 0) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Must first remove VLAN uppers having VIDs also present in bridge");
-				return false;
-			}
-		}
-	}
+	return dsa_bridge_is_coherent(dp->ds->dst, dp->bridge_dev, &mod,
+				      extack);
+}
 
-	if (!ds->vlan_filtering_is_global)
-		return true;
+bool dsa_port_can_bridge_vlan_upper(struct dsa_port *dp,
+				    struct net_device *upper_br,
+				    struct netlink_ext_ack *extack)
+{
+	struct dsa_bridge_mod mod = {
+		.bridge_upper = true,
+	};
 
-	/* For cases where enabling/disabling VLAN awareness is global to the
-	 * switch, we need to handle the case where multiple bridges span
-	 * different ports of the same switch device and one of them has a
-	 * different setting than what is being requested.
-	 */
-	for (i = 0; i < ds->num_ports; i++) {
-		struct net_device *other_bridge;
-
-		other_bridge = dsa_to_port(ds, i)->bridge_dev;
-		if (!other_bridge)
-			continue;
-		/* If it's the same bridge, it also has same
-		 * vlan_filtering setting => no need to check
-		 */
-		if (other_bridge == dp->bridge_dev)
-			continue;
-		if (br_vlan_enabled(other_bridge) != vlan_filtering) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "VLAN filtering is a global setting");
-			return false;
-		}
-	}
-	return true;
+	return dsa_bridge_is_coherent(dp->ds->dst, upper_br, &mod, extack);
+}
+
+bool dsa_port_can_add_bridge_vlan(struct dsa_port *dp, u16 vid,
+				  struct netlink_ext_ack *extack)
+{
+	struct dsa_bridge_mod mod = {
+		.br_vid = vid,
+	};
+
+	return dsa_bridge_is_coherent(dp->ds->dst, dp->bridge_dev, &mod,
+				      extack);
+}
+
+static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp, bool filter,
+					      struct netlink_ext_ack *extack)
+{
+	struct dsa_bridge_mod mod = {
+		.filter = &filter,
+	};
+
+	return dsa_bridge_is_coherent(dp->ds->dst, dp->bridge_dev, &mod,
+				      extack);
 }
 
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..fb6fda9f15f6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -325,28 +325,6 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	return ret;
 }
 
-/* Must be called under rcu_read_lock() */
-static int
-dsa_slave_vlan_check_for_8021q_uppers(struct net_device *slave,
-				      const struct switchdev_obj_port_vlan *vlan)
-{
-	struct net_device *upper_dev;
-	struct list_head *iter;
-
-	netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
-		u16 vid;
-
-		if (!is_vlan_dev(upper_dev))
-			continue;
-
-		vid = vlan_dev_vlan_id(upper_dev);
-		if (vid == vlan->vid)
-			return -EBUSY;
-	}
-
-	return 0;
-}
-
 static int dsa_slave_vlan_add(struct net_device *dev,
 			      const struct switchdev_obj *obj,
 			      struct netlink_ext_ack *extack)
@@ -363,19 +341,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
 
-	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
-	 * the same VID.
-	 */
-	if (br_vlan_enabled(dp->bridge_dev)) {
-		rcu_read_lock();
-		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
-		rcu_read_unlock();
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Port already has a VLAN upper with this VID");
-			return err;
-		}
-	}
+	if (!dsa_port_can_add_bridge_vlan(dp, vlan.vid, extack))
+		return -EBUSY;
 
 	err = dsa_port_vlan_add(dp, &vlan, extack);
 	if (err)
@@ -2050,30 +2017,22 @@ static int
 dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
-	struct netlink_ext_ack *ext_ack;
-	struct net_device *slave;
-	struct dsa_port *dp;
-
-	ext_ack = netdev_notifier_info_to_extack(&info->info);
+	struct netlink_ext_ack *extack;
+	struct dsa_slave_priv *p;
+	struct net_device *real;
 
-	if (!is_vlan_dev(dev))
-		return NOTIFY_DONE;
+	extack = netdev_notifier_info_to_extack(&info->info);
 
-	slave = vlan_dev_real_dev(dev);
-	if (!dsa_slave_dev_check(slave))
+	real = vlan_dev_real_dev(dev);
+	p = dsa_slave_dev_lower_find(real);
+	if (!p || !dsa_port_offloads_bridge_port(p->dp, real))
 		return NOTIFY_DONE;
 
-	dp = dsa_slave_to_port(slave);
-	if (!dp->bridge_dev)
+	if (!netif_is_bridge_master(info->upper_dev) || !info->linking)
 		return NOTIFY_DONE;
 
-	/* Deny enslaving a VLAN device into a VLAN-aware bridge */
-	if (br_vlan_enabled(dp->bridge_dev) &&
-	    netif_is_bridge_master(info->upper_dev) && info->linking) {
-		NL_SET_ERR_MSG_MOD(ext_ack,
-				   "Cannot enslave VLAN device into VLAN aware bridge");
+	if (!dsa_port_can_bridge_vlan_upper(p->dp, info->upper_dev, extack))
 		return notifier_from_errno(-EINVAL);
-	}
 
 	return NOTIFY_DONE;
 }
@@ -2082,29 +2041,22 @@ static int
 dsa_slave_check_8021q_upper(struct net_device *dev,
 			    struct netdev_notifier_changeupper_info *info)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct net_device *br = dp->bridge_dev;
-	struct bridge_vlan_info br_info;
 	struct netlink_ext_ack *extack;
-	int err = NOTIFY_DONE;
+	struct dsa_slave_priv *p;
+	struct net_device *real;
 	u16 vid;
 
-	if (!br || !br_vlan_enabled(br))
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	real = vlan_dev_real_dev(info->upper_dev);
+	p = dsa_slave_dev_lower_find(real);
+	if (!p || !dsa_port_offloads_bridge_port(p->dp, real))
 		return NOTIFY_DONE;
 
-	extack = netdev_notifier_info_to_extack(&info->info);
 	vid = vlan_dev_vlan_id(info->upper_dev);
 
-	/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-	 * device, respectively the VID is not found, returning
-	 * 0 means success, which is a failure for us here.
-	 */
-	err = br_vlan_get_info(br, vid, &br_info);
-	if (err == 0) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "This VLAN is already configured by the bridge");
+	if (!dsa_port_can_stack_vlan_upper(p->dp, vid, extack))
 		return notifier_from_errno(-EBUSY);
-	}
 
 	return NOTIFY_DONE;
 }
@@ -2119,10 +2071,18 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		struct netdev_notifier_changeupper_info *info = ptr;
 		struct dsa_switch *ds;
 		struct dsa_port *dp;
-		int err;
+		int err = 0;
+
+		if (is_vlan_dev(dev))
+			err = dsa_prevent_bridging_8021q_upper(dev, ptr);
+		else if (is_vlan_dev(info->upper_dev))
+			err = dsa_slave_check_8021q_upper(dev, ptr);
+
+		if (err)
+			return err;
 
 		if (!dsa_slave_dev_check(dev))
-			return dsa_prevent_bridging_8021q_upper(dev, ptr);
+			return NOTIFY_DONE;
 
 		dp = dsa_slave_to_port(dev);
 		ds = dp->ds;
@@ -2132,9 +2092,6 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 			if (err)
 				return notifier_from_errno(err);
 		}
-
-		if (is_vlan_dev(info->upper_dev))
-			return dsa_slave_check_8021q_upper(dev, ptr);
 		break;
 	}
 	case NETDEV_CHANGEUPPER:
@@ -2260,12 +2217,15 @@ static int dsa_lower_dev_walk(struct net_device *lower_dev,
 	return 0;
 }
 
-static struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev)
+struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev)
 {
 	struct netdev_nested_priv priv = {
 		.data = NULL,
 	};
 
+	if (dsa_slave_dev_check(dev))
+		return netdev_priv(dev);
+
 	netdev_walk_all_lower_dev_rcu(dev, dsa_lower_dev_walk, &priv);
 
 	return (struct dsa_slave_priv *)priv.data;
-- 
2.25.1

