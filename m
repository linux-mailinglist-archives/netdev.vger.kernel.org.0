Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE19331CD4
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhCICRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhCICRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:17:17 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1A8C061760
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 18:17:17 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ox4so8853433ejb.11
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 18:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kh/o9qjNG5BCmC7dXeocIV1ZdxnOv3TrahTexKTYhjw=;
        b=n8pWxex4ba8/yKrWDWDfcc6/8YkGZnKL34PYlrGOJH1QquLmJ3AfSXYB+X1vS9C9jo
         u7F4d07y3hxa9QFfyOOXN7/SHu+OJ5vHm3NnX/yRPQQmwcqO0W6nV+uhHcd073wdb4Ja
         N0iMhY5Fvt/6/C9R9XWlby8q86vDqQ3JMrN5knANCnIwty9LP+ubouuQG6v4G2up+Ved
         C2biUaV7CYI7Me7gUoyLQw8XvR+/G7DITfFTWl/mnKLF7Wzq+qBYCJ03mk8wMlIdWV+R
         SeSALRbaTsoD0jl6tqJqoocmzT6Wy0dQ0w4A3gh13JSTuZfbO/hqFH6Vc/EiDCHLqU9L
         8kkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kh/o9qjNG5BCmC7dXeocIV1ZdxnOv3TrahTexKTYhjw=;
        b=B/WiUIItwPVaqnRZPOmDTj9LCbOISAkYakBayJeDGOhbLlBHe8W6iWjaO5R3tYHB+r
         8p1mM8kla8H0L2lbJPW5iVpwaj4ChPC5IifJGhdB4D79uSlGMnu6wNRax0nQ5WZn39bG
         mtogHXeOeUwPaCnG/zLxVE+sjjFv8GRNkKmcaE9vWd726SmV87xBZfuLuAYnBKJS+3Sf
         EMVAC30iYT4KXjYHMErm+Cwk3kfXDmPa5XflsMUiqGvKgkwQV76/Z2gPaiJM+p8As2Nj
         cGMg+x7MektjzluY3gPTVzRk4/cY7mjxoRsLCbYn2oueylg0Z3yByNDs/DxcioK7hqTr
         wBXQ==
X-Gm-Message-State: AOAM531n+N5Ptrp8p12ecSfsmJ+rP+apfQr7wKTQ88TBo/1ngVN64F8C
        dUdxyn73zIKM7uB9G0rcQP8=
X-Google-Smtp-Source: ABdhPJz8utoQ/f5360TfHcZABooNF2qCkfoeu376eRPmnrqwpQx0GEvtqCkqhY2H2r9Oo7dPYo4VCg==
X-Received: by 2002:a17:906:1d55:: with SMTP id o21mr17777386ejh.485.1615256235887;
        Mon, 08 Mar 2021 18:17:15 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id bj7sm4364902ejb.28.2021.03.08.18.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 18:17:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net 2/4] net: dsa: prevent hardware forwarding between unbridged 8021q uppers
Date:   Tue,  9 Mar 2021 04:16:55 +0200
Message-Id: <20210309021657.3639745-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309021657.3639745-1-olteanv@gmail.com>
References: <20210309021657.3639745-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Tobias reports that the following set of commands, which bridge two
ports that have 8021q uppers with the same VID, is incorrectly accepted
by DSA as valid:

.100  br0  .100
   \  / \  /
   lan0 lan1

ip link add dev br0 type bridge vlan_filtering 1
ip link add dev lan0.100 link lan0 type vlan id 100
ip link add dev lan1.100 link lan1 type vlan id 100
ip link set dev lan0 master br0
ip link set dev lan1 master br0 # This should fail but doesn't

Again, this is a variation of the same theme of 'all VLANs kinda smell
the same in hardware, you can't tell if they came from 8021q or from the
bridge'. When the base interfaces are bridged, the expectation of the
Linux network stack is that traffic received by other upper interfaces
except the bridge is not captured by the bridge rx_handler, therefore
not subject to forwarding. So the above setup should not do forwarding
for VLAN ID 100, but it does it nonetheless. So it should be denied.

Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  6 +++++-
 net/dsa/port.c     | 23 ++++++++++++++++++++++-
 net/dsa/slave.c    | 13 +++++++++----
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d40dfede494c..d6f9b73241b4 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -181,7 +181,8 @@ int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
 void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
-int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
+int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
+			 struct netlink_ext_ack *extack);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
 int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo);
@@ -261,6 +262,9 @@ static inline bool dsa_tree_offloads_netdev(struct dsa_switch_tree *dst,
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
+int dsa_check_bridge_for_overlapping_8021q_uppers(struct net_device *bridge_dev,
+						  struct net_device *skip,
+						  u16 vid);
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
 void dsa_slave_destroy(struct net_device *slave_dev);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c9c6d7ab3f47..0aad5a84361c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -144,7 +144,8 @@ static void dsa_port_change_brport_flags(struct dsa_port *dp,
 	}
 }
 
-int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
+int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
+			 struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_bridge_info info = {
 		.tree_index = dp->ds->dst->index,
@@ -152,8 +153,28 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 		.port = dp->index,
 		.br = br,
 	};
+	struct net_device *slave = dp->slave;
+	struct net_device *upper_dev;
+	struct list_head *iter;
 	int err;
 
+	netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
+		u16 vid;
+
+		if (!is_vlan_dev(upper_dev))
+			continue;
+
+		vid = vlan_dev_vlan_id(upper_dev);
+
+		err = dsa_check_bridge_for_overlapping_8021q_uppers(br, slave,
+								    vid);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Configuration would leak VLAN-tagged packets between bridge ports");
+			return err;
+		}
+	}
+
 	/* Notify the port driver to set its configurable flags in a way that
 	 * matches the initial settings of a bridge port.
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d36e11399626..0e884fd439f8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -323,9 +323,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	return ret;
 }
 
-static int
-dsa_check_bridge_for_overlapping_8021q_uppers(struct net_device *bridge_dev,
-					      u16 vid)
+int dsa_check_bridge_for_overlapping_8021q_uppers(struct net_device *bridge_dev,
+						  struct net_device *skip,
+						  u16 vid)
 {
 	struct list_head *iter_upper, *iter_lower;
 	struct net_device *upper, *lower;
@@ -334,6 +334,9 @@ dsa_check_bridge_for_overlapping_8021q_uppers(struct net_device *bridge_dev,
 		if (!dsa_slave_dev_check(lower))
 			continue;
 
+		if (lower == skip)
+			continue;
+
 		netdev_for_each_upper_dev_rcu(lower, upper, iter_upper) {
 			u16 upper_vid;
 
@@ -373,6 +376,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	 */
 	if (br_vlan_enabled(dp->bridge_dev)) {
 		err = dsa_check_bridge_for_overlapping_8021q_uppers(dp->bridge_dev,
+								    NULL,
 								    vlan.vid);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -1969,7 +1973,8 @@ static int dsa_slave_changeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking) {
-			err = dsa_port_bridge_join(dp, info->upper_dev);
+			err = dsa_port_bridge_join(dp, info->upper_dev,
+						   info->info.extack);
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
 			err = notifier_from_errno(err);
-- 
2.25.1

