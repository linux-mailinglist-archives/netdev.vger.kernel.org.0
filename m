Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BFAFC975
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKNPET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40181 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfKNPES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:18 -0500
Received: by mail-wr1-f68.google.com with SMTP id i10so6846247wrs.7
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XOfVJxcuUuw2NudxNMfi/4+4mLmNM1VdK9Htk8RiFag=;
        b=OcvEE5IQfOl7FCPs8mFjHs/ck1V24ZBpSs3cIfWOwA89pBEasQi0C/byLAnv41FcTV
         dyM2zqoYvXkyKBhI6g4AFNDUE+hiqeBzRmTF8RHYHHuCQpnIEr+HQ60F5Sgr7YexEiu6
         y3RM+lDXXNQBLV+C6V3nfcoJxDVjgEl1pkGoGhvJTR2FDvGkr+K49V/TimkBv3j2cg2/
         YGAbUbXLPWaoigPYNBx51bxexKVLw8i3zR8QadLbvM8m/i5MdPwofdoGjkBKahRJAy64
         WKHGasver+7i1wSYPxPDwyMkFPnI9kHlSErmM1La8XWGdjJQaUaDCIlvIGz8nx3/ugaz
         D+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XOfVJxcuUuw2NudxNMfi/4+4mLmNM1VdK9Htk8RiFag=;
        b=s51K14bYNEh4fy/tkZUedYrfWUQ28fsdInrmdI+uM5peepzitSbiJHvPnmTmvcy7Lr
         7wpmXsFhuNtf20RdseMBjUQhQYSqUnGIHpg6YM/TtPwkwZDfvXmfc1VYc3FhNW10wsLx
         BLBAXdxihkUsLJckuJQKWfKIP/DkOkfU+nfaifLwyK/2gKpKDo1iqSKlGLwJB/1gd+qs
         au6lHKLQa8p5zXBlCts8efrDt8Vd2Bz3IAD8Mw5SEMCyKkm+HDpT2cEC3vkQbqNey5uf
         7C5M862OajpR7YXPqNNg0202hFtjSV+YzEOn0amMuMH56K47HnnQTajLa8Se3hzxn0HF
         dvZw==
X-Gm-Message-State: APjAAAVgz+oAvb6cDtU97c9lRRyVPDD/2pxQBBNPNJZdx0edXWJ2CCzq
        7TCL8GUbN4tSfkSZ+LQfffA=
X-Google-Smtp-Source: APXvYqz7bchCmrH/Z/TfQ6B9c0tjdoLTwkTphYa9scd+FCoXgZRMXaroXycWeS5PHJheT2gGceuf1A==
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr8358819wrj.391.1573743855664;
        Thu, 14 Nov 2019 07:04:15 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 03/11] net: mscc: ocelot: move invariant configs out of adjust_link
Date:   Thu, 14 Nov 2019 17:03:22 +0200
Message-Id: <20191114150330.25856-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It doesn't make sense to rewrite all these registers every time the PHY
library notifies us about a link state change.

In a future patch we will customize the MTU for the CPU port, and since
the MTU was previously configured from adjust_link, if we don't make
this change, its value would have got overridden.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 85 +++++++++++++++---------------
 1 file changed, 43 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 2b6792ab0eda..4558c09e2e8a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -408,7 +408,7 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			       struct phy_device *phydev)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	int speed, atop_wm, mode = 0;
+	int speed, mode = 0;
 
 	switch (phydev->speed) {
 	case SPEED_10:
@@ -440,32 +440,9 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_MAC_MODE_CFG_FDX_ENA |
 			   mode, DEV_MAC_MODE_CFG);
 
