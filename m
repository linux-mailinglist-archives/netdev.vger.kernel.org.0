Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FDC4EC38
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfFUPjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:39:00 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48314 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfFUPi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:38:58 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E6F852009FA;
        Fri, 21 Jun 2019 17:38:55 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D78B0200071;
        Fri, 21 Jun 2019 17:38:55 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6847920629;
        Fri, 21 Jun 2019 17:38:55 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 3/6] ocelot: Factor out resource ioremap and regmap init common code
Date:   Fri, 21 Jun 2019 18:38:49 +0300
Message-Id: <1561131532-14860-4-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's make this ioremap and regmap init code common.  It should not
be platform dependent as it should be usable by PCI devices too.
Use better names where necessary to avoid clashes.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.h       |  4 +---
 drivers/net/ethernet/mscc/ocelot_board.c | 12 ++++++++----
 drivers/net/ethernet/mscc/ocelot_io.c    | 14 +++++---------
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e21a6fb22ef8..4235d7294772 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -493,9 +493,7 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
-struct regmap *ocelot_io_platform_init(struct ocelot *ocelot,
-				       struct platform_device *pdev,
-				       const char *name);
+struct regmap *ocelot_io_init(struct ocelot *ocelot, struct resource *res);
 
 #define ocelot_field_write(ocelot, reg, val) regmap_field_write((ocelot)->regfields[(reg)], (val))
 #define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 2a6ee4edb858..489177058d9e 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -182,7 +182,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	struct {
 		enum ocelot_target id;
 		char *name;
-	} res[] = {
+	} io_target[] = {
 		{ SYS, "sys" },
 		{ REW, "rew" },
 		{ QSYS, "qsys" },
@@ -201,14 +201,18 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ocelot);
 	ocelot->dev = &pdev->dev;
 
-	for (i = 0; i < ARRAY_SIZE(res); i++) {
+	for (i = 0; i < ARRAY_SIZE(io_target); i++) {
 		struct regmap *target;
+		struct resource *res;
+
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   io_target[i].name);
 
-		target = ocelot_io_platform_init(ocelot, pdev, res[i].name);
+		target = ocelot_io_init(ocelot, res);
 		if (IS_ERR(target))
 			return PTR_ERR(target);
 
-		ocelot->targets[res[i].id] = target;
+		ocelot->targets[io_target[i].id] = target;
 	}
 
 	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index c6db8ad31fdf..9a9a6766c231 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -97,20 +97,16 @@ static struct regmap_config ocelot_regmap_config = {
 	.reg_stride	= 4,
 };
 
-struct regmap *ocelot_io_platform_init(struct ocelot *ocelot,
-				       struct platform_device *pdev,
-				       const char *name)
+struct regmap *ocelot_io_init(struct ocelot *ocelot, struct resource *res)
 {
-	struct resource *res;
 	void __iomem *regs;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
 	regs = devm_ioremap_resource(ocelot->dev, res);
 	if (IS_ERR(regs))
 		return ERR_CAST(regs);
 
-	ocelot_regmap_config.name = name;
-	return devm_regmap_init_mmio(ocelot->dev, regs,
-				     &ocelot_regmap_config);
+	ocelot_regmap_config.name = res->name;
+
+	return devm_regmap_init_mmio(ocelot->dev, regs, &ocelot_regmap_config);
 }
-EXPORT_SYMBOL(ocelot_io_platform_init);
+EXPORT_SYMBOL(ocelot_io_init);
-- 
2.17.1

