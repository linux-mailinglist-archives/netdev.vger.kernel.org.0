Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7BC47B27F
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 19:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbhLTSDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 13:03:45 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:64280 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240266AbhLTSDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 13:03:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=rEVdNvgWeD7EJU5QWd6ZKNY49cq3YO2E87hcYg3Erhk=;
        b=LKpmZTCK9SRaVzD9ne0wT7AzoIWBD27NDjN7zgOucRYq1qcfLAxDgdc2xJ2lH8Ad0+Op
        vBmybIJHCxtgsHFm/kWNcNPFX7PndpRHZPiuCQr2xC/LSQMT08HpgZXnEfXQfzexQETj8w
        HUwgZzCqrQ/dBd9zk8XRMxYK0kY3UplEE3Frn2Fe2krNtqDhtOISG0pJO4HO4DTUSkaSQK
        75MM952dl1JCac4KeUdMUEdNMBEDwTc+4Gd/XLHJF/qQrTNxQQBE5pOTdt95WGkaJrhUKT
        BNhUEkqwsHOjId857gI2YkKBvVyNlkXZpS6BGUlF8ERhe6WIgSG8n2+TuOqv3TRw==
Received: by filterdrecv-75ff7b5ffb-qzg65 with SMTP id filterdrecv-75ff7b5ffb-qzg65-1-61C0C57A-F
        2021-12-20 18:03:38.109442517 +0000 UTC m=+9488631.153303457
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-1 (SG)
        with ESMTP
        id iU6UAb61TmuMrBt_TAn4Qg
        Mon, 20 Dec 2021 18:03:37.909 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 4F3A07003E3; Mon, 20 Dec 2021 11:03:37 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v6 1/2] wilc1000: Add reset/enable GPIO support to SPI driver
Date:   Mon, 20 Dec 2021 18:03:38 +0000 (UTC)
Message-Id: <20211220180334.3990693-2-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220180334.3990693-1-davidm@egauge.net>
References: <20211220180334.3990693-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvLMwJmK3I26VsBNxv?=
 =?us-ascii?Q?+JgzTg4sKu22XvQsitODcchBCCPTAj7bxNuqvMu?=
 =?us-ascii?Q?LRa8hdPIngwJDMROR4n2VN8VjpzSCckzHi4QWjO?=
 =?us-ascii?Q?0B1D5DURqs7mepxkH+6mwap7oBb28FHZ=2Fm0yYND?=
 =?us-ascii?Q?kU+q4FxoVWqzu29fxEJYnkrwE9JjXy2ncuP+XS?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
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
index e0871b89917dd..86233982120a8 100644
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
@@ -981,9 +1034,10 @@ static int wilc_spi_reset(struct wilc *wilc)
 
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
 
@@ -1004,6 +1058,8 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		dev_err(&spi->dev, "Fail cmd read chip id...\n");
 	}
 
+	wilc_wlan_power(wilc, true);
+
 	/*
 	 * configure protocol
 	 */
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 4ab391b1dd8c7..227ed939c0e6b 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1250,7 +1250,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	wilc->rx_buffer = NULL;
 	kfree(wilc->tx_buffer);
 	wilc->tx_buffer = NULL;
-	wilc->hif_func->hif_deinit(NULL);
+	wilc->hif_func->hif_deinit(wilc);
 }
 
 struct sk_buff *wilc_wlan_alloc_skb(struct wilc_vif *vif, size_t len)
-- 
2.25.1

