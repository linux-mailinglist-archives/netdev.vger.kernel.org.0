Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8505826ABD7
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgIOS1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgIOSXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:23:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD214C061351
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:57 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so6429939ejf.6
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 11:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EA6Qr6VFjelBD+DslpRzCeBdHelO+UiXDpVl6fplfpY=;
        b=NLbuQI3F9DhXnwxYJfuW4GPQurAEgmtfulegGrHTJTDrWOMKfM9lt5662tb/7oEtTT
         /U11eKzNxpUvWVhBdiuCA8Shp8iCxZZPC+PfF47pixKYkhJTZBEj61AXgape6h+WM3Gz
         vI3qxVMu64fy3avbbX61h+m3yfD+nFHsgUThRMjAYf5f1YsVQZgkrtUNs6NeWRPx3lIN
         fCSTncOeIbtGhkJc7douM/GKMTIfurhP6L96c7JHZWR9r5tDB+afUBZHbx3JI3ez0vVQ
         uE1Z1NAFPneTNrs8QkneYex2tM4atAqMkiInp2HQDVjBxlFS2OeHctUYTRg6K/sApUWA
         aMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EA6Qr6VFjelBD+DslpRzCeBdHelO+UiXDpVl6fplfpY=;
        b=ulcO8XEus4+JubTqMuW+mMeSKArnhxoax5lg+33zhbFr0084pNIRTzic5Hni5yoS+1
         xLG3kZr4MF4oeSeHn6SpxXHMWNHsTuAl4tO8txLcXW77h/Q+USY1yOp/yzluOA9iG4HV
         NROLig/2R5TDvGOOKfZSpQnYrPyRzA5tS4f3eAdjSM5bHO3jpNX9J7CM+Ba0f/UK4kCp
         uF3/gMS7ANLwf6hLUQhVjiwQvpmVknyopfKvsB7ibBac42evApXCgDT+Vh6+/5klCP0b
         BUsJ8p1dcC28ihU/vSmaFaRdywIXxHmR1fx3pnhMs9sZRdqDuwx012So6h6fHothFAs6
         TVxg==
X-Gm-Message-State: AOAM533FeTcMZzbkWFFKsGKYvG83KTO4S6UcFNYYAisn/Tr0MJYokUqP
        0jnH+9ID5D1iCZ2n3eTtT5A=
X-Google-Smtp-Source: ABdhPJx+HaFITNyVPcN2BHBpheuukpJVbW2GOkJrm0KcGJW8i0rEAjTcR2QVu4IUnjQn+Eypt/rJyA==
X-Received: by 2002:a17:906:dbf5:: with SMTP id yd21mr21051863ejb.521.1600194176351;
        Tue, 15 Sep 2020 11:22:56 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id q11sm11860481eds.16.2020.09.15.11.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:22:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 6/7] net: mscc: ocelot: refactor ports parsing code into a dedicated function
Date:   Tue, 15 Sep 2020 21:22:28 +0300
Message-Id: <20200915182229.69529-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915182229.69529-1-olteanv@gmail.com>
References: <20200915182229.69529-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

mscc_ocelot_probe() is already pretty large and hard to follow. So move
the code for parsing ports in a separate function.

This makes it easier for the next patch to just call
mscc_ocelot_release_ports from the error path of mscc_ocelot_init_ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 223 +++++++++++----------
 1 file changed, 118 insertions(+), 105 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 91a915d0693f..851e79e11aed 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -896,123 +896,26 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.enable		= ocelot_ptp_enable,
 };
 
-static int mscc_ocelot_probe(struct platform_device *pdev)
+static int mscc_ocelot_init_ports(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct ocelot *ocelot = platform_get_drvdata(pdev);
+	struct device_node *np = ocelot->dev->of_node;
 	struct device_node *ports, *portnp;
-	int err, irq_xtr, irq_ptp_rdy;
-	struct ocelot *ocelot;
-	struct regmap *hsio;
-	unsigned int i;
-
-	struct {
-		enum ocelot_target id;
-		char *name;
-		u8 optional:1;
-	} io_target[] = {
-		{ SYS, "sys" },
-		{ REW, "rew" },
-		{ QSYS, "qsys" },
-		{ ANA, "ana" },
-		{ QS, "qs" },
-		{ S2, "s2" },
-		{ PTP, "ptp", 1 },
-	};
-
-	if (!np && !pdev->dev.platform_data)
-		return -ENODEV;
-
-	ocelot = devm_kzalloc(&pdev->dev, sizeof(*ocelot), GFP_KERNEL);
-	if (!ocelot)
-		return -ENOMEM;
-
-	platform_set_drvdata(pdev, ocelot);
-	ocelot->dev = &pdev->dev;
-
-	for (i = 0; i < ARRAY_SIZE(io_target); i++) {
-		struct regmap *target;
-		struct resource *res;
-
-		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						   io_target[i].name);
-
-		target = ocelot_regmap_init(ocelot, res);
-		if (IS_ERR(target)) {
-			if (io_target[i].optional) {
-				ocelot->targets[io_target[i].id] = NULL;
-				continue;
-			}
-			return PTR_ERR(target);
-		}
-
-		ocelot->targets[io_target[i].id] = target;
-	}
-
-	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
-	if (IS_ERR(hsio)) {
-		dev_err(&pdev->dev, "missing hsio syscon\n");
-		return PTR_ERR(hsio);
-	}
-
-	ocelot->targets[HSIO] = hsio;
-
-	err = ocelot_chip_init(ocelot, &ocelot_ops);
-	if (err)
-		return err;
-
-	irq_xtr = platform_get_irq_byname(pdev, "xtr");
-	if (irq_xtr < 0)
-		return -ENODEV;
-
-	err = devm_request_threaded_irq(&pdev->dev, irq_xtr, NULL,
-					ocelot_xtr_irq_handler, IRQF_ONESHOT,
-					"frame extraction", ocelot);
-	if (err)
-		return err;
-
-	irq_ptp_rdy = platform_get_irq_byname(pdev, "ptp_rdy");
-	if (irq_ptp_rdy > 0 && ocelot->targets[PTP]) {
-		err = devm_request_threaded_irq(&pdev->dev, irq_ptp_rdy, NULL,
-						ocelot_ptp_rdy_irq_handler,
-						IRQF_ONESHOT, "ptp ready",
-						ocelot);
-		if (err)
-			return err;
-
-		/* Both the PTP interrupt and the PTP bank are available */
-		ocelot->ptp = 1;
-	}
+	int err;
 
 	ports = of_get_child_by_name(np, "ethernet-ports");
 	if (!ports) {
-		dev_err(&pdev->dev, "no ethernet-ports child node found\n");
+		dev_err(ocelot->dev, "no ethernet-ports child node found\n");
 		return -ENODEV;
 	}
 
 	ocelot->num_phys_ports = of_get_child_count(ports);
 
