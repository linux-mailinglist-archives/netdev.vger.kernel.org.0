Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8DBCFC972
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKNPEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44641 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfKNPEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:15 -0500
Received: by mail-wr1-f65.google.com with SMTP id f2so6834824wrs.11
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l4q/Sid/bD+YaYF4i2VHKijU5o83ab8bFmT0KdZdQQc=;
        b=XSxcT1qNZxos8DZ92p1tZRT2+aLv0i067WeVICqMr6iGEpA9d1mb8Emt300/GsYaOb
         ryzpA3VeLkUqBQjrCu3AWM5Ue78bEw8cWMC6QiWeW2kl918jolmHFGj2WwfrWndMND3O
         vox02vbH+ux9K5g2ZezbhVsYUPEHZ8l+W8tV0/c/gL3dkN/fNFvOActg9ZpcmMWmQBeW
         jGNGyeVZSBprSD76EUDtfS7A0KEEsEd28+0MIhLu3DTYh7nhUYX/0MO9RxJ53B7Sb5e6
         02LmjbHHzgexxzJcNtT8oUvAy2948xUNUN+nyQqAbZdHOWlIULN9gnNapnDrCsZ9J7T5
         YjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l4q/Sid/bD+YaYF4i2VHKijU5o83ab8bFmT0KdZdQQc=;
        b=qhqzAS9OVW04rTFANTAxjsMbW6eqAunvwFJFUM2qFQmlOh8PMRaWqoJzlC1DLemEI2
         eYvKBJ5OZd4+QMiDRlVevbVhXk1FjlwsKxnbLkjjQVWOKovZAlpficvzgRa+N8S2bfrD
         B0zJ1ZvUpo1Ql3pWv95mbFYaoGiAZAAlVrdcqrNVx+DTo+7YeNMXLO+90O69LoVkS2lu
         G5jz48zWPzaRaZKmXFwANxv7MkgS+c1n01kW6jViIeddDc7oFUNrAdoIHPkNfVmVGhyU
         biZpTWv3wCqMfx15h3ZwA6DPD2tUlW2WcVuIaOxxFaM3hsJo0SsO5+LZuN86o064cceF
         FpOQ==
X-Gm-Message-State: APjAAAVOtfpN4QRUraW/zKDZnLibwZX1UfWZHWSqxCduJqeLTCmEEuSb
        3qdqHMYPQ+1li5GFtNlxOyWXbs6x
X-Google-Smtp-Source: APXvYqzRPN+LzxpPKl/dzOMf7qnD893ijqRaFikTH2gJQhK5B6FddOnSQmVJ3Bh27cRtK/GXzD2O3Q==
X-Received: by 2002:adf:a559:: with SMTP id j25mr8737131wrb.31.1573743852907;
        Thu, 14 Nov 2019 07:04:12 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:10 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 01/11] net: mscc: ocelot: move resource ioremap and regmap init to common code
Date:   Thu, 14 Nov 2019 17:03:20 +0200
Message-Id: <20191114150330.25856-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
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
Changes in v2:
None.

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

