Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807E6496F68
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbiAWBdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiAWBdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:44 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2445EC06173D;
        Sat, 22 Jan 2022 17:33:44 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ah7so11082587ejc.4;
        Sat, 22 Jan 2022 17:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MmjK0cbW4JfRAIy8wWmSUTOu38ViEKsI6kEuWRAmYyY=;
        b=kELF1zl8zOLzie0U4YmPvhyBXp2GYoNzeR1rEJLLOYibj1tCVvmh2w2MemDbwwEgXc
         r4H8Rq0Id61IXYoBNNT7p5BHkN79F1NxGBsPe8Bt9s5oFMmPp9wsI31wu6fnOFURwDII
         xt0BBfTI/73ZKUqGvwCbHnZVWClQZEfxHS3ocIo2ILK894kdsvr6ZAdPVZz/3YxENvWH
         QwHzD8Wd6FUCh+Ssh/Ci+ZnrPFu785H2foLZ23FZoRONkMBKiYopgUO7s+3iRlno2rQL
         4Us/T7eyrqWaOAmEsqe+gz/gF0QbA7nYt50i3+h5EMjBekIZ6X3nQtDUXUWymVzI7R1P
         +H7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MmjK0cbW4JfRAIy8wWmSUTOu38ViEKsI6kEuWRAmYyY=;
        b=wG1nxYyKffPpGarBShGmPenagv/CeKkTjY8UtrcLz1M7IARE/FjdP56kPHEU2gO8gd
         cCDvvahxaGytKMYtzVo/NX6ZWi/v4oEwJQCdp8a7t0fenjoZQszVk2cZmONo7JLUrh4z
         mTSLcBb181cnHhdJdByT3wxKgZ3IN/w8XBCyFoH1Z6MvpPKW0PNQZ+VFPx0Ys2h1FZo6
         X3TVTBblTc390l5h661N6auZe7JqMloQX/UkWcqgF5kxv5799KawUsMlC42lJN8W+nqa
         rxyr+fH+6ZdIRRZ4vaHTA8F81m4zFTq8qlQ/0iUB1ypJhPhA1WstmcRlhUE3uJ155Wj4
         gB6Q==
X-Gm-Message-State: AOAM533l0FW3heljAALYeGkAJ1L/o65d7grLbWvusDuj+dmtE8ZegOvx
        5bfpAKhWHbcLsXeLBFiizC4=
X-Google-Smtp-Source: ABdhPJwfpjRPTawcnKIqkYP0axL/rACHtJ/NTCf5R7X6AFUByFIG95PA1kDDgWiKcE7/q1oKKBcVCw==
X-Received: by 2002:a17:907:961c:: with SMTP id gb28mr2103293ejc.519.1642901622518;
        Sat, 22 Jan 2022 17:33:42 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:42 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 01/16] net: dsa: provide switch operations for tracking the master state
Date:   Sun, 23 Jan 2022 02:33:22 +0100
Message-Id: <20220123013337.20945-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Certain drivers may need to send management traffic to the switch for
things like register access, FDB dump, etc, to accelerate what their
slow bus (SPI, I2C, MDIO) can already do.

Ethernet is faster (especially in bulk transactions) but is also more
unreliable, since the user may decide to bring the DSA master down (or
not bring it up), therefore severing the link between the host and the
attached switch.

Drivers needing Ethernet-based register access already should have
fallback logic to the slow bus if the Ethernet method fails, but that
fallback may be based on a timeout, and the I/O to the switch may slow
down to a halt if the master is down, because every Ethernet packet will
have to time out. The driver also doesn't have the option to turn off
Ethernet-based I/O momentarily, because it wouldn't know when to turn it
back on.

Which is where this change comes in. By tracking NETDEV_CHANGE,
NETDEV_UP and NETDEV_GOING_DOWN events on the DSA master, we should know
the exact interval of time during which this interface is reliably
available for traffic. Provide this information to switches so they can
use it as they wish.

An helper is added dsa_port_master_is_operational() to check if a master
port is operational.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/net/dsa.h  | 17 +++++++++++++++++
 net/dsa/dsa2.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h | 13 +++++++++++++
 net/dsa/slave.c    | 32 ++++++++++++++++++++++++++++++++
 net/dsa/switch.c   | 15 +++++++++++++++
 5 files changed, 123 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 57b3e4e7413b..43c4153ef53a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -278,6 +278,10 @@ struct dsa_port {
 
 	u8			devlink_port_setup:1;
 
+	/* Master state bits, valid only on CPU ports */
+	u8			master_admin_up:1;
+	u8			master_oper_up:1;
+
 	u8			setup:1;
 
 	struct device_node	*dn;
@@ -478,6 +482,12 @@ static inline bool dsa_port_is_unused(struct dsa_port *dp)
 	return dp->type == DSA_PORT_TYPE_UNUSED;
 }
 
