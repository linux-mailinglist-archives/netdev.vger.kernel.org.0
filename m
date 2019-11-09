Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0CBF5F4C
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfKINDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:33 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39531 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfKINDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:31 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so8887488wmi.4
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dwQ0YgqiiuP4CkwTazS9xEseAZ0LPbeY90Ds6hUtA9Y=;
        b=jxVskWyzvzBkTw7GxHLxrgE2RSm5vf/AypRZOO5GxtBFM+lpR04etRRRCig67ecU1a
         uBc59iFkAYNSAD4y1+qpPznhjyMzUx8I86vJHSt1pvNSa3TZtukFr/vKOlUs40C2sMxo
         jf+jUnR7JKhvbD7smyOkjbcwTZH6dwdWrj6eZUs/Zr9Xan8BJ04QGcMtNF7pJJDAkzVT
         CypuYoKDg+QwqHftIdQNub73PCrOiPdkHgLYXn0/eHyE2R7hVdh9w+IFsyasLP2KIlX9
         ZiAj2altoolra0LsqiIWCZhNLnnTy9AcH8+RkrCxeTzC85Ad/IY7OTT0HUEo0yoRY15Q
         Ajew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dwQ0YgqiiuP4CkwTazS9xEseAZ0LPbeY90Ds6hUtA9Y=;
        b=XFNzOB0bCmM7UE2ULdKFrqu9YBkjdQdRVoEB9hxG//AMVsoG02GSXrldUpq+mBG/6F
         43nGvbgU4oH4Cgvc5o6K9fswGHAEMDVt1Mkv+MGA7hPVmXEtLR63587K8Y5AFiw9KhgW
         0ekIddDs6woFIL7SB9/Hih2soSMN57tHGGhRuf+8a1Eb+5wYz5Zg1vZj+ES8ZwoRTWk/
         z+aJ9mzwvtaQ4rrgfB1RmxyRPhPqs2UO3fysIqmZTHHG3JLem7H/rXKSne7mS6+hfl3Y
         J1Uqws8xrBQFPHfq9Xwu5bnW3U3UfZYvToXeoR1TDVazPErsERsJ5t4n85BszRLQgH/m
         Mzvg==
X-Gm-Message-State: APjAAAU0OcA4hl+29lKi+iAjpaxowNkIEjL7Y12AJR35Q6ioE+CqXPrg
        yie5RSNTTHRvpg7DnQke4Ec=
X-Google-Smtp-Source: APXvYqwVKz6btMpl6sD/gZoaNXplTENrfOr/SpPxihMbYWJTBoCCbYe9PRolTi008ZdypIkmiyRjtQ==
X-Received: by 2002:a1c:790b:: with SMTP id l11mr13364844wme.127.1573304607767;
        Sat, 09 Nov 2019 05:03:27 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:27 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 07/15] net: mscc: ocelot: separate net_device related items out of ocelot_port
Date:   Sat,  9 Nov 2019 15:02:53 +0200
Message-Id: <20191109130301.13716-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot and ocelot_port structures will be used by a new DSA driver,
so the ocelot_board.c file will have to allocate and work with a private
structure (ocelot_port_private), which embeds the generic struct
ocelot_port. This is because in DSA, at least one interface does not
have a net_device, and the DSA driver API does not interact with that
anyway.

The ocelot_port structure is equivalent to dsa_port, and ocelot to
dsa_switch. The members of ocelot_port which have an equivalent in
dsa_port (such as dp->vlan_filtering) have been moved to
ocelot_port_private.

We want to enforce the coding convention that "ocelot_port" refers to
the structure, and "port" refers to the integer index. One can retrieve
the structure at any time from ocelot->ports[port].

The patch is large but only contains variable renaming and mechanical
movement of fields from one structure to another.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c        | 288 ++++++++++++----------
 drivers/net/ethernet/mscc/ocelot.h        |  21 +-
 drivers/net/ethernet/mscc/ocelot_ace.h    |   4 +-
 drivers/net/ethernet/mscc/ocelot_board.c  |  21 +-
 drivers/net/ethernet/mscc/ocelot_flower.c |  32 +--
 drivers/net/ethernet/mscc/ocelot_tc.c     |  57 ++---
 6 files changed, 233 insertions(+), 190 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 492193af2f73..ad808344e33b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -229,8 +229,6 @@ static void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 	ocelot_rmw_gix(ocelot, val,
 		       REW_TAG_CFG_TAG_CFG_M,
 		       REW_TAG_CFG, port);
-
-	ocelot_port->vlan_aware = vlan_aware;
 }
 
 static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
@@ -297,9 +295,10 @@ static int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 			       bool untagged)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = ocelot_port->chip_port;
+	int port = priv->chip_port;
 	int ret;
 
 	ret = ocelot_vlan_add(ocelot, port, vid, pvid, untagged);
