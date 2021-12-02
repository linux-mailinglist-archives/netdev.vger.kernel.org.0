Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3CA465D36
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 05:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345143AbhLBEED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 23:04:03 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:63852 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344960AbhLBEEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 23:04:02 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2021 23:04:02 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=23XjxJiMvUrpGV4EWLI84+ejv6LWOqnwTO6ziW0doHY=;
        b=P6Z7QMuikbJgddeS5jJgiYa840G5gLr+bCwM1qTp12iFtVnEhDXTk85dBTXbvesHi8Pn
        MVh8EDRoIrn3b0YquFVrSqBphb95YT81Qizhu+j4mmRzQzeXBjE9lzmpP0HqSEuUmYvAwc
        kcTShFXhnSZhGxvi/ysKZg3/Tcd5qDk40bzXqIZQuFQWr2lNKW+qjX6HDBgboPv7yYA92m
        UNGEaD+FkVx8G0dykIgs4ubGw16RZmspxer2eJOgnsUjcnN5hWL2nk1PwkiwoqeaI1c+pz
        t9peZUwCaCf020O2uMs2X82PGUTk1OuV2WCF85QTgYEyrQgqAoTy7cVKJa42pEWQ==
Received: by filterdrecv-75ff7b5ffb-6sw96 with SMTP id filterdrecv-75ff7b5ffb-6sw96-1-61A843B1-2C
        2021-12-02 03:55:29.866771872 +0000 UTC m=+7882541.938430672
Received: from pearl.egauge.net (unknown)
        by ismtpd0042p1las1.sendgrid.net (SG) with ESMTP
        id IaRVeB_3Sii7RHlCdZmGNw
        Thu, 02 Dec 2021 03:55:29.737 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id EE184700280; Wed,  1 Dec 2021 20:55:28 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH] wilc1000: Add reset/enable GPIO support to SPI driver
Date:   Thu, 02 Dec 2021 03:55:30 +0000 (UTC)
Message-Id: <20211202034348.2901092-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvLu5Igk1Sfyh1H4GY?=
 =?us-ascii?Q?y=2F5L8eczeLAeyhf6qDQE7cj3+LWfOoDTkdLE7mg?=
 =?us-ascii?Q?bJDiECluy76VHTJ9nyKakdDAv+13VJ4rSp+ehXy?=
 =?us-ascii?Q?9O7Eg8z2DYbQ6a5PxVQS0GhdH4+zZ7nYq5UaZe=2F?=
 =?us-ascii?Q?K8II9uNPv3hWSDlRzlD=2FkbPSFc01BXqTclXP9Ww?=
 =?us-ascii?Q?RvYW98EtqaLcBxBTNuLDQ=3D=3D?=
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is based on similar code from the linux4sam/linux-at91 GIT
repository.

For the SDIO driver, the RESET/ENABLE pins of WILC1000 may be
controlled through the SDIO power sequence driver.  This commit adds
analogous support for the SPI driver.  Specifically, during bus
probing, the chip will be reset-cycled and during unloading, the chip
will be placed into reset and disabled (both to reduce power
consumption and to ensure the WiFi radio is off).

Both RESET and ENABLE GPIOs are optional.  However, if the ENABLE GPIO
is specified, then the RESET GPIO also must be specified as otherwise
there is no way to ensure proper timing of the ENABLE/RESET sequence.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip,wilc1000.yaml      | 11 +++
 .../net/wireless/microchip/wilc1000/Makefile  |  2 +-
 drivers/net/wireless/microchip/wilc1000/hif.h |  2 +
 .../net/wireless/microchip/wilc1000/netdev.h  | 10 +++
 .../net/wireless/microchip/wilc1000/power.c   | 73 +++++++++++++++++++
 drivers/net/wireless/microchip/wilc1000/spi.c | 15 +++-
 .../net/wireless/microchip/wilc1000/wlan.c    |  2 +-
 7 files changed, 110 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/power.c

diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
index 6c35682377e6..2ce316f5e353 100644
--- a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
@@ -32,6 +32,15 @@ properties:
   clock-names:
     const: rtc
 
+  enable-gpios:
+    maxItems: 1
+    description: A GPIO line connected to the ENABLE line.  If this
+      is specified, then reset-gpios also must be specified.
+
+  reset-gpios:
+    maxItems: 1
+    description: A GPIO line connected to the RESET line.
+
 required:
   - compatible
   - interrupts
@@ -51,6 +60,8 @@ examples:
         interrupts = <27 0>;
         clocks = <&pck1>;
         clock-names = "rtc";
+        enable-gpios = <&pioA 5 0>;
+        reset-gpios = <&pioA 6 0>;
       };
     };
 
diff --git a/drivers/net/wireless/microchip/wilc1000/Makefile b/drivers/net/wireless/microchip/wilc1000/Makefile
index c3c9e34c1eaa..baf9f021a1d6 100644
--- a/drivers/net/wireless/microchip/wilc1000/Makefile
+++ b/drivers/net/wireless/microchip/wilc1000/Makefile
@@ -2,7 +2,7 @@
 obj-$(CONFIG_WILC1000) += wilc1000.o
 
 wilc1000-objs := cfg80211.o netdev.o mon.o \
-			hif.o wlan_cfg.o wlan.o
+			hif.o wlan_cfg.o wlan.o power.o
 
 obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
 wilc1000-sdio-objs += sdio.o
