Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECC26D7825
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbjDEJ1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237384AbjDEJ1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:27:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777935255
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:27:35 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzQ5-0004pA-Mh; Wed, 05 Apr 2023 11:27:09 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Date:   Wed, 05 Apr 2023 11:26:58 +0200
Subject: [PATCH 07/12] net: mdio: make use of phy_device_atomic_register
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-7-7e5329f08002@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
X-Mailer: b4 0.12.1
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current fwnode_mdiobus_register_phy() implementation assume that the
phy is accessible to read the PHYID register values first which isn't
the case in some cases. Fix this by using the new
phy_device_atomic_register() helper which ensures that the prerequisites
are fulfilled before accessing the PHYID registers.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 Documentation/firmware-guide/acpi/dsd/phy.rst |  2 +-
 drivers/net/mdio/acpi_mdio.c                  | 18 ++++++++++++------
 drivers/net/mdio/of_mdio.c                    | 13 ++++++++++++-
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
index 673ac374f92a..489e978c7412 100644
--- a/Documentation/firmware-guide/acpi/dsd/phy.rst
+++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
@@ -5,7 +5,7 @@ MDIO bus and PHYs in ACPI
 =========================
 
 The PHYs on an MDIO bus [phy] are probed and registered using
-fwnode_mdiobus_register_phy().
+phy_device_atomic_register().
 
 Later, for connecting these PHYs to their respective MACs, the PHYs registered
 on the MDIO bus have to be referenced.
diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
index 4630dde01974..25feb571bd1f 100644
--- a/drivers/net/mdio/acpi_mdio.c
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -31,8 +31,10 @@ MODULE_LICENSE("GPL");
 int __acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode,
 			    struct module *owner)
 {
+	struct phy_device_config config = {
+		.mii_bus = mdio,
+	};
 	struct fwnode_handle *child;
-	u32 addr;
 	int ret;
 
 	/* Mask out all PHYs from auto probing. */
@@ -45,15 +47,19 @@ int __acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode,
 
 	/* Loop over the child nodes and register a phy_device for each PHY */
 	fwnode_for_each_child_node(fwnode, child) {
-		ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);
-		if (ret || addr >= PHY_MAX_ADDR)
+		struct phy_device *phy;
+
+		ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child),
+					     &config.phy_addr);
+		if (ret || config.phy_addr >= PHY_MAX_ADDR)
 			continue;
 
-		ret = fwnode_mdiobus_register_phy(mdio, child, addr);
-		if (ret == -ENODEV)
+		config.fwnode = child;
+		phy = phy_device_atomic_register(&config);
+		if (PTR_ERR(phy) == -ENODEV)
 			dev_err(&mdio->dev,
 				"MDIO device at address %d is missing.\n",
-				addr);
+				config.phy_addr);
 	}
 	return 0;
 }
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 7eb32ebb846d..10dd45c3bde0 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -45,7 +45,18 @@ EXPORT_SYMBOL(of_mdiobus_phy_device_register);
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
 				    struct device_node *child, u32 addr)
 {
-	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
+	struct phy_device_config config = {
+		.mii_bus = mdio,
+		.phy_addr = addr,
+		.fwnode = of_fwnode_handle(child),
+	};
+	struct phy_device *phy;
+
+	phy = phy_device_atomic_register(&config);
+	if (IS_ERR(phy))
+		return PTR_ERR(phy);
+
+	return 0;
 }
 
 static int of_mdiobus_register_device(struct mii_bus *mdio,

-- 
2.39.2

