Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722E16C650A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbjCWKaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjCWK33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:29:29 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A40F37F32;
        Thu, 23 Mar 2023 03:27:14 -0700 (PDT)
Received: (Authenticated sender: herve.codina@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPA id F14504001A;
        Thu, 23 Mar 2023 10:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679567232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0oqGErMkj5FkUfonUc1n/rq79xcUyJMxSW3w/JRA1mw=;
        b=ePk1E6dGI2R+OGEhasW0yHUoD45GS+TBRiwIPh9cwepgdCgtlN76mw4Dp4o/SLntQJgHwX
        YJXdZMigP8/PZuKvpkHJEf7CJjBihoEpNT5TNNZjGLZm4lxh//0lcs9L0vCy9B5+gMuaGG
        A7IYzvlQIrTKROBFuQh1yg8YG/UL+xH25mzn7wi/8knwzhaJxgIqsSh+U/qsezBYhfAasf
        sTW9OP17DwMe0CWNu3WtIkh/UlQxMMI+ZkV9YsqJCLQQdXxyJ6qQm3dDEnMr7Ag4rMUXxn
        0gM7DPiAx33oO9IXfL8Lu4C3LZ8J5HmUMOedXmD/NHbYck0wGEzriItmqbOnFg==
From:   Herve Codina <herve.codina@bootlin.com>
To:     Herve Codina <herve.codina@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [RFC PATCH 4/4] phy: lantiq: Add PEF2256 PHY support
Date:   Thu, 23 Mar 2023 11:26:55 +0100
Message-Id: <20230323102655.264115-5-herve.codina@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323102655.264115-1-herve.codina@bootlin.com>
References: <20230323102655.264115-1-herve.codina@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Lantiq PEF2256, is a framer and line interface component designed to
fulfill all required interfacing between an analog E1/T1/J1 line and the
digital PCM system highway/H.100 bus.

The PHY support allows to provide the PEF2556 as a generic PHY and to
use the PHY API to retrieve the E1 line carrier status from the PHY
consumer.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
---
 drivers/phy/lantiq/Kconfig              |  15 +++
 drivers/phy/lantiq/Makefile             |   1 +
 drivers/phy/lantiq/phy-lantiq-pef2256.c | 131 ++++++++++++++++++++++++
 3 files changed, 147 insertions(+)
 create mode 100644 drivers/phy/lantiq/phy-lantiq-pef2256.c

diff --git a/drivers/phy/lantiq/Kconfig b/drivers/phy/lantiq/Kconfig
index c4df9709d53f..c87881255458 100644
--- a/drivers/phy/lantiq/Kconfig
+++ b/drivers/phy/lantiq/Kconfig
@@ -2,6 +2,21 @@
 #
 # Phy drivers for Lantiq / Intel platforms
 #
+config PHY_LANTIQ_PEF2256
+	tristate "Lantiq PEF2256 PHY"
+	depends on MFD_PEF2256
+	select GENERIC_PHY
+	help
+	  Enable support for the Lantiq PEF2256 (FALC56) PHY.
+	  The PEF2256 is a framer and line interface between analog E1/T1/J1
+	  line and a digital PCM bus.
+	  This PHY support allows to consider the PEF2256 as a PHY.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called phy-lantiq-pef2256.
+
 config PHY_LANTIQ_VRX200_PCIE
 	tristate "Lantiq VRX200/ARX300 PCIe PHY"
 	depends on SOC_TYPE_XWAY || COMPILE_TEST
diff --git a/drivers/phy/lantiq/Makefile b/drivers/phy/lantiq/Makefile
index 7c14eb24ab73..6e501d865620 100644
--- a/drivers/phy/lantiq/Makefile
+++ b/drivers/phy/lantiq/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_PHY_LANTIQ_PEF2256)	+= phy-lantiq-pef2256.o
 obj-$(CONFIG_PHY_LANTIQ_RCU_USB2)	+= phy-lantiq-rcu-usb2.o
 obj-$(CONFIG_PHY_LANTIQ_VRX200_PCIE)	+= phy-lantiq-vrx200-pcie.o
