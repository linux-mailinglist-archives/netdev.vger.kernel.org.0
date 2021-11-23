Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C63745A3A4
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhKWNYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhKWNYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:24:31 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403CBC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 05:21:23 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y12so92035462eda.12
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 05:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RvlgPjbcKGRnx1/8gpPaxVHsGYdoqmTnTH/NMUe4pwc=;
        b=KGADL2hGU10jGvJPQTc2cy2uzPV61V8MUtH8oFSeYC4olut7/QO69cp7n/71sNacTB
         59JgKAhQxQWII5gWr6GG74Ip01eHIJuH5RpRULoHqgqgvQiIDjQs51Owe8Sbwf1JtxBo
         VXMwrFkCPq3FX/DFmEskC7x6jPS0Hk/4Ewv38EycL4Icl/wir/42kpnNcqxqunYPPlvm
         XldgIEz5q7Tshf1yi+3S9/ch+TrW4M2hK7nuw8NYZF4vrGZ9UsqVLZt6cX1FxSXKvlsk
         f4gOJvEeUxNxz8J+nI8Uvft4ZIouw2HJ7Lq5LIf6r6wjMENJ9rslymJStDjqO4Sp2K9o
         KZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RvlgPjbcKGRnx1/8gpPaxVHsGYdoqmTnTH/NMUe4pwc=;
        b=2XDRDJE2l4xPlOXM5+HYaMw8i5OnrZu+j3FIMBUMup5LkK0ngRd36E6eoWXcqTuNLj
         pP+dwJjnJqHjv8o5Ytoc2Uqff5GgzqvWyJNCkzX3Ji38u/DuTrN/OZKLBU2sn/7LzpiX
         yUw5ZfCE8B1vE9o1xmFCcH/JdHJ5OHrOAl4AOc2lbo2HQL4go2M1xO4/9M4ogCmzW/vJ
         iVSISF5lWXsZIEQtqoi+EQg2HUKfE/cX0sFh3LUfuYM+4FpxKT54PMLetVDSrJnKNlVC
         SjRbsjWqa/gLUK17EG7SiCAOoGEeil6IAhRdLNhCqOS9b0StcNPX86Y6CWoRh7GHDSki
         BCLA==
X-Gm-Message-State: AOAM533irGpYNtp4izZIEcV96eoTR+9A0yBNHs+QtIjRONBQu6V7g0/j
        kw19jPu56MqUXFUelTz5PDsNeuKu+bs=
X-Google-Smtp-Source: ABdhPJwsoFqpJ1/Lq4Mh4wwq2KHKUBeQC2o2cPoqUGBNaY9tis+dWKUV6TFAc+Jwo1stdMtnNYJMuA==
X-Received: by 2002:a17:907:6e1c:: with SMTP id sd28mr7815877ejc.28.1637673681607;
        Tue, 23 Nov 2021 05:21:21 -0800 (PST)
Received: from localhost.localdomain ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id ht7sm5409900ejc.27.2021.11.23.05.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 05:21:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next] net: dsa: felix: enable cut-through forwarding between ports by default
Date:   Tue, 23 Nov 2021 15:21:16 +0200
Message-Id: <20211123132116.913520-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The VSC9959 switch embedded within NXP LS1028A (and that version of
Ocelot switches only) supports cut-through forwarding - meaning it can
start the process of looking up the destination ports for a packet, and
forward towards those ports, before the entire packet has been received
(as opposed to the store-and-forward mode).

The up side is having lower forwarding latency for large packets. The
down side is that frames with FCS errors are forwarded instead of being
dropped. However, erroneous frames do not result in incorrect updates of
the FDB or incorrect policer updates, since these processes are deferred
inside the switch to the end of frame. Since the switch starts the
cut-through forwarding process after all packet headers (including IP,
if any) have been processed, packets with large headers and small
payload do not see the benefit of lower forwarding latency.

There are two cases that need special attention.

The first is when a packet is multicast (or flooded) to multiple
destinations, one of which doesn't have cut-through forwarding enabled.
The switch deals with this automatically by disabling cut-through
forwarding for the frame towards all destination ports.

The second is when a packet is forwarded from a port of lower link speed
towards a port of higher link speed. This is not handled by the hardware
and needs software intervention.

Enabling cut-through forwarding is done per {egress port, traffic class}.
I don't see any reason why this would be a configurable option as long
as it works without issues, and there doesn't appear to be any user
space configuration tool to toggle this on/off, so this patch enables
cut-through forwarding on all eligible ports and traffic classes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
update the cut-through forwarding domain on
ocelot_phylink_mac_link_down() too, since the port that went down could
have been a port which was keeping cut-through disabled on the other
ports in its bridging domain, due to it being the only port with the
lowest speed. So a link down event can lead to cut-through forwarding
being enabled, and the driver should support that.

 drivers/net/dsa/ocelot/felix_vsc9959.c | 61 ++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c     | 13 ++++++
 include/soc/mscc/ocelot.h              |  3 ++
 3 files changed, 77 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 42ac1952b39a..b7941d4dbfc6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2125,6 +2125,66 @@ static void vsc9959_psfp_init(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&psfp->sgi_list);
 }
 
