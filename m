Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2493FC973
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKNPER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:17 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34093 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfKNPEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:16 -0500
Received: by mail-wr1-f66.google.com with SMTP id e6so6880075wrw.1
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y8ibyzdrAkRySs+F3V+FYEQuKhfDa+VDB4GEk5m/hrQ=;
        b=iRmUD3s5N89TcZib4L4NQgXSvsWUDMRv4JIlTDEL0SNhLE/j/FMZFn1HZ7O0eONviZ
         KE1l7JfM/fWHDJam8uMmncMdL5Zv1sNpnDBFS+D1rMr8o/oIRxdKDPdwKcynGd3aYBzv
         SfrjYpxccjnbN6oOcQzD+3dcXIUF2x/Wi/v8hRDO16DwW1oSSEcgaFzZaooZ2deXf//o
         QL8f37p+zyHOAgdU7pVt4MJr3vyHZWLZUvLsBATHc32gdwgo3Q8x7sQnvjHYiatlZUPa
         U5B+49divDiuX0uYnwkXAG8OO9Yc1CoFptum8OyMr6NabRfXg0+69bTHSi1qlJY2Ie3m
         F97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y8ibyzdrAkRySs+F3V+FYEQuKhfDa+VDB4GEk5m/hrQ=;
        b=tGwv+2d9XBe/rktuuF12Vtg1iQ4/zcrMOZhcpH9mTr0oX11tyY+0MaFfX5W8jfhUVp
         bWEOXOwxb2//xMZu0l4MDIEefnKUN9EO9ssOMiiIGOba9Pb1wfAm2FALjs4RXh0ro4tq
         MfxY0s+NWQO3j6Ah7nesAnn5tLn8aHa82KG7Py4eUCbQuqJkw0ytNZFtaFvn4w49cpiW
         Kk2qF/QglJia9nGSRh4kJCSjsbb/SowxQpjmdy+7TN0bbHlHvpX0RTUku8gEOjcRbuMX
         2FmPGfuP1HyivLuiw1wO1zH0azvwAxX+l65WUgU45RaFhZJHqXUP/xLWDTRpVFhhHiie
         fdNw==
X-Gm-Message-State: APjAAAUpweiXV5wWmgmIF/CiWvNr50MC/I57thWcCKeS2B7XzRRb0+l5
        54UOtQQdm6GVeLbLAsIrTnh1D9Ju
X-Google-Smtp-Source: APXvYqynYW8HEShDxHBoR2ptJwczP7aJm6EquSTwT7Q9IiyqkV1RrRSq+vvW0Xb8LjDNflI0IZQCqw==
X-Received: by 2002:a5d:49c4:: with SMTP id t4mr8918954wrs.226.1573743854349;
        Thu, 14 Nov 2019 07:04:14 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 02/11] net: mscc: ocelot: filter out ocelot SoC specific PCS config from common path
Date:   Thu, 14 Nov 2019 17:03:21 +0200
Message-Id: <20191114150330.25856-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

The adjust_link routine should be generic enough to be (re)used by
any SoC that integrates a switch core compatible with the Ocelot
core switch driver.  Currently all configurations are generic except
for the PCS settings that are SoC specific.  Move these out to the
Ocelot SoC/board instance.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
Fixed an overzealous removal of EXPORT_SYMBOL(ocelot_chip_init) that
caused a build error.

 drivers/net/ethernet/mscc/ocelot.c       | 19 ++--------------
 drivers/net/ethernet/mscc/ocelot.h       |  8 ++++++-
 drivers/net/ethernet/mscc/ocelot_board.c | 29 +++++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_regs.c  |  3 ++-
 4 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 3e7a2796c37d..2b6792ab0eda 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -455,23 +455,8 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67),
 			   DEV_MAC_HDX_CFG);
 
-	/* Disable HDX fast control */
-	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
-			   DEV_PORT_MISC);
-
-	/* SGMII only for now */
-	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
-			   PCS1G_MODE_CFG);
-	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
-
-	/* Enable PCS */
-	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
-
-	/* No aneg on SGMII */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
-
-	/* No loopback */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+	if (ocelot->ops->pcs_init)
+		ocelot->ops->pcs_init(ocelot, port);
 
 	/* Set Max Length and maximum tags allowed */
 	ocelot_port_writel(ocelot_port, VLAN_ETH_FRAME_LEN,
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index b5802cea7cc4..7e28434c22c1 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -435,13 +435,19 @@ enum ocelot_tag_prefix {
 };
 
 struct ocelot_port;
+struct ocelot;
 
 struct ocelot_stat_layout {
 	u32 offset;
 	char name[ETH_GSTRING_LEN];
 };
 
+struct ocelot_ops {
+	void (*pcs_init)(struct ocelot *ocelot, int port);
+};
+
 struct ocelot {
+	const struct ocelot_ops *ops;
 	struct device *dev;
 
 	struct regmap *targets[TARGET_MAX];
@@ -553,7 +559,7 @@ struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
 
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
-int ocelot_chip_init(struct ocelot *ocelot);
+int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops);
 int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
 		      struct phy_device *phy);
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index ddb34f17fa52..de2da6d33d43 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -254,6 +254,33 @@ static const struct of_device_id mscc_ocelot_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
 
+static void ocelot_port_pcs_init(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	/* Disable HDX fast control */
+	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
+			   DEV_PORT_MISC);
+
+	/* SGMII only for now */
+	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
+			   PCS1G_MODE_CFG);
+	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
+
+	/* Enable PCS */
+	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
+
+	/* No aneg on SGMII */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
+
+	/* No loopback */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+}
+
+static const struct ocelot_ops ocelot_ops = {
+	.pcs_init		= ocelot_port_pcs_init,
+};
+
 static int mscc_ocelot_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -315,7 +342,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	ocelot->targets[HSIO] = hsio;
 
-	err = ocelot_chip_init(ocelot);
+	err = ocelot_chip_init(ocelot, &ocelot_ops);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index e59977d20400..b88b5899b227 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -423,7 +423,7 @@ static void ocelot_pll5_init(struct ocelot *ocelot)
 		     HSIO_PLL5G_CFG2_AMPC_SEL(0x10));
 }
 
-int ocelot_chip_init(struct ocelot *ocelot)
+int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 {
 	int ret;
 
@@ -431,6 +431,7 @@ int ocelot_chip_init(struct ocelot *ocelot)
 	ocelot->stats_layout = ocelot_stats_layout;
 	ocelot->num_stats = ARRAY_SIZE(ocelot_stats_layout);
 	ocelot->shared_queue_sz = 224 * 1024;
+	ocelot->ops = ops;
 
 	ret = ocelot_regfields_init(ocelot, ocelot_regfields);
 	if (ret)
-- 
2.17.1

