Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225AE4EC36
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFUPi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:38:57 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48294 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfFUPi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:38:57 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DC5782009F8;
        Fri, 21 Jun 2019 17:38:54 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CC560200071;
        Fri, 21 Jun 2019 17:38:54 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5D36820629;
        Fri, 21 Jun 2019 17:38:54 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/6] ocelot: Filter out ocelot SoC specific PCS config from common path
Date:   Fri, 21 Jun 2019 18:38:47 +0300
Message-Id: <1561131532-14860-2-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The adjust_link routine should be generic enough to be (re)used by
any SoC that integrates a switch core compatible with the Ocelot
core switch driver.  Currently all configurations are generic except
for the PCS settings that are SoC specific.  Move these out to the
Ocelot SoC/board instance.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c      | 17 ++---------------
 drivers/net/ethernet/mscc/ocelot.h      |  2 ++
 drivers/net/ethernet/mscc/ocelot_regs.c | 21 +++++++++++++++++++++
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b71e4ecbe469..66cf57e6fd76 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -405,21 +405,8 @@ static void ocelot_port_adjust_link(struct net_device *dev)
 	ocelot_port_writel(port, DEV_MAC_HDX_CFG_LATE_COL_POS(67),
 			   DEV_MAC_HDX_CFG);
 
-	/* Disable HDX fast control */
-	ocelot_port_writel(port, DEV_PORT_MISC_HDX_FAST_DIS, DEV_PORT_MISC);
-
-	/* SGMII only for now */
-	ocelot_port_writel(port, PCS1G_MODE_CFG_SGMII_MODE_ENA, PCS1G_MODE_CFG);
-	ocelot_port_writel(port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
-
-	/* Enable PCS */
-	ocelot_port_writel(port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
-
-	/* No aneg on SGMII */
-	ocelot_port_writel(port, 0, PCS1G_ANEG_CFG);
-
-	/* No loopback */
-	ocelot_port_writel(port, 0, PCS1G_LB_CFG);
+	if (ocelot->port_pcs_init)
+		ocelot->port_pcs_init(port);
 
 	/* Set Max Length and maximum tags allowed */
 	ocelot_port_writel(port, VLAN_ETH_FRAME_LEN, DEV_MAC_MAXLEN_CFG);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index f7eeb4806897..e21a6fb22ef8 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -442,6 +442,8 @@ struct ocelot {
 	u64 *stats;
 	struct delayed_work stats_work;
 	struct workqueue_struct *stats_queue;
+
+	void (*port_pcs_init)(struct ocelot_port *port);
 };
 
 struct ocelot_port {
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index 6c387f994ec5..000c43984858 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -412,6 +412,26 @@ static void ocelot_pll5_init(struct ocelot *ocelot)
 		     HSIO_PLL5G_CFG2_AMPC_SEL(0x10));
 }
 
+static void ocelot_port_pcs_init(struct ocelot_port *port)
+{
+	/* Disable HDX fast control */
+	ocelot_port_writel(port, DEV_PORT_MISC_HDX_FAST_DIS, DEV_PORT_MISC);
+
+	/* SGMII only for now */
+	ocelot_port_writel(port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
+			   PCS1G_MODE_CFG);
+	ocelot_port_writel(port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
+
+	/* Enable PCS */
+	ocelot_port_writel(port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
+
+	/* No aneg on SGMII */
+	ocelot_port_writel(port, 0, PCS1G_ANEG_CFG);
+
+	/* No loopback */
+	ocelot_port_writel(port, 0, PCS1G_LB_CFG);
+}
+
 int ocelot_chip_init(struct ocelot *ocelot)
 {
 	int ret;
@@ -420,6 +440,7 @@ int ocelot_chip_init(struct ocelot *ocelot)
 	ocelot->stats_layout = ocelot_stats_layout;
 	ocelot->num_stats = ARRAY_SIZE(ocelot_stats_layout);
 	ocelot->shared_queue_sz = 224 * 1024;
+	ocelot->port_pcs_init = ocelot_port_pcs_init;
 
 	ret = ocelot_regfields_init(ocelot, ocelot_regfields);
 	if (ret)
-- 
2.17.1