diff --git a/drivers/net/wireless/microchip/wilc1000/hif.h b/drivers/net/wireless/microchip/wilc1000/hif.h
index cccd54ed0518..a57095d8088e 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.h
+++ b/drivers/net/wireless/microchip/wilc1000/hif.h
@@ -213,4 +213,6 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length);
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length);
 void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 				struct cfg80211_crypto_settings *crypto);
+int wilc_of_parse_power_pins(struct wilc *wilc);
+void wilc_wlan_power(struct wilc *wilc, bool on);
 #endif
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index b9a88b3e322f..b95a247322a6 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -197,6 +197,15 @@ struct wilc_vif {
 	struct cfg80211_bss *bss;
 };
 
+struct wilc_power_gpios {
+	int reset;
+	int chip_en;
+};
+
+struct wilc_power {
+	struct wilc_power_gpios gpios;
+};
+
 struct wilc_tx_queue_status {
 	u8 buffer[AC_BUFFER_SIZE];
 	u16 end_index;
@@ -265,6 +274,7 @@ struct wilc {
 	bool suspend_event;
 
 	struct workqueue_struct *hif_workqueue;
+	struct wilc_power power;
 	struct wilc_cfg cfg;
 	void *bus_data;
 	struct net_device *monitor_dev;
diff --git a/drivers/net/wireless/microchip/wilc1000/power.c b/drivers/net/wireless/microchip/wilc1000/power.c
new file mode 100644
index 000000000000..d26a39b7698d
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/power.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/version.h>
+
+#include "netdev.h"
+
+/**
+ * wilc_of_parse_power_pins() - parse power sequence pins
+ *
+ * @wilc:	wilc data structure
+ *
+ * Returns:	 0 on success, negative error number on failures.
+ */
+int wilc_of_parse_power_pins(struct wilc *wilc)
+{
+	struct device_node *of = wilc->dev->of_node;
+	struct wilc_power *power = &wilc->power;
+	int ret;
+
+	power->gpios.reset = of_get_named_gpio_flags(of, "reset-gpios", 0,
+						     NULL);
+	power->gpios.chip_en = of_get_named_gpio_flags(of, "chip_en-gpios", 0,
+						       NULL);
+	if (!gpio_is_valid(power->gpios.reset))
+		return 0;	/* assume SDIO power sequence driver is used */
+
+	if (gpio_is_valid(power->gpios.chip_en)) {
+		ret = devm_gpio_request(wilc->dev, power->gpios.chip_en,
+					"CHIP_EN");
+		if (ret)
+			return ret;
+	}
+	return devm_gpio_request(wilc->dev, power->gpios.reset, "RESET");
+}
+EXPORT_SYMBOL_GPL(wilc_of_parse_power_pins);
+
+/**
+ * wilc_wlan_power() - handle power on/off commands
+ *
+ * @wilc:	wilc data structure
+ * @on:		requested power status
+ *
+ * Returns:	none
+ */
+void wilc_wlan_power(struct wilc *wilc, bool on)
+{
+	if (!gpio_is_valid(wilc->power.gpios.reset)) {
+		/* In case SDIO power sequence driver is used to power this
+		 * device then the powering sequence is handled by the bus
+		 * via pm_runtime_* functions. */
+		return;
+	}
+
+	if (on) {
+		if (gpio_is_valid(wilc->power.gpios.chip_en)) {
+			gpio_direction_output(wilc->power.gpios.chip_en, 1);
+			mdelay(5);
+		}
+		gpio_direction_output(wilc->power.gpios.reset, 1);
+	} else {
+		gpio_direction_output(wilc->power.gpios.reset, 0);
+		if (gpio_is_valid(wilc->power.gpios.chip_en))
+			gpio_direction_output(wilc->power.gpios.chip_en, 0);
+	}
+}
+EXPORT_SYMBOL_GPL(wilc_wlan_power);
diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 640850f989dd..884ad7f954d4 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -171,6 +171,10 @@ static int wilc_bus_probe(struct spi_device *spi)
 	wilc->bus_data = spi_priv;
 	wilc->dev_irq_num = spi->irq;
 
+	ret = wilc_of_parse_power_pins(wilc);
+	if (ret)
+		goto netdev_cleanup;
+
 	wilc->rtc_clk = devm_clk_get_optional(&spi->dev, "rtc");
 	if (IS_ERR(wilc->rtc_clk)) {
 		ret = PTR_ERR(wilc->rtc_clk);
@@ -178,6 +182,10 @@ static int wilc_bus_probe(struct spi_device *spi)
 	}
 	clk_prepare_enable(wilc->rtc_clk);
 
+	/* ensure WILC1000 is reset and enabled: */
+	wilc_wlan_power(wilc, false);
+	wilc_wlan_power(wilc, true);
+
 	return 0;
 
 netdev_cleanup:
@@ -977,9 +985,10 @@ static int wilc_spi_reset(struct wilc *wilc)
 
 static int wilc_spi_deinit(struct wilc *wilc)
 {
-	/*
-	 * TODO:
-	 */
+	struct wilc_spi *spi_priv = wilc->bus_data;
+
+	spi_priv->isinit = false;
+	wilc_wlan_power(wilc, false);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 82566544419a..f1e4ac3a2ad5 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1253,7 +1253,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	wilc->rx_buffer = NULL;
 	kfree(wilc->tx_buffer);
 	wilc->tx_buffer = NULL;
-	wilc->hif_func->hif_deinit(NULL);
+	wilc->hif_func->hif_deinit(wilc);
 }
 
 static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
-- 
2.25.1

