Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEFEDF8FDB
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfKLMo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:44:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33010 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbfKLMoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id w9so11572421wrr.0
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QWZoK2C/2fx6vYuyyGoaTlW6oCyo6Vl/R9q1GKLSPbM=;
        b=nkkBN8pCKYyPJHWP2sG1tfUu2/taEgiCeepqyw9/IUzDcwqjrDxus7f4n9QNUrfUnL
         f58LevkpwZU4nY77ZTiU+zYtXRQlmakuK/EYZimgpBcmu6QZEMemmXFNEvOyWK1PVPBg
         XZP2ZbsxXuwpkFl74/qkWeVRyRM0Lw9Bwv8PJZfGS+lYmQSoyTx/NCGqY8Gl+hmv4aLy
         9K3gfV0UiR5bk/W4tDNMpwkA7xirw0wZ7i/oxASFAnGm3WGTIh1N1SI32D6XBrc1z1zK
         tElglMVSqShhIMn16qXFpumzr7HMV3ePf9A447REkcvSx++SkEOBTG0Hceh6JZ8LwR6j
         9eHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QWZoK2C/2fx6vYuyyGoaTlW6oCyo6Vl/R9q1GKLSPbM=;
        b=X9bJpewVhF5yEOB3FftoonIXy7S3mACAZ/KRWRuO4Ar7g0qHGYRC6AbMtqdTxSIe0Y
         BRyb99nqnsZDcgE3mde4adoE5W+Hi8vUAp0U+gAEqF+Y5p8GLCdqPct6C8kX7KZSmi1W
         n+hK8nye0EUkV06qt1mu/OjD7vSnppx9Woxda0QjAGJnQQcub7owZ8XI+Y0G1GUqSCth
         vtiJmg2tTbOhQx4Wh9xw/s99KfWpvaX3PyrAsX3NiGDxNOZdYt2emQeMjyrS1F8qOc1f
         jgy58m1s79063Ngw2RgIUpXrZaYeukYknWkVu2RlqKWOKUZxTSsWmGGdlGOs/dSt3YOw
         asPA==
X-Gm-Message-State: APjAAAVYFdo6nX//JV3qqOet6Q4J5XnxywDb61zlJVz0ZP70uboqGpW9
        UW3e3vaFG/rQCcUJsI7/Qr4=
X-Google-Smtp-Source: APXvYqz2Gt1cTkZDPLDikBnyN6EYNQD9XNvFKV96B/FaV3fQSlA6G05XLZlBXumNv9o1OogjppL0Vw==
X-Received: by 2002:a5d:678f:: with SMTP id v15mr24246157wru.242.1573562684583;
        Tue, 12 Nov 2019 04:44:44 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 04/12] net: mscc: ocelot: create a helper for changing the port MTU
Date:   Tue, 12 Nov 2019 14:44:12 +0200
Message-Id: <20191112124420.6225-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since in an NPI/DSA setup, not all ports will have the same MTU, we need
to make sure the watermarks for pause frames and/or tail dropping logic
that existed in the driver is still coherent for the new MTU values.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

