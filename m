Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B239F5F4F
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfKINDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33427 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfKIND3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:29 -0500
Received: by mail-wr1-f67.google.com with SMTP id w9so3132055wrr.0
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QsmciPk0MzFKJYYUjnTJZhcscbnrn2PWMw3GwE+2tMI=;
        b=aw5fWFjMLLpzq9LpqeqM8+WfabTcjg5qz1xvOZO4ILmKXtAUdcTvtyLOZY7ed4FR5L
         7qojvEJ/pcGug+sKKSmNT3CTBgH4xy+l3jqO/k7lf0gm/7WMzjutng1QB/3l/rjIRrUA
         AuWk9Q7WMdQQJmZxFdm16zfw+mUqQyUyGkJ5lquZyfmMeoPC97EaLCTRB4n70Yxv1xzb
         bPRJW4uDCnIpWxdEKkPwDWdF9LMPcDFs8FCkdgheT1jHg2W7Ao2EKLws6TZK1CHwFURs
         4VTkaea/juEeXDSgbyFmhAsu1Jv4tnhY4W9WZo/bgCYVkXO20Bzd4L//BP2MnIC8oaji
         +84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QsmciPk0MzFKJYYUjnTJZhcscbnrn2PWMw3GwE+2tMI=;
        b=mDoITa7kjbAa/XvqWFzJ4xp724reLS/ZXpUfLGvhrIazGpP9iKT2iU8am/VdzZ9bIV
         lLCSJ48rdDF2djOFB84MRKMJjT9UV5oPbptr9bCDxZn/8kvxufmyFITsvC+WafXzSRfM
         rRAA9nt4xfmmuE2Y3+oPTUTV84RmsmIUmPFV1wn5dwtLhZlDMwfOpYeafyE/8nKpJf2p
         vBnCnvm3JK2efa5FmrJE6ca78cCuEWGH5dCLdkFjVX8REEDmfMwoz/hn3One236zq32g
         SB0vyhnpnK9GOJGODtqqPz2dFw0os06xEqxx+pO3iQ/v22dthFHAWNCQU/bYvwh08hxb
         fL8Q==
X-Gm-Message-State: APjAAAXGxIRpm7eyWzXGN6KJ+s1IVecfMqn/vfipWe3DJd36+JIr6x+v
        srA09hRLLzekQ9CHrql+omE=
X-Google-Smtp-Source: APXvYqz/r/TUrFUKvTIrgYU//9si9uNgvmnFdhvSJjEv5UHta8QF1UZ+edhHYrX93x1XQ/8qphQdwA==
X-Received: by 2002:a05:6000:14a:: with SMTP id r10mr12518999wrx.310.1573304606472;
        Sat, 09 Nov 2019 05:03:26 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:26 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 06/15] net: mscc: ocelot: refactor struct ocelot_port out of function prototypes
Date:   Sat,  9 Nov 2019 15:02:52 +0200
Message-Id: <20191109130301.13716-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot_port structure has a net_device embedded in it, which makes
it unsuitable for leaving it in the driver implementation functions.

Leave ocelot_flower.c untouched. In that file, ocelot_port is used as an
interface to the tc shared blocks. That will be addressed in the next
patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c        | 79 +++++++++++------------
 drivers/net/ethernet/mscc/ocelot_police.c | 36 +++++------
 drivers/net/ethernet/mscc/ocelot_police.h |  4 +-
 drivers/net/ethernet/mscc/ocelot_tc.c     |  5 +-
 4 files changed, 59 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ba8996bf995e..492193af2f73 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -133,11 +133,11 @@ static void ocelot_mact_init(struct ocelot *ocelot)
 	ocelot_write(ocelot, MACACCESS_CMD_INIT, ANA_TABLES_MACACCESS);
 }
 
-static void ocelot_vcap_enable(struct ocelot *ocelot, struct ocelot_port *port)
+static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 {
 	ocelot_write_gix(ocelot, ANA_PORT_VCAP_S2_CFG_S2_ENA |
 			 ANA_PORT_VCAP_S2_CFG_S2_IP6_CFG(0xa),
-			 ANA_PORT_VCAP_S2_CFG, port->chip_port);
+			 ANA_PORT_VCAP_S2_CFG, port);
 }
 
 static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
