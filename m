Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAFA5F8FD7
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfKLMor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:44:47 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51299 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfKLMoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id q70so3020903wme.1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8SqV/Zmi6H3rzIxlYVmttMmU482DKpPW4vMaEAReLnw=;
        b=iddYEprVs/XC+HdcuSKMWH/qEYM4axtuNlGbGhxpvogd+99GK9d90Ewo3KNReLoVU6
         skSUXDaHBBLYstPYYjZvfpSTDsf5GeDi2WRQPCfFXQmj3McQZxttoAQQ2PZWSyif7KFH
         4fKASaBXOxoIvvoCIaIeHLnDRaW2oQyVSxzW+SoZmi46siEocT6scI836w2xS7owUN9L
         95QlxuHh/+0Rka30wo8IIY5HPEkSyQn+A/SU4FX3/il+syFFN0GMhcfjoA6yFrc44ivK
         OX4EE++GPXq7Q1QBKaK0c8qFB1nQwsTJRW0P3tVrVjRQeqU1BJXWbuoH5zM9SR3qbikX
         EU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8SqV/Zmi6H3rzIxlYVmttMmU482DKpPW4vMaEAReLnw=;
        b=E9DljJT4nOWqeSTzriuv/ixjquS8T4IChxJVaBUQO7F4JQHBBen1RB49mEosKlVI33
         aF/wHaXjcATAbdiMdL1pEK2BtkH2I0m+FrYnDtTGo/XMGMoBxaXr/kpW2mOePCIIxJH9
         XlWx4BWH4wX+h40Mh9erkPTyika+CItkVf2rvvSG05XjQAv42nzq9NTBAJVHxIFp1RU5
         9063S1h1MMbvv4YDmOcDnwstQNli9Q5nfFdj8w1k3E5TIeFmQYzOnFkxpjWqAHOAn/46
         MOgx3A8BuRniJ5B2xGD3phuIm/xf3+3YpBgziwMp3ATFnXylLMeWUHGg0Cy97+S3fPEd
         Tkxg==
X-Gm-Message-State: APjAAAXbCU2nlqf1/LVTHJQDP+SEoefSjma1pflgwZxoc5hGekiBBxGt
        e0PR9EtiRCugDXKNM7dnp94=
X-Google-Smtp-Source: APXvYqw2nh48MxlkExJpk1nRljybrpVS5CNUdvZQMcr3WEnblxS54Y3Yu0F+rnrVwRd0pWlT8uCJcQ==
X-Received: by 2002:a05:600c:218e:: with SMTP id e14mr3538293wme.22.1573562683371;
        Tue, 12 Nov 2019 04:44:43 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:42 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 03/12] net: mscc: ocelot: move invariant configs out of adjust_link
Date:   Tue, 12 Nov 2019 14:44:11 +0200
Message-Id: <20191112124420.6225-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
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
---
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

