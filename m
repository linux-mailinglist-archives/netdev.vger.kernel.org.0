Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDE8F8FD8
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfKLMop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:44:45 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38110 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfKLMoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id z19so2799716wmk.3
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MZNyvm/Bl/Cv1uRXpT8GQQhm+VxZTODs1FR28V07yu8=;
        b=B8J7489Ew/tebBRjtAjGIuYJBx4vawbJePDZY03tq1tg/psOEUZ83p+M4jcZgJioeX
         Q242HyAyzb8cEUtWqCEHqxAvNu7RvyH07RkGmnf/qxeL5aAsa27B9n5lbcy/9kdSYNOB
         6JX5jz3BxmM5rP6R69f4TffP2onWjiZIhqWOTC6h3Cvcu66L2T106TQ6t3mEcQBr36Iq
         srbc7uzFsKXl5kuZjrG85xK9DmP5JH0RXVvlUsFClB2wP5/0AbQlmQJRMnBJpuc/8HQi
         IE2Ln3ZVXEamv8pzeTw1gEC8GZF9SKkpHJPvssfQtfyTl3RfFUu2vXVmQpIyO728fics
         Dvug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MZNyvm/Bl/Cv1uRXpT8GQQhm+VxZTODs1FR28V07yu8=;
        b=gqs7tj9lmBVhKoMfVM1JXVYFybrRrkuUoEZHJUU/6mxUNBd6bCK7ICZ087Vs9Gr1j3
         LSfAv97zoNR5SDzvWYFjrXTj72wZtgkZ92dfjaG2OHXhiq/9xyrfA31DsNzAyI7wrhTy
         lrO/8lZWPq6rb9jDsplsXmXJF1MvjJaPTIj8t2cm57l9R1jdYeiH9lcdmzvV3miO/SjU
         hq9Bh5LwomCVOqzyxBWu/BTvd3715cisZBPBkyuDQ3j4Y5NzQmz+8Q6m50iavYdVv99A
         vogSg9jcIPcumj7rMRtUBppaU/pIqlAMOYkdRgO/M+vXZRA2L3v2y+plqfCpHO/DuLyU
         apkA==
X-Gm-Message-State: APjAAAUU0l/WugGRArz0kL5ipF5eJq6YyTMbFeb36ktCWoroVulRPu9q
        9u2e3B7i/x+W5bf9V2MjaC0=
X-Google-Smtp-Source: APXvYqyN7DmAnEJv8ra5KiUwKJZa+CP5lfnpk/alde1awNoIZdG87T27Dlomw5TsP/tYw0P89S9AVw==
X-Received: by 2002:a1c:1b06:: with SMTP id b6mr3688900wmb.3.1573562680815;
        Tue, 12 Nov 2019 04:44:40 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:40 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 01/12] net: mscc: ocelot: move resource ioremap and regmap init to common code
Date:   Tue, 12 Nov 2019 14:44:09 +0200
Message-Id: <20191112124420.6225-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

Let's make this ioremap and regmap init code common.  It should not
be platform dependent as it should be usable by PCI devices too.
Use better names where necessary to avoid clashes.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.h       |  4 +---
 drivers/net/ethernet/mscc/ocelot_board.c | 17 ++++++++++-------
 drivers/net/ethernet/mscc/ocelot_io.c    | 14 +++++---------
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 4d8e769ccad9..b5802cea7cc4 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -546,9 +546,7 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
-struct regmap *ocelot_io_platform_init(struct ocelot *ocelot,
-				       struct platform_device *pdev,
-				       const char *name);
+struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
 
 #define ocelot_field_write(ocelot, reg, val) regmap_field_write((ocelot)->regfields[(reg)], (val))
 #define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 811599f32910..ddb34f17fa52 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -268,7 +268,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		enum ocelot_target id;
 		char *name;
 		u8 optional:1;
-	} res[] = {
+	} io_target[] = {
 		{ SYS, "sys" },
 		{ REW, "rew" },
 		{ QSYS, "qsys" },
@@ -288,20 +288,23 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
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
+		target = ocelot_regmap_init(ocelot, res);
 		if (IS_ERR(target)) {
-			if (res[i].optional) {
-				ocelot->targets[res[i].id] = NULL;
+			if (io_target[i].optional) {
+				ocelot->targets[io_target[i].id] = NULL;
 				continue;
 			}
-
 			return PTR_ERR(target);
 		}
 
-		ocelot->targets[res[i].id] = target;
+		ocelot->targets[io_target[i].id] = target;
 	}
 
 	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index c6db8ad31fdf..b229b1cb68ef 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -97,20 +97,16 @@ static struct regmap_config ocelot_regmap_config = {
 	.reg_stride	= 4,
 };
 
-struct regmap *ocelot_io_platform_init(struct ocelot *ocelot,
-				       struct platform_device *pdev,
-				       const char *name)
+struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res)
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
+EXPORT_SYMBOL(ocelot_regmap_init);
-- 
2.17.1