@@ -170,19 +170,17 @@ static int ocelot_vlant_set_mask(struct ocelot *ocelot, u16 vid, u32 mask)
 	return ocelot_vlant_wait_for_completion(ocelot);
 }
 
-static void ocelot_vlan_mode(struct ocelot_port *port,
+static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
 			     netdev_features_t features)
 {
-	struct ocelot *ocelot = port->ocelot;
-	u8 p = port->chip_port;
 	u32 val;
 
 	/* Filtering */
 	val = ocelot_read(ocelot, ANA_VLANMASK);
 	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
-		val |= BIT(p);
+		val |= BIT(port);
 	else
-		val &= ~BIT(p);
+		val &= ~BIT(port);
 	ocelot_write(ocelot, val, ANA_VLANMASK);
 }
 
@@ -1034,18 +1032,20 @@ static int ocelot_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 static int ocelot_set_features(struct net_device *dev,
 			       netdev_features_t features)
 {
-	struct ocelot_port *port = netdev_priv(dev);
 	netdev_features_t changed = dev->features ^ features;
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = ocelot_port->chip_port;
 
 	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
-	    port->tc.offload_cnt) {
+	    ocelot_port->tc.offload_cnt) {
 		netdev_err(dev,
 			   "Cannot disable HW TC offload while offloads active\n");
 		return -EBUSY;
 	}
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER)
-		ocelot_vlan_mode(port, features);
+		ocelot_vlan_mode(ocelot, port, features);
 
 	return 0;
 }
@@ -1586,11 +1586,9 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
-static int ocelot_port_bridge_join(struct ocelot_port *ocelot_port,
+static int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 				   struct net_device *bridge)
 {
-	struct ocelot *ocelot = ocelot_port->ocelot;
-
 	if (!ocelot->bridge_mask) {
 		ocelot->hw_bridge_dev = bridge;
 	} else {
@@ -1600,17 +1598,14 @@ static int ocelot_port_bridge_join(struct ocelot_port *ocelot_port,
 			return -ENODEV;
 	}
 
-	ocelot->bridge_mask |= BIT(ocelot_port->chip_port);
+	ocelot->bridge_mask |= BIT(port);
 
 	return 0;
 }
 
-static int ocelot_port_bridge_leave(struct ocelot_port *ocelot_port,
+static int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 				    struct net_device *bridge)
 {
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = ocelot_port->chip_port;
-
 	ocelot->bridge_mask &= ~BIT(port);
 
 	if (!ocelot->bridge_mask)
@@ -1679,14 +1674,12 @@ static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
 	}
 }
 
