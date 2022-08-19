Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FEB599B8B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348813AbiHSMBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348742AbiHSMBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:01:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E9DE68EE
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:01:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oP0ge-0007ml-NN; Fri, 19 Aug 2022 14:01:16 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oP0gc-000hba-G9; Fri, 19 Aug 2022 14:01:14 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oP0ga-00GBb8-AE; Fri, 19 Aug 2022 14:01:12 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH net-next v1 4/7] net: pse-pd: add generic PSE driver
Date:   Fri, 19 Aug 2022 14:01:06 +0200
Message-Id: <20220819120109.3857571-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220819120109.3857571-1-o.rempel@pengutronix.de>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic driver to support simple Power Sourcing Equipment without
automatic classification support.

This driver was tested on 10Bast-T1L switch with regulator based PoDL PSE.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/pse-pd/Kconfig       |  11 +++
 drivers/net/pse-pd/Makefile      |   2 +
 drivers/net/pse-pd/pse_generic.c | 146 +++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+)
 create mode 100644 drivers/net/pse-pd/pse_generic.c

diff --git a/drivers/net/pse-pd/Kconfig b/drivers/net/pse-pd/Kconfig
index 49c7f0bcff526..a804c9f1af2bc 100644
--- a/drivers/net/pse-pd/Kconfig
+++ b/drivers/net/pse-pd/Kconfig
@@ -9,3 +9,14 @@ menuconfig PSE_CONTROLLER
 	  Generic Power Sourcing Equipment Controller support.
 
 	  If unsure, say no.
+
+if PSE_CONTROLLER
+
+config PSE_GENERIC
+	tristate "Generic PSE driver"
+	help
+	  This module provides support for simple Ethernet Power Sourcing
+	  Equipment without automatic classification support. For example for
+	  PoDL (802.3bu) specification.
+
+endif
diff --git a/drivers/net/pse-pd/Makefile b/drivers/net/pse-pd/Makefile
index cbb79fc2e2706..80ef39ad68f10 100644
--- a/drivers/net/pse-pd/Makefile
+++ b/drivers/net/pse-pd/Makefile
@@ -2,3 +2,5 @@
 # Makefile for Linux PSE drivers
 
 obj-$(CONFIG_PSE_CONTROLLER) += pse-core.o
+
+obj-$(CONFIG_PSE_GENERIC) += pse_generic.o
diff --git a/drivers/net/pse-pd/pse_generic.c b/drivers/net/pse-pd/pse_generic.c
new file mode 100644
index 0000000000000..f264d4d589f59
--- /dev/null
+++ b/drivers/net/pse-pd/pse_generic.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Driver for the Generic Ethernet Power Sourcing Equipment, without
+// auto classification support.
+//
+// Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
+//
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pse-pd/pse.h>
+#include <linux/regulator/consumer.h>
+
+struct gen_pse_priv {
+	struct pse_controller_dev pcdev;
+	struct regulator *ps; /*power source */
+	enum ethtool_podl_pse_admin_state admin_state;
+};
+
+static struct gen_pse_priv *to_gen_pse(struct pse_controller_dev *pcdev)
+{
+	return container_of(pcdev, struct gen_pse_priv, pcdev);
+}
+
+static int
+gen_pse_podl_get_admin_sate(struct pse_controller_dev *pcdev, unsigned long id)
+{
+	struct gen_pse_priv *priv = to_gen_pse(pcdev);
+
+	/* aPoDLPSEAdminState can be different to aPoDLPSEPowerDetectionStatus
+	 * which is provided by the regulator.
+	 */
+	return priv->admin_state;
+}
+
+static int
+gen_pse_podl_set_admin_control(struct pse_controller_dev *pcdev,
+			       unsigned long id,
+			       enum ethtool_podl_pse_admin_state state)
+{
+	struct gen_pse_priv *priv = to_gen_pse(pcdev);
+	int ret;
+
+	if (priv->admin_state == state)
+		goto set_state;
+
+	switch (state) {
+	case ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED:
+		ret = regulator_enable(priv->ps);
+		break;
+	case ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED:
+		ret = regulator_disable(priv->ps);
+		break;
+	default:
+		dev_err(pcdev->dev, "Unknown admin state %i\n", state);
+		ret = -ENOTSUPP;
+	}
+
+	if (ret)
+		return ret;
+
+set_state:
+	priv->admin_state = state;
+
+	return 0;
+}
+
+static int
+gen_pse_podl_get_pw_d_status(struct pse_controller_dev *pcdev, unsigned long id)
+{
+	struct gen_pse_priv *priv = to_gen_pse(pcdev);
+	int ret;
+
+	ret = regulator_is_enabled(priv->ps);
+	if (ret < 0)
+		return ret;
+
+	if (!ret)
+		return ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED;
+
+	return ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING;
+}
+
+static const struct pse_control_ops gen_pse_ops = {
+	.get_podl_pse_admin_sate = gen_pse_podl_get_admin_sate,
+	.set_podl_pse_admin_control = gen_pse_podl_set_admin_control,
+	.get_podl_pse_pw_d_status = gen_pse_podl_get_pw_d_status,
+};
+
+static int
+gen_pse_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct gen_pse_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	if (!pdev->dev.of_node)
+		return -ENOENT;
+
+	priv->ps = devm_regulator_get(dev, "ieee802.3-podl-pse");
+	if (IS_ERR(priv->ps)) {
+		dev_err(dev, "failed to get PSE regulator (%pe)\n", priv->ps);
+		return PTR_ERR(priv->ps);
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	priv->admin_state = ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED;
+
+	priv->pcdev.owner = THIS_MODULE;
+	priv->pcdev.ops = &gen_pse_ops;
+	priv->pcdev.dev = dev;
+	ret = devm_pse_controller_register(dev, &priv->pcdev);
+	if (ret) {
+		dev_err(dev, "failed to register PSE controller (%pe)\n",
+			ERR_PTR(ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id gen_pse_of_match[] = {
+	{ .compatible = "ieee802.3-podl-pse-generic", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, gen_pse_of_match);
+
+static struct platform_driver gen_pse_driver = {
+	.probe		= gen_pse_probe,
+	.driver		= {
+		.name		= "PSE Generic",
+		.of_match_table = of_match_ptr(gen_pse_of_match),
+	},
+};
+module_platform_driver(gen_pse_driver);
+
+MODULE_AUTHOR("Oleksij Rempel <kernel@pengutronix.de>");
+MODULE_DESCRIPTION("Generic Ethernet Power Sourcing Equipment");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:pse-generic");
-- 
2.30.2