@@ -337,9 +336,9 @@ static int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 
 static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = ocelot_port->chip_port;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 	int ret;
 
 	/* 8021q removes VID 0 on module unload for all interfaces
@@ -412,10 +411,11 @@ static u16 ocelot_wm_enc(u16 value)
 
 static void ocelot_port_adjust_link(struct net_device *dev)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
-	u8 p = port->chip_port;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	int speed, atop_wm, mode = 0;
+	u8 port = priv->chip_port;
 
 	switch (dev->phydev->speed) {
 	case SPEED_10:
@@ -444,62 +444,66 @@ static void ocelot_port_adjust_link(struct net_device *dev)
 		return;
 
 	/* Only full duplex supported for now */
-	ocelot_port_writel(port, DEV_MAC_MODE_CFG_FDX_ENA |
+	ocelot_port_writel(ocelot_port, DEV_MAC_MODE_CFG_FDX_ENA |
 			   mode, DEV_MAC_MODE_CFG);
 
 	/* Set MAC IFG Gaps
 	 * FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 0
 	 * !FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 5
 	 */
-	ocelot_port_writel(port, DEV_MAC_IFG_CFG_TX_IFG(5), DEV_MAC_IFG_CFG);
+	ocelot_port_writel(ocelot_port, DEV_MAC_IFG_CFG_TX_IFG(5),
+			   DEV_MAC_IFG_CFG);
 
 	/* Load seed (0) and set MAC HDX late collision  */
-	ocelot_port_writel(port, DEV_MAC_HDX_CFG_LATE_COL_POS(67) |
+	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67) |
 			   DEV_MAC_HDX_CFG_SEED_LOAD,
 			   DEV_MAC_HDX_CFG);
 	mdelay(1);
-	ocelot_port_writel(port, DEV_MAC_HDX_CFG_LATE_COL_POS(67),
+	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67),
 			   DEV_MAC_HDX_CFG);
 
 	/* Disable HDX fast control */
-	ocelot_port_writel(port, DEV_PORT_MISC_HDX_FAST_DIS, DEV_PORT_MISC);
+	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
+			   DEV_PORT_MISC);
 
 	/* SGMII only for now */
-	ocelot_port_writel(port, PCS1G_MODE_CFG_SGMII_MODE_ENA, PCS1G_MODE_CFG);
-	ocelot_port_writel(port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
+	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
+			   PCS1G_MODE_CFG);
+	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
 
 	/* Enable PCS */
-	ocelot_port_writel(port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
+	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
 
 	/* No aneg on SGMII */
-	ocelot_port_writel(port, 0, PCS1G_ANEG_CFG);
+	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
 
 	/* No loopback */
-	ocelot_port_writel(port, 0, PCS1G_LB_CFG);
+	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
 
 	/* Set Max Length and maximum tags allowed */
-	ocelot_port_writel(port, VLAN_ETH_FRAME_LEN, DEV_MAC_MAXLEN_CFG);
-	ocelot_port_writel(port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
+	ocelot_port_writel(ocelot_port, VLAN_ETH_FRAME_LEN,
+			   DEV_MAC_MAXLEN_CFG);
+	ocelot_port_writel(ocelot_port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
 			   DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
 			   DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA,
 			   DEV_MAC_TAGS_CFG);
 
 	/* Enable MAC module */
-	ocelot_port_writel(port, DEV_MAC_ENA_CFG_RX_ENA |
+	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
 			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
 
 	/* Take MAC, Port, Phy (intern) and PCS (SGMII/Serdes) clock out of
 	 * reset */
-	ocelot_port_writel(port, DEV_CLOCK_CFG_LINK_SPEED(speed),
+	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
 			   DEV_CLOCK_CFG);
 
 	/* Set SMAC of Pause frame (00:00:00:00:00:00) */
-	ocelot_port_writel(port, 0, DEV_MAC_FC_MAC_HIGH_CFG);
-	ocelot_port_writel(port, 0, DEV_MAC_FC_MAC_LOW_CFG);
+	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_HIGH_CFG);
+	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
 
 	/* No PFC */
 	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
-			 ANA_PFC_PFC_CFG, p);
+			 ANA_PFC_PFC_CFG, port);
 
 	/* Set Pause WM hysteresis
 	 * 152 = 6 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
@@ -507,13 +511,13 @@ static void ocelot_port_adjust_link(struct net_device *dev)
 	 */
 	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
 			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
-			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, p);
+			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
 
 	/* Core: Enable port for frame transfer */
 	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
 			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
 			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
-			 QSYS_SWITCH_PORT_MODE, p);
+			 QSYS_SWITCH_PORT_MODE, port);
 
 	/* Flow control */
 	ocelot_write_rix(ocelot, SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
@@ -521,20 +525,21 @@ static void ocelot_port_adjust_link(struct net_device *dev)
 			 SYS_MAC_FC_CFG_ZERO_PAUSE_ENA |
 			 SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
 			 SYS_MAC_FC_CFG_FC_LINK_SPEED(speed),
-			 SYS_MAC_FC_CFG, p);
-	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, p);
+			 SYS_MAC_FC_CFG, port);
+	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
 
 	/* Tail dropping watermark */
 	atop_wm = (ocelot->shared_queue_sz - 9 * VLAN_ETH_FRAME_LEN) / OCELOT_BUFFER_CELL_SZ;
 	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * VLAN_ETH_FRAME_LEN),
