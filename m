Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9032246CD8B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237631AbhLHGTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:19:45 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:45492 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbhLHGTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:19:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=XBiAUp8UcRVmk7x6Q3HkpF6okFHpodYL+sU7zPJIJuo=;
        b=FZftAyoXWxAUOjjKpc3F0+y5wkmhrL4e/y1r1ikGWBxgm7KFBRvhfDvblsMBT2qsGLTN
        l0IKg8nOQcRTdTtKBW1gWVc6oOe39QGkhnfUPqY/aPFTd9t2Mqig/FViZnI+RXzqTbz58f
        U7jFH+/ux3Yb3i+ug4al2x5mIw2lnANN7o5Gb8lZWx1lrEClZfgrfR5TZ9W3IpbJXsE/VN
        cpnHGJbUe2s3fIBUXj2FsgTxwI1fOYekxsryOcTqTNnUj+dSrRfPOpJyp9IjegDqEDjPzW
        UQI8RS23lsuGjXK9y3HhaqKbMr/W/KMx0HoqfQs+GeRRz1fHTmyTDSNOUYvTkn/Q==
Received: by filterdrecv-7bf5c69d5-kwxgp with SMTP id filterdrecv-7bf5c69d5-kwxgp-1-61B04DAB-5
        2021-12-08 06:16:11.140686074 +0000 UTC m=+8409373.270894503
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-1 (SG)
        with ESMTP
        id 3zLcd1UYTVSzD7XmSqdQ5w
        Wed, 08 Dec 2021 06:16:10.899 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 5D09D700371; Tue,  7 Dec 2021 23:16:10 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 1/2] wilc1000: Add reset/enable GPIO support to SPI driver
Date:   Wed, 08 Dec 2021 06:16:11 +0000 (UTC)
Message-Id: <20211208061559.3404738-2-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208061559.3404738-1-davidm@egauge.net>
References: <20211208061559.3404738-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvD99WdZC1A3sl2HpN?=
 =?us-ascii?Q?27qbnaNt6zG=2FbAxld5KaniaAkLq8nO4mEaQuG9f?=
 =?us-ascii?Q?xPbhslPn=2FUeI3CTlFhDdr9+pmiKmHYJyxEhPWFt?=
 =?us-ascii?Q?oLuGRjCUOW2pQa2u3doiA8BsgOziTi3wijaiNOE?=
 =?us-ascii?Q?VBeQUhrFMsZNf5bHu8uNUlQAWp5n2i=2FrnENVA1?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        devicetree@vger.kernel.org,
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
 drivers/net/wireless/microchip/wilc1000/spi.c | 36 +++++++++++++++++--
 .../net/wireless/microchip/wilc1000/wlan.c    |  2 +-
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 640850f989dd..37215fcc27e0 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -8,6 +8,7 @@
 #include <linux/spi/spi.h>
 #include <linux/crc7.h>
 #include <linux/crc-itu-t.h>
+#include <linux/of_gpio.h>
 
 #include "netdev.h"
 #include "cfg80211.h"
@@ -152,6 +153,31 @@ struct wilc_spi_special_cmd_rsp {
 	u8 status;
 } __packed;
 
+static void wilc_set_enable(struct spi_device *spi, bool on)
+{
+	int enable_gpio, reset_gpio;
+
+	enable_gpio = of_get_named_gpio(spi->dev.of_node, "chip_en-gpios", 0);
+	reset_gpio = of_get_named_gpio(spi->dev.of_node, "reset-gpios", 0);
+
+	if (on) {
+		if (gpio_is_valid(enable_gpio))
+			/* assert ENABLE */
+			gpio_direction_output(enable_gpio, 1);
+		mdelay(5);	/* 5ms delay required by WILC1000 */
+		if (gpio_is_valid(reset_gpio))
+			/* deassert RESET */
+			gpio_direction_output(reset_gpio, 1);
+	} else {
+		if (gpio_is_valid(reset_gpio))
+			/* assert RESET */
+			gpio_direction_output(reset_gpio, 0);
+		if (gpio_is_valid(enable_gpio))
+			/* deassert ENABLE */
+			gpio_direction_output(enable_gpio, 0);
+	}
+}
+
 static int wilc_bus_probe(struct spi_device *spi)
 {
 	int ret;
@@ -977,9 +1003,11 @@ static int wilc_spi_reset(struct wilc *wilc)
 
 static int wilc_spi_deinit(struct wilc *wilc)
 {
-	/*
-	 * TODO:
-	 */
+	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
+
+	spi_priv->isinit = false;
+	wilc_set_enable(spi, false);
 	return 0;
 }
 
@@ -1000,6 +1028,8 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		dev_err(&spi->dev, "Fail cmd read chip id...\n");
 	}
 
+	wilc_set_enable(spi, true);
+
 	/*
 	 * configure protocol
 	 */
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

