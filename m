Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA6474E0C
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhLNWo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbhLNWoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:25 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A728FC061574;
        Tue, 14 Dec 2021 14:44:24 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g14so67336847edb.8;
        Tue, 14 Dec 2021 14:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SIfarseuazWNvAMizZs44/rl8z9XqJc6Pl24mqqhG8E=;
        b=lTk6V4dKPQevR5z7tN5XYTqk+EJyT6Ta3+S7NZNdT+4vzu502HMNQwcHaT8rcokHvX
         QgFtW/Cf4KnSfa5r95gcUNLDlM8UyYD0Hi0xD1NQ0mZRjmWRHaci4oJ3wUDhEIuPrbFq
         GZMJONjViWJaXOhJpS+7J2inNjbM+qKde2uAktuCzZ9BiF25SPmPVm2tzL8V2UeLODiN
         VAHTqUJtilaJ6wpS6d0uTkclOPn8K4oU0WaWuVU94y1BPVJPB/3yDifUUEIwvoJlKteT
         WiO8JbnwNY/NEmROQtw3kswckyT1exurZn6Kx/egqs59J199L6T70q97elI8lirLTSy0
         1CNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SIfarseuazWNvAMizZs44/rl8z9XqJc6Pl24mqqhG8E=;
        b=FWDZE4MYAMkGcHU9edRkRfBGYc3m+uI6rWQ9l6kJ9i3MzclE2RxaH1/aw27zmRiZYY
         TMsei72xs6LlUUFJXAWChC4t95LKlw5C6i9BUxW/BQ0s3HBsgdpm5MSaoybEUYt12B0D
         z/jPk3/XbMeK1XxaS3fBz0v+gNgTbEF2wQO1tXerORrxU3CmEr0O6Pfh5jxbNVCvy1jG
         LeXAMKn1z0FNPTRf0AMKsXf2A3vj4ZkpjLkh5eUPYFAqd91E2IVqs7PG0cxhZLHWZqHg
         rt3feOBU4dx3vv8sdPuixQDgcrVhmxYa4jrNmdodM8HzrMcAwGRKavjgesLvsdyuf3W6
         ElXA==
X-Gm-Message-State: AOAM530pOcQ1hiHGl0mUhg80X2zXTQjnlOrYBciqTDNMSUTz0+DA14Ql
        HOmO2meAS2GkRFO0TS15hto=
X-Google-Smtp-Source: ABdhPJyWZSJL9n9Ftf29R+xfWAiA8bSKrrrOxzhNRQ2SGaI0JSm7hau/3cT63NeEPDMRRNkhT4mXoA==
X-Received: by 2002:a17:906:5f94:: with SMTP id a20mr8925079eju.256.1639521863092;
        Tue, 14 Dec 2021 14:44:23 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:22 -0800 (PST)
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
Subject: [net-next PATCH RFC v6 01/16] net: dsa: provide switch operations for tracking the master state
Date:   Tue, 14 Dec 2021 23:43:54 +0100
Message-Id: <20211214224409.5770-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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
index f16959444ae1..70a1f21e4473 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -292,6 +292,10 @@ struct dsa_port {
 	struct list_head	fdbs;
 	struct list_head	mdbs;
 
+	/* Master state bits, valid only on CPU ports */
+	u8 master_admin_up:1,
+	   master_oper_up:1;
+
 	bool setup;
 };
 
@@ -458,6 +462,12 @@ static inline bool dsa_port_is_unused(struct dsa_port *dp)
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
@@ -1016,6 +1026,13 @@ struct dsa_switch_ops {
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
index c18b22c0bf55..eb466e92069c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1244,6 +1244,52 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
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
index edfaae7b5967..1566064ccfe2 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -45,6 +45,7 @@ enum {
 	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
+	DSA_NOTIFIER_MASTER_STATE_CHANGE,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -128,6 +129,12 @@ struct dsa_notifier_tag_8021q_vlan_info {
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
@@ -508,6 +515,12 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
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
index 88f7b8686dac..9dfcfc5dae0a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2348,6 +2348,36 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
@@ -2359,6 +2389,8 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		cpu_dp = dev->dsa_ptr;
 		dst = cpu_dp->ds->dst;
 
+		dsa_tree_master_admin_state_change(dst, dev, false);
+
 		list_for_each_entry(dp, &dst->ports, list) {
 			if (!dsa_port_is_user(dp))
 				continue;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 393f2d8a860a..726bb5ca1183 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -753,6 +753,18 @@ dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
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
@@ -844,6 +856,9 @@ static int dsa_switch_event(struct notifier_block *nb,
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