-static int ocelot_port_lag_join(struct ocelot_port *ocelot_port,
+static int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 				struct net_device *bond)
 {
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int p = ocelot_port->chip_port;
-	int lag, lp;
 	struct net_device *ndev;
 	u32 bond_mask = 0;
+	int lag, lp;
 
 	rcu_read_lock();
 	for_each_netdev_in_bond_rcu(bond, ndev) {
@@ -1701,17 +1694,17 @@ static int ocelot_port_lag_join(struct ocelot_port *ocelot_port,
 	/* If the new port is the lowest one, use it as the logical port from
 	 * now on
 	 */
-	if (p == lp) {
-		lag = p;
-		ocelot->lags[p] = bond_mask;
-		bond_mask &= ~BIT(p);
+	if (port == lp) {
+		lag = port;
+		ocelot->lags[port] = bond_mask;
+		bond_mask &= ~BIT(port);
 		if (bond_mask) {
 			lp = __ffs(bond_mask);
 			ocelot->lags[lp] = 0;
 		}
 	} else {
 		lag = lp;
-		ocelot->lags[lp] |= BIT(p);
+		ocelot->lags[lp] |= BIT(port);
 	}
 
 	ocelot_setup_lag(ocelot, lag);
@@ -1720,34 +1713,32 @@ static int ocelot_port_lag_join(struct ocelot_port *ocelot_port,
 	return 0;
 }
 
-static void ocelot_port_lag_leave(struct ocelot_port *ocelot_port,
+static void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 				  struct net_device *bond)
 {
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int p = ocelot_port->chip_port;
 	u32 port_cfg;
 	int i;
 
 	/* Remove port from any lag */
 	for (i = 0; i < ocelot->num_phys_ports; i++)
-		ocelot->lags[i] &= ~BIT(ocelot_port->chip_port);
+		ocelot->lags[i] &= ~BIT(port);
 
 	/* if it was the logical port of the lag, move the lag config to the
 	 * next port
 	 */
-	if (ocelot->lags[p]) {
-		int n = __ffs(ocelot->lags[p]);
+	if (ocelot->lags[port]) {
+		int n = __ffs(ocelot->lags[port]);
 
-		ocelot->lags[n] = ocelot->lags[p];
-		ocelot->lags[p] = 0;
+		ocelot->lags[n] = ocelot->lags[port];
+		ocelot->lags[port] = 0;
 
 		ocelot_setup_lag(ocelot, n);
 	}
 
-	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, p);
+	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
 	port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
-	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(p),
-			 ANA_PORT_PORT_CFG, p);
+	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
+			 ANA_PORT_PORT_CFG, port);
 
 	ocelot_set_aggr_pgids(ocelot);
 }
@@ -1763,24 +1754,26 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
 				       struct netdev_notifier_changeupper_info *info)
 {
 	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = ocelot_port->chip_port;
 	int err = 0;
 
 	switch (event) {
 	case NETDEV_CHANGEUPPER:
 		if (netif_is_bridge_master(info->upper_dev)) {
 			if (info->linking)
-				err = ocelot_port_bridge_join(ocelot_port,
+				err = ocelot_port_bridge_join(ocelot, port,
 							      info->upper_dev);
 			else
-				err = ocelot_port_bridge_leave(ocelot_port,
+				err = ocelot_port_bridge_leave(ocelot, port,
 							       info->upper_dev);
 		}
 		if (netif_is_lag_master(info->upper_dev)) {
 			if (info->linking)
-				err = ocelot_port_lag_join(ocelot_port,
+				err = ocelot_port_lag_join(ocelot, port,
 							   info->upper_dev);
 			else
-				ocelot_port_lag_leave(ocelot_port,
+				ocelot_port_lag_leave(ocelot, port,
 						      info->upper_dev);
 		}
 		break;
@@ -2136,7 +2129,7 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		       REW_PORT_VLAN_CFG, port);
 
 	/* Enable vcap lookups */
-	ocelot_vcap_enable(ocelot, ocelot_port);
+	ocelot_vcap_enable(ocelot, port);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_police.c b/drivers/net/ethernet/mscc/ocelot_police.c
index 701e82dd749a..faddce43f2e3 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.c
+++ b/drivers/net/ethernet/mscc/ocelot_police.c
@@ -40,13 +40,12 @@ struct qos_policer_conf {
 	u8   ipg; /* Size of IPG when MSCC_QOS_RATE_MODE_LINE is chosen */
 };
 
-static int qos_policer_conf_set(struct ocelot_port *port, u32 pol_ix,
+static int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
 				struct qos_policer_conf *conf)
 {
 	u32 cf = 0, cir_ena = 0, frm_mode = POL_MODE_LINERATE;
 	u32 cir = 0, cbs = 0, pir = 0, pbs = 0;
 	bool cir_discard = 0, pir_discard = 0;
-	struct ocelot *ocelot = port->ocelot;
 	u32 pbs_max = 0, cbs_max = 0;
 	u8 ipg = 20;
 	u32 value;
@@ -123,22 +122,26 @@ static int qos_policer_conf_set(struct ocelot_port *port, u32 pol_ix,
 
 	/* Check limits */
 	if (pir > GENMASK(15, 0)) {
-		netdev_err(port->dev, "Invalid pir\n");
+		dev_err(ocelot->dev, "Invalid pir for port %d: %u (max %lu)\n",
+			port, pir, GENMASK(15, 0));
 		return -EINVAL;
 	}
 
 	if (cir > GENMASK(15, 0)) {
-		netdev_err(port->dev, "Invalid cir\n");
+		dev_err(ocelot->dev, "Invalid cir for port %d: %u (max %lu)\n",
+			port, cir, GENMASK(15, 0));
 		return -EINVAL;
 	}
 
 	if (pbs > pbs_max) {
-		netdev_err(port->dev, "Invalid pbs\n");
+		dev_err(ocelot->dev, "Invalid pbs for port %d: %u (max %u)\n",
+			port, pbs, pbs_max);
 		return -EINVAL;
 	}
 
 	if (cbs > cbs_max) {
-		netdev_err(port->dev, "Invalid cbs\n");
+		dev_err(ocelot->dev, "Invalid cbs for port %d: %u (max %u)\n",
+			port, cbs, cbs_max);
 		return -EINVAL;
 	}
 
@@ -171,10 +174,9 @@ static int qos_policer_conf_set(struct ocelot_port *port, u32 pol_ix,
 	return 0;
 }
 
-int ocelot_port_policer_add(struct ocelot_port *port,
+int ocelot_port_policer_add(struct ocelot *ocelot, int port,
 			    struct ocelot_policer *pol)
 {
-	struct ocelot *ocelot = port->ocelot;
 	struct qos_policer_conf pp = { 0 };
 	int err;
 
@@ -185,11 +187,10 @@ int ocelot_port_policer_add(struct ocelot_port *port,
 	pp.pir = pol->rate;
 	pp.pbs = pol->burst;
 
-	netdev_dbg(port->dev,
-		   "%s: port %u pir %u kbps, pbs %u bytes\n",
-		   __func__, port->chip_port, pp.pir, pp.pbs);
+	dev_dbg(ocelot->dev, "%s: port %u pir %u kbps, pbs %u bytes\n",
+		__func__, port, pp.pir, pp.pbs);
 
-	err = qos_policer_conf_set(port, POL_IX_PORT + port->chip_port, &pp);
+	err = qos_policer_conf_set(ocelot, port, POL_IX_PORT + port, &pp);
 	if (err)
 		return err;
 
@@ -198,22 +199,21 @@ int ocelot_port_policer_add(struct ocelot_port *port,
 		       ANA_PORT_POL_CFG_POL_ORDER(POL_ORDER),
 		       ANA_PORT_POL_CFG_PORT_POL_ENA |
 		       ANA_PORT_POL_CFG_POL_ORDER_M,
-		       ANA_PORT_POL_CFG, port->chip_port);
+		       ANA_PORT_POL_CFG, port);
 
 	return 0;
 }
 
-int ocelot_port_policer_del(struct ocelot_port *port)
+int ocelot_port_policer_del(struct ocelot *ocelot, int port)
 {
-	struct ocelot *ocelot = port->ocelot;
 	struct qos_policer_conf pp = { 0 };
 	int err;
 
-	netdev_dbg(port->dev, "%s: port %u\n", __func__, port->chip_port);
+	dev_dbg(ocelot->dev, "%s: port %u\n", __func__, port);
 
 	pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
 
-	err = qos_policer_conf_set(port, POL_IX_PORT + port->chip_port, &pp);
+	err = qos_policer_conf_set(ocelot, port, POL_IX_PORT + port, &pp);
 	if (err)
 		return err;
 
@@ -221,7 +221,7 @@ int ocelot_port_policer_del(struct ocelot_port *port)
 		       ANA_PORT_POL_CFG_POL_ORDER(POL_ORDER),
 		       ANA_PORT_POL_CFG_PORT_POL_ENA |
 		       ANA_PORT_POL_CFG_POL_ORDER_M,
-		       ANA_PORT_POL_CFG, port->chip_port);
+		       ANA_PORT_POL_CFG, port);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
index d1137f79efda..ae9509229463 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.h
+++ b/drivers/net/ethernet/mscc/ocelot_police.h
@@ -14,9 +14,9 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
-int ocelot_port_policer_add(struct ocelot_port *port,
+int ocelot_port_policer_add(struct ocelot *ocelot, int port,
 			    struct ocelot_policer *pol);
 
-int ocelot_port_policer_del(struct ocelot_port *port);
+int ocelot_port_policer_del(struct ocelot *ocelot, int port);
 
 #endif /* _MSCC_OCELOT_POLICE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 16a6db71ca5e..9be8e7369d6a 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -58,7 +58,8 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
 					 PSCHED_NS2TICKS(action->police.burst),
 					 PSCHED_TICKS_PER_SEC);
 
-		err = ocelot_port_policer_add(port, &pol);
+		err = ocelot_port_policer_add(port->ocelot, port->chip_port,
+					      &pol);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack, "Could not add policer\n");
 			return err;
@@ -71,7 +72,7 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
 		if (port->tc.police_id != f->cookie)
 			return -ENOENT;
 
-		err = ocelot_port_policer_del(port);
+		err = ocelot_port_policer_del(port->ocelot, port->chip_port);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Could not delete policer\n");
-- 
2.17.1

