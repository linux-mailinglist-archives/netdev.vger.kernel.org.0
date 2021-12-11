Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384CB4715DF
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhLKT6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhLKT6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:17 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287A5C061714;
        Sat, 11 Dec 2021 11:58:17 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x15so40855130edv.1;
        Sat, 11 Dec 2021 11:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7LkxibGTG1/s8oYd+HYCisYsLoo3EkpzmJBp1nsK2GE=;
        b=LaQP421mDTGeaUzoEgaPtj06Aw3iavJIMl63eitRm6erxgl+2WvdcwQ6d32zlkhcnd
         sPY+1ggYXhhkDXITKKM+ZMaeun4Ifzc89f+RPSCADPHP/QGPI3Z4vQMl7x8c43N8dTFd
         o4h4ENnoSDUoG3Y21t7mUEH1fjxcndDC2pRRgxXSJFMUwDPpQzlwGxGSCxcC7YR0bRVJ
         P+/6SfktjtGX0T6gbAlqgRAhz67mxxxdyQTu4v5nwDnCn7QzVlDhxiv+FBDefy3M9ggb
         KJSvm2medB+fUP0Ghas2IpUE7x0y1dDtaP+OOsgzJHoFHPAvlb5wGKXTx/Dbiy9Wc/yp
         90pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7LkxibGTG1/s8oYd+HYCisYsLoo3EkpzmJBp1nsK2GE=;
        b=iCaxAexeO18DUhfPgGSNG+wMIhDVf13BeePRC1+FBulFn88UqLnH0gEVixL0v5Gmkq
         yZHgNuTTfwKII+Mwv/LQ2wCF61qJt3cgHnkt64BQDftE8rJzFu+2M6eTGSPl2gxbirkk
         B2sJDQlwrNHaWjhYxQ0oKijtazplDyRU2XfxqTRnSKbeQ/fWeqOEqrx2ICj71/swFAPq
         TxRwMeJWhAHPVbwfrp8hYTqHtvdLdd1w/850uAkQduRhuoPAJr7ffEvWMR8u4UpEMj1/
         ouHs3zL0LpF2JDbZXM0x1vVCn3KXkKNDkaoYVYUpFTqK4uJR6o7sTPwoFNsjfMBA53iK
         ln7g==
X-Gm-Message-State: AOAM533vwiL0hTMClTufeqzTXeNAqEJqJvf2fzA3Zps4LZOKvw2Jwpkc
        W1cMYp0FTknU1rP7yP8c7Ok=
X-Google-Smtp-Source: ABdhPJwR5plhr2iP9JRlHL+Gf3Oj1Kd8qZ+SCHeb/DG4YaPlJAYOB1Rq1fXc0WZT+MuNB0hObjbO7Q==
X-Received: by 2002:a05:6402:51cb:: with SMTP id r11mr48859000edd.150.1639252695588;
        Sat, 11 Dec 2021 11:58:15 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:15 -0800 (PST)
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
Subject: [net-next RFC PATCH v4 01/15] net: dsa: provide switch operations for tracking the master state
Date:   Sat, 11 Dec 2021 20:57:44 +0100
Message-Id: <20211211195758.28962-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/net/dsa.h  | 11 +++++++++++
 net/dsa/dsa2.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h | 13 +++++++++++++
 net/dsa/slave.c    | 32 ++++++++++++++++++++++++++++++++
 net/dsa/switch.c   | 15 +++++++++++++++
 5 files changed, 117 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8b496c7e62ef..12352aafe1cf 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -299,6 +299,10 @@ struct dsa_port {
 	struct list_head	fdbs;
 	struct list_head	mdbs;
 
+	/* Master state bits, valid only on CPU ports */
+	u8 master_admin_up:1,
+	   master_oper_up:1;
+
 	bool setup;
 };
 
@@ -1023,6 +1027,13 @@ struct dsa_switch_ops {
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
index cf6566168620..86b1e2f11469 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1245,6 +1245,52 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	return err;
 }
 
+static void dsa_tree_master_state_change(struct dsa_switch_tree *dst,
+					 struct net_device *master)
+{
+	struct dsa_notifier_master_state_info info;
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+
+	info.master = master;
+	info.operational = cpu_dp->master_admin_up && cpu_dp->master_oper_up;
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
+	if ((cpu_dp->master_admin_up && cpu_dp->master_oper_up) !=
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
+	if ((cpu_dp->master_admin_up && cpu_dp->master_oper_up) !=
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
index 0db2b26b0c83..d2f2bce2391b 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -44,6 +44,7 @@ enum {
 	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
+	DSA_NOTIFIER_MASTER_STATE_CHANGE,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -127,6 +128,12 @@ struct dsa_notifier_tag_8021q_vlan_info {
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
@@ -507,6 +514,12 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
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
index 88f7b8686dac..5ccb0616022d 100644
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
+							   qdisc_tx_is_noop(dev));
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
index 06948f536829..321972b85857 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -710,6 +710,18 @@ dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
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
@@ -798,6 +810,9 @@ static int dsa_switch_event(struct notifier_block *nb,
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
2.32.0

