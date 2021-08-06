Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680543E24DC
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbhHFIO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:14:56 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:20755 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243470AbhHFIOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 04:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628237678; x=1659773678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N4i5dp2gK7qlOFPjMFTn8fmP64FDDZe/f83m5Oe+rsU=;
  b=OQYW0eYm5aHQPq9r1iW7VkLIVUf/H5NOtyZQgtoMHKWFi7nB7Ci3zZob
   UFSZPOYm+BriU1qyBQFhFa1HtQzDM9KBWtqcXgXG8FaiBL6YEJPoxkaG2
   Yh1fz/Ftgz0Hgng06Du4PQWN4cJgD7NlPI8kbB0AqVGsqNfvbX2qwswfH
   d+XS/3L4+FfaGmZvRJvyRiNuevDO4Wx0zvOltxyJsaMfKrSW/OiRwA71c
   K5gWYS+DwrueZQtR+eEuKUgRvWNCpgAZkvEu0wwEEVSQSMC7N8XQ+OECu
   VFVej7bzmUwyMavpcRSPgLv56JVPRcYqboSYFgbafvcvXVWmiKJKC23/M
   Q==;
IronPort-SDR: XOfLv6bQFzzchtZ76lbSUmJmuAuLhwXQ894qFO/GyLCQ1+l4qolD1TdtgldwQoGJiOtsKXY+Tl
 Zcp8z4rSLcOzwhhcmcCARYOjmrsS29jksL/uw1vgq1YzIjvYBED3T8xr2BceR9IrTq2LTZjoJg
 vVgcqFBhgikZtcmrZELS/s3ATcKqEM2GydvfcOQw8sNijFBQfL4nNc+3/tdZxilngPxEJ0328z
 br/+HbVYdasbQjKePHoSf79uc4fjvodPoDzp8+mZEy7b0cD4OWYGOrIzD+LV9b/rBY77uwUhya
 RSJ/3fQHyxn04aXcLCG1kDRH
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="131820906"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Aug 2021 01:14:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 01:14:37 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 6 Aug 2021 01:14:35 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <ajay.kathat@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 1/3] wilc1000: use goto labels on error path
Date:   Fri, 6 Aug 2021 11:12:27 +0300
Message-ID: <20210806081229.721731-2-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806081229.721731-1-claudiu.beznea@microchip.com>
References: <20210806081229.721731-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use goto labels on error path for probe functions. This makes code easier
to read. With this introduce also netdev_cleanup and call it where
necessary.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 16 ++++++++++------
 drivers/net/wireless/microchip/wilc1000/spi.c  | 16 ++++++++++------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index e14b9fc2c67a..d11f245542e7 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -129,10 +129,8 @@ static int wilc_sdio_probe(struct sdio_func *func,
 
 	ret = wilc_cfg80211_init(&wilc, &func->dev, WILC_HIF_SDIO,
 				 &wilc_hif_sdio);
-	if (ret) {
-		kfree(sdio_priv);
-		return ret;
-	}
+	if (ret)
+		goto free;
 
 	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
 		struct device_node *np = func->card->dev.of_node;
@@ -150,13 +148,19 @@ static int wilc_sdio_probe(struct sdio_func *func,
 
 	wilc->rtc_clk = devm_clk_get(&func->card->dev, "rtc");
 	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER) {
-		kfree(sdio_priv);
-		return -EPROBE_DEFER;
+		ret = -EPROBE_DEFER;
+		goto netdev_cleanup;
 	} else if (!IS_ERR(wilc->rtc_clk))
 		clk_prepare_enable(wilc->rtc_clk);
 
 	dev_info(&func->dev, "Driver Initializing success\n");
 	return 0;
+
+netdev_cleanup:
+	wilc_netdev_cleanup(wilc);
+free:
+	kfree(sdio_priv);
+	return ret;
 }
 
 static void wilc_sdio_remove(struct sdio_func *func)
diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 8e9aaf03a6fa..23d811b2b925 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -154,10 +154,8 @@ static int wilc_bus_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	ret = wilc_cfg80211_init(&wilc, &spi->dev, WILC_HIF_SPI, &wilc_hif_spi);
-	if (ret) {
-		kfree(spi_priv);
-		return ret;
-	}
+	if (ret)
+		goto free;
 
 	spi_set_drvdata(spi, wilc);
 	wilc->dev = &spi->dev;
@@ -166,12 +164,18 @@ static int wilc_bus_probe(struct spi_device *spi)
 
 	wilc->rtc_clk = devm_clk_get(&spi->dev, "rtc");
 	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER) {
-		kfree(spi_priv);
-		return -EPROBE_DEFER;
+		ret = -EPROBE_DEFER;
+		goto netdev_cleanup;
 	} else if (!IS_ERR(wilc->rtc_clk))
 		clk_prepare_enable(wilc->rtc_clk);
 
 	return 0;
+
+netdev_cleanup:
+	wilc_netdev_cleanup(wilc);
+free:
+	kfree(spi_priv);
+	return ret;
 }
 
 static int wilc_bus_remove(struct spi_device *spi)
-- 
2.25.1

