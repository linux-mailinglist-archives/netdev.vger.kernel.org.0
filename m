Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B24BFC974
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfKNPEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:20 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42480 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfKNPES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:18 -0500
Received: by mail-wr1-f65.google.com with SMTP id a15so6828879wrf.9
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0YqKP0RJoV3Y72FGyhKD7iDH8BnTVJVkfcHAPWs8qPs=;
        b=mJtimPqVfedOsbscnvsz+9p0q8/LgjgZ0HMAb/pvrUaxcPRiCrcjE2+daON/ZoIMAm
         DchemQTAR5+vTEA5UbJd6NtNW3U3wSEnMtWY8LX64+WIrXFAyZ0HODwH+T3sxxtrv0Ew
         +BKLVH2NZiiI1FrEODayWOguRGSPU1vh+rTVKvgkdLCsxwTF7cZokms3QRlJ1jw94xP/
         fB0Fgc0NisB5ASLEe5c9AFneLTkHxbGvkmkOscNZlQa4JrTgmFTfExnQoNfila5ygoXs
         BEhZ7Qfu5LjihLzgi6N2Czab7Jm2ke8a7ao6UcrLB0smYgxsBCXJwdb9bDCslQUpjRr+
         UtdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0YqKP0RJoV3Y72FGyhKD7iDH8BnTVJVkfcHAPWs8qPs=;
        b=GT2vZTL0EVm5Y0gMeQgvGHuaS2zk2tVynaz5/WTAYoApbpysAZilHg3/1BrBMgQ/eH
         go0mGP+rLS7q1XWYpqQwiudl4g4ePXYgIs0BHIvqmxyJjXMSI2QaErfKkEMHAUCe2Jfw
         sivZcCtSPNiktTtdxjvAfJX7DCUp7PbvsJY0cT7iGO5gDJyjAzTS0D3RJOXS4RcJ+X4u
         z+LF1XzdtN1uDWGL4N70Oa3H1xVvQrNtaB8jJi2ugjeARbNZOJdneJLUnpfIeH9klKND
         tTL8NGP8ZeYLjbyhX2567jgYeQdZJWPzF9R8SwyQxgk8xi7VCQZ3RFhJnYHgthznbMxa
         Alow==
X-Gm-Message-State: APjAAAVi7q/87c0CpJn1dOITj9iE14AKSfQ87zZd4I8TI0J9IYOwMTpK
        Vyu4rNqpWCWFZYrCisaTXok=
X-Google-Smtp-Source: APXvYqxZVYCp+fYMQyHgKSRRVASiXl9ovF2wTr7s+E44fPy4FMkvN3aANfbT3GyTfx4ElALB0snMUA==
X-Received: by 2002:a5d:5404:: with SMTP id g4mr4862757wrv.359.1573743857068;
        Thu, 14 Nov 2019 07:04:17 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 04/11] net: mscc: ocelot: create a helper for changing the port MTU
Date:   Thu, 14 Nov 2019 17:03:23 +0200
Message-Id: <20191114150330.25856-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since in an NPI/DSA setup, not all ports will have the same MTU, we need
to make sure the watermarks for pause frames and/or tail dropping logic
that existed in the driver is still coherent for the new MTU values.

We need to do this because the NPI (aka external CPU) port needs an
increased MTU for the DSA tag. This will be done in a future patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
Added the "why" in the commit message.

 drivers/net/ethernet/mscc/ocelot.c | 40 +++++++++++++++++-------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4558c09e2e8a..8ede8ad902c9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2097,11 +2097,32 @@ static int ocelot_init_timestamp(struct ocelot *ocelot)
 	return 0;
 }
 
-static void ocelot_init_port(struct ocelot *ocelot, int port)
+static void ocelot_port_set_mtu(struct ocelot *ocelot, int port, size_t mtu)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int atop_wm;
 
+	ocelot_port_writel(ocelot_port, mtu, DEV_MAC_MAXLEN_CFG);
+
+	/* Set Pause WM hysteresis
+	 * 152 = 6 * mtu / OCELOT_BUFFER_CELL_SZ
+	 * 101 = 4 * mtu / OCELOT_BUFFER_CELL_SZ
+	 */
+	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
+			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
+			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
+
+	/* Tail dropping watermark */
+	atop_wm = (ocelot->shared_queue_sz - 9 * mtu) / OCELOT_BUFFER_CELL_SZ;
+	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * mtu),
+			 SYS_ATOP, port);
+	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
+}
+
+static void ocelot_init_port(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
 	INIT_LIST_HEAD(&ocelot_port->skbs);
 
 	/* Basic L2 initialization */
@@ -2122,8 +2143,7 @@ static void ocelot_init_port(struct ocelot *ocelot, int port)
 			   DEV_MAC_HDX_CFG);
 
 	/* Set Max Length and maximum tags allowed */
-	ocelot_port_writel(ocelot_port, VLAN_ETH_FRAME_LEN,
-			   DEV_MAC_MAXLEN_CFG);
+	ocelot_port_set_mtu(ocelot, port, VLAN_ETH_FRAME_LEN);
 	ocelot_port_writel(ocelot_port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
 			   DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
 			   DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA,
@@ -2133,20 +2153,6 @@ static void ocelot_init_port(struct ocelot *ocelot, int port)
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_HIGH_CFG);
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
 
-	/* Set Pause WM hysteresis
-	 * 152 = 6 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
-	 * 101 = 4 * VLAN_ETH_FRAME_LEN / OCELOT_BUFFER_CELL_SZ
-	 */
-	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
-			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
-			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
-
-	/* Tail dropping watermark */
-	atop_wm = (ocelot->shared_queue_sz - 9 * VLAN_ETH_FRAME_LEN) / OCELOT_BUFFER_CELL_SZ;
-	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * VLAN_ETH_FRAME_LEN),
-			 SYS_ATOP, port);
-	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
-
 	/* Drop frames with multicast source address */
 	ocelot_rmw_gix(ocelot, ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
 		       ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
-- 
2.17.1