-			 SYS_ATOP, p);
+			 SYS_ATOP, port);
 	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
 
 static int ocelot_port_open(struct net_device *dev)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 	int err;
 
 	/* Enable receiving frames on the port, and activate auto-learning of
@@ -542,43 +547,44 @@ static int ocelot_port_open(struct net_device *dev)
 	 */
 	ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_LEARNAUTO |
 			 ANA_PORT_PORT_CFG_RECV_ENA |
-			 ANA_PORT_PORT_CFG_PORTID_VAL(port->chip_port),
-			 ANA_PORT_PORT_CFG, port->chip_port);
+			 ANA_PORT_PORT_CFG_PORTID_VAL(port),
+			 ANA_PORT_PORT_CFG, port);
 
-	if (port->serdes) {
-		err = phy_set_mode_ext(port->serdes, PHY_MODE_ETHERNET,
-				       port->phy_mode);
+	if (priv->serdes) {
+		err = phy_set_mode_ext(priv->serdes, PHY_MODE_ETHERNET,
+				       priv->phy_mode);
 		if (err) {
 			netdev_err(dev, "Could not set mode of SerDes\n");
 			return err;
 		}
 	}
 
-	err = phy_connect_direct(dev, port->phy, &ocelot_port_adjust_link,
-				 port->phy_mode);
+	err = phy_connect_direct(dev, priv->phy, &ocelot_port_adjust_link,
+				 priv->phy_mode);
 	if (err) {
 		netdev_err(dev, "Could not attach to PHY\n");
 		return err;
 	}
 
-	dev->phydev = port->phy;
+	dev->phydev = priv->phy;
 
-	phy_attached_info(port->phy);
-	phy_start(port->phy);
+	phy_attached_info(priv->phy);
+	phy_start(priv->phy);
 	return 0;
 }
 
 static int ocelot_port_stop(struct net_device *dev)
 {
-	struct ocelot_port *port = netdev_priv(dev);
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *port = &priv->port;
 
-	phy_disconnect(port->phy);
+	phy_disconnect(priv->phy);
 
 	dev->phydev = NULL;
 
 	ocelot_port_writel(port, 0, DEV_MAC_ENA_CFG);
 	ocelot_rmw_rix(port->ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
-			 QSYS_SWITCH_PORT_MODE, port->chip_port);
+		       QSYS_SWITCH_PORT_MODE, priv->chip_port);
 	return 0;
 }
 
@@ -604,13 +610,15 @@ static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
 
 static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
-	u32 val, ifh[IFH_LEN];
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	struct frame_info info = {};
 	u8 grp = 0; /* Send everything on CPU group 0 */
 	unsigned int i, count, last;
+	int port = priv->chip_port;
+	u32 val, ifh[IFH_LEN];
 
 	val = ocelot_read(ocelot, QS_INJ_STATUS);
 	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
@@ -620,15 +628,15 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
 			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
 
-	info.port = BIT(port->chip_port);
+	info.port = BIT(port);
 	info.tag_type = IFH_TAG_TYPE_C;
 	info.vid = skb_vlan_tag_get(skb);
 
 	/* Check if timestamping is needed */
 	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
-		info.rew_op = port->ptp_cmd;
-		if (port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
-			info.rew_op |= (port->ts_id  % 4) << 3;
+		info.rew_op = ocelot_port->ptp_cmd;
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+			info.rew_op |= (ocelot_port->ts_id  % 4) << 3;
 	}
 
 	ocelot_gen_ifh(ifh, &info);
@@ -663,7 +671,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev->stats.tx_bytes += skb->len;
 
 	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
-	    port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
 		struct ocelot_skb *oskb =
 			kzalloc(sizeof(struct ocelot_skb), GFP_ATOMIC);
 
@@ -673,10 +681,10 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
 		oskb->skb = skb;
-		oskb->id = port->ts_id % 4;
-		port->ts_id++;
+		oskb->id = ocelot_port->ts_id % 4;
+		ocelot_port->ts_id++;
 
-		list_add_tail(&oskb->head, &port->skbs);
+		list_add_tail(&oskb->head, &ocelot_port->skbs);
 
 		return NETDEV_TX_OK;
 	}