-	/* Set MAC IFG Gaps
-	 * FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 0
-	 * !FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 5
-	 */
-	ocelot_port_writel(ocelot_port, DEV_MAC_IFG_CFG_TX_IFG(5),
-			   DEV_MAC_IFG_CFG);
-
-	/* Load seed (0) and set MAC HDX late collision  */
-	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67) |
-			   DEV_MAC_HDX_CFG_SEED_LOAD,
-			   DEV_MAC_HDX_CFG);
-	mdelay(1);
-	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67),
-			   DEV_MAC_HDX_CFG);
-
 	if (ocelot->ops->pcs_init)
 		ocelot->ops->pcs_init(ocelot, port);
 
-	/* Set Max Length and maximum tags allowed */
-	ocelot_port_writel(ocelot_port, VLAN_ETH_FRAME_LEN,
-			   DEV_MAC_MAXLEN_CFG);
-	ocelot_port_writel(ocelot_port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
-			   DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
-			   DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA,
-			   DEV_MAC_TAGS_CFG);
-
 	/* Enable MAC module */
 	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
 			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
@@ -475,22 +452,10 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
 			   DEV_CLOCK_CFG);
 
-	/* Set SMAC of Pause frame (00:00:00:00:00:00) */
-	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_HIGH_CFG);
-	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
-
 	/* No PFC */
 	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
 			 ANA_PFC_PFC_CFG, port);
 
-	/* Set Pause WM hysteresis
-	 * 152 = 6 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
-	 * 101 = 4 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
-	 */
-	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
-			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
-			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
-
 	/* Core: Enable port for frame transfer */
 	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
 			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
@@ -505,12 +470,6 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			 SYS_MAC_FC_CFG_FC_LINK_SPEED(speed),
 			 SYS_MAC_FC_CFG, port);
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
-
-	/* Tail dropping watermark */
-	atop_wm = (ocelot->shared_queue_sz - 9 * VLAN_ETH_FRAME_LEN) / OCELOT_BUFFER_CELL_SZ;
-	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * VLAN_ETH_FRAME_LEN),
-			 SYS_ATOP, port);
-	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
 
 static void ocelot_port_adjust_link(struct net_device *dev)
@@ -2141,11 +2100,53 @@ static int ocelot_init_timestamp(struct ocelot *ocelot)
 static void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int atop_wm;
 
 	INIT_LIST_HEAD(&ocelot_port->skbs);
 
 	/* Basic L2 initialization */
 
+	/* Set MAC IFG Gaps
+	 * FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 0
+	 * !FDX: TX_IFG = 5, RX_IFG1 = RX_IFG2 = 5
+	 */
+	ocelot_port_writel(ocelot_port, DEV_MAC_IFG_CFG_TX_IFG(5),
+			   DEV_MAC_IFG_CFG);
+
+	/* Load seed (0) and set MAC HDX late collision  */
+	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67) |
+			   DEV_MAC_HDX_CFG_SEED_LOAD,
+			   DEV_MAC_HDX_CFG);
+	mdelay(1);
+	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67),
+			   DEV_MAC_HDX_CFG);
+
+	/* Set Max Length and maximum tags allowed */
+	ocelot_port_writel(ocelot_port, VLAN_ETH_FRAME_LEN,
+			   DEV_MAC_MAXLEN_CFG);
+	ocelot_port_writel(ocelot_port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
+			   DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
+			   DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA,
+			   DEV_MAC_TAGS_CFG);
+
+	/* Set SMAC of Pause frame (00:00:00:00:00:00) */
+	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_HIGH_CFG);
+	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
+
+	/* Set Pause WM hysteresis
+	 * 152 = 6 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
+	 * 101 = 4 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
+	 */
+	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
+			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
+			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
+
+	/* Tail dropping watermark */
+	atop_wm = (ocelot->shared_queue_sz - 9 * VLAN_ETH_FRAME_LEN) / OCELOT_BUFFER_CELL_SZ;
+	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * VLAN_ETH_FRAME_LEN),
+			 SYS_ATOP, port);
+	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
+
 	/* Drop frames with multicast source address */
 	ocelot_rmw_gix(ocelot, ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
 		       ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
-- 
2.17.1

