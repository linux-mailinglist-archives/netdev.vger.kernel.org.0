Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A255F28B7
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJCGwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJCGw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:52:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233E63ECF8
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 23:52:25 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ofFJ9-0000yo-GS; Mon, 03 Oct 2022 08:52:07 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ofFJ8-004K5V-Au; Mon, 03 Oct 2022 08:52:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ofFJ5-00GJlO-HV; Mon, 03 Oct 2022 08:52:03 +0200
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
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v8 7/7] net: pse-pd: add regulator based PSE driver
Date:   Mon,  3 Oct 2022 08:52:02 +0200
Message-Id: <20221003065202.3889095-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221003065202.3889095-1-o.rempel@pengutronix.de>
References: <20221003065202.3889095-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic, regulator based PSE driver to support simple Power Sourcing
Equipment without automatic classification support.

This driver was tested on 10Bast-T1L switch with regulator based PoDL PSE.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
changes v5:
- use dev_err_probe on devm_regulator_get_exclusive() error
- add __maybe_unused to the of_device_id
changes v4:
- rename to pse_regulator
changes v2:
- add regulator_enable test to the probe
- migrate to the new PSE ethtool API
---
 drivers/net/pse-pd/Kconfig         |  11 +++
 drivers/net/pse-pd/Makefile        |   2 +
 drivers/net/pse-pd/pse_regulator.c | 147 +++++++++++++++++++++++++++++
 3 files changed, 160 insertions(+)
 create mode 100644 drivers/net/pse-pd/pse_regulator.c

diff --git a/drivers/net/pse-pd/Kconfig b/drivers/net/pse-pd/Kconfig
index 49c7f0bcff52..73d163704068 100644
--- a/drivers/net/pse-pd/Kconfig
+++ b/drivers/net/pse-pd/Kconfig
@@ -9,3 +9,14 @@ menuconfig PSE_CONTROLLER
 	  Generic Power Sourcing Equipment Controller support.
 
 	  If unsure, say no.
+
+if PSE_CONTROLLER
+
+config PSE_REGULATOR
+	tristate "Regulator based PSE controller"
+	help
+	  This module provides support for simple regulator based Ethernet Power
+	  Sourcing Equipment without automatic classification support. For
+	  example for basic implementation of PoDL (802.3bu) specification.
+
+endif
diff --git a/drivers/net/pse-pd/Makefile b/drivers/net/pse-pd/Makefile
index cfa780c7801d..1b8aa4c70f0b 100644
--- a/drivers/net/pse-pd/Makefile
+++ b/drivers/net/pse-pd/Makefile
@@ -2,3 +2,5 @@
 # Makefile for Linux PSE drivers
 
 obj-$(CONFIG_PSE_CONTROLLER) += pse_core.o
+
+obj-$(CONFIG_PSE_REGULATOR) += pse_regulator.o
diff --git a/drivers/net/pse-pd/pse_regulator.c b/drivers/net/pse-pd/pse_regulator.c
new file mode 100644
index 000000000000..e2bf8306ca90
--- /dev/null
+++ b/drivers/net/pse-pd/pse_regulator.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Driver for the regulator based Ethernet Power Sourcing Equipment, without
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
+struct pse_reg_priv {
+	struct pse_controller_dev pcdev;
+	struct regulator *ps; /*power source */
+	enum ethtool_podl_pse_admin_state admin_state;
+};
+
+static struct pse_reg_priv *to_pse_reg(struct pse_controller_dev *pcdev)
+{
+	return container_of(pcdev, struct pse_reg_priv, pcdev);
+}
+
+static int
+pse_reg_ethtool_set_config(struct pse_controller_dev *pcdev, unsigned long id,
+			   struct netlink_ext_ack *extack,
+			   const struct pse_control_config *config)
+{
+	struct pse_reg_priv *priv = to_pse_reg(pcdev);
+	int ret;
+
+	if (priv->admin_state == config->admin_cotrol)
+		return 0;
+
+	switch (config->admin_cotrol) {
+	case ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED:
+		ret = regulator_enable(priv->ps);
+		break;
+	case ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED:
+		ret = regulator_disable(priv->ps);
+		break;
+	default:
+		dev_err(pcdev->dev, "Unknown admin state %i\n",
+			config->admin_cotrol);
+		ret = -ENOTSUPP;
+	}
+
+	if (ret)
+		return ret;
+
+	priv->admin_state = config->admin_cotrol;
+
+	return 0;
+}
+
+static int
+pse_reg_ethtool_get_status(struct pse_controller_dev *pcdev, unsigned long id,
+			   struct netlink_ext_ack *extack,
+			   struct pse_control_status *status)
+{
+	struct pse_reg_priv *priv = to_pse_reg(pcdev);
+	int ret;
+
+	ret = regulator_is_enabled(priv->ps);
+	if (ret < 0)
+		return ret;
+
+	if (!ret)
+		status->podl_pw_status = ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED;
+	else
+		status->podl_pw_status =
+			ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING;
+
+	status->podl_admin_state = priv->admin_state;
+
+	return 0;
+}
+
+static const struct pse_controller_ops pse_reg_ops = {
+	.ethtool_get_status = pse_reg_ethtool_get_status,
+	.ethtool_set_config = pse_reg_ethtool_set_config,
+};
+
+static int
+pse_reg_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct pse_reg_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	if (!pdev->dev.of_node)
+		return -ENOENT;
+
+	priv->ps = devm_regulator_get_exclusive(dev, "pse");
+	if (IS_ERR(priv->ps))
+		return dev_err_probe(dev, PTR_ERR(priv->ps),
+				     "failed to get PSE regulator.\n");
+
+	platform_set_drvdata(pdev, priv);
+
+	ret = regulator_is_enabled(priv->ps);
+	if (ret < 0)
+		return ret;
+
+	if (ret)
+		priv->admin_state = ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED;
+	else
+		priv->admin_state = ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED;
+
+	priv->pcdev.owner = THIS_MODULE;
+	priv->pcdev.ops = &pse_reg_ops;
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
+static const __maybe_unused struct of_device_id pse_reg_of_match[] = {
+	{ .compatible = "podl-pse-regulator", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pse_reg_of_match);
+
+static struct platform_driver pse_reg_driver = {
+	.probe		= pse_reg_probe,
+	.driver		= {
+		.name		= "PSE regulator",
+		.of_match_table = of_match_ptr(pse_reg_of_match),
+	},
+};
+module_platform_driver(pse_reg_driver);
+
+MODULE_AUTHOR("Oleksij Rempel <kernel@pengutronix.de>");
+MODULE_DESCRIPTION("regulator based Ethernet Power Sourcing Equipment");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:pse-regulator");
-- 
2.30.2