diff --git a/drivers/phy/lantiq/phy-lantiq-pef2256.c b/drivers/phy/lantiq/phy-lantiq-pef2256.c
new file mode 100644
index 000000000000..1a1a4f66c102
--- /dev/null
+++ b/drivers/phy/lantiq/phy-lantiq-pef2256.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * PEF2256 phy support
+ *
+ * Copyright 2023 CS GROUP France
+ *
+ * Author: Herve Codina <herve.codina@bootlin.com>
+ */
+
+#include <linux/phy/phy.h>
+#include <linux/mfd/pef2256.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+struct pef2256_phy {
+	struct phy *phy;
+	struct pef2256 *pef2256;
+	struct device *dev;
+	struct atomic_notifier_head event_notifier_list;
+	struct notifier_block nb;
+};
+
+static int pef2256_carrier_notifier(struct notifier_block *nb, unsigned long action,
+				    void *data)
+{
+	struct pef2256_phy *pef2256 = container_of(nb, struct pef2256_phy, nb);
+
+	switch (action) {
+	case PEF2256_EVENT_CARRIER:
+		return atomic_notifier_call_chain(&pef2256->event_notifier_list,
+						  PHY_EVENT_STATUS,
+						  NULL);
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static int pef2256_phy_atomic_notifier_register(struct phy *phy, struct notifier_block *nb)
+{
+	struct pef2256_phy *pef2256 = phy_get_drvdata(phy);
+
+	return atomic_notifier_chain_register(&pef2256->event_notifier_list, nb);
+}
+
+static int pef2256_phy_atomic_notifier_unregister(struct phy *phy, struct notifier_block *nb)
+{
+	struct pef2256_phy *pef2256 = phy_get_drvdata(phy);
+
+	return atomic_notifier_chain_unregister(&pef2256->event_notifier_list, nb);
+}
+
+static int pef2256_phy_init(struct phy *phy)
+{
+	struct pef2256_phy *pef2256 = phy_get_drvdata(phy);
+
+	ATOMIC_INIT_NOTIFIER_HEAD(&pef2256->event_notifier_list);
+
+	pef2256->nb.notifier_call = pef2256_carrier_notifier;
+	return pef2256_register_event_notifier(pef2256->pef2256, &pef2256->nb);
+}
+
+static int pef2256_phy_exit(struct phy *phy)
+{
+	struct pef2256_phy *pef2256 = phy_get_drvdata(phy);
+
+	return pef2256_unregister_event_notifier(pef2256->pef2256, &pef2256->nb);
+}
+
+static int pef2256_phy_get_status(struct phy *phy, union phy_status *status)
+{
+	struct pef2256_phy *pef2256 = phy_get_drvdata(phy);
+
+	status->basic.link_is_on = pef2256_get_carrier(pef2256->pef2256);
+	return 0;
+}
+
+static const struct phy_ops pef2256_phy_ops = {
+	.owner = THIS_MODULE,
+	.init = pef2256_phy_init,
+	.exit = pef2256_phy_exit,
+	.get_status = pef2256_phy_get_status,
+	.atomic_notifier_register = pef2256_phy_atomic_notifier_register,
+	.atomic_notifier_unregister = pef2256_phy_atomic_notifier_unregister,
+};
+
+static int pef2256_phy_probe(struct platform_device *pdev)
+{
+	struct phy_provider *provider;
+	struct pef2256_phy *pef2256;
+
+	pef2256 = devm_kzalloc(&pdev->dev, sizeof(*pef2256), GFP_KERNEL);
+	if (!pef2256)
+		return -ENOMEM;
+
+	pef2256->dev = &pdev->dev;
+	pef2256->pef2256 = dev_get_drvdata(pef2256->dev->parent);
+
+	pef2256->phy = devm_phy_create(pef2256->dev, NULL, &pef2256_phy_ops);
+	if (IS_ERR(pef2256->phy))
+		return PTR_ERR(pef2256->phy);
+
+	phy_set_drvdata(pef2256->phy, pef2256);
+	pef2256->phy->attrs.mode = PHY_MODE_BASIC;
+
+	provider = devm_of_phy_provider_register(pef2256->dev, of_phy_simple_xlate);
+
+	return PTR_ERR_OR_ZERO(provider);
+}
+
+static const struct of_device_id pef2256_phy_of_match[] = {
+	{ .compatible = "lantiq,pef2256-phy" },
+	{} /* sentinel */
+};
+MODULE_DEVICE_TABLE(of, pef2256_phy_of_match);
+
+static struct platform_driver pef2256_phy_driver = {
+	.driver = {
+		.name = "lantiq-pef2256-phy",
+		.of_match_table = pef2256_phy_of_match,
+	},
+	.probe = pef2256_phy_probe,
+};
+module_platform_driver(pef2256_phy_driver);
+
+MODULE_AUTHOR("Herve Codina <herve.codina@bootlin.com>");
+MODULE_DESCRIPTION("PEF2256 PHY driver");
+MODULE_LICENSE("GPL");
-- 
2.39.2