@@ -715,25 +723,29 @@ EXPORT_SYMBOL(ocelot_get_hwtimestamp);
 
 static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 {
-	struct ocelot_port *port = netdev_priv(dev);
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 
-	return ocelot_mact_forget(port->ocelot, addr, port->pvid);
+	return ocelot_mact_forget(ocelot, addr, ocelot_port->pvid);
 }
 
 static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
 {
-	struct ocelot_port *port = netdev_priv(dev);
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 
-	return ocelot_mact_learn(port->ocelot, PGID_CPU, addr, port->pvid,
+	return ocelot_mact_learn(ocelot, PGID_CPU, addr, ocelot_port->pvid,
 				 ENTRYTYPE_LOCKED);
 }
 
 static void ocelot_set_rx_mode(struct net_device *dev)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
-	int i;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
 	u32 val;
+	int i;
 
 	/* This doesn't handle promiscuous mode because the bridge core is
 	 * setting IFF_PROMISC on all slave interfaces and all frames would be
@@ -749,10 +761,11 @@ static void ocelot_set_rx_mode(struct net_device *dev)
 static int ocelot_port_get_phys_port_name(struct net_device *dev,
 					  char *buf, size_t len)
 {
-	struct ocelot_port *port = netdev_priv(dev);
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	int port = priv->chip_port;
 	int ret;
 
-	ret = snprintf(buf, len, "p%d", port->chip_port);
+	ret = snprintf(buf, len, "p%d", port);
 	if (ret >= len)
 		return -EINVAL;
 
@@ -761,15 +774,16 @@ static int ocelot_port_get_phys_port_name(struct net_device *dev,
 
 static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	const struct sockaddr *addr = p;
 
 	/* Learn the new net device MAC address in the mac table. */
-	ocelot_mact_learn(ocelot, PGID_CPU, addr->sa_data, port->pvid,
+	ocelot_mact_learn(ocelot, PGID_CPU, addr->sa_data, ocelot_port->pvid,
 			  ENTRYTYPE_LOCKED);
 	/* Then forget the previous one. */
-	ocelot_mact_forget(ocelot, dev->dev_addr, port->pvid);
+	ocelot_mact_forget(ocelot, dev->dev_addr, ocelot_port->pvid);
 
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
 	return 0;
@@ -778,11 +792,12 @@ static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
 static void ocelot_get_stats64(struct net_device *dev,
 			       struct rtnl_link_stats64 *stats)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 
 	/* Configure the port to read the stats from */
-	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port->chip_port),
+	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port),
 		     SYS_STAT_CFG);
 
 	/* Get Rx stats */
