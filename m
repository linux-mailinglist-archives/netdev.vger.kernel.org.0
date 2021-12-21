Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BB247C8C7
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 22:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhLUVZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 16:25:42 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:46300 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbhLUVZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 16:25:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=GhknQ87+Tv1LmYbdBKN1RfjxKncXbw6QuueDhACEINk=;
        b=V2sZySGRr+92Ls5vHoOgt7JRt07mwHUmsKLLshep1SnGHuSy45C5Ompy7WiBB3KA8ZQx
        XvsIli2wvIKSZHHvY3yhEu7C6cU8TGguVJjnBZhCPQSSSXfUQ7vstVAZZYczHSdIeq9cXj
        b1gOe1ecaW8qkWmTWP9toCU4KVSuxr8/Q4/wwgwmkJw2ficX8jzO3Po4YBYSxzR1B/if7V
        y4IzSKfGHcoQb/0miVlm3rHdt8YHhFcMxfwYAd8hipHTDuSHoOTDcaYYRR57fRfyI/uU+p
        beOkz4fTMB8ENRa0O9pefKWbNzE7ABalX21U3ry8wywzTHXzE2r2tAaD6/XqT3Xw==
Received: by filterdrecv-75ff7b5ffb-v6hzv with SMTP id filterdrecv-75ff7b5ffb-v6hzv-1-61C2464E-39
        2021-12-21 21:25:34.638731428 +0000 UTC m=+9587076.829192542
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-1 (SG)
        with ESMTP
        id calMx7_ASpimB95p8AtDUQ
        Tue, 21 Dec 2021 21:25:34.496 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id B87E8700356; Tue, 21 Dec 2021 14:25:33 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v7 1/2] wilc1000: Add reset/enable GPIO support to SPI driver
Date:   Tue, 21 Dec 2021 21:25:34 +0000 (UTC)
Message-Id: <20211221212531.4011609-2-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211221212531.4011609-1-davidm@egauge.net>
References: <20211221212531.4011609-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvFd9EQKyTuRHwMkdm?=
 =?us-ascii?Q?G4eA0s3wODjoobJqig+D+CRuoBhWy1To12klxdS?=
 =?us-ascii?Q?maM0Y0p99RxzMREPHR9HPN2xtoRYfRDAI=2Fduq4E?=
 =?us-ascii?Q?7uiRkvhIL819xMau2yfZ3YoKW0Z04wJASPplnZo?=
 =?us-ascii?Q?XzufMB8st0+hzL5VYrPQZmB9gCnxNHMSo+KVGN5?=
 =?us-ascii?Q?FM+rvDADsoWIsOObMP1qg=3D=3D?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the SDIO driver, the RESET/ENABLE pins of WILC1000 are controlled
through the SDIO power sequence driver.  This commit adds analogous
support for the SPI driver.  Specifically, during initialization, the
chip will be ENABLEd and taken out of RESET and during
deinitialization, the chip will be placed back into RESET and disabled
(both to reduce power consumption and to ensure the WiFi radio is
off).

Both RESET and ENABLE GPIOs are optional.  However, if the ENABLE GPIO
is specified, then the RESET GPIO should normally also be specified as
otherwise there is no way to ensure proper timing of the ENABLE/RESET
sequence.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 62 ++++++++++++++++++-
 .../net/wireless/microchip/wilc1000/wlan.c    |  2 +-
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 5ace9e3a56fc8..2c2ed4b09efd5 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -8,6 +8,7 @@
 #include <linux/spi/spi.h>
 #include <linux/crc7.h>
 #include <linux/crc-itu-t.h>
+#include <linux/gpio/consumer.h>
 
 #include "netdev.h"
 #include "cfg80211.h"
@@ -45,6 +46,10 @@ struct wilc_spi {
 	bool probing_crc;	/* true if we're probing chip's CRC config */
 	bool crc7_enabled;	/* true if crc7 is currently enabled */
 	bool crc16_enabled;	/* true if crc16 is currently enabled */
+	struct wilc_gpios {
+		struct gpio_desc *enable;	/* ENABLE GPIO or NULL */
+		struct gpio_desc *reset;	/* RESET GPIO or NULL */
+	} gpios;
 };
 
 static const struct wilc_hif_func wilc_hif_spi;
@@ -152,6 +157,50 @@ struct wilc_spi_special_cmd_rsp {
 	u8 status;
 } __packed;
 
+static int wilc_parse_gpios(struct wilc *wilc)
+{
+	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
+	struct wilc_gpios *gpios = &spi_priv->gpios;
+
+	/* get ENABLE pin and deassert it (if it is defined): */
+	gpios->enable = devm_gpiod_get_optional(&spi->dev,
+						"enable", GPIOD_OUT_LOW);
+	/* get RESET pin and assert it (if it is defined): */
+	if (gpios->enable) {
+		/* if enable pin exists, reset must exist as well */
+		gpios->reset = devm_gpiod_get(&spi->dev,
+					      "reset", GPIOD_OUT_HIGH);
+		if (IS_ERR(gpios->reset)) {
+			dev_err(&spi->dev, "missing reset gpio.\n");
+			return PTR_ERR(gpios->reset);
+		}
+	} else {
+		gpios->reset = devm_gpiod_get_optional(&spi->dev,
+						       "reset", GPIOD_OUT_HIGH);
+	}
+	return 0;
+}
+
+static void wilc_wlan_power(struct wilc *wilc, bool on)
+{
+	struct wilc_spi *spi_priv = wilc->bus_data;
+	struct wilc_gpios *gpios = &spi_priv->gpios;
+
+	if (on) {
+		/* assert ENABLE: */
+		gpiod_set_value(gpios->enable, 1);
+		mdelay(5);
+		/* deassert RESET: */
+		gpiod_set_value(gpios->reset, 0);
+	} else {
+		/* assert RESET: */
+		gpiod_set_value(gpios->reset, 1);
+		/* deassert ENABLE: */
+		gpiod_set_value(gpios->enable, 0);
+	}
+}
+
 static int wilc_bus_probe(struct spi_device *spi)
 {
 	int ret;
@@ -171,6 +220,10 @@ static int wilc_bus_probe(struct spi_device *spi)
 	wilc->bus_data = spi_priv;
 	wilc->dev_irq_num = spi->irq;
 
+	ret = wilc_parse_gpios(wilc);
+	if (ret < 0)
+		goto netdev_cleanup;
+
 	wilc->rtc_clk = devm_clk_get_optional(&spi->dev, "rtc");
 	if (IS_ERR(wilc->rtc_clk)) {
 		ret = PTR_ERR(wilc->rtc_clk);
@@ -983,9 +1036,10 @@ static int wilc_spi_reset(struct wilc *wilc)
 
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
 
@@ -1006,6 +1060,8 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		dev_err(&spi->dev, "Fail cmd read chip id...\n");
 	}
 
+	wilc_wlan_power(wilc, true);
+
 	/*
 	 * configure protocol
 	 */
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 3f339c2f46f11..1a37a49fe6477 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1254,7 +1254,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	wilc->rx_buffer = NULL;
 	kfree(wilc->tx_buffer);
 	wilc->tx_buffer = NULL;
-	wilc->hif_func->hif_deinit(NULL);
+	wilc->hif_func->hif_deinit(wilc);
 }
 
 static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
-- 
2.25.1

