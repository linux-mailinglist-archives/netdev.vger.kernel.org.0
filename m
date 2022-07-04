Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C861F564AF9
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 02:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiGDAq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 20:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiGDAq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 20:46:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 437AA2BDB;
        Sun,  3 Jul 2022 17:46:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3086123A;
        Sun,  3 Jul 2022 17:46:26 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD8563F70D;
        Sun,  3 Jul 2022 17:46:23 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH] net: phy: mdio: add clock support for PHYs
Date:   Mon,  4 Jul 2022 01:45:33 +0100
Message-Id: <20220704004533.17762-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far the generic Ethernet PHY subsystem supports PHYs having a reset
line, which needs to be de-asserted before the PHY can be used. This
corresponds to an "RST" pin on most external PHY chips.
But most PHY chips also need an external clock signal, which may feed
some internal PLL, and/or is used to drive the internal logic. In many
systems this clock signal is provided by a fixed crystal oscillator, so
is of no particular interest to software.

However some systems use a more complex clock source, or try to save a
few pennies by avoiding the crystal. The X-Powers AC200 mixed signal PHY
chip, for instance, uses a software-controlled clock gate, and the
Lindenis V5 development board drives its RTL8211 PHY via a clock pin
on the SoC.

On those systems the clock source needs to be actively enabled by
software, before the PHY can be used. To support those machines, add a
struct clk, populate it from firmware tables, and enable or disable it
when needed, similar to toggling the reset line.

In contrast to exclusive reset lines, calls to clock_disable() need to
be balanced with calls to clock_enable() before, also the gate is
supposed to be initially disabled. This means we cannot treat it exactly
the same as the reset line, but have to skip the initial handling, and
just enable or disable the gate in the probe and remove handlers.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/net/phy/mdio_bus.c    | 18 ++++++++++++++++++
 drivers/net/phy/mdio_device.c | 12 ++++++++++++
 include/linux/mdio.h          |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 8a2dbe849866..5cf84f92dab4 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -67,6 +68,19 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
 	return 0;
 }
 
+static int mdiobus_register_clock(struct mdio_device *mdiodev)
+{
+	struct clk *clk;
+
+	clk = devm_clk_get_optional(&mdiodev->dev, NULL);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	mdiodev->clk = clk;
+
+	return 0;
+}
+
 int mdiobus_register_device(struct mdio_device *mdiodev)
 {
 	int err;
@@ -83,6 +97,10 @@ int mdiobus_register_device(struct mdio_device *mdiodev)
 		if (err)
 			return err;
 
+		err = mdiobus_register_clock(mdiodev);
+		if (err)
+			return err;
+
 		/* Assert the reset signal */
 		mdio_device_reset(mdiodev, 1);
 	}
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 250742ffdfd9..e8424a46a81e 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
@@ -136,6 +137,14 @@ void mdio_device_reset(struct mdio_device *mdiodev, int value)
 }
 EXPORT_SYMBOL(mdio_device_reset);
 
+static void mdio_device_toggle_clock(struct mdio_device *mdiodev, int value)
+{
+	if (value)
+		clk_prepare_enable(mdiodev->clk);
+	else
+		clk_disable_unprepare(mdiodev->clk);
+}
+
 /**
  * mdio_probe - probe an MDIO device
  * @dev: device to probe
@@ -152,11 +161,13 @@ static int mdio_probe(struct device *dev)
 
 	/* Deassert the reset signal */
 	mdio_device_reset(mdiodev, 0);
+	mdio_device_toggle_clock(mdiodev, 1);
 
 	if (mdiodrv->probe) {
 		err = mdiodrv->probe(mdiodev);
 		if (err) {
 			/* Assert the reset signal */
+			mdio_device_toggle_clock(mdiodev, 0);
 			mdio_device_reset(mdiodev, 1);
 		}
 	}
@@ -174,6 +185,7 @@ static int mdio_remove(struct device *dev)
 		mdiodrv->remove(mdiodev);
 
 	/* Assert the reset signal */
+	mdio_device_toggle_clock(mdiodev, 0);
 	mdio_device_reset(mdiodev, 1);
 
 	return 0;
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 00177567cfef..95c13bdb312b 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -50,6 +50,7 @@ struct mdio_device {
 	struct reset_control *reset_ctrl;
 	unsigned int reset_assert_delay;
 	unsigned int reset_deassert_delay;
+	struct clk *clk;
 };
 
 static inline struct mdio_device *to_mdio_device(const struct device *dev)
-- 
2.35.3

