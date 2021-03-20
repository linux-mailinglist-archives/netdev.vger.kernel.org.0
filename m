Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9724934303F
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 00:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCTXAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 19:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhCTW7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:59:49 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7E8C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:59:48 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a7so15327544ejs.3
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e+x0CsY54hAVvQrt0uKaT6klSiIJ8qHUUQIai1jnqqo=;
        b=f5LL8W2w613HqHxwDpml+eg5cWUUkOMrS4rl5+5C8PxQA6WcRBZXVYmFVqXNriIS9W
         mY4mI3KQYSvn/MqtkBJtk7PR/6rABH9WFqK4H7MqdiIkGwUYRxhh9iYTuC61HmwXwyUS
         tDhfM9DDdSNDaCupLPba7kLug7zvG6j95KNrZ2twgddPYGLzdnSERyZ+/7rmPtDsq868
         xPCqj/L6Z5jbVGjmhdr6bwT8zfnD9CHaWWmGwbM846wZuk3Sj329vttgBC4ya8bpftNG
         R0Id85yBqpufI62ZTRr+s/JTA76ZFBl3XYRdXPBkM6jrido97HN4Kaue1SOJCulwQIK1
         ZjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e+x0CsY54hAVvQrt0uKaT6klSiIJ8qHUUQIai1jnqqo=;
        b=hraOA7iVIj5JjpwRiqCrRkNKu9P1kvJ+ReTOvi0iSIfCPDKYugvvtKjm5DqraXclvr
         ZOQ2bUIXIkC0Q2gJ3iaFXsxAG9IWwysFeG6A/J4pvXjeCt1dUupQMsxZbhXEG89oseiH
         ZkMLDtitdDTkD8hENujKgkQ+GWDrpqTnOVQOLI/qo4frkYoexIfmrtaxL5EkGadAECVX
         h96bneAfbozMmygwUbiaIi4FY+lo8NR/QJFwg22PnmXIYz7C/4Ns5ILQx4keFcdD4+x/
         cB6DmXPZxhen5ERtpnKz/NU9qzGTnYWF0Fq0LiM9bZGt3aS/CA7zsJeX56IWnGokMxgI
         dVmg==
X-Gm-Message-State: AOAM532UHOID3P/UtWHKGQxOCok7PcCLtrp59WYjimZ8V3P739E1D/pu
        yPCgV276l8PVg/XAP/eSWQQ=
X-Google-Smtp-Source: ABdhPJxJan3Pmtgi7pYfOiZyPaAcNXvwLWxbz74aPCtMbQzHcKiAiU0VkQNgQqNh9KVEtwzWoDaAJA==
X-Received: by 2002:a17:906:85b:: with SMTP id f27mr12061662ejd.414.1616281186716;
        Sat, 20 Mar 2021 15:59:46 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a3sm6101517ejv.40.2021.03.20.15.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:59:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 2/3] net: dsa: don't advertise 'rx-vlan-filter' if VLAN filtering not global
Date:   Sun, 21 Mar 2021 00:59:27 +0200
Message-Id: <20210320225928.2481575-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320225928.2481575-1-olteanv@gmail.com>
References: <20210320225928.2481575-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The blamed patch has removed the driver's ability to return -EOPNOTSUPP
in the .port_vlan_add method when called from .ndo_vlan_rx_add_vid
(unmassaged by DSA, -EOPNOTSUPP is a hard error for vlan_vid_add).
But we have not managed well enough the cases under which .port_vlan_add
is called in the first place, as will be explained below. This was
reported as a problem by Tobias because mv88e6xxx_port_vlan_prepare is
stubborn and only accepts VLANs on bridged ports. That is understandably
so, because standalone mv88e6xxx ports are VLAN-unaware, and VTU entries
are said to be a scarce resource.

Otherwise said, the following fails lamentably on mv88e6xxx:

ip link add br0 type bridge vlan_filtering 1
ip link set lan3 master br0
ip link add link lan10 name lan10.1 type vlan id 1
[485256.724147] mv88e6085 d0032004.mdio-mii:12: p10: hw VLAN 1 already used by port 3 in br0
RTNETLINK answers: Operation not supported

We need to step back and explain that the dsa_slave_vlan_rx_add_vid and
dsa_slave_vlan_rx_kill_vid methods exist for drivers that need the
'rx-vlan-filter: on' feature in ethtool -k, which can be due to any of
the following reasons:

1. vlan_filtering_is_global = true, and some ports are under a
   VLAN-aware bridge while others are standalone, and the standalone
   ports would otherwise drop VLAN-tagged traffic. This is described in
   commit 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid
   implementation").

2. the ports that are under a VLAN-aware bridge should also set this
   feature, for 8021q uppers having a VID not claimed by the bridge.
   In this case, the driver will essentially not even know that the VID
   is coming from the 8021q layer and not the bridge.

3. Hellcreek. This driver needs it because in standalone mode, it uses
   unique VLANs per port to ensure separation. For separation of untagged
   traffic, it uses different PVIDs for each port, and for separation of
   VLAN-tagged traffic, it never accepts 8021q uppers with the same vid
   on two ports.

If a driver does not fall under any of the above 3 categories, there is
no reason why it should advertise the 'rx-vlan-filter' feature, therefore
no reason why it should offload the VLANs added through vlan_vid_add.

