Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B21474CFB
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbhLNVKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhLNVKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:30 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51F1C061574;
        Tue, 14 Dec 2021 13:10:29 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z7so6380684edc.11;
        Tue, 14 Dec 2021 13:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SIfarseuazWNvAMizZs44/rl8z9XqJc6Pl24mqqhG8E=;
        b=XrrkprtcBi8m1GFt06uV5L6MraXrIfwn+F5hmrvKkORAyNRyBH5U0Sr2/e2eQjUcFN
         2GdgwtFKfAG2UVc73A0/bCxinNF/VG6pv5mXxXT5qnLKv4SmuduRO1APXfDNAL781Myl
         1bo/NxXh/KaJ/TO33LJ6TzvOiiRjeO8rUWlfbv9J6RBHXpvjLmDwjA3866yh3gIZGQXQ
         iCXICMTIeTHVEm9NlApztAO2U9brLjXxj4czCh3fCup471XmKh2fDaUvZv8VGaUi5mX/
         oUQIB+hfoJ40kzkGcNto1+e29pmmJ+KH+xJT09jPL1orVaRkJchwwt3PaiYlx1EIZLvL
         eKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SIfarseuazWNvAMizZs44/rl8z9XqJc6Pl24mqqhG8E=;
        b=58cv8wAT0XeLUZbZxajSGwWqgiYCoTGlIDVEJ7avm0xZRPLXk/wr98bOWoR0ttVIHM
         N1MYjgUz8U/qUFvo0FZQ3D06wf837SSUVIJA/+LimwzocGlkOe2N2wJ4TfaiKuqD+MLF
         TbyGhm0DIHWi0blgJm4r/f2+kTUhQ50AXTk3RgcAUwx2A7xAVpY5kMA/zLcxSTHqdmCB
         um8gLDgJXfcJA7yTAsMOxZ/CsDdE9lslcwvpFestDdD/Yn8yGV0obQopv06IMD5oRUaK
         xaesxFzsP7PoTOY38E2peQTzNJFRfL6Nkpz1MSynBh1yxM3f1QEf16FetmCuVzA+A9vp
         glqg==
X-Gm-Message-State: AOAM533+ZtzsYXl2AaK3OAkLGwS5IRLu3rGVmum9V/IZ6IY0ABKAYDHR
        f98Etk7k5q9Ag0VfwpXNcJOhb4s4qnmMwg==
X-Google-Smtp-Source: ABdhPJwZqpNCWeTR0x4HryMcE9Ni09zB3YRybax3Jtn9Y1okWxEgfdE8ZHv+OWsn4JV09FQ3kXjnaQ==
X-Received: by 2002:a05:6402:2210:: with SMTP id cq16mr11280009edb.32.1639516227262;
        Tue, 14 Dec 2021 13:10:27 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:26 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 01/16] net: dsa: provide switch operations for tracking the master state
Date:   Tue, 14 Dec 2021 22:09:56 +0100
Message-Id: <20211214211011.24850-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
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