-	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
+	ocelot->ports = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
 				     sizeof(struct ocelot_port *), GFP_KERNEL);
 	if (!ocelot->ports)
 		return -ENOMEM;
 
-	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
-	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
-	ocelot->vcap = vsc7514_vcap_props;
-
-	err = ocelot_init(ocelot);
-	if (err)
-		return err;
-
-	if (ocelot->ptp) {
-		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
-		if (err) {
-			dev_err(ocelot->dev,
-				"Timestamp initialization failed\n");
-			ocelot->ptp = 0;
-		}
-	}
-
 	/* No NPI port */
 	ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
 			     OCELOT_TAG_PREFIX_NONE);
@@ -1103,14 +1006,124 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		priv->serdes = serdes;
 	}
 
+out_put_ports:
+	of_node_put(ports);
+	return err;
+}
+
+static int mscc_ocelot_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	int err, irq_xtr, irq_ptp_rdy;
+	struct ocelot *ocelot;
+	struct regmap *hsio;
+	unsigned int i;
+
+	struct {
+		enum ocelot_target id;
+		char *name;
+		u8 optional:1;
+	} io_target[] = {
+		{ SYS, "sys" },
+		{ REW, "rew" },
+		{ QSYS, "qsys" },
+		{ ANA, "ana" },
+		{ QS, "qs" },
+		{ S2, "s2" },
+		{ PTP, "ptp", 1 },
+	};
+
+	if (!np && !pdev->dev.platform_data)
+		return -ENODEV;
+
+	ocelot = devm_kzalloc(&pdev->dev, sizeof(*ocelot), GFP_KERNEL);
+	if (!ocelot)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, ocelot);
+	ocelot->dev = &pdev->dev;
+
+	for (i = 0; i < ARRAY_SIZE(io_target); i++) {
+		struct regmap *target;
+		struct resource *res;
+
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   io_target[i].name);
+
+		target = ocelot_regmap_init(ocelot, res);
+		if (IS_ERR(target)) {
+			if (io_target[i].optional) {
+				ocelot->targets[io_target[i].id] = NULL;
+				continue;
+			}
+			return PTR_ERR(target);
+		}
+
+		ocelot->targets[io_target[i].id] = target;
+	}
+
+	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
+	if (IS_ERR(hsio)) {
+		dev_err(&pdev->dev, "missing hsio syscon\n");
+		return PTR_ERR(hsio);
+	}
+
+	ocelot->targets[HSIO] = hsio;
+
+	err = ocelot_chip_init(ocelot, &ocelot_ops);
+	if (err)
+		return err;
+
+	irq_xtr = platform_get_irq_byname(pdev, "xtr");
+	if (irq_xtr < 0)
+		return -ENODEV;
+
+	err = devm_request_threaded_irq(&pdev->dev, irq_xtr, NULL,
+					ocelot_xtr_irq_handler, IRQF_ONESHOT,
+					"frame extraction", ocelot);
+	if (err)
+		return err;
+
+	irq_ptp_rdy = platform_get_irq_byname(pdev, "ptp_rdy");
+	if (irq_ptp_rdy > 0 && ocelot->targets[PTP]) {
+		err = devm_request_threaded_irq(&pdev->dev, irq_ptp_rdy, NULL,
+						ocelot_ptp_rdy_irq_handler,
+						IRQF_ONESHOT, "ptp ready",
+						ocelot);
+		if (err)
+			return err;
+
+		/* Both the PTP interrupt and the PTP bank are available */
+		ocelot->ptp = 1;
+	}
+
+	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
+	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
+	ocelot->vcap = vsc7514_vcap_props;
+
+	err = ocelot_init(ocelot);
+	if (err)
+		return err;
+
+	err = mscc_ocelot_init_ports(pdev);
+	if (err)
+		return err;
+
+	if (ocelot->ptp) {
+		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
+		if (err) {
+			dev_err(ocelot->dev,
+				"Timestamp initialization failed\n");
+			ocelot->ptp = 0;
+		}
+	}
+
 	register_netdevice_notifier(&ocelot_netdevice_nb);
 	register_switchdev_notifier(&ocelot_switchdev_nb);
 	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 
 	dev_info(&pdev->dev, "Ocelot switch probed\n");
 
-out_put_ports:
-	of_node_put(ports);
 	return err;
 }
 
-- 
2.25.1