This commit fixes the problem by removing the 'rx-vlan-filter' feature
from the slave devices when they operate in standalone mode, and when
they offload a VLAN-unaware bridge. This gives the mv88e6xxx driver what
it wants, since it keeps the 8021q VLANs away from the VTU until VLAN
awareness is enabled (point at which the ports are no longer standalone,
hence the check in mv88e6xxx_port_vlan_prepare passes). And since the
issue predates the existence of the hellcreek driver, case 3 will be
dealt with in a separate patch.

The commit also has the nice side effect that we no longer lie to the
network stack about our VLAN filtering status.

Because the 'rx-vlan-filter' feature is now dynamically toggled, and our
.ndo_vlan_rx_add_vid does not get called when 'rx-vlan-filter' is off,
we need to avoid bugs such as the following by replaying the VLANs from
8021q uppers every time we enable VLAN filtering:

ip link add link lan0 name lan0.100 type vlan id 100
ip addr add 192.168.100.1/24 dev lan0.100
ping 192.168.100.2 # should work
ip link add br0 type bridge vlan_filtering 0
ip link set lan0 master br0
ping 192.168.100.2 # should still work
ip link set br0 type bridge vlan_filtering 1
ping 192.168.100.2 # should still work but doesn't

Fixes: 9b236d2a69da ("net: dsa: Advertise the VLAN offload netdev ability only if switch supports it")
Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 37 +++++++++++++++++++++++++++--
 net/dsa/slave.c    | 58 ++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 4c43c5406834..d7dd9e07d168 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -269,6 +269,8 @@ int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
 void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
+int dsa_slave_manage_vlan_filtering(struct net_device *dev,
+				    bool vlan_filtering);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c9c6d7ab3f47..902095f04e0a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -363,6 +363,7 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack)
 {
+	bool old_vlan_filtering = dsa_port_is_vlan_filtering(dp);
 	struct dsa_switch *ds = dp->ds;
 	bool apply;
 	int err;
@@ -388,12 +389,44 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 	if (err)
 		return err;
 
-	if (ds->vlan_filtering_is_global)
+	if (ds->vlan_filtering_is_global) {
+		int port;
+
+		for (port = 0; port < ds->num_ports; port++) {
+			struct net_device *slave;
+
+			if (!dsa_is_user_port(ds, port))
+				continue;
+
+			/* We might be called in the unbind path, so not
+			 * all slave devices might still be registered.
+			 */
+			slave = dsa_to_port(ds, port)->slave;
+			if (!slave)
+				continue;
+
+			err = dsa_slave_manage_vlan_filtering(slave,
+							      vlan_filtering);
+			if (err)
+				goto restore;
+		}
+
 		ds->vlan_filtering = vlan_filtering;
-	else
+	} else {
+		err = dsa_slave_manage_vlan_filtering(dp->slave,
+						      vlan_filtering);
+		if (err)
+			goto restore;
+
 		dp->vlan_filtering = vlan_filtering;
+	}
 
 	return 0;
+
+restore:
+	ds->ops->port_vlan_filtering(ds, dp->index, old_vlan_filtering, NULL);
+
+	return err;
 }
 
 /* This enforces legacy behavior for switch drivers which assume they can't
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..6d06d13cdf3a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1387,6 +1387,62 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	return 0;
 }
 
+static int dsa_slave_restore_vlan(struct net_device *vdev, int vid, void *arg)
+{
+	__be16 proto = vdev ? vlan_dev_vlan_proto(vdev) : htons(ETH_P_8021Q);
+
+	return dsa_slave_vlan_rx_add_vid(arg, proto, vid);
+}
+
+static int dsa_slave_clear_vlan(struct net_device *vdev, int vid, void *arg)
+{
+	__be16 proto = vdev ? vlan_dev_vlan_proto(vdev) : htons(ETH_P_8021Q);
+
+	return dsa_slave_vlan_rx_kill_vid(arg, proto, vid);
+}
+
+/* Keep the VLAN RX filtering list in sync with the hardware only if VLAN
+ * filtering is enabled.
+ *
+ * - Standalone ports offload:
+ *   - no VLAN (any 8021q upper is a software VLAN) if
+ *     ds->vlan_filtering_is_global = false
+ *   - the 8021q upper VLANs if ds->vlan_filtering_is_global = true and there
+ *     are bridges spanning this switch chip which have vlan_filtering=1
+ *
+ * - Ports under a vlan_filtering=0 bridge offload:
+ *   - no VLAN if ds->configure_vlan_while_not_filtering = false (deprecated)
+ *   - the bridge VLANs if ds->configure_vlan_while_not_filtering = true
+ *
+ * - Ports under a vlan_filtering=1 bridge offload:
+ *   - the bridge VLANs
+ *   - the 8021q upper VLANs
+ */
+int dsa_slave_manage_vlan_filtering(struct net_device *slave,
+				    bool vlan_filtering)
+{
+	int err;
+
+	if (vlan_filtering) {
+		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+
+		err = vlan_for_each(slave, dsa_slave_restore_vlan, slave);
+		if (err) {
+			vlan_for_each(slave, dsa_slave_clear_vlan, slave);
+			slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+			return err;
+		}
+	} else {
+		err = vlan_for_each(slave, dsa_slave_clear_vlan, slave);
+		if (err)
+			return err;
+
+		slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	}
+
+	return 0;
+}
+
 struct dsa_hw_port {
 	struct list_head list;
 	struct net_device *dev;
@@ -1857,8 +1913,6 @@ int dsa_slave_create(struct dsa_port *port)
 		return -ENOMEM;
 
 	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
-	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
-		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
 	slave_dev->features |= NETIF_F_LLTX;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
-- 
2.25.1