@@ -814,12 +829,13 @@ static void ocelot_get_stats64(struct net_device *dev,
 }
 
 static int ocelot_fdb_add(struct ocelot *ocelot, int port,
-			  const unsigned char *addr, u16 vid)
+			  const unsigned char *addr, u16 vid,
+			  bool vlan_aware)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	if (!vid) {
-		if (!ocelot_port->vlan_aware)
+		if (!vlan_aware)
 			/* If the bridge is not VLAN aware and no VID was
 			 * provided, set it to pvid to ensure the MAC entry
 			 * matches incoming untagged packets
@@ -841,10 +857,11 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			       u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 
-	return ocelot_fdb_add(ocelot, ocelot_port->chip_port, addr, vid);
+	return ocelot_fdb_add(ocelot, port, addr, vid, priv->vlan_aware);
 }
 
 static int ocelot_fdb_del(struct ocelot *ocelot, int port,
@@ -857,10 +874,11 @@ static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			       struct net_device *dev,
 			       const unsigned char *addr, u16 vid)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 
-	return ocelot_fdb_del(ocelot, ocelot_port->chip_port, addr, vid);
+	return ocelot_fdb_del(ocelot, port, addr, vid);
 }
 
 struct ocelot_dump_ctx {
@@ -999,18 +1017,18 @@ static int ocelot_port_fdb_dump(struct sk_buff *skb,
 				struct net_device *dev,
 				struct net_device *filter_dev, int *idx)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
 	struct ocelot_dump_ctx dump = {
 		.dev = dev,
 		.skb = skb,
 		.cb = cb,
 		.idx = *idx,
 	};
+	int port = priv->chip_port;
 	int ret;
 
-	ret = ocelot_fdb_dump(ocelot, ocelot_port->chip_port,
-			      ocelot_port_fdb_do_dump, &dump);
+	ret = ocelot_fdb_dump(ocelot, port, ocelot_port_fdb_do_dump, &dump);
 
 	*idx = dump.idx;
 
@@ -1033,12 +1051,12 @@ static int ocelot_set_features(struct net_device *dev,
 			       netdev_features_t features)
 {
 	netdev_features_t changed = dev->features ^ features;
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = ocelot_port->chip_port;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 
 	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
-	    ocelot_port->tc.offload_cnt) {
+	    priv->tc.offload_cnt) {
 		netdev_err(dev,
 			   "Cannot disable HW TC offload while offloads active\n");
 		return -EBUSY;
@@ -1053,8 +1071,8 @@ static int ocelot_set_features(struct net_device *dev,
 static int ocelot_get_port_parent_id(struct net_device *dev,
 				     struct netdev_phys_item_id *ppid)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
 
 	ppid->id_len = sizeof(ocelot->base_mac);
 	memcpy(&ppid->id, &ocelot->base_mac, ppid->id_len);
@@ -1136,9 +1154,9 @@ static int ocelot_hwstamp_set(struct ocelot *ocelot, int port,
 
 static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = ocelot_port->chip_port;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 
 	/* The function is only used for PTP operations for now */
 	if (!ocelot->ptp)
@@ -1175,8 +1193,8 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 
 static void ocelot_get_strings(struct net_device *netdev, u32 sset, u8 *data)
 {
-	struct ocelot_port *port = netdev_priv(netdev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(netdev);
+	struct ocelot *ocelot = priv->port.ocelot;
 	int i;
 
 	if (sset != ETH_SS_STATS)
@@ -1230,8 +1248,9 @@ static void ocelot_check_stats_work(struct work_struct *work)
 static void ocelot_get_ethtool_stats(struct net_device *dev,
 				     struct ethtool_stats *stats, u64 *data)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 	int i;
 
 	/* check and update now */
@@ -1239,13 +1258,13 @@ static void ocelot_get_ethtool_stats(struct net_device *dev,
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
-		*data++ = ocelot->stats[port->chip_port * ocelot->num_stats + i];
+		*data++ = ocelot->stats[port * ocelot->num_stats + i];
 }
 
 static int ocelot_get_sset_count(struct net_device *dev, int sset)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
 
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
@@ -1255,8 +1274,8 @@ static int ocelot_get_sset_count(struct net_device *dev, int sset)
 static int ocelot_get_ts_info(struct net_device *dev,
 			      struct ethtool_ts_info *info)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
 
 	if (!ocelot->ptp)
 		return ethtool_op_get_ts_info(dev, info);
@@ -1388,9 +1407,9 @@ static int ocelot_port_attr_set(struct net_device *dev,
 				const struct switchdev_attr *attr,
 				struct switchdev_trans *trans)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = ocelot_port->chip_port;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
 	int err = 0;
 
 	switch (attr->id) {
@@ -1402,8 +1421,8 @@ static int ocelot_port_attr_set(struct net_device *dev,
 		ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		ocelot_port_vlan_filtering(ocelot, port,
-					   attr->u.vlan_filtering);
+		priv->vlan_aware = attr->u.vlan_filtering;
+		ocelot_port_vlan_filtering(ocelot, port, priv->vlan_aware);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
@@ -1468,15 +1487,17 @@ static int ocelot_port_obj_add_mdb(struct net_device *dev,
 				   const struct switchdev_obj_port_mdb *mdb,
 				   struct switchdev_trans *trans)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
-	struct ocelot_multicast *mc;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	unsigned char addr[ETH_ALEN];
+	struct ocelot_multicast *mc;
+	int port = priv->chip_port;
 	u16 vid = mdb->vid;
 	bool new = false;
 
 	if (!vid)
-		vid = port->pvid;
+		vid = ocelot_port->pvid;
 
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc) {
@@ -1500,7 +1521,7 @@ static int ocelot_port_obj_add_mdb(struct net_device *dev,
 		ocelot_mact_forget(ocelot, addr, vid);
 	}
 
-	mc->ports |= BIT(port->chip_port);
+	mc->ports |= BIT(port);
 	addr[2] = mc->ports << 0;
 	addr[1] = mc->ports << 8;
 
@@ -1510,14 +1531,16 @@ static int ocelot_port_obj_add_mdb(struct net_device *dev,
 static int ocelot_port_obj_del_mdb(struct net_device *dev,
 				   const struct switchdev_obj_port_mdb *mdb)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
-	struct ocelot_multicast *mc;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	unsigned char addr[ETH_ALEN];
+	struct ocelot_multicast *mc;
+	int port = priv->chip_port;
 	u16 vid = mdb->vid;
 
 	if (!vid)
-		vid = port->pvid;
+		vid = ocelot_port->pvid;
 
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc)
@@ -1529,7 +1552,7 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
 	addr[0] = 0;
 	ocelot_mact_forget(ocelot, addr, vid);
 
-	mc->ports &= ~BIT(port->chip_port);
+	mc->ports &= ~BIT(port);
 	if (!mc->ports) {
 		list_del(&mc->list);
 		devm_kfree(ocelot->dev, mc);
@@ -1683,9 +1706,9 @@ static int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 
 	rcu_read_lock();
 	for_each_netdev_in_bond_rcu(bond, ndev) {
-		struct ocelot_port *port = netdev_priv(ndev);
+		struct ocelot_port_private *priv = netdev_priv(ndev);
 
-		bond_mask |= BIT(port->chip_port);
+		bond_mask |= BIT(priv->chip_port);
 	}
 	rcu_read_unlock();
 
@@ -1753,20 +1776,23 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
 				       unsigned long event,
 				       struct netdev_notifier_changeupper_info *info)
 {
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = ocelot_port->chip_port;
+	int port = priv->chip_port;
 	int err = 0;
 
 	switch (event) {
 	case NETDEV_CHANGEUPPER:
 		if (netif_is_bridge_master(info->upper_dev)) {
-			if (info->linking)
+			if (info->linking) {
 				err = ocelot_port_bridge_join(ocelot, port,
 							      info->upper_dev);
-			else
+			} else {
 				err = ocelot_port_bridge_leave(ocelot, port,
 							       info->upper_dev);
+				priv->vlan_aware = false;
+			}
 		}
 		if (netif_is_lag_master(info->upper_dev)) {
 			if (info->linking)
@@ -2080,21 +2106,23 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
 		      struct phy_device *phy)
 {
+	struct ocelot_port_private *priv;
 	struct ocelot_port *ocelot_port;
 	struct net_device *dev;
 	u32 val;
 	int err;
 
-	dev = alloc_etherdev(sizeof(struct ocelot_port));
+	dev = alloc_etherdev(sizeof(struct ocelot_port_private));
 	if (!dev)
 		return -ENOMEM;
 	SET_NETDEV_DEV(dev, ocelot->dev);
-	ocelot_port = netdev_priv(dev);
-	ocelot_port->dev = dev;
+	priv = netdev_priv(dev);
+	priv->dev = dev;
+	priv->phy = phy;
+	priv->chip_port = port;
+	ocelot_port = &priv->port;
 	ocelot_port->ocelot = ocelot;
 	ocelot_port->regs = regs;
-	ocelot_port->chip_port = port;
-	ocelot_port->phy = phy;
 	ocelot->ports[port] = ocelot_port;
 
 	dev->netdev_ops = &ocelot_port_netdev_ops;
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 06ac806052bc..7f3526151fa9 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -479,11 +479,9 @@ struct ocelot {
 };
 
 struct ocelot_port {
-	struct net_device *dev;
 	struct ocelot *ocelot;
-	struct phy_device *phy;
+
 	void __iomem *regs;
-	u8 chip_port;
 
 	/* Ingress default VLAN (pvid) */
 	u16 pvid;
@@ -491,18 +489,23 @@ struct ocelot_port {
 	/* Egress default VLAN (vid) */
 	u16 vid;
 
-	u8 vlan_aware;
+	u8 ptp_cmd;
+	struct list_head skbs;
+	u8 ts_id;
+};
 
-	u64 *stats;
+struct ocelot_port_private {
+	struct ocelot_port port;
+	struct net_device *dev;
+	struct phy_device *phy;
+	u8 chip_port;
+
+	u8 vlan_aware;
 
 	phy_interface_t phy_mode;
 	struct phy *serdes;
 
 	struct ocelot_port_tc tc;
-
-	u8 ptp_cmd;
-	struct list_head skbs;
-	u8 ts_id;
 };
 
 struct ocelot_skb {
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index e98944c87259..c08e3e8482e7 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -224,9 +224,9 @@ int ocelot_ace_rule_stats_update(struct ocelot_ace_rule *rule);
 int ocelot_ace_init(struct ocelot *ocelot);
 void ocelot_ace_deinit(void);
 
-int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
+int ocelot_setup_tc_block_flower_bind(struct ocelot_port_private *priv,
 				      struct flow_block_offload *f);
-void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
+void ocelot_setup_tc_block_flower_unbind(struct ocelot_port_private *priv,
 					 struct flow_block_offload *f);
 
 #endif /* _MSCC_OCELOT_ACE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 723724bdc139..4793d275d845 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -95,6 +95,8 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 
 	do {
 		struct skb_shared_hwtstamps *shhwtstamps;
+		struct ocelot_port_private *priv;
+		struct ocelot_port *ocelot_port;
 		u64 tod_in_ns, full_ts_in_ns;
 		struct frame_info info = {};
 		struct net_device *dev;
@@ -114,7 +116,10 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 
 		ocelot_parse_ifh(ifh, &info);
 
-		dev = ocelot->ports[info.port]->dev;
+		ocelot_port = ocelot->ports[info.port];
+		priv = container_of(ocelot_port, struct ocelot_port_private,
+				    port);
+		dev = priv->dev;
 
 		skb = netdev_alloc_skb(dev, info.len);
 
@@ -363,6 +368,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot_init(ocelot);
 
 	for_each_available_child_of_node(ports, portnp) {
+		struct ocelot_port_private *priv;
+		struct ocelot_port *ocelot_port;
 		struct device_node *phy_node;
 		phy_interface_t phy_mode;
 		struct phy_device *phy;
@@ -398,13 +405,17 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 			goto out_put_ports;
 		}
 
+		ocelot_port = ocelot->ports[port];
+		priv = container_of(ocelot_port, struct ocelot_port_private,
+				    port);
+
 		err = of_get_phy_mode(portnp, &phy_mode);
 		if (err && err != -ENODEV)
 			goto out_put_ports;
 
-		ocelot->ports[port]->phy_mode = phy_mode;
+		priv->phy_mode = phy_mode;
 
-		switch (ocelot->ports[port]->phy_mode) {
+		switch (priv->phy_mode) {
 		case PHY_INTERFACE_MODE_NA:
 			continue;
 		case PHY_INTERFACE_MODE_SGMII:
@@ -413,7 +424,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 			/* Ensure clock signals and speed is set on all
 			 * QSGMII links
 			 */
-			ocelot_port_writel(ocelot->ports[port],
+			ocelot_port_writel(ocelot_port,
 					   DEV_CLOCK_CFG_LINK_SPEED
 					   (OCELOT_SPEED_1000),
 					   DEV_CLOCK_CFG);
@@ -441,7 +452,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 			goto out_put_ports;
 		}
 
-		ocelot->ports[port]->serdes = serdes;
+		priv->serdes = serdes;
 	}
 
 	register_netdevice_notifier(&ocelot_netdevice_nb);
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index b894bc0c9c16..3d65b99b9734 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -10,7 +10,7 @@
 
 struct ocelot_port_block {
 	struct ocelot_acl_block *block;
-	struct ocelot_port *port;
+	struct ocelot_port_private *priv;
 };
 
 static int ocelot_flower_parse_action(struct flow_cls_offload *f,
@@ -177,8 +177,8 @@ struct ocelot_ace_rule *ocelot_ace_rule_create(struct flow_cls_offload *f,
 	if (!rule)
 		return NULL;
 
-	rule->port = block->port;
-	rule->chip_port = block->port->chip_port;
+	rule->port = &block->priv->port;
+	rule->chip_port = block->priv->chip_port;
 	return rule;
 }
 
@@ -202,7 +202,7 @@ static int ocelot_flower_replace(struct flow_cls_offload *f,
 	if (ret)
 		return ret;
 
-	port_block->port->tc.offload_cnt++;
+	port_block->priv->tc.offload_cnt++;
 	return 0;
 }
 
@@ -213,14 +213,14 @@ static int ocelot_flower_destroy(struct flow_cls_offload *f,
 	int ret;
 
 	rule.prio = f->common.prio;
-	rule.port = port_block->port;
+	rule.port = &port_block->priv->port;
 	rule.id = f->cookie;
 
 	ret = ocelot_ace_rule_offload_del(&rule);
 	if (ret)
 		return ret;
 
-	port_block->port->tc.offload_cnt--;
+	port_block->priv->tc.offload_cnt--;
 	return 0;
 }
 
@@ -231,7 +231,7 @@ static int ocelot_flower_stats_update(struct flow_cls_offload *f,
 	int ret;
 
 	rule.prio = f->common.prio;
-	rule.port = port_block->port;
+	rule.port = &port_block->priv->port;
 	rule.id = f->cookie;
 	ret = ocelot_ace_rule_stats_update(&rule);
 	if (ret)
@@ -261,7 +261,7 @@ static int ocelot_setup_tc_block_cb_flower(enum tc_setup_type type,
 {
 	struct ocelot_port_block *port_block = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(port_block->port->dev, type_data))
+	if (!tc_cls_can_offload_and_chain0(port_block->priv->dev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
@@ -275,7 +275,7 @@ static int ocelot_setup_tc_block_cb_flower(enum tc_setup_type type,
 }
 
 static struct ocelot_port_block*
-ocelot_port_block_create(struct ocelot_port *port)
+ocelot_port_block_create(struct ocelot_port_private *priv)
 {
 	struct ocelot_port_block *port_block;
 
@@ -283,7 +283,7 @@ ocelot_port_block_create(struct ocelot_port *port)
 	if (!port_block)
 		return NULL;
 
-	port_block->port = port;
+	port_block->priv = priv;
 
 	return port_block;
 }
@@ -300,7 +300,7 @@ static void ocelot_tc_block_unbind(void *cb_priv)
 	ocelot_port_block_destroy(port_block);
 }
 
-int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
+int ocelot_setup_tc_block_flower_bind(struct ocelot_port_private *priv,
 				      struct flow_block_offload *f)
 {
 	struct ocelot_port_block *port_block;
@@ -311,14 +311,14 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 		return -EOPNOTSUPP;
 
 	block_cb = flow_block_cb_lookup(f->block,
-					ocelot_setup_tc_block_cb_flower, port);
+					ocelot_setup_tc_block_cb_flower, priv);
 	if (!block_cb) {
-		port_block = ocelot_port_block_create(port);
+		port_block = ocelot_port_block_create(priv);
 		if (!port_block)
 			return -ENOMEM;
 
 		block_cb = flow_block_cb_alloc(ocelot_setup_tc_block_cb_flower,
-					       port, port_block,
+					       priv, port_block,
 					       ocelot_tc_block_unbind);
 		if (IS_ERR(block_cb)) {
 			ret = PTR_ERR(block_cb);
@@ -339,13 +339,13 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 	return ret;
 }
 
-void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
+void ocelot_setup_tc_block_flower_unbind(struct ocelot_port_private *priv,
 					 struct flow_block_offload *f)
 {
 	struct flow_block_cb *block_cb;
 
 	block_cb = flow_block_cb_lookup(f->block,
-					ocelot_setup_tc_block_cb_flower, port);
+					ocelot_setup_tc_block_cb_flower, priv);
 	if (!block_cb)
 		return;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 9be8e7369d6a..a4f7fbd76507 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -9,17 +9,19 @@
 #include "ocelot_ace.h"
 #include <net/pkt_cls.h>
 
-static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
+static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 					struct tc_cls_matchall_offload *f,
 					bool ingress)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
+	struct ocelot *ocelot = priv->port.ocelot;
 	struct ocelot_policer pol = { 0 };
 	struct flow_action_entry *action;
+	int port = priv->chip_port;
 	int err;
 
-	netdev_dbg(port->dev, "%s: port %u command %d cookie %lu\n",
-		   __func__, port->chip_port, f->command, f->cookie);
+	netdev_dbg(priv->dev, "%s: port %u command %d cookie %lu\n",
+		   __func__, port, f->command, f->cookie);
 
 	if (!ingress) {
 		NL_SET_ERR_MSG_MOD(extack, "Only ingress is supported");
@@ -34,7 +36,7 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
 			return -EOPNOTSUPP;
 		}
 
-		if (port->tc.block_shared) {
+		if (priv->tc.block_shared) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Rate limit is not supported on shared blocks");
 			return -EOPNOTSUPP;
@@ -47,7 +49,7 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
 			return -EOPNOTSUPP;
 		}
 
-		if (port->tc.police_id && port->tc.police_id != f->cookie) {
+		if (priv->tc.police_id && priv->tc.police_id != f->cookie) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Only one policer per port is supported\n");
 			return -EEXIST;
@@ -58,28 +60,27 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
 					 PSCHED_NS2TICKS(action->police.burst),
 					 PSCHED_TICKS_PER_SEC);
 
-		err = ocelot_port_policer_add(port->ocelot, port->chip_port,
-					      &pol);
+		err = ocelot_port_policer_add(ocelot, port, &pol);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack, "Could not add policer\n");
 			return err;
 		}
 
-		port->tc.police_id = f->cookie;
-		port->tc.offload_cnt++;
+		priv->tc.police_id = f->cookie;
+		priv->tc.offload_cnt++;
 		return 0;
 	case TC_CLSMATCHALL_DESTROY:
-		if (port->tc.police_id != f->cookie)
+		if (priv->tc.police_id != f->cookie)
 			return -ENOENT;
 
-		err = ocelot_port_policer_del(port->ocelot, port->chip_port);
+		err = ocelot_port_policer_del(ocelot, port);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Could not delete policer\n");
 			return err;
 		}
-		port->tc.police_id = 0;
-		port->tc.offload_cnt--;
+		priv->tc.police_id = 0;
+		priv->tc.offload_cnt--;
 		return 0;
 	case TC_CLSMATCHALL_STATS: /* fall through */
 	default:
@@ -91,21 +92,21 @@ static int ocelot_setup_tc_block_cb(enum tc_setup_type type,
 				    void *type_data,
 				    void *cb_priv, bool ingress)
 {
-	struct ocelot_port *port = cb_priv;
+	struct ocelot_port_private *priv = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(port->dev, type_data))
+	if (!tc_cls_can_offload_and_chain0(priv->dev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
 	case TC_SETUP_CLSMATCHALL:
-		netdev_dbg(port->dev, "tc_block_cb: TC_SETUP_CLSMATCHALL %s\n",
+		netdev_dbg(priv->dev, "tc_block_cb: TC_SETUP_CLSMATCHALL %s\n",
 			   ingress ? "ingress" : "egress");
 
-		return ocelot_setup_tc_cls_matchall(port, type_data, ingress);
+		return ocelot_setup_tc_cls_matchall(priv, type_data, ingress);
 	case TC_SETUP_CLSFLOWER:
 		return 0;
 	default:
-		netdev_dbg(port->dev, "tc_block_cb: type %d %s\n",
+		netdev_dbg(priv->dev, "tc_block_cb: type %d %s\n",
 			   type,
 			   ingress ? "ingress" : "egress");
 
@@ -131,19 +132,19 @@ static int ocelot_setup_tc_block_cb_eg(enum tc_setup_type type,
 
 static LIST_HEAD(ocelot_block_cb_list);
 
-static int ocelot_setup_tc_block(struct ocelot_port *port,
+static int ocelot_setup_tc_block(struct ocelot_port_private *priv,
 				 struct flow_block_offload *f)
 {
 	struct flow_block_cb *block_cb;
 	flow_setup_cb_t *cb;
 	int err;
 
-	netdev_dbg(port->dev, "tc_block command %d, binder_type %d\n",
+	netdev_dbg(priv->dev, "tc_block command %d, binder_type %d\n",
 		   f->command, f->binder_type);
 
 	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
 		cb = ocelot_setup_tc_block_cb_ig;
-		port->tc.block_shared = f->block_shared;
+		priv->tc.block_shared = f->block_shared;
 	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
 		cb = ocelot_setup_tc_block_cb_eg;
 	} else {
@@ -154,14 +155,14 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		if (flow_block_cb_is_busy(cb, port, &ocelot_block_cb_list))
+		if (flow_block_cb_is_busy(cb, priv, &ocelot_block_cb_list))
 			return -EBUSY;
 
-		block_cb = flow_block_cb_alloc(cb, port, port, NULL);
+		block_cb = flow_block_cb_alloc(cb, priv, priv, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
-		err = ocelot_setup_tc_block_flower_bind(port, f);
+		err = ocelot_setup_tc_block_flower_bind(priv, f);
 		if (err < 0) {
 			flow_block_cb_free(block_cb);
 			return err;
@@ -170,11 +171,11 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 		list_add_tail(&block_cb->driver_list, f->driver_block_list);
 		return 0;
 	case FLOW_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f->block, cb, port);
+		block_cb = flow_block_cb_lookup(f->block, cb, priv);
 		if (!block_cb)
 			return -ENOENT;
 
-		ocelot_setup_tc_block_flower_unbind(port, f);
+		ocelot_setup_tc_block_flower_unbind(priv, f);
 		flow_block_cb_remove(block_cb, f);
 		list_del(&block_cb->driver_list);
 		return 0;
@@ -186,11 +187,11 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 int ocelot_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		    void *type_data)
 {
-	struct ocelot_port *port = netdev_priv(dev);
+	struct ocelot_port_private *priv = netdev_priv(dev);
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return ocelot_setup_tc_block(port, type_data);
+		return ocelot_setup_tc_block(priv, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.1