+static inline bool dsa_port_master_is_operational(struct dsa_port *dp)
+{
+	return dsa_port_is_cpu(dp) && dp->master_admin_up &&
+	       dp->master_oper_up;
+}
+
 static inline bool dsa_is_unused_port(struct dsa_switch *ds, int p)
 {
 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_UNUSED;
@@ -1036,6 +1046,13 @@ struct dsa_switch_ops {
 	int	(*tag_8021q_vlan_add)(struct dsa_switch *ds, int port, u16 vid,
 				      u16 flags);
 	int	(*tag_8021q_vlan_del)(struct dsa_switch *ds, int port, u16 vid);
+
+	/*
+	 * DSA master tracking operations
+	 */
+	void	(*master_state_change)(struct dsa_switch *ds,
+				       const struct net_device *master,
+				       bool operational);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3d21521453fe..ff998c0ede02 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1279,6 +1279,52 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	return err;
 }
 
+static void dsa_tree_master_state_change(struct dsa_switch_tree *dst,
+					 struct net_device *master)
+{
+	struct dsa_notifier_master_state_info info;
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+
+	info.master = master;
+	info.operational = dsa_port_master_is_operational(cpu_dp);
+
+	dsa_tree_notify(dst, DSA_NOTIFIER_MASTER_STATE_CHANGE, &info);
+}
+
+void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
+					struct net_device *master,
+					bool up)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	bool notify = false;
+
+	if ((dsa_port_master_is_operational(cpu_dp)) !=
+	    (up && cpu_dp->master_oper_up))
+		notify = true;
+
+	cpu_dp->master_admin_up = up;
+
+	if (notify)
+		dsa_tree_master_state_change(dst, master);
+}
+
+void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
+				       struct net_device *master,
+				       bool up)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	bool notify = false;
+
+	if ((dsa_port_master_is_operational(cpu_dp)) !=
+	    (cpu_dp->master_admin_up && up))
+		notify = true;
+
+	cpu_dp->master_oper_up = up;
+
+	if (notify)
+		dsa_tree_master_state_change(dst, master);
+}
+
 static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 {
 	struct dsa_switch_tree *dst = ds->dst;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 760306f0012f..2bbfa9efe9f8 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -40,6 +40,7 @@ enum {
 	DSA_NOTIFIER_TAG_PROTO_DISCONNECT,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
+	DSA_NOTIFIER_MASTER_STATE_CHANGE,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -109,6 +110,12 @@ struct dsa_notifier_tag_8021q_vlan_info {
 	u16 vid;
 };
 
+/* DSA_NOTIFIER_MASTER_STATE_CHANGE */
+struct dsa_notifier_master_state_info {
+	const struct net_device *master;
+	bool operational;
+};
+
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
@@ -482,6 +489,12 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
+void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
+					struct net_device *master,
+					bool up);
+void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
+				       struct net_device *master,
+				       bool up);
 unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
 void dsa_bridge_num_put(const struct net_device *bridge_dev,
 			unsigned int bridge_num);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 22241afcac81..2b5b0f294233 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2346,6 +2346,36 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		err = dsa_port_lag_change(dp, info->lower_state_info);
 		return notifier_from_errno(err);
 	}
+	case NETDEV_CHANGE:
+	case NETDEV_UP: {
+		/* Track state of master port.
+		 * DSA driver may require the master port (and indirectly
+		 * the tagger) to be available for some special operation.
+		 */
+		if (netdev_uses_dsa(dev)) {
+			struct dsa_port *cpu_dp = dev->dsa_ptr;
+			struct dsa_switch_tree *dst = cpu_dp->ds->dst;
+
+			/* Track when the master port is UP */
+			dsa_tree_master_oper_state_change(dst, dev,
+							  netif_oper_up(dev));
+
+			/* Track when the master port is ready and can accept
+			 * packet.
+			 * NETDEV_UP event is not enough to flag a port as ready.
+			 * We also have to wait for linkwatch_do_dev to dev_activate
+			 * and emit a NETDEV_CHANGE event.
+			 * We check if a master port is ready by checking if the dev
+			 * have a qdisc assigned and is not noop.
+			 */
+			dsa_tree_master_admin_state_change(dst, dev,
+							   !qdisc_tx_is_noop(dev));
+
+			return NOTIFY_OK;
+		}
+
+		return NOTIFY_DONE;
+	}
 	case NETDEV_GOING_DOWN: {
 		struct dsa_port *dp, *cpu_dp;
 		struct dsa_switch_tree *dst;
@@ -2357,6 +2387,8 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		cpu_dp = dev->dsa_ptr;
 		dst = cpu_dp->ds->dst;
 
+		dsa_tree_master_admin_state_change(dst, dev, false);
+
 		list_for_each_entry(dp, &dst->ports, list) {
 			if (!dsa_port_is_user(dp))
 				continue;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index e3c7d2627a61..4e9cbe3a3127 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -683,6 +683,18 @@ dsa_switch_disconnect_tag_proto(struct dsa_switch *ds,
 	return 0;
 }
 
+static int
+dsa_switch_master_state_change(struct dsa_switch *ds,
+			       struct dsa_notifier_master_state_info *info)
+{
+	if (!ds->ops->master_state_change)
+		return 0;
+
+	ds->ops->master_state_change(ds, info->master, info->operational);
+
+	return 0;
+}
+
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
@@ -756,6 +768,9 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_TAG_8021Q_VLAN_DEL:
 		err = dsa_switch_tag_8021q_vlan_del(ds, info);
 		break;
+	case DSA_NOTIFIER_MASTER_STATE_CHANGE:
+		err = dsa_switch_master_state_change(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.33.1