+/* When using cut-through forwarding and the egress port runs at a higher data
+ * rate than the ingress port, the packet currently under transmission would
+ * suffer an underrun since it would be transmitted faster than it is received.
+ * The Felix switch implementation of cut-through forwarding does not check in
+ * hardware whether this condition is satisfied or not, so we must restrict the
+ * list of ports that have cut-through forwarding enabled on egress to only be
+ * the ports operating at the lowest link speed within their respective
+ * forwarding domain.
+ */
+static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+	int port, other_port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		unsigned long mask;
+		int min_speed;
+		u32 val = 0;
+
+		if (ocelot_port->speed <= 0)
+			continue;
+
+		min_speed = ocelot_port->speed;
+		if (port == ocelot->npi) {
+			/* Ocelot switches forward from the NPI port towards
+			 * any port, regardless of it being in the NPI port's
+			 * forwarding domain or not.
+			 */
+			mask = dsa_user_ports(ds);
+		} else {
+			mask = ocelot_read_rix(ocelot, ANA_PGID_PGID,
+					       PGID_SRC + port);
+			/* Ocelot switches forward to the NPI port despite it
+			 * not being in the source ports' forwarding domain.
+			 */
+			if (ocelot->npi >= 0)
+				mask |= BIT(ocelot->npi);
+		}
+
+		for_each_set_bit(other_port, &mask, ocelot->num_phys_ports) {
+			struct ocelot_port *other_ocelot_port;
+
+			other_ocelot_port = ocelot->ports[other_port];
+			if (other_ocelot_port->speed <= 0)
+				continue;
+
+			if (min_speed > other_ocelot_port->speed)
+				min_speed = other_ocelot_port->speed;
+		}
+
+		/* Enable cut-through forwarding for all traffic classes. */
+		if (ocelot_port->speed == min_speed)
+			val = GENMASK(7, 0);
+
+		ocelot_write_rix(ocelot, val, ANA_CUT_THRU_CFG, port);
+	}
+}
+
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
 	.wm_enc			= vsc9959_wm_enc,
@@ -2136,6 +2196,7 @@ static const struct ocelot_ops vsc9959_ops = {
 	.psfp_filter_add	= vsc9959_psfp_filter_add,
 	.psfp_filter_del	= vsc9959_psfp_filter_del,
 	.psfp_stats_get		= vsc9959_psfp_stats_get,
+	.cut_through_fwd	= vsc9959_cut_through_fwd,
 };
 
 static const struct felix_info felix_info_vsc9959 = {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 95920668feb0..30c790f401be 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -682,6 +682,11 @@ void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
 				 DEV_CLOCK_CFG_MAC_TX_RST |
 				 DEV_CLOCK_CFG_MAC_RX_RST,
 				 DEV_CLOCK_CFG);
+
+	ocelot_port->speed = SPEED_UNKNOWN;
+
+	if (ocelot->ops->cut_through_fwd)
+		ocelot->ops->cut_through_fwd(ocelot);
 }
 EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_down);
 
@@ -697,6 +702,8 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	int mac_speed, mode = 0;
 	u32 mac_fc_cfg;
 
+	ocelot_port->speed = speed;
+
 	/* The MAC might be integrated in systems where the MAC speed is fixed
 	 * and it's the PCS who is performing the rate adaptation, so we have
 	 * to write "1000Mbps" into the LINK_SPEED field of DEV_CLOCK_CFG
@@ -772,6 +779,9 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	/* Core: Enable port for frame transfer */
 	ocelot_fields_write(ocelot, port,
 			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
+
+	if (ocelot->ops->cut_through_fwd)
+		ocelot->ops->cut_through_fwd(ocelot);
 }
 EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_up);
 
@@ -1637,6 +1647,9 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 
 		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
 	}
+
+	if (ocelot->ops->cut_through_fwd)
+		ocelot->ops->cut_through_fwd(ocelot);
 }
 EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 89d17629efe5..611847ee5faf 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -561,6 +561,7 @@ struct ocelot_ops {
 	int (*psfp_filter_del)(struct ocelot *ocelot, struct flow_cls_offload *f);
 	int (*psfp_stats_get)(struct ocelot *ocelot, struct flow_cls_offload *f,
 			      struct flow_stats *stats);
+	void (*cut_through_fwd)(struct ocelot *ocelot);
 };
 
 struct ocelot_vcap_policer {
@@ -655,6 +656,8 @@ struct ocelot_port {
 
 	struct net_device		*bridge;
 	u8				stp_state;
+
+	int				speed;
 };
 
 struct ocelot {
-- 
2.25.1

